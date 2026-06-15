"""pytest configuration — extracts agent notebook code for unit tests.

Loads ALL code cells from agent/dbx_vibe_modelling_agent.ipynb (concatenated),
not cell[1] only. Databricks runtime globals are stubbed; tests patch as needed.
"""
import json
import os
import re
import sys
import types
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"

if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))


def _extract_source_from_notebook() -> str:
    """Return concatenated source from every code cell in the agent notebook.

    The cache is honored ONLY when it is at least as new as the notebook on disk.
    Root cause of a real audit hazard (2026-06-15): a stale /tmp/agent_source.py
    (dumped days earlier at __AGENT_VERSION__ 3.5.8) silently shadowed the live
    notebook, so every agent_helpers-based test ran against OLD source while the
    working tree was 3.5.9 — a 'lying scoreboard' that lets tests pass against code
    that no longer exists. The mtime guard makes the cache safe: if the notebook is
    newer, the cache is ignored (and refreshed) so tests always reflect disk.

    The cache path is WORKER-SCOPED (PYTEST_XDIST_WORKER). Root cause of a second
    hazard (2026-06-15, v3.6.0): under `pytest -n 6`, all workers saw no cache,
    parsed concurrently, then raced to write the SAME /tmp/agent_source.py with a
    non-atomic write_text(); a worker reading mid-write got a truncated file →
    exec failed → ~4 agent_helpers tests flaked (FAILED under -n, PASSED serial).
    A per-worker cache file removes the shared-write race entirely while keeping
    the within-worker reuse and the staleness guard. The write is also atomic
    (temp + os.replace) so even a same-worker re-entry can never see a partial file.
    """
    worker = os.environ.get("PYTEST_XDIST_WORKER", "main")
    tmp_src = Path("/tmp") / f"agent_source.{worker}.py"
    if tmp_src.exists() and tmp_src.stat().st_mtime >= NOTEBOOK_PATH.stat().st_mtime:
        try:
            return tmp_src.read_text(encoding="utf-8")
        except Exception:
            pass  # corrupt/partial cache — fall through and re-extract

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
    if not parts:
        raise RuntimeError("No code cells found in agent notebook")
    concat = "\n\n".join(parts)
    # Refresh the (worker-scoped) cache atomically so its mtime is newer than the
    # notebook and a same-worker re-entry reuses it without ever seeing a partial.
    try:
        tmp_partial = tmp_src.with_suffix(f".py.{os.getpid()}.tmp")
        tmp_partial.write_text(concat, encoding="utf-8")
        os.replace(str(tmp_partial), str(tmp_src))
    except Exception:
        pass
    return concat


def _build_agent_helpers_module():
    """Parse full notebook source and exec defs with lightweight Databricks stubs."""
    import ast

    source = _extract_source_from_notebook()
    source = re.sub(
        r"\n+(?:#\s*COMMAND\s*-+\s*\n+)?if __name__ == \"__main__\":\s*\n\s+main\(\)\s*\n?\s*$",
        "\n",
        source,
        flags=re.DOTALL,
    )

    module = types.ModuleType("agent_helpers")

    class _Stub:
        def __init__(self, *args, **kwargs):
            pass

        def __getattr__(self, name):
            return _Stub()

        def __call__(self, *args, **kwargs):
            return _Stub()

        def __bool__(self):
            return False

        def __iter__(self):
            return iter([])

        def __getitem__(self, k):
            return _Stub()

        def __setitem__(self, k, v):
            pass

        def __len__(self):
            return 0

    module.__dict__.update(
        {
            "spark": _Stub(),
            "dbutils": _Stub(),
            "displayHTML": lambda *a, **k: None,
            "SparkSession": _Stub(),
            "_FAKER_AVAILABLE": False,
            "_POOL_ENGINE_AVAILABLE": True,
            "_OBS_AVAILABLE": False,
        }
    )

    tree = ast.parse(source)
    kept = []
    _BLOCKED_IMPORTS = {
        "pyspark",
        "databricks",
        "delta",
        "pandas",
        "numpy",
        "IPython",
        "ipywidgets",
        "matplotlib",
        "plotly",
    }
    for node in tree.body:
        if isinstance(node, (ast.Import, ast.ImportFrom)):
            mod_name = (
                node.module
                if isinstance(node, ast.ImportFrom)
                else (node.names[0].name if node.names else "")
            )
            top = (mod_name or "").split(".")[0]
            if top in _BLOCKED_IMPORTS:
                continue
            kept.append(node)
        elif isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef)):
            kept.append(node)
        elif isinstance(node, ast.Assign):
            rhs_has_runtime = False
            for sub in ast.walk(node.value):
                if isinstance(sub, ast.Name) and sub.id in {
                    "spark",
                    "dbutils",
                    "SparkSession",
                }:
                    rhs_has_runtime = True
                    break
            if not rhs_has_runtime:
                kept.append(node)

    module.__dict__["_load_errors"] = []
    module.__dict__["_load_error"] = None
    module.__dict__["_loaded_node_count"] = 0
    for node in kept:
        try:
            snippet = ast.Module(body=[node], type_ignores=[])
            code = compile(snippet, str(NOTEBOOK_PATH), "exec")
            exec(code, module.__dict__)
            module.__dict__["_loaded_node_count"] += 1
        except Exception as e:
            _name = getattr(node, "name", type(node).__name__)
            module.__dict__["_load_errors"].append(
                f"{_name}: {type(e).__name__}: {e}"
            )
            if module.__dict__["_load_error"] is None:
                module.__dict__["_load_error"] = f"{_name}: {e}"

    module.__file__ = str(NOTEBOOK_PATH)
    sys.modules["agent_helpers"] = module
    return module


_build_agent_helpers_module()


@pytest.fixture(scope="session")
def agent_source_text():
    """Full notebook Python source (all code cells) — prefer over raw .ipynb JSON."""
    from notebook_source_util import notebook_concat_source

    return notebook_concat_source()


def pytest_sessionfinish(session, exitstatus):
    """Print symbol-coverage summary after the full test run."""
    try:
        from coverage_report import emit_symbol_coverage_report

        emit_symbol_coverage_report(session)
    except Exception as exc:
        import traceback

        print(f"\n[coverage-report] skipped: {exc}")
        traceback.print_exc()
    try:
        from scenario_coverage_report import emit_scenario_summary

        emit_scenario_summary()
    except Exception as exc:
        import traceback

        print(f"\n[scenario-report] skipped: {exc}")
        traceback.print_exc()
