"""Tests for _resolve_managed_location — v0.8.0 G2 DRY helper."""
import pytest


def _load():
    from agent_helpers import _resolve_managed_location  # noqa
    return _resolve_managed_location


class _FakeRow(list):
    """Mimics pyspark Row — list + attr access."""
    def __getitem__(self, i): return list.__getitem__(self, i)


class _FakeSpark:
    def __init__(self, handlers):
        self.handlers = handlers
    class _DF:
        def __init__(self, rows): self._rows = rows
        def collect(self): return self._rows
    def sql(self, q):
        for key, rows in self.handlers.items():
            if key in q.upper():
                return self._DF(rows)
        raise Exception(f"unknown query: {q}")


class TestResolveManagedLocation:
    def test_returns_metastore_storage_root_when_available(self):
        fn = _load()
        spark = _FakeSpark({
            "DESCRIBE METASTORE": [_FakeRow(["storage_root", "abfss://x@y.dfs.core.windows.net/root/"])],
        })
        assert fn(spark) == "abfss://x@y.dfs.core.windows.net/root/"

    def test_falls_back_to_existing_catalog(self):
        fn = _load()
        spark = _FakeSpark({
            "DESCRIBE METASTORE": Exception,  # raises
            "SHOW CATALOGS": [_FakeRow(["mycat"])],
            "DESCRIBE CATALOG EXTENDED": [_FakeRow(["storage_root", "gs://bucket/uc/__unitystorage/foo"])],
        })
        # Monkey: replace Exception with raise behavior
        orig_sql = spark.sql
        def _sql(q):
            if "DESCRIBE METASTORE" in q.upper(): raise Exception("no perm")
            return orig_sql(q)
        spark.sql = _sql
        result = fn(spark)
        assert result == "gs://bucket/uc"

    def test_returns_empty_when_nothing_found(self):
        fn = _load()
        class _Empty:
            def sql(self, q): raise Exception("nothing")
        assert fn(_Empty()) == ""
