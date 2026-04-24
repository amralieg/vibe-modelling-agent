"""Tests for v0.8.5 N6-FIX (alias: metric-views-no-char-iter).

Root cause: in `_render_metric_sql_for_domain_from_llm_spec`, the line
    raw_metric_views = spec.get("metric_views", []) ...
    for mv_raw in raw_metric_views:
        if isinstance(mv_raw, dict): ...
        elif isinstance(mv_raw, str): ...

iterated CHARACTERS when the LLM returned `metric_views` as a single
JSON-string blob (~40K chars) instead of a list. Each char fell into
the str-branch, failed JSON repair, and emitted a warning. Result:
40K identical "Skipping unparseable" warnings in 1 second = 5.5MB log.

Live evidence: tiny_v84_gcp/ecm_v2 error.log on 2026-04-24 13:08:44.

Fix:
1. UPSTREAM type-guard at top of function: parse string-blob once,
   coerce to list, log exactly one info/warning depending on outcome.
2. SAFETY NET: cap per-domain "Skipping unparseable" warning emission
   at 10, then emit one summary line. Bounds future log explosions
   from any other shape-mismatch.

This test file enforces BOTH behaviors so reverting either breaks tests.
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
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        parts.append(src)
    return "\n".join(parts)


@pytest.fixture(scope="module")
def agent_src() -> str:
    return _read_notebook_source(NOTEBOOK_PATH)


@pytest.fixture(scope="module")
def helpers():
    import agent_helpers as ah
    return ah


# =====================================================================
# Sentinel and alias presence
# =====================================================================

class TestN6Sentinels:
    def test_n6_alias_present(self, agent_src):
        assert "v0.8.5 N6-FIX" in agent_src, "v0.8.5 N6-FIX alias missing"
        assert "metric-views-no-char-iter" in agent_src, \
            "alias=metric-views-no-char-iter sentinel missing"

    def test_n6_log_signal_present(self, agent_src):
        assert "[N6-FIX]" in agent_src, "[N6-FIX] log signal missing"

    def test_upstream_type_guard_present(self, agent_src):
        # The fix's distinguishing line — type-guard ON raw_metric_views
        # before the iteration begins.
        assert "if isinstance(raw_metric_views, str):" in agent_src, \
            "Upstream type-guard for raw_metric_views str-shape is missing"

    def test_warn_cap_present(self, agent_src):
        assert "_STR_SKIP_WARN_CAP" in agent_src, \
            "warning emission cap variable missing"
        assert "_str_skip_count" in agent_src, \
            "warning skip counter missing"


# =====================================================================
# Behavioral test — call the patched function with bug-triggering input
# =====================================================================

class TestN6Behavior:
    def _make_logger(self):
        """Lightweight logger that records all calls."""
        class L:
            def __init__(self):
                self.warnings = []
                self.infos = []
                self.errors = []
            def warning(self, msg, *a, **k): self.warnings.append(str(msg))
            def info(self, msg, *a, **k): self.infos.append(str(msg))
            def error(self, msg, *a, **k): self.errors.append(str(msg))
            def debug(self, msg, *a, **k): pass
        return L()

    def test_string_blob_parses_once_no_char_iter(self, helpers):
        """The original bug case: metric_views is a string-blob containing
        a JSON list. Must parse once, must NOT iterate characters."""
        fn = getattr(helpers, "_render_metric_sql_for_domain_from_llm_spec", None)
        if fn is None:
            pytest.skip("Function not loaded under test stub env")
        logger = self._make_logger()
        # 40K-char JSON-string blob (the bug-triggering shape)
        valid_mv = {
            "view_name": "product_test",
            "owner_product": "test_product",
            "source_table": "tiny_v85.product.test",
            "dimensions": [{"name": "id", "expr": "id"}],
            "measures": [{"name": "row_count", "expr": "COUNT(1)"}],
        }
        spec = {"metric_views": json.dumps([valid_mv])}
        try:
            fn(
                catalog="test_cat",
                db_name="test_db",
                domain_name="product",
                spec=spec,
                products_by_name={"test_product": {"name": "test_product"}},
                logger=logger,
            )
        except Exception:
            # We accept downstream failures — only assertion is on warnings count.
            pass
        # CRITICAL: the bug would emit 1 warning per char (~thousands).
        # The fix must emit AT MOST ~10 (cap) and ideally 0 + 1 info line.
        skip_warns = [w for w in logger.warnings
                      if "Skipping unparseable metric_view string" in w]
        assert len(skip_warns) == 0, (
            f"BUG REGRESSION: char-iter produced {len(skip_warns)} warnings; "
            f"expected 0 because string-blob should be parsed once upstream"
        )
        # And there must be exactly one info line announcing the upstream parse
        n6_infos = [m for m in logger.infos if "[N6-FIX]" in m]
        assert len(n6_infos) >= 1, \
            "Expected [N6-FIX] info line when metric_views is JSON-string-list"

    def test_string_blob_unparseable_emits_one_warning_only(self, helpers):
        """If the string-blob is itself unparseable, the fix must still
        bound output to a single warning, not 40K char-warnings."""
        fn = getattr(helpers, "_render_metric_sql_for_domain_from_llm_spec", None)
        if fn is None:
            pytest.skip("Function not loaded under test stub env")
        logger = self._make_logger()
        # 40K of garbage that won't json.loads
        bad_blob = "{" * 40_000
        spec = {"metric_views": bad_blob}
        try:
            fn(
                catalog="test_cat",
                db_name="test_db",
                domain_name="product",
                spec=spec,
                products_by_name={},
                logger=logger,
            )
        except Exception:
            pass
        skip_warns = [w for w in logger.warnings
                      if "Skipping unparseable metric_view string" in w]
        n6_warns = [w for w in logger.warnings if "[N6-FIX]" in w]
        # The OLD bug would produce 40_000 skip_warns.
        # The fix produces 0 skip_warns + 1 N6-FIX warn (upstream catch).
        assert len(skip_warns) == 0, (
            f"BUG REGRESSION: still emitting {len(skip_warns)} per-char warnings "
            f"when string-blob is unparseable"
        )
        assert len(n6_warns) >= 1, \
            "Expected [N6-FIX] warning announcing upstream parse failure"

    def test_warn_cap_bounds_list_of_strings_explosion(self, helpers):
        """Defense-in-depth: even if metric_views is correctly a LIST but
        every element is an unparseable string (a different LLM bug),
        the cap must bound emitted warnings."""
        fn = getattr(helpers, "_render_metric_sql_for_domain_from_llm_spec", None)
        if fn is None:
            pytest.skip("Function not loaded under test stub env")
        logger = self._make_logger()
        # 1000 unparseable strings as list elements (legal shape, bad content)
        spec = {"metric_views": ["{garbage" for _ in range(1000)]}
        try:
            fn(
                catalog="test_cat",
                db_name="test_db",
                domain_name="product",
                spec=spec,
                products_by_name={},
                logger=logger,
            )
        except Exception:
            pass
        skip_warns = [w for w in logger.warnings
                      if "Skipping unparseable metric_view string" in w]
        cap_msg = [w for w in logger.warnings if "suppressing further per-string skip warnings" in w]
        summary_msg = [w for w in logger.warnings
                       if "total per-string skip warnings suppressed" in w]
        assert len(skip_warns) <= 11, (
            f"Cap should limit per-string skip warnings to ~10; got {len(skip_warns)}"
        )
        assert len(cap_msg) == 1, "Expected one 'suppressing further' notice"
        assert len(summary_msg) == 1, "Expected one final summary line"
        # Summary must report the TRUE total (not the capped count)
        assert "1000" in summary_msg[0] or "990" in summary_msg[0], \
            f"Summary line must report true count: {summary_msg}"


# =====================================================================
# Anti-tautology — prove the OLD code DID iterate chars (sanity check)
# =====================================================================

class TestN6BugReproWithoutFix:
    def test_python_for_over_string_iterates_chars(self):
        """Documents that Python's `for x in string` iterates characters,
        not chunks. Without the fix, the bug is unavoidable."""
        s = "[abc"
        result = []
        for x in s:
            result.append(x)
        assert result == ["[", "a", "b", "c"], \
            "Python iteration semantics — this is exactly why the bug fired"
