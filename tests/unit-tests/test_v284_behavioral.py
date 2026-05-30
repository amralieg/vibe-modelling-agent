"""Behavioral tests for v2.8.4 — vibe-handling unification (alias=vibe-single-resolver).

One canonical resolve_user_vibe_text(widgets_values) is now THE single read-path for the
user's vibe text across every operation and every consumer. This:
  - replaces the private 5-key assembly _enforce_source_trace_tags added in v2.8.1,
  - replaces the ad-hoc effective/vibe_modelling_instructions read in get_distributed_vibes_for_prompt,
  - documents the single bridge: model_vibes is the ONLY vibe WIDGET; vibe_modelling_instructions
    is the canonical internal key populated by extract_vibe_modelling_instructions.

Tests extract the actual shipped function and exercise both precedence and concat modes.
"""
import json
import re
from pathlib import Path

NB_PATH = Path(__file__).parent.parent.parent / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _nb_src():
    cells = json.loads(NB_PATH.read_text()).get("cells", [])
    return "\n".join("".join(c.get("source", [])) for c in cells if c.get("cell_type") == "code")


def _resolver():
    src = _nb_src()
    start = src.find("def resolve_user_vibe_text(")
    assert start > 0, "resolve_user_vibe_text not defined"
    nxt = src.find("\ndef ", start + 1)
    block = src[start:nxt]
    ns = {"_resolve_vibes_from_file": lambda x: x}  # identity stub (file resolution tested elsewhere)
    exec(compile(block, "<resolver>", "exec"), ns)
    return ns["resolve_user_vibe_text"]


# ---------------- version + uniqueness ----------------

def test_agent_version_284():
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', _nb_src())
    assert m and tuple(int(x) for x in m.group(1).split(".")) >= (2, 8, 4), m.group(1) if m else "missing"


def test_only_one_vibe_widget():
    """model_vibes is the ONLY vibe widget; vibe_modelling_instructions must NOT be a widget."""
    src = _nb_src()
    assert 'dbutils.widgets.text("model_vibes"' in src
    assert 'dbutils.widgets.text("vibe_modelling_instructions"' not in src
    assert 'dbutils.widgets.dropdown("vibe_modelling_instructions"' not in src
    # registered widget list contains model_vibes, not the internal key
    wl = src[src.find("_NOTEBOOK_WIDGET_NAMES = ["): src.find("_NOTEBOOK_WIDGET_NAMES = [") + 600]
    assert '"model_vibes"' in wl
    assert '"vibe_modelling_instructions"' not in wl


# ---------------- single-resolver wiring (DRY) ----------------

def test_consumers_route_through_single_resolver():
    src = _nb_src()
    # the source-trace enforcer's private 5-key assembly is GONE
    assert '_vibe_parts.append(_vv)' not in src, "private source-trace vibe assembly must be removed"
    # both consumers call the canonical resolver
    assert "resolve_user_vibe_text(widgets_values, include_business_description=True, concat=True)" in src
    assert "raw = resolve_user_vibe_text(widgets_values)" in src
    # distributor's old inline read is gone
    assert 'raw = widgets_values.get("effective_vibe_modelling_instructions", widgets_values.get("vibe_modelling_instructions", ""))' not in src


# ---------------- behavioral: precedence ----------------

def test_precedence_first_non_empty_wins():
    r = _resolver()
    assert r({"model_vibes": "MV"}) == "MV"
    assert r({"vibe_modelling_instructions": "CANON", "model_vibes": "MV"}) == "CANON"
    assert r({"effective_vibe_modelling_instructions": "EFF",
              "vibe_modelling_instructions": "CANON", "model_vibes": "MV"}) == "EFF"
    # whitespace-only is skipped
    assert r({"effective_vibe_modelling_instructions": "   ", "model_vibes": "MV"}) == "MV"


def test_business_description_gated():
    r = _resolver()
    wv = {"business_description": "BIZ DESC"}
    assert r(wv) == ""  # not a vibe by default
    assert r(wv, include_business_description=True) == "BIZ DESC"


def test_concat_joins_all_sources_for_source_trace():
    r = _resolver()
    wv = {"model_vibes": "DDL CREATE t(...)", "business_description": "summary referencing the DDL"}
    out = r(wv, include_business_description=True, concat=True)
    assert "DDL CREATE t(...)" in out and "summary referencing the DDL" in out
    assert out.count("DDL CREATE t(...)") == 1  # dedup
    # concat does NOT file-resolve (raw join), and joins with blank line
    assert "\n\n" in out


def test_non_dict_and_empty():
    r = _resolver()
    assert r(None) == "" and r("nope") == "" and r({}) == ""
    # dedup: same text under two keys appears once in concat
    assert r({"model_vibes": "X", "model_vibes_source": "X"}, concat=True) == "X"
