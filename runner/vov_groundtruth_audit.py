#!/usr/bin/env python3
"""GROUND-TRUTH VReq audit: parse VReqs from the SOURCE vibe ourselves, verify each
against the agent's v2 model.json, score adherence = fulfilled / ALL parsed VReqs.

This is deliberately INDEPENDENT of the agent's own vibe_orchestrator_scored payload
(the "lying scoreboard" whose denominator = what the agent extracted). Here the
denominator is what WE parse from next_vibes.txt, so a vibe with 100 VReqs where the
agent extracted 50 and applied 45 scores 45%, not 90%.

VReq sources parsed from vibes/<ind>/next_vibes.txt:
  - SEC1 preserve   : every v1 domain + product (from vibes/<ind>/model.json) must exist in v2 ecm
  - SEC3C P1..P20   : connect_table / rename_attribute / move_product / remove_fk / rename_product
  - SEC3A stubs     : listed products must gain real data attributes (> PK/FK)
  - SEC3B thin      : listed products should be expanded vs v1
  - SEC2 entities   : snake_case multi-token entities the reviewer flags as missing/add/required

Verification is deterministic against v2 ecm model.json (+ v1 model.json for baselines).
Industry-agnostic: nothing hardcoded per industry.
"""
import json
import os
import re
import sys

VIBES = "/Users/amr.ali/Documents/projects/vibe-business-data-models-v2/vibes"
V2REPO = "/Users/amr.ali/Documents/projects/vibe-business-data-models-v2"
OUT = os.path.expanduser("~/claude/vibe-agent/v2_groundtruth")


def norm(s):
    return re.sub(r"[^a-z0-9]+", "_", (s or "").strip().lower()).strip("_")


def load_model(path):
    try:
        return json.load(open(path))
    except Exception:
        return None


def index_model(mj):
    """Return (prod2domain, prod2attrs) where attrs = {attr_name: fk_to_or_None}."""
    prod2domain, prod2attrs = {}, {}
    model = (mj or {}).get("model", {})
    for d in model.get("domains", []):
        dn = norm(d.get("name"))
        for p in (d.get("products") or d.get("data_products") or []):
            pn = norm(p.get("name"))
            prod2domain[pn] = dn
            prod2attrs[pn] = {norm(a.get("name")): a.get("foreign_key_to") for a in p.get("attributes", [])}
    return prod2domain, prod2attrs


def v1_structure(mj):
    domains, products = set(), set()
    for d in (mj or {}).get("model", {}).get("domains", []):
        domains.add(norm(d.get("name")))
        for p in (d.get("products") or d.get("data_products") or []):
            products.add(norm(p.get("name")))
    return domains, products


# ---------------- parse next_vibes.txt -----------------
P_RE = re.compile(r"-\s*(P\d+):\s*([a-z_]+):\s*([a-z_0-9]+)\.([a-z_0-9]+)\*\*\s*[—-]+\s*(.*)")


def parse_priorities(text):
    out = []
    for m in P_RE.finditer(text):
        pid, action, dom, prod, detail = m.groups()
        v = {"id": pid, "source": "SEC3C", "action": action,
             "domain": norm(dom), "product": norm(prod), "raw": detail.strip()[:200]}
        if action == "connect_table":
            mm = re.search(r"add column ([a-z_0-9]+)\s*\(([A-Za-z]+)\)\s*with FK to ([a-z_0-9.]+)", detail)
            if mm:
                v["column"] = norm(mm.group(1)); v["fk_to"] = mm.group(3).strip(". ")
        elif action == "rename_attribute":
            mm = re.search(r"rename column ([a-z_0-9]+) to ([a-z_0-9]+)", detail)
            if mm:
                v["old_col"] = norm(mm.group(1)); v["new_col"] = norm(mm.group(2))
        elif action == "move_product":
            mm = re.search(r"move to ([a-z_0-9]+)", detail)
            if mm:
                v["new_domain"] = norm(mm.group(1))
        elif action == "remove_fk":
            mm = re.search(r"remove FK on column ([a-z_0-9]+)", detail)
            if mm:
                v["column"] = norm(mm.group(1))
        elif action == "rename_product":
            mm = re.search(r"rename to ([a-z_0-9]+)", detail)
            if mm:
                v["new_name"] = norm(mm.group(1))
        out.append(v)
    return out


