from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass
from typing import Iterable, Optional


@dataclass(frozen=True)
class InvariantSnapshot:
    user_pinned_domains: frozenset[str]
    user_pinned_products: frozenset[tuple[str, str]]
    agent_version: str
    locked_fields: tuple[tuple[str, ...], ...]

    def fingerprint(self) -> str:
        h = hashlib.sha256()
        for d in sorted(self.user_pinned_domains):
            h.update(b"D:"); h.update(d.encode()); h.update(b"|")
        for d, p in sorted(self.user_pinned_products):
            h.update(b"P:"); h.update(d.encode()); h.update(b"."); h.update(p.encode()); h.update(b"|")
        h.update(b"V:"); h.update(self.agent_version.encode()); h.update(b"|")
        for path in sorted(self.locked_fields):
            h.update(b"L:"); h.update("/".join(path).encode()); h.update(b"|")
        return h.hexdigest()[:32]


def capture_invariants(
    model: dict,
    user_pinned_domains: Iterable[str],
    user_pinned_products: Iterable[tuple[str, str]],
    locked_fields: Iterable[tuple[str, ...]] = (),
) -> InvariantSnapshot:
    av = model.get("agent_version", "") or model.get("model", {}).get("agent_version", "")
    return InvariantSnapshot(
        user_pinned_domains=frozenset(user_pinned_domains),
        user_pinned_products=frozenset(user_pinned_products),
        agent_version=av,
        locked_fields=tuple(tuple(p) for p in locked_fields),
    )


def verify_invariants(model: dict, expected: InvariantSnapshot) -> tuple[bool, str]:
    mdl = model.get("model", model)
    actual_domains = {d.get("name", "") for d in mdl.get("domains", [])}
    missing_domains = expected.user_pinned_domains - actual_domains
    if missing_domains:
        return False, f"user-pinned domains removed: {sorted(missing_domains)}"

    actual_products = set()
    for d in mdl.get("domains", []):
        dn = d.get("name", "")
        for p in (d.get("products") or d.get("data_products") or []):
            actual_products.add((dn, p.get("name", "")))
    missing_products = expected.user_pinned_products - actual_products
    if missing_products:
        return False, f"user-pinned products removed: {sorted(missing_products)}"

    actual_av = model.get("agent_version", "") or mdl.get("agent_version", "")
    if expected.agent_version and actual_av != expected.agent_version:
        return False, f"agent_version changed: {expected.agent_version!r} -> {actual_av!r}"

    for path in expected.locked_fields:
        cur = model
        try:
            for step in path:
                cur = cur[step]
        except (KeyError, TypeError, IndexError):
            return False, f"locked field path {'/'.join(path)} unreachable post-mutation"

    return True, ""


def diff_models_summary(before: dict, after: dict) -> dict:
    b_mdl = before.get("model", before)
    a_mdl = after.get("model", after)

    def index(m):
        domains = {}
        for d in m.get("domains", []):
            dn = d.get("name", "")
            prods = {}
            for p in (d.get("products") or d.get("data_products") or []):
                prods[p.get("name", "")] = {
                    "tags": p.get("tags", ""),
                    "subdomain": p.get("subdomain", ""),
                    "primary_key": p.get("primary_key", ""),
                    "n_attrs": len(p.get("attributes", [])),
                    "attr_tags": {a.get("name", ""): a.get("tags", "") for a in p.get("attributes", [])},
                    "attr_fks": {a.get("name", ""): a.get("foreign_key_to", "") for a in p.get("attributes", [])},
                }
            domains[dn] = prods
        return domains

    bi = index(b_mdl)
    ai = index(a_mdl)

    domains_added = set(ai) - set(bi)
    domains_removed = set(bi) - set(ai)
    products_added = []
    products_removed = []
    products_modified = []
    tags_added = 0
    fks_added = 0
    fks_removed = 0

    for dn in set(bi) & set(ai):
        ba = bi[dn]
        aa = ai[dn]
        for p in set(aa) - set(ba):
            products_added.append((dn, p))
        for p in set(ba) - set(aa):
            products_removed.append((dn, p))
        for p in set(ba) & set(aa):
            bp, ap = ba[p], aa[p]
            if bp != ap:
                products_modified.append((dn, p))
            for an, t in ap["attr_tags"].items():
                bt = bp["attr_tags"].get(an, "")
                if t and t != bt:
                    tags_added += max(0, len(t.split(",")) - len(bt.split(",") if bt else []))
            for an, fk in ap["attr_fks"].items():
                bfk = bp["attr_fks"].get(an, "")
                if fk and not bfk:
                    fks_added += 1
                elif bfk and not fk:
                    fks_removed += 1

    n_mv_b = len((before.get("model", before)).get("metric_views", []))
    n_mv_a = len((after.get("model", after)).get("metric_views", []))

    return {
        "domains_added": sorted(domains_added),
        "domains_removed": sorted(domains_removed),
        "products_added": sorted(products_added),
        "products_removed": sorted(products_removed),
        "n_products_modified": len(products_modified),
        "tags_added_estimate": tags_added,
        "fks_added": fks_added,
        "fks_removed": fks_removed,
        "metric_views_delta": n_mv_a - n_mv_b,
    }


def diff_within_summary_scope(diff: dict, summary: str) -> tuple[bool, str]:
    s = summary.lower()
    over = []

    if diff["domains_removed"] and "remove domain" not in s and "delete domain" not in s and "drop domain" not in s:
        over.append(f"domains_removed={diff['domains_removed']}")
    if diff["domains_added"] and "add domain" not in s and "create domain" not in s and "new domain" not in s:
        over.append(f"domains_added={diff['domains_added']}")
    if diff["products_removed"] and not any(k in s for k in ["remove product", "delete product", "drop product", "merge"]):
        over.append(f"products_removed={diff['products_removed']}")
    if diff["fks_removed"] > 5 and "remove fk" not in s and "drop fk" not in s:
        over.append(f"fks_removed={diff['fks_removed']}")
    if abs(diff["metric_views_delta"]) > 0 and not any(k in s for k in ["metric view", "mv"]):
        over.append(f"metric_views_delta={diff['metric_views_delta']}")

    if over:
        return False, f"diff exceeds summary scope; suspicious changes: {over}; summary={summary!r}"
    return True, ""
