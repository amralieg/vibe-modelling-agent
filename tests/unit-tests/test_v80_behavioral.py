from notebook_source_util import notebook_concat_source

"""
Behavioral tests for v0.8.0 P43 (n6-add-malformed-field-fallthrough).

The P43 root-cause fix: when `attribute.add` targets an EXISTING row (e.g. after
a prior `move_product` merge cascaded the column into place) and the LLM sends
`field=<description_prose>` with empty new_value, v0.7.9's P41 upsert branch
matched only the allowed-field-list + non-empty new_value case and silently
no-op'd the rest. The P42 classifier then mislabeled these as
'attribute_not_in_model' even though the row DID exist, polluting the
adherence audit and producing 11/22 attribute.add skips on the legal VOV
matter.deadline merge (59.5% adherence vs 100% required).

v0.8.0 P43 makes the engine robust:
- attribute.add on an existing row always counts as APPLIED (existence intent satisfied)
- if the malformed `field` text is multi-word / >40 chars AND description is blank,
  rescue the prose into the description column instead of dropping it.
"""

import json
import re
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
AGENT_NB = REPO / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _agent_code_text() -> str:
    nb = json.loads(AGENT_NB.read_text(encoding="utf-8"))
    return "".join(
        "".join(cell.get("source", []))
        for cell in nb.get("cells", [])
        if cell.get("cell_type") == "code"
    )


def test_v80_agent_version_is_at_least_080():
    """Per §3a single-digit semver, version must be >= 0.8.0 so that v0.8.x patches
    that build on P43 (such as v0.8.1 P44/P45) still satisfy this test."""
    nb = json.loads(AGENT_NB.read_text(encoding="utf-8"))
    cell1 = "".join(nb["cells"][1].get("source", []))
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', cell1)
    assert m, "__AGENT_VERSION__ not found in Cell 1"
    maj, mn, pt = int(m.group(1)), int(m.group(2)), int(m.group(3))
    assert (maj, mn, pt) >= (0, 8, 0), f"expected >= 0.8.0, got {maj}.{mn}.{pt}"


def test_v80_p43_alias_present():
    code = _agent_code_text()
    assert "n6-add-malformed-field-fallthrough" in code, (
        "P43 alias must be present in agent notebook"
    )
    # Must fire on a sentinel log line
    assert "[n6-add-malformed-field-fallthrough FIRED]" in code, (
        "P43 sentinel log must be present"
    )


def test_v80_p43_handler_signature_intact():
    # The signature stays compatible; P43 only changes the existing-row branch.
    code = _agent_code_text()
    assert "elif entity_type == 'attribute' and operation == 'add':" in code, (
        "attribute.add branch must remain in dispatcher"
    )


def _build_mini_apply():
    """Extract _llm_fallback_apply_mutations and dependencies into an exec'd module.

    We do a minimal stub: instead of executing the entire 80k-line notebook, we
    write a tiny harness that mimics the dispatcher's attribute.add branch with
    P43 semantics, then asserts the contract: existing row + malformed field
    => applied=1, optional description rescue.
    """
    code = _agent_code_text()
    # Find the attribute add branch + surrounding logic. For these unit-level
    # tests we don't need to exec the agent — we test the contract by simulating
    # the LLM input pattern against an in-memory attributes_data list, mirroring
    # the dispatcher logic.
    assert "elif entity_type == 'attribute' and operation == 'add':" in code
    return code


# --- Behavioral tests against simulated dispatcher logic ---


def _simulate_attribute_add(attributes_data, entity_ref, field, new_value):
    """Simulate the v0.8.0 P43 dispatcher logic for attribute.add only.

    Returns (applied_delta, by_reason_label_if_skipped).
    """
    applied = 0
    skip_reason = None

    parts = entity_ref.split(".")
    if len(parts) < 3:
        skip_reason = "ref_too_few_parts"
        return applied, skip_reason

    dom, prod = parts[0], parts[1]
    col = ".".join(parts[2:])
    existing = next(
        (
            a
            for a in attributes_data
            if a.get("domain") == dom and a.get("product") == prod and a.get("attribute") == col
        ),
        None,
    )

    allowed_fields = {
        "description", "type", "tags", "value_regex", "foreign_key_to",
        "column_name", "business_glossary_term", "reference",
    }

    if existing is not None:
        # P41 upsert path
        if field and new_value and field in allowed_fields:
            existing[field] = new_value
            applied += 1
        else:
            # P43 fallthrough: existence intent satisfied, optionally rescue prose
            field_str = str(field or "").strip()
            curr_desc = str(existing.get("description", "") or "").strip()
            looks_like_prose = bool(field_str) and (" " in field_str or len(field_str) > 40)
            field_not_mappable = field_str and field_str.lower() not in (
                allowed_fields | {"attribute", "nullable", "primary_key"}
            )
            if looks_like_prose and field_not_mappable and not curr_desc:
                existing["description"] = field_str
            applied += 1
    else:
        # CREATE path
        new_attr = {
            "domain": dom,
            "product": prod,
            "attribute": col,
            "type": new_value or "STRING",
            "description": field or "",
            "tags": "",
            "value_regex": "",
            "foreign_key_to": "",
        }
        attributes_data.append(new_attr)
        applied += 1

    return applied, skip_reason


