"""verifier install-headroom budget test (v2.9.1 origin, v2.9.3 current behaviour).

ROOT CAUSE (v2.9.1): _verify_via_llm reserved a FLAT 1800s install headroom; on
wide models whose build consumed most of the run budget, the final few VREQs were
skipped (status skipped_budget -> mark_partial) -- false partials dragging precision.

v2.9.1 FIX-4 made the reserve scale with remaining req count
(headroom = min(1800, 300 + 100 * remaining)). v2.9.3 SUPERSEDED that: the scaled
headroom still skipped final APPLIED reqs at remaining<860s even with ample time, so
v2.9.3 reserves a FIXED install floor instead (alias on _v293_install_floor):
  _v293_install_floor = 900
  _v291_headroom      = _v293_install_floor
Reuses RuntimeBudget.should_skip_optional (no new engine).

§8.10 proof-of-failure on pre-patch HEAD: the v2.9.3 install-floor expression does
not exist before the patch.
"""
import json
import os
import re

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def test_install_floor_expression_present():
    src = _src()
    assert "_v293_install_floor = 900" in src, \
        "v2.9.3 fixed install-floor not found (pre-patch HEAD => FAIL)"
    assert "_v291_headroom = _v293_install_floor" in src, \
        "v2.9.3 headroom must be the fixed install floor, not the v2.9.1 scaled expression"


def test_v293_replaced_v291_scaling():
    """v2.9.3 dropped the remaining-scaled headroom in favour of a fixed floor."""
    src = _src()
    assert "_v291_headroom = min(1800, 300 + 100 * max(0, _v291_remaining))" not in src, \
        "v2.9.1 scaled headroom must be gone (superseded by the v2.9.3 fixed floor)"


def test_skip_uses_scaled_headroom_not_flat():
    src = _src()
    # the budget check must consume the scaled headroom, not the old flat 1800
    assert "should_skip_optional(min_required_seconds=60, headroom_seconds=_v291_headroom)" in src
    assert "should_skip_optional(min_required_seconds=60, headroom_seconds=1800)" not in src


def test_headroom_is_fixed_floor_not_remaining_scaled():
    """The v2.9.3 reserve is a constant 900s install floor, independent of remaining."""
    src = _src()
    # The headroom is bound to the fixed floor constant, never recomputed from remaining.
    assert "_v291_headroom = _v293_install_floor" in src
    assert "_v293_install_floor = 900" in src


def test_remaining_excludes_terminal_statuses():
    src = _src()
    # must not count already-decided reqs toward the reserve
    assert 'getattr(_r, "status", "") not in ("fulfilled", "failed", "informational")' in src
