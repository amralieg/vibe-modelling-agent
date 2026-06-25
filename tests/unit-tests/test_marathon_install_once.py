import os
import sys
import importlib.util

_RUNNER = os.path.join(os.path.dirname(__file__), "..", "..", "runner", "vov_v2_marathon.py")
_spec = importlib.util.spec_from_file_location("vov_v2_marathon", os.path.abspath(_RUNNER))
m = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(m)


def _keys(spec):
    return [t["task_key"] for t in spec["tasks"]]


def _dep(spec, key):
    for t in spec["tasks"]:
        if t["task_key"] == key:
            return [d["task_key"] for d in t.get("depends_on", [])]
    return None


def test_fresh_install_runs_full_three_task_pipeline():
    spec = m.build_job_spec("travel_hospitality", installed=False)
    assert _keys(spec) == ["install", "vov", "shrink"]
    assert _dep(spec, "install") == []
    assert _dep(spec, "vov") == ["install"]
    assert _dep(spec, "shrink") == ["vov"]


def test_reuse_drops_install_task_and_vov_has_no_install_dep():
    spec = m.build_job_spec("travel_hospitality", installed=True)
    assert _keys(spec) == ["vov", "shrink"]
    assert _dep(spec, "vov") == []
    assert _dep(spec, "shrink") == ["vov"]
    # the installed deliverable inputs must still be wired for the vov task
    vov_task = next(t for t in spec["tasks"] if t["task_key"] == "vov")
    params = vov_task["notebook_task"]["base_parameters"]
    assert params["operation"] == "vibe modeling of version"
    assert params["model_version"] == "1"
    assert params["context_file"] == ""


def test_default_is_fresh_install():
    assert _keys(m.build_job_spec("ngo")) == ["install", "vov", "shrink"]


def test_force_reinstall_env_short_circuits_probe(monkeypatch):
    calls = {"n": 0}

    def _boom(*a, **k):
        calls["n"] += 1
        raise AssertionError("sql_exec must not run when VOV_FORCE_REINSTALL=1")

    monkeypatch.setattr(m, "sql_exec", _boom)
    monkeypatch.setenv("VOV_FORCE_REINSTALL", "1")
    assert m.v1_installed("fe-gcp", "travel_hospitality") is False
    assert calls["n"] == 0


def test_probe_true_when_v1_complete(monkeypatch):
    # v1_installed now mirrors the agent's completeness contract: reuse a v1 ONLY when
    # MAX(completed_percent) >= 100 AND domain rows exist. "100" satisfies both the
    # completeness query (float("100") == 100.0) and the domain-count query (int("100") > 0).
    monkeypatch.delenv("VOV_FORCE_REINSTALL", raising=False)
    monkeypatch.setattr(m, "sql_exec",
                        lambda *a, **k: {"result": {"data_array": [["100"]]}})
    assert m.v1_installed("fe-gcp", "travel_hospitality") is True


def test_probe_false_when_v1_incomplete(monkeypatch):
    # a v1 row that never finished (completed_percent < 100) must NOT be reused — fresh install.
    monkeypatch.delenv("VOV_FORCE_REINSTALL", raising=False)
    monkeypatch.setattr(m, "sql_exec",
                        lambda *a, **k: {"result": {"data_array": [["99.0"]]}})
    assert m.v1_installed("fe-gcp", "travel_hospitality") is False


def test_probe_false_when_no_row(monkeypatch):
    monkeypatch.delenv("VOV_FORCE_REINSTALL", raising=False)
    monkeypatch.setattr(m, "sql_exec",
                        lambda *a, **k: {"result": {"data_array": []}})
    assert m.v1_installed("fe-gcp", "travel_hospitality") is False


def test_probe_false_when_catalog_missing(monkeypatch):
    monkeypatch.delenv("VOV_FORCE_REINSTALL", raising=False)

    def _raise(*a, **k):
        raise RuntimeError("TABLE_OR_VIEW_NOT_FOUND: _metamodel.business")

    monkeypatch.setattr(m, "sql_exec", _raise)
    assert m.v1_installed("fe-gcp", "travel_hospitality") is False


