"""v0.7.2 (alias=storage-root-validation) — unit tests for the runner's
_validate_storage_accessible / _resolve_managed_location / _create_catalog_with_managed_location
fix that unblocks Azure default-storage workspaces sharing a metastore.

ROOT CAUSE under test:
On Azure, the fe-vm-feip workspace shares its metastore with multiple other
workspaces. SHOW CATALOGS leaks catalog rows whose storage_root resolves to
External Locations the current workspace cannot access (e.g. delta_dore_azure
on dbstorage3lkupgasvxipk). The pre-fix runner happily handed those URLs back
as MANAGED LOCATION; CREATE CATALOG then crashed with PERMISSION_DENIED:
'External Location ... is not accessible in current workspace', which the
pre-fix runner converted into 'PRE-LAUNCH VALIDATION FAILED' and surfaced as
RuntimeError on every Azure run (19 INTERNAL_ERROR runs in 50 minutes before
this fix).

This test extracts the three helpers from the runner notebook's source and
exercises them with FakeSpark + FakeDBUtils stubs covering:
  - METASTORE storage_root inaccessible → fall through to SHOW CATALOGS
  - SHOW CATALOGS first candidate inaccessible (Azure leak) → keep walking
  - SHOW CATALOGS second candidate accessible → return it
  - CREATE CATALOG with MANAGED LOCATION fails PERMISSION_DENIED →
    bare-CREATE fallback fires
"""
import ast
import json
import sys
import types
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
RUNNER_NB = REPO_ROOT / "runner" / "vibe_runner.ipynb"


def _runner_helpers():
    nb = json.loads(RUNNER_NB.read_text(encoding="utf-8"))
    src_chunks = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        src_chunks.append(src)
    full_src = "\n".join(src_chunks)

    tree = ast.parse(full_src)
    wanted = {
        "_validate_storage_accessible",
        "_resolve_managed_location",
        "_create_catalog_with_managed_location",
        "log",
    }
    kept_nodes = [n for n in tree.body
                  if isinstance(n, ast.FunctionDef) and n.name in wanted]

    mod = types.ModuleType("runner_helpers_under_test")
    mod.__dict__["dbutils"] = None
    mod.__dict__["spark"] = None
    mod.__dict__["log"] = lambda *a, **k: None
    for n in kept_nodes:
        if n.name == "log":
            continue
        snippet = ast.Module(body=[n], type_ignores=[])
        exec(compile(snippet, str(RUNNER_NB), "exec"), mod.__dict__)
    return mod


@pytest.fixture(scope="module")
def helpers():
    return _runner_helpers()


class _Row(list):
    def __init__(self, *args):
        list.__init__(self, args)


class _DF:
    def __init__(self, rows):
        self._rows = rows

    def collect(self):
        return self._rows


class _FakeSpark:
    def __init__(self, rules):
        self.rules = rules

    def sql(self, q):
        for pat, handler in self.rules.items():
            if pat in q.upper():
                out = handler(q) if callable(handler) else handler
                if isinstance(out, Exception):
                    raise out
                if isinstance(out, list):
                    return _DF(out)
                return out
        raise RuntimeError(f"no rule for: {q}")


class _FakeDbu:
    def __init__(self, ls_rules):
        self._ls_rules = ls_rules

        class _FS:
            def __init__(self, parent):
                self._p = parent

            def ls(self, path):
                if path in self._p._ls_rules:
                    out = self._p._ls_rules[path]
                    if isinstance(out, Exception):
                        raise out
                    return out
                return []

        self.fs = _FS(self)


class TestValidateStorageAccessible:
    def test_empty_returns_false(self, helpers):
        helpers.dbutils = _FakeDbu({})
        assert helpers._validate_storage_accessible("") is False

    def test_accessible_returns_true(self, helpers):
        helpers.dbutils = _FakeDbu({"abfss://ok@x/y": []})
        assert helpers._validate_storage_accessible("abfss://ok@x/y") is True

    def test_permission_denied_returns_false(self, helpers):
        helpers.dbutils = _FakeDbu({
            "abfss://leaked@x/y": Exception(
                "PERMISSION_DENIED: External Location 'delta_dore_azure' is not accessible in current workspace"
            )
        })
        assert helpers._validate_storage_accessible("abfss://leaked@x/y") is False

    def test_unauthorized_access_returns_false(self, helpers):
        helpers.dbutils = _FakeDbu({
            "abfss://leaked2@x/y": Exception("UnauthorizedAccessException: nope")
        })
        assert helpers._validate_storage_accessible("abfss://leaked2@x/y") is False

    def test_403_returns_false(self, helpers):
        helpers.dbutils = _FakeDbu({
            "abfss://leaked3@x/y": Exception("HTTP 403 forbidden")
        })
        assert helpers._validate_storage_accessible("abfss://leaked3@x/y") is False

    def test_unknown_error_fails_open(self, helpers):
        helpers.dbutils = _FakeDbu({
            "abfss://transient@x/y": Exception("network blip")
        })
        assert helpers._validate_storage_accessible("abfss://transient@x/y") is True


