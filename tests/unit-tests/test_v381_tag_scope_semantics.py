"""v3.8.1 behavioral tests for the tag-scope semantic fix (user audit 2026-06-18).

Reproduces the EXACT bug the user found in vibe_gov_transport_basemvm:
  - hr.employee carried a TABLE-level `gov_transport_source_attribute=load_date` (attribute-scoped key on a table)
  - a harvested placeholder `gov_transport_source_attribute=<col>`
  - duplicate `original_table_name` + `gov_transport_original_table_name`

Proves the deterministic sanitizer strips off-scope keys + placeholders + dedups, the verifier reports
0 residual findings post-sanitize, and a legitimate attribute KEEPS its source_attribute provenance.
Extracts the live helpers from the production notebook (cell 5) so it fails on pre-v3.8.1 HEAD.
"""
import json
import os

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_ns():
    nb = json.load(open(NB))
    for c in nb.get("cells", []):
        if c.get("cell_type") != "code":
            continue
        src = "".join(c.get("source", []))
        if "def _v381_bare_key" in src and "def _v381_verify_tag_semantics" in src:
            start = src.index("def _v381_bare_key")
            end = src.index("def _harvest_trace_tags")
            block = src[start:end]
            ns = {}
            exec(compile(block, "<v381scope>", "exec"), ns)
            return ns
    raise AssertionError("v381 tag-scope helpers not found in notebook")


@pytest.fixture(scope="module")
def ns():
    return _load_ns()


def test_scope_classification(ns):
    sc = ns["_v381_tag_scope"]
    # attribute-scoped (names a source column) — prefix tolerant
    assert sc("gov_transport_source_attribute", "gov_transport_") == "attribute"
    assert sc("source_attribute") == "attribute"
    assert sc("foo_column") == "attribute"
    # table-scoped
    assert sc("gov_transport_original_table_name", "gov_transport_") == "table"
    assert sc("source_table") == "table"
    assert sc("subdomain") == "table"
    assert sc("data_type") == "table"
    # domain-scoped
    assert sc("division") == "domain"
    # neutral
    assert sc("glossary_term") == "any"
    assert sc("pii") == "any"


def test_placeholder_detection(ns):
    ph = ns["_v381_is_placeholder_tag_value"]
    assert ph("<col>") is True
    assert ph("<anything>") is True
    assert ph("") is True
    assert ph("null") is True
    assert ph("load_date") is False
    assert ph("emp_actions") is False


def _bug_product():
    # the exact corrupted hr.employee product from vibe_gov_transport_basemvm
    return {
        "domain": "hr", "name": "employee",
        "tags": "gov_transport_source_table=emp_actions,gov_transport_source_attribute=load_date,"
                "original_table_name=emp_actions,gov_transport_original_table_name=emp_actions,"
                "gov_transport_source_attribute=<col>,gov_transport_subdomain=employee_records,"
                "gov_transport_source_table=<table>",
        "tag_set": [
            {"key": "gov_transport_source_attribute", "value": "load_date", "kind": "key_value", "source": "explicit"},
            {"key": "gov_transport_source_attribute", "value": "<col>", "kind": "key_value", "source": "harvested"},
            {"key": "gov_transport_source_table", "value": "emp_actions", "kind": "key_value", "source": "explicit"},
            {"key": "gov_transport_subdomain", "value": "employee_records", "kind": "key_value", "source": "derived"},
        ],
    }


def _legit_attr():
    return {"domain": "hr", "product": "employee", "attribute": "hire_date",
            "tags": "gov_transport_source_attribute=load_date,glossary_term=Hire Date"}


