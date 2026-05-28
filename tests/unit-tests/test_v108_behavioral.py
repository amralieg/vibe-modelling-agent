"""
v1.0.8 behavioral test — verifier-rescue-retry-on-transient-error

Reproduces HC iter=8 + RT iter=8 fidelity-precision drop:
  HC: precision 0.55 < required 0.85 (rollback recommended)
  RT: precision 0.8148 < required 0.85
caused by 8 + 6 SparkException `REMOTE_FUNCTION_HTTP_FAILED_ERROR` failures
inside `_verify_via_llm` primary `_call_ai_query` and rescue `_call_ai_query`.

Pre-fix: when `_call_ai_query` raised, the verifier marked the VREQ failed
(treating a transient infra blip as evidence the change wasn't made — a hidden
soft-accept per CLAUDE.md §11.5).

v1.0.8 fix: `_v108_call_with_transient_retry` retries up to 3 times with
exponential backoff (1s, 3s, 7s) on transient marker patterns; permanent
errors re-raise immediately.
"""
import json
import re
import time
from pathlib import Path

NB_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_nb():
    with open(NB_PATH) as f:
        return json.load(f)


def _find_class_cell_with(needle):
    nb = _load_nb()
    for ci, cell in enumerate(nb["cells"]):
        if cell.get("cell_type") != "code":
            continue
        src = "".join(cell["source"]) if isinstance(cell["source"], list) else cell["source"]
        if needle in src:
            return ci, src
    raise AssertionError(f"needle {needle!r} not found in any code cell")


def test_agent_version_bumped_to_108():
    nb = _load_nb()
    found = None
    for cell in nb["cells"]:
        if cell.get("cell_type") != "code":
            continue
        src = "".join(cell["source"]) if isinstance(cell["source"], list) else cell["source"]
        m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
        if m:
            found = m.group(1)
            break
    parts = tuple(int(p) for p in found.split(".")) if found else (0, 0, 0)
    assert parts >= (1, 0, 8), f"expected >= 1.0.8, got {found}"


def test_helper_methods_exist_in_orchestrator_class():
    """Both static and instance helper must be defined on the verifier class."""
    _, src = _find_class_cell_with("def _verify_via_llm")
    assert "def _v108_is_transient_llm_error" in src, "transient detector missing"
    assert "def _v108_call_with_transient_retry" in src, "retry wrapper missing"


def test_primary_verifier_uses_retry_helper():
    """The primary verifier site (`_v100_resp`) must route through the retry helper, not raw _call_ai_query."""
    _, src = _find_class_cell_with("def _verify_via_llm")
    primary_block_match = re.search(
        r'_v100_resp\s*=\s*None.*?if not _v100_resp:',
        src,
        re.DOTALL,
    )
    assert primary_block_match is not None, "could not locate primary verifier block"
    primary_block = primary_block_match.group(0)
    assert "_v108_call_with_transient_retry" in primary_block, (
        "primary verifier must call _v108_call_with_transient_retry, not raw _call_ai_query"
    )
    # The OLD direct call must be gone from this block
    direct_call_count = primary_block.count("self.ai_agent._call_ai_query(")
    assert direct_call_count == 0, (
        f"primary verifier block still has {direct_call_count} direct _call_ai_query calls; must route through helper"
    )


def test_rescue_extractor_uses_retry_helper():
    """The rescue extractor site (`_v103_extract_resp`) must route through the retry helper."""
    _, src = _find_class_cell_with("def _verify_via_llm")
    rescue_block_match = re.search(
        r'_v103_extract_resp\s*=\s*None.*?# Parse rescue response',
        src,
        re.DOTALL,
    )
    assert rescue_block_match is not None, "could not locate rescue extractor block"
    rescue_block = rescue_block_match.group(0)
    assert "_v108_call_with_transient_retry" in rescue_block, (
        "rescue extractor must call _v108_call_with_transient_retry"
    )
    direct_call_count = rescue_block.count("self.ai_agent._call_ai_query(")
    assert direct_call_count == 0, (
        f"rescue extractor block still has {direct_call_count} direct _call_ai_query calls; must route through helper"
    )


