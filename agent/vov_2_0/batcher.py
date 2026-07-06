from __future__ import annotations

import json
import re
from collections import defaultdict
from typing import Any, Optional

from .llm import LLMClient
from .types import Batch, RawVREQ


BATCHING_SYSTEM_PROMPT = """You group VREQs into BATCHES that can each be applied by ONE Python mutator.

A batch is a coherent slice:
  - same KIND of mutation (tag application, FK addition, field assignment, rename, count enforcement, structural fix, ...)
  - related target scope (same domain, same product family, or same source DDL)
  - 5 to 30 VREQs is the sweet spot; batches of 1 are allowed for unique VREQs; >100 is forbidden

For each batch, also extract a `data_payload` if the batch references tabular data
(e.g. a 72-row CDE table, a list of 9 PSE source tables, a 7-row HR DDL list).
The data_payload is a list of dicts, each dict being one row's structured fields.
The mutator will receive data_payload as its `data` argument and iterate.

If a batch needs no tabular data, set data_payload to [].

Emit JSON: {"batches": [{"batch_id": "B1", "vreq_ids": ["VREQ-0001", ...], "intent_summary": "...", "target_entities": [["domain","product"], ...], "data_payload": [{...}, ...]}, ...]}

target_entities is a list of [domain, product] pairs the batch touches. Use ["domain", "*"] for "all products in domain". Use ["*", "*"] for global.

No prose around the JSON.
"""


def _entities_for_signature(target_entities: tuple[tuple[str, str], ...]) -> frozenset[tuple[str, str]]:
    return frozenset(target_entities)


def deterministic_pre_group(vreqs: list[RawVREQ]) -> dict[str, list[RawVREQ]]:
    groups = defaultdict(list)
    for v in vreqs:
        text = f"{v.intent} {v.target}".lower()
        if "tag" in text and ("ncdot_source_table" in text or "ncdot_source_attribute" in text or "original_table_name" in text or "ncdot_business_glossary_term" in text):
            key = "tag_apply"
        elif "subdomain" in text:
            key = "subdomain"
        elif "metric view" in text or "kpi-" in text or "exactly 3 metric" in text:
            key = "metric_view"
        elif "rename" in text:
            key = "rename"
        elif "fk" in text or "foreign key" in text or "connect_table" in text:
            key = "fk"
        elif "remove" in text or "drop" in text or "delete" in text:
            key = "remove"
        elif "add column" in text or "add attribute" in text:
            key = "add_attr"
        elif "domain" in text and ("exactly" in text or "build" in text or "must" in text):
            key = "domain_structure"
        else:
            key = "other"
        groups[key].append(v)
    return groups


def batch_vreqs(
    vreqs: list[RawVREQ],
    llm: Optional[LLMClient] = None,
    max_per_call: int = 60,
) -> list[Batch]:
    if not vreqs:
        return []

    if llm is None:
        return _heuristic_batch(vreqs)

    pre_groups = deterministic_pre_group(vreqs)
    all_batches: list[Batch] = []
    batch_idx = 0

    for group_key, group_vreqs in pre_groups.items():
        if not group_vreqs:
            continue
        for window_start in range(0, len(group_vreqs), max_per_call):
            window = group_vreqs[window_start:window_start + max_per_call]
            user = json.dumps({
                "pre_group_hint": group_key,
                "vreqs": [{"vreq_id": v.vreq_id, "intent": v.intent, "target": v.target, "source_quote": v.source_quote[:300]} for v in window],
            }, indent=2)
            try:
                raw = llm.complete_json(system=BATCHING_SYSTEM_PROMPT, user=user, temperature=0.0)
            except Exception:
                all_batches.extend(_heuristic_batch(window, batch_offset=batch_idx))
                batch_idx = len(all_batches)
                continue

            if not isinstance(raw, dict):
                all_batches.extend(_heuristic_batch(window, batch_offset=batch_idx))
                batch_idx = len(all_batches)
                continue

            for b in raw.get("batches", []):
                if not isinstance(b, dict):
                    continue
                vids = tuple(str(x) for x in (b.get("vreq_ids") or []) if str(x))
                te_raw = b.get("target_entities") or []
                te = tuple(
                    (str(t[0]), str(t[1])) for t in te_raw
                    if isinstance(t, (list, tuple)) and len(t) >= 2
                )
                dp_raw = b.get("data_payload") or []
                dp = tuple(d for d in dp_raw if isinstance(d, dict))
                batch_idx += 1
                all_batches.append(Batch(
                    batch_id=f"B{batch_idx:04d}",
                    vreq_ids=vids,
                    intent_summary=str(b.get("intent_summary", "")).strip(),
                    target_entities=te,
                    data_payload=dp,
                ))

    if not all_batches:
        return _heuristic_batch(vreqs)
    return all_batches


def _heuristic_batch(vreqs: list[RawVREQ], batch_offset: int = 0) -> list[Batch]:
    pre_groups = deterministic_pre_group(vreqs)
    batches = []
    idx = batch_offset
    for key, items in pre_groups.items():
        for window_start in range(0, len(items), 25):
            window = items[window_start:window_start + 25]
            idx += 1
            batches.append(Batch(
                batch_id=f"B{idx:04d}",
                vreq_ids=tuple(v.vreq_id for v in window),
                intent_summary=f"heuristic batch ({key})",
                target_entities=(("*", "*"),),
                data_payload=tuple(
                    {"intent": v.intent, "target": v.target, "source_quote": v.source_quote}
                    for v in window
                ),
            ))
    return batches
