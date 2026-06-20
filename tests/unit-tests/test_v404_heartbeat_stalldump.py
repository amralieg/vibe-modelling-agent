import json
import os
import tempfile
from pathlib import Path

import agent_helpers as ah

PRE = Path("/tmp/agent_v403_backup.ipynb")  # pre-v4.0.4 (v4.0.3) backup, no stall-dump


def _tmp_info():
    f = tempfile.NamedTemporaryFile(mode="w", suffix="_info.log", delete=False)
    f.write("2026-06-20 10:00:00 - INFO - some app line\n")
    f.close()
    return f.name


def test_version_bumped_to_404():
    assert ah.__AGENT_VERSION__ == "4.0.6", ah.__AGENT_VERSION__


def test_noop_when_not_stalled():
    p = _tmp_info()
    try:
        hb = {"last_app": "x"}
        before = os.path.getsize(p)
        out = ah._v404_maybe_stalldump(hb, silent=10, local_info_path=p, threshold=600)
        assert out is False
        assert os.path.getsize(p) == before  # nothing written
    finally:
        os.unlink(p)


def test_dumps_stacks_when_stalled():
    p = _tmp_info()
    try:
        hb = {"last_app": "frozen-line-A"}
        out = ah._v404_maybe_stalldump(hb, silent=900, local_info_path=p, threshold=600)
        assert out is True
        body = open(p).read()
        assert "[HEARTBEAT-STACKDUMP v4.0.4 FIRED]" in body
        assert "alias=heartbeat-stalldump" in body
        assert "--- thread" in body  # at least one thread stack rendered
        assert "app_silent=900s" in body
    finally:
        os.unlink(p)


def test_dumps_once_per_stall_episode():
    p = _tmp_info()
    try:
        hb = {"last_app": "frozen-line-A"}
        assert ah._v404_maybe_stalldump(hb, silent=900, local_info_path=p, threshold=600) is True
        n1 = open(p).read().count("[HEARTBEAT-STACKDUMP v4.0.4 FIRED]")
        # same frozen line -> must NOT re-dump
        assert ah._v404_maybe_stalldump(hb, silent=1200, local_info_path=p, threshold=600) is False
        n2 = open(p).read().count("[HEARTBEAT-STACKDUMP v4.0.4 FIRED]")
        assert n1 == 1 and n2 == 1
    finally:
        os.unlink(p)


def test_rearms_after_app_advances():
    p = _tmp_info()
    try:
        hb = {"last_app": "frozen-line-A"}
        assert ah._v404_maybe_stalldump(hb, silent=900, local_info_path=p, threshold=600) is True
        # app advanced (new last_app) then stalled again -> must re-dump
        hb["last_app"] = "frozen-line-B"
        assert ah._v404_maybe_stalldump(hb, silent=900, local_info_path=p, threshold=600) is True
        assert open(p).read().count("[HEARTBEAT-STACKDUMP v4.0.4 FIRED]") == 2
    finally:
        os.unlink(p)


def test_fail_pre_v403_lacks_stalldump():
    src = "".join("".join(c.get("source", []))
                  for c in json.load(open(PRE))["cells"] if c.get("cell_type") == "code")
    assert "_v404_maybe_stalldump" not in src, "v4.0.3 backup unexpectedly already has the stall-dump"
    assert "heartbeat-stalldump" not in src
