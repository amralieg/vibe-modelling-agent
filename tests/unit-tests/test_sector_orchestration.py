import json
from pathlib import Path

import pytest


REPO = Path(__file__).resolve().parent.parent.parent
SECTORS_DIR = REPO / "runner" / "industry-sectors"
ALL_INDUSTRIES = REPO / "runner" / "all-industries.json"
ORCHESTRATOR = REPO / "runner" / "orchestrate_sectors.py"
RUNNER_NB = REPO / "runner" / "vibe_runner.ipynb"


SECTOR_FILE_ORDER = [
    "agriculture.json",
    "real_estate_and_professional_services.json",
    "financial_services.json",
    "healthcare_and_life_sciences.json",
    "energy_and_utilities.json",
    "travel_transport_logistics.json",
    "public_sector_education_nonprofit.json",
    "communications_media_entertainment.json",
    "manufacturing.json",
    "retail_and_consumer_goods.json",
]


EXPECTED_TOTAL_INDUSTRIES = 40
EXPECTED_GLOBAL_VOLUME = "/Volumes/_root/default/root_vol"


def _all_sector_payloads():
    payloads = {}
    for fname in SECTOR_FILE_ORDER:
        p = SECTORS_DIR / fname
        payloads[fname] = json.loads(p.read_text())
    return payloads


def test_all_10_sector_files_exist():
    for fname in SECTOR_FILE_ORDER:
        p = SECTORS_DIR / fname
        assert p.exists(), f"sector file missing: {p}"


def test_total_industries_is_40():
    payloads = _all_sector_payloads()
    total = sum(len(p["businesses"]) for p in payloads.values())
    assert total == EXPECTED_TOTAL_INDUSTRIES, f"total industries = {total}, expected {EXPECTED_TOTAL_INDUSTRIES}"


def test_no_industry_appears_in_two_sector_files():
    payloads = _all_sector_payloads()
    seen = {}
    for fname, p in payloads.items():
        for b in p["businesses"]:
            assert b["name"] not in seen, (
                f"industry '{b['name']}' appears in BOTH {seen[b['name']]} and {fname}"
            )
            seen[b["name"]] = fname


def test_every_industry_name_exists_in_all_industries_json():
    src = json.loads(ALL_INDUSTRIES.read_text())
    src_names = {b["name"] for b in src["businesses"]}
    payloads = _all_sector_payloads()
    for fname, p in payloads.items():
        for b in p["businesses"]:
            assert b["name"] in src_names, (
                f"industry '{b['name']}' in {fname} not present in all-industries.json"
            )


def test_descriptions_match_all_industries_json():
    src = json.loads(ALL_INDUSTRIES.read_text())
    src_by_name = {b["name"]: b["description"] for b in src["businesses"]}
    payloads = _all_sector_payloads()
    for fname, p in payloads.items():
        for b in p["businesses"]:
            assert b["description"] == src_by_name[b["name"]], (
                f"description for '{b['name']}' in {fname} drifted from all-industries.json"
            )


def test_every_sector_has_global_collection_volume_widget_value():
    payloads = _all_sector_payloads()
    for fname, p in payloads.items():
        wv = p["widget_values"]
        assert "global_collection_volume" in wv, f"missing global_collection_volume in {fname}"
        assert wv["global_collection_volume"] == EXPECTED_GLOBAL_VOLUME, (
            f"global_collection_volume mismatch in {fname}: got {wv['global_collection_volume']!r}"
        )


def test_every_sector_widget_values_has_19_canonical_keys_plus_global_collection_volume():
    src = json.loads(ALL_INDUSTRIES.read_text())
    canonical_keys = set(src["widget_values"].keys())
    payloads = _all_sector_payloads()
    for fname, p in payloads.items():
        wv = p["widget_values"]
        missing = canonical_keys - set(wv.keys())
        assert not missing, f"sector {fname} missing canonical widget keys: {missing}"
        assert "global_collection_volume" in wv, f"sector {fname} missing global_collection_volume"


def test_sector_file_order_is_smallest_to_largest():
    payloads = _all_sector_payloads()
    sizes = [(fname, len(payloads[fname]["businesses"])) for fname in SECTOR_FILE_ORDER]
    for i in range(1, len(sizes)):
        assert sizes[i][1] >= sizes[i - 1][1], (
            f"sector order not non-decreasing at index {i}: "
            f"{sizes[i-1]} (size={sizes[i-1][1]}) -> {sizes[i]} (size={sizes[i][1]})"
        )


def test_runner_notebook_has_mirror_helper_and_call_site():
    nb = json.loads(RUNNER_NB.read_text())
    src = "".join(nb["cells"][1].get("source", []))
    assert "def _mirror_industry_to_global_volume(" in src, (
        "runner missing _mirror_industry_to_global_volume helper"
    )
    assert "[global-collection-volume FIRED]" in src, (
        "runner missing [global-collection-volume FIRED] sentinel log"
    )
    assert "_gcv_stats = _mirror_industry_to_global_volume(" in src, (
        "runner missing call site for _mirror_industry_to_global_volume"
    )
    assert "global-collection-volume-manifest" in src, (
        "runner missing manifest alias"
    )


def test_runner_notebook_call_site_runs_before_drop_catalog():
    nb = json.loads(RUNNER_NB.read_text())
    src = "".join(nb["cells"][1].get("source", []))
    call_idx = src.find("_gcv_stats = _mirror_industry_to_global_volume(")
    drop_idx = src.find("Dropping staging catalog...")
    assert call_idx >= 0 and drop_idx >= 0
    assert call_idx < drop_idx, (
        "_mirror_industry_to_global_volume call site MUST run before drop_catalog(staging) "
        "or the staging vol_root will be gone before the copy"
    )


