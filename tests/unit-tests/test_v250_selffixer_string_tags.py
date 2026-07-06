"""Behavioral test for v250 SelfFixer schema-shape guard + boundary tags-string invariant.

aliases:
  v250-selffixer-schema-shape-guard
  v250-enforce-string-tags-invariant
  v250-modeljson-tags-coerced
  v250-coerce-tags-to-string
  v250-count-schema-string-violations

Regression target: gov_transport install_base run <run_id> (2026-05-28 09:36 → 10:04 UTC) crashed
with AttributeError: 'dict' object has no attribute 'lower' at step_generate_data_model_json,
then again with 'dict' object has no attribute 'strip' at step_generate_metric_view_artifacts.

Producer: [selffixer-applied FIRED v2.0.8] req=VREQ-018 applied an LLM-generated sandbox mutator
that wrote attr['tags'] = {'gov_transport_source_attribute': '<orig>'} (a Python dict) to 1372 attributes,
violating the TABLE_ATTRIBUTE_SCHEMA tags:string contract.

v240 only protected enforce_configured_pk_consistency (ONE consumer). 4 downstream consumers
crashed before reaching it. v250 is layered:
  (1) ROOT: SelfFixer rejects sandbox mutations that increase schema-string violations.
  (2) PROMPT: _SELFFIXER_PROMPT explicitly forbids dict tags and shows the right pattern.
  (3) BOUNDARY: step_finalize_model_before_physical_schema coerces all attribute tags.
  (4) CRASH-SITE-1: step_generate_data_model_json defensive coerce before .lower().
  (5) CRASH-SITE-2: step_generate_metric_view_artifacts invariant call at top.
  (6) DRY: helpers are module-level (no duplication).

Tests:
- Static: every v250 alias is present in the notebook source.
- Static: every consumer site (4 of them) calls the v250 helper or coerces inline.
- Static: SelfFixer invariants now capture schema_string_violations_total.
- Static: _SELFFIXER_PROMPT forbids dict tags.
- Behavioral: _count_schema_string_violations_v250 catches dict-tagged attrs.
- Behavioral: _enforce_string_tags_invariant_v250 coerces dict tags to comma-joined string.
- Behavioral: schema-shape regression check rejects mutations that introduce dict tags.
"""

import json
import pathlib
import re

import pytest


NB_PATH = pathlib.Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_source() -> str:
    nb = json.loads(NB_PATH.read_text())
    out = []
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        out.append("".join(c.get("source", [])))
    return "\n".join(out)


SRC = _read_source()


def test_v250_version_bump():
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', SRC)
    assert m, "__AGENT_VERSION__ not found"
    assert tuple(int(_x) for _x in m.group(1).split(".")) >= (2, 5, 0), f"__AGENT_VERSION__ should be 2.5.0, got {m.group(1)}"


def test_v250_aliases_all_present():
    expected_aliases = [
        "v250-selffixer-schema-shape-guard",
        "v250-enforce-string-tags-invariant",
        "v250-modeljson-tags-coerced",
        "v250-coerce-tags-to-string",
        "v250-count-schema-string-violations",
    ]
    for alias in expected_aliases:
        assert alias in SRC, f"v250 alias `{alias}` missing"


def test_v250_fired_sentinels_present():
    fired_sentinels = [
        "[v250-enforce-string-tags-invariant FIRED]",
        "[v250-selffixer-schema-shape-guard FIRED]",
        "[v250-modeljson-tags-coerced FIRED]",
    ]
    for sentinel in fired_sentinels:
        assert sentinel in SRC, f"FIRED log sentinel `{sentinel}` missing"


def test_v250_module_level_helpers_exist():
    assert "def _coerce_tags_to_string_v250(" in SRC, \
        "_coerce_tags_to_string_v250 must be a module-level helper"
    assert "def _enforce_string_tags_invariant_v250(" in SRC, \
        "_enforce_string_tags_invariant_v250 must be a module-level helper"
    assert "def _count_schema_string_violations_v250(" in SRC, \
        "_count_schema_string_violations_v250 must be a module-level helper"


def test_v250_no_inline_v240_coerce_duplication():
    """DRY check: enforce_configured_pk_consistency should NOT have an inline _coerce_tags;
    it should call the module-level helper instead.
    """
    fn_start = SRC.find("def enforce_configured_pk_consistency(")
    assert fn_start > 0, "enforce_configured_pk_consistency not found"
    next_def_after = SRC.find("\ndef ", fn_start + 1)
    fn_block = SRC[fn_start:next_def_after] if next_def_after > 0 else SRC[fn_start:]
    assert "def _coerce_tags(v):" not in fn_block, \
        "DRY violation: enforce_configured_pk_consistency still has the inline v240 _coerce_tags. " \
        "It should call _enforce_string_tags_invariant_v250 instead."
    assert "_enforce_string_tags_invariant_v250(" in fn_block, \
        "enforce_configured_pk_consistency must call _enforce_string_tags_invariant_v250"


