from __future__ import annotations

import json
from typing import Optional

from .llm import LLMClient
from .types import Batch, Handler


SYNTHESIS_SYSTEM_PROMPT = """You write Python code that mutates a model.json document so that a batch of user requirements is satisfied, plus a verifier that checks whether the requirements are satisfied.

You will produce TWO functions and ONE summary string:

  def mutator(model, data):
      # mutates model in place AND returns model (or returns a new dict)
      ...
      return model

  def verifier(model, data):
      # returns (True, "") if the batch's requirements are satisfied;
      # (False, "<diagnostic naming the entities that fail>") otherwise.
      ...
      return (True, "")

CONSTRAINTS (HARD):
  - Allowed builtins: len, range, enumerate, zip, sorted, reversed, set, list, dict, tuple, frozenset, str, int, float, bool, type, any, all, sum, min, max, abs, round, isinstance, hasattr, getattr, callable, print
  - Allowed modules and methods: re.search, re.match, re.findall, re.finditer, re.sub, re.subn, re.compile, re.split, re.escape, json.dumps, json.loads, copy.deepcopy, copy.copy
  - Forbidden: import (other than module attrs above), open, exec, eval, compile, __import__, file IO, network, dunders, subprocess, os, sys
  - Functions must be DETERMINISTIC and IDEMPOTENT (running mutator(mutator(m), data) must equal mutator(m, data))
  - The verifier must FAIL on a model that does NOT satisfy the batch (so we can prove the mutator made a difference). Tautological verifiers that always return True are forbidden.

MODEL JSON SCHEMA (the structure you mutate):
{
  "agent_version": "1.x.x",
  "model": {
    "domains": [
      {
        "name": "...",
        "products": [
          {
            "name": "...",
            "subdomain": "...",
            "primary_key": "...",
            "tags": "comma,separated,key=value,strings",
            "description": "...",
            "reference": "...",
            "attributes": [
              {
                "name": "...",
                "type": "BIGINT|STRING|...",
                "tags": "comma,separated,key=value,strings",
                "foreign_key_to": "domain.product.attribute or empty",
                "business_glossary_term": "...",
                "description": "..."
              }
            ]
          }
        ]
      }
    ],
    "metric_views": [
      {"view_name": "...", "owner_domain": "...", "owner_product": "...", "sql": "...", "description": "..."}
    ]
  }
}

BATCH:
  intent: {intent}
  target_entities: {target_entities}
  data_payload (this becomes the `data` argument): {data_payload}

OUTPUT format (JSON only, no prose):
{{
  "mutator_source": "<full Python source of `def mutator(model, data): ...`>",
  "verifier_source": "<full Python source of `def verifier(model, data): ...`>",
  "expected_changes_summary": "one short sentence describing what mutations to expect"
}}

If the batch references both products and attributes that may not exist yet, your mutator should be defensive (skip missing entities, do not crash).
If the batch's intent cannot be expressed safely under the constraints, write a verifier that returns (False, "cannot synthesize") and a mutator that returns model unchanged.
"""


def synthesize_handler(
    batch: Batch,
    llm: LLMClient,
    prior_failure_trace: Optional[str] = None,
) -> Handler:
    user = SYNTHESIS_SYSTEM_PROMPT.replace(
        "{intent}", batch.intent_summary
    ).replace(
        "{target_entities}", json.dumps(list(batch.target_entities))
    ).replace(
        "{data_payload}", json.dumps(list(batch.data_payload))[:8000]
    )

    if prior_failure_trace:
        user += f"\n\nPRIOR ATTEMPT FAILED. Trace:\n{prior_failure_trace[:3000]}\n\nFix the failure and try again. Do NOT repeat the same mistake."

    raw = llm.complete_json(
        system="You are a careful Python code generator that produces safe, deterministic mutators.",
        user=user,
        temperature=0.0,
    )

    if not isinstance(raw, dict):
        raw = {}

    return Handler(
        batch_id=batch.batch_id,
        mutator_src=str(raw.get("mutator_source", "")).strip(),
        verifier_src=str(raw.get("verifier_source", "")).strip(),
        expected_changes_summary=str(raw.get("expected_changes_summary", "")).strip(),
        target_entities=batch.target_entities,
    )


def synthesize_batch_handlers(
    batches: list[Batch],
    llm: LLMClient,
    parallel: bool = True,
    max_workers: int = 8,
) -> list[Handler]:
    if not parallel:
        return [synthesize_handler(b, llm) for b in batches]

    from concurrent.futures import ThreadPoolExecutor

    handlers: list[Optional[Handler]] = [None] * len(batches)
    with ThreadPoolExecutor(max_workers=max_workers) as ex:
        futs = {ex.submit(synthesize_handler, b, llm): i for i, b in enumerate(batches)}
        for f, i in futs.items():
            try:
                handlers[i] = f.result()
            except Exception as e:
                handlers[i] = Handler(
                    batch_id=batches[i].batch_id,
                    mutator_src="def mutator(model, data):\n    return model\n",
                    verifier_src=f"def verifier(model, data):\n    return (False, 'synth failed: {type(e).__name__}')\n",
                    expected_changes_summary=f"synthesis failed: {e}",
                    target_entities=batches[i].target_entities,
                )
    return [h for h in handlers if h is not None]
