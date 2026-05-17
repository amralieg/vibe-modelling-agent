"""v0.7.3 strict-VOV authority tests.

Verifies the overhaul guarantees that for `vibe modeling of version`:
  - The user vibe REACHES the parser (P1: widget vibe wins in bc builder).
  - The auto-load gate fires correctly with the user vibe present (P9).
  - The diff guard at writeback time enforces additive semantics:
      * Entities user TOUCHED -> mutated version preserved.
      * Entities user marked NEW -> additions preserved.
      * Entities NOT mentioned -> reverted to v_base bytes (no drift).

Industry-agnostic — every test is parameterized over multiple verticals.
"""
import ast
import copy
import json
import re
import sys
import types
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_vov_helpers():
    nb = json.loads(NOTEBOOK_PATH.read_text(encoding="utf-8"))
    helpers_module = types.ModuleType("vov_helpers_v73")
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        if "_compute_vov_user_closure" not in src or "_strict_vov_diff_guard" not in src:
            continue
        start = src.find("def _compute_vov_user_closure")
        end = src.find("def step_setup_and_clean")
        if start < 0 or end < 0:
            raise RuntimeError("Could not locate VOV helpers in notebook")
        helpers_code = src[start:end]
        tree = ast.parse(helpers_code)
        for node in tree.body:
            if isinstance(node, ast.FunctionDef):
                snippet = ast.Module(body=[node], type_ignores=[])
                exec(compile(snippet, str(NOTEBOOK_PATH), "exec"), helpers_module.__dict__)
        return helpers_module
    raise RuntimeError("No cell contains the VOV helpers")


VOV = _load_vov_helpers()


INDUSTRY_VIBES = {
    "healthcare": {
        "base": {
            "model": {
                "domains": [
                    {"name": "patient", "products": [
                        {"name": "patient", "attributes": [{"name": "patient_id"}, {"name": "dob"}]},
                        {"name": "patient_coverage", "attributes": [{"name": "coverage_id"}]},
                    ]},
                    {"name": "encounter", "products": [
                        {"name": "visit", "attributes": [{"name": "visit_id"}, {"name": "patient_id"}]},
                    ]},
                    {"name": "pharmacy", "products": [
                        {"name": "prescription", "attributes": [{"name": "prescription_id"}]},
                    ]},
                ]
            }
        },
        "vibe_new_domain": "CREATE NEW DOMAIN behavioral_health with product behavioral_health.screening (screening_id, patient_id).\n"
                           "CREATE NEW DOMAIN clinical_ai with product clinical_ai.inference (inference_id).",
        "vibe_surgical": "Rename column pharmacy.prescription.dosage to pharmacy.prescription.dose_mg.",
        "new_entities": {("behavioral_health",), ("clinical_ai",)},
        "mentioned_entities": {("pharmacy", "prescription", "dosage")},
        "untouched_domains": {"patient", "encounter"},
    },
    "airlines": {
        "base": {
            "model": {
                "domains": [
                    {"name": "passenger", "products": [
                        {"name": "passenger", "attributes": [{"name": "passenger_id"}]},
                    ]},
                    {"name": "flight", "products": [
                        {"name": "leg", "attributes": [{"name": "leg_id"}, {"name": "aircraft_id"}]},
                    ]},
                    {"name": "crew", "products": [
                        {"name": "roster", "attributes": [{"name": "roster_id"}]},
                    ]},
                ]
            }
        },
        "vibe_new_domain": "CREATE NEW DOMAIN sustainability with product sustainability.fuel_consumption (consumption_id, leg_id).",
        "vibe_surgical": "Add foreign_key_to=passenger.passenger.passenger_id on flight.leg.passenger_id.",
        "new_entities": {("sustainability",)},
        "mentioned_entities": {("flight", "leg", "passenger_id")},
        "untouched_domains": {"passenger", "crew"},
    },
    "telecom": {
        "base": {
            "model": {
                "domains": [
                    {"name": "subscriber", "products": [
                        {"name": "account", "attributes": [{"name": "account_id"}]},
                    ]},
                    {"name": "network", "products": [
                        {"name": "cell_tower", "attributes": [{"name": "tower_id"}]},
                    ]},
                ]
            }
        },
        "vibe_new_domain": "INTRODUCE NEW DOMAIN iot with product iot.sensor (sensor_id, account_id).",
        "vibe_surgical": "Rename column network.cell_tower.lat to network.cell_tower.latitude.",
        "new_entities": {("iot",)},
        "mentioned_entities": {("network", "cell_tower", "lat")},
        "untouched_domains": {"subscriber"},
    },
    "retail": {
        "base": {
            "model": {
                "domains": [
                    {"name": "customer", "products": [
                        {"name": "customer", "attributes": [{"name": "customer_id"}]},
                    ]},
                    {"name": "order", "products": [
                        {"name": "order_header", "attributes": [{"name": "order_id"}]},
                    ]},
                ]
            }
        },
        "vibe_new_domain": "ADD NEW DOMAIN loyalty with product loyalty.points (point_id, customer_id).",
        "vibe_surgical": "Rename column order.order_header.tot to order.order_header.total_amount.",
        "new_entities": {("loyalty",)},
        "mentioned_entities": {("order", "order_header", "tot")},
        "untouched_domains": {"customer"},
    },
}


