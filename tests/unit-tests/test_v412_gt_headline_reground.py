"""v4.1.2 behavioral tests -- gt-headline-reground.

ROOT CAUSE (automotive v3 <profile> run): the headline `vibe_orchestrator_scored`
event reported precision 0.5935 while the PHYSICAL model scored 0.805. Eight
move_product VReqs landed AFTER the mid-loop audit_all emitted the scoreboard;
the LATE verifier-move-product re-audit recognized them, but the headline event
was NEVER re-emitted, so every downstream consumer (marathon vov_audit_extract,
UI _vibe_progress, the audit) read the STALE pessimistic mid-loop number. Same
lying-scoreboard class the MISSION names #1, here biased PESSIMISTIC.

Fix: `_run_ground_truth_audit` re-emits `vibe_orchestrator_scored` from the
AUTHORITATIVE physical ground-truth tallies, combining physical + mid-loop
verdicts per-VReq so generative/LLM-grounded VReqs are not lost, and never
inflates (precision = fulfilled/total so unknown/partial/failed all count
against).

Each test proves fail-pre on the committed v4.1.1 backup and pass-post on the
live notebook (§8.10).
"""
import ast
import json
import re
import types
from pathlib import Path

import agent_helpers as ah

PRE = Path("/tmp/agent_v411_backup.ipynb")  # committed v4.1.1, no v4.1.2 fixes


def _load_backup_module(path: Path):
    if not path.exists():
        import pytest
        pytest.skip(f"pre-patch backup {path} absent (ephemeral /tmp dev artifact); fail-pre half historical, pass-post protects live behavior")
    nb = json.loads(path.read_bytes().decode("utf-8"))
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        if src.strip():
            parts.append(src)
    source = "\n\n".join(parts)
    mod = types.ModuleType("agent_helpers_v411")
    _BLOCKED = {"pyspark", "databricks", "delta", "pandas", "numpy", "IPython",
                "ipywidgets", "matplotlib", "plotly"}
    tree = ast.parse(source)
    for node in tree.body:
        if isinstance(node, (ast.Import, ast.ImportFrom)):
            continue
        if not isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef, ast.Assign)):
            continue
        try:
            exec(compile(ast.Module(body=[node], type_ignores=[]), str(path), "exec"), mod.__dict__)
        except Exception:
            pass
    return mod


# ============================== version =====================================
def test_version_bumped_to_412():
    assert tuple(int(x) for x in ah.__AGENT_VERSION__.split(".")) >= (4, 1, 3), ah.__AGENT_VERSION__


# ===================== _v412_combine_verdict (FAILPRE) ======================
def test_combine_verdict_absent_pre_patch_FAILPRE():
    mod = _load_backup_module(PRE)
    assert not hasattr(mod, "_v412_combine_verdict"), "v4.1.1 must NOT have the combine helper"
    assert not hasattr(mod, "_v412_build_reground_scorecard"), "v4.1.1 must NOT have the scorecard helper"


# ===================== _v412_combine_verdict (POST) =========================
def test_physical_grounds_recovers_unknown_to_midloop_POST():
    # physical 'unknown' (cannot deterministically check, e.g. generative/LLM-grounded)
    # -> retain the mid-loop verdict so those VReqs survive into the headline.
    assert ah._v412_combine_verdict("unknown", "fulfilled") == "fulfilled"
    assert ah._v412_combine_verdict("unknown", "partial") == "partial"
    assert ah._v412_combine_verdict("", "fulfilled") == "fulfilled"


def test_physical_authoritative_when_it_grounds_POST():
    # physical GROUNDS the VReq (reads information_schema) -> it WINS, even when the
    # mid-loop LLM verdict is more optimistic. This is the anti-lying direction.
    assert ah._v412_combine_verdict("failed", "fulfilled") == "failed"
    assert ah._v412_combine_verdict("partial", "fulfilled") == "partial"
    # ... and when physical confirms a move the stale mid-loop missed, physical wins UP too.
    assert ah._v412_combine_verdict("fulfilled", "partial") == "fulfilled"


def test_both_unknown_stays_unknown_POST():
    assert ah._v412_combine_verdict("unknown", "unknown") == "unknown"
    assert ah._v412_combine_verdict(None, None) == "unknown"


# ================= _v412_build_reground_scorecard (POST) ====================
def test_reground_scorecard_never_inflates_POST():
    # unknown/partial/failed ALL count against precision (fulfilled/total); the
    # headline can NEVER inflate by hiding ungrounded VReqs.
    card = ah._v412_build_reground_scorecard(
        total=100, fulfilled=80, partial=0, failed=0, unknown=20, scored=80, pct=80.0)
    assert card["precision"] == 0.8, card
    assert card["precision_honest"] == 0.8
    assert card["total_requirements"] == 100
    assert card["fulfilled"] == 80 and card["fulfilled_count"] == 80
    assert card["adherence_source"] == "physical_ground_truth"


def test_reground_scorecard_recovers_stale_automotive_pessimism_POST():
    # automotive v3: mid-loop emitted 0.5935; physical audit found 99/123 fulfilled.
    card = ah._v412_build_reground_scorecard(
        total=123, fulfilled=99, partial=14, failed=10, unknown=0, scored=123, pct=80.5)
    assert card["precision"] == round(99 / 123, 4), card  # 0.8049, not the stale 0.5935
    assert card["physical_adherence_pct"] == 80.5


def test_reground_scorecard_passes_unfulfilled_details_POST():
    dets = [{"id": "VREQ-7", "text": "move x", "evidence": "", "status": "partial"}]
    card = ah._v412_build_reground_scorecard(
        total=10, fulfilled=9, partial=1, failed=0, unknown=0, scored=10, pct=90.0,
        unfulfilled_details=dets)
    assert card["unfulfilled_details"] == dets


def test_reground_scorecard_empty_total_safe_POST():
    card = ah._v412_build_reground_scorecard(
        total=0, fulfilled=0, partial=0, failed=0, unknown=0, scored=0, pct=0.0)
    assert card["precision"] == 0.0
    assert card["coverage"] == 0.0


# ===================== live-source wiring (POST) ============================
def test_audit_reemits_headline_from_physical_POST(agent_source_text):
    src = agent_source_text
    assert "gt-headline-reground FIRED v4.1.2" in src
    # the re-emit must call emit_vibe_event with the scored event from the reground card
    assert '_v412_build_reground_scorecard(' in src
    # the combine helper is wired into the tally (not dead code)
    assert "_v412_combine_verdict(st," in src


def test_reemit_after_scorecard_store_POST(agent_source_text):
    src = agent_source_text
    store_at = src.find('widgets_values["_ground_truth_scorecard"] = scorecard')
    emit_at = src.find("gt-headline-reground FIRED v4.1.2")
    assert store_at != -1 and emit_at != -1
    assert emit_at > store_at, "headline re-emit must run AFTER the scorecard is stored (late audit)"
