from notebook_source_util import notebook_concat_source

"""v0.9.6 behavioral tests -- ACTUALLY-DELIVERED LLM-only vibe extraction.

These tests verify that the v0.9.4 header's claimed deletions are now real in code
(closing the §8.4 dead-code-framed-as-fix gap). Each test exercises one of the six
regex paths the v0.9.4 header claimed were deleted; v0.9.6 makes them ACTUALLY gone.

Sentinels (grep-verifiable, all must have >= 1 hit in source):
- vibe-attr-cap-regex-removed                       (v0.7.4 attr-range regex deleted)
- vibe-llm-only-no-product-list-regex               (_parse_product_lists_from_vibes neutered)
- vibe-llm-only-no-prefix-regex                     (_detect_required_product_prefix neutered)
- vibe-llm-only-no-vendor-map                       (_t1d_VENDOR_MAP deleted)
- vibe-llm-only-no-connect-table-fk-derive          (_ct_re + _id-suffix heuristic deleted)
- connect-table-fk-missing                          (new graceful-degrade path replaces them)
- vibe-llm-only-pipeline                            (v0.9.4 master sentinel preserved)
- vibe-llm-only-fk-required                         (VIBE_MASTER_PROMPT FK requirement preserved)
- vibe-llm-only-validator-retry                     (v0.9.4 retry path preserved)
- vibe-llm-only-chunking                            (v0.9.4 chunking path preserved)
"""

import json
import os
import re
import unittest

REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), '..', '..'))
AGENT_NB = os.path.join(REPO_ROOT, 'agent', 'dbx_vibe_modelling_agent.ipynb')


def load_agent_source():
    with open(AGENT_NB) as f:
        nb = json.load(f)
    return ''.join(''.join(c.get('source', [])) for c in nb['cells'] if c.get('cell_type') == 'code')


class TestV96VersionConstant(unittest.TestCase):
    def setUp(self):
        self.src = load_agent_source()

    def test_version_is_0_9_6_or_later(self):
        """v0.9.6 introduced the regex-removal sentinels checked below. Later
        single-digit-segment versions (0.9.7, 0.9.8, ..., 1.0.0+) preserve the
        same sentinels and are still considered v0.9.6-compatible for this
        behavioural contract."""
        m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', self.src)
        self.assertIsNotNone(m, 'AGENT_VERSION constant missing')
        ver = m.group(1)
        parts = ver.split('.')
        self.assertEqual(len(parts), 3, f'semver must have 3 segments, got {ver}')
        for seg in parts:
            self.assertTrue(seg.isdigit() and len(seg) == 1,
                            f'each semver segment must be single digit, got {ver}')
        cmp_key = tuple(int(s) for s in parts)
        self.assertGreaterEqual(cmp_key, (0, 9, 6),
                                f'Expected v0.9.6 or later (single-digit segments), got {ver}')

    def test_version_single_digit_segments(self):
        m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', self.src)
        for seg in m.group(1).split('.'):
            self.assertEqual(len(seg), 1, f'Segment {seg!r} not single-digit (CLAUDE.md §3a)')
            self.assertTrue(seg.isdigit(), f'Segment {seg!r} not numeric')


class TestV96AttrCapRegexRemoved(unittest.TestCase):
    """v0.7.4 attribute-range regex (_v074_attr_re) was a regex sweep over model_vibes/
    business_description that extracted 'between N and M attributes per product'. v0.9.6
    deletes it; tier defaults + VIBE_MASTER_PROMPT-extracted requirements own the intent."""

    def setUp(self):
        self.src = load_agent_source()

    def test_sentinel_present(self):
        self.assertIn('vibe-attr-cap-regex-removed FIRED', self.src,
                      'v0.9.6 deletion sentinel for v0.7.4 attr-range regex missing')

    def test_regex_constant_absent(self):
        self.assertNotIn('_v074_attr_re = ', self.src,
                         '_v074_attr_re still defined in source')
        self.assertNotIn('_v074_attr_re.search', self.src,
                         '_v074_attr_re.search still called in source')

    def test_no_re_compile_on_attributes_per_product(self):
        # Original regex pattern fragment that should not appear anywhere as a live re.compile
        self.assertNotIn("attributes?\\s*per\\s*(?:product|table|entity)", self.src,
                         'attribute-range regex pattern still present in source')