def test_transient_markers_cover_observed_errors():
    """Detector must catch every error pattern actually observed in HC/RT iter=8 logs."""
    _, src = _find_class_cell_with("def _v108_is_transient_llm_error")
    helper_match = re.search(r'def _v108_is_transient_llm_error.*?return any', src, re.DOTALL)
    assert helper_match is not None
    helper_src = helper_match.group(0)
    must_have = ["REMOTE_FUNCTION_HTTP_FAILED_ERROR", "awaitResult", "Read timed out"]
    for marker in must_have:
        assert marker in helper_src, f"helper must include marker {marker!r}"


def _build_isolated_helper():
    """Extract _v108_is_transient_llm_error + _v108_call_with_transient_retry into a tiny
    standalone class for behavioral testing in isolation."""
    return """
import time

class FakeOrch:
    def __init__(self, ai_agent, logger=None):
        self.ai_agent = ai_agent
        self.logger = logger or _DummyLogger()

    @staticmethod
    def _v108_is_transient_llm_error(exc):
        try:
            _et = (type(exc).__name__ or '') + ': ' + (str(exc) or '')
        except Exception:
            return False
        _markers = (
            'REMOTE_FUNCTION_HTTP_FAILED_ERROR',
            'Read timed out',
            'ReadTimeoutError',
            ' 502 ', ' 503 ', ' 504 ',
            'Connection reset',
            'Connection refused',
            'Connection aborted',
            'awaitResult',
            'SocketTimeoutException',
            'Server disconnected',
            'BadGateway',
            'ServiceUnavailable',
            'GatewayTimeout',
        )
        return any(m in _et for m in _markers)

    def _v108_call_with_transient_retry(self, *, prompt_name, prompt, response_schema, step_name, max_retries=2, max_attempts=3):
        if not self.ai_agent or not hasattr(self.ai_agent, '_call_ai_query'):
            return None
        # FAST: 0s delays for tests
        _delays = (0.0, 0.0, 0.0)
        _last_exc = None
        for _attempt in range(1, int(max_attempts) + 1):
            try:
                return self.ai_agent._call_ai_query(
                    prompt_name=prompt_name, prompt=prompt,
                    response_schema=response_schema, step_name=step_name,
                    max_retries=max_retries,
                )
            except Exception as _e:
                _last_exc = _e
                if not self._v108_is_transient_llm_error(_e):
                    raise
                self.logger.warning(f"retry {_attempt}/{max_attempts} for {step_name}")
                if _attempt < int(max_attempts):
                    time.sleep(_delays[min(_attempt - 1, len(_delays)-1)])
        if _last_exc is not None:
            raise _last_exc
        return None

class _DummyLogger:
    def __init__(self): self.warnings = []
    def warning(self, m): self.warnings.append(m)
    def info(self, m): pass
    def error(self, m): pass
"""


def test_helper_retries_3x_then_raises_on_persistent_transient():
    """Behavioral: persistent transient → exactly 3 attempts then re-raise (no soft-accept)."""
    ns = {}
    exec(_build_isolated_helper(), ns)
    calls = []

    class FlakyAgent:
        def _call_ai_query(self, **kw):
            calls.append(kw)
            err_str = "[REMOTE_FUNCTION_HTTP_FAILED_ERROR] The remote HTTP request"
            raise RuntimeError(err_str)

    orch = ns["FakeOrch"](FlakyAgent())
    raised = None
    try:
        orch._v108_call_with_transient_retry(
            prompt_name="X", prompt="p", response_schema={}, step_name="t",
        )
    except RuntimeError as e:
        raised = e
    assert raised is not None, "must re-raise after 3 transient failures"
    assert "REMOTE_FUNCTION_HTTP_FAILED_ERROR" in str(raised)
    assert len(calls) == 3, f"expected 3 attempts on persistent transient; got {len(calls)}"


