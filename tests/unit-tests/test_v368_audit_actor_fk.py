"""v3.6.8 hc-rootcause behavioral test: audit-actor FKs (created_by_*, updated_by_*, approved_by_*,
... and the universal '<verb>_by_<actor>_id' pattern) are recognised as convenience edges so the
deterministic cycle-breaker sacrifices THEM first (+10000) and PROTECTS real domain/ownership FKs.

ROOT CAUSE (healthcare base-MVM 2026-06-17): every product carried audit/actor FKs pointing at a
central workforce.employee / provider hub (provider had 447 incoming FKs), feeding 2062 FK cycles.
The convenience detector only knew latest_/current_/primary_/... so the breaker risked sacrificing
structural FKs instead of these low-value audit edges.

FIX (alias=audit-actor-fk-convenience): _is_convenience_fk also returns True for any name containing
'_by_'. Used ONLY in cycle-break scoring, never at FK creation, so acyclic audit FKs survive.

Test A (fail-pre/pass-post): audit-actor names are convenience + score >= 10000.
Test B (regression guard): existing convenience prefixes still True.
Test C (negative control, no §8.3 over-match): real domain FKs are NOT convenience.
"""
from collections import defaultdict
from notebook_source_util import notebook_concat_source


def _helper_namespace():
    src = notebook_concat_source()
    start = src.index("_CONVENIENCE_FK_PREFIXES = (")
    end = src.index("def _break_cycles(", start)
    block = src[start:end]
    ns = {"defaultdict": defaultdict}
    exec(compile(block, "<cyclebreak_helpers>", "exec"), ns)
    return ns


_NS = _helper_namespace()
_is_convenience_fk = _NS["_is_convenience_fk"]
_heuristic_edge_break_score = _NS["_heuristic_edge_break_score"]


def test_audit_actor_fk_is_convenience():
    """Audit-actor FK names must be convenience (fails pre-patch)."""
    for name in [
        "created_by_user_employee_id",   # exact healthcare log case
        "created_by_employee_id",
        "created_by_staff_employee_id",
        "updated_by_id",
        "approved_by_user_id",
        "reviewed_by_provider_id",
        "signed_by_id",
    ]:
        assert _is_convenience_fk(name) is True, f"{name} must be detected as audit-actor convenience FK"


def test_audit_actor_fk_scores_break_first():
    """The cycle-break scorer must give an audit-actor edge the +10000 break-first weight."""
    edge_key = "clinical.note→workforce.employee"
    fk_index = {
        edge_key: [{
            "source_attribute": "created_by_user_employee_id",
            "source_domain": "clinical", "source_product": "note",
            "target_domain": "workforce", "target_product": "employee",
        }]
    }
    score = _heuristic_edge_break_score(edge_key, fk_index, incoming_count={}, edge_betweenness=None)
    assert score >= 10000, f"audit-actor edge should score break-first (+10000), got {score}"


def test_existing_convenience_prefixes_still_true():
    """Regression guard: pre-existing convenience prefixes must still be recognised."""
    for name in ["latest_status_id", "current_address_id", "primary_provider_id", "preferred_pharmacy_id"]:
        assert _is_convenience_fk(name) is True


def test_real_domain_fk_not_convenience():
    """Negative control: real structural FKs must NOT be flagged convenience (no over-match)."""
    for name in ["patient_id", "encounter_id", "employee_id", "order_set_item_id", "claim_id"]:
        assert _is_convenience_fk(name) is False, f"{name} is a structural FK, must NOT be convenience"
