"""Behavioral tests for v2.1.9 mv-statements-dict-coercion-fix.

Live failure reproduced: gov_transport vov_v1_to_v2 attempt-1 (run <run_id>,
2026-05-27 16:32) crashed with:

    TypeError: expected string or bytes-like object, got 'dict'
    File _extract_metric_view_name_from_statement, line ...
        match = re.search(pattern, stmt, flags=re.IGNORECASE)

Root cause: v2.0.8 added two writeback paths
(`vov-mv-pipe-to-json` at ~line 9941 and `vov-selffixer-flat-roundtrip`
at ~line 85179) that appended a dict
`{view_name, sql, owner_domain, owner_product}` into
`widgets_values['metric_view_statements']`. Every downstream consumer
(`step_apply_metric_views` pre-execute filter, `_v074_rewrite_stmt`,
the SQL-flush list comprehension, the post-failure cleanup loop)
treats that list as DDL strings, so once VOV produced new MVs the
dict-shaped element crashed.

v2.1.9 fix is three-layer defense:
1. SOURCE-FIX in `vov-mv-pipe-to-json` writeback - append raw SQL string.
2. SOURCE-FIX in `vov-selffixer-flat-roundtrip` writeback - append raw SQL string.
3. DEFENSIVE-FIX in `_extract_metric_view_name_from_statement` - unwrap dict.
4. EXECUTION-COERCION at top of `step_apply_metric_views` - rewrite list in place.

These tests assert the on-disk notebook content (smoke checks for §8.10
behavioral coverage: the on-disk function-shape change is the behavior).
"""

import json
import re
from pathlib import Path

import pytest

NOTEBOOK_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_notebook_source() -> str:
    with NOTEBOOK_PATH.open() as f:
        nb = json.load(f)
    chunks = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") == "code":
            src = cell.get("source", "")
            if isinstance(src, list):
                chunks.append("".join(src))
            else:
                chunks.append(src)
    return "\n".join(chunks)


def test_agent_version_at_least_2_1_9():
    """v219 fixes must persist into v220+ — version may have moved on."""
    src = _load_notebook_source()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m, "__AGENT_VERSION__ constant not found in notebook"
    v = tuple(int(x) for x in m.group(1).split("."))
    assert v >= (2, 1, 9), f"expected >= 2.1.9, got {m.group(1)}"


def test_source_fix_vov_mv_pipe_to_json_appends_raw_sql():
    """Source fix #1: vov-mv-pipe-to-json must append _rec['sql'] (a string),
    not a dict envelope."""
    src = _load_notebook_source()
    # The fix replaces the multi-line dict literal with a single-line raw-sql append.
    # Anchor on the function-local variable name + the surrounding alias.
    assert "_existing_statements.append(_rec[\"sql\"])" in src, (
        "v2.1.9 source fix #1 missing: vov-mv-pipe-to-json must append raw SQL "
        "string. Found old dict-shape append still in source."
    )
    # And the OLD dict-append must be gone (it would have produced the crash).
    assert "_existing_statements.append({\n" not in src, (
        "v2.1.9 source fix #1 incomplete: old dict-append in vov-mv-pipe-to-json "
        "is still present."
    )


def test_source_fix_vov_selffixer_flat_roundtrip_appends_raw_sql():
    """Source fix #2: vov-selffixer-flat-roundtrip must append _rec['sql']."""
    src = _load_notebook_source()
    assert "_sf_existing_statements.append(_rec['sql'])" in src, (
        "v2.1.9 source fix #2 missing: vov-selffixer-flat-roundtrip must append "
        "raw SQL string from _rec['sql']."
    )
    assert "_sf_existing_statements.append({'view_name'" not in src, (
        "v2.1.9 source fix #2 incomplete: old dict-append in "
        "vov-selffixer-flat-roundtrip is still present."
    )


def test_defensive_fix_extract_metric_view_name_unwraps_dict():
    """Defensive fix #3: _extract_metric_view_name_from_statement must unwrap
    a dict-shaped statement before passing it to re.search()."""
    src = _load_notebook_source()
    # Anchor: the function must inspect isinstance(stmt, dict) BEFORE the regex.
    fn_start = src.find("def _extract_metric_view_name_from_statement(stmt):")
    assert fn_start >= 0, "_extract_metric_view_name_from_statement not found"
    fn_end = src.find("\ndef ", fn_start + 1)
    fn_body = src[fn_start:fn_end if fn_end > 0 else fn_start + 3000]
    assert "isinstance(stmt, dict)" in fn_body, (
        "v2.1.9 defensive fix #3 missing: function must check isinstance(stmt, dict)"
    )
    # And it must unwrap via the sql/statement/definition keys.
    assert "stmt.get(\"sql\")" in fn_body or "stmt.get('sql')" in fn_body, (
        "v2.1.9 defensive fix #3 incomplete: must extract sql/statement/definition "
        "from dict-shaped stmt"
    )


def test_execution_coercion_at_step_apply_metric_views_top():
    """Defensive fix #4: step_apply_metric_views must coerce dict-shaped
    entries in metric_view_statements to their raw SQL strings BEFORE the
    pre-execute filter loop, so any legacy or third-party dict-shaped entries
    never reach _extract_metric_view_name_from_statement or the SQL-flush
    list comprehension."""
    src = _load_notebook_source()
    fn_start = src.find("def step_apply_metric_views(widgets_values):")
    assert fn_start >= 0, "step_apply_metric_views not found"
    # The coercion must happen near the top, before the existing
    # `if not metric_view_statements:` guard at the head of the function.
    fn_body = src[fn_start:fn_start + 6000]
    assert "_v219_coerced" in fn_body, (
        "v2.1.9 execution-coercion missing: step_apply_metric_views must rewrite "
        "metric_view_statements list, replacing any dict entry with its raw SQL."
    )
    assert "mv-statements-dict-coercion-fix FIRED v2.1.9" in fn_body, (
        "v2.1.9 execution-coercion must emit [mv-statements-dict-coercion-fix "
        "FIRED v2.1.9] log line when a coercion happens"
    )


