"""Endpoint pre-flight + ensemble resolver for the vibe-modelling-agent.

Externalizes LLM endpoint selection so a new workspace needs **no code edits**:

  resolve_ensemble(workspace, override) decides which serving endpoints to use, in
  priority order:
    1. explicit override (the `llm_endpoints` widget / arg, comma-separated)
    2. auto-discovery of chat endpoints actually present on the target workspace
    3. the packaged default list (last resort)

  preflight(...) then verifies every chosen endpoint EXISTS on the workspace and,
  optionally, probes whether it accepts the `temperature` param (Anthropic
  reasoning models reject it — see upstream issue #3). It returns a go/no-go plus
  an actionable message, so a misconfigured run fails in seconds instead of ~10
  min into generation.

Run standalone:  python endpoint_preflight.py [--warehouse <id>] [--probe-temperature]
Import in the agent:  from endpoint_preflight import resolve_ensemble, preflight
"""
from __future__ import annotations

import argparse
import sys

# Role preference: substrings matched against endpoint names, best first.
# "thinker" = large/reasoning stages; "worker" = high-volume cheaper stages.
THINKER_PREF = ["claude-opus", "claude-3-7-sonnet", "gpt-5", "claude-sonnet", "llama-3-3-70b"]
WORKER_PREF = ["claude-sonnet", "claude-3-5", "gpt-5", "gpt-oss", "llama", "claude-opus"]

# Packaged fallback if discovery finds nothing (kept for parity with upstream).
DEFAULT_ENDPOINTS = ["databricks-claude-sonnet-4-5", "databricks-claude-opus-4-5"]

# Endpoints known to reject the `temperature` param (hybrid-reasoning models).
# Heuristic only — preflight(probe_temperature=True) confirms empirically.
_REASONING_HINTS = ("opus-4-7", "opus-4-8", "gpt-5")


def _is_chat(ep) -> bool:
    """True if a serving endpoint looks like an LLM chat endpoint."""
    task = (getattr(ep, "task", None) or "").lower()
    if task:
        return "chat" in task or "llm" in task
    name = (getattr(ep, "name", "") or "").lower()
    return any(k in name for k in ("claude", "gpt", "llama", "gemini", "mixtral", "dbrx", "mistral"))


def discover_chat_endpoints(w) -> list[str]:
    return sorted({ep.name for ep in w.serving_endpoints.list() if ep.name and _is_chat(ep)})


def _pick(available: list[str], pref: list[str]) -> str | None:
    for key in pref:
        for name in available:
            if key in name.lower():
                return name
    return available[0] if available else None


def resolve_ensemble(w=None, override: str | list[str] | None = None,
                     available: list[str] | None = None) -> list[dict]:
    """Return [{name, role, supports_temperature}] for the resolved ensemble.

    `override` wins (widget value). Else discover from the workspace. Else default.
    """
    if isinstance(override, str):
        override = [s.strip() for s in override.split(",") if s.strip()]
    if override:
        chosen = list(override)
    else:
        if available is None:
            available = discover_chat_endpoints(w) if w is not None else []
        thinker = _pick(available, THINKER_PREF)
        worker = _pick(available, WORKER_PREF)
        chosen = [e for e in dict.fromkeys([thinker, worker]) if e] or list(DEFAULT_ENDPOINTS)
    return [
        {"name": e,
         "role": "thinker" if i == 0 else "worker",
         "supports_temperature": not any(h in e.lower() for h in _REASONING_HINTS)}
        for i, e in enumerate(chosen)
    ]


def _exists(w, name: str) -> bool:
    try:
        w.serving_endpoints.get(name)
        return True
    except Exception:
        return False


def _probe_temperature(w, warehouse_id: str, name: str) -> bool | None:
    """True/False if temperature is accepted; None if the probe was inconclusive."""
    def run(with_temp: bool):
        extra = ", 'temperature', 0" if with_temp else ""
        sql = (f"SELECT ai_query('{name}', 'ping', "
               f"modelParameters => named_struct('max_tokens', 5{extra})) AS r")
        r = w.statement_execution.execute_statement(
            warehouse_id=warehouse_id, statement=sql, wait_timeout="30s")
        ok = r.status.state.value == "SUCCEEDED"
        msg = (r.status.error.message if r.status.error else "") or ""
        return ok, msg
    ok_no, _ = run(False)
    if not ok_no:
        return None  # endpoint itself not reachable via ai_query → inconclusive
    ok_yes, msg = run(True)
    if ok_yes:
        return True
    if "temperature" in msg.lower():
        return False
    return None


def preflight(w, override=None, warehouse_id: str | None = None,
              probe_temperature: bool = False) -> dict:
    """Resolve + validate. Returns {ok, ensemble, errors, available}."""
    available = discover_chat_endpoints(w)
    ensemble = resolve_ensemble(w, override=override, available=available)
    errors: list[str] = []
    for m in ensemble:
        if not _exists(w, m["name"]):
            errors.append(f"endpoint '{m['name']}' not found on workspace")
            continue
        if probe_temperature and warehouse_id:
            supports = _probe_temperature(w, warehouse_id, m["name"])
            if supports is not None:
                m["supports_temperature"] = supports
    if not ensemble:
        errors.append("no chat endpoints resolved")
    return {"ok": not errors, "ensemble": ensemble, "errors": errors, "available": available}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--override", default=None, help="comma-separated endpoint override")
    ap.add_argument("--warehouse", default=None, help="SQL warehouse id (for --probe-temperature)")
    ap.add_argument("--probe-temperature", action="store_true")
    args = ap.parse_args()

    from databricks.sdk import WorkspaceClient
    w = WorkspaceClient()
    res = preflight(w, override=args.override, warehouse_id=args.warehouse,
                    probe_temperature=args.probe_temperature)

    print(f"available chat endpoints ({len(res['available'])}):")
    for e in res["available"]:
        print(f"  - {e}")
    print("\nresolved ensemble:")
    for m in res["ensemble"]:
        print(f"  - {m['name']:<34} role={m['role']:<8} supports_temperature={m['supports_temperature']}")
    if res["ok"]:
        print("\nPREFLIGHT: OK ✅  (set llm_endpoints widget to override)")
        return 0
    print("\nPREFLIGHT: FAIL ❌")
    for e in res["errors"]:
        print(f"  ! {e}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
