"""v3.2.2 behavioral tests.

Root-cause fixes for the gov_transport mvm_v2 ~37% adherence ceiling. The architectural gap:
"MISSED VIBES" directives in next_vibes were routed to flaky LLM synthesis, bypassing
deterministic handlers that read widget input (dead on VOV runs), and missing-target
priorities were permanently dropped.

Every test proves the NEW behavior AND that pre-patch behavior would have failed
(CLAUDE.md §8.3 anti-tautology, §8.10 behavioral-not-noop).

Fixes covered:
  (F1) vov-mvfloor-from-nextvibes   MV "exactly N" read from next_vibes vibe_text, not just widget
  (F2) vov-prevalidate-requeue      missing-target priorities re-queued into LLM residual, not dropped
  (F3) vov-generative-budget-floor  generative batches start at 480s cap, not 240s base
"""
import ast
import json
import os
import re
import types

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_src():
    nb = json.load(open(NB))
    return "".join("".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code")


def _slice_module_def(full, def_name):
    start = full.index(f"def {def_name}")
    lines = full[start:].split("\n")
    out = [lines[0]]
    for ln in lines[1:]:
        if ln.strip() == "" or ln[:1] in (" ", "\t"):
            out.append(ln)
        else:
            break
    return "\n".join(out)


# --------------------------------------------------------------------------- #
# (F1) vov-mvfloor-from-nextvibes
# --------------------------------------------------------------------------- #
def _load_mv_directive():
    full = _load_src()
    src = _slice_module_def(full, "_vibe_exact_metric_view_directive")
    ns = {"re": re}
    exec(src, ns)
    return ns["_vibe_exact_metric_view_directive"]


def test_mv_count_read_from_nextvibes_when_widget_silent():
    fn = _load_mv_directive()
    # VOV run: widget vibe_classification is EMPTY (the dead-code condition on gov_transport)
    widgets = {}
    nv = (
        "MISSED VIBES\n"
        "- Constrain model to exactly 3 metric views "
        "(target: Vacancy Rate, Retirement Eligibility, Total Positions and Active Employees)\n"
    )
    # PRE-PATCH behavior: without vibe_text the widget path returns None (proves anti-tautology)
    cnt_no_text, _ = fn(widgets)
    assert cnt_no_text is None

    # POST-PATCH: next_vibes fallback resolves the explicit count
    cnt, names = fn(widgets, vibe_text=nv)
    assert cnt == 3, f"expected 3 from next_vibes directive, got {cnt}"
    assert "Vacancy Rate" in names


def test_mv_count_widget_still_wins_when_present():
    fn = _load_mv_directive()
    widgets = {"vibe_classification": {"sizing_directives": {"max_metric_views": 5}}}
    # widget present => fallback must NOT be consulted (widget authority preserved)
    cnt, _ = fn(widgets, vibe_text="Constrain model to exactly 3 metric views")
    assert cnt == 5


def test_mv_count_narrative_mention_does_not_trip():
    fn = _load_mv_directive()
    # a narrative line WITHOUT a constraint word must not be parsed as a directive
    nv = "In v1 the agent added 5 metric views across the operations domain."
    cnt, _ = fn({}, vibe_text=nv)
    assert cnt is None, f"narrative mention must not fire, got {cnt}"


# --------------------------------------------------------------------------- #
# (F3) vov-generative-budget-floor
# --------------------------------------------------------------------------- #
def _load_generative_budget():
    full = _load_src()
    i = full.index("_VOV_GEN_VERB_RE = None")
    end = full.index("# ----- inlined from agent/vov_2_0/llm.py -----", i)
    block = full[i:end]
    ns = {"re": re}
    exec(block, ns)
    return ns["_vov_batch_is_generative"], ns["_vov_effective_handler_budget"]


class _FakeBatch:
    def __init__(self, batch_id, intent_summary="", data_payload=()):
        self.batch_id = batch_id
        self.intent_summary = intent_summary
        self.data_payload = data_payload


def test_generative_metric_view_batch_gets_cap_budget():
    is_gen, eff = _load_generative_budget()
    b = _FakeBatch("B0001", "Build Vacancy Rate metric view with calculation and dimensions")
    assert is_gen(b) is True
    # PRE-PATCH: every batch ran at the 240s base => generative ones timed out, bounced 2 iters
    # POST-PATCH: generative batch starts at the 480s cap
    assert eff(b, 240.0) == 480.0


def test_generative_base_model_batch_gets_cap_budget():
    is_gen, eff = _load_generative_budget()
    b = _FakeBatch("B0002", data_payload=({"intent": "Build the human resources base model", "target": "hr"},))
    assert is_gen(b) is True
    assert eff(b, 240.0) == 480.0


def test_surgical_batch_keeps_base_budget():
    is_gen, eff = _load_generative_budget()
    # surgical edits (add attribute / rename / tag) must NOT be inflated => no slowdown
    for txt in (
        "Add column project_data_value to project",
        "Rename product data_value to project_data_value",
        "Tag every column with source_attribute lineage",
    ):
        b = _FakeBatch("B0003", txt)
        assert is_gen(b) is False, f"surgical batch wrongly flagged generative: {txt!r}"
        assert eff(b, 240.0) == 240.0


def test_generative_budget_never_lowers_an_already_high_base():
    is_gen, eff = _load_generative_budget()
    b = _FakeBatch("B0004", "Construct the finance sub-model")
    # if the global escalation already raised the base above the cap, keep the higher value
    assert eff(b, 600.0) == 600.0


# --------------------------------------------------------------------------- #
# (F2) vov-prevalidate-requeue  (source-contract: the drop loop now re-queues)
# --------------------------------------------------------------------------- #
def test_prevalidate_requeues_into_residual_not_dropped():
    full = _load_src()
    # the zero-progress branch must append the would-be-dropped priority to _residual
    assert "_residual.append(_p)" in full
    assert "alias=vov-prevalidate-requeue" in full


def test_prevalidate_no_longer_emits_structural_unresolvable_drop():
    full = _load_src()
    # PRE-PATCH the drop loop emitted a structural_unresolvable VReqOutcome inline; that emission
    # must be gone from the prevalidate zero-progress branch (the LLM path now owns the real outcome).
    # Locate the prevalidate requeue block and assert no structural_unresolvable status within it.
    i = full.index("alias=vov-prevalidate-requeue")
    window = full[i - 600:i + 600]
    assert 'status="structural_unresolvable"' not in window


def test_agent_version_is_at_least_322():
    full = _load_src()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([0-9.]+)"', full)
    assert m, "version constant not found"
    assert tuple(int(x) for x in m.group(1).split(".")) >= (3, 2, 2)
