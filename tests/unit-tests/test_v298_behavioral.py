"""Behavioral tests for v2.9.8 severity-calibration root-cause fix (user audit 2026-06-01).

Root cause: the extractor labelled ~92% of VREQs 'critical' (healthcare 2891/3136), so the
existing severity-first ordering + defer-low-severity tail were DEFEATED. v2.9.8 adds
_v298_recalibrate_severity (alias=vov-severity-calibrate) which re-derives severity from the
VREQ's OWN intent text, independent of the (inflated) LLM label.

These tests exercise the REAL production helpers sliced from the agent notebook and assert the
OBSERVABLE flip (cosmetic critical->low, structural medium->critical), per CLAUDE.md 8.10. The
PRE-PATCH behaviour was "trust the LLM label verbatim", so on the degenerate input below the
cosmetic VREQs would stay 'critical' -> these assertions FAIL on pre-patch HEAD.
"""
import re
import textwrap
from dataclasses import dataclass

from notebook_source_util import notebook_concat_source

SRC = notebook_concat_source()


def _load_severity_helpers():
    """Slice the contiguous severity-helper block (_v296_norm_severity ..
    _v298_recalibrate_severity) from the notebook and exec it as real code."""
    m = re.search(
        r"def _v296_norm_severity\(.*?(?=\n_V296_SEV_RANK\s*=)",
        SRC,
        re.DOTALL,
    )
    assert m, "severity-helper block not found in agent notebook"
    block = textwrap.dedent(m.group(0))
    ns = {}
    exec(compile(block, "agent_notebook", "exec"), ns)
    return ns


HELPERS = _load_severity_helpers()
recalibrate = HELPERS["_v298_recalibrate_severity"]


# --- FIX-B: deterministic guard flips on real degenerate input --------------

def test_cosmetic_comment_vreq_downranked_to_low_even_when_llm_says_critical():
    # healthcare VREQ-054 class: "Every attribute must include a business-justification comment".
    sev = recalibrate(
        "Add a detailed business-justification comment to every attribute",
        "all attributes",
        "VREQ-054 Every attribute must include a detailed business-justification comment",
        "critical",  # the inflated LLM label
    )
    assert sev == "low", f"cosmetic comment VREQ must down-rank to low, got {sev!r}"


def test_description_add_downranked():
    sev = recalibrate("Provide a description for the column", "finance.invoice.total", "", "high")
    assert sev == "low", sev


def test_nonkey_rename_downranked_to_low():
    # healthcare VREQ-038 class: rename a non-key column for canonical naming (SOFT per 3a-bis).
    sev = recalibrate(
        "Rename attribute in consent.workflow: rename column superseded_by_workflow_id to superseded_by_consent_workflow_id",
        "consent.workflow",
        "ambiguous double-stem column name",
        "critical",
    )
    assert sev == "low", f"non-key rename must down-rank to low, got {sev!r}"


def test_structural_fk_uppranked_to_critical_even_when_llm_says_low():
    sev = recalibrate(
        "Add the missing foreign key from booking to flight_leg",
        "booking.flight_leg_id",
        "orphaned table needs FK",
        "low",  # under-rated by the LLM
    )
    assert sev == "critical", f"missing-FK VREQ must up-rank to critical, got {sev!r}"


def test_ssot_duplicate_uppranked():
    sev = recalibrate(
        "Resolve the cross-domain SSOT duplicate of patient identity",
        "patient.mpi_record",
        "19 cross-domain SSOT duplicates",
        "medium",
    )
    assert sev == "critical", sev


def test_cycle_uppranked():
    assert recalibrate("Break the FK cycle between order and shipment", "", "", "medium") == "critical"


def test_add_new_attribute_is_NOT_downranked():
    # 'add a new attribute' has object=attribute (not comment) -> must NOT be treated as cosmetic.
    sev = recalibrate("Add a new attribute aircraft_tail_number", "flight.aircraft", "", "high")
    assert sev == "high", f"adding a real attribute must keep its severity, got {sev!r}"


def test_rename_touching_key_keeps_llm_severity():
    # a rename that explicitly touches a primary/foreign key keeps the LLM judgement (not auto-low).
    sev = recalibrate(
        "Rename the primary key column", "x.y", "primary key rename", "high",
    )
    # 'primary key' matches a STRUCT pattern -> critical (structural). Either way must NOT be low.
    assert sev != "low", sev


def test_neutral_vreq_keeps_deinflated_llm_label():
    sev = recalibrate("Refine the data type of a secondary attribute", "x.y.amount", "", "medium")
    assert sev == "medium", sev


# --- sort chokepoint persists the recalibrated severity ---------------------

def test_sort_chokepoint_recalibrates_and_persists():
    # slice the full contiguous block (norm_severity .. _v296_sort_vreqs) so the sort fn's
    # dependencies (_V296_SEV_RANK, _v296_sev_rank) are present.
    full_block = re.search(
        r"def _v296_norm_severity\(.*?(?=\ndef _vreq_from_dict)",
        SRC,
        re.DOTALL,
    )
    assert full_block, "_v296_sort_vreqs block not found"
    block = textwrap.dedent(full_block.group(0))
    ns = {}
    exec(compile(block, "agent_notebook", "exec"), ns)
    sort_fn = ns["_v296_sort_vreqs"]

    @dataclass
    class _RV:
        vreq_id: str
        intent: str = ""
        target: str = ""
        source_quote: str = ""
        severity: str = "medium"
        is_user_directive: bool = False
        priority_id: int = 9999

    cosmetic = _RV("V1", "Add a business-justification comment to every attribute", severity="critical")
    structural = _RV("V2", "Add the missing foreign key that orphans the table", severity="low")
    ordered = sort_fn([cosmetic, structural])
    # severity persisted back in place
    assert cosmetic.severity == "low", cosmetic.severity
    assert structural.severity == "critical", structural.severity
    # and the structural (now critical) sorts ahead of the cosmetic (now low)
    assert ordered[0].vreq_id == "V2", [v.vreq_id for v in ordered]


def test_agent_version_is_298_or_higher():
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([0-9]+)\.([0-9]+)\.([0-9]+)"', SRC)
    assert m, "agent version constant not found"
    major, minor, patch = (int(g) for g in m.groups())
    assert (major, minor, patch) >= (2, 9, 8), f"expected >= 2.9.8, got {m.group(0)}"
