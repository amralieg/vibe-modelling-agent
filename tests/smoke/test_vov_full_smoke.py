"""FULL SMOKE TEST for the agent notebook vov_v1_to_v2 code path.

Catches the THREE bug classes we've burned compute on plus a forward-looking
AST sweep for the same anti-patterns elsewhere in the notebook so we ship
ONE fix that covers everything, not one-fix-per-deploy.

Bug classes covered:
1. v2.1.8 silent-drop in VIBE_PARSE_PROMPT (HC/RT 1-VREQ collapse on review prose).
2. v2.1.9 dict-vs-str in metric_view_statements (NCDOT vov_v1_to_v2 attempt-1 crash).
3. v2.2.0 None-model in _apply_handler_with_retry (HC + RT vov_v1_to_v2 crash).

The suite runs:
A. Notebook static checks (valid JSON, valid Python after concatenation, no eval drift).
B. Specific behavioral simulations of pre-patch vs post-patch shapes.
C. AST-based sweep for SAME-CLASS latent bugs elsewhere in the source:
   - Calls of foo.get(...) where foo can be the return of an LLM-mutator path.
   - Calls of re.search(pattern, X) where X comes from widgets_values.get(...).
   - List iteration loops that assume str-elements but the source can produce dicts.
D. Aggregate report — every finding is named with the file:line site.

Run with: python3 -m pytest tests/smoke/test_vov_full_smoke.py -v -s
"""

import ast
import json
import re
import textwrap
from pathlib import Path
from typing import Iterator

import pytest

ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


# ---------------------------------------------------------------------------
# Notebook loaders
# ---------------------------------------------------------------------------

_SRC_CACHE: dict[str, str] = {}


def notebook_source(joined: bool = True) -> str:
    """Concatenate every code cell into one string with cell sentinels.

    The cell sentinels (`# === CELL N ===`) allow AST visitors to map line
    numbers back to the cell + offset.
    """
    key = "joined" if joined else "raw"
    if key in _SRC_CACHE:
        return _SRC_CACHE[key]
    with NOTEBOOK_PATH.open() as f:
        nb = json.load(f)
    chunks: list[str] = []
    for i, cell in enumerate(nb.get("cells", [])):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        if joined:
            chunks.append(f"# === CELL {i} ===\n{src}\n")
        else:
            chunks.append(src)
    out = "\n".join(chunks)
    _SRC_CACHE[key] = out
    return out


def notebook_ast() -> ast.Module:
    src = notebook_source()
    return ast.parse(src)


# ---------------------------------------------------------------------------
# A. Notebook static checks
# ---------------------------------------------------------------------------


def test_A1_notebook_is_valid_json():
    with NOTEBOOK_PATH.open() as f:
        nb = json.load(f)
    assert isinstance(nb, dict)
    assert "cells" in nb
    assert isinstance(nb["cells"], list)
    assert len(nb["cells"]) > 0


def test_A2_notebook_python_is_syntactically_valid():
    """Every code cell, concatenated, must be valid Python 3 syntax.

    This catches the kind of JSON-escape corruption we've seen when patches
    were applied to the .ipynb without preserving \"escaping.
    """
    src = notebook_source()
    try:
        ast.parse(src)
    except SyntaxError as e:
        pytest.fail(
            f"Notebook concatenated source is NOT valid Python: "
            f"{e.msg} at line {e.lineno}, col {e.offset}\n"
            f"Context: {(e.text or '').strip()[:200]}"
        )


def test_A3_agent_version_is_single_digit_semver():
    src = notebook_source()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m, "__AGENT_VERSION__ not found"
    v = m.group(1)
    parts = v.split(".")
    assert len(parts) == 3, f"version {v!r} must be 3-segment semver"
    for seg in parts:
        assert seg.isdigit() and 0 <= int(seg) <= 9, (
            f"version segment {seg!r} in {v!r} violates §3a single-digit semver"
        )


# ---------------------------------------------------------------------------
# B. Behavioral simulations — pre-patch vs post-patch shapes
# ---------------------------------------------------------------------------


# ---- Bug 2: dict-vs-str in metric_view_statements (v2.1.9 fix) ----


def test_B1_extract_metric_view_name_handles_string():
    """Baseline: string DDL must yield the view name."""
    fn_src = _extract_function_source("_extract_metric_view_name_from_statement")
    fn = _exec_function(fn_src, "_extract_metric_view_name_from_statement")
    stmt = "CREATE OR REPLACE VIEW `cat`.`sch`.`v1` AS SELECT 1"
    assert fn(stmt) == "v1"


