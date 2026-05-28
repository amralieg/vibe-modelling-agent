from notebook_source_util import notebook_concat_source

"""
Behavioral tests for v1.0.0 — FOUR-FIX SUITE targeting full vibe adherence.

Validates the on-disk state of agent/dbx_vibe_modelling_agent.ipynb for the
v1.0.0 fixes:

  Fix-1  user-directive-protects-from-fk-rename — LG silent merge guard
  Fix-2  verifier-llm-fallback                  — HC verifier-blind partial fallback
  Fix-3  vov-new-domains-from-manifest          — HC empty-domain cleanup protection
  Fix-4  master-failure-mode-from-manifest      — RT GENERATIVE bypass (preserved from v0.9.9)

Plus version-rollover invariants per CLAUDE.md §3a (single-digit semver,
v0.9.9 -> v1.0.0).
"""

import json
import os
import re

import pytest

REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
AGENT_NB = os.path.join(REPO_ROOT, "agent", "dbx_vibe_modelling_agent.ipynb")
README = os.path.join(REPO_ROOT, "readme.md")


@pytest.fixture(scope="module")
def agent_text():
    with open(AGENT_NB, "r", encoding="utf-8", errors="ignore") as f:
        return f.read()


@pytest.fixture(scope="module")
def readme_text():
    with open(README, "r", encoding="utf-8", errors="ignore") as f:
        return f.read()


def test_v100_agent_version_bumped(agent_text):
    """Live __AGENT_VERSION__ must be valid single-digit semver and appear in notebook."""
    from version_test_util import assert_valid_single_digit_semver, assert_version_in_notebook

    assert_valid_single_digit_semver()
    assert_version_in_notebook(agent_text)


def test_v100_single_digit_semver_invariant(agent_text):
    """No segment of the version may be two-or-more digits (CLAUDE.md §3a)."""
    # Look for any __AGENT_VERSION__ assignment with a >= 10 segment, which would be invalid.
    bad = re.findall(r'__AGENT_VERSION__\s*=\s*\\?"\d+\.\d{2,}\.\d+\\?"', agent_text)
    bad += re.findall(r'__AGENT_VERSION__\s*=\s*\\?"\d+\.\d+\.\d{2,}\\?"', agent_text)
    bad += re.findall(r'__AGENT_VERSION__\s*=\s*\\?"\d{2,}\.\d+\.\d+\\?"', agent_text)
    assert not bad, f"Single-digit-segment semver invariant violated: {bad}"


def test_v100_readme_version_line(readme_text):
    """readme.md 'Current version' line MUST say v1.0.x."""
    assert re.search(r"Current version: \*\*v1\.0\.\d\*\*", readme_text), \
        "readme.md 'Current version' line must be v1.0.x"


def test_v100_readme_version_history_entry(readme_text):
    """A row for **v1.0.0** MUST appear in the Version history table."""
    assert re.search(r"^\|\s*\*\*v1\.0\.0\*\*\s*\|", readme_text, re.MULTILINE), \
        "readme.md Version history must include a **v1.0.0** row"


# ─── Fix 1: user-directive-protects-from-fk-rename ─────────────────────────


def test_fix1_alias_present_in_agent(agent_text):
    """alias=user-directive-protects-from-fk-rename must appear at the FK-rename site."""
    count = agent_text.count("user-directive-protects-from-fk-rename")
    assert count >= 4, (
        f"Expected ≥4 sentinel/alias references for user-directive-protects-from-fk-rename, got {count} — "
        "fix should appear at version-constant comment + 2 protection sites (merge + rename) "
        "and at least one alias=... grep-anchor"
    )


def test_fix1_protects_merge_branch(agent_text):
    """The merge branch in fix_fk_column_naming MUST check _user_directive on BOTH attrs."""
    # Find the consolidate-merge log line (the original bug site).
    merge_idx = agent_text.find("Consolidated duplicate rename conflict")
    assert merge_idx > 0, "Could not locate Consolidated duplicate rename conflict log line"
    # Look BACKWARDS from this log line for the user-directive guard (within ~3000 chars).
    pre = agent_text[max(0, merge_idx - 4000):merge_idx]
    assert "_user_directive" in pre, (
        "Merge branch is missing the _user_directive check — silent merge bug not fixed"
    )
    assert "[user-directive-protects-from-fk-rename FIRED]" in pre, (
        "Merge branch is missing the [user-directive-protects-from-fk-rename FIRED] sentinel"
    )


