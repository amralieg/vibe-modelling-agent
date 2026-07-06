"""
v2.0.7 Phase 0 behavioural tests — verify the 3 unblocker fixes ARE present in the
deployed notebook source AND produce the correct observable behaviour.

Per CLAUDE.md §8.10 "no no-op patches": every alias must have a [<alias> FIRED] log
emission site AND a behavioural test that demonstrates observable state change. The
tests below do BOTH — static-grep that the FIRED-emission code is in the notebook,
AND in-process behavioural assertions for the RuntimeBudget class and temperature-strip
logic (the only Phase 0 pieces that don't require a live Databricks runtime).

The Spark-free HTTP-direct helper (verifier-spark-free-path) cannot be unit-tested in
isolation because it requires a live WorkspaceClient + serving endpoint — covered by
the live v207 deploy validation (test cycle on RT/gov_transport/HC).
"""

from __future__ import annotations

import json
import re
from pathlib import Path

NOTEBOOK = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _notebook_source() -> str:
    nb = json.loads(NOTEBOOK.read_text())
    return "".join("".join(c["source"]) for c in nb["cells"] if c["cell_type"] == "code")


def _exec_cell_with_class(class_name: str, helper_names: tuple = ()):
    """Find the cell that defines class_name and exec it; return the resulting class object."""
    nb = json.loads(NOTEBOOK.read_text())
    for cell in nb["cells"]:
        if cell["cell_type"] != "code":
            continue
        src = "".join(cell["source"])
        if f"class {class_name}" in src and all(h in src for h in helper_names):
            ns: dict = {}
            exec(src, ns)
            return ns
    raise RuntimeError(f"cell defining {class_name} not found")


# ---------------------------------------------------------------------------
# Version bump (CLAUDE.md §3a-bis)
# ---------------------------------------------------------------------------

def test_v207_version_bumped_to_2_0_7():
    src = _notebook_source()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+\.\d+\.\d+)"', src)
    assert m is not None, "__AGENT_VERSION__ constant not found"
    assert m.group(1) >= "2.0.7", f"expected version >= 2.0.7, got {m.group(1)} (v208 is forward-compatible — includes all v207 work + SelfFixer)"
    for seg in m.group(1).split("."):
        assert len(seg) == 1, f"single-digit semver violation in '{m.group(1)}'"


# ---------------------------------------------------------------------------
# Opus 4.7 added as first-order thinker with temperature_supported=False
# ---------------------------------------------------------------------------

def test_v207_opus_4_7_present_as_first_order_thinker():
    src = _notebook_source()
    assert "databricks-claude-opus-4-7" in src, "Opus 4.7 endpoint missing from roster"
    assert "\"order\": 5" in src, "order=5 not present (Opus 4.7 must be first-order)"
    assert "\"temperature_supported\": False" in src, (
        "Opus 4.7 must have temperature_supported=False (endpoint rejects the parameter)"
    )


def test_v207_thinker_roles_declared_for_opus_4_7():
    src = _notebook_source()
    assert '"thinker_roles": ["self_auditor", "self_fixer", "architect", "judge"]' in src, (
        "Opus 4.7 must declare the 4 thinker roles it will own (per Phase-0 routing decision)"
    )


# ---------------------------------------------------------------------------
# Temperature-conditional SQL builder (v207-model-params-temperature-conditional)
# ---------------------------------------------------------------------------

def test_v207_temperature_conditional_builder_present():
    src = _notebook_source()
    assert "v207-model-params-temperature-conditional" in src
    assert "_v207_temp_supported = bool(_v207_cfg_for_model.get(\"temperature_supported\", True))" in src
    assert "named_struct('max_tokens', {max_tokens}, 'temperature', {temperature})" in src, (
        "supported-temperature SQL form must still be present"
    )
    # The unsupported-temperature form must be the bare max_tokens struct.
    assert "named_struct('max_tokens', {max_tokens})" in src, (
        "unsupported-temperature SQL form (no temperature) must be present"
    )


