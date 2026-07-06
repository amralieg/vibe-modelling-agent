"""v0.7.9 behavioral tests — three root-cause fixes for the no_match_or_parts
audit ("THIS IS UNACCEPTABLE" — user, 2026-05-19).

Each fix is exercised end-to-end against an in-memory model. The tests are
designed to FAIL on v0.7.8 and PASS on v0.7.9.

Patches under test:
  P40 n6-persistent-renames    -- _llm_fallback_apply_mutations seeds its rename
                                  maps from `persistent_renames` passed by the
                                  caller (the outer action loop). Previously the
                                  per-call rename map was fresh, so refs like
                                  `consent.event.X` issued AFTER consent.event
                                  had been renamed to consent_event by a prior
                                  action failed lookup. 8/19 unique
                                  no_match_or_parts refs in healthcare VOV came
                                  from this single root cause.
  P41 n6-add-as-upsert         -- attribute.add on an existing row with field
                                  + new_value populated now upserts the field
                                  instead of silently no-op'ing.
  P42 n6-skip-reason-clarity   -- the catch-all skip reason is now classified
                                  into actionable buckets (entity_not_in_model,
                                  ref_too_few_parts, lookup_failed_after_renames,
                                  attribute_not_in_model) so audit can tell LLM
                                  hallucination apart from engine bug.
"""
from __future__ import annotations

import json
import logging
import re
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
AGENT_NB = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_engine():
    from notebook_source_util import slice_function_source

    ns = {
        "__name__": "_v79test",
        "logging": logging,
        "json": json,
        "re": re,
        "_MUT_ENTITY_SYNONYMS": {
            "link": "link",
            "attribute": "attribute",
            "product": "product",
            "domain": "domain",
            "fk": "link",
            "foreign_key": "link",
            "column": "attribute",
            "table": "product",
        },
        "_MUT_OPERATION_SYNONYMS": {
            "modify": "modify",
            "add": "add",
            "create": "add",
            "remove": "remove",
            "drop": "remove",
        },
        "sanitize_attribute_type": lambda a: None,
        "_vibe_set_entity_tag": lambda obj, field, value: (
            obj.__setitem__(field, value) if isinstance(obj, dict) else None
        ),
        "_p091_is_valid_identifier": lambda s: (True, ""),
        "_p091_reject_name_mutation": lambda *a, **k: False,
    }
    for fn in ("_preseed_rename_maps", "_llm_fallback_apply_mutations"):
        exec(compile(slice_function_source(fn), f"<v79_{fn}>", "exec"), ns)
    return ns


@pytest.fixture(scope="module")
def engine():
    return _load_engine()


def _logger(level=logging.INFO, capture=None):
    lg = logging.getLogger(f"v79test.{id(object())}")
    lg.handlers = []
    if capture is not None:
        class _Cap(logging.Handler):
            def emit(self, record):
                capture.append(record.getMessage())
        lg.addHandler(_Cap())
    else:
        lg.addHandler(logging.NullHandler())
    lg.setLevel(level)
    return lg


# ============================================================================
# P40 n6-persistent-renames — cross-action rename-cascade fix
# ============================================================================


def test_p40_link_remove_against_renamed_product_resolves_via_persistent_map(engine):
    """The healthcare VOV root cause, exact reproduction.

    State BEFORE the failing batch:
      * v1 had product `consent.event` with attribute `compliance_audit_id`.
      * Earlier action renamed `consent.event` → `consent_event`, cascading
        the rename into attributes_data (rows now carry product='consent_event').
      * `attribute_renames`/`product_renames` from the OUTER LOOP record this rename.
      * The LLM-fallback engine is now called with a SINGLE mutation:
        `link.remove consent.event.compliance_audit_id` (pre-rename ref).

    Pre-v0.7.9: engine had a fresh rename map → _find_attribute returned None →
    skipped with reason='no_match_or_parts'. (Live healthcare VOV log evidence.)
    Post-v0.7.9: persistent_renames seed the engine's _product_rename, so
    _find_attribute resolves via the rename map.
    """
    apply_mutations = engine["_llm_fallback_apply_mutations"]
    domains = [{"domain": "consent"}]
    products = [{"domain": "consent", "product": "consent_event"}]  # AFTER rename
    attributes = [{
        "domain": "consent",
        "product": "consent_event",  # AFTER rename
        "attribute": "compliance_audit_id",
        "foreign_key_to": "compliance.audit.audit_id",
    }]
    mutations = [{
        "entity_type": "link",
        "operation": "remove",
        "entity_ref": "consent.event.compliance_audit_id",  # PRE-rename ref from LLM
        "field": "foreign_key_to",
        "new_value": "",
    }]
    persistent_renames = {
        "domain": {},
        "product": {"consent.event": "consent.consent_event"},
        "attribute": {},
    }
    applied = apply_mutations(
        mutations, domains, products, attributes, [], _logger(),
        persistent_renames=persistent_renames,
    )
    assert applied == 1, (
        "P40: link.remove against a previously-renamed product MUST resolve "
        "via persistent_renames. Got applied=0 → no_match_or_parts regression."
    )
    assert attributes[0]["foreign_key_to"] == "", "FK should have been cleared"


