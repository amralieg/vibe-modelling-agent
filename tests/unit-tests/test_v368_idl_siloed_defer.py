"""v3.6.8 hc-bug2 behavioral test: smart_worker_loop must DEFER (not CRITICAL hard-fail) when the
only residual validation errors are non-critical siloed / unlinked-FK / need-ai-linking issues.

ROOT CAUSE (healthcare base-MVM 2026-06-17 04:00:43): in_domain_linking_order exhausted retries
because ONE product (order.order_set_item, unlinked col set_item_id with no target table) is
genuinely unlinkable. The validator flagged it as a PURELY non-critical siloed issue and
is_non_critical_only was computed True, but the positive deferral branch was never wired -> the
code fell straight through to the P59 'soft-accept-hard-fail-on-critical-step' return False ->
step_in_domain_linking DISCARDED the whole order domain's valid links over one unlinkable orphan.

FIX (alias=idl-siloed-defer-not-hardfail): when residual errors are PURELY non-critical
siloed/unlinked-FK issues, return (True, last_valid_response, errors) so the valid links survive
and the residual silo defers to global silo-resolution / Step 7D-2 / the Step 4.8 _id normalizer.

This test extracts the LIVE post-retry decision region from smart_worker_loop and drives it with
controlled last_errors to assert the control-flow decision (defer vs hard-fail).
Test A (fail-pre/pass-post): siloed-only -> success True + FIRED log.
Test B (negative control): IDL_SILOED_DEFER_NOT_HARDFAIL=False -> still hard-fails (no always-fire).
Test C (negative control): a genuinely CRITICAL error -> still hard-fails (defer didn't weaken it).
"""
import re
import textwrap
import pytest
from notebook_source_util import notebook_concat_source


def _extract_decision_region():
    src = notebook_concat_source()
    start = src.index("critical_error_patterns = [")
    start = src.rindex("\n", 0, start) + 1  # snap to line start
    anchor = "exhausted on CRITICAL step \u2014 failing honest instead of proceeding with broken validation"
    aidx = src.index(anchor, start)
    ret = src.index("return False, last_valid_response, last_errors", aidx)
    end = src.index("\n", ret) + 1
    return textwrap.dedent(src[start:end])


def _make_decider():
    region = _extract_decision_region()
    factory = (
        "def _decide(last_errors, last_valid_response, step_name, max_attempts, config, logger, re):\n"
        + textwrap.indent(region, "    ")
        + "    return ('FELL_THROUGH', last_valid_response, last_errors)\n"
    )
    ns = {}
    exec(compile(factory, "<decide>", "exec"), ns)
    return ns["_decide"]


class _Log:
    def __init__(self):
        self.errors, self.warnings, self.infos = [], [], []
    def error(self, m): self.errors.append(m)
    def warning(self, m): self.warnings.append(m)
    def info(self, m): self.infos.append(m)


_SILOED_ERR = ["Domain 'order' has siloed products with unlinked FK columns (need AI linking): ['order_set_item']"]


def test_siloed_only_defers_returns_true():
    """PURELY siloed residual -> defer (success True) + FIRED log. Fails pre-patch (was False)."""
    decide = _make_decider()
    log = _Log()
    resp = {"links": [{"source": "order.a", "target": "order.b"}]}
    success, out, errs = decide(_SILOED_ERR, resp, "in_domain_linking_order", 3, {}, log, re)
    assert success is True, "siloed-only residual must DEFER (success True), not CRITICAL hard-fail"
    assert out is resp, "the AI's valid links must be preserved on defer"
    assert any("idl-siloed-defer-not-hardfail FIRED" in m for m in log.warnings)
    assert not any("soft-accept-hard-fail-on-critical-step FIRED" in m for m in log.errors)


def test_defer_disabled_flag_hardfails():
    """Negative control: flag off -> still hard-fails (proves the gate isn't an always-fire tautology)."""
    decide = _make_decider()
    log = _Log()
    success, out, errs = decide(
        _SILOED_ERR, {"links": []}, "in_domain_linking_order", 3,
        {"IDL_SILOED_DEFER_NOT_HARDFAIL": False}, log, re,
    )
    assert success is False, "with defer disabled, siloed-only must still hard-fail"
    assert any("soft-accept-hard-fail-on-critical-step FIRED" in m for m in log.errors)


def test_real_critical_still_hardfails():
    """Negative control: a genuinely critical error must still block (defer did not weaken it)."""
    decide = _make_decider()
    log = _Log()
    crit = ["Validation failed: domain has only 2 products, minimum required is 5"]
    success, out, errs = decide(crit, {"links": []}, "in_domain_linking_order", 3, {}, log, re)
    assert success is False, "critical validation error must still hard-fail"
    assert any("CRIT-PATTERN-MATCH" in m for m in log.errors)
    assert not any("idl-siloed-defer-not-hardfail FIRED" in m for m in log.warnings)
