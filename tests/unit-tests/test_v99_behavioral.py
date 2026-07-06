"""v0.9.9 behavioral test — master-analyze fallback derives classification from manifest.

ROOT-CAUSE FIX for v0.9.8 RT iter-2 GENERATIVE-bypass.

Symptom (RT iter-2, run 358541968803010):
    The VIBE_MASTER_PROMPT timed out at 720s SQL timeout. The caller fallback
    at `step_interpret_model_instructions` then hardcoded
    `vibe_classification['classification'] = 'GENERATIVE'`, completely ignoring
    the orchestrator's already-successful parse (manifest.overall_mode=surgical
    with 85/85 per-requirement modes=surgical).

Result chain:
    master_analyze returns None (timeout)
    -> caller fallback sets classification='GENERATIVE' (HARDCODED, no manifest read)
    -> compile_vibe_contract reads vibe_classification['classification']='GENERATIVE'
    -> contract.mode='GENERATIVE'
    -> mutation pipeline bypassed
    -> 0 mutation_applied events
    -> 0% structural adherence on RT (vs 82% on HC which did NOT time out)

v0.9.9 fix:
    When master_analyze returns None/raises, the caller fallback now:
      1. Reads `_orch.manifest.requirements` (already successfully parsed).
      2. Aggregates per-requirement `mode` via deterministic majority rule.
      3. Falls through to `manifest.overall_mode` if per-requirement modes empty.
      4. Falls through to GENERATIVE only as a TRUE last resort (empty manifest).

    Generic, no regex on text, no industry strings, no hardcoded entity names.
    The aggregation is a pure Counter pattern over an enum field already
    populated by the LLM parse step.

Sentinel: '[master-failure-mode-from-manifest FIRED]' on recovery,
          '[master-failure-mode-from-manifest FALLBACK]' on empty-manifest GENERATIVE,
          '[master-failure-mode-from-manifest ERROR]' on unexpected attribute access.
"""
import json
import re
from pathlib import Path

NOTEBOOK = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_notebook_source():
    nb = json.loads(NOTEBOOK.read_text())
    return [(idx, "".join(cell.get("source", []))) for idx, cell in enumerate(nb["cells"])]


def _all_source():
    return "\n".join(src for _, src in _load_notebook_source())


def test_v99_agent_version_constant():
    cells = _load_notebook_source()
    cell1 = next(src for idx, src in cells if "__AGENT_VERSION__" in src)
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', cell1)
    assert m is not None, "v0.9.9: __AGENT_VERSION__ must be set with single-digit semver"
    major, minor, patch = int(m.group(1)), int(m.group(2)), int(m.group(3))
    assert (major, minor, patch) >= (0, 9, 9), (
        f"v0.9.9: __AGENT_VERSION__ must be 0.9.9 or later, got {major}.{minor}.{patch}"
    )
    for seg in (major, minor, patch):
        assert 0 <= seg <= 9, (
            f"v0.9.9: every semver segment must be single-digit (0-9); got {major}.{minor}.{patch}"
        )


def test_v99_master_failure_recovery_sentinel_present():
    src = _all_source()
    assert "master-failure-mode-from-manifest FIRED" in src, (
        "v0.9.9: success sentinel '[master-failure-mode-from-manifest FIRED]' missing"
    )
    assert "master-failure-mode-from-manifest FALLBACK" in src, (
        "v0.9.9: last-resort sentinel '[master-failure-mode-from-manifest FALLBACK]' missing"
    )
    assert "master-failure-mode-from-manifest ERROR" in src, (
        "v0.9.9: error sentinel '[master-failure-mode-from-manifest ERROR]' missing"
    )


def test_v99_reads_manifest_in_fallback_path():
    """The fallback path must read the orchestrator's manifest before defaulting."""
    src = _all_source()
    assert "getattr(_orch, 'manifest', None)" in src, (
        "v0.9.9: fallback must read _orch.manifest via getattr (defensive)"
    )
    assert "getattr(_manifest, 'requirements', None)" in src, (
        "v0.9.9: fallback must read manifest.requirements via getattr"
    )
    assert "getattr(_manifest, 'overall_mode', '')" in src, (
        "v0.9.9: fallback must read manifest.overall_mode via getattr as a secondary source"
    )


