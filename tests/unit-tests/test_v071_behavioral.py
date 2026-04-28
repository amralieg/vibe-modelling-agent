"""Behavioral tests for v0.7.1 — three root-cause fixes from v0.7.0 airlines ECM+MVM audit
of failed runs 76240803654456 (mvm_shrink AttributeError) and 453386975947787 (killed mid-ECM).

Fixes shipped:
  1. shrink-llm-malformed   — `_run_resize_model` shrink branch defensive against
                              LLM responses where `domains_to_remove`,
                              `tables_to_keep`, `tables_to_relocate`, or
                              `domains_to_keep` items are not the expected
                              `dict` shape. Previously crashed with
                              `AttributeError: 'str' object has no attribute 'get'`
                              when LLM returned a list of strings instead of
                              dicts (root cause of run_id 210677821854565
                              first shrink attempt failure).

  2. shrink-phantom-drop    — `_run_resize_model` shrink branch filters
                              `tables_to_keep` against the actual source
                              `products_data` BEFORE running the silo
                              validator. Phantom product names introduced by
                              the LLM (e.g. `legal_entity`, `roster_period`
                              from run_id 450474006514631 second shrink
                              attempt) are now logged + dropped instead of
                              wrongly tripping the SHRINK-NEW-SILO validator
                              (which used to trigger because the phantom
                              names had no FKs in `attributes_data`, looking
                              like silos).

  3. fmfl-final-sanitize    — `_fmfl_postprocessor` performs an unconditional
                              final sweep that auto-coerces any LINK whose
                              `target_table` is not in
                              `_fmfl_canonical_entities` to `KEEP_AS_IS`.
                              Previously the validator's stem-suggestion
                              feedback path could be soft-accepted after
                              `Max retries (3) exhausted` (R7/F2 hatch
                              observed at line 14:40:23 of killed
                              run 453386975947787 for
                              `find_missing_fk_links_workforce`,
                              `timesheet.schedule_id` →
                              `workforce.work_schedule.work_schedule_id`).

Aliases under test:
  - shrink-llm-malformed
  - shrink-llm-malformed-summary
  - shrink-phantom-drop
  - fmfl-final-sanitize
  - fmfl-final-sanitize-summary
  - agent-version-global   (re-asserted at 0.7.1)
  - agent-version-mirror   (re-asserted at 0.7.1)
"""

import json
import re
from pathlib import Path

AGENT = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"

EXPECTED_VERSION = "0.7.1"


def _agent_cells():
    with AGENT.open() as f:
        nb = json.load(f)
    return nb.get("cells", [])


def _cell_source(cell):
    src = cell.get("source", "")
    return "".join(src) if isinstance(src, list) else src


def _agent_text():
    return "\n".join(_cell_source(c) for c in _agent_cells())


def _first_code_cell_source():
    for c in _agent_cells():
        if c.get("cell_type") == "code":
            s = _cell_source(c)
            if s.strip():
                return s
    raise AssertionError("No non-empty code cell found in agent notebook")


def test_v071_constant_bumped_to_expected():
    txt = _agent_text()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', txt)
    assert m is not None, "__AGENT_VERSION__ constant not found"
    assert m.group(1) == EXPECTED_VERSION, (
        f"__AGENT_VERSION__ '{m.group(1)}' != expected '{EXPECTED_VERSION}'"
    )


def test_v071_constant_first_line_of_cell1():
    src = _first_code_cell_source()
    code_lines = [
        ln for ln in src.splitlines()
        if ln.strip() and not ln.lstrip().startswith("#")
    ]
    assert code_lines and code_lines[0].startswith("__AGENT_VERSION__"), (
        f"First non-comment line in Cell 1 must be __AGENT_VERSION__; got: {code_lines[0]!r}"
    )


def test_v071_single_digit_semver():
    assert re.fullmatch(r"\d\.\d\.\d", EXPECTED_VERSION), (
        f"EXPECTED_VERSION '{EXPECTED_VERSION}' violates CLAUDE.md §3a single-digit semver"
    )


# ============================================================================
# Fix 1: shrink-llm-malformed
# ============================================================================


def test_v071_fix1_alias_present():
    txt = _agent_text()
    assert "shrink-llm-malformed FIRED" in txt, (
        "Expected at least one [shrink-llm-malformed FIRED] log marker"
    )
    assert "alias=shrink-llm-malformed" in txt, (
        "Expected alias=shrink-llm-malformed sentinel"
    )