# ---------- P-COMPUTE-CLOSURE tests ----------

@pytest.mark.parametrize("industry", list(INDUSTRY_VIBES.keys()))
def test_compute_closure_extracts_new_domain_industry_agnostic(industry):
    vibe = INDUSTRY_VIBES[industry]["vibe_new_domain"]
    expected_new = INDUSTRY_VIBES[industry]["new_entities"]
    closure, new = VOV._compute_vov_user_closure(vibe)
    for e in expected_new:
        assert e in new, f"{industry}: expected NEW {e} in new_entities, got {sorted(new)}"
        assert e in closure, f"{industry}: expected NEW {e} in closure"


@pytest.mark.parametrize("industry", list(INDUSTRY_VIBES.keys()))
def test_compute_closure_extracts_surgical_target_industry_agnostic(industry):
    vibe = INDUSTRY_VIBES[industry]["vibe_surgical"]
    expected_mentioned = INDUSTRY_VIBES[industry]["mentioned_entities"]
    closure, new = VOV._compute_vov_user_closure(vibe)
    for e in expected_mentioned:
        assert e in closure, f"{industry}: expected mentioned {e} in closure, got {sorted(closure)[:10]}"


def test_compute_closure_empty_returns_empty():
    closure, new = VOV._compute_vov_user_closure("")
    assert closure == set() and new == set()
    closure, new = VOV._compute_vov_user_closure(None)
    assert closure == set() and new == set()


def test_compute_closure_ignores_common_words():
    vibe = "the user must add the column or attribute to the model"
    closure, new = VOV._compute_vov_user_closure(vibe)
    common = {"the", "user", "must", "add", "column", "or", "attribute", "to", "model"}
    for c in closure:
        for part in c:
            assert part not in common, f"common word {part} should not be in closure"


# ---------- P3 DIFF-GUARD tests ----------

@pytest.mark.parametrize("industry", list(INDUSTRY_VIBES.keys()))
def test_diff_guard_preserves_untouched_domains_industry_agnostic(industry):
    base = INDUSTRY_VIBES[industry]["base"]
    untouched = INDUSTRY_VIBES[industry]["untouched_domains"]
    # Simulate: output drifted — added EXTRA attribute to an untouched product
    out = copy.deepcopy(base["model"])
    for d in out["domains"]:
        if d["name"] in untouched:
            for p in d.get("products", []):
                p.setdefault("attributes", []).append({"name": "DRIFT_ATTR", "data_type": "STRING"})
    # User vibe says nothing about these domains
    user_closure = set()
    user_new = set()
    n, log = VOV._strict_vov_diff_guard(base, out, user_closure, user_new)
    assert n > 0, f"{industry}: drift should have been reverted"
    # Verify DRIFT_ATTR is gone
    for d in out["domains"]:
        if d["name"] in untouched:
            for p in d.get("products", []):
                attrs = [a.get("name") for a in p.get("attributes", [])]
                assert "DRIFT_ATTR" not in attrs, f"{industry}: DRIFT_ATTR should be removed from {d['name']}.{p['name']}"


