"""v3.6.7 Fix #3 — SelfFixer round-counter must count COMMITTED (model-changing) mutations only.

Root cause (CLAUDE.md §8.10): _fix_one_req returned (True, applied) whenever sb_ok and ver_ok and
not regressed, even when the mutator was a NO-OP (verifier blesses an already-satisfied REQ or is
lenient). The outer loop then counted round_fixed += 1 and "converged" while the model was unchanged
— a silent drop masquerading as a fix.

Fix: _selffixer_state_signature() computes a full-fidelity content hash of the whole model dict; the
apply path is gated on pre_sig != post_sig (alias=selffixer-noop-guard). The structural digest /
invariants are too coarse (they omit tags/descriptions/samples), so a tags-only fix would look like a
no-op under them — hence a content signature, not the digest.

These tests reuse the proven v208 harness (§3d). The §8.10 anti-tautology proof:
test_noop_blessed_by_verifier_not_counted FAILS on pre-patch HEAD (returns fixed_count==1) and PASSES
post-patch (returns fixed_count==0).
"""

import json

from test_v208_selffixer import (
    _build_selffixer_namespace,
    _CapturingLogger,
    _FakeAIAgent,
    _fake_sandbox_factory,
    _starting_model_one_missing_fk,
    _scripted_fk_link_mutator,
)


def _noop_but_verifier_true():
    return {
        "mutator_src": "def mutator(model, data):\n    return model\n",
        "verifier_src": "def verifier(model, data):\n    return (True, 'already satisfied')\n",
        "rationale": "no-op mutation the verifier nonetheless blesses",
    }


def _tag_add_mutator():
    """A change INVISIBLE to the structural digest/invariants (tags only) but a real model change."""
    return {
        "mutator_src": (
            "def mutator(model, data):\n"
            "    root = model.get('model', model)\n"
            "    for d in root.get('domains', []):\n"
            "        for p in d.get('products', []):\n"
            "            if p.get('product') == 'p1':\n"
            "                for a in p.get('attributes', []):\n"
            "                    if a.get('name') == 'p1_id':\n"
            "                        a['tags'] = ['pii']\n"
            "    return model\n"
        ),
        "verifier_src": (
            "def verifier(model, data):\n"
            "    root = model.get('model', model)\n"
            "    for d in root.get('domains', []):\n"
            "        for p in d.get('products', []):\n"
            "            if p.get('product') == 'p1':\n"
            "                for a in p.get('attributes', []):\n"
            "                    if a.get('name') == 'p1_id' and a.get('tags'):\n"
            "                        return (True, 'tagged')\n"
            "    return (False, 'no tag')\n"
        ),
        "rationale": "add a PII tag (structural-digest-invisible change)",
    }


def test_state_signature_helper_present_and_content_sensitive():
    ns = _build_selffixer_namespace()
    sig = ns["_selffixer_state_signature"]
    m = _starting_model_one_missing_fk()
    s1 = sig(m)
    assert isinstance(s1, str) and len(s1) == 64, "expected sha256 hexdigest"
    # identical content -> identical signature
    import copy
    assert sig(copy.deepcopy(m)) == s1
    # tags-only change -> DIFFERENT signature (digest would miss this)
    m2 = copy.deepcopy(m)
    m2["model"]["domains"][0]["products"][0]["attributes"][0]["tags"] = ["pii"]
    assert sig(m2) != s1, "content signature must catch a tags-only change"


def test_state_signature_fails_open_on_unserializable():
    ns = _build_selffixer_namespace()
    sig = ns["_selffixer_state_signature"]

    class Boom:
        def __iter__(self):
            raise RuntimeError("unserializable")
    # default=str handles most objects; force a hard failure via a key that can't sort
    bad = {1: "a", "b": 2}  # mixed-type keys -> sort_keys raises TypeError
    assert sig(bad) is None, "must return None (fail-open) on serialization failure"


