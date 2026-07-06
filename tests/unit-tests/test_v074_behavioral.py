from notebook_source_util import notebook_concat_source

"""v0.7.4 behavioral tests — autonomous resilience bundle.

Six fixes ship together (alias prefix per fix):
    NEW-1 alias=runner-single-biz-fallback   (R1-1/R1-2: industries.json optional)
    NEW-2 alias=shrink-fk-densest-fallback   (R2-1: empty-after-orphan-drop recovery)
    NEW-3 alias=shrink-cascade-iterate       (R2-2: cascade-orphan-drop iterate then fallback)
    NEW-4 alias=ensemble-singleshot-fallback (R2-4: all-variants-failed last-chance retry)
    NEW-5 alias=install-ddl-retry-skip       (R2-5: gated transient-error skip in halt_on_error path)
    NEW-6 alias=runner-failure-manifest      (R5-1/R5-2: write _failure_manifest.json before staging drop)

These tests are STRUCTURAL (look for sentinels, signatures, ordering invariants in
the deployed notebook source). Behavioural tests proper run live during the
vibe_tester smoke after deploy.
"""

import json
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
AGENT_NB = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"
RUNNER_NB = REPO_ROOT / "runner" / "vibe_runner.ipynb"


def _load_nb_source(path: Path) -> str:
    nb = json.loads(path.read_text())
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") == "code":
            parts.append("".join(cell.get("source", [])))
    return "\n\n".join(parts)


def test_v074_agent_version_is_071_release():
    src = _load_nb_source(AGENT_NB)
    assert '__AGENT_VERSION__ = "4.2.7"' in src, (
        "__AGENT_VERSION__ must track the current single-digit semver (CLAUDE.md \u00a73a-bis)"
    )


def test_v074_agent_version_is_first_non_comment_line_of_first_code_cell():
    nb = json.loads(AGENT_NB.read_text())
    first_code_cell = next((c for c in nb["cells"] if c.get("cell_type") == "code"), None)
    assert first_code_cell is not None, "Notebook must have at least one code cell"
    src_lines = "".join(first_code_cell.get("source", [])).splitlines()
    code_lines = [ln for ln in src_lines if ln.strip() and not ln.lstrip().startswith("#")]
    assert code_lines, "First code cell must contain at least one code line"
    assert '__AGENT_VERSION__ = "4.2.7"' in code_lines[0], (
        "First non-comment code line of first code cell must declare current __AGENT_VERSION__ (CLAUDE.md §3a-bis)"
    )


# -------------------- NEW-1 runner-single-biz-fallback --------------------

def test_v074_runner_single_biz_fallback_alias_present():
    src = _load_nb_source(RUNNER_NB)
    assert "runner-single-biz-fallback" in src, (
        "NEW-1 alias must appear in vibe_runner.ipynb (deploy-time grep anchor)"
    )


def test_v074_runner_has_placeholder_or_missing_path_helper():
    src = _load_nb_source(RUNNER_NB)
    assert "_runner_is_placeholder_or_missing_path" in src, (
        "NEW-1 must define `_runner_is_placeholder_or_missing_path` to detect "
        "<your-user> placeholder + missing-file conditions"
    )


def test_v074_runner_has_single_biz_synthesiser():
    src = _load_nb_source(RUNNER_NB)
    assert "_runner_build_single_business_context_from_widgets" in src, (
        "NEW-1 must define `_runner_build_single_business_context_from_widgets` "
        "to synthesise industries.json from direct widget params"
    )


def test_v074_runner_has_single_biz_widget_defaults_dict():
    src = _load_nb_source(RUNNER_NB)
    assert "_SINGLE_BIZ_WIDGET_DEFAULTS" in src, (
        "NEW-1 must define `_SINGLE_BIZ_WIDGET_DEFAULTS` so missing widget params "
        "fall back to deterministic, industry-agnostic defaults"
    )


