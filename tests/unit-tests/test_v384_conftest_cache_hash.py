"""Behavioral guard for the conftest source-cache freshness fix (v3.8.4).

Root cause (2026-06-18): `_extract_source_from_notebook()` trusted the worker
cache whenever cache_mtime >= notebook_mtime. A notebook patched/restored with a
preserved (older) mtime left a NEWER stale cache that the mtime guard honored, so
`agent_helpers` loaded a stale __AGENT_VERSION__ while the live notebook was newer
-> test_v100_agent_version_bumped failed as a FALSE regression.

The fix keys the cache on the SHA-256 of the notebook bytes. These tests prove:
  (1) a stale cache with a NEWER mtime but a non-matching hash is IGNORED
      (this assertion fails under the old mtime-only guard, passes under the fix);
  (2) a cache whose hash matches the live notebook is still REUSED (no perf
      regression, the cache is not always invalidated).
"""
import hashlib
import importlib
import os
import re
import time
from pathlib import Path

import pytest

conftest = importlib.import_module("conftest")
NOTEBOOK_PATH = conftest.NOTEBOOK_PATH


def _live_version() -> str:
    text = NOTEBOOK_PATH.read_text(encoding="utf-8")
    m = re.search(r'__AGENT_VERSION__\s*=\s*\\?"(\d+\.\d+\.\d+)\\?"', text)
    assert m, "could not find __AGENT_VERSION__ in live notebook"
    return m.group(1)


@pytest.fixture
def isolated_worker(monkeypatch):
    """Use a unique worker label so we never clobber the real /tmp cache."""
    label = f"test_cache_hash_{os.getpid()}"
    monkeypatch.setenv("PYTEST_XDIST_WORKER", label)
    src = Path("/tmp") / f"agent_source.{label}.py"
    hsh = Path("/tmp") / f"agent_source.{label}.sha256"
    for p in (src, hsh):
        if p.exists():
            p.unlink()
    yield src, hsh
    for p in (src, hsh):
        if p.exists():
            p.unlink()


def test_stale_cache_with_newer_mtime_is_ignored(isolated_worker):
    src, hsh = isolated_worker
    live = _live_version()
    fake_version = "0.0.1"
    assert fake_version != live

    # Plant a stale cache: fake version content, a hash that does NOT match the
    # live notebook, and a future mtime that would defeat the old mtime guard.
    src.write_text(f'__AGENT_VERSION__ = "{fake_version}"\n', encoding="utf-8")
    hsh.write_text("deadbeef" * 8, encoding="utf-8")
    future = time.time() + 10_000
    os.utime(src, (future, future))
    os.utime(hsh, (future, future))

    result = conftest._extract_source_from_notebook()

    assert fake_version not in result, (
        "stale cache (newer mtime, non-matching hash) was served — mtime guard "
        "regression"
    )
    assert f'__AGENT_VERSION__ = "{live}"' in result or f'__AGENT_VERSION__ = \\"{live}\\"' in result


def test_matching_hash_cache_is_reused(isolated_worker):
    src, hsh = isolated_worker
    nb_hash = hashlib.sha256(NOTEBOOK_PATH.read_bytes()).hexdigest()

    sentinel = "# SENTINEL_REUSED_CACHE_MARKER\n__AGENT_VERSION__ = \"9.9.9\"\n"
    src.write_text(sentinel, encoding="utf-8")
    hsh.write_text(nb_hash, encoding="utf-8")

    result = conftest._extract_source_from_notebook()

    assert "SENTINEL_REUSED_CACHE_MARKER" in result, (
        "cache with a matching content hash was NOT reused — caching broken"
    )


def test_refreshes_cache_and_hash_sidecar(isolated_worker):
    src, hsh = isolated_worker
    result = conftest._extract_source_from_notebook()

    assert src.exists() and hsh.exists(), "cache + hash sidecar not written"
    nb_hash = hashlib.sha256(NOTEBOOK_PATH.read_bytes()).hexdigest()
    assert hsh.read_text(encoding="utf-8").strip() == nb_hash
    assert src.read_text(encoding="utf-8") == result
