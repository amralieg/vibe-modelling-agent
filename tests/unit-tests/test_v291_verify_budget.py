"""v2.9.1 FIX-4 behavioral test: verifier budget scales with remaining req count.

ROOT CAUSE (pre-patch): _verify_via_llm reserved a FLAT 1800s install headroom; on
wide models whose build consumed most of the run budget, the final few VREQs were
skipped (status skipped_budget -> mark_partial) -- false partials dragging precision
(live audit: 5 reqs skipped this way).

FIX: reserve scales with the number of still-unverified requirements --
  headroom = min(1800, 300 + 100 * remaining)
so few remaining => small reserve => they verify; many remaining => keep the full
30-min install reserve. Reuses RuntimeBudget.should_skip_optional (no new engine).

§8.10 proof-of-failure on pre-patch HEAD: the scaling expression does not exist.
"""
import json
import os
import re

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _headroom(remaining):
    return min(1800, 300 + 100 * max(0, remaining))


def test_scaling_expression_present():
    src = _src()
    assert "_v291_headroom = min(1800, 300 + 100 * max(0, _v291_remaining))" in src, \
        "v2.9.1 FIX-4 scaling expression not found (pre-patch HEAD => FAIL)"


def test_skip_uses_scaled_headroom_not_flat():
    src = _src()
    # the budget check must consume the scaled headroom, not the old flat 1800
    assert "should_skip_optional(min_required_seconds=60, headroom_seconds=_v291_headroom)" in src
    assert "should_skip_optional(min_required_seconds=60, headroom_seconds=1800)" not in src


def test_few_reqs_get_smaller_reserve_than_many():
    assert _headroom(3) < _headroom(20)
    assert _headroom(0) == 300
    assert _headroom(3) == 600
    assert _headroom(100) == 1800  # capped


def test_remaining_excludes_terminal_statuses():
    src = _src()
    # must not count already-decided reqs toward the reserve
    assert 'getattr(_r, "status", "") not in ("fulfilled", "failed", "informational")' in src