def test_v074_runner_load_business_context_calls_fallback_before_raising():
    src = _load_nb_source(RUNNER_NB)
    fn_start = src.find("def load_business_context(json_path)")
    assert fn_start > -1, "load_business_context must exist"
    fn_body = src[fn_start:fn_start + 6000]
    assert "_runner_is_placeholder_or_missing_path" in fn_body, (
        "load_business_context must call `_runner_is_placeholder_or_missing_path` "
        "before any FileNotFoundError raise"
    )
    assert "_runner_build_single_business_context_from_widgets" in fn_body, (
        "load_business_context must invoke the single-business synthesiser before raising"
    )


def test_v074_runner_placeholder_detection_includes_your_user_token():
    src = _load_nb_source(RUNNER_NB)
    helper_start = src.find("def _runner_is_placeholder_or_missing_path")
    assert helper_start > -1
    helper_body = src[helper_start:helper_start + 1500]
    assert "<your-user>" in helper_body, "Placeholder detector must catch the literal `<your-user>` token"


# -------------------- NEW-2 shrink-fk-densest-fallback --------------------

def test_v074_shrink_fk_densest_fallback_alias_present():
    src = _load_nb_source(AGENT_NB)
    assert "shrink-fk-densest-fallback" in src, (
        "NEW-2 alias must appear in agent notebook"
    )


def test_v074_shrink_fk_densest_fallback_replaces_emptied_raise():
    src = _load_nb_source(AGENT_NB)
    fired_pos = src.find("[shrink-orphan-drop-emptied FIRED]")
    assert fired_pos > -1, "shrink-orphan-drop-emptied must FIRE before falling back"
    window = src[fired_pos:fired_pos + 5000]
    assert "shrink-fk-densest-fallback" in window, (
        "FK-densest fallback must follow the emptied-orphan signal in the same code block"
    )
    # v3.5.1: the FK-density scoring was extracted to the shared module-level helper
    # _shrink_fk_densest_pick (DRY — replaced two copy-pasted inline _v74_fk_count loops).
    # The fallback must still score by FK in/out degree, now via the shared helper.
    assert "_shrink_fk_densest_pick(products_data, attributes_data, _v74_target_size)" in window, (
        "FK-densest fallback must score products by FK in/out degree via the shared "
        "_shrink_fk_densest_pick helper"
    )


def test_v074_shrink_fk_densest_fallback_files_next_vibes():
    src = _load_nb_source(AGENT_NB)
    assert "SHRINK_FK_DENSEST_FALLBACK_USED" in src, (
        "NEW-2 must file SHRINK_FK_DENSEST_FALLBACK_USED into NEXT_VIBES so the "
        "next vibe-iteration can refine the survivor set"
    )


# -------------------- NEW-3 shrink-cascade-iterate --------------------

def test_v074_shrink_cascade_iterate_alias_present():
    src = _load_nb_source(AGENT_NB)
    assert "shrink-cascade-iterate" in src, "NEW-3 alias must appear in agent notebook"


def test_v074_shrink_cascade_iterate_replaces_cascade_raise():
    src = _load_nb_source(AGENT_NB)
    cascade_pos = src.find("[shrink-orphan-drop-cascade FIRED]")
    assert cascade_pos > -1, "shrink-orphan-drop-cascade FIRED marker must remain"
    window = src[cascade_pos:cascade_pos + 8000]
    assert "shrink-cascade-iterate" in window, (
        "Cascade-iterate must follow cascade-detection in the same block"
    )
    assert "_v74_round" in window and "while" in window, (
        "Cascade recovery must iterate auto-drop in a while loop (up to 5 rounds)"
    )


def test_v074_shrink_cascade_falls_back_to_fk_densest_on_non_convergence():
    src = _load_nb_source(AGENT_NB)
    cascade_pos = src.find("[shrink-orphan-drop-cascade FIRED]")
    window = src[cascade_pos:cascade_pos + 10000]
    assert "(cascade-recovery path)" in window, (
        "Non-convergence + tables-empty path must engage FK-densest fallback labelled with `(cascade-recovery path)`"
    )


def test_v074_shrink_cascade_files_next_vibes_on_recovery():
    src = _load_nb_source(AGENT_NB)
    assert "SHRINK_CASCADE_AUTO_RECOVERED" in src, (
        "NEW-3 convergence path must file SHRINK_CASCADE_AUTO_RECOVERED so the "
        "next vibe-iteration can audit the surviving set"
    )