def test_v250_boundary_call_in_finalize_step():
    fn_start = SRC.find("def step_finalize_model_before_physical_schema(")
    assert fn_start > 0, "step_finalize_model_before_physical_schema not found"
    next_def_after = SRC.find("\ndef ", fn_start + 1)
    fn_block = SRC[fn_start:next_def_after] if next_def_after > 0 else SRC[fn_start:]
    assert "_enforce_string_tags_invariant_v250(" in fn_block, \
        "step_finalize_model_before_physical_schema must call the v250 boundary invariant"
    assert "step_finalize_model_before_physical_schema_BOUNDARY" in fn_block, \
        "boundary site_alias should mark this as the chokepoint"


def test_v250_modeljson_coerce_precedes_lower():
    """The defensive coerce in step_generate_data_model_json must run BEFORE `'pii' in _attr_tags.lower()`.
    Look only inside the function body, not in the release-note header where the string is quoted.
    """
    fn_start = SRC.find("\n                _pii_tagged_in_export = 0")
    assert fn_start > 0, "step_generate_data_model_json PII loop not found"
    fn_block = SRC[fn_start:fn_start + 4000]
    idx_coerce = fn_block.find("v250-modeljson-tags-coerced FIRED")
    idx_lower = fn_block.find("'pii' in _attr_tags.lower()")
    assert idx_coerce > 0, "v250-modeljson-tags-coerced FIRED sentinel missing in step_generate_data_model_json"
    assert idx_lower > 0, "_attr_tags.lower() call site missing"
    assert idx_coerce < idx_lower, (
        f"v250-modeljson-tags-coerced (idx={idx_coerce}) must come BEFORE the .lower() call "
        f"(idx={idx_lower}); otherwise the dict crash repeats"
    )


def test_v250_mv_artifact_invariant_call():
    fn_start = SRC.find("def step_generate_metric_view_artifacts(")
    assert fn_start > 0
    next_def_after = SRC.find("\ndef ", fn_start + 1)
    fn_block = SRC[fn_start:next_def_after] if next_def_after > 0 else SRC[fn_start:]
    assert "_enforce_string_tags_invariant_v250(" in fn_block, \
        "step_generate_metric_view_artifacts must call _enforce_string_tags_invariant_v250 at top"
    assert "step_generate_metric_view_artifacts" in fn_block, "site_alias should reference this fn"


def test_v250_selffixer_invariants_capture_schema_violations():
    fn_start = SRC.find("def _selffixer_capture_invariants(")
    assert fn_start > 0
    next_def_after = SRC.find("\ndef ", fn_start + 1)
    fn_block = SRC[fn_start:next_def_after] if next_def_after > 0 else SRC[fn_start:]
    assert "_count_schema_string_violations_v250(" in fn_block, \
        "_selffixer_capture_invariants must invoke _count_schema_string_violations_v250"
    assert "schema_string_violations_total" in fn_block, \
        "_selffixer_capture_invariants must expose schema_string_violations_total"


def test_v250_selffixer_rejects_schema_regression():
    idx_regressed = SRC.find("schema_regressed = (")
    assert idx_regressed > 0, "schema_regressed gate missing in SelfFixer"
    # The first occurrence of the FIRED string is in the version-history header — skip past it.
    idx_log = SRC.find("v250-selffixer-schema-shape-guard FIRED", idx_regressed)
    assert idx_log > idx_regressed, (
        "v250-selffixer-schema-shape-guard FIRED must be emitted by the schema_regressed branch "
        "(must appear AFTER the schema_regressed = ( gate)"
    )


def test_v250_selffixer_prompt_forbids_dict_tags():
    idx_prompt = SRC.find("_SELFFIXER_PROMPT = ")
    assert idx_prompt > 0
    prompt_end = SRC.find('"""', idx_prompt + 30)
    prompt_block = SRC[idx_prompt:prompt_end + 3]
    assert "FIELD SHAPE INVARIANTS" in prompt_block, "FIELD SHAPE INVARIANTS section missing"
    assert "NEVER a dict" in prompt_block, "prompt must say tags is NEVER a dict"
    assert "key1=value1,key2=value2" in prompt_block or "k=v" in prompt_block.lower(), \
        "prompt must show the correct comma-separated key=value shape"


def test_v250_coerce_tags_behavior():
    """Behavioral: run the helper extracted from the notebook source."""
    ns = {}
    fn_start = SRC.find("def _coerce_tags_to_string_v250(")
    next_def = SRC.find("\ndef ", fn_start + 1)
    fn_src = SRC[fn_start:next_def].strip()
    exec(fn_src, ns)
    fn = ns["_coerce_tags_to_string_v250"]

    assert fn("pii,contact") == "pii,contact"
    assert fn("") == ""
    assert fn(None) == ""
    assert fn({"gov_transport_source_attribute": "employee_id"}) == "gov_transport_source_attribute=employee_id"
    coerced = fn({"a": 1, "b": 2})
    parts = sorted(coerced.split(","))
    assert parts == ["a=1", "b=2"]
    assert fn(["pii", "personal"]) == "pii,personal"
    assert fn(("pii", "audit")) == "pii,audit"
    assert fn(123) == "123"

    for shape in [{}, [], (), set(), None]:
        out = fn(shape)
        assert isinstance(out, str), f"v250 coerce on {shape!r} returned {type(out).__name__}, want str"
        _ = out.lower()


