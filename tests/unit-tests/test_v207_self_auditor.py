"""Behavioural tests for v207 SelfAuditor (5 user-locked audit invariants).

Per CLAUDE.md §8.10: no no-op patches. Every alias has [FIRED] emission AND behavioural
test that proves the patch changes observable state. These tests:

1. Static-grep verify the auditor cell + wire-in call site exist in the deployed notebook.
2. Exec the auditor cell directly + call SelfAuditor.audit() with crafted inputs that
   force each invariant to fire OK / WARN / HIGH / CRITICAL. Verify the right
   AuditFinding is emitted.
3. End-to-end: feed a known-bad model + manifest into run_self_audit_or_skip() and
   verify the returned dict contains CRITICAL findings with the correct aliases.

User-locked policy 2026-05-26 (the 5 invariants):
  I1 - agent captured all vibes (no miss)
  I2 - all captured vibes mapped to REQ-IDs
  I3 - all REQs are actioned (sandbox or deterministic)
  I4 - model quality score is monotonic-up
  I5 - no regression in structural integrity
"""

import json
import os
import re
import sys
import types
from dataclasses import dataclass, field
from typing import List, Optional


NB = os.path.join(
    os.path.dirname(__file__),
    "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb",
)


def _read_nb():
    with open(NB, "r", encoding="utf-8") as f:
        return json.load(f)


def _all_code() -> str:
    nb = _read_nb()
    out = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") == "code":
            out.append("".join(cell.get("source", [])))
    return "\n".join(out)


def _exec_auditor_cell():
    """Exec ONLY the SelfAuditor cell to get SelfAuditor + run_self_audit_or_skip in a fresh ns."""
    nb = _read_nb()
    # Find the cell whose source declares SelfAuditor
    src = None
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        s = "".join(cell.get("source", []))
        if "class SelfAuditor" in s and "run_self_audit_or_skip" in s:
            src = s
            break
    assert src is not None, "SelfAuditor cell not found in notebook"
    ns: dict = {"__AGENT_VERSION__": "2.0.7"}
    exec(src, ns)
    return ns


# ============================================================================
# 1. Static-grep — alias + wire-in presence
# ============================================================================

def test_static_alias_v207_self_audit_cell_present():
    """SelfAuditor cell exists and emits its alias."""
    s = _all_code()
    assert "v207-self-audit-cell" in s
    assert "class SelfAuditor" in s
    assert "def run_self_audit_or_skip" in s


def test_static_all_5_invariant_aliases_present():
    s = _all_code()
    for alias in ("audit-i1-vibe-capture", "audit-i2-req-mapping",
                  "audit-i3-req-action", "audit-i4-score-monotonic",
                  "audit-i5-no-regression"):
        assert alias in s, f"missing invariant alias {alias}"


def test_static_wire_in_at_orchestrator_post_lineage():
    """Auditor MUST be called after step_generate_vibe_lineage in the orchestrator."""
    s = _all_code()
    # The call site is wired in cell 26; assert the marker + the actual call
    assert "v207-self-audit-call" in s, "wire-in marker missing — auditor was NEVER called"
    assert "run_self_audit_or_skip(" in s, "auditor not actually invoked"
    # And the audit report is captured into widgets_values
    assert '_v207_audit_report' in s, "audit report not captured into widgets_values"


def test_static_priority_append_to_next_vibes_present():
    """HIGH/CRITICAL findings MUST append PRIORITY lines to next_vibes.txt for next cycle."""
    s = _all_code()
    assert "v207-self-audit-priority-append" in s
    assert "priority_lines" in s


# ============================================================================
# 2. Behavioural — each invariant fires correctly
# ============================================================================

@dataclass
class _FakeReq:
    id: str = ""
    raw_text: str = ""
    status: str = "pending"
    scope: str = "model"
    constraint_type: str = "hard"


@dataclass
class _FakeManifest:
    raw_text: str = ""
    requirements: list = field(default_factory=list)


def test_i1_fires_critical_when_manifest_missing_for_substantial_vibe():
    """raw_vibe with content + no manifest -> CRITICAL on I1."""
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    findings = auditor.audit(raw_vibe="we need a comprehensive customer 360 model "
                                       "with PII tagging and SCD2 history",
                              manifest=None)
    i1 = [f for f in findings if f.invariant == "I1"]
    assert len(i1) == 1
    assert i1[0].severity == "CRITICAL"
    assert "did not parse" in i1[0].summary or "manifest" in i1[0].summary.lower()


def test_i1_ok_when_empty_vibe():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    findings = auditor.audit(raw_vibe="", manifest=None)
    i1 = [f for f in findings if f.invariant == "I1"][0]
    assert i1.severity == "OK"


