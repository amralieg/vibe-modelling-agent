"""Full symbol coverage with multi-scenario matrix (min 3 per callable; scales with call sites)."""
from __future__ import annotations

import pytest

import agent_helpers as ah
from agent_coverage_util import notebook_symbol_inventory
from coverage_report import full_agent_inventory
from scenario_plan_util import (
    class_method_scenario_matrix,
    class_scenario_matrix,
    module_function_scenario_matrix,
    module_global_scenario_matrix,
    run_class_method_scenario,
    run_class_scenario,
    run_module_function_scenario,
    run_module_global_scenario,
    scenario_summary_stats,
)


def _inventory():
    return full_agent_inventory()


def _notebook_methods():
    return notebook_symbol_inventory()["methods"]


class TestAgentHelpersLoadHealth:
    def test_zero_load_errors(self):
        assert getattr(ah, "_load_errors", []) == []

    def test_loaded_substantial_surface(self):
        inv = _inventory()
        assert inv["counts"]["module_functions"] >= 400
        assert inv["counts"]["classes"] >= 40
        assert inv["counts"]["methods"] >= 300

    def test_minimum_three_scenarios_per_callable(self):
        stats = scenario_summary_stats()
        assert stats["below_min"] == [], (
            f"symbols with <3 scenarios: {stats['below_min'][:20]}"
        )


@pytest.mark.parametrize("func_name,scenario", module_function_scenario_matrix())
def test_module_function_scenario(func_name, scenario):
    run_module_function_scenario(func_name, scenario)


@pytest.mark.parametrize("class_method,scenario", class_method_scenario_matrix())
def test_class_method_scenario(class_method, scenario):
    run_class_method_scenario(class_method, scenario)


@pytest.mark.parametrize("global_name,scenario", module_global_scenario_matrix())
def test_module_global_scenario(global_name, scenario):
    run_module_global_scenario(global_name, scenario)


@pytest.mark.parametrize("class_name,scenario", class_scenario_matrix())
def test_class_scenario(class_name, scenario):
    run_class_scenario(class_name, scenario)


@pytest.mark.parametrize("qualified", _notebook_methods())
def test_notebook_method_surface(qualified):
    if "." not in qualified:
        pytest.skip("not a class method")
    class_name, method_name = qualified.split(".", 1)
    if not hasattr(ah, class_name):
        pytest.skip(f"class {class_name} not loaded (may be inner/nested)")
    cls = getattr(ah, class_name)
    assert hasattr(cls, method_name), (
        f"notebook defines {qualified} but agent_helpers.{class_name} has no {method_name}"
    )
    attr = getattr(cls, method_name)
    assert callable(attr) or isinstance(attr, property), (
        f"{qualified} must be callable or @property"
    )


class TestCorePipelineSymbols:
    def test_core_symbols_present(self):
        for sym in (
            "sanitize_name",
            "replace_single_quote",
            "run_batch_with_halving_on_timeout",
            "run_with_context_ladder",
            "HeartbeatWatchdog",
            "AIAgent",
            "VibeOrchestrator",
            "VibeWriter",
            "main",
            "__AGENT_VERSION__",
            "TECHNICAL_CONTEXT",
            "PROMPT_TEMPLATES",
        ):
            assert hasattr(ah, sym), f"missing {sym}"


class TestCannedLLMStub:
    def test_load_airlines_vibe_parse_fixture(self):
        from tests.fixtures.llm_canned.mock_ai_query import load_canned_response

        data = load_canned_response("VIBE_PARSE_PROMPT")
        assert "vibe_classification" in data

    @pytest.mark.skipif(
        not __import__("pathlib").Path("/tmp/vibe-business-data-models").is_dir(),
        reason="vibe-business-data-models clone required",
    )
    def test_load_airlines_model_json_from_repo(self):
        from tests.fixtures.industries.airlines.model_loader import load_industry_model

        m = load_industry_model()
        assert m.get("agent_version")
        domains = m.get("model", {}).get("domains", [])
        assert len(domains) >= 3
