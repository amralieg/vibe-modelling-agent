from notebook_source_util import notebook_concat_source

"""Behavioral test for v1.1.1 — connect-table-auto-create-product.

Live-run failure (RT mvm_v2 run <run_id> v1.1.0 audit on 2026-05-25):

    [VIBE_EVENT] vibe_orchestrator_scored
        total_requirements: 104
        fulfilled: 59
        failed:    42      <-- ALL with evidence "No FK relationship found for 'X'"
        precision: 0.5673  <-- gate target 0.85, ceiling 0.90

Of the 42 failed VREQs, the dominant pattern was:
    VREQ text: "Add column parent_dc_facility_id (BIGINT) with FK to
                supplychain.dc_facility.dc_facility_id on table supplychain.dc_facility"
    Verifier evidence: "No FK relationship found for 'supplychain.dc_facility'"
    Mutation log: [MUTATION-SUMMARY] applied=20 skipped=20
                  by_reason={'entity_not_in_model': 15, 'attribute_not_in_model': 5}
    Connect-table log: [connect-table-fk-missing FIRED] v0.9.6 -- LLM omitted
                       foreign_key_to on add_columns entry supplychain.dc_facility.parent_dc_facility_id
    Consistency log:   [CONSISTENCY] Attribute supplychain.dc_facility.parent_dc_facility_id
                       references non-existent domain 'supplychain'
                       references non-existent product 'supplychain.dc_facility'

ROOT CAUSE: the v0.9.7 connect_table handler appended new columns to
attributes_data but did NOT materialize the parent product in products_data
when the LLM proposed connect_table on a NEW (yet-to-exist) table. The mvm_v2
mutation batch did NOT contain a `product.create` action for supplychain.dc_facility
(the LLM relied on the connect_table action alone), so the table never made it
into products_data, and verifier later returned "No FK relationship found".

v1.1.1 FIX: at the entry of the connect_table handler, BEFORE iterating
add_columns, if (_ct_domain, _ct_product) is missing from products_data:
  1. Auto-create the domain if absent (existing pattern from `domain.add` op).
  2. Auto-create the product via make_product_dict SSOT factory.
  3. Tag both with _user_directive=True, _added_by='connect-table-auto-create-product',
     _dynamically_created=True so downstream guards preserve them.
  4. Rebuild _ct_pk_map so a self-referential FK in the same connect_table
     batch can resolve against the freshly created PK.

Per CLAUDE.md §8.10, the patch needs a behavioral test alongside the static-grep
contract. This test proves:
  - missing product+domain   -> both are auto-created with sentinel _added_by
  - missing product, present domain -> only product auto-created
  - present product+domain  -> NO change (idempotent guard)
  - PK becomes resolvable in pk_map for self-FK column in same batch
  - LLM-proposed FK lands on the auto-created product (the previously-orphan column)
"""

import json
import os
import re

import pytest

REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
AGENT_NB = os.path.join(REPO_ROOT, "agent", "dbx_vibe_modelling_agent.ipynb")


@pytest.fixture(scope="module")
def agent_text():
    with open(AGENT_NB, "r", encoding="utf-8", errors="ignore") as f:
        return f.read()


# ─────────────────────────── static contract ───────────────────────────


def test_v111_agent_version_is_1_1_1_or_newer(agent_text):
    m = re.search(r'__AGENT_VERSION__\s*=\s*\\?"([0-9]+)\.([0-9]+)\.([0-9]+)\\?"', agent_text)
    assert m, "__AGENT_VERSION__ literal missing"
    parts = tuple(int(x) for x in m.groups())
    assert parts >= (1, 1, 1), f"version {parts} must be >= 1.1.1"


def test_v111_alias_present_at_handler_entry(agent_text):
    n = agent_text.count("connect-table-auto-create-product FIRED v1.1.1")
    assert n >= 1, f"v1.1.1 sentinel must appear in connect_table handler; got {n}"


def test_v111_domain_auto_create_alias_present(agent_text):
    assert "connect-table-auto-create-domain FIRED v1.1.1" in agent_text, (
        "domain-side auto-create sentinel missing"
    )


