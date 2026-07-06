"""v3.8.3 behavioral tests for the SIX generic VREQ-lifecycle fixes (microscopic vibe audit 2026-06-18).

Each fix is industry-agnostic; tests assert the OBSERVABLE state change (not a log line) and use the
EXACT structural shapes from the ncdot vibe (backtick directives, the 72-row CDE glossary table, the
9-row subdomain roster, the 3 mandated metric views, the PSE merge-first directive) so they would have
caught every real miss. Loads the live helpers from the production notebook; on pre-v3.8.3 HEAD the
helpers do not exist, so _load_ns() raises and every test fails (fail-pre proof).
"""
import json
import os

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")

VIBE = """
### HR subdomains (use the first column of the dataset table to define HR subdomain grouping)

| Subdomain | Datasets | Proposed Steward |
|---|---|---|
| Employee Records | x | A |
| Compensation & Benefits | y | B |
| Talent Acquisition | z | C |

For EACH new table created in the `hr` domain based on the DDL below, add an ATTRIBUTE-LEVEL tag `ncdot_source_attribute=<original_column>`.

### Business glossary attribute enrichment

For every attribute in the HR base model, attach the tag `ncdot_business_glossary_term=<Business Data Element>` whenever a match exists in the table below.

| CDE# | Sub-Domain | Business Data Element | Description |
|---|---|---|---|
| CDE-1 | x | Organizational Unit | a |
| CDE-2 | x | Position | b |
| CDE-3 | x | Vacancy Status | c |

### Metric views (build EXACTLY these 3 metric views)

#### KPI-1: Vacancy Rate
#### KPI-2: Retirement Eligibility
#### KPI-3: Total Positions

### Reverse-engineer the PSE schema into the `project` domain

Evaluate every column from these source tables and merge into existing `project` domain products where
the concept already exists; only create a new product when none of the existing project products covers the column.

- Tag prefix: `ncdot_` for every NCDOT-specific tag.
- Source-trace MANDATORY for every HR table: `ncdot_source_table=<orig>`, `ncdot_source_attribute=<orig>`.
- For PSE-derived project tables: `original_table_name=<orig>`.
"""

CFG = {"MODEL_CONVENTIONS": {"tag_prefix": "ncdot_", "tag_suffix": ""}}


def _grab(src, name):
    i = src.index("\ndef " + name + "(")
    j = src.index("\ndef ", i + 5)
    return src[i:j]


def _load_ns():
    nb = json.load(open(NB))
    code = [c for c in nb.get("cells", []) if c.get("cell_type") == "code"]
    s0 = "".join(code[0].get("source", []))
    s2 = "".join(code[2].get("source", []))
    if "def _v383_remove_metric_view_products" not in s2:
        raise AssertionError("v3.8.3 _v383 helpers not found in notebook (pre-fix HEAD)")
    import re as _re
    ns = {"re": _re}
    exec(compile(_grab(s0, "_coerce_tags_to_string_v250"), "<coerce>", "exec"), ns)
    for nm in ("_v371_parse_bulk_tag_directives", "_iter_flat_attributes", "_vibe_set_entity_tag"):
        exec(compile(_grab(s2, nm), "<" + nm + ">", "exec"), ns)
    blk = s2[s2.index("def _v381_bare_key"):s2.index("def _harvest_trace_tags")]
    exec(compile(blk, "<v381v383>", "exec"), ns)

    def _mv_dir(wv, vibe_text=None):
        names = _re.findall(r"####\s*KPI-\d+:\s*(.+)", vibe_text or "")
        return (len(names), [n.strip() for n in names])

    ns["_vibe_exact_metric_view_directive"] = _mv_dir
    return ns


@pytest.fixture(scope="module")
def ns():
    return _load_ns()


# ---------------------------------------------------------------- CLASS A ----
def test_A_metric_view_product_removed_not_fk_target(ns):
    doms = [{"name": "hr", "products": [{"name": "vacancy_rate"}, {"name": "employee"}]}]
    prods = [{"domain": "hr", "name": "vacancy_rate", "description": "Metric view (KPI-1): vacancy rate"},
             {"domain": "hr", "name": "employee", "description": "core HR table"}]
    attrs = [{"domain": "hr", "product": "vacancy_rate", "attribute": "x"},
             {"domain": "hr", "product": "employee", "attribute": "y"}]
    removed = ns["_v383_remove_metric_view_products"](doms, prods, attrs, VIBE, {}, CFG, None)
    assert removed == ["vacancy_rate"], removed
    assert [p["name"] for p in prods] == ["employee"]
    assert [a["product"] for a in attrs] == ["employee"]  # orphan attrs dropped
    assert doms[0]["products"] == [{"name": "employee"}]   # domain product list pruned


def test_A_fk_target_metric_view_is_kept_safe(ns):
    # a product that LOOKS like an MV but is an FK target must NOT be removed (FK-safe)
    doms = [{"name": "hr", "products": [{"name": "vacancy_rate"}]}]
    prods = [{"domain": "hr", "name": "vacancy_rate", "description": "Metric view (KPI-1)"}]
    attrs = [{"domain": "hr", "product": "other", "attribute": "vr_id", "foreign_key_to": "hr.vacancy_rate.id"}]
    removed = ns["_v383_remove_metric_view_products"](doms, prods, attrs, VIBE, {}, CFG, None)
    assert removed == [], removed
    assert [p["name"] for p in prods] == ["vacancy_rate"]


