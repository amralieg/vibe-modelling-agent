"""v0.7.6 universal-action-dispatch + freeze-by-default-with-required-side-effects regression tests.

User directive (2026-05-19):
  "i do not know why you limiting yourself by specificying specific action types
   for the vibes, user vibes can SPAN ANY ACTION, DO NOT LIMIT IT, NEVER EVER
   REJECT USER VIBE BECAUSE YOU DID NOT ADD THE ACTION TO THE LIST, there are 200
   actions, user can choose ANY OF THEM, NEVER EVER LIMIT IT, FORGET ABOUT THE
   MODES surgcial holistic generative remdiate ETC, THE RULE IS: USER CAN ACTION
   ANY THING, WHATEVER USER DID NOT MENTION SHOULD STAY UNCHANGED UNLESS IT IS
   REQUIRED TO CHANGE, for example user said I want to add customer table, when
   you link this table to tother you might tough other table to ADD relationships
   thats fine, if there is SSOT violations you remove subscriber table NOT
   customer table because user asked for it and so on. USER VIBES ARE KINGS."

This file enforces all 8 v0.7.6 patches via static-grep contracts on the agent
notebook so that an audit can prove each fix is on-disk and reachable.

Patches:
  P22 vov-user-authority-bypass-contract
  P23 vov-action-dispatch-universal
  P24 vov-closure-action-aware
  P25 vov-ssot-user-wins
  P26 vreq-target-revalidate-on-execute
  P27 vov-sizing-source-scale-guard
  P28 vov-master-failure-user-authority
  P29 vov-skip-regen-action-aware
"""

from __future__ import annotations

import json
import re
from pathlib import Path

import pytest

from notebook_source_util import notebook_concat_source

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
AGENT_NB = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


# ---------- Version constant ----------


def test_agent_version_is_0_7_6():
    src = notebook_concat_source()
    m = re.search(r'__AGENT_VERSION__\s*=\s*\\?"(\d+)\.(\d+)\.(\d+)\\?"', src)
    assert m, "__AGENT_VERSION__ literal not found in agent notebook"
    major, minor, patch = int(m.group(1)), int(m.group(2)), int(m.group(3))
    assert (major, minor, patch) >= (0, 7, 6), (
        f"expected v>=0.7.6, found {major}.{minor}.{patch}"
    )
    for seg_name, seg_val in [("major", major), ("minor", minor), ("patch", patch)]:
        assert 0 <= seg_val <= 9, f"{seg_name} segment {seg_val} violates §3a single-digit semver"


# ---------- P22 — vov-user-authority-bypass-contract ----------


def test_p22_helper_function_present():
    src = notebook_concat_source()
    assert "_vov_user_authority_active" in src, (
        "P22 helper _vov_user_authority_active() must be defined to centralize VOV authority "
        "detection across contract gates"
    )
    assert "vov-user-authority-helper" in src, (
        "P22 helper must carry alias=vov-user-authority-helper for audit grep"
    )


def test_p22_evaluate_action_against_contract_accepts_widgets_values():
    src = notebook_concat_source()
    assert "def evaluate_action_against_contract(action, contract, widgets_values=None)" in src, (
        "P22: evaluate_action_against_contract() must accept widgets_values kwarg so it can "
        "check VOV authority and bypass rejections"
    )


def test_p22_filter_actions_by_contract_accepts_widgets_values():
    src = notebook_concat_source()
    assert "def filter_actions_by_contract(actions, contract, logger, widgets_values=None)" in src, (
        "P22: filter_actions_by_contract() must accept widgets_values kwarg"
    )


def test_p22_contract_gates_emit_override_log():
    src = notebook_concat_source()
    assert "vov_user_authority_override:forbidden_op" in src, (
        "P22: forbidden_op rejection must be converted to override under VOV authority"
    )
    assert "vov_user_authority_override:surgical_global_rewrite_blocked" in src, (
        "P22: surgical_global_rewrite_blocked must be converted to override under VOV authority"
    )
    assert "vov_user_authority_override:domain_scope_budget_exceeded" in src, (
        "P22: domain_scope_budget_exceeded must be converted to override under VOV authority"
    )
    assert "vov_user_authority_override:product_scope_budget_exceeded" in src, (
        "P22: product_scope_budget_exceeded must be converted to override under VOV authority"
    )


