"""Faithful local harness: exec ONLY defs/classes/imports from the agent notebook
so the REAL run_metamodel_static_analysis (and all its helpers) can run offline,
with no Databricks/spark/LLM. Used to prove the quality-convergence loop drives
static-analysis warnings down and the deterministic quality score up across
versions (the accountability gate: model MUST get better, not worse)."""
from __future__ import annotations

import ast
import json
import logging
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


class _AnyMock:
    """Permissive stand-in for Databricks-only globals (spark, dbutils, ...)."""
    def __getattr__(self, _):
        return _AnyMock()
    def __call__(self, *a, **k):
        return _AnyMock()
    def __getitem__(self, _):
        return _AnyMock()


def _top_node_snippets():
    nb = json.loads(NOTEBOOK_PATH.read_text(encoding="utf-8"))
    snippets = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        if not src.strip():
            continue
        try:
            tree = ast.parse(src)
        except SyntaxError:
            continue
        lines = src.splitlines(keepends=True)
        for node in tree.body:
            if isinstance(node, ast.ImportFrom) and node.module == "__future__":
                continue
            keep = isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef,
                                     ast.Import, ast.ImportFrom, ast.Assign, ast.AnnAssign))
            if keep:
                snippets.append("".join(lines[node.lineno - 1:node.end_lineno]))
    return snippets


def load_agent_namespace() -> dict:
    """Exec notebook defs/classes/imports/constants statement-by-statement so the
    real static analyzer + helpers load offline. Databricks-only statements that
    raise are skipped; constants and pure functions land in the namespace."""
    ns = {"__name__": "_agent_defs_only"}
    for g in ("spark", "dbutils", "sc", "displayHTML", "display", "sql"):
        ns[g] = _AnyMock()
    for snip in _top_node_snippets():
        try:
            exec(compile(snip, str(NOTEBOOK_PATH), "exec"), ns)
        except Exception:
            pass
    return ns


def quiet_logger():
    lg = logging.getLogger("qconverge")
    lg.setLevel(logging.CRITICAL)
    if not lg.handlers:
        lg.addHandler(logging.NullHandler())
    return lg


def flat_lists(model_json):
    """Convert a model.json (nested domains/products/attributes) into the flat
    products_data + attributes_data rows the static analyzer consumes."""
    m = model_json.get("model", model_json)
    domains_data, products_data, attributes_data = [], [], []
    for dom in m.get("domains", []):
        dn = dom.get("name")
        domains_data.append({"domain": dn, "name": dn, "database_name": dn,
                             "description": dom.get("description", f"{dn} domain")})
        for p in (dom.get("products") or dom.get("data_products", [])):
            pn = p.get("name")
            pk = p.get("primary_key", f"{pn}_id")
            products_data.append({"domain": dn, "product": pn,
                                  "primary_key": pk,
                                  "table_name": p.get("table_name", pn),
                                  "description": p.get("description", f"{pn} table")})
            for a in p.get("attributes", []):
                nm = a.get("name")
                is_pk = bool(a.get("primary_key")) or nm == pk
                attributes_data.append({
                    "domain": dn, "product": pn,
                    "attribute": nm,
                    "column_name": nm,
                    "type": (a.get("type") or a.get("data_type") or "STRING"),
                    "foreign_key_to": a.get("foreign_key_to", ""),
                    "primary_key": is_pk,
                    "is_primary_key": is_pk,
                    "description": a.get("description", f"{nm} column"),
                })
    return domains_data, products_data, attributes_data


def minimal_config():
    return {
        "PROMPT_VARIABLES": {"business_config": {}},
        "NAMING_CONVENTION": "snake_case",
        "PK_SUFFIX": "_id",
    }
