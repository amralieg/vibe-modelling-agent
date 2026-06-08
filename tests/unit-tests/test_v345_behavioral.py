import json
import re
import textwrap

NB = "/Users/amr.ali/Documents/projects/vibe-modelling-agent/agent/dbx_vibe_modelling_agent.ipynb"


def _cell_src(idx):
    nb = json.load(open(NB))
    return "".join(nb["cells"][idx]["source"])


def _slice(src, start_marker, end_marker, include_end=False):
    i = src.index(start_marker)
    i = src.rfind("\n", 0, i) + 1
    j = src.index(end_marker, i)
    if include_end:
        j = src.index("\n", j) + 1
    return src[i:j]


# ---- version anchor ----
def test_v345_version_constant():
    src = _cell_src(1)
    m = re.search(r'__AGENT_VERSION__ = "([0-9.]+)"', src)
    assert m and m.group(1) == "3.4.5", f"expected 3.4.5, got {m and m.group(1)}"


# ---- mutator-json-literal-alias: prefix binds null/true/false ----
def test_v345_prefix_aliases_json_literals():
    src = _cell_src(3)
    # extract the raw prefix string body and assert the aliases are present + bind correctly
    assert "null = None" in src
    assert "true = True" in src
    assert "false = False" in src
    # behavioral: the three assignment lines actually bind to the Python singletons
    ns = {}
    exec("null = None\ntrue = True\nfalse = False\n", ns)
    assert ns["null"] is None and ns["true"] is True and ns["false"] is False
    # and LLM-style JSON-literal code resolves under that namespace (would NameError pre-fix)
    exec("d = {'a': null, 'b': true, 'c': false}", ns)
    assert ns["d"] == {"a": None, "b": True, "c": False}


# ---- retry-feedback hint table (behavioral) ----
def _exec_hints():
    src = _cell_src(3)
    block = _slice(src, "def _v204_ast_class_hints(", "return ", include_end=False)
    # the function ends after building/returning hints; slice generously to the final return
    full = src[src.index("def _v204_ast_class_hints("):]
    # take up to the line that returns the joined hints (first standalone 'return' after the for-loop)
    end = full.index("\n    return ")
    end = full.index("\n", end + len("\n    return ")) + 1
    block = textwrap.dedent(full[:end])

    class _L:
        def info(self, *a, **k):
            pass
    ns = {"logger": _L()}
    exec(block, ns)
    return ns["_v204_ast_class_hints"]


def test_v345_undefined_name_hint_fires():
    h = _exec_hints()
    out = h("attempt 3: mutator raised: NameError: name 'TARGET_SPECS' is not defined")
    assert out, "no hint for undefined-name trace"
    assert "UNDEFINED NAME" in out
    assert "model" in out and "data" in out
    # also covers the 'null' undefined case
    out2 = h("NameError: name 'null' is not defined")
    assert "UNDEFINED NAME" in out2


def test_v345_list_dict_shape_hint_fires():
    h = _exec_hints()
    out = h("mutator raised: AttributeError: 'list' object has no attribute 'get'")
    assert out and "LIST/DICT SHAPE" in out
    assert "data_products" in out  # teaches the real model shape
    out2 = h("AttributeError: 'dict' object has no attribute 'append'")
    assert "LIST/DICT SHAPE" in out2


def test_v345_hint_nontautology_clean_trace_returns_empty():
    # NON-TAUTOLOGY: a trace with no known failure needle must yield NO hint.
    h = _exec_hints()
    assert h("everything finished successfully, no errors") == ""
    assert h("") == ""
