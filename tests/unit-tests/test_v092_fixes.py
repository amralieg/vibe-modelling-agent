"""v0.9.2 TESTER-USE-LATEST-ARCHIVE test.

The vibe_tester notebook now auto-discovers the latest
`dbx_vibe_modelling_agent_v*` archive in the tester's parent directory
and uses that path instead of the canon. This bypasses the Databricks
notebook cache that prevented v0.8.9, v0.9.0, v0.9.1 fixes from reaching
tester sub-tasks despite correct content in the canon.
"""

import json
import re
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
TESTER_NB_PATH = REPO_ROOT / "tests" / "vibe_tester.ipynb"


def _read_notebook_source(path: Path) -> str:
    nb = json.loads(path.read_text(encoding="utf-8"))
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") == "code":
            parts.extend(cell.get("source", []))
    return "".join(parts)


@pytest.fixture(scope="module")
def tester_src() -> str:
    return _read_notebook_source(TESTER_NB_PATH)


class TestTesterUseLatestArchive:
    def test_alias_present(self, tester_src):
        assert "tester-use-latest-archive" in tester_src

    def test_workspaceclient_imported(self, tester_src):
        assert "from databricks.sdk import WorkspaceClient as _AVWC" in tester_src

    def test_archive_regex(self, tester_src):
        # Pattern: dbx_vibe_modelling_agent_v(\d+)
        assert re.search(
            r"r['\"]dbx_vibe_modelling_agent_v\(\\d\+\)\$['\"]", tester_src
        ), "archive-name regex not found"

    def test_sort_descending(self, tester_src):
        assert "_av_candidates.sort(reverse=True)" in tester_src

    def test_fallback_to_canon(self, tester_src):
        # If no archive found, fall back to canon path.
        assert (
            'agent_notebook = "./../agent/dbx_vibe_modelling_agent"' in tester_src
        )

    def test_log_marker_emit(self, tester_src):
        assert (
            "TESTER-USE-LATEST-ARCHIVE: selected agent notebook" in tester_src
        )