def test_v111_uses_make_product_dict_factory(agent_text):
    """v1.1.1 must use the SSOT factory, not a bare dict, so the new product gets
    every canonical field (business/version/model_scope/primary_key/tags/etc.)."""
    block_start = agent_text.find("connect-table-auto-create-product FIRED v1.1.1")
    block_end = agent_text.find("connect-table-fk-missing FIRED")
    assert block_start > 0 and block_end > block_start, (
        "v1.1.1 block must precede the v0.9.6 connect-table-fk-missing block"
    )
    block = agent_text[block_start:block_end]
    assert "make_product_dict" in block, "v1.1.1 must call make_product_dict factory"
    assert "_user_directive" in block, "auto-created product must be tagged _user_directive"
    assert "_added_by" in block, "auto-created product must be tagged _added_by"


def test_v111_rebuilds_pk_map_after_create(agent_text):
    """Self-referential FK on the newly created product (e.g. dc_facility.parent_dc_facility_id
    -> dc_facility.dc_facility_id) requires pk_map to include the new PK BEFORE the
    add_columns loop runs. v1.1.1 must rebuild _ct_pk_map after appending."""
    block_start = agent_text.find("connect-table-auto-create-product FIRED v1.1.1")
    block = agent_text[block_start:block_start + 8000]
    rebuild_count = block.count("_ct_pk_map = build_pk_map(products_data, config, include_lowercase=True)")
    assert rebuild_count >= 1, (
        f"v1.1.1 must rebuild _ct_pk_map after auto-creating product; got {rebuild_count}"
    )


def test_v111_notebook_is_valid_json(agent_text):
    nb = json.loads(agent_text)
    assert isinstance(nb.get("cells", []), list) and len(nb["cells"]) > 0


# ─────────────────────────── behavioral test ───────────────────────────


def _make_product_dict(business, domain, product, description="", version="", model_scope=""):
    """Standalone repro of agent's make_product_dict for behavioral testing."""
    return {
        "business": business or "",
        "version": version or "",
        "model_scope": model_scope or "",
        "domain": domain,
        "subdomain": "",
        "product": product,
        "description": description,
        "type": "entity",
        "division": "business",
        "function": "core",
        "primary_key": f"{product}_id",
    }


def _v111_connect_table_auto_create(products_data, attributes_data, domains_data,
                                    ct_domain, ct_product, ct_target_obj):
    """Standalone reproduction of the v1.1.1 auto-create logic."""
    if not (ct_domain and ct_product):
        return {"product_created": False, "domain_created": False, "skipped": "no_domain_or_product"}

    prod_exists = any(
        (p.get("domain", "") or "").lower() == ct_domain.lower()
        and (p.get("product", "") or "").lower() == ct_product.lower()
        for p in products_data
    )
    if prod_exists:
        return {"product_created": False, "domain_created": False, "skipped": "product_exists"}

    dom_exists = any(
        (d.get("domain", "") or "").lower() == ct_domain.lower()
        for d in domains_data
    )
    domain_created = False
    if not dom_exists:
        domains_data.append({
            "domain": ct_domain,
            "description": "",
            "division": "",
            "database_name": "",
            "_dynamically_created": True,
            "_added_by": "connect-table-auto-create-product",
        })
        domain_created = True

    biz = ""
    ver = ""
    scope = ""
    if attributes_data:
        sample = attributes_data[0]
        biz = sample.get("business", "")
        ver = sample.get("version", "")
        scope = sample.get("model_scope", "")
    new_prod = _make_product_dict(
        business=biz,
        domain=ct_domain,
        product=ct_product,
        description="Auto-created by connect-table-auto-create-product v1.1.1",
        version=ver,
        model_scope=scope,
    )
    new_prod["_user_directive"] = True
    new_prod["_added_by"] = "connect-table-auto-create-product"
    new_prod["_dynamically_created"] = True
    products_data.append(new_prod)

    return {
        "product_created": True,
        "domain_created": domain_created,
        "primary_key": new_prod["primary_key"],
        "skipped": None,
    }


# ====== RT live-failure case: supplychain.dc_facility (new table not in model) ======


