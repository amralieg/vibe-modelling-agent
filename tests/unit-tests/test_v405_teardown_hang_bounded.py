import json
import time
import concurrent.futures as cf
from pathlib import Path

import agent_helpers as ah

PRE = Path("/tmp/agent_v404_backup.ipynb")  # pre-v4.0.5 (v4.0.4): unbounded wait + watchdog-after-shutdown


def test_version_bumped_to_405():
    assert ah.__AGENT_VERSION__ == "4.1.1", ah.__AGENT_VERSION__


class _BlockingPool:
    """Fake pool whose shutdown() blocks forever — simulates the drain deadlock."""

    def __init__(self):
        self.shutdown_called = False

    def shutdown(self, wait=True, cancel_futures=False):
        self.shutdown_called = True
        # never returns within the test horizon
        time.sleep(3600)


class _FastPool:
    def __init__(self):
        self.shutdown_called = False

    def shutdown(self, wait=True, cancel_futures=False):
        self.shutdown_called = True
        return None


def test_shutdown_bounded_returns_when_drain_hangs(capsys):
    """The fix: a hanging pool drain must NOT hang the caller — it returns within drain_timeout."""
    pool = _BlockingPool()
    ah._GLOBAL_LLM_POOL["pool"] = pool
    t0 = time.time()
    ah.shutdown_global_llm_pool(wait=True, source="unit", drain_timeout=2)
    elapsed = time.time() - t0
    assert elapsed < 8, f"shutdown did not bound the hanging drain (took {elapsed:.1f}s)"
    assert pool.shutdown_called is True
    assert ah._GLOBAL_LLM_POOL["pool"] is None  # reference cleared
    out = capsys.readouterr().out
    assert "[global-pool-shutdown-bounded FIRED v4.0.5]" in out
    assert "alias=global-pool-shutdown-bounded" in out


def test_shutdown_clean_path_logs_success(capsys):
    """When the drain completes fast, the original v3.9.9 success line is logged (no false TIMEOUT)."""
    pool = _FastPool()
    ah._GLOBAL_LLM_POOL["pool"] = pool
    ah.shutdown_global_llm_pool(wait=True, source="unit", drain_timeout=5)
    out = capsys.readouterr().out
    assert "[global-llm-pool-shutdown FIRED v3.9.9]" in out
    assert "[global-pool-shutdown-bounded FIRED v4.0.5]" not in out
    assert pool.shutdown_called is True


def test_shutdown_noop_when_pool_none():
    ah._GLOBAL_LLM_POOL["pool"] = None
    # must not raise
    ah.shutdown_global_llm_pool(wait=True, source="unit", drain_timeout=1)


def test_shared_pool_exit_wait_is_bounded(capsys):
    """_SharedPoolHandle.__exit__ must call _cf2.wait with a FINITE timeout (deadlock self-heal)."""
    captured = {}
    orig = cf.wait

    def fake_wait(fs, timeout=None, return_when=cf.ALL_COMPLETED):
        captured["timeout"] = timeout
        never = cf.Future()  # simulate a future that never completes
        return (set(), {never})

    cf.wait = fake_wait
    try:
        h = ah._SharedPoolHandle(pool=object(), pool_name="unit", max_workers=2, mark_guard=False)
        h._futs = [cf.Future()]
        t0 = time.time()
        ret = h.__exit__(None, None, None)
        elapsed = time.time() - t0
    finally:
        cf.wait = orig
    assert captured.get("timeout") == 1200, captured
    assert ret is False
    assert elapsed < 5
    out = capsys.readouterr().out
    assert "[shared-pool-wait-bounded FIRED v4.0.5]" in out


def test_shared_pool_exit_completes_normally_when_futures_done():
    """Normal path: all futures done -> __exit__ returns without firing the bounded warning."""
    f = cf.Future()
    f.set_result(1)
    h = ah._SharedPoolHandle(pool=object(), pool_name="unit", max_workers=1, mark_guard=False)
    h._futs = [f]
    t0 = time.time()
    ret = h.__exit__(None, None, None)
    assert ret is False
    assert time.time() - t0 < 3


def test_fail_pre_v404_lacks_bounded_teardown_fix():
    """Prove the fix is NEW: the v4.0.4 backup has the unbounded wait and watchdog-after-shutdown order."""
    if not PRE.exists():
        import pytest
        pytest.skip(f"pre-patch backup {PRE} absent (ephemeral /tmp dev artifact); fail-pre half is historical, pass-post protects live behavior")
    src = "".join(
        "".join(c.get("source", []))
        for c in json.load(open(PRE))["cells"]
        if c.get("cell_type") == "code"
    )
    # v4.0.4 lacks all three v4.0.5 fix markers
    assert "global-pool-shutdown-bounded" not in src
    assert "shared-pool-wait-bounded" not in src
    assert "watchdog-before-shutdown" not in src
    # v4.0.4 had the unbounded wait (no timeout kwarg on the handle wait)
    assert "_cf2.wait(self._futs)" in src
    assert "_cf2.wait(self._futs, timeout=1200)" not in src
    # v4.0.4 finally armed the watchdog AFTER the shutdown call (the ordering bug)
    i_shutdown = src.find('shutdown_global_llm_pool(wait=True, logger=(widgets_values.get("logger")')
    i_watchdog = src.find('_arm_finalization_watchdog(widgets_values, grace_seconds=600, source="pipeline-finally")')
    assert i_shutdown != -1 and i_watchdog != -1
    assert i_watchdog > i_shutdown, "expected v4.0.4 to arm watchdog AFTER shutdown (the bug)"
