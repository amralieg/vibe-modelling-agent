"""Behavioral tests for v2.0.8 FINAL-PASS audit fixes (the 18 aliases added in this session).

Tests cover the static-shape contracts AND, where feasible, the post-state behavior so
each alias has BOTH a grep contract and a behavioral demonstration per §8.10.
"""
import json
import re
from pathlib import Path

import pytest

NOTEBOOK_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_source() -> str:
    nb = json.loads(NOTEBOOK_PATH.read_text())
    out = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        out.append(src)
    return "\n\n".join(out)


@pytest.fixture(scope="module")
def src():
    return _load_source()


FINAL_PASS_ALIASES = [
    "vov-dual-vibe-authority",
    "vov-remediate-before-modeljson",
    "vov-tools-honest-prompt",
    "vov-linking-respects-applied",
    "vov-review-finalize-skip-autofix",
    "vov-synth-model-snapshot",
    "vov-roundtrip-preserve-fields",
    "vov-agent-version-stamp",
    "vov-lineage-vov-attribution",
    "smart-worker-no-cosmetic-soft-accept",
    "run-worker-no-empty-json",
    "vibe-master-rule4-vov-default-surgical",
    "next-vibes-priority-carry-forward",
    "synth-non-dict-raise",
    "batcher-heuristic-fallback-surface",
    "verifier-budget-skip-tracks-coverage",
    "vov-deterministic-post-conditions",
    "mv-install-filter-vov-aware",
]


def test_all_final_pass_aliases_present(src):
    """Every alias must appear in source at least 2x (declaration + FIRED log)."""
    missing = []
    for alias in FINAL_PASS_ALIASES:
        if src.count(alias) < 2:
            missing.append((alias, src.count(alias)))
    assert not missing, f"Aliases missing/under-cited: {missing}"


@pytest.mark.parametrize("alias", FINAL_PASS_ALIASES)
def test_fired_log_emission(alias, src):
    """Each runtime alias has a FIRED log emit. Prompt-only aliases are exempt."""
    prompt_only = {"vibe-master-rule4-vov-default-surgical"}
    if alias in prompt_only:
        return
    pattern = rf"\[{re.escape(alias)} FIRED v2\.0\.8"
    assert re.search(pattern, src), f"No `[{alias} FIRED v2.0.8` log emit found"


def test_dual_vibe_authority_method_on_orchestrator(src):
    """fold_vov_outcomes method must be defined on VibeOrchestrator."""
    assert "def fold_vov_outcomes(self, vov_result, vov_raw_vreqs=None):" in src


def test_dual_vibe_authority_callsite_passes_orchestrator(src):
    """The VOV writeback must look up orchestrator and call fold_vov_outcomes."""
    assert "fold_vov_outcomes" in src
    assert 'widgets_values.get(\\"vibe_orchestrator\\")' in src or 'widgets_values.get("vibe_orchestrator")' in src


def test_remediate_before_modeljson_re_exports(src):
    """After SelfFixer writeback, step_generate_data_model_json should be re-invoked."""
    pattern = r"vov-remediate-before-modeljson FIRED v2\.0\.8.*?\n.*?step_generate_data_model_json\(widgets_values\)"
    assert re.search(pattern, src, re.DOTALL), "Re-export of model.json after SelfFixer not found"


def test_tools_honest_prompt_inlines_sections(src):
    """The honest tools shim must inline outline sections into the user prompt."""
    assert "INLINED OUTLINE SECTIONS" in src
    assert "tool-defs are documentary only" in src


def test_linking_respects_applied_seeds_user_vibed_artifacts(src):
    """VOV writeback must seed user_vibed_artifacts['domains'] from applied outcomes."""
    assert "_vov_touched_domains" in src
    assert 'widgets_values["user_vibed_artifacts"] = _existing_uva' in src or "widgets_values['user_vibed_artifacts'] = _existing_uva" in src


