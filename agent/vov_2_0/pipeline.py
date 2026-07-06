from __future__ import annotations

import copy
import json
from concurrent.futures import ProcessPoolExecutor, ThreadPoolExecutor
from dataclasses import asdict
from typing import Iterable, Optional

from .batcher import batch_vreqs
from .chunker import chunk_vibe
from .deduper import dedupe_vreqs
from .extractor import extract_all
from .invariants import (
    InvariantSnapshot,
    capture_invariants,
    diff_models_summary,
    diff_within_summary_scope,
    verify_invariants,
)
from .llm import LLMClient
from .outline import build_outline
from .planner import plan_waves
from .sandbox import execute_in_sandbox
from .synthesizer import synthesize_batch_handlers, synthesize_handler
from .types import Batch, Handler, PipelineResult, RawVREQ, VReqOutcome


def _apply_handler_with_retry(
    handler: Handler,
    batch: Batch,
    model: dict,
    invariants: InvariantSnapshot,
    llm: LLMClient,
    max_retries: int = 3,
) -> tuple[Optional[dict], VReqOutcome]:
    failure_traces: list[str] = []
    current_handler = handler

    for attempt in range(1, max_retries + 1):
        result = execute_in_sandbox(
            current_handler.mutator_src,
            current_handler.verifier_src,
            model,
            data=list(batch.data_payload),
        )

        if not result.ok:
            trace = f"attempt {attempt}: sandbox rejected ({result.error}); stderr={result.stderr[:500]}"
            failure_traces.append(trace)
            if attempt < max_retries:
                current_handler = synthesize_handler(batch, llm, prior_failure_trace="\n".join(failure_traces))
                continue
            return None, VReqOutcome(
                batch_id=batch.batch_id,
                vreq_ids=batch.vreq_ids,
                status="rejected_unsafe",
                diagnostic=trace,
                attempts=attempt,
            )

        new_model = result.new_model

        ok_inv, inv_diag = verify_invariants(new_model, invariants)
        if not ok_inv:
            trace = f"attempt {attempt}: invariants violated: {inv_diag}"
            failure_traces.append(trace)
            if attempt < max_retries:
                current_handler = synthesize_handler(batch, llm, prior_failure_trace="\n".join(failure_traces))
                continue
            return None, VReqOutcome(
                batch_id=batch.batch_id,
                vreq_ids=batch.vreq_ids,
                status="invariant_violation",
                diagnostic=inv_diag,
                attempts=attempt,
            )

        diff = diff_models_summary(model, new_model)
        ok_scope, scope_diag = diff_within_summary_scope(diff, current_handler.expected_changes_summary)
        if not ok_scope:
            trace = f"attempt {attempt}: scope mismatch: {scope_diag}"
            failure_traces.append(trace)
            if attempt < max_retries:
                current_handler = synthesize_handler(batch, llm, prior_failure_trace="\n".join(failure_traces))
                continue
            return None, VReqOutcome(
                batch_id=batch.batch_id,
                vreq_ids=batch.vreq_ids,
                status="scope_mismatch",
                diagnostic=scope_diag,
                attempts=attempt,
            )

        if not result.verifier_ok:
            trace = f"attempt {attempt}: verifier failed: {result.verifier_diag}"
            failure_traces.append(trace)
            if attempt < max_retries:
                current_handler = synthesize_handler(batch, llm, prior_failure_trace="\n".join(failure_traces))
                continue
            return new_model, VReqOutcome(
                batch_id=batch.batch_id,
                vreq_ids=batch.vreq_ids,
                status="verifier_failed",
                diagnostic=result.verifier_diag,
                attempts=attempt,
            )

        return new_model, VReqOutcome(
            batch_id=batch.batch_id,
            vreq_ids=batch.vreq_ids,
            status="applied",
            diagnostic="",
            attempts=attempt,
        )

    return None, VReqOutcome(
        batch_id=batch.batch_id,
        vreq_ids=batch.vreq_ids,
        status="exhausted_retries",
        diagnostic="\n".join(failure_traces),
        attempts=max_retries,
    )


