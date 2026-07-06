"""v3.8.0 behavioral test: widened sandbox capability + no-spark/no-sql/no-storage guards.

Extracts the REAL AST-gate definitions (ALLOWED_BUILTINS, ALLOWED_MODULE_ATTRS,
FORBIDDEN_MODULE_NAMES, FORBIDDEN_RUNTIME_NAMES, UnsafeCodeError, validate_ast,
required_function_present) from the production notebook cell and exercises them.

Pre-patch (v3.7.1) these assertions fail because:
  - FORBIDDEN_RUNTIME_NAMES did not exist (spark/dbutils refs were allowed),
  - re.fullmatch / json.JSONDecodeError were not in the attr allowlists.

aliases under test: sandbox-capability-widen, sandbox-no-spark-no-sql-no-storage
"""
import ast
import json
import os
import re
import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_gate_namespace():
    nb = json.load(open(NB))
    big = ""
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        src = "".join(c.get("source", []))
        if "ALLOWED_AST_NODES = frozenset" in src and "def validate_ast" in src:
            big = src
            break
    assert big, "could not find the AST-gate cell"
    start = big.index("ALLOWED_AST_NODES = frozenset")
    end = big.index("def _apply_rlimits")
    snippet = big[start:end]
    ns = {"ast": ast, "logger": None}
    exec(compile(snippet, "<gate>", "exec"), ns)
    return ns


@pytest.fixture(scope="module")
def gate():
    return _load_gate_namespace()


def _wrap(body):
    # gate is applied to a full mutator body; wrap an expression/stmt into mutator()
    return "def mutator(model):\n" + "\n".join("    " + l for l in body.split("\n")) + "\n    return model\n"


# ---- widened capability: these must now PASS validate_ast ----
@pytest.mark.parametrize("body", [
    "x = uuid.uuid4().hex",
    "x = decimal.Decimal('1.5')",
    "x = fractions.Fraction(1, 3)",
    "x = statistics.mean([1, 2, 3])",
    "x = hashlib.sha256(b'a').hexdigest()",
    "x = base64.b64encode(b'a')",
    "x = textwrap.shorten('hello world', 5)",
    "x = re.fullmatch(r'\\\\d+', '123')",
    "x = operator.itemgetter(0)([1, 2])",
    "x = ''.join(map(str, range(3)))",
    "x = list(filter(None, [0, 1]))",
    "x = format(3.14159, '.2f')",
    "x = sorted([3, 1, 2])",
])
def test_widened_capability_allowed(gate, body):
    gate["validate_ast"](_wrap(body))  # must not raise


# ---- hard guards: these must now be REJECTED ----
@pytest.mark.parametrize("body,needle", [
    ("rows = spark.sql('SELECT 1')", "spark"),
    ("x = sc.parallelize([1])", "sc"),
    ("dbutils.fs.rm('/Volumes/x', True)", "dbutils"),
    ("s = SparkSession.builder.getOrCreate()", "SparkSession"),
    ("x = sqlContext.tables()", "sqlContext"),
])
def test_runtime_handles_forbidden(gate, body, needle):
    with pytest.raises(gate["UnsafeCodeError"]):
        gate["validate_ast"](_wrap(body))


# ---- still-forbidden classics (no regression) ----
@pytest.mark.parametrize("body", [
    "x = eval('1+1')",
    "x = __import__('os')",
    "f = open('/etc/passwd')",
    "x = os.remove('/tmp/x')",
    "x = pyspark.SparkContext()",
    "x = requests.get('http://x')",
])
def test_classics_still_forbidden(gate, body):
    with pytest.raises(gate["UnsafeCodeError"]):
        gate["validate_ast"](_wrap(body))


def test_forbidden_runtime_names_present(gate):
    frn = gate["FORBIDDEN_RUNTIME_NAMES"]
    for n in ("spark", "sc", "sqlContext", "dbutils", "SparkSession", "SparkContext"):
        assert n in frn
    fmn = gate["FORBIDDEN_MODULE_NAMES"]
    for n in ("pyspark", "boto3", "requests", "pandas", "numpy", "delta",
              "tarfile", "zipfile", "glob", "mmap", "resource"):
        assert n in fmn


# --------------------------------------------------------------------------
# v3.8.0 /sandbox dump (4A) + real end-to-end sandbox execution
# --------------------------------------------------------------------------

def _load_full_sandbox_namespace():
    import subprocess, tempfile, os, sys, resource, copy, ast as _ast, json as _json, re as _re, threading
    from dataclasses import dataclass
    from typing import Optional
    nb = json.load(open(NB))
    big = ""
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        src = "".join(c.get("source", []))
        if "ALLOWED_AST_NODES = frozenset" in src and "def execute_in_sandbox" in src:
            big = src
            break
    assert big
    start = big.index("ALLOWED_AST_NODES = frozenset")
    end = big.index("# ----- inlined from agent/vov_2_0/invariants.py -----")
    snippet = big[start:end]
    ns = {
        "ast": _ast, "json": _json, "os": os, "sys": sys, "subprocess": subprocess,
        "tempfile": tempfile, "resource": resource, "copy": copy, "re": _re,
        "threading": threading, "dataclass": dataclass, "Optional": Optional, "logger": None,
    }
    exec(compile(snippet, "<sandbox>", "exec"), ns)
    return ns


@pytest.fixture(scope="module")
def sb():
    return _load_full_sandbox_namespace()


def test_sandbox_wrapper_and_impl_split(sb):
    assert "execute_in_sandbox" in sb
    assert "_execute_in_sandbox_impl" in sb
    assert "_emit_sandbox_dump" in sb
    assert sb.get("_SANDBOX_DUMP_SINK") is None  # default no-op


def test_sandbox_executes_and_dumps_with_status(sb):
    captured = []
    sb["_SANDBOX_DUMP_SINK"] = lambda label, m, v, info: captured.append((label, m, v, info))
    mut = "def mutator(model):\n    model['x'] = 1\n    return model\n"
    res = sb["execute_in_sandbox"](mut, "", {"x": 0}, label="unit-tag-all")
    assert res.ok is True
    assert res.new_model.get("x") == 1
    assert len(captured) == 1
    label, m, v, info = captured[0]
    assert label == "unit-tag-all"
    assert m == mut            # RAW LLM source preserved for audit
    assert info["ok"] is True


def test_sandbox_dump_fires_even_on_unsafe_reject(sb):
    captured = []
    sb["_SANDBOX_DUMP_SINK"] = lambda label, m, v, info: captured.append((label, m, v, info))
    # references dbutils -> validate_ast rejects -> impl returns ok=False -> dump STILL fires
    mut = "def mutator(model):\n    dbutils.fs.rm('/x')\n    return model\n"
    res = sb["execute_in_sandbox"](mut, "", {"x": 0}, label="unit-bad")
    assert res.ok is False
    assert len(captured) == 1
    assert captured[0][3]["ok"] is False


def test_sandbox_no_sink_no_crash(sb):
    sb["_SANDBOX_DUMP_SINK"] = None
    mut = "def mutator(model):\n    model['y'] = 2\n    return model\n"
    res = sb["execute_in_sandbox"](mut, "", {"y": 0}, label="nosink")
    assert res.ok is True and res.new_model.get("y") == 2
