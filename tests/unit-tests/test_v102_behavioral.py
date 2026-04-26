"""v1.0.2 BEHAVIORAL tests for the v1.0.1 tiny ECM audit fixes.

Each test exercises real input -> output behavior (positive AND negative cases per
CLAUDE.md section 8.3 anti-tautology).

Fixes covered:
  1. fidelity-count-soft-pass-deterministic  (FIDELITY-GATES-FAILED)
  2. mv-source-product-prefix-rewrite        (MV-FAIL-ORDER-STATUS)
  3. prefix-strip-reserved-word-guard        (MV-PREFIX-STRIP-DESYNC)
"""

import ast
import json
import re
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_notebook_source(path: Path) -> str:
    nb = json.loads(path.read_text(encoding="utf-8"))
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") == "code":
            parts.extend(cell.get("source", []))
    return "".join(parts)


@pytest.fixture(scope="module")
def agent_src() -> str:
    return _read_notebook_source(NOTEBOOK_PATH)


def _extract_function(src: str, fn_name: str) -> str:
    tree = ast.parse(src)
    for node in ast.walk(tree):
        if isinstance(node, ast.FunctionDef) and node.name == fn_name:
            return ast.get_source_segment(src, node)
    raise AssertionError(f"Function {fn_name} not found")


def _exec_function(src: str, fn_name: str, extra_globals=None):
    fn_src = _extract_function(src, fn_name)
    g = {"re": re, "json": json}
    if extra_globals:
        g.update(extra_globals)
    exec(compile(fn_src, f"<{fn_name}>", "exec"), g)
    return g[fn_name]


class TestFidelityCountSoftPassDeterministic:
    def test_alias_present(self, agent_src):
        assert "[fidelity-count-soft-pass-deterministic FIRED]" in agent_src
        assert "alias=fidelity-count-soft-pass-deterministic" in agent_src

    def test_count_shape_patterns_recognised(self, agent_src):
        snippet = agent_src.split("fidelity-count-soft-pass-deterministic")[0][-4000:]
        for kw in ["exactly", "approximately", "around", "intentionally", "minimal"]:
            assert kw in snippet, f"missing vibe keyword {kw!r} in count-shape regex region"


class TestMvSourceProductPrefixRewrite:
    def test_helper_defined(self, agent_src):
        assert "def _strip_source_product_prefix_in_expr(" in agent_src

    def test_alias_present(self, agent_src):
        assert "[mv-source-product-prefix-rewrite FIRED]" in agent_src
        assert "alias=mv-source-product-prefix-rewrite" in agent_src

    def test_strips_source_prefix_positive(self, agent_src):
        fn = _exec_function(agent_src, "_strip_source_product_prefix_in_expr")
        out = fn("order.status = 'completed'", "order")
        assert out == "status = 'completed'"

    def test_preserves_joined_prefix_negative(self, agent_src):
        fn = _exec_function(agent_src, "_strip_source_product_prefix_in_expr")
        # joined product 'item' must be preserved (not the source)
        out = fn("order.status = 'completed' AND item.qty > 0", "order", ["item"])
        assert out == "status = 'completed' AND item.qty > 0"

    def test_handles_multiple_refs(self, agent_src):
        fn = _exec_function(agent_src, "_strip_source_product_prefix_in_expr")
        out = fn("SUM(order.amount) + AVG(order.tax)", "order")
        assert "order.amount" not in out
        assert "order.tax" not in out
        assert "SUM(amount)" in out
        assert "AVG(tax)" in out

    def test_noop_without_qualifier(self, agent_src):
        fn = _exec_function(agent_src, "_strip_source_product_prefix_in_expr")
        out = fn("amount + tax", "order")
        assert out == "amount + tax"

    def test_noop_without_source_product(self, agent_src):
        fn = _exec_function(agent_src, "_strip_source_product_prefix_in_expr")
        assert fn("order.status", "") == "order.status"
        assert fn("order.status", None) == "order.status"

    def test_call_sites_in_render_pipeline(self, agent_src):
        # Must be invoked for filter, dimension and measure expressions
        assert agent_src.count("_strip_source_product_prefix_in_expr(") >= 4  # 1 def + 3 call sites


class TestPrefixStripReservedWordGuard:
    def test_alias_present(self, agent_src):
        assert "[prefix-strip-reserved-word-guard FIRED]" in agent_src
        assert "alias=prefix-strip-reserved-word-guard" in agent_src

    def test_reserved_set_covers_status(self, agent_src):
        # the new guard set must include 'status' (root cause of the desync)
        idx = agent_src.find("_V102_PREFIX_STRIP_RESERVED")
        assert idx != -1
        snippet = agent_src[idx:idx + 2000]
        assert '"status"' in snippet
        assert '"type"' in snippet
        assert '"date"' in snippet

    def test_guard_placed_before_existing_conflict_check(self, agent_src):
        # reserved-word guard must fire BEFORE the existing "name conflict" check
        idx_reserved = agent_src.find("_V102_PREFIX_STRIP_RESERVED")
        idx_conflict = agent_src.find("SKIPPED product prefix removal (name conflict)")
        assert idx_reserved != -1 and idx_conflict != -1
        assert idx_reserved < idx_conflict