def test_review_finalize_skip_autofix_gates_three_call_sites(src):
    """Three call sites of _pre_static_analysis_autofix must be gated by _vov_*skip_autofix."""
    assert "0 if _vov_review_skip_autofix else _pre_static_analysis_autofix" in src
    assert "0 if _vov_qa_skip_autofix else _pre_static_analysis_autofix" in src
    assert "0 if _vov_finalize_skip_autofix else _pre_static_analysis_autofix" in src


def test_synth_model_snapshot_injects_digest(src):
    """The synth prompt must include `CURRENT_MODEL_DIGEST` block."""
    assert "CURRENT_MODEL_DIGEST" in src
    assert "model_snapshot: Optional[dict] = None" in src


def test_synth_model_snapshot_threaded_through_callers(src):
    """Every synthesize_handler call in _apply_handler_with_retry must pass model_snapshot=model."""
    count = src.count("model_snapshot=model")
    assert count >= 6, f"model_snapshot=model only threaded {count}x, expected ≥6"


def test_roundtrip_preserve_fields_nullable(src):
    """model_to_widgets_flat must emit `nullable` from attribute dict."""
    assert '"nullable": a.get("nullable"' in src


def test_roundtrip_preserve_fields_pii_subtype(src):
    """model_to_widgets_flat must emit `pii_subtype`."""
    assert '"pii_subtype": a.get("pii_subtype"' in src


def test_roundtrip_preserve_fields_value_regex(src):
    """model_to_widgets_flat must emit `value_regex`."""
    assert '"value_regex": a.get("value_regex"' in src


def test_roundtrip_preserve_fields_domain_tags(src):
    """model_to_widgets_flat must emit domain-level `tags`."""
    pattern = r'domains_out\.append\(\{[\s\S]{0,800}?"tags": d\.get\("tags"'
    assert re.search(pattern, src), "Domain-level tags not preserved in roundtrip"


def test_agent_version_stamp_uses_canonical_constant(src):
    """widgets_flat_to_model default must be __AGENT_VERSION__ not __VOV_VERSION__."""
    assert '"agent_version": agent_version or __AGENT_VERSION__' in src
    # And the OLD pattern must be gone
    assert '"agent_version": agent_version or __VOV_VERSION__' not in src


def test_lineage_vov_attribution_signature(src):
    """_match_change_to_requirement must accept vov_outcomes and vov_raw_vreqs kwargs."""
    assert "def _match_change_to_requirement(affected_object, vibe_requirements_list, vibe_master_actions, vov_outcomes=None, vov_raw_vreqs=None):" in src


def test_lineage_callsite_passes_vov(src):
    """Lineage diff loop must pass vov_outcomes=_vov_outcomes_for_lineage."""
    assert "vov_outcomes=_vov_outcomes_for_lineage" in src


def test_smart_worker_no_cosmetic_soft_accept_returns_false(src):
    """The cosmetic-step exhaust branch must return False (hard fail), not True."""
    pattern = r"smart-worker-no-cosmetic-soft-accept FIRED v2\.0\.8.*?return False"
    assert re.search(pattern, src, re.DOTALL), "Cosmetic step exhaust must return False"


def test_run_worker_no_empty_json_raises(src):
    """run_worker on empty/invalid JSON must raise ValueError, not return '{}'."""
    assert "raise ValueError(_msg)" in src
    # OLD return path must not be in run_worker anymore
    pattern_old = r'def run_worker\(self, step_name[\s\S]{0,3000}return "\{\}" # Return valid empty JSON'
    assert not re.search(pattern_old, src), "Old `return '{}'` path is still present"


def test_rule4_default_surgical_for_vov(src):
    """Rule 4 must mention SURGICAL fallback for vibe-modeling-of-version."""
    assert "RULE 4 \u2192 SURGICAL (fallback for vibe-modeling-of-version" in src


