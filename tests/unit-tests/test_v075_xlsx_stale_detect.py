"""v0.7.5 (alias=xlsx-stale-detect) regression tests.

Covers root-cause fix for the 2026-05-10 sports_entertainment incident:
  - sports_entertainment landed in the repo at 00:00 UTC
  - 9 watchdog cycles 00:08 -> 00:31 all reported cycle_pushed=0
  - xlsx-rebuild was never triggered because the prior implementation
    only fired on cycle_pushed > 0
  - User opened the dashboard at ~00:29 UTC and saw status="Waiting"
    for sports_entertainment although it had completed 29 minutes earlier

These tests verify the new _xlsx_is_stale() probe in
runner/sync_watchdog.py correctly detects:
  - xlsx newer than every model.json -> NOT stale
  - any model.json newer than xlsx (beyond grace) -> stale
  - xlsx missing entirely -> stale
"""

import os
import sys
import tempfile
import time

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "runner"))

import sync_watchdog as sw


def _setup(tmpdir):
    repo = os.path.join(tmpdir, "repo")
    xlsx = os.path.join(tmpdir, "state.xlsx")
    os.makedirs(os.path.join(repo, "alpha", "ecm_v1"))
    os.makedirs(os.path.join(repo, "alpha", "mvm_v1"))
    open(os.path.join(repo, "alpha", "ecm_v1", "model.json"), "w").write("{}")
    open(os.path.join(repo, "alpha", "mvm_v1", "model.json"), "w").write("{}")
    sw.REPO_PATH = repo
    sw.XLSX_STATE_FILE = xlsx
    sw.XLSX_STALE_GRACE_S = 0
    return repo, xlsx


def test_xlsx_fresh_not_stale():
    with tempfile.TemporaryDirectory() as td:
        repo, xlsx = _setup(td)
        time.sleep(0.05)
        open(xlsx, "w").write("xxx")
        assert sw._xlsx_is_stale() is False


def test_xlsx_older_than_model_is_stale():
    with tempfile.TemporaryDirectory() as td:
        repo, xlsx = _setup(td)
        open(xlsx, "w").write("xxx")
        time.sleep(0.05)
        os.utime(os.path.join(repo, "alpha", "ecm_v1", "model.json"), None)
        assert sw._xlsx_is_stale() is True


def test_xlsx_missing_is_stale():
    with tempfile.TemporaryDirectory() as td:
        repo, xlsx = _setup(td)
        assert not os.path.isfile(xlsx)
        assert sw._xlsx_is_stale() is True


def test_xlsx_grace_period_respected():
    with tempfile.TemporaryDirectory() as td:
        repo, xlsx = _setup(td)
        sw.XLSX_STALE_GRACE_S = 60
        open(xlsx, "w").write("xxx")
        time.sleep(0.05)
        os.utime(os.path.join(repo, "alpha", "ecm_v1", "model.json"), None)
        assert sw._xlsx_is_stale() is False


def test_xlsx_stale_skips_dotfolders():
    with tempfile.TemporaryDirectory() as td:
        repo, xlsx = _setup(td)
        os.makedirs(os.path.join(repo, ".git", "hooks"), exist_ok=True)
        future = time.time() + 3600
        os.utime(os.path.join(repo, ".git"), (future, future))
        time.sleep(0.05)
        open(xlsx, "w").write("xxx")
        assert sw._xlsx_is_stale() is False


def test_xlsx_stale_failopen_on_io_error(monkeypatch):
    sw.REPO_PATH = "/nonexistent_path_does_not_exist_for_test"
    sw.XLSX_STATE_FILE = "/another_nonexistent_path"
    assert sw._xlsx_is_stale() is True
    sw.XLSX_STATE_FILE = __file__
    monkeypatch.setattr(os, "listdir", lambda *a, **kw: (_ for _ in ()).throw(PermissionError("denied")))
    assert sw._xlsx_is_stale() is False
