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


@pytest.fixture(autouse=True)
def _reset_ml_cache(helpers):
    """v0.7.3 — _create_catalog_with_managed_location memoises the MANAGED LOCATION
    via a function attribute. Reset between tests so cached state from one test
    doesn't bleed into the next."""
    fn = helpers._create_catalog_with_managed_location
    if hasattr(fn, "_ml_cache"):
        delattr(fn, "_ml_cache")
    yield
    if hasattr(fn, "_ml_cache"):
        delattr(fn, "_ml_cache")


class TestCreateCatalogFallback:
    def test_v73_bare_create_succeeds_no_resolve_called(self, helpers):
        """v0.7.3 (alias=storage-root-v73-bare-first) — on default-storage workspaces
        (AWS, GCP, modern Azure) bare CREATE works on first try. Helper MUST NOT call
        _resolve_managed_location (which would scan thousands of catalogs on shared AWS).
        """
        helpers.dbutils = _FakeDbu({})
        calls = []

        class _S:
            def sql(self, q):
                calls.append(q)
                qu = q.upper()
                if "CREATE CATALOG" in qu and "MANAGED LOCATION" not in qu:
                    return _DF([])
                raise RuntimeError(f"unexpected (v73 should not have called this): {q}")

        helpers._create_catalog_with_managed_location(_S(), "aws_default_storage_cat")
        creates = [c for c in calls if "CREATE CATALOG" in c.upper()]
        assert len(creates) == 1, f"v73 should issue exactly 1 bare CREATE, got: {creates}"
        assert "MANAGED LOCATION" not in creates[0]
        scans = [c for c in calls if "SHOW CATALOGS" in c.upper() or "DESCRIBE METASTORE" in c.upper()]
        assert scans == [], f"v73 should NOT scan when bare CREATE works, got: {scans}"

    def test_v73_bare_create_unrelated_error_propagates_without_resolve(self, helpers):
        """v0.7.3 — if bare CREATE fails for a NON-managed-location reason
        (e.g. INVALID_PARAMETER_VALUE on bad name), re-raise immediately without
        wasting cycles on the catalog scan."""
        helpers.dbutils = _FakeDbu({})
        calls = []

        class _S:
            def sql(self, q):
                calls.append(q)
                qu = q.upper()
                if "CREATE CATALOG" in qu and "MANAGED LOCATION" not in qu:
                    raise Exception("INVALID_PARAMETER_VALUE: bad name 'foo bar'")
                raise RuntimeError(f"unexpected: {q}")

        with pytest.raises(Exception, match="INVALID_PARAMETER_VALUE"):
            helpers._create_catalog_with_managed_location(_S(), "foo bar")
        scans = [c for c in calls if "SHOW CATALOGS" in c.upper() or "DESCRIBE METASTORE" in c.upper()]
        assert scans == [], f"v73 must not scan on non-ML errors, got: {scans}"

    def test_v73_bare_create_needs_ml_then_resolve_and_succeed(self, helpers):
        """v0.7.3 — when bare CREATE explicitly says workspace requires MANAGED LOCATION,
        helper MUST resolve and retry with that location."""
        helpers.dbutils = _FakeDbu({"abfss://meta@x/y": []})
        calls = []

        class _S:
            def sql(self, q):
                calls.append(q)
                qu = q.upper()
                if "CREATE CATALOG" in qu and "MANAGED LOCATION" not in qu:
                    raise Exception(
                        "Metastore storage root URL does not exist. Please provide a storage location for the catalog"
                    )
                if "DESCRIBE METASTORE" in qu:
                    return _DF([_Row("storage_root", "abfss://meta@x/y")])
                if "CREATE CATALOG" in qu and "MANAGED LOCATION" in qu:
                    return _DF([])
                if "SHOW CATALOGS" in qu:
                    return _DF([])
                raise RuntimeError(f"unexpected: {q}")

        helpers._create_catalog_with_managed_location(_S(), "azure_no_default")
        creates = [c for c in calls if "CREATE CATALOG" in c.upper()]
        assert len(creates) == 2, f"expected 2 CREATEs (bare + ML), got {len(creates)}"
        assert "MANAGED LOCATION" not in creates[0]
        assert "MANAGED LOCATION 'abfss://meta@x/y'" in creates[1]

    def test_v73_ml_cache_reused_across_multiple_calls(self, helpers):
        """v0.7.3 — when bare CREATE needs ML, _resolve_managed_location is called once
        and the result cached on the function attribute. Subsequent calls reuse cached
        value; SHOULD NOT re-scan SHOW CATALOGS for each catalog. Critical to avoid
        the O(N_industries × N_catalogs) AWS slowdown."""
        helpers.dbutils = _FakeDbu({"abfss://meta@x/y": []})
        scan_count = {"describe_meta": 0, "show_catalogs": 0}

        class _S:
            def sql(self, q):
                qu = q.upper()
                if "CREATE CATALOG" in qu and "MANAGED LOCATION" not in qu:
                    raise Exception("managed location required by metastore policy")
                if "DESCRIBE METASTORE" in qu:
                    scan_count["describe_meta"] += 1
                    return _DF([_Row("storage_root", "abfss://meta@x/y")])
                if "SHOW CATALOGS" in qu:
                    scan_count["show_catalogs"] += 1
                    return _DF([])
                if "CREATE CATALOG" in qu and "MANAGED LOCATION" in qu:
                    return _DF([])
                raise RuntimeError(f"unexpected: {q}")

        s = _S()
        for cat in ["industry_a_ecm", "industry_a_ecm_v1", "industry_a_mvm_v1",
                    "industry_b_ecm", "industry_b_ecm_v1", "industry_b_mvm_v1"]:
            helpers._create_catalog_with_managed_location(s, cat)
        assert scan_count["describe_meta"] == 1, (
            f"_resolve should be called once across all catalogs, got describe_meta="
            f"{scan_count['describe_meta']}"
        )

    def test_v73_managed_location_perm_denied_falls_back_to_bare_final(self, helpers):
        """v0.7.3 — if ML attempt fails with PERMISSION_DENIED (e.g. metastore-leaked
        External Location not granted to this workspace), final bare-CREATE fallback fires."""
        helpers.dbutils = _FakeDbu({"abfss://passed-validate@x/y": []})
        calls = []

        class _S:
            def __init__(self):
                self.bare_attempts = 0

            def sql(self, q):
                calls.append(q)
                qu = q.upper()
                if "CREATE CATALOG" in qu and "MANAGED LOCATION" not in qu:
                    self.bare_attempts += 1
                    if self.bare_attempts == 1:
                        raise Exception(
                            "Metastore storage root URL does not exist. Please provide a storage location for the catalog"
                        )
                    return _DF([])
                if "DESCRIBE METASTORE" in qu:
                    return _DF([_Row("storage_root", "abfss://passed-validate@x/y")])
                if "SHOW CATALOGS" in qu:
                    return _DF([])
                if "CREATE CATALOG" in qu and "MANAGED LOCATION" in qu:
                    raise Exception(
                        "PERMISSION_DENIED: External Location 'delta_dore_azure' is not accessible in current workspace"
                    )
                raise RuntimeError(f"unexpected: {q}")

        helpers._create_catalog_with_managed_location(_S(), "azure_leaked_external_loc")
        creates = [c for c in calls if "CREATE CATALOG" in c.upper()]
        assert len(creates) == 3, f"expected 3 CREATEs (bare → ML → bare), got {len(creates)}"
        assert "MANAGED LOCATION" not in creates[0]
        assert "MANAGED LOCATION" in creates[1]
        assert "MANAGED LOCATION" not in creates[2]
        assert "azure_leaked_external_loc" in creates[2]

    def test_v73_bare_needs_ml_but_resolve_returns_empty_raises_informative(self, helpers):
        """v0.7.3 — workspace needs ML, but no candidate is accessible → raise an
        informative RuntimeError rather than silently doing nothing."""
        helpers.dbutils = _FakeDbu({})

        class _S:
            def sql(self, q):
                qu = q.upper()
                if "CREATE CATALOG" in qu and "MANAGED LOCATION" not in qu:
                    raise Exception("managed location required")
                if "DESCRIBE METASTORE" in qu:
                    raise Exception("no metastore storage_root")
                if "SHOW CATALOGS" in qu:
                    return _DF([])
                raise RuntimeError(f"unexpected: {q}")

        with pytest.raises(RuntimeError, match="MANAGED LOCATION but no accessible storage_root"):
            helpers._create_catalog_with_managed_location(_S(), "no_storage_anywhere")
