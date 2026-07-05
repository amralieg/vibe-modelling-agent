from notebook_source_util import notebook_concat_source

"""Behavioral tests for v1.0.1 — verifier-llm-fallback-call-fix.

v1.0.0 introduced the verifier-llm-fallback to route deterministic-blind verifier
results to an LLM. The wiring (routing + sentinel) was correct, BUT the actual
LLM invocation called self.ai_agent.run(prompt, response_schema=...) which does
NOT exist on the ai_agent interface used by this codebase. iter-3 HC live logs
proved every _verify_via_llm call returned the "LLM returned empty" partial
because the .run() attribute lookup failed silently.

v1.0.1 routes the call through self.ai_agent._call_ai_query(...) — the canonical
interface every other LLM stage (vibe master, master analyze, mutation generation,
etc.) uses. Same signature: prompt_name, prompt, response_schema, step_name, max_retries.
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


def _agent_version_tuple(agent_text):
    """Parse the running __AGENT_VERSION__ into a (major, minor, patch) tuple."""
    m = re.search(r'__AGENT_VERSION__\s*=\s*\\?"(\d+)\.(\d+)\.(\d+)\\?"', agent_text)
    assert m, "__AGENT_VERSION__ literal not found"
    return tuple(int(g) for g in m.groups())


def test_v101_agent_version(agent_text):
    """__AGENT_VERSION__ MUST be v1.0.1 or higher.

    The engine build advanced past the 1.0.x line to 4.x; this test stays forward-compatible
    by parsing the actual version tuple. The v1.0.1 contract (_call_ai_query, kwargs, try/except)
    is asserted independently by the tests below.
    """
    assert _agent_version_tuple(agent_text) >= (1, 0, 1), (
        f"__AGENT_VERSION__ must be >= 1.0.1; got {_agent_version_tuple(agent_text)}"
    )


def test_v101_single_digit_semver(agent_text):
    """Every segment must remain single-digit per CLAUDE.md §3a."""
    bad = re.findall(r'__AGENT_VERSION__\s*=\s*\\?"\d+\.\d{2,}\.\d+\\?"', agent_text)
    bad += re.findall(r'__AGENT_VERSION__\s*=\s*\\?"\d+\.\d+\.\d{2,}\\?"', agent_text)
    bad += re.findall(r'__AGENT_VERSION__\s*=\s*\\?"\d{2,}\.\d+\.\d+\\?"', agent_text)
    assert not bad, f"Single-digit segment invariant violated: {bad}"


def test_v101_readme_current_version(readme_text):
    """readme.md 'Current version' is the PUBLIC release label (__RELEASE_VERSION__
    = v0.8.0 decoupling), continuous from main's v0.7.7."""
    assert "Current version: **v0.8.0**" in readme_text, (
        "readme.md 'Current version' line must be the public release v0.8.0"
    )


def test_v101_readme_history_row(readme_text):
    """readme.md Version history MUST include a **v1.0.1** row."""
    assert re.search(r"^\|\s*\*\*v1\.0\.1\*\*\s*\|", readme_text, re.MULTILINE), (
        "readme.md Version history must include a **v1.0.1** row"
    )


def test_v101_alias_present(agent_text):
    """alias=verifier-llm-fallback-call-fix MUST appear at the call-site fix."""
    count = agent_text.count("verifier-llm-fallback-call-fix")
    assert count >= 2, (
        f"Expected >=2 sentinel/alias refs for verifier-llm-fallback-call-fix, got {count}"
    )


def test_v101_call_uses_canonical_interface(agent_text):
    """_verify_via_llm MUST call self.ai_agent._call_ai_query with the canonical kwargs."""
    fn_match = re.search(r"def _verify_via_llm\(self.*?\\n", agent_text)
    assert fn_match, "Could not locate _verify_via_llm"
    # _verify_via_llm grew across epochs (budget guards, deterministic rescue); the canonical
    # LLM call now sits deeper in the body, so scan a window that spans the whole function.
    body = agent_text[fn_match.end():fn_match.end() + 40000]
    assert "self.ai_agent._call_ai_query" in body, (
        "_verify_via_llm must invoke self.ai_agent._call_ai_query "
        "(NOT self.ai_agent.run which does not exist)"
    )
    for kw in ("prompt_name=", "prompt=", "response_schema=", "step_name=", "max_retries="):
        assert kw in body, f"_call_ai_query call missing canonical kwarg: {kw}"


def _strip_comments(text):
    """Strip Python comment lines (everything after # to end-of-line) from a code blob.

    Handles the notebook-JSON form by walking line-by-line and ignoring everything
    after the first un-quoted '#'. Conservative: only strips ' # ' / start-of-line '#'
    patterns so '# ' inside string literals is preserved if it doesn't begin a comment.
    """
    out_lines = []
    for line in text.splitlines():
        # In the notebook JSON each cell line is a quoted string like '    "..."'.
        # We approximate: drop everything after the FIRST '#' that follows whitespace.
        stripped = re.sub(r"\s+#[^\"\n]*", "", line)
        out_lines.append(stripped)
    return "\n".join(out_lines)


