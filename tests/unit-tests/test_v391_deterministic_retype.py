"""v3.9.1 behavioral guard (§8.10 fail-pre/pass-post) for the deterministic-retype + prefix-tolerant
action breakthroughs.

Root cause these fixes address (proven on the live v385 travel_hospitality vov run):
  - The dominant sandbox residual was mechanical ops the LLM-authored mutator could not navigate
    ('did not change attribute type', empty-diff noop). Type-correction VReqs ("Correct dom.tbl.col,
    currently typed as STRING, to a DECIMAL ...") were NOT in B3's deterministic whitelist, so they
    churned to rejected_unsafe/noop_failed forever.
  - The live LLM-extracted intent carries a section/priority PREFIX ("Section 3c P2: connect_table -
    ...") so _vov_vreq_to_priority's first-word action match yielded the prefix ('section'), silently
    routing EVERY prefixed mechanical VReq onto the failing LLM sandbox instead of the deterministic
    engine.

These tests exec the VERBATIM notebook helpers (no reimplementation) and assert observable state
changes: the retype priority is produced, the attribute TYPE actually flips in the model dict, the
holistic rule is correctly deferred to the LLM path, and prefixed mechanical actions are recovered.
"""
import json
import logging
import os
import sys

import pytest

HERE = os.path.dirname(__file__)
sys.path.insert(0, os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(HERE, "..", "..", "tests"))

from vov_offline_harness import load_notebook_namespace  # noqa: E402


@pytest.fixture(scope="module")
def ns():
    namespace, _ = load_notebook_namespace()
    return namespace


def _mk(ns, intent, target, quote=None):
    Raw = ns["RawVREQ"]
    fields = set(getattr(Raw, "__dataclass_fields__", {}).keys())
    kw = dict(vreq_id="V", intent=intent, target=target, source_quote=quote or intent,
              source_chunk_id="c", severity="high", is_user_directive=False, priority_id=None)
    return Raw(**{k: v for k, v in kw.items() if k in fields})


def _model():
    return {"domains": [
        {"name": "property", "products": [
            {"name": "media", "primary_key": "media_id", "attributes": [
                {"name": "media_id", "type": "BIGINT"},
                {"name": "aspect_ratio", "type": "STRING"},
            ]}]},
        {"name": "marketing", "products": [
            {"name": "campaign_offer", "primary_key": "co_id", "attributes": [
                {"name": "co_id", "type": "BIGINT"},
                {"name": "redemption_limit_total", "type": "INT"},
            ]}]},
    ]}


def test_surgical_retype_flips_type(ns):
    """Exact live intent shape -> retype_attribute priority -> attribute type flips STRING->DECIMAL."""
    to_prio = ns["_vov_vreq_to_priority"]
    parse = ns["_v251_parse_priority_details"]
    applyf = ns["_v251_apply_priority_deterministic"]
    findattr = ns["_v251_find_attribute_row"]
    lg = logging.getLogger("t391")
    lg.addHandler(logging.NullHandler())
    model = _model()
    v = _mk(ns, "Section 3E.3: Correct property.media.aspect_ratio, currently typed as rate/pct "
                "STRING, to a DECIMAL/DOUBLE physical type", "property.media.aspect_ratio")
    p = to_prio(v)
    assert p is not None and p["action"] == "retype_attribute"
    assert p["target"] == "property.media.aspect_ratio"
    assert p["target_state"] == "DECIMAL"
    ok, msg = applyf(p, parse(p), model, lg)
    assert ok and msg == "applied"
    assert findattr(model, "property", "media", "aspect_ratio").get("type") == "DECIMAL"


def test_monetary_int_to_decimal(ns):
    to_prio = ns["_vov_vreq_to_priority"]
    parse = ns["_v251_parse_priority_details"]
    applyf = ns["_v251_apply_priority_deterministic"]
    findattr = ns["_v251_find_attribute_row"]
    lg = logging.getLogger("t391")
    lg.addHandler(logging.NullHandler())
    model = _model()
    v = _mk(ns, "Correct marketing.campaign_offer.redemption_limit_total, currently typed as money "
                "INT, to a DECIMAL physical type", "marketing.campaign_offer.redemption_limit_total")
    p = to_prio(v)
    assert p is not None and p["action"] == "retype_attribute"
    ok, msg = applyf(p, parse(p), model, lg)
    assert ok and msg == "applied"
    assert findattr(model, "marketing", "campaign_offer", "redemption_limit_total").get("type") == "DECIMAL"


def test_retype_idempotent(ns):
    """Re-applying an already-correct type must report already-applied (no false coverage)."""
    to_prio = ns["_vov_vreq_to_priority"]
    parse = ns["_v251_parse_priority_details"]
    applyf = ns["_v251_apply_priority_deterministic"]
    lg = logging.getLogger("t391")
    lg.addHandler(logging.NullHandler())
    model = _model()
    model["domains"][0]["products"][0]["attributes"][1]["type"] = "DECIMAL"
    v = _mk(ns, "Correct property.media.aspect_ratio, currently typed as STRING, to a DECIMAL "
                "physical type", "property.media.aspect_ratio")
    p = to_prio(v)
    ok, msg = applyf(p, parse(p), model, lg)
    assert ok and msg == "already-applied"


def test_holistic_retype_defers_to_llm(ns):
    """Model-wide 'every monetary attribute -> DECIMAL' is NOT a single-target deterministic op; it
    must return None so it stays on the LLM/SA path (not falsely applied to one entity)."""
    to_prio = ns["_vov_vreq_to_priority"]
    v = _mk(ns, "Section 3E.5 GENERIC RULE: every monetary attribute -> DECIMAL across the whole "
                "model", "")
    assert to_prio(v) is None


def test_prefixed_mechanical_action_recovered(ns):
    """The live 'Section 3c P2: connect_table - ...' prefix must NOT defeat action detection. Pre-fix
    the first-word match yielded 'section' (-> None -> LLM sandbox). Post-fix it resolves to
    connect_table so B3 applies it deterministically."""
    to_prio = ns["_vov_vreq_to_priority"]
    v = _mk(ns, "Section 3c P2: connect_table - add column property_id (BIGINT) with FK to "
                "property.property.property_id on marketing.campaign_offer", "marketing.campaign_offer")
    p = to_prio(v)
    assert p is not None and p["action"] == "connect_table"


def test_non_mechanical_governance_still_none(ns):
    """A pure governance/tag VReq must still return None (no over-capture by the new branches)."""
    to_prio = ns["_vov_vreq_to_priority"]
    v = _mk(ns, "apply glossary tag to every attribute in reservation.booking", "reservation.booking")
    assert to_prio(v) is None
