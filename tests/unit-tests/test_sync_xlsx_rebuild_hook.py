"""Unit tests for the post-push xlsx-rebuild hook in sync_to_repo.py.

ROOT CAUSE this fixes:
The user requires the stats Excel file (~/claude/vibe-agent/state/vibe_state_raw.xlsx)
to be auto-synced every time something is pushed to the repo. Without an in-band
hook, the dashboard would only refresh when refresh_dashboard.py is run manually,
producing stale views (e.g. xlsx showing 25 industries while repo has 28).

The fix wires `_rebuild_state_xlsx(log)` into `sync_completed_industries()` so
that ANY successful push (whether from the orchestrator's per-industry sync or
from the watchdog daemon) immediately rebuilds the consolidated xlsx.

These tests verify:
1. The hook FIRES (subprocess invoked) when result["synced"] is non-empty.
2. The hook does NOT fire when nothing was pushed (no synced industries).
3. The hook is BEST-EFFORT — a subprocess failure does NOT raise; the function
   still returns the original result dict cleanly.
4. The hook is BEST-EFFORT — a missing builder script logs a SKIP and returns.
5. The hook is BEST-EFFORT — a TimeoutExpired on the subprocess does NOT raise.

Repo-sync MUST NEVER block on dashboard refresh because the xlsx is a downstream
observability artifact — losing it temporarily is far less bad than losing the
git push of a model artifact.
"""
import os
import subprocess
import sys
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT / "runner"))

import sync_to_repo as _sr


@pytest.fixture
def captured_logs():
    msgs = []
    return msgs, msgs.append


def _make_fake_run(returncode=0, stdout="Wrote: vibe_state_raw.xlsx", stderr=""):
    class _R:
        pass
    r = _R()
    r.returncode = returncode
    r.stdout = stdout
    r.stderr = stderr
    return r


def test_rebuild_hook_fires_when_synced_nonempty(monkeypatch, captured_logs):
    msgs, log = captured_logs
    monkeypatch.setattr(_sr.os.path, "exists", lambda p: p == _sr.XLSX_BUILDER_PATH)
    captured_cmd = []

    def fake_run(cmd, capture_output=False, text=False, timeout=None, **kw):
        captured_cmd.append(cmd)
        return _make_fake_run(returncode=0, stdout="Wrote: /Users/x/state/vibe_state_raw.xlsx\n  1 sheet: 'State' (40 rows)")

    monkeypatch.setattr(_sr.subprocess, "run", fake_run)
    _sr._rebuild_state_xlsx(log)

    assert len(captured_cmd) == 1, "subprocess.run must be called exactly once"
    cmd = captured_cmd[0]
    assert cmd[0] == sys.executable
    assert cmd[1] == _sr.XLSX_BUILDER_PATH
    assert any("[xlsx-rebuild FIRED]" in m for m in msgs), f"missing FIRED log: {msgs}"


def test_sync_completed_industries_calls_rebuild_when_pushed(monkeypatch, captured_logs):
    msgs, log = captured_logs

    monkeypatch.setattr(_sr, "_ensure_repo_clone", lambda *a, **k: True)
    monkeypatch.setattr(_sr, "_list_workspace_industries", lambda *a, **k: ["agriculture"])
    monkeypatch.setattr(_sr, "_export_industry", lambda *a, **k: True)
    monkeypatch.setattr(_sr, "normalize_industry_readmes", lambda *a, **k: None)
    monkeypatch.setattr(_sr, "_commit_and_push", lambda *a, **k: True)

    monkeypatch.setattr(_sr.os.path, "isdir", lambda p: False)
    monkeypatch.setattr(_sr.os, "listdir", lambda p: [])

    rebuild_calls = []
    monkeypatch.setattr(_sr, "_rebuild_state_xlsx", lambda log: rebuild_calls.append("called"))

    out = _sr.sync_completed_industries(
        repo_path="/tmp/fake-repo",
        workspace_root="/Users/x/vibe_runner_models",
        profile="<profile>",
        log=log,
    )

    assert out["synced"] == ["agriculture"], f"expected agriculture in synced, got {out}"
    assert rebuild_calls == ["called"], "rebuild hook MUST fire after a successful push"
    assert any("rebuilding xlsx dashboard" in m for m in msgs), f"missing rebuild log line: {msgs}"


