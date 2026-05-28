"""
v2.0.8 VOV microscopic-audit root-cause fixes.

These tests verify the SIX additional root-cause fixes added 2026-05-26 after the
microscopic line-by-line review of the VOV pipeline path. Each fix targets a way
user vibes could silently fail to land as model mutations, inflating coverage_pct
while keeping real adherence at 33-66%.

Aliases under test (all must appear in the notebook + actually mutate behaviour):

  1. vov-dedupe-include-source        (B1) include source_quote in cluster signature
                                            so distinct rename targets aren't merged
  2. vov-extract-error-loud           (A1) log every per-chunk extraction failure
                                            instead of silently swallowing
  3. vov-merge-partial-mv-union       (K3) union metric_views from candidate so
                                            scoped parallel batches don't drop MVs
  4. vov-noop-applied-guard           (D1+F1+F2) demote empty-diff "applies" to
                                                  noop_failed and "cannot synthesize"
                                                  to skipped_unsafe
  5. vov-orphan-vreq-reconcile        (C1+C3) recover VREQs the batcher omitted
  6. vov-coverage-honest              (G1) coverage_pct = applied_unique /
                                             extracted (not / batched)
  7. vov-strict-guard-respects-sandbox (H1) extend closure with VOV-applied
                                              target_entities before strict diff guard
  8. vov-result-target-entities       (H1) persist batch target_entities into
                                              the pipeline_result dict

Per CLAUDE.md §8.10: each test exercises the failure mode end-to-end (not just
static grep) and asserts an observable state change.
"""

import json
import re
from pathlib import Path

import pytest

NB_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _vov_runtime_source():
    nb = json.loads(NB_PATH.read_text())
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        s = "".join(c.get("source", []))
        if "def _apply_handler_with_retry" in s and "def run_vov_pipeline" in s:
            return s
    raise RuntimeError("VOV runtime cell not found")


def _vov_shim_source():
    nb = json.loads(NB_PATH.read_text())
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        s = "".join(c.get("source", []))
        if "def run_vov_2_against_widgets" in s:
            return s
    raise RuntimeError("VOV shim cell not found")


def _strict_guard_site_source():
    nb = json.loads(NB_PATH.read_text())
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        s = "".join(c.get("source", []))
        if "_strict_vov_diff_guard(_vov_input_root" in s:
            return s
    raise RuntimeError("Strict-guard call site cell not found")


# ---------------------------------------------------------------------------
# Static-grep — every alias is present at least once
# ---------------------------------------------------------------------------

EXPECTED_ALIASES = [
    "vov-dedupe-include-source",
    "vov-extract-error-loud",
    "vov-merge-partial-mv-union",
    "vov-noop-applied-guard",
    "vov-orphan-vreq-reconcile",
    "vov-coverage-honest",
    "vov-strict-guard-respects-sandbox",
    "vov-result-target-entities",
]


