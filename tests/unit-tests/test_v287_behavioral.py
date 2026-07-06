"""Behavioral tests for v2.8.7 — PINNED-DOMAIN RECONCILE (alias=vov-pinned-domain-reconcile).

Live <profile>/restaurants VOV run (2026-05-30) printed the swarm's first per-iteration outcome:
    [VOV-OUTCOME-SUMMARY] iter=1 batches=54 applied=0 by_status={'invariant_violation': 36,
                          'time_budget_exceeded': 18}
0% applied coverage. Ground-truth: business_domains widget was EMPTY yet the VOV pinned 13
domains parsed from the vibe in DISPLAY form ('food safety','real estate','restaurant
operations','supply chain'); the installed base model stores them normalized/shortened
('foodsafety','realestate','restaurant','supply'). verify_invariants did an EXACT set
subtraction (expected.user_pinned_domains - actual_domains), so the 4 multi-word pins were
reported 'removed' on EVERY batch -> 36/54 invariant_violation regardless of what the mutator
actually did. The mutator was fine; the invariant was lying.

FIX: capture_invariants now reconciles each pinned NAME to the model's ACTUAL canonical domain
name (exact-normalized via _vov285_san, then prefix/substring for shortened names) and DROPS
vibe-derived pins with no model counterpart (CLAUDE.md §3a-bis: vibe-derived domain names are
SOFT; only widget/model-present names stay hard-pinned).

These tests exec the REAL notebook _vov285_san + _vov286_reconcile_pinned_domains and assert the
OBSERVABLE contrast against the pre-patch exact-subtraction behavior on the live restaurants data.
"""
import re

from notebook_source_util import notebook_concat_source, slice_function_source

SRC = notebook_concat_source()

# Exact live restaurants state (model.json domains + the 13 vibe-pinned names, all lower-cased
# as run_vov_2_against_widgets lower-cases them).
MODEL_DOMAINS = ['menu', 'guest', 'order', 'supply', 'inventory', 'restaurant', 'workforce',
                 'franchise', 'foodsafety', 'loyalty', 'marketing', 'finance', 'realestate',
                 'procurement']
LIVE_PINNED = ['menu', 'guest', 'order', 'inventory', 'workforce', 'franchise', 'loyalty',
               'marketing', 'finance', 'procurement', 'food safety', 'real estate',
               'restaurant operations', 'supply chain']


def _model(domains):
    return {"model": {"domains": [{"name": n} for n in domains], "metric_views": []}}


def _exec_reconcile_ns():
    ns = {"__name__": "_v287_reconcile"}
    class _L:
        def info(self, *a, **k):
            pass

        def warning(self, *a, **k):
            pass
    ns["logger"] = _L()
    for name in ["_vov285_san", "_vov286_reconcile_pinned_domains"]:
        exec(compile(slice_function_source(name, source=SRC), f"<{name}>", "exec"), ns)
    return ns


# ---------- version + sentinel contract ----------

def test_version_287_and_reconcile_alias_present():
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', SRC)
    seg = tuple(int(x) for x in (m.group(1).split(".") if m else []))
    assert m and seg >= (2, 8, 7), f"expected >=2.8.7, got {m and m.group(1)}"
    assert "vov-pinned-domain-reconcile FIRED" in SRC
    assert "_vov286_reconcile_pinned_domains" in SRC
    # capture_invariants MUST call the reconciler (the fix is wired, not dead code §8.4).
    cap = slice_function_source("capture_invariants", source=SRC)
    assert "_vov286_reconcile_pinned_domains(model, user_pinned_domains)" in cap


# ---------- non-tautology: prove the pre-patch behavior was broken ----------

def test_prepatch_exact_subtraction_falsely_flags_multiword_pins():
    # This is what verify_invariants did BEFORE the fix: exact set subtraction.
    actual = set(MODEL_DOMAINS)
    missing = set(LIVE_PINNED) - actual
    # Pre-patch: the 4 multi-word pins are falsely 'removed' on every batch.
    assert missing == {'food safety', 'real estate', 'restaurant operations', 'supply chain'}, missing


