import os
import re
import sys
from pathlib import Path

import pytest


REPO = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(REPO / "runner"))

from sync_to_repo import (
    normalize_domain_product_comparison,
    normalize_industry_readmes,
)


_BROKEN_INPUT = """\
# Foo Industry

## Domain & Product Comparison

| Domain | Subdomain | Product | ECM | MVM (Minimum Viable Model) | Notes |
|---|---|---|:---:|:---:|---|

<a id="domain-finance"></a>

| **finance** | core_ledger | journal_entry | \u2705 | \u274c | Domain not in MVM |
|  | core_ledger | trial_balance | \u2705 | \u274c | Domain not in MVM |
|  | budgeting | budget_line | \u2705 | \u274c | Domain not in MVM |

<a id="domain-sales"></a>

| **sales** | order_management | sales_order | \u2705 | \u2705 | |
|  | order_management | sales_order_line | \u2705 | \u2705 | |

## Some Other Section

This stays untouched.
"""

_BROKEN_TABLE_SEPARATOR_RE = re.compile(r"^\|[\s\-:|]+\|\s*$")
_ANCHOR_LINE_RE = re.compile(r'^\s*<a\s+id="domain-')


def _has_anchor_immediately_after_table_separator(text: str) -> bool:
    """Returns True if any markdown table separator is followed (after only blank lines) by a <a id="domain-..."> anchor.

    This is exactly the broken pattern produced by agent v0.7.1's
    step_save_to_md and is what breaks markdown table rendering.
    """
    lines = text.split("\n")
    for i, line in enumerate(lines):
        if not _BROKEN_TABLE_SEPARATOR_RE.match(line):
            continue
        j = i + 1
        while j < len(lines) and lines[j].strip() == "":
            j += 1
        if j < len(lines) and _ANCHOR_LINE_RE.match(lines[j]):
            return True
    return False


def test_input_is_actually_broken():
    assert _has_anchor_immediately_after_table_separator(_BROKEN_INPUT), (
        "test fixture must reproduce the v0.7.1 bug pattern"
    )


def test_normalizer_removes_broken_pattern():
    fixed = normalize_domain_product_comparison(_BROKEN_INPUT)
    assert not _has_anchor_immediately_after_table_separator(fixed), (
        "after normalization, no <a id='domain-...'> anchor may sit between a table separator "
        "and the next non-blank line"
    )


def test_normalizer_keeps_all_anchors():
    fixed = normalize_domain_product_comparison(_BROKEN_INPUT)
    assert '<a id="domain-finance"></a>' in fixed
    assert '<a id="domain-sales"></a>' in fixed


def test_normalizer_emits_per_domain_subtables_with_h3():
    fixed = normalize_domain_product_comparison(_BROKEN_INPUT)
    assert "### finance" in fixed, "each anchor must be followed by an H3 heading using the domain name"
    assert "### sales" in fixed


def test_normalizer_drops_domain_column_from_subtables():
    fixed = normalize_domain_product_comparison(_BROKEN_INPUT)
    section = fixed.split("## Domain & Product Comparison", 1)[1].split("## Some Other Section", 1)[0]
    assert "| Subdomain | Product | ECM | MVM | Notes |" in section, (
        "sub-tables must use the 5-column header (Subdomain/Product/ECM/MVM/Notes); the Domain "
        "column is implicit from the H3 heading and should be removed"
    )
    assert "| **finance** |" not in section, (
        "redundant first-row '| **<domain>** |' cell must be dropped — H3 heading carries domain name"
    )


def test_normalizer_preserves_data_rows():
    fixed = normalize_domain_product_comparison(_BROKEN_INPUT)
    assert "journal_entry" in fixed
    assert "trial_balance" in fixed
    assert "sales_order" in fixed
    assert "sales_order_line" in fixed


def test_normalizer_preserves_unrelated_sections():
    fixed = normalize_domain_product_comparison(_BROKEN_INPUT)
    assert "## Some Other Section" in fixed and "This stays untouched." in fixed


def test_normalizer_is_idempotent():
    once = normalize_domain_product_comparison(_BROKEN_INPUT)
    twice = normalize_domain_product_comparison(once)
    assert once == twice, (
        "normalizer must be idempotent — running it on already-fixed text must not mutate it"
    )


def test_normalizer_no_op_on_text_without_section():
    text = "# Just a doc\n\nNo comparison section here.\n"
    assert normalize_domain_product_comparison(text) == text