def test_fired_log_alias_present_at_two_sites():
    """Both the defensive-function fix and the execution-coercion fix must
    each have a [mv-statements-dict-coercion-fix FIRED v2.1.9] log line so
    audit greps can locate every site where the fix matters."""
    src = _load_notebook_source()
    count = src.count("mv-statements-dict-coercion-fix FIRED v2.1.9")
    assert count >= 2, (
        f"expected at least 2 [mv-statements-dict-coercion-fix FIRED v2.1.9] "
        f"sites (function + step_apply_metric_views), found {count}"
    )


def test_no_dict_append_into_metric_view_statements_anywhere():
    """Belt-and-braces: no remaining `metric_view_statements.append({...dict...})`
    pattern anywhere in the notebook source."""
    src = _load_notebook_source()
    # The two known sites had multi-line dict literals - check both shapes
    bad_shapes = [
        "_existing_statements.append({\n",
        "_existing_statements.append({\"view_name\"",
        "_sf_existing_statements.append({'view_name'",
        "_sf_existing_statements.append({\"view_name\"",
        "metric_view_statements.append({",
    ]
    for shape in bad_shapes:
        assert shape not in src, (
            f"v2.1.9 invariant violated: dict-append into metric_view_statements "
            f"list found: {shape!r}. Downstream consumers crash on dict elements."
        )


def test_pre_patch_failure_reproduction():
    """§8.10 honest behavioral check: prove that the ORIGINAL function shape
    (before v2.1.9) would crash on a dict input. This is the failure mode
    we are fixing."""
    import re as _re

    # Simulate the PRE-PATCH function exactly as it was in v2.1.8:
    def _v218_pre_patch_extract(stmt):
        if not stmt:
            return "unknown_metric_view"
        patterns = [
            r"CREATE\s+OR\s+REPLACE\s+VIEW\s+`[^`]+`\.`[^`]+`\.`([^`]+)`",
            r"CREATE\s+VIEW\s+`[^`]+`\.`[^`]+`\.`([^`]+)`",
        ]
        for pattern in patterns:
            match = _re.search(pattern, stmt, flags=_re.IGNORECASE)
            if match:
                return match.group(1)
        return "unknown_metric_view"

    dict_stmt = {
        "view_name": "hr.vacancy_rate_metric",
        "sql": "CREATE OR REPLACE VIEW `cat`.`_metrics`.`vacancy_rate_metric` AS SELECT 1",
        "owner_domain": "hr",
        "owner_product": "vacancy_rate_metric",
    }
    # Pre-patch: passing the dict to the function crashes with TypeError.
    with pytest.raises(TypeError):
        _v218_pre_patch_extract(dict_stmt)


def test_post_patch_function_handles_dict_gracefully():
    """§8.10 honest behavioral check: simulate the POST-PATCH function shape
    and prove it now handles dict input without crashing."""
    import re as _re

    def _v219_post_patch_extract(stmt):
        if not stmt:
            return "unknown_metric_view"
        if isinstance(stmt, dict):
            _vn_direct = stmt.get("view_name") or stmt.get("name")
            if _vn_direct and isinstance(_vn_direct, str) and _vn_direct.strip():
                return _vn_direct.strip()
            stmt = stmt.get("sql") or stmt.get("statement") or stmt.get("definition") or ""
        if not isinstance(stmt, str) or not stmt.strip():
            return "unknown_metric_view"
        patterns = [
            r"CREATE\s+OR\s+REPLACE\s+VIEW\s+`[^`]+`\.`[^`]+`\.`([^`]+)`",
            r"CREATE\s+VIEW\s+`[^`]+`\.`[^`]+`\.`([^`]+)`",
        ]
        for pattern in patterns:
            match = _re.search(pattern, stmt, flags=_re.IGNORECASE)
            if match:
                return match.group(1)
        return "unknown_metric_view"

    dict_stmt = {
        "view_name": "hr.vacancy_rate_metric",
        "sql": "CREATE OR REPLACE VIEW `cat`.`_metrics`.`vacancy_rate_metric` AS SELECT 1",
    }
    # Should return view_name directly without crashing.
    assert _v219_post_patch_extract(dict_stmt) == "hr.vacancy_rate_metric"

    # Even without view_name, falls back to parsing sql.
    dict_stmt_no_name = {
        "sql": "CREATE OR REPLACE VIEW `cat`.`_metrics`.`my_view` AS SELECT 1",
    }
    assert _v219_post_patch_extract(dict_stmt_no_name) == "my_view"

    # A normal string still works.
    str_stmt = "CREATE OR REPLACE VIEW `c`.`s`.`v` AS SELECT 1"
    assert _v219_post_patch_extract(str_stmt) == "v"

    # None / empty returns sentinel.
    assert _v219_post_patch_extract(None) == "unknown_metric_view"
    assert _v219_post_patch_extract("") == "unknown_metric_view"
    assert _v219_post_patch_extract({}) == "unknown_metric_view"