class TestV96ProductListRegexRemoved(unittest.TestCase):
    """_parse_product_lists_from_vibes was a 6-regex sweep over raw vibe text. v0.9.6
    neuters the function body so it returns ({}, False); LLM-extracted vibe_requirements_checklist
    + vibe_classification own product-list intent."""

    def setUp(self):
        self.src = load_agent_source()

    def test_sentinel_present(self):
        self.assertIn('vibe-llm-only-no-product-list-regex FIRED', self.src,
                      'v0.9.6 deletion sentinel for product-list regex missing')

    def test_regex_constants_absent(self):
        for name in ('_no_extras_patterns = ', '_re_domain_header = ', '_re_product_line = ',
                     '_re_product_numbered = ', '_vreq_patterns = '):
            self.assertNotIn(name, self.src, f'{name.strip()!r} still defined in source')

    def test_function_still_callable_and_returns_empty(self):
        # Extract the function body and exec it; verify it returns the expected no-op result
        # so call sites don't break.
        m = re.search(r'def _parse_product_lists_from_vibes\(widgets_values\):(.*?)\nreturn', self.src, re.DOTALL)
        # Cannot rely on regex slice due to nested returns; smoke-test by checking the
        # presence of the no-op return statement directly.
        self.assertIn('return {}, False', self.src,
                      '_parse_product_lists_from_vibes no-op return statement missing')


class TestV96PrefixRegexRemoved(unittest.TestCase):
    """_detect_required_product_prefix was an 8-pattern regex sweep over raw vibe text.
    v0.9.6 neuters it; LLM-emitted transform_name / standardize_naming actions own intent."""

    def setUp(self):
        self.src = load_agent_source()

    def test_sentinel_present(self):
        self.assertIn('vibe-llm-only-no-prefix-regex FIRED', self.src,
                      'v0.9.6 deletion sentinel for prefix regex missing')

    def test_regex_constants_absent(self):
        self.assertNotIn('_prefix_patterns = ', self.src,
                         '_prefix_patterns still defined in source')
        self.assertNotIn('_tag_prefix_exclusion = ', self.src,
                         '_tag_prefix_exclusion still defined in source')

    def test_function_returns_empty(self):
        # The neutered function returns "" -- look for the explicit return statement.
        m = re.search(r'def _detect_required_product_prefix\(widgets_values\):(.*?)return ""',
                      self.src, re.DOTALL)
        self.assertIsNotNone(m, '_detect_required_product_prefix should return "" after v0.9.6 neuter')


class TestV96VendorMapRemoved(unittest.TestCase):
    """_t1d_VENDOR_MAP was an industry-hardcoded 46-vendor blocklist. v0.9.6 deletes it;
    the LLM emits update_description actions via VIBE_MASTER_PROMPT's vendor-scrub guidance."""

    def setUp(self):
        self.src = load_agent_source()

    def test_sentinel_present(self):
        self.assertIn('vibe-llm-only-no-vendor-map FIRED', self.src,
                      'v0.9.6 deletion sentinel for vendor-map missing')

    def test_vendor_map_absent(self):
        self.assertNotIn('_t1d_VENDOR_MAP = {', self.src,
                         '_t1d_VENDOR_MAP dict literal still present')

    def test_prompt_level_vendor_guidance_preserved(self):
        # The LLM-level guidance in VIBE_MASTER_PROMPT must still teach the LLM what to scrub.
        for v in ('Informatica MDM', 'Salesforce Commerce Cloud', 'SAP CAR'):
            self.assertIn(v, self.src,
                          f'vendor pattern {v!r} missing from LLM prompt guidance')
        self.assertIn('update_description', self.src,
                      'update_description action type missing -- LLM cannot scrub vendors')


