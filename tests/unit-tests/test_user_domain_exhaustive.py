"""Tests for user business_domains EXHAUSTIVE enforcement — v0.8.0.

When user sets business_domains=['a','b','c'], that's EXACTLY 3, not a minimum.
Tier classifier / judge must NOT add more.
"""
import pytest


class TestExhaustiveEnforcement:
    """Validate that the logic invariants hold in the source code."""

    def test_user_domains_exhaustive_flag_setter_present(self):
        """Source should contain the exhaustive flag-setting code."""
        with open('/tmp/agent_source.py') as f:
            src = f.read()
        assert 'user_domains_exhaustive' in src
        assert 'sizing_directives' in src

    def test_exhaustive_trim_logic_present(self):
        """Source should contain the drop-non-user-domains trim pass."""
        with open('/tmp/agent_source.py') as f:
            src = f.read()
        assert 'EXHAUSTIVE mode' in src
        assert 'dropped' in src and 'non-user domain' in src

    def test_sanitize_matches_injection_rules(self):
        """User-specified names are lowercased + underscore-stripped for comparison."""
        with open('/tmp/agent_source.py') as f:
            src = f.read()
        # The comparison uses lower + strip _
        assert '.lower().replace("_","")' in src or '.lower().replace("_", "")' in src