# ---------------------------------------------------------------- CLASS B ----
def test_B_per_attribute_provenance_resolved(ns):
    prods = [{"domain": "hr", "name": "employee", "tags": "ncdot_source_table=emp_actions"},
             {"domain": "project", "name": "route", "tags": ""}]  # NOT source-derived
    attrs = [{"domain": "hr", "product": "employee", "attribute": "hire_date", "column_name": "hire_date", "tags": ""},
             {"domain": "project", "product": "route", "attribute": "route_id", "column_name": "route_id", "tags": ""}]
    n = ns["_v383_apply_per_attribute_value_tags"](attrs, prods, VIBE, CFG, None)
    assert n == 1, n
    assert "ncdot_source_attribute=hire_date" in attrs[0]["tags"], attrs[0]["tags"]
    # the non-source-derived product's attribute is untouched (no blanket stamping)
    assert "source_attribute" not in (attrs[1]["tags"] or ""), attrs[1]["tags"]


def test_B_directive_parses_through_backticks(ns):
    keys = ns["_v383_parse_attr_placeholder_directives"](VIBE)
    assert "ncdot_source_attribute" in keys, keys  # backtick + 'EACH table' phrasing must parse


# ---------------------------------------------------------------- CLASS C ----
def test_C_glossary_lexicon_harvested_full(ns):
    lex = ns["_v383_harvest_column_values"](VIBE, "Business Data Element")
    assert set(lex) == {"Organizational Unit", "Position", "Vacancy Status"}, lex


def test_C_fabricated_glossary_purged_real_kept(ns):
    attrs = [{"domain": "hr", "product": "e", "attribute": "a", "business_glossary_term": "Position"},
             {"domain": "hr", "product": "e", "attribute": "b", "business_glossary_term": "Made Up Zzqq Nonsense"},
             {"domain": "hr", "product": "e", "attribute": "c", "tags": "ncdot_business_glossary_term=Garbage Xyzzy"}]
    purged = ns["_v383_purge_fabricated_lookup_tags"](attrs, VIBE, CFG, None)
    assert purged == 2, purged
    assert attrs[0]["business_glossary_term"] == "Position"   # real lexicon match survives
    assert attrs[1]["business_glossary_term"] == ""           # zero-overlap fabrication purged
    assert "glossary_term" not in attrs[2]["tags"]            # fabricated tag-string value purged


def test_C_noop_when_no_lookup_directive(ns):
    attrs = [{"domain": "hr", "product": "e", "attribute": "a", "business_glossary_term": "Anything"}]
    assert ns["_v383_purge_fabricated_lookup_tags"](attrs, "no directives here", CFG, None) == 0
    assert attrs[0]["business_glossary_term"] == "Anything"


# ---------------------------------------------------------------- CLASS D ----
def test_D_closed_roster_relabels_invented_label(ns):
    prods = [{"domain": "hr", "name": "benefit_plan", "subdomain": "made_up_label", "description": "compensation benefits"},
             {"domain": "hr", "name": "emp", "subdomain": "Employee Records", "description": ""}]
    n = ns["_v383_enforce_closed_label_roster"](prods, VIBE, CFG, None)
    assert n == 1, n
    assert prods[0]["subdomain"] == "compensation_benefits"   # forced onto nearest roster member
    assert prods[1]["subdomain"] == "Employee Records"        # already a member -> untouched


def test_D_noop_for_open_roster(ns):
    prods = [{"domain": "hr", "name": "x", "subdomain": "anything", "description": "z"}]
    assert ns["_v383_enforce_closed_label_roster"](prods, "no roster table here", CFG, None) == 0
    assert prods[0]["subdomain"] == "anything"


# ---------------------------------------------------------------- CLASS E ----
def test_E_merge_first_flags_overlapping_source_clone(ns):
    prods = [{"domain": "project", "name": "dsctrcategory", "tags": "original_table_name=dsctrcategory", "description": "decision tree category"},
             {"domain": "project", "name": "category", "tags": "", "description": "project category lookup"}]
    wv = {}
    flags = ns["_v383_flag_merge_first_candidates"]([], prods, [], VIBE, wv, CFG, None)
    assert len(flags) == 1, flags
    assert len(wv["_unfulfilled_for_next_vibe"]) == 1


def test_E_noop_without_merge_directive(ns):
    prods = [{"domain": "project", "name": "dsctrcategory", "tags": "original_table_name=x", "description": "category"},
             {"domain": "project", "name": "category", "tags": "", "description": "category"}]
    assert ns["_v383_flag_merge_first_candidates"]([], prods, [], "no merge directive", {}, CFG, None) == []


# ---------------------------------------------------------------- CLASS F ----
def test_F_literal_tag_name_outranks_prefix(ns):
    prods = [{"domain": "project", "name": "route", "tags": "ncdot_original_table_name=pse_route,foo=bar"}]
    n = ns["_v383_enforce_tag_name_precedence"](prods, [], VIBE, CFG, None)
    assert n == 1, n
    assert "original_table_name=pse_route" in prods[0]["tags"]
    assert "ncdot_original_table_name" not in prods[0]["tags"]  # prefixed variant rewritten to literal
    assert "foo=bar" in prods[0]["tags"]                        # unrelated tag preserved


def test_F_prefixed_only_keys_untouched(ns):
    # ncdot_source_table is given WITH prefix in the vibe -> not a literal-unprefixed target
    prods = [{"domain": "hr", "name": "employee", "tags": "ncdot_source_table=emp_actions"}]
    ns["_v383_enforce_tag_name_precedence"](prods, [], VIBE, CFG, None)
    assert prods[0]["tags"] == "ncdot_source_table=emp_actions"
