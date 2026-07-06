"""v3.8.0 behavioral test: build_business_context_section is memoized (alias=bc-section-memo).

DRY/perf fix: the function is a pure projection of `bc` + business_context_user, called ~24x
per run, and previously rebuilt the same string every time when USE_DISK_CACHE was off.

This is a real behavioral test (not a tautology):
  - same config twice -> SAME string OBJECT (identity), proving no rebuild (a rebuild makes a
    new object; these long multi-line strings are not interned).
  - different bc -> DIFFERENT result AND memo grows, proving the memo is content-keyed (never
    returns a stale value for a changed config).
"""
import hashlib
import json
import os
import tempfile

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _extract_func(fname):
    nb = json.load(open(NB))
    src_all = "".join("".join(c["source"]) for c in nb["cells"] if c["cell_type"] == "code")
    lines = src_all.split("\n")
    start = None
    for i, l in enumerate(lines):
        if l.startswith(f"def {fname}("):
            start = i
            break
    assert start is not None, f"{fname} not found"
    body = [lines[start]]
    for l in lines[start + 1:]:
        if l and not l[0].isspace() and not l.startswith(("    ", "\t")):
            break
        body.append(l)
    return "\n".join(body)


def _load():
    ns = {"hashlib": hashlib, "json": json, "os": os, "tempfile": tempfile}
    exec(_extract_func("build_business_context_section"), ns)
    return ns


def _cfg(industry):
    return {
        "PROMPT_VARIABLES": {
            "business_config": {
                "industry_alignment": industry,
                "core_business_processes": ["a", "b"],
                "data_domains": "hr, project",
            },
            "business_context_user": "critical note",
        }
    }


def test_same_config_returns_cached_object():
    ns = _load()
    fn = ns["build_business_context_section"]
    cfg = _cfg("transport")
    r1 = fn(cfg)
    r2 = fn(cfg)
    assert r1 == r2
    # identity: the second call returned the memoized object, i.e. it did NOT rebuild.
    assert r1 is r2, "expected memoized identical object (rebuild detected -> memo not firing)"
    assert len(ns.get("_BC_SECTION_MEMO", {})) == 1


def test_different_config_not_stale():
    ns = _load()
    fn = ns["build_business_context_section"]
    r1 = fn(_cfg("transport"))
    r2 = fn(_cfg("healthcare"))
    assert r1 != r2, "different bc must not return a stale memoized value"
    assert "transport" in r1 and "healthcare" in r2
    assert len(ns["_BC_SECTION_MEMO"]) == 2


def test_empty_bc_short_circuits():
    ns = _load()
    fn = ns["build_business_context_section"]
    assert fn({}) == "(Business context not available)"


def test_notebook_wires_memo():
    src = open(NB).read()
    assert "_BC_SECTION_MEMO" in src
    assert "alias=bc-section-memo" in src


if __name__ == "__main__":
    for name, f in sorted(globals().items()):
        if name.startswith("test_") and callable(f):
            f()
            print("PASS", name)
    print("all passed")