@pytest.mark.parametrize("industry", list(INDUSTRY_VIBES.keys()))
def test_diff_guard_keeps_user_new_domains_industry_agnostic(industry):
    base = INDUSTRY_VIBES[industry]["base"]
    new_entities = INDUSTRY_VIBES[industry]["new_entities"]
    out = copy.deepcopy(base["model"])
    # Add new domains to output (simulating pipeline created them per user vibe)
    for (dname,) in new_entities:
        out["domains"].append({"name": dname, "products": [{"name": "test_product", "attributes": [{"name": "test_id"}]}]})
    closure = {e for e in new_entities}
    closure.update({(d_name, "test_product") for (d_name,) in new_entities})
    closure.update({(d_name, "test_product", "test_id") for (d_name,) in new_entities})
    new = set(closure)
    n, log = VOV._strict_vov_diff_guard(base, out, closure, new)
    # Verify all new domains survived
    out_names = {d["name"] for d in out["domains"]}
    for (dname,) in new_entities:
        assert dname in out_names, f"{industry}: new domain {dname} should survive diff guard"


@pytest.mark.parametrize("industry", list(INDUSTRY_VIBES.keys()))
def test_diff_guard_restores_dropped_untouched_domains_industry_agnostic(industry):
    base = INDUSTRY_VIBES[industry]["base"]
    untouched = INDUSTRY_VIBES[industry]["untouched_domains"]
    out = copy.deepcopy(base["model"])
    # Simulate: pipeline dropped an untouched domain
    dropped_name = sorted(untouched)[0]
    out["domains"] = [d for d in out["domains"] if d["name"] != dropped_name]
    closure = set()
    new = set()
    n, log = VOV._strict_vov_diff_guard(base, out, closure, new)
    # The dropped domain should be restored
    out_names = {d["name"] for d in out["domains"]}
    assert dropped_name in out_names, f"{industry}: dropped untouched domain {dropped_name} should be restored"
    assert any(op == "RESTORE_DOMAIN" and tgt == dropped_name for op, tgt in log)


def test_diff_guard_drops_phantom_domain_not_in_user_vibe():
    base = {"model": {"domains": [{"name": "patient", "products": []}]}}
    out = {"domains": [{"name": "patient"}, {"name": "phantom_made_up_thing"}]}
    closure = set()
    new = set()
    n, log = VOV._strict_vov_diff_guard(base, out, closure, new)
    out_names = {d["name"] for d in out["domains"]}
    assert "phantom_made_up_thing" not in out_names, "phantom domain not in user vibe should be dropped"
    assert any(op == "DROP_PHANTOM_DOMAIN" and tgt == "phantom_made_up_thing" for op, tgt in log)


def test_diff_guard_keeps_user_touched_domain_modifications():
    """A user-touched domain keeps its modified products/attrs; untouched products inside REVERT."""
    base = {"model": {"domains": [
        {"name": "pharmacy", "products": [
            {"name": "prescription", "attributes": [
                {"name": "dosage", "data_type": "STRING"},
                {"name": "patient_id", "data_type": "BIGINT"},
            ]},
            {"name": "inventory", "attributes": [{"name": "stock_id"}]},
        ]}
    ]}}
    out = {"domains": [
        {"name": "pharmacy", "products": [
            {"name": "prescription", "attributes": [
                {"name": "dosage", "data_type": "STRING"},
                {"name": "patient_id", "data_type": "BIGINT"},
                {"name": "DRIFT_INSIDE_TOUCHED", "data_type": "STRING"},
            ]},
            {"name": "inventory", "attributes": [{"name": "stock_id"}, {"name": "DRIFT_UNTOUCHED", "data_type": "STRING"}]},
        ]}
    ]}
    # User touched pharmacy.prescription.dosage only
    closure = {("pharmacy",), ("pharmacy", "prescription"), ("pharmacy", "prescription", "dosage")}
    new = set()
    n, log = VOV._strict_vov_diff_guard(base, out, closure, new)
    # pharmacy.prescription is touched -> kept (including DRIFT_INSIDE_TOUCHED because no per-attr guard for non-mentioned attrs in user-touched products)
    # Actually: the diff guard recurses into touched products. For attrs not in closure, it reverts/drops.
    pharma = out["domains"][0]
    prescription = next(p for p in pharma["products"] if p["name"] == "prescription")
    attr_names = [a["name"] for a in prescription["attributes"]]
    assert "dosage" in attr_names
    assert "patient_id" in attr_names
    assert "DRIFT_INSIDE_TOUCHED" not in attr_names, f"non-mentioned attrs inside touched product should be dropped, got: {attr_names}"
    inventory = next(p for p in pharma["products"] if p["name"] == "inventory")
    inv_attrs = [a["name"] for a in inventory["attributes"]]
    assert "DRIFT_UNTOUCHED" not in inv_attrs, f"untouched product inside touched domain should be reverted, got: {inv_attrs}"


