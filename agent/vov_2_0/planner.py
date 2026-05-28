from __future__ import annotations

from collections import defaultdict
from typing import Iterable

from .types import Batch, Handler


def _entities_set(target_entities: Iterable[tuple[str, str]]) -> set[tuple[str, str]]:
    return set(target_entities)


def _has_global(entities: set[tuple[str, str]]) -> bool:
    return ("*", "*") in entities


def _conflicts(a: set[tuple[str, str]], b: set[tuple[str, str]]) -> bool:
    if _has_global(a) or _has_global(b):
        return True
    a_doms = {d for d, _ in a}
    b_doms = {d for d, _ in b}
    if "*" in a_doms or "*" in b_doms:
        if a_doms & b_doms or "*" in a_doms or "*" in b_doms:
            return True
    if a & b:
        return True
    a_dom_wild = {d for d, p in a if p == "*"}
    b_dom_wild = {d for d, p in b if p == "*"}
    for d in a_dom_wild:
        if any(bd == d for bd, _ in b):
            return True
    for d in b_dom_wild:
        if any(ad == d for ad, _ in a):
            return True
    return False


def plan_waves(handlers: list[Handler]) -> list[list[Handler]]:
    if not handlers:
        return []

    n = len(handlers)
    entity_sets = [_entities_set(h.target_entities) for h in handlers]
    conflict = [[False] * n for _ in range(n)]
    for i in range(n):
        for j in range(i + 1, n):
            if _conflicts(entity_sets[i], entity_sets[j]):
                conflict[i][j] = True
                conflict[j][i] = True

    assigned = [-1] * n
    waves: list[list[int]] = []
    order = sorted(range(n), key=lambda i: -sum(conflict[i]))

    for i in order:
        for w_idx, wave in enumerate(waves):
            if all(not conflict[i][j] for j in wave):
                wave.append(i)
                assigned[i] = w_idx
                break
        if assigned[i] == -1:
            waves.append([i])
            assigned[i] = len(waves) - 1

    return [[handlers[i] for i in sorted(w)] for w in waves]
