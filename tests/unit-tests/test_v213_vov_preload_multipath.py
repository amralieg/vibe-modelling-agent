import json
import re
from pathlib import Path


AGENT_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_all_source() -> str:
    nb = json.loads(AGENT_PATH.read_text())
    return "\n".join("".join(c.get("source", [])) for c in nb["cells"])


def test_agent_version_is_at_least_v213():
    src = _load_all_source()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m is not None, "No __AGENT_VERSION__ found"
    parts = tuple(int(x) for x in m.group(1).split("."))
    assert parts >= (2, 1, 3), f"Expected >= 2.1.3, got {m.group(1)}"


def test_preload_fallback_handles_context_file_widget():
    src = _load_all_source()
    assert 'for _v213_widget_name in ("business_context_file_path", "context_file"):' in src, (
        "v213 fallback must iterate both widget names so empty business_context_file_path is no longer the only override"
    )


def test_preload_fallback_derives_volume_path():
    src = _load_all_source()
    assert "_v213_candidate_paths.append(" in src, (
        "v213 fallback must derive disk candidate paths"
    )
    assert "/_metamodel/vol_root/business" in src, (
        "v213 fallback must derive paths under the canonical volume root"
    )
    assert "_v213_scope_order" in src, (
        "v213 fallback must iterate scope (mvm/ecm) candidates"
    )


def test_preload_fallback_prefers_mvm_scope_when_widget_says_mvm():
    src = _load_all_source()
    assert '_v213_scope_order = ("mvm", "ecm") if ("mvm" in _v213_scope_raw or not _v213_scope_raw) else ("ecm", "mvm")' in src, (
        "scope-order selector must prefer mvm when data_model_scopes contains 'mvm', else ecm-first"
    )


def test_preload_fallback_emits_alias_logs():
    src = _load_all_source()
    assert "alias=vov-v1-preload-fallback-disk-multipath" in src, (
        "v213 must self-report with its alias so the deployed-archive grep can verify activation"
    )
    assert "[vov-v1-preload-fallback-disk FIRED v2.1.3]" in src
    assert "[vov-v1-preload-fallback-disk MISS v2.1.3]" in src
    assert "[vov-v1-preload-fallback-disk ERROR v2.1.3]" in src


def test_preload_fallback_hydrates_widgets_business_context_file_path():
    src = _load_all_source()
    assert 'widgets_values["business_context_file_path"] = _bcfp' in src, (
        "After successful disk load, the resolved path must be written into business_context_file_path so downstream code sees a single canonical source"
    )


def test_preload_fail_loud_still_present():
    src = _load_all_source()
    assert "vov-v1-preload-fail-loud" in src, "v209 FAIL-LOUD defense must still be active"
    assert "raise RuntimeError(_msg)" in src
