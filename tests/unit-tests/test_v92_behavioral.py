from notebook_source_util import notebook_concat_source

import json
import os
import re
import unittest


REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), '..', '..'))
AGENT_NB = os.path.join(REPO_ROOT, 'agent', 'dbx_vibe_modelling_agent.ipynb')


def load_agent_source():
    with open(AGENT_NB) as f:
        nb = json.load(f)
    return "".join("".join(c.get('source', [])) for c in nb['cells'])


class TestV92Version(unittest.TestCase):
    def setUp(self):
        self.src = load_agent_source()

    def test_version_is_0_9_2(self):
        # v0.9.6: the version constant has advanced past 0.9.2; verify it has NOT regressed
        # below 0.9.2 and that v0.9.2 lineage is preserved as a legacy header marker.
        m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', self.src)
        self.assertIsNotNone(m, "AGENT_VERSION constant missing")
        parts = m.group(1).split('.')
        self.assertEqual(len(parts), 3)
        major, minor, patch = (int(p) for p in parts)
        self.assertGreaterEqual((major, minor, patch), (0, 9, 2),
                                f"Version regressed below 0.9.2: got {m.group(1)}")
        self.assertIn("v0.9.2", self.src,
                      "v0.9.2 lineage marker not preserved in header chain")

    def test_version_single_digit_segments(self):
        m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', self.src)
        for seg in m.group(1).split('.'):
            self.assertEqual(len(seg), 1, f"Segment {seg!r} is not single-digit")
            self.assertTrue(seg.isdigit(), f"Segment {seg!r} is not numeric")


class TestV92RenameClosureAddTarget(unittest.TestCase):
    """P2: rename action's target_state name added to user_closure AND user_new_entities."""

    def setUp(self):
        self.src = load_agent_source()

    def test_alias_present(self):
        self.assertIn("vov-rename-closure-add-target FIRED", self.src,
                      "alias 'vov-rename-closure-add-target' not present")

    def test_handles_rename_action_type(self):
        idx = self.src.find("vov-rename-closure-add-target FIRED")
        self.assertGreater(idx, 0)
        window = self.src[max(0, idx - 2500): idx + 3500]
        self.assertIn("'rename'", window, "rename action not in target-name handler")

    def test_adds_target_to_both_sets(self):
        idx = self.src.find("vov-rename-closure-add-target FIRED")
        self.assertGreater(idx, 0)
        window = self.src[idx: idx + 2500]
        self.assertIn("user_closure.add", window)
        self.assertIn("user_new_entities.add", window)

    def test_handles_attribute_scope(self):
        idx = self.src.find("vov-rename-closure-add-target FIRED")
        window = self.src[idx: idx + 3500]
        self.assertIn("_scope == 'attribute'", window)

    def test_handles_dotted_target_state(self):
        idx = self.src.find("vov-rename-closure-add-target FIRED")
        window = self.src[idx: idx + 3500]
        self.assertIn("len(_ts_parts)", window,
                      "target_state with dots not handled")


class TestV92ConnectTableColumnClosure(unittest.TestCase):
    """P3: connect_table.target_state.add_columns names added to user_new_entities at attribute level."""

    def setUp(self):
        self.src = load_agent_source()

    def test_alias_present(self):
        self.assertIn("vov-connect-table-column-closure FIRED", self.src)

    def test_parses_add_columns(self):
        idx = self.src.find("vov-connect-table-column-closure FIRED")
        window = self.src[idx: idx + 2500]
        self.assertIn("add_columns", window)
        self.assertIn("user_new_entities.add", window)


class TestV92ConnectTableFkDerive(unittest.TestCase):
    """v0.9.6 DELETED the v0.9.2 P1 regex (FK-from-reason) + _id-suffix heuristic per the
    LLM-only contract. The LLM MUST now emit foreign_key_to via VIBE_MASTER_PROMPT, enforced
    by the post-LLM _validate_vibe_master_actions validator with one retry on failure. This
    test was repurposed to verify the deletion + the new no-FK-missing log path."""

    def setUp(self):
        self.src = load_agent_source()

    def test_alias_deleted_sentinel_present(self):
        self.assertIn("vibe-llm-only-no-connect-table-fk-derive FIRED", self.src,
                      "v0.9.6 deletion sentinel for connect_table FK-derive missing")
        # The old alias must no longer fire (its FIRED log line should be gone).
        # The string 'connect-table-fk-derive FIRED' may still appear in legacy header
        # text; assert the surrounding LIVE-CODE-only regex constructs are gone.
        self.assertNotIn("_ct_fk_pattern", self.src,
                         "regex constant _ct_fk_pattern still in source -- not deleted")

    def test_no_regex_on_reason(self):
        # v0.9.6: no `import re as _ct_re` block should exist in connect_table.
        self.assertNotIn("import re as _ct_re", self.src,
                         "regex import alias _ct_re still in connect_table handler")

    def test_no_id_suffix_pk_map_lookup_in_add_columns(self):
        # The deleted block had `if not _ct_fk_to and _ct_col_name.lower().endswith('_id'):`
        # walking back to _ct_pk_map. v0.9.6 deletes this clause.
        self.assertNotIn("_ct_col_name.lower().endswith('_id')", self.src,
                         "_id-suffix heuristic still present in add_columns FK-derive")

    def test_validator_retry_path_present(self):
        # The replacement: VIBE_MASTER_PROMPT-level enforcement via the validator/retry.
        self.assertIn("_validate_vibe_master_actions", self.src,
                      "v0.9.4 validator helper missing -- LLM-only FK extraction not enforced")
        self.assertIn("connect-table-fk-missing FIRED", self.src,
                      "v0.9.6 missing-FK log path absent -- LLM omissions would be silent")