def test_diff_guard_no_op_when_input_empty():
    """For new-base-model runs (no context_file), diff guard is a no-op."""
    out = {"domains": [{"name": "fresh_domain", "products": [{"name": "prod"}]}]}
    out_copy_before = copy.deepcopy(out)
    n, log = VOV._strict_vov_diff_guard({}, out, set(), set())
    assert n == 0
    assert out == out_copy_before


def test_diff_guard_no_op_when_perfect_additive():
    """If output is base + user-new entities, diff guard makes zero changes."""
    base = {"model": {"domains": [
        {"name": "patient", "products": [{"name": "patient", "attributes": [{"name": "patient_id"}]}]},
        {"name": "encounter", "products": [{"name": "visit", "attributes": [{"name": "visit_id"}]}]},
    ]}}
    out = {"domains": [
        {"name": "patient", "products": [{"name": "patient", "attributes": [{"name": "patient_id"}]}]},
        {"name": "encounter", "products": [{"name": "visit", "attributes": [{"name": "visit_id"}]}]},
        {"name": "behavioral_health", "products": [{"name": "screening", "attributes": [{"name": "screening_id"}]}]},
    ]}
    closure = {("behavioral_health",), ("behavioral_health", "screening"), ("behavioral_health", "screening", "screening_id")}
    new = set(closure)
    n, log = VOV._strict_vov_diff_guard(base, out, closure, new)
    assert n == 0, f"perfect-additive should be 0 reverts, got {n} ops={log[:5]}"


# ---------- VERSION TESTS (P0: ensure __AGENT_VERSION__ is bumped) ----------

def test_agent_version_constant_bumped_to_073():
    nb = json.loads(NOTEBOOK_PATH.read_text(encoding="utf-8"))
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+\.\d+\.\d+)"', src)
        if m:
            assert m.group(1) == "0.7.3", f"expected v0.7.3, found {m.group(1)}"
            return
    pytest.fail("__AGENT_VERSION__ literal not found in any code cell")


def test_v073_aliases_present_in_notebook():
    """Every fix must carry a sentinel grep anchor (CLAUDE.md §10.5)."""
    src = NOTEBOOK_PATH.read_text(encoding="utf-8")
    for alias in [
        "vov-widget-wins-bc-builder",
        "vov-auto-next-vibes-keyfix-v2",
        "vov-closure-extract",
        "vov-closure-plumb",
        "vov-strict-mode",
        "vov-strict-diff-guard",
        "vov-strict-diff-guard-summary",
        "vov-strict-helpers",
    ]:
        assert src.count(alias) >= 1, f"alias {alias!r} missing from notebook"


def test_p1_widget_vibe_wins_in_bc_builder_present():
    """P1 fix at the new-format bc_section builder."""
    src = NOTEBOOK_PATH.read_text(encoding="utf-8")
    # the bc_section builder now prefers _eff_vibes_content over _model_section
    assert "vov-widget-wins-bc-builder FIRED" in src
    # and the conditional `_eff_vibes_content if _eff_vibes_content else _model_section.get` is present
    assert "_eff_vibes_content\\n" in src or "_eff_vibes_content\n" in src


def test_p3_diff_guard_call_at_writeback_present():
    """Diff guard must be called in step_generate_data_model_json before model_json_root build."""
    src = NOTEBOOK_PATH.read_text(encoding="utf-8")
    assert "_strict_vov_diff_guard(_vov_input_root, data_model, _vov_closure_w, _vov_new_w" in src
    assert "STRICT_VOV" in src


def test_p9_gate_uses_widget_raw_values():
    """P9 fix must read _widget_raw_values (the dict that's actually populated)."""
    src = NOTEBOOK_PATH.read_text(encoding="utf-8")
    assert "_widget_raw_values" in src
    assert "model_vibes_source" in src
