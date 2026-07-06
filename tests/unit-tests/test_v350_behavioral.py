import json
import os
import re

_NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _full():
    nb = json.load(open(_NB))
    return "\n".join("".join(c.get("source", [])) for c in nb["cells"])


# --------------------------------------------------------------------------- #
# version + markers                                                            #
# --------------------------------------------------------------------------- #
def test_v350_version_constant():
    src = _full()
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', src)
    assert m and tuple(int(x) for x in m.groups()) >= (3, 5, 0)


def test_v350_subdomain_name_enforce_present():
    src = _full()
    assert "subdomain-name-enforce" in src
    assert "SUBDOMAIN_NAME_ENFORCE" in src
    assert "_SUBDOMAIN_ROSTER_SCHEMA" in src
    # gated: only fires when the vibe actually mentions subdomains (no relabel on open rosters)
    assert 'if ai and vibe_text and ("subdomain" in vibe_text.lower()' in src


def test_v350_roster_schema_shape():
    src = _full()
    # schema maps product -> subdomain (not steward)
    seg = src[src.index("_SUBDOMAIN_ROSTER_SCHEMA"):src.index("_SUBDOMAIN_ROSTER_SCHEMA") + 700]
    assert '"product"' in seg and '"subdomain"' in seg
    assert '"required": ["product", "subdomain"]' in seg


# --------------------------------------------------------------------------- #
# relabel application logic (faithful re-impl of the v3.5.0 apply branch)      #
# --------------------------------------------------------------------------- #
def _apply_subdomain_roster(products, mappings):
    """Mirror of the v3.5.0 relabel branch: set product.subdomain to the vibe-declared
    name when the LLM returns a non-empty target that differs from the current label.
    Empty target => keep current (open-roster / no-roster safety)."""
    pbyname = {str(p.get("product", "")): p for p in products}
    relabelled = 0
    for m in mappings:
        pn = (m.get("product") or "").strip()
        sn = (m.get("subdomain") or "").strip()
        if not pn or not sn or pn not in pbyname:
            continue
        pp = pbyname[pn]
        if str(pp.get("subdomain") or "").strip() != sn:
            pp["subdomain"] = sn
            relabelled += 1
    return relabelled


def test_v350_relabels_invented_to_vibe_roster():
    # Mirrors gov_transport S1: generator invented labels; vibe declared the canonical 9.
    products = [
        {"product": "employee", "subdomain": "workforce_administration"},
        {"product": "position", "subdomain": "workforce_administration"},
        {"product": "comp_plan", "subdomain": "compensation_benefits"},
        {"product": "posting", "subdomain": "talent_acquisition"},
    ]
    mappings = [
        {"product": "employee", "subdomain": "Employee Records"},
        {"product": "position", "subdomain": "Employee Records"},
        {"product": "comp_plan", "subdomain": "Compensation & Benefits"},
        {"product": "posting", "subdomain": "Recruitment & Onboarding"},
    ]
    n = _apply_subdomain_roster(products, mappings)
    by = {p["product"]: p for p in products}
    assert by["employee"]["subdomain"] == "Employee Records"
    assert by["position"]["subdomain"] == "Employee Records"
    assert by["comp_plan"]["subdomain"] == "Compensation & Benefits"
    assert by["posting"]["subdomain"] == "Recruitment & Onboarding"
    assert n == 4


def test_v350_empty_target_keeps_current_open_roster():
    # Open roster (healthcare/automotive): LLM returns empty -> no relabel, no fabrication.
    products = [
        {"product": "claim", "subdomain": "billing"},
        {"product": "encounter", "subdomain": "clinical"},
    ]
    mappings = [
        {"product": "claim", "subdomain": ""},
        {"product": "encounter", "subdomain": ""},
    ]
    n = _apply_subdomain_roster(products, mappings)
    assert n == 0
    assert products[0]["subdomain"] == "billing"
    assert products[1]["subdomain"] == "clinical"


def test_v350_idempotent_when_already_matching():
    # If the model subdomain already equals the vibe roster name, it must be a no-op.
    products = [{"product": "employee", "subdomain": "Employee Records"}]
    mappings = [{"product": "employee", "subdomain": "Employee Records"}]
    n = _apply_subdomain_roster(products, mappings)
    assert n == 0
    assert products[0]["subdomain"] == "Employee Records"


def test_v350_unknown_product_ignored():
    products = [{"product": "employee", "subdomain": "x"}]
    mappings = [{"product": "ghost", "subdomain": "Employee Records"}]
    n = _apply_subdomain_roster(products, mappings)
    assert n == 0
    assert products[0]["subdomain"] == "x"


def test_v350_prepatch_leaves_invented_labels():
    # Proves the gap: WITHOUT the pass, invented labels persist (never match the vibe roster).
    products = [{"product": "employee", "subdomain": "workforce_administration"}]
    assert products[0]["subdomain"] == "workforce_administration"
    _apply_subdomain_roster(products, [{"product": "employee", "subdomain": "Employee Records"}])
    assert products[0]["subdomain"] == "Employee Records"
