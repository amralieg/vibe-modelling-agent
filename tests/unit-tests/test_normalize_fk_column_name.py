"""Tests for normalize_fk_column_name — FK column renaming helper."""
import pytest


def _load():
    from agent_helpers import normalize_fk_column_name
    return normalize_fk_column_name


class TestNormalizeFkColumnName:
    def test_callable_and_does_not_crash_on_empty(self):
        fn = _load()
        attr = {"attribute": "customer_id", "type": "BIGINT"}
        pk_map = {"customer.customer": "customer_id"}
        # Should not raise
        try:
            fn(attr, pk_map, [])
        except Exception as e:
            pytest.fail(f"unexpected exception: {e}")
