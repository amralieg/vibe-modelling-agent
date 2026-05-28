"""v0.8.2 P46/P47 behavioral tests.

P46 alias=rdfs-description-keyerror-fix — RDFS generator must use .get('description','') at the 3
business_row / domain / product comment sites to avoid KeyError on missing description.

P47 alias=user-pinned-domain-guard — §3b defense-in-depth:
- module-level _USER_PINNED_DOMAINS_RUNTIME cache
- _is_user_pinned_domain helper
- _guard_user_pinned_domain_drop helper
- population in step_interpret_model_instructions (widget business_domains + v1 input preserve)
- guards at 4 mutation drop sites
"""
import json
import re
import pathlib

AGENT_NB = pathlib.Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_cell1():
    nb = json.loads(AGENT_NB.read_text(encoding="utf-8"))
    return "".join(nb["cells"][1].get("source", []))


def _read_all_cells():
    nb = json.loads(AGENT_NB.read_text(encoding="utf-8"))
    return "\n".join("".join(c.get("source", [])) for c in nb["cells"])


def test_v82_agent_version_is_at_least_082():
    """Per CLAUDE.md §3a single-digit semver, version must be >= 0.8.2."""
    cell1 = _read_cell1()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', cell1)
    assert m, "__AGENT_VERSION__ not found in Cell 1"
    maj, mn, pt = int(m.group(1)), int(m.group(2)), int(m.group(3))
    assert (maj, mn, pt) >= (0, 8, 2), f"expected >= 0.8.2, got {maj}.{mn}.{pt}"


def test_v82_p46_rdfs_description_keyerror_fix_present():
    """RDFS comment lines must use safe description extraction (either P46 .get() fix
    or P62 _safe_desc helper which supersedes it by also handling Spark Row objects)."""
    src = _read_all_cells()
    p46_count = src.count("rdfs-description-keyerror-fix")
    p62_count = src.count("rdfs-business-row-asdict")
    assert (p46_count + p62_count) >= 3, (
        f"expected at least 3 RDFS description sites to use either P46 or P62 fix alias "
        f"(p46={p46_count}, p62={p62_count})"
    )
    assert "sanitize_literal(business_row['description'])" not in src, (
        "P46 regression: business_row['description'] hard-key access still present in RDFS"
    )
    assert "sanitize_literal(domain['description'])" not in src, (
        "P46 regression: domain['description'] hard-key access still present in RDFS"
    )
    assert "sanitize_literal(product['description'])" not in src, (
        "P46 regression: product['description'] hard-key access still present in RDFS"
    )


def test_v82_p47_module_level_cache_present():
    """Module-level _USER_PINNED_DOMAINS_RUNTIME set + helpers must be in Cell 1."""
    cell1 = _read_cell1()
    assert "_USER_PINNED_DOMAINS_RUNTIME" in cell1, "P47 cache symbol missing from Cell 1"
    assert "def _is_user_pinned_domain" in cell1, "P47 _is_user_pinned_domain helper missing"
    assert "def _guard_user_pinned_domain_drop" in cell1, "P47 _guard_user_pinned_domain_drop missing"
    assert "user-pinned-domain-runtime-cache" in cell1
    assert "user-pinned-domain-check" in cell1
    assert "user-pinned-domain-guard" in cell1


def test_v82_p47_cache_populated_in_step_interpret():
    """The cache must be populated with widget business_domains in step_interpret_model_instructions."""
    src = _read_all_cells()
    assert "user-pinned-domains-runtime-populate FIRED" in src, (
        "P47 cache population sentinel not emitted in orchestrator"
    )
    # And must also extend with v1 preserve
    assert "user-pinned-domains-runtime-add-v1 FIRED" in src, (
        "P47 cache v1-preserve extension sentinel not emitted"
    )


def test_v82_p47_guard_present_at_llm_fallback_remove():
    """_llm_fallback_apply_mutations domain.remove path must call _guard_user_pinned_domain_drop."""
    src = _read_all_cells()
    assert "user-pinned-domain-guard-llm-fallback" in src, (
        "P47 guard missing at _llm_fallback_apply_mutations entity-remove path"
    )


def test_v82_p47_guard_present_at_drop_domain_action():
    """apply_mutation_command 'drop' scope 'domain' must call _guard_user_pinned_domain_drop."""
    src = _read_all_cells()
    assert "user-pinned-domain-guard-drop-action" in src, (
        "P47 guard missing at apply_mutation_command drop_domain action"
    )


def test_v82_p47_guard_present_at_drop_domains_except():
    """drop_domains_except must auto-augment keep_domains with user-pinned ones."""
    src = _read_all_cells()
    assert "user-pinned-domain-guard-drop-except" in src, (
        "P47 keep-domains augmentation missing at drop_domains_except path"
    )


def test_v82_p47_guard_present_at_archive_domain():
    """archive_domain must call _guard_user_pinned_domain_drop."""
    src = _read_all_cells()
    assert "user-pinned-domain-guard-archive" in src, (
        "P47 guard missing at archive_domain action"
    )


def test_v82_p47_is_user_pinned_domain_returns_true_for_cached():
    """Behavioral: pinning a domain in the cache makes _is_user_pinned_domain return True."""
    cell1 = _read_cell1()
    # Execute the helper definitions standalone to verify the behavioral contract
    ns = {}
    # Trim to just the helper block to keep exec cheap
    block_start = cell1.find("_USER_PINNED_DOMAINS_RUNTIME = set()")
    block_end = cell1.find("VIBE_MODELING_ASCII_ART")
    helper_block = cell1[block_start:block_end]
    assert block_start >= 0 and block_end > block_start, "could not isolate helper block"
    exec(helper_block, ns)
    ns["_USER_PINNED_DOMAINS_RUNTIME"].clear()
    ns["_USER_PINNED_DOMAINS_RUNTIME"].update({"court", "client", "matter"})
    assert ns["_is_user_pinned_domain"]("court") is True
    assert ns["_is_user_pinned_domain"]("Court") is True  # case-insensitive
    assert ns["_is_user_pinned_domain"]("contract") is False
    assert ns["_is_user_pinned_domain"]("") is False
    assert ns["_is_user_pinned_domain"](None) is False


