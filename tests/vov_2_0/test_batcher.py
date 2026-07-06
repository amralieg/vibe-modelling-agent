from agent.vov_2_0.batcher import (
    batch_vreqs,
    deterministic_pre_group,
    _heuristic_batch,
)
from agent.vov_2_0.llm import CannedResponse, MockLLM
from agent.vov_2_0.types import RawVREQ


def _v(vid, intent, target="x", quote="..."):
    return RawVREQ(vreq_id=vid, intent=intent, target=target, source_quote=quote, source_chunk_id="C1")


def test_pre_group_separates_tag_from_fk_from_metric_view():
    vreqs = [
        _v("V1", "Add tag ncdot_source_table=emp_history at table level"),
        _v("V2", "Add tag ncdot_source_attribute=Employee_ID at attribute level"),
        _v("V3", "Connect FK from claim.encounter_id to encounter.encounter.encounter_id"),
        _v("V4", "Build metric view KPI-1 Vacancy Rate"),
        _v("V5", "Rename product foo to bar"),
        _v("V6", "Use snake_case naming"),
    ]
    groups = deterministic_pre_group(vreqs)
    assert "tag_apply" in groups and len(groups["tag_apply"]) == 2
    assert "fk" in groups and len(groups["fk"]) == 1
    assert "metric_view" in groups and len(groups["metric_view"]) == 1
    assert "rename" in groups and len(groups["rename"]) == 1


def test_heuristic_batch_handles_empty():
    out = _heuristic_batch([])
    assert out == []


def test_heuristic_batch_assigns_unique_batch_ids():
    vreqs = [_v(f"V{i}", f"Add tag ncdot_source_table=t{i} at table level") for i in range(10)]
    batches = _heuristic_batch(vreqs)
    ids = [b.batch_id for b in batches]
    assert len(set(ids)) == len(ids)
    assert all(b.batch_id.startswith("B") for b in batches)


def test_heuristic_batch_chunks_large_groups():
    vreqs = [_v(f"V{i}", f"Add tag ncdot_source_attribute=col{i} at attribute level") for i in range(50)]
    batches = _heuristic_batch(vreqs)
    assert len(batches) >= 2
    for b in batches:
        assert len(b.vreq_ids) <= 25


def test_batch_vreqs_no_llm_falls_back_to_heuristic():
    vreqs = [
        _v("V1", "Add tag ncdot_source_table=emp_history"),
        _v("V2", "Use snake_case naming"),
    ]
    batches = batch_vreqs(vreqs, llm=None)
    assert len(batches) >= 1
    all_ids = []
    for b in batches:
        all_ids.extend(b.vreq_ids)
    assert "V1" in all_ids and "V2" in all_ids


def test_batch_vreqs_preserves_all_vreqs():
    vreqs = [_v(f"V{i}", f"Add tag ncdot_source_table=t{i}") for i in range(8)]
    batches = batch_vreqs(vreqs, llm=None)
    seen = set()
    for b in batches:
        for vid in b.vreq_ids:
            seen.add(vid)
    assert seen == {f"V{i}" for i in range(8)}


def test_batch_vreqs_llm_canned_response():
    canned_batch = {
        "batches": [
            {
                "batch_id": "B1",
                "vreq_ids": ["V1", "V2"],
                "intent_summary": "Add table-level ncdot_source_table tag for HR products",
                "target_entities": [["hr", "*"]],
                "data_payload": [
                    {"product": "emp_history", "source_table": "emp_history"},
                ],
            }
        ]
    }
    llm = MockLLM(canned=[CannedResponse(
        fingerprint_predicate=lambda s: "group VREQs into BATCHES" in s,
        response=canned_batch,
    )])
    vreqs = [
        _v("V1", "Add tag ncdot_source_table=emp_history"),
        _v("V2", "Add tag ncdot_source_table=emp_history"),
    ]
    batches = batch_vreqs(vreqs, llm=llm)
    assert len(batches) >= 1
    b = batches[0]
    assert b.target_entities == (("hr", "*"),)
    assert any(d.get("product") == "emp_history" for d in b.data_payload)


def test_batch_vreqs_handles_llm_exception_gracefully():
    class _ThrowingLLM:
        call_log = []
        def complete_json(self, system, user, temperature=0.0):
            raise RuntimeError("simulated LLM failure")
        def complete_with_tools(self, *a, **kw):
            return self.complete_json("", "")
    vreqs = [_v("V1", "Add tag ncdot_source_table=emp_history")]
    batches = batch_vreqs(vreqs, llm=_ThrowingLLM())
    assert len(batches) >= 1


def test_batch_vreqs_propagates_data_payload_correctly():
    canned_batch = {
        "batches": [
            {
                "batch_id": "B1",
                "vreq_ids": ["V1", "V2", "V3"],
                "intent_summary": "Apply ncdot_business_glossary_term tag to attrs from CDE rows",
                "target_entities": [["hr", "*"]],
                "data_payload": [
                    {"cde_id": "CDE-1", "business_data_element": "Organizational Unit"},
                    {"cde_id": "CDE-2", "business_data_element": "Employee"},
                    {"cde_id": "CDE-3", "business_data_element": "Job"},
                ],
            }
        ]
    }
    llm = MockLLM(canned=[CannedResponse(
        fingerprint_predicate=lambda s: "group VREQs into BATCHES" in s,
        response=canned_batch,
    )])
    vreqs = [_v(f"V{i+1}", f"Apply ncdot_business_glossary_term=CDE-{i+1} tag") for i in range(3)]
    batches = batch_vreqs(vreqs, llm=llm)
    b = batches[0]
    assert len(b.data_payload) == 3
    cde_ids = [d.get("cde_id") for d in b.data_payload]
    assert cde_ids == ["CDE-1", "CDE-2", "CDE-3"]
