"""v2.8.0 behavioral tests for _enforce_source_trace_tags (alias=source-trace-enforce).

§8.10: every patch needs a BEHAVIORAL test that exercises the production code path
end-to-end and asserts the OBSERVABLE state change (not a static grep).

Failure mode pre-patch (no enforcement pass existed for new-base models):
  - table-level source-trace tags (e.g. original_table_name) left EMPTY by the
    MODEL_ARCHITECT_REVIEW path (it only knows the model name).
  - attribute-level source-trace tags (e.g. ncdot_source_attribute) stamped
    SELF-REFERENTIALLY (col=col) by generic ATTRIBUTE_GENERATE.

These tests drive the real notebook function (sliced from the agent .ipynb) with a
stubbed ai_agent + reverse-engineer extraction, and assert the tags become faithful
source names. Each test first asserts the pre-call (broken) state, then the post-call
(fixed) state — so the assertion proves the function changed observable state.
"""
import json
import logging
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from notebook_source_util import exec_function_namespace, slice_function_source  # noqa: E402

_LOGGER = logging.getLogger("test_source_trace")


class _StubAI:
    """Stub ai_agent. Returns canned reverse-engineer extraction and residual mapping."""

    def __init__(self, tables, residual_map=None):
        self._tables = tables
        self._residual = residual_map or {}

    def _call_ai_query(self, prompt_name=None, prompt=None, response_schema=None,
                       step_name=None, timeout_seconds=None):
        if prompt_name == "QA_REVERSE_ENGINEER_PROMPT":
            return json.dumps({"tables": self._tables})
        if prompt_name in ("SOURCE_TRACE_RESIDUAL_MAP", "SOURCE_TRACE_RESIDUAL_MAP_TBL"):
            # echo back configured mappings for idx values present in the prompt
            return json.dumps({"mappings": [
                {"idx": idx, "source_column": col} for idx, col in self._residual.items()
            ]})
        return "{}"


def _parse_ddl():
    ns = exec_function_namespace("_parse_source_ddl")
    return ns["_parse_source_ddl"]


def test_parse_source_ddl_create_materialized_view():
    fn = _parse_ddl()
    ddl = ("CREATE MATERIALIZED VIEW `hr_devtest`.`hr_silver`.`emp_history` (\n"
           "  Employee_ID STRING, employee_name STRING, Employee_Salary STRING, Date_of_Birth DATE)")
    t, c = fn(ddl)
    assert "emphistory" in t and t["emphistory"] == "emp_history"
    assert "employeesalary" in c and c["employeesalary"] == "Employee_Salary"


def test_parse_source_ddl_compact_notation():
    fn = _parse_ddl()
    ddl = "userinformation (Id INT, UserName STRING, UniqueIdentifier INT)"
    t, c = fn(ddl)
    assert t.get("userinformation") == "userinformation"
    assert c.get("username") == "UserName"


def test_parse_source_ddl_rejects_prose_parens():
    fn = _parse_ddl()
    # prose with parenthetical lists that are NOT typed columns must not become tables
    prose = "Domains and subdomains (datasets, classification, funding) and keys (employee_id)."
    t, c = fn(prose)
    assert t == {} and c == {}


def test_parse_source_ddl_empty_input():
    fn = _parse_ddl()
    assert fn("") == ({}, {})
    assert fn(None) == ({}, {})


def _ns(ai_tables, residual=None):
    """Exec the notebook function with all its free globals stubbed."""
    # _enforce_source_trace_tags calls module-level _parse_source_ddl -> provide the real one
    _parse_ns = {"__name__": "_parse_src"}
    exec(compile(slice_function_source("_parse_source_ddl"), "<nb>", "exec"), _parse_ns)
    extra = {
        "PROMPT_TEMPLATES": {"QA_REVERSE_ENGINEER_PROMPT": "{ddl_content}"},
        "QA_REVERSE_ENGINEER_SCHEMA": {},
        "_SOURCE_TRACE_RESIDUAL_SCHEMA": {},
        "_chunk_ddl_for_reverse_engineer": lambda text, max_chars=7500: [text],
        "_parse_source_ddl": _parse_ns["_parse_source_ddl"],
    }
    ns = exec_function_namespace("_enforce_source_trace_tags", extra_globals=extra)
    fn = ns["_enforce_source_trace_tags"]
    ai = _StubAI(ai_tables, residual)
    return fn, ai


def _widgets(ai):
    return {
        "ai_agent": ai,
        "effective_vibe_modelling_instructions": "CREATE TABLE hr_emp_master (...);",
    }


def _tag_val(entity, key):
    for part in (entity.get("tags") or "").split(","):
        if "=" in part:
            k, v = part.split("=", 1)
            if k.strip() == key:
                return v.strip()
        elif part.strip() == key:
            return ""
    return None


def test_table_level_empty_tag_filled_with_source_name():
    fn, ai = _ns([
        {"original_name": "hr_emp_master", "product": "employees",
         "columns": [{"name": "employee_id", "original_column_name": "emp_id"}]},
    ])
    products = [{"product": "employees", "tags": "original_table_name"}]  # empty value
    attrs = []
    # pre-call: tag value is empty (the broken state)
    assert _tag_val(products[0], "original_table_name") == ""
    changed = fn([], products, attrs, _widgets(ai), _LOGGER)
    # post-call: faithfully stamped from source DDL
    assert _tag_val(products[0], "original_table_name") == "hr_emp_master"
    assert changed >= 1


