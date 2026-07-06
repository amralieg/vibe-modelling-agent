"""v3.6.7 Fix #4 — verifier time-budget false-fail.

Root cause: _verify_via_llm's top guard skips per-VREQ verification when remaining wall-clock is below
the install-floor headroom (960s). But once past that guard, the primary + rescue LLM calls (each with
transient retries) can THEMSELVES consume the remaining budget on a slow/timing-out endpoint near
end-of-run. When both return empty, the v1.1.0 keyword-rescue path emits a 'failed' verdict for a
possibly-applied VREQ purely because we ran out of time — false negatives that pollute the adherence
score. Fix (alias=verifier-budget-empty-not-failed): at the empty juncture, re-check the budget; if it
has now dropped below the optional-skip threshold, return 'skipped_budget' (unverified-due-to-budget,
mapped to mark_partial) instead of letting keyword-rescue emit 'failed'.

These tests drive the REAL VibeOrchestrator._verify_via_llm via a class slice (no notebook execution of
module-level code) with a stateful fake RuntimeBudget. §8.10 anti-tautology: the budget-induced case
returns 'skipped_budget' post-patch and a non-skip verdict ('failed'/'informational') pre-patch; the
ample-budget control returns a non-skip verdict in BOTH (proving the gate does not over-fire).
"""

import ast
import json
from pathlib import Path
from types import SimpleNamespace

import pytest

NB_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _concat_code():
    nb = json.loads(NB_PATH.read_text(encoding="utf-8"))
    return "\n\n".join(
        "".join(c["source"]) for c in nb.get("cells", [])
        if c.get("cell_type") == "code" and "".join(c["source"]).strip()
    )


class _Budget:
    """Stateful fake: should_skip_optional returns the scripted sequence; remaining/elapsed are numbers."""
    def __init__(self, skip_sequence, remaining=120.0):
        self._seq = list(skip_sequence)
        self._calls = 0
        self._remaining = remaining
    def should_skip_optional(self, min_required_seconds=60, headroom_seconds=1800):
        v = self._seq[self._calls] if self._calls < len(self._seq) else self._seq[-1]
        self._calls += 1
        return v
    def remaining_seconds(self):
        return self._remaining
    def elapsed_seconds(self):
        return 1000.0


def _build_orchestrator(budget):
    src = _concat_code()
    lines = src.splitlines(keepends=True)
    tree = ast.parse(src)
    node = next(n for n in tree.body if isinstance(n, ast.ClassDef) and n.name == "VibeOrchestrator")
    cls_src = "".join(lines[node.lineno - 1:node.end_lineno])
    import re as _re
    ns = {
        "__name__": "_test_vorch",
        "re": _re,
        "json": json,
        "_v207_get_runtime_budget": lambda: budget,
        "_v207_set_runtime_budget": lambda b: None,
    }
    exec(compile(cls_src, str(NB_PATH), "exec"), ns)
    VO = ns["VibeOrchestrator"]
    o = object.__new__(VO)
    # Minimal attrs _verify_via_llm touches (enumerated from the method body):
    o.ai_agent = object()  # truthy but has NO _call_ai_query -> both LLM calls skipped -> empty
    o.logger = SimpleNamespace(
        info=lambda *a, **k: None, warning=lambda *a, **k: None,
        error=lambda *a, **k: None, debug=lambda *a, **k: None,
    )
    o.manifest = SimpleNamespace(requirements=[])
    o.widgets_values = {}
    return o


def _req():
    return SimpleNamespace(
        id="VREQ-budget-001",
        original_text="Add an FK from billing.invoice.customer_id to billing.customer.customer_id",
        scope_targets=[],
    )


def test_alias_present_in_source():
    src = _concat_code()
    assert src.count("verifier-budget-empty-not-failed") >= 3, "Fix#4 alias must be present (FIRED + return + comment)"


def test_budget_induced_empty_returns_skipped_not_failed():
    """§8.10: top guard passes (1st skip=False), then the empty juncture sees skip=True -> skipped_budget.

    Pre-patch there is no budget re-check at the juncture, so this falls to keyword-rescue and returns
    'failed' (the VREQ tokens do not match the empty snapshot) -> assertion fails on pre-patch HEAD.
    """
    budget = _Budget(skip_sequence=[False, True])  # entry guard passes; juncture re-check skips
    o = _build_orchestrator(budget)
    res = o._verify_via_llm(_req(), domains_data=[], products_data=[], attributes_data=[])
    assert res["status"] == "skipped_budget", f"budget-induced empty must NOT be 'failed'; got {res}"


def test_ample_budget_does_not_over_skip():
    """Control: budget never skips -> the gate must NOT fire; verdict falls through to keyword-rescue
    (a non-skip status). Proves the fix does not mask genuine LLM silence as budget skips."""
    budget = _Budget(skip_sequence=[False, False])
    o = _build_orchestrator(budget)
    res = o._verify_via_llm(_req(), domains_data=[], products_data=[], attributes_data=[])
    assert res["status"] != "skipped_budget", f"gate over-fired with ample budget: {res}"
    assert res["status"] in ("failed", "fulfilled", "partial", "informational")


def test_top_guard_still_skips_when_budget_low_at_entry():
    """Pre-existing v2.0.7 behaviour preserved: if budget is low at ENTRY, the top guard skips."""
    budget = _Budget(skip_sequence=[True])
    o = _build_orchestrator(budget)
    res = o._verify_via_llm(_req(), domains_data=[], products_data=[], attributes_data=[])
    assert res["status"] == "skipped_budget"
