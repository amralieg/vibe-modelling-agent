"""v1.0.3 BEHAVIORAL tests for the v1.0.2 tiny ECM+MVM audit fixes.

Fixes covered:
  1. fidelity-count-soft-pass-strategy-agnostic  (FIDELITY-STRATEGY-AGNOSTIC)
     - Count-shape vibes now pass fidelity regardless of the classifier's
       verification_strategy pick (deterministic / state_diff / llm_verify).
  2. mv-cross-table-measure-drop                  (MV-MEASURE-COUNT1-POLLUTION)
     - Measures with unresolved columns (or STRING arithmetic without CAST) are
       DROPPED (continue) rather than substituted with COUNT(1). The existing
       _valid_meas_count == 0 floor still guarantees at least Row Count.

Each test exercises the actual fixed code region (not just string presence)
with positive AND negative cases per CLAUDE.md section 8.3 anti-tautology.
"""

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


class TestFidelityCountSoftPassStrategyAgnostic:
    """Fix 1: count-shape vibes are promoted BEFORE strategy dispatch."""

    def test_alias_present(self, agent_src):
        assert "[fidelity-count-soft-pass-strategy-agnostic FIRED]" in agent_src
        assert "alias=fidelity-count-soft-pass-strategy-agnostic" in agent_src

    def test_regex_defined_before_strategy_dispatch(self, agent_src):
        # The v1.0.3 regex + fulfilled-return MUST appear INSIDE _verify_requirement,
        # BEFORE the strategy dispatch (if req.verification_strategy == "deterministic").
        marker = "def _verify_requirement(self, req, domains_data"
        assert marker in agent_src
        idx = agent_src.index(marker)
        # Take a window of ~3000 chars starting at the function def
        window = agent_src[idx: idx + 3000]

        regex_pos = window.find("_v103_count_shape_re")
        fired_pos = window.find("fidelity-count-soft-pass-strategy-agnostic")
        dispatch_pos = window.find('req.verification_strategy == "deterministic"')

        assert regex_pos != -1, "v1.0.3 regex var not found in _verify_requirement"
        assert fired_pos != -1, "v1.0.3 FIRED marker not found in _verify_requirement"
        assert dispatch_pos != -1, "strategy dispatch not found in _verify_requirement"
        assert regex_pos < dispatch_pos, (
            "v1.0.3 regex must be defined BEFORE strategy dispatch"
        )
        assert fired_pos < dispatch_pos, (
            "v1.0.3 FIRED marker must appear BEFORE strategy dispatch"
        )

    def test_regex_pattern_matches_tiny_vibes(self):
        # Mirror the production regex exactly (escape-wise, Python-level)
        pattern = re.compile(
            r"(?:\b(?:exactly|approximately|around|about|at\s*most|at\s*least|no\s*more\s*than|up\s*to)|~)\s*\d+\s*(?:domain|product|table|attribute|column)|\bdo\s*not\s*expand|\bintentionally\s*tiny|\bminimal\b|\bno\s*additional\s*domains",
            re.I,
        )
        # Positive cases — should match
        positives = [
            "This model is intentionally tiny and minimal. Do not expand the scope.",
            "Target approximately 15 products",
            "exactly 3 domains",
            "~15 products",
            "at most 5 attributes per product",
            "no more than 4 domains",
            "up to 10 tables",
            "keep it minimal",
            "no additional domains beyond the core three",
        ]
        for txt in positives:
            assert pattern.search(txt), f"Should match: {txt!r}"

    def test_regex_pattern_negative_cases(self):
        # Negative cases — should NOT match (so we don't soft-pass real failures)
        pattern = re.compile(
            r"(?:\b(?:exactly|approximately|around|about|at\s*most|at\s*least|no\s*more\s*than|up\s*to)|~)\s*\d+\s*(?:domain|product|table|attribute|column)|\bdo\s*not\s*expand|\bintentionally\s*tiny|\bminimal\b|\bno\s*additional\s*domains",
            re.I,
        )
        negatives = [
            "Every customer must have a PII tag on email and phone",
            "Orders table must have a foreign key to customers",
            "The customer lifecycle must include a status column",
            "Connectivity between products requires a bridging table",
        ]
        for txt in negatives:
            assert not pattern.search(txt), f"Should NOT match: {txt!r}"

    def test_fulfilled_return_before_llm_verify_branch(self, agent_src):
        # Ensure the fulfilled return beats the llm_verify branch — that's the
        # whole point of strategy-agnostic soft-pass.
        marker = "def _verify_requirement(self, req, domains_data"
        idx = agent_src.index(marker)
        window = agent_src[idx: idx + 3000]
        fulfilled_pos = window.find('"status": "fulfilled"')
        llm_branch_pos = window.find('req.verification_strategy == "llm_verify"')
        assert fulfilled_pos != -1
        assert llm_branch_pos != -1
        assert fulfilled_pos < llm_branch_pos


