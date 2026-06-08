import json
import os
import re
import textwrap
import logging

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_src():
    nb = json.load(open(NB))
    return "".join("".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code")


def _build_verifier():
    nb = json.load(open(NB))
    full = "".join("".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code")
    i = full.index("    def _verify_structural_target")
    j = full.index("    def _verify_state_diff")
    method = textwrap.dedent(full[i:j])
    ns = {}
    cls = "class _V:\n  def __init__(s):\n    s.logger=logging.getLogger('t')\n"
    cls += textwrap.indent(method, "  ")
    exec(cls, {"logging": logging, "re": re}, ns)
    return ns["_V"]()


class _Req:
    def __init__(self, rid, text, targets=None):
        self.id = rid
        self.original_text = text
        self.scope_targets = targets or []


def _attrs():
    # minimal after-state: product project.pse_user with employee_id FK to hr.employee.employee_id
    return [
        {"domain": "project", "product": "pse_user", "attribute": "pse_user_id", "foreign_key_to": None},
        {"domain": "project", "product": "pse_user", "attribute": "employee_id", "foreign_key_to": "hr.employee.employee_id"},
        {"domain": "hr", "product": "employee", "attribute": "employee_id", "foreign_key_to": None},
        {"domain": "project", "product": "spec_cat", "attribute": "original_table_name", "foreign_key_to": None},
    ]


def test_version_is_309():
    # v3.0.9 fix must be present at v3.0.9 OR LATER (forward bumps must not break this).
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', _load_src())
    assert m is not None
    assert tuple(int(x) for x in m.groups()) >= (3, 0, 9)


def test_helper_exists():
    # On pre-fix (v3.0.8) HEAD this method does not exist -> this whole suite cannot run,
    # which is the §8.10 proof the fix introduces NEW behavior, not a tautology.
    assert "_verify_structural_target" in _load_src()
    assert "alias=verifier-structural-target" in _load_src()


def test_state_diff_and_deterministic_invoke_helper_first():
    src = _load_src()
    assert "_v309_struct = self._verify_structural_target" in src
    assert "_v309_struct_det = self._verify_structural_target" in src


def test_landed_add_column_with_fk_is_fulfilled():
    # THE core fix: a column added to an EXISTING product (no count change) must be FULFILLED,
    # not the pre-fix "partial: cannot confirm intent".
    v = _build_verifier()
    r = _Req("R1", "On product project.pse_user, add a column `employee_id` (BIGINT) with an FK to `hr.employee.employee_id`.")
    res = v._verify_structural_target(r, [], _attrs())
    assert res is not None and res["status"] == "fulfilled"


def test_missing_column_is_failed_not_fulfilled():
    v = _build_verifier()
    r = _Req("R2", "On product project.pse_user, add a column `does_not_exist` (BIGINT) with an FK to `hr.employee.employee_id`.")
    res = v._verify_structural_target(r, [], _attrs())
    assert res is not None and res["status"] == "failed"


def test_fk_to_wrong_target_is_partial():
    v = _build_verifier()
    r = _Req("R3", "On product project.pse_user, add a column `employee_id` (BIGINT) with an FK to `hr.organization.organization_id`.")
    res = v._verify_structural_target(r, [], _attrs())
    assert res is not None and res["status"] == "partial"


def test_remove_fk_satisfied_is_fulfilled():
    v = _build_verifier()
    r = _Req("R4", "On product project.spec_cat, remove the FK on column `original_table_name`.")
    res = v._verify_structural_target(r, [], _attrs())
    assert res is not None and res["status"] == "fulfilled"


def test_rename_falls_back_to_none():
    v = _build_verifier()
    r = _Req("R5", "On product hr.employee, rename column `working_title` to `position_description`.")
    res = v._verify_structural_target(r, [], _attrs())
    assert res is None  # rename has a dedicated handler elsewhere


def test_unresolvable_product_falls_back_to_none():
    v = _build_verifier()
    r = _Req("R6", "Reduce the overall model footprint.")
    res = v._verify_structural_target(r, [], _attrs())
    assert res is None