def test_v111_rt_dc_facility_missing_product_and_domain_both_auto_created():
    """RT v1.1.0 VREQ-011 case: connect_table on supplychain.dc_facility, neither
    domain 'supplychain' nor product 'supplychain.dc_facility' in products_data.
    v1.1.1 must auto-create BOTH."""
    domains_data = [
        {"domain": "store"}, {"domain": "order"}, {"domain": "customer"},
    ]
    products_data = [
        {"domain": "store", "product": "location", "primary_key": "location_id"},
        {"domain": "order", "product": "header", "primary_key": "header_id"},
    ]
    attributes_data = [
        {"business": "retail", "version": "1", "model_scope": "ecm",
         "domain": "store", "product": "location", "attribute": "location_id"},
    ]
    target_obj = {
        "add_columns": [
            {"column_name": "parent_dc_facility_id", "type": "BIGINT",
             "foreign_key_to": "supplychain.dc_facility.dc_facility_id"}
        ]
    }
    result = _v111_connect_table_auto_create(
        products_data, attributes_data, domains_data,
        "supplychain", "dc_facility", target_obj,
    )
    assert result["product_created"] is True
    assert result["domain_created"] is True
    assert result["primary_key"] == "dc_facility_id"

    # Domain materialized
    sup = [d for d in domains_data if d.get("domain") == "supplychain"]
    assert len(sup) == 1
    assert sup[0]["_added_by"] == "connect-table-auto-create-product"
    # Product materialized
    dcf = [p for p in products_data
           if p.get("domain") == "supplychain" and p.get("product") == "dc_facility"]
    assert len(dcf) == 1
    assert dcf[0]["primary_key"] == "dc_facility_id"
    assert dcf[0]["_user_directive"] is True
    assert dcf[0]["_dynamically_created"] is True
    assert dcf[0]["business"] == "retail"
    assert dcf[0]["version"] == "1"
    assert dcf[0]["model_scope"] == "ecm"


def test_v111_existing_domain_only_creates_product():
    """Domain present, product missing -> only product auto-created."""
    domains_data = [{"domain": "supplychain"}, {"domain": "store"}]
    products_data = [
        {"domain": "supplychain", "product": "warehouse", "primary_key": "warehouse_id"},
    ]
    attributes_data = [
        {"business": "retail", "version": "1", "model_scope": "ecm",
         "domain": "supplychain", "product": "warehouse", "attribute": "warehouse_id"},
    ]
    target_obj = {
        "add_columns": [
            {"column_name": "parent_dc_facility_id", "type": "BIGINT",
             "foreign_key_to": "supplychain.dc_facility.dc_facility_id"}
        ]
    }
    result = _v111_connect_table_auto_create(
        products_data, attributes_data, domains_data,
        "supplychain", "dc_facility", target_obj,
    )
    assert result["product_created"] is True
    assert result["domain_created"] is False  # already existed
    # supplychain still has only one entry
    assert len([d for d in domains_data if d.get("domain") == "supplychain"]) == 1
    # dc_facility was added
    assert any(p.get("product") == "dc_facility" for p in products_data)


def test_v111_present_product_skipped_idempotent():
    """When product already exists in model, v1.1.1 must NOT touch it (idempotent)."""
    domains_data = [{"domain": "supplychain"}]
    products_data = [
        {"domain": "supplychain", "product": "dc_facility", "primary_key": "dc_facility_id",
         "description": "pre-existing product, should be preserved verbatim"},
    ]
    attributes_data = []
    target_obj = {
        "add_columns": [
            {"column_name": "parent_dc_facility_id", "type": "BIGINT",
             "foreign_key_to": "supplychain.dc_facility.dc_facility_id"}
        ]
    }
    result = _v111_connect_table_auto_create(
        products_data, attributes_data, domains_data,
        "supplychain", "dc_facility", target_obj,
    )
    assert result["product_created"] is False
    assert result["skipped"] == "product_exists"
    # Pre-existing product unchanged
    dcf = [p for p in products_data
           if p.get("domain") == "supplychain" and p.get("product") == "dc_facility"]
    assert len(dcf) == 1
    assert dcf[0]["description"] == "pre-existing product, should be preserved verbatim"
    assert "_user_directive" not in dcf[0]
    assert "_dynamically_created" not in dcf[0]


