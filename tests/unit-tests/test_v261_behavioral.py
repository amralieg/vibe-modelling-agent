"""v2.6.1 behavioral tests — agentic loop on the RAW-vibe (else) path.

Root cause v261 fixes: v260's slip-feedback loop only ran in the _parsed_priorities
branch (PRIORITY-formatted next_vibes). New-base-model runs feed the raw user vibe
(no **PRIORITY N** lines) so _v251_parse_priorities returned [] and run_vov_pipeline
fell into the legacy else branch (extract_all -> dedupe -> apply ONCE) with no loop and
no feedback. v261 wraps that else branch in the same audit->slip->feedback->retry loop,
keyed off outcome.status/diagnostic, via _v261_vreq_with_feedback.

These are §8.10 BEHAVIORAL tests: they assert the OBSERVABLE state change
(VREQ.source_quote now carries the prior-iteration slip-reason that the next LLM call
consumes), not just that a log line exists. On pre-patch HEAD the symbol does not exist,
so importing/calling it fails — that is the pre-patch failure proof.
"""
import agent_helpers as ah


def test_v261_helper_exists():
    assert hasattr(ah, "_v261_vreq_with_feedback"), (
        "v261 fix missing: _v261_vreq_with_feedback not defined in agent notebook"
    )


def test_v261_feedback_embeds_slip_reason_into_source_quote():
    RawVREQ = ah.RawVREQ
    v = RawVREQ(
        vreq_id="VREQ-007",
        intent="connect_table: ops.trip.driver_id",
        target="ops.trip.driver_id",
        source_quote="ORIGINAL USER REQUIREMENT TEXT",
        source_chunk_id="chunk-3",
    )
    # pre-patch state: the original VREQ carries no slip reason
    assert "PRIOR ITERATION SLIP-REASON" not in v.source_quote

    out = ah._v261_vreq_with_feedback(
        v, "noop_failed", "mutator passed AST but produced an empty diff", 2
    )

    # OBSERVABLE change: the next LLM call's input (source_quote) now contains the
    # slip-reason, the sandbox status, and the diagnostic — this is what makes the
    # retry differ from the first attempt (not a log-only no-op).
    assert "PRIOR ITERATION SLIP-REASON" in out.source_quote
    assert "iteration 2" in out.source_quote
    assert "noop_failed" in out.source_quote
    assert "empty diff" in out.source_quote
    # original requirement text is preserved (feedback is appended, not replacing)
    assert "ORIGINAL USER REQUIREMENT TEXT" in out.source_quote


def test_v261_feedback_preserves_vreq_id_for_applied_dedup():
    # The loop tracks applied vreq_ids across iterations; the retried VREQ MUST keep the
    # same vreq_id so a later "applied" outcome correctly removes it from the residual set.
    RawVREQ = ah.RawVREQ
    v = RawVREQ(
        vreq_id="VREQ-042",
        intent="add_attribute: hr.employee.manager_id",
        target="hr.employee.manager_id",
        source_quote="q",
        source_chunk_id="chunk-9",
    )
    out = ah._v261_vreq_with_feedback(v, "scope_mismatch", "diag", 3)
    assert out.vreq_id == "VREQ-042"
    assert out.target == "hr.employee.manager_id"
    assert out.intent == "add_attribute: hr.employee.manager_id"
    # chunk id is suffixed per-iteration so batches don't collide across loops
    assert out.source_chunk_id == "chunk-9-iter3"


def test_v261_feedback_distinct_diagnostics_produce_distinct_inputs():
    # Two different slip reasons must yield two different source_quotes so the LLM gets
    # genuinely different guidance per failure class (proves it is not a constant).
    RawVREQ = ah.RawVREQ
    v = RawVREQ(vreq_id="V1", intent="i", target="d.p.c", source_quote="base", source_chunk_id="c1")
    a = ah._v261_vreq_with_feedback(v, "noop_failed", "empty diff", 2)
    b = ah._v261_vreq_with_feedback(v, "rejected_unsafe", "del of module forbidden", 2)
    assert a.source_quote != b.source_quote
    assert "noop_failed" in a.source_quote and "noop_failed" not in b.source_quote
    assert "rejected_unsafe" in b.source_quote
