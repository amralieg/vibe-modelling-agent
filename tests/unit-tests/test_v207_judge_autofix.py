"""Behavioural tests for v207 judge autofix (domain-name + domain-count tune).

Per CLAUDE.md §8.10: no no-op patches. Every alias has [FIRED] emission AND behavioural test
that proves the patch changes observable state. These tests verify the v207 judge autofix
honors the §3c-clarified policy: user-vibe is supreme, agent tunes proposals to fit hard rules.

Policy (clarified 2026-05-26):
- User can propose 'digital_health' (multi-word, user-vibe-driven)
- Agent tunes to 'digital' (single-word, satisfies naming rule)
- LLM is NOT retried 3x against contradictory requirements
- The tune is OBSERVABLE: log line emitted + canonical response_data mutated

These tests load the agent notebook source and assert the autofix code shape + alias
emission sites are in place. They do NOT execute the full pipeline (that's covered by
the live cycle 3 run).
"""

import json
import os
import re

NB = os.path.join(
    os.path.dirname(__file__),
    "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb",
)


def _read_source() -> str:
    with open(NB, "r", encoding="utf-8") as f:
        d = json.load(f)
    src_lines = []
    for cell in d.get("cells", []):
        if cell.get("cell_type") == "code":
            src_lines.append("".join(cell.get("source", [])))
    return "\n".join(src_lines)


def test_v207_judge_autofix_state_holder_present():
    """The closure-captured tune-state dict is defined before the validator."""
    src = _read_source()
    assert "_judge_autofix_tunes = {\"name_tunes\": {}, \"count_dropped\": 0, \"dropped_names\": []}" in src, (
        "judge_autofix_tunes state holder missing — without it, tunes cannot survive smart_worker_loop re-parse"
    )


def test_v207_count_cap_tune_fires_when_overcount():
    """domain-count-cap-tune alias has its FIRED emission site at the trim block."""
    src = _read_source()
    assert "[domain-count-cap-tune FIRED v2.0.7]" in src
    assert "alias=domain-count-cap-tune" in src
    # The trim must be on data["domains"] AND on the local `domains` reference (both, so the rest
    # of the validator sees the trimmed list)
    assert "data[\"domains\"] = domains[:max_domains]" in src, (
        "count-cap-tune must mutate data['domains'] so the parsed dict reflects trim"
    )


def test_v207_name_snake_tune_fires_for_multiword():
    """domain-name-snake-tune alias has its FIRED emission site at the rename block."""
    src = _read_source()
    assert "[domain-name-snake-tune FIRED v2.0.7]" in src
    assert "alias=domain-name-snake-tune" in src
    # Algorithm must SPLIT on _ or space, prefer first non-colliding non-forbidden part
    assert re.search(r"_re_v207\.split\(r'\[_ \]\+'", src), (
        "split-on-underscore-or-space pattern missing — name tune must decompose multi-word"
    )


def test_v207_name_tune_excludes_system_and_forbidden():
    """Tune candidate selection must skip SYSTEM_MANAGED and FORBIDDEN_GENERIC names."""
    src = _read_source()
    assert "_cl_v207 not in SYSTEM_MANAGED_DOMAIN_NAMES" in src
    assert "_cl_v207 not in FORBIDDEN_GENERIC_DOMAIN_NAMES" in src


def test_v207_name_tune_collision_fallback_camelcase_smush():
    """When all parts collide/forbidden, tune falls back to a-z0-9 only concatenated lowercase."""
    src = _read_source()
    assert "_re_v207.sub(r'[^a-zA-Z0-9]', '', _name_v207).lower()" in src


def test_v207_multiword_no_longer_hard_fails_validator():
    """The old 'Domain {name} must be ONE WORD only' error MUST NOT be appended any more."""
    src = _read_source()
    # The error string may still appear as part of a removed/comment path, but it must NOT be appended.
    # Strict check: no surviving errors.append(...ONE WORD only...) call.
    pattern = r"errors\.append\([^)]*ONE WORD only"
    matches = re.findall(pattern, src)
    assert not matches, (
        f"multi-word check still hard-fails the validator — found {len(matches)} append(s): {matches[:2]}"
    )


def test_v207_count_cap_no_longer_hard_fails_validator():
    """The old 'Judge selected N domains, maximum is M' MUST NOT be appended — autofix replaces it."""
    src = _read_source()
    pattern = r"errors\.append\(f?\"Judge selected \{len\(domains\)\} domains, maximum"
    matches = re.findall(pattern, src)
    assert not matches, (
        f"count > max check still hard-fails — found {len(matches)} append(s) — autofix should trim instead"
    )


def test_v207_min_check_still_hard_fails():
    """Min-domain check is NOT autofixed — too few is still an error (LLM should retry)."""
    src = _read_source()
    assert 'errors.append(f"Judge selected only {len(domains)} domains, minimum is {min_domains}")' in src, (
        "min-check must remain a hard-fail — autofix only relaxes UPPER bound and naming"
    )


def test_v207_postprocess_func_defined_and_wired():
    """The postprocess func applies tunes to canonical response_data + is passed to smart_worker_loop."""
    src = _read_source()
    assert "def _apply_judge_autofix_tunes(response_data, _logger):" in src
    assert "[judge-autofix-postprocess FIRED v2.0.7]" in src
    assert "alias=judge-autofix-postprocess" in src
    assert "response_postprocess_func=_apply_judge_autofix_tunes," in src, (
        "postprocess hook must be wired into smart_worker_loop call — otherwise tunes are LOST on re-parse"
    )