def run_vov_pipeline(
    vibe_text: str,
    initial_model: dict,
    llm: LLMClient,
    user_pinned_domains: Iterable[str],
    user_pinned_products: Iterable[tuple[str, str]],
    parallel: bool = True,
) -> PipelineResult:
    outline = build_outline(vibe_text, llm)
    chunks = chunk_vibe(vibe_text, outline=outline)
    raw_vreqs = extract_all(chunks, outline, llm, parallel=parallel)
    deduped = dedupe_vreqs(raw_vreqs, threshold=0.85, llm=None)
    batches = batch_vreqs(deduped, llm=llm)

    handler_by_batch = {h.batch_id: h for h in synthesize_batch_handlers(batches, llm, parallel=parallel)}
    batch_by_id = {b.batch_id: b for b in batches}

    invariants = capture_invariants(initial_model, user_pinned_domains, user_pinned_products)

    handlers_in_order = [handler_by_batch[b.batch_id] for b in batches if b.batch_id in handler_by_batch]
    waves = plan_waves(handlers_in_order)

    model = copy.deepcopy(initial_model)
    outcomes: list[VReqOutcome] = []
    rejected: list[tuple[str, str]] = []

    for wave in waves:
        if parallel and len(wave) > 1:
            with ThreadPoolExecutor(max_workers=min(8, len(wave))) as ex:
                futs = []
                for h in wave:
                    futs.append((h, ex.submit(
                        _apply_handler_with_retry,
                        h,
                        batch_by_id[h.batch_id],
                        copy.deepcopy(model),
                        invariants,
                        llm,
                    )))
                for h, f in futs:
                    new_m, outcome = f.result()
                    outcomes.append(outcome)
                    if new_m is not None and outcome.status == "applied":
                        model = _merge_partial(model, new_m, h.target_entities)
                    elif outcome.status != "applied":
                        rejected.append((h.batch_id, outcome.diagnostic[:200]))
        else:
            for h in wave:
                new_m, outcome = _apply_handler_with_retry(
                    h, batch_by_id[h.batch_id], model, invariants, llm,
                )
                outcomes.append(outcome)
                if new_m is not None and outcome.status == "applied":
                    model = new_m
                elif outcome.status != "applied":
                    rejected.append((h.batch_id, outcome.diagnostic[:200]))

    n_total = sum(len(b.vreq_ids) for b in batches) or 1
    n_applied = sum(len(o.vreq_ids) for o in outcomes if o.status == "applied")
    coverage = 100.0 * n_applied / n_total

    return PipelineResult(
        initial_model=initial_model,
        final_model=model,
        outline=outline,
        raw_vreqs=deduped,
        batches=batches,
        outcomes=outcomes,
        coverage_pct=coverage,
        rejected_handlers=rejected,
    )


def _merge_partial(base: dict, candidate: dict, target_entities: tuple[tuple[str, str], ...]) -> dict:
    if not target_entities or ("*", "*") in target_entities:
        return candidate
    out = copy.deepcopy(base)
    base_mdl = out.get("model", out)
    cand_mdl = candidate.get("model", candidate)
    cand_doms = {d.get("name", ""): d for d in cand_mdl.get("domains", [])}
    base_doms = {d.get("name", ""): d for d in base_mdl.get("domains", [])}

    target_doms_wild = {d for d, p in target_entities if p == "*" and d != "*"}
    target_pairs = {(d, p) for d, p in target_entities if d != "*" and p != "*"}

    for dn in set(cand_doms) | set(base_doms):
        if dn in target_doms_wild:
            if dn in cand_doms:
                base_doms[dn] = cand_doms[dn]
            elif dn in base_doms:
                del base_doms[dn]
            continue
        if dn not in base_doms and dn in cand_doms and any(td == dn for td, _ in target_entities):
            base_doms[dn] = cand_doms[dn]
            continue
        if dn in base_doms and dn in cand_doms:
            bd = base_doms[dn]
            cd = cand_doms[dn]
            b_prods = {p.get("name", ""): p for p in (bd.get("products") or bd.get("data_products") or [])}
            c_prods = {p.get("name", ""): p for p in (cd.get("products") or cd.get("data_products") or [])}
            scope_pairs_for_d = {p for d2, p in target_pairs if d2 == dn}
            for pn in set(b_prods) | set(c_prods):
                if pn in scope_pairs_for_d:
                    if pn in c_prods:
                        b_prods[pn] = c_prods[pn]
                    elif pn in b_prods:
                        del b_prods[pn]
            merged_prods = [b_prods[k] for k in b_prods]
            if "products" in bd:
                bd["products"] = merged_prods
            else:
                bd["data_products"] = merged_prods

    base_mdl["domains"] = [base_doms[k] for k in base_doms]
    if "model" in out:
        out["model"] = base_mdl
    else:
        out.update(base_mdl)
    return out
