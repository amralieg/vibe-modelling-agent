"""Tests for v0.8.3 regression fixes from the Airlines MVM v1->v2 quality
report (2026-04-24).

Each fix carries an alias of the form `v0.8.3 Q<N>` where N maps to the
issue tag in the report. Reverting any fix breaks at least one test.

Issue index <-> alias map:
    R1   -> v0.8.3 Q1   vibe-modeling-of-version IN-PLACE OVERWRITE
    F2re -> v0.8.3 Q2   model_architect_review soft-accepts IMMUTABLE VIOLATION
    R3   -> v0.8.3 Q3   log file truncated to 0 bytes on SUCCESS
    R6   -> v0.8.3 Q6   metric-view bare status/type column drop (DESCRIBE rewrite)
    R7   -> v0.8.3 Q7   MODEL-PARAMS LLM skips required subdomain fields
    R8   -> v0.8.3 Q8   FK cycle-breaker deterministic pass-2
"""
import json
import os
import re
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_notebook_source(path: Path) -> str:
    nb = json.loads(path.read_text(encoding="utf-8"))
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        parts.append(src)
    return "\n".join(parts)


@pytest.fixture(scope="module")
def agent_src() -> str:
    return _read_notebook_source(NOTEBOOK_PATH)


@pytest.fixture(scope="module")
def helpers():
    import agent_helpers as ah
    return ah


# =====================================================================
# R1 -- v0.8.3 Q1 -- vibe-version-must-advance
# =====================================================================

class TestR1VibeVersionMustAdvance:
    def test_q1_alias_present(self, agent_src):
        assert "v0.8.3 Q1" in agent_src
        assert "vibe-version-must-advance" in agent_src

    def test_helper_exists(self, agent_src):
        assert "def _assert_vibe_version_advances(" in agent_src

    def test_helper_callable(self, helpers):
        assert hasattr(helpers, "_assert_vibe_version_advances")

    def test_helper_no_raise_on_unrelated_op(self, helpers):
        # Op is NOT vibe modeling of version -> must NOT raise even if cur==base
        helpers._assert_vibe_version_advances(
            {"operation": "new base model", "current_version": "1", "base_version_for_review": "1"},
            "test"
        )

    def test_helper_raises_when_cur_equals_base(self, helpers):
        with pytest.raises(ValueError) as exc:
            helpers._assert_vibe_version_advances(
                {"operation": "vibe modeling of version", "current_version": "1", "base_version_for_review": "1"},
                "test_callsite"
            )
        msg = str(exc.value).lower()
        assert "vibe-version-invariant" in msg
        assert "test_callsite" in msg
        assert "advance" in msg or "clobber" in msg

    def test_helper_raises_when_cur_empty(self, helpers):
        with pytest.raises(ValueError):
            helpers._assert_vibe_version_advances(
                {"operation": "vibe modeling of version", "current_version": "", "base_version_for_review": "1"},
                "test"
            )

    def test_helper_raises_when_base_empty(self, helpers):
        with pytest.raises(ValueError):
            helpers._assert_vibe_version_advances(
                {"operation": "vibe modeling of version", "current_version": "2", "base_version_for_review": ""},
                "test"
            )

    def test_helper_passes_when_cur_advances(self, helpers):
        helpers._assert_vibe_version_advances(
            {"operation": "vibe modeling of version", "current_version": "2", "base_version_for_review": "1"},
            "test"
        )

    def test_helper_handles_none_widgets(self, helpers):
        # Should not raise on None / empty -- just no-op (op missing -> early return)
        helpers._assert_vibe_version_advances(None, "test")
        helpers._assert_vibe_version_advances({}, "test")

    def test_helper_invoked_at_three_callsites(self, agent_src):
        # Invariant must be asserted at 3 critical points:
        #   1) end of step_setup_and_clean (resolver exit)
        #   2) entry of step_generate_data_model_json (write barrier)
        #   3) entry of step_consolidate_and_cleanup (final-merge barrier)
        # Total >=4 references (def + 3 calls).
        n = len(re.findall(r"_assert_vibe_version_advances\s*\(", agent_src))
        assert n >= 4, (
            f"Expected >=4 references (1 def + 3 callsites), got {n}. "
            f"Defense-in-depth requires the invariant to fire at all 3 write barriers."
        )


# =====================================================================
# F2-regression -- v0.8.3 Q2 -- immutable-violation-critical
# =====================================================================