class TestResolveManagedLocationWithValidation:
    def test_returns_metastore_root_when_accessible(self, helpers):
        helpers.dbutils = _FakeDbu({"abfss://meta@x/y": []})
        spark = _FakeSpark({
            "DESCRIBE METASTORE": [_Row("storage_root", "abfss://meta@x/y")],
        })
        assert helpers._resolve_managed_location(spark) == "abfss://meta@x/y"

    def test_skips_inaccessible_metastore_root(self, helpers):
        helpers.dbutils = _FakeDbu({
            "abfss://blocked@x/y": Exception("PERMISSION_DENIED: not accessible"),
            "abfss://owned@x/y": [],
        })
        spark = _FakeSpark({
            "DESCRIBE METASTORE": [_Row("storage_root", "abfss://blocked@x/y")],
            "SHOW CATALOGS": [_Row("airlines_install_v95")],
            "DESCRIBE CATALOG EXTENDED": [_Row("storage_root", "abfss://owned@x/y/__unitystorage/abc")],
        })
        assert helpers._resolve_managed_location(spark) == "abfss://owned@x/y"

    def test_skips_first_inaccessible_catalog_walks_to_next(self, helpers):
        """The Azure failure mode: SHOW CATALOGS returns a leaked catalog from
        another workspace first; helper must skip it and try the next one."""
        helpers.dbutils = _FakeDbu({
            "abfss://leaked@otherws/y": Exception("PERMISSION_DENIED: External Location not accessible in current workspace"),
            "abfss://mine@thisws/y": [],
        })

        def desc_handler(q):
            if "LEAKED_CATALOG" in q.upper():
                return [_Row("storage_root", "abfss://leaked@otherws/y/__unitystorage/foo")]
            if "MY_CATALOG" in q.upper():
                return [_Row("storage_root", "abfss://mine@thisws/y/__unitystorage/bar")]
            return []

        spark = _FakeSpark({
            "DESCRIBE METASTORE": Exception("metastore storage root empty"),
            "SHOW CATALOGS": [_Row("leaked_catalog"), _Row("my_catalog")],
            "DESCRIBE CATALOG EXTENDED": desc_handler,
        })
        assert helpers._resolve_managed_location(spark) == "abfss://mine@thisws/y"

    def test_returns_empty_when_all_blocked(self, helpers):
        helpers.dbutils = _FakeDbu({
            "abfss://x@y/z": Exception("PERMISSION_DENIED: nope"),
        })
        spark = _FakeSpark({
            "DESCRIBE METASTORE": Exception("no admin"),
            "SHOW CATALOGS": [_Row("only_blocked_one")],
            "DESCRIBE CATALOG EXTENDED": [_Row("storage_root", "abfss://x@y/z/__unitystorage/foo")],
        })
        assert helpers._resolve_managed_location(spark) == ""


class TestCreateCatalogFallback:
    def test_managed_location_succeeds_no_fallback(self, helpers):
        helpers.dbutils = _FakeDbu({"abfss://ok@x/y": []})
        calls = []

        class _S:
            def sql(self, q):
                calls.append(q)
                if "DESCRIBE METASTORE" in q.upper():
                    return _DF([_Row("storage_root", "abfss://ok@x/y")])
                if "SHOW CATALOGS" in q.upper():
                    return _DF([])
                if "CREATE CATALOG" in q.upper():
                    return _DF([])
                raise RuntimeError(f"unexpected: {q}")

        helpers._create_catalog_with_managed_location(_S(), "test_cat")
        # Exactly one CREATE CATALOG with MANAGED LOCATION
        creates = [c for c in calls if "CREATE CATALOG" in c.upper()]
        assert len(creates) == 1
        assert "MANAGED LOCATION 'abfss://ok@x/y'" in creates[0]

    def test_managed_location_perm_denied_falls_back_to_bare(self, helpers):
        """The Azure failure mode where validate said OK but CREATE still failed."""
        helpers.dbutils = _FakeDbu({"abfss://passed-validate@x/y": []})
        calls = []

        class _S:
            def sql(self, q):
                calls.append(q)
                qu = q.upper()
                if "DESCRIBE METASTORE" in qu:
                    return _DF([_Row("storage_root", "abfss://passed-validate@x/y")])
                if "SHOW CATALOGS" in qu:
                    return _DF([])
                if "CREATE CATALOG" in qu and "MANAGED LOCATION" in qu:
                    raise Exception(
                        "PERMISSION_DENIED: External Location 'delta_dore_azure' is not accessible in current workspace"
                    )
                if "CREATE CATALOG" in qu:
                    return _DF([])
                raise RuntimeError(f"unexpected: {q}")

        helpers._create_catalog_with_managed_location(_S(), "fallback_cat")
        creates = [c for c in calls if "CREATE CATALOG" in c.upper()]
        assert len(creates) == 2
        assert "MANAGED LOCATION" in creates[0]
        assert "MANAGED LOCATION" not in creates[1]
        assert "fallback_cat" in creates[1]

    def test_unrelated_create_error_propagates(self, helpers):
        helpers.dbutils = _FakeDbu({"abfss://passed@x/y": []})

        class _S:
            def sql(self, q):
                qu = q.upper()
                if "DESCRIBE METASTORE" in qu:
                    return _DF([_Row("storage_root", "abfss://passed@x/y")])
                if "SHOW CATALOGS" in qu:
                    return _DF([])
                if "CREATE CATALOG" in qu and "MANAGED LOCATION" in qu:
                    raise Exception("INVALID_PARAMETER_VALUE: bad name")
                raise RuntimeError(f"unexpected: {q}")

        with pytest.raises(Exception, match="INVALID_PARAMETER_VALUE"):
            helpers._create_catalog_with_managed_location(_S(), "bad")
