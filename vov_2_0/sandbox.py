from __future__ import annotations

import ast
import copy
import json
import os
import resource
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from typing import Optional

ALLOWED_AST_NODES = frozenset({
    ast.Module, ast.FunctionDef, ast.AsyncFunctionDef, ast.Return,
    ast.If, ast.For, ast.While, ast.Pass, ast.Break, ast.Continue,
    ast.Assign, ast.AugAssign, ast.AnnAssign,
    ast.Expr, ast.Compare, ast.BoolOp, ast.UnaryOp, ast.BinOp, ast.IfExp,
    ast.Name, ast.Constant, ast.Tuple, ast.List, ast.Dict, ast.Set,
    ast.Subscript, ast.Slice, ast.Attribute, ast.Call, ast.Lambda,
    ast.ListComp, ast.DictComp, ast.SetComp, ast.GeneratorExp, ast.comprehension,
    ast.arguments, ast.arg, ast.keyword, ast.Load, ast.Store, ast.Del,
    ast.Eq, ast.NotEq, ast.Lt, ast.LtE, ast.Gt, ast.GtE, ast.In, ast.NotIn,
    ast.And, ast.Or, ast.Not, ast.Is, ast.IsNot,
    ast.Add, ast.Sub, ast.Mult, ast.Div, ast.FloorDiv, ast.Mod, ast.Pow,
    ast.BitAnd, ast.BitOr, ast.BitXor, ast.LShift, ast.RShift, ast.Invert,
    ast.JoinedStr, ast.FormattedValue, ast.Starred,
    ast.Try, ast.ExceptHandler, ast.Raise,
})

ALLOWED_BUILTINS = frozenset({
    "len", "range", "enumerate", "zip", "sorted", "reversed",
    "set", "list", "dict", "tuple", "frozenset",
    "str", "int", "float", "bool", "type",
    "any", "all", "sum", "min", "max", "abs", "round",
    "isinstance", "hasattr", "getattr", "callable",
    "print",
})

ALLOWED_MODULE_ATTRS = {
    "re": frozenset({"search", "match", "findall", "finditer", "sub", "subn", "compile", "split", "escape",
                     "IGNORECASE", "I", "MULTILINE", "M", "DOTALL", "S"}),
    "json": frozenset({"dumps", "loads"}),
    "copy": frozenset({"deepcopy", "copy"}),
}

FORBIDDEN_MODULE_NAMES = frozenset({
    "os", "sys", "subprocess", "socket", "pathlib", "shutil", "tempfile",
    "ctypes", "multiprocessing", "threading", "asyncio", "importlib",
    "builtins", "io", "fcntl", "select", "signal", "atexit",
    "urllib", "http", "ftplib", "smtplib", "telnetlib", "ssl",
    "pickle", "marshal", "shelve", "dbm", "sqlite3",
    "gc", "weakref", "inspect", "ast", "dis", "trace", "tracemalloc",
})


class UnsafeCodeError(Exception):
    pass


def validate_ast(source: str) -> None:
    try:
        tree = ast.parse(source)
    except SyntaxError as e:
        raise UnsafeCodeError(f"syntax error: {e}")

    for node in ast.walk(tree):
        if type(node) not in ALLOWED_AST_NODES:
            raise UnsafeCodeError(f"forbidden AST node: {type(node).__name__}")
        if isinstance(node, ast.Attribute):
            if node.attr.startswith("__") and node.attr.endswith("__") and node.attr not in ("__class__",):
                raise UnsafeCodeError(f"forbidden dunder attr: {node.attr}")
        if isinstance(node, ast.Name):
            if node.id.startswith("__") and node.id.endswith("__"):
                raise UnsafeCodeError(f"forbidden dunder name: {node.id}")
        if isinstance(node, ast.Call):
            fn = node.func
            if isinstance(fn, ast.Name):
                if fn.id in ("eval", "exec", "compile", "__import__", "open", "input", "globals", "locals", "vars", "dir", "breakpoint", "exit", "quit"):
                    raise UnsafeCodeError(f"forbidden call: {fn.id}")
            if isinstance(fn, ast.Attribute):
                if isinstance(fn.value, ast.Name):
                    mod = fn.value.id
                    if mod in ALLOWED_MODULE_ATTRS:
                        if fn.attr not in ALLOWED_MODULE_ATTRS[mod]:
                            raise UnsafeCodeError(f"forbidden {mod} attr: {fn.attr}")
                    elif mod in FORBIDDEN_MODULE_NAMES:
                        raise UnsafeCodeError(f"forbidden module reference: {mod}.{fn.attr}")


