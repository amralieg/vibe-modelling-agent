import json
import os

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "\n".join("".join(c.get("source", [])) for c in nb.get("cells", []))


def test_agent_version_is_295():
    import re as _re
    m = _re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', _src())
    assert m, "version constant not found"
    assert tuple(int(x) for x in m.groups()) >= (2, 9, 5)


def test_fix_present():
    src = _src()
    assert "alias=vov-bridge-strict-false-parse" in src
    assert "json.loads(_cand, strict=_strict)" in src


# Faithful reconstruction of the v2.9.5 bridge parse logic.
def _bridge_parse(raw):
    s = raw.strip()
    if s.startswith("```"):
        _lines = s.split("\n")
        if len(_lines) > 2:
            s = "\n".join(_lines[1:-1]).strip()
    _candidates = [s]
    _b0 = s.find("{"); _b1 = s.rfind("}")
    if _b0 != -1 and _b1 != -1 and _b1 > _b0:
        _candidates.append(s[_b0:_b1 + 1])
    for _ci, _cand in enumerate(_candidates):
        for _strict in (True, False):
            try:
                return json.loads(_cand, strict=_strict)
            except json.JSONDecodeError:
                continue
    raise ValueError("failed to parse")


def test_control_char_mutator_parses():
    # The exact failure mode: mutator_source carries Python with LITERAL newlines/tabs.
    code = "def mutator(model, data):\n\t# add fk\n\treturn model\n"
    # Build a JSON string with the control chars NOT escaped (what Claude emits).
    bad = '{"mutator_source": "' + code + '", "expected_changes_summary": "x"}'

    # Pre-patch behaviour: strict=True rejects literal control chars.
    failed_strict = False
    try:
        json.loads(bad)
    except json.JSONDecodeError:
        failed_strict = True
    assert failed_strict, "strict=True should reject literal control chars (pre-patch failure mode)"

    # Post-patch behaviour: the bridge recovers it.
    parsed = _bridge_parse(bad)
    assert parsed["mutator_source"] == code
    assert parsed["expected_changes_summary"] == "x"


def test_clean_json_still_parses():
    good = json.dumps({"mutator_source": "def mutator(model, data): return model",
                       "expected_changes_summary": "ok"})
    parsed = _bridge_parse(good)
    assert "mutator" in parsed["mutator_source"]


def test_truly_broken_json_still_raises():
    # strict=False must NOT mask genuinely unparseable garbage.
    raised = False
    try:
        _bridge_parse("not json at all <<<")
    except ValueError:
        raised = True
    assert raised


if __name__ == "__main__":
    for fn in [v for k, v in sorted(globals().items()) if k.startswith("test_")]:
        fn()
        print("ok", fn.__name__)