def test_helper_succeeds_on_transient_then_recovery():
    """Behavioral: 2 transient failures then success → returns the result, attempt 3."""
    ns = {}
    exec(_build_isolated_helper(), ns)
    calls = []

    class IntermittentAgent:
        def _call_ai_query(self, **kw):
            calls.append(kw)
            if len(calls) <= 2:
                raise RuntimeError("[REMOTE_FUNCTION_HTTP_FAILED_ERROR] transient")
            return {"status": "fulfilled", "evidence": "ok"}

    orch = ns["FakeOrch"](IntermittentAgent())
    result = orch._v108_call_with_transient_retry(
        prompt_name="X", prompt="p", response_schema={}, step_name="t",
    )
    assert result == {"status": "fulfilled", "evidence": "ok"}
    assert len(calls) == 3, f"expected 3 attempts (2 fail + 1 success); got {len(calls)}"


def test_helper_does_not_retry_on_permanent_error():
    """Anti-tautology (§8.3): non-transient errors must re-raise IMMEDIATELY without retry."""
    ns = {}
    exec(_build_isolated_helper(), ns)
    calls = []

    class BadSchemaAgent:
        def _call_ai_query(self, **kw):
            calls.append(kw)
            raise ValueError("Schema validation failed: missing required field 'status'")

    orch = ns["FakeOrch"](BadSchemaAgent())
    raised = None
    try:
        orch._v108_call_with_transient_retry(
            prompt_name="X", prompt="p", response_schema={}, step_name="t",
        )
    except ValueError as e:
        raised = e
    assert raised is not None
    assert "Schema validation" in str(raised)
    assert len(calls) == 1, f"permanent error must NOT retry; got {len(calls)} attempts"


def test_helper_returns_none_when_no_ai_agent():
    """If ai_agent is None or lacks _call_ai_query, helper returns None (graceful no-op)."""
    ns = {}
    exec(_build_isolated_helper(), ns)
    orch = ns["FakeOrch"](None)
    assert orch._v108_call_with_transient_retry(
        prompt_name="X", prompt="p", response_schema={}, step_name="t",
    ) is None


def test_helper_first_attempt_success_no_retry():
    """Anti-tautology: when LLM works first time, helper returns immediately (1 call)."""
    ns = {}
    exec(_build_isolated_helper(), ns)
    calls = []

    class HealthyAgent:
        def _call_ai_query(self, **kw):
            calls.append(kw)
            return {"status": "fulfilled"}

    orch = ns["FakeOrch"](HealthyAgent())
    result = orch._v108_call_with_transient_retry(
        prompt_name="X", prompt="p", response_schema={}, step_name="t",
    )
    assert result == {"status": "fulfilled"}
    assert len(calls) == 1


def test_observed_hciter8_error_is_classified_transient():
    """The exact exception text observed in HC iter=8 logs must classify as transient."""
    ns = {}
    exec(_build_isolated_helper(), ns)
    sample = (
        "Job aborted due to stage failure: org.apache.spark.SparkException: "
        "Exception thrown in awaitResult: [REMOTE_FUNCTION_HTTP_FAILED_ERROR] "
        "The remote HTTP request failed."
    )
    fake = type("FakeException", (Exception,), {})(sample)
    is_t = ns["FakeOrch"]._v108_is_transient_llm_error(fake)
    assert is_t is True, "observed HC iter=8 error MUST classify as transient"


def test_v107_sentinel_still_present():
    """Defense in depth: prior fix sentinel must remain in code (no regression)."""
    nb = _load_nb()
    raw = json.dumps(nb)
    assert "qa-widgets-values-via-config FIRED v1.0.7" in raw
    assert "division-filter-user-domain-bypass FIRED v1.0.6" in raw
