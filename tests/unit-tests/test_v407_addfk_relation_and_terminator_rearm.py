"""v4.0.7 behavioral tests — two root-cause fixes proven fail-pre (v4.0.6) / pass-post.

Diagnosed from the live mfg v5 ground-truth audit (my-aws 2026-06-21) and the 6-run
batch teardown hang:

  1. verifier-relation-domain-prefix-resolve — VREQ-046/047 'add FK production.plant ->
     finance.company_code' scored FAILED by the _verify_deterministic relation+table
     branches because the SSOT normalizer renamed the table to production.production_plant
     and the branches substring-matched the PRE-rename 'production.plant', missing the
     physically-present FK. v4.0.6 fixed only _verify_structural_target; the relation/table
     branches were the surviving false-negative site. Now both call the shared
     _v407_resolve_dp resolver.

  2. v407-rearm-robust-terminators — the GIL-immune _spawn_process_kill_watchdog
     (control-plane self-cancel + faulthandler) was DEMOTED TO DEAD CODE in v4.0.6
     (0 call sites), leaving only a GIL-starvable daemon os._exit that cannot win the
     GIL during a native teardown wedge -> the 6-run batch hung 70+ min in teardown.
     v4.0.7 re-arms it (grace=660s) in the pipeline finally block AND _safe_notebook_exit
     behind an arm-once guard.

fail-pre is proven against the committed v4.0.6 backup; pass-post against the live
notebook (§8.10).
"""
import json
import re
from pathlib import Path

import agent_helpers as ah

# DRY: reuse the tolerant backup loader + tiny fixtures from the v4.0.6 test module
# (same tests/unit-tests dir is on sys.path under pytest's prepend import mode).
from test_v406_verifier_false_negatives import (
    LOG,
    _Req,
    _bare_orch,
    _load_backup_module,
)

PRE = Path("/tmp/agent_v406_backup.ipynb")  # committed v4.0.6 — no v4.0.7 fixes

PLANT_FK_TEXT = ("P19: Connect production.plant to finance.company_code by adding column "
                 "finance_company_code_id (BIGINT) as an FK to "
                 "finance.company_code.company_code_id.")


def _relation_after():
    """After-state: SSOT renamed production.plant -> production.production_plant; the
    add-FK landed on the renamed table (foreign_key_to finance.company_code...)."""
    products_data = [
        {"domain": "production", "product": "production_plant"},
        {"domain": "finance", "product": "company_code"},
    ]
    attributes_data = [
        {"domain": "production", "product": "production_plant", "attribute": "production_plant_id",
         "foreign_key_to": "", "tags": "primary_key"},
        {"domain": "production", "product": "production_plant", "attribute": "finance_company_code_id",
         "foreign_key_to": "finance.company_code.company_code_id", "tags": ""},
        {"domain": "finance", "product": "company_code", "attribute": "company_code_id",
         "foreign_key_to": "", "tags": "primary_key"},
    ]
    return [], products_data, attributes_data


def _relation_req():
    r = _Req(PLANT_FK_TEXT, "VREQ-046", ["production.plant"])
    r.scope = "relation"
    return r


def _orch(klass):
    o = _bare_orch(klass)
    o.config = {}
    return o


# ============================== version =====================================
def test_version_bumped_to_407():
    assert tuple(int(x) for x in ah.__AGENT_VERSION__.split(".")) >= (4, 1, 3), ah.__AGENT_VERSION__


# ============ FIX 1: relation-branch domain-prefix-resolve (add FK) =========
def test_addfk_relation_resolves_ssot_rename_POST():
    o = _orch(ah.VibeOrchestrator)
    dd, pd, ad = _relation_after()
    res = o._verify_deterministic(_relation_req(), dd, pd, ad)
    assert res and res["status"] == "fulfilled", res


def test_addfk_relation_honest_when_fk_absent_POST():
    # FK genuinely NOT added -> must stay failed even with the resolver (no false-fulfill).
    o = _orch(ah.VibeOrchestrator)
    pd = [{"domain": "production", "product": "production_plant"},
          {"domain": "finance", "product": "company_code"}]
    ad = [
        {"domain": "production", "product": "production_plant", "attribute": "production_plant_id",
         "foreign_key_to": "", "tags": "primary_key"},
        {"domain": "finance", "product": "company_code", "attribute": "company_code_id",
         "foreign_key_to": "", "tags": "primary_key"},
    ]
    res = o._verify_deterministic(_relation_req(), [], pd, ad)
    assert res and res["status"] == "failed", res


def test_addfk_table_branch_resolves_ssot_rename_POST():
    # scope=="table" create check must also see the renamed table.
    o = _orch(ah.VibeOrchestrator)
    _, pd, ad = _relation_after()
    r = _Req("Create table production.plant", "VREQ-T", ["production.plant"])
    r.scope = "table"
    res = o._verify_deterministic(r, [], pd, ad)
    assert res and res["status"] == "fulfilled", res


