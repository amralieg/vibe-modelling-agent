"""v4.1.5 behavioral tests -- two root-cause fixes from the fresh v4.1.4 cross-industry
vov audit (automotive 76.2 / construction 90.5 / travel 82.8 / ngo 79.6):

RC#1 v415-verify-add-attr -- MISSION #1 lying-scoreboard lever. Add-column / add-FK
   VReqs that NAME their exact target ('On field_services.mobile_service_order add
   column party_id BIGINT FK->customer.party.party_id') had NO deterministic verifier
   (scope/scope_targets carried no 3-part triple), so _verify_deterministic returned
   None and the COARSE _verify_state_diff fallback scored them 'partial: Model changed
   but cannot confirm intent' even though the column IS present in the v2 model dict.
   Fix: a dict-grounded verifier that parses the column location+name (+optional FK)
   from the VReq text. PURE FALSE-NEGATIVE RECOVERY -- returns a verdict ONLY when the
   named column is present (fulfilled, or partial when an FK target is named but wrong);
   returns None for absent columns/products so it can NEVER false-fulfill a genuine gap.

RC#2 v415-empty-domain-final-export-sweep -- empty husk domains (consolidating /
   isolation / otherwise / data_governance) shipped in automotive's model.json with 0
   products while the v4.1.4 husk gate logged dropped=0. Root cause: every prior
   _cleanup_empty_domains call site ran on the FLAT lists BEFORE step_generate_data_model_json's
   phantom-product exclusion (0-attribute products) empties the husk in the EXPORT set.
   Fix: re-sweep the SAME _cleanup_empty_domains against the export-filtered products at
   the authoritative artifact point, with identical §3b/§3c protections.

Each test proves fail-pre on the v4.1.4 backup (/tmp/agent_pre_v415.ipynb) and pass-post
on the live notebook (CLAUDE.md §8.10).
"""
import json
import os
import re
import textwrap
import types

import pytest

import agent_helpers as ah

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")
NB_PRE = "/tmp/agent_pre_v415.ipynb"


def _full_src(path):
    nb = json.load(open(path))
    return "".join(
        "".join(c.get("source", [])) if isinstance(c.get("source"), list) else c.get("source", "")
        for c in nb["cells"]
    )


def _extract_fn(src, name):
    m = re.search(rf"\n    def {name}\(self.*?\n    def ", src, re.S)
    assert m, f"{name} not found"
    body = m.group(0)
    body = body[: body.rfind("\n    def ")]
    return textwrap.dedent(body)


class _Logger:
    def info(self, *a, **k):
        pass

    def warning(self, *a, **k):
        pass

    def error(self, *a, **k):
        pass


class _Req:
    def __init__(self, text, rid="VREQ-T"):
        self.original_text = text
        self.id = rid


def _bind(path, name):
    src = _full_src(path)
    ns = {"re": re}
    exec(_extract_fn(src, name), ns)

    class Dummy:
        logger = _Logger()

    setattr(Dummy, name, ns[name])
    return Dummy()


def _prods(pairs):
    return [{"domain": d, "product": p} for d, p in pairs]


def _attr(d, p, a, fk=None):
    x = {"domain": d, "product": p, "attribute": a}
    if fk:
        x["foreign_key_to"] = fk
    return x


# ============================== version =====================================
def test_version_bumped_to_415():
    ver = tuple(int(x) for x in ah.__AGENT_VERSION__.split("."))
    assert ver >= (4, 1, 5), ah.__AGENT_VERSION__


# ===================== RC#1 _v415_verify_add_attr (POST) ====================
PRODS = _prods([("field_services", "mobile_service_order"), ("customer", "party")])
TXT_FK = ("On field_services.mobile_service_order add column party_id BIGINT "
          "FK->customer.party.party_id")


def test_add_fk_present_correct_fulfilled():
    obj = _bind(NB, "_v415_verify_add_attr")
    attrs = [_attr("field_services", "mobile_service_order", "party_id", "customer.party.party_id")]
    v = obj._v415_verify_add_attr(_Req(TXT_FK), PRODS, attrs)
    assert v is not None and v["status"] == "fulfilled", v
    assert "v415-verify-add-attr" in v["evidence"]


def test_add_fk_present_wrong_target_partial():
    # column present but FK points at the WRONG target -> partial (honest, not fulfilled)
    obj = _bind(NB, "_v415_verify_add_attr")
    attrs = [_attr("field_services", "mobile_service_order", "party_id", "vehicle.unit.unit_id")]
    v = obj._v415_verify_add_attr(_Req(TXT_FK), PRODS, attrs)
    assert v is not None and v["status"] == "partial", v


