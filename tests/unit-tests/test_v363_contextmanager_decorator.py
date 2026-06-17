"""Behavioral tests for v3.6.3 alias=contextmanager-decorator-misplacement.

ROOT CAUSE this fixes: the v3.6.2 io-timeout-watchdog splice attached the
`@contextmanager` decorator to the WRONG function. It landed on
`_io_with_timeout` (a plain function that RETURNS a `(value, timed_out)` tuple and
has NO `yield`) instead of `_suppress_dbutils_stdout` (a `yield`-based generator
used 14x via `with _suppress_dbutils_stdout(): ...`).

Two failures resulted, both fatal to every operation that creates the business
folder structure (new base model, vov, shrink, enlarge):

  1. `with _suppress_dbutils_stdout():` raised
     `TypeError: 'generator' object does not support the context manager protocol`
     because an undecorated generator function is not a context manager.

  2. `_io_with_timeout(_mk, 90, logger, ...)` returned a `_GeneratorContextManager`
     (because the misplaced decorator wrapped it) instead of the
     `(val, timed_out)` tuple, so the `_, _mk_to = _io_with_timeout(...)` unpack
     and every other call site broke.

Net effect: the child new-base-model run crashed in ~1.7 min at
`step_setup_and_clean` (the mkdirs loop) with INTERNAL_ERROR (signature N1:
"Workload failed, see run output for details"). There was never an I/O hang; the
driver was merely polling an already-crashed child.

The fix moves `@contextmanager` onto `_suppress_dbutils_stdout` and removes it
from `_io_with_timeout`.

These tests extract the REAL production helpers from the notebook (not stubs) and
exercise them. They FAIL on pre-v3.6.3 HEAD (decorator on the wrong function).
"""
import json
import re
import os
import io as _io
import sys
import threading
from contextlib import contextmanager

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _extract(name):
    """Return the source block for `def name(...)` INCLUDING any immediately
    preceding decorator line(s)."""
    src = _src()
    m = re.search(r"\ndef " + re.escape(name) + r"\(.*?\n(?=\ndef |\n@|\n[^ \n])", src, re.DOTALL)
    assert m, f"def {name} not found in notebook"
    start = m.start()
    # walk backwards over contiguous decorator lines
    lines = src[:start].split("\n")
    decos = []
    for ln in reversed(lines):
        if ln.strip().startswith("@"):
            decos.insert(0, ln)
        elif ln.strip() == "":
            continue
        else:
            break
    block = ("\n".join(decos) + "\n" if decos else "") + m.group(0).lstrip("\n")
    return block


# ── static: decorator is on the RIGHT function ────────────────────────────────

def test_suppress_is_decorated_contextmanager():
    block = _extract("_suppress_dbutils_stdout")
    assert "@contextmanager" in block.split("def _suppress_dbutils_stdout")[0], (
        "_suppress_dbutils_stdout MUST carry @contextmanager (pre-v3.6.3 it did not)"
    )


def test_io_with_timeout_is_NOT_decorated_contextmanager():
    block = _extract("_io_with_timeout")
    assert "@contextmanager" not in block.split("def _io_with_timeout")[0], (
        "_io_with_timeout MUST NOT carry @contextmanager — it returns a tuple, "
        "not a generator (pre-v3.6.3 the decorator was wrongly here)"
    )


# ── behavior: the real helpers work end to end ────────────────────────────────

def _exec_block(name):
    g = {
        "contextmanager": contextmanager,
        "io": _io,
        "sys": sys,
        "threading": threading,
        "_suppress_stdout_lock": threading.RLock(),
    }
    exec(_extract(name), g)
    return g[name]


def test_suppress_dbutils_stdout_usable_as_context_manager():
    fn = _exec_block("_suppress_dbutils_stdout")
    orig = sys.stdout
    try:
        # On pre-v3.6.3 HEAD this raises TypeError: 'generator' object does not
        # support the context manager protocol.
        with fn():
            print("swallowed")  # captured by the StringIO inside the CM
        assert sys.stdout is orig, "stdout must be restored on exit"
    finally:
        sys.stdout = orig


def test_io_with_timeout_returns_tuple_not_contextmanager():
    fn = _exec_block("_io_with_timeout")
    out = fn(lambda: 7, 5, None, "ok")
    assert isinstance(out, tuple) and out == (7, False), (
        f"_io_with_timeout must return (val, timed_out); got {out!r}"
    )


def test_suppress_dbutils_stdout_restores_on_exception():
    fn = _exec_block("_suppress_dbutils_stdout")
    orig = sys.stdout
    try:
        try:
            with fn():
                raise ValueError("boom")
        except ValueError:
            pass
        assert sys.stdout is orig, "stdout must be restored even when body raises"
    finally:
        sys.stdout = orig