def test_p40_attribute_modify_with_persistent_attribute_rename(engine):
    """Same root cause class but for attribute-level renames."""
    apply_mutations = engine["_llm_fallback_apply_mutations"]
    domains = [{"domain": "finance"}]
    products = [{"domain": "finance", "product": "ar_transaction"}]
    attributes = [{
        "domain": "finance",
        "product": "ar_transaction",
        "attribute": "reversed_ar_transaction_id",  # AFTER rename
        "description": "old description",
    }]
    mutations = [{
        "entity_type": "attribute",
        "operation": "modify",
        "entity_ref": "finance.ar_transaction.reversed_transaction_ar_transaction_id",  # PRE-rename
        "field": "description",
        "new_value": "updated description",
    }]
    persistent_renames = {
        "domain": {},
        "product": {},
        "attribute": {
            "finance.ar_transaction.reversed_transaction_ar_transaction_id":
            "finance.ar_transaction.reversed_ar_transaction_id",
        },
    }
    applied = apply_mutations(
        mutations, domains, products, attributes, [], _logger(),
        persistent_renames=persistent_renames,
    )
    assert applied == 1, "P40: attribute.modify against renamed column must resolve"
    assert attributes[0]["description"] == "updated description"


def test_p40_no_persistent_renames_still_works(engine):
    """Anti-regression: passing persistent_renames=None must not break anything."""
    apply_mutations = engine["_llm_fallback_apply_mutations"]
    domains = [{"domain": "sales"}]
    products = [{"domain": "sales", "product": "orders"}]
    attributes = [{"domain": "sales", "product": "orders", "attribute": "id"}]
    mutations = [{
        "entity_type": "attribute", "operation": "modify",
        "entity_ref": "sales.orders.id", "field": "description", "new_value": "PK",
    }]
    # No persistent_renames argument at all
    applied = apply_mutations(mutations, domains, products, attributes, [], _logger())
    assert applied == 1


def test_p40_fired_sentinel_logged(engine):
    """When persistent_renames is non-empty, the engine must emit the [FIRED]
    sentinel so audit can grep deployed runs for confirmation."""
    apply_mutations = engine["_llm_fallback_apply_mutations"]
    captured = []
    domains = [{"domain": "sales"}]
    products = [{"domain": "sales", "product": "orders"}]
    attributes = [{"domain": "sales", "product": "orders", "attribute": "id"}]
    mutations = [{
        "entity_type": "attribute", "operation": "modify",
        "entity_ref": "sales.orders.id", "field": "description", "new_value": "PK",
    }]
    apply_mutations(
        mutations, domains, products, attributes, [], _logger(capture=captured),
        persistent_renames={"product": {"sales.orders_v1": "sales.orders"}, "domain": {}, "attribute": {}},
    )
    fired = [m for m in captured if "[n6-persistent-renames FIRED]" in m]
    assert fired, (
        "P40: [n6-persistent-renames FIRED] sentinel must log when seed renames are non-empty. "
        f"Captured: {captured!r}"
    )


# ============================================================================
# P41 n6-add-as-upsert — attribute.add on existing row upserts the field
# ============================================================================