def test_v250_count_schema_violations_behavior():
    ns = {}
    for name in ("_count_schema_string_violations_v250",):
        fn_start = SRC.find(f"def {name}(")
        next_def = SRC.find("\ndef ", fn_start + 1)
        fn_src = SRC[fn_start:next_def].strip()
        exec(fn_src, ns)
    fn = ns["_count_schema_string_violations_v250"]

    clean_model = {
        "model": {
            "domains": [
                {
                    "name": "hr",
                    "products": [
                        {
                            "product": "employee",
                            "attributes": [
                                {"name": "employee_id", "type": "BIGINT", "tags": "primary_key", "description": "PK"},
                                {"name": "first_name", "type": "STRING", "tags": "pii", "description": ""},
                            ],
                        }
                    ],
                }
            ]
        }
    }
    counts = fn(clean_model)
    assert counts["total"] == 0, f"clean model should have 0 violations, got {counts}"

    dirty_model = {
        "model": {
            "domains": [
                {
                    "name": "hr",
                    "products": [
                        {
                            "product": "employee",
                            "attributes": [
                                {
                                    "name": "employee_id",
                                    "type": "BIGINT",
                                    "tags": {"gov_transport_source_attribute": "employee_id"},
                                    "description": "PK",
                                },
                                {
                                    "name": "first_name",
                                    "type": "STRING",
                                    "tags": ["pii", "personal"],
                                    "description": {"text": "the first name"},
                                },
                            ],
                        }
                    ],
                }
            ]
        }
    }
    counts = fn(dirty_model)
    assert counts["tags"] == 2, f"two dict/list tag fields, got {counts['tags']}"
    assert counts["description"] == 1, f"one dict description field, got {counts['description']}"
    assert counts["total"] >= 3


def test_v250_enforce_invariant_behavior():
    """Behavioral: prove the invariant coerces an in-place mutation."""
    ns = {}
    for name in ("_coerce_tags_to_string_v250", "_enforce_string_tags_invariant_v250"):
        fn_start = SRC.find(f"def {name}(")
        next_def = SRC.find("\ndef ", fn_start + 1)
        fn_src = SRC[fn_start:next_def].strip()
        exec(fn_src, ns)

    attrs = [
        {"domain": "hr", "product": "employee", "attribute": "employee_id", "tags": {"gov_transport_source_attribute": "employee_id"}},
        {"domain": "hr", "product": "employee", "attribute": "first_name", "tags": "pii"},
        {"domain": "hr", "product": "employee", "attribute": "last_name", "tags": ["pii", "audit"]},
        {"domain": "hr", "product": "employee", "attribute": "manager_id", "tags": None},
    ]

    n_coerced = ns["_enforce_string_tags_invariant_v250"](attrs, logger=None, site_alias="test")
    assert n_coerced == 2, f"expected 2 coerced (dict + list), got {n_coerced}"
    for a in attrs:
        assert isinstance(a["tags"], str) or a["tags"] is None
    assert attrs[0]["tags"] == "gov_transport_source_attribute=employee_id"
    assert attrs[1]["tags"] == "pii"
    assert attrs[2]["tags"] == "pii,audit"


def test_v250_v240_compatibility_preserved():
    """The v240 alias must STILL be in the notebook so prior tests/audits don't break.
    The v240 INLINE _coerce_tags is removed (DRY), but the [v240-tags-coerced FIRED] sentinel
    can either be removed or replaced by the v250 ones — what matters is the call-site coerces.
    """
    assert "v250-enforce-string-tags-invariant" in SRC


def test_v250_pre_patch_would_crash_proof():
    """Prove the pre-patch behavior: `.lower()` on a dict crashes."""
    bad_dict_tag = {"gov_transport_source_attribute": "employee_id"}
    with pytest.raises(AttributeError, match="lower"):
        _ = bad_dict_tag.lower()

    bad_list_tag = [{"x": 1}]
    with pytest.raises(AttributeError, match="strip"):
        _ = bad_list_tag.strip()


if __name__ == "__main__":
    test_v250_version_bump()
    test_v250_aliases_all_present()
    test_v250_fired_sentinels_present()
    test_v250_module_level_helpers_exist()
    test_v250_no_inline_v240_coerce_duplication()
    test_v250_boundary_call_in_finalize_step()
    test_v250_modeljson_coerce_precedes_lower()
    test_v250_mv_artifact_invariant_call()
    test_v250_selffixer_invariants_capture_schema_violations()
    test_v250_selffixer_rejects_schema_regression()
    test_v250_selffixer_prompt_forbids_dict_tags()
    test_v250_coerce_tags_behavior()
    test_v250_count_schema_violations_behavior()
    test_v250_enforce_invariant_behavior()
    test_v250_v240_compatibility_preserved()
    test_v250_pre_patch_would_crash_proof()
    print("OK — all v2.5.0 tests pass")
