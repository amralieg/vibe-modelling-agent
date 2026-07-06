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

v2.7.2/v2.7.3 used REGEX to parse the MV count from the raw vibe. That violated the
user's directive to rely 100% on LLM interpretation AND CLAUDE.md 3d (regex extraction
of user directives is the canonical anti-pattern when VIBE_PARSE_PROMPT already LLM-parses
the vibe), and it broke on "build EXACTLY these 3 metric views" (the word "these").

v2.7.4 fixes (LLM-sourced, NO regex):
- VIBE_PARSE_PROMPT + _VIBE_PARSE_RESPONSE_SCHEMA: added max_metric_views/min_metric_views/
  explicit_metric_views to sizing_directives (same USER-KING mechanism as max_domains).
- _vibe_exact_metric_view_directive: now READS vibe_classification.sizing_directives (no regex).
- mv-exact-count: override target_kpi_count with the LLM-extracted count.
- mv-exact-trim: trim kpi_views to N ranked by overlap with LLM explicit_metric_views names.
- mv-gapfill-suppress: early-return step_generate_metric_view_artifacts.
- ddl-drop-empty-product: drop empty-named products before DDL (confirmed live on v272).
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
    ns = {}
    exec(compile(func_src, "<directive>", "exec"), ns)
    return ns["_vibe_exact_metric_view_directive"]


def _vc(**sd):
    """build a widgets_values carrying an LLM vibe_classification.sizing_directives."""
    return {"vibe_classification": {"sizing_directives": sd}}


# ---------- version / sentinel ----------

def test_agent_version_bumped():
    src = _nb_src()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m, "missing __AGENT_VERSION__"
    parts = tuple(int(x) for x in m.group(1).split("."))
    assert parts >= (2, 7, 4), f"expected >= 2.7.4, got {m.group(1)}"


def test_aliases_present():
    src = _nb_src()
    for a in ("mv-exact-count", "mv-exact-trim", "mv-gapfill-suppress", "ddl-drop-empty-product"):
        assert a in src, f"missing alias {a}"


# ---------- anti-regression: the directive MUST be LLM-sourced, NO REGEX ----------

def test_directive_helper_uses_no_regex():
    """User directive + CLAUDE.md 3d: the metric-view count MUST come from the LLM
    (vibe_classification.sizing_directives), NEVER from regex over the raw vibe.
    This guards against re-introducing the v2.7.2/v2.7.3 regex anti-pattern."""
    src = _nb_src()
    fn_src = _extract_func(src, "_vibe_exact_metric_view_directive")
    assert "import re" not in fn_src, "regex import re-introduced into the directive helper"
    assert "re.search" not in fn_src and "re.match" not in fn_src, "regex matching in directive helper"
    assert "vibe_classification" in fn_src, "helper must read the LLM vibe_classification"
    assert "sizing_directives" in fn_src, "helper must read sizing_directives"


def test_llm_schema_carries_metric_view_fields():
    """The LLM VIBE_PARSE schema + prompt must extract the MV count, so the count is an
    LLM interpretation, not a downstream regex."""
    src = _nb_src()
    for f in ("max_metric_views", "min_metric_views", "explicit_metric_views"):
        assert f in src, f"LLM sizing_directives schema missing {f}"


# ---------- behavioral: directive reads LLM-extracted fields (executes the real function) ----------

def test_directive_reads_llm_exact_count():
    fn = _load_directive_fn()
    n, names = fn(_vc(max_metric_views=3, min_metric_views=3,
                      explicit_metric_views=["Vacancy Rate", "Retirement Eligibility",
                                             "Total Positions and Active Employees"]))
    assert n == 3, f"expected 3 from LLM max_metric_views, got {n}"
    assert len(names) == 3


def test_directive_names_only_infers_count():
    fn = _load_directive_fn()
    n, names = fn(_vc(max_metric_views=None, min_metric_views=None,
                      explicit_metric_views=["Vacancy Rate", "Retirement Eligibility"]))
    assert n == 2, f"expected 2 from named MVs, got {n}"


def test_directive_silent_returns_none():
    """A vibe the LLM parsed with NO metric-view directive MUST return None so the
    size-based default is untouched (zero risk to silent runs)."""
    fn = _load_directive_fn()
    n, names = fn(_vc(max_metric_views=None, min_metric_views=None, explicit_metric_views=[]))
    assert n is None, f"expected None for silent vibe, got {n}"
    assert names == []


def test_directive_no_classification_returns_none():
    fn = _load_directive_fn()
    n, names = fn({})
    assert n is None and names == []


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
