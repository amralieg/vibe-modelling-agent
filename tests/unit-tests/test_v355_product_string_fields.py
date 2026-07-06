"""Behavioral test for v3.5.5 product-level string-field boundary invariant.

aliases:
  v355-enforce-string-product-fields-invariant

Regression target: v3.5.4 healthcare + media_broadcasting VOV2 runs (2026-06-11) BOTH crashed at
~13h with `AttributeError: 'list' object has no attribute 'strip'` in
step_create_physical_schema_stage1 table-tag emit, on `product.source_domains`, AFTER step 8d
metric-view artifacts had already SUCCEEDED (281 MVs for healthcare). The crash line is:

    if p_source_domains and p_source_domains.strip():   # p_source_domains is a list

Producer: VOV / SelfFixer / sandbox LLM mutations emit product-level string fields
(source_domains / subdomain / data_type / association_edges / tags) as list/dict/None.

Root cause: only ATTRIBUTE `tags` had a boundary string-coercer (v250). Product-level string
fields had none, so physical-build + table-tag + readme consumers calling .strip()/.lower()/.split()
crashed.

Fix (this version): module-level _enforce_string_product_fields_invariant_v355 reuses
_coerce_tags_to_string_v250 (DRY) and is called at all 3 consumer boundaries:
  (1) step_create_physical_schema_stage1 (the live crash site)
  (2) step_generate_readme
  (3) main() install re-tag

Tests:
- Static: alias + FIRED sentinel + module-level helper present.
- Static: all 3 consumer sites call the helper.
- Static: helper reuses _coerce_tags_to_string_v250 (DRY, no duplicated coercion).
- Behavioral: helper coerces list/dict/None product fields in place; returns count.
- Behavioral pre/post: the EXACT notebook consumer pattern `p_source_domains.strip()` crashes on a
  list pre-coerce and runs clean post-coerce.
- Version bump >= 3.5.5.
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


def _extract(*names):
    ns = {}
    # The v355 enforcer reads a module-level tuple constant; exec it into the namespace first.
    const_match = re.search(r'^_PRODUCT_STRING_FIELDS_V355\s*=\s*\(.*?\)', SRC, re.MULTILINE)
    assert const_match, "_PRODUCT_STRING_FIELDS_V355 constant not found"
    exec(const_match.group(0), ns)
    for name in names:
        fn_start = SRC.find(f"def {name}(")
        assert fn_start > 0, f"{name} not found in notebook source"
        next_def = SRC.find("\ndef ", fn_start + 1)
        fn_src = SRC[fn_start:next_def].strip() if next_def > 0 else SRC[fn_start:].strip()
        exec(fn_src, ns)
    return ns


def test_v355_version_bump():
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', SRC)
    assert m, "__AGENT_VERSION__ not found"
    assert tuple(int(x) for x in m.group(1).split(".")) >= (3, 5, 5), \
        f"__AGENT_VERSION__ should be >= 3.5.5, got {m.group(1)}"


def test_v355_alias_and_helper_present():
    assert "v355-enforce-string-product-fields-invariant" in SRC, "v355 alias missing"
    assert "def _enforce_string_product_fields_invariant_v355(" in SRC, \
        "module-level helper _enforce_string_product_fields_invariant_v355 missing"
    assert "[v355-enforce-string-product-fields-invariant FIRED]" in SRC, "FIRED sentinel missing"


def test_v355_helper_is_dry_reuses_v250_coercer():
    fn_start = SRC.find("def _enforce_string_product_fields_invariant_v355(")
    next_def = SRC.find("\ndef ", fn_start + 1)
    fn_block = SRC[fn_start:next_def] if next_def > 0 else SRC[fn_start:]
    assert "_coerce_tags_to_string_v250(" in fn_block, \
        "DRY violation: v355 enforcer must reuse _coerce_tags_to_string_v250, not duplicate coercion"


def test_v355_called_at_all_three_consumer_sites():
    for fn_name, alias in [
        ("step_create_physical_schema_stage1", "step_create_physical_schema_stage1"),
        ("step_generate_readme", "step_generate_readme"),
        ("main", "main_install_retag"),
    ]:
        fn_start = SRC.find(f"def {fn_name}(")
        assert fn_start > 0, f"{fn_name} not found"
        next_def = SRC.find("\ndef ", fn_start + 1)
        fn_block = SRC[fn_start:next_def] if next_def > 0 else SRC[fn_start:]
        assert "_enforce_string_product_fields_invariant_v355(" in fn_block, \
            f"{fn_name} must call the v355 product-field invariant"
        assert alias in fn_block, f"{fn_name} should pass site_alias containing `{alias}`"


def test_v355_enforcer_coerces_product_fields_in_place():
    ns = _extract("_coerce_tags_to_string_v250", "_enforce_string_product_fields_invariant_v355")
    enforce = ns["_enforce_string_product_fields_invariant_v355"]

    products = [
        {"domain": "patient", "product": "demographics",
         "source_domains": ["clinical", "billing"],          # the live crash field
         "subdomain": ["identity", "demographics"],
         "data_type": "master_data",                          # already a string -> untouched
         "association_edges": {"edge": "patient->encounter"},
         "tags": ["pii", "phi"]},
        {"domain": "billing", "product": "claim",
         "source_domains": "billing",                         # clean -> untouched
         "subdomain": None},                                  # None -> untouched (not coerced)
        "not-a-dict",                                          # skipped gracefully
    ]

    n = enforce(products, logger=None, site_alias="test")
    # coerced: source_domains(list) + subdomain(list) + association_edges(dict) + tags(list) = 4
    assert n == 4, f"expected 4 coerced fields, got {n}"
    assert products[0]["source_domains"] == "clinical,billing"
    assert products[0]["subdomain"] == "identity,demographics"
    assert products[0]["data_type"] == "master_data"          # untouched
    assert products[0]["association_edges"] == "edge=patient->encounter"
    assert products[0]["tags"] == "pii,phi"
    assert products[1]["source_domains"] == "billing"         # untouched
    assert products[1]["subdomain"] is None                   # None left as-is


def test_v355_pre_patch_crash_then_post_patch_clean_on_real_consumer_pattern():
    """The EXACT notebook consumer pattern crashes on a list pre-coerce; runs clean post-coerce."""
    ns = _extract("_coerce_tags_to_string_v250", "_enforce_string_product_fields_invariant_v355")
    enforce = ns["_enforce_string_product_fields_invariant_v355"]

    # PRE-PATCH reality: source_domains is a list, consumer does `x and x.strip()`.
    p_source_domains = ["clinical", "billing"]
    with pytest.raises(AttributeError, match="strip"):
        if p_source_domains and p_source_domains.strip():  # noqa: B015 - replicates notebook crash line
            pass

    # POST-PATCH: run the boundary enforcer first, then the identical consumer pattern is safe.
    product = {"domain": "patient", "product": "demographics", "source_domains": ["clinical", "billing"]}
    enforce([product], logger=None, site_alias="test")
    p_source_domains = product["source_domains"]
    emitted = None
    if p_source_domains and p_source_domains.strip():
        emitted = p_source_domains.strip()
    assert emitted == "clinical,billing"


if __name__ == "__main__":
    test_v355_version_bump()
    test_v355_alias_and_helper_present()
    test_v355_helper_is_dry_reuses_v250_coercer()
    test_v355_called_at_all_three_consumer_sites()
    test_v355_enforcer_coerces_product_fields_in_place()
    test_v355_pre_patch_crash_then_post_patch_clean_on_real_consumer_pattern()
    print("OK -- all v3.5.5 product-string-field tests pass")
