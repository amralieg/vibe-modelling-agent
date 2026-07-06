from __future__ import annotations

import json
import re
from typing import Iterable, Optional

from .llm import LLMClient
from .types import RawVREQ


_NORMALIZE_RE = re.compile(r"[^a-z0-9 ]+")


def _normalize(s: str) -> str:
    return _NORMALIZE_RE.sub(" ", s.lower()).strip()


def _shingle_set(s: str, k: int = 4) -> frozenset[str]:
    norm = _normalize(s)
    if len(norm) < k:
        return frozenset({norm})
    return frozenset(norm[i:i + k] for i in range(len(norm) - k + 1))


def jaccard(a: frozenset[str], b: frozenset[str]) -> float:
    if not a or not b:
        return 0.0
    inter = len(a & b)
    if inter == 0:
        return 0.0
    return inter / len(a | b)


DEDUPE_MERGE_PROMPT = """You are a requirements analyst. Given a CLUSTER of near-duplicate VREQs that all express the same user instruction, produce a SINGLE merged RawVREQ that captures the union of their meaning.

Rules:
- Keep the most specific intent statement.
- Union the targets if they refer to the same scope.
- Keep the longest source_quote that is still verbatim from the vibe.
- Do NOT invent new requirements. If two VREQs disagree, keep the more SPECIFIC one and drop the more abstract.
- Output one JSON object: {{"vreq_id": "...", "intent": "...", "target": "...", "source_quote": "..."}}

CLUSTER:
{cluster_json}
"""


def cluster_vreqs(vreqs: list[RawVREQ], threshold: float = 0.8) -> list[list[RawVREQ]]:
    if not vreqs:
        return []
    n = len(vreqs)
    sigs = [_shingle_set(f"{v.intent} {v.target}") for v in vreqs]
    parent = list(range(n))

    def find(i: int) -> int:
        while parent[i] != i:
            parent[i] = parent[parent[i]]
            i = parent[i]
        return i

    def union(i: int, j: int) -> None:
        ri, rj = find(i), find(j)
        if ri != rj:
            parent[ri] = rj

    for i in range(n):
        for j in range(i + 1, n):
            if jaccard(sigs[i], sigs[j]) >= threshold:
                union(i, j)

    clusters: dict[int, list[RawVREQ]] = {}
    for i, v in enumerate(vreqs):
        clusters.setdefault(find(i), []).append(v)
    return list(clusters.values())


def merge_cluster(cluster: list[RawVREQ], llm: Optional[LLMClient] = None) -> RawVREQ:
    if len(cluster) == 1:
        return cluster[0]

    if llm is None:
        cluster_sorted = sorted(cluster, key=lambda v: -len(v.intent + v.target + v.source_quote))
        primary = cluster_sorted[0]
        return RawVREQ(
            vreq_id=primary.vreq_id,
            intent=primary.intent,
            target=primary.target,
            source_quote=primary.source_quote,
            source_chunk_id=primary.source_chunk_id,
        )

    cluster_json = json.dumps([
        {"vreq_id": v.vreq_id, "intent": v.intent, "target": v.target, "source_quote": v.source_quote}
        for v in cluster
    ], indent=2)

    raw = llm.complete_json(
        system="You merge near-duplicate requirements into one.",
        user=DEDUPE_MERGE_PROMPT.format(cluster_json=cluster_json),
        temperature=0.0,
    )

    if not isinstance(raw, dict):
        return cluster[0]

    return RawVREQ(
        vreq_id=str(raw.get("vreq_id") or cluster[0].vreq_id),
        intent=str(raw.get("intent") or cluster[0].intent),
        target=str(raw.get("target") or cluster[0].target),
        source_quote=str(raw.get("source_quote") or cluster[0].source_quote),
        source_chunk_id=cluster[0].source_chunk_id,
    )


def dedupe_vreqs(
    vreqs: list[RawVREQ],
    threshold: float = 0.8,
    llm: Optional[LLMClient] = None,
) -> list[RawVREQ]:
    clusters = cluster_vreqs(vreqs, threshold=threshold)
    out = []
    for c in clusters:
        merged = merge_cluster(c, llm=llm)
        out.append(merged)

    final = []
    for i, v in enumerate(out):
        new_id = f"VREQ-{i+1:04d}"
        final.append(RawVREQ(
            vreq_id=new_id,
            intent=v.intent,
            target=v.target,
            source_quote=v.source_quote,
            source_chunk_id=v.source_chunk_id,
        ))
    return final