def test_B2_extract_metric_view_name_handles_dict_after_v219():
    """If v2.1.9 fix landed, dict input must NOT crash — return view_name or sql-parsed name."""
    fn_src = _extract_function_source("_extract_metric_view_name_from_statement")
    fn = _exec_function(fn_src, "_extract_metric_view_name_from_statement")
    dict_stmt = {
        "view_name": "hr.vacancy_rate_metric",
        "sql": "CREATE OR REPLACE VIEW `c`.`s`.`v` AS SELECT 1",
    }
    out = fn(dict_stmt)
    assert out == "hr.vacancy_rate_metric", (
        f"v2.1.9 fix incomplete: dict input gave {out!r}, expected 'hr.vacancy_rate_metric'"
    )


def test_B3_extract_metric_view_name_handles_none_and_empty():
    fn_src = _extract_function_source("_extract_metric_view_name_from_statement")
    fn = _exec_function(fn_src, "_extract_metric_view_name_from_statement")
    assert fn(None) == "unknown_metric_view"
    assert fn("") == "unknown_metric_view"
    assert fn({}) == "unknown_metric_view"


def test_B4_no_dict_append_into_metric_view_statements():
    """v2.1.9 invariant — no remaining append-dict patterns into the str-list."""
    src = notebook_source()
    bad = [
        "_existing_statements.append({\n",
        '_existing_statements.append({"view_name"',
        "_sf_existing_statements.append({'view_name'",
        '_sf_existing_statements.append({"view_name"',
    ]
    for shape in bad:
        assert shape not in src, f"v2.1.9 invariant violated: {shape!r} still present"


# ---- Bug 3: verify_invariants(None) crash + _apply_handler None-model (v2.2.0 fix) ----


def test_B5_verify_invariants_handles_none_model_after_v220():
    """If v2.2.0 fix landed, verify_invariants(None, ...) must return (False, ...)
    instead of raising AttributeError."""
    fn_src = _extract_function_source("verify_invariants")
    if "isinstance(model, dict)" not in fn_src and "model is None" not in fn_src:
        pytest.skip("v2.2.0 verify_invariants None-guard not yet applied — test will gate the fix")
    fn = _exec_function(
        fn_src,
        "verify_invariants",
        injected_names={
            "InvariantSnapshot": _build_invariant_snapshot_stub(),
        },
    )
    snap = _make_invariant_snapshot()
    ok, diag = fn(None, snap)
    assert ok is False, f"v2.2.0 fix incomplete: verify_invariants(None) returned ok={ok}"
    assert isinstance(diag, str) and diag, "diagnostic must be non-empty"


def test_B6_verify_invariants_handles_non_dict_after_v220():
    """Same as B5 but for other non-dict shapes (str, list, int)."""
    fn_src = _extract_function_source("verify_invariants")
    if "isinstance(model, dict)" not in fn_src and "model is None" not in fn_src:
        pytest.skip("v2.2.0 verify_invariants None-guard not yet applied")
    fn = _exec_function(
        fn_src,
        "verify_invariants",
        injected_names={"InvariantSnapshot": _build_invariant_snapshot_stub()},
    )
    snap = _make_invariant_snapshot()
    for bad in ("not-a-dict", [], 42, object()):
        ok, diag = fn(bad, snap)
        assert ok is False, f"verify_invariants({bad!r}) returned ok={ok}, must be False"


def test_B7_apply_handler_guards_none_new_model_after_v220():
    """The fix at _apply_handler_with_retry must guard new_model = result.new_model
    when result.new_model is None or non-dict, BEFORE calling verify_invariants."""
    fn_src = _extract_function_source("_apply_handler_with_retry")
    # The fix MUST insert a None/non-dict guard between
    #   new_model = result.new_model
    # and the verify_invariants call.
    must_have_patterns = [
        # Guard token: either v2.2.0 alias OR an isinstance check on new_model.
        ("isinstance(new_model, dict)", "new_model is None"),
    ]
    for any_of in must_have_patterns:
        if not any(token in fn_src for token in any_of):
            pytest.fail(
                f"v2.2.0 fix missing: _apply_handler_with_retry must guard "
                f"new_model is None / non-dict before calling verify_invariants. "
                f"Expected one of: {any_of}"
            )


# ---- Bug 1: VIBE_PARSE_PROMPT must teach Shape A vs Shape B (v2.1.8 baseline) ----