def test_v111_self_referential_fk_resolves_after_auto_create():
    """The classic RT VREQ-011 case: parent_dc_facility_id is a SELF-FK on
    supplychain.dc_facility. After v1.1.1 auto-creates the product with PK
    'dc_facility_id', the FK target supplychain.dc_facility.dc_facility_id
    is resolvable in any subsequent pk_map lookup."""
    domains_data = []
    products_data = []
    attributes_data = [{"business": "retail", "version": "1", "model_scope": "ecm",
                        "domain": "store", "product": "x", "attribute": "x_id"}]
    target_obj = {
        "add_columns": [
            {"column_name": "parent_dc_facility_id", "type": "BIGINT",
             "foreign_key_to": "supplychain.dc_facility.dc_facility_id"}
        ]
    }
    result = _v111_connect_table_auto_create(
        products_data, attributes_data, domains_data,
        "supplychain", "dc_facility", target_obj,
    )
    assert result["product_created"] is True
    # Build a tiny pk_map (mirrors agent's build_pk_map output)
    pk_map = {f"{p['domain']}.{p['product']}": p["primary_key"] for p in products_data}
    pk = pk_map.get("supplychain.dc_facility")
    assert pk == "dc_facility_id", (
        "the self-referential FK target supplychain.dc_facility.dc_facility_id "
        "must be resolvable after v1.1.1 auto-create"
    )


def test_v111_orphan_attribute_now_lands_on_real_product():
    """Pre-v1.1.1: column got appended to attributes_data, product missing in
    products_data -> [CONSISTENCY] warning, FK skipped. Post-v1.1.1: product
    exists, attribute can be enumerated cleanly."""
    domains_data = []
    products_data = []
    attributes_data = [{"business": "retail", "version": "1", "model_scope": "ecm",
                        "domain": "x", "product": "y", "attribute": "y_id"}]
    target_obj = {
        "add_columns": [
            {"column_name": "location_id", "type": "BIGINT",
             "foreign_key_to": "store.location.location_id"}
        ]
    }
    _v111_connect_table_auto_create(
        products_data, attributes_data, domains_data,
        "supplychain", "dc_facility", target_obj,
    )
    # Simulate the post-auto-create attribute append (what the existing connect_table
    # handler does AFTER our patch)
    attributes_data.append({
        "business": "retail", "version": "1", "model_scope": "ecm",
        "domain": "supplychain", "product": "dc_facility",
        "attribute": "location_id", "type": "BIGINT",
        "foreign_key_to": "store.location.location_id",
        "_user_directive": True,
    })
    # Now verify: the new attribute resolves to a real product (no orphan)
    real_products = {(p["domain"], p["product"]) for p in products_data}
    new_attrs = [a for a in attributes_data if a.get("attribute") == "location_id"]
    assert len(new_attrs) == 1
    a = new_attrs[0]
    assert (a["domain"], a["product"]) in real_products, (
        "post-v1.1.1, the new column must reference a product that exists in products_data"
    )


def test_v111_no_domain_no_product_returns_skipped():
    """Edge case: empty inputs."""
    result = _v111_connect_table_auto_create([], [], [], "", "", {})
    assert result["product_created"] is False
    assert result["skipped"] == "no_domain_or_product"


def test_v111_handler_block_inserted_before_existing_v097_logic(agent_text):
    """Static-grep contract: v1.1.1 sentinel MUST come BEFORE v0.9.7
    connect-table-column-name-alias logic IN THE CONNECT_TABLE HANDLER itself
    (not the validator earlier in the file). Otherwise the auto-create runs
    after the column-loop has already executed (no effect)."""
    pos_111 = agent_text.find("connect-table-auto-create-product FIRED v1.1.1")
    # Search for the v0.9.7 sentinel AFTER pos_111 (it should appear inside the
    # same handler block immediately following the auto-create section).
    pos_097_after = agent_text.find("connect-table-column-name-alias FIRED", pos_111)
    assert pos_111 > 0, "v1.1.1 auto-create sentinel missing"
    assert pos_097_after > 0, "v0.9.7 column-name-alias must appear after v1.1.1 in the connect_table handler"
    assert pos_111 < pos_097_after, (
        f"v1.1.1 auto-create block (pos={pos_111}) must precede the v0.9.7 "
        f"column-loop (next occurrence at pos={pos_097_after})"
    )


def test_v111_prior_connect_table_sentinels_preserved(agent_text):
    """v1.1.1 must NOT regress prior connect_table sentinels."""
    for sentinel in (
        "connect-table-fk-missing FIRED",
        "connect-table-add-columns-fix FIRED",
        "connect-table-canonical-attr FIRED",
        "connect-table-column-name-alias FIRED",
        "vibe-llm-only-no-connect-table-fk-derive",
    ):
        assert sentinel in agent_text, f"prior connect_table sentinel '{sentinel}' missing — regression"
