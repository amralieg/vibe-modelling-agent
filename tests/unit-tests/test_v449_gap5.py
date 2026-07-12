import json
import os
import re
import types

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _cells():
    nb = json.load(open(NB))
    return ["".join(c.get("source", [])) if isinstance(c.get("source"), list) else (c.get("source") or "")
            for c in nb["cells"]]


def _slice_def(src, name):
    """Slice a top-level `def <name>` (or method `    def <name>`) block out of a cell source."""
    lines = src.splitlines()
    start = None
    base = 0
    for i, l in enumerate(lines):
        if re.match(r"^(\s*)def %s\b" % re.escape(name), l):
            start = i
            base = len(l) - len(l.lstrip())
            break
    assert start is not None, "def %s not found" % name
    end = start + 1
    while end < len(lines):
        l = lines[end]
        if l.strip() and (len(l) - len(l.lstrip())) <= base and (l.lstrip().startswith(("def ", "class "))):
            break
        end += 1
    body = "\n".join(lines[start:end])
    # de-indent a method to module level so it can exec standalone
    if base:
        body = "\n".join(ln[base:] if ln[:base].strip() == "" else ln for ln in body.splitlines())
    return body


def _load_parser_and_finalizer():
    cells = _cells()
    ns = {"re": re}
    exec(_slice_def(cells[56], "_vov_named_create_targets"), ns)
    exec(_slice_def(cells[138], "_v441_reviewer_finalization"), ns)
    return ns


def _load_pcc():
    """_verify_product_create_coverage sliced as a standalone fn; drop leading `self` at call."""
    cells = _cells()
    ns = {"re": re}
    exec(_slice_def(cells[56], "_vov_named_create_targets"), ns)
    body = _slice_def(cells[100], "_verify_product_create_coverage")
    exec(body, ns)
    return ns


# real reviewer directive text (shipping & ports R1..R9), verbatim shape
R1 = ("REVIEWER-PRIORITY 1 - add_product: cargo.transhipment - model transhipment (T/S) as a FIRST-CLASS "
      "concept, not a generic container visit. Add product cargo.transhipment (a T/S move that links an "
      "inbound vessel call to an outbound vessel call) plus cargo.transhipment_leg. "
      "FK the transhipment to the existing inbound/outbound vessel.call and cargo.container.")
R2 = ("REVIEWER-PRIORITY 2 - add_product: cargo.empty_container_pool - add empty container / MTY pool / depot "
      "operations. Add products cargo.empty_container_pool (MTY pool balance), cargo.container_depot (depot "
      "facility), cargo.container_lease (leasing agreement), and cargo.depot_repair_order (M&R work order).")
R4 = ("REVIEWER-PRIORITY 4 - add_domain: sustainability - create a new FIRST-CLASS domain sustainability in "
      "the operations division for decarbonization tracking, with products cii_rating, eexi_record, "
      "shore_power_session, and bunker_carbon_intensity. Classify sustainability as division=operations; "
      "FK to masterdata.vessel_master and vessel.call where relevant.")

FULL = "\n".join([R1, R2, R4])


def _fake_req(text, scope="domain", scope_targets=None, rid="VREQ-005"):
    r = types.SimpleNamespace()
    r.original_text = text
    r.scope = scope
    r.scope_targets = scope_targets or []
    r.id = rid
    return r


# ---------------------------------------------------------------- parser
def test_parser_extracts_add_product_targets():
    ns = _load_parser_and_finalizer()
    tg = ns["_vov_named_create_targets"](R1)
    assert ("cargo", "transhipment") in tg["products"], tg["products"]
    assert ("cargo", "transhipment_leg") in tg["products"], tg["products"]
    # FK-target 'the existing ... vessel.call' must NOT be a create target
    assert ("vessel", "call") not in tg["products"], tg["products"]


def test_parser_extracts_multi_product_list():
    ns = _load_parser_and_finalizer()
    tg = ns["_vov_named_create_targets"](R2)
    prods = set(tg["products"])
    for p in ["empty_container_pool", "container_depot", "container_lease", "depot_repair_order"]:
        assert ("cargo", p) in prods, (p, prods)


def test_parser_extracts_add_domain_with_products():
    ns = _load_parser_and_finalizer()
    tg = ns["_vov_named_create_targets"](R4)
    assert "sustainability" in tg["domains"]
    meta = tg["domain_meta"]["sustainability"]
    assert meta["division"] == "operations", meta
    for p in ["cii_rating", "eexi_record", "shore_power_session", "bunker_carbon_intensity"]:
        assert p in meta["products"], (p, meta["products"])


