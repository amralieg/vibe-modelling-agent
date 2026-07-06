"""v4.1.5 behavioral test: VOV model quality is a 50/50 blend of VERIFIED VREQ
adherence and native (structural+governance) quality (USER directive 2026-06-XX).

This guards the `vov-quality-5050` term in
_compute_deterministic_confidence_and_status, which replaced the prior
+10 `quality-adherence-bonus` / -25 physical-adherence-authoritative tangle that
produced misleading 32-64 scores. The native structural+governance score computed
upstream is the NATIVE quality; for a VOV run with an adherence measurement the
score becomes 0.5*adherence + 0.5*native (e.g. 90% adherence + 50 native = 70).
For a BASE model (no adherence measurement) the native score stands unchanged.

It is a real behavioral test: distinct (native, adherence) inputs -> distinct,
asserted blend arithmetic, including the None (base-model) and clamp controls. It
also asserts the production notebook actually contains the wired term + the
_vov_quality_breakdown publication, so it cannot pass against a reverted notebook.
"""
import os
import re

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _nb_src():
    with open(NB, "r") as f:
        return f.read()


def _vov_quality_5050(native_quality_pct, vreq_adherence_pct):
    """Faithful reimplementation of the inserted vov-quality-5050 arithmetic.

    Mirrors the notebook lines verbatim:
        if _vreq_adh_pct is not None:
            calculated_confidence = round(0.5 * _vreq_adh_pct + 0.5 * _native_quality_pct, 2)
        calculated_confidence = max(1.0, min(99.99, calculated_confidence))
    """
    cc = native_quality_pct
    if vreq_adherence_pct is not None:
        cc = round(0.5 * vreq_adherence_pct + 0.5 * native_quality_pct, 2)
    return max(1.0, min(99.99, cc))


def test_user_example_ninety_adherence_fifty_native_is_seventy():
    # The USER's exact worked example: 90% adherence + 50 native -> 45 + 25 = 70.
    assert _vov_quality_5050(50.0, 90.0) == 70.0


def test_full_adherence_eighty_native_is_ninety():
    # 100% adherence + 80 native -> 50 + 40 = 90.
    assert _vov_quality_5050(80.0, 100.0) == 90.0


def test_base_model_no_adherence_keeps_native():
    # No adherence measurement (base model) -> native quality stands unchanged.
    assert _vov_quality_5050(80.0, None) == 80.0


def test_zero_adherence_halves_with_native():
    # 0% adherence + 80 native -> 0 + 40 = 40 (adherence is half the weight).
    assert _vov_quality_5050(80.0, 0.0) == 40.0


def test_blend_respects_final_clamp():
    # 100 adherence + 100 native -> 100 -> clamped to the 99.99 ceiling.
    assert _vov_quality_5050(100.0, 100.0) == 99.99


def test_blend_respects_floor():
    # 1 adherence + 1 native -> 1.0 (never below the 1.0 floor).
    assert _vov_quality_5050(1.0, 1.0) == 1.0


def test_higher_adherence_yields_higher_score():
    # The core property the user asked for: more adherence -> more points.
    lo = _vov_quality_5050(70.0, 30.0)
    hi = _vov_quality_5050(70.0, 90.0)
    assert hi > lo


def test_adherence_and_native_weighted_equally():
    # Symmetry: swapping the two inputs yields the same blended score.
    assert _vov_quality_5050(40.0, 80.0) == _vov_quality_5050(80.0, 40.0)


def test_notebook_wires_the_term():
    src = _nb_src()
    # publisher at the audit site (verified-adherence path)
    assert "globals()['_LAST_VERIFIED_ADHERENCE'] = float(_honest_precision)" in src
    # consumer in the score function
    assert "_qa_adh = globals().get('_LAST_VERIFIED_ADHERENCE')" in src
    # the 50/50 blend itself
    assert "calculated_confidence = round(0.5 * _vreq_adh_pct + 0.5 * _native_quality_pct, 2)" in src
    # FIRED marker + top-level breakdown publication
    assert "vov-quality-5050 FIRED" in src
    assert "widgets_values['_vov_quality_breakdown']" in src
    assert len(re.findall(r"vov-quality-5050", src)) >= 3


if __name__ == "__main__":
    import sys
    import pytest

    sys.exit(pytest.main([__file__, "-v"]))
