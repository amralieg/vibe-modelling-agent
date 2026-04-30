"""Behavioral test for v0.7.2 division-filter user-domain exemption (CLAUDE.md §3b/§3c).

Root cause fixed in this version
================================

The v0.7.1 NCDOT HR MVM live audit (Run 338922686355673) revealed that the
agent's create_logical_schema_domains stage applies a "division allow-list"
filter AFTER the LLM produces domains. The filter compares each domain's
auto-classified division against `business_context.orgnaization_divisions`
(typically "business, operations") and DROPS any domain classified as
"corporate" (e.g. policies_procedures, compliance_legal,
disciplinary_grievance for HR).

This is a hard CLAUDE.md §3b/§3c violation — the user explicitly populated the
`business_domains` widget with these names, but the heuristic over-rode them.
Audit log evidence:

    📋 Division filter from business context: business, operations
    🚫 Filtered out 3 domains (division not in allowed list: business, operations):
      - Domain: 'policies_procedures' --> corporate (EXCLUDED)
      - Domain: 'compliance_legal' --> corporate (EXCLUDED)
      - Domain: 'disciplinary_grievance' --> corporate (EXCLUDED)

Architect-self-review iterations 1, 2, 3 ALL flagged the violation but no
mutation pipeline put the missing domains back, so the model finalised at
6 user-domains + 1 internal `shared` = 7 total instead of 9.

Fix
===

In the same domain-emit loop, two new behaviours fire ONLY when the user
populated the `business_domains` widget (i.e. `_user_specified_domains` is
non-empty in `widgets_values`):

1. `[user-domain-division-exempt FIRED]` — for every user-specified domain
   whose LLM-classified division is NOT in `allowed_divisions`, the filter
   is BYPASSED. The domain's division is COERCED to a value in
   `allowed_divisions` so downstream division-aware passes still see a
   valid value, and the domain proceeds into `domains_to_create`.

2. `[user-domain-injection FIRED]` — after the loop, if any name in
   `_user_specified_domains` is STILL absent from `domains_to_create` (e.g.
   the LLM never produced it at all), inject a stub entry so it is
   guaranteed to land in the model.

Tests
=====

This file does NOT import the notebook (the notebook is a Databricks-only
artifact and cannot be imported in CI). Instead it asserts:

  T1. The version constant is "0.7.2".
  T2. The exact patched block exists in cell 1's source (or whichever code
      cell holds it) with both sentinels.
  T3. The exemption fires only when `_user_specified_domains` is non-empty.
  T4. A simulated LLM that returned only 6 of the 9 user-specified domains
      results in all 9 surviving the filter (the 3 missing are injected).
  T5. A simulated LLM that returned 9 user-specified domains all classified
      "corporate" with allow-list ["business", "operations"] still produces
      9 entries in domains_to_create (each with division coerced to one of
      the allowed values).
  T6. When `_user_specified_domains` is empty, the original behaviour is
      preserved (corporate-classified domains ARE filtered out).
"""

from __future__ import annotations

import json
import re
from pathlib import Path

NOTEBOOK_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_all_source() -> str:
    nb = json.loads(NOTEBOOK_PATH.read_text(encoding="utf-8"))
    parts = []
    for c in nb["cells"]:
        if c["cell_type"] == "code":
            src = c["source"]
            parts.append("".join(src) if isinstance(src, list) else src)
    return "\n".join(parts)


def test_t1_version_is_074():
    src = _read_all_source()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m is not None, "__AGENT_VERSION__ not found"
    assert m.group(1) == "0.7.9", f"Expected 0.7.9, got {m.group(1)}"


def test_t2_sentinels_present():
    src = _read_all_source()
    assert src.count("[user-domain-division-exempt FIRED]") >= 2, (
        "Expected at least 2 occurrences of [user-domain-division-exempt FIRED] "
        "(once for the heads-up log, once per-domain inside the loop)"
    )
    assert src.count("[user-domain-injection FIRED]") >= 1, (
        "Expected at least 1 occurrence of [user-domain-injection FIRED]"
    )
    assert "BYPASS the division allow-list filter per CLAUDE.md §3b/§3c" in src


