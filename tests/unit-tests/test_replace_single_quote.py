"""Tests for replace_single_quote — STRIPS single quotes, backslashes, newlines
for SQL COMMENT / TAG sanitization. Does NOT double quotes (not a SQL string escape)."""
import pytest


def _load():
    from agent_helpers import replace_single_quote
    return replace_single_quote


class TestReplaceSingleQuote:
    def test_no_special_chars(self):
        fn = _load()
        assert fn("hello") == "hello"

    def test_single_quote_stripped(self):
        fn = _load()
        assert fn("O'Brien") == "OBrien"

    def test_multiple_quotes_stripped(self):
        fn = _load()
        assert fn("'a'b'") == "ab"

    def test_backslash_stripped(self):
        fn = _load()
        assert "\\" not in fn("a\\b")

    def test_newline_stripped(self):
        fn = _load()
        assert "\n" not in fn("line1\nline2")

    def test_empty_string(self):
        fn = _load()
        assert fn("") == ""

    def test_none_returns_empty(self):
        fn = _load()
        assert fn(None) == ""