def test_reconcile_eliminates_all_false_removals_on_live_data():
    ns = _exec_reconcile_ns()
    canon = ns["_vov286_reconcile_pinned_domains"](_model(MODEL_DOMAINS), LIVE_PINNED)
    # Every reconciled name MUST exist verbatim in the model -> exact subtraction now empty.
    assert set(canon) <= set(MODEL_DOMAINS), f"reconciled names not in model: {set(canon)-set(MODEL_DOMAINS)}"
    missing = set(canon) - set(MODEL_DOMAINS)
    assert missing == set(), missing
    # All 14 pins map to a real domain (10 exact single-word + 4 reconciled multi-word).
    assert set(canon) == set(MODEL_DOMAINS), f"got {sorted(canon)}"


# ---------- specific reconciliation rules ----------

def test_exact_normalized_match_spaces_removed():
    ns = _exec_reconcile_ns()
    # 'food safety' -> 'foodsafety', 'real estate' -> 'realestate' (san strips spaces).
    canon = ns["_vov286_reconcile_pinned_domains"](_model(['foodsafety', 'realestate']),
                                                    ['food safety', 'real estate'])
    assert canon == ['foodsafety', 'realestate'], canon


def test_prefix_substring_match_for_shortened_names():
    ns = _exec_reconcile_ns()
    # model shortened the name: 'supply chain' -> 'supply', 'restaurant operations' -> 'restaurant'.
    canon = ns["_vov286_reconcile_pinned_domains"](_model(['supply', 'restaurant']),
                                                    ['supply chain', 'restaurant operations'])
    assert set(canon) == {'supply', 'restaurant'}, canon


def test_vibe_phantom_with_no_model_match_is_dropped_soft():
    ns = _exec_reconcile_ns()
    # 'aviation' has no counterpart in a restaurant model -> dropped from the HARD invariant.
    canon = ns["_vov286_reconcile_pinned_domains"](_model(['menu', 'guest']),
                                                    ['menu', 'guest', 'aviation'])
    assert 'aviation' not in canon
    assert set(canon) == {'menu', 'guest'}, canon


def test_single_word_widget_domains_preserved_verbatim():
    ns = _exec_reconcile_ns()
    # business_domains widget case: names built verbatim into the model stay hard-pinned, no drops.
    pins = ['customer', 'order', 'product']
    canon = ns["_vov286_reconcile_pinned_domains"](_model(pins), pins)
    assert canon == pins, canon


def test_empty_pinned_or_empty_model_passes_through():
    ns = _exec_reconcile_ns()
    assert ns["_vov286_reconcile_pinned_domains"](_model([]), ['x']) == ['x']
    assert ns["_vov286_reconcile_pinned_domains"](_model(['x']), []) == []


def test_reconcile_is_order_preserving_and_deduped():
    ns = _exec_reconcile_ns()
    # duplicate display forms collapsing to one canonical -> single entry, original order kept.
    canon = ns["_vov286_reconcile_pinned_domains"](_model(['supply', 'menu']),
                                                    ['supply chain', 'menu', 'supply'])
    assert canon == ['supply', 'menu'], canon


def test_reconcile_fired_line_routes_to_vov2_pipeline_logger():
    # §8.10 regression guard: the FIRED line MUST emit on the vov2-pipeline logger (which the VOV
    # pipeline attaches to the volume info.log), NOT the module-global logger. Live <profile>/restaurants
    # v287 proved the fix but its FIRED line was invisible to a volume-log grep because capture_invariants
    # used the unrouted global logger. This locks the routing so the gap can't regress.
    import logging
    ns = _exec_reconcile_ns()
    captured = []

    class _Cap(logging.Handler):
        def emit(self, record):
            captured.append(record.getMessage())

    lg = logging.getLogger("vov2-pipeline")
    h = _Cap()
    lg.addHandler(h)
    lg.setLevel(logging.INFO)
    try:
        ns["_vov286_reconcile_pinned_domains"](_model(['supply', 'foodsafety']),
                                               ['supply chain', 'food safety'])
    finally:
        lg.removeHandler(h)
    fired = [m for m in captured if "vov-pinned-domain-reconcile FIRED" in m]
    assert fired, f"FIRED line did not route to vov2-pipeline logger; captured={captured}"
    # source asserts the routed logger is used, not the bare global `logger`.
    src = slice_function_source("_vov286_reconcile_pinned_domains", source=SRC)
    assert 'getLogger("vov2-pipeline")' in src
