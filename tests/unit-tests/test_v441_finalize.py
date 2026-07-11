"""v4.4.1 behavioral tests — the reviewer-directive FINALIZATION pass that runs at the model.json
serialization boundary (CLAUDE.md 8.10). Exercises the REAL notebook function
`_v441_reviewer_finalization` sliced from agent/dbx_vibe_modelling_agent.ipynb.

Fail-pre proof: on the v4.4.0 HEAD the function does not exist, so `slice_functions` raises
LookupError -> every test errors. Pass-post: the function exists and enforces P2/P6/P7/P9/P12 on
the final nested data_model, so the shipped model.json actually carries the reviewer directives even
when the earlier pass-1 deterministic handlers are undone downstream.

Generic: the pass reads the reviewer's own FQNs / domain names from the vibe text; the test asserts
NO hardcoding of "retail"/"customer" by using a DIFFERENT root domain name ("member") in one case.
"""
import re

from v435_helpers import concat_source, slice_functions


class _Log:
    def info(self, *a, **k):
        pass

    def warning(self, *a, **k):
        pass

    def error(self, *a, **k):
        pass

    def debug(self, *a, **k):
        pass


def _finalize_ns():
    return slice_functions(["_v441_reviewer_finalization"], concat_source(),
                           extra_globals={"re": re})


# Reviewer directive text mirroring the retail SME review shape, but the tests below also run a
# second domain name to prove genericity.
REVIEWER_TEXT = (
    "The customer domain is a ROOT master-data domain; master entities are pointed TO, not OUT.\n\n"
    'REVIEWER-PRIORITY 2 - vendor_neutral_descriptions: strip vendor names.\n'
    '  - "Informatica MDM" -> "the customer master data system"\n'
    '  - "Salesforce Service Cloud" -> "the case management system"\n'
    '  - remove brand examples such as "Nike" from descriptions.\n\n'
    "REVIEWER-PRIORITY 6 - split_preference_god_table: customer.preference crams many concepts into "
    "one EAV-style table. Split it into focused tables: customer.communication_preference, "
    "customer.dietary_restriction, and a small generic customer.customer_attribute(key, value) "
    "extensibility table for the long tail. Do not keep a single catch-all preference table.\n\n"
    "REVIEWER-PRIORITY 7 - rehome_non_identity_products: move customer.segment to a marketing domain "
    "(marketing-analytics construct, not identity).\n\n"
    "REVIEWER-PRIORITY 9 - fk_direction_correctness: the customer master must not point OUT to "
    "transactional domains; prune those cross-domain FKs.\n"
)


def _base_model():
    return {
        "model": {
            "domains": [
                {
                    "name": "customer",
                    "products": [
                        {
                            "name": "profile",
                            "attributes": [
                                {"name": "profile_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"},
                                {"name": "source_system_code", "type": "STRING",
                                 "description": "Populated by Informatica MDM for the golden record; sample brand such as Nike."},
                                {"name": "email", "type": "STRING", "description": "Email address.",
                                 "business_glossary_term": "Email",
                                 "tag_set": [{"key": "dbx_business_glossary_term", "value": "Email"},
                                             {"key": "pii", "value": "true"}]},
                                {"name": "status_code", "type": "INT", "description": "Status.",
                                 "value_regex": "^[0-9]+$",
                                 "tag_set": [{"key": "dbx_value_regex", "value": "^[0-9]+$"}]},
                                {"name": "region_name", "type": "STRING", "description": "Region name descriptor.",
                                 "business_glossary_term": "Customer Home Region",
                                 "tag_set": [{"key": "dbx_business_glossary_term", "value": "Customer Home Region"}]},
                            ],
                        },
                        {
                            "name": "preference",
                            "attributes": [
                                {"name": "preference_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"},
                                {"name": "preference_value", "type": "STRING", "description": "A value."},
                            ],
                        },
                        {
                            "name": "segment",
                            "attributes": [
                                {"name": "segment_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"},
                            ],
                        },
                        {
                            "name": "loyalty",
                            "attributes": [
                                {"name": "loyalty_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"},
                                {"name": "campaign_id", "type": "BIGINT", "foreign_key_to": "marketing.campaign.campaign_id", "tags": "foreign_key"},
                                {"name": "location_id", "type": "BIGINT", "foreign_key_to": "store.location.location_id", "tags": "foreign_key"},
                                {"name": "profile_id", "type": "BIGINT", "foreign_key_to": "customer.profile.profile_id", "tags": "foreign_key"},
                            ],
                        },
                        {
                            "name": "wishlist",
                            "attributes": [
                                {"name": "wishlist_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"},
                                {"name": "campaign_id", "type": "BIGINT", "foreign_key_to": "marketing.campaign.campaign_id", "tags": "foreign_key"},
                            ],
                        },
                    ],
                },
                {
                    "name": "marketing",
                    "products": [
                        {"name": "segment", "attributes": [
                            {"name": "segment_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"}]},
                        {"name": "campaign", "attributes": [
                            {"name": "campaign_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"}]},
                    ],
                },
                {
                    "name": "store",
                    "products": [
                        {"name": "location", "attributes": [
                            {"name": "location_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"}]},
                    ],
                },
            ]
        }
    }


