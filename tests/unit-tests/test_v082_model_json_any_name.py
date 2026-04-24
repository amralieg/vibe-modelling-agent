"""Tests for v0.8.2 MJ-FIX (alias: model-json-any-name) — accept any *.json filename
for the user-provided model JSON, not just the literal `model.json`.

Two layers of coverage:

1. Behavioural tests of the module-level helpers `_looks_like_model_json` and
   `_resolve_user_model_json_path` via the `agent_helpers` test harness.
2. Source-level structural invariants for closure-internal sites that cannot be
   imported (install read path, in-place writebacks, recovery, migration scan).

Each test exercises the FAILURE MODE of the fix so a revert breaks it.
"""
import json
import os
import re
import tempfile
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_notebook_source(path: Path) -> str:
    nb = json.loads(path.read_text(encoding="utf-8"))
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        parts.append(src)
    return "\n".join(parts)


@pytest.fixture(scope="module")
def agent_src() -> str:
    return _read_notebook_source(NOTEBOOK_PATH)


@pytest.fixture(scope="module")
def helpers():
    import agent_helpers as ah  # built by conftest.py
    return ah


def _write(tmp: Path, name: str, payload):
    p = tmp / name
    p.write_text(json.dumps(payload), encoding="utf-8")
    return str(p)


# ────────────────────────────────────────────────────────────────────────────
# 1. _looks_like_model_json — structural detector
# ────────────────────────────────────────────────────────────────────────────

class TestLooksLikeModelJson:
    def test_new_format_with_model_dict(self, helpers):
        assert helpers._looks_like_model_json({"model_requirements": {}, "model": {"domains": []}}) is True

    def test_bare_domains_only(self, helpers):
        assert helpers._looks_like_model_json({"domains": [{"name": "customer"}]}) is True

    def test_model_requirements_only(self, helpers):
        assert helpers._looks_like_model_json({"model_requirements": {"business_name": "x"}}) is True

    def test_empty_dict_rejected(self, helpers):
        assert helpers._looks_like_model_json({}) is False

    def test_unrelated_dict_rejected(self, helpers):
        assert helpers._looks_like_model_json({"foo": "bar", "biz": "n"}) is False

    def test_non_dict_rejected(self, helpers):
        assert helpers._looks_like_model_json("not a dict") is False
        assert helpers._looks_like_model_json([{"domains": []}]) is False
        assert helpers._looks_like_model_json(None) is False

    def test_model_value_must_be_dict(self, helpers):
        assert helpers._looks_like_model_json({"model": "not a dict"}) is False

    def test_domains_value_must_be_list(self, helpers):
        assert helpers._looks_like_model_json({"domains": "not a list"}) is False


# ────────────────────────────────────────────────────────────────────────────
# 2. _resolve_user_model_json_path — resolution priority
# ────────────────────────────────────────────────────────────────────────────

