"""v0.7.4 orchestrator-resilience bundle — three fixes ship together.

Each fix has its own alias for deploy-time grep verification:

NEW-15  alias=sync-watchdog          (out-of-band per-industry repo-sync daemon)
NEW-16  alias=per-industry-sync      (orchestrate_sectors per-industry sync hook)
NEW-17  alias=oauth-reauth           (CLI auth-error retry with explicit token refresh)
NEW-18  alias=sector-timeout-36h     (raise SECTOR_TIMEOUT_S from 14h to 36h)

Root causes addressed:
  • Pre-v0.7.4 sync_to_repo only fired at the END of each sector. When sector_runner
    timed out (AWS Retail 8.5h, Azure Oil Gas 17h burned the 14h budget; remaining
    industries forced into one-by-one retries), green industries sat on the workspace
    volume for HOURS waiting for the auto-sync. Plus, pre-v0.7.1 orchestrators
    (e.g. GCP PID 59630 from May 1) had NO sync hook at all.
  • Pre-v0.7.4 db() helper had no auth-error retry — when CLI's cached OAuth bearer
    expired and the auto-refresh path encountered a transient IDP error, the
    orchestrator's poll loop entered a 1-2h stall (saw on AWS+Azure May 4 morning).
  • Pre-v0.7.4 SECTOR_TIMEOUT_S = 14h was too low for big-industry sectors
    (retail+CPG 7 industries × 8h = 56h theoretical worst case; 14h killed the
    sector_runner before half the industries even started).
"""

import importlib
import os
import subprocess
import sys
from pathlib import Path
from unittest import mock

REPO_ROOT = Path(__file__).resolve().parents[2]
ORCH_FILE = REPO_ROOT / "runner" / "orchestrate_sectors.py"
WATCHDOG_FILE = REPO_ROOT / "runner" / "sync_watchdog.py"


# -------------------- NEW-15 sync-watchdog --------------------


def test_v074_sync_watchdog_module_imports():
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        m = importlib.import_module("sync_watchdog")
    finally:
        sys.path.pop(0)
    assert hasattr(m, "main"), "sync_watchdog must expose main()"
    assert hasattr(m, "poll_one_cloud"), "sync_watchdog must expose poll_one_cloud()"
    assert hasattr(m, "push_industry"), "sync_watchdog must expose push_industry()"
    assert hasattr(m, "acquire_repo_lock") and hasattr(m, "release_repo_lock"), (
        "sync_watchdog must expose lock helpers to serialise vs orchestrator's repo_sync hook"
    )


def test_v074_sync_watchdog_alias_present():
    src = WATCHDOG_FILE.read_text()
    assert "sync-watchdog" in src, "NEW-15 alias must appear in runner/sync_watchdog.py"
    assert "sync-watchdog FIRED" in src, "NEW-15 must emit a [sync-watchdog FIRED] log line on push"


def test_v074_sync_watchdog_polls_all_three_clouds():
    src = WATCHDOG_FILE.read_text()
    for prof in ("<profile>", "<profile>", "fe-vm-feip"):
        assert prof in src, f"watchdog CLOUDS must include profile '{prof}'"


def test_v074_sync_watchdog_only_pushes_terminated_success():
    src = WATCHDOG_FILE.read_text()
    assert 'life_cycle_state' in src and '"TERMINATED"' in src, (
        "watchdog must guard on life_cycle_state == TERMINATED"
    )
    assert '"SUCCESS"' in src, "watchdog must guard on result_state == SUCCESS"


def test_v074_sync_watchdog_skips_already_pushed_industries():
    src = WATCHDOG_FILE.read_text()
    assert "industry_in_repo" in src, "watchdog must check repo presence before pushing"
    assert 'pushed_set' in src, "watchdog must track pushed industries in state"


def test_v074_sync_watchdog_uses_repo_lock_to_avoid_clash():
    """The watchdog runs in parallel with the orchestrator's own repo_sync hook.
    Without locking, two `git pull && git push` operations can clash and one will
    error with `non-fast-forward`. Lock prevents that."""
    src = WATCHDOG_FILE.read_text()
    assert "acquire_repo_lock" in src and "release_repo_lock" in src, (
        "watchdog must call acquire_repo_lock + release_repo_lock around push_industry"
    )
    push_pos = src.find("def push_industry(")
    push_body = src[push_pos: push_pos + 2000]
    assert "acquire_repo_lock" in push_body, (
        "push_industry must acquire the lock before invoking sync_to_repo"
    )
    assert "release_repo_lock" in push_body, (
        "push_industry must release the lock after invoking sync_to_repo"
    )