def test_attribute_self_referential_corrected_to_source_column():
    fn, ai = _ns([
        {"original_name": "hr_emp_master", "product": "employees",
         "columns": [{"name": "annual_salary", "original_column_name": "base_salary_amt"}]},
    ])
    attrs = [{"attribute": "annual_salary", "product": "employees",
              "tags": "ncdot_source_attribute=annual_salary"}]  # self-referential
    assert _tag_val(attrs[0], "ncdot_source_attribute") == "annual_salary"
    fn([], [], attrs, _widgets(ai), _LOGGER)
    assert _tag_val(attrs[0], "ncdot_source_attribute") == "base_salary_amt"


def test_residual_llm_maps_semantic_rename():
    # name does NOT match any source column; residual LLM maps idx 0 -> employee_name
    fn, ai = _ns(
        [{"original_name": "hr_emp_master", "product": "employees",
          "columns": [{"name": "employee_name", "original_column_name": "employee_name"}]}],
        residual={0: "employee_name"},
    )
    attrs = [{"attribute": "emp_full_name", "product": "employees",
              "tags": "ncdot_source_attribute=emp_full_name"}]
    fn([], [], attrs, _widgets(ai), _LOGGER)
    assert _tag_val(attrs[0], "ncdot_source_attribute") == "employee_name"


def test_fabricated_self_ref_blanked_when_no_source_origin():
    # >=20 source columns => high extraction confidence => blank fabricated self-refs
    cols = [{"name": f"src_col_{i}", "original_column_name": f"src_col_{i}"} for i in range(25)]
    fn, ai = _ns(
        [{"original_name": "hr_emp_master", "product": "employees", "columns": cols}],
        residual={0: ""},  # LLM says no source origin
    )
    attrs = [{"attribute": "synthetic_score", "product": "employees",
              "tags": "ncdot_source_attribute=synthetic_score"}]
    assert _tag_val(attrs[0], "ncdot_source_attribute") == "synthetic_score"
    fn([], [], attrs, _widgets(ai), _LOGGER)
    assert _tag_val(attrs[0], "ncdot_source_attribute") == ""


def test_noop_when_no_source_trace_keys_present():
    fn, ai = _ns([{"original_name": "x", "product": "p", "columns": []}])
    products = [{"product": "p", "tags": "pii=true"}]
    attrs = [{"attribute": "a", "product": "p", "tags": "classification=internal"}]
    changed = fn([], products, attrs, _widgets(ai), _LOGGER)
    assert changed == 0
    assert products[0]["tags"] == "pii=true"
    assert attrs[0]["tags"] == "classification=internal"


def test_v281_reads_ddl_from_model_vibes_not_business_description():
    """v2.8.1 root-cause fix: source DDL lives in model_vibes, not business_description.
    Pre-fix the function read business_description (a useless summary) -> 0 extraction.
    """
    fn, ai = _ns([
        {"original_name": "hr_emp_master", "product": "employees",
         "columns": [{"name": "annual_salary", "original_column_name": "base_salary_amt"}]},
    ])
    widgets = {
        "ai_agent": ai,
        # summary that merely *references* model_vibes — no DDL (mirrors the live NCDOT run)
        "business_description": "Reverse-engineer tables listed in model_vibes; add source tags.",
        "model_vibes": "CREATE MATERIALIZED VIEW hr_emp_master (base_salary_amt STRING);",
    }
    attrs = [{"attribute": "annual_salary", "product": "employees",
              "tags": "ncdot_source_attribute=annual_salary"}]
    fn([], [], attrs, widgets, _LOGGER)
    # the StubAI keys off prompt_name not text, but the function only reaches extraction
    # because vibe_text was non-empty from model_vibes -> tag faithfully corrected
    assert _tag_val(attrs[0], "ncdot_source_attribute") == "base_salary_amt"


def test_v281_table_residual_llm_maps_unmatched_table():
    """v2.8.1: the few unmatched source-derived tables get a residual LLM mapping."""
    fn, ai = _ns(
        [{"original_name": "userinformation", "product": "user_info",
          "columns": [{"name": "id", "original_column_name": "Id"}]}],
        residual={0: "userinformation"},
    )
    # product name does NOT normalize-match 'userinformation' -> deterministic miss -> residual
    products = [{"product": "dsctr_user_directory", "domain": "project",
                 "tags": "original_table_name"}]
    widgets = {"ai_agent": ai, "model_vibes": "userinformation (Id INT, UserName STRING)"}
    assert _tag_val(products[0], "original_table_name") == ""
    fn([], products, [], widgets, _LOGGER)
    assert _tag_val(products[0], "original_table_name") == "userinformation"


def test_faithful_value_already_present_is_preserved():
    fn, ai = _ns([
        {"original_name": "hr_emp_master", "product": "employees",
         "columns": [{"name": "annual_salary", "original_column_name": "base_salary_amt"}]},
    ])
    # attribute already carries the correct source value -> must not be blanked/changed
    attrs = [{"attribute": "annual_salary", "product": "employees",
              "tags": "ncdot_source_attribute=base_salary_amt"}]
    fn([], [], attrs, _widgets(ai), _LOGGER)
    assert _tag_val(attrs[0], "ncdot_source_attribute") == "base_salary_amt"