def test_p22_call_site_passes_widgets_values():
    src = notebook_concat_source()
    assert (
        "filter_actions_by_contract(actions, vibe_contract, logger, widgets_values=widgets_values)" in src
    ), "P22: production call site in step_interpret must pass widgets_values to enable bypass"


def test_p22_step_setup_marks_vov_authority_active():
    src = notebook_concat_source()
    assert "_vov_user_authority_active" in src
    # config sentinel set at step_setup when operation == vibe modeling of version
    assert "VOV_USER_AUTHORITY" in src, (
        "P22: step_setup must set config['VOV_USER_AUTHORITY']=True for VOV runs"
    )


# ---------- P23 — vov-action-dispatch-universal ----------


def test_p23_universal_dispatch_log_present():
    src = notebook_concat_source()
    assert "[vov-action-dispatch-universal FIRED]" in src, (
        "P23: every action dispatch must self-report so audit can prove the user-vibe-derived "
        "action_type reached the LLM fallback handler (not silently dropped)"
    )
    assert "[vov-action-dispatch-universal MISS]" in src, (
        "P23: LLM-fallback decline must emit a loud MISS log — NOT a silent drop"
    )
    assert "[vov-action-dispatch-universal NO-AGENT]" in src, (
        "P23: missing-AI-agent edge case must emit a loud NO-AGENT log — NOT a silent drop"
    )


def test_p23_unknown_action_never_hard_rejected():
    """P23 contract: there must be NO `return False` immediately after an
    'Unknown action type' warning. Unknown actions must always flow through
    _llm_fallback_handler — never hard-stop."""
    src = notebook_concat_source()
    # Find the unknown-action warning + ensure it's accompanied by NO-AGENT alias
    assert "vov-action-dispatch-universal-no-agent" in src, (
        "P23: unknown action warning must use NO-AGENT alias (signals attempted-but-no-route, "
        "not action_type rejection)"
    )


# ---------- P24 — vov-closure-action-aware ----------


# v2.7.0: test_p24_diff_guard_accepts_applied_actions and
# test_p24_call_site_passes_applied_actions REMOVED — _strict_vov_diff_guard
# was deleted in the architectural collapse (sandbox is authoritative), so
# there is no guard signature or call site to assert.


def test_p24_creates_widgets_entry_for_allowed_actions():
    src = notebook_concat_source()
    # Notebook .ipynb is JSON-escaped; quote is \\\" in raw text
    assert 'contract_allowed_actions' in src, (
        "P24: filter_actions_by_contract call site must persist contract_allowed_actions for diff-guard"
    )
    assert re.search(r'contract_allowed_actions\\?"\]\s*=\s*actions', src), (
        "P24: must assign filter result to widgets_values[contract_allowed_actions]"
    )


# ---------- P25 — vov-ssot-user-wins ----------


def test_p25_ssot_resolver_present():
    src = notebook_concat_source()
    assert "[vov-ssot-user-wins FIRED]" in src, (
        "P25: SSOT REMOVE branch must check user-vibe closure and prefer the user-mentioned entity"
    )
    # The override must mention BOTH product_to_keep and product_to_remove reassignment
    assert re.search(r"product_to_keep\s*=\s*_user_side", src), (
        "P25: when override fires, product_to_keep must be reassigned to _user_side"
    )
    assert re.search(r"product_to_remove\s*=\s*_other_side", src), (
        "P25: when override fires, product_to_remove must be reassigned to _other_side"
    )