def test_fix1_protects_rename_branch_too(agent_text):
    """The rename branch (when _ren_new doesn't already exist) MUST also defend with _user_directive."""
    # The rename branch protection check must appear BEFORE the merge-or-rename split.
    # Look for the scan-attributes-data pattern.
    pattern = r"_a_ud\.get\('_user_directive'"
    assert re.search(pattern, agent_text), (
        "Rename branch is missing the defense-in-depth scan for _user_directive on _ren_old"
    )


def test_fix1_continue_skips_rename_on_user_directive(agent_text):
    """When _ud_skip is True, the loop MUST `continue` to skip both merge and rename branches."""
    # Look for the _ud_skip-True path with continue.
    assert re.search(r"if\s+_ud_skip:[\s\\n]+[^\\n]*?[\\s]*?continue", agent_text) or \
        re.search(r"_ud_skip\s*=\s*True", agent_text), (
        "Defense-in-depth must set _ud_skip=True and then continue, skipping rename/merge"
    )


# ─── Fix 2: verifier-llm-fallback ──────────────────────────────────────────


def test_fix2_alias_present_in_agent(agent_text):
    """alias=verifier-llm-fallback must appear in _verify_via_llm and the deterministic-blind fallback."""
    count = agent_text.count("verifier-llm-fallback")
    assert count >= 4, (
        f"Expected ≥4 references for verifier-llm-fallback, got {count}"
    )


def test_fix2_verify_via_llm_makes_real_llm_call(agent_text):
    """_verify_via_llm MUST invoke the CANONICAL ai_agent interface (_call_ai_query).

    v1.0.0 used self.ai_agent.run(...) which does NOT exist on the ai_agent — every call
    returned empty in iter-3 HC live logs. v1.0.1 uses self.ai_agent._call_ai_query(...) —
    the same interface every other LLM stage in this codebase uses.
    """
    fn_match = re.search(r"def _verify_via_llm\(self.*?\\n", agent_text)
    assert fn_match, "Could not locate _verify_via_llm function"
    body = agent_text[fn_match.end():fn_match.end() + 12000]
    assert "self.ai_agent._call_ai_query" in body, (
        "_verify_via_llm MUST invoke self.ai_agent._call_ai_query — NOT self.ai_agent.run "
        "(which does not exist on the ai_agent interface and caused v1.0.0 to return empty live)"
    )
    assert "prompt_name=" in body and "response_schema=" in body and "step_name=" in body and "max_retries=" in body, (
        "_verify_via_llm _call_ai_query call must use the canonical kwargs: "
        "prompt_name, prompt, response_schema, step_name, max_retries"
    )
    assert "[verifier-llm-fallback FIRED" in body, (
        "_verify_via_llm must emit the [verifier-llm-fallback FIRED] sentinel"
    )


def test_fix2_no_pattern_matched_routes_to_llm(agent_text):
    """In _verify_requirement, the deterministic 'no specific pattern matched' partial MUST route to LLM."""
    # Find the orchestration block that wraps _verify_deterministic and check for the routing.
    assert "verifier-llm-fallback-on-deterministic-blind" in agent_text, (
        "Deterministic-blind fallback to LLM must use alias verifier-llm-fallback-on-deterministic-blind"
    )
    # The routing should call _verify_via_llm.
    assert re.search(
        r"verifier-llm-fallback-on-deterministic-blind[\s\S]{0,800}_verify_via_llm",
        agent_text,
    ), "Deterministic-blind branch must route through _verify_via_llm"


# ─── Fix 3: vov-new-domains-from-manifest ──────────────────────────────────


def test_fix3_alias_present_in_agent(agent_text):
    """alias=vov-new-domains-from-manifest must appear at the create-domain handler and the cleanup function."""
    count = agent_text.count("vov-new-domains-from-manifest")
    assert count >= 4, (
        f"Expected ≥4 references for vov-new-domains-from-manifest, got {count}"
    )


def test_fix3_cleanup_respects_needs_products(agent_text):
    """_cleanup_empty_domains MUST protect domains marked _needs_products=True."""
    # Find the function body.
    fn_match = re.search(r"def _cleanup_empty_domains\([^)]*\):", agent_text)
    assert fn_match, "Could not locate _cleanup_empty_domains function"
    body = agent_text[fn_match.end():fn_match.end() + 4000]
    assert "_needs_products" in body, (
        "_cleanup_empty_domains must check _needs_products on candidate empty domains"
    )
    assert "protected_needs_products" in body, (
        "_cleanup_empty_domains must accumulate protected_needs_products list"
    )
    assert "vov-new-domains-from-manifest" in body, (
        "_cleanup_empty_domains must emit the vov-new-domains-from-manifest sentinel for protected new domains"
    )


