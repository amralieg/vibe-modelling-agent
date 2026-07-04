"""
v4.2.5 behavioral tests -- governance-scorer-tagset-authoritative (RC1).

ROOT CAUSE (retail/water_utilities/automotive v2 ECM VOV, e.g. retail run
257229033091163): the native_quality governance penalty counted only the LEGACY
scalar attr["tags"] field (holds labels like "primary_key", ~10% populated) instead
of the AUTHORITATIVE structured tag_set / curated business_glossary_term. On a model
that was 100% glossary-governed (every attribute carries tag_set with
dbx_business_glossary_term) the scorer reported ~10% coverage and deducted -13.5
native_quality points -- a section-12 lying-scoreboard FALSE-NEGATIVE that crushed
vov_quality (retail native 36.5%).

FIX: exclude PK/FK columns from the denominator (structural, not business attributes)
and count an attribute as governed if it carries a non-empty structured tag_set OR a
non-empty scalar tags OR a CURATED (non auto-derived) business_glossary_term. A term
equal to make_attribute_dict's auto default "<Product> - <Attribute>" is NOT counted
(anti-gaming, S8.3).

These tests EXEC the ACTUAL shipped counting snippet from the notebook (not a copy),
proving fail-pre/pass-post on a realistic flat-attribute fixture mirroring the live
retail model.json shape.
"""
import json
import os
import re
import textwrap

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _extract_counting_snippet():
    """Pull the shipped RC1 governance-coverage counting loop from the notebook."""
    cells = json.load(open(NB))["cells"]
    src = ""
    for c in cells:
        if c["cell_type"] == "code" and "governance-scorer-tagset-authoritative" in "".join(c["source"]):
            src = "".join(c["source"])
            break
    assert src, "cell containing governance-scorer-tagset-authoritative not found"
    lines = src.split("\n")
    start = end = None
    for i, ln in enumerate(lines):
        if start is None and "_attrs_for_score = attributes_data if isinstance(attributes_data" in ln:
            start = i
        if start is not None and ln.strip().startswith("if _n_attr_sc > 0:"):
            end = i
            break
    assert start is not None and end is not None, "could not slice the RC1 counting loop"
    snippet = textwrap.dedent("\n".join(lines[start:end]))
    return snippet


def _run_snippet(attributes_data):
    ns = {"attributes_data": attributes_data}
    exec(compile(_extract_counting_snippet(), "<rc1-snippet>", "exec"), ns)
    return ns["_n_tagged_sc"], ns["_n_attr_sc"]


# ---- fixtures mirroring the live retail v2 model.json attribute shape ----

def _attr(product, attribute, tags="", tag_set=None, glossary=None, is_pk=False, fk=""):
    d = {
        "product": product,
        "attribute": attribute,
        "column_name": attribute,
        "type": "STRING",
        "tags": tags,
        "foreign_key_to": fk,
        # make_attribute_dict default when no curated glossary is supplied:
        "business_glossary_term": glossary if glossary is not None else (
            product.replace("_", " ").title() + " - " + attribute.replace("_", " ").title()
        ),
    }
    if tag_set is not None:
        d["tag_set"] = tag_set
    if is_pk:
        d["is_primary_key"] = True
    return d


GLOSSARY_TS = [{"key": "dbx_business_glossary_term", "value": "Stock Position", "kind": "key_value", "source": "derived"}]


class TestGovernedModelScoresHigh:
    def test_tag_set_counts_as_governed(self):
        # 10 business attrs, all with tag_set (the authoritative signal) -> 100% coverage.
        attrs = [_attr("stock_position", f"col_{i}", tag_set=GLOSSARY_TS) for i in range(10)]
        tagged, total = _run_snippet(attrs)
        assert total == 10
        assert tagged == 10  # pass-post: fully governed

    def test_curated_glossary_counts_but_auto_derived_does_not(self):
        curated = _attr("stock_position", "region_code", glossary="Region Code")  # != "Stock Position - Region Code"
        auto = _attr("stock_position", "region_code")  # == auto default -> NOT curated
        tagged, total = _run_snippet([curated, auto])
        assert total == 2
        assert tagged == 1  # only the curated one; auto-derived is anti-gaming-excluded


class TestPkFkExcludedFromDenominator:
    def test_pk_and_fk_not_counted(self):
        pk = _attr("orders", "order_id", tags="primary_key", is_pk=True)
        fk = _attr("orders", "customer_id", fk="customer.customer.customer_id")
        biz = _attr("orders", "order_total", tag_set=GLOSSARY_TS)
        tagged, total = _run_snippet([pk, fk, biz])
        assert total == 1  # PK + FK excluded from denominator
        assert tagged == 1


class TestPrePatchWouldFalseNegative:
    """The pre-patch predicate counted only scalar attr['tags'] over ALL attrs."""

    def test_prepatch_scalar_only_undercounts(self):
        # A fully tag_set-governed model with empty scalar tags: the OLD predicate
        # (`if attr.get("tags")`) would count 0/N; the shipped fix counts N/N.
        attrs = [_attr("p", f"c_{i}", tags="", tag_set=GLOSSARY_TS) for i in range(8)]
        prepatch = sum(1 for a in attrs if a.get("tags"))
        assert prepatch == 0  # proves the old field is empty -> false-negative
        tagged, total = _run_snippet(attrs)
        assert tagged == 8 and total == 8  # post-patch is honest
