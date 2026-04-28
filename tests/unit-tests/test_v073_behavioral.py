"""v0.7.3 behavioral tests.

NEW-1 (alias=session-end-status-honest):
    `_finalize_common` previously hard-coded `status="stage_ended"` for the
    "Vibe Session/Session Ended" sentinel regardless of whether the caller was
    `finalize_pipeline` (success) or `finalize_pipeline_error` (failure). The
    App reads the session-end status to colour the run pill. Hard-coding
    `stage_ended` lied about the outcome on the error path. The fix:
        - `_finalize_common` now takes `end_status` (default `"stage_ended"`).
        - `finalize_pipeline` keeps the default → success pill stays green.
        - `finalize_pipeline_error` passes `end_status="stage_failed"` → red.
        - The session-bookend immediate-flush logic now also recognises
          `"stage_failed"` so the App sees the failure pill on the very next
          poll, instead of waiting for the next 10-second interval flush.
"""

import json
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_notebook_source():
    nb = json.loads(NOTEBOOK_PATH.read_text())
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") == "code":
            parts.append("".join(cell.get("source", [])))
    return "\n\n".join(parts)


def test_v073_agent_version_is_073():
    src = _load_notebook_source()
    assert '__AGENT_VERSION__ = "0.7.3"' in src, (
        "v0.7.3 deploy must bump __AGENT_VERSION__ to '0.7.3' (CLAUDE.md §3a single-digit semver)"
    )


def test_v073_finalize_common_signature_takes_end_status_with_default():
    src = _load_notebook_source()
    assert (
        'def _finalize_common(self, close_message, end_message, end_progress, '
        'result_json, log_label, close_status="stage_failed", end_status="stage_ended"):'
        in src
    ), (
        "_finalize_common must accept `end_status` keyword (default 'stage_ended' "
        "for backwards compatibility with finalize_pipeline)."
    )


def test_v073_session_ended_emit_uses_end_status_param_not_hardcoded_stage_ended():
    src = _load_notebook_source()
    # The Session Ended emit block must reference end_status (the param) instead
    # of the literal "stage_ended". Anchor on the surrounding lines so the test
    # is unique — Vibe Session bookend is the only emit_step with these neighbours.
    snippet = (
        '            stage_name="Vibe Session",\n'
        '            step_name="Session Ended",\n'
        '            progress_increment=end_progress,\n'
        '            message=end_message,\n'
        '            status=end_status,'
    )
    assert snippet in src, (
        "Vibe Session/Session Ended emit must use status=end_status (the parameter), "
        "not the hard-coded literal 'stage_ended'. This was the App-misreporting bug."
    )


def test_v073_finalize_pipeline_keeps_stage_ended_default_via_omission():
    src = _load_notebook_source()
    # finalize_pipeline (the success path) must NOT pass end_status — it should
    # rely on the default "stage_ended" so success runs still show the green pill.
    success_block_start = src.find("def finalize_pipeline(self, message=")
    success_block_end = src.find("def finalize_pipeline_error", success_block_start)
    assert 0 < success_block_start < success_block_end, "finalize_pipeline block not found"
    success_block = src[success_block_start:success_block_end]
    assert "end_status=" not in success_block, (
        "finalize_pipeline (success path) must NOT pass end_status — it should rely on "
        "the default 'stage_ended' so green pill behaviour is preserved."
    )


def test_v073_finalize_pipeline_error_passes_end_status_stage_failed():
    src = _load_notebook_source()
    err_block_start = src.find("def finalize_pipeline_error")
    err_block_end = src.find("def _safe_notebook_exit", err_block_start)
    assert 0 < err_block_start < err_block_end, "finalize_pipeline_error block not found"
    err_block = src[err_block_start:err_block_end]
    assert 'end_status="stage_failed"' in err_block, (
        "finalize_pipeline_error MUST pass end_status='stage_failed' so the App's "
        "run-status pill turns red on the error path. This is the actual fix the "
        "downstream Claude session reported; without it the App lies about session outcome."
    )


def test_v073_alias_session_end_status_honest_present_at_call_site():
    src = _load_notebook_source()
    assert "alias=session-end-status-honest" in src, (
        "Fix sentinel `alias=session-end-status-honest` must appear in the deployed "
        "notebook so post-deploy grep can prove the fix shipped (CLAUDE.md §10.7 step 6)."
    )


def test_v073_alias_appears_at_least_twice_call_site_and_bookend():
    src = _load_notebook_source()
    occurrences = src.count("alias=session-end-status-honest")
    assert occurrences >= 2, (
        f"Expected the v0.7.3 alias to appear at BOTH the call site (finalize_pipeline_error) "
        f"AND the bookend logic (so the failed-session bookend triggers immediate flush). "
        f"Only {occurrences} occurrence(s) found."
    )


def test_v073_session_bookend_immediate_flush_includes_stage_failed():
    src = _load_notebook_source()
    # The bookend logic must recognise stage_failed for "Vibe Session" so the
    # immediate flush path runs on error termination — otherwise the App waits
    # up to FLUSH_INTERVAL_SECONDS (10s) before seeing the failure.
    expected = (
        '_is_session_bookend = (_sn == "Vibe Session" and status in '
        '("stage_started", "stage_ended", "stage_failed"))'
    )
    assert expected in src, (
        "Bookend immediate-flush check must include 'stage_failed' for Vibe Session "
        "so the failed-session emit is flushed within the same emit_step call, not "
        "deferred to the next 10s background flush window."
    )


def test_v073_stage_failed_in_valid_statuses_set():
    src = _load_notebook_source()
    # Defensive: confirm "stage_failed" is in _VALID_STATUSES so the new
    # session-end emit doesn't get rejected by the validator.
    assert "stage_failed" in src and "_VALID_STATUSES" in src
    valid_block_start = src.find("_VALID_STATUSES")
    valid_block = src[valid_block_start:valid_block_start + 400]
    assert "stage_failed" in valid_block, (
        "stage_failed must be a member of _VALID_STATUSES so emit_step('Vibe Session', "
        "'Session Ended', status='stage_failed') is not silently dropped."
    )


def test_v073_open_step_pop_logic_includes_stage_failed():
    src = _load_notebook_source()
    # The _open_step_ids pop logic should remove the step on success/failed/ended.
    # This pre-existed the v0.7.3 fix — check it as a regression sentinel.
    expected = 'elif status in ("stage_succeeded", "stage_failed", "stage_ended"):'
    assert expected in src, (
        "Pre-existing _open_step_ids pop on terminal statuses must still include "
        "stage_failed. If this regressed, finalize_pipeline_error would leak open "
        "step ids across sessions."
    )