def test_p41_attribute_add_existing_with_description_upserts(engine):
    """Live evidence from healthcare VOV (patient.demographics.preferred_language_code):
    LLM emits `attribute.add ... field=description new_value='new desc'` for
    an attribute that already exists. Pre-v0.7.9: silent no-op → no_match_or_parts.
    Post-v0.7.9: upsert the description on the existing row."""
    apply_mutations = engine["_llm_fallback_apply_mutations"]
    domains = [{"domain": "patient"}]
    products = [{"domain": "patient", "product": "demographics"}]
    attributes = [{
        "domain": "patient", "product": "demographics",
        "attribute": "preferred_language_code",
        "description": "old description",
        "type": "BIGINT",
    }]
    mutations = [{
        "entity_type": "attribute", "operation": "add",
        "entity_ref": "patient.demographics.preferred_language_code",
        "field": "description",
        "new_value": "Standard SNOMED concept code for the patient's preferred language.",
    }]
    applied = apply_mutations(mutations, domains, products, attributes, [], _logger())
    assert applied == 1, "P41: attribute.add on existing with field+new_value must upsert"
    assert attributes[0]["description"].startswith("Standard SNOMED"), (
        f"P41: description must be updated. Got: {attributes[0]['description']!r}"
    )
    # Must not duplicate
    assert len(attributes) == 1


def test_p41_attribute_add_existing_idempotent_no_args(engine):
    """attribute.add on existing row with no field/new_value is idempotent — counts as applied."""
    apply_mutations = engine["_llm_fallback_apply_mutations"]
    domains = [{"domain": "patient"}]
    products = [{"domain": "patient", "product": "demographics"}]
    attributes = [{
        "domain": "patient", "product": "demographics",
        "attribute": "mpi_record_id",
    }]
    mutations = [{
        "entity_type": "attribute", "operation": "add",
        "entity_ref": "patient.demographics.mpi_record_id",
        "field": "",
        "new_value": "",
    }]
    applied = apply_mutations(mutations, domains, products, attributes, [], _logger())
    assert applied == 1, "P41: idempotent attribute.add on existing should count as applied"


def test_p41_attribute_add_new_still_creates(engine):
    """Anti-regression: attribute.add for a brand-new column still creates the row."""
    apply_mutations = engine["_llm_fallback_apply_mutations"]
    domains = [{"domain": "sales"}]
    products = [{"domain": "sales", "product": "orders"}]
    attributes = []
    mutations = [{
        "entity_type": "attribute", "operation": "add",
        "entity_ref": "sales.orders.discount_pct",
        "field": "", "new_value": "DECIMAL(5,2)",
    }]
    applied = apply_mutations(mutations, domains, products, attributes, [], _logger())
    assert applied == 1
    assert len(attributes) == 1
    assert attributes[0]["attribute"] == "discount_pct"


# ============================================================================
# P42 n6-skip-reason-clarity — actionable skip reasons
# ============================================================================


def test_p42_entity_not_in_model_for_hallucinated_column(engine):
    """LLM proposes drop FK on a column that doesn't exist anywhere. Skip reason
    must be `entity_not_in_model` (or `attribute_not_in_model`), NOT the
    ambiguous catch-all `no_match_or_parts`."""
    apply_mutations = engine["_llm_fallback_apply_mutations"]
    captured = []
    domains = [{"domain": "billing"}]
    products = [{"domain": "billing", "product": "refund"}]
    attributes = [
        {"domain": "billing", "product": "refund", "attribute": "refund_id"},
    ]
    mutations = [{
        "entity_type": "link", "operation": "remove",
        "entity_ref": "billing.refund.patient_demographics_id",  # Hallucinated column
        "field": "foreign_key_to", "new_value": "",
    }]
    applied = apply_mutations(
        mutations, domains, products, attributes, [], _logger(capture=captured),
    )
    assert applied == 0
    # Find the [n6-skip-reason-clarity FIRED] log line
    fired = [m for m in captured if "[n6-skip-reason-clarity FIRED]" in m]
    assert fired, f"P42 sentinel must fire on skip. Captured: {captured!r}"
    # The reason classified must be attribute_not_in_model (domain+product exist, col doesn't)
    reasons_found = [m for m in fired if "attribute_not_in_model" in m or "entity_not_in_model" in m]
    assert reasons_found, (
        f"P42: hallucinated column must be classified as attribute_not_in_model or "
        f"entity_not_in_model, not 'no_match_or_parts'. Captured: {fired!r}"
    )


def test_p42_ref_too_few_parts_for_product_scoped_link(engine):
    """LLM proposes `link.remove claim.line` (no column part). The ref has only
    2 parts. Skip reason must be `ref_too_few_parts`."""
    apply_mutations = engine["_llm_fallback_apply_mutations"]
    captured = []
    domains = [{"domain": "claim"}]
    products = [{"domain": "claim", "product": "line"}]
    attributes = []
    mutations = [{
        "entity_type": "link", "operation": "remove",
        "entity_ref": "claim.line",  # only 2 parts
        "field": "foreign_key_to", "new_value": "",
    }]
    applied = apply_mutations(
        mutations, domains, products, attributes, [], _logger(capture=captured),
    )
    assert applied == 0
    fired = [m for m in captured if "[n6-skip-reason-clarity FIRED]" in m and "ref_too_few_parts" in m]
    assert fired, (
        f"P42: 2-part link ref must be classified as ref_too_few_parts. Captured: {captured!r}"
    )


