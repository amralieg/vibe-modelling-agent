from agent.vov_2_0.chunker import chunk_vibe
from agent.vov_2_0.extractor import (
    extract_all,
    extract_from_chunk,
    make_tool_handlers,
)
from agent.vov_2_0.llm import CannedResponse, MockLLM
from agent.vov_2_0.types import VibeOutline, VibeSection
from tests.vov_2_0.fixtures.simulated_vibes import (
    CROSS_REFERENCE_VIBE,
    HEALTHCARE_VIBE,
    NCDOT_MINIMAL,
    REPETITIVE_VIBE,
)


def _make_outline(text, sections):
    return VibeOutline(
        sections=tuple(VibeSection(**s) for s in sections),
        full_text=text,
        global_constraints=(),
        declared_entities_global=(),
    )


def _extraction_canned(needle, vreqs):
    return CannedResponse(
        fingerprint_predicate=lambda s: needle in s,
        response={"vreqs": vreqs},
    )


def test_extract_from_chunk_emits_one_vreq_per_atomic_instruction():
    text = NCDOT_MINIMAL
    outline = _make_outline(text, [
        {"section_id": "S1", "title": "NCDOT — base model", "byte_start": 0, "byte_end": len(text),
         "summary": "", "declared_entities": ("hr", "project"), "cross_references": (), "constraints": ()}
    ])
    chunks = chunk_vibe(text, outline=outline)
    chunk = chunks[0]
    canned_vreqs = [
        {"vreq_id": "V1", "intent": "Use prefix ncdot_ for all NCDOT-specific tags", "target": "tag-keys", "source_quote": "All NCDOT-specific tags MUST use prefix `ncdot_`."},
        {"vreq_id": "V2", "intent": "Build exactly 2 domains: hr and project", "target": "domain count", "source_quote": "BUILD EXACTLY THESE 2 DOMAINS"},
        {"vreq_id": "V3", "intent": "Add ncdot_source_table tag at table level for HR products derived from DDL", "target": "HR products", "source_quote": "TABLE-LEVEL tag `ncdot_source_table=<original_table>`"},
    ]
    llm = MockLLM(canned=[_extraction_canned("CHUNK", canned_vreqs)])
    vreqs = extract_from_chunk(chunk, outline, llm)
    assert len(vreqs) == 3
    intents = [v.intent for v in vreqs]
    assert any("ncdot_" in i for i in intents)
    assert all(v.source_chunk_id == chunk.chunk_id for v in vreqs)


def test_extract_from_chunk_handles_no_vreqs():
    text = "no instructions here"
    outline = _make_outline(text, [{"section_id": "S1", "title": "", "byte_start": 0, "byte_end": len(text),
                                    "summary": "", "declared_entities": (), "cross_references": (), "constraints": ()}])
    chunks = chunk_vibe(text, outline=outline)
    llm = MockLLM(canned=[_extraction_canned("CHUNK", [])])
    vreqs = extract_from_chunk(chunks[0], outline, llm)
    assert vreqs == []


def test_extract_from_chunk_handles_garbage_response():
    text = "trivial"
    outline = _make_outline(text, [{"section_id": "S1", "title": "", "byte_start": 0, "byte_end": len(text),
                                    "summary": "", "declared_entities": (), "cross_references": (), "constraints": ()}])
    chunks = chunk_vibe(text, outline=outline)
    llm = MockLLM(canned=[_extraction_canned("CHUNK", "not_a_list")])
    vreqs = extract_from_chunk(chunks[0], outline, llm)
    assert vreqs == []


def test_make_tool_handlers_grep_finds_lines():
    outline = _make_outline(NCDOT_MINIMAL, [
        {"section_id": "S1", "title": "NCDOT", "byte_start": 0, "byte_end": len(NCDOT_MINIMAL),
         "summary": "", "declared_entities": (), "cross_references": (), "constraints": ()}
    ])
    handlers = make_tool_handlers(outline)
    result = handlers["vibe_grep"](pattern=r"snake_case")
    assert result["count"] >= 1
    assert any("snake_case" in m for m in result["matches"])


def test_make_tool_handlers_section_returns_text():
    text = "## A\nbody A\n## B\nbody B"
    outline = _make_outline(text, [
        {"section_id": "S1", "title": "A", "byte_start": 0, "byte_end": 12,
         "summary": "", "declared_entities": (), "cross_references": (), "constraints": ()},
        {"section_id": "S2", "title": "B", "byte_start": 12, "byte_end": len(text),
         "summary": "", "declared_entities": (), "cross_references": (), "constraints": ()},
    ])
    handlers = make_tool_handlers(outline)
    s2 = handlers["vibe_section"](section_id="S2")
    assert "B" in s2["text"]
    err = handlers["vibe_section"](section_id="S99")
    assert "error" in err


