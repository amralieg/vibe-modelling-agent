import json, os, re, textwrap, logging

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _synth_cell():
    nb = json.load(open(NB))
    for c in nb["cells"]:
        if c["cell_type"] != "code":
            continue
        s = "".join(c["source"])
        if "vov-blind-batch-nonempty-contract" in s and "vov-errfb-grounded-retry" in s:
            return s
    raise AssertionError("synthesize_handler cell not found")


def _extract(s, start_anchor, end_anchor):
    i = s.index(start_anchor)
    j = s.index(end_anchor, i) + len(end_anchor)
    return textwrap.dedent(s[i:j])


# ---- Edit 2: blind-batch already-satisfied escape in the cross-cutting directive ----
def _blind_directive_user():
    s = _synth_cell()
    block = _extract(
        s,
        'user += (\n                "\\n\\nCROSS-CUTTING DIRECTIVE:',
        'there is no named target."\n            )',
    )
    ns = {"user": ""}
    exec(block, ns)
    return ns["user"]


def test_blind_directive_has_already_satisfied_escape():
    # PASS-POST: the blind/cross-cutting directive now offers an already-satisfied escape so a
    # cross-cutting VReq that already holds returns UNCHANGED instead of being forced to raise.
    # FAIL-PRE: the v3.9.1 directive said only "if _changed == 0 then raise ... ; otherwise return"
    # with NO 'already satisfied:' path -> this assertion would fail on the pre-edit source.
    u = _blind_directive_user()
    assert "already satisfied:" in u, u[:400]
    assert "ALREADY-SATISFIED" in u
    assert "vov-blind-already-satisfied" in u
    # the two-case contract is explicit
    assert "GENUINELY-UNAPPLIED" in u
    # genuine-work path preserved: must still mutate when an entity needs it
    assert "if even ONE applicable entity still needs the change" in u


def test_blind_directive_no_longer_forces_unconditional_raise():
    # The pre-edit unconditional "if `_changed == 0` then raise ... ; otherwise return the mutated
    # model." sentence must be GONE (it is what false-failed already-satisfied cross-cutting VReqs).
    u = _blind_directive_user()
    assert "if `_changed == 0` then raise ValueError('cross-cutting mutator produced empty diff'); otherwise return the mutated model." not in u
    # success on a real change is still defined
    assert "if `_changed > 0` return the mutated model" in u


# ---- Edit 1: FIX B grounded-retry now emits an observable FIRED line (§8.10) ----
def test_errfb_grounded_retry_fires_observable_log():
    s = _synth_cell()
    block = _extract(
        s,
        '        user += f"\\n\\nPRIOR ATTEMPT FAILED. Trace:\\n{prior_failure_trace[:8000]}',
        'alias=vov-errfb-grounded-retry")\n        except Exception:\n            pass',
    )
    records = []

    class _Cap(logging.Handler):
        def emit(self, r):
            records.append(r.getMessage())

    lg = logging.getLogger("vov2-pipeline")
    lg.setLevel(logging.INFO)
    h = _Cap()
    lg.addHandler(h)
    try:
        ns = {"user": "", "prior_failure_trace": "attempt 3: cross-cutting mutator produced empty diff"}
        exec(block, ns)
    finally:
        lg.removeHandler(h)
    fired = [m for m in records if "vov-errfb-grounded-retry FIRED" in m]
    assert fired, records
    # the FIRED line reports how many chars of trace were fed back (observability payload)
    assert "prior-failure trace back to the generator" in fired[0]


# ---- Integration contract: the existing path-agnostic credit the escape relies on still credits
#      an already-satisfied + empty-diff outcome as 'applied' (regression guard) ----
def test_already_satisfied_credit_contract_intact():
    s = _synth_cell()
    # the credit gate keys off the summary prefix + a noop diff, independent of blind vs named
    assert "_is_already_satisfied = _ecs.startswith('already satisfied')" in s
    assert "if _is_already_satisfied and _is_noop_diff:" in s
    # and it returns status 'applied' (not noop_failed / rejected_unsafe)
    i = s.index("if _is_already_satisfied and _is_noop_diff:")
    seg = s[i:i + 600]
    assert 'status="applied"' in seg, seg


if __name__ == "__main__":
    test_blind_directive_has_already_satisfied_escape(); print("blind escape present OK")
    test_blind_directive_no_longer_forces_unconditional_raise(); print("unconditional-raise removed OK")
    test_errfb_grounded_retry_fires_observable_log(); print("errfb FIRED observable OK")
    test_already_satisfied_credit_contract_intact(); print("credit contract intact OK")
    print("ALL PASS")
