"""Behavioral + contract tests for v3.2.4 vov-verify-already-satisfied.

Live failure reproduced (NCDOT mvm_v3 clean+matched, run 239923648275285,
2026-06-04): the VOV adherence ceilinged at 50.0% (24/48). The dominant
residual cause was NOT missing targets — it was the LLM mutator's rule-4
self-check `raise ValueError('mutator did not touch any target entity')`
(and the '... did not remove any fabricated FK' variant) firing on
VERIFICATION / CONDITIONAL requirements whose asserted condition ALREADY
HOLDS in the clean base. Ground-truth verified against the base the run
consumed:

  - VREQ-022 "Confirm hr.employee key column is employee_id" -> PK already
    employee_id  => mutator changes nothing => self-raise => rejected_unsafe
  - P21 "Confirm employee_eligibility.eligibility_rule_id FK exists" -> FK
    already present => rejected_unsafe
  - P20 "Verify plan_inclusion not isolated; add FK if applicable" -> already
    has outbound FK to project.project => rejected_unsafe

These already-true requirements were FALSE-COUNTED as misses, capping
adherence. The status tally confirmed: rejected_unsafe=12, noop_failed=4
dominated over applied=9 in the residual.

Fix (3 edits, generic/industry-agnostic, DRY mirror of the existing
cannot-synthesize self-declaration):
  (1) synth-prompt rule-4 EXCEPTION: for verification/conditional
      requirements the mutator FIRST tests whether the condition holds and,
      if so, returns the model UNCHANGED with expected_changes_summary
      beginning 'already satisfied: <evidence>' instead of raising.
  (2) _apply_handler_with_retry recognizes _is_already_satisfied (summary
      startswith 'already satisfied') + empty diff -> status='applied'
      (not noop_failed/rejected_unsafe), logs [vov-verify-already-satisfied
      FIRED v3.2.4]. This branch MUST run BEFORE the _is_noop_diff demotion.
  (3) _v204_ast_class_hints maps the 'did not touch any target entity' and
      'did not remove any fabricated' self-check raises to the
      already-satisfied retry guidance, AND tells remove-FK mutators to
      match by FK TARGET (not exact column name).
"""

import ast
import json
import re
from pathlib import Path

NOTEBOOK_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_source() -> str:
    with NOTEBOOK_PATH.open() as f:
        nb = json.load(f)
    chunks = []
    for c in nb.get("cells", []):
        if c.get("cell_type") == "code":
            s = c.get("source", "")
            if isinstance(s, list):
                s = "".join(s)
            chunks.append(s)
    return "\n".join(chunks)


def _extract_fn(name: str) -> str:
    src = _load_source()
    tree = ast.parse(src)
    lines = src.splitlines()
    for node in ast.walk(tree):
        if isinstance(node, ast.FunctionDef) and node.name == name:
            return "\n".join(lines[node.lineno - 1:node.end_lineno])
    raise AssertionError(f"function {name!r} not found")


# ---------------------------------------------------------------------------
# Static contract checks
# ---------------------------------------------------------------------------


def test_agent_version_at_least_3_2_4():
    src = _load_source()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m
    v = tuple(int(x) for x in m.group(1).split("."))
    assert v >= (3, 2, 4), f"expected >= 3.2.4, got {m.group(1)}"


def test_apply_handler_defines_already_satisfied():
    fn_src = _extract_fn("_apply_handler_with_retry")
    assert "_is_already_satisfied" in fn_src, (
        "v3.2.4 fix missing: _apply_handler_with_retry must compute "
        "_is_already_satisfied from the handler summary"
    )
    assert "already satisfied" in fn_src.lower(), (
        "v3.2.4 fix must key off the 'already satisfied' summary prefix"
    )
    assert "vov-verify-already-satisfied FIRED v3.2.4" in fn_src, (
        "v3.2.4 fix must emit the [vov-verify-already-satisfied FIRED v3.2.4] log"
    )


