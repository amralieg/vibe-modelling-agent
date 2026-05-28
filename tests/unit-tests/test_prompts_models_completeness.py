"""prompts_models completeness invariant — every prompt defined in code MUST be
registered in the widget config so users can see / route every prompt.

This is the behavioral guard for the v0.7.1 audit finding: 10 prompts (vov-2.0
SYSTEM prompts, _SELFFIXER_PROMPT, and 4 PROMPT_TEMPLATES gate prompts) were
defined in code but absent from the prompts_models widget config, meaning the
user could not see them, could not route them via widget, and the widget UI
gave a misleading inventory.

Per CLAUDE.md §8.10 this test runs against the production code path (no stub).
"""
from __future__ import annotations

import json
import re
from pathlib import Path

import pytest

NB_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


@pytest.fixture(scope="module")
def all_src() -> str:
    nb = json.loads(NB_PATH.read_text())
    chunks = []
    for c in nb["cells"]:
        s = c.get("source", "")
        if isinstance(s, list):
            s = "".join(s)
        chunks.append(s)
    return "\n".join(chunks)


def _prompts_models_names(all_src: str) -> set[str]:
    return set(re.findall(r'"prompt_name":\s*"([A-Za-z_][A-Za-z0-9_]*_PROMPT)"', all_src))


def _top_level_prompt_vars(all_src: str) -> set[str]:
    return set(re.findall(r'^([A-Z_][A-Z0-9_]*_PROMPT)\s*=\s*[fr]?"""', all_src, re.MULTILINE))


def _prompt_templates_keys(all_src: str) -> set[str]:
    return set(re.findall(r'PROMPT_TEMPLATES\[\s*"([A-Za-z_][A-Za-z0-9_]*_PROMPT)"\s*\]\s*=', all_src))


def test_prompts_models_covers_all_top_level_prompt_vars(all_src):
    declared = _prompts_models_names(all_src)
    actual = _top_level_prompt_vars(all_src)
    missing = actual - declared
    assert not missing, (
        f"Top-level *_PROMPT variables are defined in the notebook but not registered in "
        f"prompts_models widget config. Add them so the widget UI shows the full inventory:\n"
        f"  {sorted(missing)}"
    )


def test_prompts_models_covers_all_prompt_templates_keys(all_src):
    declared = _prompts_models_names(all_src)
    actual = _prompt_templates_keys(all_src)
    missing = actual - declared
    assert not missing, (
        f"PROMPT_TEMPLATES[...] entries are defined in the notebook but not registered in "
        f"prompts_models widget config:\n  {sorted(missing)}"
    )


def test_prompts_models_no_phantom_entries(all_src):
    """Reverse: every prompts_models entry should match a real definition (top-level
    var, PROMPT_TEMPLATES key, or be a known historical reserved name). Catches typos."""
    declared = _prompts_models_names(all_src)
    real = _top_level_prompt_vars(all_src) | _prompt_templates_keys(all_src)
    phantom = declared - real
    assert not phantom, (
        f"prompts_models entries reference prompts that are NOT defined in the notebook "
        f"(typo or stale entry):\n  {sorted(phantom)}"
    )


def test_prompts_models_minimum_count_v240(all_src):
    """v0.7.1 audit raised the floor from 51 to 61. Lock the new floor so a future
    PR cannot silently remove entries."""
    declared = _prompts_models_names(all_src)
    assert len(declared) >= 61, (
        f"prompts_models has only {len(declared)} entries; v0.7.1 baseline is 61. "
        f"If you deleted prompts intentionally, lower this floor in the same commit."
    )


def test_prompts_models_v240_required_names_present(all_src):
    """The 10 specific prompts added by the v0.7.1 audit MUST stay registered."""
    required = {
        "BATCHING_SYSTEM_PROMPT",
        "DEDUPE_MERGE_PROMPT",
        "EXTRACTION_SYSTEM_PROMPT",
        "OUTLINE_SYSTEM_PROMPT",
        "SYNTHESIS_SYSTEM_PROMPT",
        "_SELFFIXER_PROMPT",
        "FK_EDGE_SYNTHESIS_PROMPT",
        "FK_SEMANTIC_CORRECTNESS_GATE_PROMPT",
        "PROCESS_FLOW_FK_GATE_PROMPT",
        "SSOT_BLOCK_GATE_PROMPT",
    }
    declared = _prompts_models_names(all_src)
    missing = required - declared
    assert not missing, (
        f"v0.7.1 required prompts removed from prompts_models:\n  {sorted(missing)}"
    )


def test_prompts_models_entries_have_required_fields(all_src):
    """Every entry must have prompt_name, type, size, temperature, prompt_operations."""
    nb = json.loads(NB_PATH.read_text())
    entries_text = ""
    for c in nb["cells"]:
        s = c.get("source", "")
        if isinstance(s, list):
            s = "".join(s)
        if '"prompts_models"' in s:
            entries_text = s
            break
    assert entries_text, "Did not find prompts_models block in notebook cells"

    pattern = re.compile(
        r'\{\s*"prompt_name":\s*"([A-Za-z_][A-Za-z0-9_]*_PROMPT)"[^}]*\}'
    )
    for m in pattern.finditer(entries_text):
        entry = m.group(0)
        name = m.group(1)
        for field in ("type", "size", "temperature", "prompt_operations"):
            assert f'"{field}"' in entry, f"prompts_models entry '{name}' is missing field '{field}': {entry[:200]}"