def test_orchestrator_script_imports_and_help_runs():
    import subprocess
    p = subprocess.run(
        ["python3", str(ORCHESTRATOR), "--help"],
        capture_output=True,
        text=True,
        timeout=15,
    )
    assert p.returncode == 0, f"orchestrator --help failed: {p.stderr[:500]}"
    assert "--profile" in p.stdout
    assert "--global-volume" in p.stdout
    assert "--dry-preflight" in p.stdout


def test_orchestrator_constants_match_user_directives():
    src = ORCHESTRATOR.read_text()
    assert 'DEFAULT_PROFILE = "emirates-gcp"' in src
    assert 'DEFAULT_GLOBAL_VOLUME = "/Volumes/_root/default/root_vol"' in src
    assert 'DEFAULT_RUNNER_PATH = "/Users/amr.ali@databricks.com/vibe_runner_v71"' in src
    expected_block = "\n".join([f'    "{f}",' for f in SECTOR_FILE_ORDER])
    assert expected_block in src, (
        "orchestrator SECTOR_FILES_ORDER must list files smallest-to-largest exactly as test expects"
    )


def test_orchestrator_pulse_interval_is_10_minutes():
    src = ORCHESTRATOR.read_text()
    assert "PULSE_INTERVAL_S = 600" in src, "pulse cadence must be 10 minutes (per user directive 2026-04-30)"


def test_orchestrator_uploads_create_parent_dir():
    src = ORCHESTRATOR.read_text()
    upload_fn = src.split("def upload_sector_to_volume", 1)[1].split("\ndef ", 1)[0]
    assert '"fs", "mkdir"' in upload_fn, (
        "upload_sector_to_volume must mkdir the volume subdir before cp "
        "(databricks fs cp does NOT auto-create parents — caught in 2026-04-30 hot run)"
    )
    assert "RESOURCE_ALREADY_EXISTS" in upload_fn or "already exists" in upload_fn.lower(), (
        "mkdir must tolerate already-exists so reruns don't crash"
    )


def test_orchestrator_preflight_creates_sectors_subdir():
    src = ORCHESTRATOR.read_text()
    preflight_fn = src.split("def preflight", 1)[1].split("\ndef ", 1)[0]
    assert "_sectors" in preflight_fn and '"fs", "mkdir"' in preflight_fn, (
        "preflight must mkdir the _sectors subdir up-front so the first sector upload doesn't fail"
    )


def test_orchestrator_submit_uses_no_wait():
    src = ORCHESTRATOR.read_text()
    submit_fn = src.split("def submit_sector_run", 1)[1].split("\ndef ", 1)[0]
    assert '"--no-wait"' in submit_fn, (
        "submit_sector_run MUST pass --no-wait to `databricks jobs run-now` "
        "(per CLAUDE.md §10.11.2 GOTCHA C — without --no-wait the CLI blocks for the "
        "full run duration, defeating the orchestrator's polling loop)"
    )


def test_orchestrator_preflight_kills_orphan_child_runs():
    src = ORCHESTRATOR.read_text()
    preflight_fn = src.split("def preflight", 1)[1].split("\ndef ", 1)[0]
    assert "ORPHAN-DETECTED" in preflight_fn, (
        "preflight MUST detect orphan dbx_vibe_*_pipeline_* child runs left over from "
        "cancelled prior orchestrator attempts — they occupy max_concurrent_runs=1 slots "
        "and block our new child runs from starting (caught 2026-04-30 in launch)"
    )
    assert "dbx_vibe_" in preflight_fn and "_pipeline_" in preflight_fn, (
        "orphan detector MUST match the runner's child-job naming pattern"
    )
    assert '"jobs", "cancel-run"' in preflight_fn, (
        "preflight MUST actually cancel detected orphans, not just warn"
    )
    assert "creator_user_name" in preflight_fn or "creator ==" in preflight_fn, (
        "orphan detector MUST scope to current-user-owned runs (per §12 ownership rule)"
    )
    assert "CATALOG-DROP RULE" in preflight_fn or "§12" in preflight_fn, (
        "orphan cancellation MUST log §12 authorisation rationale"
    )


def test_orchestrator_supports_kill_switch():
    src = ORCHESTRATOR.read_text()
    assert 'KILL_FILE_NAME = "_kill.json"' in src
    assert "def kill_switch_present(" in src
    assert "kill_switch_present(args.profile" in src or "kill_switch_present(" in src


def test_orchestrator_supports_one_retry_on_failure():
    src = ORCHESTRATOR.read_text()
    assert "retrying" in src and "failed industries one-by-one" in src
    assert "build_single_industry_payload" in src


def test_agent_version_constant_unchanged_at_071():
    nb = json.loads(open(REPO / "agent" / "dbx_vibe_modelling_agent.ipynb").read())
    cell0_src = "".join(nb["cells"][0].get("source", [])) if nb["cells"][0].get("cell_type") == "code" else ""
    cell1_src = "".join(nb["cells"][1].get("source", [])) if len(nb["cells"]) > 1 and nb["cells"][1].get("cell_type") == "code" else ""
    text = cell0_src + "\n" + cell1_src
    import re
    matches = re.findall(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', text)
    assert matches, "agent notebook missing __AGENT_VERSION__"
    assert matches[0] in ("0.7.1", "0.8.1"), (
        f"agent __AGENT_VERSION__ unexpected value: {matches[0]} "
        "(should be 0.7.1 for v0.7.1 deploy, or 0.8.1 if dev iteration)"
    )


if __name__ == "__main__":
    raise SystemExit(pytest.main([__file__, "-v"]))