def test_p42_lookup_failed_after_renames_when_rename_map_has_key(engine):
    """The engine knows the entity used to exist (it's in the rename map), but
    the rename map doesn't help resolve (e.g., disagreement between rename
    direction and current data). Skip reason must surface the rename context."""
    apply_mutations = engine["_llm_fallback_apply_mutations"]
    captured = []
    domains = [{"domain": "x"}]
    products = [{"domain": "x", "product": "p1"}]
    # No attribute matching either pre- or post-rename names
    attributes = []
    mutations = [{
        "entity_type": "attribute", "operation": "modify",
        "entity_ref": "x.p1.col_a",  # in rename map (pre-rename) but absent from data
        "field": "description", "new_value": "anything",
    }]
    apply_mutations(
        mutations, domains, products, attributes, [], _logger(capture=captured),
        persistent_renames={
            "domain": {},
            "product": {},
            "attribute": {"x.p1.col_a": "x.p1.col_b"},
        },
    )
    fired = [m for m in captured if "[n6-skip-reason-clarity FIRED]" in m]
    assert fired, f"P42: skip must classify reason. Captured: {captured!r}"
    # When the attribute key IS in the rename map, the reason should be lookup_failed_after_renames
    target = [m for m in fired if "lookup_failed_after_renames" in m]
    assert target, (
        f"P42: when the ref appears in the rename map but no row matches, "
        f"reason must be lookup_failed_after_renames. Captured: {fired!r}"
    )


# ============================================================================
# Static-anchor tests — aliases present in deployed agent
# ============================================================================


def test_v79_aliases_present():
    src = notebook_concat_source()
    for alias in [
        "n6-persistent-renames",
        "n6-add-as-upsert",
        "n6-skip-reason-clarity",
    ]:
        assert alias in src, f"v0.7.9 alias {alias!r} must be present in deployed code"


def test_v79_engine_signature_accepts_persistent_renames():
    src = notebook_concat_source()
    assert (
        "def _llm_fallback_apply_mutations(mutations, domains_data, products_data, attributes_data, dyn_attrs, logger, persistent_renames=None)"
        in src
    ), "P40: engine signature must accept persistent_renames=None kwarg"


def test_v79_handler_passes_persistent_renames():
    src = notebook_concat_source()
    n = src.count("persistent_renames=_persistent_renames")
    assert n >= 2, (
        f"P40: _llm_fallback_handler must pass persistent_renames at both engine callsites. "
        f"Found {n} occurrences."
    )


def test_v79_step_interpret_initializes_attribute_renames():
    from notebook_source_util import notebook_concat_source

    src = notebook_concat_source()
    assert "attribute_renames = {}" in src, (
        "P40a: step_interpret_model_instructions must init attribute_renames at loop level"
    )
    assert (
        "'attribute_renames': attribute_renames" in src
        or "ctx.get('attribute_renames')" in src
        or 'widgets_values.get(\'attribute_renames\'' in src
    ), "P40a: attribute_renames must flow into mutation context"


def test_v79_apply_mutation_command_returns_rename_info():
    nb = json.loads(AGENT_NB.read_text(encoding="utf-8"))
    code = "".join(
        "".join(cell.get("source", []))
        for cell in nb.get("cells", [])
        if cell.get("cell_type") == "code"
    )
    assert '"renamed_attribute"' in code, (
        "P40b: apply_mutation_command must surface renamed_attribute in meta dict"
    )


def test_v79_agent_version_is_at_least_079():
    """Per §3a single-digit semver, version must be >= 0.7.9 (allows 0.8.0+ patches that build on P40-P42)."""
    import re as _re
    src = notebook_concat_source()
    m = _re.search(r'__AGENT_VERSION__\s*=\s*\\?"(\d+)\.(\d+)\.(\d+)\\?"', src)
    assert m, "__AGENT_VERSION__ literal not found"
    maj, mn, pt = int(m.group(1)), int(m.group(2)), int(m.group(3))
    assert (maj, mn, pt) >= (0, 7, 9), f"version must be >= 0.7.9, got {maj}.{mn}.{pt}"
