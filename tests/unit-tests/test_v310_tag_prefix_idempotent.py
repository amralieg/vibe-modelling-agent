"""v3.1.0 behavioral test: install-time tag-prefix idempotency.

Root cause (gov_transport mvm_v2 ground-truth catalog audit 2026-06-03):
The install-time SET TAGS construction prepended `tag_prefix` to every `tag_key`
read from model.json. System tag keys (business_glossary_term, cde, self_ref_fk,
source_table, source_attribute) already carry the prefix baked in by generation,
so the unconditional prepend produced `gov_transport_gov_transport_business_glossary_term` on
2000+ physical tags. The fix makes the prefix application idempotent at the single
install boundary (table-level + column-level SET TAGS).

These tests exercise the exact effective-key expression now embedded in the agent
notebook, proving (a) a pre-prefixed key is NOT doubled, (b) a bare key is prefixed
once, and that the PRE-FIX expression WOULD have doubled (anti-tautology, per
CLAUDE.md 8.10 -- the test must fail against the old logic).
"""
import json
import os
import re

import pytest

_NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _effective_tag_key_fixed(tag_key, tag_prefix):
    """Mirror of the v3.1.0 idempotent expression embedded in the notebook."""
    return tag_key if str(tag_key).startswith(tag_prefix) else tag_prefix + tag_key


def _effective_tag_key_prefix_only(tag_key, tag_prefix):
    """Mirror of the PRE-v3.1.0 unconditional prepend (the bug)."""
    return f"{tag_prefix}{tag_key}"


@pytest.mark.parametrize(
    "tag_key,tag_prefix,expected",
    [
        ("business_glossary_term", "gov_transport_", "gov_transport_business_glossary_term"),
        ("gov_transport_business_glossary_term", "gov_transport_", "gov_transport_business_glossary_term"),
        ("gov_transport_cde", "gov_transport_", "gov_transport_cde"),
        ("gov_transport_self_ref_fk", "gov_transport_", "gov_transport_self_ref_fk"),
        ("gov_transport_source_table", "gov_transport_", "gov_transport_source_table"),
        ("confidential", "gov_transport_", "gov_transport_confidential"),
        ("pii_personal_data", "gov_transport_", "gov_transport_pii_personal_data"),
        ("data_type", "dbx_", "dbx_data_type"),
        ("dbx_data_type", "dbx_", "dbx_data_type"),
    ],
)
def test_idempotent_prefix_no_double(tag_key, tag_prefix, expected):
    """Fixed logic: every key ends up with EXACTLY one prefix occurrence."""
    out = _effective_tag_key_fixed(tag_key, tag_prefix)
    assert out == expected
    # the prefix must appear exactly once at the front, never doubled
    assert not out.startswith(tag_prefix + tag_prefix)


def test_prefix_only_logic_would_double_pre_prefixed():
    """Anti-tautology: the OLD unconditional prepend DID double a pre-prefixed key."""
    bad = _effective_tag_key_prefix_only("gov_transport_business_glossary_term", "gov_transport_")
    assert bad == "gov_transport_gov_transport_business_glossary_term"
    assert bad.startswith("gov_transport_gov_transport_")
    # and the fixed logic does NOT
    good = _effective_tag_key_fixed("gov_transport_business_glossary_term", "gov_transport_")
    assert good != bad
    assert not good.startswith("gov_transport_gov_transport_")


def _iter_code_cells():
    nb = json.load(open(_NB))
    for c in nb.get("cells", []):
        if c.get("cell_type") == "code":
            yield "".join(c.get("source", []))


def test_notebook_uses_idempotent_expression_at_install():
    """Contract: the unconditional '{tag_prefix}{tag_key}' must be gone, and the
    idempotent expression present at exactly the 2 install SET TAGS sites."""
    src = "\n".join(_iter_code_cells())
    assert "'{tag_prefix}{tag_key}'" not in src, "unconditional prepend still present (would double pre-prefixed keys)"
    n = src.count("tag_key if str(tag_key).startswith(tag_prefix) else tag_prefix + tag_key")
    assert n == 2, f"expected 2 idempotent SET TAGS sites (table + column), found {n}"


def test_version_is_310():
    src = "\n".join(_iter_code_cells())
    m = re.search(r'__AGENT_VERSION__ = "([0-9.]+)"', src)
    assert m is not None
    # v3.1.0 fix must be present at v3.1.0 OR LATER (forward bumps must not break this).
    assert tuple(int(x) for x in m.group(1).split(".")) >= (3, 1, 0)
    # single-digit semver per CLAUDE.md 3a
    assert all(0 <= int(seg) <= 9 for seg in m.group(1).split("."))
