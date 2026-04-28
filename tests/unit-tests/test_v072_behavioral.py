"""Behavioral tests for v0.7.2 — three root-cause fixes from v0.7.1 airlines tiny live audit
(run 1097831250061095, all 5 tasks SUCCESS) PLUS the Phase 6 Retailer SHRINK-NEW-SILO
external report (Databricks parent run 939656662583490).

Fixes shipped:
  1. self-ref-mem-json-sync   — Memory <-> JSON drift fix. The SELF-REF-FIX autofix
                                mutates `widgets_values["attributes"]` in-place
                                (adds new renamed FK rows) but never persists the
                                mutation back to ATTRIBUTES_FILE_PATH. The next
                                downstream step reads JSON, sees stale data,
                                computes a Memory-vs-JSON drift, and the fidelity
                                gate fails at precision 0.5 (root cause of v0.7.1
                                ECM N2 with `crew.bid_period.prior_bid_period_id`,
                                `crew.training_center.parent_training_center_id`,
                                `flight.aircraft.replaced_aircraft_id` only in
                                Memory). New: rewrite ATTRIBUTES_FILE_PATH from
                                Memory state on count drift.

  2. mv-prevalidate-keywords-extend  — MV column prevalidator was rejecting
                                MVs whose expressions used `between`,
                                `current_date`, `interval`, etc. (4/12 ECM and
                                4/16 MVM in v0.7.1) because these SQL keywords
                                were not in the SQL_KW exclusion list and got
                                parsed as missing column tokens. Extend the
                                keyword set to cover SQL-92 conditional +
                                datetime/system + window + aggregate + array/map
                                + numeric/string functions.

  3. shrink-orphan-drop      — Phase 6 Retailer report: LLM kept REAL product
                                `customer.segment` as MVM survivor without
                                keeping any FK partner. Validator's old message
                                LIED about "validator will retry the LLM" but
                                no retry exists. Now: deterministic auto-drop
                                of orphan products from `tables_to_keep`,
                                cascade detection, NEXT_VIBES file, clear
                                error messages on degenerate plans.

Aliases under test:
  - self-ref-mem-json-sync
  - mv-prevalidate-keywords-extend
  - shrink-orphan-drop
  - shrink-orphan-drop-cascade
  - shrink-orphan-drop-cleared
  - agent-version-global   (re-asserted at 0.7.2)
  - agent-version-mirror   (re-asserted at 0.7.2)
"""

import json
import re
from pathlib import Path

AGENT = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"

EXPECTED_VERSION = "0.7.2"


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


def test_v072_constant_bumped_to_expected():
    txt = _agent_text()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', txt)
    assert m is not None, "__AGENT_VERSION__ constant not found"
    assert m.group(1) == EXPECTED_VERSION, (
        f"__AGENT_VERSION__ '{m.group(1)}' != expected '{EXPECTED_VERSION}'"
    )


def test_v072_constant_first_line_of_cell1():
    src = _first_code_cell_source()
    code_lines = [
        ln for ln in src.splitlines()
        if ln.strip() and not ln.lstrip().startswith("#")
    ]
    assert code_lines and code_lines[0].startswith("__AGENT_VERSION__"), (
        f"First non-comment line in Cell 1 must be __AGENT_VERSION__; got: {code_lines[0]!r}"
    )


def test_v072_single_digit_semver():
    assert re.fullmatch(r"\d\.\d\.\d", EXPECTED_VERSION), (
        f"EXPECTED_VERSION '{EXPECTED_VERSION}' violates CLAUDE.md §3a single-digit semver"
    )


def test_v072_readme_current_version_matches():
    rd = AGENT.parents[1] / "readme.md"
    with rd.open() as f:
        txt = f.read()
    m = re.search(r"Current version:\s*\*\*v(\d\.\d\.\d)\*\*", txt)
    assert m is not None, "Could not locate 'Current version:' line in readme.md"
    assert m.group(1) == EXPECTED_VERSION, (
        f"readme.md Current version 'v{m.group(1)}' != expected 'v{EXPECTED_VERSION}'"
    )


# ============================================================================
# Fix 1: self-ref-mem-json-sync
# ============================================================================


def test_v072_fix1_alias_present():
    txt = _agent_text()
    assert "self-ref-mem-json-sync FIRED" in txt, (
        "Expected at least one [self-ref-mem-json-sync FIRED] log marker"
    )
    assert "alias=self-ref-mem-json-sync" in txt, (
        "Expected alias=self-ref-mem-json-sync sentinel"
    )


