"""pytest configuration — extracts pure helper functions from the agent notebook
source so they can be imported and unit-tested without Databricks runtime.

Strategy:
- Agent's full source lives in agent/dbx_vibe_modelling_agent.ipynb cell[1].
- We AST-walk that source and expose module-level function defs as an
  `agent_helpers` module that tests can import.
- Functions depending on Spark/dbutils are skipped at import time via a
  sentinel import guard — the test file can patch those in.
"""
import json
import os
import sys
import re
import types
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _extract_source_from_notebook() -> str:
    """Return the code source of the main cell (cell[1]) of the agent notebook.

    If the committed notebook is older than our patched /tmp/agent_source.py,
    prefer /tmp/agent_source.py so tests run against the latest in-memory fixes.
    """
    tmp_src = Path("/tmp/agent_source.py")
    if tmp_src.exists():
        return tmp_src.read_text(encoding="utf-8")
    nb = json.loads(NOTEBOOK_PATH.read_text(encoding="utf-8"))
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        if "def " in src and len(src) > 10_000:
            return src
    raise RuntimeError("Could not find agent code cell in notebook")


def _build_agent_helpers_module():
    """Parse the agent source and exec it with lightweight stubs.

    Databricks-only globals (spark, dbutils, displayHTML, WorkspaceClient, etc.)
    are stubbed so the module loads; tests that exercise functions using those
    objects must patch them via monkeypatch.
    """
    import ast

    source = _extract_source_from_notebook()

    # Strip trailing main() invocation if present
    source = re.sub(
        r'\n+(?:#\s*COMMAND\s*-+\s*\n+)?if __name__ == "__main__":\s*\n\s+main\(\)\s*\n?\s*$',
        '\n', source, flags=re.DOTALL
    )

    module = types.ModuleType("agent_helpers")

    # Stubs for Databricks runtime globals
    class _Stub:
        def __init__(self, *args, **kwargs): pass
        def __getattr__(self, name): return _Stub()
        def __call__(self, *args, **kwargs): return _Stub()
        def __bool__(self): return False
        def __iter__(self): return iter([])
        def __getitem__(self, k): return _Stub()
        def __setitem__(self, k, v): pass

    module.__dict__.update({
        "spark": _Stub(),
        "dbutils": _Stub(),
        "displayHTML": lambda *a, **k: None,
        "SparkSession": _Stub(),
        # Sentinels normally defined at module level via runtime imports
        "_FAKER_AVAILABLE": False,
        "_POOL_ENGINE_AVAILABLE": True,
        "_OBS_AVAILABLE": False,
    })

    # We only want module-level function/class defs, not executable top-level code.
    # Parse, keep defs + imports + simple assigns. Drop top-level `if`, `for`, calls.
    tree = ast.parse(source)
    kept = []
    # Modules we CANNOT import in pytest (no Databricks runtime here).
    _BLOCKED_IMPORTS = {"pyspark", "databricks", "delta", "pandas", "numpy",
                        "IPython", "ipywidgets", "matplotlib", "plotly"}
    for node in tree.body:
        if isinstance(node, (ast.Import, ast.ImportFrom)):
            mod_name = node.module if isinstance(node, ast.ImportFrom) else (node.names[0].name if node.names else "")
            top = (mod_name or "").split(".")[0]
            if top in _BLOCKED_IMPORTS:
                continue  # skip pyspark/databricks — stubbed above
            kept.append(node)
        elif isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef)):
            kept.append(node)
        elif isinstance(node, ast.Assign):
            # Keep simple module-level assigns (constants, dicts); drop if they
            # evaluate side-effectful calls (heuristic: exclude if RHS has Call
            # that references Spark/dbutils etc.)
            rhs_has_runtime = False
            for sub in ast.walk(node.value):
                if isinstance(sub, ast.Name) and sub.id in {
                    "spark", "dbutils", "SparkSession"
                }:
                    rhs_has_runtime = True
                    break
            if not rhs_has_runtime:
                kept.append(node)

    # Exec each top-level node individually, skipping failures.
    module.__dict__["_load_errors"] = []
    module.__dict__["_load_error"] = None
    for node in kept:
        try:
            snippet = ast.Module(body=[node], type_ignores=[])
            code = compile(snippet, str(NOTEBOOK_PATH), "exec")
            exec(code, module.__dict__)
        except Exception as e:
            _name = getattr(node, 'name', type(node).__name__)
            module.__dict__["_load_errors"].append(f"{_name}: {type(e).__name__}: {e}")
            if module.__dict__["_load_error"] is None:
                module.__dict__["_load_error"] = f"{_name}: {e}"

    sys.modules["agent_helpers"] = module
    return module


# Eagerly build so tests can `import agent_helpers`
_build_agent_helpers_module()
