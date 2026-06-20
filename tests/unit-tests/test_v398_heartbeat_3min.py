import json
import os
import re
import textwrap
import time
from pathlib import Path

import pytest

REPO = Path(__file__).resolve().parents[2]
NB = REPO / "agent" / "dbx_vibe_modelling_agent.ipynb"
PRE = Path("/tmp/agent_pre_v398.ipynb")


def _concat(nb_path):
    nb = json.loads(Path(nb_path).read_text(encoding="utf-8"))
    out = []
    for c in nb.get("cells", []):
        if c.get("cell_type") == "code":
            s = c.get("source", "")
            out.append("".join(s) if isinstance(s, list) else s)
    return "\n\n".join(out)


def _extract_nested(src, signature):
    """Return dedented source of a nested function starting at `signature`."""
    lines = src.splitlines(keepends=True)
    start = None
    base_indent = None
    for i, ln in enumerate(lines):
        if ln.lstrip().startswith(signature):
            start = i
            base_indent = len(ln) - len(ln.lstrip())
            break
    assert start is not None, f"{signature!r} not found"
    block = [lines[start]]
    for ln in lines[start + 1:]:
        if ln.strip() == "":
            block.append(ln)
            continue
        indent = len(ln) - len(ln.lstrip())
        if indent <= base_indent:
            break
        block.append(ln)
    return textwrap.dedent("".join(block))


@pytest.fixture(scope="module")
def src():
    return _concat(NB)


def _make_emit(src, log_path, hb_state):
    fn_src = _extract_nested(src, "def _emit_heartbeat():")
    ns = {
        "os": os,
        "_hb_time": time,
        "_hb_state": hb_state,
        "_vl_local_info": str(log_path),
    }
    exec(compile(fn_src, "emit_hb", "exec"), ns)
    return ns["_emit_heartbeat"]


def test_heartbeat_writes_alive_line(tmp_path, src):
    log = tmp_path / "info.log"
    log.write_text("2026-06-20 10:00:00 - INFO - Step 9: Physical Schema Construction\n")
    st = {"run_start": time.time() - 600, "last_app": None, "last_app_change": time.time(), "n": 0}
    emit = _make_emit(src, log, st)
    emit()
    txt = log.read_text()
    hb = [l for l in txt.splitlines() if "[HEARTBEAT v3.9.8]" in l]
    assert len(hb) == 1, txt
    assert "alias=heartbeat-3min" in hb[0]
    assert "alive" in hb[0]
    assert "elapsed=0.1" in hb[0]
    # last real app line is surfaced so a reader sees the current stage
    assert "Physical Schema Construction" in hb[0]


def test_heartbeat_flags_stall_when_app_silent(tmp_path, src):
    log = tmp_path / "info.log"
    frozen = "2026-06-20 10:47:16 - INFO - Model finalization complete"
    log.write_text(frozen + "\n")
    # app last changed 400s ago and the frozen line already recorded -> silent >= 300 -> STALL?
    st = {"run_start": time.time() - 7200, "last_app": frozen,
          "last_app_change": time.time() - 400, "n": 5}
    emit = _make_emit(src, log, st)
    emit()
    hb = [l for l in log.read_text().splitlines() if "[HEARTBEAT v3.9.8]" in l]
    assert hb and "STALL?" in hb[0], hb
    assert "Model finalization complete" in hb[0]


def test_heartbeat_ignores_own_and_flush_lines_for_stall(tmp_path, src):
    log = tmp_path / "info.log"
    app = "2026-06-20 10:47:16 - INFO - Step 9 DDL"
    log.write_text(app + "\n")
    st = {"run_start": time.time() - 3600, "last_app": None, "last_app_change": time.time(), "n": 0}
    emit = _make_emit(src, log, st)
    emit()  # records app line, resets last_app_change to now
    # append flush + heartbeat noise only; no new APP line
    with open(log, "a") as f:
        f.write("[VolumeLogFlush][SAFE-FLUSH] dst=x prev=1 cur=2 delta=+1\n")
    st["last_app_change"] = time.time() - 350  # simulate 350s since last real app line
    emit()
    hb = [l for l in log.read_text().splitlines() if "[HEARTBEAT v3.9.8]" in l]
    # second heartbeat must still see the SAME app line (flush noise ignored) -> STALL?
    assert "STALL?" in hb[-1], hb


def test_loop_calls_heartbeat_every_sixth_flush(src):
    # the 30s flush loop must invoke the heartbeat on every 6th tick (=180s=3min)
    assert "_flush_count[\"n\"] % 6 == 0" in src
    assert "_emit_heartbeat()" in src


def test_fail_pre_heartbeat_absent_in_pre_patch():
    if not PRE.exists():
        pytest.skip("pre-patch backup not present")
    pre = _concat(PRE)
    assert "_emit_heartbeat" not in pre
    assert "heartbeat-3min" not in pre


def test_version_bumped_to_398(src):
    assert '__AGENT_VERSION__ = "3.9.9"' in src
