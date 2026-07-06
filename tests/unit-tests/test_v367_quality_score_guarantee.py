"""Behavioral tests for v3.6.7 Fix#6 (alias=quality-score-guarantee).

ROOT CAUSE under test (I4 monotonic-improvement audit WARN "no quality score parseable"):
the single next_vibes.txt writer `_build_next_vibes_txt()` assembles its text from
`next_vibe_response["vibe_modelling_instructions"]`. On the LLM path that string is prefixed with
the deterministic `**Model Quality Score: N/100**` line, but on the TWO rule-based fallback
branches (no AIAgent / empty LLM response) the instructions are built WITHOUT a score line. Those
terminal models therefore write a next_vibes.txt with no parseable score, so the version-over-version
"model must get better" audit (_i4_score_monotonic / _parse_score) cannot run.

The fix guarantees a parseable score at the single write choke-point: if the assembled text lacks a
"Model Quality Score: N/100" line, prepend a deterministic one from confidence_score (which is
always set, deterministically, before this writer runs).

These tests extract the REAL nested `_build_next_vibes_txt` from the notebook and run it end-to-end
in a faithful closure (not a stub). They FAIL on pre-patch HEAD (no guarantee) and pass post-patch.
"""
import json
import os
import re
import textwrap

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")

# The exact regex the I4 audit uses to parse the score (must stay in sync with _parse_score).
_I4_SCORE_RE = re.compile(r"Model Quality Score:\s*\**\s*([\d.]+)\s*/\s*100")


def _load_src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _extract_build_next_vibes(src):
    m = re.search(
        r"\n        def _build_next_vibes_txt\(\):\n.*?\n            return \"\\n\"\.join\(lines\)\n",
        src,
        re.DOTALL,
    )
    assert m, "could not extract _build_next_vibes_txt from notebook"
    return textwrap.dedent(m.group(0).lstrip("\n"))


class _FakeLogger:
    def __init__(self):
        self.lines = []

    def info(self, m):
        self.lines.append(str(m))

    def warning(self, m):
        self.lines.append(str(m))


def _run(next_vibe_response, widgets_values=None, missed=None):
    src = _load_src()
    body = _extract_build_next_vibes(src)
    logger = _FakeLogger()
    g = {
        "re": re,
        "next_vibe_response": next_vibe_response,
        "widgets_values": widgets_values or {},
        "_v304_vibe_missed_rollup": (lambda wv: (missed or [])),
        "logger": logger,
    }
    exec(body, g)
    return g["_build_next_vibes_txt"](), logger.lines


def test_extraction_and_wiring_present():
    src = _load_src()
    assert "alias=quality-score-guarantee" in src
    # exactly one guarantee site (the single next_vibes writer); alias appears in comment + log + assert-free
    assert src.count("quality-score-guarantee") >= 2
    # the guard reads confidence_score and the I4-compatible score regex
    body = _extract_build_next_vibes(src)
    assert "next_vibe_response.get(\"confidence_score\"" in body
    assert "Model Quality Score:" in body
    from version_test_util import assert_version_at_least
    assert_version_at_least("3.6.7")


def test_fallback_no_score_gets_guaranteed_score():
    # rule-based fallback branch: instructions carry NO score line (the live healthcare gap)
    resp = {
        "vibe_modelling_instructions": "VALIDATION MODE - Validate the model. Do NOT drop any domains.",
        "data_modeler_notes": "Deterministic score: 72/100",
        "confidence_score": 72,
    }
    txt, logs = _run(resp)
    m = _I4_SCORE_RE.search(txt)
    assert m is not None, f"no parseable score after guarantee:\n{txt}"
    assert float(m.group(1)) == 72.0
    assert any("quality-score-guarantee FIRED" in l for l in logs), logs


def test_existing_score_not_duplicated():
    # LLM path: instructions already carry the score -> guard must NOT add a second one
    resp = {
        "vibe_modelling_instructions": "**Model Quality Score: 85/100**\n\n1. fix something",
        "data_modeler_notes": "",
        "confidence_score": 85,
    }
    txt, logs = _run(resp)
    assert len(_I4_SCORE_RE.findall(txt)) == 1, txt
    assert float(_I4_SCORE_RE.search(txt).group(1)) == 85.0
    assert not any("quality-score-guarantee FIRED" in l for l in logs), logs


def test_missing_confidence_defaults_to_zero_but_parseable():
    # confidence_score absent/None -> still writes a parseable score so the I4 audit never WARNs
    resp = {
        "vibe_modelling_instructions": "MODEL CHECKUP - fix issues.",
        "data_modeler_notes": "",
    }
    txt, logs = _run(resp)
    m = _I4_SCORE_RE.search(txt)
    assert m is not None, txt
    assert 0.0 <= float(m.group(1)) <= 100.0
    assert any("quality-score-guarantee FIRED" in l for l in logs), logs


def test_guaranteed_score_is_first_line_for_audit():
    # I4 parses the whole text, but a leading score line is the contract the LLM path also emits
    resp = {
        "vibe_modelling_instructions": "VALIDATION MODE - nothing to do.",
        "data_modeler_notes": "",
        "confidence_score": 90,
    }
    txt, _ = _run(resp)
    assert txt.lstrip().startswith("**Model Quality Score: 90/100**"), txt[:120]
