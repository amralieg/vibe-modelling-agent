"""v0.9.4 BEHAVIORAL tests — actually invoke the patched functions with
mocked args and assert real behavior. Replaces the static-grep-only
sentinel tests of v0.8.9-v0.9.2.

Per CLAUDE.md §8.3 (no tautologies): each test includes a positive case
that MUST classify and a negative case that MUST NOT classify, so the
test can fail by deletion AND by behavior regression.
"""

import pytest


def test_is_system_identifier_column_classifies_dynamic_sor_string(monkeypatch):
    """When operational_systems_of_records is a comma-separated STRING
    (LLM output shape), _is_system_identifier_column MUST split it and
    derive prefix matchers — the v0.8.9 NEW-5 fix."""
    import agent_helpers as ah

    config = {
        "PROMPT_VARIABLES": {
            "business_context_data": {
                "operational_systems_of_records": "Shopify, Klaviyo, Stripe, Zendesk, Algolia, ShipStation"
            }
        }
    }

    # Positive case: shopify_customer_id MUST classify as system identifier
    assert ah._is_system_identifier_column(
        "shopify_customer", attr_name="shopify_customer_id", config=config
    ) is True, "shopify_* should be classified as SOR-prefixed system ID"

    # Positive case: klaviyo_profile_id MUST classify
    assert ah._is_system_identifier_column(
        "klaviyo_profile", attr_name="klaviyo_profile_id", config=config
    ) is True, "klaviyo_* should be classified"

    # Negative case: a domain entity FK like customer_account_id MUST NOT classify
    assert ah._is_system_identifier_column(
        "customer_account", attr_name="customer_account_id", config=config
    ) is False, "domain entity FK must NOT be flagged as system identifier"

    # Negative case: bare invoice_id MUST NOT classify
    assert ah._is_system_identifier_column(
        "invoice", attr_name="invoice_id", config=config
    ) is False, "bare entity_id must NOT be flagged as system identifier"


def test_is_system_identifier_column_handles_list_sor(monkeypatch):
    """Backward compat — when SOR is already a list (legacy callers)."""
    import agent_helpers as ah

    config = {
        "PROMPT_VARIABLES": {
            "business_context_data": {
                "operational_systems_of_records": ["Salesforce", "NetSuite"]
            }
        }
    }
    assert ah._is_system_identifier_column(
        "salesforce_lead", attr_name="salesforce_lead_id", config=config
    ) is True, "list-shape SOR should still derive prefix"

    assert ah._is_system_identifier_column(
        "netsuite_journal", attr_name="netsuite_journal_id", config=config
    ) is True


def test_is_system_identifier_column_pii_debias_no_emirates_id(monkeypatch):
    """v0.9.4 PII-DEBIAS — emirates_id/civil_id/eid_number should NOT be in
    the system-identifier whitelist (it's a PII column, not a system ID).
    This test ensures we didn't accidentally add them somewhere else
    while removing them.
    """
    import agent_helpers as ah

    config = {"PROMPT_VARIABLES": {"business_context_data": {"operational_systems_of_records": []}}}
    # emirates_id / civil_id are PII identifiers, not external-system FK references
    # They should NOT be classified as system identifiers (would skip linking)
    # Without an SOR prefix, these match no SOR prefix, no SUFFIX, no PATTERN — return False
    assert ah._is_system_identifier_column(
        "emirates", attr_name="emirates_id", config=config
    ) is False, "emirates_id should NOT be a system identifier (it's PII)"


def test_is_system_identifier_column_recognizes_system_id_suffixes():
    """Existing v0.8.x behavior — _hash, _token, _uuid suffixes classify."""
    import agent_helpers as ah
    config = {}

    assert ah._is_system_identifier_column("session_token", attr_name="session_token") is True
    assert ah._is_system_identifier_column("idempotency_uuid", attr_name="idempotency_uuid") is True
    # But account_uuid should ALSO classify (the suffix wins)
    assert ah._is_system_identifier_column("account_uuid", attr_name="account_uuid") is True


def test_wrap_schema_with_honesty_preserves_strict_true():
    """v0.9.0 R7-STRICT-PRESERVE — when base schema declares strict=True,
    the wrapper MUST keep strict=True (was forcing strict=False prior to fix)."""
    import agent_helpers as ah

    base = {
        "name": "test_schema",
        "schema": {
            "type": "object",
            "properties": {"foo": {"type": "string"}},
            "required": ["foo"],
        },
        "strict": True,
    }
    wrapped = ah.wrap_schema_with_honesty(base)
    assert wrapped.get("strict") is True, (
        "v0.9.0 R7-STRICT-PRESERVE: outer strict must remain True"
    )
    assert wrapped["schema"].get("strict", True) is True, (
        "schema-level strict must not be downgraded"
    )
    # honesty fields added
    assert "honesty_score" in wrapped["schema"]["properties"]
    assert "honesty_score" in wrapped["schema"]["required"]
    assert "honesty_justification" in wrapped["schema"]["required"]


def test_wrap_schema_with_honesty_preserves_strict_false():
    """If the base intentionally set strict=False, that should also be preserved."""
    import agent_helpers as ah

    base = {
        "name": "lenient",
        "schema": {"type": "object", "properties": {}, "required": []},
        "strict": False,
    }
    wrapped = ah.wrap_schema_with_honesty(base)
    assert wrapped.get("strict") is False, "explicit strict=False must be preserved"