# -------------------- NEW-4 ensemble-singleshot-fallback --------------------

def test_v074_ensemble_singleshot_fallback_alias_present():
    src = _load_nb_source(AGENT_NB)
    assert "ensemble-singleshot-fallback" in src, "NEW-4 alias must appear in agent notebook"


def test_v074_ensemble_singleshot_fallback_runs_before_raise():
    src = _load_nb_source(AGENT_NB)
    fired_pos = src.find("[ensemble-singleshot-fallback FIRED]")
    assert fired_pos > -1, "ensemble-singleshot-fallback must FIRE on all-variants-failed path"
    # It must use _run_domain_generation_variant + assign successful_variants on success.
    body = src[fired_pos:fired_pos + 6000]
    assert "_run_domain_generation_variant" in body, (
        "Single-shot fallback must reuse the existing `_run_domain_generation_variant` helper (DRY §3d)"
    )
    assert "successful_variants = [" in body, (
        "Single-shot fallback success path must populate `successful_variants`"
    )


def test_v074_ensemble_singleshot_fallback_uses_temp_zero_and_clamped_max_domains():
    src = _load_nb_source(AGENT_NB)
    body_start = src.find("[ensemble-singleshot-fallback FIRED]")
    body = src[body_start:body_start + 6000]
    assert '"temperature": 0.0' in body, (
        "Single-shot fallback must use temperature 0.0 for determinism"
    )
    assert "max_business_domains" in body, (
        "Single-shot fallback must clamp max_business_domains to reduce LLM complexity"
    )


# -------------------- NEW-5 install-ddl-retry-skip --------------------

def test_v074_install_ddl_retry_skip_alias_present():
    src = _load_nb_source(AGENT_NB)
    assert "install-ddl-retry-skip" in src, "NEW-5 alias must appear in agent notebook"


def test_v074_install_ddl_recoverable_patterns_enumerated_explicitly():
    src = _load_nb_source(AGENT_NB)
    helper_start = src.find("_v74_recoverable_patterns")
    assert helper_start > -1, "Recoverable-pattern tuple must be defined"
    helper_body = src[helper_start:helper_start + 1500]
    for pat in (
        "TABLE_OR_VIEW_ALREADY_EXISTS",
        "SCHEMA_ALREADY_EXISTS",
        "COLUMN_ALREADY_EXISTS",
        "OBJECT_DOES_NOT_EXIST",
        "DEADLINE_EXCEEDED",
        "CANCELLED",
        "DELTA_CONCURRENT",
    ):
        assert pat in helper_body, (
            f"Recoverable-pattern tuple must enumerate `{pat}` (no blanket ignore — gated allow-list)"
        )


def test_v074_install_ddl_retry_skip_does_not_change_non_halt_path():
    src = _load_nb_source(AGENT_NB)
    body_start = src.find("[install-ddl-retry-skip FIRED]")
    body = src[body_start:body_start + 4000]
    # The else-if-halt branch (non-recoverable) must STILL raise.
    assert "elif halt_on_error:" in body, (
        "Non-recoverable + halt_on_error path must still raise (no blanket relaxation)"
    )
    assert '"\'{operation_name}\' statement failed. Halting execution."' in body or "Halting execution" in body


def test_v074_install_ddl_retry_skip_preserves_non_halt_continue_branch():
    """Loose-mode (halt_on_error=False) callers must still see the existing 'continues' log line."""
    src = _load_nb_source(AGENT_NB)
    assert "statement failed (continues). Error:" in src, (
        "halt_on_error=False path (existing v0.6.x behaviour) must remain"
    )


# -------------------- NEW-6 runner-failure-manifest --------------------

def test_v074_runner_failure_manifest_alias_present():
    src = _load_nb_source(RUNNER_NB)
    assert "runner-failure-manifest" in src, "NEW-6 alias must appear in vibe_runner.ipynb"


