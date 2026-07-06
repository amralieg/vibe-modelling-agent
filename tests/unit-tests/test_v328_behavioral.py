"""v3.2.8 behavioral tests.

vov-batch-pack-45: VOV synthesis batches were hard-capped at 48,000 bytes of
TARGET_ENTITIES_FULL (~6% of an 800K-char opus-4-8 input window) -> ~1-4
VREQs/batch -> 1,400+ LLM bridge calls on large ECM models (AUTO ecm hit the
1,400 call cap; RETAIL threw time_budget_exceeded across iter-1). The under-
packing inflated per-batch orchestration overhead (target resolution, digest,
merge, verify, dedup paid PER BATCH) and 429 throttle churn.

POST-PATCH: the batch byte-budget packs toward ~45% of the model INPUT window,
OUTPUT-aware (bounded by ~62% of the OUTPUT window so a packed batch never
truncates its mutation response and silently drops VREQs). The per-batch time
budget scales sqrt(packing) so wide batches are not pre-empted by
time_budget_exceeded -- the exact failure that forced the 64KB->48KB revert.

These tests pin the pure budget math (_v328_pack_budget) and the wiring
(threaded from widgets context window, used at the split site + time budgets).
Pre-patch the helper does not exist and the call site is hardcoded 48000, so
every assertion below fails on pre-patch HEAD.
"""

from notebook_source_util import notebook_concat_source
from test_v251_vov_priority_landing import _exec_v251_namespace
from version_test_util import assert_version_at_least

SRC = notebook_concat_source()


def test_pack45_alias_and_version_present():
    assert "vov-batch-pack-45" in SRC
    assert_version_at_least("3.2.8", SRC)
    assert "def _v328_pack_budget(" in SRC


def test_pack45_callsite_uses_budget_not_hardcoded_48000():
    # the 48000 literal must be gone from the split call; budget now derived
    assert "_vov286_split_batches_by_budget(_batches, model, budget=_pack_budget)" in SRC
    assert "_vov286_split_batches_by_budget(_batches, model, budget=48000)" not in SRC


def test_pack45_time_budget_scales_with_packing():
    # base, escalation cap, and generative cap all scale with _pack_time_scale
    assert "_handler_time_budget = 240.0 * _pack_time_scale" in SRC
    assert "min(480.0 * _pack_time_scale, _handler_time_budget * 2.0)" in SRC
    assert "gen_cap=480.0 * _pack_time_scale" in SRC


def test_pack45_context_threaded_from_widgets():
    # caller derives the window from the live model widgets (per-model, no magic)
    assert 'input_ctx_chars=int(widgets_values.get("llm_input_context_tokens_count"' in SRC
    assert 'output_ctx_chars=int(widgets_values.get("llm_output_context_tokens_count"' in SRC


def test_pack45_budget_default_opus48():
    ns = _exec_v251_namespace()
    f = ns["_v328_pack_budget"]
    # opus-4-8 default window: 200K tokens in (800K chars), 128K tokens out (512K chars)
    budget, scale, in_cap, out_cap = f(800000, 512000)
    # ~315KB packed budget = output-bound; ~6.5x the old 48KB
    assert 300000 <= budget <= 330000, budget
    assert budget > 48000 * 6, "must pack at least ~6x wider than old 48KB"
    assert 2.4 <= scale <= 2.7, scale  # sqrt(~6.56)
    assert in_cap == 320000  # 45% of 800K minus 40K overhead
    assert out_cap == budget  # output is the binding constraint here


def test_pack45_is_output_aware():
    """The discriminating safety test: a tiny output window MUST clamp the budget
    down (input-only packing would overflow output and drop VREQs)."""
    ns = _exec_v251_namespace()
    f = ns["_v328_pack_budget"]
    # huge input window but tiny output window
    budget, scale, in_cap, out_cap = f(800000, 64000)
    assert out_cap < in_cap, "output cap must bind when output window is small"
    assert budget == out_cap
    assert budget <= 48000, "tiny output forces budget back to the 48K floor"
    assert scale == 1.0


def test_pack45_fraction_monotonic():
    ns = _exec_v251_namespace()
    f = ns["_v328_pack_budget"]
    # larger frac -> larger (or equal) input cap; with a large output window the
    # budget tracks the input fraction
    b30, *_ = f(2000000, 4000000, frac=0.30)
    b45, *_ = f(2000000, 4000000, frac=0.45)
    assert b45 > b30


def test_pack45_safe_fallback_on_bad_input():
    ns = _exec_v251_namespace()
    f = ns["_v328_pack_budget"]
    budget, scale, in_cap, out_cap = f("not-a-number", None)
    assert budget == 48000 and scale == 1.0


# --- teardown-watchdog-force-exit (post-success teardown hang) ---
# gov_transport mvm_v6 finished (model written + FINAL-FLUSH 11:58) but the serverless
# command stayed RUNNING +4h48m: dbutils.notebook.exit() does not force-kill
# lingering non-daemon threads / volume-FUSE stalls. The watchdog arms a daemon
# timer BEFORE the exit call and force-terminates after a grace period, since the
# success result is already submitted. Pre-patch _safe_notebook_exit has no
# watchdog, so every assertion below fails on pre-patch HEAD.

def test_watchdog_alias_and_fired_log_present():
    assert "teardown-watchdog-force-exit" in SRC
    assert "[teardown-watchdog-force-exit FIRED v3.2.8]" in SRC


def test_watchdog_uses_os_exit_and_daemon_thread():
    assert "_wd_os._exit(0)" in SRC
    assert 'name="teardown_watchdog", daemon=True' in SRC


def test_watchdog_armed_before_notebook_exit():
    # the watchdog must be started BEFORE dbutils.notebook.exit() so a blocked
    # exit can still be force-terminated; assert ordering inside _safe_notebook_exit
    i = SRC.find("def _safe_notebook_exit")
    assert i >= 0
    body = SRC[i:i + 2000]
    wd = body.find("_wd_t.start()")
    ex = body.find("dbutils.notebook.exit(exit_result_json)")
    assert wd >= 0 and ex >= 0 and wd < ex, "watchdog must arm before notebook exit"


def test_watchdog_logs_offending_threads():
    # diagnostic for next-time RCA: enumerate non-daemon survivors, excluding main
    assert "_wd_threading.enumerate()" in SRC
    assert "not t.daemon" in SRC
    assert "_wd_threading.main_thread()" in SRC