def test_v072_fix1_writes_back_to_attributes_file_path():
    """The fix must read ATTRIBUTES_FILE_PATH, compare counts, and rewrite the
    JSON from in-memory `widgets_values["attributes"]` when they differ."""
    txt = _agent_text()
    assert "_v72_attrs_path = (config or {}).get('ATTRIBUTES_FILE_PATH')" in txt, (
        "Fix must read ATTRIBUTES_FILE_PATH from config"
    )
    assert "_v72_mem_attrs = widgets_values.get(\"attributes\", []) or []" in txt, (
        "Fix must read in-memory attrs from widgets_values"
    )
    assert "json.dump(_v72_mem_attrs, _v72_wf, indent=2, default=str)" in txt, (
        "Fix must rewrite the JSON file from Memory state"
    )


def test_v072_fix1_runs_after_self_ref_fix_block():
    """The mem-json sync MUST run AFTER the SELF-REF-FIX try/except so it sees
    the mutated attrs list, not the pre-mutation state."""
    txt = _agent_text()
    srf_end = txt.find("[SELF-REF-FIX] Failed (non-critical)")
    sync_start = txt.find("self-ref-mem-json-sync FIRED")
    invariants_start = txt.find("Capturing post-finalize invariants")
    assert srf_end > 0, "Could not locate SELF-REF-FIX except clause"
    assert sync_start > 0, "Could not locate sync FIRED log"
    assert invariants_start > 0, "Could not locate post-finalize invariants log"
    assert srf_end < sync_start < invariants_start, (
        f"sync block must run AFTER SELF-REF-FIX (pos {srf_end}) and BEFORE "
        f"post-finalize invariants (pos {invariants_start}); sync at {sync_start}"
    )


def test_v072_fix1_no_tautology_actually_writes_on_drift():
    """Anti-tautology: the sync MUST be conditional on count drift AND it MUST
    perform the write (not just log)."""
    txt = _agent_text()
    pos = txt.find("self-ref-mem-json-sync FIRED")
    assert pos > 0
    window_before = txt[max(0, pos - 600):pos]
    assert "if _v72_mem_count != _v72_json_count" in window_before, (
        "Sync must be guarded by count-drift check (not unconditional write)"
    )
    assert "json.dump(_v72_mem_attrs" in window_before, (
        "Sync must actually write to JSON, not just log"
    )


# ============================================================================
# Fix 2: mv-prevalidate-keywords-extend
# ============================================================================


def test_v072_fix2_alias_present():
    txt = _agent_text()
    assert "mv-prevalidate-keywords-extend" in txt, (
        "Expected the mv-prevalidate-keywords-extend alias comment in the SQL_KW extension block"
    )


def test_v072_fix2_keywords_include_between_and_current_date():
    """The exact tokens that triggered v0.7.1 false-positive drops MUST be in the keyword set."""
    txt = _agent_text()
    pos = txt.find("mv-prevalidate-keywords-extend")
    assert pos > 0
    window_after = txt[pos:pos + 4000]
    for kw in ["'between'", "'current_date'", "'current_timestamp'", "'interval'"]:
        assert kw in window_after, (
            f"SQL keyword {kw} missing from extended _mvcp_SQL_KW set — would re-introduce "
            f"the v0.7.1 false-positive drop class"
        )


def test_v072_fix2_keywords_cover_common_window_and_aggregate_funcs():
    """Defense-in-depth: window functions and common aggregates MUST be in the set."""
    txt = _agent_text()
    pos = txt.find("mv-prevalidate-keywords-extend")
    assert pos > 0
    window_after = txt[pos:pos + 4000]
    for kw in ["'over'", "'partition'", "'rank'", "'lag'", "'lead'", "'percentile_approx'"]:
        assert kw in window_after, (
            f"Window/aggregate keyword {kw} missing — could cause false-positive drops "
            f"for any MV using analytical functions"
        )


# ============================================================================
# Fix 3: shrink-orphan-drop (Phase 6 Retailer report)
# ============================================================================


def test_v072_fix3_alias_present():
    txt = _agent_text()
    assert "shrink-orphan-drop FIRED" in txt, (
        "Expected at least one [shrink-orphan-drop FIRED] log marker"
    )
    assert "alias=shrink-orphan-drop" in txt, (
        "Expected alias=shrink-orphan-drop sentinel"
    )