def test_v074_sync_watchdog_lock_reclaim_on_stale():
    """If a previous orchestrator process crashed mid-push, its lock file lingers.
    Watchdog must detect stale locks (>15 min) and reclaim, otherwise the daemon
    silently stops syncing forever."""
    src = WATCHDOG_FILE.read_text()
    assert "reclaimed stale lock" in src or "stale_age" in src or "age > 900" in src, (
        "watchdog must reclaim stale lock files (TTL ~15 min)"
    )


def test_v074_sync_watchdog_push_industry_uses_subprocess_timeout():
    """sync_to_repo can hang on slow workspace export (Azure was sluggish on May 3).
    Watchdog must time out the subprocess so one stuck export doesn't freeze the daemon."""
    src = WATCHDOG_FILE.read_text()
    push_pos = src.find("def push_industry(")
    push_body = src[push_pos: push_pos + 2000]
    assert "timeout=" in push_body, (
        "push_industry must pass an explicit subprocess timeout"
    )


def test_v074_sync_watchdog_logs_to_dedicated_file():
    src = WATCHDOG_FILE.read_text()
    assert "sync_watchdog.log" in src, "watchdog must log to ~/claude/vibe-agent/sync_watchdog.log"


# -------------------- NEW-16 per-industry-sync --------------------


def test_v074_per_industry_sync_alias_present():
    src = ORCH_FILE.read_text()
    assert "per-industry-sync" in src, "NEW-16 alias must appear in orchestrate_sectors.py"
    assert "per-industry-sync FIRED" in src, "must emit FIRED log line"


def test_v074_per_industry_sync_helper_exists():
    src = ORCH_FILE.read_text()
    assert "def _sync_one_industry_now(" in src, (
        "per-industry-sync must define helper `_sync_one_industry_now(...)`"
    )


def test_v074_per_industry_sync_called_in_post_run_loop():
    """Helper must be invoked inside the post-run scan when an industry transitions
    GREEN — otherwise it's dead code that doesn't actually publish anything."""
    src = ORCH_FILE.read_text()
    green_marker = src.find('"status": "green"')
    assert green_marker > -1
    window = src[green_marker: green_marker + 800]
    assert "_sync_one_industry_now" in window, (
        "_sync_one_industry_now must be invoked inside the GREEN-status branch"
    )


def test_v074_per_industry_sync_called_after_retry_recovery():
    """And also after a retry RECOVERED an industry — otherwise retried industries
    sit on the volume for hours waiting for the sector-end hook."""
    src = ORCH_FILE.read_text()
    recovered_marker = src.find("RECOVERED")
    assert recovered_marker > -1
    window = src[recovered_marker: recovered_marker + 600]
    assert "_sync_one_industry_now" in window, (
        "_sync_one_industry_now must be invoked inside the green_after_retry branch"
    )


def test_v074_per_industry_sync_passes_single_industry_in_allowlist():
    """The helper must allowlist EXACTLY the just-completed industry — not the
    full sector list, otherwise it duplicates the sector-end hook's work."""
    src = ORCH_FILE.read_text()
    helper_pos = src.find("def _sync_one_industry_now(")
    helper_body = src[helper_pos: helper_pos + 2500]
    assert "industry_allowlist=[industry_name]" in helper_body, (
        "Helper must call sync_completed_industries with a single-element allowlist"
    )


def test_v074_per_industry_sync_records_state_per_industry():
    src = ORCH_FILE.read_text()
    helper_pos = src.find("def _sync_one_industry_now(")
    helper_body = src[helper_pos: helper_pos + 2500]
    assert "repo_sync_per_industry" in helper_body, (
        "Helper must record per-industry sync results in state['repo_sync_per_industry'][industry]"
    )