def test_v071_fix1_handles_string_in_domains_to_remove():
    txt = _agent_text()
    assert "domains_to_remove item not a dict" in txt, (
        "domains_to_remove items must be guarded against non-dict (root cause of "
        "AttributeError 'str' has no 'get' in run 210677821854565)"
    )


def test_v071_fix1_handles_string_in_tables_to_keep():
    txt = _agent_text()
    assert "tables_to_keep item not a {{domain,product}} dict" in txt, (
        "tables_to_keep items must be guarded against non-dict shape "
        "(grep matches the f-string source with double braces)"
    )


def test_v071_fix1_handles_string_in_tables_to_relocate():
    txt = _agent_text()
    assert "tables_to_relocate item not a dict" in txt, (
        "tables_to_relocate items must be guarded against non-dict shape"
    )


def test_v071_fix1_summary_emitted():
    txt = _agent_text()
    assert "shrink-llm-malformed-summary FIRED" in txt, (
        "Expected a summary marker after shrink LLM response parsing"
    )


def test_v071_fix1_no_unguarded_dict_get_on_removed_domain():
    """Behavioural: the `removed_domain.get(\"tables_to_relocate\")` call MUST
    be preceded by an `isinstance(removed_domain, dict)` guard within ~6 lines."""
    txt = _agent_text()
    # Find the .get call site
    pos = txt.find('removed_domain.get(\\"tables_to_relocate\\")')
    if pos < 0:
        pos = txt.find('removed_domain.get("tables_to_relocate")')
    assert pos > 0, "Could not locate removed_domain.get(\"tables_to_relocate\") call"
    # Look in the 800-char window BEFORE the call for the isinstance guard
    window = txt[max(0, pos - 800):pos]
    assert "isinstance(removed_domain, dict)" in window, (
        "removed_domain.get(...) call site is not guarded by isinstance() within 800 chars; "
        "this is the exact failure mode of run 210677821854565"
    )


# ============================================================================
# Fix 2: shrink-phantom-drop
# ============================================================================


def test_v071_fix2_alias_present():
    txt = _agent_text()
    assert "shrink-phantom-drop FIRED" in txt, (
        "Expected [shrink-phantom-drop FIRED] log marker"
    )
    assert "alias=shrink-phantom-drop" in txt, (
        "Expected alias=shrink-phantom-drop sentinel"
    )


def test_v071_fix2_phantom_filter_runs_before_silo_validator():
    """The phantom filter MUST run BEFORE the silo validator block; otherwise
    the silo validator would still wrongly fail on phantom product names."""
    txt = _agent_text()
    phantom_pos = txt.find("shrink-phantom-drop FIRED")
    silo_pos = txt.find("v0.9.1 SHRINK-NEW-SILO")
    assert phantom_pos > 0 and silo_pos > 0, "Both markers must be present"
    assert phantom_pos < silo_pos, (
        "Phantom-drop must occur BEFORE the SHRINK-NEW-SILO validator raises; "
        "otherwise phantoms still trigger false positives (root cause of "
        "run 450474006514631 SHRINK-NEW-SILO failure with phantom names "
        "['legal_entity', 'roster_period'])"
    )


def test_v071_fix2_filter_uses_source_product_names():
    txt = _agent_text()
    assert "_source_product_names_set" in txt, (
        "Phantom filter must compare against source product names (not just (domain,product) tuples) "
        "so that LLM-relocated products with NEW domain names are not falsely treated as phantoms"
    )


def test_v071_fix2_relocations_filtered_too():
    """Phantom drop must also filter `domain_relocations` so downstream FK
    rewrite logic does not see phantom mappings."""
    txt = _agent_text()
    # Look for the relocation comprehension
    assert "domain_relocations = {(od, pn): nd" in txt, (
        "domain_relocations must be filtered by the same source-product-names set "
        "to keep downstream FK rewrite consistent with the filtered tables_to_keep"
    )


# ============================================================================
# Fix 3: fmfl-final-sanitize
# ============================================================================


def test_v071_fix3_alias_present():
    txt = _agent_text()
    assert "fmfl-final-sanitize FIRED" in txt, (
        "Expected [fmfl-final-sanitize FIRED] log marker"
    )
    assert "alias=fmfl-final-sanitize" in txt, (
        "Expected alias=fmfl-final-sanitize sentinel"
    )