def section(text, start_pat, end_pats):
    s = re.search(start_pat, text)
    if not s:
        return ""
    rest = text[s.end():]
    end = len(rest)
    for ep in end_pats:
        e = re.search(ep, rest)
        if e:
            end = min(end, e.start())
    return rest[:end]


def parse_stub_thin(text):
    stubs, thin = [], []
    sa = section(text, r"3a\.\s*STUBS", [r"3b\.", r"3c\.", r"SECTION"])
    for m in re.finditer(r"-\s*([a-z_0-9]+)\.([a-z_0-9]+)", sa):
        stubs.append((norm(m.group(1)), norm(m.group(2))))
    sb = section(text, r"3b\.\s*THIN", [r"3c\.", r"3d\.", r"SECTION"])
    for m in re.finditer(r"-\s*([a-z_0-9]+)\.([a-z_0-9]+)", sb):
        thin.append((norm(m.group(1)), norm(m.group(2))))
    return stubs, thin


GAP_MARK = re.compile(r"missing|not (?:a )?first-class|no support|not modeled|not modeling|absent|"
                      r"\bgap\b|required:|add(?:ing)?\b|promote to mvm|reconcile|not treated", re.I)


def parse_sec2_entities(text, v1_products):
    """Heuristic: snake_case multi-token identifiers in gap-marked sentences of Section 2,
    that are NOT already v1 products (so they are NEW asks). Deterministic + transparent."""
    sec2 = section(text, r"SECTION 2", [r"SECTION 3", r"END OF VIBE"])
    cands = {}
    for sent in re.split(r"(?<=[.\n])\s+", sec2):
        if not GAP_MARK.search(sent):
            continue
        for tok in re.findall(r"\b([a-z][a-z0-9]+(?:_[a-z0-9]+)+)\b", sent):
            t = norm(tok)
            if t in v1_products:
                continue
            if t in ("first_class", "cold_chain", "data_model", "use_cases", "use_case",
                     "real_time", "self_assessment", "back_office", "back_offices", "data_models",
                     "lookup_tables", "metric_views", "self_ref", "self_referencing"):
                continue
            cands.setdefault(t, sent.strip()[:160])
    return [{"id": f"SEC2-{i+1}", "source": "SEC2", "action": "add_entity", "entity": e, "raw": r}
            for i, (e, r) in enumerate(sorted(cands.items()))]


# ---------------- verification -----------------
def fk_matches(fk_val, fk_to):
    if not fk_val:
        return False
    fv = norm(fk_val); want = norm(fk_to)
    # match on the product token of the target (2nd-to-last) or full contains
    parts = [p for p in re.split(r"_+", want) if p]
    return want in fv or fv in want or (len(parts) >= 2 and "_".join(parts[-3:]) in fv)


def find_product(prod, prod2domain):
    if prod in prod2domain:
        return prod
    # tolerate domain-prefixed rename (e.g. nameplate -> aftersales_nameplate)
    for p in prod2domain:
        if p.endswith("_" + prod) or p == prod:
            return p
    return None


