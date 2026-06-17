"""Behavioral tests for v3.7.0 alias=selffixer-endpoint-default-fallback.

ROOT CAUSE this fixes (live, ncdot base-MVM run 1100641407727378 @ fe-gcp, v3.6.9):
the SelfFixer endpoint cascade in __init__ resolved NOTHING --
`_select_model_for_requirement(thinker/worker, large)` AND the `_models_lookup`
scan both returned empty because the v3.0.4 model-discovery step marked the live
catalog broken / type-classified the working endpoint out. self.llm_endpoint
stayed None, so `_call_opus` (v3.6.5) routed to the Spark `_call_ai_query` UDF,
which threw `REMOTE_FUNCTION_HTTP` SparkException repeatedly, landed 0 repairs,
and left N2 fidelity stuck at precision 0.6364 < 0.85 (the root cause of BOTH
nc-fidelity and nc-drift).

THE FIX: add a final resolution tier that reads the SAME authoritative widget
endpoint the main synthesis path uses -- `ai_agent._default_model_config` then
`ai_agent.llm_config` `llm_endpoint_name` (= databricks-claude-opus-4-8, which
demonstrably built the entire model on that workspace). It is NOT broken-filtered:
the default endpoint is ground truth and model-discovery's broken-mark was the
false-negative being corrected. With an endpoint now resolved, `_call_opus` uses
the proven HTTP-direct `_v207_call_llm_spark_free` path, avoiding the flaky UDF.

These tests extract the REAL SelfFixer from the notebook. They FAIL on pre-v3.7.0
HEAD (cascade misses -> endpoint None even though the default config has a working
endpoint) and PASS post-fix, while a cascade HIT is NOT overridden (selectivity,
no tautology) and an agent with NO default config stays None (no fabrication).
"""
import json
import os
import re

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")
DEFAULT_EP = "databricks-claude-opus-4-8"


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _extract_class(name):
    src = _src()
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


class _Agent:
    """Configurable fake. `cascade_ep` controls the _select_model_for_requirement /
    _models_lookup cascade (None => MISS, mirrors fe-gcp). `default_cfg` / `llm_cfg`
    set the authoritative widget endpoint the main synthesis path uses."""

    def __init__(self, cascade_ep=None, default_cfg=None, llm_cfg=None):
        self.calls = []
        self._cascade_ep = cascade_ep
        self._models_lookup = {}
        if default_cfg is not None:
            self._default_model_config = default_cfg
        if llm_cfg is not None:
            self.llm_config = llm_cfg

    def _select_model_for_requirement(self, t, s, skip_broken=True):
        if self._cascade_ep:
            return {"llm_endpoint_name": self._cascade_ep}
        return None

    def _v207_call_llm_spark_free(self, model=None, **kw):
        self.calls.append(("v207", model))
        if not model:
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


# ── static: the new tier is wired + carries the alias ─────────────────────────

def test_default_fallback_alias_and_wiring_present():
    src = _src()
    assert "selffixer-endpoint-default-fallback" in src
    assert '"_default_model_config", "llm_config"' in src, "must read both config sources"
    assert "default-fallback:" in src, "must record the resolution path"


# ── behavior (the fix): cascade MISS but default config has a working endpoint ──

def test_default_fallback_resolves_from_default_model_config():
    SelfFixer = _load_selffixer()
    agent = _Agent(cascade_ep=None, default_cfg={"llm_endpoint_name": DEFAULT_EP})
    fx = SelfFixer(agent, _CapLogger())
    assert fx.llm_endpoint == DEFAULT_EP, (
        "cascade MISS must fall back to _default_model_config endpoint (the one that built the model)"
    )


def test_default_fallback_resolves_from_llm_config_when_no_default():
    SelfFixer = _load_selffixer()
    agent = _Agent(cascade_ep=None, llm_cfg={"llm_endpoint_name": DEFAULT_EP})
    fx = SelfFixer(agent, _CapLogger())
    assert fx.llm_endpoint == DEFAULT_EP, "must also resolve from llm_config when _default_model_config absent"


def test_default_model_config_takes_precedence_over_llm_config():
    SelfFixer = _load_selffixer()
    agent = _Agent(cascade_ep=None,
                   default_cfg={"llm_endpoint_name": DEFAULT_EP},
                   llm_cfg={"llm_endpoint_name": "databricks-other"})
    fx = SelfFixer(agent, _CapLogger())
    assert fx.llm_endpoint == DEFAULT_EP, "_default_model_config is tried first"


# ── downstream benefit: a resolved endpoint forces the HTTP-direct path ────────

def test_default_fallback_forces_v207_http_path():
    SelfFixer = _load_selffixer()
    agent = _Agent(cascade_ep=None, default_cfg={"llm_endpoint_name": DEFAULT_EP})
    fx = SelfFixer(agent, _CapLogger())
    fx._call_opus("REQ1", "req text", "evidence", "digest")
    kinds = [c[0] for c in agent.calls]
    assert kinds and kinds[0] == "v207", (
        f"with the default endpoint resolved, SelfFixer must use the proven HTTP path, not the Spark UDF; calls={agent.calls}"
    )
    assert ("v207", DEFAULT_EP) in agent.calls, f"must POST to the resolved endpoint, not None; calls={agent.calls}"


# ── selectivity (no tautology): a cascade HIT is NOT overridden by the default ─

def test_cascade_hit_not_overridden_by_default():
    SelfFixer = _load_selffixer()
    agent = _Agent(cascade_ep="databricks-claude-sonnet-4-5",
                   default_cfg={"llm_endpoint_name": DEFAULT_EP})
    fx = SelfFixer(agent, _CapLogger())
    assert fx.llm_endpoint == "databricks-claude-sonnet-4-5", (
        "when the cascade resolves, the default-fallback tier must NOT override it"
    )


# ── no fabrication: no config anywhere stays None (graceful -> aiquery route) ──

def test_no_config_anywhere_stays_none():
    SelfFixer = _load_selffixer()
    agent = _Agent(cascade_ep=None)  # no default_cfg, no llm_cfg
    fx = SelfFixer(agent, _CapLogger())
    assert fx.llm_endpoint is None, "must not fabricate an endpoint when none is configured anywhere"


def test_empty_endpoint_name_does_not_resolve():
    SelfFixer = _load_selffixer()
    agent = _Agent(cascade_ep=None, default_cfg={"llm_endpoint_name": "   "})
    fx = SelfFixer(agent, _CapLogger())
    assert fx.llm_endpoint is None, "a blank/whitespace endpoint name must be ignored"