def test_v074_per_industry_sync_handles_import_failure_gracefully():
    """If sync_to_repo can't be imported (e.g. relative-path issue on a fresh
    deploy), the orchestrator must NOT crash — log a skip and move on."""
    src = ORCH_FILE.read_text()
    helper_pos = src.find("def _sync_one_industry_now(")
    helper_body = src[helper_pos: helper_pos + 2500]
    assert "import failed" in helper_body or "import sync_to_repo" in helper_body, (
        "Helper must wrap import in try/except and skip-with-log on failure"
    )


# -------------------- NEW-17 oauth-reauth --------------------


def test_v074_oauth_reauth_alias_present():
    src = ORCH_FILE.read_text()
    assert "oauth-reauth" in src, "NEW-17 alias must appear in orchestrate_sectors.py"


def test_v074_oauth_reauth_force_refresh_helper_exists():
    src = ORCH_FILE.read_text()
    assert "def _force_token_refresh(" in src, (
        "oauth-reauth must define `_force_token_refresh(profile)` helper"
    )


def test_v074_oauth_reauth_force_refresh_calls_databricks_auth_token():
    src = ORCH_FILE.read_text()
    pos = src.find("def _force_token_refresh(")
    body = src[pos: pos + 800]
    assert '"databricks", "auth", "token"' in body, (
        "_force_token_refresh must run `databricks auth token --profile X` to trigger refresh-token grant"
    )


def test_v074_oauth_reauth_db_retries_on_auth_signature():
    """db() must detect auth-error keywords in stderr and retry exactly once after
    forcing a token refresh. Without this, the orchestrator's outer poll loop
    keeps emitting WARN poll error every 2 min for hours."""
    src = ORCH_FILE.read_text()
    db_pos = src.find("def db(args, profile, capture=True, timeout=300):")
    assert db_pos > -1
    db_body = src[db_pos: db_pos + 2000]
    assert "_AUTH_ERROR_HINTS" in db_body, "db() must consult _AUTH_ERROR_HINTS"
    assert "_force_token_refresh" in db_body, (
        "db() must call _force_token_refresh on auth-error detection"
    )


def test_v074_oauth_reauth_hints_cover_common_error_strings():
    src = ORCH_FILE.read_text()
    pos = src.find("_AUTH_ERROR_HINTS")
    body = src[pos: pos + 600]
    for hint in ("oauth", "401", "unauthorized", "expired", "invalid_grant"):
        assert hint in body.lower(), f"_AUTH_ERROR_HINTS must include '{hint}'"


def test_v074_oauth_reauth_only_retries_once():
    """A failing-auth retry loop without a counter would burn CPU forever if the
    refresh-token itself is dead. Must retry exactly ONCE then propagate."""
    src = ORCH_FILE.read_text()
    db_pos = src.find("def db(args, profile, capture=True, timeout=300):")
    db_body = src[db_pos: db_pos + 2000]
    subprocess_calls = db_body.count("subprocess.run(cmd")
    assert subprocess_calls == 2, (
        f"db() must invoke subprocess.run(cmd, ...) exactly TWICE (initial + one auth retry); "
        f"saw {subprocess_calls} calls — risk of infinite retry loop"
    )


def test_v074_oauth_reauth_force_refresh_is_safe_on_failure():
    """_force_token_refresh must NOT raise if the auth command fails — otherwise
    a transient refresh-token failure crashes the entire orchestrator."""
    src = ORCH_FILE.read_text()
    pos = src.find("def _force_token_refresh(")
    body = src[pos: pos + 800]
    assert "try:" in body and "except" in body, (
        "_force_token_refresh must wrap the auth command in try/except to swallow refresh failures"
    )


# -------------------- NEW-18 sector-timeout-36h --------------------


def test_v074_sector_timeout_raised_to_36h():
    """v0.7.5 (2026-05-18): user directive "15h for all jobs in all workflows" supersedes
    the v0.7.4 36h cap. The sector-runner is also subject to the 15h ceiling per §3c
    USER-VIBE AUTHORITY. WARNING: multi-industry sector runs (e.g. retail+CPG 7 industries)
    may exceed 15h and get killed; user accepted this risk explicitly."""
    src = ORCH_FILE.read_text()
    assert "SECTOR_TIMEOUT_S = 15 * 3600" in src, (
        "SECTOR_TIMEOUT_S MUST be 15 * 3600 (54000s) per user directive 2026-05-18 "
        '"set timeout is always 15hrs for all jobs in all workflows"'
    )
    assert "SECTOR_TIMEOUT_S = 36 * 3600" not in src, (
        "Old 36h timeout constant must be removed (user directive 2026-05-18 caps all jobs at 15h)"
    )
    assert "SECTOR_TIMEOUT_S = 14 * 3600" not in src, (
        "Old 14h timeout constant must be removed"
    )


