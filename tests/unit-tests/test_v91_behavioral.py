"""Behavioral tests for v0.9.1 — critical connect_table column-add fix.

Root cause of v0.9.0 RT run audit showing 12.9% adherence (35/62 connect_table
VREQs missing from persisted model.json): the connect_table action handler was
only re-LINKING existing unbound columns, never APPENDING new attribute rows
when target_state.add_columns was provided. The deterministic verifier still
returned [OK] because the table had other (unrelated) FKs.

This fix appends a new attribute row to attributes_data for every entry in
target_state.add_columns that does not already exist on the target product,
with foreign_key_to set from add_columns[i].fk_to. The alias
`connect-table-add-columns-fix` fires in the live log per added column.
"""

import json
import pathlib
import re


REPO = pathlib.Path(__file__).resolve().parents[2]
NB = REPO / "agent" / "dbx_vibe_modelling_agent.ipynb"
NB_TEXT = NB.read_text()


def test_v091_agent_version_constant():
    m = re.search(r'__AGENT_VERSION__\s*=\s*\\?"([0-9.]+)\\?"', NB_TEXT)
    assert m, "no __AGENT_VERSION__ constant"
    parts = [int(s) for s in m.group(1).split('.')]
    assert tuple(parts) >= (0, 9, 1), f"version must be >= 0.9.1, got {m.group(1)}"


def test_v091_connect_table_add_columns_alias_present():
    assert NB_TEXT.count("connect-table-add-columns-fix") >= 4, (
        "connect-table-add-columns-fix alias must appear in both comments and FIRED log lines (>=4 occurrences)"
    )


def test_v091_connect_table_handler_parses_add_columns():
    assert "_ct_target_obj = json.loads(target_state)" in NB_TEXT, (
        "connect_table handler must parse target_state JSON to find add_columns"
    )
    assert "_ct_target_obj.get('add_columns')" in NB_TEXT, (
        "connect_table handler must extract add_columns from target_state"
    )


def test_v091_connect_table_handler_appends_new_attribute():
    assert "attributes_data.append(_ct_new_attr)" in NB_TEXT, (
        "connect_table handler must append new attribute rows when add_columns specifies new columns"
    )


def test_v091_connect_table_handler_sets_foreign_key_to():
    assert "'foreign_key_to': _ct_fk_to" in NB_TEXT, (
        "connect_table handler must set foreign_key_to on the new attribute"
    )


def test_v091_connect_table_handler_skips_existing_columns():
    assert "_ct_already_exists = True" in NB_TEXT, (
        "connect_table handler must detect when the proposed column already exists"
    )


def test_v091_connect_table_handler_logs_added_count():
    assert "added_new=" in NB_TEXT, (
        "connect_table handler must log added_new count for audit trail"
    )


def test_v091_connect_table_handler_extracts_data_type_fallback():
    assert "or 'BIGINT'" in NB_TEXT, (
        "connect_table handler must default data_type to BIGINT when not specified"
    )


def test_v091_does_not_remove_existing_link_logic():
    """Sanity: the existing re-linking branches MUST still be present.
    
    The fix is ADDITIVE — it adds new-column support on top of the existing
    re-link existing column / inbound-link logic.
    """
    assert "for attr in attributes_data:" in NB_TEXT
    assert "Connected '" in NB_TEXT
    assert "queued_quality_checks['fix_siloed']" in NB_TEXT


if __name__ == "__main__":
    import sys
    fns = [v for k, v in globals().items() if k.startswith("test_") and callable(v)]
    failures = 0
    for f in fns:
        try:
            f()
            print(f"[ok] {f.__name__}")
        except AssertionError as e:
            print(f"[FAIL] {f.__name__}: {e}")
            failures += 1
    sys.exit(1 if failures else 0)