def test_i1_ok_when_atom_ratio_healthy():
    """If manifest captured plenty of reqs, I1 should be OK."""
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    reqs = [_FakeReq(id=f"REQ-{i}", raw_text=f"directive {i}", status="fulfilled") for i in range(10)]
    manifest = _FakeManifest(raw_text="x" * 200, requirements=reqs)
    vibe = ("must have customer table\nmust have order table\nmust not include PII raw\n"
            "should include SCD2 history\nensure FK integrity\n"
            "1. customer\n2. order\n3. product\n")
    findings = auditor.audit(raw_vibe=vibe, manifest=manifest)
    i1 = [f for f in findings if f.invariant == "I1"][0]
    assert i1.severity == "OK", f"expected OK got {i1.severity}: {i1.summary}"


def test_i1_high_when_under_capture():
    """Many vibe atoms + tiny manifest -> HIGH."""
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    reqs = [_FakeReq(id="REQ-1", raw_text="something")]  # only 1 req
    manifest = _FakeManifest(raw_text="x", requirements=reqs)
    vibe = "\n".join([f"must have {i}" for i in range(30)])  # 30 atoms
    findings = auditor.audit(raw_vibe=vibe, manifest=manifest)
    i1 = [f for f in findings if f.invariant == "I1"][0]
    assert i1.severity == "HIGH", f"expected HIGH got {i1.severity}: {i1.summary}"
    assert "under-capture" in i1.summary


def test_i2_high_when_reqs_have_no_ids():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    reqs = [_FakeReq(id="", raw_text="orphan vibe")]
    manifest = _FakeManifest(requirements=reqs)
    findings = auditor.audit(raw_vibe="something", manifest=manifest)
    i2 = [f for f in findings if f.invariant == "I2"][0]
    assert i2.severity == "HIGH"
    assert "orphan" in i2.summary.lower() or "no req_id" in i2.summary


def test_i2_high_when_action_maps_to_unknown_req():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    reqs = [_FakeReq(id="REQ-1", status="fulfilled")]
    manifest = _FakeManifest(requirements=reqs)
    vma = {"actions": [{"name": "weird_action", "mapped_req_ids": ["REQ-999"]}]}
    findings = auditor.audit(raw_vibe="x", manifest=manifest, vibe_master_actions=vma)
    i2 = [f for f in findings if f.invariant == "I2"][0]
    assert i2.severity == "HIGH"


def test_i2_ok_when_everything_mapped():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    reqs = [_FakeReq(id=f"REQ-{i}", status="fulfilled") for i in range(3)]
    manifest = _FakeManifest(requirements=reqs)
    vma = {"actions": [{"name": "a", "mapped_req_ids": ["REQ-0", "REQ-1"]},
                       {"name": "b", "mapped_req_ids": ["REQ-2"]}]}
    findings = auditor.audit(raw_vibe="x", manifest=manifest, vibe_master_actions=vma)
    i2 = [f for f in findings if f.invariant == "I2"][0]
    assert i2.severity == "OK"


def test_i3_high_when_reqs_unactioned():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    reqs = [_FakeReq(id="REQ-1", status="pending")]  # not fulfilled + not in lineage
    manifest = _FakeManifest(requirements=reqs)
    findings = auditor.audit(raw_vibe="x", manifest=manifest, vibe_lineage={})
    i3 = [f for f in findings if f.invariant == "I3"][0]
    assert i3.severity == "HIGH"
    assert "not actioned" in i3.summary


def test_i3_ok_when_lineage_covers_pending_reqs():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    reqs = [_FakeReq(id="REQ-1", status="pending"),
            _FakeReq(id="REQ-2", status="fulfilled")]
    manifest = _FakeManifest(requirements=reqs)
    lineage = {"by_req_id": {"REQ-1": [{"action": "add_table"}]}}
    findings = auditor.audit(raw_vibe="x", manifest=manifest, vibe_lineage=lineage)
    i3 = [f for f in findings if f.invariant == "I3"][0]
    assert i3.severity == "OK"


def test_i4_critical_when_score_regresses():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    findings = auditor.audit(
        raw_vibe="x",
        prior_next_vibes="...\nModel Quality Score: 85/100\n...",
        current_next_vibes="...\nModel Quality Score: 72/100\n...",
    )
    i4 = [f for f in findings if f.invariant == "I4"][0]
    assert i4.severity == "CRITICAL"
    assert "REGRESSED" in i4.summary
    assert i4.evidence["delta"] < 0


def test_i4_ok_when_score_improves():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    findings = auditor.audit(
        raw_vibe="x",
        prior_next_vibes="...\nModel Quality Score: 72/100\n...",
        current_next_vibes="...\nModel Quality Score: 85/100\n...",
    )
    i4 = [f for f in findings if f.invariant == "I4"][0]
    assert i4.severity == "OK"
    assert i4.evidence["delta"] == 13.0


def test_i4_ok_first_version_no_prior():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    findings = auditor.audit(
        raw_vibe="x",
        prior_next_vibes="",
        current_next_vibes="Model Quality Score: 90/100",
    )
    i4 = [f for f in findings if f.invariant == "I4"][0]
    assert i4.severity == "OK"


