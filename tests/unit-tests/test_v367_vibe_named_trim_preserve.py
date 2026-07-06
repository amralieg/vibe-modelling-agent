"""Behavioral tests for v3.6.7 Fix#7 (alias=vibe-named-trim-preserve / vibe-named-judge-count-effective).

ROOT CAUSE under test (healthcare base-MVM live run 562080035570249, error log):
the judge free-synthesised 24 domains (mostly free-invented: revenue/telehealth/population/
device/finance/access...), missing the user's vibe-named required domains. Two downstream bugs
then INVERTED the user's intent:

  Fix#7b -- the judge-count validator hard-failed `24 < min(25)` three times -> the
    soft-accept-hard-fail-on-critical-step guard logged 2 ERROR + "Max retries (3) exhausted"
    (CLAUDE.md sec10.6 hard signatures), even though the 12 missing required domains are injected
    deterministically downstream (so the real final count is >= 25). The fix validates the
    EFFECTIVE post-injection count.

  Fix#7a -- the P0.65 cap-trim preserve-set was WIDGET-ONLY (_user_specified_domains). Healthcare's
    business_domains widget was EMPTY, so the trim kept the judge's first-25 (free-invented) and
    DROPPED the 12 appended vibe-named required domains (reference/laboratory/radiology/clinical/
    billing/claim/consent/scheduling/...), the exact opposite of sec3b/sec3c. Fix#1 had patched the
    INJECT path (P0.52, widget UNION vibe) but missed THIS trim. The fix unions the vibe-named
    required domains into the preserve-set so non-required extras trim first.

These tests extract the REAL production helpers from the notebook and exercise them end-to-end
(not stubs). They FAIL on pre-patch HEAD (helpers absent) and pass post-patch.
"""
import json
import re
import os

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_funcs(names):
    nb = json.load(open(NB))
    src = "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")
    g = {"re": re}
    for fn in names:
        m = re.search(rf"\ndef {fn}\(.*?\n(?=\ndef |\n[^ \n])", src, re.DOTALL)
        assert m, f"function {fn} not found in notebook"
        exec(m.group(0), g)
    return g, src


_ALL = [
    "_v367_norm_entity",
    "_v367_required_domain_norm_set",
    "_v367_effective_domain_count",
    "_v367_cap_trim_preserve_required",
]


def test_fix7_helpers_and_wiring_present():
    g, src = _load_funcs(_ALL)
    assert "def _v367_required_domain_norm_set(" in src
    assert "def _v367_effective_domain_count(" in src
    assert "def _v367_cap_trim_preserve_required(" in src
    # each helper has exactly one live call site (def + call == 2 occurrences of the call token).
    assert src.count("_v367_cap_trim_preserve_required(_gate_domains") == 1
    assert src.count("_v367_effective_domain_count(domains, _required_norm_f7)") == 1
    # the trim call site reads the unioned preserve-set, not the widget-only set
    assert "_user_set_lower = _v367_required_domain_norm_set(widgets_values)" in src
    from version_test_util import assert_version_at_least
    assert_version_at_least("3.6.7")


def test_required_set_unions_widget_and_vibe():
    g, _ = _load_funcs(["_v367_norm_entity", "_v367_required_domain_norm_set"])
    req = g["_v367_required_domain_norm_set"]
    # widget empty (the healthcare case) -> vibe-named still pinned
    wv = {"_user_specified_domains": [], "_required_domains_from_vibe": ["Behavioral Health", "reference"]}
    assert req(wv) == {"behavioralhealth", "reference"}
    # both present -> union, normalized (underscores/spaces stripped)
    wv2 = {"_user_specified_domains": ["hr"], "_required_domains_from_vibe": ["clinical_ai"]}
    assert req(wv2) == {"hr", "clinicalai"}
    # nothing required -> empty (control: behaviour identical to legacy for non-vibe runs)
    assert req({}) == set()
    assert req(None) == set()


def test_effective_count_counts_required_to_be_injected():
    """Fix#7b: 24 selected + 12 required-missing (injected downstream) = 36 >= min(25) -> PASS."""
    g, _ = _load_funcs(["_v367_norm_entity", "_v367_required_domain_norm_set", "_v367_effective_domain_count"])
    eff = g["_v367_effective_domain_count"]
    # judge selected 24: 13 overlap required + 11 free-invented
    required = {f"req{i}" for i in range(25)}
    selected = [{"domain": f"req{i}"} for i in range(13)] + [{"domain": f"free{i}"} for i in range(11)]
    assert len(selected) == 24
    effective = eff(selected, required)
    assert effective == 24 + 12, "12 required not yet present count toward the effective minimum"
    assert effective >= 25, "the 24<25 selection is NOT a hard-fail because injection makes it >=25"


