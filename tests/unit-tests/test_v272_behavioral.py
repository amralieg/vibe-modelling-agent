"""Behavioral tests for v2.7.2 (mv-exact-count + ddl-drop-empty-product).

Pre-fix evidence: NCDOT new-base baseline v2.7.1 (run 915669391125577,
TERMINATED SUCCESS) produced 11 metric views while the vibe said
"EXACTLY 3 metric views". Root cause: step_generate_kpi_first_metric_views
computed target_kpi_count = max(5, min(120, max(len(domains)*5, len(products)//2)))
= 42 for 84 products, and step_generate_metric_view_artifacts (per-domain
gap-fill) added 8 extra project_* MVs. Neither honored the explicit vibe count.

Also: a malformed empty-named phantom product (hr.'') reached the DDL pre-check,
got hr..termination_id, fell back to unknown_table -> only 83/84 tables created
plus a SET TAGS failure on unknown_table.

v2.7.2 fixes:
- _vibe_exact_metric_view_directive: parse the explicit MV count from the vibe.
- mv-exact-count: override target_kpi_count with the vibe count.
- mv-exact-trim: hard-trim kpi_views to exactly N by vibe relevance.
- mv-gapfill-suppress: early-return step_generate_metric_view_artifacts.
- ddl-drop-empty-product: drop empty-named products before DDL.
"""
import json
import re
from pathlib import Path

NB_PATH = Path(__file__).parent.parent.parent / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _nb_src():
    nb = json.loads(NB_PATH.read_text())
    cells = nb.get("cells", [])
    return "\n".join("".join(c.get("source", [])) for c in cells if c.get("cell_type") == "code")


def _extract_func(src, name):
    """Extract a top-level `def name(...):` body up to the next column-0 `def `/`class `."""
    lines = src.split("\n")
    start = None
    for i, ln in enumerate(lines):
        if ln.startswith(f"def {name}("):
            start = i
            break
    assert start is not None, f"function {name} not found in notebook source"
    end = len(lines)
    for j in range(start + 1, len(lines)):
        if lines[j].startswith("def ") or lines[j].startswith("class "):
            end = j
            break
    return "\n".join(lines[start:end])


def _load_directive_fn():
    src = _nb_src()
    func_src = _extract_func(src, "_vibe_exact_metric_view_directive")
    ns = {"get_vibes_from_config": lambda *a, **k: ""}
    exec(compile(func_src, "<directive>", "exec"), ns)
    return ns["_vibe_exact_metric_view_directive"]


# ---------- version / sentinel ----------

def test_agent_version_bumped_to_272():
    src = _nb_src()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m, "missing __AGENT_VERSION__"
    parts = tuple(int(x) for x in m.group(1).split("."))
    assert parts >= (2, 7, 2), f"expected >= 2.7.2, got {m.group(1)}"


def test_v272_aliases_present():
    src = _nb_src()
    for a in ("mv-exact-count", "mv-exact-trim", "mv-gapfill-suppress", "ddl-drop-empty-product"):
        assert a in src, f"missing alias {a}"


# ---------- behavioral: directive detection (executes the real function) ----------

def test_directive_detects_exactly_3_digit():
    fn = _load_directive_fn()
    n, low = fn({"model_vibes": "We need EXACTLY 3 metric views and nothing else."})
    assert n == 3, f"expected 3, got {n}"
    assert "metric views" in low


def test_directive_detects_real_ncdot_filler_phrasing():
    """v2.7.3 regression: the REAL NCDOT vibe says 'build EXACTLY these 3 metric views'.
    The word 'these' between 'exactly' and '3' broke v2.7.2's rigid regex -> 14 MVs live.
    This is the exact phrasing that must now parse to 3."""
    fn = _load_directive_fn()
    for phrasing in (
        "### Metric views (build EXACTLY these 3 metric views)",
        "build the following 3 metric views",
        "produce only these three metric views",
        "create exactly the 2 metric views below",
    ):
        n, _ = fn({"model_vibes": phrasing})
        assert n in (2, 3), f"filler phrasing not parsed: {phrasing!r} -> {n}"


def test_directive_detects_word_number():
    fn = _load_directive_fn()
    n, _ = fn({"business_description": "Produce only three metric views for executives."})
    assert n == 3, f"expected 3 from word-number, got {n}"


def test_directive_detects_total_phrasing():
    fn = _load_directive_fn()
    n, _ = fn({"model_vibes": "Generate 2 metric views total, suppress all others."})
    assert n == 2, f"expected 2, got {n}"


def test_directive_silent_returns_none():
    """The critical anti-tautology case: a vibe WITHOUT an explicit MV count
    MUST return None so the size-based default is untouched (zero risk to silent runs)."""
    fn = _load_directive_fn()
    n, low = fn({"model_vibes": "Build a rich HR and project model with good FK density."})
    assert n is None, f"expected None for silent vibe, got {n}"
    assert low == ""


def test_directive_no_vibe_returns_none():
    fn = _load_directive_fn()
    n, low = fn({})
    assert n is None and low == ""


# ---------- wiring: override + suppress + trim are present at the right sites ----------

def test_kpi_first_overrides_target_with_vibe_count():
    src = _nb_src()
    kpi = _extract_func(src, "step_generate_kpi_first_metric_views")
    assert "_vibe_exact_metric_view_directive(widgets_values)" in kpi
    assert "target_kpi_count = _exact_mv_n" in kpi, "override of target_kpi_count missing"
    assert "[mv-exact-trim FIRED]" in kpi, "kpi_views trim missing"


def test_gapfill_step_early_returns_when_exact_count_set():
    src = _nb_src()
    gap = _extract_func(src, "step_generate_metric_view_artifacts")
    # the guard must appear BEFORE the heavy work (i.e., near the top, before catalog logic)
    guard_idx = gap.find("[mv-gapfill-suppress FIRED]")
    assert guard_idx != -1, "gap-fill suppression guard missing"
    # there must be a `return` right after the guard log
    after = gap[guard_idx: guard_idx + 400]
    assert re.search(r"\breturn\b", after), "gap-fill guard does not return early"


def test_ddl_drop_empty_product_guard_present():
    src = _nb_src()
    assert "ddl-drop-empty-product" in src
    # the guard filters products with empty/whitespace name
    assert "if not (p.get('product') or '').strip()" in src