def test_i5_critical_when_silos_increase():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    prior = {"model": {"domains": [
        {"name": "d", "products": [
            {"name": "p1", "primary_key": "id",
             "attributes": [{"name": "id"}, {"name": "fk", "foreign_key_to": "d.p2.id"}]},
            {"name": "p2", "primary_key": "id",
             "attributes": [{"name": "id"}, {"name": "v"}]}]
        }]}}
    current = {"model": {"domains": [
        {"name": "d", "products": [
            {"name": "p1", "primary_key": "id",
             "attributes": [{"name": "id"}, {"name": "v1"}]},
            {"name": "p2", "primary_key": "id",
             "attributes": [{"name": "id"}, {"name": "v2"}]},
            {"name": "p3", "primary_key": "id",
             "attributes": [{"name": "id"}, {"name": "v3"}]}]
        }]}}
    findings = auditor.audit(raw_vibe="", prior_model_json=prior, current_model_json=current)
    i5 = [f for f in findings if f.invariant == "I5"][0]
    assert i5.severity == "CRITICAL"
    assert "silos" in i5.summary.lower() or "regress" in i5.summary.lower()


def test_i5_ok_when_no_regression():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    prior = {"model": {"domains": [
        {"name": "d", "products": [
            {"name": "p1", "primary_key": "id",
             "attributes": [{"name": "id"}, {"name": "fk", "foreign_key_to": "d.p2.id"}]},
            {"name": "p2", "primary_key": "id",
             "attributes": [{"name": "id"}, {"name": "v"}]}]
        }]}}
    current = prior  # same model
    findings = auditor.audit(raw_vibe="", prior_model_json=prior, current_model_json=current)
    i5 = [f for f in findings if f.invariant == "I5"][0]
    assert i5.severity == "OK"


def test_i5_first_version_baseline_ok():
    ns = _exec_auditor_cell()
    auditor = ns["SelfAuditor"]()
    current = {"model": {"domains": [
        {"name": "d", "products": [
            {"name": "p1", "primary_key": "id",
             "attributes": [{"name": "id"}, {"name": "v"}]}]
        }]}}
    findings = auditor.audit(raw_vibe="", prior_model_json=None, current_model_json=current)
    i5 = [f for f in findings if f.invariant == "I5"][0]
    assert i5.severity == "OK"


# ============================================================================
# 3. End-to-end — run_self_audit_or_skip returns full dict + priority lines
# ============================================================================

def test_run_self_audit_returns_dict_with_summary_and_priority_lines():
    ns = _exec_auditor_cell()
    run = ns["run_self_audit_or_skip"]
    reqs = [_FakeReq(id="REQ-1", status="pending")]
    manifest = _FakeManifest(requirements=reqs)
    widgets = {"model_vibes": "must have a customer table", "vibe_master_actions": {}}
    report = run(
        widgets_values=widgets, manifest=manifest,
        current_model_json={"model": {"domains": []}},
        prior_model_json=None,
        prior_next_vibes="Model Quality Score: 90/100",
        current_next_vibes="Model Quality Score: 70/100",  # regressed
        vibe_lineage={},
    )
    assert isinstance(report, dict)
    assert "summary" in report
    assert "findings" in report
    assert "priority_lines" in report
    assert report["summary"]["critical"] >= 1, "expected at least 1 CRITICAL finding (I4 score regression)"
    # Priority lines should include the I4 critical
    plines = report["priority_lines"]
    assert any("audit-i4-score-monotonic" in line for line in plines)


def test_run_self_audit_includes_agent_version():
    ns = _exec_auditor_cell()
    run = ns["run_self_audit_or_skip"]
    report = run(widgets_values={}, manifest=None,
                 current_model_json=None, prior_model_json=None)
    assert report.get("agent_version") == "2.0.7"


def test_run_self_audit_never_crashes_on_garbage_input():
    """Buggy input MUST NOT crash the auditor — pipeline robustness invariant."""
    ns = _exec_auditor_cell()
    run = ns["run_self_audit_or_skip"]
    # Pass total garbage
    report = run(widgets_values="not a dict", manifest="not a manifest",  # type: ignore
                 current_model_json=42, prior_model_json="x")  # type: ignore
    assert isinstance(report, dict)
    assert "findings" in report


def test_run_self_audit_emits_run_alias_in_logger():
    ns = _exec_auditor_cell()
    run = ns["run_self_audit_or_skip"]
    captured = []

    class _CaptureLogger:
        def info(self, m): captured.append(("info", m))
        def warning(self, m): captured.append(("warning", m))

    run(widgets_values={"model_vibes": ""}, manifest=None,
        current_model_json=None, prior_model_json=None, logger=_CaptureLogger())
    log_text = "\n".join(m for _, m in captured)
    assert "v207-self-audit-run FIRED v2.0.7" in log_text


def test_audit_finding_to_priority_line_format():
    ns = _exec_auditor_cell()
    AuditFinding = ns["AuditFinding"]
    f = AuditFinding(alias="audit-i4-score-monotonic", invariant="I4",
                     severity="CRITICAL", summary="score regressed 85 -> 72")
    line = f.to_priority_line()
    assert line.startswith("PRIORITY 1 - fix I4")
    assert "audit-i4-score-monotonic" in line
    assert "score regressed" in line
