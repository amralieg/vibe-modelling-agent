"""v3.2.3 behavioral tests.

Root-cause fix for the ~36% VOV adherence ceiling + serial slowness observed on the
NCDOT mvm_v3 ground-truth run (2026-06-04: 26/72 landed = 36.1%, 59 zero-target synth
calls, slip parse-failed=23).

Root cause: in synthesize_handler, batches whose target_entities resolve to an EMPTY set
(cross-cutting / bulk directives, or VREQ text that names no concrete domain.product) were
handed TARGET_ENTITIES_FULL=[] while the system prompt's rule-4 "verify-before-return over
target_entities" loop iterated an EMPTY list -> the LLM-generated mutator's own
`raise ValueError('mutator did not touch any target entity')` fired on every attempt ->
3 failed retries -> rejected_unsafe. Guaranteed 0% landing for that whole class.

(F4) vov-blind-batch-nonempty-contract: when _tgt_pairs and _tgt_domains are both empty,
the synth prompt switches that batch to a NON-EMPTY-DIFF success contract and overrides
rule-4 for that batch only.

Tests EXECUTE the real inserted code block (extracted from notebook source) with controlled
locals so they prove observable behavior, not just code shape (CLAUDE.md §8.10), and also
prove the pre-patch path would have failed (§8.3 anti-tautology).
"""
import json
import os
import re
import textwrap

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_src():
    nb = json.load(open(NB))
    return "".join("".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code")


def _extract_f4_block(full):
    """Extract the exact F4 code lines from synthesize_handler source."""
    start_marker = "_is_blind_batch = (not _tgt_pairs)"
    si = full.index(start_marker)
    # back up to the start of that line
    line_start = full.rfind("\n", 0, si) + 1
    # end at the `pass` that closes the F4 logging try/except (first `pass` after the FIRED log)
    fired = full.index("vov-blind-batch-nonempty-contract FIRED v3.2.3", si)
    pass_i = full.index("pass", fired)
    line_end = full.index("\n", pass_i) + 1
    return textwrap.dedent(full[line_start:line_end])


class _Batch:
    batch_id = "B0042"
    vreq_ids = ("VREQ-018", "VREQ-019", "VREQ-020", "VREQ-021")


def _run_block(tgt_pairs, tgt_domains):
    block = _extract_f4_block(_load_src())
    ns = {
        "_tgt_pairs": tgt_pairs,
        "_tgt_domains": tgt_domains,
        "user": "",
        "batch": _Batch(),
    }
    exec(block, ns)
    return ns["user"], ns.get("_is_blind_batch")


# ---------- F4: blind-batch non-empty-diff contract ----------

def test_blind_batch_gets_crosscutting_contract():
    """Empty targets -> batch flagged blind AND cross-cutting contract injected into prompt."""
    user, is_blind = _run_block(set(), set())
    assert is_blind is True
    assert "CROSS-CUTTING DIRECTIVE" in user
    # the contract MUST override rule-4 and forbid the impossible empty-target raise
    assert "OVERRIDE system rule 4" in user
    assert "NON-EMPTY diff IS success" in user
    assert "mutator did not touch any target entity" in user  # named only to forbid it
    assert "Do NOT emit" in user


def test_targeted_pair_batch_keeps_strict_contract():
    """A concrete (domain,product) target -> NOT blind -> NO cross-cutting override."""
    user, is_blind = _run_block({("project", "data_value")}, set())
    assert is_blind is False
    assert "CROSS-CUTTING DIRECTIVE" not in user
    assert user == ""  # block appends nothing when not blind


def test_domain_only_target_keeps_strict_contract():
    """A domain-level target (no pairs) is still NOT blind -> no override."""
    user, is_blind = _run_block(set(), {"project"})
    assert is_blind is False
    assert "CROSS-CUTTING DIRECTIVE" not in user


def test_contract_uses_changed_counter_not_target_loop():
    """The cross-cutting contract must instruct a _changed counter + empty-diff raise,
    NOT the target-entity loop that guarantees failure on blind batches."""
    user, _ = _run_block(set(), set())
    assert "_changed" in user
    assert "cross-cutting mutator produced empty diff" in user


# ---------- pre-patch proof (§8.3 anti-tautology) ----------

def test_block_is_actually_wired_not_dead_code():
    """The F4 block must live INSIDE synthesize_handler, immediately before the
    TARGET_ENTITIES_FULL prompt assembly (proves it runs on the real synth path,
    not an orphan helper)."""
    full = _load_src()
    sh = full.index("def synthesize_handler")
    blk = full.index("_is_blind_batch = (not _tgt_pairs)")
    tgt = full.index("TARGET_ENTITIES_FULL (the EXACT")
    assert sh < blk < tgt, "F4 block must be inside synthesize_handler before TARGET_ENTITIES_FULL"
    # and the strict assembly that follows must be the rule-4 prompt we are overriding
    between = full[blk:tgt]
    assert "user += (" in between


def test_agent_version_is_at_least_323():
    full = _load_src()
    m = re.search(r'__AGENT_VERSION__ = "([0-9]+)\.([0-9]+)\.([0-9]+)"', full)
    assert m, "version constant not found"
    maj, mino, pat = int(m.group(1)), int(m.group(2)), int(m.group(3))
    assert (maj, mino, pat) >= (3, 2, 3), f"expected >=3.2.3, got {maj}.{mino}.{pat}"


def test_fired_log_present_for_grep_audit():
    """A [<alias> FIRED] emission site must exist for the live-run grep audit (§10.7)."""
    full = _load_src()
    assert "[vov-blind-batch-nonempty-contract FIRED v3.2.3]" in full