def test_v101_no_legacy_run_call_outside_comments(agent_text):
    """The buggy self.ai_agent.run(...) call from v1.0.0 MUST be gone from _verify_via_llm RUNTIME code.

    Comments inside the function MAY mention `self.ai_agent.run(...)` as historical context for the fix
    (the v1.0.1 ROOT-CAUSE FIX comment explicitly does so). We strip comments before asserting.
    """
    fn_match = re.search(r"def _verify_via_llm\(self.*?\\n", agent_text)
    assert fn_match
    body = agent_text[fn_match.end():fn_match.end() + 12000]
    code_only = _strip_comments(body)
    assert "self.ai_agent.run(" not in code_only, (
        "_verify_via_llm still has self.ai_agent.run(...) in CODE (not comment) — the v1.0.0 bug is not fixed"
    )


def test_v101_call_in_try_except(agent_text):
    """The _call_ai_query call MUST be wrapped in try/except so a transient failure becomes a partial, not a crash.

    Strip comments so we find the CODE call site (not the historical-context comment that also mentions
    self.ai_agent._call_ai_query as part of the v1.0.1 fix description).
    """
    fn_match = re.search(r"def _verify_via_llm\(self.*?\\n", agent_text)
    assert fn_match
    body = agent_text[fn_match.end():fn_match.end() + 40000]
    code_only = _strip_comments(body)
    # v1.0.8 (verifier-rescue-retry-on-transient-error) refactored the direct
    # self.ai_agent._call_ai_query(...) invocation into the transient-retry wrapper
    # self._v108_call_with_transient_retry(...), which itself delegates to _call_ai_query
    # with the identical canonical kwargs. Accept either code call site.
    call_idx = code_only.find("self.ai_agent._call_ai_query(")
    if call_idx < 0:
        call_idx = code_only.find("self._v108_call_with_transient_retry(")
    assert call_idx > 0, (
        "Could not find the canonical LLM call site (self.ai_agent._call_ai_query or the "
        "_v108_call_with_transient_retry wrapper) in non-comment code"
    )
    pre = code_only[max(0, call_idx - 1500):call_idx]
    post = code_only[call_idx:call_idx + 2000]
    assert "try:" in pre, (
        "_call_ai_query invocation must be downstream of a try: block so transient errors don't crash the verifier"
    )
    assert "except" in post, (
        "_call_ai_query invocation must be upstream of an except clause so transient errors are caught"
    )


def test_v101_returns_v101_evidence_on_empty(agent_text):
    """v1.0.1 evidence string ('verifier-llm-fallback FIRED v1.0.1' as a soft-accept) was
    SUPERSEDED by v1.0.3's [verifier-llm-fallback-deterministic-rescue FIRED v1.0.3]. The v1.0.1
    behavior was a §11.5 forbidden soft-accept (returned status=partial with 'LLM returned empty');
    v1.0.3 replaced it with a deterministic rescue that returns 'fulfilled' or 'failed'. We assert
    EITHER the v1.0.1 sentinel OR the v1.0.3 successor is present in the function body."""
    fn_match = re.search(r"def _verify_via_llm\(self.*?\\n", agent_text)
    assert fn_match
    body = agent_text[fn_match.end():fn_match.end() + 30000]
    has_v101 = "verifier-llm-fallback FIRED v1.0.1" in body
    has_v103 = "verifier-llm-fallback-deterministic-rescue FIRED v1.0.3" in body
    assert has_v101 or has_v103, (
        "Empty-response handling must be tagged v1.0.1 (legacy soft-accept) OR v1.0.3 "
        "(deterministic-rescue successor) so audits can identify the active behavior"
    )


def test_v101_industry_agnostic(agent_text):
    """v1.0.1 fix must not bake industry-specific strings into runtime log emissions."""
    industries = ["legal", "airlines", "airline", "retail", "healthcare", "telecom",
                  "ecomm", "banking", "matter_matter_id", "behavioral_health"]
    pattern = re.compile(r'logger\.\w+\(f\\?"([^"]+)"', re.IGNORECASE)
    for m in pattern.finditer(agent_text):
        s = m.group(1)
        if "verifier-llm-fallback-call-fix" not in s:
            continue
        s_lower = s.lower()
        for ind in industries:
            assert ind not in s_lower, (
                f"Industry string '{ind}' in v1.0.1 runtime log: {s[:200]}"
            )


def test_v101_notebook_is_valid_json(agent_text):
    """Agent notebook must remain valid JSON after v1.0.1 edit."""
    nb = json.loads(agent_text)
    assert isinstance(nb.get("cells", []), list) and len(nb["cells"]) > 0


def test_v101_v100_fixes_still_present(agent_text):
    """The four v1.0.0 protections MUST still be reachable in the engine.

    Two of the original v1.0.0 sentinel STRINGS were renamed as the engine evolved through
    the 2.x-4.x epochs, but the underlying protections live on under their successors:
      - user-directive FK/attribute-rename protection  -> [user-renamed-attribute-record FIRED]
      - manifest-derived master failure handling        -> [vibe-master-retry-on-zero-actions FIRED
    The other two v1.0.0 sentinels are unchanged.
    """
    for sentinel in (
        "[user-renamed-attribute-record FIRED]",
        "[verifier-llm-fallback FIRED",
        "[vov-new-domains-from-manifest FIRED]",
        "[vibe-master-retry-on-zero-actions FIRED",
    ):
        assert sentinel in agent_text, (
            f"v1.0.0-lineage protection sentinel '{sentinel}' missing — engine regressed a prior fix"
        )
