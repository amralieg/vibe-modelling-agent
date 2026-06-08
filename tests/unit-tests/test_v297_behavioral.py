"""Behavioral tests for v2.9.7 root-cause fixes (user audit 2026-06-01).

Each test exercises the REAL production code sliced from the agent notebook
(not a replica) and asserts an OBSERVABLE state change, per CLAUDE.md 8.10.

Fixes under test:
  FIX rc-soft  alias=fmfl-auto-remap        -> canonical-target auto-remap
  FIX rc-mv    alias=mv-skip-system-source  -> drop system/information_schema MVs
  FIX rc-cycle alias=gate-cycle-final-verdict (push_v2.py, tested if present)
"""
import ast
import re
import textwrap
from pathlib import Path

from notebook_source_util import notebook_concat_source

SRC = notebook_concat_source()


def _slice_nested_function(fn_name, source=SRC):
    """Slice a (possibly nested) function def by name and dedent it to top level."""
    lines = source.splitlines(keepends=True)
    tree = ast.parse(source)
    target = None
    for node in ast.walk(tree):
        if isinstance(node, ast.FunctionDef) and node.name == fn_name:
            target = node  # last definition wins
    if target is None:
        raise LookupError(f"nested def {fn_name!r} not found in agent notebook")
    raw = "".join(lines[target.lineno - 1:target.end_lineno])
    return textwrap.dedent(raw)


def _load_nested(fn_name, extra_globals):
    ns = dict(extra_globals)
    exec(compile(_slice_nested_function(fn_name), "agent_notebook", "exec"), ns)
    return ns[fn_name]


# ---------------------------------------------------------------------------
# FIX rc-soft: canonical-target auto-remap  (alias=fmfl-auto-remap)
# ---------------------------------------------------------------------------
def _make_suggest(canonical_entities):
    return _load_nested(
        "_fmfl_suggest_canonical",
        {"pk_suffix": "_id", "_fmfl_canonical_entities": set(canonical_entities)},
    )


def test_suggest_returns_scored_pairs_not_names():
    # v2.9.7 contract change: the function now returns (score, ent) tuples so the
    # caller can auto-remap. Pre-patch HEAD returned bare entity-name strings, so
    # ranked[0][0] would be a character, not an int -> this assertion FAILS on HEAD.
    suggest = _make_suggest({"behavioral_health.cfr42_consent_workflow"})
    ranked = suggest("workflow_id")
    assert ranked, "expected a stem-match candidate"
    top = ranked[0]
    assert isinstance(top, tuple) and len(top) == 2, f"expected (score, ent) tuple, got {top!r}"
    assert isinstance(top[0], int), f"expected int score, got {top[0]!r}"
    assert top[1] == "behavioral_health.cfr42_consent_workflow"
    assert top[0] == 80  # endswith '_workflow'


def _auto_remap_decision(ranked):
    """Replicate the EXACT predicate wired into _validate_fmfl (asserted live below)."""
    if not ranked:
        return None
    ar_top = ranked[0][0]
    ar_tied = [e for s, e in ranked if s == ar_top]
    if ar_top >= 80 and len(ar_tied) == 1:
        return ar_tied[0]
    return None


def test_auto_remap_fires_on_unambiguous_rename():
    # The healthcare 68%->? case: a renamed/consolidated product with a single
    # high-score stem match must be auto-remapped (FK lands instead of dropping).
    suggest = _make_suggest({
        "behavioral_health.cfr42_consent_workflow",
        "patient.patient_record",
        "billing.claim",
    })
    ranked = suggest("workflow_id")
    remap = _auto_remap_decision(ranked)
    assert remap == "behavioral_health.cfr42_consent_workflow", \
        f"expected auto-remap to the unambiguous canonical product, got {remap!r}"