def test_effective_count_no_required_is_legacy_behaviour():
    """Control: with no required domains the effective count equals the raw count (no regression)."""
    g, _ = _load_funcs(["_v367_norm_entity", "_v367_effective_domain_count"])
    eff = g["_v367_effective_domain_count"]
    selected = [{"domain": f"d{i}"} for i in range(24)]
    assert eff(selected, set()) == 24
    assert eff(selected, None) == 24


def test_trim_preserves_all_vibe_named_drops_free_invented():
    """THE healthcare inversion: free-invented at the FRONT, vibe-named appended at the TAIL, cap=25.
    Post-patch keeps ALL 25 vibe-named required and trims the 11 free-invented extras."""
    g, _ = _load_funcs(["_v367_norm_entity", "_v367_cap_trim_preserve_required"])
    trim = g["_v367_cap_trim_preserve_required"]
    free = [{"domain": f"free{i}"} for i in range(11)]          # judge free-invented (front)
    req = [{"domain": f"req{i}"} for i in range(25)]            # vibe-named required (some injected at tail)
    gate = free + req                                            # 36 domains, over cap
    required_norm = {f"req{i}" for i in range(25)}
    keep, trimmed = trim(gate, 25, required_norm)
    keep_names = {d["domain"] for d in keep}
    trim_names = {d["domain"] for d in trimmed}
    assert keep_names == required_norm, "every vibe-named required domain survives the cap-trim"
    assert trim_names == {f"free{i}" for i in range(11)}, "only free-invented non-required extras trimmed"
    assert len(keep) == 25


def test_trim_pre_patch_widget_only_would_have_dropped_required():
    """Documents the regression: the legacy widget-only first-N trim (preserve-set EMPTY for an
    empty widget) keeps the first 25 in list order -> drops 11 of the vibe-named required. The new
    required-aware helper does the opposite. This contrast proves the fix changes observable state."""
    g, _ = _load_funcs(["_v367_norm_entity", "_v367_cap_trim_preserve_required"])
    trim = g["_v367_cap_trim_preserve_required"]
    free = [{"domain": f"free{i}"} for i in range(11)]
    req = [{"domain": f"req{i}"} for i in range(25)]
    gate = free + req

    # legacy behaviour: empty preserve-set -> keep first 25 in order
    legacy_keep = gate[:25]
    legacy_keep_names = {d["domain"] for d in legacy_keep}
    legacy_dropped_required = {f"req{i}" for i in range(25)} - legacy_keep_names
    assert legacy_dropped_required, "legacy widget-only trim DROPS vibe-named required (the bug)"

    # new behaviour: required-aware -> drops zero required
    keep, _ = trim(gate, 25, {f"req{i}" for i in range(25)})
    new_dropped_required = {f"req{i}" for i in range(25)} - {d["domain"] for d in keep}
    assert new_dropped_required == set(), "fix drops ZERO vibe-named required"


def test_trim_required_exceeding_cap_keeps_all_required():
    """sec3b: if the user named MORE domains than the cap, NEVER drop a protected one (caller then
    raises USER-VIBE-CONFLICT and lifts the cap)."""
    g, _ = _load_funcs(["_v367_norm_entity", "_v367_cap_trim_preserve_required"])
    trim = g["_v367_cap_trim_preserve_required"]
    req = [{"domain": f"req{i}"} for i in range(30)]
    keep, trimmed = trim(req, 25, {f"req{i}" for i in range(30)})
    assert len(keep) == 30, "all 30 required kept even though cap is 25 (no protected drop)"
    assert trimmed == []


def test_fix7_industry_agnostic():
    _, src = _load_funcs(_ALL)
    for fn in ["_v367_required_domain_norm_set", "_v367_effective_domain_count", "_v367_cap_trim_preserve_required"]:
        m = re.search(rf"\ndef {fn}\(.*?\n(?=\ndef |\n[^ \n])", src, re.DOTALL)
        body = m.group(0).lower()
        for term in ["healthcare", "airline", "ncdot", "automotive", "banking", "retail"]:
            assert f'"{term}"' not in body and f"'{term}'" not in body, f"industry literal {term} in {fn}"