class TestV92ConnectTableCanonicalAttr(unittest.TestCase):
    """P1b: connect_table uses make_attribute_dict() canonical factory, not bare dict."""

    def setUp(self):
        self.src = load_agent_source()

    def test_alias_present(self):
        self.assertIn("connect-table-canonical-attr FIRED", self.src)

    def test_uses_make_attribute_dict(self):
        idx = self.src.find("connect-table-canonical-attr FIRED")
        window = self.src[idx: idx + 2500]
        self.assertIn("make_attribute_dict(", window)

    def test_no_data_type_field_in_new_path(self):
        """Canonical factory uses 'type', not 'data_type'."""
        idx = self.src.find("connect-table-canonical-attr FIRED")
        window = self.src[idx: idx + 2500]
        # The canonical factory uses attr_type kwarg, not data_type
        self.assertIn("attr_type=", window)

    def test_user_directive_flag(self):
        """New attributes are flagged as user-directive so they survive normalization."""
        idx = self.src.find("connect-table-canonical-attr FIRED")
        window = self.src[idx: idx + 3500]
        self.assertIn("_user_directive", window)


class TestV92RenameFkDoubleReplaceFix(unittest.TestCase):
    """P4: FK rewriter no longer produces 'consent_consent_record_id' from 'record_id'."""

    def setUp(self):
        self.src = load_agent_source()

    def test_alias_present(self):
        self.assertIn("rename-fk-pk-double-replace FIRED", self.src)

    def test_guards_double_pk_replacement(self):
        idx = self.src.find("rename-fk-pk-double-replace FIRED")
        window = self.src[idx: idx + 2500]
        # The fix only rewrites PK if it isn't already there
        self.assertIn("new_pk.lower() not in new_fk.lower()", window,
                      "PK double-replace guard missing")


class TestV92FkRewriterUnit(unittest.TestCase):
    """Pure logic test for the FK rewriter — applies the v0.9.2 substitution rules manually."""

    @staticmethod
    def rewrite_fk(fk, old_ref_full, new_ref_full, old_ref, new_ref, old_pk, new_pk):
        new_fk = fk
        if old_ref_full.lower() in fk.lower():
            i = new_fk.lower().find(old_ref_full.lower())
            new_fk = new_fk[:i] + new_ref_full + new_fk[i + len(old_ref_full):]
        elif old_ref.lower() in fk.lower():
            i = fk.lower().find(old_ref.lower())
            new_fk = fk[:i] + new_ref + fk[i + len(old_ref):]
            if old_pk.lower() in new_fk.lower() and new_pk.lower() not in new_fk.lower():
                j = new_fk.lower().find(old_pk.lower())
                new_fk = new_fk[:j] + new_pk + new_fk[j + len(old_pk):]
        return new_fk

    def test_consent_record_rename_produces_clean_fk(self):
        """The exact failure case from HC v0.9.1 run: should produce 'consent.consent_record.consent_record_id'."""
        out = self.rewrite_fk(
            fk='consent.record.record_id',
            old_ref_full='consent.record.record_id',
            new_ref_full='consent.consent_record.consent_record_id',
            old_ref='consent.record',
            new_ref='consent.consent_record',
            old_pk='record_id',
            new_pk='consent_record_id',
        )
        self.assertEqual(out, 'consent.consent_record.consent_record_id')
        self.assertNotIn('consent_consent_record_id', out)

    def test_partial_fk_rewrites_correctly(self):
        """When FK references the old product but uses a different PK column name."""
        out = self.rewrite_fk(
            fk='consent.record.legacy_record_id',
            old_ref_full='consent.record.record_id',
            new_ref_full='consent.consent_record.consent_record_id',
            old_ref='consent.record',
            new_ref='consent.consent_record',
            old_pk='record_id',
            new_pk='consent_record_id',
        )
        self.assertTrue(out.startswith('consent.consent_record.'))
        self.assertNotIn('consent_consent_record_id', out)


if __name__ == '__main__':
    unittest.main()