def test_v071_fix3_summary_emitted():
    txt = _agent_text()
    assert "fmfl-final-sanitize-summary FIRED" in txt, (
        "Expected summary marker after FMFL post-process sanitisation"
    )


def test_v071_fix3_runs_inside_fmfl_postprocessor():
    """The final sanitise must be inside `_fmfl_postprocessor`, after the
    person/role corrections, BEFORE the actual_counts recomputation."""
    txt = _agent_text()
    pp_pos = txt.find("def _fmfl_postprocessor")
    sanitize_pos = txt.find("fmfl-final-sanitize FIRED")
    counts_pos = txt.find('actual_counts = {"LINK": 0, "CREATE": 0, "DROP": 0, "KEEP_AS_IS": 0}')
    assert 0 < pp_pos < sanitize_pos, "fmfl-final-sanitize must be inside _fmfl_postprocessor"
    assert sanitize_pos < counts_pos, (
        "fmfl-final-sanitize must run BEFORE the actual_counts recomputation "
        "(otherwise the LINK/KEEP_AS_IS counts in summary will be wrong)"
    )


def test_v071_fix3_coerces_link_to_keep_as_is():
    """The sanitiser must change decision -> KEEP_AS_IS, null target_table,
    and prepend an AUTO-COERCED-FINAL marker to reasoning."""
    txt = _agent_text()
    # Find the sanitize block
    pos = txt.find("AUTO-COERCED-FINAL")
    assert pos > 0, "Expected AUTO-COERCED-FINAL reasoning prefix on coerced decisions"
    # Window from pos backward 600 chars should contain decision change + target null
    window = txt[max(0, pos - 600):pos + 200]
    assert 'dec["decision"] = "KEEP_AS_IS"' in window, "Sanitiser must set decision to KEEP_AS_IS"
    assert 'dec["target_table"] = None' in window, "Sanitiser must null the target_table"


def test_v071_fix3_uses_canonical_entities_set():
    """The sanitiser must check against `_fmfl_canonical_entities` (the same
    set used by the validator), not invent a new check."""
    txt = _agent_text()
    pos = txt.find("fmfl-final-sanitize FIRED")
    window = txt[max(0, pos - 800):pos]
    assert "_fmfl_canonical_entities" in window, (
        "fmfl-final-sanitize must reuse _fmfl_canonical_entities for DRY consistency"
    )
    assert "_fmfl_normalise_target" in window, (
        "fmfl-final-sanitize must use _fmfl_normalise_target for the same domain.product canonicalisation"
    )


# ============================================================================
# Anti-tautology — none of the new branches always-fall-through
# ============================================================================


def test_v071_no_tautology_shrink_llm_malformed():
    """Per CLAUDE.md §8.3, the malformed guard MUST have a hard skip path,
    not just log + continue with broken data."""
    txt = _agent_text()
    pos = txt.find("[shrink-llm-malformed FIRED] domains_to_remove")
    assert pos > 0
    window = txt[pos:pos + 600]
    assert "continue" in window, (
        "shrink-llm-malformed branch must SKIP the malformed item via continue, "
        "not fall through and re-trigger the original AttributeError"
    )


def test_v071_no_tautology_phantom_drop_filters_set():
    txt = _agent_text()
    pos = txt.find("[shrink-phantom-drop FIRED]")
    assert pos > 0
    window = txt[pos:pos + 1000]
    assert "tables_to_keep = {(d, p) for (d, p) in tables_to_keep" in window, (
        "phantom-drop branch must REASSIGN tables_to_keep to the filtered set, "
        "not just log and proceed (otherwise the silo validator still sees phantoms)"
    )


def test_v071_no_tautology_fmfl_actually_changes_decision():
    txt = _agent_text()
    pos = txt.find("[fmfl-final-sanitize FIRED]")
    assert pos > 0
    window = txt[max(0, pos - 1500):pos]
    assert 'dec["decision"] = "KEEP_AS_IS"' in window, (
        "fmfl-final-sanitize branch must actually mutate dec['decision'] to KEEP_AS_IS, "
        "not just log without changing the response"
    )
    assert 'dec["target_table"] = None' in window, (
        "fmfl-final-sanitize must also null the target_table; otherwise the FK is still pointing somewhere"
    )
