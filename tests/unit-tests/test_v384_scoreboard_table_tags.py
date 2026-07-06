"""
v3.8.4 behavioral test for the lying-scoreboard root-cause fix (alias=gt-table-tag-enrich).

ROOT CAUSE: the ground-truth audit enriched COLUMN tags into phys_attrs but never read
information_schema.table_tags, so table-scoped coverage VREQs (subdomain, division) were
invisible -> products_data carried only {domain,product} (no subdomain) and domains_data
only {domain} (no division). The verifier subdomain/division branches therefore scored
0/N FALSE-NEGATIVES (gov_transport v383 reported 66.7% while physical subdomain was 77/85).

FIX: gt-table-tag-enrich queries information_schema.table_tags and grounds products_data +
domains_data with the REAL physical table tags before the verifier runs.

These tests run the ACTUAL enrich block extracted from the notebook against a mocked spark
(no Spark context required -> serverless-safe test) and prove the observable state change,
then prove the verifier verdict flips failed -> fulfilled.
"""
import json
import os
import re
import textwrap

import pytest

REPO = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")


def _code_src():
    nb = json.load(open(NB))
    return "\n".join(
        "".join(c.get("source", [])) for c in nb["cells"] if c["cell_type"] == "code"
    )


def _extract_enrich_block(src):
    start = src.find("# v3.8.4 [gt-table-tag-enrich] alias=gt-table-tag-enrich")
    assert start != -1, "gt-table-tag-enrich block missing from notebook"
    # end at the EXC warning line (inclusive)
    exc = src.find('alias=gt-table-tag-enrich")', src.find("EXC v3.8.4", start))
    assert exc != -1, "gt-table-tag-enrich EXC handler missing"
    end = src.find("\n", exc)
    block = src[start:end]
    # strip the 8-space method indentation so it execs at module level
    lines = block.splitlines()
    out = [lines[0]]  # first line already dedented (no leading spaces)
    for ln in lines[1:]:
        out.append(ln[8:] if ln.startswith("        ") else ln)
    return "\n".join(out)


def _extract_method(src, name):
    i = src.find("def " + name + "(")
    assert i != -1, name + " not found"
    # back up to the line start
    ls = src.rfind("\n", 0, i) + 1
    j = src.find("\n    def ", i + 1)
    body = src[ls:j]
    return textwrap.dedent(body)


class _FakeCol:
    def __init__(self, rows):
        self._rows = rows

    def collect(self):
        return self._rows


class _FakeSpark:
    """Returns table_tags rows only for the table_tags query; empty otherwise."""

    def __init__(self, rows):
        self._rows = rows

    def sql(self, q):
        if "information_schema.table_tags" in q:
            return _FakeCol(self._rows)
        return _FakeCol([])


class _Resolver:
    def resolve_catalog(self, dd):
        return "cat1"

    def resolve_schema(self, dd, p):
        return "hr_schema"


class _Logger:
    def __init__(self):
        self.msgs = []

    def info(self, m):
        self.msgs.append(m)

    def warning(self, m):
        self.msgs.append(m)


def _row(s, t, tn, tv):
    return {"s": s, "t": t, "tn": tn, "tv": tv}


def _run_enrich(products_data, domains_data, rows):
    block = _extract_enrich_block(_code_src())
    ns = {
        "spark": _FakeSpark(rows),
        "cat_schema": {("cat1", "hr_schema")},
        "resolver": _Resolver(),
        "domain_dict": {"hr": {"domain": "hr"}},
        "products": [{"domain": "hr", "product": "applicant", "table_name": "applicant"}],
        "apply_convention": (lambda name, conv: name),
        "_ddl_convention": "snake_case",
        "products_data": products_data,
        "domains_data": domains_data,
        "widgets_values": {"_gt_observed_tag_keys": []},
        "logger": _Logger(),
    }
    exec(compile(block, "<enrich>", "exec"), ns)
    return ns