def test_noop_blessed_by_verifier_not_counted():
    """§8.10 anti-tautology: no-op mutator + verifier=True must NOT count as a committed fix.

    Pre-patch this returns fixed_count==1 (the bug). Post-patch the noop-guard returns fixed_count==0.
    """
    ns = _build_selffixer_namespace()
    SelfFixer = ns["SelfFixer"]
    logger = _CapturingLogger()
    ai = _FakeAIAgent([json.dumps(_noop_but_verifier_true())])
    fixer = SelfFixer(ai_agent=ai, logger=logger, sandbox_executor=_fake_sandbox_factory())
    model = _starting_model_one_missing_fk()
    before = json.dumps(model, sort_keys=True)
    unfulfilled = [{"id": "REQ-noop-001", "text": "x", "evidence": "y", "attempts": 1}]
    res = fixer.fix_all_unfulfilled(model, unfulfilled, max_rounds=1, per_req_retries=0)
    assert res["fixed_count"] == 0, f"no-op must not count as a committed fix, got {res}"
    assert res["remaining_count"] == 1
    assert json.dumps(model, sort_keys=True) == before, "model must be byte-identical (no-op)"
    assert logger.has_alias("selffixer-noop-guard"), "guard must fire on a no-op committed attempt"


def test_real_change_still_counts():
    """Regression guard: a genuine FK link (sigs differ) MUST still count as fixed."""
    ns = _build_selffixer_namespace()
    SelfFixer = ns["SelfFixer"]
    logger = _CapturingLogger()
    ai = _FakeAIAgent([json.dumps(_scripted_fk_link_mutator())])
    fixer = SelfFixer(ai_agent=ai, logger=logger, sandbox_executor=_fake_sandbox_factory())
    model = _starting_model_one_missing_fk()
    unfulfilled = [{"id": "REQ-fk-001", "text": "link fk", "evidence": "missing fk", "attempts": 1}]
    res = fixer.fix_all_unfulfilled(model, unfulfilled, max_rounds=1, per_req_retries=0)
    assert res["fixed_count"] == 1, f"real change must still count, got {res}"
    p1_attrs = model["model"]["domains"][0]["products"][0]["attributes"]
    assert next(a for a in p1_attrs if a["name"] == "p2_id").get("foreign_key_to") == "d1.p2.p2_id"
    assert not logger.has_alias("selffixer-noop-guard"), "guard must NOT fire on a real change"


def test_tags_only_change_counts_proving_digest_too_coarse():
    """A tags-only change is invisible to the structural digest/invariants but IS a real fix.

    The content signature counts it; a digest-based guard would have dropped it. This proves the
    design choice (full-fidelity signature, not _selffixer_model_digest).
    """
    ns = _build_selffixer_namespace()
    SelfFixer = ns["SelfFixer"]
    digest = ns["_selffixer_model_digest"]
    model = _starting_model_one_missing_fk()
    import copy
    tagged = copy.deepcopy(model)
    tagged["model"]["domains"][0]["products"][0]["attributes"][0]["tags"] = ["pii"]
    # The coarse digest MISSES the tag change (justifies why we need the content signature):
    assert digest(model) == digest(tagged), "precondition: digest is blind to tags"

    logger = _CapturingLogger()
    ai = _FakeAIAgent([json.dumps(_tag_add_mutator())])
    fixer = SelfFixer(ai_agent=ai, logger=logger, sandbox_executor=_fake_sandbox_factory())
    unfulfilled = [{"id": "REQ-tag-001", "text": "tag pii", "evidence": "no pii tag", "attempts": 1}]
    res = fixer.fix_all_unfulfilled(model, unfulfilled, max_rounds=1, per_req_retries=0)
    assert res["fixed_count"] == 1, f"tags-only change must count as a fix, got {res}"
    assert model["model"]["domains"][0]["products"][0]["attributes"][0].get("tags") == ["pii"]
    assert not logger.has_alias("selffixer-noop-guard"), "guard must NOT fire (sigs differ)"
