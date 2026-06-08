"""v3.2.9 — verifier-rename false-fulfillment root-cause fix.

Ground truth (NCDOT mvm_v6 physical audit 2026-06-05): source priorities
P18-P22 (rename_attribute, e.g. project_id -> primary_project_id on
project.asset_impact / project.location / project.plan_inclusion) were marked
ALREADY FULFILLED by the deterministic verifier yet were absent from BOTH
model.json and the ncdot_v1 catalog. Two false-pass paths:

  (1) verifier-rename-state: the new-name capture regex `\\bto\\s+X` matched
      "...two FKs point to project.project" (the WRONG "to"), found leaf
      `project` present, and returned fulfilled.
  (2) verifier-rename-drop-structural: for scope=='attribute' it compared
      product-level (2-part) scope_targets against 3-part attr_keys. A 2-part
      name can never be in attr_keys, so _still_present was always empty ->
      "rename applied" -> false fulfilled.

The fix (a) anchors the new-name regex to a real "rename <old> to <new>"
construct, and (b) for scope=='attribute' filters old_targets to column
granularity (>=2 dots) and skips the absence shortcut (never false-fulfill)
when only product-level targets remain.

tests test_structural_path_* and test_rename_state_path_* FAIL on pre-patch
HEAD (verifier returns 'fulfilled') and PASS post-patch (no longer fulfilled).
"""
import json
import os
import re
import logging

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_src():
    nb = json.load(open(NB))
    return "".join("".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code")


def _build_verifier():
    nb = json.load(open(NB))
    full = "".join("".join(c.get("source", [])) for c in nb["cells"] if c.get("cell_type") == "code")
    i = full.index("    def _verify_deterministic")
    j = full.index("    def _verify_structural_target")
    method = full[i:j]
    # dedent one method-level (4 spaces) and re-indent under the test class (2 spaces)
    import textwrap
    method = textwrap.dedent(method)
    cls = (
        "from collections import defaultdict\n"
        "class _V:\n"
        "  def __init__(s):\n"
        "    s.logger=logging.getLogger('t'); s.config={}\n"
        "  def _verify_structural_target(s, req, products_data, attributes_data):\n"
        "    return None\n"
    )
    cls += textwrap.indent(method, "  ")
    ns = {"logging": logging, "re": re}
    exec(cls, ns, ns)
    return ns["_V"]()


class _Req:
    def __init__(self, rid, text, scope, targets=None):
        self.id = rid
        self.original_text = text
        self.scope = scope
        self.scope_targets = targets or []
        self.attributes = []


def _attrs_not_renamed():
    # project_id still present (rename project_id->primary_project_id NOT applied)
    return [
        {"domain": "project", "product": "asset_impact", "attribute": "asset_impact_id", "foreign_key_to": None},
        {"domain": "project", "product": "asset_impact", "attribute": "project_id", "foreign_key_to": "project.project.project_id"},
        {"domain": "project", "product": "location", "attribute": "project_id", "foreign_key_to": "project.project.project_id"},
        {"domain": "project", "product": "project", "attribute": "project_id", "foreign_key_to": None},
        {"domain": "hr", "product": "job", "attribute": "job_code_object_code", "foreign_key_to": None},
    ]


def _prods(names):
    return [{"domain": n.split(".")[0], "product": n.split(".")[1]} for n in names]


# ---------------- static contracts ----------------

def test_version_at_least_329():
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', _load_src())
    assert m is not None
    assert tuple(int(x) for x in m.groups()) >= (3, 2, 9)


def test_aliases_present():
    src = _load_src()
    assert "verifier-rename-granularity-guard" in src
    assert "verifier-rename-granularity-guard FIRED v3.2.9" in src


# ---------- (1) structural false-pass path: product-level targets ----------

def test_structural_path_product_level_targets_not_false_fulfilled():
    """scope=attribute, product-level (2-part) targets, rename NOT applied.
    Pre-patch: structural block -> 'fulfilled' (BUG). Post-patch: not fulfilled."""
    v = _build_verifier()
    r = _Req(
        "VREQ-029",
        "Rename generic/unlabeled FK columns where two FKs point to project.project. "
        "On project.asset_impact, project.location, and project.plan_inclusion, rename the "
        "generic column to a descriptive label.",
        scope="attribute",
        targets=["project.asset_impact", "project.location", "project.plan_inclusion"],
    )
    res = v._verify_deterministic(r, [], [], _attrs_not_renamed())
    assert res["status"] != "fulfilled", res


# ---------- (2) rename-state false-pass path: "point to X" ----------

def test_rename_state_path_point_to_not_treated_as_rename_target():
    """Same VREQ but with products present so the rename-state 'to X' regex would
    grab 'point to project.project'. Pre-patch -> 'fulfilled'. Post-patch: not."""
    v = _build_verifier()
    r = _Req(
        "VREQ-029b",
        "Two FKs point to project.project. Rename the generic column to a descriptive label.",
        scope="attribute",
        targets=["project.asset_impact", "project.location"],
    )
    res = v._verify_deterministic(r, [], _prods(["project.project", "project.asset_impact", "project.location"]), _attrs_not_renamed())
    assert res["status"] != "fulfilled", res


# ---------- correctness regressions (must stay correct) ----------

def test_column_level_rename_applied_is_fulfilled():
    v = _build_verifier()
    attrs = [
        {"domain": "project", "product": "asset_impact", "attribute": "primary_project_id", "foreign_key_to": "project.project.project_id"},
        {"domain": "project", "product": "project", "attribute": "project_id", "foreign_key_to": None},
    ]
    r = _Req(
        "VREQ-020",
        "On project.asset_impact, rename column project_id to primary_project_id to disambiguate.",
        scope="attribute",
        targets=["project.asset_impact.project_id"],
    )
    res = v._verify_deterministic(r, [], _prods(["project.asset_impact", "project.project"]), attrs)
    assert res["status"] == "fulfilled", res


def test_column_level_rename_not_applied_is_failed():
    v = _build_verifier()
    r = _Req(
        "VREQ-027",
        "rename column job_code_object_code to code_object_code to remove the redundant product prefix.",
        scope="attribute",
        targets=["hr.job.job_code_object_code"],
    )
    res = v._verify_deterministic(r, [], _prods(["hr.job"]), _attrs_not_renamed())
    assert res["status"] != "fulfilled", res
    assert res["status"] == "failed", res


# ---------- bucket 2: remove_fk / relation verifier false-pass (P13/VREQ-025) ----------

def _attrs_with_org_fk():
    return [
        {"domain": "project", "product": "dsctr_project_data", "attribute": "organization_id",
         "foreign_key_to": "hr.organization.organization_id"},
        {"domain": "hr", "product": "organization", "attribute": "organization_id", "foreign_key_to": None},
    ]


def test_remove_fk_still_present_is_not_false_fulfilled():
    """remove_fk whose text contains 'FK' matched the legacy add-intent branch and
    FALSE-fulfilled because the to-be-removed FK was still present. Post-patch the
    remove verb is honored -> failed while the FK persists."""
    v = _build_verifier()
    r = _Req(
        "VREQ-025",
        "On project.dsctr_project_data, remove the FK to hr.organization.",
        scope="relation",
        targets=["hr.organization"],
    )
    res = v._verify_deterministic(r, [], _prods(["project.dsctr_project_data", "hr.organization"]), _attrs_with_org_fk())
    assert res["status"] != "fulfilled", res


def test_remove_fk_actually_removed_is_fulfilled():
    """Same directive but the FK is gone -> the remove is genuinely fulfilled."""
    v = _build_verifier()
    r = _Req(
        "VREQ-025",
        "On project.dsctr_project_data, remove the FK to hr.organization.",
        scope="relation",
        targets=["hr.organization"],
    )
    attrs = [{"domain": "hr", "product": "organization", "attribute": "organization_id", "foreign_key_to": None}]
    res = v._verify_deterministic(r, [], _prods(["project.dsctr_project_data", "hr.organization"]), attrs)
    assert res["status"] == "fulfilled", res


def test_add_link_relation_still_works():
    """Regression: an add/link relation directive with the FK present stays fulfilled."""
    v = _build_verifier()
    r = _Req(
        "VREQ-100",
        "Link project.dsctr_project_data to hr.organization via a foreign key.",
        scope="relation",
        targets=["hr.organization"],
    )
    res = v._verify_deterministic(r, [], _prods(["project.dsctr_project_data", "hr.organization"]), _attrs_with_org_fk())
    assert res["status"] == "fulfilled", res


def test_aliases_present_bucket2():
    assert "verifier-relation-remove-verb" in _load_src()