def verify(v, v2pd, v2pa, v1_products):
    a = v["action"]
    prod = v.get("product")
    if a == "preserve":
        present = v["target"] in v2pd
        return ("fulfilled" if present else "missed",
                "" if present else f"product '{v['target']}' from v1 absent in v2 ECM (dropped)")
    if a == "add_entity":
        e = v["entity"]
        if e in v2pd:
            return "fulfilled", f"entity present as product '{e}'"
        for pn, attrs in v2pa.items():
            if any(e in an or an in e for an in attrs):
                return "fulfilled", f"entity present as attribute on '{pn}'"
        # token-overlap soft check
        toks = set(t for t in e.split("_") if len(t) > 3)
        for pn in v2pd:
            if toks and toks.issubset(set(pn.split("_"))):
                return "partial", f"near-match product '{pn}'"
        return "missed", f"reviewer-requested entity '{e}' not found as product or attribute"
    # P-actions need the product to exist somewhere
    rp = find_product(prod, v2pd)
    if a == "connect_table":
        if not rp:
            return "missed", f"target product '{prod}' absent in v2 (cannot connect)"
        col = v.get("column"); attrs = v2pa.get(rp, {})
        if col and col in attrs and fk_matches(attrs[col], v.get("fk_to", "")):
            return "fulfilled", f"column '{col}' present with FK -> {attrs[col]}"
        if col and col in attrs:
            return "partial", f"column '{col}' present but FK missing/wrong (got {attrs[col]})"
        if any(attrs[an] for an in attrs):
            return "partial", f"exact column '{col}' absent but product has other outbound FKs (connected differently)"
        return "missed", f"column '{col}' absent and product has no outbound FK (still isolated)"
    if a == "rename_attribute":
        if not rp:
            return "missed", f"target product '{prod}' absent"
        attrs = v2pa.get(rp, {})
        new, old = v.get("new_col"), v.get("old_col")
        if new and new in attrs and (not old or old not in attrs):
            return "fulfilled", f"renamed to '{new}'"
        if old and old in attrs:
            return "missed", f"old column '{old}' still present (rename not applied)"
        return "partial", f"neither '{old}' nor '{new}' found (column may have been dropped/restructured)"
    if a == "move_product":
        if not rp:
            return "missed", f"product '{prod}' absent"
        cur = v2pd.get(rp); nd = v.get("new_domain")
        if nd and cur == nd:
            return "fulfilled", f"now in domain '{nd}'"
        return "missed", f"still in domain '{cur}', not moved to '{nd}'"
    if a == "remove_fk":
        if not rp:
            return "missed", f"product '{prod}' absent"
        attrs = v2pa.get(rp, {}); col = v.get("column")
        if col not in attrs:
            return "fulfilled", f"column '{col}' removed entirely"
        if not attrs.get(col):
            return "fulfilled", f"FK removed from '{col}'"
        return "missed", f"FK still present on '{col}' (-> {attrs[col]})"
    if a == "rename_product":
        new = v.get("new_name")
        if new and new in v2pd:
            return "fulfilled", f"product renamed to '{new}'"
        if prod in v2pd:
            return "missed", f"old name '{prod}' still present (rename not applied)"
        return "partial", f"neither old '{prod}' nor new '{new}' present"
    return "unverifiable", "no rule for action"


# ---------------- LLM-structured VReq extraction -----------------
LLM_ENDPOINT = "databricks-claude-sonnet-4-6"
LLM_PROFILE = "fe-aws"

_ACTIONS = ("connect_table", "rename_attribute", "move_product", "remove_fk",
            "rename_product", "add_entity", "expand_stub", "expand_thin")


def _salvage_vreqs(s):
    """Recover complete VReq objects from a truncated 'vreqs' array via balanced-brace scan."""
    k = s.find('"vreqs"')
    if k < 0:
        return None
    lb = s.find("[", k)
    if lb < 0:
        return None
    objs = []
    depth = 0
    start = None
    in_str = False
    esc = False
    for idx in range(lb + 1, len(s)):
        ch = s[idx]
        if in_str:
            if esc:
                esc = False
            elif ch == "\\":
                esc = True
            elif ch == '"':
                in_str = False
            continue
        if ch == '"':
            in_str = True
        elif ch == "{":
            if depth == 0:
                start = idx
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0 and start is not None:
                frag = s[start:idx + 1]
                try:
                    objs.append(json.loads(frag))
                except Exception:
                    pass
                start = None
        elif ch == "]" and depth == 0:
            break
    return {"vreqs": objs} if objs else None


def _extract_json(raw):
    if not raw:
        return None
    s = raw.strip()
    if s.startswith("```"):
        s = re.sub(r"^```[a-zA-Z]*\n", "", s)
        s = re.sub(r"\n```\s*$", "", s)
    i = s.find("{")
    j = s.rfind("}")
    if i >= 0 and j > i:
        try:
            return json.loads(s[i:j + 1])
        except Exception:
            pass
    return _salvage_vreqs(s)


_HOST_CACHE = {}
_TOKEN_CACHE = {}


def _profile_host(profile):
    if profile in _HOST_CACHE:
        return _HOST_CACHE[profile]
    import configparser
    c = configparser.ConfigParser()
    c.read(os.path.expanduser("~/.databrickscfg"))
    host = c[profile].get("host") if profile in c else None
    if host:
        host = host.rstrip("/")
    _HOST_CACHE[profile] = host
    return host


def _profile_token(profile):
    if profile in _TOKEN_CACHE:
        return _TOKEN_CACHE[profile]
    import subprocess
    try:
        p = subprocess.run(["databricks", "auth", "token", "--profile", profile, "-o", "json"],
                           capture_output=True, text=True, timeout=60)
        if p.returncode != 0:
            return None
        tok = json.loads(p.stdout).get("access_token")
        _TOKEN_CACHE[profile] = tok
        return tok
    except Exception:
        return None


