"""v2.9.1 FIX-2 behavioral test: meta model-quality-score requirements.

ROOT CAUSE (pre-patch): a VREQ like "improve the model quality score to >= 85"
has no entity target, so the per-VREQ verifier could not confirm it and marked it
failed/partial -- a false negative that dragged precision/recall, because the
authoritative deterministic Model Quality Score is computed later (in next_vibes),
not at the verifier stage.

FIX: _verify_requirement detects aggregate model-quality-score goals and returns
status='informational' (excluded from precision), reusing the existing
mark_informational path. Re-implementing the deterministic score in the verifier
would duplicate _compute_deterministic_confidence_and_status (DRY violation), so
the meta-goal is correctly excluded rather than faked as fulfilled.

§8.10 proof-of-failure on pre-patch HEAD: the two regex patterns + the
informational return do not exist pre-patch, so the extraction/asserts fail.
"""
import json
import os
import re

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _extract_regexes():
    src = _src()
    mp = re.search(r'_v291_metascore_phrase = re\.compile\((r"[^\n]*?")\s*,\s*re\.I\)', src)
    mv = re.search(r'_v291_metascore_verb = re\.compile\((r"[^\n]*?")\s*,\s*re\.I\)', src)
    assert mp and mv, "v2.9.1 FIX-2 metascore regexes not found (pre-patch HEAD => FAIL)"
    phrase = re.compile(eval(mp.group(1)), re.I)
    verb = re.compile(eval(mv.group(1)), re.I)
    return phrase, verb


def _classifies_meta(text, phrase, verb):
    return bool(phrase.search(text) and verb.search(text))


META_REQS = [
    "Improve the model quality score to >= 85",
    "Achieve an overall model score of 90/100",
    "Raise the quality score above 80",
    "Maintain a model quality score of at least 88",
    "Increase the confidence score for the model",
]

ENTITY_REQS = [
    "Add a foreign key from booking.flight_id to flight.flight_id",
    "Reverse-engineer the PSE schema into the project domain",
    "Tag all PII attributes in the customer domain",
    "Rename product order_header to orders",
    "Build metric view KPI-1: On-time performance",
]


def test_meta_reqs_classified():
    phrase, verb = _extract_regexes()
    for t in META_REQS:
        assert _classifies_meta(t, phrase, verb), f"should classify meta-score: {t!r}"


def test_entity_reqs_not_classified():
    # §8.3 anti-tautology: prove the branch does NOT fire on real structural reqs.
    phrase, verb = _extract_regexes()
    for t in ENTITY_REQS:
        assert not _classifies_meta(t, phrase, verb), f"must NOT classify entity req as meta-score: {t!r}"


def test_informational_return_wired():
    src = _src()
    assert "verifier-metascore-informational FIRED v2.9.1" in src
    # the branch must return informational, not fulfilled/failed
    assert '"status": "informational", "evidence": "[verifier-metascore-informational' in src