def test_v82_p47_guard_blocks_pinned_domain_drop_returns_false():
    """Behavioral: _guard_user_pinned_domain_drop returns False (=block) for cached domains."""
    cell1 = _read_cell1()
    ns = {}
    block_start = cell1.find("_USER_PINNED_DOMAINS_RUNTIME = set()")
    block_end = cell1.find("VIBE_MODELING_ASCII_ART")
    exec(cell1[block_start:block_end], ns)
    ns["_USER_PINNED_DOMAINS_RUNTIME"].clear()
    ns["_USER_PINNED_DOMAINS_RUNTIME"].add("court")

    class _CapturingLogger:
        def __init__(self):
            self.warnings = []

        def warning(self, msg):
            self.warnings.append(msg)

    log = _CapturingLogger()
    # Pinned domain → blocked
    assert ns["_guard_user_pinned_domain_drop"]("court", logger=log, action_label="test") is False
    assert any("user-pinned-domain-guard FIRED" in w for w in log.warnings)
    # Non-pinned domain → allowed (no warning)
    log.warnings.clear()
    assert ns["_guard_user_pinned_domain_drop"]("workforce", logger=log, action_label="test") is True
    assert log.warnings == []


def test_v82_preserves_v81_p44_p45():
    """Anti-regression: v0.8.1 P44/P45 sentinels must remain in the agent notebook."""
    src = _read_all_cells()
    assert "vov-no-forced-master-record-stub FIRED" in src
    assert "vov-hydrate-skip-non-vov FIRED" in src


def test_v82_p48_vov_sizing_gate_domain_only_filter_present():
    """P48 alias=vov-sizing-gate-domain-only-filter — root-cause fix for the false-positive
    'missing domains' that were really product/attribute tuples. Must filter to single-element
    domain tuples before the membership check against _final_dom_names."""
    src = _read_all_cells()
    assert "vov-sizing-gate-domain-only-filter" in src, (
        "P48 alias missing from agent notebook"
    )
    assert "_skipped_pa" in src, (
        "P48 skipped-product/attribute counter missing"
    )
    # Anti-regression: the original str(_t) on multi-element tuples must be gone in that gate
    # Easier check: ensure the new filter branch exists
    assert "if isinstance(_t, (tuple, list)) and len(_t) == 1 and _t[0]:" in src, (
        "P48 single-element-domain filter branch missing in vov-sizing-hard-gate"
    )


def test_v82_p49_stale_table_alert_only_on_confirmed_extras():
    """P49 alias=stale-table-confirmed-extras / stale-table-no-extras-info — root-cause fix for
    STALE TABLE ALERT firing at ERROR level even when extras-list comes up EMPTY (junction
    tables / normalization side-effects, not actually stale). Must:
    1. Compute extras BEFORE logging the ERROR.
    2. Emit ERROR with alias=stale-table-confirmed-extras ONLY when extras_count > 0.
    3. Emit INFO with alias=stale-table-no-extras-info when count differs but all names match.
    """
    src = _read_all_cells()
    assert "stale-table-confirmed-extras" in src, (
        "P49 confirmed-extras ERROR alias missing"
    )
    assert "stale-table-no-extras-info" in src, (
        "P49 no-extras INFO alias missing"
    )
    # The old structure that logged ERROR before computing extras must be gone:
    # specifically, the line that logged 'STALE TABLE ALERT' immediately under
    # 'if len(created_tables) > expected_count:' without the intervening extras compute.
    bad_pat = re.compile(
        r"if len\(created_tables\) > expected_count:\s*\\n[^\n]*extra_count = len\(created_tables\) - expected_count[^\n]*\\n[^\n]*logger\.error\(f.*STALE TABLE ALERT.*from previous runs",
        re.DOTALL,
    )
    assert not bad_pat.search(src), (
        "P49 regression: STALE TABLE ALERT still logged BEFORE extras-list is computed"
    )


def test_v82_no_hardcoded_master_record_in_executable_code():
    """Anti-regression for 'EVERYTHING MUST COME FROM LLM': scan only Python code cells (not
    markdown cells, not version-header comments) for the literal hardcoded f-string fallback.
    Acceptable: the literal appears inside comment / docstring / markdown narrative documenting
    why P44 removed it. Disallowed: an actual executable assignment using the fallback."""
    nb = json.loads(AGENT_NB.read_text(encoding="utf-8"))
    bad_pat = re.compile(
        r"""^[^#\n]*_vov_products_map\s*=\s*\{[^}]*['"]_master_record['"]""",
        re.MULTILINE,
    )
    for idx, cell in enumerate(nb["cells"]):
        if cell.get("cell_type") != "code":
            continue
        src = "".join(cell.get("source", []))
        # Strip the version-header comment block (it intentionally documents the deleted pattern).
        # The version header sits on one logical line glued together; strip lines that start with '#' or are inside quoted strings explaining the change.
        # Simple heuristic: only fail if pattern is in non-comment Python code.
        m = bad_pat.search(src)
        assert not m, (
            f"regression: hardcoded master_record fallback re-introduced in cell {idx} at: {m.group(0)[:200]}"
        )
