import json
from pathlib import Path

import pytest

NB_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _full_src():
    return "".join(
        "".join(c.get("source", []))
        for c in json.loads(NB_PATH.read_text()).get("cells", [])
        if c.get("cell_type") == "code"
    )


class _L:
    def info(self, *a, **k): pass
    def warning(self, *a, **k): pass
    def error(self, *a, **k): pass


def _model():
    return {
        "model": {
            "domains": [
                {"name": "procurement", "products": [
                    {"name": "benefit_plan", "primary_key": "benefit_plan_id",
                     "attributes": [{"name": "benefit_plan_id", "type": "BIGINT"}]}
                ]},
                {"name": "workforce", "products": [
                    {"name": "employee", "primary_key": "employee_id",
                     "attributes": [{"name": "employee_id", "type": "BIGINT"}]}
                ]},
            ]
        }
    }


# --- static wiring proof: the deterministic fast-path is called at the TOP of _fix_one_req,
#     before the retry/sandbox loop (so it is not dead code) ---
def test_call_site_precedes_sandbox_loop():
    src = _full_src()
    head = src.find("def _fix_one_req(self")
    assert head != -1
    call = src.find("_v410_deterministic_selffix(model, req, self.logger)", head)
    loop = src.find("for attempt in range(per_req_retries", head)
    sandbox = src.find("self.sandbox_executor", head)
    assert call != -1 and loop != -1
    assert head < call < loop, "deterministic fast-path must run before the retry/sandbox loop"
    assert call < sandbox, "deterministic fast-path must run before any sandbox use"


# --- behavioral: a move VReq lands via the deterministic path WITHOUT touching the sandbox.
#     The sandbox_executor RAISES; if the deterministic path did not short-circuit, the test
#     would surface that error instead of a clean success. ---
def test_move_req_lands_without_sandbox():
    import agent_helpers as ah
    if not hasattr(ah, "SelfFixer"):
        pytest.skip("SelfFixer not loaded in agent_helpers")

    def _boom(*a, **k):
        raise AssertionError("sandbox must NOT be reached for a deterministic move VReq")

    fixer = ah.SelfFixer(ai_agent=None, logger=_L(), sandbox_executor=_boom)
    model = _model()
    req = {"id": "VREQ-046",
           "text": "P17: Move the product procurement.benefit_plan to the workforce domain "
                   "because benefit plans are an HR function."}
    ok, applied, ev = fixer._fix_one_req(model, req, per_req_retries=2)
    assert ok is True, ev
    proc = [d for d in model["model"]["domains"] if d["name"] == "procurement"][0]
    work = [d for d in model["model"]["domains"] if d["name"] == "workforce"][0]
    assert all(p["name"] != "benefit_plan" for p in proc.get("products", []))
    assert any(p["name"] == "benefit_plan" for p in work.get("products", []))


# --- behavioral: a generative req falls through (deterministic returns None); with a None
#     sandbox the LLM path cannot run, so it must NOT report a deterministic success. ---
def test_generative_req_does_not_deterministically_fix():
    import agent_helpers as ah
    if not hasattr(ah, "SelfFixer"):
        pytest.skip("SelfFixer not loaded in agent_helpers")
    fixer = ah.SelfFixer(ai_agent=None, logger=_L(), sandbox_executor=None)
    model = _model()
    req = {"id": "VREQ-099",
           "text": "Expand procurement.benefit_plan with additional relevant business attributes."}
    ok, applied, ev = fixer._fix_one_req(model, req, per_req_retries=0)
    # deterministic path abstains; sandbox is None so no fix lands -> ok is False
    assert ok is False
