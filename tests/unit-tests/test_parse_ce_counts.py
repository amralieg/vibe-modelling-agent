"""Tests for _parse_ce_counts — parses the COUNTS: line from candidate_evaluation text.

Covers fix: P0.XX (candidate evaluation counts parsing).
Critical because: if this parser drops a key, LINK-POSTPROCESS over-trims
legitimate FK proposals and we get the "Created 0 FK(s)" regression.
"""
import pytest


def _load_fn():
    from agent_helpers import _parse_ce_counts  # noqa
    return _parse_ce_counts


class TestParseCECounts:
    def test_empty_input(self):
        fn = _load_fn()
        assert fn("") == {}
        assert fn(None) == {}

    def test_non_string_input(self):
        fn = _load_fn()
        assert fn(123) == {}
        assert fn({"COUNTS": "links_to_include=5"}) == {}

    def test_missing_counts_line(self):
        fn = _load_fn()
        assert fn("This text has no counts marker.") == {}

    def test_single_pair_links_to_include(self):
        fn = _load_fn()
        assert fn("Some eval text\nCOUNTS: links_to_include=12") == {"links_to_include": 12}

    def test_single_pair_cross_domain(self):
        fn = _load_fn()
        assert fn("COUNTS: cross_domain_links_to_include=8") == {"cross_domain_links_to_include": 8}

    def test_multi_pair(self):
        fn = _load_fn()
        result = fn("COUNTS: orphaned_fks=5, denormalized=3, duplicate_fks=1")
        assert result == {"orphaned_fks": 5, "denormalized": 3, "duplicate_fks": 1}

    def test_case_insensitive_marker(self):
        fn = _load_fn()
        assert fn("counts: links_to_include=4") == {"links_to_include": 4}
        assert fn("Counts: links_to_include=4") == {"links_to_include": 4}

    def test_whitespace_tolerance(self):
        fn = _load_fn()
        assert fn("COUNTS:  links_to_include = 7  , orphaned = 2 ") == {"links_to_include": 7, "orphaned": 2}

    def test_non_integer_value_skipped(self):
        fn = _load_fn()
        result = fn("COUNTS: links_to_include=abc, orphaned=5")
        assert "links_to_include" not in result
        assert result.get("orphaned") == 5

    def test_terminates_at_newline(self):
        fn = _load_fn()
        result = fn("COUNTS: links_to_include=3\nMore text: should_not_be_captured=99")
        assert result == {"links_to_include": 3}

    def test_multiple_counts_lines_first_wins(self):
        """First COUNTS: line is authoritative per the regex non-greedy search."""
        fn = _load_fn()
        result = fn("COUNTS: links_to_include=1\nCOUNTS: links_to_include=99")
        assert result == {"links_to_include": 1}

    def test_trailing_content_ignored(self):
        fn = _load_fn()
        result = fn("Preamble\n\nCOUNTS: a=1, b=2\nConclusion text here")
        assert result == {"a": 1, "b": 2}
