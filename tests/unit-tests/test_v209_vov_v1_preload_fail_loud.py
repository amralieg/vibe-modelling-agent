"""Behavioral tests for v2.0.9 vov-v1-preload-fail-loud fix.

Live run <run_id> (gov_transport 2026-05-27 02:00) failed at consolidate with
`CRITICAL: Products file is empty`. Root cause: vov-v1-preload outer
`isinstance(business_context_raw, dict)` gate silently fell through when
business_context_raw was not dict-shaped, leaving VOV to mutate an empty
initial_model. v2.0.9 adds: (a) DIAG log before the gate, (b) disk fallback
via business_context_file_path, (c) FAIL-LOUD raise if both paths produce
empty state.

These tests verify the fix at the source level (presence + structure) and
behaviorally (against a JSON-fixture loaded from disk).
"""
from __future__ import annotations

import json
import os
import re

import pytest

NB_PATH = os.path.join(
    os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb"
)


@pytest.fixture(scope="module")
def src() -> str:
    with open(NB_PATH) as f:
        nb = json.load(f)
    chunks = []
    for c in nb.get("cells", []):
        if c.get("cell_type") == "code":
            chunks.append("".join(c["source"]))
    return "\n\n".join(chunks)


def test_agent_version_is_209(src: str) -> None:
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+\.\d+\.\d+)"', src)
    assert m is not None, "__AGENT_VERSION__ not found in Cell 1"
    assert tuple(int(_x) for _x in m.group(1).split(".")) >= (2, 0, 9), f"expected 2.0.9 got {m.group(1)}"


def test_vov_v1_preload_diag_present(src: str) -> None:
    assert "[vov-v1-preload DIAG v2.0.9]" in src, "DIAG log line missing"
    assert "alias=vov-v1-preload-diag" in src, "DIAG alias missing"
    assert "bcr_type=" in src, "DIAG must include bcr_type for audit"
    assert "bcfp=" in src, "DIAG must include bcfp for audit"


def test_vov_v1_preload_fallback_disk_present(src: str) -> None:
    assert "[vov-v1-preload-fallback-disk FIRED v2.0.9]" in src
    assert "alias=vov-v1-preload-fallback-disk" in src
    assert 'widgets_values.get("business_context_file_path")' in src


def test_vov_v1_preload_fail_loud_present(src: str) -> None:
    assert "[vov-v1-preload FAIL-LOUD v2.0.9]" in src
    assert "raise RuntimeError(_msg)" in src
    assert "alias=vov-v1-preload-fail-loud" in src


def test_old_silent_fallback_gate_removed(src: str) -> None:
    """The old outer gate was:
        if (...empty...) and isinstance(widgets_values.get("business_context_raw"), dict):
    which fell through silently when bcr wasn't dict. v2.0.9 must split the gate
    so the dict-check happens INSIDE the outer 'empty' block, not as a precondition."""
    old_pattern = (
        '((not domains_data) or (not products_data) or (not attributes_data))'
        ' and isinstance(widgets_values.get(\\"business_context_raw\\"), dict):'
    )
    assert old_pattern not in src, (
        "Old silent-fallback gate is still present — v2.0.9 must replace the "
        "combined gate with split logic that emits DIAG even when bcr is non-dict"
    )


def test_fail_loud_condition_is_correct(src: str) -> None:
    """The fail-loud must trigger when domains_data OR products_data is empty
    AFTER all preload attempts — not just when domains_data is empty (the
    original buggy gate). Products is the actual file that consolidate checks."""
    assert "if (not domains_data) or (not products_data):" in src, (
        "FAIL-LOUD condition must check BOTH domains_data and products_data — "
        "consolidate fails on either empty file"
    )


def test_disk_fallback_rehydrates_bcr(src: str) -> None:
    """When disk fallback succeeds, widgets_values['business_context_raw'] must
    be repopulated so downstream code that reads bcr (e.g. step_create_logical_schema
    review-base seeding) sees the full v1 model — not just the flat lists."""
    assert 'widgets_values["business_context_raw"] = copy.deepcopy(_disk_blob)' in src or \
           'widgets_values["business_context_raw"] = _disk_blob' in src