class TestF2RegImmutableViolationCritical:
    def test_q2_alias_present(self, agent_src):
        assert "v0.8.3 Q2" in agent_src
        assert "immutable-violation-critical" in agent_src

    def test_immutable_patterns_in_critical_list(self, agent_src):
        m = re.search(
            r"critical_error_patterns\s*=\s*\[(.*?)\]",
            agent_src,
            re.DOTALL,
        )
        assert m, "Could not locate critical_error_patterns list"
        block = m.group(1).lower()
        # The 6 sentinel substrings must all appear -- defends against the
        # IMMUTABLE VIOLATION soft-accept observed in v0.8.2 Airlines run.
        for needle in [
            "immutable violation",
            "cannot move protected",
            "cannot rename protected",
            "cannot remove protected",
            "cannot delete protected",
            "protected product",
        ]:
            assert needle in block, (
                f"'{needle}' MUST be in critical_error_patterns so the soft-accept "
                f"path at the end of smart_worker_loop does NOT bypass it."
            )

    def test_critical_list_no_tautology(self, agent_src):
        # The patterns must REJECT genuine immutable-violation messages and ACCEPT
        # benign ones. Build a fake check that mirrors the runtime logic.
        m = re.search(
            r"critical_error_patterns\s*=\s*\[(.*?)\]",
            agent_src,
            re.DOTALL,
        )
        block = m.group(1)
        # Extract quoted entries
        patterns = re.findall(r"'([^']+)'|\"([^\"]+)\"", block)
        patterns = [p[0] or p[1] for p in patterns if (p[0] or p[1])]

        def _matches(err_msg):
            low = err_msg.lower()
            return any(p.lower() in low for p in patterns)

        # MUST match
        assert _matches("IMMUTABLE VIOLATION: Cannot move protected product 'passenger.ticket'")
        assert _matches("IMMUTABLE VIOLATION: Cannot rename protected product 'flight.leg'")
        # MUST NOT match (benign warning)
        assert not _matches("Domain enrichment completed successfully")
        assert not _matches("Sample generation produced 100 rows")


# =====================================================================
# R3 -- v0.8.3 Q3 -- log-no-truncate-on-success
# =====================================================================

class TestR3LogNoTruncateOnSuccess:
    def test_q3_alias_present(self, agent_src):
        assert "v0.8.3 Q3" in agent_src
        assert "log-no-truncate-on-success" in agent_src

    def test_safe_volume_flush_helper_exists(self, agent_src):
        assert "def _safe_volume_flush(" in agent_src

    def test_flush_helper_uses_size_tracking(self, agent_src):
        # The helper must (a) read current local size and (b) compare against
        # last-flushed size per destination so truncation is impossible.
        m = re.search(
            r"def _safe_volume_flush\(.*?(?=\n\s*def [a-zA-Z_]|\n\s*_volume_log_flush_loop)",
            agent_src,
            re.DOTALL,
        )
        assert m, "Could not locate _safe_volume_flush body"
        body = m.group(0)
        assert "_last_flushed_bytes" in body, (
            "Helper must track per-destination last-flushed size to detect shrink"
        )
        assert "getsize" in body, "Helper must read current local size"
        assert "skipping flush" in body.lower() or "shrunk" in body.lower(), (
            "Helper must SKIP (not perform) the flush when local has shrunk"
        )

    def test_periodic_loop_uses_helper(self, agent_src):
        m = re.search(
            r"def _volume_log_flush_loop\(.*?(?=\n\S)",
            agent_src,
            re.DOTALL,
        )
        assert m, "Could not locate _volume_log_flush_loop body"
        body = m.group(0)
        # BOTH the periodic flush AND the post-loop final flush must go
        # through _safe_volume_flush. Two call sites required.
        n = body.count("_safe_volume_flush(")
        assert n >= 2, (
            f"Expected >=2 _safe_volume_flush calls in the loop (periodic + final), got {n}. "
            f"The post-loop final flush is the one that truncates v2's log on SUCCESS — "
            f"it MUST go through the size-tracking helper, not raw _safe_copy_local_to_dbfs."
        )


# =====================================================================
# R6 -- v0.8.3 Q6 -- metric-view-bare-via-describe
# =====================================================================

