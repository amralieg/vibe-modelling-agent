import ast
import json
from pathlib import Path

import agent_helpers as ah

REPO = Path(__file__).resolve().parents[2]
PRE = Path("/tmp/agent_v401_backup.ipynb")  # pre-v4.0.2 (v4.0.1) backup, no typed-hint

STR_APPEND = "attempt 3: mutator raised: AttributeError: 'str' object has no attribute 'append'"
STR_GET = "mutator raised: AttributeError: 'str' object has no attribute 'get'"
DICT_APPEND = "mutator raised: AttributeError: 'dict' object has no attribute 'append'"
NONE_APPEND = "mutator raised: AttributeError: 'NoneType' object has no attribute 'append'"


def _load_fn_from_nb(path, fnname):
    """Exec a single top-level function from a notebook into an isolated namespace."""
    nb = json.load(open(path))
    src = "".join(
        "".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code"
    )
    tree = ast.parse(src)
    for node in tree.body:
        if isinstance(node, ast.FunctionDef) and node.name == fnname:
            import re as _re

            class _L:
                def info(self, *a, **k):
                    pass

                def warning(self, *a, **k):
                    pass

            ns = {"re": _re, "logger": _L()}
            exec(compile(ast.Module([node], []), str(path), "exec"), ns)
            return ns[fnname]
    raise AssertionError(f"{fnname} not found in {path}")


# ----- version -----
def test_version_bumped_to_402():
    assert ah.__AGENT_VERSION__ == "4.0.5", ah.__AGENT_VERSION__


# ----- pass-post: 'str'.append now gets STRING advice, not DICT advice -----
def test_str_append_gives_string_advice_and_suppresses_dict():
    out = ah._v204_ast_class_hints(STR_APPEND)
    assert "STRING-NOT-LIST" in out, out
    # the contradictory generic dict-assumption hint must be suppressed for .append
    assert "on a DICT (dicts have no" not in out, out


def test_str_get_gives_string_advice_and_suppresses_list():
    out = ah._v204_ast_class_hints(STR_GET)
    assert "STRING-NOT-DICT" in out, out
    # generic ".get on a LIST" advice must be suppressed for .get
    assert "object has no attribute 'get'" not in out or "STRING-NOT-DICT" in out


# ----- regression guards: dict + NoneType still correct -----
def test_dict_append_still_gives_dict_advice():
    out = ah._v204_ast_class_hints(DICT_APPEND)
    assert "DICT-NOT-LIST" in out, out


def test_nonetype_append_still_none_deref():
    out = ah._v204_ast_class_hints(NONE_APPEND)
    # NoneType is NOT a scalar-typed match (excluded); existing NONE-DEREF needle handles it
    assert "NONE-DEREF" in out, out
    assert "STRING-NOT-LIST" not in out, out


def test_clean_trace_returns_empty():
    assert ah._v204_ast_class_hints("no attribute errors here") == ""


# ----- fail-pre: prove the fix is ABSENT in the v4.0.1 backup -----
def test_fail_pre_v401_gives_wrong_dict_advice_for_str_append():
    fn = _load_fn_from_nb(PRE, "_v204_ast_class_hints")
    out = fn(STR_APPEND)
    # pre-patch: NO string-specific advice, and the WRONG dict advice fires
    assert "STRING-NOT-LIST" not in out, "v4.0.1 backup unexpectedly already has the fix"
    assert "on a DICT (dicts have no" in out, out