# -------------------- Behavioural smoke (mocked subprocess) --------------------


def test_v074_db_retries_after_oauth_token_expired_stderr():
    """Live behavioral test: db() with mocked subprocess returns success on retry
    after seeing an auth-error stderr."""
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        orch = importlib.import_module("orchestrate_sectors")
    finally:
        sys.path.pop(0)
    fail = subprocess.CompletedProcess(args=[], returncode=1, stdout="",
                                       stderr="OAuth token has expired, refresh failed")
    success = subprocess.CompletedProcess(args=[], returncode=0, stdout='{"ok":true}', stderr="")
    refresh = subprocess.CompletedProcess(args=[], returncode=0, stdout="newtoken", stderr="")
    call_log = []

    def fake_run(cmd, capture_output=True, text=True, timeout=None, check=False):
        call_log.append(list(cmd))
        if "auth" in cmd and "token" in cmd:
            return refresh
        if len(call_log) == 1:
            return fail
        return success

    with mock.patch.object(orch.subprocess, "run", side_effect=fake_run):
        out = orch.db(["jobs", "list"], "<profile>")
    assert out == '{"ok":true}', "db() must return success after one auth-error retry"
    auth_token_calls = [c for c in call_log if "auth" in c and "token" in c]
    assert len(auth_token_calls) == 1, "Exactly one `databricks auth token` refresh call expected"


def test_v074_db_does_not_retry_on_non_auth_error():
    """A regular 404 / 500 error must NOT trigger token refresh — that would mask
    real bugs."""
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        orch = importlib.import_module("orchestrate_sectors")
    finally:
        sys.path.pop(0)
    fail = subprocess.CompletedProcess(args=[], returncode=1, stdout="",
                                       stderr="resource not found: job_id 999")
    call_log = []

    def fake_run(cmd, capture_output=True, text=True, timeout=None, check=False):
        call_log.append(list(cmd))
        return fail

    with mock.patch.object(orch.subprocess, "run", side_effect=fake_run):
        try:
            orch.db(["jobs", "get", "999"], "<profile>")
            raise AssertionError("expected RuntimeError")
        except RuntimeError as e:
            assert "resource not found" in str(e)
    auth_token_calls = [c for c in call_log if "auth" in c and "token" in c]
    assert auth_token_calls == [], "Non-auth errors must NOT trigger _force_token_refresh"
    assert len(call_log) == 1, "Non-auth errors must NOT retry — exactly one CLI invocation"


def test_v074_watchdog_lock_acquire_release_cycle():
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        wd = importlib.import_module("sync_watchdog")
    finally:
        sys.path.pop(0)
    lock_path = wd.LOCK_FILE
    if os.path.isfile(lock_path):
        os.remove(lock_path)
    assert wd.acquire_repo_lock(timeout_s=2), "should acquire lock when free"
    assert os.path.isfile(lock_path), "lock file must be created"
    wd.release_repo_lock()
    assert not os.path.isfile(lock_path), "lock file must be removed on release"


def test_v074_watchdog_lock_blocks_concurrent_acquire():
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        wd = importlib.import_module("sync_watchdog")
    finally:
        sys.path.pop(0)
    if os.path.isfile(wd.LOCK_FILE):
        os.remove(wd.LOCK_FILE)
    assert wd.acquire_repo_lock(timeout_s=2)
    try:
        assert not wd.acquire_repo_lock(timeout_s=2), (
            "Second acquire must time out while first lock is held"
        )
    finally:
        wd.release_repo_lock()


def test_v074_watchdog_quality_gate_alias_present():
    src = WATCHDOG_FILE.read_text()
    assert "sync-watchdog-quality-gate" in src, (
        "quality-gate alias must appear in sync_watchdog.py — added after first cycle "
        "pushed 3 empty-shell models from Azure leftover test runs"
    )