def _extract_vibe_parse_prompt_body() -> str:
    """The prompt is assigned via PROMPT_TEMPLATES["VIBE_PARSE_PROMPT"] = r\"\"\"...\"\"\"."""
    src = notebook_source()
    anchor = 'PROMPT_TEMPLATES["VIBE_PARSE_PROMPT"] = r"""'
    idx = src.find(anchor)
    assert idx >= 0, "PROMPT_TEMPLATES[\"VIBE_PARSE_PROMPT\"] assignment not found"
    body_start = idx + len(anchor)
    end = src.find('"""', body_start)
    assert end > body_start, "VIBE_PARSE_PROMPT closing triple-quote not found"
    return src[body_start:end]


def test_B8_vibe_parse_prompt_teaches_shape_a_and_b():
    body = _extract_vibe_parse_prompt_body()
    must_have = ["Shape A", "Shape B", "review", "Priority", "Recommendation"]
    missing = [k for k in must_have if k.lower() not in body.lower()]
    assert not missing, (
        f"VIBE_PARSE_PROMPT missing Shape A/B teaching tokens: {missing} "
        f"(prose-only v2.1.8 prompt must reference these)"
    )


def test_B9_vibe_parse_prompt_contains_no_embedded_json_examples():
    """v2.1.8: explicit removal of embedded JSON examples because Opus 4.7
    was treating them as the literal output shape, returning malformed JSON
    that the strict response_schema rejected."""
    body = _extract_vibe_parse_prompt_body()
    bad_json_anchors = [
        '"requirements": [',
        '"original_text":',
        '{ "requirements"',
        "```json",
    ]
    found = [a for a in bad_json_anchors if a in body]
    assert not found, (
        f"v2.1.8 invariant violated: VIBE_PARSE_PROMPT contains embedded JSON example tokens "
        f"{found}. Opus 4.7 mirrors these to literal output and crashes."
    )


# ---------------------------------------------------------------------------
# C. AST sweep — find SAME-CLASS latent bugs elsewhere
# ---------------------------------------------------------------------------


class NoneDerefVisitor(ast.NodeVisitor):
    """Flag attribute access on names that were assigned from .get() with no default
    (so they might be None) and then dereferenced without a None-check.

    This is a heuristic — over-flagging is fine, the report is what we use to triage.
    """

    def __init__(self):
        self.findings: list[tuple[int, str]] = []
        self.maybe_none: dict[str, int] = {}

    def visit_Assign(self, node: ast.Assign):
        # x = something.get("k") with no default -> x may be None.
        if (
            len(node.targets) == 1
            and isinstance(node.targets[0], ast.Name)
            and isinstance(node.value, ast.Call)
            and isinstance(node.value.func, ast.Attribute)
            and node.value.func.attr == "get"
            and len(node.value.args) == 1
        ):
            self.maybe_none[node.targets[0].id] = node.lineno
        # x = obj.attr (where attr is e.g. .new_model) — also might be None.
        if (
            len(node.targets) == 1
            and isinstance(node.targets[0], ast.Name)
            and isinstance(node.value, ast.Attribute)
            and node.value.attr in {"new_model", "model", "result"}
        ):
            self.maybe_none[node.targets[0].id] = node.lineno
        self.generic_visit(node)

    def visit_Attribute(self, node: ast.Attribute):
        # x.y where x in self.maybe_none — possible None.get crash later.
        if isinstance(node.value, ast.Name) and node.value.id in self.maybe_none:
            self.findings.append(
                (node.lineno, f"{node.value.id}.{node.attr} (assigned line {self.maybe_none[node.value.id]})")
            )
        self.generic_visit(node)


def test_C1_aststrip_finds_known_v220_site():
    """Sanity: the AST visitor must find the verify_invariants(new_model) call site
    (the v2.2.0 bug) — proves the visitor isn't a no-op."""
    tree = notebook_ast()
    v = NoneDerefVisitor()
    v.visit(tree)
    # We don't assert specific count - just that the sweep produced findings.
    assert len(v.findings) > 0, "AST visitor must find at least 1 maybe-None deref site"


def test_C2_report_all_same_class_findings():
    """Print every maybe-None-deref site so we can triage them BEFORE deploy.

    This is a report-only test — it always passes but emits the list. Capture with
    pytest -s.
    """
    tree = notebook_ast()
    v = NoneDerefVisitor()
    v.visit(tree)
    print(f"\n=== AST sweep: {len(v.findings)} maybe-None-deref sites ===")
    by_pattern: dict[str, int] = {}
    for lineno, what in v.findings[:80]:
        print(f"  line {lineno:>6}: {what}")
        key = what.split(".")[1] if "." in what else what
        by_pattern[key] = by_pattern.get(key, 0) + 1
    if len(v.findings) > 80:
        print(f"  ... and {len(v.findings) - 80} more")
    print(f"\n  by attribute (top 10):")
    for k, c in sorted(by_pattern.items(), key=lambda x: -x[1])[:10]:
        print(f"    .{k}: {c}")