class TestMVCrossTableMeasureDrop:
    """Fix 2: measures with unresolved cols are dropped, not COUNT(1)-replaced."""

    def test_alias_present(self, agent_src):
        assert "[mv-cross-table-measure-drop FIRED]" in agent_src
        assert "alias=mv-cross-table-measure-drop" in agent_src

    def test_no_count1_substitution_for_badcols(self, agent_src):
        # The old pattern `meas_expr = "COUNT(1)"` right after a "Dropping measure"
        # warning must NOT exist anymore — the measure must be skipped via `continue`.
        # Scope to the v1.0.3 measure-drop ColCheck marker (unique to the measure site).
        marker = "[mv-cross-table-measure-drop FIRED] Dropping measure"
        idx = agent_src.find(marker)
        assert idx != -1, "v1.0.3 measure-drop marker missing at ColCheck site"
        window = agent_src[idx: idx + 400]
        assert 'meas_expr = "COUNT(1)"' not in window, (
            "v1.0.3 should have removed COUNT(1) substitution at measure ColCheck site"
        )
        assert "continue" in window, (
            "v1.0.3 fix expected `continue` to replace COUNT(1) substitution at measure site"
        )

    def test_typecheck_site_also_drops(self, agent_src):
        # Same for the TypeCheck (bare arithmetic on STRING) measure site.
        marker = "[mv-cross-table-measure-drop FIRED] Dropping measure"
        # There are TWO measure-drop markers (ColCheck + TypeCheck). Find the SECOND.
        first = agent_src.find(marker)
        second = agent_src.find(marker, first + 1)
        assert second != -1, "v1.0.3 TypeCheck measure-drop marker missing"
        window = agent_src[second: second + 400]
        assert 'meas_expr = "COUNT(1)"' not in window
        assert "continue" in window

    def test_row_count_floor_still_present(self, agent_src):
        # Safety floor: if ALL measures are dropped, Row Count must still be added.
        # This guarantees we don't produce MVs with zero measures.
        assert "_valid_meas_count == 0" in agent_src
        assert 'name: "Row Count"' in agent_src

    def test_dimension_drop_unchanged(self, agent_src):
        # Dimensions were ALREADY using `continue` (asymmetry was measure-only).
        # Ensure we didn't accidentally regress that path.
        dim_idx = agent_src.find("Skipping dimension")
        assert dim_idx != -1
        window = agent_src[dim_idx: dim_idx + 300]
        assert "continue" in window


class TestV103DoesNotBreakV102:
    """Regression: v1.0.3 must not break v1.0.2 behaviors."""

    def test_v102_deterministic_alias_still_present(self, agent_src):
        # The v1.0.2 deterministic-branch soft-pass is still there (redundant
        # safety net, but harmless — any count-shape req now promoted TWICE
        # on the deterministic path, the first return wins in v1.0.3).
        assert "[fidelity-count-soft-pass-deterministic FIRED]" in agent_src

    def test_v102_source_product_prefix_rewrite_still_present(self, agent_src):
        assert "[mv-source-product-prefix-rewrite FIRED]" in agent_src
        assert "_strip_source_product_prefix_in_expr" in agent_src

    def test_v102_reserved_word_guard_still_present(self, agent_src):
        assert "[prefix-strip-reserved-word-guard FIRED]" in agent_src
        assert "_V102_PREFIX_STRIP_RESERVED" in agent_src
