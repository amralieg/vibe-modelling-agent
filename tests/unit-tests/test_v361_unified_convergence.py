"""Behavioral tests for v3.6.1 alias=unified-agentic-convergence.

USER DIRECTIVE under test: "AGENTIC LOOP MUST RUN FOR ANY OPERATION base model,
vov, shrink, enlarge ... you exit the agentic loop when you are done, or there is
no more convergence or you are at good quality or approaching the timeout of 15hrs."

ROOT CAUSE this fixes: the three agentic refinement loops each had their OWN ad-hoc
stopping rule and a binding FIXED iteration cap (base-model architect domain+global
= 3 iters; VOV apply = 10 iters / 5h budget). A fixed cap is NOT a sanctioned exit
under the directive — a model that still has convergence headroom was cut off at the
cap, and a model that converged early kept spinning. v3.6.1 introduces ONE shared
policy `_agentic_loop_should_stop` wired into all three loops; the fixed caps survive
ONLY as high safety ceilings (arch 3->8, vov 10->25, vov budget 300m->840m).

These tests extract the REAL production helper from the notebook (not a stub) and
exercise every exit branch, then statically assert the helper is wired into all
three loops. They FAIL on pre-v3.6.1 HEAD because the helper + wiring do not exist.
"""
import json
import re
import os

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _load_helper():
    src = _src()
    m = re.search(r"\ndef _agentic_loop_should_stop\(.*?\n(?=\ndef |\n[^ \n])", src, re.DOTALL)
    assert m, "_agentic_loop_should_stop not found in notebook (pre-v3.6.1 HEAD)"
    g = {}
    exec(m.group(0), g)
    return g["_agentic_loop_should_stop"]


class _Budget:
    def __init__(self, rem):
        self._rem = rem

    def remaining_seconds(self):
        return self._rem


# ── exit-branch behavior ──────────────────────────────────────────────────────

def test_good_quality_wins_first():
    stop = _load_helper()
    # good-quality outranks everything: even at iter 1 with a near-zero budget, a
    # satisfied production gate stops the loop cleanly.
    s, why = stop(iteration=1, ceiling=8, quality_ok=True, progressed=True,
                  score_history=[10.0], job_budget=_Budget(1.0))
    assert s is True and why == "good-quality"


def test_approaching_15h_yields_budget():
    stop = _load_helper()
    # budget below the tail reserve -> yield remaining time to finalize/verify/install.
    s, why = stop(iteration=2, ceiling=8, quality_ok=False, progressed=True,
                  score_history=[10.0, 20.0], job_budget=_Budget(100.0),
                  tail_reserve_s=2400.0)
    assert s is True and why == "approaching-15h"


def test_no_convergence_on_plateau():
    stop = _load_helper()
    # quality plateaued over the trailing window AND this iter made no progress -> stop.
    s, why = stop(iteration=4, ceiling=8, quality_ok=False, progressed=False,
                  score_history=[70.0, 70.2, 70.3, 70.4], job_budget=_Budget(99999.0))
    assert s is True and why == "no-convergence"


def test_still_progressing_continues_despite_flat_score():
    stop = _load_helper()
    # flat score but the loop IS still applying changes this iter -> keep going
    # (no-convergence requires BOTH flat window AND no progress).
    s, why = stop(iteration=4, ceiling=8, quality_ok=False, progressed=True,
                  score_history=[70.0, 70.1, 70.1, 70.1], job_budget=_Budget(99999.0))
    assert s is False and why == "continue"


def test_rising_score_continues():
    stop = _load_helper()
    # strong window gain -> not converged, keep iterating even with no per-iter "progress" flag.
    s, why = stop(iteration=4, ceiling=8, quality_ok=False, progressed=False,
                  score_history=[40.0, 55.0, 70.0, 85.0], job_budget=_Budget(99999.0))
    assert s is False and why == "continue"


def test_safety_ceiling_is_last_resort():
    stop = _load_helper()
    # nothing else fired but we hit the ceiling -> stop as a backstop, distinctly labeled.
    s, why = stop(iteration=8, ceiling=8, quality_ok=False, progressed=True,
                  score_history=[10.0, 30.0, 50.0, 80.0], job_budget=_Budget(99999.0))
    assert s is True and why == "safety-ceiling"


def test_early_iters_never_no_converge():
    stop = _load_helper()
    # too few samples to judge a trailing window -> must keep iterating (continue),
    # never a premature no-convergence at iter 1/2.
    for it, hist in ((1, [70.0]), (2, [70.0, 70.0])):
        s, why = stop(iteration=it, ceiling=8, quality_ok=False, progressed=False,
                      score_history=hist, job_budget=_Budget(99999.0))
        assert s is False and why == "continue", (it, why)


def test_none_budget_is_safe():
    stop = _load_helper()
    # job_budget=None must not crash the budget branch.
    s, why = stop(iteration=1, ceiling=8, quality_ok=False, progressed=True,
                  score_history=[10.0], job_budget=None)
    assert s is False and why == "continue"


# ── wiring: helper called in all three agentic loops ──────────────────────────

def test_wired_into_all_three_loops():
    src = _src()
    assert "def _agentic_loop_should_stop(" in src
    # domain-architect loop, global-principal-architect loop, each call the shared policy
    assert 'alias="arch-domain-converge"' in src, "domain loop not wired"
    assert 'alias="arch-global-converge"' in src, "global loop not wired"
    # exactly 1 def + 2 call sites (domain + global) reference the helper by name
    assert src.count("_agentic_loop_should_stop(") == 3, src.count("_agentic_loop_should_stop(")


def test_fixed_caps_demoted_to_safety_ceilings():
    src = _src()
    # architect cap raised 3 -> 8
    assert 'config.get("MAX_ARCHITECT_REVIEW_ITERATIONS", 8)' in src
    assert 'config.get("MAX_ARCHITECT_REVIEW_ITERATIONS", 3)' not in src
    # VOV apply caps raised 10 -> 25 and budget 300 -> 840
    assert "priority_reapply_loops: int = 25," in src
    assert "_total_loop_budget_min = 840" in src
    assert "_total_loop_budget_min = 300" not in src


def test_version_at_least_361():
    from version_test_util import assert_version_at_least
    assert_version_at_least("3.6.1")