def test_v074_runner_failure_manifest_writes_before_drop_catalog():
    src = _load_nb_source(RUNNER_NB)
    manifest_pos = src.find("[runner-failure-manifest FIRED]")
    assert manifest_pos > -1, "Manifest write site must FIRE"
    drop_pos = src.find("Dropping staging catalog", manifest_pos)
    assert drop_pos > manifest_pos, (
        "Failure manifest write must occur BEFORE drop_catalog(staging) so post-mortems "
        "have evidence after staging is destroyed"
    )


def test_v074_runner_failure_manifest_captures_all_five_task_states():
    src = _load_nb_source(RUNNER_NB)
    # The manifest dict must reference all 5 task-state variables.
    for v in (
        "ecm_gen_state",
        "ecm_inst_state",
        "ecm_uninstall_state",
        "mvm_shrink_state",
        "mvm_inst_state",
    ):
        assert v in src, f"failure manifest must capture `{v}`"


def test_v074_runner_failure_manifest_only_writes_when_not_all_ok():
    src = _load_nb_source(RUNNER_NB)
    pos_marker = src.find("if not all_ok:")
    assert pos_marker > -1, "Manifest must be gated on `if not all_ok:`"
    manifest_within = src[pos_marker:pos_marker + 6000]
    assert "[runner-failure-manifest FIRED]" in manifest_within, (
        "Failure manifest must be written only on the failure branch (don't pollute SUCCESS volume)"
    )


# -------------------- README sync --------------------

def test_v074_readme_current_version_matches():
    rd = (REPO_ROOT / "readme.md").read_text()
    assert "Current version: **v0.8.0**" in rd, (
        "readme `Current version:` line must match __RELEASE_VERSION__ (public release; v0.8.0 decoupling)"
    )


def test_v074_readme_version_history_row_exists():
    rd = (REPO_ROOT / "readme.md").read_text()
    assert "| **v0.7.4** |" in rd, "readme version-history must include a v0.7.4 row"
    for alias in (
        "runner-single-biz-fallback",
        "shrink-fk-densest-fallback",
        "shrink-cascade-iterate",
        "ensemble-singleshot-fallback",
        "install-ddl-retry-skip",
        "runner-failure-manifest",
        "runner-folder-path-discovery",
        "fidelity-deterministic-attr-count",
        "fidelity-deterministic-fk-density",
        "vibe-tester-inner-workflow-error-capture",
        "mv-stale-catalog-rewrite",
        "run-test-inner-workflow-error-capture",
        "vibe-attr-cap-override",
        "mv-date-interval-autofix",
    ):
        assert alias in rd, f"v0.7.4 readme entry must mention alias=`{alias}`"


TESTER_NB = REPO_ROOT / "tests" / "vibe_tester.ipynb"


def test_v074_runner_folder_path_discovery_alias_present():
    src = _load_nb_source(RUNNER_NB)
    assert "runner-folder-path-discovery" in src, (
        "NEW-7 alias must appear in vibe_runner.ipynb (folder_path discovery)"
    )


def test_v074_runner_folder_path_discovery_anchors_under_user_home():
    src = _load_nb_source(RUNNER_NB)
    assert "vibe_runner_models" in src, (
        "NEW-7 fix must use the discovered runner workspace path to anchor folder_path "
        "(e.g. /Workspace/Users/<user>/vibe_runner_models) instead of './../models'"
    )
    assert "/tmp/vibe_runner_models" in src, (
        "NEW-7 must include /tmp fallback so non-/Users/ deploys (or notebook-context unavailable) still work"
    )


def test_v074_runner_folder_path_discovery_fires_before_makedirs():
    src = _load_nb_source(RUNNER_NB)
    discovery_pos = src.find("[runner-folder-path-discovery FIRED]")
    assert discovery_pos > -1, "Discovery FIRED marker must exist"
    makedirs_pos = src.find("os.makedirs(folder_path", discovery_pos)
    assert makedirs_pos > discovery_pos, (
        "folder_path discovery must run before os.makedirs(folder_path) so the resolved "
        "path (not the './../models' default) is materialised"
    )