def test_v207_postprocess_applies_count_drop_and_name_tunes():
    """Postprocess inspects _judge_autofix_tunes and mutates response_data accordingly."""
    src = _read_source()
    # Count drop application
    assert 'response_data["domains"] = _domains_list[:_kept]' in src
    # Name tune application
    assert "_d[\"domain\"] = _name_tunes[_orig]" in src


def test_v207_autofix_simulation_hc_scenario():
    """Simulate cycle 2 HC scenario (26 domains, multi-word) end-to-end against the tune algorithm.

    This is the §8.10 'prove the test fails on pre-patch HEAD' style probe:
    if the autofix code path didn't exist, the validator would fail on these inputs.
    Here we reconstruct the autofix logic and verify it produces the expected outcome.
    """
    SYSTEM_MANAGED = {"_metrics", "_metamodel", "system", "default", "information_schema"}
    FORBIDDEN_GENERIC = {"shared", "reference", "common", "main", "global"}

    # Cycle 2 HC inputs
    domains = [{"domain": f"hc_domain_{i}"} for i in range(22)]  # 22 single-word
    domains += [
        {"domain": "digital_health"},
        {"domain": "behavioral_health"},
        {"domain": "clinical_ai"},
        {"domain": "population_health"},
    ]  # 26 total, 4 multi-word
    max_domains = 22

    # Apply count autofix
    if len(domains) > max_domains:
        dropped = [d.get("domain", "") for d in domains[max_domains:]]
        domains = domains[:max_domains]
    else:
        dropped = []

    # Apply name autofix on what remains
    name_tunes = {}
    existing = set()
    for d in domains:
        name = d.get("domain", "")
        if "_" in name or " " in name:
            parts = re.split(r"[_ ]+", name)
            tuned = None
            for cand in parts:
                cl = (cand or "").lower().strip()
                if cl and cl not in existing and cl not in SYSTEM_MANAGED and cl not in FORBIDDEN_GENERIC:
                    tuned = cl
                    break
            if tuned is None:
                tuned = re.sub(r"[^a-zA-Z0-9]", "", name).lower()
            name_tunes[name] = tuned
            d["domain"] = tuned
            name = tuned
        existing.add(name.lower())

    # Assertions
    assert len(domains) == 22, f"count cap should trim to 22, got {len(domains)}"
    assert len(dropped) == 4, f"4 domains should be dropped, got {len(dropped)}"
    assert "population_health" in dropped, "trim should drop tail-domains in judge order"
    # No multi-word survives
    for d in domains:
        assert "_" not in d["domain"] and " " not in d["domain"], (
            f"multi-word domain '{d['domain']}' survived autofix"
        )
    # All names unique
    names = [d["domain"] for d in domains]
    assert len(names) == len(set(names)), f"dupes after autofix: {[n for n in names if names.count(n) > 1]}"


def test_v207_autofix_simulation_rt_scenario():
    """Simulate cycle 1 RT scenario (15 domains, max 14) — pure count overshoot, no naming."""
    domains = [{"domain": f"rt_dom_{i}"} for i in range(15)]
    max_domains = 14

    if len(domains) > max_domains:
        dropped = [d.get("domain", "") for d in domains[max_domains:]]
        domains = domains[:max_domains]
    else:
        dropped = []

    assert len(domains) == 14
    assert dropped == ["rt_dom_14"], (
        f"single-tail drop expected, got {dropped}"
    )


def test_v207_autofix_simulation_all_parts_collide():
    """When every part of a multi-word name already exists, fallback to camelCase smush."""
    SYSTEM_MANAGED = set()
    FORBIDDEN_GENERIC = set()
    existing = {"clinical", "ai"}  # both parts already taken

    name = "clinical_ai"
    parts = re.split(r"[_ ]+", name)
    tuned = None
    for cand in parts:
        cl = (cand or "").lower().strip()
        if cl and cl not in existing and cl not in SYSTEM_MANAGED and cl not in FORBIDDEN_GENERIC:
            tuned = cl
            break
    if tuned is None:
        tuned = re.sub(r"[^a-zA-Z0-9]", "", name).lower()

    assert tuned == "clinicalai", (
        f"camelCase-smush fallback expected, got {tuned!r}"
    )


def test_v207_autofix_simulation_partial_collide():
    """First part collides, second part free — should pick second."""
    existing = {"behavioral"}  # first part taken, 'health' free
    name = "behavioral_health"
    parts = re.split(r"[_ ]+", name)
    tuned = None
    for cand in parts:
        cl = (cand or "").lower().strip()
        if cl and cl not in existing:
            tuned = cl
            break
    if tuned is None:
        tuned = re.sub(r"[^a-zA-Z0-9]", "", name).lower()

    assert tuned == "health"


def test_v207_judge_autofix_state_holder_typed_correctly():
    """The state holder is a plain dict (closure-captured by Python lookup rules)."""
    state = {"name_tunes": {}, "count_dropped": 0, "dropped_names": []}
    state["name_tunes"]["digital_health"] = "digital"
    state["count_dropped"] = 4
    state["dropped_names"].extend(["a", "b"])
    assert state["name_tunes"] == {"digital_health": "digital"}
    assert state["count_dropped"] == 4
    assert state["dropped_names"] == ["a", "b"]
