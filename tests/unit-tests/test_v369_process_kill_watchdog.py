import json
import os
import re
import subprocess
import sys
import tempfile
import textwrap
import time

import pytest

NB = os.path.join(
    os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb"
)


def _extract_func_source(func_name):
    nb = json.load(open(NB))
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        src = "".join(c.get("source", []))
        if f"def {func_name}" not in src:
            continue
        lines = src.splitlines(keepends=True)
        out, capturing, indent = [], False, None
        for ln in lines:
            if ln.lstrip().startswith(f"def {func_name}"):
                capturing = True
                indent = len(ln) - len(ln.lstrip())
                out.append(ln)
                continue
            if capturing:
                stripped = ln.strip()
                cur_indent = len(ln) - len(ln.lstrip())
                # stop at next top-level def/class at same indent
                if stripped and cur_indent <= indent and (
                    stripped.startswith("def ") or stripped.startswith("class ")
                ):
                    break
                out.append(ln)
        return textwrap.dedent("".join(out))
    raise AssertionError(f"{func_name} not found in notebook")


def test_watchdog_source_present_and_parses():
    src = _extract_func_source("_spawn_process_kill_watchdog")
    assert "os.getppid()" in src, "PID-reuse safety guard missing"
    assert "SIGTERM" in src and "SIGKILL" in src, "must escalate SIGTERM->SIGKILL"
    assert "subprocess" in src or "Popen" in src, "must spawn a SEPARATE OS PROCESS"
    compile(src, "<watchdog>", "exec")


def _run_parent(arm: bool, grace: int, parent_sleep: int):
    """Launch a parent process that optionally arms the kill-watchdog then sleeps.

    Returns (popen, start_time). Caller polls popen.poll().
    """
    func_src = _extract_func_source("_spawn_process_kill_watchdog")
    arm_call = (
        f"_spawn_process_kill_watchdog({grace}, 'test')" if arm else "pass  # not armed"
    )
    script = (
        func_src
        + "\n\nif __name__ == '__main__':\n"
        + f"    {arm_call}\n"
        + f"    import time as _t; _t.sleep({parent_sleep})\n"
    )
    f = tempfile.NamedTemporaryFile(
        "w", suffix="_parent.py", delete=False
    )
    f.write(script)
    f.close()
    p = subprocess.Popen([sys.executable, f.name])
    return p, time.time(), f.name


def test_armed_watchdog_kills_hung_parent():
    # PASS-POST: parent arms watchdog (grace=2s) then hangs for 60s.
    # The external killer process must SIGTERM/SIGKILL it well before 60s.
    p, t0, path = _run_parent(arm=True, grace=2, parent_sleep=60)
    try:
        deadline = t0 + 45  # grace(2)+SIGTERM wait(25)+SIGKILL margin
        rc = None
        while time.time() < deadline:
            rc = p.poll()
            if rc is not None:
                break
            time.sleep(0.5)
        elapsed = time.time() - t0
        assert rc is not None, (
            f"armed parent still alive after {elapsed:.0f}s — watchdog did NOT fire"
        )
        assert elapsed < 45, f"killed too late ({elapsed:.0f}s)"
        # killed by signal => negative returncode on POSIX
        assert rc != 0 or os.name != "posix", f"expected signal-kill, got rc={rc}"
    finally:
        if p.poll() is None:
            p.kill()
        try:
            os.unlink(path)
        except OSError:
            pass


def test_unarmed_parent_survives_negative_control():
    # FAIL-PRE proxy: WITHOUT arming, nothing kills the parent. At t≈6s
    # (grace=2 + SIGTERM=25 window) an armed parent would already be dead;
    # the unarmed parent must still be alive, proving the kill is attributable
    # to the watchdog and not ambient teardown.
    p, t0, path = _run_parent(arm=False, grace=2, parent_sleep=30)
    try:
        time.sleep(6)
        assert p.poll() is None, "unarmed parent died unexpectedly (not a clean control)"
    finally:
        if p.poll() is None:
            p.kill()
            p.wait(timeout=5)
        try:
            os.unlink(path)
        except OSError:
            pass


def test_armed_into_arm_finalization_and_safe_exit():
    nb = json.load(open(NB))
    src = "".join(
        "".join(c.get("source", []))
        for c in nb["cells"]
        if c.get("cell_type") == "code"
    )
    # both teardown paths must wire the GIL-independent backstop
    assert "_spawn_process_kill_watchdog(int(grace_seconds)" in src, (
        "_arm_finalization_watchdog must call the process killer"
    )
    assert "_spawn_process_kill_watchdog(240" in src, (
        "_safe_notebook_exit must call the process killer"
    )


if __name__ == "__main__":
    sys.exit(pytest.main([__file__, "-v"]))
