"""v3.8.0 pre-commit AST guard (item 21).

Fast, dependency-free: AST-parses EVERY code cell of the production notebook so a
syntax error / broken edit (the class that caused the transient 'str' crash) can
never slip into a commit or a deploy. Runs in ~1s (no notebook execution).

This is the deterministic guard the project lacked: every edit to the 6.6MB
notebook must keep all cells parseable. Notebook magics (%/!) are normalised to
`pass` before parsing (they are valid in Jupyter, not in ast.parse).

Usage as a standalone guard (pre-commit / pre-deploy):
    python3 tests/unit-tests/test_v380_notebook_ast_compiles.py
"""
import ast
import json
import os
import sys

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _iter_code_cells():
    nb = json.load(open(NB))
    for i, c in enumerate(nb.get("cells", [])):
        if c.get("cell_type") == "code":
            yield i, "".join(c.get("source", []))


def _normalise(src):
    out = []
    for ln in src.split("\n"):
        s = ln.lstrip()
        if s.startswith("%") or s.startswith("!"):
            out.append("pass")
        else:
            out.append(ln)
    return "\n".join(out)


def check_all_cells():
    failures = []
    n = 0
    for idx, src in _iter_code_cells():
        n += 1
        # A clean cell parses RAW (no normalisation). Only fall back to magic-
        # normalisation when the raw parse fails (genuine Jupyter %/! magics). This
        # avoids the false-positive where _normalise() would replace a %/!-leading
        # line INSIDE a multiline string literal with `pass`, corrupting the string
        # and reporting a spurious SyntaxError on a syntactically-valid cell.
        try:
            ast.parse(src)
            continue
        except SyntaxError:
            pass
        try:
            ast.parse(_normalise(src))
        except SyntaxError as e:
            failures.append((idx, f"{e.msg} (line {e.lineno})"))
    return n, failures


def test_every_notebook_cell_compiles():
    n, failures = check_all_cells()
    assert n > 0, "no code cells found — notebook path wrong?"
    assert not failures, "notebook cells with syntax errors: " + "; ".join(
        f"cell#{i}: {m}" for i, m in failures
    )


if __name__ == "__main__":
    n, failures = check_all_cells()
    if failures:
        print(f"[AST-GUARD FAIL] {len(failures)} cell(s) broken of {n}:")
        for i, m in failures:
            print(f"  cell#{i}: {m}")
        sys.exit(1)
    print(f"[AST-GUARD OK] all {n} code cells parse clean")
    sys.exit(0)
