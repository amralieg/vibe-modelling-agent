"""Behavioral tests for v0.6.9 — global __AGENT_VERSION__ traceability.

The v0.6.9 patch wires a single source-of-truth version constant into the
agent notebook (Cell 1, FIRST line of code) and mirrors it as the FIRST
top-level property of every generated model.json. CLAUDE.md §3a-bis codifies
the rule going forward.

Aliases tested:
  - agent-version-global   (constant + Cell 1 first-line position)
  - agent-version-mirror   (model.json `agent_version` first key + FIRED log)
"""

import json
import re
from pathlib import Path

AGENT = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"
README = Path(__file__).resolve().parents[2] / "readme.md"
CLAUDE_MD = Path(__file__).resolve().parents[2] / "CLAUDE.md"

EXPECTED_VERSION = "0.6.9"


def _agent_cells():
    with AGENT.open() as f:
        nb = json.load(f)
    return nb.get("cells", [])


def _cell_source(cell):
    src = cell.get("source", "")
    return "".join(src) if isinstance(src, list) else src


def _agent_text():
    return "\n".join(
        _cell_source(c) for c in _agent_cells()
    )


def _first_code_cell_source():
    for c in _agent_cells():
        if c.get("cell_type") == "code":
            s = _cell_source(c)
            if s.strip():
                return s
    raise AssertionError("No non-empty code cell found in agent notebook")


def test_v069_constant_value_matches_expected():
    txt = _agent_text()
    pat = re.compile(r'__AGENT_VERSION__\s*=\s*"([^"]+)"')
    m = pat.search(txt)
    assert m is not None, "__AGENT_VERSION__ constant not found in agent notebook"
    assert m.group(1) == EXPECTED_VERSION, (
        f"__AGENT_VERSION__ value '{m.group(1)}' != expected '{EXPECTED_VERSION}'"
    )


def test_v069_constant_is_first_code_line_in_cell1():
    src = _first_code_cell_source()
    lines = [ln for ln in src.splitlines() if ln.strip()]
    code_lines = [ln for ln in lines if not ln.lstrip().startswith("#")]
    assert code_lines, "First code cell has no executable lines"
    first = code_lines[0]
    assert first.startswith("__AGENT_VERSION__"), (
        f"First non-comment statement in Cell 1 must be __AGENT_VERSION__; got: {first!r}"
    )


def test_v069_constant_is_single_digit_semver():
    assert re.fullmatch(r"\d\.\d\.\d", EXPECTED_VERSION), (
        f"EXPECTED_VERSION '{EXPECTED_VERSION}' violates §3a single-digit semver"
    )
    txt = _agent_text()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', txt)
    assert m and re.fullmatch(r"\d\.\d\.\d", m.group(1)), (
        "__AGENT_VERSION__ literal violates §3a single-digit semver"
    )


def test_v069_alias_global_present():
    txt = _agent_text()
    assert "agent-version-global" in txt, "alias 'agent-version-global' missing"


def test_v069_alias_mirror_present():
    txt = _agent_text()
    assert "agent-version-mirror" in txt, "alias 'agent-version-mirror' missing"


def test_v069_fired_marker_present():
    txt = _agent_text()
    assert "[agent-version-mirror FIRED]" in txt, (
        "[agent-version-mirror FIRED] log marker missing"
    )


def test_v069_model_json_root_has_agent_version_first_key():
    txt = _agent_text()
    pat = re.compile(
        r'model_json_root\s*=\s*\{\s*"agent_version"\s*:\s*__AGENT_VERSION__\s*,\s*'
        r'"model_requirements"',
        re.MULTILINE,
    )
    assert pat.search(txt), (
        "model_json_root dict literal must have 'agent_version' as the FIRST key, "
        "before 'model_requirements'"
    )


def test_v069_metric_view_writeback_refreshes_agent_version():
    txt = _agent_text()
    assert (
        '"agent_version" in _mj_root' in txt
        and '_mj_root["agent_version"] = __AGENT_VERSION__' in txt
        and '_mj_root = {"agent_version": __AGENT_VERSION__, **_mj_root}' in txt
    ), "metric-view writeback path must refresh/prepend agent_version"


def test_v069_install_metric_cleanup_refreshes_agent_version():
    txt = _agent_text()
    assert (
        '"agent_version" in _parsed_root' in txt
        and '_parsed_root["agent_version"] = __AGENT_VERSION__' in txt
        and '_parsed_root = {"agent_version": __AGENT_VERSION__, **_parsed_root}' in txt
    ), "install metric-view cleanup writeback must refresh/prepend agent_version"


