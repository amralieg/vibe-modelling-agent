"""v1.0.4 behavioral tests — interpret-action-field-stringify.

Root cause: step_interpret_model_instructions did `action.get('target_state','')[:25]`
(and the same for action/scope/name). When the LLM emits any of those as a dict (legitimate
per the VIBE_MASTER_PROMPT schema, especially target_state for renames/connect_table),
Python raises `KeyError: slice(None, 25, None)` because dicts use slices as keys, not as
slice operations. LG iter-5 run 830504162641240 hit this and the whole VOV died before any
mutation ran.

Fix: wrap each slice with `_v104_safe_str(x, n)` that coerces non-strings via json.dumps.
First non-string coercion logs `[interpret-action-field-stringify FIRED v1.0.4]` once per call.

Tests must:
1. Verify the version constant is bumped to 1.0.4.
2. Verify the sentinel `[interpret-action-field-stringify FIRED v1.0.4]` is in the agent body.
3. Behaviorally exercise `_v104_safe_str` to assert dict/list/None inputs no longer crash and
   that the slice never raises KeyError.
4. Anti-tautology: the helper must produce DIFFERENT output for two different dict inputs.
5. Verify the prior bug pattern `action.get('target_state','')[:25]` is GONE from the active
   code path of step_interpret_model_instructions (no regression).
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


def test_v104_agent_version(agent_text):
    matches = re.findall(r'__AGENT_VERSION__\s*=\s*\\?"(1\.\d\.\d)\\?"', agent_text)
    assert matches, "__AGENT_VERSION__ must be present"
    assert any(v >= "1.0.4" for v in matches), f"version must be >= 1.0.4; got {matches}"


def test_v104_sentinel_present(agent_text):
    assert agent_text.count("interpret-action-field-stringify FIRED v1.0.4") >= 1, (
        "v1.0.4 sentinel must be in the deployed agent body"
    )


def test_v104_helper_definition_present(agent_text):
    """The _v104_safe_str helper MUST be defined in step_interpret_model_instructions."""
    assert "_v104_safe_str" in agent_text, (
        "_v104_safe_str helper must be defined in agent notebook"
    )


def test_v104_active_code_no_unsafe_slice_on_action_get_target_state(agent_text):
    """The exact bug pattern `action.get('target_state', '')[:25]` MUST NOT appear inside the
    step_interpret_model_instructions function body. (It is allowed inside the cell-1 version-history
    comment, which describes the bug — that's a documentation reference, not active code.)"""
    fn_match = re.search(r"def step_interpret_model_instructions\(", agent_text)
    assert fn_match, "step_interpret_model_instructions must be present"
    # Slice from the def to the next top-level def (rough heuristic: 80,000 chars or until we hit a
    # `\\n\"def ` sequence).
    body = agent_text[fn_match.end():fn_match.end() + 250000]
    next_def = re.search(r"\\n\s*\"def ", body)
    if next_def:
        body = body[:next_def.start()]
    forbidden = r"action\.get\(\\?'target_state\\?', ?\\?''\\?\)\[:25\]"
    matches = re.findall(forbidden, body)
    assert not matches, (
        f"v1.0.4 must remove the unsafe slice `action.get('target_state','')[:25]` from "
        f"step_interpret_model_instructions; found {len(matches)} occurrence(s)"
    )


def test_v104_helper_handles_non_string_inputs():
    """Behaviorally simulate _v104_safe_str. The helper signature:
        def _v104_safe_str(_x, _n=64, _seen={'fired': False}):
    Inline-replicate it verbatim and exercise it with strings, dicts, lists, None."""
    import json as _json

    class _StubLogger:
        def __init__(self): self.lines = []
        def info(self, m): self.lines.append(m)

    logger = _StubLogger()

    def _v104_safe_str(_x, _n=64, _seen={'fired': False}):
        if isinstance(_x, str):
            return _x[:_n]
        if _x is None:
            return ''
        try:
            _s = _json.dumps(_x, default=str, ensure_ascii=False)
        except Exception:
            _s = repr(_x)
        if not _seen['fired']:
            logger.info(f"[interpret-action-field-stringify FIRED v1.0.4] coerced non-string action field type={type(_x).__name__} preview={_s[:80]!r} alias=interpret-action-field-stringify")
            _seen['fired'] = True
        return _s[:_n]

    # String — preserved + sliced
    assert _v104_safe_str("hello world", 5) == "hello"
    # None — empty
    assert _v104_safe_str(None, 25) == ""
    # Dict — coerced to JSON, sliced
    out = _v104_safe_str({"old": "matter_id", "new": "matter_legal_id"}, 25)
    assert isinstance(out, str)
    assert len(out) <= 25
    assert "matter" in out  # entity name preserved
    # List — coerced to JSON, sliced
    out2 = _v104_safe_str(["a", "b", "c"], 64)
    assert isinstance(out2, str)
    assert "a" in out2
    # Bare integer — coerced
    out3 = _v104_safe_str(42, 10)
    assert out3 == "42"

    # Anti-tautology: different dict inputs → different outputs
    a = _v104_safe_str({"old": "X", "new": "Y"}, 64)
    b = _v104_safe_str({"old": "P", "new": "Q"}, 64)
    assert a != b, "helper must produce different outputs for different dict inputs"


def test_v104_helper_dict_does_not_raise_keyerror_on_slice():
    """The original bug: `dict[:25]` raises KeyError: slice(None, 25, None). Confirm directly."""
    d = {"old": "matter_id", "new": "matter_legal_id"}
    with pytest.raises(KeyError) as excinfo:
        _ = d[:25]
    assert "slice(None, 25, None)" in str(excinfo.value), (
        "Sanity: dict[:25] must raise the exact KeyError that LG iter-5 saw"
    )

    # Now show that v1.0.4's safe helper does NOT raise on the same input
    import json as _json
    def _v104_safe_str(_x, _n=64, _seen={'fired': False}):
        if isinstance(_x, str): return _x[:_n]
        if _x is None: return ''
        try: _s = _json.dumps(_x, default=str, ensure_ascii=False)
        except Exception: _s = repr(_x)
        return _s[:_n]
    out = _v104_safe_str(d, 25)
    assert isinstance(out, str)
    assert len(out) <= 25


def test_v104_call_sites_use_helper_for_all_four_fields(agent_text):
    """All four fields (action, scope, name, target_state) in the action-summary loop MUST be
    routed through _v104_safe_str. This is the v1.0.4 contract."""
    # Find the relevant region: between the column header banner and the EXECUTING ACTIONS banner
    region_match = re.search(
        r"\{'#':<4\} \{'ACTION':<35\} \{'SCOPE':<10\} \{'NAME':<35\} \{'TARGET':<25\}.*?EXECUTING ACTIONS ON MODEL DATA",
        agent_text,
        flags=re.DOTALL,
    )
    assert region_match, "Could not locate the action-summary region"
    region = region_match.group(0)
    for field, slice_n in (("action", 35), ("scope", 10), ("name", 35), ("target_state", 25)):
        pattern = rf"_v104_safe_str\(action\.get\(\\?'{field}\\?', ?\\?''\\?\), ?{slice_n}\)"
        assert re.search(pattern, region), (
            f"v1.0.4 must call _v104_safe_str on action.get('{field}', '') with width {slice_n}"
        )


def test_v104_prior_v103_sentinels_preserved(agent_text):
    """v1.0.4 patch must not break v1.0.3 fixes — sentinels still present."""
    for sentinel in (
        "vibe-master-retry-on-zero-actions FIRED v1.0.3",
        "verifier-llm-fallback-deterministic-rescue FIRED v1.0.3",
    ):
        assert sentinel in agent_text, f"v1.0.3 sentinel preserved: {sentinel}"


def test_v104_dispatch_miss_log_safe_for_dict_reason(agent_text):
    """Companion site at the vov-action-dispatch-universal MISS warning must coerce dict-typed
    `reason` before the [:160] slice."""
    # Find the warning emission and verify the reason field is wrapped in a stringification
    # block (isinstance check + json.dumps fallback) within ~10 lines of the warning.
    warn_idx = agent_text.find("vov-action-dispatch-universal MISS")
    assert warn_idx > 0, "expected the dispatch-miss warning to exist"
    # Look back ~3000 chars for the v1.0.4 stringify block
    pre = agent_text[max(0, warn_idx - 3000):warn_idx + 500]
    assert "_v104_reason" in pre or "isinstance(_v104_reason, str)" in pre, (
        "v1.0.4 must coerce a non-string `reason` before slicing in the dispatch-miss log"
    )
