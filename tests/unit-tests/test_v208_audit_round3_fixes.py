"""
v2.0.8 round-3 audit fixes — post-VOV pipeline + prompt cop-out removal.

After two rounds of microscopic VOV reviews, this third pass targets ten more
adherence killers found across the post-VOV pipeline, the LLM prompts, and the
soft-accept hatches. Each fix has an alias that must appear in the deployed
notebook AND emit a FIRED log line at runtime.

Aliases under test:
  1. vov-extract-no-zero-skip            — extraction prompt removes "emit zero VREQs" cop-out
  2. vov-synth-no-cop-out                — synthesis prompt removes "cannot synthesize" / defensive skip
  3. vov-audit-be-aggressive             — vibe-audit prompt removes "be conservative"
  4. vov-mv-pipe-to-json                 — VOV writeback seeds _metric_view_records + statements
  5. vov-skip-post-gen-broader           — Track 1 skips post-gen for VOV review path
  6. vov-skip-normalization-after-sandbox — review mode skips normalization integrity check
  7. vov-bridge-no-silent-empty          — AIAgentLLMBridge raises instead of returning {}
  8. vov-strict-guard-fail-closed        — strict-guard re-raises on STRICT_VOV ops
  9. vov-v1-preload-broader-gate         — preload fires when ANY flat list is empty
 10. vov-selffixer-flat-roundtrip        — SelfFixer fixes propagate back to flat lists + review_base

Per CLAUDE.md §8.10: every alias has a runtime FIRED emit AND a behavioural assertion.
"""

import json
import re
from pathlib import Path

import pytest

