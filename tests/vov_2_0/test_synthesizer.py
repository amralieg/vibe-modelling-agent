from agent.vov_2_0.llm import CannedResponse, MockLLM
from agent.vov_2_0.synthesizer import synthesize_handler, synthesize_batch_handlers
from agent.vov_2_0.types import Batch
from agent.vov_2_0.sandbox import execute_in_sandbox


def _batch(intent="add pii=true tag", target_entities=(("customer", "*"),), data_payload=()):
    return Batch(
        batch_id="B0001",
        vreq_ids=("VREQ-0001",),
        intent_summary=intent,
        target_entities=target_entities,
        data_payload=data_payload,
    )


def _synth_canned(mutator_src, verifier_src, summary=""):
    return CannedResponse(
        fingerprint_predicate=lambda s: "mutator_source" in s,
        response={
            "mutator_source": mutator_src,
            "verifier_source": verifier_src,
            "expected_changes_summary": summary,
        },
    )


SAFE_PII_MUTATOR = """def mutator(model, data):
    for d in model.get("model", {}).get("domains", []):
        if d.get("name") != "customer":
            continue
        for p in d.get("products", []):
            for a in p.get("attributes", []):
                tags = a.get("tags", "") or ""
                if "pii=true" not in [t.strip() for t in tags.split(",") if t.strip()]:
                    a["tags"] = (tags + ",pii=true") if tags else "pii=true"
    return model
"""


SAFE_PII_VERIFIER = """def verifier(model, data):
    for d in model.get("model", {}).get("domains", []):
        if d.get("name") != "customer":
            continue
        for p in d.get("products", []):
            for a in p.get("attributes", []):
                if "pii=true" not in (a.get("tags", "") or ""):
                    return (False, "missing pii=true on " + d.get("name", "?") + "." + p.get("name", "?") + "." + a.get("name", "?"))
    return (True, "")
"""


def test_synthesize_handler_returns_handler_object():
    llm = MockLLM(canned=[_synth_canned(SAFE_PII_MUTATOR, SAFE_PII_VERIFIER, "tag pii=true on customer attrs")])
    h = synthesize_handler(_batch(), llm)
    assert h.batch_id == "B0001"
    assert "def mutator" in h.mutator_src
    assert "def verifier" in h.verifier_src
    assert "pii" in h.expected_changes_summary


def test_synthesize_handler_runs_through_sandbox():
    llm = MockLLM(canned=[_synth_canned(SAFE_PII_MUTATOR, SAFE_PII_VERIFIER, "")])
    h = synthesize_handler(_batch(), llm)
    model = {
        "model": {"domains": [{"name": "customer", "products": [
            {"name": "customer", "attributes": [{"name": "email", "type": "STRING", "tags": ""}]}
        ]}]}
    }
    result = execute_in_sandbox(h.mutator_src, h.verifier_src, model)
    assert result.ok
    assert result.verifier_ok
    assert "pii=true" in result.new_model["model"]["domains"][0]["products"][0]["attributes"][0]["tags"]


def test_synthesize_handler_propagates_failure_trace_on_retry():
    call_count = [0]
    def predicate(s):
        return "mutator_source" in s

    canned_first = """def mutator(model, data):
    return model
"""
    canned_first_v = """def verifier(model, data):
    return (False, "always fails")
"""
    second_response = {
        "mutator_source": SAFE_PII_MUTATOR,
        "verifier_source": SAFE_PII_VERIFIER,
        "expected_changes_summary": "tag pii=true on customer attrs",
    }

    class _SeqLLM:
        def __init__(self):
            self.call_log = []
            self.responses = [
                {"mutator_source": canned_first, "verifier_source": canned_first_v, "expected_changes_summary": ""},
                second_response,
            ]
            self.idx = 0
        def complete_json(self, system, user, temperature=0.0):
            r = self.responses[min(self.idx, len(self.responses) - 1)]
            self.idx += 1
            self.call_log.append({"system_len": len(system), "user_len": len(user)})
            return r
        def complete_with_tools(self, *a, **kw):
            return self.complete_json("", "")

    llm = _SeqLLM()
    h1 = synthesize_handler(_batch(), llm)
    assert "always fails" in h1.verifier_src
    h2 = synthesize_handler(_batch(), llm, prior_failure_trace="attempt 1: verifier failed: always fails")
    assert "pii=true" in h2.verifier_src
    user_text = llm.call_log[-1]
    assert user_text["user_len"] > llm.call_log[0]["user_len"]


def test_synthesize_batch_handlers_parallel_returns_one_per_batch():
    batches = [
        Batch(batch_id=f"B{i:04d}", vreq_ids=(f"VREQ-{i:04d}",), intent_summary=f"intent {i}",
              target_entities=(("d", "p"),), data_payload=())
        for i in range(5)
    ]
    llm = MockLLM(canned=[_synth_canned(
        "def mutator(model, data):\n    return model\n",
        "def verifier(model, data):\n    return (True, '')\n",
        "noop",
    )])
    handlers = synthesize_batch_handlers(batches, llm, parallel=True, max_workers=4)
    assert len(handlers) == 5
    seen_ids = {h.batch_id for h in handlers}
    assert seen_ids == {b.batch_id for b in batches}


def test_synthesize_batch_handlers_handles_synth_failure_gracefully():
    class _BrokenLLM:
        call_log = []
        def complete_json(self, system, user, temperature=0.0):
            raise RuntimeError("upstream LLM unreachable")
        def complete_with_tools(self, *a, **kw):
            return self.complete_json("", "")

    batches = [Batch("B0001", ("VREQ-0001",), "intent", (("d", "p"),), ())]
    handlers = synthesize_batch_handlers(batches, _BrokenLLM(), parallel=True)
    assert len(handlers) == 1
    h = handlers[0]
    assert "synthesis failed" in h.expected_changes_summary
    assert "def mutator" in h.mutator_src
    assert "def verifier" in h.verifier_src
