"""Behavioral tests for v3.6.2 alias=io-timeout-watchdog.

ROOT CAUSE this fixes: the new-base-model pipeline froze SILENTLY for the full
job budget on serverless. Deterministically reproduced on both fe-gcp (ncdot) and
fe-aws (healthcare): both stalled 28+ min at the setup cleanup step
("Removing Previous Run Business Folder") which calls
`dbutils.fs.rm(TARGET_VOLUME, recurse=True)`. Serverless dbutils.fs / Files-API
calls have NO client-side timeout, so a stalled UC Volume blocks the calling
thread forever. The same class also blocks `_safe_copy_local_to_dbfs`, which is
what the log-streamer daemon uses, so the hang was invisible (the streamer that
should have shown progress was itself blocked).

v3.6.2 introduces `_io_with_timeout(fn, timeout_s, logger, label)`: it runs the
blocking call in a daemon worker thread and join()s with a hard deadline. On
deadline the main thread proceeds (the abandoned daemon dies with the process)
and the helper returns (None, True). It is wired into the cleanup rm (skip on
timeout), the subfolder mkdirs (retry once on timeout), and all three
`_safe_copy_local_to_dbfs` upload strategies (timeout == strategy failure ->
fall through to the next).

These tests extract the REAL production helper from the notebook (not a stub) and
exercise every branch, then statically assert the wiring. They FAIL on
pre-v3.6.2 HEAD because the helper + wiring do not exist.
"""
import json
import re
import os
import time

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _load_helper():
    src = _src()
    m = re.search(r"\ndef _io_with_timeout\(.*?\n(?=\ndef |\n[^ \n])", src, re.DOTALL)
    assert m, "_io_with_timeout not found in notebook (pre-v3.6.2 HEAD)"
    g = {}
    exec(m.group(0), g)
    return g["_io_with_timeout"]


# ── behavior: every branch of the watchdog ────────────────────────────────────

def test_fast_call_returns_value_not_timed_out():
    io_to = _load_helper()
    val, timed_out = io_to(lambda: 42, 5, None, "fast")
    assert val == 42 and timed_out is False


def test_slow_call_times_out_and_main_thread_proceeds():
    io_to = _load_helper()
    # worker sleeps 10s but deadline is 0.3s: the helper MUST return promptly with
    # timed_out=True (this is the whole point — the pipeline does not block on a
    # stalled volume). Assert wall-clock is bounded well under the worker sleep.
    start = time.time()
    val, timed_out = io_to(lambda: time.sleep(10), 0.3, None, "slow")
    elapsed = time.time() - start
    assert timed_out is True and val is None
    assert elapsed < 3.0, f"watchdog did not short-circuit; elapsed={elapsed:.2f}s"


def test_exception_in_worker_is_reraised():
    io_to = _load_helper()
    def _boom():
        raise ValueError("volume gone")
    try:
        io_to(_boom, 5, None, "boom")
        assert False, "expected ValueError to propagate"
    except ValueError as e:
        assert "volume gone" in str(e)


def test_logger_warning_on_timeout_does_not_crash():
    io_to = _load_helper()
    seen = {}
    class _L:
        def warning(self, msg):
            seen["msg"] = msg
    val, timed_out = io_to(lambda: time.sleep(5), 0.2, _L(), "with-logger")
    assert timed_out is True
    assert "io-timeout-watchdog" in seen.get("msg", "")


# ── wiring: helper used at all the blocking-I/O sites ─────────────────────────

def test_helper_defined_once():
    src = _src()
    assert src.count("def _io_with_timeout(") == 1


def test_cleanup_rm_is_bounded():
    src = _src()
    assert '_io_with_timeout(_rm_target_volume, 90' in src, "cleanup rm not wrapped"
    # on timeout the cleanup is SKIPPED (best-effort on a fresh volume), not retried forever
    assert "_rm_timed_out" in src and "SKIPPING" in src


def test_mkdirs_is_bounded_with_retry():
    src = _src()
    assert re.search(r'_io_with_timeout\(_mk, 90, logger, f"mkdir-\{_subfolder\}"\)', src), "mkdir not wrapped"
    assert 'f"mkdir-{_subfolder}-retry"' in src, "mkdir retry path missing"


def test_safecopy_strategies_all_bounded():
    src = _src()
    for label in ("safecopy-sdk-upload", "safecopy-put", "safecopy-cp"):
        assert f'"{label}"' in src, f"{label} not bounded by watchdog"
    # a timed-out strategy must be treated as a failure so the next one is tried
    assert "(io-timeout-watchdog)" in src


def test_version_at_least_362():
    from version_test_util import assert_version_at_least
    assert_version_at_least("3.6.2")