def test_v074_runner_folder_path_makedirs_is_wrapped_in_try():
    src = _load_nb_source(RUNNER_NB)
    pos = src.find("os.makedirs(folder_path, exist_ok=True)")
    assert pos > -1, "os.makedirs call must remain"
    window_before = src[max(0, pos - 200): pos]
    assert "try:" in window_before, (
        "os.makedirs(folder_path) MUST be wrapped in try/except so a permission failure "
        "on the discovered path falls back to /tmp instead of crashing the runner"
    )


def test_v074_fidelity_deterministic_attr_count_alias_present():
    src = _load_nb_source(AGENT_NB)
    assert "fidelity-deterministic-attr-count" in src, (
        "NEW-8 alias must appear in dbx_vibe_modelling_agent.ipynb (deterministic attr-count verifier)"
    )


def test_v074_fidelity_deterministic_attr_count_uses_attrs_by_product():
    """v0.9.6 update: the v0.7.4 regex on req.original_text (`between N and M attributes per product`)
    was DELETED per the LLM-only mandate. Attribute-count caps now come from the LLM-extracted
    structured fields `requirement.attribute_count_min/_max` (set by VIBE_MASTER_PROMPT) with a
    fallback to tier defaults in PROMPT_VARIABLES. The verifier still uses `attrs_by_product`,
    still FIRES the `[fidelity-deterministic-attr-count FIRED]` sentinel, but no longer re-parses
    prose with regex."""
    src = _load_nb_source(AGENT_NB)
    pos = src.find("[fidelity-deterministic-attr-count FIRED]")
    assert pos > -1
    block = src[max(0, pos - 4000): pos + 1500]
    assert "attrs_by_product" in block, (
        "Verifier must use the existing per-product attribute index; do NOT recompute"
    )
    assert "vibe-attr-cap-regex-removed" in block, (
        "v0.9.6 sentinel must mark the deletion of the v0.7.4 regex sweep"
    )
    assert "min_attributes_per_product" in block and "max_attributes_per_product" in block, (
        "v0.9.6 verifier must read structured min/max attribute caps from LLM-extracted requirement "
        "fields or tier defaults (no regex on req.original_text)"
    )


def test_v074_fidelity_deterministic_fk_density_alias_present():
    src = _load_nb_source(AGENT_NB)
    assert "fidelity-deterministic-fk-density" in src, (
        "NEW-9 alias must appear in dbx_vibe_modelling_agent.ipynb (deterministic FK-density verifier)"
    )


def test_v074_fidelity_deterministic_fk_density_counts_inbound_and_outbound():
    src = _load_nb_source(AGENT_NB)
    pos = src.find("[fidelity-deterministic-fk-density FIRED]")
    assert pos > -1
    block = src[max(0, pos - 5000): pos + 1500]
    assert "_v074_fk_inbound" in block and "_v074_fk_outbound" in block, (
        "FK density check must consider BOTH inbound and outbound FK relationships per product"
    )


def test_v074_fidelity_verifiers_run_before_fallthrough_partial():
    """The new verifiers MUST execute BEFORE the 'no specific pattern matched' fall-through,
    otherwise they're dead code."""
    src = _load_nb_source(AGENT_NB)
    attr_pos = src.find("[fidelity-deterministic-attr-count FIRED]")
    fk_pos = src.find("[fidelity-deterministic-fk-density FIRED]")
    fallthrough_pos = src.rfind("Deterministic verification: no specific pattern matched for this requirement")
    assert attr_pos < fallthrough_pos, "attr-count verifier must precede fall-through"
    assert fk_pos < fallthrough_pos, "fk-density verifier must precede fall-through"


def test_v074_vibe_tester_inner_workflow_error_capture_alias_present():
    src = _load_nb_source(TESTER_NB)
    assert "vibe-tester-inner-workflow-error-capture" in src, (
        "NEW-10 alias must appear in tests/vibe_tester.ipynb (inner workflow error capture)"
    )


