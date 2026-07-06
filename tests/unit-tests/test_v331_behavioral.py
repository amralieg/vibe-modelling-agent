"""v3.3.1 — verifier snapshot full-inventory fix (alias=verifier-snapshot-full-inventory).

ROOT CAUSE (live gov_transport run <run_id>, 2026-06-05): the per-VREQ LLM verifier
(_verify_via_llm) serialized the ENTIRE model attribute-by-attribute into one snapshot
hard-capped at 150K chars. On wide models (gov_transport: 77 products / 3448 attrs) the cap was
reached mid-model, eliding whole domains off the end. The LLM then saw "project domain
contains zero products" (actual 33) and "hr contains 30 products" (actual 50), marked
~25 VREQs falsely FAILED, crashed precision to 22.6%, and drove the SelfFixer to RECREATE
products that already existed.

The fix prepends an untruncatable domain->product inventory (names + counts) so existence
can never be falsely concluded from attribute-budget truncation.

These tests:
  1. extract the EXACT inventory-building block from the deployed notebook source and run
     it against a wide model that would overflow the detail-snapshot budget, asserting the
     full per-domain roster is surfaced; and
  2. assert the verifier prompt carries the AUTHORITATIVE-EXISTENCE rule and the version
     constant is 3.3.1.

The block did not exist pre-patch, so test 1 fails on pre-patch HEAD (no tautology).
"""
import json
import os

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_src():
    nb = json.load(open(NB))
    return "".join("".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code")


def _slice(src, start, end):
    i = src.index(start)
    j = src.index(end, i + len(start))
    return src[i:j]


def _run_inventory_block(products_data):
    """Execute the real, deployed inventory block in isolation."""
    src = _load_src()
    block = _slice(src, "            _v331_inv_by_domain = {}\n",
                   "            # v3.3.2 [verifier-snapshot-metadata")
    import textwrap, types, logging
    block = textwrap.dedent(block)
    _self = types.SimpleNamespace(logger=logging.getLogger("v331test"))
    ns = {"products_data": products_data,
          "_v100_summary_lines": ["# Model snapshot (post-mutation)"],
          "self": _self}
    exec(block, ns, ns)
    return ns["_v100_summary_lines"]


def test_inventory_surfaces_full_roster_on_wide_model():
    # 50 hr + 33 project products — mirrors the live gov_transport shape that overflowed the cap.
    products = ([{"domain": "hr", "product": f"h{i}"} for i in range(50)]
                + [{"domain": "project", "product": f"p{i}"} for i in range(33)])
    lines = _run_inventory_block(products)
    inv = [l for l in lines if l.startswith("- domain")]
    assert any("domain 'project': 33 products" in l for l in inv), f"project roster missing: {inv}"
    assert any("domain 'hr': 50 products" in l for l in inv), f"hr roster missing: {inv}"
    # The inventory is placed BEFORE the detail section so it survives the 150K truncation.
    assert "FULL MODEL INVENTORY" in "\n".join(lines)


def test_inventory_survives_detail_truncation():
    # Simulate the real truncation: even if the detail section is cut at 150K, the inventory
    # (emitted first) is preserved, so existence is never falsely zeroed.
    products = [{"domain": "project", "product": f"p{i}"} for i in range(33)]
    lines = _run_inventory_block(products)
    snapshot = "\n".join(lines) + "\n" + ("x" * 200000)  # huge detail tail
    truncated = snapshot[:150000] + "\n... (snapshot truncated)"
    assert "domain 'project': 33 products" in truncated, "inventory lost to truncation — fix ineffective"


def test_authoritative_existence_rule_in_prompt():
    src = _load_src()
    assert "FULL MODEL INVENTORY" in src
    assert "AUTHORITATIVE EXISTENCE" in src
    assert "verifier-snapshot-full-inventory" in src


def test_version_is_current():
    # version monotonically advances; v331 fix (inventory) must remain present at/after 3.3.1
    src = _load_src()
    assert "verifier-snapshot-full-inventory" in src
    import re
    ver = re.search(r'__AGENT_VERSION__ = "([\d.]+)"', src).group(1)
    assert tuple(int(x) for x in ver.split(".")) >= (3, 3, 1), ver