class TestResolveUserModelJsonPath:
    def test_verbatim_user_path_with_custom_name_wins(self, helpers, tmp_path):
        path = _write(tmp_path, "my_airlines.json", {"model_requirements": {}, "model": {"domains": []}})
        resolved, content = helpers._resolve_user_model_json_path(str(tmp_path), path, None)
        assert resolved == path, f"Expected verbatim user path, got {resolved}"
        assert content is not None
        assert json.loads(content)["model"]["domains"] == []

    def test_canonical_fallback_when_user_path_missing(self, helpers, tmp_path):
        canonical = _write(tmp_path, "model.json", {"domains": [{"name": "customer"}]})
        resolved, content = helpers._resolve_user_model_json_path(str(tmp_path), None, None)
        assert resolved == canonical
        assert json.loads(content)["domains"][0]["name"] == "customer"

    def test_discovery_finds_any_named_json(self, helpers, tmp_path):
        path = _write(tmp_path, "weird_name_12345.json", {"model_requirements": {}, "model": {"domains": []}})
        resolved, content = helpers._resolve_user_model_json_path(str(tmp_path), None, None)
        assert resolved == path, f"Expected discovery to pick {path}, got {resolved}"
        assert content is not None

    def test_discovery_skips_invalid_json_files(self, helpers, tmp_path):
        bad = tmp_path / "garbage.json"
        bad.write_text("{ not valid json", encoding="utf-8")
        good = _write(tmp_path, "actual_model.json", {"domains": []})
        resolved, content = helpers._resolve_user_model_json_path(str(tmp_path), None, None)
        assert resolved == good

    def test_discovery_skips_non_model_json_files(self, helpers, tmp_path):
        unrelated = _write(tmp_path, "other.json", {"unrelated": "stuff"})
        good = _write(tmp_path, "real_model.json", {"domains": []})
        resolved, content = helpers._resolve_user_model_json_path(str(tmp_path), None, None)
        assert resolved == good

    def test_returns_none_none_when_nothing_found(self, helpers, tmp_path):
        resolved, content = helpers._resolve_user_model_json_path(str(tmp_path), None, None)
        assert resolved is None and content is None

    def test_user_provided_non_json_extension_is_ignored(self, helpers, tmp_path):
        canonical = _write(tmp_path, "model.json", {"domains": []})
        weird = tmp_path / "thing.txt"
        weird.write_text("not json", encoding="utf-8")
        resolved, content = helpers._resolve_user_model_json_path(str(tmp_path), str(weird), None)
        assert resolved == canonical, "non-.json user input must be skipped, fall through to canonical"

    def test_user_provided_json_that_is_not_model_falls_through(self, helpers, tmp_path):
        canonical = _write(tmp_path, "model.json", {"domains": []})
        not_a_model = _write(tmp_path, "garbage.json", {"unrelated": "stuff"})
        resolved, content = helpers._resolve_user_model_json_path(str(tmp_path), not_a_model, None)
        assert resolved == canonical, "non-model JSON at user path must fall through, not be accepted"

    def test_canonical_preferred_over_other_files_when_canonical_valid(self, helpers, tmp_path):
        canonical = _write(tmp_path, "model.json", {"domains": [{"name": "from_canonical"}]})
        other = _write(tmp_path, "another.json", {"domains": [{"name": "from_other"}]})
        resolved, content = helpers._resolve_user_model_json_path(str(tmp_path), None, None)
        assert resolved == canonical
        assert json.loads(content)["domains"][0]["name"] == "from_canonical"

    def test_legacy_data_model_v_in_subfolder_still_works(self, helpers, tmp_path):
        docs = tmp_path / "docs"
        docs.mkdir()
        legacy = _write(docs, "airline_data_model_v1.json", {"domains": [{"name": "legacy"}]})
        resolved, content = helpers._resolve_user_model_json_path(str(tmp_path), None, None)
        assert resolved == legacy
        assert json.loads(content)["domains"][0]["name"] == "legacy"

    def test_empty_inputs_return_none(self, helpers):
        resolved, content = helpers._resolve_user_model_json_path("", None, None)
        assert resolved is None and content is None


# ────────────────────────────────────────────────────────────────────────────
# 3. Source-level structural invariants — install path
# ────────────────────────────────────────────────────────────────────────────

class TestInstallPathUsesResolver:
    def test_install_calls_unified_resolver(self, agent_src):
        """Install must call _resolve_user_model_json_path, not reconstruct {model_folder}/model.json."""
        m = re.search(r"--- Step 0: Detecting Business Name and Version from Model Folder ---.*?_strip_baked_catalog_from_model",
                      agent_src, re.DOTALL)
        assert m, "Could not locate install Step 0 block"
        block = m.group(0)
        assert "_resolve_user_model_json_path" in block, "install must call the unified resolver"

    def test_install_no_longer_hardcodes_model_json_path(self, agent_src):
        """The pre-fix line `_model_json_path = f\"{model_folder}/model.json\"` must be gone."""
        assert '_model_json_path = f"{model_folder}/model.json"' not in agent_src, \
            "Hardcoded f\"{model_folder}/model.json\" must not appear — use the resolver"

    def test_install_captures_resolved_path_for_writebacks(self, agent_src):
        assert "_resolved_model_json_path = json_file" in agent_src, \
            "Install must pin the resolved path so writebacks reuse it"

    def test_install_captures_user_provided_path(self, agent_src):
        """The widget's actual user path must be captured into _user_provided_json_path."""
        assert "_user_provided_json_path" in agent_src
        assert 'widgets_values.get("business_context_file_path"' in agent_src


# ────────────────────────────────────────────────────────────────────────────
# 4. Source-level structural invariants — write-back sites
# ────────────────────────────────────────────────────────────────────────────