def _llm_invoke(profile, endpoint, system, user, max_tokens=32000, timeout=600):
    import urllib.request
    import urllib.error
    host = _profile_host(profile)
    token = _profile_token(profile)
    if not host or not token:
        return None
    payload = {"messages": [{"role": "system", "content": system},
                            {"role": "user", "content": user}],
               "max_tokens": max_tokens, "temperature": 0}
    req = urllib.request.Request(
        f"{host}/serving-endpoints/{endpoint}/invocations",
        data=json.dumps(payload).encode("utf-8"),
        headers={"Authorization": f"Bearer {token}", "Content-Type": "application/json"},
        method="POST")
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            d = json.loads(r.read().decode("utf-8"))
        return d.get("choices", [{}])[0].get("message", {}).get("content", "")
    except Exception:
        _TOKEN_CACHE.pop(profile, None)
        return None


_LLM_SYS = (
    "You are a meticulous data-modeling requirements extractor. You are given a "
    "'next_vibes' review document: instructions to evolve a v1 data model into v2. "
    "Your job is to extract EVERY atomic, independently-verifiable improvement "
    "requirement (VReq) the document states, regardless of wording: numbered "
    "priorities, prose sentences, gap statements, tables, stub/thin callouts. "
    "Capture all of them; never invent requirements not in the document; never merge "
    "two distinct requirements into one. Output STRICT JSON only, no prose.")


def _llm_user_prompt(text, v1_domains, v1_products):
    schema = (
        "Allowed action values and their required fields (snake_case names; for "
        "`product` use the v1 product token, i.e. the table name without its domain "
        "prefix):\n"
        "- connect_table {product, column?, fk_to?}  (table must gain an FK / be linked)\n"
        "- rename_attribute {product, old_col, new_col}\n"
        "- move_product {product, new_domain}\n"
        "- remove_fk {product, column}\n"
        "- rename_product {product, new_name}\n"
        "- add_entity {entity}  (a NEW table/entity the reviewer says is missing/required)\n"
        "- expand_stub {product, domain?}  (a near-empty table that must gain real attributes)\n"
        "- expand_thin {product, domain?}  (an under-developed table that must be expanded)\n")
    return (
        f"v1 DOMAINS: {sorted(v1_domains)}\n\n"
        f"v1 PRODUCTS (tables): {sorted(v1_products)}\n\n"
        f"{schema}\n"
        "Return JSON: {\"vreqs\": [ {\"action\": <one of the above>, ...required fields..., "
        "\"verbatim\": <the exact source phrase, <=200 chars>, \"interpretation\": "
        "<one-line plain English of what must change>} ] }\n"
        "Rules: resolve every `product` to an existing v1 product token when the document "
        "refers to one; if a requirement names a brand-new table not in v1, use add_entity. "
        "Do NOT emit a requirement that merely says 'preserve/keep existing tables' (those "
        "are handled separately). Extract EVERYTHING else exhaustively.\n\n"
        "=== NEXT_VIBES DOCUMENT START ===\n"
        f"{text[:120000]}\n"
        "=== NEXT_VIBES DOCUMENT END ===")


def llm_extract_vreqs(text, v1_domains, v1_products, profile, endpoint):
    raw = _llm_invoke(profile, endpoint, _LLM_SYS,
                      _llm_user_prompt(text, v1_domains, v1_products))
    d = _extract_json(raw)
    if not d or "vreqs" not in d:
        return None
    out = []
    for i, v in enumerate(d.get("vreqs", [])):
        a = (v.get("action") or "").strip()
        if a not in _ACTIONS:
            continue
        vr = {"id": f"LLM-{i+1}", "source": "LLM", "action": a,
              "verbatim": (v.get("verbatim") or "")[:200],
              "interpretation": (v.get("interpretation") or "")[:200]}
        if a == "add_entity":
            vr["entity"] = norm(v.get("entity"))
            if not vr["entity"]:
                continue
        else:
            vr["product"] = norm(v.get("product"))
            if not vr["product"] and a not in ("add_entity",):
                continue
        if a == "connect_table":
            if v.get("column"):
                vr["column"] = norm(v.get("column"))
            if v.get("fk_to"):
                vr["fk_to"] = str(v.get("fk_to")).strip(". ")
        elif a == "rename_attribute":
            vr["old_col"] = norm(v.get("old_col"))
            vr["new_col"] = norm(v.get("new_col"))
        elif a == "move_product":
            vr["new_domain"] = norm(v.get("new_domain"))
        elif a == "remove_fk":
            vr["column"] = norm(v.get("column"))
        elif a == "rename_product":
            vr["new_name"] = norm(v.get("new_name"))
        elif a in ("expand_stub", "expand_thin"):
            vr["domain"] = norm(v.get("domain")) if v.get("domain") else ""
        out.append(vr)
    return out


