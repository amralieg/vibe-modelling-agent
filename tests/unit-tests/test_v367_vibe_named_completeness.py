"""Behavioral tests for v3.6.7 Fix#1 (alias=vibe-named-entities-harvest / vibe-completeness-gate).

ROOT CAUSE under test: the healthcare base-MVM (59.5% adherence) DROPPED user-required
domains (`workforce`, `reference`) and under-generated products because the
`business_domains` widget was EMPTY, so only widget-named domains were pinned. Domains the
user named only in the vibe TEXT were never wired into the protection sets, so the judge
`domain-count-cap-tune` trimmed them with no recovery.

The fix harvests `scope=='domain'/'table'` scope_targets from the parsed VibeOrchestrator
manifest into `_USER_PINNED_DOMAINS_RUNTIME` + `_required_domains_from_vibe` /
`_required_products_from_vibe`, raises (never lowers) the sizing floor, feeds the existing
judge-inject + architect must-have, and adds a last-resort pre-physical completeness gate.

These tests extract the REAL production functions from the notebook and exercise them
end-to-end (not stubs). They FAIL on pre-patch HEAD (functions absent) and pass post-patch.
"""
import json
import re
import os

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_funcs(names):
    nb = json.load(open(NB))
    src = "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")
    g = {"re": re, "_USER_PINNED_DOMAINS_RUNTIME": set()}
    for fn in names:
        m = re.search(rf"\ndef {fn}\(.*?\n(?=\ndef |\n[^ \n])", src, re.DOTALL)
        assert m, f"function {fn} not found in notebook"
        exec(m.group(0), g)
    return g, src


class _Req:
    def __init__(self, scope, scope_targets):
        self.scope = scope
        self.scope_targets = scope_targets


def test_v367_functions_and_wiring_present():
    g, src = _load_funcs(["_v367_norm_entity", "_v367_harvest_vibe_named_entities", "_v367_completeness_reinject"])
    assert "def _v367_harvest_vibe_named_entities(" in src
    assert "def _v367_completeness_reinject(" in src
    # exactly one live call site for each (def + call)
    assert src.count("_v367_harvest_vibe_named_entities(_vibe_orchestrator") == 1
    assert src.count("_v367_completeness_reinject(consolidated_domains_to_cache") == 1
    # judge-inject now sources widget+vibe union, architect must-have fed
    assert "_required_domains_from_vibe" in src
    assert "vibe-named-product-musthave" in src
    from version_test_util import assert_version_at_least
    assert_version_at_least("3.6.7")


def test_v367_harvest_pins_vibe_named_domains_with_empty_widget():
    """The exact healthcare failure: widget empty, domains named only in vibe text."""
    g, _ = _load_funcs(["_v367_norm_entity", "_v367_harvest_vibe_named_entities"])
    harvest = g["_v367_harvest_vibe_named_entities"]
    reqs = [
        _Req("domain", ["workforce", "reference"]),
        _Req("table", ["claims.claim", "provider.clinician"]),
        _Req("model", ["*"]),
    ]
    wv = {}  # empty widget -> _user_specified_domains absent
    doms, prods = harvest(reqs, wv, None)
    assert "workforce" in doms and "reference" in doms
    # domain half of a 'domain.product' table target is also pinned
    assert "claims" in doms and "provider" in doms
    assert "claims.claim" in prods and "provider.clinician" in prods
    # wired into the protection sets the downstream inject/must-have/gate read
    assert set(wv["_required_domains_from_vibe"]) >= {"workforce", "reference", "claims", "provider"}
    assert set(wv["_required_products_from_vibe"]) >= {"claims.claim", "provider.clinician"}
    # module-level drop-guard cache extended
    assert {"workforce", "reference"} <= g["_USER_PINNED_DOMAINS_RUNTIME"]
    # sizing floor raised to fit all named domains
    assert wv["sizing_directives"]["min_domains"] >= 4


def test_v367_sizing_floor_raises_but_never_lowers():
    g, _ = _load_funcs(["_v367_norm_entity", "_v367_harvest_vibe_named_entities"])
    harvest = g["_v367_harvest_vibe_named_entities"]
    reqs = [_Req("domain", ["a", "b", "c"])]
    # existing max already higher than need -> must NOT be lowered (preserve richness)
    wv = {"sizing_directives": {"max_domains": 10, "min_domains": 1}}
    harvest(reqs, wv, None)
    assert wv["sizing_directives"]["max_domains"] == 10
    assert wv["sizing_directives"]["min_domains"] == 3
    # existing max below need -> raised to fit named domains so cap-tune cannot trim them
    wv2 = {"sizing_directives": {"max_domains": 2}}
    harvest(reqs, wv2, None)
    assert wv2["sizing_directives"]["max_domains"] == 3


def test_v367_completeness_reinjects_dropped_required_domains():
    g, _ = _load_funcs(["_v367_norm_entity", "_v367_harvest_vibe_named_entities", "_v367_completeness_reinject"])
    reinject = g["_v367_completeness_reinject"]
    # model built only 'claims'; required workforce+reference were dropped downstream
    consolidated_domains = [{"domain": "claims"}]
    consolidated_products = [{"domain": "claims", "product": "claim"}]
    wv = {
        "_required_domains_from_vibe": ["workforce", "reference", "claims"],
        "_required_products_from_vibe": ["claims.claim", "workforce.employee"],
    }
    out = reinject(consolidated_domains, consolidated_products, wv, None)
    names = {d["domain"] for d in consolidated_domains}
    assert "workforce" in names and "reference" in names, "dropped required domains re-injected"
    assert set(out["reinjected_domains"]) == {"workforce", "reference"}
    # present product not flagged; absent product flagged for the agentic loop
    assert "workforce.employee" in out["missing_products"]
    assert "claims.claim" not in out["missing_products"]


def test_v367_completeness_noop_when_all_present():
    g, _ = _load_funcs(["_v367_norm_entity", "_v367_completeness_reinject"])
    reinject = g["_v367_completeness_reinject"]
    consolidated_domains = [{"domain": "workforce"}, {"domain": "claims"}]
    wv = {"_required_domains_from_vibe": ["workforce", "claims"], "_required_products_from_vibe": []}
    out = reinject(consolidated_domains, [], wv, None)
    assert out["reinjected_domains"] == []
    assert len(consolidated_domains) == 2


def test_v367_industry_agnostic():
    _, src = _load_funcs(["_v367_harvest_vibe_named_entities", "_v367_completeness_reinject"])
    m1 = re.search(r"\ndef _v367_harvest_vibe_named_entities\(.*?\n(?=\ndef )", src, re.DOTALL)
    m2 = re.search(r"\ndef _v367_completeness_reinject\(.*?\n(?=\ndef )", src, re.DOTALL)
    body = (m1.group(0) + m2.group(0)).lower()
    for term in ["healthcare", "airline", "gov_transport", "automotive", "banking", "retail"]:
        assert f'"{term}"' not in body and f"'{term}'" not in body, f"industry literal {term} in logic"
