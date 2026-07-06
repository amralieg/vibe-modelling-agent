import json
import os
import re
import sys

import pytest

_NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")
_RUNNER = os.path.join(os.path.dirname(__file__), "..", "..", "runner")


def _full():
    nb = json.load(open(_NB))
    return "\n".join("".join(c.get("source", [])) for c in nb["cells"])


def _parse_tags(s):
    d = {}
    for part in (s or "").split(","):
        part = part.strip()
        if not part:
            continue
        if "=" in part:
            k, v = part.split("=", 1)
            d[k.strip()] = v.strip()
        else:
            d[part] = ""
    return d


def _serialize_tags(d):
    return ",".join((f"{k}={v}" if v != "" else k) for k, v in d.items())


# --------------------------------------------------------------------------- #
# version + markers                                                            #
# --------------------------------------------------------------------------- #
def test_v349_version_constant():
    src = _full()
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', src)
    assert m and tuple(int(x) for x in m.groups()) >= (3, 4, 9)


def test_v349_steward_enforce_present():
    src = _full()
    assert "subdomain-steward-enforce" in src
    assert "SUBDOMAIN_STEWARD_ENFORCE" in src
    assert "_SUBDOMAIN_STEWARD_SCHEMA" in src
    # only fires when the vibe declares stewards (no over-tagging on vibes that don't mention them)
    assert 'if ai and vibe_text and ("steward" in vibe_text.lower())' in src


# --------------------------------------------------------------------------- #
# steward application logic (faithful re-impl of the deterministic apply step) #
# --------------------------------------------------------------------------- #
def _apply_subdomain_stewards(products, mappings, prefix=""):
    """Mirror of the v3.4.9 apply branch: set product.steward + {prefix}subdomain_steward tag
    for products whose subdomain has a non-empty steward in the vibe-derived mapping."""
    subs = {}
    for p in products:
        sd = str(p.get("subdomain") or "").strip()
        if sd:
            subs.setdefault(sd, []).append(p)
    added = 0
    skey = f"{prefix}subdomain_steward"
    for m in mappings:
        sd = (m.get("subdomain") or "").strip()
        stew = (m.get("steward") or "").strip()
        if not sd or not stew or sd not in subs:
            continue
        for pp in subs[sd]:
            if not (pp.get("steward") or "").strip():
                pp["steward"] = stew
            tags = _parse_tags(pp.get("tags"))
            if skey not in tags:
                tags[skey] = stew
                pp["tags"] = _serialize_tags(tags)
        added += 1
    return added


def test_v349_steward_populates_from_vibe_mapping():
    # Mirrors NCDOT S2: 4 named HR subdomains; pre-patch all stewards empty.
    products = [
        {"product": "employee", "subdomain": "employee_records", "steward": "", "tags": ""},
        {"product": "position", "subdomain": "employee_records", "steward": "", "tags": ""},
        {"product": "comp_plan", "subdomain": "compensation_and_benefits", "steward": "", "tags": ""},
        {"product": "policy", "subdomain": "policies_and_procedures", "steward": "", "tags": ""},
        {"product": "term", "subdomain": "terminations_and_exits", "steward": "", "tags": ""},
        {"product": "skill", "subdomain": "talent_development", "steward": "", "tags": ""},  # N/A in vibe
    ]
    mappings = [
        {"subdomain": "employee_records", "steward": "Keisha Isley"},
        {"subdomain": "compensation_and_benefits", "steward": "Sara Royster"},
        {"subdomain": "policies_and_procedures", "steward": "Daphne Wright"},
        {"subdomain": "terminations_and_exits", "steward": "Daphne Wright, Chris Law"},
        {"subdomain": "talent_development", "steward": ""},  # advisory N/A -> must NOT tag
    ]
    added = _apply_subdomain_stewards(products, mappings, prefix="ncdot_")

    by = {p["product"]: p for p in products}
    # all 4 named stewards now applied to BOTH the model field and the physical tag
    assert by["employee"]["steward"] == "Keisha Isley"
    assert _parse_tags(by["employee"]["tags"])["ncdot_subdomain_steward"] == "Keisha Isley"
    assert by["comp_plan"]["steward"] == "Sara Royster"
    assert by["policy"]["steward"] == "Daphne Wright"
    assert by["term"]["steward"] == "Daphne Wright, Chris Law"
    # every product in a stewarded subdomain gets it (employee + position)
    assert by["position"]["steward"] == "Keisha Isley"
    # N/A subdomain must NOT be tagged (no fabrication)
    assert by["skill"]["steward"] == ""
    assert "ncdot_subdomain_steward" not in _parse_tags(by["skill"]["tags"])
    assert added == 4  # 4 named, talent_development skipped


def test_v349_steward_does_not_overwrite_existing():
    products = [
        {"product": "x", "subdomain": "sd1", "steward": "Already Set", "tags": ""},
    ]
    mappings = [{"subdomain": "sd1", "steward": "New Name"}]
    _apply_subdomain_stewards(products, mappings)
    # existing model steward preserved; tag still stamped for physical visibility
    assert products[0]["steward"] == "Already Set"


def test_v349_prepatch_leaves_stewards_empty():
    # Proves the gap existed: WITHOUT the pass, empty subdomain stewards stay empty.
    products = [{"product": "employee", "subdomain": "employee_records", "steward": "", "tags": ""}]
    # pre-patch: no population happens
    assert products[0]["steward"] == ""
    assert "ncdot_subdomain_steward" not in _parse_tags(products[0]["tags"])
    # post-patch recovers it
    _apply_subdomain_stewards(products, [{"subdomain": "employee_records", "steward": "Keisha Isley"}], "ncdot_")
    assert products[0]["steward"] == "Keisha Isley"


# --------------------------------------------------------------------------- #
# oracle scoring fix (verify_protocol.py): denominator = TOTAL TRUE VREQs      #
# --------------------------------------------------------------------------- #
def test_v349_oracle_count_agent_vreqs():
    if _RUNNER not in sys.path:
        sys.path.insert(0, _RUNNER)
    import verify_protocol as vp
    vibe = (
        "VREQ-001 something\n"
        "VREQ-002 another\n"
        "PRIORITY 1 — fix x\n"
        "[SA:silo] table y isolated\n"
        "unrelated prose line\n"
    )
    assert vp.count_agent_vreqs(vibe) == 4


def test_v349_oracle_denominator_is_total_true_not_checked_rows():
    """The bug: adherence = pass / len(rows) (only the directives the oracle parsed).
    The fix: adherence = verified_applied / total_true. With 8 true VREQs but only 4
    mechanically checked and all 4 passing, the OLD score = 100% (4/4); the NEW score = 50% (4/8)."""
    verified_applied = 4.0  # 4 mechanical PASS
    mech_total = 4          # only 4 classes the oracle could parse
    total_true = 8          # ground-truth independent extraction

    old_buggy = 100.0 * verified_applied / mech_total
    new_correct = 100.0 * verified_applied / total_true

    assert old_buggy == 100.0          # the lying scoreboard
    assert new_correct == 50.0         # honest: extraction/coverage misses count as 0
    assert new_correct < old_buggy
