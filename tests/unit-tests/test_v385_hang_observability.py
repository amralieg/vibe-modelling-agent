"""
v3.8.5 behavioral test for the self-cancel hang-observability root-cause fix
(alias=self-cancel-vol-log / self-cancel-subproc-sentinel).

ROOT CAUSE (ncdot v3.8.4 run + healthcare v3.8.3 run both hung ~4h past FINAL-FLUSH):
the v3.8.4 control-plane self-cancel was INERT and UNDIAGNOSABLE. The watchdog armed the
REST runs/cancel branch ONLY when _SELF_CANCEL_CTX had run_id+host+token; when capture
failed silently (it ran before logger init, print()ed to driver stdout that is never
exposed mid-run, every failure swallowed by except:pass), the gate fell to a SILENT skip
and only the serverless-ineffective SIGTERM/SIGKILL child armed -> the multi-hour hang,
with ZERO volume evidence of why.

FIX: _spawn_process_kill_watchdog takes a `logger` and routes the arm decision through the
VOLUME logger -- ARMED (with run_id source) when ctx is complete, and NOT-ARMED (with the
exact missing fields + the capture _diag tag-key dump) when ctx is incomplete. The cancel
subprocess writes its HTTP result to a volume sentinel (env SCW_SENTINEL) instead of DEVNULL.

These tests prove fail-pre/pass-post:
  - test_accepts_logger_param: the function signature now accepts logger= (pre-patch the
    keyword did not exist -> TypeError).
  - test_not_armed_emits_diag_to_logger: an INCOMPLETE ctx now emits a NOT-ARMED warning
    carrying missing=run_id + diag tag keys (pre-patch this path was a silent skip with no
    logger call at all).
  - test_armed_passes_sentinel_env_to_subprocess: a COMPLETE ctx emits ARMED and the cancel
    subprocess receives SCW_RUNID + SCW_SENTINEL in its env (pre-patch: DEVNULL, no sentinel).
"""
import inspect
import json
import os
import sys
import textwrap
import types

import pytest

REPO = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_watchdog():
    """Extract _spawn_process_kill_watchdog from the notebook and exec it in isolation.

    The function imports subprocess + faulthandler INTERNALLY and (if real) would spawn a
    SIGTERM/SIGKILL child against pytest and arm faulthandler exit -- both fatal to the test
    runner. Callers MUST stub sys.modules['subprocess'] and ['faulthandler'] before invoking.
    """
    nb = json.load(open(NB))
    src = "\n".join("".join(c.get("source", [])) for c in nb["cells"] if c["cell_type"] == "code")
    i = src.find("\ndef _spawn_process_kill_watchdog(")
    assert i != -1, "_spawn_process_kill_watchdog missing"
    ls = i + 1
    k = src.find("\ndef ", ls + 1)
    end = k if k != -1 else len(src)
    body = textwrap.dedent(src[ls:end])
    ns = {"_SELF_CANCEL_CTX": {}}
    exec(compile(body, "<watchdog>", "exec"), ns)
    return ns


class _FakeHandler:
    baseFilename = "/tmp/v385_hang_test/healthcare_info_v1_mvm.log"


class _FakeLogger:
    def __init__(self):
        self.warnings = []
        self.handlers = [_FakeHandler()]

    def warning(self, msg):
        self.warnings.append(str(msg))


class _FakePopen:
    """Records the env each spawn was given; never starts a real process."""

    instances = []

    def __init__(self, args, **kwargs):
        _FakePopen.instances.append(kwargs.get("env") or {})


@pytest.fixture
def stub_dangerous_modules(monkeypatch):
    _FakePopen.instances = []
    fake_sp = types.ModuleType("subprocess")
    fake_sp.DEVNULL = -3
    fake_sp.Popen = _FakePopen
    fake_fh = types.ModuleType("faulthandler")
    fake_fh.dump_traceback_later = lambda *a, **k: None
    monkeypatch.setitem(sys.modules, "subprocess", fake_sp)
    monkeypatch.setitem(sys.modules, "faulthandler", fake_fh)
    yield


def test_accepts_logger_param():
    """Signature must accept logger= (the wiring that lets the arm decision reach the volume)."""
    ns = _load_watchdog()
    sig = inspect.signature(ns["_spawn_process_kill_watchdog"])
    assert "logger" in sig.parameters, "logger param missing -- volume routing impossible (v3.8.4 regression)"


def test_not_armed_emits_diag_to_logger(stub_dangerous_modules):
    ns = _load_watchdog()
    # Incomplete ctx: host+token present but run_id MISSING (the exact v3.8.4 silent-skip case).
    ns["_SELF_CANCEL_CTX"].clear()
    ns["_SELF_CANCEL_CTX"].update({
        "host": "https://example",
        "token": "tok",
        "_diag": {"tag_keys": ["clusterId", "jobId", "orgId"], "run_id_source": "", "has_run_id": False, "has_host": True, "has_token": True},
    })
    log = _FakeLogger()
    ns["_spawn_process_kill_watchdog"](grace_seconds=1, source="test", logger=log)

    blob = "\n".join(log.warnings)
    assert "NOT-ARMED" in blob, "incomplete ctx must volume-log NOT-ARMED (pre-patch: silent skip)"
    assert "missing=run_id" in blob, "must name the missing field so the next run is decisive"
    assert "clusterId" in blob and "jobId" in blob, "must dump the captured tag keys for run_id-source RCA"
    # The cancel subprocess must NOT have been armed when ctx is incomplete.
    assert _FakePopen.instances == [] or all("SCW_RUNID" not in e for e in _FakePopen.instances)


def test_armed_passes_sentinel_env_to_subprocess(stub_dangerous_modules):
    ns = _load_watchdog()
    ns["_SELF_CANCEL_CTX"].clear()
    ns["_SELF_CANCEL_CTX"].update({
        "run_id": "868791867403394",
        "host": "https://example",
        "token": "tok",
        "_diag": {"tag_keys": ["multitaskParentRunId"], "run_id_source": "multitaskParentRunId", "has_run_id": True, "has_host": True, "has_token": True},
    })
    log = _FakeLogger()
    ns["_spawn_process_kill_watchdog"](grace_seconds=1, source="test", logger=log)

    blob = "\n".join(log.warnings)
    assert "ARMED" in blob and "868791867403394" in blob, "complete ctx must volume-log ARMED with the run_id"
    # The self-cancel subprocess must receive the run_id AND the sentinel path (not DEVNULL-only).
    sc_envs = [e for e in _FakePopen.instances if "SCW_RUNID" in e]
    assert sc_envs, "self-cancel subprocess was not armed with a complete ctx"
    env = sc_envs[0]
    assert env.get("SCW_RUNID") == "868791867403394"
    assert env.get("SCW_SENTINEL", "").endswith("self_cancel_sentinel.log"), "cancel subprocess must write to a volume sentinel, not DEVNULL"
