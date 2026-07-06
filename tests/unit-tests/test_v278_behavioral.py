"""Behavioral tests for v2.7.8 (generic sizing recovery + de-overfit).

v2.7.7 shipped a metric-view-ONLY focused fallback whose prompt baked in run-specific KPI
names. That was overfitting: a user can fix the count of ANY structural entity (domains,
products/tables, products-per-domain, metric views), and the fix must NOT embed any single
run's data.

v2.7.8:
  1. ONE generic SIZING_DIRECTIVE_RECOVERY_PROMPT recovers a dropped exact count for ANY
     entity type and gap-fills only the null sizing fields (never overrides the broad parse).
  2. All run-specific examples removed from the recovery prompt + VIBE_PARSE_PROMPT.
  3. deterministic_pre_group no longer hardcodes run-specific tag keys or "exactly 3" literals.
"""
import json
import re
from pathlib import Path

NB_PATH = Path(__file__).parent.parent.parent / "agent" / "dbx_vibe_modelling_agent.ipynb"

# Tokens that would prove the codebase is overfit to one specific run/customer.
RUN_SPECIFIC_TOKENS = ["Vacancy Rate", "Retirement Eligibility", "Total Positions and Active Employees"]


def _nb():
    return json.loads(NB_PATH.read_text())


def _nb_src():
    cells = _nb().get("cells", [])
    return "\n".join("".join(c.get("source", [])) for c in cells if c.get("cell_type") == "code")


# ---------- version + alias ----------

def test_agent_version_278():
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', _nb_src())
    assert m and tuple(int(x) for x in m.group(1).split(".")) >= (2, 7, 8), m.group(1) if m else "missing"


def test_generic_recovery_replaces_mv_only_fallback():
    src = _nb_src()
    assert 'PROMPT_TEMPLATES["SIZING_DIRECTIVE_RECOVERY_PROMPT"]' in src
    assert "_SIZING_RECOVERY_SCHEMA = {" in src
    assert "[sizing-directive-focused-recovery FIRED v2.7.8]" in src
    # the MV-only construct must be fully gone (no parallel sub-system)
    assert "MV_DIRECTIVE_EXTRACT_PROMPT" not in src, "old MV-only prompt must be removed (DRY)"
    assert "mv-directive-focused-fallback" not in src, "old MV-only alias must be removed"


# ---------- de-overfit (the serious one) ----------

def test_no_run_specific_names_in_recovery_or_parse_prompts():
    """The recovery prompt and the VIBE_PARSE sizing example must contain NO run-specific
    KPI names. This is the explicit user directive: never embed one run's data in the agent."""
    src = _nb_src()
    rec_start = src.find('PROMPT_TEMPLATES["SIZING_DIRECTIVE_RECOVERY_PROMPT"]')
    rec_block = src[rec_start: rec_start + 2000]
    for tok in RUN_SPECIFIC_TOKENS:
        assert tok not in rec_block, f"recovery prompt is overfit: contains '{tok}'"
    # The VIBE_PARSE explicit_metric_views guidance must also be generic.
    ev = src.find("explicit_metric_views`: array of the exact metric-view")
    if ev > 0:
        for tok in RUN_SPECIFIC_TOKENS:
            assert tok not in src[ev: ev + 600], f"VIBE_PARSE example is overfit: contains '{tok}'"


def test_pregroup_has_no_hardcoded_run_specific_literals():
    """deterministic_pre_group must bucket intents generically, not by a specific run's tag
    keys or a specific count literal."""
    src = _nb_src()
    start = src.find("def deterministic_pre_group(")
    block = src[start: start + 1400]
    assert '"gov_transport_source_table" in text' not in block, "hardcoded run-specific tag key must be gone"
    assert '"gov_transport_business_glossary_term" in text' not in block
    assert '"exactly 3 metric" in text' not in block, "hardcoded count literal must be gone"
    assert "pregroup-generic-no-run-overfit" in block, "generic-intent sentinel missing"


# ---------- the recovery is GENERIC across entity types (not MV-only) ----------