def test_v069_install_location_writeback_refreshes_agent_version():
    txt = _agent_text()
    assert (
        '"agent_version" in _updated_root' in txt
        and '_updated_root["agent_version"] = __AGENT_VERSION__' in txt
        and '_updated_root = {"agent_version": __AGENT_VERSION__, **_updated_root}' in txt
    ), "install location writeback must refresh/prepend agent_version"


def test_v069_no_two_digit_semver_in_constant():
    txt = _agent_text()
    bad = re.search(r'__AGENT_VERSION__\s*=\s*"\d+\.\d{2,}', txt)
    assert bad is None, (
        "Two-digit segment in __AGENT_VERSION__ violates §3a single-digit semver"
    )
    bad2 = re.search(r'__AGENT_VERSION__\s*=\s*"\d{2,}\.', txt)
    assert bad2 is None, (
        "Two-digit major segment in __AGENT_VERSION__ violates §3a single-digit semver"
    )


def test_v069_readme_current_version_matches():
    text = README.read_text(encoding="utf-8")
    assert f"Current version: **v{EXPECTED_VERSION}**" in text, (
        f"readme.md 'Current version' line must reference v{EXPECTED_VERSION}"
    )


def test_v069_readme_history_row_present():
    text = README.read_text(encoding="utf-8")
    assert f"| **v{EXPECTED_VERSION}** |" in text, (
        f"readme.md Version-history table must have a row for v{EXPECTED_VERSION}"
    )


def test_v069_claude_md_documents_rule():
    text = CLAUDE_MD.read_text(encoding="utf-8")
    assert "## 3a-bis. Global `__AGENT_VERSION__` constant" in text, (
        "CLAUDE.md must document §3a-bis __AGENT_VERSION__ rule"
    )
    assert "agent-version-global" in text, (
        "CLAUDE.md §3a-bis must reference agent-version-global alias"
    )


def test_v069_simulated_model_json_serializes_agent_version_first():
    """Simulate the model_json_root assembly and confirm json.dump preserves
    insertion order with agent_version first."""
    __AGENT_VERSION__ = EXPECTED_VERSION
    model_json_root = {
        "agent_version": __AGENT_VERSION__,
        "model_requirements": {"business_name": "test"},
        "_vibe_session_metadata": {"status": "test"},
        "model": {"type": "business", "name": "test", "domains": []},
    }
    s = json.dumps(model_json_root, indent=2)
    parsed = json.loads(s)
    keys = list(parsed.keys())
    assert keys[0] == "agent_version", (
        f"agent_version must be the FIRST top-level key; got {keys}"
    )
    assert parsed["agent_version"] == EXPECTED_VERSION


def test_v069_simulated_rewrite_path_refreshes_stale_agent_version():
    """Simulate the rewrite-path logic that an older model.json gets re-stamped."""
    __AGENT_VERSION__ = EXPECTED_VERSION
    stale = {
        "agent_version": "0.6.5",
        "model_requirements": {},
        "model": {},
    }
    if "agent_version" in stale:
        stale["agent_version"] = __AGENT_VERSION__
    else:
        stale = {"agent_version": __AGENT_VERSION__, **stale}
    assert stale["agent_version"] == EXPECTED_VERSION
    keys = list(stale.keys())
    assert keys[0] == "agent_version"


def test_v069_simulated_rewrite_path_prepends_when_missing():
    __AGENT_VERSION__ = EXPECTED_VERSION
    legacy = {"model_requirements": {}, "model": {}}
    if "agent_version" in legacy:
        legacy["agent_version"] = __AGENT_VERSION__
    else:
        legacy = {"agent_version": __AGENT_VERSION__, **legacy}
    assert list(legacy.keys())[0] == "agent_version"
    assert legacy["agent_version"] == EXPECTED_VERSION


def test_v069_prior_aliases_preserved():
    """Regression — every v0.6.x alias from prior fixes must still be present."""
    txt = _agent_text()
    prior_aliases = [
        "vibe-version-must-advance",
        "perf-cap-16",
        "perf-llm-throttle-16",
        "perf-mv15-parallel",
        "immutable-early-exit",
        "ssot-stem-autofix",
        "llm-json-recoverable",
        "collision-naming-canonical",
        "fmfl-canonical-target",
        "surgical-mv-preserve",
        "surgical-mv-rewrite",
        "fmfl-auto-coerce-keep",
        "log-append-on-retry",
    ]
    missing = [a for a in prior_aliases if a not in txt]
    assert not missing, f"Prior v0.6.x aliases missing from notebook: {missing}"
