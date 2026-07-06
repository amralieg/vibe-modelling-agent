import json
import os
import re

import pytest

NB_HEAD = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")
NB_PRE = "/tmp/agent_pre_v418.ipynb"

# The exact source branch the v4.1.7->4.1.8 fix introduces in step_apply_metric_views.
DROP_BRANCH = "if _mvcp_existence_known and (_src_sch.lower(), _src_tbl.lower()) not in _mvcp_table_exists:"
BATCH_FETCH = "_allcol_rows = spark.sql(f\"SELECT LOWER(table_schema) AS s, LOWER(table_name) AS t, LOWER(column_name) AS c FROM `{_cat}`.information_schema.columns\").collect()"


def _nb_source(path):
    nb = json.load(open(path))
    return "\n".join(
        "".join(c.get("source", [])) for c in nb.get("cells", []) if c.get("cell_type") == "code"
    )


def _decide(src_sch, src_tbl, table_exists, existence_known):
    """Faithful reproduction of the v4.1.8 prevalidation drop decision: an MV whose source table is
    physically ABSENT (and whose absence is KNOWN because the batch fetch succeeded) is DROPPED; in
    every other case the MV is retained for the column-pruning pass. Mirrors the notebook branch
    asserted present by test_branch_present_post."""
    dropped, kept = [], []
    if existence_known and (src_sch.lower(), src_tbl.lower()) not in table_exists:
        dropped.append((src_sch, src_tbl))
    else:
        kept.append((src_sch, src_tbl))
    return dropped, kept


# ---- behavioral: observable drop/keep decision (the state change the patch must produce) ----

def test_absent_table_known_is_dropped():
    """POST behavior: media_broadcasting's 8 R6 case — table physically absent, existence known => DROP."""
    dropped, kept = _decide("audience", "viewership_record", table_exists=set(), existence_known=True)
    assert dropped == [("audience", "viewership_record")]
    assert kept == []


def test_present_table_is_kept():
    """A real table is never dropped by the existence gate (no false drops)."""
    dropped, kept = _decide(
        "billing", "invoice", table_exists={("billing", "invoice")}, existence_known=True
    )
    assert dropped == []
    assert kept == [("billing", "invoice")]


def test_absent_table_unknown_is_kept():
    """Safety fallback: if the catalog-wide batch fetch FAILED (_mvcp_existence_known=False), we must
    NOT drop anything (no existence signal) — keep-on-empty preserves the pre-fix conservative path."""
    dropped, kept = _decide("audience", "viewership_record", table_exists=set(), existence_known=False)
    assert dropped == []
    assert kept == [("audience", "viewership_record")]


def test_case_insensitive_existence_match():
    """Existence check lower-cases both sides so a mixed-case MV ref still matches a real table."""
    dropped, kept = _decide(
        "Billing", "Invoice", table_exists={("billing", "invoice")}, existence_known=True
    )
    assert dropped == []


# ---- structural fail-pre / pass-post (ties the behavior to the real notebook code) ----

def test_branch_present_post():
    src = _nb_source(NB_HEAD)
    assert DROP_BRANCH in src, "v4.1.8 drop-on-absent branch missing from notebook"
    assert BATCH_FETCH in src, "v4.1.8 catalog-wide batch column fetch missing from notebook"
    assert "_dropped2.append(_stmt)" in src, "drop path must append the stmt to _dropped2"
    assert "[mv-prevalidate-drop-absent-table FIRED v4.1.7]" in src, "FIRED summary log missing"
    assert "[mv-prevalidate-batch-colfetch FIRED v4.1.7]" in src, "batch-colfetch FIRED log missing"


def test_branch_absent_pre():
    if not os.path.exists(NB_PRE):
        pytest.skip("pre-patch baseline /tmp/agent_pre_v418.ipynb not present")
    src = _nb_source(NB_PRE)
    assert DROP_BRANCH not in src, "pre-patch baseline must NOT contain the drop-on-absent branch"
    assert BATCH_FETCH not in src, "pre-patch baseline must NOT contain the batch column fetch"


def test_per_table_serial_query_removed_post():
    """The old per-table information_schema query (the ~50min silent N-round-trip pass) is gone."""
    src = _nb_source(NB_HEAD)
    old = "SELECT LOWER(column_name) AS c FROM `{_cat}`.information_schema.columns WHERE LOWER(table_schema)"
    assert old not in src, "old per-table serial information_schema query must be replaced by the batch fetch"


def test_version_bumped_post():
    src = _nb_source(NB_HEAD)
    assert '__AGENT_VERSION__ = "4.2.7"' in src
