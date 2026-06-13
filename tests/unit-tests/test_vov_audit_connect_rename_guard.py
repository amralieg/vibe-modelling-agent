import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "runner"))
import vov_groundtruth_audit as A


def test_columnless_connect_table_linked_is_fulfilled():
    # column-less connect_table on a table that HAS an outbound FK -> table-level
    # "link this table" intent is satisfied (pre-patch this was scored 'partial').
    status, reason = A.verify(
        {"action": "connect_table", "product": "pfas_monitoring"},
        {"pfas_monitoring": "compliance"},
        {"pfas_monitoring": {"facility_id": "ops.facility.facility_id"}}, set())
    assert status == "fulfilled", (status, reason)


def test_columnless_connect_table_isolated_is_missed():
    status, reason = A.verify(
        {"action": "connect_table", "product": "orphan"},
        {"orphan": "compliance"},
        {"orphan": {"name": ""}}, set())
    assert status == "missed", (status, reason)


def test_named_column_connect_table_absent_still_partial():
    # specific requested column missing but table linked differently -> real gap (partial).
    status, reason = A.verify(
        {"action": "connect_table", "product": "dmr", "column": "jurisdiction_id"},
        {"dmr": "compliance"},
        {"dmr": {"facility_id": "ops.facility.facility_id"}}, set())
    assert status == "partial", (status, reason)


def test_rename_product_empty_target_is_unverifiable():
    # extractor produced no new name -> cannot verify (pre-patch this was 'partial').
    status, reason = A.verify(
        {"action": "rename_product", "product": "regulatory_jurisdiction", "new_name": ""},
        {"regulatory_jurisdiction": "compliance"},
        {"regulatory_jurisdiction": {}}, set())
    assert status == "unverifiable", (status, reason)


def test_rename_product_applied_is_fulfilled():
    status, reason = A.verify(
        {"action": "rename_product", "product": "old_name", "new_name": "new_name"},
        {"new_name": "compliance"}, {"new_name": {}}, set())
    assert status == "fulfilled", (status, reason)
