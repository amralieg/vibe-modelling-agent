import json
import logging
from pathlib import Path

import pytest

import agent_helpers as ah

REPO = Path(__file__).resolve().parents[2]
NB = REPO / "agent" / "dbx_vibe_modelling_agent.ipynb"
PRE = Path("/tmp/agent_pre_v401.ipynb")  # v4.0.0 backup (pre-preskip)


def _concat(nb_path):
    nb = json.load(open(nb_path))
    return "".join("".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code")


class _SandboxCalled(AssertionError):
    pass


def _raise_sandbox(*a, **k):
    raise _SandboxCalled("execute_in_sandbox was called — pre-skip did NOT short-circuit")


def _raise_synth(*a, **k):
    raise _SandboxCalled("synthesize_handler was called — pre-skip did NOT short-circuit")


def _model(desc):
    # inner model dict shape: top-level 'domains' (NOT wrapped in {'model': ...})
    return {
        "domains": [
            {
                "name": "sales",
                "data_products": [
                    {
                        "name": "order",
                        "description": desc,
                        "attributes": [
                            {"name": "order_id", "is_primary_key": True, "data_type": "BIGINT"},
                        ],
                    }
                ],
            }
        ]
    }


def _batch():
    return ah.Batch(
        batch_id="B1",
        vreq_ids=("VREQ-1",),
        intent_summary="add a description / document the order table",
        target_entities=(("sales", "order"),),
        data_payload=(),
    )


def _handler():
    return ah.Handler(
        batch_id="B1",
        mutator_src="def mutator(model, data):\n    return model\n",
        verifier_src="",
        expected_changes_summary="",
        target_entities=(("sales", "order"),),
    )


@pytest.fixture(autouse=True)
def _isolate(monkeypatch):
    # ensure flag on; patch the LLM + sandbox to raise so any fall-through is provable
    monkeypatch.setattr(ah, "_VOV_DETERMINISTIC_PRESKIP_ENABLED", True, raising=False)
    monkeypatch.setattr(ah, "execute_in_sandbox", _raise_sandbox, raising=False)
    monkeypatch.setattr(ah, "synthesize_handler", _raise_synth, raising=False)
    yield


def _capture_logger(monkeypatch):
    lg = logging.getLogger("v401test")
    lg.setLevel(logging.INFO)
    records = []

    class _Cap(logging.Handler):
        def emit(self, r):
            records.append(r.getMessage())

    lg.handlers = [_Cap()]
    monkeypatch.setattr(ah, "logger", lg, raising=False)
    return records


# ---------------- deterministic probe unit check ----------------

def test_probe_true_when_description_present():
    ok, ev = ah._vov_deterministic_satisfied(_batch(), _handler(), _model("Customer purchase order header."))
    assert ok is True, ev


def test_probe_false_when_description_missing():
    ok, ev = ah._vov_deterministic_satisfied(_batch(), _handler(), _model(""))
    assert ok is False, ev


# ---------------- behavioral: pre-skip avoids the LLM+sandbox ----------------

def test_preskip_credits_applied_without_calling_llm():
    m = _model("Customer purchase order header.")
    new_model, outcome = ah._apply_handler_with_retry(_handler(), _batch(), m, None, object())
    assert outcome.status == "applied", outcome
    assert outcome.attempts == 0, outcome
    assert "deterministic pre-skip" in outcome.diagnostic, outcome.diagnostic
    assert new_model is m  # returned the SAME live model unchanged


def test_preskip_emits_fired_log(monkeypatch):
    records = _capture_logger(monkeypatch)
    ah._apply_handler_with_retry(_handler(), _batch(), _model("documented."), None, object())
    fired = [r for r in records if "vov-deterministic-preskip FIRED v4.0.1" in r]
    assert fired, records


def test_unsatisfied_falls_through_to_llm_sandbox():
    # description missing -> probe False -> pre-skip does NOT fire -> sandbox is invoked (raises sentinel)
    with pytest.raises(_SandboxCalled):
        ah._apply_handler_with_retry(_handler(), _batch(), _model(""), None, object())


def test_killswitch_disables_preskip(monkeypatch):
    monkeypatch.setattr(ah, "_VOV_DETERMINISTIC_PRESKIP_ENABLED", False, raising=False)
    # even though the model IS satisfied, the disabled pre-skip lets it fall through to the sandbox
    with pytest.raises(_SandboxCalled):
        ah._apply_handler_with_retry(_handler(), _batch(), _model("documented."), None, object())


# ---------------- version + fail-pre ----------------

def test_version_bumped_to_401():
    assert '__AGENT_VERSION__ = "4.0.1"' in _concat(NB)


def test_failpre_preskip_absent_in_v400_backup():
    if not PRE.exists():
        pytest.skip("v4.0.0 backup not present")
    src = _concat(PRE)
    assert "_VOV_DETERMINISTIC_PRESKIP_ENABLED" not in src
    assert "vov-deterministic-preskip FIRED v4.0.1" not in src