def test_make_tool_handlers_resolve_entity_uses_declared():
    text = NCDOT_MINIMAL
    outline = _make_outline(text, [
        {"section_id": "S1", "title": "domains", "byte_start": 0, "byte_end": 100,
         "summary": "", "declared_entities": ("hr", "project"), "cross_references": (), "constraints": ()},
        {"section_id": "S2", "title": "hr_products", "byte_start": 100, "byte_end": 300,
         "summary": "", "declared_entities": ("employee", "position"), "cross_references": (), "constraints": ()},
    ])
    handlers = make_tool_handlers(outline)
    res = handlers["vibe_resolve_entity"](entity_name="employee")
    assert "S2" in res["sections"]


def test_extract_from_chunk_bad_regex_in_grep_returns_error_to_tool_caller():
    outline = _make_outline("text", [
        {"section_id": "S1", "title": "", "byte_start": 0, "byte_end": 4,
         "summary": "", "declared_entities": (), "cross_references": (), "constraints": ()}
    ])
    handlers = make_tool_handlers(outline)
    err = handlers["vibe_grep"](pattern="[unclosed")
    assert "error" in err


def test_extract_all_aggregates_across_chunks():
    text = HEALTHCARE_VIBE
    outline = _make_outline(text, [
        {"section_id": "S1", "title": "Healthcare data model", "byte_start": 0, "byte_end": len(text),
         "summary": "", "declared_entities": ("patient", "encounter", "claim"), "cross_references": (), "constraints": ()}
    ])
    chunks = chunk_vibe(text, outline=outline)
    llm = MockLLM(canned=[
        _extraction_canned("CHUNK", [
            {"vreq_id": "V1", "intent": "build 3 domains: patient encounter claim", "target": "domains", "source_quote": "three domains: patient, encounter, and claim"},
            {"vreq_id": "V2", "intent": "Add tag pii_classification=PHI to patient demographic attrs", "target": "patient attrs", "source_quote": "Add tag `pii_classification=PHI`"},
        ])
    ])
    vreqs = extract_all(chunks, outline, llm, parallel=False)
    assert len(vreqs) >= 2


def test_extract_repetitive_vibe_keeps_atomicity():
    text = REPETITIVE_VIBE
    outline = _make_outline(text, [
        {"section_id": "S1", "title": "Repetitive vibe", "byte_start": 0, "byte_end": len(text),
         "summary": "", "declared_entities": (), "cross_references": (), "constraints": ()}
    ])
    chunks = chunk_vibe(text, outline=outline)
    canned = [
        {"vreq_id": "V1", "intent": "use snake_case naming", "target": "naming", "source_quote": "snake_case"},
        {"vreq_id": "V2", "intent": "use snake_case naming", "target": "naming", "source_quote": "snake_case naming convention"},
        {"vreq_id": "V3", "intent": "use snake_case naming", "target": "naming", "source_quote": "Naming: snake_case"},
        {"vreq_id": "V4", "intent": "PK suffix is _id", "target": "PK suffix", "source_quote": "PK suffix _id"},
        {"vreq_id": "V5", "intent": "PK suffix is _id", "target": "PK suffix", "source_quote": "Primary keys end in _id"},
        {"vreq_id": "V6", "intent": "Use BIGINT for ID columns", "target": "id types", "source_quote": "BIGINT for IDs"},
        {"vreq_id": "V7", "intent": "Apply tag corp_dept=engineering to every product", "target": "all products", "source_quote": "Add tag `corp_dept=engineering`"},
    ]
    llm = MockLLM(canned=[_extraction_canned("CHUNK", canned)])
    vreqs = extract_all(chunks, outline, llm, parallel=False)
    assert len(vreqs) == 7


def test_extract_cross_reference_vibe_simulated_tool_use():
    text = CROSS_REFERENCE_VIBE
    outline = _make_outline(text, [
        {"section_id": "S1", "title": "Section A — naming conventions", "byte_start": 0, "byte_end": 200,
         "summary": "naming", "declared_entities": ("acme_",), "cross_references": (), "constraints": ("snake_case",)},
        {"section_id": "S4", "title": "Section D — beta products", "byte_start": 400, "byte_end": 600,
         "summary": "products of beta", "declared_entities": ("record", "log_entry"), "cross_references": ("Section A",), "constraints": ()},
    ])
    chunks = chunk_vibe(text, outline=outline)
    canned = [
        {"vreq_id": "V1", "intent": "use snake_case", "target": "naming", "source_quote": "Use snake_case"},
        {"vreq_id": "V2", "intent": "tag prefix acme_", "target": "tag-keys", "source_quote": "Tag prefix `acme_`"},
        {"vreq_id": "V3", "intent": "Add FK from beta.record.* to alpha.entity_one", "target": "beta.record", "source_quote": "FK to alpha.entity_one as defined above"},
    ]
    llm = MockLLM(canned=[_extraction_canned("CHUNK", canned)])
    vreqs = extract_all(chunks, outline, llm, parallel=False)
    intents = [v.intent for v in vreqs]
    assert any("FK" in i and "alpha.entity_one" in i for i in intents)
