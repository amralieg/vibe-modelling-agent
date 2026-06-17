"""Behavioral tests for v3.7.1 alias=pkw-arm-volume-log (BUG-C diagnostic).

ROOT CAUSE context: ncdot v3.7.0 (run 980958435536744 @ fe-gcp) crashed with a
transient AttributeError, then sat RUNNING ~57 minutes despite the v3.6.9
process-kill-watchdog being armed on the crash path (finally -> _arm_finalization_watchdog
-> _spawn_process_kill_watchdog, 360s grace). The watchdog ARM event was only print()ed
to driver stdout, which is LOST when the driver wedges -- so there was zero persisted
evidence of whether the watchdog armed, and BUG-C (why it didn't kill) was unrootcauseable.

THE FIX: _arm_finalization_watchdog now ALSO logs the ARM event via the volume logger
(widgets_values["logger"]), which survives a hang and is mirrored by the poller. On the
next crash, if this line shows grace=G but the run stays RUNNING beyond G+60s, the
external SIGTERM/SIGKILL child is conclusively the culprit.

Test 1 (structural): the notebook contains the pkw-arm-volume-log marker.
Test 2 (behavioral): calling the REAL _arm_finalization_watchdog with a recording logger
emits the ARM-LOG warning (with grace + pkw_grace), while _spawn_process_kill_watchdog is
stubbed so no real terminator process is spawned.
Test 3 (negative): no logger in widgets_values -> graceful (no exception, no spawn change).
"""
import json
import os
import re

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _extract_func(name):
    src = _src()
    m = re.search(r"\ndef " + re.escape(name) + r"\b[\s\S]*?\n(?=\n(?:class |def )[A-Za-z_])", "\n" + src)
    assert m, f"def {name} not found in notebook"
    return m.group(0).lstrip("\n")


def _load_arm():
    import threading, time as _t
    g = {"threading": threading, "time": _t, "os": os, "logging": __import__("logging")}
    spawn_calls = []

    def _stub_spawn(grace_seconds=360, source="operation", *a, **k):
        spawn_calls.append((grace_seconds, source))

    g["_spawn_process_kill_watchdog"] = _stub_spawn
    exec(_extract_func("_arm_finalization_watchdog"), g)
    return g["_arm_finalization_watchdog"], spawn_calls


class _Log:
    def __init__(self):
        self.warnings = []

    def warning(self, m):
        self.warnings.append(m)

    def info(self, m):
        pass

    def error(self, m):
        pass


def test_marker_present():
    assert "pkw-arm-volume-log" in _src()
    assert "ARM-LOG FIRED" in _src()


def test_arm_logs_event_to_volume_logger():
    """BEHAVIORAL — real _arm_finalization_watchdog logs the ARM event with grace info."""
    arm, spawn_calls = _load_arm()
    log = _Log()
    # huge grace so the daemon _wd thread never fires os._exit during the test (it is a daemon,
    # pytest exits long before); the stubbed spawn means no real killer process.
    arm({"logger": log}, grace_seconds=99999, source="unit-test")
    armlog = [m for m in log.warnings if "ARM-LOG FIRED" in m]
    assert armlog, f"expected ARM-LOG warning; got {log.warnings}"
    msg = armlog[0]
    assert "grace=99999s" in msg, msg
    assert "pkw_grace=100059s" in msg, msg  # grace + 60
    assert "pkw-arm-volume-log" in msg, msg
    # the GIL-independent backstop is still armed (stubbed) with grace+60
    assert any(gc == 99999 + 60 for gc, _ in spawn_calls), spawn_calls


def test_arm_no_logger_is_graceful():
    """NEGATIVE — no logger key must not raise and must still arm the backstop."""
    arm, spawn_calls = _load_arm()
    arm({}, grace_seconds=99999, source="unit-test-nolog")  # must not raise
    assert any(gc == 99999 + 60 for gc, _ in spawn_calls), spawn_calls