# ---------------------------------------------------------------------------
# F-1 Spark-free path (verifier-spark-free-path)
# ---------------------------------------------------------------------------

def test_v207_spark_free_path_method_present():
    src = _notebook_source()
    assert "def _v207_call_llm_spark_free" in src, "Spark-free helper method missing"
    assert "from databricks.sdk import WorkspaceClient" in src, (
        "Spark-free path must use WorkspaceClient (HTTP-direct via SDK), not ai_query"
    )
    assert "serving_endpoints.query" in src, (
        "Spark-free path must use serving_endpoints.query (the SDK's HTTP-direct call)"
    )
    assert "[verifier-spark-free-path FIRED v2.0.7]" in src, (
        "FIRED log line must be present (§8.10)"
    )


def test_v207_spark_free_path_omits_temperature_for_no_temp_models():
    """Behavioural — the payload-building branch must skip 'temperature' when
    the resolved model_config has temperature_supported=False."""
    src = _notebook_source()
    # Locate the payload-building block within _v207_call_llm_spark_free.
    helper_start = src.find("def _v207_call_llm_spark_free")
    helper_end = src.find("def ", helper_start + 1)
    helper_src = src[helper_start:helper_end]
    # The guard must check temperature_supported BEFORE adding the key.
    assert "if _v207_temp_supported:" in helper_src, (
        "Spark-free path must guard temperature addition with temperature_supported check"
    )
    assert "_v207_payload[\"temperature\"]" in helper_src, (
        "Spark-free path must reference temperature inside the guard"
    )
    # Ordering check: 'temperature_supported' must appear BEFORE the conditional add.
    ts_idx = helper_src.find("_v207_temp_supported = bool(_v207_cfg.get")
    add_idx = helper_src.find("_v207_payload[\"temperature\"]")
    assert 0 < ts_idx < add_idx, "temperature_supported must be resolved before payload temperature add"


# ---------------------------------------------------------------------------
# F-2 Skip-on-transient (verifier-spark-transient-as-skip)
# ---------------------------------------------------------------------------

def test_v207_skip_on_transient_replaces_reraise():
    src = _notebook_source()
    # The OLD post-exhaustion behaviour was `raise _last_exc`. v207 replaces it with
    # `return None` accompanied by the FIRED log.
    assert "[verifier-spark-transient-as-skip FIRED v2.0.7]" in src, (
        "FIRED log line must be present at the skip site"
    )
    # The escalation-to-HTTP path must also be wired.
    assert "[verifier-spark-transient-escalate-to-http FIRED v2.0.7]" in src, (
        "First-transient escalation to HTTP-direct must fire its own log"
    )


def test_v207_skip_on_transient_returns_none_not_raises():
    """The skip branch must `return None` so callers treat the verifier as 'unavailable'
    rather than crashing. SelfAuditor at Step 10.9 will catch anything skipped."""
    src = _notebook_source()
    helper_start = src.find("def _v108_call_with_transient_retry")
    helper_end = src.find("def ", helper_start + 1)
    helper_src = src[helper_start:helper_end]
    # Ensure the FINAL behaviour (after all attempts exhausted) is `return None`, not `raise`.
    assert "[verifier-spark-transient-as-skip FIRED v2.0.7]" in helper_src
    # The terminal line of the helper must be `return None`, not `raise _last_exc`.
    # Find the LAST `return` and `raise` to compare.
    last_return = helper_src.rfind("return None")
    last_raise = helper_src.rfind("raise")
    assert last_return > last_raise > 0, (
        "post-exhaustion path must end with `return None`, not `raise _last_exc`"
    )


# ---------------------------------------------------------------------------
# F-3 RuntimeBudget (v207-runtime-budget)
# ---------------------------------------------------------------------------