def test_v074_watchdog_quality_gate_helper_exists():
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        m = importlib.import_module("sync_watchdog")
    finally:
        sys.path.pop(0)
    assert hasattr(m, "passes_quality_gate"), "watchdog must expose passes_quality_gate(profile, industry, cloud)"
    assert hasattr(m, "_model_counts"), "watchdog must expose _model_counts(model_obj) helper"


def test_v074_watchdog_quality_gate_thresholds_are_strict():
    """Empty shell models produced <10 files; real models produce 50-200.
    Manifest-based threshold must require ≥30 files copied + ≥20 ECM + ≥15 MVM."""
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        m = importlib.import_module("sync_watchdog")
    finally:
        sys.path.pop(0)
    assert m.QUALITY_GATE_MIN_FILES_COPIED >= 30
    assert m.QUALITY_GATE_MIN_FILES_ECM >= 20
    assert m.QUALITY_GATE_MIN_FILES_MVM >= 15


def test_v074_watchdog_uses_global_volume_manifest():
    """Workspace export hits 10MB limit on real models (healthcare = 14MB).
    Switched to volume _manifest.json which is always small and authoritative."""
    src = WATCHDOG_FILE.read_text()
    assert "_read_volume_manifest" in src, "watchdog must define _read_volume_manifest helper"
    assert "/Volumes/_root/default/root_vol" in src, (
        "watchdog must reference the global volume root path"
    )
    assert "_manifest.json" in src, "watchdog must read the orchestrator's _manifest.json"


def test_v074_watchdog_model_counts_handles_nested_and_flat():
    """Helper still useful for ad-hoc inspection even though gate uses manifest."""
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        m = importlib.import_module("sync_watchdog")
    finally:
        sys.path.pop(0)
    nested = {"agent_version": "0.7.1", "model": {
        "domains": [
            {"name": "d1", "products": [
                {"name": "p1", "attributes": [{"name": "a1"}, {"name": "a2"}]},
                {"name": "p2", "attributes": [{"name": "a1"}]},
            ]},
        ],
        "metric_views": [{"name": "mv1"}],
    }}
    nd, np_, na, nmv = m._model_counts(nested)
    assert (nd, np_, na, nmv) == (1, 2, 3, 1)
    flat = {"domains": [{"name": "d1", "data_products": [{"name": "p1", "attributes": []}]}]}
    nd, np_, na, nmv = m._model_counts(flat)
    assert (nd, np_, na, nmv) == (1, 1, 0, 0)
    assert m._model_counts(None) == (0, 0, 0, 0)
    assert m._model_counts({"domains": []}) == (0, 0, 0, 0)


def _make_fake_manifest_runner(manifest_dict):
    """Helper: returns a subprocess.run replacement that writes manifest_dict
    to whatever local file the CLI was asked to copy to, and returns rc=0."""
    import json as _json
    fake = subprocess.CompletedProcess(args=[], returncode=0, stdout="", stderr="")

    def fake_run(cmd, capture_output=True, text=True, timeout=None):
        if "fs" in cmd and "cp" in cmd and len(cmd) >= 5:
            local_idx = cmd.index("cp") + 2
            local = cmd[local_idx]
            _json.dump(manifest_dict, open(local, "w"))
        return fake

    return fake_run


def test_v074_watchdog_quality_gate_rejects_empty_shells_via_manifest():
    """Empty shell run produces a manifest with files_copied <30 (or no manifest at all).
    Must REJECT."""
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        m = importlib.import_module("sync_watchdog")
    finally:
        sys.path.pop(0)
    empty_manifest = {
        "alias": "global-collection-volume-manifest",
        "business_name": "Semiconductors",
        "scopes": {"ecm_v1": {"status": "ok", "files": 5}, "mvm_v1": {"status": "ok", "files": 3}},
        "files_copied": 8,
        "run_metadata": {"all_tasks_succeeded": True, "warning_count": 0},
    }
    captured = []
    with mock.patch.object(m.subprocess, "run", side_effect=_make_fake_manifest_runner(empty_manifest)):
        result = m.passes_quality_gate("fe-vm-feip", "semiconductors", "AZURE", log_fn=captured.append)
    assert result is False, "Manifest with files_copied=8 must FAIL"
    assert any("REJECT" in c for c in captured), "must log REJECT"


