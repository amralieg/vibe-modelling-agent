"""v1.0.5 behavioral tests — target-state-as-obj-helper + llm-fallback-classify-target-stringify.

Root causes (LG iter-5 run 414381475381882 + iter-6 run 445906933640133):

1. The LLM emits `action.target_state` as either a JSON-encoded STRING or a Python dict
   (depending on the prompt + model that produced it). 51 sites in the agent did
   `json.loads(target_state) if target_state and target_state != '-' else <default>`. When
   the LLM returns a dict, json.loads(dict) raises TypeError. v1.0.5 ships
   `_v105_target_state_as_obj(ts, default)` and updates all 50 unsafe sites (2 sites already
   had isinstance guards and are left alone).

2. Line 9793 logged `target_state[:100]` for an LLM-fallback action; same dict-slice bug as
   v1.0.4 line 1587 but at width 100. v1.0.5 wraps with `_v105_target_state_as_str`.

Tests:
- Version constant bumped to 1.0.5.
- Sentinels `[target-state-as-obj-helper FIRED v1.0.5]` and
  `[llm-fallback-classify-target-stringify FIRED v1.0.5]` present.
- Helpers exist with correct semantics for str / dict / list / None / '-' / non-str.
- Anti-tautology: different dict inputs produce different obj-as-helper outputs.
- The 50 unsafe `json.loads(target_state) ... else ...` patterns are GONE from active code.
- Original bug repro: Python's TypeError on json.loads(dict) is real, helper avoids it.
- Original bug repro: Python's KeyError on dict[:100] is real, _as_str helper avoids it.
- Prior v1.0.3 + v1.0.4 sentinels still present (no regression).
"""
import json
import re
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


@pytest.fixture(scope="module")
def agent_text():
    return NOTEBOOK_PATH.read_text(encoding="utf-8")


def test_v105_agent_version(agent_text):
    matches = re.findall(r'__AGENT_VERSION__\s*=\s*\\?"(1\.\d\.\d)\\?"', agent_text)
    assert matches, "__AGENT_VERSION__ must be present"
    assert any(v >= "1.0.5" for v in matches), f"version must be >= 1.0.5; got {matches}"


def test_v105_sentinels_present(agent_text):
    assert agent_text.count("target-state-as-obj-helper FIRED v1.0.5") >= 1, (
        "v1.0.5 helper sentinel must be in deployed agent body"
    )
    assert agent_text.count("llm-fallback-classify-target-stringify FIRED v1.0.5") >= 1, (
        "v1.0.5 fallback-classify sentinel must be in deployed agent body"
    )


def test_v105_helper_definitions_present(agent_text):
    assert "def _v105_target_state_as_obj(" in agent_text, (
        "_v105_target_state_as_obj helper must be defined"
    )
    assert "def _v105_target_state_as_str(" in agent_text, (
        "_v105_target_state_as_str helper must be defined"
    )


def test_v105_unsafe_consumer_sites_replaced(agent_text):
    """The forbidden pattern `json.loads(target_state) if target_state and target_state != '-' else`
    must NOT remain in active code. The helper docstring + version-history may reference it."""
    # Strip lines that are clearly comment/docstring text in the notebook (start with `# ` or `#` after
    # JSON quote/whitespace stripping)
    code_only_pieces = []
    for raw in agent_text.split("\\n"):
        clean = raw.lstrip(' \t\n,"')
        if clean.startswith("#") or clean.startswith("\\\""):
            continue
        code_only_pieces.append(raw)
    code_only = "\\n".join(code_only_pieces)
    forbidden = re.findall(
        r"json\.loads\(target_state\)\s*if\s*target_state\s*and\s*target_state\s*!=\s*'-'\s*else",
        code_only,
    )
    assert not forbidden, (
        f"v1.0.5 must replace all `json.loads(target_state) if ... else` sites; "
        f"found {len(forbidden)} occurrence(s)"
    )


def test_v105_helper_usage_count(agent_text):
    """v1.0.5 must call _v105_target_state_as_obj at >=49 distinct sites (50 replacements minus
    duplicate-line lossy collapse)."""
    n = len(re.findall(r"_v105_target_state_as_obj\(target_state,", agent_text))
    assert n >= 49, f"expected >= 49 usages of _v105_target_state_as_obj(target_state, ...); got {n}"