# --- fixed-catalog mechanism (a profile where the metastore denies CREATE CATALOG) ---
# my-aws is the FIXED_CATALOG profile but is now EMPTY of industries (manufacturing was relocated
# to the droppable fe-aws on 2026-06-24 to escape the un-droppable shared catalog that pinned it
# 'partial'). The fixed-catalog mechanism must still be covered, so these tests drive it through a
# SYNTHETIC industry mapped onto my-aws rather than a live assignment.
FIXED_PROFILE = "my-aws"
FIXED_CAT = "serverless_stable_8nstmo_catalog"


def test_fixed_catalog_mechanism_via_synthetic_industry(monkeypatch):
    monkeypatch.setitem(m._IND_PROFILE, "_fixedtest", FIXED_PROFILE)
    assert m.FIXED_CATALOG.get(FIXED_PROFILE) == FIXED_CAT
    # an industry on the fixed-catalog profile resolves to the shared pre-existing catalog
    assert m.cat_name("_fixedtest") == FIXED_CAT
    # an industry on a normal profile keeps its isolated, droppable per-industry catalog
    assert m.cat_name("travel_hospitality") == "vibe_travel_hospitality_v1"


def test_manufacturing_on_droppable_fe_aws():
    # manufacturing now lives on fe-aws (CREATE/DROP CATALOG allowed) so the marathon can do a
    # clean DROP+install v1->v2; it must NOT be on the fixed/un-droppable or flaky-Azure profiles.
    assert "manufacturing" in m.ASSIGN["fe-aws"]
    assert "manufacturing" not in m.ASSIGN["my-aws"]
    assert "manufacturing" not in m.ASSIGN.get("my-adp", [])
    # and it therefore gets a droppable, isolated per-industry catalog
    assert m.cat_name("manufacturing") == "vibe_manufacturing_v1"


def test_build_job_spec_uses_fixed_catalog_for_fixed_profile_industry(monkeypatch):
    monkeypatch.setitem(m._IND_PROFILE, "_fixedtest", FIXED_PROFILE)
    spec = m.build_job_spec("_fixedtest", installed=False)
    for t in spec["tasks"]:
        assert t["notebook_task"]["base_parameters"]["deployment_catalog"] == FIXED_CAT


def test_build_job_spec_uses_droppable_catalog_for_manufacturing():
    spec = m.build_job_spec("manufacturing", installed=False)
    for t in spec["tasks"]:
        assert t["notebook_task"]["base_parameters"]["deployment_catalog"] == "vibe_manufacturing_v1"


def test_prepare_catalog_fixed_skips_drop_and_create(monkeypatch):
    monkeypatch.setitem(m._IND_PROFILE, "_fixedtest", FIXED_PROFILE)
    stmts = []
    monkeypatch.setattr(m, "v1_installed", lambda *a, **k: False)
    monkeypatch.setattr(m, "sql_exec",
                        lambda profile, stmt, timeout=180: stmts.append(stmt) or {"result": {"data_array": []}})
    monkeypatch.setattr(m, "pulse", lambda *a, **k: None)
    reused = m.prepare_catalog(FIXED_PROFILE, "_fixedtest")
    joined = " | ".join(stmts).upper()
    # the metastore denies CREATE CATALOG, so neither DROP nor CREATE CATALOG may be issued
    assert "DROP CATALOG" not in joined
    assert "CREATE CATALOG" not in joined
    # but the agent meta schema + volume must be ensured inside the shared catalog
    assert any("CREATE SCHEMA IF NOT EXISTS" in s and FIXED_CAT in s for s in stmts)
    assert any("CREATE VOLUME IF NOT EXISTS" in s for s in stmts)
    # v1 not yet installed -> install task must run (reused False)
    assert reused is False


def test_prepare_catalog_normal_profile_still_drops_and_creates(monkeypatch):
    stmts = []
    monkeypatch.setattr(m, "v1_installed", lambda *a, **k: False)
    monkeypatch.setattr(m, "sql_exec",
                        lambda profile, stmt, timeout=180: stmts.append(stmt) or {"result": {"data_array": []}})
    monkeypatch.setattr(m, "pulse", lambda *a, **k: None)
    m.prepare_catalog("fe-gcp", "travel_hospitality")
    joined = " | ".join(stmts).upper()
    # a normal profile (CREATE CATALOG allowed) must still drop+recreate its isolated catalog
    assert "DROP CATALOG IF EXISTS" in joined
    assert "CREATE CATALOG" in joined
