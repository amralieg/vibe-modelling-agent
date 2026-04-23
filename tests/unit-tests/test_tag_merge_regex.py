"""Tests for the tag-merge regex used by P0.99 (v0.7.10) + PE12 (v0.7.13).

Critical because: this merges 9894 individual ALTER … SET TAGS statements into
~500 multi-tag statements (~20× speedup). A regex bug produces malformed SQL
and install crashes.

The regex literal lives inline in `_run_deploy_model`; we duplicate it here
to exercise behavior without spinning up the notebook.
"""
import re
import pytest


TAG_RE = re.compile(
    r"^ALTER\s+(TABLE|SCHEMA|VIEW)\s+(\S+?)(?:\s+ALTER\s+COLUMN\s+(`[^`]+`))?\s+SET\s+TAGS\s*\((.*)\)\s*;?\s*$",
    re.IGNORECASE | re.DOTALL,
)


class TestTagMergeRegex:
    def test_simple_table_tag(self):
        stmt = "ALTER TABLE catalog.schema.tbl SET TAGS ('env'='prod');"
        m = TAG_RE.match(stmt)
        assert m is not None
        kind, tgt, col, kv = m.groups()
        assert kind.upper() == "TABLE"
        assert tgt == "catalog.schema.tbl"
        assert col is None
        assert kv == "'env'='prod'"

    def test_schema_tag(self):
        stmt = "ALTER SCHEMA cat.schema SET TAGS ('owner'='team_a');"
        m = TAG_RE.match(stmt)
        assert m is not None
        assert m.group(1).upper() == "SCHEMA"

    def test_view_tag(self):
        stmt = "ALTER VIEW cat.sch.v SET TAGS ('type'='view');"
        m = TAG_RE.match(stmt)
        assert m is not None
        assert m.group(1).upper() == "VIEW"

    def test_column_tag(self):
        stmt = "ALTER TABLE c.s.t ALTER COLUMN `user_id` SET TAGS ('pii'='true');"
        m = TAG_RE.match(stmt)
        assert m is not None
        assert m.group(3) == "`user_id`"

    def test_tag_value_with_comma(self):
        """PE12 fix — greedy .* allows commas inside values."""
        stmt = "ALTER TABLE c.s.t SET TAGS ('description'='Revenue, net of returns');"
        m = TAG_RE.match(stmt)
        assert m is not None
        assert "Revenue, net of returns" in m.group(4)

    def test_multi_pair_kv(self):
        stmt = "ALTER TABLE c.s.t SET TAGS ('env'='prod', 'owner'='team_a', 'sla'='24h');"
        m = TAG_RE.match(stmt)
        assert m is not None
        assert m.group(4) == "'env'='prod', 'owner'='team_a', 'sla'='24h'"

    def test_no_match_for_drop_tag(self):
        stmt = "ALTER TABLE c.s.t UNSET TAGS ('env');"
        assert TAG_RE.match(stmt) is None

    def test_no_match_for_non_tag_alter(self):
        stmt = "ALTER TABLE c.s.t ADD COLUMN x INT;"
        assert TAG_RE.match(stmt) is None

    def test_backtick_quoted_target(self):
        stmt = "ALTER TABLE `cat`.`sch`.`tbl` SET TAGS ('env'='prod');"
        m = TAG_RE.match(stmt)
        assert m is not None

    def test_trailing_whitespace_tolerated(self):
        stmt = "ALTER TABLE c.s.t SET TAGS ('env'='prod')   ;   "
        m = TAG_RE.match(stmt)
        assert m is not None

    def test_semicolon_optional(self):
        stmt = "ALTER TABLE c.s.t SET TAGS ('env'='prod')"
        m = TAG_RE.match(stmt)
        assert m is not None