def _cust(dm):
    return next(d for d in dm["model"]["domains"] if d["name"] == "customer")


def _prod(dom, name):
    return next((p for p in dom["products"] if p["name"] == name), None)


def _attr(prod, name):
    return next((a for a in prod["attributes"] if a["name"] == name), None)


# ============================================================ P2
def test_p2_strips_vendor_root_and_examples_everywhere():
    ns = _finalize_ns()
    dm = _base_model()
    ns["_v441_reviewer_finalization"](dm, REVIEWER_TEXT, _Log())
    desc = _attr(_prod(_cust(dm), "profile"), "source_system_code")["description"].lower()
    assert "informatica" not in desc, desc
    assert "nike" not in desc, desc


def test_p2_token_joined_brand_root_scrubbed():
    """Brand root embedded in an underscore-joined token (INFORMATICA_MDM) must be scrubbed too."""
    ns = _finalize_ns()
    dm = _base_model()
    _attr(_prod(_cust(dm), "profile"), "source_system_code")["description"] = "Fed from INFORMATICA_MDM nightly."
    ns["_v441_reviewer_finalization"](dm, REVIEWER_TEXT, _Log())
    assert "informatica" not in _attr(_prod(_cust(dm), "profile"), "source_system_code")["description"].lower()


# ============================================================ P6
def test_p6_materializes_all_three_children_no_columns_lost():
    ns = _finalize_ns()
    dm = _base_model()
    ns["_v441_reviewer_finalization"](dm, REVIEWER_TEXT, _Log())
    cust = _cust(dm)
    for child in ("communication_preference", "dietary_restriction", "customer_attribute"):
        assert _prod(cust, child) is not None, "missing child %s" % child
    # the (key,value) child must carry the EAV columns the reviewer named
    ca = _prod(cust, "customer_attribute")
    cols = {a["name"] for a in ca["attributes"]}
    assert "attribute_key" in cols and "attribute_value" in cols, cols


# ============================================================ P7
def test_p7_dedupes_moved_product_from_root_and_rewires():
    ns = _finalize_ns()
    dm = _base_model()
    # add a NON-root-domain product that references the to-be-removed customer.segment, so P9
    # (which only prunes the ROOT domain's outbound FKs) leaves it in place and we can observe
    # the P7 rewire to marketing.segment.
    mk = next(d for d in dm["model"]["domains"] if d["name"] == "marketing")
    mk["products"].append({"name": "affinity", "attributes": [
        {"name": "affinity_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"},
        {"name": "segment_id", "type": "BIGINT", "foreign_key_to": "customer.segment.segment_id", "tags": "foreign_key"},
    ]})
    ns["_v441_reviewer_finalization"](dm, REVIEWER_TEXT, _Log())
    # customer.segment removed (survives only in marketing)
    assert _prod(_cust(dm), "segment") is None
    assert _prod(mk, "segment") is not None
    # the inbound FK was rewired to marketing.segment
    aff_fk = _attr(_prod(mk, "affinity"), "segment_id")["foreign_key_to"]
    assert aff_fk.lower().startswith("marketing.segment."), aff_fk


