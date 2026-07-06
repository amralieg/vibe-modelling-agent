from __future__ import annotations

import json
import re
from typing import Any

from .chunker import find_section_offsets
from .llm import LLMClient
from .types import VibeOutline, VibeSection

OUTLINE_SYSTEM_PROMPT = """You are a requirements analyst. Read a model-design vibe and produce a STRUCTURED OUTLINE.
For each section in the vibe, emit:
  - section_id (e.g. "S1", "S2", ...)
  - title (verbatim from heading; empty string if no heading)
  - summary (one short sentence describing what this section covers)
  - declared_entities (list of named domains, products, tables, columns, tag-keys, and metric-view names introduced in this section, verbatim)
  - cross_references (list of references to OTHER sections, e.g. "see above", "section X", "as defined earlier"; empty list if none)
  - constraints (list of hard constraints declared in this section: "EXACTLY N", "MUST", "ONLY", numeric caps, mandatory tags, naming conventions)

Also emit two top-level keys:
  - global_constraints (constraints that apply to the WHOLE vibe regardless of section, e.g. "use snake_case", "tag prefix ncdot_")
  - declared_entities_global (all entities ever named in the vibe, deduplicated)

CRITICAL: emit raw JSON only. No prose, no commentary. The structure must be:
{
  "sections": [{"section_id": "S1", "title": "...", "summary": "...", "declared_entities": [...], "cross_references": [...], "constraints": [...]}, ...],
  "global_constraints": [...],
  "declared_entities_global": [...]
}
Do NOT include byte ranges in your output; those are computed deterministically from the vibe text by the caller.
"""


def _normalize_str_list(v: Any) -> tuple[str, ...]:
    if v is None:
        return ()
    if isinstance(v, str):
        return (v,)
    if isinstance(v, (list, tuple, set, frozenset)):
        return tuple(str(x).strip() for x in v if str(x).strip())
    return (str(v),)


def _align_sections_to_offsets(
    llm_sections: list[dict],
    offsets: list[tuple[int, int, int, str]],
) -> list[VibeSection]:
    sections: list[VibeSection] = []
    by_title = {title.lower(): (start, end) for start, end, _, title in offsets if title}
    fallback_iter = iter(offsets)

    for i, sec in enumerate(llm_sections):
        title = str(sec.get("title", "")).strip()
        sid = str(sec.get("section_id", f"S{i+1}")).strip() or f"S{i+1}"
        start, end = by_title.get(title.lower(), (None, None))
        if start is None:
            try:
                start, end, _, _ = next(fallback_iter)
            except StopIteration:
                start, end = 0, 0

        sections.append(VibeSection(
            section_id=sid,
            title=title,
            byte_start=start,
            byte_end=end,
            summary=str(sec.get("summary", "")).strip(),
            declared_entities=_normalize_str_list(sec.get("declared_entities")),
            cross_references=_normalize_str_list(sec.get("cross_references")),
            constraints=_normalize_str_list(sec.get("constraints")),
        ))

    return sections


def build_outline(vibe_text: str, llm: LLMClient) -> VibeOutline:
    offsets = find_section_offsets(vibe_text)

    raw = llm.complete_json(
        system=OUTLINE_SYSTEM_PROMPT,
        user=vibe_text,
        temperature=0.0,
    )

    if not isinstance(raw, dict):
        raw = {}

    llm_sections = raw.get("sections") or []
    if not isinstance(llm_sections, list):
        llm_sections = []

    sections = _align_sections_to_offsets(llm_sections, offsets)
    if not sections:
        sections = [VibeSection(
            section_id=f"S{i+1}",
            title=title,
            byte_start=s,
            byte_end=e,
            summary="",
            declared_entities=(),
            cross_references=(),
            constraints=(),
        ) for i, (s, e, _, title) in enumerate(offsets)]

    return VibeOutline(
        sections=tuple(sections),
        full_text=vibe_text,
        global_constraints=_normalize_str_list(raw.get("global_constraints")),
        declared_entities_global=_normalize_str_list(raw.get("declared_entities_global")),
    )
