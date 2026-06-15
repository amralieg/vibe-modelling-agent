"""Behavioral tests for v3.6.5 alias=selffixer-route-aiquery-on-unresolved-endpoint.

ROOT CAUSE this fixes (live, ncdot base-MVM run 748921978115629 @ fe-gcp):
the SelfFixer (closed-loop residual VREQ repair, the LARGEST adherence lever per
CLAUDE.md MISSION) was INERT. SelfFixer.__init__ logged
`[selffixer-endpoint-resolve MISS]` -> self.llm_endpoint stayed None, BUT
`_call_opus` still PREFERRED the spark-free HTTP path purely on
`hasattr(self.ai_agent, "_v207_call_llm_spark_free")` (always True on the real
AIAgent). It therefore POSTed to `/serving-endpoints/None/invocations` and got
`NotFound` on every failed VREQ -> ncdot shipped 60.87% verified adherence
("DEAD AGENTIC REPAIR"). The proven main path `_call_ai_query` (which built the
ENTIRE model on the same workspace, self-resolving the model via
`_get_model_config_for_prompt` -> default databricks-claude-sonnet-4-5) was only
the unreachable elif fallback.

THE FIX: gate the `_v207` branch on `self.llm_endpoint AND hasattr(...)`. An
UNRESOLVED endpoint now falls through to `_call_ai_query` instead of POSTing to a
literal 'None' endpoint. Behaviour is UNCHANGED when an endpoint DID resolve.

These tests extract the REAL SelfFixer class from the notebook and exercise the
two methods involved (`__init__` endpoint-resolve + `_call_opus` routing) with a
recording fake ai_agent. They FAIL on pre-v3.6.5 HEAD (unresolved endpoint POSTs
to `_v207` with model=None) and PASS post-fix, while the resolved-endpoint case
STILL prefers `_v207` (proves the fix is selective, not a blanket disable).
"""
import json
import os
import re

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _extract_class(name):
    src = _src()
    # Capture from `class <name>` up to the next TOP-LEVEL def/class (methods are
    # indented so `\ndef `/`\nclass ` only match column-0 boundaries).
    m = re.search(r"\nclass " + re.escape(name) + r"\b[\s\S]*?\n(?=\n(?:class |def )[A-Za-z_])", "\n" + src)
    assert m, f"class {name} not found in notebook"
    return m.group(0).lstrip("\n")


def _load_selffixer():
    g = {
        "_SELFFIXER_PROMPT": "__REQ_ID__|__REQ_TEXT__|__REQ_EVIDENCE__",
        "_SELFFIXER_RESPONSE_SCHEMA": {},
        "_sf_json": json,
        "_sf_re": re,
    }
    exec(_extract_class("SelfFixer"), g)
    return g["SelfFixer"]


_GOOD_JSON = '{"mutator_src": "model", "verifier_src": "True", "rationale": "ok"}'


class _RecAgent:
    """Records which LLM path SelfFixer chose. `resolve` controls whether the
    __init__ endpoint cascade finds a serving-endpoint NAME (mirrors a workspace
    that exposes named serving endpoints vs one that only serves via ai_query)."""

    def __init__(self, resolve):
        self.calls = []
        self._resolve = resolve
        self._models_lookup = {}

    def _select_model_for_requirement(self, t, s, skip_broken=True):
        if self._resolve:
            return {"llm_endpoint_name": "databricks-claude-sonnet-4-5"}
        return None

    def _v207_call_llm_spark_free(self, model=None, **kw):
        self.calls.append(("v207", model))
        if not model:
            # Mirror production: POST /serving-endpoints/None/invocations -> NotFound
            raise RuntimeError("NotFound: serving endpoint 'None' does not exist")
        return _GOOD_JSON

    def _call_ai_query(self, prompt_name=None, prompt=None, response_schema=None,
                       step_name=None, max_retries=1):
        self.calls.append(("aiquery", prompt_name))
        return _GOOD_JSON


class _CapLogger:
    def __init__(self):
        self.lines = []

    def info(self, m):
        self.lines.append(("INFO", m))

    def warning(self, m):
        self.lines.append(("WARN", m))

    def error(self, m):
        self.lines.append(("ERROR", m))


# ── static: the gate is wired at the call site + carries the alias ────────────

def test_call_opus_gates_v207_on_resolved_endpoint():
    src = _src()
    assert 'if self.llm_endpoint and hasattr(self.ai_agent, "_v207_call_llm_spark_free")' in src, (
        "the _v207 branch must be gated on a resolved llm_endpoint, not hasattr alone"
    )
    assert "selffixer-route-aiquery-on-unresolved-endpoint" in src


# ── behavior (the fix): unresolved endpoint routes to the proven ai_query path ─

def test_unresolved_endpoint_routes_to_aiquery():
    SelfFixer = _load_selffixer()
    agent = _RecAgent(resolve=False)
    fx = SelfFixer(agent, _CapLogger())
    assert fx.llm_endpoint is None, "precondition: endpoint resolve MISSES (mirrors fe-gcp)"

    parsed = fx._call_opus("REQ1", "req text", "evidence", "digest")

    kinds = [c[0] for c in agent.calls]
    assert "aiquery" in kinds, f"unresolved endpoint must route to _call_ai_query; calls={agent.calls}"
    assert ("v207", None) not in agent.calls, (
        f"must NOT POST to _v207 with model=None (the NotFound bug); calls={agent.calls}"
    )
    assert parsed.get("rationale") == "ok"


# ── selectivity (no tautology): a resolved endpoint STILL prefers the HTTP path ─

def test_resolved_endpoint_still_prefers_v207():
    SelfFixer = _load_selffixer()
    agent = _RecAgent(resolve=True)
    fx = SelfFixer(agent, _CapLogger())
    assert fx.llm_endpoint, "precondition: endpoint resolved to a serving-endpoint name"

    fx._call_opus("REQ1", "req text", "evidence", "digest")

    kinds = [c[0] for c in agent.calls]
    assert kinds and kinds[0] == "v207", (
        f"a resolved endpoint must keep the spark-free HTTP path (fix is selective); calls={agent.calls}"
    )
    assert "aiquery" not in kinds, f"must not fall back when the endpoint works; calls={agent.calls}"