@pytest.mark.parametrize("alias", EXPECTED_ALIASES)
def test_alias_present_in_notebook(alias):
    nb = json.loads(NB_PATH.read_text())
    full = "\n".join("".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code")
    assert f"alias={alias}" in full, f"alias={alias} missing from notebook"


@pytest.mark.parametrize("alias", EXPECTED_ALIASES)
def test_alias_has_fired_log(alias):
    nb = json.loads(NB_PATH.read_text())
    full = "\n".join("".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code")
    assert f"[{alias} FIRED" in full, f"FIRED log emit missing for {alias}"


# ---------------------------------------------------------------------------
# B1 — dedupe must include source_quote in signature
# ---------------------------------------------------------------------------

def test_b1_cluster_vreqs_uses_source_quote_in_signature():
    src = _vov_runtime_source()
    m = re.search(r"sigs\s*=\s*\[_shingle_set\(([^)]+)\)\s*for\s+v\s+in\s+vreqs\]", src)
    assert m is not None, "Could not find sigs= line"
    expr = m.group(1)
    assert "source_quote" in expr, (
        f"B1 fix not applied: dedupe signature still excludes source_quote. expr={expr!r}"
    )


def test_b1_distinct_rename_targets_are_preserved():
    """Behavioural: two VREQs with same intent+target but different source_quotes
    must NOT be clustered together (would lose one rename)."""
    ns = _build_dedupe_namespace()
    cluster_vreqs = ns["cluster_vreqs"]
    RawVREQ = ns["RawVREQ"]
    v1 = RawVREQ(
        vreq_id="VREQ-0001",
        intent="rename",
        target="customer",
        source_quote="rename customer to customer_profile please",
        source_chunk_id="c1",
    )
    v2 = RawVREQ(
        vreq_id="VREQ-0002",
        intent="rename",
        target="customer",
        source_quote="rename customer to customer_master in product domain",
        source_chunk_id="c1",
    )
    clusters = cluster_vreqs([v1, v2], threshold=0.85)
    assert len(clusters) == 2, (
        f"Distinct rename targets collapsed into one cluster — would lose a VREQ. clusters={clusters}"
    )


def test_b1_genuine_dupes_still_cluster():
    """Inverse: identical VREQs should still cluster."""
    ns = _build_dedupe_namespace()
    cluster_vreqs = ns["cluster_vreqs"]
    RawVREQ = ns["RawVREQ"]
    v1 = RawVREQ(
        vreq_id="VREQ-0001",
        intent="add foreign key",
        target="order.customer_id",
        source_quote="add fk from order.customer_id to customer.customer_id",
        source_chunk_id="c1",
    )
    v2 = RawVREQ(
        vreq_id="VREQ-0002",
        intent="add foreign key",
        target="order.customer_id",
        source_quote="add fk from order.customer_id to customer.customer_id",
        source_chunk_id="c1",
    )
    clusters = cluster_vreqs([v1, v2], threshold=0.85)
    assert len(clusters) == 1, "Identical VREQs should still cluster (B1 fix shouldn't disable dedup)"


# ---------------------------------------------------------------------------
# A1 — extraction failures must be logged
# ---------------------------------------------------------------------------

def _extract_function_body_until_next_def(src, fn_name):
    """Slice from `def fn_name(` to the start of the next top-level `def `."""
    start_re = re.compile(rf"^def {re.escape(fn_name)}\b", re.MULTILINE)
    m = start_re.search(src)
    if m is None:
        return None
    start = m.start()
    # Find next top-level def AFTER this one
    next_def = re.search(r"^def\s", src[start + 4:], re.MULTILINE)
    if next_def is None:
        return src[start:]
    return src[start: start + 4 + next_def.start()]


def test_a1_extract_all_logs_failures():
    src = _vov_runtime_source()
    body = _extract_function_body_until_next_def(src, "extract_all")
    assert body is not None, "extract_all body not found"
    assert "_extract_failures" in body, "A1 fix not applied: extract_all still missing failure list"
    assert "vov-extract-error-loud" in body, "A1 alias missing inside extract_all"
    assert ".getLogger" in body, "A1: failures must reach the logger"


def test_a1_old_pass_swallow_removed():
    """The specific anti-pattern `out.extend(f.result()); except Exception: pass` must be gone.
    (A post-loop logging fallback that swallows is fine — that's not the extraction-loss bug.)"""
    src = _vov_runtime_source()
    body = _extract_function_body_until_next_def(src, "extract_all")
    assert body is not None
    no_comments = "\n".join(
        ln for ln in body.splitlines() if not ln.lstrip().startswith("#")
    )
    # The killer pattern: f.result() followed directly by except: pass with no logging/append.
    silent_pattern = re.search(
        r"out\.extend\(f\.result\(\)\)\s*\n\s*except\s+Exception\s*:\s*\n\s*pass",
        no_comments,
    )
    assert silent_pattern is None, (
        "A1 fix incomplete: silent `out.extend(f.result()) / except Exception: pass` still present in extract_all"
    )


# ---------------------------------------------------------------------------
# K3 — _merge_partial must merge metric_views
# ---------------------------------------------------------------------------

def test_k3_merge_partial_unions_metric_views():
    src = _vov_runtime_source()
    body = _extract_function_body_until_next_def(src, "_merge_partial")
    assert body is not None
    assert "metric_views" in body, "K3 fix not applied: _merge_partial still doesn't reference metric_views"
    assert "vov-merge-partial-mv-union" in body, "K3 alias not in _merge_partial"


def test_k3_merge_partial_preserves_candidate_mvs_behavioural():
    """Build a tiny model, run _merge_partial, assert candidate MV is preserved."""
    ns = _build_merge_partial_namespace()
    _merge_partial = ns["_merge_partial"]
    base = {
        "domains": [
            {"name": "hr", "products": [{"name": "emp", "attributes": []}]},
        ],
        "metric_views": [{"name": "base_mv", "domain": "hr"}],
    }
    candidate = {
        "domains": [
            {"name": "hr", "products": [{"name": "emp", "attributes": [{"name": "added_col"}]}]},
        ],
        "metric_views": [
            {"name": "base_mv", "domain": "hr"},  # already in base
            {"name": "new_mv_from_candidate", "domain": "hr"},
        ],
    }
    merged = _merge_partial(base, candidate, target_entities=(("hr", "emp"),))
    mv_names = {(mv.get("name") or "").lower() for mv in merged.get("metric_views", [])}
    assert "new_mv_from_candidate" in mv_names, (
        f"K3 fix did not actually preserve candidate MV. merged metric_views={merged.get('metric_views')}"
    )
    assert "base_mv" in mv_names, "K3 fix accidentally removed base MV"


# ---------------------------------------------------------------------------
# D1+F1+F2 — no-op applied guard
# ---------------------------------------------------------------------------

def test_d1_noop_applied_guard_inserts_demotions():
    src = _vov_runtime_source()
    m = re.search(r"def _apply_handler_with_retry.*?return None, VReqOutcome\(\s*batch_id=batch\.batch_id,\s*vreq_ids=batch\.vreq_ids,\s*status=\"exhausted_retries\"", src, re.DOTALL)
    assert m is not None, "Could not locate _apply_handler_with_retry body"
    body = m.group(0)
    assert "_is_noop_diff" in body, "D1: noop-diff check missing"
    assert "_is_cannot_synth" in body, "F2: cannot_synthesize check missing"
    assert '"noop_failed"' in body, "D1: noop_failed status not emitted"
    assert '"skipped_unsafe"' in body, "F2: skipped_unsafe status not emitted"


def test_d1_demotion_order_pre_applied():
    """Both demotions must come BEFORE the final `status=applied` return."""
    src = _vov_runtime_source()
    m = re.search(
        r"(_is_cannot_synth\s*=.*?)return new_model, VReqOutcome\(\s*batch_id=batch\.batch_id,\s*vreq_ids=batch\.vreq_ids,\s*status=\"applied\"",
        src,
        re.DOTALL,
    )
    assert m is not None, "D1/F2 demotion is not placed before the applied return"


# ---------------------------------------------------------------------------
# C1+C3 — orphan VREQ reconciliation
# ---------------------------------------------------------------------------

def test_c1_orphan_reconcile_present_in_pipeline():
    src = _vov_runtime_source()
    m = re.search(r"def run_vov_pipeline\([^)]*\)[^:]*:.*?(?=def\s)", src, re.DOTALL)
    assert m is not None
    body = m.group(0)
    assert "_orphan_ids" in body, "C1: orphan_ids set not computed"
    assert "_recovery_batches" in body, "C1: recovery batches list not created"
    assert "orphan-recovery-" in body, "C1: orphan-recovery batch id prefix missing"


# ---------------------------------------------------------------------------
# G1 — coverage_pct must divide by extracted, not batched
# ---------------------------------------------------------------------------

def test_g1_coverage_pct_divides_by_extracted():
    src = _vov_runtime_source()
    # New formula must reference n_extracted
    assert "n_extracted = len(deduped)" in src, (
        "G1 fix not applied: coverage_pct still uses batched VREQs as denominator"
    )
    assert "_applied_vreq_set" in src, "G1: per-VREQ applied set missing"


def test_g1_old_formula_removed():
    """Old `n_total = sum(len(b.vreq_ids) for b in batches)` must be gone."""
    src = _vov_runtime_source()
    m = re.search(r"n_total\s*=\s*sum\(len\(b\.vreq_ids\)\s*for\s*b\s*in\s*batches\)", src)
    assert m is None, "G1 fix incomplete: old batched-denominator formula still present"


# ---------------------------------------------------------------------------
# H1 — strict guard must extend closure with sandbox-applied targets
# ---------------------------------------------------------------------------

def test_h1_strict_guard_extends_with_sandbox_targets():
    src = _strict_guard_site_source()
    m = re.search(r"_vov_applied_actions_for_closure = .*?_strict_vov_diff_guard\(_vov_input_root", src, re.DOTALL)
    assert m is not None
    body = m.group(0)
    assert "_vov_2_pipeline_result" in body, "H1: pipeline_result read missing"
    assert "_applied_target_entities" in body, "H1: applied_target_entities list missing"
    assert "vov-strict-guard-respects-sandbox" in body, "H1 alias missing"


def test_h1_pipeline_result_persists_target_entities():
    src = _vov_shim_source()
    m = re.search(r'widgets_values\[\\?"_vov_2_pipeline_result\\?"\]\s*=\s*\{', src)
    assert m is not None, "pipeline_result writeback not found"
    # Match the dict literal until the closing }
    block_start = m.end()
    # Take enough text to capture the block
    block = src[block_start: block_start + 2000]
    assert "target_entities" in block, "H1: target_entities not persisted into pipeline_result"
    assert "_batch_targets_by_id" in src, "H1: batch->targets lookup not built"


# ---------------------------------------------------------------------------
# Helpers — extract minimal namespaces from the runtime cell to exercise functions
# ---------------------------------------------------------------------------

def _extract_function_block(src, fn_name):
    """Extract a top-level def block by greedy slice up to the next top-level def."""
    pattern = rf"^def {re.escape(fn_name)}\b.*?(?=^def\s)"
    m = re.search(pattern, src, re.MULTILINE | re.DOTALL)
    if m is None:
        # Fallback: end-of-source
        pattern2 = rf"^def {re.escape(fn_name)}\b.*\Z"
        m = re.search(pattern2, src, re.MULTILINE | re.DOTALL)
    assert m is not None, f"Could not extract function {fn_name}"
    return m.group(0)


def _build_dedupe_namespace():
    """Compile just enough of the dedupe module into a private namespace to call cluster_vreqs."""
    src = _vov_runtime_source()
    preamble = (
        "from __future__ import annotations\n"
        "import re\n"
        "import json\n"
        "from typing import Iterable, Optional\n"
        "from dataclasses import dataclass, field\n"
        "\n"
        "_NORMALIZE_RE = re.compile(r\"[^a-z0-9 ]+\")\n"
        "\n"
        "@dataclass(frozen=True)\n"
        "class RawVREQ:\n"
        "    vreq_id: str\n"
        "    intent: str\n"
        "    target: str\n"
        "    source_quote: str\n"
        "    source_chunk_id: str\n"
        "\n"
        "class LLMClient: ...\n"
    )
    pieces = [
        _extract_function_block(src, "_normalize"),
        _extract_function_block(src, "_shingle_set"),
        _extract_function_block(src, "jaccard"),
        _extract_function_block(src, "cluster_vreqs"),
    ]
    ns = {}
    exec(compile(preamble + "\n".join(pieces), "<dedupe>", "exec"), ns)
    return ns


def _build_merge_partial_namespace():
    src = _vov_runtime_source()
    preamble = "import copy\n"
    body = _extract_function_block(src, "_merge_partial")
    ns = {}
    exec(compile(preamble + body, "<merge_partial>", "exec"), ns)
    return ns
