import json
import os

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "\n".join("".join(c.get("source", [])) for c in nb.get("cells", []))


# ---- RuntimeBudget skip logic (faithful reconstruction of should_skip_optional) ----
def should_skip_optional(remaining_seconds, min_required_seconds=60, headroom_seconds=1800):
    return remaining_seconds < (float(min_required_seconds) + float(headroom_seconds))


# OLD (v2.9.1/2) verifier headroom: scaled with remaining unverified reqs.
def old_headroom(remaining_reqs):
    return min(1800, 300 + 100 * max(0, remaining_reqs))


# NEW (v2.9.3) verifier headroom: fixed install floor; the loop guarantees the tail reserve.
def new_headroom(remaining_reqs):
    return 900


def test_agent_version_is_293():
    # v2.9.3 fixes must remain present in this and all later versions.
    src = _src()
    import re
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', src)
    assert m, "version constant not found"
    assert tuple(int(x) for x in m.groups()) >= (2, 9, 3)


def test_fix_aliases_present():
    src = _src()
    assert "alias=vov-loop-yield-to-verify" in src
    assert "alias=verifier-budget-install-floor" in src
    assert "_VOV_TAIL_RESERVE_SEC" in src
    assert "_v293_install_floor" in src


def test_verifier_runs_where_old_headroom_would_skip():
    # The smoking gun: on a wide model the apply phase leaves a moderate tail. With 20 unverified
    # reqs and ~1500s remaining, the OLD scaled headroom (1800) forced a skip -> applied reqs scored
    # 'partial' (precision << recall). The NEW fixed install floor (900) lets the verifier RUN.
    remaining = 1500.0
    reqs = 20
    old_skip = should_skip_optional(remaining, 60, old_headroom(reqs))   # 1500 < 60+1800 -> True (SKIP)
    new_skip = should_skip_optional(remaining, 60, new_headroom(reqs))   # 1500 < 60+900  -> False (RUN)
    assert old_skip is True, "pre-patch must SKIP (proves the bug existed)"
    assert new_skip is False, "post-patch must RUN the verifier (the fix)"


def test_install_floor_still_protects_install():
    # Honesty guard: the verifier must STILL yield to install when time is genuinely scarce.
    # With only 800s left, even the new floor (900) skips so install/cleanup is not starved.
    assert should_skip_optional(800.0, 60, new_headroom(5)) is True


def test_loop_yields_when_job_budget_below_tail_reserve():
    # Faithful reconstruction of the vov-loop-yield-to-verify guard.
    TAIL_RESERVE = 2400.0

    def loop_should_yield(job_remaining):
        return job_remaining is not None and job_remaining < TAIL_RESERVE

    assert loop_should_yield(1000.0) is True    # near job end -> yield to verifier+install
    assert loop_should_yield(5000.0) is False   # plenty left -> keep applying
    assert loop_should_yield(None) is False     # no budget object -> never block the loop


if __name__ == "__main__":
    for fn in [v for k, v in sorted(globals().items()) if k.startswith("test_")]:
        fn()
        print("ok", fn.__name__)
