import json
import os
import re
import textwrap

import pytest

NB = os.path.join(
    os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb"
)


def _all_code():
    nb = json.load(open(NB))
    return "".join(
        "".join(c.get("source", []))
        for c in nb["cells"]
        if c.get("cell_type") == "code"
    )


def _extract_func_source(src, func_name):
    lines = src.splitlines(keepends=True)
    out, capturing, indent = [], False, None
    for ln in lines:
        if ln.lstrip().startswith(f"def {func_name}"):
            capturing = True
            indent = len(ln) - len(ln.lstrip())
            out.append(ln)
            continue
        if capturing:
            stripped = ln.strip()
            cur = len(ln) - len(ln.lstrip())
            if stripped and cur <= indent and (
                stripped.startswith("def ") or stripped.startswith("class ")
            ):
                break
            out.append(ln)
    assert out, f"{func_name} not found"
    return textwrap.dedent("".join(out))


def _extract_assign(src, name):
    # both regex globals we need are single-line assignments; literal parens inside
    # the regex strings make paren-balancing unreliable, so grab the one line.
    for ln in src.splitlines(keepends=True):
        if ln.lstrip().startswith(f"{name} ="):
            return textwrap.dedent(ln)
    raise AssertionError(f"{name} assignment not found")


@pytest.fixture(scope="module")
def ns():
    src = _all_code()
    g = {"re": re}
    exec(_extract_assign(src, "_METRIC_AGG_FUNCS_RE"), g)
    exec(_extract_assign(src, "_AGG_CALL_RE"), g)
    exec(_extract_func_source(src, "_cast_arith_operands_in_aggregates"), g)
    return g


def cast(ns, expr):
    return ns["_cast_arith_operands_in_aggregates"](expr)


def test_sum_of_addition_casts_both_operands(ns):
    # PASS-POST: the exact ncdot failure shape
    out = cast(ns, "SUM(full_time_count + part_time_count)")
    assert out == "SUM(CAST(full_time_count AS DOUBLE) + CAST(part_time_count AS DOUBLE))", out


def test_sum_single_column_unchanged_negative_control(ns):
    # no arithmetic -> the single-column CAST regex (elsewhere) owns this; helper must no-op
    assert cast(ns, "SUM(head_count)") == "SUM(head_count)"


def test_numeric_literals_not_cast(ns):
    out = cast(ns, "SUM(amount * 100)")
    assert out == "SUM(CAST(amount AS DOUBLE) * 100)", out


def test_already_cast_left_alone(ns):
    e = "SUM(CAST(a AS DOUBLE) + CAST(b AS DOUBLE))"
    assert cast(ns, e) == e


def test_case_expression_not_corrupted(ns):
    e = "SUM(CASE WHEN active = 1 THEN salary ELSE 0 END)"
    assert cast(ns, e) == e


def test_ratio_with_nested_calls_not_touched(ns):
    e = "SUM(revenue) / NULLIF(SUM(orders), 0)"
    assert cast(ns, e) == e


def test_round_wrapper_preserved(ns):
    out = cast(ns, "ROUND(SUM(a + b), 2)")
    assert out == "ROUND(SUM(CAST(a AS DOUBLE) + CAST(b AS DOUBLE)), 2)", out


def test_three_operand_subtraction(ns):
    out = cast(ns, "SUM(gross - tax - discount)")
    assert out == (
        "SUM(CAST(gross AS DOUBLE) - CAST(tax AS DOUBLE) - CAST(discount AS DOUBLE))"
    ), out


def test_full_sanitizer_wires_the_helper(ns):
    # the production sanitizer must call the helper (wiring guard)
    src = _all_code()
    assert "expr = _cast_arith_operands_in_aggregates(expr)" in src
    assert "mv-agg-arith-cast FIRED" in src


if __name__ == "__main__":
    import sys

    sys.exit(pytest.main([__file__, "-v"]))
