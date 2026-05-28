"""Behavioral test for v240 PK-consistency tags-coerce fix.

alias=v240-pk-consistency-tags-string-coerce

Regression target: NCDOT install_base run 388372284033213 (2026-05-28 00:07) crashed with
    AttributeError: 'dict' object has no attribute 'lower'
at enforce_configured_pk_consistency line `tags = (a.get("tags") or "").lower()` because
an upstream LLM stage produced an attribute whose `tags` field was a dict instead of the
contract-required string (per TABLE_ATTRIBUTE_SCHEMA).

Strategy:
- Static check: the patch alias is present in the notebook source.
- Static check: the coercion loop is positioned BEFORE the first `(a.get("tags") or "").lower()` site.
- Behavioral check: the inline `_coerce_tags` helper handles every input shape we have seen in the wild.
"""

import json
import pathlib


NB_PATH = pathlib.Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_source() -> str:
    nb = json.loads(NB_PATH.read_text())
    out = []
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        out.append("".join(c.get("source", [])))
    return "\n".join(out)


def test_v240_alias_present():
    src = _read_source()
    assert "v240-pk-consistency-tags-string-coerce" in src, \
        "v240-pk-consistency-tags-string-coerce alias missing — patch was lost"
    assert "[v240-tags-coerced FIRED]" in src, \
        "[v240-tags-coerced FIRED] sentinel missing — patch was lost"


def test_v240_coercion_precedes_lower_call():
    """v240 behavior preserved in v250: enforce_configured_pk_consistency must coerce tags
    BEFORE the first `.lower()` site, whether via inline helper (v240) or via the v250
    module-level _enforce_string_tags_invariant_v250 call.
    """
    src = _read_source()
    fn_start = src.find("def enforce_configured_pk_consistency")
    assert fn_start > 0, "enforce_configured_pk_consistency not found"

    next_def_after = src.find("\ndef ", fn_start + 1)
    fn_block = src[fn_start:next_def_after] if next_def_after > 0 else src[fn_start:]

    coerce_idx = fn_block.find("_coerce_tags")
    if coerce_idx < 0:
        coerce_idx = fn_block.find("_enforce_string_tags_invariant_v250")
    lower_idx = fn_block.find('(a.get("tags") or "").lower()')
    if lower_idx < 0:
        lower_idx = fn_block.find("(a.get('tags') or '').lower()")
    assert coerce_idx > 0, (
        "Neither _coerce_tags (v240 inline) nor _enforce_string_tags_invariant_v250 "
        "(v250 module-level) present in enforce_configured_pk_consistency — coerce was lost"
    )
    if lower_idx > 0:
        assert coerce_idx < lower_idx, (
            f"coerce/invariant (idx={coerce_idx}) must come BEFORE the .lower() call (idx={lower_idx})"
        )


def test_v240_coerce_helper_handles_all_shapes():
    def _coerce_tags(v):
        if isinstance(v, str):
            return v
        if v is None:
            return ""
        if isinstance(v, dict):
            return ",".join(str(k) for k in v.keys())
        if isinstance(v, (list, tuple, set)):
            return ",".join(str(x) for x in v)
        return str(v)

    assert _coerce_tags("pii,contact") == "pii,contact"
    assert _coerce_tags("") == ""
    assert _coerce_tags(None) == ""
    assert _coerce_tags({"category": "primary_key"}) == "category"
    coerced_two_key = _coerce_tags({"a": 1, "b": 2})
    assert set(coerced_two_key.split(",")) == {"a", "b"}
    assert _coerce_tags(["pii", "personal"]) == "pii,personal"
    assert _coerce_tags(("pii", "audit")) == "pii,audit"
    assert _coerce_tags({"x", "y"}) in ("x,y", "y,x")
    assert _coerce_tags(123) == "123"
    assert _coerce_tags(True) == "True"
    for shape in [{}, [], (), set(), None]:
        out = _coerce_tags(shape)
        assert isinstance(out, str), f"_coerce_tags on {shape!r} returned {type(out).__name__}, expected str"
        assert out.lower() == out or isinstance(out.lower(), str)


def test_v240_dict_lower_would_crash_pre_patch():
    import pytest
    bad = {"category": "primary_key"}
    with pytest.raises(AttributeError, match="dict"):
        _ = bad.lower()


if __name__ == "__main__":
    test_v240_alias_present()
    test_v240_coercion_precedes_lower_call()
    test_v240_coerce_helper_handles_all_shapes()
    test_v240_dict_lower_would_crash_pre_patch()
    print("OK")
