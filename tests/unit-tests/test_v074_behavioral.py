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


def test_v074_agent_version_is_074():
    src = _load_nb_source(AGENT_NB)
    assert '__AGENT_VERSION__ = "0.7.4"' in src, (
        "v0.7.4 deploy must bump __AGENT_VERSION__ to '0.7.4' (CLAUDE.md §3a single-digit semver)"
    )


def test_v074_agent_version_is_first_non_comment_line_of_first_code_cell():
    nb = json.loads(AGENT_NB.read_text())
    first_code_cell = next((c for c in nb["cells"] if c.get("cell_type") == "code"), None)
    assert first_code_cell is not None, "Notebook must have at least one code cell"
    src_lines = "".join(first_code_cell.get("source", [])).splitlines()
    code_lines = [ln for ln in src_lines if ln.strip() and not ln.lstrip().startswith("#")]
    assert code_lines, "First code cell must contain at least one code line"
    assert '__AGENT_VERSION__ = "0.7.4"' in code_lines[0], (
        "First non-comment code line of first code cell must declare __AGENT_VERSION__ = \"0.7.4\" (CLAUDE.md §3a-bis)"
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
    assert "_v74_fk_count" in window, (
        "FK-densest fallback must score products by FK in/out degree"
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
    assert "Current version: **v0.7.4**" in rd, (
        "readme `Current version:` line must match __AGENT_VERSION__ (CLAUDE.md §3a-bis)"
    )


def test_v074_readme_version_history_row_exists():
    rd = (REPO_ROOT / "readme.md").read_text()
    assert "| **v0.7.4** |" in rd, "readme version-history must include a v0.7.4 row"
    # Each NEW-* alias must be documented.
    for alias in (
        "runner-single-biz-fallback",
        "shrink-fk-densest-fallback",
        "shrink-cascade-iterate",
        "ensemble-singleshot-fallback",
        "install-ddl-retry-skip",
        "runner-failure-manifest",
    ):
        assert alias in rd, f"v0.7.4 readme entry must mention alias=`{alias}`"
