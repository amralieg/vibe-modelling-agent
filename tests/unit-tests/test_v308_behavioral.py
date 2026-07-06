"""v3.0.8 behavioral tests.

Context: v3.0.7 tried to fix the "73K-95K char mutator embedded as a JSON string breaks
json.loads on unescaped quotes/backslashes" failure by dropping response_schema and asking
the synthesizer to emit a ```python fence. Empirically that turned a v306 ~26-min retail VOV
iteration into a 2h+ non-convergence hang (run 1063899640798190 cancelled 2026-06-03 after 2h
with zero version flush). The dropped schema regressed the generation path.

v3.0.8 reverts the contract to the known-good fast JSON path:
  - alias=vov-synth-schema-restore: the synth call passes response_schema=_synth_schema again
    and the prompt asks for a single JSON object (not a fence).
  - alias=vov-bridge-mutator-recover: the ONLY v306 fault (json.loads crash on the huge
    unescaped payload) is fixed WRAPPING-AGNOSTICALLY in complete_json -- when strict AND lax
    json.loads both fail but the raw text contains `def mutator`, the bridge recovers
    mutator_source (and expected_changes_summary) directly from the raw text. The v307 fence
    extractor is kept as a harmless defensive fallback.

These tests drive the REAL normalizer block sliced from the agent notebook.
"""
import sys
import textwrap
import json as _json
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parent))

from notebook_source_util import notebook_concat_source  # noqa: E402


def _load_bridge_parser():
    """Slice the str/dict-handling tail of the VOV bridge complete_json (a class method)
    and wrap it as a free function _parse(self, raw) so the real parsing + v3.0.8 recovery
    logic can be driven directly. The slice spans `if isinstance(raw, dict):` through the
    final `unexpected response type` raise, which includes the vov-bridge-mutator-recover
    block inserted before the parse-fail raise."""
    src = notebook_concat_source()
    marker = "vov-bridge-mutator-recover FIRED v3.0.8"
    mi = src.index(marker)
    di = src.rindex("if isinstance(raw, dict):", 0, mi)
    line_start = src.rfind("\n", 0, di) + 1
    ei = src.index("unexpected response type", mi)
    end = src.index("\n", ei) + 1
    block = src[line_start:end]
    body = textwrap.indent(textwrap.dedent(block), "    ")
    fn_src = "def _parse(self, raw):\n" + body
    ns = {"json": _json, "__name__": "_test_v308_bridge"}
    exec(compile(fn_src, "v308_bridge_parser", "exec"), ns)
    return ns["_parse"]


class _Logger:
    def info(self, *a, **k):
        pass

    def error(self, *a, **k):
        pass

    def warning(self, *a, **k):
        pass


class _FakeSelf:
    logger = _Logger()


# The exact pre-v3.0.7 failure mode: full mutator embedded as a JSON STRING VALUE with
# unescaped inner double-quotes and literal newlines. json.loads (strict AND lax) reject this.
_BAD_EMBEDDED_JSON = (
    '{"mutator_source": "def mutator(model, data):\n'
    '    mdl = model.get("model", model)\n'
    '    for d in mdl.get("domains", []):\n'
    '        if d.get("name", "").lower() == "billing":\n'
    '            d["note"] = "flagged"\n'
    '    return model", "expected_changes_summary": "annotate billing domain"}'
)


def test_recover_mutator_from_malformed_embedded_json():
    """THE core v3.0.8 fix: a payload that strict AND lax json.loads both reject is still
    recovered, returning the intact mutator source. This is exactly what v3.0.7's json.loads
    path raised on."""
    # Non-tautology guard: prove the payload genuinely defeats BOTH json.loads modes.
    for _strict in (True, False):
        with pytest.raises(_json.JSONDecodeError):
            _json.loads(_BAD_EMBEDDED_JSON, strict=_strict)

    parse = _load_bridge_parser()
    out = parse(_FakeSelf(), _BAD_EMBEDDED_JSON)
    assert isinstance(out, dict)
    code = out["mutator_source"]
    assert code.startswith("def mutator(model, data):")
    # the fragile unescaped inner quotes survive and the code is complete
    assert 'mdl = model.get("model", model)' in code
    assert '"billing"' in code
    assert code.rstrip().endswith("return model")
    assert out["expected_changes_summary"] == "annotate billing domain"


