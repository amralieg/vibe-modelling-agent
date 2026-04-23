"""Tests for sanitize_name — canonical naming helper (GEN-RUL-002).

Critical because: catalog/schema/table names derive from this. A regression
here means wrong physical DDL, wrong volume paths, wrong log folder, wrong
tag namespace.

Default: strip_stop_words=True → strips articles (a, the, corp, ltd, inc...).
Callers that need literal preservation pass strip_stop_words=False.
"""
import pytest


def _load():
    from agent_helpers import sanitize_name  # noqa
    return sanitize_name


class TestSanitizeNameDefault:
    """strip_stop_words=True (default) — business/catalog naming."""

    def test_empty_uses_fallback(self):
        fn = _load()
        import warnings
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            # Known behavior: empty name → fallback identifier
            result = fn("")
        assert result  # non-empty fallback

    def test_lowercase(self):
        fn = _load()
        assert fn("Airlines") == "airlines"

    def test_strips_stop_word_corp(self):
        fn = _load()
        # "Corp" / "Ltd" etc. are stop words by default
        assert fn("Acme Corp") == "acme"

    def test_strips_stop_word_the(self):
        fn = _load()
        assert fn("The Airlines") == "airlines"

    def test_special_chars_stripped(self):
        fn = _load()
        assert "!" not in fn("Hello!World")
        assert "&" not in fn("A & B")


class TestSanitizeNameLiteral:
    """strip_stop_words=False — preserve every token."""

    def test_corp_retained(self):
        fn = _load()
        assert fn("Acme Corp", strip_stop_words=False) == "acme_corp"

    def test_multiple_spaces_collapsed(self):
        fn = _load()
        assert fn("a   b   c", strip_stop_words=False) == "a_b_c"

    def test_idempotent(self):
        fn = _load()
        first = fn("Acme Corp Ltd.", strip_stop_words=False)
        second = fn(first, strip_stop_words=False)
        assert first == second

    def test_valid_identifier_chars_only(self):
        fn = _load()
        import re as _re
        result = fn("Café Résumé", strip_stop_words=False)
        assert _re.match(r'^[a-z0-9_]*$', result), f"invalid chars in {result!r}"
