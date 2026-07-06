"""v3.8.1 behavioral tests for the two gov_transport-run-246274309742438 root-cause fixes.

FIX-1 alias=ground-truth-reaudit-post-tags (the lying scoreboard):
    step_generate_next_vibes_late MUST clear widgets_values["_ground_truth_scorecard"]
    BEFORE it calls step_generate_next_vibes, so the LATE pass (after Track 3 physical
    SET TAGS) re-grounds adherence against the real catalog instead of reusing the stale
    pre-tags scorecard. Observable state change: the inner call sees scorecard == None.

FIX-2 alias=faulthandler-kill-backstop (the 88-min post-finalize hang):
    _spawn_process_kill_watchdog MUST arm faulthandler.dump_traceback_later(grace, exit=True)
    in addition to the fragile Popen SIGKILL child. Observable state change: dump_traceback_later
    is invoked with the grace seconds and exit=True.

Both tests extract the live function source from the production notebook (not a copy) and
prove the observable state change, so they FAIL on pre-v3.8.1 HEAD where the clear / the
faulthandler arm do not exist.
"""
import json
import os
import sys
import types

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _extract_function_source(func_name):
    """Slice a single top-level def out of whichever code cell defines it."""
    nb = json.load(open(NB))
    needle = f"def {func_name}("
    for c in nb.get("cells", []):
        if c.get("cell_type") != "code":
            continue
        src = "".join(c.get("source", []))
        if needle not in src:
            continue
        start = src.index(needle)
        rest = src[start + len(needle):]
        # find the next top-level "def " (newline + 'def ' at column 0)
        nxt = rest.find("\ndef ")
        end = (start + len(needle) + nxt) if nxt != -1 else len(src)
        return src[start:end]
    raise AssertionError(f"{func_name} not found in notebook")


# ---------------------------------------------------------------------------
# FIX-1: ground-truth-reaudit-post-tags
# ---------------------------------------------------------------------------
def _load_late_fn():
    block = _extract_function_source("step_generate_next_vibes_late")
    captured = {}

    def _stub_inner(widgets_values):
        # record the scorecard value AT THE MOMENT the inner audit fn is called
        captured["scorecard_at_call"] = widgets_values.get("_ground_truth_scorecard")

    ns = {"step_generate_next_vibes": _stub_inner}
    exec(compile(block, "<late>", "exec"), ns)
    return ns["step_generate_next_vibes_late"], captured


def test_late_pass_clears_stale_scorecard_before_reaudit():
    fn, captured = _load_late_fn()
    wv = {"logger": None, "_ground_truth_scorecard": {"adherence": 0.56, "stale": True}}

    fn(wv)

    # observable state change: inner audit saw a CLEARED scorecard (re-audit unblocked)
    assert captured["scorecard_at_call"] is None, (
        "lying-scoreboard regression: step_generate_next_vibes_late did NOT clear the "
        "stale pre-tags scorecard before the late re-audit"
    )
    assert wv.get("_next_vibes_late_emitted") is True


def test_late_pass_noop_when_no_scorecard():
    """Guard: if no scorecard exists, the clear is a no-op and the inner call still runs."""
    fn, captured = _load_late_fn()
    wv = {"logger": None}
    fn(wv)
    assert captured["scorecard_at_call"] is None
    assert wv.get("_next_vibes_late_emitted") is True


# ---------------------------------------------------------------------------
# FIX-2: faulthandler-kill-backstop
# ---------------------------------------------------------------------------
def _load_watchdog_fn():
    block = _extract_function_source("_spawn_process_kill_watchdog")
    ns = {}
    exec(compile(block, "<wd>", "exec"), ns)
    return ns["_spawn_process_kill_watchdog"]


def test_watchdog_arms_faulthandler_backstop(monkeypatch):
    fn = _load_watchdog_fn()
    calls = []

    # stub faulthandler so the test process is NOT actually scheduled for _exit()
    fake_fh = types.ModuleType("faulthandler")
    fake_fh.dump_traceback_later = lambda secs, exit=False: calls.append((secs, exit))
    monkeypatch.setitem(sys.modules, "faulthandler", fake_fh)

    # stub subprocess so no real python child is spawned for `grace` seconds
    fake_sp = types.ModuleType("subprocess")
    fake_sp.DEVNULL = -3
    fake_sp.Popen = lambda *a, **k: types.SimpleNamespace(pid=12345)
    monkeypatch.setitem(sys.modules, "subprocess", fake_sp)

    fn(grace_seconds=42, source="unit-test")

    assert calls, (
        "hang regression: _spawn_process_kill_watchdog did NOT arm "
        "faulthandler.dump_traceback_later (GIL-independent backstop missing)"
    )
    secs, do_exit = calls[0]
    assert secs == 42
    assert do_exit is True, "faulthandler backstop must arm with exit=True to terminate the wedge"


def test_watchdog_survives_faulthandler_import_failure(monkeypatch):
    """The backstop must be best-effort: a faulthandler failure cannot break the watchdog."""
    fn = _load_watchdog_fn()

    fake_fh = types.ModuleType("faulthandler")

    def _boom(*a, **k):
        raise RuntimeError("no native thread")

    fake_fh.dump_traceback_later = _boom
    monkeypatch.setitem(sys.modules, "faulthandler", fake_fh)

    fake_sp = types.ModuleType("subprocess")
    fake_sp.DEVNULL = -3
    fake_sp.Popen = lambda *a, **k: types.SimpleNamespace(pid=1)
    monkeypatch.setitem(sys.modules, "subprocess", fake_sp)

    # must not raise
    fn(grace_seconds=5, source="unit-test")