def test_normalizer_no_op_on_text_already_using_subtables():
    already_fixed = """\
## Domain & Product Comparison

<a id="domain-finance"></a>
### finance

| Subdomain | Product | ECM | MVM | Notes |
|---|---|:---:|:---:|---|
| core_ledger | journal_entry | \u2705 | \u274c | Domain not in MVM |
"""
    assert normalize_domain_product_comparison(already_fixed) == already_fixed, (
        "running the normalizer on a tree that already uses per-domain sub-tables must be a no-op"
    )


def test_normalize_industry_readmes_walks_only_readme_md(tmp_path):
    indir = tmp_path / "agriculture"
    indir.mkdir()
    (indir / "readme.md").write_text(_BROKEN_INPUT, encoding="utf-8")
    (indir / "ecm_v1").mkdir()
    (indir / "ecm_v1" / "readme.md").write_text("# clean\n", encoding="utf-8")
    (indir / "ecm_v1" / "model.json").write_text('{"x":1}', encoding="utf-8")
    out = normalize_industry_readmes(str(indir), log=lambda _m: None)
    paths = out["normalized"]
    assert len(paths) == 1, "only the broken readme should be rewritten"
    assert paths[0].endswith("agriculture/readme.md") or paths[0].endswith("agriculture\\readme.md")
    assert (indir / "ecm_v1" / "readme.md").read_text() == "# clean\n", (
        "the ecm_v1/readme.md is clean and must NOT be rewritten"
    )


def test_normalize_industry_readmes_skips_when_no_broken_pattern(tmp_path):
    indir = tmp_path / "x"
    indir.mkdir()
    clean = "# Clean\n\n## Other\n\nText only.\n"
    (indir / "readme.md").write_text(clean, encoding="utf-8")
    out = normalize_industry_readmes(str(indir), log=lambda _m: None)
    assert out["normalized"] == [], "no rewrite when no broken pattern present"
    assert (indir / "readme.md").read_text() == clean


def test_sync_to_repo_invokes_normalizer_post_export():
    src = (REPO / "runner" / "sync_to_repo.py").read_text()
    body = src.split("def sync_completed_industries(", 1)[1]
    assert "normalize_industry_readmes(" in body, (
        "sync_completed_industries MUST call normalize_industry_readmes(...) after export-dir, "
        "before commit/push, so v0.7.1 broken readmes are fixed inline before they ever reach origin/main"
    )
    assert "[readme-normalizer FIRED]" in src, (
        "normalizer MUST emit a [readme-normalizer FIRED] sentinel for §10.7 grep verification"
    )


def test_agent_notebook_uses_per_domain_subtable_pattern():
    """Root-cause fix in the agent: step_save_to_md must emit per-domain mini-tables, not one giant table broken by mid-table anchors."""
    import json

    nb_path = REPO / "agent" / "dbx_vibe_modelling_agent.ipynb"
    nb = json.loads(nb_path.read_text())
    src_chunks = []
    for c in nb["cells"]:
        if c["cell_type"] == "code":
            src_chunks.extend(c["source"])
    full_src = "".join(src_chunks)

    assert 'f\'\\n<a id="{_ov_domain_anchor}"></a>\\n\'' not in full_src, (
        "old broken pattern md.append(f'\\n<a id=\"{_ov_domain_anchor}\"></a>\\n') must be removed — "
        "this is the root cause of literal '|' rendering in the Domain & Product Comparison section"
    )

    assert 'md.append(f\'<a id="{_ov_domain_anchor}"></a>\')' in full_src, (
        "agent must emit anchor as its own line OUTSIDE any markdown table"
    )
    assert 'md.append(f"### {domain}")' in full_src, (
        "agent must emit an H3 heading for each domain so each mini-table has its own anchored heading"
    )
    assert 'md.append("| Subdomain | Product | ECM | MVM | Notes |")' in full_src, (
        "agent must emit the new 5-column per-domain header (Domain column dropped — H3 heading carries it)"
    )
    assert "domain_cell" not in full_src, (
        "dead variable 'domain_cell' must be removed; H3 heading replaces the leading **<domain>** cell"
    )

    assert "## Domain & Product Comparison" in full_src


if __name__ == "__main__":
    raise SystemExit(pytest.main([__file__, "-v"]))