def test_v99_aggregates_via_majority_rule():
    """Aggregation must use Python's max(items, key=count) — deterministic majority."""
    src = _all_source()
    assert "max(_mode_distribution.items(), key=lambda x: x[1])[0]" in src, (
        "v0.9.9: per-requirement mode aggregation must use majority via max(items, key=count)"
    )


def test_v99_classification_constrained_to_known_enum():
    """The recovered classification must be one of the three known enum values
    before being accepted; otherwise fall through to GENERATIVE."""
    src = _all_source()
    assert "{\"SURGICAL\", \"HOLISTIC\", \"GENERATIVE\"}" in src, (
        "v0.9.9: recovered mode must be validated against the SURGICAL/HOLISTIC/GENERATIVE enum"
    )


def test_v99_no_new_regex_or_industry_strings():
    """v0.9.9 fix must NOT introduce regex on vibe text or industry-specific strings.
    
    The fix block is identified by the unique anchor `_recovered_mode = None` 
    (introduced in v0.9.9) and ends at the next `vibe_classification = {` assignment."""
    src = _all_source()
    anchor = "_recovered_mode = None"
    fix_window_start = src.find(anchor)
    assert fix_window_start > 0, "v0.9.9: anchor `_recovered_mode = None` not found"
    fix_window_end = src.find("vibe_contract = compile_vibe_contract", fix_window_start)
    assert fix_window_end > fix_window_start, "v0.9.9: could not locate end of fix block"
    fix_block = src[fix_window_start:fix_window_end]
    forbidden_industry = (
        "airline", "retail", "healthcare", "legal", "banking",
        "manufacturing", "telco", "telecom", "insurance",
    )
    for kw in forbidden_industry:
        assert kw.lower() not in fix_block.lower(), (
            f"v0.9.9: industry-specific string {kw!r} leaked into the fix block"
        )
    forbidden_regex_apis = ("re.compile", "re.search", "re.findall", "re.match")
    for api in forbidden_regex_apis:
        assert api not in fix_block, (
            f"v0.9.9: regex API {api!r} leaked into the fix block (must stay LLM-only/structural)"
        )


def test_v99_preserves_old_authority_sentinel():
    """Backward compatibility: the v0.7.6 USER-AUTHORITY sentinel still fires for
    VOV failure, because downstream contract gates depend on it."""
    src = _all_source()
    assert "vov-master-failure-user-authority FIRED" in src, (
        "v0.9.9: legacy v0.7.6 USER-AUTHORITY sentinel must remain for VOV contract gates"
    )


def test_v99_simulated_recovery_surgical():
    """Simulate the fallback aggregation: 85 surgical reqs should yield SURGICAL."""
    distribution = {"SURGICAL": 85}
    recovered = max(distribution.items(), key=lambda x: x[1])[0]
    assert recovered == "SURGICAL", (
        "v0.9.9: 85 surgical requirements must aggregate to SURGICAL (not GENERATIVE)"
    )
    assert recovered in {"SURGICAL", "HOLISTIC", "GENERATIVE"}


def test_v99_simulated_recovery_mixed_majority():
    """Mixed modes must resolve to the deterministic majority."""
    distribution = {"SURGICAL": 50, "HOLISTIC": 30, "GENERATIVE": 5}
    recovered = max(distribution.items(), key=lambda x: x[1])[0]
    assert recovered == "SURGICAL"
    distribution2 = {"SURGICAL": 10, "HOLISTIC": 40}
    recovered2 = max(distribution2.items(), key=lambda x: x[1])[0]
    assert recovered2 == "HOLISTIC"


def test_v99_simulated_recovery_empty_manifest_falls_to_generative():
    """When manifest has zero modes, the code path must default to GENERATIVE
    (true last-resort behavior)."""
    distribution = {}
    if distribution:
        recovered = max(distribution.items(), key=lambda x: x[1])[0]
    else:
        recovered = None
    final = recovered if recovered in {"SURGICAL", "HOLISTIC", "GENERATIVE"} else "GENERATIVE"
    assert final == "GENERATIVE"


def test_v99_classification_field_uses_recovered_value():
    """The vibe_classification dict assigned by the fallback must reference
    `_final_classification`, NOT a hardcoded 'GENERATIVE' literal."""
    src = _all_source()
    assert "\"classification\": _final_classification" in src, (
        "v0.9.9: vibe_classification['classification'] must use the recovered _final_classification"
    )
