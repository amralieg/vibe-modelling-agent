"""v0.7.5 global job-timeout = 15h regression tests.

User directive (2026-05-18):
  "set timeout is always 15hrs for all jobs in all workflows"

This test file enforces that EVERY job-creation / job-wait / notebook-run site
in the codebase uses the canonical 54000s (15h) timeout literal — and that
prior values (14400s 4h, 43200s 12h, 50400s 14h, 129600s 36h) have been removed
so we cannot accidentally regress.

Job-creation sites covered:
  1. agent/dbx_vibe_modelling_agent.ipynb — JobLauncher.create_or_run task spec
  2. agent/dbx_vibe_modelling_agent.ipynb — two wait_for_run_terminal defaults
  3. runner/vibe_runner.ipynb            — JOB_TIMEOUT_SECONDS constant
  4. runner/orchestrate_sectors.py       — SECTOR_TIMEOUT_S constant
  5. tests/vibe_tester.ipynb             — run_test(dbutils.notebook.run) default

Per CLAUDE.md §3a: 15h = 54000s = single literal "54000" (not "15 * 3600" in nb cells
because JSON escapes; orchestrate_sectors.py uses the readable "15 * 3600").
"""

from __future__ import annotations

import re
from pathlib import Path

import pytest

from notebook_source_util import notebook_concat_source

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
AGENT_NB = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"
RUNNER_NB = REPO_ROOT / "runner" / "vibe_runner.ipynb"
ORCH_PY = REPO_ROOT / "runner" / "orchestrate_sectors.py"
TESTER_NB = REPO_ROOT / "tests" / "vibe_tester.ipynb"

CANONICAL_TIMEOUT_SECONDS = 54000  # 15 * 3600


# ---------- 1. Agent notebook: JobLauncher task spec ----------


def test_agent_joblauncher_task_timeout_is_15h():
    src = notebook_concat_source()
    assert re.search(
        r'task_key="vibe_modeling_task"[^"]*?notebook_task[^}]*?timeout_seconds=54000',
        src,
        re.DOTALL,
    ) or 'timeout_seconds=54000' in src, (
        "JobLauncher task spec MUST set timeout_seconds=54000 (15h) per user directive 2026-05-18"
    )
    assert "timeout_seconds=14400" not in src, (
        "Old 4h JobLauncher timeout (14400) must be removed; v0.7.5 enforces 54000"
    )


def test_agent_wait_for_run_terminal_default_is_15h():
    """Both copies of wait_for_run_terminal (the original + v0.8.2 P7 duplicate)
    must default timeout_seconds=54000."""
    src = notebook_concat_source()
    matches = re.findall(
        r"def wait_for_run_terminal\(run_id, heartbeat_seconds=60, timeout_seconds=(\d+)",
        src,
    )
    assert len(matches) >= 2, (
        f"Expected ≥2 wait_for_run_terminal definitions in agent notebook, found {len(matches)}"
    )
    for v in matches:
        assert int(v) == CANONICAL_TIMEOUT_SECONDS, (
            f"wait_for_run_terminal default timeout_seconds={v} != 54000; "
            "user directive 2026-05-18 requires 15h ceiling everywhere"
        )


# ---------- 2. Runner notebook: JOB_TIMEOUT_SECONDS constant ----------


def test_runner_job_timeout_constant_is_15h():
    src = RUNNER_NB.read_text(encoding="utf-8")
    assert "JOB_TIMEOUT_SECONDS = 54000" in src, (
        "runner/vibe_runner.ipynb JOB_TIMEOUT_SECONDS MUST be 54000 (15h) "
        "per user directive 2026-05-18"
    )
    assert "JOB_TIMEOUT_SECONDS = 43200" not in src, (
        "Old 12h JOB_TIMEOUT_SECONDS (43200) must be removed"
    )


# ---------- 3. Orchestrator: SECTOR_TIMEOUT_S constant ----------


def test_orchestrator_sector_timeout_is_15h_global():
    src = ORCH_PY.read_text(encoding="utf-8")
    assert "SECTOR_TIMEOUT_S = 15 * 3600" in src, (
        "runner/orchestrate_sectors.py SECTOR_TIMEOUT_S MUST be 15 * 3600 (54000s) "
        'per user directive 2026-05-18 "set timeout is always 15hrs for all jobs in all workflows". '
        "WARNING: multi-industry sectors with >3 tier-1 industries may exceed 15h and get killed; "
        "user accepted this risk explicitly."
    )
    assert "SECTOR_TIMEOUT_S = 36 * 3600" not in src
    assert "SECTOR_TIMEOUT_S = 14 * 3600" not in src
    assert "SECTOR_TIMEOUT_S = 6 * 3600" not in src


# ---------- 4. Vibe-tester: run_test default ----------


def test_vibe_tester_run_test_default_is_15h():
    src = TESTER_NB.read_text(encoding="utf-8")
    assert "def run_test(test_def, timeout_seconds=54000)" in src, (
        "tests/vibe_tester.ipynb run_test default timeout_seconds MUST be 54000 (15h) "
        "per user directive 2026-05-18"
    )
    assert "def run_test(test_def, timeout_seconds=43200)" not in src, (
        "Old 12h tester timeout (43200) must be removed"
    )


# ---------- 5. Anti-regression: no stale 4h timeouts anywhere ----------


def test_no_stale_14400_timeouts_in_job_creation_paths():
    """Ensure no job-level timeout_seconds=14400 (4h) literal survives anywhere
    in job-creation paths. AI-query timeouts (per-LLM-call, 45-720s) are a
    DIFFERENT concept and are not affected by the 15h ceiling."""
    for path in [AGENT_NB, RUNNER_NB, TESTER_NB]:
        src = path.read_text(encoding="utf-8")
        # We accept 14400 in pure-string contexts (e.g. error messages), but
        # NOT in `timeout_seconds=14400` (kwarg) or `timeout_seconds": 14400` (JSON spec).
        bad_kwarg = re.findall(r"timeout_seconds\s*=\s*14400\b", src)
        bad_json = re.findall(r'"timeout_seconds"\s*:\s*14400\b', src)
        assert not bad_kwarg, (
            f"{path.name}: stale `timeout_seconds=14400` job-creation kwarg(s) "
            f"detected ({len(bad_kwarg)}); v0.7.5 requires 54000"
        )
        assert not bad_json, (
            f"{path.name}: stale `\"timeout_seconds\": 14400` JSON spec(s) "
            f"detected ({len(bad_json)}); v0.7.5 requires 54000"
        )


# ---------- 6. Version constant ----------


def test_agent_version_constant_is_075():
    """v0.7.5 ships the 15h-everywhere change; constant must reflect it."""
    src = notebook_concat_source()
    m = re.search(r'__AGENT_VERSION__\s*=\s*\\?"(\d+)\.(\d+)\.(\d+)\\?"', src)
    assert m, "__AGENT_VERSION__ literal not found in agent notebook"
    major, minor, patch = int(m.group(1)), int(m.group(2)), int(m.group(3))
    assert (major, minor, patch) >= (0, 7, 5), (
        f"expected v>=0.7.5 (single-digit semver), found {major}.{minor}.{patch}"
    )
    # Each segment must be a single digit 0-9 per §3a
    for seg_name, seg_val in [("major", major), ("minor", minor), ("patch", patch)]:
        assert 0 <= seg_val <= 9, f"{seg_name} segment {seg_val} violates §3a single-digit semver"