def regex_improvement_vreqs(vibe, v1_products):
    vreqs = []
    vreqs += parse_priorities(vibe)
    stubs, thin = parse_stub_thin(vibe)
    for dom, prod in stubs:
        vreqs.append({"id": f"STUB-{prod}", "source": "SEC3A", "action": "expand_stub",
                      "product": prod, "domain": dom})
    for dom, prod in thin:
        vreqs.append({"id": f"THIN-{prod}", "source": "SEC3B", "action": "expand_thin",
                      "product": prod, "domain": dom})
    vreqs += parse_sec2_entities(vibe, v1_products)
    return vreqs


def audit_industry(ind, use_llm=False, profile=None, endpoint=None):
    vibe = open(os.path.join(VIBES, ind, "next_vibes.txt"), errors="ignore").read()
    v1 = load_model(os.path.join(VIBES, ind, "model.json"))
    v2ecm = load_model(os.path.join(V2REPO, ind, "v2", "ecm", "model.json"))
    if not v2ecm:
        return None
    v1_domains, v1_products = v1_structure(v1)
    v2pd, v2pa = index_model(v2ecm)

    vreqs = []
    # SEC1 preservation (per product) — deterministic, always complete
    for p in sorted(v1_products):
        vreqs.append({"id": f"PRES-{p}", "source": "SEC1", "action": "preserve", "target": p})

    # improvement VReqs: LLM-structured (exhaustive) with regex fallback
    imp_mode = "regex"
    imp = None
    if use_llm:
        imp = llm_extract_vreqs(vibe, v1_domains, v1_products,
                                profile or LLM_PROFILE, endpoint or LLM_ENDPOINT)
        if imp is not None:
            imp_mode = "llm"
    if imp is None:
        imp = regex_improvement_vreqs(vibe, v1_products)
    vreqs += imp

    results = []
    for v in vreqs:
        a = v["action"]
        if a in ("expand_stub", "expand_thin"):
            rp = find_product(v["product"], v2pd)
            if not rp:
                status, reason = "missed", f"product '{v['product']}' absent in v2"
            else:
                attrs = v2pa.get(rp, {})
                nonkey = [an for an in attrs if not (an.endswith("_id") or an == "id")]
                thr = 8 if a == "expand_stub" else 12
                if len(nonkey) >= thr:
                    status, reason = "fulfilled", f"{len(nonkey)} non-key attributes"
                else:
                    status, reason = "partial", f"only {len(nonkey)} non-key attributes (< {thr})"
        else:
            status, reason = verify(v, v2pd, v2pa, v1_products)
        results.append({**v, "status": status, "reason": reason})

    # scoreboard (ALL vreqs denominator)
    by = {}
    for r in results:
        by[r["status"]] = by.get(r["status"], 0) + 1
    total = len(results)
    ful = by.get("fulfilled", 0)
    adher = round(100.0 * ful / total, 1) if total else 0.0

    # improvement-only (exclude SEC1 preservation)
    imp = [r for r in results if r["source"] != "SEC1"]
    imp_ful = sum(1 for r in imp if r["status"] == "fulfilled")
    imp_adher = round(100.0 * imp_ful / len(imp), 1) if imp else 0.0

    return {"industry": ind, "total_vreqs": total, "by_status": by,
            "adherence_all": adher, "fulfilled": ful,
            "improvement_total": len(imp), "improvement_fulfilled": imp_ful,
            "improvement_adherence": imp_adher, "extraction_mode": imp_mode,
            "v1_products": len(v1_products), "v2_products": len(v2pd),
            "results": results}


_STATUS_MAP = {"fulfilled": "applied", "partial": "partial", "missed": "missed",
               "unverifiable": "missed"}