def test_recover_huge_embedded_mutator():
    """Scale check: ~80K-char mutator body with many unescaped quotes (the real retail/
    automotive/ngo size class) is recovered intact rather than crashing the batch."""
    body_lines = ['def mutator(model, data):',
                  '    mdl = model.get("model", model)']
    for i in range(1500):
        body_lines.append(f'    mdl.setdefault("notes", []).append("row {i} touches \\"x\\"")')
    body_lines.append('    return model')
    big_code = "\n".join(body_lines)
    assert len(big_code) > 60000
    payload = '{"mutator_source": "' + big_code + '", "expected_changes_summary": "bulk notes"}'
    parse = _load_bridge_parser()
    out = parse(_FakeSelf(), payload)
    assert out["mutator_source"].startswith("def mutator(model, data):")
    assert out["mutator_source"].rstrip().endswith("return model")
    assert len(out["mutator_source"]) > 50000


def test_recover_does_not_fire_without_def_mutator():
    """Non-tautology / guards over-eager recovery: a malformed payload with NO `def mutator`
    must still raise (recovery is scoped to mutator payloads only)."""
    parse = _load_bridge_parser()
    bad = '{"foo": "this is "broken" json with no mutator", "bar": 1}'
    with pytest.raises((ValueError, Exception)):
        parse(_FakeSelf(), bad)


def test_well_formed_json_still_parses_fast_path():
    """Regression: a correctly-escaped JSON object parses via the normal strict path
    (recovery must not interfere)."""
    parse = _load_bridge_parser()
    good = _json.dumps({"mutator_source": "def mutator(model, data):\n    return model",
                        "expected_changes_summary": "noop"})
    out = parse(_FakeSelf(), good)
    assert out["mutator_source"].startswith("def mutator")
    assert out["expected_changes_summary"] == "noop"


def test_plain_dict_passes_through():
    parse = _load_bridge_parser()
    d = {"mutator_source": "def mutator(model, data):\n    return model",
         "expected_changes_summary": "noop"}
    assert parse(_FakeSelf(), d) is d


def test_small_unrelated_json_still_parses():
    parse = _load_bridge_parser()
    assert parse(_FakeSelf(), '{"foo": "bar", "n": 3}') == {"foo": "bar", "n": 3}


def test_defensive_fence_extraction_still_works():
    """The v307 fence extractor is retained as a defensive fallback; if a model still emits
    a ```python fence, it is recovered."""
    parse = _load_bridge_parser()
    resp = ('```python\n'
            'def mutator(model, data):\n'
            '    mdl = model.get("model", model)\n'
            '    return model\n'
            '```\n'
            '{"expected_changes_summary": "fence path"}')
    out = parse(_FakeSelf(), resp)
    assert out["mutator_source"].startswith("def mutator")
    assert out["expected_changes_summary"] == "fence path"


def test_version_is_308():
    import re as _re
    m = _re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', notebook_concat_source())
    assert m is not None
    assert tuple(int(x) for x in m.groups()) >= (3, 0, 8)


def test_synth_call_restores_response_schema():
    """The synth call must pass response_schema=_synth_schema (NOT None) -- restoring the
    known-good fast generation path that v307 regressed."""
    src = notebook_concat_source()
    i = src.index("alias=vov-synth-schema-restore -- response_schema RESTORED")
    nxt = src.index("response_schema=_synth_schema,", i)
    assert 0 < (nxt - i) < 600


def test_prompt_uses_json_object_contract():
    src = notebook_concat_source()
    assert "return a SINGLE JSON object with exactly two keys" in src
    # the reverted fence instruction must be gone
    assert "emit the mutator as a fenced Python code block" not in src