def test_v074_vibe_tester_inner_workflow_capture_uses_workflow_run_type():
    src = _load_nb_source(TESTER_NB)
    pos = src.find("[vibe-tester-inner-workflow-error-capture FIRED]")
    assert pos > -1
    window = src[max(0, pos - 3000): pos + 800]
    assert "WORKFLOW_RUN" in window, (
        "Inner-workflow capture must enumerate jobs via run_type='WORKFLOW_RUN' "
        "(dbutils.notebook.run produces hidden workflow runs not in default list)"
    )
    assert "get_run_output" in window, (
        "Capture must call get_run_output() to retrieve the inner notebook's error_trace"
    )


def test_v074_vibe_tester_inner_workflow_capture_filters_by_runner_path():
    src = _load_nb_source(TESTER_NB)
    pos = src.find("[vibe-tester-inner-workflow-error-capture FIRED]")
    assert pos > -1
    window = src[max(0, pos - 3000): pos + 800]
    assert "runner_notebook" in window, (
        "Capture must filter workflow runs by notebook_path matching `runner_notebook` "
        "to avoid grabbing an unrelated failed workflow run"
    )


def test_v074_run_test_inner_workflow_error_capture_alias_present():
    src = _load_nb_source(TESTER_NB)
    assert "run-test-inner-workflow-error-capture" in src, (
        "NEW-12 alias must appear in tests/vibe_tester.ipynb — extends inner-workflow capture into run_test() helper"
    )


def test_v074_run_test_inner_workflow_capture_uses_workflow_run_type():
    src = _load_nb_source(TESTER_NB)
    pos = src.find("[run-test-inner-workflow-error-capture FIRED]")
    assert pos > -1, "FIRED marker for run-test-inner-workflow-error-capture must exist"
    window = src[max(0, pos - 3500): pos + 800]
    assert "WORKFLOW_RUN" in window, (
        "run_test() inner-workflow capture must enumerate run_type='WORKFLOW_RUN'"
    )
    assert "get_run_output" in window, (
        "run_test() inner-workflow capture must use get_run_output() for error_trace"
    )


def test_v074_mv_stale_catalog_rewrite_alias_present():
    src = _load_nb_source(AGENT_NB)
    assert "mv-stale-catalog-rewrite" in src, (
        "NEW-11 alias must appear in agent/dbx_vibe_modelling_agent.ipynb (MV stale catalog rewrite guard)"
    )


def test_v074_mv_stale_catalog_rewrite_runs_before_execute():
    """The rewrite guard must execute BEFORE execute_metric_views_in_parallel_no_halt.
    Otherwise stale catalog refs (e.g., MVM_v2 inheriting ecomm_ecm) reach the executor and fail."""
    src = _load_nb_source(AGENT_NB)
    fired_pos = src.find("[mv-stale-catalog-rewrite FIRED]")
    assert fired_pos > -1
    exec_pos = src.find("execute_metric_views_in_parallel_no_halt(", fired_pos)
    assert exec_pos > fired_pos, (
        "mv-stale-catalog-rewrite must rewrite stmts BEFORE execute_metric_views_in_parallel_no_halt is invoked"
    )


def test_v074_mv_stale_catalog_rewrite_excludes_protected_catalogs():
    src = _load_nb_source(AGENT_NB)
    pos = src.find("[mv-stale-catalog-rewrite FIRED]")
    assert pos > -1
    window = src[max(0, pos - 4000): pos + 500]
    for protected in ("system", "samples", "hive_metastore", "__databricks_internal"):
        assert protected in window, (
            f"Catalog '{protected}' must be in the protected-list and never rewritten"
        )


def test_v074_mv_stale_catalog_rewrite_respects_existing_catalogs():
    src = _load_nb_source(AGENT_NB)
    pos = src.find("[mv-stale-catalog-rewrite FIRED]")
    assert pos > -1
    window = src[max(0, pos - 4000): pos + 500]
    assert "SHOW CATALOGS" in window, (
        "Rewrite guard must enumerate live catalogs (SHOW CATALOGS) so it only rewrites STALE refs, not legit cross-catalog refs to existing catalogs"
    )