def test_add_column_no_fk_present_fulfilled():
    obj = _bind(NB, "_v415_verify_add_attr")
    txt = "On field_services.mobile_service_order add column dispatch_notes"
    attrs = [_attr("field_services", "mobile_service_order", "dispatch_notes")]
    v = obj._v415_verify_add_attr(_Req(txt), PRODS, attrs)
    assert v is not None and v["status"] == "fulfilled", v


def test_add_column_absent_returns_none_defer():
    # MUST-defer (non-tautology): column NOT in model -> None so it never false-fulfills a gap
    obj = _bind(NB, "_v415_verify_add_attr")
    attrs = [_attr("field_services", "mobile_service_order", "some_other_col")]
    v = obj._v415_verify_add_attr(_Req(TXT_FK), PRODS, attrs)
    assert v is None, v


def test_add_column_product_absent_returns_none_defer():
    # product not in model (genuine RC#3 gap) -> None, never false-fail here
    obj = _bind(NB, "_v415_verify_add_attr")
    prods = _prods([("customer", "party")])  # mobile_service_order absent
    attrs = []
    v = obj._v415_verify_add_attr(_Req(TXT_FK), prods, attrs)
    assert v is None, v


def test_non_add_column_text_returns_none():
    obj = _bind(NB, "_v415_verify_add_attr")
    v = obj._v415_verify_add_attr(_Req("Rename product sales.order to sales.sales_order"),
                                  PRODS, [])
    assert v is None, v


def test_add_column_domain_prefix_tolerant():
    # SSOT rename: product physically named field_services_mobile_service_order;
    # the verifier must still resolve the unprefixed VReq target.
    obj = _bind(NB, "_v415_verify_add_attr")
    prods = _prods([("field_services", "field_services_mobile_service_order"), ("customer", "party")])
    attrs = [_attr("field_services", "field_services_mobile_service_order", "party_id",
                   "customer.party.party_id")]
    v = obj._v415_verify_add_attr(_Req(TXT_FK), prods, attrs)
    assert v is not None and v["status"] == "fulfilled", v


# ===================== RC#2 husk export sweep (POST) ========================
def test_cleanup_drops_empty_husk_against_export_products():
    # the mechanism the export sweep relies on: a domain with NO covering product is dropped
    domains = [{"domain": "sales"}, {"domain": "isolation"}]
    products = [{"domain": "sales", "product": "order"}]  # 'isolation' has 0 products
    dropped = ah._cleanup_empty_domains(domains, products, logger=_Logger())
    assert dropped == ["isolation"], dropped
    assert [d["domain"] for d in domains] == ["sales"], domains


def test_cleanup_protects_user_vibed_new_domain():
    # §3c protection: a user-vibed-new empty domain is KEPT (never dropped)
    domains = [{"domain": "sales"}, {"domain": "new_analytics"}]
    products = [{"domain": "sales", "product": "order"}]
    dropped = ah._cleanup_empty_domains(domains, products, logger=_Logger(),
                                        user_vibed_new_domains=["new_analytics"])
    assert "new_analytics" not in dropped, dropped
    assert {"new_analytics"} <= {d["domain"] for d in domains}


# ===================== live-source wiring (POST) ============================
def test_export_sweep_wired_after_phantom_exclusion_POST(agent_source_text):
    src = agent_source_text
    assert "v415-empty-domain-final-export-sweep FIRED" in src
    assert "_cleanup_empty_domains(domains, products_for_export" in src
    # must run AFTER products_for_export is finalized (post phantom-product exclusion)
    pf_at = src.find("    products = products_for_export")
    sweep_at = src.find("_cleanup_empty_domains(domains, products_for_export")
    assert pf_at != -1 and sweep_at != -1 and pf_at < sweep_at


def test_add_attr_verifier_wired_before_coarse_fallback_POST(agent_source_text):
    src = agent_source_text
    assert "v415-verify-add-attr" in src
    assert "self._v415_verify_add_attr(req, products_data, attributes_data)" in src
    # the dict verifier must run inside _verify_deterministic, BEFORE that function's
    # scope_targets dispatch loop (anchor on the loop that FOLLOWS the call, since the
    # 'for target in req.scope_targets:' string also appears in other functions).
    call_at = src.find("self._v415_verify_add_attr(req, products_data, attributes_data)")
    assert call_at != -1
    loop_after = src.find("        for target in req.scope_targets:", call_at)
    assert loop_after != -1 and loop_after > call_at


# ============================== FAILPRE =====================================
@pytest.mark.skipif(not os.path.exists(NB_PRE), reason="pre-v415 backup absent")
def test_add_attr_verifier_absent_pre_patch_FAILPRE():
    pre = _full_src(NB_PRE)
    assert "_v415_verify_add_attr" not in pre, "v4.1.4 must NOT have the add-attr verifier"
    assert "v415-empty-domain-final-export-sweep" not in pre, "v4.1.4 must NOT have the export sweep"