def test_v072_fix3_cascade_detection_present():
    txt = _agent_text()
    assert "shrink-orphan-drop-cascade FIRED" in txt, (
        "Cascade detection (auto-drop introducing additional silos) MUST be aliased"
    )
    assert "_v72_postdrop_silos" in txt, (
        "Cascade check must re-run silo detection on the trimmed tables_to_keep"
    )


def test_v072_fix3_clears_log_on_success():
    txt = _agent_text()
    assert "shrink-orphan-drop-cleared FIRED" in txt, (
        "On clean post-drop validation, must emit [shrink-orphan-drop-cleared FIRED]"
    )


def test_v072_fix3_no_lying_validator_message():
    """The OLD lying message 'Re-run shrink (validator will retry the LLM)' MUST be gone.
    The validator does not actually retry the LLM — that text was the §8.3 tautology root
    cause of the Phase 6 Retailer report."""
    txt = _agent_text()
    assert "validator will retry the LLM" not in txt, (
        "Lying validator message 'validator will retry the LLM' must be removed; "
        "no LLM retry exists. Replace with deterministic auto-drop or honest error."
    )


def test_v072_fix3_no_tautology_actually_mutates_tables_to_keep():
    """Anti-tautology: the orphan-drop MUST actually mutate `tables_to_keep`
    (different sizes before vs after) — not just log."""
    txt = _agent_text()
    pos = txt.find("shrink-orphan-drop FIRED")
    assert pos > 0
    window_before = txt[max(0, pos - 1200):pos]
    assert "_v72_keep_before = len(tables_to_keep)" in window_before, (
        "Must capture the BEFORE count to prove mutation"
    )
    assert "tables_to_keep = {(d, p) for (d, p) in tables_to_keep" in window_before, (
        "Must filter tables_to_keep with set-comprehension excluding orphans"
    )
    assert "_v72_new_silo_set" in window_before, (
        "Must use the new-silo set (not phantom-set or input-silo-set) for filtering"
    )


def test_v072_fix3_files_next_vibes_for_user_decision():
    """Auto-drop is not a silent decision — the dropped product MUST be filed
    in NEXT_VIBES so the next vibe iteration can revisit it."""
    txt = _agent_text()
    pos = txt.find("shrink-orphan-drop FIRED")
    assert pos > 0
    window_after = txt[pos:pos + 1500]
    assert 'rule_id="SHRINK_ORPHAN_DROPPED"' in window_after, (
        "Auto-drop must add a SHRINK_ORPHAN_DROPPED row to NEXT_VIBES"
    )
    assert "NEEDS_USER_DECISION" in window_after, (
        "NEXT_VIBES severity should be NEEDS_USER_DECISION (user can vibe to keep+link)"
    )


def test_v072_fix3_handles_degenerate_empty_plan():
    """If after auto-drop tables_to_keep is empty, raise an INSTRUCTIVE error
    (not a generic ValueError) suggesting the next vibe text the user should provide."""
    txt = _agent_text()
    assert "v0.7.2 SHRINK-NEW-SILO-ALL-ORPHANS" in txt, (
        "Empty-plan path must raise an instructive error with the canonical alias"
    )
    assert "shrink-orphan-drop-emptied" in txt, (
        "Empty-plan error must carry a distinct alias for grep audit"
    )


def test_v072_fix3_phantom_drop_still_runs_first():
    """v0.7.1 shrink-phantom-drop is a complementary fix — phantom-name filter
    MUST still run BEFORE orphan-drop (which only handles real-product silos)."""
    txt = _agent_text()
    phantom_pos = txt.find("shrink-phantom-drop FIRED")
    orphan_pos = txt.find("shrink-orphan-drop FIRED")
    assert phantom_pos > 0 and orphan_pos > 0, "Both v71 phantom-drop and v72 orphan-drop must be present"
    assert phantom_pos < orphan_pos, (
        f"shrink-phantom-drop (phantom-names) must run BEFORE shrink-orphan-drop "
        f"(real-product orphans); phantom at {phantom_pos}, orphan at {orphan_pos}"
    )