def test_v074_vibe_attr_cap_override_alias_present():
    """v0.9.6 update: the original `vibe-attr-cap-override` alias was tied to a regex sweep over
    raw `model_vibes`/`business_description` text, which violated the LLM-only mandate. The new
    sentinel `vibe-attr-cap-regex-removed` marks the deletion. Attribute-count caps now come
    from LLM-extracted `requirement.attribute_count_min/_max` (or tier defaults), not regex."""
    src = _load_nb_source(AGENT_NB)
    assert "vibe-attr-cap-regex-removed" in src, (
        "v0.9.6 sentinel `vibe-attr-cap-regex-removed` must appear in agent notebook "
        "(replaces the v0.7.4 `vibe-attr-cap-override` regex sweep)"
    )


def test_v074_vibe_attr_cap_override_modifies_prompt_variables():
    """v0.9.6 update: attribute-count caps still flow through `PROMPT_VARIABLES.min/max_attributes_per_product`,
    but they are now set from tier defaults (already in PROMPT_VARIABLES) plus LLM-extracted structured
    requirement fields — NOT from a regex sweep over raw vibe text."""
    src = _load_nb_source(AGENT_NB)
    pos = src.find("[vibe-attr-cap-regex-removed FIRED]")
    assert pos > -1, "v0.9.6 deletion sentinel must FIRE in the orchestrator-init site"
    window = src[max(0, pos - 4000): pos + 500]
    assert "PROMPT_VARIABLES" in window or "min_attributes_per_product" in src, (
        "Tier-default min/max_attributes_per_product must still be carried in PROMPT_VARIABLES so the "
        "generation prompt reflects the per-tier cap (v0.9.6 keeps tier defaults; deletes regex layer)"
    )


def test_v074_vibe_attr_cap_override_after_authority_init():
    """v0.9.6 update: the deletion-sentinel must run AFTER `apply_vibe_authority_overrides` so the
    LLM-only path composes cleanly with the user-king authority chain (§3c). No regex layer remains
    between the authority overrides and the prompt-variables consumption."""
    src = _load_nb_source(AGENT_NB)
    auth_pos = src.find("apply_vibe_authority_overrides(config, widgets_values")
    # The first occurrence is in the version header; we need the FIRST FIRING site AFTER auth_pos.
    cap_pos = src.find("[vibe-attr-cap-regex-removed FIRED]", auth_pos)
    assert auth_pos > -1, "apply_vibe_authority_overrides call site must exist"
    assert cap_pos > auth_pos, (
        "v0.9.6 [vibe-attr-cap-regex-removed FIRED] (firing site, not version header) must run AFTER "
        "apply_vibe_authority_overrides() to compose with §3c authority chain (CLAUDE.md §3d)"
    )


def test_v074_mv_date_interval_autofix_alias_present():
    src = _load_nb_source(AGENT_NB)
    assert "mv-date-interval-autofix" in src, (
        "NEW-14 alias must appear in agent/dbx_vibe_modelling_agent.ipynb (date-interval cast autofix)"
    )


def test_v074_mv_date_interval_autofix_emits_datediff():
    src = _load_nb_source(AGENT_NB)
    pos = src.find("[mv-date-interval-autofix FIRED]")
    assert pos > -1
    window = src[max(0, pos - 3000): pos + 500]
    assert "DATEDIFF" in window, (
        "Date-interval autofix must rewrite (date - date) expressions to DATEDIFF(date1, date2) "
        "to avoid INTERVAL DAY → DOUBLE cast failures"
    )


def test_v074_mv_date_interval_autofix_in_sanitizer():
    """The autofix must live INSIDE _sanitize_metric_measure_expr so EVERY MV measure
    expression is normalized — not in a one-off helper that isn't invoked everywhere."""
    src = _load_nb_source(AGENT_NB)
    sani_pos = src.find("def _sanitize_metric_measure_expr(")
    fired_pos = src.find("[mv-date-interval-autofix FIRED]")
    assert sani_pos > -1
    assert fired_pos > sani_pos, (
        "mv-date-interval-autofix must be inside the _sanitize_metric_measure_expr function "
        "(invoked by every measure-expression sanitization path)"
    )
    block = src[sani_pos: sani_pos + 5000]
    assert "[mv-date-interval-autofix FIRED]" in block, (
        "FIRED marker must be inside the sanitizer function body"
    )