def _recovery_block():
    """Isolate the generic-recovery try-block so assertions don't bleed into unrelated code."""
    src = _nb_src()
    start = src.find('_sz_prompt = PROMPT_TEMPLATES["SIZING_DIRECTIVE_RECOVERY_PROMPT"]')
    end = src.find("[sizing-directive-focused-recovery ERROR]")
    assert start > 0 and end > start
    return src[start:end]


def test_recovery_maps_every_entity_type_to_sizing_fields():
    """The fallback must gap-fill domains / products / products-per-domain / metric views --
    proving it is not limited to metric views."""
    block = _recovery_block()
    assert '_sz_fill_exact("domains_exact", "max_domains", "min_domains")' in block
    assert '_sz_fill_exact("products_exact", "max_total_products", "min_total_products")' in block
    assert '_sz_fill_exact("products_per_domain_exact", "max_products_per_domain", "min_products_per_domain")' in block
    assert '_sz_fill_exact("metric_views_exact", "max_metric_views", "min_metric_views")' in block


def test_recovery_fires_on_any_null_count_and_gapfills_only():
    src = _nb_src()
    # fires when ANY exact-count field is null (generic trigger, not MV-specific)
    assert '_sz_count_fields = ("max_domains", "max_total_products", "max_products_per_domain", "max_metric_views")' in src
    assert "any(_merged_sd.get(_f) is None for _f in _sz_count_fields)" in src
    block = _recovery_block()
    # gap-fill only: each fill is guarded by `_merged_sd.get(_max_key) is None`
    assert "_merged_sd.get(_max_key) is None" in block, "recovery must never override the broad parse"
    assert "_call_ai_query" in block and "re.search" not in block, "must be LLM, no regex on the vibe"


# ---------- behavioral: enforcement gate consumes the recovered field ----------

def _extract_gate_fn():
    src = _nb_src()
    start = src.find("def _vibe_exact_metric_view_directive(")
    nxt = src.find("\ndef ", start + 1)
    ns = {}
    exec(compile(src[start:nxt], "<gate>", "exec"), ns)
    return ns["_vibe_exact_metric_view_directive"]


def test_gate_none_then_exact_after_recovery():
    gate = _extract_gate_fn()
    pre = {"vibe_classification": {"sizing_directives": {"max_metric_views": None, "explicit_metric_views": []}}}
    assert gate(pre) == (None, [])
    post = {"vibe_classification": {"sizing_directives": {"max_metric_views": 3, "min_metric_views": 3,
            "explicit_metric_views": ["A", "B", "C"]}}}
    cnt, names = gate(post)
    assert cnt == 3 and names == ["A", "B", "C"]


# ---------- behavioral: DDL chunker (reverse-engineer source-tag coverage) ----------

def _extract_chunker():
    import re as _re_mod
    src = _nb_src()
    start = src.find("def _chunk_ddl_for_reverse_engineer(")
    nxt = src.find("\ndef ", start + 1)
    ns = {"re": _re_mod}
    exec(compile(src[start:nxt], "<chunker>", "exec"), ns)
    return ns["_chunk_ddl_for_reverse_engineer"]


def test_handler_chunks_full_ddl_not_truncated():
    src = _nb_src()
    assert "ddl_content=_re_ddl[:8000]" not in src
    assert "_chunk_ddl_for_reverse_engineer(_re_ddl" in src


def test_chunker_preserves_all_tables():
    chunk = _extract_chunker()
    ddl = "\n".join(f"t_{i}(id BIGINT, name STRING, dep_id BIGINT->hr.dep.id)" for i in range(56))
    chunks = chunk(ddl, max_chars=600)
    assert len(chunks) > 1 and all(len(c) <= 600 for c in chunks)
    lines = [l for c in chunks for l in c.split("\n") if l.strip()]
    assert len(lines) == 56
    assert all(l.count("(") == 1 and l.rstrip().endswith(")") for l in lines)


def test_chunker_small_and_empty():
    chunk = _extract_chunker()
    assert chunk("only(id INT)") == ["only(id INT)"]
    assert chunk("") == [] and chunk(None) == []