def test_sanitizer_strips_offscope_placeholder_dedup(ns):
    cfg = {"MODEL_CONVENTIONS": {"tag_prefix": "gov_transport_", "tag_suffix": ""}}
    prod = _bug_product()
    attr = _legit_attr()

    # FAIL-PRE proof: the bug exists before sanitize
    verify = ns["_v381_verify_tag_semantics"]
    pre = verify([], [prod], [attr], cfg, None)
    # the attribute-scoped source_attribute on a product is a scope mismatch (checked before placeholder)
    assert any("tag_scope_mismatch" in f for f in pre), "expected a pre-fix scope violation on the product"
    # a correctly-scoped table key (source_table) with a placeholder value is a placeholder finding
    assert any("placeholder" in f for f in pre), "expected a pre-fix placeholder finding"

    stats = ns["_v381_sanitize_tag_scopes"]([prod], [attr], cfg, None)
    assert stats["scope"] >= 1 and stats["placeholder"] >= 1 and stats["dup"] >= 1

    # product no longer carries the attribute-scoped source_attribute tag
    assert "source_attribute" not in prod["tags"], prod["tags"]
    assert "<col>" not in prod["tags"], prod["tags"]
    # duplicate original_table_name collapsed to the single prefix-correct variant
    assert prod["tags"].count("original_table_name") == 1, prod["tags"]
    assert "gov_transport_original_table_name=emp_actions" in prod["tags"]
    # legit table-scoped tags retained
    assert "gov_transport_source_table=emp_actions" in prod["tags"]
    assert "gov_transport_subdomain=employee_records" in prod["tags"]
    # tag_set also cleaned
    keys = [t["key"] for t in prod["tag_set"]]
    assert "gov_transport_source_attribute" not in keys, keys

    # the ATTRIBUTE keeps its legitimate source_attribute provenance (not stripped)
    assert "source_attribute=load_date" in attr["tags"], attr["tags"]

    # PASS-POST: verifier now reports zero violations
    post = verify([], [prod], [attr], cfg, None)
    assert post == [], post


def test_demote_lineage_column_to_tag(ns):
    cfg = {"MODEL_CONVENTIONS": {"tag_prefix": "gov_transport_", "tag_suffix": ""}}
    # hr.organization.gov_transport_source_table is a lineage column wrongly ingested as a business attribute
    prod = {"domain": "hr", "name": "organization", "tags": "gov_transport_subdomain=employee_records", "attributes": []}
    attrs = [
        {"domain": "hr", "product": "organization", "name": "org_unit_number"},   # real business col
        {"domain": "hr", "product": "organization", "name": "gov_transport_source_table",
         "tags": "gov_transport_source_table=enriched_position_data,glossary_term=gov_transport Source Table"},
        {"domain": "hr", "product": "organization", "name": "source_system",
         "tags": "source_system=hr_silver"},
    ]
    res = ns["_v381_demote_metadata_columns"]([prod], attrs, cfg, None)
    assert res["removed"] == 2, res
    names = [a["name"] for a in attrs]
    assert "gov_transport_source_table" not in names and "source_system" not in names, names
    assert "org_unit_number" in names  # real business column preserved
    # provenance promoted to a table tag (not lost)
    assert "gov_transport_source_table=enriched_position_data" in prod["tags"], prod["tags"]


def test_demote_never_removes_division_or_pkfk(ns):
    cfg = {"MODEL_CONVENTIONS": {"tag_prefix": "gov_transport_", "tag_suffix": ""}}
    attrs = [
        {"domain": "project", "product": "route", "name": "gov_transport_division"},        # legit gov_transport business data
        {"domain": "hr", "product": "employee", "name": "source_table", "primary_key": True},  # guarded PK
        {"domain": "hr", "product": "employee", "name": "source_system", "foreign_key_to": "x.y.z"},  # guarded FK
    ]
    res = ns["_v381_demote_metadata_columns"]([], attrs, cfg, None)
    assert res["removed"] == 0, res
    names = [a["name"] for a in attrs]
    assert names == ["gov_transport_division", "source_table", "source_system"]


def test_attribute_table_scoped_tag_stripped(ns):
    cfg = {"MODEL_CONVENTIONS": {"tag_prefix": "gov_transport_", "tag_suffix": ""}}
    # a table-scoped key wrongly on an attribute must be removed
    attr = {"domain": "hr", "product": "employee", "attribute": "x",
            "tags": "gov_transport_original_table_name=emp_actions,glossary_term=X"}
    ns["_v381_sanitize_tag_scopes"]([], [attr], cfg, None)
    assert "original_table_name" not in attr["tags"], attr["tags"]
    assert "glossary_term=X" in attr["tags"]