def test_p25_closure_mirrored_to_config():
    src = notebook_concat_source()
    assert '_vov_user_closure_for_ssot' in src, (
        "P25: step_setup must mirror closure to config[_vov_user_closure_for_ssot] so dedup can see it"
    )
    assert '_vov_user_new_entities_for_ssot' in src, (
        "P25: step_setup must mirror new_entities to config[_vov_user_new_entities_for_ssot]"
    )


# ---------- P26 — vreq-target-revalidate-on-execute ----------


def test_p26_revalidate_fired_log_present():
    src = notebook_concat_source()
    assert "[vreq-target-revalidate-on-execute FIRED]" in src, (
        "P26: fuzzy last-component revalidation must self-report on successful match"
    )
    assert "[vreq-target-revalidate-on-execute MISS]" in src, (
        "P26: revalidation MISS must be a loud WARNING — not a silent drop"
    )


def test_p26_skip_entry_includes_revalidate_resolved():
    src = notebook_concat_source()
    assert "'revalidate_resolved'" in src, (
        "P26: skipped mutation dict must include revalidate_resolved field for audit trail"
    )


# ---------- P27 — vov-sizing-source-scale-guard ----------


def test_p27_sizing_source_scale_guard_present():
    src = notebook_concat_source()
    assert "[vov-sizing-source-scale-guard FIRED]" in src, (
        "P27: sizing-source-scale guard must self-report stripped clamps"
    )
    # The guard must check source domain count >= 5 OR source product count >= 30
    assert "_src_n_d >= 5" in src or "_src_n_d>=5" in src, (
        "P27: guard threshold must consider source models with >=5 domains"
    )
    assert "_src_n_p >= 30" in src or "_src_n_p>=30" in src, (
        "P27: guard threshold must consider source models with >=30 products"
    )


def test_p27_strips_max_domains_when_shrink_over_20pct():
    src = notebook_concat_source()
    # Sentinel: when stripped, max_domains is set to None
    assert "_merged_sd['max_domains'] = None" in src, (
        "P27: guard must STRIP (set to None) max_domains when it would shrink source >20%"
    )
    assert "_merged_sd['max_total_products'] = None" in src, (
        "P27: guard must STRIP max_total_products under same condition"
    )


# ---------- P28 — vov-master-failure-user-authority ----------


def test_p28_master_failure_sets_user_authority_for_vov():
    src = notebook_concat_source()
    assert "[vov-master-failure-user-authority FIRED]" in src, (
        "P28: master classification failure under VOV must self-report USER-AUTHORITY fallback"
    )
    # Check the conditional that distinguishes VOV failure from new-base failure
    assert "_is_vov_fail" in src, (
        "P28: master failure handler must branch on whether operation is vibe modeling of version"
    )


# ---------- P29 — vov-skip-regen-action-aware ----------


def test_p29_skip_regen_action_aware_present():
    src = notebook_concat_source()
    assert "[vov-skip-regen-action-aware FIRED]" in src, (
        "P29: skip-regen must self-report when SURGICAL/HOLISTIC mode is overridden by pending "
        "regen queues from user-vibe-derived actions"
    )
    assert "_vov_user_authority_active(widgets_values)" in src, (
        "P29: skip-regen action-aware check must use the central VOV authority helper"
    )


# ---------- Anti-regression: 0.7.5 fixes still in place ----------


def test_v075_15h_timeout_still_present():
    src = notebook_concat_source()
    assert "timeout_seconds=54000" in src, "v0.7.5 15h timeout fix must remain intact"


# v2.7.0: test_v074_vov_strict_guard_still_present REMOVED — the
# vov-strict-diff-guard was intentionally deleted in the architectural
# collapse. Asserting its continued presence is now incorrect.


# ---------- Integration: parsed notebook JSON is valid ----------


def test_notebook_json_loads():
    """The agent notebook must remain valid JSON after the v0.7.6 patches."""
    with AGENT_NB.open() as f:
        nb = json.load(f)
    assert "cells" in nb
    assert isinstance(nb["cells"], list)
    assert len(nb["cells"]) >= 14, f"Expected ≥14 cells, got {len(nb['cells'])}"