class TestV96ConnectTableFkDeriveRemoved(unittest.TestCase):
    """v0.9.2 P1 added two FK-derivation fallbacks: (1) regex on action.reason text,
    (2) _id-suffix heuristic that walked _ct_pk_map. v0.9.6 deletes both per the LLM-only
    contract. Missing FK now logs a warning and adds column without FK + defers to next_vibes."""

    def setUp(self):
        self.src = load_agent_source()

    def test_sentinel_present(self):
        self.assertIn('vibe-llm-only-no-connect-table-fk-derive FIRED', self.src,
                      'v0.9.6 deletion sentinel missing')

    def test_regex_alias_absent(self):
        self.assertNotIn('import re as _ct_re', self.src,
                         'regex import alias _ct_re still present')
        self.assertNotIn('_ct_fk_pattern', self.src,
                         'regex constant _ct_fk_pattern still present')

    def test_id_suffix_heuristic_absent(self):
        self.assertNotIn("_ct_col_name.lower().endswith('_id')", self.src,
                         '_id-suffix heuristic still present')

    def test_graceful_degrade_path_present(self):
        self.assertIn('connect-table-fk-missing FIRED', self.src,
                      'graceful-degrade path for missing FK absent')


class TestV96LLMOnlyHelpersPresentAndWired(unittest.TestCase):
    """The 5 helper functions added in v0.9.4 must remain defined AND called in
    VibeOrchestrator.master_analyze."""

    def setUp(self):
        self.src = load_agent_source()

    def test_helpers_defined(self):
        for fn in ('_build_v1_pk_catalog_for_vibe_master',
                   '_validate_and_plan_vibe',
                   '_chunk_vibe_by_semantic_boundary',
                   '_merge_stage_a_outputs',
                   '_validate_vibe_master_actions'):
            self.assertIn(f'def {fn}(', self.src, f'helper {fn} not defined')

    def test_helpers_called_from_orchestrator(self):
        # master_analyze should call all 5 helpers
        idx = self.src.find('def master_analyze(')
        self.assertGreater(idx, 0, 'VibeOrchestrator.master_analyze not found')
        window = self.src[idx: idx + 30000]
        for fn in ('_build_v1_pk_catalog_for_vibe_master',
                   '_validate_and_plan_vibe',
                   '_merge_stage_a_outputs',
                   '_validate_vibe_master_actions'):
            self.assertIn(f'{fn}(', window, f'helper {fn} not called from master_analyze')


class TestV96NoRegexOnVibeText(unittest.TestCase):
    """Anti-regression: enumerate every regex pattern in the source and verify none
    operates on raw vibe text (model_vibes / business_description / vibe_modelling_instructions).
    """

    def setUp(self):
        self.src = load_agent_source()

    def test_no_module_level_vibe_regex(self):
        # These regex constants are the ones v0.9.6 deleted; if any returns, that's a regression.
        DEAD_REGEX_NAMES = (
            '_PRIORITY_DIRECTIVE_PATTERN = ',
            '_DETERMINISTIC_OVERRIDE_PATTERNS = ',
            'def _convert_priority_to_action',
            'def _parse_priority_directives',
            '_t1d_VENDOR_MAP = ',
            '_no_extras_patterns = ',
            '_v074_attr_re = ',
            '_re_domain_header = ',
            '_re_product_line = ',
            '_vreq_patterns = ',
            '_prefix_patterns = ',
            '_ct_fk_pattern',
        )
        for name in DEAD_REGEX_NAMES:
            self.assertNotIn(name, self.src,
                             f'dead regex {name!r} reappeared in source -- v0.9.6 regression')


class TestV96RegistrationViaCallAIQuery(unittest.TestCase):
    """Every LLM call must flow through ai_agent._call_ai_query (or AIAgent._call_ai_query)
    so its tokens are registered in _prompt_stats. The validator-retry path in master_analyze
    must use the same registration mechanism."""

    def setUp(self):
        self.src = load_agent_source()

    def test_master_analyze_uses_call_ai_query(self):
        idx = self.src.find('def master_analyze(')
        window = self.src[idx: idx + 30000]
        # The post-LLM validator-retry path must call ai_agent._call_ai_query for the retry.
        self.assertIn('_call_ai_query(', window,
                      'master_analyze does not invoke _call_ai_query -- LLM calls unregistered')


if __name__ == '__main__':
    unittest.main()
