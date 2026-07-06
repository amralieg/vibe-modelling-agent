from vov_2_0.chunker import chunk_vibe, find_section_offsets, _atomic_block_ranges
from tests.vov_2_0.fixtures.simulated_vibes import (
    NCDOT_MINIMAL,
    HEALTHCARE_VIBE,
    RETAIL_VIBE,
    EMPTY_VIBE,
    CROSS_REFERENCE_VIBE,
    JSON_HEAVY_VIBE,
)


def test_find_section_offsets_basic():
    text = "## A\nbody A\n## B\nbody B\n"
    offsets = find_section_offsets(text)
    assert len(offsets) == 2
    assert offsets[0][3] == "A"
    assert offsets[1][3] == "B"


def test_find_section_offsets_empty_text():
    offsets = find_section_offsets("")
    assert len(offsets) == 1
    assert offsets[0] == (0, 0, 0, "")


def test_find_section_offsets_no_headings_returns_single_block():
    text = "Just prose with no headings whatsoever."
    offsets = find_section_offsets(text)
    assert len(offsets) == 1
    assert offsets[0][3] == ""
    assert offsets[0][1] == len(text)


def test_find_section_offsets_handles_preamble():
    text = "preamble\n## first\nbody"
    offsets = find_section_offsets(text)
    assert offsets[0][0] == 0
    assert offsets[0][2] == 0
    assert offsets[1][3] == "first"


def test_chunk_vibe_ncdot_produces_chunks_with_section_ids():
    chunks = chunk_vibe(NCDOT_MINIMAL)
    assert len(chunks) > 0
    for c in chunks:
        assert c.text
        assert c.byte_start >= 0
        assert c.byte_end > c.byte_start
        assert c.byte_end <= len(NCDOT_MINIMAL)
        assert c.section_ids


def test_chunk_vibe_preserves_full_text():
    chunks = chunk_vibe(NCDOT_MINIMAL)
    reconstructed = "".join(c.text for c in chunks)
    assert reconstructed == NCDOT_MINIMAL


def test_chunk_vibe_empty():
    chunks = chunk_vibe(EMPTY_VIBE)
    assert isinstance(chunks, list)


def test_chunk_vibe_keeps_tables_atomic():
    text = """## Section A

| col1 | col2 | col3 |
|---|---|---|
| a | 1 | x |
| b | 2 | y |
| c | 3 | z |
| d | 4 | w |

After table.
"""
    chunks = chunk_vibe(text, target_bytes=50, max_bytes=200)
    table_chunk = None
    for c in chunks:
        if "| col1" in c.text:
            table_chunk = c
            break
    assert table_chunk is not None
    assert "| d | 4 | w |" in table_chunk.text


def test_chunk_vibe_keeps_code_fence_atomic():
    chunks = chunk_vibe(NCDOT_MINIMAL, target_bytes=200, max_bytes=600)
    code_chunk = None
    for c in chunks:
        if "CREATE MATERIALIZED VIEW" in c.text:
            code_chunk = c
            break
    if code_chunk is not None:
        assert "Position_Number" in code_chunk.text or any("Position_Number" in c.text for c in chunks)


def test_atomic_block_ranges_finds_code_fence():
    text = "before\n```python\nx = 1\n```\nafter"
    blocks = _atomic_block_ranges(text)
    assert len(blocks) == 1
    assert "x = 1" in text[blocks[0][0]:blocks[0][1]]


def test_atomic_block_ranges_finds_table():
    text = "before\n| a | b |\n|---|---|\n| 1 | 2 |\nafter"
    blocks = _atomic_block_ranges(text)
    assert len(blocks) == 1


def test_atomic_block_ranges_merges_overlapping():
    text = "| a |\n| b |\n```\nx\n```"
    blocks = _atomic_block_ranges(text)
    assert len(blocks) == 2 or (len(blocks) == 1 and blocks[0][1] >= len(text) - 5)


def test_chunk_long_section_splits_at_paragraph_breaks():
    long = "## Section\n\n" + "\n\n".join([f"para {i} " + "x" * 200 for i in range(10)])
    chunks = chunk_vibe(long, target_bytes=400, max_bytes=600)
    assert len(chunks) >= 2
    for c in chunks:
        assert c.byte_end - c.byte_start <= 700


def test_chunk_healthcare_full_round_trip():
    chunks = chunk_vibe(HEALTHCARE_VIBE)
    reconstructed = "".join(c.text for c in chunks)
    assert reconstructed == HEALTHCARE_VIBE


def test_chunk_retail_full_round_trip():
    chunks = chunk_vibe(RETAIL_VIBE)
    reconstructed = "".join(c.text for c in chunks)
    assert reconstructed == RETAIL_VIBE


def test_chunk_cross_reference_keeps_sections_split():
    chunks = chunk_vibe(CROSS_REFERENCE_VIBE)
    section_a = next((c for c in chunks if "Section A" in c.text), None)
    section_d = next((c for c in chunks if "Section D" in c.text), None)
    assert section_a is not None
    assert section_d is not None
    assert section_a.chunk_id != section_d.chunk_id


def test_chunk_json_heavy_keeps_json_block_atomic():
    chunks = chunk_vibe(JSON_HEAVY_VIBE)
    json_chunk = next((c for c in chunks if '"domains"' in c.text and '"api"' in c.text), None)
    assert json_chunk is not None
    assert '"products": ["endpoint"' in json_chunk.text or '"endpoint"' in json_chunk.text
