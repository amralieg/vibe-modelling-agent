import json
import re
from pathlib import Path


AGENT_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_all_source() -> str:
    nb = json.loads(AGENT_PATH.read_text())
    return "\n".join("".join(c.get("source", [])) for c in nb["cells"])


def test_agent_version_is_at_least_v214():
    src = _load_all_source()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m is not None
    parts = tuple(int(x) for x in m.group(1).split("."))
    assert parts >= (2, 1, 4), f"Expected >= 2.1.4, got {m.group(1)}"


def test_v214_alias_present():
    src = _load_all_source()
    assert "alias=vov-v1-preload-fallback-disk-case-variants" in src


def test_v214_enumerates_case_variants():
    src = _load_all_source()
    assert "_v213_biz.lower()" in src
    assert "_v213_biz.title()" in src
    assert "_v213_biz.lower().replace(' ', '_')" in src
    assert "_v213_biz.lower().replace(' ', '')" in src


def test_v214_listdir_discovers_actual_subdirs():
    src = _load_all_source()
    assert "_v214_os.listdir(_v214_biz_root)" in src
    assert "_v214_os.path.isdir(_v214_biz_root)" in src


def test_v214_listdir_failure_is_logged_not_raised():
    src = _load_all_source()
    assert "vov-v1-preload-fallback-disk-case-variants WARN v2.1.4" in src
    assert "except Exception as _v214_lserr" in src


def test_v214_does_not_break_v213_multipath():
    src = _load_all_source()
    assert "alias=vov-v1-preload-fallback-disk-multipath" in src, "v213 widget-name multipath must still be active"
    assert "_v213_candidate_paths" in src
    assert 'for _v213_widget_name in ("business_context_file_path", "context_file"):' in src


def test_v214_preserves_fail_loud_defense():
    src = _load_all_source()
    assert "vov-v1-preload-fail-loud" in src
    assert "raise RuntimeError(_msg)" in src
