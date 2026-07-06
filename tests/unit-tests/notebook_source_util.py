"""Load and slice functions from the full agent notebook (all code cells)."""
from __future__ import annotations

import ast
import json
from pathlib import Path
from typing import Optional

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def notebook_concat_source() -> str:
    nb = json.loads(NOTEBOOK_PATH.read_text(encoding="utf-8"))
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        if src.strip():
            parts.append(src)
    return "\n\n".join(parts)


def slice_function_source(fn_name: str, source: Optional[str] = None) -> str:
    """Return source of the last module-level function named fn_name."""
    source = source or notebook_concat_source()
    lines = source.splitlines(keepends=True)
    tree = ast.parse(source)
    target: Optional[ast.FunctionDef] = None
    for node in tree.body:
        if isinstance(node, ast.FunctionDef) and node.name == fn_name:
            target = node
    if target is None:
        raise LookupError(f"module-level def {fn_name!r} not found in agent notebook")
    start = target.lineno - 1
    end = target.end_lineno
    return "".join(lines[start:end])


def exec_function_namespace(
    fn_name: str,
    extra_globals: Optional[dict] = None,
    source: Optional[str] = None,
) -> dict:
    """Exec a notebook function into a namespace and return it."""
    fn_src = slice_function_source(fn_name, source=source)
    ns = {"__name__": f"_test_slice_{fn_name}"}
    if extra_globals:
        ns.update(extra_globals)
    exec(compile(fn_src, str(NOTEBOOK_PATH), "exec"), ns)
    return ns