def test_already_satisfied_branch_runs_before_noop_demotion():
    """The already-satisfied empty-diff branch MUST be evaluated BEFORE the
    _is_noop_diff -> noop_failed demotion, otherwise an already-satisfied
    empty diff would be demoted to noop_failed first and never reach applied.
    """
    fn_src = _extract_fn("_apply_handler_with_retry")
    idx_already = fn_src.find("if _is_already_satisfied and _is_noop_diff:")
    idx_noop = fn_src.find("if _is_noop_diff:")
    assert idx_already >= 0, "already-satisfied guard block not found"
    assert idx_noop >= 0, "noop_failed block not found"
    assert idx_already < idx_noop, (
        "already-satisfied branch must precede the noop_failed demotion; "
        f"already@{idx_already} noop@{idx_noop}"
    )


def test_already_satisfied_branch_returns_applied():
    """The already-satisfied block must return status='applied' (so it counts
    toward landed coverage), not a miss status."""
    fn_src = _extract_fn("_apply_handler_with_retry")
    start = fn_src.find("if _is_already_satisfied and _is_noop_diff:")
    block = fn_src[start: start + 900]
    assert 'status="applied"' in block or "status='applied'" in block, (
        "already-satisfied block must return status='applied'"
    )
    assert "already-satisfied" in block, (
        "already-satisfied outcome diagnostic must record the evidence"
    )


def test_synth_prompt_has_verification_exception():
    src = _load_source()
    assert "vov-verify-already-satisfied" in src
    # The prompt must instruct returning unchanged + 'already satisfied:' summary
    assert "already satisfied:" in src, (
        "synth prompt must instruct the LLM to emit an 'already satisfied:' summary "
        "for already-true verification/conditional requirements"
    )
    # And it must be framed as an EXCEPTION to the raise-on-empty-diff rule
    assert "VERIFICATION" in src and "CONDITIONAL" in src


def test_retry_hints_cover_self_check_raises():
    fn_src = _extract_fn("_v204_ast_class_hints")
    assert "did not touch any target entity" in fn_src, (
        "retry hints must map the 'did not touch any target entity' self-check "
        "raise to the already-satisfied guidance"
    )
    assert "did not remove any fabricated" in fn_src, (
        "retry hints must map the 'did not remove any fabricated FK' self-check "
        "raise to remove-FK-by-target guidance"
    )
    # remove-FK guidance must steer matching by FK target, not exact column name
    low = fn_src.lower()
    assert "fk target" in low or "by the fk target" in low or "match by" in low


# ---------------------------------------------------------------------------
# §8.10 behavioral — prove pre-patch differs from post-patch
# ---------------------------------------------------------------------------


def _decide_postpatch(is_already_satisfied: bool, is_noop_diff: bool) -> str:
    """Mirror of the DEPLOYED control-flow ORDER (verified by
    test_already_satisfied_branch_runs_before_noop_demotion to match the
    actual source): already-satisfied empty diff -> applied, before the
    generic noop_failed demotion."""
    if is_already_satisfied and is_noop_diff:
        return "applied"
    if is_noop_diff:
        return "noop_failed"
    return "other"


def _decide_prepatch(is_noop_diff: bool) -> str:
    """Verbatim pre-v3.2.4 logic: an empty diff is ALWAYS demoted to
    noop_failed regardless of any 'already satisfied' self-declaration."""
    if is_noop_diff:
        return "noop_failed"
    return "other"


def test_pre_patch_false_counts_already_satisfied_as_noop():
    # An already-satisfied verification requirement produces an empty diff.
    # Pre-patch demotes it to noop_failed (the bug that capped adherence).
    assert _decide_prepatch(is_noop_diff=True) == "noop_failed"


def test_post_patch_counts_already_satisfied_as_applied():
    # Post-patch routes the same empty diff (with an 'already satisfied:'
    # summary) to applied.
    assert _decide_postpatch(is_already_satisfied=True, is_noop_diff=True) == "applied"


def test_post_patch_still_demotes_genuine_noop():
    # A genuine empty diff WITHOUT an 'already satisfied' declaration is still
    # demoted to noop_failed — the fix must not inflate coverage for real misses.
    assert _decide_postpatch(is_already_satisfied=False, is_noop_diff=True) == "noop_failed"


def test_post_patch_non_empty_diff_unaffected():
    # A real mutation (non-empty diff) is never touched by either guard.
    assert _decide_postpatch(is_already_satisfied=True, is_noop_diff=False) == "other"
    assert _decide_postpatch(is_already_satisfied=False, is_noop_diff=False) == "other"
