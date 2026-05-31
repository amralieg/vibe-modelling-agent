"""v2.9.3 behavioral test: agentic APPLICATION guarantee pt2 (real production code).

FIX-APPLY-ESCALATE alias=vov-pass1-escalate-residual
  ROOT CAUSE of <100% application, proven live on ncdot v292 (run 1087667212605110):
    [LLM_PARSE] parsed 116 semantic requirements; 112 PRIORITY VREQs built
    [v251-vov-pass1-deterministic] applied=14 residual=0 total=112   <- residual=0 !
    [v251-vov-target-prevalidate] dropped=1 reason=fk-target-missing  x273
    [VOV-OUTCOME-SUMMARY] iter=1/2/3 branch=priority batches=0 applied=0
    [vov-coverage-honest] detected=112 applied_in_universe=14 application_pct=12.5
  The deterministic pass-1 applier returned `_residual` populated ONLY by unsupported-action
  priorities; every SUPPORTED-action priority it could not apply (98 connect_table with a
  not-yet-existing FK target) was stamped structural_unresolvable and DROPPED -- never added to
  `_residual`, so the agentic LLM batch fallback (`_apply_batches_for_vreqs`, which receives ONLY
  `_residual`) was starved and the loop finished in <1s with 12.5% applied.

  v293 fix: when a fixpoint round makes ZERO progress, ESCALATE the still-deferred priorities into
  `_residual` (the LLM batcher can add/remap the missing FK target) instead of terminally dropping
  them. No structural_unresolvable outcome is emitted -> the batch path stays authoritative.

These tests exec the REAL `_v251_*` functions out of the live notebook (cell 3) and prove the
escalation behaviorally. They FAIL on pre-patch HEAD (residual empty + structural_unresolvable
emitted) and PASS on patch.
"""
import ast
import json
import logging
import os
import re
from dataclasses import dataclass

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")
LOG = logging.getLogger("v293test")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _load_pass1():
    """EXEC the real _v251_* pass-1 family out of the notebook (not a mirror)."""
    nb = json.load(open(NB))
    full = "\n\n".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")
    tree = ast.parse(full)

    # VReqOutcome / RawVREQ are trivial data containers (not the logic under test) -> faithful stubs
    # with the fields pass-1 constructs, same rationale as the v292 RawVREQ stub.
    @dataclass
    class VReqOutcome:  # noqa: N801
        batch_id: str = ""
        vreq_ids: tuple = ()
        status: str = ""
        diagnostic: str = ""
        attempts: int = 0

    @dataclass
    class RawVREQ:  # noqa: N801
        vreq_id: str = ""
        intent: str = ""
        target: str = ""
        source_quote: str = ""
        source_chunk_id: str = ""

    ns = {"re": re, "VReqOutcome": VReqOutcome, "RawVREQ": RawVREQ}
    segs = []
    for node in tree.body:
        if isinstance(node, ast.FunctionDef) and node.name.startswith("_v251_"):
            segs.append((node.lineno, ast.get_source_segment(full, node)))
    segs.sort()
    for _, seg in segs:
        exec(compile(seg, "<nb>", "exec"), ns)
    return ns


def _model_with_target_product_only():
    """project.dsctr_category_group EXISTS; the FK target project.dsctr_category.* does NOT."""
    return {
        "model": {
            "domains": [
                {
                    "name": "project",
                    "products": [
                        {
                            "name": "dsctr_category_group",
                            "attributes": [{"name": "dsctr_category_group_id", "type": "BIGINT"}],
                        }
                    ],
                }
            ]
        }
    }


def _connect_table_priority_missing_fk():
    return {
        "action": "connect_table",
        "target": "project.dsctr_category_group",
        "priority_id": 1,
        "reason": "add column dsctr_category_id (BIGINT) with FK to project.dsctr_category.dsctr_category_id — source schema link",
    }


# ---------------- version + sentinel ----------------

def test_v293_version_is_293():
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', _src())
    assert m and m.group(1) == "2.9.3", f"expected 2.9.3, got {m.group(1) if m else None}"
    assert all(len(seg) == 1 for seg in m.group(1).split(".")), "single-digit semver violated"


def test_v293_alias_has_fired_log_site():
    src = _src()
    assert "vov-pass1-escalate-residual FIRED v2.9.3" in src, "no FIRED emission for the escalate fix"
    assert "alias=vov-pass1-escalate-residual" in src, "no alias= grep anchor for the escalate fix"


# ---------------- FIX-APPLY-ESCALATE (behavioral) ----------------

def test_v293_deferred_fk_target_missing_is_escalated_to_residual():
    """The core fix: an un-applicable connect_table (fk-target-missing) must be ESCALATED into
    _residual (handed to the LLM batcher), NOT dropped. FAILS on pre-patch (residual empty)."""
    ns = _load_pass1()
    fn = ns["_v251_apply_pass1_priorities"]
    prio = _connect_table_priority_missing_fk()
    _model, _outcomes, _residual = fn([prio], _model_with_target_product_only(), LOG)

    assert len(_residual) == 1, (
        f"v293/vov-pass1-escalate-residual: the deferred fk-target-missing priority must be "
        f"escalated into _residual for the LLM batcher, got residual={len(_residual)} "
        f"(pre-patch drops it as structural_unresolvable -> 0)"
    )
    assert str(_residual[0].get("action")).lower() == "connect_table"
    # and it must NOT also be terminally stamped structural_unresolvable (no double-record)
    statuses = {getattr(o, "status", "") for o in _outcomes}
    assert "structural_unresolvable" not in statuses, (
        f"v293: escalated priority must not also be dropped as structural_unresolvable; statuses={statuses}"
    )


def test_v293_applicable_priority_still_applied_not_escalated():
    """Control: a priority pass-1 CAN apply (FK target exists) is applied deterministically and is
    NOT dumped into _residual. Proves the fix escalates only un-applicable priorities, not blanket."""
    ns = _load_pass1()
    fn = ns["_v251_apply_pass1_priorities"]
    # model where the FK target DOES exist -> prevalidate passes -> deterministic apply
    model = {
        "model": {
            "domains": [
                {
                    "name": "project",
                    "products": [
                        {"name": "dsctr_category_group", "attributes": [{"name": "dsctr_category_group_id", "type": "BIGINT"}]},
                        {"name": "dsctr_category", "attributes": [{"name": "dsctr_category_id", "type": "BIGINT"}]},
                    ],
                }
            ]
        }
    }
    prio = _connect_table_priority_missing_fk()  # same priority; target now resolvable
    _model, _outcomes, _residual = fn([prio], model, LOG)

    assert len(_residual) == 0, f"applicable priority should not be escalated to _residual, got {len(_residual)}"
    assert any(getattr(o, "status", "") == "applied" for o in _outcomes), (
        f"applicable connect_table should be applied deterministically; statuses={[getattr(o,'status','') for o in _outcomes]}"
    )
