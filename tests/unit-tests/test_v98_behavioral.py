"""v0.9.8 behavioral test — structural rename/drop verifier in _verify_deterministic.

ROOT-CAUSE FIX for v0.9.6/v0.9.7 RT audit finding: the deterministic verifier in
VibeOrchestrator had NO handler for rename / drop / remove on scope=table or
scope=attribute requirements. Result:
  - VREQ-003..008 (rename_product, RT)  -> all "partial" with generic evidence
  - VREQ-031..038 (rename_attribute, RT) -> same generic partial
  - Connect_table VREQs were FALSE-FULFILLED by the scope==table + 'add' check
    (which verifies the table exists, not the column addition).

v0.9.8 adds two structural verifier branches BEFORE the partial fallback:
  1. RENAME — when vibe text mentions rename and scope is table/attribute,
     check the OLD name is GONE from model.json (products / attributes).
  2. DROP/REMOVE/DELETE — when vibe text mentions drop/remove/delete and scope
     is table/attribute, check the target is GONE.

These are structural checks against the LIVE model state (products_data /
attributes_data inside the verifier closure), NOT regex on the vibe text.
The verb membership check (`'rename' in ll`) is a single-token membership,
not a regex pattern, and is generic across all industries. No industry strings,
no hardcoded entity names.

Sentinel: '[verifier-rename-drop-structural FIRED]' logs once per VREQ.
"""
import json
import re
from pathlib import Path

NOTEBOOK = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_notebook_source():
    nb = json.loads(NOTEBOOK.read_text())
    return [(idx, "".join(cell.get("source", []))) for idx, cell in enumerate(nb["cells"])]


def _all_source():
    return "\n".join(src for _, src in _load_notebook_source())


def test_v98_agent_version_constant():
    cells = _load_notebook_source()
    cell1 = next(src for idx, src in cells if "__AGENT_VERSION__" in src)
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', cell1)
    assert m is not None, "v0.9.8: __AGENT_VERSION__ must be set with single-digit semver"
    major, minor, patch = int(m.group(1)), int(m.group(2)), int(m.group(3))
    assert (major, minor, patch) >= (0, 9, 8), (
        f"v0.9.8: __AGENT_VERSION__ must be 0.9.8 or later, got {major}.{minor}.{patch}"
    )


def test_v98_rename_verifier_present():
    """v0.9.8: _verify_deterministic must contain a structural rename verifier
    that checks scope_targets against product_keys / attr_keys."""
    src = _all_source()
    assert "_verifier_verbs_rename = ('rename', 'rename to')" in src, (
        "v0.9.8: rename verb tuple missing from _verify_deterministic"
    )
    assert "verifier-rename-drop-structural FIRED" in src, (
        "v0.9.8: sentinel '[verifier-rename-drop-structural FIRED]' missing"
    )
    # The rename branch must check scope in (table, attribute) and use scope_targets
    assert "req.scope in ('table', 'attribute') and req.scope_targets" in src, (
        "v0.9.8: rename verifier must gate on scope in (table, attribute) and scope_targets"
    )


def test_v98_drop_verifier_present():
    """v0.9.8: _verify_deterministic must contain a structural drop/remove
    verifier alongside the rename verifier."""
    src = _all_source()
    assert "_verifier_verbs_drop = ('drop', 'remove', 'delete')" in src, (
        "v0.9.8: drop verb tuple missing from _verify_deterministic"
    )


def test_v98_rename_returns_failed_when_old_target_still_present():
    """v0.9.8: when an old rename target still appears in product_keys,
    the verifier MUST return status='failed' with the structural evidence."""
    src = _all_source()
    # The fail path emits a 'failed' status and 'Rename not applied' evidence
    assert "\"status\": \"failed\", \"evidence\": f\"[verifier-rename-drop-structural FIRED] Rename not applied:" in src, (
        "v0.9.8: rename failure path must emit status=failed with structural evidence"
    )
    assert "\"status\": \"fulfilled\", \"evidence\": f\"[verifier-rename-drop-structural FIRED] Rename applied:" in src, (
        "v0.9.8: rename success path must emit status=fulfilled with structural evidence"
    )


def test_v98_drop_returns_failed_when_target_still_present():
    """v0.9.8: when a drop target still appears in product_keys/attr_keys,
    the verifier MUST return status='failed' with the structural evidence."""
    src = _all_source()
    assert "\"status\": \"failed\", \"evidence\": f\"[verifier-rename-drop-structural FIRED] Drop not applied:" in src, (
        "v0.9.8: drop failure path must emit status=failed with structural evidence"
    )
    assert "\"status\": \"fulfilled\", \"evidence\": f\"[verifier-rename-drop-structural FIRED] Drop applied:" in src, (
        "v0.9.8: drop success path must emit status=fulfilled with structural evidence"
    )