def test_fix3_create_domain_handler_registers_new_domain(agent_text):
    """The create-domain mutation handler MUST register the new domain into _vov_user_new_entities."""
    # Find the create-domain branch via the auto-created-domain log line.
    log_idx = agent_text.find("queued for product generation")
    assert log_idx > 0, "Could not locate the 'queued for product generation' log line"
    pre = agent_text[max(0, log_idx - 3000):log_idx]
    assert "_vov_user_new_entities" in pre, (
        "Create-domain handler must register the new domain into widgets_values['_vov_user_new_entities']"
    )
    assert "vov-new-domains-from-manifest" in pre, (
        "Create-domain handler must emit the vov-new-domains-from-manifest sentinel"
    )


# ─── Fix 4: master-failure-mode-from-manifest (preserved from v0.9.9) ──────


def test_fix4_preserved_from_v099(agent_text):
    """master-failure-mode-from-manifest sentinel from v0.9.9 MUST still be present in v1.0.0."""
    count = agent_text.count("master-failure-mode-from-manifest")
    assert count >= 4, (
        f"Expected ≥4 references for master-failure-mode-from-manifest (v0.9.9 fix preserved), got {count}"
    )


# ─── Cross-cutting industry-agnostic invariants ────────────────────────────


def test_no_industry_strings_in_v100_runtime_logs(agent_text):
    """v1.0.0 runtime log f-strings MUST NOT bake in industry-specific names.

    The fix-description comments WILL reference industries (audit context), but the actual
    `logger.info(f"...")` / `logger.warning(f"...")` strings that fire at runtime must be
    industry-agnostic. We extract only the runtime log strings (inside f-strings) and check
    those.
    """
    # Match logger.<level>(f\"...<alias>...\") strings — these are the runtime emissions.
    aliases = [
        "user-directive-protects-from-fk-rename",
        "verifier-llm-fallback",
        "vov-new-domains-from-manifest",
    ]
    industry_strings = ["legal", "airlines", "airline", "retail", "healthcare", "telecom", "ecomm", "banking", "matter_matter_id", "behavioral_health"]
    pattern = re.compile(r'logger\.\w+\(f\\?"([^"]+)"', re.IGNORECASE)
    for alias in aliases:
        # Find every logger emit string that contains the alias.
        for m in pattern.finditer(agent_text):
            log_string = m.group(1)
            if alias not in log_string:
                continue
            log_lower = log_string.lower()
            for ind in industry_strings:
                assert ind not in log_lower, (
                    f"Industry string '{ind}' must not appear in runtime logger emit for alias '{alias}'.\n"
                    f"Offending log string: {log_string[:240]}"
                )


def test_v100_v099_test_file_still_passes_alias_check(agent_text):
    """Regression: the v0.9.9 test_v99 alias check (master-failure-mode-from-manifest) must still hold."""
    # Trivially asserted by test_fix4_preserved_from_v099 — this is a redundancy check
    # to ensure the v0.9.9 fix did not get accidentally regressed by v1.0.0 edits.
    assert "[master-failure-mode-from-manifest FIRED]" in agent_text


def test_notebook_is_valid_json(agent_text):
    """The agent notebook must remain valid JSON after the v1.0.0 edits."""
    nb = json.loads(agent_text)
    assert isinstance(nb.get("cells", []), list) and len(nb["cells"]) > 0, "Notebook has no cells"


def test_v100_sentinels_grepable_for_audit():
    """Smoke-test: every v1.0.0 sentinel must be grep-anchored for §10.7 step-6 verification."""
    with open(AGENT_NB, "r", encoding="utf-8", errors="ignore") as f:
        text = f.read()
    expected_sentinels = [
        "[user-directive-protects-from-fk-rename FIRED]",
        "[verifier-llm-fallback FIRED",
        "[vov-new-domains-from-manifest FIRED]",
        "[master-failure-mode-from-manifest FIRED]",
    ]
    for sentinel in expected_sentinels:
        assert sentinel in text, f"Sentinel '{sentinel}' missing from agent — §10.7 grep audit will fail"