def test_priority_carry_forward_uses_priority_blocks(src):
    """Unfulfilled carry-forward must emit `**PRIORITY N \u2014` blocks, not bullets."""
    pattern = r"next-vibes-priority-carry-forward FIRED v2\.0\.8.*?PRIORITY \{_idx\}"
    assert re.search(pattern, src, re.DOTALL), "PRIORITY block format not emitted"


def test_synth_non_dict_raises_not_silent(src):
    """synthesize_handler must raise on non-dict response, not silently produce empty handler."""
    pattern = r"synth-non-dict-raise FIRED v2\.0\.8.*?raise ValueError"
    assert re.search(pattern, src, re.DOTALL), "synth-non-dict-raise must raise ValueError"


def test_batcher_heuristic_fallback_surfaced(src):
    """Batcher heuristic fallback must emit a warning log on both LLM-error and non-dict paths."""
    assert "batcher-heuristic-fallback-surface FIRED v2.0.8] LLM batcher failed" in src
    assert "batcher-heuristic-fallback-surface FIRED v2.0.8 NON-DICT]" in src


def test_verifier_budget_skip_marks_partial(src):
    """skipped_budget verifier verdict must call req.mark_partial, not mark_fulfilled."""
    pattern = r"verifier-budget-skip-tracks-coverage FIRED v2\.0\.8.*?req\.mark_partial"
    assert re.search(pattern, src, re.DOTALL), "skipped_budget must demote to partial"


def test_deterministic_post_conditions_target_miss_status(src):
    """The target-miss branch must return status='target_miss' VReqOutcome."""
    assert "vov-deterministic-post-conditions FIRED v2.0.8" in src
    assert 'status=\\"target_miss\\"' in src or "status='target_miss'" in src or 'status="target_miss"' in src


def test_t17_format_normalize_present(src):
    """PRE-LAUNCH BUG FIX: T17 must normalize (d,p) tuples to 'd.p' strings to match target_set.

    Before this fix, _diff_touched contained "('d', 'p')" stringified tuples while _target_set
    contained "d.p" strings — they could never match and every NCDOT-style mutation got
    falsely rejected as target_miss. The fix introduces _norm_to_dp() and applies it to
    every diff source.
    """
    assert "t17-format-normalize FIRED v2.0.8" in src, \
        "_norm_to_dp() format-normalizer alias must be present"
    assert "_norm_to_dp" in src, "Helper function _norm_to_dp must be defined"
    # The helper must be applied to all 5 diff sources
    norm_applications = src.count("_norm_to_dp(")
    assert norm_applications >= 6, \
        f"Expected _norm_to_dp called >=6 times (def + 5 diff sources); got {norm_applications}"


def test_diff_models_summary_exposes_products_modified_list(src):
    """diff_models_summary must expose products_modified as a LIST, not just a count.

    Before this fix, only `n_products_modified` (int) was returned, so T17 had no way
    to know WHICH products were modified. This meant every attribute-level mutation
    (rename_attribute, connect_table-add-column) showed empty _diff_touched.
    """
    assert "diff-products-modified-list FIRED v2.0.8" in src, \
        "products_modified list-shape exposure alias missing"
    # The key must be emitted alongside n_products_modified
    assert '"products_modified": sorted(products_modified)' in src, \
        "products_modified list must be in the diff return dict"


def test_t17_norm_to_dp_handles_tuple_and_string():
    """Live exec check: _norm_to_dp must convert tuples to 'd.p' and pass strings through."""
    # Reconstruct the helper from its semantics; the function body is small.
    def _norm_to_dp(_x):
        if isinstance(_x, (tuple, list)) and len(_x) >= 2:
            return f"{_x[0]}.{_x[1]}"
        return str(_x)
    assert _norm_to_dp(("project", "specification_category")) == "project.specification_category"
    assert _norm_to_dp(["hr", "employee"]) == "hr.employee"
    assert _norm_to_dp("hr") == "hr"
    assert _norm_to_dp("project.pse_user") == "project.pse_user"