class TestWritebackUsesResolvedPath:
    def test_failed_metric_view_writeback_uses_resolved_path(self, agent_src):
        m = re.search(r"_jm_writeback_path\s*=\s*_resolved_model_json_path", agent_src)
        assert m, "Failed-metric-view cleanup must write back to the resolved (user-provided) path"

    def test_failed_metric_view_writeback_does_not_hardcode_model_json(self, agent_src):
        assert 'file_path=f"{model_folder}/model.json"' not in agent_src, \
            "Failed-metric-view writeback must not hardcode {model_folder}/model.json"

    def test_deployment_location_writeback_preserves_filename(self, agent_src):
        """The deploy-folder copy must use the same filename the user provided."""
        m = re.search(r"_deploy_json_filename\s*=\s*os\.path\.basename\(", agent_src)
        assert m, "Deployment-location writeback must derive filename from _resolved_model_json_path"

    def test_deployment_location_writeback_does_not_hardcode_model_json(self, agent_src):
        assert 'file_path=f"{_deploy_biz_folder}/model.json"' not in agent_src, \
            "Deployment writeback must not hardcode {_deploy_biz_folder}/model.json"


# ────────────────────────────────────────────────────────────────────────────
# 5. Source-level structural invariants — recovery path
# ────────────────────────────────────────────────────────────────────────────

class TestRecoveryUsesResolver:
    def test_recovery_uses_unified_resolver(self, agent_src):
        m = re.search(r"def _recover_model_data_from_volume.*?def _find_next_available_version", agent_src, re.DOTALL)
        assert m, "Could not locate _recover_model_data_from_volume"
        recovery_block = m.group(0)
        assert "_resolve_user_model_json_path" in recovery_block, "Recovery must use the unified resolver"

    def test_recovery_no_longer_hardcodes_model_json(self, agent_src):
        m = re.search(r"def _recover_model_data_from_volume.*?def _find_next_available_version", agent_src, re.DOTALL)
        assert m
        recovery_block = m.group(0)
        assert 'os.path.join(volume_path, "model.json")' not in recovery_block, \
            "Recovery must not hardcode os.path.join(volume_path, \"model.json\")"


# ────────────────────────────────────────────────────────────────────────────
# 6. Source-level structural invariants — migration scan
# ────────────────────────────────────────────────────────────────────────────

class TestMigrationAcceptsAnyJson:
    def test_migration_uses_structural_match(self, agent_src):
        m = re.search(r"def _migrate_json_in_dir.*?def _migrate_obj|def _migrate_json_in_dir.*?biz_base", agent_src, re.DOTALL)
        if not m:
            m = re.search(r"def _migrate_json_in_dir\(scan_dir\):.*?(?=\n    [a-zA-Z_]+\s*=\s*f|biz_base)", agent_src, re.DOTALL)
        assert m, "Could not locate _migrate_json_in_dir"
        block = m.group(0)
        assert "_looks_like_model_json" in block, "Migration scan must use structural match for non-canonical filenames"


# ────────────────────────────────────────────────────────────────────────────
# 7. Source-level structural invariants — widget label and error messages
# ────────────────────────────────────────────────────────────────────────────

class TestUserFacingMessages:
    def test_widget_label_says_any_filename(self, agent_src):
        assert 'dbutils.widgets.text("context_file"' in agent_src
        # The label should now say "any *.json" or similar — not hardcode "model.json"
        m = re.search(r'dbutils\.widgets\.text\("context_file",\s*"",\s*"([^"]+)"\)', agent_src)
        assert m, "widget definition not found"
        label = m.group(1)
        assert "any" in label.lower() or "*.json" in label, \
            f"Widget label must indicate any filename is accepted; got: {label!r}"

    def test_install_missing_path_error_mentions_any_filename(self, agent_src):
        # The error raised when model_folder is empty should mention that any *.json filename works
        m = re.search(r"For 'install model', provide a Model JSON file path[^\"]*", agent_src)
        assert m, "Install missing-path error message must mention any *.json filename"
        msg = m.group(0)
        assert "any" in msg.lower() and ".json" in msg.lower()


# ────────────────────────────────────────────────────────────────────────────
# 8. Sentinel check — the v0.8.2 alias must be greppable
# ────────────────────────────────────────────────────────────────────────────

class TestSentinelGreppable:
    def test_v082_mj_fix_sentinel_present(self, agent_src):
        assert "v0.8.2 MJ-FIX" in agent_src, "v0.8.2 MJ-FIX sentinel must be present"

    def test_alias_greppable(self, agent_src):
        assert "model-json-any-name" in agent_src, "Alias 'model-json-any-name' must be greppable"

    def test_alias_appears_at_install_recovery_writeback_migration(self, agent_src):
        # At least 4 sites should carry the alias: helper, install read, writebacks (2), recovery, migration.
        count = agent_src.count("model-json-any-name")
        assert count >= 5, f"Expected >=5 alias mentions across all touched sites, got {count}"