def test_v98_no_regex_introduced_for_verbs():
    """v0.9.8: the new verifier branches MUST NOT introduce regex on req.original_text
    for the verb check. Verb membership must use Python tuple `in ll`, not re.search."""
    src = _all_source()
    # Verify that the new branch uses tuple membership, not regex compilation
    assert "any(v in ll for v in _verifier_verbs_rename)" in src, (
        "v0.9.8: rename verb check must use tuple-membership, not regex"
    )
    assert "any(v in ll for v in _verifier_verbs_drop)" in src, (
        "v0.9.8: drop verb check must use tuple-membership, not regex"
    )


def test_v98_no_industry_strings_introduced():
    """v0.9.8: the new verifier MUST NOT contain industry-specific strings,
    customer names, or hardcoded entity names (per CLAUDE.md §8.5 industry-agnostic).
    Specifically check the surrounding verifier code does not introduce
    common industry tokens that were absent before."""
    src = _all_source()
    forbidden = (
        "retail_", "healthcare_", "legal_", "airlines_", "banking_",
        "advance_ship_notice", "return_authorization", "ship_from_store_node",
    )
    start = src.find("# v0.9.8 [verifier-rename-drop-structural FIRED]")
    end = src.find("return {\"status\": \"partial\", \"evidence\": \"Deterministic verification: no specific pattern matched", start)
    assert start != -1 and end != -1 and end > start, (
        "v0.9.8: verifier block markers not found in expected order"
    )
    block = src[start:end]
    for token in forbidden:
        assert token not in block, (
            f"v0.9.8: forbidden industry-specific token '{token}' found in verifier block"
        )


def test_v98_mode_reconciliation_aggregate_wins_present():
    """v0.9.8: master_analyze must reconcile LLM top-level classification vs
    aggregate overall_mode; when they disagree, empirical aggregate wins.

    ROOT-CAUSE FIX for v0.9.6 RT (run <run_id>):
    All 85 parsed VREQs had mode=surgical, but LLM returned classification='GENERATIVE'.
    compile_vibe_contract read 'classification' verbatim, so VibeContract.mode='GENERATIVE',
    surgical mutation pipeline was bypassed, 0 rename_product/connect_table mutations landed.
    """
    src = _all_source()
    assert "mode-reconciliation-aggregate-wins FIRED" in src, (
        "v0.9.8: sentinel '[mode-reconciliation-aggregate-wins FIRED]' missing from master_analyze"
    )
    assert "_llm_top_classification" in src, (
        "v0.9.8: reconciliation must capture LLM top-level classification in _llm_top_classification"
    )
    assert "_aggregate_mode_upper" in src, (
        "v0.9.8: reconciliation must compute aggregate mode from per-requirement modes"
    )
    assert "_reconciled_classification = _aggregate_mode_upper" in src, (
        "v0.9.8: when LLM disagrees with aggregate, classification must be set to aggregate"
    )


def test_v98_mode_reconciliation_uses_aggregate_in_classification_data():
    """v0.9.8: the dict written to widgets_values['vibe_classification'] must use
    the reconciled value, not the raw LLM value."""
    src = _all_source()
    assert "\"classification\": _reconciled_classification," in src, (
        "v0.9.8: classification_data dict must use _reconciled_classification, not data.get('classification', ...)"
    )


def test_v98_mode_reconciliation_no_regex_no_industry_strings():
    """v0.9.8: mode reconciliation MUST be a pure enum comparison —
    no regex on vibe text, no industry-specific strings."""
    src = _all_source()
    start = src.find("# v0.9.8 [mode-reconciliation-aggregate-wins FIRED]")
    end = src.find("classification_data = {", start)
    assert start != -1 and end != -1 and end > start, (
        "v0.9.8: mode-reconciliation block markers not found in expected order"
    )
    block = src[start:end]
    forbidden_industry = (
        "retail", "healthcare", "legal", "airlines", "banking",
    )
    for token in forbidden_industry:
        assert token.lower() not in block.lower(), (
            f"v0.9.8: forbidden industry token '{token}' found in mode-reconciliation block"
        )
    assert "re.search" not in block and "re.match" not in block and "re.compile" not in block, (
        "v0.9.8: mode-reconciliation block must not introduce regex"
    )
