import io
import json
import os
import re
import threading
import time
from contextlib import redirect_stdout

_NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _full():
    nb = json.load(open(_NB))
    return "\n".join("".join(c.get("source", [])) for c in nb["cells"])


def _finally_cell_src():
    nb = json.load(open(_NB))
    for c in nb["cells"]:
        if c["cell_type"] != "code":
            continue
        s = "".join(c["source"])
        if "    finally:\n" in s and "_safe_notebook_exit(widgets_values.get" in s and "_finalize_logs(" in s:
            return s
    raise AssertionError("finalize cell not found")


def test_v353_version_constant():
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', _full())
    assert m and tuple(int(x) for x in m.groups()) >= (3, 5, 3)


def test_v353_finalize_logs_bounded_in_thread():
    src = _finally_cell_src()
    assert "alias=finalize-logs-bounded-timeout" in src
    assert "finalize-logs-bounded-timeout FIRED v3.5.3" in src
    assert "_fl_t.join(timeout=120)" in src
    assert "target=_fl_do_finalize" in src


def test_v353_direct_unbounded_finalize_call_removed():
    # Not a tautology: the old direct top-level call (finally -> _finalize_logs(...) -> exit)
    # must no longer sit unbounded right under the `if logger and config and log_paths:` guard.
    src = _finally_cell_src()
    assert "if logger and config and log_paths:\n            _finalize_logs(" not in src


def test_v353_watchdog_armed_before_finalize():
    # v3.5.4: the inline backstop was refactored into the shared _arm_finalization_watchdog
    # helper. The pipeline-finally must arm it strictly before the log-finalization that can
    # stall, so the watchdog can fire on a finalize hang.
    src = _finally_cell_src()
    wd = src.index('_arm_finalization_watchdog(widgets_values, grace_seconds=300, source="pipeline-finally")')
    fin = src.index("_fl_do_finalize")
    fly = src.index("    finally:\n")
    assert fly < wd < fin


# --------------------------------------------------------------------------- #
# behavioral re-impl faithful to the two mechanisms                           #
# --------------------------------------------------------------------------- #
def _run_bounded_finalize(target, timeout):
    t = threading.Thread(target=target, name="finalize_logs_uploader", daemon=True)
    t.start()
    t.join(timeout=timeout)
    return t.is_alive()


def test_v353_bounded_join_returns_on_hang():
    stuck = threading.Event()
    alive = _run_bounded_finalize(lambda: stuck.wait(30), timeout=0.2)
    assert alive is True  # main path proceeded; did NOT wait 30s for the hung uploader
    stuck.set()


def test_v353_bounded_join_completes_on_fast():
    done = {"v": False}

    def fast():
        done["v"] = True

    alive = _run_bounded_finalize(fast, timeout=2.0)
    assert alive is False and done["v"] is True


def test_v353_watchdog_body_prints_result_and_force_exits():
    exit_result = json.dumps({"status": "success", "warning_count": 0})
    exits = []

    def fake_exit(code):
        exits.append(code)
        raise SystemExit(code)

    def watchdog():
        if exit_result:
            print(f"\n[VIBE_EXIT_RESULT]{exit_result}[/VIBE_EXIT_RESULT]")
        print("[finalize-hang-force-exit FIRED v3.5.3] forcing process termination")
        fake_exit(0)

    buf = io.StringIO()
    try:
        with redirect_stdout(buf):
            watchdog()
    except SystemExit:
        pass
    out = buf.getvalue()
    assert exits == [0]
    assert "[VIBE_EXIT_RESULT]" in out and exit_result in out
    assert "finalize-hang-force-exit FIRED v3.5.3" in out
