"""Behavioral + contract tests for v2.7.0 (v270-sandbox-is-authoritative).

ARCHITECTURE COLLAPSE: the `vibe modeling of version` (VOV) path is now a SINGLE
engine — the VOV-2.0 SANDBOX. The dual-architecture conflict that caused low
vibe-adherence is removed:

  1. DELETED the legacy strict-diff-guard subsystem that reverted sandbox-applied
     FKs/attributes as "phantoms" (248 reverts on gov_transport v263 run <run_id>):
       _strict_vov_diff_guard, _vov_diff_guard_products, _vov_diff_guard_attrs,
       _v264_sandbox_change_closure_triples (the v264 band-aid).
  2. DELETED dead code with zero callers:
       _vov_hydrate_new_domains_from_vibe, _vov_extract_products_for_new_domains.
  3. GATED OFF the legacy vibe-verification sweep (run_vibe_verification_sweep ->
     apply_mutation_command/_llm_fallback_* second engine) for VOV.

KEPT (shared with non-VOV ops install/shrink/enlarge, which do NOT use the sandbox):
  _compute_vov_user_closure, apply_mutation_command, run_vibe_verification_sweep,
  VibeOrchestrator.

These tests assert the deletion stays deleted (regression), the sandbox-authoritative
sentinels are wired, and the sweep-gate truth table evaluated from the REAL notebook
source skips VOV while still running for non-VOV ops.
"""
import ast
import json
import re
from pathlib import Path

NB_PATH = Path(__file__).parent.parent.parent / "agent" / "dbx_vibe_modelling_agent.ipynb"

_DELETED_FUNCS = [
    "_strict_vov_diff_guard",
    "_vov_diff_guard_attrs",
    "_vov_diff_guard_products",
    "_v264_sandbox_change_closure_triples",
    "_vov_hydrate_new_domains_from_vibe",
    "_vov_extract_products_for_new_domains",
]

_KEPT_FUNCS = [
    "_compute_vov_user_closure",
    "apply_mutation_command",
    "run_vibe_verification_sweep",
]


def _code_cells():
    nb = json.loads(NB_PATH.read_text())
    return [c for c in nb.get("cells", []) if c.get("cell_type") == "code"]


def _nb_src():
    return "\n".join("".join(c.get("source", [])) for c in _code_cells())


# ---------- regression: the legacy engine stays deleted ----------

def test_legacy_guard_subsystem_deleted():
    src = _nb_src()
    for fn in _DELETED_FUNCS:
        assert ("def " + fn + "(") not in src, f"{fn} must be deleted (legacy/dead)"


def test_no_dangling_calls_to_deleted_funcs():
    src = _nb_src()
    for fn in _DELETED_FUNCS:
        total = len(re.findall(re.escape(fn) + r"\(", src))
        defs = len(re.findall(r"def " + re.escape(fn) + r"\(", src))
        assert total - defs == 0, f"dangling call(s) to deleted {fn}: {total - defs}"


def test_shared_engine_retained_for_non_vov_ops():
    src = _nb_src()
    for fn in _KEPT_FUNCS:
        assert ("def " + fn + "(") in src, f"{fn} is shared with non-VOV ops; must NOT be deleted"


def test_all_code_cells_still_compile():
    bad = []
    for i, c in enumerate(_code_cells()):
        try:
            ast.parse("".join(c.get("source", [])))
        except SyntaxError as e:
            bad.append((i, e.lineno, e.msg))
    assert not bad, f"syntax errors after excision: {bad}"


def test_version_bumped_to_270():
    src = _nb_src()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m, "missing __AGENT_VERSION__"
    parts = tuple(int(x) for x in m.group(1).split("."))
    assert parts >= (2, 7, 0), f"expected >= 2.7.0, got {m.group(1)}"
    # single-digit semver invariant (CLAUDE.md 3a)
    assert all(0 <= p <= 9 for p in parts), f"semver segments must be single-digit: {m.group(1)}"


def test_sentinels_present():
    src = _nb_src()
    assert "[v270-sandbox-is-authoritative FIRED]" in src
    assert "[v270-sweep-skip-on-vov FIRED]" in src


# ---------- behavioral: sweep-gate truth table from REAL source ----------

def _extract_sweep_gate():
    """Pull the real `_v270_is_vov = ...` assignment and the gated `if ...:` condition
    from the notebook so we evaluate the SHIPPED logic, not a re-typed copy."""
    src = _nb_src()
    assign_m = re.search(r'_v270_is_vov = \(widgets_values\.get\("operation", ""\)[^\n]*', src)
    assert assign_m, "v270 sweep-gate assignment not found"
    assign = assign_m.group(0).strip()
    cond_m = re.search(
        r"if _vs_ai_agent and _vs_vibe_text and not config\.get\('_verification_sweep_ran'\) and not _v270_is_vov:",
        src,
    )
    assert cond_m, "v270-gated sweep condition not found"
    cond = cond_m.group(0).strip()[len("if "):-1]  # strip 'if ' and trailing ':'
    return assign, cond


def _sweep_would_run(operation, ai_agent, vibe_text, sweep_ran):
    assign, cond = _extract_sweep_gate()
    ns = {
        "widgets_values": {"operation": operation},
        "config": {"_verification_sweep_ran": sweep_ran},
        "_vs_ai_agent": ai_agent,
        "_vs_vibe_text": vibe_text,
    }
    exec(assign, ns)
    return bool(eval(cond, ns))


def test_sweep_skipped_for_vov_even_with_vibe_and_agent():
    # VOV path: sandbox is authoritative -> legacy sweep must NOT run.
    assert _sweep_would_run("vibe modeling of version", ai_agent=object(),
                            vibe_text="rename X; add FK Y", sweep_ran=False) is False


def test_sweep_still_runs_for_non_vov_ops():
    # install/shrink/enlarge keep the legacy sweep (they don't use the sandbox).
    for op in ("install model (new base)", "shrink model", "enlarge model", ""):
        assert _sweep_would_run(op, ai_agent=object(), vibe_text="some directive",
                                sweep_ran=False) is True, f"sweep must run for non-VOV op {op!r}"


def test_sweep_not_rerun_when_already_ran():
    assert _sweep_would_run("shrink model", ai_agent=object(), vibe_text="x", sweep_ran=True) is False


def test_guard_callblock_replaced_with_sandbox_authoritative():
    src = _nb_src()
    # the old guard call must be gone from the writeback
    assert "_reverts_n, _reverts_list = _strict_vov_diff_guard(" not in src
    # replaced by the sandbox-authoritative sentinel inside step_finalize writeback
    assert 'logger.info("[v270-sandbox-is-authoritative FIRED] strict-diff-guard REMOVED' in src