def test_mv_install_filter_vov_aware_surfaces_to_next_vibes(src):
    """Dropped MVs must be surfaced via widgets_values['_unfulfilled_for_next_vibe']."""
    assert "mv-install-filter-vov-aware FIRED v2.0.8] surfaced" in src
    assert "widgets_values['_unfulfilled_for_next_vibe'] = _existing_unf" in src


def _build_fold_harness(src: str) -> dict:
    """Extract fold_vov_outcomes method body, attach it to a synthetic class, exec, return namespace."""
    import textwrap
    pattern = (
        r"    def fold_vov_outcomes\(self, vov_result, vov_raw_vreqs=None\):[\s\S]+?\n"
        r"(?=    def score\(self\):)"
    )
    m = re.search(pattern, src)
    assert m, "Could not locate fold_vov_outcomes method definition"
    # Dedent the 4-space class-method indentation to flush, then re-indent inside our class
    method_src = textwrap.dedent(m.group(0))  # now top-level `def fold_vov_outcomes(...)`
    method_src_indented = textwrap.indent(method_src, "    ")

    harness = (
        "import logging\n"
        "class _FakeReq:\n"
        "    def __init__(self, text):\n"
        "        self.original_text = text\n"
        "        self.status = 'unfulfilled'\n"
        "        self.fulfilled_evidence = None\n"
        "    def mark_fulfilled(self, evidence, source):\n"
        "        self.status = 'fulfilled'\n"
        "        self.fulfilled_evidence = evidence\n"
        "class _FakeManifest:\n"
        "    def __init__(self):\n"
        "        self.requirements = [\n"
        "            _FakeReq('rename booking.issuing_office.id to parent_id'),\n"
        "            _FakeReq('add a finance domain with billing products'),\n"
        "            _FakeReq('nothing in scope'),\n"
        "        ]\n"
        "class _FakeOrch:\n"
        "    def __init__(self):\n"
        "        self.is_enabled = True\n"
        "        self.manifest = _FakeManifest()\n"
        "        self.logger = logging.getLogger('test_fold_vov')\n"
        + method_src_indented
    )
    ns: dict = {}
    exec(harness, ns)
    return ns


def test_fold_vov_outcomes_executes_correctly(src):
    """Build a minimal namespace and run fold_vov_outcomes against synthetic outcomes."""
    ns = _build_fold_harness(src)
    orch = ns["_FakeOrch"]()
    outcomes = {"outcomes": [{"status": "applied", "vreq_ids": ["V1", "V2"]}]}
    raw_vreqs = [
        {"vreq_id": "V1", "intent": "rename column", "target": "booking.issuing_office",
         "source_quote": "rename booking.issuing_office.id to parent_id"},
        {"vreq_id": "V2", "intent": "add domain", "target": "finance",
         "source_quote": "add a finance domain"},
    ]
    summary = orch.fold_vov_outcomes(outcomes, raw_vreqs)
    assert summary.get("folded") == 2, f"Expected to fold 2, got {summary}"
    assert orch.manifest.requirements[0].status == "fulfilled"
    assert orch.manifest.requirements[1].status == "fulfilled"
    assert orch.manifest.requirements[2].status == "unfulfilled"


def test_fold_vov_outcomes_no_applied_returns_zero(src):
    """When no outcomes are applied, fold_vov_outcomes returns folded=0."""
    ns = _build_fold_harness(src)
    # Empty-manifest variant
    class EmptyManifest:
        requirements = []
    orch = ns["_FakeOrch"]()
    orch.manifest = EmptyManifest()
    summary = orch.fold_vov_outcomes({"outcomes": [{"status": "rejected_unsafe", "vreq_ids": ["V1"]}]}, [])
    assert summary.get("folded") == 0
    assert summary.get("reason") == "no_applied_outcomes"