def test_auto_remap_skips_when_ambiguous():
    # NON-tautology guard (CLAUDE.md 8.3): when TWO products tie at the top score,
    # the remap MUST NOT fire (we cannot pick safely) -> falls through to the
    # existing reject+suggest path. Proves the fix is selective, not blanket.
    suggest = _make_suggest({
        "consent.consent_workflow",
        "intake.intake_workflow",
        "patient.patient_record",
    })
    ranked = suggest("workflow_id")
    tied_top = [e for s, e in ranked if s == ranked[0][0]]
    assert len(tied_top) == 2, f"test setup expects a 2-way tie, got {tied_top}"
    assert _auto_remap_decision(ranked) is None, "must NOT auto-remap an ambiguous target"


def test_auto_remap_predicate_is_wired_into_validator():
    # Source-level proof the tested predicate actually runs in production (the
    # inline block lives inside _validate_fmfl, which is too closure-heavy to exec).
    assert "fmfl-auto-remap FIRED" in SRC
    assert "_ar_tied = [e for s, e in _ranked if s == _ar_top]" in SRC
    assert "if _ar_top >= 80 and len(_ar_tied) == 1:" in SRC
    assert "dec['target_table'] = _ar_to" in SRC


# ---------------------------------------------------------------------------
# FIX rc-mv: skip metric views over system/information_schema (alias=mv-skip-system-source)
# ---------------------------------------------------------------------------
def _mv_guard():
    return _load_nested("_mv_targets_system", {"re": re})


def test_mv_guard_drops_system_information_schema():
    guard = _mv_guard()
    assert guard("source: system.information_schema.table_properties") is True
    assert guard("source: `system`.information_schema.columns") is True
    assert guard("FROM system.information_schema.tables") is True


def test_mv_guard_keeps_business_views():
    guard = _mv_guard()
    assert guard("source: bizcat.healthcare.encounter") is False
    # NON-regression (CLAUDE.md 8.3): a business domain literally named `system`
    # (catalog != system) must NOT be dropped.
    assert guard("source: bizcat.system.audit_log") is False


def test_mv_guard_actually_filters_statement_list():
    # Behavioral: the production line `statements = [s for s in statements if not
    # _mv_targets_system(s)]` removes system-sourced MVs. Prove the wiring + effect.
    guard = _mv_guard()
    statements = [
        "source: bizcat.healthcare.encounter",
        "source: system.information_schema.table_properties",
        "source: bizcat.claims.claim_line",
    ]
    kept = [s for s in statements if not guard(s)]
    assert len(kept) == 2
    assert all("information_schema" not in s for s in kept)
    assert "statements = [s for s in statements if not _mv_targets_system(s)]" in SRC
    assert "mv-skip-system-source FIRED" in SRC


# ---------------------------------------------------------------------------
# FIX rc-cycle: gate counts only the timestamp-last cycle verdict (push_v2.py)
# ---------------------------------------------------------------------------
def test_gate_cycle_final_verdict_if_present():
    push = Path("/tmp/fullscale/push_v2.py")
    if not push.exists():
        import pytest
        pytest.skip("push_v2.py runner not present in this environment")
    src = push.read_text(encoding="utf-8")
    if "_final_cycle_count" not in src:
        import pytest
        pytest.skip("gate fix not present in push_v2.py")
    # _final_cycle_count is nested in gate(); slice it from the RUNNER source (not the notebook).
    fn = _load_nested_from("_final_cycle_count", src)
    transient_then_clean = (
        "2026-06-01 02:15:34 - WARNING - [CYCLE DETECTION] Found 5 cycle(s) in FK relationships:\n"
        "2026-06-01 02:17:59 - INFO - [CYCLE DETECTION] No cycles detected in FK relationships\n"
    )
    real_residual = (
        "2026-06-01 02:10:00 - INFO - [CYCLE DETECTION] No cycles detected\n"
        "2026-06-01 02:20:00 - WARNING - [CYCLE DETECTION] Found 3 cycle(s) in FK relationships:\n"
    )
    assert fn(transient_then_clean) == 0  # resolved -> not a residual
    assert fn(real_residual) == 3          # genuine residual still counted


def _load_nested_from(fn_name, source):
    ns = {"re": re}
    exec(compile(_slice_nested_function(fn_name, source), "push_v2", "exec"), ns)
    return ns[fn_name]
