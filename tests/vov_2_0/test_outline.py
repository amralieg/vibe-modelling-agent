from agent.vov_2_0.llm import CannedResponse, MockLLM
from agent.vov_2_0.outline import build_outline
from tests.vov_2_0.fixtures.simulated_vibes import HEALTHCARE_VIBE, NCDOT_MINIMAL, EMPTY_VIBE


def _outline_canned(response):
    return CannedResponse(fingerprint_predicate=lambda s: "STRUCTURED OUTLINE" in s, response=response)


def test_build_outline_aligns_to_real_byte_offsets():
    response = {
        "sections": [
            {"section_id": "S1", "title": "Healthcare data model", "summary": "intro", "declared_entities": ["patient", "encounter", "claim"], "cross_references": [], "constraints": []},
        ],
        "global_constraints": [],
        "declared_entities_global": ["patient", "encounter", "claim"],
    }
    llm = MockLLM(canned=[_outline_canned(response)])
    outline = build_outline(HEALTHCARE_VIBE, llm)
    assert len(outline.sections) >= 1
    s = outline.section("S1")
    assert s is not None
    assert s.title == "Healthcare data model"
    assert s.byte_end > s.byte_start


def test_build_outline_falls_back_when_llm_returns_garbage():
    llm = MockLLM(canned=[_outline_canned("not a dict")])
    outline = build_outline(NCDOT_MINIMAL, llm)
    assert len(outline.sections) >= 1
    assert outline.full_text == NCDOT_MINIMAL


def test_build_outline_section_text_extracts_correct_slice():
    response = {
        "sections": [
            {"section_id": "S1", "title": "NCDOT — base model", "summary": "", "declared_entities": [], "cross_references": [], "constraints": []},
            {"section_id": "S2", "title": "Tag prefix", "summary": "", "declared_entities": [], "cross_references": [], "constraints": ["ncdot_ prefix"]},
        ],
        "global_constraints": ["ncdot_ tag prefix"],
        "declared_entities_global": [],
    }
    llm = MockLLM(canned=[_outline_canned(response)])
    outline = build_outline(NCDOT_MINIMAL, llm)
    s2 = outline.section("S2")
    if s2 and s2.byte_end > s2.byte_start:
        assert "ncdot_" in outline.section_text("S2") or "Tag prefix" in outline.section_text("S2")


def test_build_outline_global_constraints_preserved():
    response = {
        "sections": [],
        "global_constraints": ["snake_case", "tag prefix ncdot_", "PK suffix _id"],
        "declared_entities_global": ["hr", "project"],
    }
    llm = MockLLM(canned=[_outline_canned(response)])
    outline = build_outline(NCDOT_MINIMAL, llm)
    assert "snake_case" in outline.global_constraints
    assert "tag prefix ncdot_" in outline.global_constraints
    assert "hr" in outline.declared_entities_global


def test_build_outline_find_entity():
    response = {
        "sections": [
            {"section_id": "S1", "title": "Domains", "summary": "", "declared_entities": ["hr", "project"], "cross_references": [], "constraints": []},
            {"section_id": "S2", "title": "HR products", "summary": "", "declared_entities": ["employee", "position", "job"], "cross_references": [], "constraints": []},
        ],
        "global_constraints": [],
        "declared_entities_global": ["hr", "project", "employee", "position", "job"],
    }
    llm = MockLLM(canned=[_outline_canned(response)])
    outline = build_outline(NCDOT_MINIMAL, llm)
    found = outline.find_entity("employee")
    assert any(s.section_id == "S2" for s in found)


def test_build_outline_empty_vibe():
    llm = MockLLM(canned=[_outline_canned({"sections": [], "global_constraints": [], "declared_entities_global": []})])
    outline = build_outline(EMPTY_VIBE, llm)
    assert outline.full_text == ""
    assert outline.sections


def test_build_outline_normalizes_string_or_list_entities():
    response = {
        "sections": [
            {"section_id": "S1", "title": "Stuff", "summary": "", "declared_entities": "single_entity_as_string", "cross_references": [], "constraints": []},
        ],
        "global_constraints": "snake_case",
        "declared_entities_global": ["a"],
    }
    llm = MockLLM(canned=[_outline_canned(response)])
    outline = build_outline(NCDOT_MINIMAL, llm)
    s = outline.section("S1")
    assert s is not None
    assert "single_entity_as_string" in s.declared_entities
    assert "snake_case" in outline.global_constraints
