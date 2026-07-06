"""Parallel-execution determinism tests.

Verify the pipeline produces equivalent final models whether run serially or in parallel.
Verify the planner partitions handlers so that no two parallel handlers conflict on the
same target entity.
"""
import copy

from vov_2_0.pipeline import run_vov_pipeline
from vov_2_0.planner import plan_waves, _conflicts, _entities_set
from vov_2_0.types import Handler


def _initial_model():
    return {"agent_version": "2.0.0", "model": {"domains": [
        {"name": f"d{i}", "products": [
            {"name": f"p{j}", "tags": "", "attributes": [
                {"name": f"a{k}", "type": "BIGINT", "tags": "", "foreign_key_to": ""}
                for k in range(2)
            ]} for j in range(2)
        ]} for i in range(4)
    ], "metric_views": []}}


SAFE_NOOP_MUTATOR = "def mutator(model, data):\n    return model\n"
SAFE_TRUE_VERIFIER = "def verifier(model, data):\n    return (True, '')\n"


class _DisjointBatchLLM:
    def __init__(self, n_batches=4):
        self.n_batches = n_batches
        self.call_log = []

    def complete_json(self, system, user, temperature=0.0):
        if "STRUCTURED OUTLINE" in system:
            return {"sections": [{"section_id": "S1", "title": "x", "summary": "", "declared_entities": [], "cross_references": [], "constraints": []}], "global_constraints": [], "declared_entities_global": []}
        if "RawVREQ" in system:
            return {"vreqs": [{"vreq_id": f"V{i}", "intent": f"Add tag mark{i}=true to d{i} products", "target": f"d{i}.*", "source_quote": "..."} for i in range(self.n_batches)]}
        if "group VREQs into BATCHES" in system:
            return {"batches": [
                {"batch_id": f"B{i:04d}", "vreq_ids": [f"VREQ-{i+1:04d}"], "intent_summary": f"tag mark{i}=true on d{i}.*", "target_entities": [[f"d{i}", "*"]], "data_payload": [{"domain": f"d{i}", "tag": f"mark{i}=true"}]}
                for i in range(self.n_batches)
            ]}
        if "mutator_source" in user:
            mutator = """def mutator(model, data):
    spec = (data or [{}])[0]
    target_dom = spec.get('domain', '')
    tag_to_add = spec.get('tag', '')
    for d in model.get('model', {}).get('domains', []):
        if d.get('name') != target_dom:
            continue
        for p in d.get('products', []):
            tags = (p.get('tags', '') or '').split(',')
            tags = [t for t in tags if t.strip()]
            if tag_to_add not in tags:
                tags.append(tag_to_add)
                p['tags'] = ','.join(tags)
    return model
"""
            verifier = """def verifier(model, data):
    spec = (data or [{}])[0]
    target_dom = spec.get('domain', '')
    tag_to_add = spec.get('tag', '')
    for d in model.get('model', {}).get('domains', []):
        if d.get('name') != target_dom:
            continue
        for p in d.get('products', []):
            if tag_to_add not in (p.get('tags', '') or ''):
                return (False, 'missing on ' + p.get('name', ''))
        return (True, '')
    return (False, 'domain not found: ' + target_dom)
"""
            return {"mutator_source": mutator, "verifier_source": verifier, "expected_changes_summary": "tag application on a single domain"}
        return {}

    def complete_with_tools(self, system="", user="", tools=None, tool_handlers=None, max_iters=6, temperature=0.0):
        return self.complete_json(system, user, temperature)


def test_parallel_pipeline_equivalent_to_serial():
    initial = _initial_model()
    serial = run_vov_pipeline(
        vibe_text="dummy vibe",
        initial_model=copy.deepcopy(initial),
        llm=_DisjointBatchLLM(n_batches=4),
        user_pinned_domains=[f"d{i}" for i in range(4)],
        user_pinned_products=[],
        parallel=False,
    )
    parallel = run_vov_pipeline(
        vibe_text="dummy vibe",
        initial_model=copy.deepcopy(initial),
        llm=_DisjointBatchLLM(n_batches=4),
        user_pinned_domains=[f"d{i}" for i in range(4)],
        user_pinned_products=[],
        parallel=True,
    )
    assert serial.coverage_pct == parallel.coverage_pct
    serial_statuses = sorted(o.status for o in serial.outcomes)
    parallel_statuses = sorted(o.status for o in parallel.outcomes)
    assert serial_statuses == parallel_statuses


def test_planner_groups_disjoint_into_one_wave():
    handlers = [
        Handler(batch_id=f"B{i}",
                mutator_src=SAFE_NOOP_MUTATOR,
                verifier_src=SAFE_TRUE_VERIFIER,
                expected_changes_summary="",
                target_entities=((f"d{i}", "*"),))
        for i in range(8)
    ]
    waves = plan_waves(handlers)
    assert len(waves) == 1
    assert len(waves[0]) == 8


def test_planner_serializes_overlapping_into_separate_waves():
    handlers = [
        Handler(batch_id="B1", mutator_src=SAFE_NOOP_MUTATOR, verifier_src=SAFE_TRUE_VERIFIER,
                expected_changes_summary="", target_entities=(("hr", "employee"),)),
        Handler(batch_id="B2", mutator_src=SAFE_NOOP_MUTATOR, verifier_src=SAFE_TRUE_VERIFIER,
                expected_changes_summary="", target_entities=(("hr", "employee"),)),
        Handler(batch_id="B3", mutator_src=SAFE_NOOP_MUTATOR, verifier_src=SAFE_TRUE_VERIFIER,
                expected_changes_summary="", target_entities=(("hr", "employee"),)),
    ]
    waves = plan_waves(handlers)
    assert len(waves) == 3


def test_no_two_handlers_in_same_wave_conflict():
    handlers = [
        Handler(batch_id="B1", mutator_src=SAFE_NOOP_MUTATOR, verifier_src=SAFE_TRUE_VERIFIER,
                expected_changes_summary="", target_entities=(("hr", "employee"),)),
        Handler(batch_id="B2", mutator_src=SAFE_NOOP_MUTATOR, verifier_src=SAFE_TRUE_VERIFIER,
                expected_changes_summary="", target_entities=(("hr", "position"),)),
        Handler(batch_id="B3", mutator_src=SAFE_NOOP_MUTATOR, verifier_src=SAFE_TRUE_VERIFIER,
                expected_changes_summary="", target_entities=(("hr", "*"),)),
        Handler(batch_id="B4", mutator_src=SAFE_NOOP_MUTATOR, verifier_src=SAFE_TRUE_VERIFIER,
                expected_changes_summary="", target_entities=(("project", "*"),)),
        Handler(batch_id="B5", mutator_src=SAFE_NOOP_MUTATOR, verifier_src=SAFE_TRUE_VERIFIER,
                expected_changes_summary="", target_entities=(("*", "*"),)),
    ]
    waves = plan_waves(handlers)
    for wave in waves:
        for i in range(len(wave)):
            for j in range(i + 1, len(wave)):
                ei = _entities_set(wave[i].target_entities)
                ej = _entities_set(wave[j].target_entities)
                assert not _conflicts(ei, ej), f"wave conflict between {wave[i].batch_id} and {wave[j].batch_id}"
