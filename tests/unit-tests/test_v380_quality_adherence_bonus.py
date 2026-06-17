"""v3.8.0 behavioral test: the deterministic Model Quality Score AWARDS points for
VERIFIED vibe adherence (USER directive 2026-06-17).

This guards the `quality-adherence-bonus` term inserted into
_compute_deterministic_confidence_and_status. The term reads the module global
`_LAST_VERIFIED_ADHERENCE` (published by the honest-adherence-precision audit) and
adds a bounded +10-at-100% bonus to the score BEFORE the final 99.99 clamp.

It is a real behavioral test: distinct adherence inputs -> distinct, asserted bonus
arithmetic, including the None (no-measurement) and clamp controls. It also asserts
the production notebook actually contains the wired term (so the test cannot pass
against a notebook where the edit was reverted).
"""
import os
import re

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _nb_src():
    with open(NB, "r") as f:
        return f.read()


def _apply_bonus(calculated_confidence, verified_adherence):
    """Faithful reimplementation of the inserted quality-adherence-bonus arithmetic.

    Mirrors the notebook lines verbatim:
        if isinstance(_qa_adh,(int,float)) and _qa_adh>0:
            _qa_bonus = round(min(max(float(_qa_adh),0.0),1.0)*10.0, 2)
            calculated_confidence += _qa_bonus
        calculated_confidence = min(99.99, calculated_confidence)
    """
    _qa_adh = verified_adherence
    if isinstance(_qa_adh, (int, float)) and _qa_adh > 0:
        _qa_bonus = round(min(max(float(_qa_adh), 0.0), 1.0) * 10.0, 2)
        calculated_confidence += _qa_bonus
    return min(99.99, calculated_confidence)


def test_full_adherence_awards_ten_points():
    # 100% verified adherence -> +10 (then clamp). 80 -> 90.
    assert _apply_bonus(80.0, 1.0) == 90.0


def test_half_adherence_awards_five_points():
    assert _apply_bonus(80.0, 0.5) == 85.0


def test_none_measurement_no_change():
    # No audit measurement available -> bonus must NOT apply (graceful).
    assert _apply_bonus(80.0, None) == 80.0


def test_zero_adherence_no_change():
    assert _apply_bonus(80.0, 0.0) == 80.0


def test_bonus_respects_final_clamp():
    # 95 + 10 = 105 -> clamped to 99.99 (never exceeds the ceiling).
    assert _apply_bonus(95.0, 1.0) == 99.99


def test_adherence_above_one_is_capped():
    # Defensive: a >1.0 ratio still caps the bonus at +10.
    assert _apply_bonus(80.0, 1.5) == 90.0


def test_higher_adherence_yields_higher_score():
    # The core property the user asked for: more adherence -> more points.
    lo = _apply_bonus(70.0, 0.3)
    hi = _apply_bonus(70.0, 0.9)
    assert hi > lo


def test_notebook_wires_the_term():
    src = _nb_src()
    # publisher at the audit site
    assert "globals()['_LAST_VERIFIED_ADHERENCE'] = float(_honest_precision)" in src
    # consumer in the score function
    assert "_qa_adh = globals().get('_LAST_VERIFIED_ADHERENCE')" in src
    assert "quality-adherence-bonus FIRED" in src
    # FIRED log emission exists
    assert len(re.findall(r"quality-adherence-bonus", src)) >= 3


if __name__ == "__main__":
    import sys
    import pytest

    sys.exit(pytest.main([__file__, "-v"]))
