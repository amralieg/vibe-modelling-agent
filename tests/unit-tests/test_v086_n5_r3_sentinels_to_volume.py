"""v0.8.6 N5-FIX — R3 sentinels MUST also reach the volume log file, not
only the driver console (sys.stderr).

Pre-existing v0.8.4 R3 fix (log-no-truncate-on-success) added three
sentinel emissions:
    [VolumeLogFlush] WARNING: ... shrunk ...
    [VolumeLogFlush][SAFE-FLUSH] ...
    [VolumeLogFlush][FINAL-FLUSH] ...

All three were written to sys.stderr only. They never reached the volume
info.log because the file the volume-flush thread copies to UC is the
local info log, and stderr is not piped to that file. Result: an auditor
inspecting volume logs after a run could not grep for these sentinels —
defeating their purpose for post-mortem audit.

This module verifies the v0.8.6 fix: each of the three sentinels must
also be appended to the local INFO log file (`_vl_local_info`) so the
next safe-flush cycle promotes them to volume info.log."""

import json
import re
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_notebook_source(path: Path) -> str:
    nb = json.loads(path.read_text(encoding="utf-8"))
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") == "code":
            parts.extend(cell.get("source", []))
    return "".join(parts)


@pytest.fixture(scope="module")
def agent_src() -> str:
    return _read_notebook_source(NOTEBOOK_PATH)


class TestN5R3SentinelsReachVolumeInfoLog:
    def test_alias_present(self, agent_src):
        assert "r3-sentinels-to-volume" in agent_src
        assert "N5-FIX" in agent_src

    def test_three_n5_callsites_present(self, agent_src):
        # Each of the three sentinel sites (SHRUNK warning, SAFE-FLUSH,
        # FINAL-FLUSH) must have a paired N5-FIX local-file append block.
        n5_blocks = re.findall(r"v0\.8\.6 N5-FIX", agent_src)
        assert len(n5_blocks) >= 3, (
            f"Expected ≥3 N5-FIX call sites (shrunk warning, safe-flush, "
            f"final-flush); found {len(n5_blocks)}."
        )

    def test_n5_writes_to_local_info_log(self, agent_src):
        # All three N5 blocks must append to _vl_local_info (the local INFO
        # log file that the safe-flush loop copies to volume).
        # Count occurrences of the open-append-write pattern targeting
        # _vl_local_info inside the volume-log-flush region.
        appends = re.findall(r"open\(_vl_local_info,\s*'a'\)", agent_src)
        assert len(appends) >= 3, (
            f"Expected ≥3 `open(_vl_local_info, 'a')` calls (one per N5 "
            f"site); found {len(appends)}."
        )

    def test_n5_guards_against_missing_local_path(self, agent_src):
        # Each N5 append must check `_vl_local_info and os.path.exists(...)`
        # so the fix is safe in environments where local logging is disabled.
        guards = re.findall(
            r"if\s+_vl_local_info\s+and\s+os\.path\.exists\(_vl_local_info\)",
            agent_src,
        )
        assert len(guards) >= 3, (
            f"Each N5 append must be guarded by `if _vl_local_info and "
            f"os.path.exists(...)` to handle the no-local-log case; "
            f"found {len(guards)} guards."
        )

    def test_safe_flush_message_is_extracted_to_variable(self, agent_src):
        # Anti-tautology: ensure the SAFE-FLUSH text is captured in a single
        # variable used by BOTH the stderr write AND the local-file append.
        # Otherwise the two paths could drift apart silently.
        assert "_safe_msg = (" in agent_src
        # Both sinks must reference the same variable
        assert agent_src.count("_safe_msg") >= 3  # define + stderr + file

    def test_final_flush_message_is_extracted_to_variable(self, agent_src):
        assert "_final_msg = " in agent_src
        assert agent_src.count("_final_msg") >= 3  # define + stderr + file

    def test_shrunk_message_is_extracted_to_variable(self, agent_src):
        assert "_shrunk_msg = (" in agent_src
        assert agent_src.count("_shrunk_msg") >= 3  # define + stderr + file

    def test_final_flush_n5_appends_BEFORE_final_safe_flush(self, agent_src):
        # The FINAL-FLUSH N5 append MUST come BEFORE the final
        # `_safe_volume_flush(_vl_local_info, _vl_final_info)` call, so the
        # sentinel is included in the very last copy to volume.
        # Search for the FINAL-FLUSH N5 block and confirm it precedes the
        # for-loop that does the final flush.
        n5_final = agent_src.find("_final_msg + \"\\n\"")
        # Find the LAST occurrence (in the final-flush region, not stderr)
        n5_final_lastsink = agent_src.rfind("_nf3.write(_final_msg")
        final_flush_loop = agent_src.find(
            "for _src, _dst in [(_vl_local_info, _vl_final_info), "
            "(_vl_local_error, _vl_final_error)]:\n",
            n5_final_lastsink if n5_final_lastsink > 0 else 0,
        )
        assert n5_final_lastsink > 0, "FINAL-FLUSH local-file append not found"
        assert final_flush_loop > n5_final_lastsink, (
            "FINAL-FLUSH N5 append must precede the final safe-flush loop, "
            "otherwise the sentinel never reaches volume info.log."
        )

    def test_no_self_amplification_explosion(self, agent_src):
        # The N5 fix adds ~140 bytes per flush cycle to local info log,
        # which itself triggers another flush next cycle. We cap concern
        # by NOT writing to local ERROR (only INFO) — verify no N5 block
        # opens _vl_local_error.
        appends_to_error = re.findall(r"open\(_vl_local_error,\s*'a'\)", agent_src)
        assert appends_to_error == [], (
            f"N5 must NOT append to _vl_local_error — that would inflate "
            f"error.log on EVERY flush cycle and obscure real errors. "
            f"Found {len(appends_to_error)} writes to local_error."
        )
