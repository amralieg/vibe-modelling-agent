"""Behavioral tests for v3.6.5 alias=joblaunch-getrun-watchdog.

ROOT CAUSE this fixes (live, ncdot parent launcher run 23674965251537 @ fe-gcp):
the agent self-relaunches as a child job (Job Launch Gate) and the parent blocks in
JobLauncher.wait_for_run_terminal, which polls the child via SDK jobs.get_run(). That
SDK call has NO client-side timeout, so a stalled control-plane call blocks the poll
loop forever. The loop's own `timeout_seconds` check runs only AFTER get_run returns,
so it never fires -> the parent never observes the child's TERMINATED state and never
exits (the 15h job budget was the only backstop). Empirically: the child TERMINATED
SUCCESS, all artifacts were written, yet the parent stayed RUNNING 41 min later.

THE FIX: wrap each get_run in the v3.6.2 `_io_with_timeout` watchdog (120s/call). A
timed-out call raises into the existing `except` and is re-polled on the next loop
iteration; a transient stall recovers and a permanent one is still capped by the
overall `timeout_seconds`.

These tests extract the REAL `_io_with_timeout` watchdog from the notebook and prove
(1) a hung callable is abandoned within the deadline returning timed_out=True (the
exact mechanism wait_for_run_terminal now relies on), and (2) statically that both
poll defs route get_run through the watchdog. They FAIL on pre-v3.6.5 HEAD (no
watchdog wrap around get_run) and PASS post-fix.
"""
import json
import os
import re
import time

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _extract(name):
    src = _src()
    m = re.search(r"\ndef " + re.escape(name) + r"\(.*?\n(?=\ndef |\n@|\n[^ \n])", "\n" + src, re.DOTALL)
    assert m, f"def {name} not found"
    return m.group(0).lstrip("\n")


def _load_watchdog():
    g = {}
    exec(_extract("_io_with_timeout"), g)
    return g["_io_with_timeout"]


# ── static: every poll-loop get_run is wrapped by the watchdog ────────────────

def test_get_run_is_wrapped_in_watchdog_at_every_site():
    src = _src()
    raw = src.count("_w.jobs.get_run(run_id=run_id)")
    wrapped = src.count("_io_with_timeout(lambda: _w.jobs.get_run(run_id=run_id)")
    assert raw == wrapped and wrapped >= 1, (
        f"every wait_for_run_terminal get_run must be watchdog-wrapped: raw={raw} wrapped={wrapped}"
    )
    assert "joblaunch-getrun-watchdog" in src


# ── behavior: a hung get_run is abandoned within the deadline ─────────────────

def test_watchdog_abandons_hung_call_returns_timed_out():
    io_to = _load_watchdog()

    def _hang():
        time.sleep(30)  # simulate a stalled control-plane get_run
        return "should-never-be-seen"

    t0 = time.time()
    val, timed_out = io_to(_hang, 1, label="test-getrun-hang")
    dt = time.time() - t0
    assert timed_out is True, "a call exceeding the deadline must report timed_out=True"
    assert val is None
    assert dt < 5, f"watchdog must return ~at the deadline (1s), not block on the hung call; took {dt:.1f}s"


# ── selectivity: a fast get_run returns its value, not a timeout ──────────────

def test_watchdog_passes_through_fast_call():
    io_to = _load_watchdog()
    val, timed_out = io_to(lambda: "RUN_STATE", 5, label="test-getrun-fast")
    assert timed_out is False
    assert val == "RUN_STATE"


# ── selectivity: a real get_run exception still propagates (retry path) ───────

def test_watchdog_reraises_real_exception():
    io_to = _load_watchdog()

    def _boom():
        raise RuntimeError("control-plane 500")

    import pytest
    with pytest.raises(RuntimeError):
        io_to(_boom, 5, label="test-getrun-error")
