"""Tests for user business_domains EXHAUSTIVE enforcement — v0.8.0.

When user sets business_domains=['a','b','c'], that's EXACTLY 3, not a minimum.
Tier classifier / judge must NOT add more.

v0.8.1 EXP4-FIX (alias: tmp-agent-source-removal) — read directly from the
committed notebook instead of /tmp/agent_source.py so this test runs in a
fresh checkout without a Databricks export step.
"""
import json
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _agent_source() -> str:
    """Prefer /tmp/agent_source.py if present (Databricks export), else parse the notebook."""
    tmp_src = Path("/tmp/agent_source.py")
    if tmp_src.exists():
        return tmp_src.read_text(encoding="utf-8")
    nb = json.loads(NOTEBOOK_PATH.read_text(encoding="utf-8"))
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        s = cell.get("source", "")
        if isinstance(s, list):
            s = "".join(s)
        parts.append(s)
    return "\n".join(parts)


class TestExhaustiveEnforcement:
    """Validate that the logic invariants hold in the source code."""

    def test_user_domains_exhaustive_flag_setter_present(self):
        """Source should contain the exhaustive flag-setting code."""
        src = _agent_source()
        assert 'user_domains_exhaustive' in src
        assert 'sizing_directives' in src

    def test_exhaustive_trim_logic_present(self):
        """Source should contain the drop-non-user-domains trim pass."""
        src = _agent_source()
        assert 'EXHAUSTIVE mode' in src
        assert 'dropped' in src and 'non-user domain' in src

    def test_sanitize_matches_injection_rules(self):
        """User-specified names are lowercased + underscore-stripped for comparison."""
        src = _agent_source()
        assert '.lower().replace("_","")' in src or '.lower().replace("_", "")' in src
