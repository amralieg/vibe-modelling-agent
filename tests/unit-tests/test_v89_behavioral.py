"""v0.8.9 behavioral tests — P72 vov-auto-seed-skip-reserved.

Root cause fix for v0.8.8 LG regression where P70 auto-seeded reserved-name
'domains' (duplicate, ssot, ip_asset) that the vibe parser had spuriously
extracted from vibe text.
"""
from __future__ import annotations

import json
import re
from pathlib import Path

import pytest

from notebook_source_util import notebook_concat_source

AGENT_NB = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _agent_source() -> str:
    nb = json.loads(AGENT_NB.read_text(encoding="utf-8"))
    parts = []
    for c in nb.get("cells", []):
        if c.get("cell_type") != "code":
            continue
        s = c.get("source", "")
        parts.append("".join(s) if isinstance(s, list) else s)
    return "\n\n".join(parts)


def _cell_source(i: int) -> str:
    nb = json.loads(AGENT_NB.read_text(encoding="utf-8"))
    s = nb["cells"][i]["source"]
    return "".join(s) if isinstance(s, list) else s


@pytest.fixture(scope="module")
def agent_src() -> str:
    return _agent_source()


# ---------------------------------------------------------------------------
# Version + alias
# ---------------------------------------------------------------------------
def test_agent_version_at_least_089(agent_src):
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', agent_src)
    assert m, "no __AGENT_VERSION__"
    parts = [int(x) for x in m.group(1).split(".")]
    assert parts >= [0, 8, 9], f"version {m.group(1)} < 0.8.9"


def test_p72_alias_present(agent_src):
    assert "vov-auto-seed-skip-reserved FIRED" in agent_src


# ---------------------------------------------------------------------------
# P72 logic
# ---------------------------------------------------------------------------
def test_p72_reserved_blocklist_includes_known_bad(agent_src):
    """P72 blocklist must include the names seen in v0.8.8 LG regression."""
    src = _cell_source(21)
    for bad in ("duplicate", "ssot", "ip_asset", "shared", "reference"):
        assert f"'{bad}'" in src, f"P72 _p72_reserved missing {bad!r}"


def test_p72_carveout_for_user_widget(agent_src):
    """If a reserved name IS in business_domains widget, P72 must allow it."""
    src = _cell_source(21)
    assert "_p72_user_widget_domains" in src
    assert "_miss not in _p72_user_widget_domains" in src, (
        "P72 must allow reserved names when user widget set them"
    )


def test_p72_records_skipped_count(agent_src):
    src = _cell_source(21)
    assert "_p72_skipped = []" in src
    assert "_p72_skipped.append(_miss)" in src
    # Must log the count of P72-rejected stubs
    assert "vov-auto-seed-skip-reserved FIRED" in src


# ---------------------------------------------------------------------------
# Regression: v88 patches still present
# ---------------------------------------------------------------------------
@pytest.mark.parametrize("alias", [
    "fmfl-final-sanitize-drop-orphans FIRED",      # P63
    "vov-reject-reserved-domain-moves FIRED",       # P64
    "attr-gen-timeout-raise FIRED",                 # P66
    "vov-sizing-soft-warn-record-to-next-vibes FIRED",  # P68
    "next-vibes-collector-soft-warn FIRED",         # P69
    "vov-auto-seed-missing-domains FIRED",          # P70
    "vov-score-soft-warn-record-to-next-vibes FIRED",   # P71
])
def test_v088_aliases_preserved(alias, agent_src):
    assert alias in agent_src, f"v0.8.8 alias regression: {alias}"