def test_sync_completed_industries_skips_rebuild_when_nothing_pushed(monkeypatch, captured_logs):
    msgs, log = captured_logs

    monkeypatch.setattr(_sr, "_ensure_repo_clone", lambda *a, **k: True)
    monkeypatch.setattr(_sr, "_list_workspace_industries", lambda *a, **k: ["agriculture"])
    monkeypatch.setattr(_sr.os.path, "isdir", lambda p: True)
    monkeypatch.setattr(_sr.os, "listdir", lambda p: ["model.json"])

    rebuild_calls = []
    monkeypatch.setattr(_sr, "_rebuild_state_xlsx", lambda log: rebuild_calls.append("called"))

    out = _sr.sync_completed_industries(
        repo_path="/tmp/fake-repo",
        workspace_root="/Users/x/vibe_runner_models",
        profile="<profile>",
        log=log,
    )

    assert out["synced"] == [], "nothing should have been synced (industry already present)"
    assert out["skipped_existing"] == ["agriculture"]
    assert rebuild_calls == [], "rebuild hook MUST NOT fire when nothing was pushed (saves 1.5s/cycle)"


def test_rebuild_hook_swallows_subprocess_failure(monkeypatch, captured_logs):
    msgs, log = captured_logs
    monkeypatch.setattr(_sr.os.path, "exists", lambda p: p == _sr.XLSX_BUILDER_PATH)

    monkeypatch.setattr(_sr.subprocess, "run",
                         lambda *a, **k: _make_fake_run(returncode=1, stderr="ImportError: openpyxl"))

    _sr._rebuild_state_xlsx(log)

    assert any("[xlsx-rebuild FAILED]" in m for m in msgs), f"missing FAILED log: {msgs}"
    assert not any("FIRED" in m for m in msgs), "FIRED line must not appear on failure"


def test_rebuild_hook_skips_when_builder_missing(monkeypatch, captured_logs):
    msgs, log = captured_logs
    monkeypatch.setattr(_sr.os.path, "exists", lambda p: False)

    runs = []
    monkeypatch.setattr(_sr.subprocess, "run", lambda *a, **k: runs.append(a) or _make_fake_run())

    _sr._rebuild_state_xlsx(log)

    assert runs == [], "subprocess.run must NOT be called when builder is missing"
    assert any("[xlsx-rebuild SKIP]" in m for m in msgs), f"missing SKIP log: {msgs}"


def test_rebuild_hook_swallows_timeout(monkeypatch, captured_logs):
    msgs, log = captured_logs
    monkeypatch.setattr(_sr.os.path, "exists", lambda p: p == _sr.XLSX_BUILDER_PATH)

    def boom(*a, **k):
        raise subprocess.TimeoutExpired(cmd=a[0] if a else "x", timeout=k.get("timeout", 30))

    monkeypatch.setattr(_sr.subprocess, "run", boom)

    _sr._rebuild_state_xlsx(log)
    assert any("[xlsx-rebuild TIMEOUT]" in m for m in msgs), f"missing TIMEOUT log: {msgs}"


def test_rebuild_hook_swallows_arbitrary_exception(monkeypatch, captured_logs):
    msgs, log = captured_logs
    monkeypatch.setattr(_sr.os.path, "exists", lambda p: p == _sr.XLSX_BUILDER_PATH)

    monkeypatch.setattr(_sr.subprocess, "run",
                         lambda *a, **k: (_ for _ in ()).throw(RuntimeError("kaboom")))

    _sr._rebuild_state_xlsx(log)
    assert any("[xlsx-rebuild THREW]" in m for m in msgs), f"missing THREW log: {msgs}"
