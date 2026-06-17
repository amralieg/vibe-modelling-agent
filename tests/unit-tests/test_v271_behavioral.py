"""Behavioral tests for v2.7.1 — the two precision fixes that lifted NCDOT VOV
adherence past the 0.85 fidelity gate (v270 ceiling was 0.804):

  FIX 1 [v271-vov-pass1-fixpoint] — `_v251_apply_pass1_priorities` ran a SINGLE
  pass and PERMANENTLY dropped (structural_unresolvable) any connect_table whose
  FK-target attribute did not exist YET, even when a LATER priority creates it.
  96 such ordering drops on the 48-priority NCDOT run. The fix re-attempts
  prevalidate-deferred priorities round-over-round as long as the previous round
  applied >=1 mutation; only a zero-progress round declares the remainder
  genuinely unresolvable.

  FIX 2 [verifier-rename-state] — rename_* requirements carry "tag"/"convention"
  words in original_text and fell through to the tag/pii branch, returning
  "partial: inconclusive" even though the sandbox renamed the column in place.
  The fix verifies the post-rename state: the renamed-TO name must be present.

Both tests exercise the REAL notebook source (sliced/execed), assert OBSERVABLE
state changes, and would fail on the v2.7.0 pre-patch source (no fixpoint, no
rename branch).
"""
import ast
import copy
import re
import textwrap
from collections import defaultdict
from dataclasses import dataclass
from types import SimpleNamespace
from typing import Any, Optional

from notebook_source_util import notebook_concat_source, slice_function_source

SRC = notebook_concat_source()


class _ListLogger:
    def __init__(self):
        self.info_msgs = []
        self.warn_msgs = []
        self.error_msgs = []

    def info(self, msg, *a, **k):
        self.info_msgs.append(str(msg))

    def warning(self, msg, *a, **k):
        self.warn_msgs.append(str(msg))

    def error(self, msg, *a, **k):
        self.error_msgs.append(str(msg))


@dataclass
class RawVREQ:
    vreq_id: str
    intent: str
    target: str
    source_quote: str
    source_chunk_id: str
    severity: str = "medium"  # v2.9.6 alias=vov-severity-first
    is_user_directive: bool = False  # v2.9.6 alias=vov-merge-user-first
    priority_id: int = 9999  # v2.9.6 alias=vov-severity-first


@dataclass
class VReqOutcome:
    batch_id: str
    vreq_ids: tuple
    status: str
    diagnostic: str
    attempts: int


# ---------- version + sentinel contract ----------

def test_version_271_and_aliases_present():
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', SRC)
    # Relaxed to >= (test_v295 precedent): the v2.7.1 aliases under test persist in
    # later versions; pinning an exact string broke spuriously on every version bump.
    assert m, "version missing"
    assert tuple(int(x) for x in m.group(1).split(".")) >= (2, 7, 1), f"expected >= 2.7.1, got {m.group(1)}"
    assert "v271-vov-pass1-fixpoint FIRED" in SRC
    assert "verifier-rename-state FIRED" in SRC


# ---------- FIX 1: fixpoint ordering recovery ----------

def _exec_v251_ns():
    ns = {
        "__name__": "_v271_ns",
        "copy": copy,
        "re": re,
        "Optional": Optional,
        "RawVREQ": RawVREQ,
        "VReqOutcome": VReqOutcome,
        "logger": _ListLogger(),
    }
    for name in [
        "_v251_model_root",
        "_v251_product_list",
        "_v251_find_domain",
        "_v251_find_product",
        "_v251_find_attribute_row",
        "_v251_iter_attribute_rows",
        "_v251_parse_priority_details",
        "_v251_prevalidate_priority",
        "_v251_apply_priority_deterministic",
        "_v310_apply_rename_ledger",
        "_v251_apply_pass1_priorities",
    ]:
        exec(compile(slice_function_source(name, source=SRC), f"<{name}>", "exec"), ns)
    return ns


def _sales_model():
    return {
        "model": {
            "domains": [
                {
                    "name": "sales",
                    "products": [
                        {"name": "order", "attributes": [{"name": "order_id", "type": "BIGINT"}]},
                        {"name": "invoice", "attributes": [{"name": "invoice_id", "type": "BIGINT"}]},
                    ],
                }
            ]
        }
    }


def test_fixpoint_recovers_ordering_dependent_priority():
    """P_A connects to an FK target that P_B creates. P_A is ordered FIRST.

    Pre-patch single-pass: P_A -> fk-target-missing -> structural_unresolvable (dropped).
    Post-patch fixpoint: round1 applies P_B (creates the target), round2 applies P_A.
    Both end APPLIED.
    """
    ns = _exec_v251_ns()
    apply_pass1 = ns["_v251_apply_pass1_priorities"]
    model = _sales_model()
    priorities = [
        {
            "priority_id": 1,
            "vreq_id": "P001",
            "action": "connect_table",
            "target": "sales.order",
            # FK target sales.invoice.audit_id does NOT exist yet — created by P002 below
            "reason": "add column audit_ref_id (BIGINT) with FK to sales.invoice.audit_id",
        },
        {
            "priority_id": 2,
            "vreq_id": "P002",
            "action": "connect_table",
            "target": "sales.invoice",
            "reason": "add column audit_id (BIGINT) with FK to sales.order.order_id",
        },
    ]
    logger = _ListLogger()
    updated, outcomes, residual = apply_pass1(priorities, model, logger)
    by_id = {o.batch_id: o for o in outcomes}
    assert by_id["P002"].status == "applied"
    assert by_id["P001"].status == "applied", (
        f"fixpoint should recover ordering-dependent P001, got {by_id['P001'].status}"
    )
    # observable model state: P001's column landed on sales.order with the FK resolved
    order_attrs = updated["model"]["domains"][0]["products"][0]["attributes"]
    audit_ref = [a for a in order_attrs if a["name"] == "audit_ref_id"]
    assert audit_ref and audit_ref[0].get("foreign_key_to") == "sales.invoice.audit_id"
    assert any("v271-vov-pass1-fixpoint FIRED" in m for m in logger.info_msgs)