def required_function_present(source: str, name: str) -> bool:
    try:
        tree = ast.parse(source)
    except SyntaxError:
        return False
    return any(isinstance(n, ast.FunctionDef) and n.name == name for n in tree.body)


SUBPROCESS_RUNNER_PREFIX = r"""
import sys as _sys_internal
import json as _json_internal
import re
import copy
import json

_input = _sys_internal.stdin.read()
_payload = _json_internal.loads(_input)
model = _payload["model"]
data = _payload.get("data")
_real_stdout = _sys_internal.stdout
_sys_internal.stdout = _sys_internal.stderr

"""

SUBPROCESS_RUNNER_SUFFIX = r"""

_pre = copy.deepcopy(model)
try:
    _new_model = mutator(model, data) if "data" in mutator.__code__.co_varnames else mutator(model)
except Exception as _e:
    _real_stdout.write(_json_internal.dumps({"model": None, "verifier_ok": False, "verifier_diag": "mutator raised: " + type(_e).__name__ + ": " + str(_e)[:200]}))
    _sys_internal.exit(0)
if _new_model is None:
    _new_model = model
try:
    _ok, _diag = verifier(_new_model, data) if "data" in verifier.__code__.co_varnames else verifier(_new_model)
except Exception as _e:
    _ok = False
    _diag = "verifier raised: " + type(_e).__name__ + ": " + str(_e)[:200]

_real_stdout.write(_json_internal.dumps({"model": _new_model, "verifier_ok": bool(_ok), "verifier_diag": str(_diag)}))
"""


def _apply_rlimits():
    for limit_name, soft, hard in [
        ("RLIMIT_AS", 1024 * 1024 * 1024, 1024 * 1024 * 1024),
        ("RLIMIT_CPU", 30, 30),
        ("RLIMIT_FSIZE", 4 * 1024 * 1024, 4 * 1024 * 1024),
        ("RLIMIT_NPROC", 64, 64),
    ]:
        if not hasattr(resource, limit_name):
            continue
        try:
            resource.setrlimit(getattr(resource, limit_name), (soft, hard))
        except (ValueError, OSError):
            pass


@dataclass
class SandboxResult:
    ok: bool
    new_model: Optional[dict]
    verifier_ok: bool
    verifier_diag: str
    error: Optional[str]
    stderr: str


def execute_in_sandbox(
    mutator_src: str,
    verifier_src: str,
    model: dict,
    data: Optional[list[dict]] = None,
    timeout: float = 30.0,
) -> SandboxResult:
    try:
        validate_ast(mutator_src)
        validate_ast(verifier_src)
    except UnsafeCodeError as e:
        return SandboxResult(False, None, False, "", f"unsafe_ast: {e}", "")

    if not required_function_present(mutator_src, "mutator"):
        return SandboxResult(False, None, False, "", "no `mutator` function defined", "")
    if not required_function_present(verifier_src, "verifier"):
        return SandboxResult(False, None, False, "", "no `verifier` function defined", "")

    runner = SUBPROCESS_RUNNER_PREFIX + mutator_src + "\n\n" + verifier_src + SUBPROCESS_RUNNER_SUFFIX

    payload = json.dumps({"model": model, "data": data}).encode()

    with tempfile.TemporaryDirectory() as workdir:
        try:
            proc = subprocess.run(
                [sys.executable, "-I", "-S", "-c", runner],
                input=payload,
                capture_output=True,
                timeout=timeout,
                env={"PATH": "/usr/bin:/bin"},
                cwd=workdir,
                preexec_fn=_apply_rlimits if hasattr(os, "fork") else None,
            )
        except subprocess.TimeoutExpired:
            return SandboxResult(False, None, False, "", "subprocess timeout", "")
        except Exception as e:
            return SandboxResult(False, None, False, "", f"subprocess error: {e}", "")

    if proc.returncode != 0:
        return SandboxResult(False, None, False, "", f"subprocess exit {proc.returncode}", proc.stderr.decode(errors="replace")[:2000])

    try:
        out = json.loads(proc.stdout.decode())
    except json.JSONDecodeError as e:
        return SandboxResult(False, None, False, "", f"bad subprocess output: {e}", proc.stderr.decode(errors="replace")[:1000])

    return SandboxResult(
        ok=True,
        new_model=out.get("model"),
        verifier_ok=bool(out.get("verifier_ok")),
        verifier_diag=str(out.get("verifier_diag", "")),
        error=None,
        stderr=proc.stderr.decode(errors="replace")[:1000],
    )