def test_v074_watchdog_quality_gate_rejects_when_tasks_failed():
    """all_tasks_succeeded=False must fail even if files_copied is high enough
    (e.g. install crashed but partial schema dump succeeded)."""
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        m = importlib.import_module("sync_watchdog")
    finally:
        sys.path.pop(0)
    partial_failure = {
        "scopes": {"ecm_v1": {"status": "ok", "files": 100}, "mvm_v1": {"status": "ok", "files": 80}},
        "files_copied": 200,
        "run_metadata": {"all_tasks_succeeded": False, "failed_parts": ["mvm_install"]},
    }
    captured = []
    with mock.patch.object(m.subprocess, "run", side_effect=_make_fake_manifest_runner(partial_failure)):
        result = m.passes_quality_gate("<profile>", "test_industry", "GCP", log_fn=captured.append)
    assert result is False, "all_tasks_succeeded=False must REJECT regardless of file count"
    assert any("all_tasks_succeeded=False" in c for c in captured), "must cite the failure reason"


def test_v074_watchdog_quality_gate_passes_real_manifest():
    """Healthcare-class manifest (211 files copied, ecm=59, mvm=47) must PASS."""
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        m = importlib.import_module("sync_watchdog")
    finally:
        sys.path.pop(0)
    real_manifest = {
        "alias": "global-collection-volume-manifest",
        "business_name": "Healthcare",
        "scopes": {"ecm_v1": {"status": "ok", "files": 59}, "mvm_v1": {"status": "ok", "files": 47}},
        "files_copied": 211,
        "run_metadata": {"all_tasks_succeeded": True, "warning_count": 0, "failed_parts": []},
    }
    captured = []
    with mock.patch.object(m.subprocess, "run", side_effect=_make_fake_manifest_runner(real_manifest)):
        result = m.passes_quality_gate("<profile>", "healthcare", "GCP", log_fn=captured.append)
    assert result is True, "Healthcare-class manifest must PASS"
    assert any("PASS" in c for c in captured), "must log PASS"


def test_v074_watchdog_quality_gate_rejects_missing_manifest():
    """If no manifest exists on the volume, run is incomplete — REJECT."""
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        m = importlib.import_module("sync_watchdog")
    finally:
        sys.path.pop(0)
    fail = subprocess.CompletedProcess(args=[], returncode=1, stdout="",
                                       stderr="dbfs file not found")

    def fake_run(cmd, capture_output=True, text=True, timeout=None):
        return fail

    captured = []
    with mock.patch.object(m.subprocess, "run", side_effect=fake_run):
        result = m.passes_quality_gate("<profile>", "no_such_industry", "GCP", log_fn=captured.append)
    assert result is False, "Missing manifest must REJECT"
    assert any("no _manifest.json" in c for c in captured), "must cite missing manifest"


def test_v074_watchdog_quality_gate_called_before_push():
    """Wire-up check: poll_one_cloud must call passes_quality_gate before push_industry."""
    src = WATCHDOG_FILE.read_text()
    poll_pos = src.find("def poll_one_cloud(")
    poll_body = src[poll_pos: poll_pos + 3000]
    qg_pos = poll_body.find("passes_quality_gate(")
    push_pos = poll_body.find("push_industry(")
    assert qg_pos > -1, "poll_one_cloud must call passes_quality_gate"
    assert push_pos > -1, "poll_one_cloud must call push_industry"
    assert qg_pos < push_pos, "passes_quality_gate must be called BEFORE push_industry"


def test_v074_watchdog_lock_reclaims_stale():
    """Simulate a stale lock file > 15 min old by setting mtime far in past."""
    import time as _t
    sys.path.insert(0, str(REPO_ROOT / "runner"))
    try:
        wd = importlib.import_module("sync_watchdog")
    finally:
        sys.path.pop(0)
    if os.path.isfile(wd.LOCK_FILE):
        os.remove(wd.LOCK_FILE)
    Path(wd.LOCK_FILE).write_text("99999")
    old = _t.time() - 1000
    os.utime(wd.LOCK_FILE, (old, old))
    assert wd.acquire_repo_lock(timeout_s=2), "Stale lock must be reclaimed"
    wd.release_repo_lock()
