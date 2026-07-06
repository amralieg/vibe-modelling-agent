"""v2.9.1 FIX-3 behavioral test: verifier JSON hardening.

ROOT CAUSE (pre-patch): _verify_via_llm parsed the LLM verdict with a bare
json.loads + a single {..} re-extraction that ALSO re-raised on single-quoted /
trailing-comma / prose-wrapped JSON. The exception propagated to the outer except
and returned {"status": "partial", "evidence": "[verifier-llm-fallback ERROR ...
JSONDecodeError ...]"} -- a FALSE partial that corrupted precision/recall whenever
the model genuinely satisfied the requirement (observed live on ncdot VREQ-022/023).

FIX: a shared _v291_lenient_verifier_json(raw) helper handles code-fences, prose,
single-quoted dicts (ast.literal_eval), trailing commas, and finally regex-extracts
status/evidence. Both the primary and the rescue parse sites route through it.

§8.10 proof-of-failure on pre-patch HEAD: the helper does not exist pre-patch, so
_load_helper() raises and every assertion below fails.
"""
import json
import os
import re

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_helper():
    nb = json.load(open(NB))
    fn_src = None
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        src = "".join(c["source"])
        if "def _v291_lenient_verifier_json(raw):" not in src:
            continue
        # capture from the def to the next column-0 def/class
        lines = src.splitlines(keepends=True)
        start = next(i for i, ln in enumerate(lines)
                     if ln.startswith("def _v291_lenient_verifier_json("))
        end = len(lines)
        for j in range(start + 1, len(lines)):
            if lines[j] and not lines[j][0].isspace() and (
                lines[j].startswith("def ") or lines[j].startswith("class ")):
                end = j
                break
        fn_src = "".join(lines[start:end])
        break
    assert fn_src, "v2.9.1 FIX-3 helper _v291_lenient_verifier_json not found (pre-patch HEAD => FAIL)"
    ns = {}
    exec(fn_src, ns)
    return ns["_v291_lenient_verifier_json"]


def test_passthrough_dict():
    f = _load_helper()
    assert f({"status": "fulfilled", "evidence": "x"}) == {"status": "fulfilled", "evidence": "x"}


def test_plain_json():
    f = _load_helper()
    assert f('{"status": "failed", "evidence": "missing fk"}')["status"] == "failed"


def test_single_quoted_dict():
    # The exact class that produced JSONDecodeError "Expecting property name
    # enclosed in double quotes: line 1 column 2 (char 1)" pre-patch.
    f = _load_helper()
    out = f("{'status': 'fulfilled', 'evidence': 'all products present'}")
    assert out is not None and out["status"] == "fulfilled"


def test_code_fenced():
    f = _load_helper()
    out = f('```json\n{"status": "partial", "evidence": "2 of 3"}\n```')
    assert out["status"] == "partial"


def test_trailing_comma():
    f = _load_helper()
    out = f('{"status": "fulfilled", "evidence": "ok",}')
    assert out["status"] == "fulfilled"


def test_prose_wrapped():
    f = _load_helper()
    out = f('Here is my verdict: {"status": "failed", "evidence": "no change"} done.')
    assert out["status"] == "failed"


def test_regex_last_resort():
    # Structurally broken JSON but status/evidence keys recoverable by regex.
    f = _load_helper()
    out = f('garbage "status": "fulfilled" and "evidence": "found it", trailing')
    assert out is not None and out["status"] == "fulfilled"


def test_empty_returns_none():
    f = _load_helper()
    assert f("") is None
    assert f(None) is None


def test_rewire_sites_present():
    src = "".join("".join(c["source"]) for c in json.load(open(NB))["cells"]
                  if c.get("cell_type") == "code")
    # both the primary and rescue parse sites must call the helper
    assert src.count("_v291_lenient_verifier_json(_v100_txt)") == 1
    assert src.count("_v291_lenient_verifier_json(_v103_etxt)") == 1