class TestR6MetricViewBareViaDescribe:
    def test_q6_alias_present(self, agent_src):
        assert "v0.8.3 Q6" in agent_src
        assert "metric-view-bare-via-describe" in agent_src

    def test_describe_rewrite_helper_exists(self, agent_src):
        assert "def _rewrite_via_describe(" in agent_src

    def test_describe_helper_uses_describe_table(self, agent_src):
        m = re.search(
            r"def _rewrite_via_describe\(.*?(?=\n\S)",
            agent_src,
            re.DOTALL,
        )
        assert m, "Could not locate _rewrite_via_describe body"
        body = m.group(0)
        assert "DESCRIBE TABLE" in body, "Helper must query schema via DESCRIBE TABLE"
        assert "endswith" in body, "Helper must search for *_<bare> suffix matches"
        assert "UNRESOLVED_COLUMN" not in body or "with name" in body, (
            "Helper must extract the bare column name from the unresolved-column message"
        )

    def test_describe_helper_integrated_into_tracked_sql(self, agent_src):
        # The retry tier must be invoked from _tracked_sql, positioned between
        # the spark-suggestion rewrite and the strip/safe fallbacks.
        m = re.search(
            r"def _tracked_sql\(.*?(?=\ndef [a-zA-Z_])",
            agent_src,
            re.DOTALL,
        )
        assert m, "Could not locate _tracked_sql body"
        body = m.group(0)
        assert "_rewrite_via_describe" in body, (
            "_tracked_sql must invoke _rewrite_via_describe as a retry tier "
            "before falling back to strip/safe"
        )

    def test_prompt_warns_against_bare_columns(self, agent_src):
        # DOMAIN_METRICS_PROMPT is built via multi-section r-string concatenation
        # so we anchor on the assignment and read up to the next prompt template
        # assignment. The BARE-COLUMN HARD RULE sentinel must appear in that window.
        start = agent_src.find('PROMPT_TEMPLATES["DOMAIN_METRICS_PROMPT"]')
        assert start != -1, "Could not locate DOMAIN_METRICS_PROMPT assignment"
        # Find the next PROMPT_TEMPLATES assignment after this one
        nxt = agent_src.find('PROMPT_TEMPLATES["', start + 1)
        if nxt == -1:
            nxt = len(agent_src)
        body = agent_src[start:nxt]
        assert "BARE-COLUMN HARD RULE" in body, (
            "DOMAIN_METRICS_PROMPT must contain a BARE-COLUMN HARD RULE warning "
            "that forbids the LLM from emitting generic 'status'/'type' column names"
        )
        for word in ["status", "type", "name", "code"]:
            assert word in body.lower(), f"Reserved bare name '{word}' must appear in the warning"


# =====================================================================
# R7 -- v0.8.3 Q7 -- model-params-subdomain-required
# =====================================================================

class TestR7ModelParamsSubdomainRequired:
    def test_q7_alias_present(self, agent_src):
        assert "v0.8.3 Q7" in agent_src
        assert "model-params-subdomain-required" in agent_src

    def test_required_keys_include_subdomain(self, agent_src):
        # The validate_model_generation_parameters method must require
        # min/max_business_subdomains + min_products_per_subdomain.
        m = re.search(
            r"def validate_model_generation_parameters\(.*?required_param_keys\s*=\s*\[(.*?)\]",
            agent_src,
            re.DOTALL,
        )
        assert m, "Could not locate required_param_keys in validate_model_generation_parameters"
        block = m.group(1)
        for needle in [
            "min_business_subdomains",
            "max_business_subdomains",
            "min_products_per_subdomain",
        ]:
            assert needle in block, (
                f"'{needle}' MUST be in required_param_keys so the LLM is forced to "
                f"emit it (R7: v0.8.2 silently fell back to midpoints when LLM omitted)."
            )

    def test_prompt_lists_subdomain_keys(self, agent_src):
        # The MODEL_GENERATION_PARAMETER_PROMPT is built via multi-section r-string
        # concatenation. Anchor on the assignment and read until the next
        # PROMPT_TEMPLATES entry. The subdomain keys MUST appear in that window.
        start = agent_src.find('PROMPT_TEMPLATES["MODEL_GENERATION_PARAMETER_PROMPT"]')
        assert start != -1, "Could not locate MODEL_GENERATION_PARAMETER_PROMPT assignment"
        nxt = agent_src.find('PROMPT_TEMPLATES["', start + 1)
        if nxt == -1:
            nxt = len(agent_src)
        body = agent_src[start:nxt]
        for needle in [
            "min_business_subdomains",
            "max_business_subdomains",
            "min_products_per_subdomain",
        ]:
            assert needle in body, (
                f"MODEL_GENERATION_PARAMETER_PROMPT output schema MUST list '{needle}' "
                f"so the LLM emits the field instead of silently omitting."
            )


# =====================================================================
# R8 -- v0.8.3 Q8 -- cycle-breaker-deterministic-pass2
# =====================================================================

class TestR8CycleBreakerDeterministicPass2:
    def test_q8_alias_present(self, agent_src):
        assert "v0.8.3 Q8" in agent_src
        assert "cycle-breaker-deterministic-pass2" in agent_src

    def test_pass2_uses_heuristic_breaker(self, agent_src):
        # The pass-2 fallback must invoke _break_cycles_heuristic_internal
        # within step_finalize_model_before_physical_schema, after the
        # LLM-based pass and gated on _fin_remaining.
        m = re.search(
            r"def step_finalize_model_before_physical_schema\(.*?(?=\ndef [a-zA-Z_])",
            agent_src,
            re.DOTALL,
        )
        assert m, "Could not locate step_finalize_model_before_physical_schema"
        body = m.group(0)
        assert "v0.8.3 Q8" in body, "Pass-2 sentinel must live inside the finalize step"
        assert "_break_cycles_heuristic_internal" in body, (
            "Pass-2 must fall back to the deterministic heuristic breaker"
        )
        # Must run AFTER LLM retries are exhausted (i.e. gated on residual cycles).
        assert "_fin_remaining" in body, (
            "Pass-2 must be gated on residual cycles after the LLM-based breaker"
        )