# ---------------------------------------------------------------- finalizer P0-create (behavioral)
def _base_model():
    # cargo exists (so a domain-present verifier would false-fulfill), but transhipment is absent;
    # sustainability domain is entirely absent.
    return {"model": {"domains": [
        {"name": "cargo", "products": [
            {"name": "container", "primary_key": "container_id",
             "attributes": [{"name": "container_id", "type": "BIGINT", "is_primary_key": True}]}]},
        {"name": "vessel", "products": [
            {"name": "call", "primary_key": "call_id",
             "attributes": [{"name": "call_id", "type": "BIGINT", "is_primary_key": True}]},
            {"name": "vessel_master", "primary_key": "vessel_master_id",
             "attributes": [{"name": "vessel_master_id", "type": "BIGINT", "is_primary_key": True}]}]},
        {"name": "masterdata", "products": [
            {"name": "vessel_master", "primary_key": "vessel_master_id",
             "attributes": [{"name": "vessel_master_id", "type": "BIGINT", "is_primary_key": True}]}]},
    ]}}


def _all_products(model):
    out = []
    for d in model["model"]["domains"]:
        for p in (d.get("products") or d.get("data_products") or []):
            out.append((d["name"], p["name"]))
    return out


def test_finalizer_materializes_missing_products_and_domain():
    ns = _load_parser_and_finalizer()
    m = _base_model()
    ns["_v441_reviewer_finalization"](m, FULL, logger=None)
    prods = _all_products(m)
    names = {p for (_d, p) in prods}
    # R1/R2 add_product targets now exist
    for p in ["transhipment", "transhipment_leg", "empty_container_pool", "container_depot",
              "container_lease", "depot_repair_order"]:
        assert p in names, (p, sorted(names))
    # R4 add_domain sustainability exists with its 4 products
    doms = {d["name"]: d for d in m["model"]["domains"]}
    assert "sustainability" in doms, list(doms)
    sp = {pp["name"] for pp in (doms["sustainability"].get("products") or doms["sustainability"].get("data_products") or [])}
    for p in ["cii_rating", "eexi_record", "shore_power_session", "bunker_carbon_intensity"]:
        assert p in sp, (p, sp)
    # every created product has a primary key (not a bare silo shell)
    for d in m["model"]["domains"]:
        for p in (d.get("products") or d.get("data_products") or []):
            assert any(a.get("is_primary_key") for a in p.get("attributes", [])), (d["name"], p["name"])


def test_finalizer_idempotent_no_dup():
    ns = _load_parser_and_finalizer()
    m = _base_model()
    ns["_v441_reviewer_finalization"](m, FULL, logger=None)
    n1 = len(_all_products(m))
    ns["_v441_reviewer_finalization"](m, FULL, logger=None)
    n2 = len(_all_products(m))
    assert n1 == n2, ("re-running finalization must not duplicate", n1, n2)


# ---------------------------------------------------------------- verifier honesty (fail-pre/pass-post)
def test_verifier_scope_domain_named_product_scores_failed_when_missing():
    ns = _load_pcc()
    fn = ns["_verify_product_create_coverage"]
    self = types.SimpleNamespace(logger=types.SimpleNamespace(info=lambda *a, **k: None))
    products_data = [{"domain": "cargo", "product": "container"}]  # transhipment absent
    req = _fake_req(R1, scope="domain", rid="VREQ-005")
    verdict = fn(self, req, products_data)
    # v4.4.8 bug returned None (scope==domain bail) -> LLM fallback false-fulfilled.
    # v4.4.9 must return an authoritative non-fulfilled verdict.
    assert verdict is not None, "must not fall through for a domain-scoped named-product create"
    assert verdict["status"] in ("failed", "partial"), verdict
    assert verdict["status"] == "failed", verdict  # 0 of {transhipment,transhipment_leg} exist


def test_verifier_scores_fulfilled_when_products_present():
    ns = _load_pcc()
    fn = ns["_verify_product_create_coverage"]
    self = types.SimpleNamespace(logger=types.SimpleNamespace(info=lambda *a, **k: None))
    products_data = [{"domain": "cargo", "product": "container"},
                     {"domain": "cargo", "product": "transhipment"},
                     {"domain": "cargo", "product": "transhipment_leg"}]
    req = _fake_req(R1, scope="domain", rid="VREQ-005")
    verdict = fn(self, req, products_data)
    assert verdict is not None and verdict["status"] == "fulfilled", verdict


if __name__ == "__main__":
    import sys
    sys.exit(pytest.main([__file__, "-v"]))
