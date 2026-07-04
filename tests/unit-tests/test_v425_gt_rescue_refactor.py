"""
v4.2.5 behavioral tests -- gt-rescue-refactor (RC3).

ROOT CAUSE (retail v2 ECM VOV, run 257229033091163): holistic-refactor VReqs
    "ensure a household table exists in the customer domain" / "re-home service_case
    out of the customer domain" scored PARTIAL with the generic "Model changed but
    cannot confirm intent" evidence and were NOT credited, keeping physical adherence
    at 78.9% below the 90% floor -- even though the household table WAS created and
    service_case WAS re-homed in the shipped model.

FIX: the deterministic _gt_rescue gains two FULFILLED-ONLY, PHYSICALLY-GROUNDED
    rescues (alias gt-rescue-refactor): table-exists (credited iff the target table
    physically exists) and re-home (credited iff the table physically moved off the
    named source domain). Upgrade-only -> can rescue a false-negative, can NEVER
    inflate beyond genuine satisfaction (S8.3).

Tests extract the SHIPPED regexes (not copies) and prove correct table/domain parse,
plus assert the physically-grounded FULFILLED-only contract in the shipped source.
"""
import json
import os
import re

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _rescue_src():
    cells = json.load(open(NB))["cells"]
    for c in cells:
        if c["cell_type"] == "code" and "gt-rescue-refactor" in "".join(c["source"]):
            return "".join(c["source"])
    raise AssertionError("cell containing gt-rescue-refactor not found")


def _pattern(var):
    src = _rescue_src()
    m = re.search(var + r' = _gtre_re\.search\(r"(.*?)", _t\)', src)
    assert m, "could not extract %s pattern literal" % var
    return re.compile(m.group(1), re.I)


class TestTableExistsParse:
    @pytest.mark.parametrize("text,expect", [
        ("ensure a household table exists in the customer domain", "household"),
        ("add a consent table exists check", "consent"),
        ("introduce a privacy table is present", "privacy"),
    ])
    def test_table_name_extracted(self, text, expect):
        m = _pattern("_te_rc").search(text.lower())
        assert m, text
        assert m.group(1).strip().replace(" ", "_") == expect


class TestReHomeParse:
    @pytest.mark.parametrize("text,tbl,src", [
        ("re-home service_case out of the customer domain", "service_case", "customer"),
        ("move consent out of customer", "consent", "customer"),
        ("re-home the audit_log off of the finance domain", "audit_log", "finance"),
    ])
    def test_rehome_table_and_source_extracted(self, text, tbl, src):
        m = _pattern("_rh_rc").search(text.lower())
        assert m, text
        assert m.group(1).strip() == tbl
        assert m.group(2).strip() == src


class TestFulfilledOnlyPhysicallyGroundedContract:
    """The rescue must only return fulfilled, and only against the physical after-state."""

    def test_source_contract(self):
        src = _rescue_src()
        block = src.split("alias=gt-rescue-refactor", 1)[1]
        block = block[:4000]
        # table-exists: credited only when _prod_present_rc(...) resolves a physical product
        assert "gt-rescue/table-exists FIRED v4.2.5" in block
        assert "if _hit_te_rc:" in block
        # re-home: credited only when the table physically moved OFF the named source domain
        assert "gt-rescue/re-home FIRED v4.2.5" in block
        assert "_rsrc_rc not in _cur_doms_rc" in block
        # both branches return fulfilled ONLY (never partial/failed) -> upgrade-only
        assert block.count('"status": "fulfilled"') >= 2
        assert '"status": "partial"' not in block.split("gt-rescue/re-home", 1)[0]

    def test_prod_present_is_prefix_tolerant(self):
        src = _rescue_src()
        assert "def _prod_present_rc(" in src
        # tolerant match: exact, suffix _name, or name endswith _pk
        blk = src.split("def _prod_present_rc(", 1)[1][:800]
        assert 'endswith("_" + _n)' in blk
