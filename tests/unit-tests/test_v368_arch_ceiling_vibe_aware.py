"""Behavioral tests for v3.6.8 architect-review product-ceiling fixes.

ROOT CAUSE: the model_architect_review per-iteration validator capped the model
product count against a HARDCODED scope band (`_scope_upper = 500 if "ecm" else
151`, `_ceiling = scope_upper * 1.2` -> 181 for MVM). Two defects:

  (1) alias=arch-ceiling-vibe-aware -- the hardcoded 151 ignored the user vibe's
      EXPLICIT product enumeration. The healthcare base-MVM vibe lists 541
      products ("preserve every product name ... you may ADD") and the reviewer
      asks for MORE, so generation correctly built ~590 products. The 181 ceiling
      then contradicted the vibe (CLAUDE.md 3c USER-KING violation).

  (2) alias=arch-ceiling-net-increase-only -- the gate rejected EVERY proposal
      once `_current_products` exceeded the ceiling, including a NET-ZERO change
      ("590 current + 0 new = 590 > 181"). model_architect_review is a CRITICAL
      step, so 3 retries exhausted -> [soft-accept-hard-fail-on-critical-step] ->
      architect review SKIPPED + 10.6 hard-signature trip (Max retries + ERROR).

The fix raises the ceiling to the vibe-derived product floor
(`_required_products_from_vibe` count and `sizing_directives.max_total_products`,
the same sources `_v358_enforce_product_ceiling_flat` protects) and only rejects
a NET-INCREASE that crosses the ceiling FROM AT/BELOW it.

These tests extract the REAL gate block from the notebook, exec it as a function,
and assert the live decision. They FAIL on pre-v3.6.8 HEAD (the unwinnable-
net-zero / vibe-floor scenarios produce a ceiling error) and PASS post-fix, while
a genuine runaway addition (100 -> 700) STILL errors (guard not disabled).
"""
import json
import os
import re
import textwrap

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _build_gate():
    """Slice the ceiling-gate block out of the notebook and wrap it in a fn.

    Returns a callable gate(products_data, data, widgets_values, config) -> errors.
    """
    src = _src()
    start = src.index("_current_domains = len(_coerce_list_of_dicts(domains_data))")
    # end at the close of the ceiling errors.append (just before the domain-cap comment)
    end_anchor = "# Domain cap: soft sanity only"
    end = src.index(end_anchor, start)
    block = src[start:end]
    block = textwrap.dedent("        " + block) if not block.startswith(" ") else textwrap.dedent(block)
    # The slice begins mid-line at 8-space indent; normalise by dedenting the raw block.
    block = textwrap.dedent("\n".join(("        " + ln) if ln.strip() else ln
                                      for ln in block.splitlines()))

    def _coerce_list_of_dicts(x):
        return [d for d in (x or []) if isinstance(d, dict)]

    class _Logger:
        def info(self, *a, **k):
            pass

        def warning(self, *a, **k):
            pass

    fn_src = "def gate(products_data, data, widgets_values, config):\n"
    fn_src += "    domains_data = []\n"
    fn_src += "    errors = []\n"
    fn_src += "    _scope_key = str((config.get('MODEL_SCOPE') or (widgets_values or {}).get('model_scope') or 'mvm')).lower()\n"
    for ln in block.splitlines():
        fn_src += ("    " + ln + "\n") if ln.strip() else "\n"
    fn_src += "    return errors\n"

    ns = {"_coerce_list_of_dicts": _coerce_list_of_dicts, "logger": _Logger()}
    exec(compile(fn_src, "<gate>", "exec"), ns)
    return ns["gate"]


def _has_ceiling_err(errors):
    return any("ceiling" in str(e).lower() for e in errors)


def test_netzero_over_hardcoded_ceiling_not_blocked():
    """590 current + 0 new must NOT be blocked (the healthcare unwinnable gate).

    No vibe floor supplied -> isolates the net-increase-only fix. Pre-patch:
    590 > 181 -> ceiling error. Post-patch: 0 new -> never blocked.
    """
    gate = _build_gate()
    products = [{"product": f"p{i}"} for i in range(590)]
    data = {"products_to_add": [], "domains_to_add": []}
    errors = gate(products, data, {"model_scope": "mvm"}, {"MODEL_SCOPE": "mvm"})
    assert not _has_ceiling_err(errors), f"net-zero proposal wrongly blocked: {errors}"


def test_vibe_floor_raises_ceiling():
    """A vibe enumerating 541 products lifts the ceiling above the 590 build.

    Pre-patch: hardcoded 181 -> 590 > 181 ceiling error. Post-patch: vibe floor
    541 -> ceiling 649 -> 590 ok, and a small add stays under.
    """
    gate = _build_gate()
    products = [{"product": f"p{i}"} for i in range(590)]
    req = [f"prod_{i}" for i in range(541)]
    wv = {"model_scope": "mvm", "_required_products_from_vibe": req}
    data = {"products_to_add": [{"name": "new_a"}, {"name": "new_b"}], "domains_to_add": []}
    errors = gate(products, data, wv, {"MODEL_SCOPE": "mvm"})
    assert not _has_ceiling_err(errors), f"vibe-floor ceiling not honored: {errors}"


def test_sizing_directive_max_total_products_floor():
    """sizing_directives.max_total_products also lifts the ceiling (DRY w/ _v358)."""
    gate = _build_gate()
    products = [{"product": f"p{i}"} for i in range(400)]
    wv = {"model_scope": "mvm", "sizing_directives": {"max_total_products": 500}}
    data = {"products_to_add": [{"name": "x"}], "domains_to_add": []}
    errors = gate(products, data, wv, {"MODEL_SCOPE": "mvm"})
    assert not _has_ceiling_err(errors), f"max_total_products floor not honored: {errors}"


def test_runaway_addition_still_blocked():
    """Guard is NOT disabled: 100 current + 600 new with no vibe floor must error.

    Both pre- and post-patch block this (proves the gate still catches explosions).
    """
    gate = _build_gate()
    products = [{"product": f"p{i}"} for i in range(100)]
    data = {"products_to_add": [{"name": f"n{i}"} for i in range(600)], "domains_to_add": []}
    errors = gate(products, data, {"model_scope": "mvm"}, {"MODEL_SCOPE": "mvm"})
    assert _has_ceiling_err(errors), "runaway 100->700 addition must still be blocked"


def test_bounded_addition_under_default_ceiling_ok():
    """A modest add under the default MVM ceiling is fine (no false positive)."""
    gate = _build_gate()
    products = [{"product": f"p{i}"} for i in range(120)]
    data = {"products_to_add": [{"name": f"n{i}"} for i in range(20)], "domains_to_add": []}
    errors = gate(products, data, {"model_scope": "mvm"}, {"MODEL_SCOPE": "mvm"})
    assert not _has_ceiling_err(errors), f"bounded 120->140 wrongly blocked: {errors}"