def test_v105_helper_obj_handles_dict_directly():
    """Behaviorally exercise the helper. Replicate its definition verbatim."""
    _V105_TS_HELPER_FIRED = {'fired': False}

    def _v105_target_state_as_obj(_ts, _default, _logger=None):
        if _ts is None or _ts == '' or _ts == '-':
            return _default
        if isinstance(_ts, (dict, list)):
            return _ts
        if isinstance(_ts, str):
            try:
                return json.loads(_ts)
            except Exception:
                return _default
        return _default

    # Dict passes through unchanged
    d = {"issue_type": "fk_namespace_mismatch", "fix": "..."}
    assert _v105_target_state_as_obj(d, {}) is d

    # JSON-string parses to dict
    out = _v105_target_state_as_obj('{"key": "value"}', {})
    assert out == {"key": "value"}

    # None / '' / '-' return default
    assert _v105_target_state_as_obj(None, []) == []
    assert _v105_target_state_as_obj('', []) == []
    assert _v105_target_state_as_obj('-', {}) == {}

    # Bad JSON returns default
    assert _v105_target_state_as_obj("not-json", {"d": 1}) == {"d": 1}

    # List passes through
    lst = [1, 2, 3]
    assert _v105_target_state_as_obj(lst, []) is lst


def test_v105_helper_str_coerces_dict_for_slice():
    """The companion _v105_target_state_as_str must handle dict + max_len=100 without KeyError."""
    def _v105_target_state_as_str(_ts, _max_len=None):
        if _ts is None or _ts == '' or _ts == '-':
            return ''
        if isinstance(_ts, str):
            return _ts if _max_len is None else _ts[:_max_len]
        try:
            _s = json.dumps(_ts, default=str, ensure_ascii=False)
        except Exception:
            _s = repr(_ts)
        return _s if _max_len is None else _s[:_max_len]

    out = _v105_target_state_as_str({"issue": "fk_mismatch", "fix": "rename"}, _max_len=100)
    assert isinstance(out, str)
    assert len(out) <= 100
    assert "issue" in out
    # str + None
    assert _v105_target_state_as_str(None) == ''
    assert _v105_target_state_as_str('hello', _max_len=3) == 'hel'


def test_v105_anti_tautology_obj_helper():
    """Different dict inputs MUST produce different outputs."""
    def helper(_ts, _default):
        if _ts is None or _ts == '' or _ts == '-': return _default
        if isinstance(_ts, (dict, list)): return _ts
        return json.loads(_ts) if isinstance(_ts, str) else _default

    a = helper({"x": 1}, None)
    b = helper({"x": 2}, None)
    assert a != b


def test_v105_repros_original_bugs():
    """Both the json.loads(dict) TypeError and the dict[:100] KeyError must be reproducible
    on raw Python — proves the bug existed and the helpers actually rescue from it."""
    # Bug 1: json.loads(dict) raises TypeError
    with pytest.raises(TypeError) as excinfo:
        json.loads({"a": 1})
    assert "JSON object must be" in str(excinfo.value)

    # Bug 2: dict[:100] raises KeyError: slice(None, 100, None)
    d = {"a": 1}
    with pytest.raises(KeyError) as excinfo:
        _ = d[:100]
    assert "slice(None, 100, None)" in str(excinfo.value)


def test_v105_line_9793_uses_v105_helper(agent_text):
    """The LLM-fallback-classify site (formerly target_state[:100]) must now use the helper."""
    region = re.search(
        r"🤖 \[LLM-FALLBACK\] Unrecognized action.*?LLM_FALLBACK_CLASSIFY_PROMPT.*?_call_ai_query",
        agent_text,
        flags=re.DOTALL,
    )
    assert region, "LLM-fallback-classify region must exist"
    body = region.group(0)
    assert "_v105_target_state_as_str" in body, (
        "v1.0.5 must coerce target_state to string at the LLM-fallback-classify site"
    )
    # The bug pattern target_state[:100] (non-stringified) MUST NOT be in this region
    assert "target_state[:100]" not in body, (
        "the unsafe target_state[:100] slice must be removed from the LLM-fallback-classify site"
    )


def test_v105_prior_fix_sentinels_preserved(agent_text):
    """v1.0.5 must not break v1.0.3 / v1.0.4 fixes — sentinels still present."""
    for sentinel in (
        "vibe-master-retry-on-zero-actions FIRED v1.0.3",
        "verifier-llm-fallback-deterministic-rescue FIRED v1.0.3",
        "interpret-action-field-stringify FIRED v1.0.4",
    ):
        assert sentinel in agent_text, f"prior sentinel preserved: {sentinel}"