# ============================================================ P9
def test_p9_prunes_transactional_out_keeps_reference_out():
    ns = _finalize_ns()
    dm = _base_model()
    ns["_v441_reviewer_finalization"](dm, REVIEWER_TEXT, _Log())
    loyalty = _prod(_cust(dm), "loyalty")
    # cross-domain FK to a transactional/marketing table pruned
    assert _attr(loyalty, "campaign_id")["foreign_key_to"] == ""
    # cross-domain FK to a reference/dimension table (store.location) kept
    assert _attr(loyalty, "location_id")["foreign_key_to"] == "store.location.location_id"
    # intra-domain FK untouched
    assert _attr(loyalty, "profile_id")["foreign_key_to"] == "customer.profile.profile_id"


def test_p9_silo_guard_repoints_to_master_not_reversed_fk():
    ns = _finalize_ns()
    dm = _base_model()
    ns["_v441_reviewer_finalization"](dm, REVIEWER_TEXT, _Log())
    wishlist = _prod(_cust(dm), "wishlist")
    # original reversed cross-domain FK is gone
    assert _attr(wishlist, "campaign_id")["foreign_key_to"] == ""
    # product is NOT siloed: it carries a clean intra-domain FK to the customer master
    intra = [a for a in wishlist["attributes"]
             if str(a.get("foreign_key_to") or "").startswith("customer.profile.")]
    assert intra, "wishlist was left siloed after prune"


# ============================================================ P12
def test_p12_clears_junk_keeps_genuine_and_pii():
    ns = _finalize_ns()
    dm = _base_model()
    ns["_v441_reviewer_finalization"](dm, REVIEWER_TEXT, _Log())
    prof = _prod(_cust(dm), "profile")
    email = _attr(prof, "email")
    status = _attr(prof, "status_code")
    region = _attr(prof, "region_name")
    # junk glossary (term == TitleCase(col)) cleared, in field AND tag_set
    assert email.get("business_glossary_term", "") == ""
    assert all(t.get("key") != "dbx_business_glossary_term" for t in email.get("tag_set", []))
    # PII tag preserved
    assert any(t.get("key") == "pii" for t in email.get("tag_set", []))
    # redundant value_regex on an already-typed (INT) column cleared
    assert status.get("value_regex", "") == ""
    assert all(t.get("key") != "dbx_value_regex" for t in status.get("tag_set", []))
    # genuine glossary term (NOT a title-cased column name) kept
    assert region.get("business_glossary_term", "") == "Customer Home Region"


# ============================================================ genericity (no hardcoded "customer")
def test_generic_root_domain_name():
    """Prove the pass reads the reviewer's OWN root/domain names — use 'member', not 'customer'."""
    ns = _finalize_ns()
    dm = {
        "model": {
            "domains": [
                {"name": "member", "products": [
                    {"name": "master", "attributes": [
                        {"name": "master_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"}]},
                    {"name": "activity", "attributes": [
                        {"name": "activity_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"},
                        {"name": "order_id", "type": "BIGINT", "foreign_key_to": "sales.order.order_id", "tags": "foreign_key"}]},
                ]},
                {"name": "sales", "products": [
                    {"name": "order", "attributes": [
                        {"name": "order_id", "type": "BIGINT", "is_primary_key": True, "tags": "primary_key"}]},
                ]},
            ]
        }
    }
    rtext = "The member domain is a ROOT master-data domain; do not point OUT to transactional domains.\n"
    ns["_v441_reviewer_finalization"](dm, rtext, _Log())
    activity = next(p for p in dm["model"]["domains"][0]["products"] if p["name"] == "activity")
    order_fk = next(a for a in activity["attributes"] if a["name"] == "order_id")["foreign_key_to"]
    # the transactional cross-domain FK from the reviewer-named ROOT ('member') is pruned/re-pointed
    assert not order_fk.startswith("sales.order"), order_fk
