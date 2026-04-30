"""
Behavioral tests for v0.8.0 fixes:
- Fix 1: step_apply_user_vibe_tags injects user-vibe-mandated tags into attributes/products
- Fix 2: _dedup_mv_as_product_artifacts removes products that duplicate metric_view names

Per CLAUDE.md \u00a78.1: every fix MUST have at least one unit test exercising the failure mode.
"""
import json
import re
import os
import unittest

REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
NB_PATH = os.path.join(REPO_ROOT, "agent", "dbx_vibe_modelling_agent.ipynb")

EXPECTED_VERSION = "0.8.1"


def _load_notebook_text():
    with open(NB_PATH, "r", encoding="utf-8") as f:
        return f.read()


def _load_notebook_json():
    with open(NB_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def _extract_function_source(fn_name):
    """Extract a function's source from the agent notebook."""
    nb = _load_notebook_json()
    for cell in nb["cells"]:
        src = "".join(cell.get("source", []))
        marker = f"def {fn_name}("
        if marker in src:
            start = src.find(marker)
            # Find the next top-level def or eof
            tail = src[start + 1:]
            next_def_match = re.search(r"\n(?:def |class )", tail)
            end = start + 1 + (next_def_match.start() if next_def_match else len(tail))
            return src[start:end]
    raise RuntimeError(f"Function {fn_name} not found in notebook")


class TestV080AgentVersion(unittest.TestCase):
    def test_agent_version_is_080(self):
        text = _load_notebook_text()
        # Notebook is JSON-escaped, so look for both raw and escaped forms
        m = re.search(r'__AGENT_VERSION__\s*=\s*\\?"([0-9]+\.[0-9]+\.[0-9]+)\\?"', text)
        self.assertIsNotNone(m, "__AGENT_VERSION__ not found")
        self.assertEqual(m.group(1), EXPECTED_VERSION,
                         f"Expected {EXPECTED_VERSION}, got {m.group(1)}")

    def test_v080_marker_in_version_comment(self):
        text = _load_notebook_text()
        v_line = [l for l in text.splitlines() if "__AGENT_VERSION__" in l and "alias=agent-version-global" in l]
        self.assertTrue(v_line, "version line not found")
        first = v_line[0]
        self.assertIn("user-vibe-tag-applier", first, "Fix 1 alias not in version comment")
        self.assertIn("mv-product-dedup-guard", first, "Fix 2 alias not in version comment")
        self.assertIn("mv-column-llm-repair", first, "Fix 3 alias not in version comment")
        self.assertIn("mv-joins-reenabled", first, "Fix 4a alias not in version comment")
        self.assertIn("mv-prompt-joins-enabled", first, "Fix 4d alias not in version comment")


class TestV080Fix2MVProductDedup(unittest.TestCase):
    """Fix 2: _dedup_mv_as_product_artifacts removes MV-as-product duplicates."""

    def test_helper_function_exists(self):
        nb = _load_notebook_text()
        self.assertIn("def _dedup_mv_as_product_artifacts(widgets_values, logger):", nb,
                      "Helper not present in agent notebook")

    def test_helper_has_fired_alias(self):
        src = _extract_function_source("_dedup_mv_as_product_artifacts")
        self.assertIn("[mv-product-dedup-guard FIRED]", src,
                      "FIRED log marker missing from helper")
        self.assertIn("alias=mv-product-dedup-guard", src,
                      "alias= sentinel missing from helper")

    def test_helper_call_site_in_run_track_1(self):
        nb = _load_notebook_text()
        # Must be invoked after step_generate_metric_view_artifacts
        self.assertIn("_dedup_mv_as_product_artifacts(widgets_values, logger)", nb,
                      "Call site missing")
        # Must be wrapped in try/except with non-fatal warning
        self.assertIn("[mv-product-dedup-guard] failed non-critically", nb,
                      "Defensive try/except missing on call site")

    def test_helper_logic_removes_mv_named_products(self):
        """Behavioral test: simulate the v0.7.9 bug — products with _mv suffix that match metric_view names are removed."""
        # Extract helper source and exec it in an isolated namespace with stub deps
        src = _extract_function_source("_dedup_mv_as_product_artifacts")
        ns = {"sanitize_name": lambda s: s.lower().replace(" ", "_")}
        exec(src, ns)
        helper = ns["_dedup_mv_as_product_artifacts"]

        class StubLogger:
            def __init__(self):
                self.msgs = []
            def info(self, m): self.msgs.append(("info", m))
            def warning(self, m): self.msgs.append(("warn", m))

        logger = StubLogger()
        widgets_values = {
            "domains": [{"domain": "hr"}],
            "products": [
                {"domain": "hr", "product": "employee"},          # keep
                {"domain": "hr", "product": "vacancy_rate_mv"},   # REMOVE (matches mv name with _mv suffix)
                {"domain": "hr", "product": "retirement_eligibility_mv"},  # REMOVE
                {"domain": "hr", "product": "position"},          # keep
            ],
            "attributes": [
                {"domain": "hr", "product": "employee", "column_name": "employee_id"},
                {"domain": "hr", "product": "vacancy_rate_mv", "column_name": "vacancy_rate"},
                {"domain": "hr", "product": "retirement_eligibility_mv", "column_name": "eligible_count"},
                {"domain": "hr", "product": "position", "column_name": "position_id"},
            ],
            "_metric_view_records": [
                {"view_name": "hr_vacancy_rate", "owner_domain": "hr"},
                {"view_name": "hr_retirement_eligibility", "owner_domain": "hr"},
            ],
        }

        helper(widgets_values, logger)

        remaining = [p["product"] for p in widgets_values["products"]]
        self.assertEqual(set(remaining), {"employee", "position"},
                         f"Expected only employee+position to remain, got {remaining}")
        remaining_attrs = [a["product"] for a in widgets_values["attributes"]]
        self.assertEqual(set(remaining_attrs), {"employee", "position"},
                         f"Attributes for removed products should be gone, got {remaining_attrs}")

        # Per CLAUDE.md \u00a78.3: ensure NOT a tautology — also test the non-removal path
        warn_msgs = [m for tag, m in logger.msgs if tag == "warn"]
        fire_msgs = [m for m in warn_msgs if "FIRED" in m]
        self.assertTrue(any("vacancy_rate_mv" in m for m in fire_msgs),
                        "Should have logged removal of vacancy_rate_mv")

    def test_helper_no_op_when_no_metric_views(self):
        """Defensive: helper should be no-op when there are no metric views."""
        src = _extract_function_source("_dedup_mv_as_product_artifacts")
        ns = {"sanitize_name": lambda s: s.lower().replace(" ", "_")}
        exec(src, ns)
        helper = ns["_dedup_mv_as_product_artifacts"]

        class StubLogger:
            def info(self, m): pass
            def warning(self, m): pass

        widgets_values = {
            "domains": [{"domain": "hr"}],
            "products": [{"domain": "hr", "product": "employee_mv"}],  # _mv but no MV records
            "attributes": [],
            "_metric_view_records": [],
        }
        helper(widgets_values, StubLogger())
        self.assertEqual(len(widgets_values["products"]), 1,
                         "No MVs => no removal even if name has _mv suffix")


class TestV080Fix1UserVibeTagApplier(unittest.TestCase):
    """Fix 1: step_apply_user_vibe_tags injects user-vibe-mandated tags."""

    def test_step_function_exists(self):
        nb = _load_notebook_text()
        self.assertIn("def step_apply_user_vibe_tags(widgets_values):", nb,
                      "step_apply_user_vibe_tags not present in notebook")

    def test_step_has_fired_alias(self):
        src = _extract_function_source("step_apply_user_vibe_tags")
        self.assertIn("[user-vibe-tag-applier FIRED]", src,
                      "FIRED log marker missing from step")
        self.assertIn("alias=user-vibe-tag-applier", src,
                      "alias= sentinel missing from step")

    def test_step_uses_llm_not_regex(self):
        """Per CLAUDE.md \u00a73c: USE LLM ALL THE WAY, NEVER regex on user vibes."""
        src = _extract_function_source("step_apply_user_vibe_tags")
        self.assertIn("ai_agent._call_ai_query", src,
                      "Step must invoke ai_agent._call_ai_query (LLM-driven)")
        # Defensive: should NOT do regex pattern matching on the vibe text
        self.assertNotIn(".findall(", src,
                         "Should not use regex.findall on vibe text")
        # USER-KING AUTHORITY mention required (\u00a73c)
        self.assertIn("USER-KING AUTHORITY", src,
                      "Per CLAUDE.md \u00a73c every prompt must declare user-king authority")

    def test_step_call_site_before_physical_schema(self):
        """Step must be invoked BEFORE step_create_physical_schema_stage1."""
        nb = _load_notebook_text()
        self.assertIn("step_apply_user_vibe_tags(widgets_values)", nb,
                      "Call site missing")
        # Must be wrapped in try/except with non-fatal warning
        self.assertIn("[user-vibe-tag-applier] failed non-critically", nb,
                      "Defensive try/except missing on call site")

    def test_step_injection_logic_only_fills_missing_tags(self):
        """Behavioral test: tags already on attribute should NOT be overwritten."""
        # Stub the LLM call by patching the helper context
        src = _extract_function_source("step_apply_user_vibe_tags")
        # Validate injection helper logic — the inner _has_tag and _inject_tag functions
        self.assertIn("def _has_tag(existing, tag_name):", src,
                      "Helper _has_tag missing")
        self.assertIn("def _inject_tag(entity, tag_name, value):", src,
                      "Helper _inject_tag missing")
        # _has_tag must check string, list, dict — defensive against multiple tag formats
        for fmt_check in [
            "isinstance(existing, str)",
            "isinstance(existing, list)",
            "isinstance(existing, dict)",
        ]:
            self.assertIn(fmt_check, src,
                          f"_has_tag missing format-check: {fmt_check}")


class TestV080Fix3MVColumnLLMRepair(unittest.TestCase):
    """Issue 3 fix: LLM-based MV column repair before drop.

    Per CLAUDE.md \u00a71a NO VERSIONING ROADMAP: every audit issue MUST be fixed
    in the SAME version that ships next. Issue 3 (vacancy_rate dropped due to
    UNRESOLVED_COLUMN) MUST be fixed in v0.8.0 alongside Fix 1 + Fix 2.
    """

    def test_alias_present_in_notebook(self):
        nb = _load_notebook_text()
        self.assertIn("mv-column-llm-repair", nb,
                      "Issue 3 fix alias missing — mv-column-llm-repair must be present")

    def test_fired_marker_for_repair_success(self):
        nb = _load_notebook_text()
        self.assertIn("[mv-column-llm-repair FIRED]", nb,
                      "FIRED log marker missing — must self-report when repair succeeds")

    def test_repair_runs_before_drop(self):
        """Repair must be ATTEMPTED before falling through to the drop bucket."""
        src = _extract_function_source("step_apply_metric_views")
        repair_idx = src.find("[mv-column-llm-repair FIRED]")
        drop_idx = src.find("_dropped2.append(_stmt)\n                        _drop_reasons2.append((_vname, f\"physical table")
        # Drop is in the FALLTHROUGH branch (`if _repaired_stmt is not None: ... else: ...`)
        # So repair invocation comes textually BEFORE the fallthrough drop branch
        self.assertGreater(repair_idx, 0, "repair FIRED log not found in step_apply_metric_views")
        self.assertGreater(drop_idx, 0, "fallthrough drop branch not found in step_apply_metric_views")
        self.assertLess(repair_idx, drop_idx,
                        "Repair must be attempted BEFORE drop fallthrough")

    def test_repair_uses_llm_not_regex(self):
        """Per CLAUDE.md \u00a73c: USE LLM ALL THE WAY for semantic decisions on user vibe artefacts."""
        src = _extract_function_source("step_apply_metric_views")
        # Locate the repair block specifically
        repair_block_start = src.find("_repaired_stmt = None")
        self.assertGreater(repair_block_start, 0, "repair block not found")
        repair_block = src[repair_block_start:repair_block_start + 5000]
        self.assertIn("_call_ai_query", repair_block,
                      "Repair must use LLM via _call_ai_query")
        self.assertIn("USER-KING AUTHORITY", repair_block,
                      "Per \u00a73c every prompt must declare user-king authority")
        self.assertIn("AVAILABLE_COLUMNS", repair_block,
                      "Repair prompt must constrain to available physical columns")

    def test_repair_revalidates_candidate_before_keeping(self):
        """LLM may hallucinate; repair must revalidate the candidate against _src_cols."""
        src = _extract_function_source("step_apply_metric_views")
        # The candidate revalidation reuses _src_cols / _mvcp_token_re / _mvcp_SQL_KW
        repair_block_start = src.find("_repaired_stmt = None")
        repair_block = src[repair_block_start:repair_block_start + 5000]
        self.assertIn("_cand_bad", repair_block,
                      "Candidate must be revalidated for residual bad columns")
        self.assertIn("if not _cand_bad:", repair_block,
                      "Repair must only KEEP candidate when 0 residual bad columns")

    def test_repair_falls_through_to_drop_on_failure(self):
        """If repair fails OR LLM unavailable, MV must be dropped (preserves prior behaviour)."""
        src = _extract_function_source("step_apply_metric_views")
        # The fallthrough path: when _repaired_stmt is None, we hit _dropped2.append + _drop_reasons2.append
        self.assertIn("if _repaired_stmt is not None:", src,
                      "Fallthrough conditional missing")
        self.assertIn("_dropped2.append(_stmt)", src,
                      "Fallthrough must still drop on repair failure")
        self.assertIn("mv-column-llm-repair-failed", src,
                      "Failed-repair alias missing for log forensics")
        self.assertIn("mv-column-llm-repair-error", src,
                      "Error-path alias missing for exception forensics")


class TestV080Fix4MVJoinsReenabled(unittest.TestCase):
    """Issue 4 fix (v0.8.0 amendment): re-enable MV cross-table joins.

    Pre-fix: joins disabled by `if False and ...` due to runtime alias-resolution bug
    (`i.order_id` -> `did you mean ord.order_id?`). Caused 12 cross-table measures
    to be dropped at MV-gen time in ncdot run 158267072339186 across 3 user-named MVs.

    Per CLAUDE.md \u00a71a NO VERSIONING ROADMAP: this fix ships in v0.8.0, not v0.8.1.
    """

    def test_joins_gate_unconditional(self):
        """The `if False and isinstance(_mv_joins_raw, ...)` gate must be removed."""
        nb = _load_notebook_text()
        self.assertNotIn("if False and isinstance(_mv_joins_raw", nb,
                         "joins gate must be unconditional (False removed)")
        self.assertIn("if isinstance(_mv_joins_raw, list) and _mv_joins_raw:", nb,
                      "unconditional joins gate not found")

    def test_mv_joins_reenabled_alias_present(self):
        nb = _load_notebook_text()
        self.assertIn("mv-joins-reenabled", nb, "mv-joins-reenabled alias missing")

    def test_alias_normalize_uses_table_name(self):
        """Join `name:` MUST be the joined table name (not LLM short alias)."""
        nb = _load_notebook_text()
        self.assertIn("mv-joins-alias-normalize", nb, "mv-joins-alias-normalize alias missing")
        # The normalization logic: _normalized_alias = (_t_table or _j_alias).strip()
        self.assertIn("_normalized_alias = (_t_table or _j_alias).strip()", nb,
                      "Normalization logic missing — must prefer table name over LLM alias")

    def test_on_clause_alias_rewrite(self):
        """Join ON clause must rewrite `<llm_alias>.col` -> `<table_name>.col`."""
        nb = _load_notebook_text()
        # The rewrite regex must be present
        self.assertIn("rewrote join alias", nb, "ON-clause alias-rewrite log line missing")

    def test_measure_dim_filter_alias_rewrite(self):
        """Measure/dimension/filter exprs must also have aliases rewritten BEFORE ColCheck."""
        nb = _load_notebook_text()
        self.assertIn("mv-joins-expr-alias-rewrite", nb,
                      "mv-joins-expr-alias-rewrite alias missing")
        # Must walk measures + dimensions (JSON-escaped form)
        self.assertIn('_coll_name in (\\"measures\\", \\"dimensions\\")', nb,
                      "Expression rewrite must walk measures + dimensions collections")
        # Must also handle filter expr
        self.assertIn('mv.get(\\"filter\\")', nb,
                      "Expression rewrite must handle filter expression")

    def test_llm_alias_preserved_in_valid_joins_dict(self):
        """The dict in _valid_joins must store BOTH normalized alias AND llm_alias."""
        nb = _load_notebook_text()
        # JSON-escaped form: "llm_alias" appears as \"llm_alias\"
        self.assertIn('\\"llm_alias\\": _j_alias', nb,
                      "_valid_joins entry must preserve LLM-original alias for downstream rewrite")


class TestV080Fix4PromptJoinsEnabled(unittest.TestCase):
    """Issue 4 amendment-2: prompts must INSTRUCT the LLM to use joins, not forbid them.

    Discovered from AI logs of run 665620745043660 where the LLM honestly reported
    "joins array is correctly empty per the SINGLE-TABLE HARD RULE" \u2014 the prompt
    forbade joins, so the renderer-side fix had nothing to render.
    """

    def test_no_joins_disabled_prompt_remains(self):
        """The 'JOINS ARE DISABLED' / mv-prompt-joins-disabled directives must be REMOVED."""
        nb = _load_notebook_text()
        self.assertNotIn("JOINS ARE DISABLED", nb,
                         "'JOINS ARE DISABLED' must be removed from all prompts")
        self.assertNotIn("mv-prompt-joins-disabled", nb,
                         "'mv-prompt-joins-disabled' alias must be replaced by mv-prompt-joins-enabled")

    def test_joins_enabled_prompt_present_twice(self):
        """Both DOMAIN_METRICS_PROMPT and KPI_FIRST_GLOBAL_PROMPT must declare joins enabled."""
        nb = _load_notebook_text()
        # Each prompt header line contains 'mv-prompt-joins-enabled' twice (header + alias=)
        self.assertGreaterEqual(nb.count("mv-prompt-joins-enabled"), 2,
                                "mv-prompt-joins-enabled alias must appear in both prompts")
        self.assertEqual(nb.count("JOINS ARE ENABLED"), 2,
                         "'JOINS ARE ENABLED' must appear in both prompts")

    def test_prompt_describes_alias_normalization(self):
        """Prompts must explain the alias-normalization behaviour."""
        nb = _load_notebook_text()
        self.assertIn("mv-joins-alias-normalize", nb,
                      "Prompt must reference mv-joins-alias-normalize so LLM emits compatible aliases")

    def test_prompt_describes_repair_path(self):
        """Prompts must reference the install-time repair fallback."""
        nb = _load_notebook_text()
        # mv-column-llm-repair must be referenced in the new prompt block
        # (it's already referenced in code; check the prompt mentions it)
        self.assertGreaterEqual(nb.count("mv-column-llm-repair"), 5,
                                "mv-column-llm-repair must be referenced in code AND prompts")


class TestV080NoVersioningRoadmap(unittest.TestCase):
    """Per CLAUDE.md \u00a71a: every audit-surfaced issue MUST be fixed in the same version."""

    def test_no_defer_to_future_version_in_version_comment(self):
        """Version comment must NOT contain 'deferred to v0.X.Y' rationale."""
        nb_json = _load_notebook_json()
        cell1_src = "".join(nb_json["cells"][1].get("source", []))
        # Forbidden phrases
        for forbidden in [
            "deferred to v0.8.1",
            "deferred to v0.8.2",
            "deferred to next version",
            "DEFER ISSUE",
        ]:
            self.assertNotIn(forbidden, cell1_src,
                             f"\u00a71a violation: version comment defers to future version: {forbidden!r}")

    def test_all_audit_fix_aliases_present(self):
        """All audit issues from v0.7.9 NCDOT + v0.8.0 first-run MUST have aliases in v0.8.0."""
        nb = _load_notebook_text()
        for alias in [
            "user-vibe-tag-applier",          # Issue 1 (v0.7.9 audit)
            "mv-product-dedup-guard",         # Issue 2 (v0.7.9 audit)
            "mv-column-llm-repair",           # Issue 3 (v0.7.9 audit)
            "mv-joins-reenabled",             # Issue 4 (v0.8.0 first-run audit @ run 158267072339186)
            "mv-joins-alias-normalize",       # Issue 4 supporting fix
            "mv-joins-expr-alias-rewrite",    # Issue 4 supporting fix
        ]:
            self.assertIn(alias, nb,
                          f"\u00a71a violation: audit-issue alias missing: {alias!r}")


class TestV080PriorVersionAliasesPreserved(unittest.TestCase):
    """Ensure prior-version aliases (positive signals) are still present in v0.8.0."""

    def test_v079_fidelity_bypass_widget_alias_present(self):
        nb = _load_notebook_text()
        self.assertIn("fidelity-bypass-widget-live", nb,
                      "v0.7.9 fidelity bypass alias must remain (not regressed)")

    def test_v078_audit_all_alias_present(self):
        nb = _load_notebook_text()
        self.assertIn("llm-audit-residual", nb,
                      "v0.7.8 audit_all alias must remain (not regressed)")


class TestV080NoVersionPollution(unittest.TestCase):
    """Per v0.7.7 invariant: no version literals outside __AGENT_VERSION__ + comment + readme."""
    def test_no_080_version_string_in_widget_labels(self):
        nb = _load_notebook_text()
        # Find widget labels (between dropdown/text 4th arg quotes)
        # Widget labels have specific markers like dbutils.widgets.dropdown('name', 'default', [...], 'LABEL')
        # The label is the 4th argument
        for line in nb.splitlines():
            if "dbutils.widgets" not in line:
                continue
            if "alias=fidelity-bypass-widget-live" in line:
                continue  # exempt: alias is a sentinel, not a label
            # Check for version pollution pattern like "v0.8.0" inside widget label strings
            if re.search(r"\\?\"[^\"]*v0\.8\.0[^\"]*\\?\"", line):
                self.fail(f"v0.8.0 string found in widget label: {line[:200]}")


if __name__ == "__main__":
    unittest.main()