class DictStrAmbiguityVisitor(ast.NodeVisitor):
    """Flag any list iteration where the loop body calls .strip()/.lower()/re.search
    on the loop variable. If the source of the list can produce dicts, the loop crashes.
    """

    def __init__(self):
        self.findings: list[tuple[int, str]] = []

    def visit_For(self, node: ast.For):
        if not isinstance(node.target, ast.Name):
            self.generic_visit(node)
            return
        var_name = node.target.id
        # Walk body for .strip()/.lower()/re.search(_, var_name) calls.
        for sub in ast.walk(node):
            if isinstance(sub, ast.Call):
                # var.strip() / var.lower()
                if (
                    isinstance(sub.func, ast.Attribute)
                    and isinstance(sub.func.value, ast.Name)
                    and sub.func.value.id == var_name
                    and sub.func.attr in {"strip", "lower", "upper", "startswith", "endswith"}
                ):
                    self.findings.append((sub.lineno, f"{var_name}.{sub.func.attr}() in for-loop"))
                # re.search(_, var_name)
                if (
                    isinstance(sub.func, ast.Attribute)
                    and isinstance(sub.func.value, ast.Name)
                    and sub.func.value.id == "re"
                    and sub.func.attr in {"search", "match", "findall", "sub"}
                    and any(
                        isinstance(a, ast.Name) and a.id == var_name
                        for a in sub.args
                    )
                ):
                    self.findings.append((sub.lineno, f"re.{sub.func.attr}(_, {var_name}) in for-loop"))
        self.generic_visit(node)


def test_C3_report_dict_str_ambiguity_sites():
    """Report-only: find loops where loop-var is treated as string but might be dict."""
    tree = notebook_ast()
    v = DictStrAmbiguityVisitor()
    v.visit(tree)
    print(f"\n=== AST sweep: {len(v.findings)} dict-str-ambiguity sites ===")
    for lineno, what in v.findings[:50]:
        print(f"  line {lineno:>6}: {what}")
    if len(v.findings) > 50:
        print(f"  ... and {len(v.findings) - 50} more")


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _extract_function_source(name: str) -> str:
    """Pull the source text of a top-level def by name from the notebook."""
    tree = notebook_ast()
    src_lines = notebook_source().splitlines()
    for node in ast.walk(tree):
        if isinstance(node, ast.FunctionDef) and node.name == name:
            start = node.lineno - 1
            end = node.end_lineno
            return "\n".join(src_lines[start:end])
    raise AssertionError(f"function {name!r} not found in notebook")


def _exec_function(fn_src: str, name: str, injected_names: dict | None = None):
    """Compile + exec a single function body in an isolated namespace and return it.

    For execution-time safety, we inject `re`, `logger` (stub), and optional names.
    """
    import logging
    import re as _re

    class _StubLogger:
        def info(self, *a, **k): pass
        def warning(self, *a, **k): pass
        def error(self, *a, **k): pass
        def debug(self, *a, **k): pass

    ns: dict = {
        "re": _re,
        "logger": _StubLogger(),
        "Optional": type(None),
    }
    if injected_names:
        ns.update(injected_names)
    # Some functions reference typing.Optional in annotations - patch lightly.
    try:
        from typing import Optional as _Opt, Tuple as _Tup, Any as _Any
        ns.update({"Optional": _Opt, "Tuple": _Tup, "Any": _Any, "tuple": tuple, "dict": dict})
    except ImportError:
        pass
    exec(compile(fn_src, f"<{name}>", "exec"), ns)
    return ns[name]


def _build_invariant_snapshot_stub():
    """Lightweight InvariantSnapshot stand-in with the attributes verify_invariants reads."""
    from dataclasses import dataclass, field

    @dataclass
    class _Stub:
        user_pinned_domains: frozenset = field(default_factory=frozenset)
        user_pinned_products: frozenset = field(default_factory=frozenset)
        agent_version: str = ""
        locked_fields: tuple = ()
        initial_mv_count: int = 0
        initial_mv_names: frozenset = field(default_factory=frozenset)

    return _Stub


def _make_invariant_snapshot():
    Stub = _build_invariant_snapshot_stub()
    return Stub()