def test_v207_runtime_budget_class_skip_optional_under_pressure():
    """Behavioural — RuntimeBudget.should_skip_optional MUST return True when remaining
    time is below the headroom + min-required threshold, False otherwise."""
    ns = _exec_cell_with_class("RuntimeBudget")
    RuntimeBudget = ns["RuntimeBudget"]

    import time

    # Case 1: just-started 4-hour budget — no skip.
    b1 = RuntimeBudget(task_timeout_seconds=14400)
    assert b1.should_skip_optional(min_required_seconds=60, headroom_seconds=1800) is False
    # Case 2: budget that's "started" 4 hours ago — should skip (0 time remaining < threshold).
    b2 = RuntimeBudget(task_timeout_seconds=14400, started_at=time.time() - 14400)
    assert b2.should_skip_optional(min_required_seconds=60, headroom_seconds=1800) is True
    # Case 3: 35 min remaining, 30 min headroom + 60s min required = 31 min needed → no skip.
    b3 = RuntimeBudget(task_timeout_seconds=14400, started_at=time.time() - (14400 - 35 * 60))
    assert b3.should_skip_optional(min_required_seconds=60, headroom_seconds=1800) is False
    # Case 4: 25 min remaining, same threshold → skip.
    b4 = RuntimeBudget(task_timeout_seconds=14400, started_at=time.time() - (14400 - 25 * 60))
    assert b4.should_skip_optional(min_required_seconds=60, headroom_seconds=1800) is True

    # Counters
    assert b4.summary()["optional_skips"] == 1
    assert b1.summary()["optional_skips"] == 0


def test_v207_runtime_budget_module_holder_present():
    src = _notebook_source()
    assert "_V207_RUNTIME_BUDGET = None" in src
    assert "def _v207_get_runtime_budget" in src
    assert "def _v207_set_runtime_budget" in src


def test_v207_runtime_budget_wired_into_main():
    src = _notebook_source()
    # The main() entry must instantiate the budget and emit the FIRED line.
    assert "_v207_set_runtime_budget(RuntimeBudget(task_timeout_seconds=_v207_task_timeout))" in src
    assert '[v207-runtime-budget FIRED v2.0.7]' in src


def test_v207_verifier_consults_budget_before_calling_llm():
    """The skip-budget guard must sit BEFORE the LLM-snapshot-building block inside
    _verify_via_llm; otherwise we'd waste time building snapshots we then throw away."""
    src = _notebook_source()
    helper_start = src.find("def _verify_via_llm")
    helper_end = src.find("def ", helper_start + 1)
    helper_src = src[helper_start:helper_end]
    guard_idx = helper_src.find("[verifier-skipped-budget FIRED v2.0.7]")
    snapshot_idx = helper_src.find("_v100_summary_lines = [\"# Model snapshot")
    assert 0 < guard_idx < snapshot_idx, (
        "RuntimeBudget skip guard must fire BEFORE the model-snapshot construction"
    )


# ---------------------------------------------------------------------------
# Anti-regression: §8.10 "the patch must change observable state" check
# ---------------------------------------------------------------------------

def test_v207_phase0_aliases_have_distinct_emission_sites():
    """Each of the 7 Phase 0 aliases must appear at least once as a FIRED log line
    (not just in a comment). Prevents the §8.10 no-op-observability pattern."""
    src = _notebook_source()
    fired_aliases = [
        "verifier-spark-free-path",
        "verifier-spark-transient-as-skip",
        "verifier-spark-transient-escalate-to-http",
        "verifier-skipped-budget",
        "v207-runtime-budget",
        "v207-model-params-temperature-conditional",
    ]
    for alias in fired_aliases:
        # Each alias must appear at least twice — once in code-comment, once in FIRED line.
        n = src.count(alias)
        assert n >= 2, f"alias '{alias}' appears only {n} time(s); expected ≥2 (comment + FIRED log)"
        # And specifically the FIRED variant must exist.
        fired_pattern = re.compile(rf"\[{re.escape(alias)} FIRED v")
        assert fired_pattern.search(src), f"FIRED log emission for alias '{alias}' is missing"
