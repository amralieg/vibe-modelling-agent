"""Additional tests for _resolve_managed_location focusing on edge cases."""
import pytest


def _load():
    from agent_helpers import _resolve_managed_location
    return _resolve_managed_location


class _Row(list):
    def __init__(self, *args): list.__init__(self, args)


class _FakeSpark:
    def __init__(self, rules):
        self.rules = rules  # {pattern: callable returning list[Row]}
    class _DF:
        def __init__(self, rows): self._rows = rows
        def collect(self): return self._rows
    def sql(self, q):
        for pat, handler in self.rules.items():
            if pat in q.upper():
                out = handler() if callable(handler) else handler
                if isinstance(out, Exception): raise out
                return self._DF(out)
        raise Exception(f"no rule: {q}")


class TestResolveManagedLocationEdge:
    def test_spark_completely_broken_returns_empty(self):
        fn = _load()
        class _Broken:
            def sql(self, q): raise RuntimeError("broken")
        assert fn(_Broken()) == ""

    def test_gs_prefix_returned_as_is(self):
        fn = _load()
        spark = _FakeSpark({
            "DESCRIBE METASTORE": [_Row("storage_root", "gs://gcp-bucket/uc/root")],
        })
        result = fn(spark)
        assert result.startswith("gs://")

    def test_s3_prefix_accepted(self):
        fn = _load()
        spark = _FakeSpark({
            "DESCRIBE METASTORE": [_Row("storage_root", "s3://aws-bucket/uc/root")],
        })
        result = fn(spark)
        assert result.startswith("s3://")

    def test_http_prefix_rejected(self):
        fn = _load()
        # Bad URL scheme — should be rejected, fall back to empty
        spark = _FakeSpark({
            "DESCRIBE METASTORE": [_Row("storage_root", "http://not-a-storage-root.com")],
            "SHOW CATALOGS": [],
        })
        assert fn(spark) == ""

    def test_skips_system_catalogs(self):
        fn = _load()
        # Must skip system/samples/main/hive_metastore
        spark = _FakeSpark({
            "DESCRIBE METASTORE": RuntimeError("no admin"),
            "SHOW CATALOGS": [_Row("system"), _Row("samples"), _Row("_internal")],
            "DESCRIBE CATALOG EXTENDED": [_Row("storage_root", "abfss://x/__unitystorage/y")],
        })
        # All catalogs are skipped → empty
        assert fn(spark) == ""