def test_enrich_populates_subdomain_and_division():
    """pass-post: physical table tags flow into products_data/domains_data."""
    products_data = [{"domain": "hr", "product": "applicant"}]  # NO subdomain (pre-state)
    domains_data = [{"domain": "hr"}]  # NO division (pre-state)
    rows = [
        _row("hr_schema", "applicant", "gov_transport_subdomain", "Recruitment"),
        _row("hr_schema", "applicant", "gov_transport_division", "Corporate"),
    ]
    # pre-condition: subdomain/division absent
    assert not products_data[0].get("subdomain")
    assert not domains_data[0].get("division")

    ns = _run_enrich(products_data, domains_data, rows)

    # observable state change
    assert ns["products_data"][0]["subdomain"] == "Recruitment"
    assert ns["domains_data"][0]["division"] == "Corporate"
    assert "gov_transport_subdomain" in ns["widgets_values"]["_gt_observed_tag_keys"]
    assert any("gt-table-tag-enrich FIRED v3.8.4" in m for m in ns["logger"].msgs)


def test_enrich_noop_when_no_table_tags():
    """Empty table_tags -> products_data untouched (no crash, no fabricated tags)."""
    products_data = [{"domain": "hr", "product": "applicant"}]
    domains_data = [{"domain": "hr"}]
    ns = _run_enrich(products_data, domains_data, [])
    assert not ns["products_data"][0].get("subdomain")
    assert not ns["domains_data"][0].get("division")


def test_verdict_flips_failed_to_fulfilled():
    """
    The real observable: the verifier subdomain/division verdict is a FALSE-NEGATIVE before
    enrich and CORRECT after. Uses the actual _verify_bulk_coverage from the notebook.
    """
    src = _code_src()
    method_src = _extract_method(src, "_verify_bulk_coverage")
    ns = {"re": re}
    exec(compile(method_src, "<vbc>", "exec"), ns)
    vbc = ns["_verify_bulk_coverage"]

    class _Self:
        logger = _Logger()

    class _Req:
        def __init__(self, text, rid):
            self.original_text = text
            self.id = rid

    sub_req = _Req("Every table must be tagged with its subdomain", "VREQ-SUB")
    div_req = _Req("Each domain must be tagged with a division", "VREQ-DIV")

    # PRE-ENRICH (the v383 false-negative state): no subdomain / no division
    pd_pre = [{"domain": "hr", "product": "applicant"}]
    dd_pre = [{"domain": "hr"}]
    v_sub_pre = vbc(_Self(), sub_req, dd_pre, pd_pre, [])
    v_div_pre = vbc(_Self(), div_req, dd_pre, pd_pre, [])
    assert v_sub_pre is not None and v_sub_pre["status"] != "fulfilled", v_sub_pre
    assert v_div_pre is not None and v_div_pre["status"] != "fulfilled", v_div_pre

    # POST-ENRICH: run the actual enrich block to populate, then re-verify
    rows = [
        _row("hr_schema", "applicant", "gov_transport_subdomain", "Recruitment"),
        _row("hr_schema", "applicant", "gov_transport_division", "Corporate"),
    ]
    en = _run_enrich([{"domain": "hr", "product": "applicant"}], [{"domain": "hr"}], rows)
    pd_post, dd_post = en["products_data"], en["domains_data"]
    v_sub_post = vbc(_Self(), sub_req, dd_post, pd_post, [])
    v_div_post = vbc(_Self(), div_req, dd_post, pd_post, [])
    assert v_sub_post is not None and v_sub_post["status"] == "fulfilled", v_sub_post
    assert v_div_post is not None and v_div_post["status"] == "fulfilled", v_div_post


def test_gt_tag_verify_harvests_table_scope_keys():
    """EDIT B: gt-tag-verify pool now harvests products_data/domains_data tag keys."""
    src = _code_src()
    assert src.count("gt-tag-verify-table-scope") == 1
    # the harvest loops must reference products_data and domains_data tags
    i = src.find("gt-tag-verify-table-scope")
    seg = src[i:i + 700]
    assert "_pd2 in (products_data or [])" in seg
    assert "_dd3 in (domains_data or [])" in seg