def test_fixpoint_still_drops_genuinely_unresolvable():
    """A connect_table to a product that NO priority ever creates must still be
    declared structural_unresolvable after a zero-progress round (no false apply)."""
    ns = _exec_v251_ns()
    apply_pass1 = ns["_v251_apply_pass1_priorities"]
    model = _sales_model()
    priorities = [
        {
            "priority_id": 1,
            "vreq_id": "P001",
            "action": "connect_table",
            "target": "sales.invoice",
            "reason": "add column order_id (BIGINT) with FK to sales.order.order_id",
        },
        {
            "priority_id": 2,
            "vreq_id": "P002",
            "action": "connect_table",
            "target": "sales.nonexistent_product",  # never created
            "reason": "add column x_id (BIGINT) with FK to sales.invoice.invoice_id",
        },
    ]
    logger = _ListLogger()
    _, outcomes, _ = apply_pass1(priorities, model, logger)
    by_id = {o.batch_id: o for o in outcomes}
    assert by_id["P001"].status == "applied"
    assert by_id["P002"].status == "structural_unresolvable"
    assert "[unresolvable] needs-sourcing-decision" in by_id["P002"].diagnostic


# ---------- FIX 2: verifier rename-state ----------

def _slice_method_source(name: str) -> str:
    tree = ast.parse(SRC)
    target = None
    for node in ast.walk(tree):
        if isinstance(node, ast.FunctionDef) and node.name == name:
            target = node
    assert target is not None, f"method {name} not found"
    lines = SRC.splitlines(keepends=True)
    return textwrap.dedent("".join(lines[target.lineno - 1:target.end_lineno]))


def _exec_verifier():
    fn_src = _slice_method_source("_verify_deterministic")
    ns = {
        "re": re,
        "defaultdict": defaultdict,
        "apply_convention": lambda name, conv: name,
        "config": {},
    }
    exec(compile(fn_src, "<_verify_deterministic>", "exec"), ns)
    return ns["_verify_deterministic"]


def _make_verifier_self():
    """fake self with the REAL _verify_bulk_coverage bound. v3.6.8 g3 made
    _verify_deterministic call self._verify_bulk_coverage(...) first, so any isolation
    harness for _verify_deterministic must provide that method or it AttributeErrors."""
    import json as _json
    fn_src = _slice_method_source("_verify_bulk_coverage")
    ns = {"re": re, "defaultdict": defaultdict, "json": _json}
    exec(compile(fn_src, "<_verify_bulk_coverage>", "exec"), ns)
    fs = SimpleNamespace(config={}, logger=_ListLogger())
    fs._verify_bulk_coverage = ns["_verify_bulk_coverage"].__get__(fs)
    return fs


def test_verifier_rename_attribute_reports_fulfilled_when_new_name_present():
    verify = _exec_verifier()
    fake_self = _make_verifier_self()
    req = SimpleNamespace(
        id="VREQ-024",
        scope="attribute",
        scope_targets=["hr.employee.ethnicity"],
        # carries a "tag/glossary" word that used to route it to the tag/pii branch
        original_text="rename column `ethnicity` to `ethnic_origin` and update the glossary tag",
    )
    domains_data = [{"domain": "hr"}]
    products_data = [{"domain": "hr", "product": "employee", "primary_key": "employee_id"}]
    # post-rename state: the renamed-TO attribute is present (sandbox applied it)
    attributes_data = [
        {"domain": "hr", "product": "employee", "attribute": "employee_id", "type": "BIGINT"},
        {"domain": "hr", "product": "employee", "attribute": "ethnic_origin", "type": "STRING"},
    ]
    res = verify(fake_self, req, domains_data, products_data, attributes_data)
    assert res["status"] == "fulfilled", f"expected fulfilled, got {res}"
    assert "verifier-rename-state FIRED" in res["evidence"]


def test_verifier_rename_does_not_false_fulfill_when_new_name_absent():
    """Conservative: if the renamed-TO name is NOT present, the rename branch must
    NOT emit a fulfilled — it falls through to the existing (partial/failed) logic."""
    verify = _exec_verifier()
    fake_self = _make_verifier_self()
    req = SimpleNamespace(
        id="VREQ-024",
        scope="attribute",
        scope_targets=["hr.employee.ethnicity"],
        original_text="rename column `ethnicity` to `ethnic_origin`",
    )
    domains_data = [{"domain": "hr"}]
    products_data = [{"domain": "hr", "product": "employee", "primary_key": "employee_id"}]
    # rename NOT applied: old name still present, new name absent
    attributes_data = [
        {"domain": "hr", "product": "employee", "attribute": "employee_id", "type": "BIGINT"},
        {"domain": "hr", "product": "employee", "attribute": "ethnicity", "type": "STRING"},
    ]
    res = verify(fake_self, req, domains_data, products_data, attributes_data)
    assert res["status"] != "fulfilled" or "verifier-rename-state FIRED" not in res.get("evidence", ""), (
        f"must not false-fulfill when new name absent, got {res}"
    )