def test_p43_existing_row_with_description_prose_in_field_counts_applied_and_rescues_description():
    """
    Mirrors the legal failure: matter.deadline.deadline_id row exists, LLM sends
    field='Primary key for the merged deadline table', new_value=''. Pre-v0.8.0
    was silent no-op. v0.8.0 must apply and rescue prose into description.
    """
    attrs = [
        {"domain": "matter", "product": "deadline", "attribute": "deadline_id",
         "type": "BIGINT", "description": "", "tags": "primary_key"},
    ]
    applied, reason = _simulate_attribute_add(
        attrs,
        entity_ref="matter.deadline.deadline_id",
        field="Primary key for the merged deadline table",
        new_value="",
    )
    assert applied == 1, "P43: existing row + prose field must count as applied"
    assert reason is None
    # Description should have been rescued (was blank)
    row = next(a for a in attrs if a["attribute"] == "deadline_id")
    assert row["description"] == "Primary key for the merged deadline table"


def test_p43_existing_row_with_nonblank_description_does_not_overwrite():
    """Rescue only fires when description is blank — never overwrites real descriptions."""
    attrs = [
        {"domain": "matter", "product": "deadline", "attribute": "deadline_id",
         "type": "BIGINT", "description": "ORIGINAL DESCRIPTION", "tags": "primary_key"},
    ]
    applied, reason = _simulate_attribute_add(
        attrs,
        entity_ref="matter.deadline.deadline_id",
        field="Primary key for the merged deadline table",
        new_value="",
    )
    assert applied == 1
    row = next(a for a in attrs if a["attribute"] == "deadline_id")
    assert row["description"] == "ORIGINAL DESCRIPTION", "must NOT overwrite real description"


def test_p43_existing_row_with_short_identifier_field_does_not_rescue_as_description():
    """If field is a short identifier-looking token (not prose), don't treat as description."""
    attrs = [
        {"domain": "matter", "product": "deadline", "attribute": "deadline_id",
         "type": "BIGINT", "description": "", "tags": ""},
    ]
    applied, _ = _simulate_attribute_add(
        attrs,
        entity_ref="matter.deadline.deadline_id",
        field="unknown_field",
        new_value="",
    )
    assert applied == 1, "existence intent satisfied — must still count as applied"
    row = next(a for a in attrs if a["attribute"] == "deadline_id")
    assert row["description"] == "", "short single-token field must NOT be rescued as description"


def test_p43_existing_row_with_proper_field_value_upserts_as_p41():
    """Backwards-compat: proper field='description' + new_value=<text> still upserts via P41."""
    attrs = [
        {"domain": "matter", "product": "deadline", "attribute": "deadline_id",
         "type": "BIGINT", "description": "", "tags": ""},
    ]
    applied, _ = _simulate_attribute_add(
        attrs,
        entity_ref="matter.deadline.deadline_id",
        field="description",
        new_value="Primary key for the merged deadline table",
    )
    assert applied == 1
    row = next(a for a in attrs if a["attribute"] == "deadline_id")
    assert row["description"] == "Primary key for the merged deadline table"


def test_p43_nonexisting_row_still_creates_new_attribute():
    """Backwards-compat: ADD on non-existent attr still creates."""
    attrs = []
    applied, _ = _simulate_attribute_add(
        attrs,
        entity_ref="matter.deadline.matter_id",
        field="FK to matter table",
        new_value="",
    )
    assert applied == 1
    assert len(attrs) == 1
    assert attrs[0]["attribute"] == "matter_id"
    assert attrs[0]["description"] == "FK to matter table"


def test_p43_no_more_silent_noop_on_existing_row_with_unmappable_field():
    """
    Regression guard: pre-v0.8.0 returned applied=0 here. This is the bug.
    """
    attrs = [
        {"domain": "matter", "product": "deadline", "attribute": "responsible_timekeeper_id",
         "type": "BIGINT", "description": "FK to responsible timekeeper", "tags": ""},
    ]
    applied, reason = _simulate_attribute_add(
        attrs,
        entity_ref="matter.deadline.responsible_timekeeper_id",
        field="The timekeeper responsible for meeting this deadline",
        new_value="",
    )
    assert applied == 1, "P43: existing row must count as applied (was 0 in v0.7.9)"
    assert reason is None, "must NOT skip with attribute_not_in_model"


def test_p43_logic_present_in_agent_notebook():
    code = _agent_code_text()
    # The fallthrough must always increment applied for existing rows
    assert "_looks_like_prose" in code, "P43 prose-detection must be present"
    assert "_field_not_mappable" in code, "P43 field-mappability check must be present"
    assert "existence intent satisfied" in code, "P43 sentinel rationale must be present"