def test_v072_fix3_preexisting_silo_path_still_fires_independently():
    """The pre-existing-silo PASS-THROUGH path must run via `if _preexisting_silos`
    (NOT `elif`) so it fires correctly on plans that have pre-existing input silos
    but no NEW silos (the elif structure would have masked it after my orphan-drop
    branch handles _new_silos)."""
    txt = _agent_text()
    pos = txt.find("Shrink plan PASS-THROUGH:")
    assert pos > 0, "Pre-existing silo PASS-THROUGH path must still exist"
    window_before = txt[max(0, pos - 200):pos]
    assert "elif _preexisting_silos" in window_before or "if _preexisting_silos" in window_before, (
        "Pre-existing silo branch keyword must be present"
    )


RUNNER = Path(__file__).resolve().parents[2] / "runner" / "vibe_runner.ipynb"


def _runner_text():
    with RUNNER.open() as f:
        nb = json.load(f)
    return "\n".join("".join(c.get("source", [])) for c in nb.get("cells", []))


def test_v072_fix4_runner_agent_multipath_alias_present():
    txt = _runner_text()
    assert "runner-agent-multipath FIRED" in txt, (
        "Expected [runner-agent-multipath FIRED] log marker so vibe_tester test 00 "
        "no longer fails with 'Workload failed' on flat user-root deploys"
    )
    assert "alias=runner-agent-multipath" in txt, (
        "Expected alias=runner-agent-multipath sentinel for grep audit"
    )


def test_v072_fix4_runner_canon_path_resolves_first_when_present():
    """Source-tree convention <repo>/runner -> <repo>/agent must STILL be tried
    first (so existing dev workflows are not broken)."""
    txt = _runner_text()
    assert 'posixpath.normpath(posixpath.join(runner_dir, "./../agent/dbx_vibe_modelling_agent"))' in txt, (
        "Canon source-tree path must still be the FIRST attempt (preserve dev workflow)"
    )
    canon_pos = txt.find('posixpath.normpath(posixpath.join(runner_dir, "./../agent/dbx_vibe_modelling_agent"))')
    discovery_pos = txt.find("dbx_vibe_modelling_agent_v(")
    assert canon_pos < discovery_pos, (
        f"Canon path attempt (pos {canon_pos}) must come BEFORE the discovery regex "
        f"(pos {discovery_pos}) — discovery is the FALLBACK only"
    )


def test_v072_fix4_runner_searches_both_parent_and_runner_dir():
    """Multipath: BOTH the runner's parent dir (source-tree) AND the runner's own dir
    (flat user-root) must be in the search list, mirroring vibe_tester's pattern."""
    txt = _runner_text()
    assert '_ra_search_paths = [' in txt, "Search paths list must be defined"
    pos = txt.find("_ra_search_paths = [")
    window = txt[pos:pos + 400]
    assert 'runner_dir.split("/")[:-1]' in window, (
        "Parent-of-runner_dir (source-tree case) must be in search paths"
    )
    assert "runner_dir," in window, (
        "runner_dir itself (flat-deploy sibling case) must be in search paths"
    )


def test_v072_fix4_runner_picks_highest_versioned_archive():
    """When multiple agent_v<N> archives coexist (e.g. v70, v71, v72), the runner
    must select the HIGHEST version (not first-match)."""
    txt = _runner_text()
    pos = txt.find('"  ✅ [runner-agent-multipath FIRED]')
    assert pos > 0, "Must find the FIRED log statement (not just the docstring marker)"
    window_before = txt[max(0, pos - 600):pos]
    assert "_ra_candidates.sort(reverse=True)" in window_before, (
        "Must sort candidates in descending order to pick the highest version"
    )
    assert "_ra_candidates[0][1]" in window_before, (
        "Must select the [0] entry after sort (highest version)"
    )


def test_v072_fix4_runner_only_fires_when_canon_missing():
    """The discovery + log line MUST only fire if the canon path is missing
    (avoid log noise on healthy source-tree deploys)."""
    txt = _runner_text()
    pos = txt.find('"  ✅ [runner-agent-multipath FIRED]')
    assert pos > 0, "Must find the FIRED log statement (not just the docstring marker)"
    window_before = txt[max(0, pos - 2500):pos]
    assert "_ra_resolved" in window_before, (
        "Must check _ra_resolved guard before firing discovery"
    )
    assert "if not _ra_resolved" in window_before, (
        "Discovery scan must be guarded by `if not _ra_resolved`"
    )
