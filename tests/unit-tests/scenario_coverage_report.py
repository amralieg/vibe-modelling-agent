"""Report: how many test scenarios exist per agent symbol."""
from __future__ import annotations

import json
import re
from collections import defaultdict
from pathlib import Path

UNIT = Path(__file__).resolve().parent


def _scenario_counts() -> dict:
    """Map symbol -> number of pytest test functions targeting it."""
    counts: dict[str, int] = defaultdict(int)
    for p in UNIT.glob("test_*.py"):
        if p.name in (
            "test_agent_callable_coverage.py",
            "scenario_coverage_report.py",
        ):
            continue
        text = p.read_text(encoding="utf-8")
        for m in re.finditer(r"def (test_\w+)", text):
            body_start = m.end()
            next_def = re.search(r"\ndef test_", text[body_start:])
            body = text[body_start : body_start + (next_def.start() if next_def else 2000)]
            # Heuristic: which symbol is under test
            for sym in re.findall(r'["\']([A-Za-z_][\w.]*)["\']', body):
                if sym.startswith("test_"):
                    continue
                if len(sym) > 3:
                    counts[sym] += 1
    return dict(counts)


def emit_scenario_summary() -> None:
    from scenario_plan_util import scenario_summary_stats

    stats = scenario_summary_stats()
    counts = _scenario_counts()
    multi = sum(1 for s, n in counts.items() if n >= 3)

    print("\n--- SCENARIOS PER FUNCTION (summary) ---")
    print(f"  Multi-scenario matrix tests (parametrized): {stats['total_scenario_tests']}")
    print(f"    module functions: {stats['module_function_tests']}")
    print(f"    class methods:    {stats['class_method_tests']}")
    print(f"    module globals:   {stats['global_tests']}")
    print(f"    classes:          {stats['class_tests']}")
    print(f"  Unique callables in matrix: {stats['unique_callables']}")
    print(f"  Avg scenarios per callable: {stats['avg_scenarios_per_callable']}")
    print(f"  Min scenarios enforced:     {stats['min_scenarios']}")
    print(f"  Max scenarios (hot paths):  {stats['max_scenarios']}")
    print(f"  Symbols below min (must=0): {len(stats['below_min'])}")
    print(f"  Extra behavioral refs (3+): {multi} (heuristic from test_*.py)")
    print("---\n")


if __name__ == "__main__":
    emit_scenario_summary()