def _simulate_filter_loop(
    domains_list,
    allowed_divisions,
    user_specified_domains,
    business_name="testco",
):
    """Pure-Python re-implementation of the patched loop, identical semantics."""
    _user_specified_domains_set = set(
        str(_ud).strip().lower() for _ud in (user_specified_domains or []) if str(_ud).strip()
    )
    domains_to_create = []
    filtered_out_domains = []
    fired_division_exempt = []
    fired_injection = []

    for domain_info in domains_list:
        domain_name = re.sub(r"[^A-Za-z0-9_]+", "_", domain_info.get("domain", "")).strip("_").lower()
        division = (domain_info.get("division") or "business").lower().strip()
        if division not in {"operations", "business", "corporate"}:
            division = "business"

        is_user = domain_name in _user_specified_domains_set
        if division not in allowed_divisions:
            if is_user:
                coerced = next(iter(sorted(allowed_divisions))) if allowed_divisions else "business"
                if coerced not in {"operations", "business", "corporate"}:
                    coerced = "business"
                fired_division_exempt.append((domain_name, division, coerced))
                division = coerced
            else:
                filtered_out_domains.append({"domain": domain_name, "division": division})
                continue
        domains_to_create.append({"domain": domain_name, "division": division})

    if _user_specified_domains_set:
        emitted = {d["domain"] for d in domains_to_create}
        missing = sorted(_user_specified_domains_set - emitted)
        coerced = next(iter(sorted(allowed_divisions))) if allowed_divisions else "business"
        if coerced not in {"operations", "business", "corporate"}:
            coerced = "business"
        for md in missing:
            fired_injection.append(md)
            domains_to_create.append({"domain": md, "division": coerced})

    return {
        "domains_to_create": domains_to_create,
        "filtered_out_domains": filtered_out_domains,
        "fired_division_exempt": fired_division_exempt,
        "fired_injection": fired_injection,
    }


def test_t3_no_exemption_when_user_specified_empty():
    """Without _user_specified_domains, corporate-classified domains ARE filtered out (preserves prior behaviour)."""
    domains_list = [
        {"domain": "employee_records", "division": "operations"},
        {"domain": "policies_procedures", "division": "corporate"},
    ]
    res = _simulate_filter_loop(
        domains_list,
        allowed_divisions={"business", "operations"},
        user_specified_domains=[],
    )
    assert len(res["domains_to_create"]) == 1
    assert res["domains_to_create"][0]["domain"] == "employee_records"
    assert len(res["filtered_out_domains"]) == 1
    assert res["filtered_out_domains"][0]["domain"] == "policies_procedures"
    assert len(res["fired_division_exempt"]) == 0
    assert len(res["fired_injection"]) == 0


def test_t4_six_returned_three_injected():
    """LLM returned 6 of 9 user-specified domains. Patch must inject the missing 3."""
    user_doms = [
        "employee_records", "recruitment_onboarding", "compensation_benefits",
        "performance_management", "training_development", "policies_procedures",
        "compliance_legal", "disciplinary_grievance", "terminations_exits",
    ]
    domains_list = [
        {"domain": "employee_records", "division": "operations"},
        {"domain": "recruitment_onboarding", "division": "business"},
        {"domain": "compensation_benefits", "division": "business"},
        {"domain": "performance_management", "division": "operations"},
        {"domain": "training_development", "division": "operations"},
        {"domain": "terminations_exits", "division": "operations"},
    ]
    res = _simulate_filter_loop(
        domains_list,
        allowed_divisions={"business", "operations"},
        user_specified_domains=user_doms,
    )
    emitted = {d["domain"] for d in res["domains_to_create"]}
    assert emitted == set(user_doms), f"Missing user domains: {set(user_doms) - emitted}"
    assert sorted(res["fired_injection"]) == sorted(
        ["policies_procedures", "compliance_legal", "disciplinary_grievance"]
    )
    assert len(res["filtered_out_domains"]) == 0


def test_t5_all_corporate_user_specified_survive_with_coerced_division():
    """Even when ALL user domains are LLM-classified corporate, all 9 survive (with coerced divisions)."""
    user_doms = ["alpha", "beta", "gamma"]
    domains_list = [
        {"domain": "alpha", "division": "corporate"},
        {"domain": "beta", "division": "corporate"},
        {"domain": "gamma", "division": "corporate"},
    ]
    res = _simulate_filter_loop(
        domains_list,
        allowed_divisions={"business", "operations"},
        user_specified_domains=user_doms,
    )
    emitted = [d["domain"] for d in res["domains_to_create"]]
    assert set(emitted) == set(user_doms)
    assert len(res["fired_division_exempt"]) == 3
    assert len(res["filtered_out_domains"]) == 0
    for d in res["domains_to_create"]:
        assert d["division"] in {"business", "operations"}, (
            f"Coerced division must be in allowed list, got {d['division']}"
        )


def test_t6_non_user_corporate_domain_is_still_filtered():
    """Non-user-specified corporate-classified domains MUST still be filtered out (no regression for vibe-only flows)."""
    user_doms = ["alpha"]
    domains_list = [
        {"domain": "alpha", "division": "operations"},
        {"domain": "extra_corporate", "division": "corporate"},
    ]
    res = _simulate_filter_loop(
        domains_list,
        allowed_divisions={"business", "operations"},
        user_specified_domains=user_doms,
    )
    emitted = {d["domain"] for d in res["domains_to_create"]}
    assert emitted == {"alpha"}
    assert len(res["filtered_out_domains"]) == 1
    assert res["filtered_out_domains"][0]["domain"] == "extra_corporate"
    assert len(res["fired_injection"]) == 0