def test_addfk_relation_FAILPRE_v406_scores_failed():
    pre = _load_backup_module(PRE)
    assert pre.__AGENT_VERSION__ == "4.0.6", pre.__AGENT_VERSION__
    o = _bare_orch(pre.VibeOrchestrator)
    o.logger = LOG
    o.config = {}
    dd, pd, ad = _relation_after()
    res = o._verify_deterministic(_relation_req(), dd, pd, ad)
    # pre-patch: 'production.plant' substring-misses the renamed table -> false-negative FAILED
    assert res and res["status"] == "failed", res
    assert "No FK relationship found" in (res.get("evidence") or "")


def test_v407_resolver_helper_absent_in_v406():
    pre = _load_backup_module(PRE)
    assert not hasattr(pre, "_v407_resolve_dp"), \
        "v4.0.6 must NOT have the shared domain-prefix resolver (fail-pre proof)"


# ============ FIX 1b: move_product verifier (cannot-confirm-intent FN) ======
MOVE_DONE = "Move product bid.contract_agreement to the contract domain, because it belongs there."
MOVE_NOTDONE = "P17 (move_product): Move bid.payment_application to the finance domain."


def _mv_req(text, rid, targets):
    r = _Req(text, rid, targets)
    r.scope = "product"
    return r


def _prods(rows):
    return [{"domain": d, "product": p} for d, p in rows]


def test_move_product_fulfilled_when_moved_POST():
    o = _orch(ah.VibeOrchestrator)
    pd = _prods([("contract", "contract_agreement"), ("subcontractor", "subcontract_agreement")])
    res = o._verify_deterministic(_mv_req(MOVE_DONE, "VREQ-037", ["bid.contract_agreement"]), [], pd, [])
    assert res and res["status"] == "fulfilled", res


def test_move_product_failed_when_not_moved_POST():
    # honest: genuine miss must NOT get false partial-credit -> failed
    o = _orch(ah.VibeOrchestrator)
    pd = _prods([("bid", "bid_payment_application")])
    res = o._verify_deterministic(_mv_req(MOVE_NOTDONE, "VREQ-038", ["bid.payment_application"]), [], pd, [])
    assert res and res["status"] == "failed", res


def test_move_product_partial_when_source_copy_remains_POST():
    o = _orch(ah.VibeOrchestrator)
    pd = _prods([("contract", "contract_agreement"), ("bid", "bid_contract_agreement")])
    res = o._verify_deterministic(_mv_req(MOVE_DONE, "VREQ-037", ["bid.contract_agreement"]), [], pd, [])
    assert res and res["status"] == "partial", res


def test_move_product_FAILPRE_v406_not_fulfilled():
    pre = _load_backup_module(PRE)
    o = _bare_orch(pre.VibeOrchestrator)
    o.logger = LOG
    o.config = {}
    pd = _prods([("contract", "contract_agreement"), ("subcontractor", "subcontract_agreement")])
    res = o._verify_deterministic(_mv_req(MOVE_DONE, "VREQ-037", ["bid.contract_agreement"]), [], pd, [])
    # pre-patch: no move_product branch -> None (falls to coarse 'cannot confirm intent' downstream)
    assert (res is None) or (res.get("status") != "fulfilled"), res


# ============ FIX 2: robust-terminator re-arm wiring ========================
def _agent_source():
    nb = json.loads(Path(ah.__file__).read_bytes().decode("utf-8"))
    return "".join("".join(c["source"]) for c in nb["cells"] if c["cell_type"] == "code")


def test_terminator_armonce_guard_present_POST():
    assert isinstance(ah._V407_TERMINATORS_ARMED, dict)
    assert ah._V407_TERMINATORS_ARMED.get("done") is False


def test_terminator_rearm_wired_two_sites_POST():
    src = _agent_source()
    # The GIL-immune watchdog is now CALLED (grace=660) at >=2 funnels: pipeline-finally
    # and safe-notebook-exit. v4.0.6 had it defined but never called.
    assert src.count("_spawn_process_kill_watchdog(grace_seconds=660") >= 2, \
        src.count("_spawn_process_kill_watchdog(grace_seconds=660")
    assert "_V407_TERMINATORS_ARMED[\"done\"] = True" in src


def test_terminator_was_dead_code_FAILPRE_v406():
    if not PRE.exists():
        import pytest
        pytest.skip(f"pre-patch backup {PRE} absent (ephemeral /tmp dev artifact); fail-pre half historical, pass-post protects live behavior")
    pre_src = json.loads(PRE.read_bytes().decode("utf-8"))
    src = "".join("".join(c["source"]) for c in pre_src["cells"] if c["cell_type"] == "code")
    # fail-pre: v4.0.6 defines the watchdog but NEVER calls it with the re-arm grace (dead code).
    assert "def _spawn_process_kill_watchdog" in src, "watchdog should still be DEFINED in v4.0.6"
    assert src.count("_spawn_process_kill_watchdog(grace_seconds=660") == 0, \
        "v4.0.6 must have ZERO re-arm call sites (proves the dead-code regression)"