def _affected(v):
    a = v["action"]
    p = v.get("product")
    if a == "preserve":
        return {"type": "product", "fqname": v.get("target"), "blast_radius": "1"}
    if a == "add_entity":
        return {"type": "product", "fqname": v.get("entity"), "blast_radius": "1"}
    if a == "connect_table":
        col = v.get("column")
        return {"type": "fk", "fqname": f"{p}.{col}" if col else p, "blast_radius": "1"}
    if a == "rename_attribute":
        return {"type": "attribute",
                "fqname": f"{p}.{v.get('old_col')}->{v.get('new_col')}", "blast_radius": "1"}
    if a == "move_product":
        return {"type": "product", "fqname": f"{p}->{v.get('new_domain')}", "blast_radius": "1"}
    if a == "remove_fk":
        return {"type": "fk", "fqname": f"{p}.{v.get('column')}", "blast_radius": "1"}
    if a == "rename_product":
        return {"type": "product", "fqname": f"{p}->{v.get('new_name')}", "blast_radius": "1"}
    if a in ("expand_stub", "expand_thin"):
        return {"type": "product", "fqname": p, "blast_radius": "<N>"}
    return {"type": "unknown", "fqname": p or "", "blast_radius": "1"}


def build_lineage(audit):
    out = []
    for r in audit["results"]:
        vibe = r.get("verbatim") or r.get("raw") or f"{r['action']} {_affected(r)['fqname']}"
        interp = r.get("interpretation") or f"{r['action'].replace('_', ' ')} on {_affected(r)['fqname']}"
        out.append({"id": r["id"], "vibe": vibe[:200], "interpretation": interp[:200],
                    "status": _STATUS_MAP.get(r["status"], r["status"]),
                    "affected": _affected(r)})
    return out


def main(industries, use_llm=False, profile=None, endpoint=None, out_dir=None):
    out = out_dir or OUT
    os.makedirs(out, exist_ok=True)
    agg = {"per_industry": [], "totals": {}}
    tot = ful = 0
    print(f"{'industry':<20}{'ALL':>8}{'ful':>6}{'adher%':>8}   {'impr':>5}{'impr%':>7}")
    for ind in industries:
        a = audit_industry(ind, use_llm=use_llm, profile=profile, endpoint=endpoint)
        if not a:
            print(f"{ind:<20}  (no v2 ecm)")
            continue
        json.dump(a, open(os.path.join(out, f"{ind}.json"), "w"), indent=2)
        json.dump(build_lineage(a), open(os.path.join(out, f"{ind}.lineage.json"), "w"), indent=2)
        agg["per_industry"].append({k: a[k] for k in
            ("industry", "total_vreqs", "fulfilled", "adherence_all", "by_status",
             "improvement_total", "improvement_fulfilled", "improvement_adherence",
             "extraction_mode")})
        tot += a["total_vreqs"]; ful += a["fulfilled"]
        print(f"{ind:<20}{a['total_vreqs']:>8}{a['fulfilled']:>6}{a['adherence_all']:>8}"
              f"   {a['improvement_total']:>5}{a['improvement_adherence']:>7}  [{a['extraction_mode']}]")
    agg["totals"] = {"total_vreqs": tot, "fulfilled": ful,
                     "adherence_all": round(100.0 * ful / tot, 1) if tot else 0.0,
                     "extraction_mode": "llm" if use_llm else "regex"}
    json.dump(agg, open(os.path.join(out, "_aggregate.json"), "w"), indent=2)
    print(f"\nAGGREGATE: {ful}/{tot} = {agg['totals']['adherence_all']}% (all-VReq, ground-truth denominator)")


if __name__ == "__main__":
    args = sys.argv[1:]
    use_llm = "--llm" in args
    profile = endpoint = out_dir = None
    inds = []
    i = 0
    while i < len(args):
        a = args[i]
        if a == "--llm":
            i += 1
        elif a == "--profile":
            profile = args[i + 1]; i += 2
        elif a == "--endpoint":
            endpoint = args[i + 1]; i += 2
        elif a == "--out":
            out_dir = os.path.expanduser(args[i + 1]); i += 2
        else:
            inds.append(a); i += 1
    if not inds:
        inds = ["automotive", "construction", "consumer_goods", "health_insurance",
                "healthcare", "manufacturing", "ngo", "restaurants", "retail",
                "semiconductors", "travel_hospitality", "water_utilities"]
    main(inds, use_llm=use_llm, profile=profile, endpoint=endpoint, out_dir=out_dir)
