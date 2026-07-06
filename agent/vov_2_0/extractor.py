from __future__ import annotations

import json
import re
from typing import Any

from .llm import LLMClient
from .types import RawVREQ, VibeChunk, VibeOutline


EXTRACTION_SYSTEM_PROMPT = """You are a requirements analyst extracting USER INSTRUCTIONS from a chunk of a model-design vibe.

Emit ONE RawVREQ for every distinct, atomic user instruction in this chunk. Do NOT merge instructions. Do NOT compress.
If a markdown table has N rows that each represent a separate instruction, emit N RawVREQs (one per row).
If a code block defines N columns each with a tag-application rule, emit N RawVREQs (one per column).
If a sentence packs M instructions, emit M RawVREQs.

A RawVREQ has the form:
  - vreq_id: a short id you assign (e.g. "V1", "V2", ...)
  - intent: one-sentence natural-language statement of what the user wants
  - target: the entity, scope, or set the instruction applies to (e.g. "all HR products derived from DDL emp_history", "domain count", "every CDE row attribute")
  - source_quote: 1-3 lines quoted verbatim from the chunk that produced this requirement

GUIDELINES:
- Atomicity beats brevity. 30 small VREQs is better than 5 abstract ones.
- Quote exact lines for source_quote, with no rephrasing.
- A RawVREQ is "USE the listed value" or "APPLY the listed mapping", not "do something reasonable".
- If you encounter a reference to another section ("as defined above"), use the vibe_grep / vibe_section / vibe_resolve_entity tools to fetch the referenced material before emitting the VREQ. Never guess.
- If the chunk is purely descriptive context (jargons, acronyms, ambient prose with no instructions), emit zero VREQs.

OUTLINE OF THE FULL VIBE (for cross-reference resolution):
{outline_json}

Output JSON: {{"vreqs": [{{...RawVREQ fields...}}, ...]}}
No prose, no commentary, no markdown around the JSON.
"""


TOOL_DEFS = [
    {
        "name": "vibe_grep",
        "description": "Search the FULL vibe (not just the current chunk) for a regex pattern. Use when current chunk references something defined elsewhere. Returns up to 8 matching lines with surrounding context.",
        "parameters": {
            "type": "object",
            "properties": {"pattern": {"type": "string", "description": "Python regex pattern"}},
            "required": ["pattern"],
        },
    },
    {
        "name": "vibe_section",
        "description": "Fetch a named section of the vibe by its section_id from the outline.",
        "parameters": {
            "type": "object",
            "properties": {"section_id": {"type": "string"}},
            "required": ["section_id"],
        },
    },
    {
        "name": "vibe_resolve_entity",
        "description": "Look up where an entity (domain, product, attribute, tag-key) is defined in the vibe outline. Returns the section_ids where the entity appears.",
        "parameters": {
            "type": "object",
            "properties": {"entity_name": {"type": "string"}},
            "required": ["entity_name"],
        },
    },
]


def make_tool_handlers(outline: VibeOutline) -> dict:
    full = outline.full_text

    def vibe_grep(pattern: str) -> dict:
        try:
            rx = re.compile(pattern, re.IGNORECASE | re.MULTILINE)
        except re.error as e:
            return {"error": f"bad regex: {e}"}
        matches = []
        for m in rx.finditer(full):
            line_start = full.rfind("\n", 0, m.start()) + 1
            line_end = full.find("\n", m.end())
            if line_end == -1:
                line_end = len(full)
            matches.append(full[line_start:line_end])
            if len(matches) >= 8:
                break
        return {"matches": matches, "count": len(matches)}

    def vibe_section(section_id: str) -> dict:
        text = outline.section_text(section_id)
        if not text:
            return {"error": f"section_id {section_id} not found"}
        return {"section_id": section_id, "text": text[:6000]}

    def vibe_resolve_entity(entity_name: str) -> dict:
        secs = outline.find_entity(entity_name)
        return {"sections": [s.section_id for s in secs], "n": len(secs)}

    return {
        "vibe_grep": vibe_grep,
        "vibe_section": vibe_section,
        "vibe_resolve_entity": vibe_resolve_entity,
    }


def _vreq_from_dict(d: dict, chunk_id: str, default_idx: int) -> RawVREQ:
    return RawVREQ(
        vreq_id=str(d.get("vreq_id") or f"{chunk_id}_V{default_idx}").strip(),
        intent=str(d.get("intent") or "").strip(),
        target=str(d.get("target") or "").strip(),
        source_quote=str(d.get("source_quote") or "").strip(),
        source_chunk_id=chunk_id,
    )


def extract_from_chunk(
    chunk: VibeChunk,
    outline: VibeOutline,
    llm: LLMClient,
) -> list[RawVREQ]:
    outline_json = json.dumps({
        "sections": [
            {"section_id": s.section_id, "title": s.title, "summary": s.summary,
             "declared_entities": list(s.declared_entities)[:30],
             "constraints": list(s.constraints)[:10]}
            for s in outline.sections
        ],
        "global_constraints": list(outline.global_constraints),
    }, indent=2)

    system = EXTRACTION_SYSTEM_PROMPT.format(outline_json=outline_json[:12000])
    handlers = make_tool_handlers(outline)
    raw = llm.complete_with_tools(
        system=system,
        user=f"CHUNK {chunk.chunk_id} (section_ids={list(chunk.section_ids)}):\n\n{chunk.text}",
        tools=TOOL_DEFS,
        tool_handlers=handlers,
        temperature=0.0,
    )

    if not isinstance(raw, dict):
        return []
    items = raw.get("vreqs") or raw.get("requirements") or []
    if not isinstance(items, list):
        return []

    out = []
    for i, item in enumerate(items):
        if isinstance(item, dict) and (item.get("intent") or item.get("target")):
            out.append(_vreq_from_dict(item, chunk.chunk_id, i + 1))
    return out


def extract_all(
    chunks: list[VibeChunk],
    outline: VibeOutline,
    llm: LLMClient,
    parallel: bool = True,
    max_workers: int = 8,
) -> list[RawVREQ]:
    if not parallel:
        out = []
        for c in chunks:
            out.extend(extract_from_chunk(c, outline, llm))
        return out

    from concurrent.futures import ThreadPoolExecutor

    out: list[RawVREQ] = []
    with ThreadPoolExecutor(max_workers=max_workers) as ex:
        futs = [ex.submit(extract_from_chunk, c, outline, llm) for c in chunks]
        for f in futs:
            try:
                out.extend(f.result())
            except Exception:
                pass
    return out
