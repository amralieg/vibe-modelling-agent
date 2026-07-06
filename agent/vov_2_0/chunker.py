from __future__ import annotations

import re
from typing import Iterator

from .types import VibeChunk, VibeOutline, VibeSection

DEFAULT_CHUNK_TARGET_BYTES = 2200
DEFAULT_CHUNK_MAX_BYTES = 4000

_HEADING_RE = re.compile(r"^(#{1,6})\s+(.+?)\s*$", re.MULTILINE)
_TABLE_RE = re.compile(r"((?:^\|.*\|\s*$\n?)+)", re.MULTILINE)
_CODE_FENCE_RE = re.compile(r"```[\s\S]*?```", re.MULTILINE)


def find_section_offsets(text: str) -> list[tuple[int, int, int, str]]:
    matches = list(_HEADING_RE.finditer(text))
    out = []
    for i, m in enumerate(matches):
        start = m.start()
        end = matches[i + 1].start() if i + 1 < len(matches) else len(text)
        depth = len(m.group(1))
        title = m.group(2).strip()
        out.append((start, end, depth, title))
    if not out:
        return [(0, len(text), 0, "")]
    if out[0][0] > 0:
        out.insert(0, (0, out[0][0], 0, ""))
    return out


def _atomic_block_ranges(text: str) -> list[tuple[int, int]]:
    blocks = []
    for m in _CODE_FENCE_RE.finditer(text):
        blocks.append((m.start(), m.end()))
    for m in _TABLE_RE.finditer(text):
        blocks.append((m.start(), m.end()))
    blocks.sort()
    merged = []
    for s, e in blocks:
        if merged and s <= merged[-1][1]:
            merged[-1] = (merged[-1][0], max(merged[-1][1], e))
        else:
            merged.append((s, e))
    return merged


def chunk_vibe(
    vibe_text: str,
    outline: VibeOutline | None = None,
    target_bytes: int = DEFAULT_CHUNK_TARGET_BYTES,
    max_bytes: int = DEFAULT_CHUNK_MAX_BYTES,
) -> list[VibeChunk]:
    if outline:
        section_ranges = [(s.byte_start, s.byte_end, 0, s.title) for s in outline.sections]
        section_id_lookup = {(s.byte_start, s.byte_end): s.section_id for s in outline.sections}
    else:
        section_ranges = find_section_offsets(vibe_text)
        section_id_lookup = {(s, e): f"S{i+1}" for i, (s, e, _, _) in enumerate(section_ranges)}

    atomics = _atomic_block_ranges(vibe_text)

    chunks: list[VibeChunk] = []
    chunk_idx = 0

    for sec_start, sec_end, _depth, _title in section_ranges:
        sec_text = vibe_text[sec_start:sec_end]
        sid = section_id_lookup.get((sec_start, sec_end), f"S{chunk_idx + 1}")

        if len(sec_text) <= max_bytes:
            chunk_idx += 1
            chunks.append(VibeChunk(
                chunk_id=f"C{chunk_idx}",
                section_ids=(sid,),
                text=sec_text,
                byte_start=sec_start,
                byte_end=sec_end,
            ))
            continue

        cursor = sec_start
        while cursor < sec_end:
            window_end = min(cursor + target_bytes, sec_end)
            blocking = [(s, e) for s, e in atomics if s < window_end and e > cursor and not (s >= cursor and e <= window_end)]
            if blocking:
                bs, be = blocking[0]
                if bs <= cursor:
                    window_end = min(max(window_end, be), sec_end)
                else:
                    window_end = bs

            if window_end - cursor > max_bytes:
                window_end = cursor + max_bytes

            if window_end < sec_end:
                slice_text = vibe_text[cursor:window_end]
                m = list(re.finditer(r"\n\n", slice_text))
                if m:
                    last_break = m[-1].end()
                    if last_break > target_bytes // 2:
                        window_end = cursor + last_break

            chunk_idx += 1
            chunks.append(VibeChunk(
                chunk_id=f"C{chunk_idx}",
                section_ids=(sid,),
                text=vibe_text[cursor:window_end],
                byte_start=cursor,
                byte_end=window_end,
            ))
            cursor = window_end

    return chunks
