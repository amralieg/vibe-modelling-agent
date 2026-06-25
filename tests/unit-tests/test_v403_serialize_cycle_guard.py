import json
from pathlib import Path

import agent_helpers as ah

PRE = Path("/tmp/v402_backup.ipynb")  # pre-v4.0.3 (v4.0.2) backup, no serialization cycle-guard


class _L:
    def info(self, *a, **k):
        pass

    def warning(self, *a, **k):
        pass


LOG = _L()


def _cycles(model):
    pd, ad = [], []
    for d in model["domains"]:
        for p in d.get("products", []):
            pd.append({"domain": d["name"], "product": p["name"]})
            for a in p.get("attributes", []):
                ad.append({
                    "domain": d["name"], "product": p["name"],
                    "attribute": a["name"], "foreign_key_to": a.get("foreign_key_to", ""),
                })
    return ah._detect_cycles_dfs(pd, ad, LOG)


def _fks(model):
    return [a.get("foreign_key_to", "")
            for d in model["domains"] for p in d.get("products", [])
            for a in p.get("attributes", []) if a.get("foreign_key_to")]


def _model_2cycle():
    return {"domains": [{"name": "fin", "products": [
        {"name": "company_code", "attributes": [
            {"name": "cc_id", "tags": "primary_key"},
            {"name": "coa_id", "tags": "", "foreign_key_to": "fin.chart_of_accounts.coa_id"}]},
        {"name": "chart_of_accounts", "attributes": [
            {"name": "coa_id", "tags": "primary_key"},
            {"name": "cc_id", "tags": "", "foreign_key_to": "fin.company_code.cc_id"}]},
    ]}]}


# ----- version -----
def test_version_bumped_to_403():
    assert ah.__AGENT_VERSION__ == "4.1.2", ah.__AGENT_VERSION__


# ----- pass-post: 2-cycle in the NESTED dict is broken in place -----
def test_guard_breaks_2cycle_in_nested_dict():
    m = _model_2cycle()
    assert len(_cycles(m)) >= 1
    cleared = ah._v403_break_cycles_in_serialized_model(m, LOG)
    assert cleared >= 1
    assert len(_cycles(m)) == 0
    assert len(_fks(m)) == 1  # exactly one of the two cyclic FKs cleared


def test_guard_breaks_3cycle_in_nested_dict():
    m = {"domains": [{"name": "s", "products": [
        {"name": "opportunity", "attributes": [
            {"name": "opportunity_id", "tags": "primary_key"},
            {"name": "quote_id", "foreign_key_to": "s.quote.quote_id"}]},
        {"name": "quote", "attributes": [
            {"name": "quote_id", "tags": "primary_key"},
            {"name": "contract_id", "foreign_key_to": "s.sales_contract.contract_id"}]},
        {"name": "sales_contract", "attributes": [
            {"name": "contract_id", "tags": "primary_key"},
            {"name": "opportunity_id", "foreign_key_to": "s.opportunity.opportunity_id"}]},
    ]}]}
    assert len(_cycles(m)) >= 1
    ah._v403_break_cycles_in_serialized_model(m, LOG)
    assert len(_cycles(m)) == 0


# ----- idempotent no-op on a clean model (no FK wrongly cleared) -----
def test_clean_model_is_noop():
    m = {"domains": [{"name": "d", "products": [
        {"name": "a", "attributes": [{"name": "a_id", "tags": "primary_key"}]},
        {"name": "b", "attributes": [
            {"name": "b_id", "tags": "primary_key"},
            {"name": "a_id", "foreign_key_to": "d.a.a_id"}]},
    ]}]}
    assert len(_cycles(m)) == 0
    cleared = ah._v403_break_cycles_in_serialized_model(m, LOG)
    assert cleared == 0
    assert _fks(m) == ["d.a.a_id"]


# ----- CLAUDE.md S3c: user-vibed edge protected when a non-vibed alternative exists -----
def test_vibed_edge_protected_when_alternative_exists():
    m = {"domains": [{"name": "x", "products": [
        {"name": "a", "attributes": [
            {"name": "a_id", "tags": "primary_key"},
            {"name": "b_id", "foreign_key_to": "x.b.b_id", "_dynamically_created": True}]},
        {"name": "b", "attributes": [
            {"name": "b_id", "tags": "primary_key"},
            {"name": "a_id", "foreign_key_to": "x.a.a_id"}]},
    ]}]}
    assert len(_cycles(m)) >= 1
    ah._v403_break_cycles_in_serialized_model(m, LOG)
    assert len(_cycles(m)) == 0
    a_fk = [a.get("foreign_key_to", "") for a in m["domains"][0]["products"][0]["attributes"] if a["name"] == "b_id"][0]
    b_fk = [a.get("foreign_key_to", "") for a in m["domains"][0]["products"][1]["attributes"] if a["name"] == "a_id"][0]
    assert a_fk == "x.b.b_id", "user-vibed edge must be protected"
    assert b_fk == "", "non-vibed edge should be broken"


# ----- fail-pre: the v4.0.2 backup has neither the guard fn nor the call -----
def test_fail_pre_v402_lacks_guard():
    if not PRE.exists():
        import pytest
        pytest.skip(f"pre-patch backup {PRE} absent (ephemeral /tmp dev artifact); fail-pre half is historical, pass-post protects live behavior")
    src = "".join("".join(c.get("source", []))
                  for c in json.load(open(PRE))["cells"] if c.get("cell_type") == "code")
    assert "_v403_break_cycles_in_serialized_model" not in src, "v4.0.2 backup unexpectedly already has the guard"
    assert "v403-serialize-cycle-guard" not in src