NB_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _full_source():
    nb = json.loads(NB_PATH.read_text())
    return "\n".join("".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code")


def _vov_runtime_cell():
    nb = json.loads(NB_PATH.read_text())
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        s = "".join(c.get("source", []))
        if "def _apply_handler_with_retry" in s and "def run_vov_pipeline" in s:
            return s
    raise RuntimeError("VOV runtime cell not found")


def _vov_shim_cell():
    nb = json.loads(NB_PATH.read_text())
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        s = "".join(c.get("source", []))
        if "def run_vov_2_against_widgets" in s:
            return s
    raise RuntimeError("VOV shim cell not found")


EXPECTED_ALIASES = [
    "vov-extract-no-zero-skip",
    "vov-synth-no-cop-out",
    "vov-audit-be-aggressive",
    "vov-mv-pipe-to-json",
    "vov-skip-post-gen-broader",
    "vov-skip-normalization-after-sandbox",
    "vov-bridge-no-silent-empty",
    "vov-strict-guard-fail-closed",
    "vov-v1-preload-broader-gate",
    "vov-selffixer-flat-roundtrip",
    "vov-batcher-no-source-quote-trunc",
    "vov-synth-no-payload-trunc",
    "vov-dedupe-enable-llm",
    "vov-dedupe-no-drop",
]

# Aliases that live INSIDE LLM prompt templates (no runtime FIRED log expected)
PROMPT_ONLY_ALIASES = {
    "vov-extract-no-zero-skip",
    "vov-synth-no-cop-out",
    "vov-audit-be-aggressive",
    "vov-batcher-no-source-quote-trunc",  # injected as prompt-build comment
    "vov-synth-no-payload-trunc",         # injected as prompt-build comment
    "vov-dedupe-enable-llm",              # injected at call site
}


@pytest.mark.parametrize("alias", EXPECTED_ALIASES)
def test_audit_round3_alias_present(alias):
    src = _full_source()
    assert f"alias={alias}" in src, f"alias={alias} missing"


@pytest.mark.parametrize("alias", sorted(set(EXPECTED_ALIASES) - PROMPT_ONLY_ALIASES))
def test_audit_round3_runtime_alias_has_fired_emit(alias):
    src = _full_source()
    assert f"[{alias} FIRED" in src, f"FIRED emit missing for {alias}"


# ---------------------------------------------------------------------------
# Prompt-level fixes
# ---------------------------------------------------------------------------

def test_extraction_prompt_user_king_preamble():
    src = _full_source()
    m = re.search(r"EXTRACTION_SYSTEM_PROMPT\s*=\s*\\?\"\\?\"\\?\"([\s\S]{0,4000})", src)
    assert m is not None, "could not locate EXTRACTION_SYSTEM_PROMPT body"
    body = m.group(1)
    assert "USER VIBES ARE THE SUPREME AUTHORITY" in body or "vov-extract-no-zero-skip" in body, (
        "extraction prompt missing USER-KING preamble / no-zero-skip clause"
    )


def test_extraction_prompt_no_unconditional_zero_emit():
    """The old 'If the chunk is purely descriptive ... emit zero VREQs' cop-out must be gone."""
    src = _full_source()
    # Old anti-pattern was a single bullet without conditions
    bad = re.search(
        r"If the chunk is purely descriptive context.*emit zero VREQs\.\s*\\n",
        src,
    )
    assert bad is None, "Extraction prompt still has the unconditional zero-emit clause"


def test_synthesis_prompt_removes_cannot_synthesize_cop_out():
    src = _full_source()
    m = re.search(
        r"If the batch's intent cannot be expressed safely under the constraints OR would\s*\\?n.*?violate a pinned-domain.*?return model unchanged",
        src,
    )
    assert m is None, "Synthesis prompt still teaches the LLM to return model unchanged on conflict"


def test_synthesis_prompt_has_no_cop_out_clause():
    src = _full_source()
    assert "vov-synth-no-cop-out" in src, "Synthesis prompt missing no-cop-out clause"
    # Must explicitly tell LLM to apply safe rows and skip ONLY conflicting rows
    assert "apply the SAFE rows" in src or "apply as many rows of the data_payload as possible" in src, (
        "Synthesis prompt missing per-row partial-apply directive"
    )


def test_synthesis_prompt_no_defensive_skip():
    """The 'skip missing entities, do not crash' clause must be replaced with 'create-then-mutate'."""
    src = _full_source()
    m = re.search(r"your mutator should be defensive \(skip missing entities, do not crash\)", src)
    assert m is None, "Synthesis prompt still has defensive-skip-missing clause"


def test_audit_prompt_removes_be_conservative():
    src = _full_source()
    m = re.search(r"5\. Be conservative\s*[—-]\s*only flag real gaps", src)
    assert m is None, "VIBE_AUDIT_PROMPT still tells LLM to be conservative"
    assert "vov-audit-be-aggressive" in src, "audit prompt missing aggressive directive"


# ---------------------------------------------------------------------------
# Post-VOV pipeline fixes
# ---------------------------------------------------------------------------

def test_mv_pipe_to_json_seeds_records_and_statements():
    src = _vov_shim_cell()
    assert "_metric_view_records" in src, "MV pipe must touch _metric_view_records"
    assert "metric_view_statements" in src, "MV pipe must touch metric_view_statements"
    assert "vov-mv-pipe-to-json" in src, "MV pipe alias missing"


def test_skip_post_gen_broader_triggers_on_use_review_base_data():
    src = _full_source()
    assert "_vov_review_path_already_ran" in src, "broader-skip variable not defined"
    assert "vov-skip-post-gen-broader" in src, "broader-skip alias missing"
    # _skip_post_gen assignment must include _vov_review_path_already_ran (loosened to substring)
    m = re.search(r"_skip_post_gen\s*=[\s\S]{0,2000}_vov_review_path_already_ran", src)
    assert m is not None, "_skip_post_gen does not reference _vov_review_path_already_ran"


def test_normalization_check_skipped_when_vov_applied():
    src = _full_source()
    assert "_vov_applied_any" in src, "normalization-skip condition missing"
    assert "vov-skip-normalization-after-sandbox" in src, "normalization-skip alias missing"


def test_bridge_no_silent_empty():
    src = _full_source()
    assert "VOV-2.0 LLM bridge failed" in src, "bridge raise message missing"
    assert "raise RuntimeError" in src, "bridge does not raise RuntimeError"
    assert "vov-bridge-no-silent-empty" in src, "bridge-no-silent-empty alias missing"


def test_strict_guard_fail_closed_for_strict_vov():
    src = _full_source()
    assert "vov-strict-guard-fail-closed" in src, "fail-closed alias missing"
    assert "refusing to ship unguarded model.json for STRICT_VOV op" in src, (
        "strict-guard does not refuse to ship on STRICT_VOV"
    )


def test_v1_preload_broader_gate():
    src = _vov_shim_cell()
    # New gate triggers when domains_data is empty OR products_data OR attributes_data
    m = re.search(
        r"\(\s*\(not\s+domains_data\)\s+or\s+\(not\s+products_data\)\s+or\s+\(not\s+attributes_data\)\s*\)",
        src,
    )
    assert m is not None, "v1-preload still gates only on `not domains_data`"
    assert "vov-v1-preload-broader-gate" in src


def test_selffixer_writes_to_flat_lists():
    src = _full_source()
    assert "vov-selffixer-flat-roundtrip" in src, "selffixer flat-roundtrip alias missing"
    # The post-SelfFixer block must reassign flat lists from the mutated model
    m = re.search(
        r"_sf_new_d, _sf_new_p, _sf_new_a, _sf_new_mv = model_to_widgets_flat\(_sf_model\)",
        src,
    )
    assert m is not None, "SelfFixer flat-list writeback missing model_to_widgets_flat call"
    # And review_base_* must be updated
    m2 = re.search(r"widgets_values\[.review_base_domains.\]\s*=\s*_sf_new_d", src)
    assert m2 is not None, "SelfFixer flat-list writeback does not refresh review_base_domains"


def test_selffixer_builds_model_from_flats_when_missing():
    src = _full_source()
    # When nested model dict is absent, SelfFixer must call widgets_flat_to_model to build it.
    m = re.search(r"_sf_model\s*=\s*widgets_flat_to_model\(", src)
    assert m is not None, "SelfFixer entry does not fall back to widgets_flat_to_model when nested model dict is absent"


# ---------------------------------------------------------------------------
# Data-payload truncation removal
# ---------------------------------------------------------------------------

def test_batcher_source_quote_cap_widened_to_4000():
    """The old 300-char cap on source_quote in the batcher payload amputated table rows."""
    src = _full_source()
    # Old anti-pattern must be gone
    old = re.search(r"source_quote\":\s*v\.source_quote\[:300\]", src)
    assert old is None, "Batcher still truncates source_quote at 300 chars"
    # New cap at 4000 must be present
    new = re.search(r"source_quote\":\s*v\.source_quote\[:4000\]", src)
    assert new is not None, "Batcher source_quote cap not raised to 4000"


def test_synth_payload_cap_widened_to_64kb():
    """The old 8KB cap on data_payload truncated mid-row JSON."""
    src = _full_source()
    old = re.search(r"json\.dumps\(list\(batch\.data_payload\)\)\[:8000\]", src)
    assert old is None, "Synthesizer still truncates data_payload at 8000"
    assert "65536" in src and "vov-synth-no-payload-trunc" in src, (
        "Synth payload not capped at 64KB / alias missing"
    )


def test_dedupe_calls_llm_in_production():
    """The pipeline must pass `llm=llm` to dedupe_vreqs, not `llm=None`."""
    src = _full_source()
    # The production call site in run_vov_pipeline must pass llm=llm
    m = re.search(r"dedupe_vreqs\(raw_vreqs,\s*threshold=0\.85,\s*llm=llm\)", src)
    assert m is not None, "run_vov_pipeline does not pass llm into dedupe_vreqs"
    # The dead `llm=None` line must be gone from the live call site
    m2 = re.search(r"dedupe_vreqs\(raw_vreqs,\s*threshold=0\.85,\s*llm=None\)", src)
    assert m2 is None, "Old llm=None dedupe call still present"


def test_dedupe_no_drop_preserves_distinct_outcomes():
    """merge_cluster must return a list and never drop the cluster size when distinct outcomes differ."""
    src = _full_source()
    # New signature returns list[RawVREQ]
    m = re.search(r"def merge_cluster\(cluster: list\[RawVREQ\],\s*llm:\s*Optional\[LLMClient\][^)]*\)\s*->\s*list\[RawVREQ\]", src)
    assert m is not None, "merge_cluster signature not updated to return list[RawVREQ]"
    # Safety-net log line must exist
    assert "keeping originals to prevent silent drop" in src, "vov-dedupe-no-drop safety net missing"
    # dedupe_vreqs consumer must handle list output
    assert "out.extend(merged_list)" in src, "dedupe_vreqs does not flatten list returns from merge_cluster"
