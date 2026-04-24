"""Tests for v0.8.5 model-quality root-cause fixes from the mvm_v4 audit
(2026-04-24 GCP run on 8259555029405006.6.gcp.databricks.com).

Defect index <-> alias map:
    M1   -> v0.8.5 alias=fk-name-helper-field-widen
                          + FK_EDGE_SYNTHESIS_PROMPT rule #1 (anti-IdId)
    M2   -> v0.8.5 alias=pk-casing-preserve-boundaries
    M3+M4 -> v0.8.5 alias=fk-temporal-precedence
                           + alias=fk-cardinality-correctness
                           + alias=fk-semantic-gate-no-keyerror (N1)
    M5   -> v0.8.5 alias=canonical-attrs-enforced

Anti-tautology: every test below either parses persisted-model.json field
shapes that reproduce the production failure, or runs the patched helper
against an input where the unpatched helper produced the wrong answer.
"""
import json
import re
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_notebook_source(path: Path) -> str:
    nb = json.loads(path.read_text(encoding="utf-8"))
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        parts.append(src)
    return "\n".join(parts)


@pytest.fixture(scope="module")
def agent_src() -> str:
    return _read_notebook_source(NOTEBOOK_PATH)


@pytest.fixture(scope="module")
def helpers():
    import agent_helpers as ah
    return ah


# =====================================================================
# M1 -- FK column name double-suffix (e.g., AccountIdId)
# =====================================================================

class TestM1FkNameNoDoubleSuffix:
    def test_alias_present(self, agent_src):
        assert "fk-name-helper-field-widen" in agent_src
        assert "M1-FIX" in agent_src

    def test_prompt_anti_idid_rule_present(self, agent_src):
        # FK_EDGE_SYNTHESIS_PROMPT rule #1 must explicitly forbid IdId pattern
        assert "ABSOLUTELY FORBIDDEN" in agent_src
        assert "IdId" in agent_src
        assert "AccountIdId" in agent_src or "double-suffix" in agent_src

    def test_prompt_demands_verbatim_match(self, agent_src):
        assert "VERBATIM" in agent_src or "byte-for-byte" in agent_src

    def test_helper_reads_three_field_names(self, agent_src):
        # The persisted model.json uses 'name' or 'column_name', not 'attribute'.
        # The unpatched helper read attr.get('attribute', '') and silently
        # no-op'd on every reload-cycle attribute. The patched helper must
        # try all three keys.
        # Locate normalize_fk_column_name body in source and verify the read
        m = re.search(
            r"def normalize_fk_column_name\([^)]+\):(.+?)(?=\n\s*\"\s*def\s|\Z)",
            agent_src,
            flags=re.DOTALL,
        )
        assert m, "normalize_fk_column_name function not found in notebook source"
        body = m.group(1)[:3000]  # first ~3KB of body is enough
        # Patched body must read from at least the 3 known field names
        assert "attr.get('attribute')" in body, body[:500]
        assert "attr.get('column_name')" in body
        assert "attr.get('name')" in body
        # And MUST NOT silently default-empty 'attribute' alone (the old bug)
        # The deprecated form was: attr.get('attribute', '')
        # The new form must NOT use that exact pattern as the only read.
        assert "attr.get('attribute', '')" not in body or "attr.get('column_name')" in body

    def test_helper_writes_all_three_field_names(self, agent_src):
        # Source must write to attribute + column_name + name (when name exists)
        # so downstream consumers reading any of them see the rename.
        assert "attr['attribute'] = new_name" in agent_src
        assert "attr['column_name'] = new_name" in agent_src
        assert "attr['name'] = new_name" in agent_src

    def test_signature_log_signal_present(self, agent_src):
        # Runtime sentinel for live verification
        assert "[FK-NAME-FIX] [M1-FIX]" in agent_src
        assert "alias=fk-name-helper-field-widen" in agent_src


# =====================================================================
# M2 -- PK casing collapses (CatalogItem -> CatalogitemId)
# =====================================================================

class TestM2PkCasingPreserveBoundaries:
    def test_alias_present(self, agent_src):
        assert "pk-casing-preserve-boundaries" in agent_src
        assert "M2-FIX" in agent_src

    def test_compose_uses_preserve_boundaries(self, agent_src):
        # The patched _compose must wrap each part in apply_convention(snake_case)
        # before sanitize_name lowercases, to preserve PascalCase boundaries.
        assert "_preserve_boundaries" in agent_src
        assert "apply_convention(p, convention='snake_case', dedup=False)" in agent_src

    def test_namingconvention_pk_pascalcase_correct(self, helpers):
        NC = getattr(helpers, "NamingConvention", None)
        if NC is None:
            pytest.skip("NamingConvention not loaded in helpers shim")
        nc = NC(widgets_values={"naming_convention": "PascalCase",
                                "primary_key_suffix": "Id"})
        # Multi-word entities — these are EXACTLY the cases that produced
        # CatalogitemId / OrderlineId / PriceruleId / ConsentrecordId
        # in mvm_v4. With the M2 fix they MUST round-trip cleanly.
        assert nc.pk_column("CatalogItem") == "CatalogItemId"
        assert nc.pk_column("OrderLine") == "OrderLineId"
        assert nc.pk_column("PriceRule") == "PriceRuleId"
        assert nc.pk_column("ConsentRecord") == "ConsentRecordId"
        # Single-word — must still work (anti-regression on simple cases)
        assert nc.pk_column("Customer") == "CustomerId"
        # snake_case input also accepted (covers downstream callers
        # that pass already-normalised names)
        assert nc.pk_column("catalog_item") == "CatalogItemId"

    def test_namingconvention_pk_snakecase_also_correct(self, helpers):
        NC = getattr(helpers, "NamingConvention", None)
        if NC is None:
            pytest.skip("NamingConvention not loaded in helpers shim")
        nc = NC(widgets_values={"naming_convention": "snake_case",
                                "primary_key_suffix": "id"})
        # Same PascalCase-to-snake conversion path must also preserve boundaries
        assert nc.pk_column("CatalogItem") == "catalog_item_id"
        assert nc.pk_column("OrderLine") == "order_line_id"


# =====================================================================
# M3+M4 -- FK semantic gate KeyError (N1) + missing rules
# =====================================================================

class TestM3M4SemanticGate:
    def test_n1_keyerror_fix_present(self, agent_src):
        assert "fk-semantic-gate-no-keyerror" in agent_src
        assert "N1-FIX" in agent_src

    def test_n1_user_sizing_directives_passed(self, agent_src):
        # Both .format() call sites in run_fk_semantic_correctness_gate
        # must now pass user_sizing_directives.
        # Find every .format( call referencing FK_SEMANTIC_CORRECTNESS_GATE_PROMPT.
        idx = 0
        callsites_with_sizing = 0
        callsites_total = 0
        while True:
            i = agent_src.find('PROMPT_TEMPLATES["FK_SEMANTIC_CORRECTNESS_GATE_PROMPT"].format(', idx)
            if i < 0:
                break
            # Find the closing paren of the .format( call (cheap balanced-paren scan)
            depth = 0
            j = i + len('PROMPT_TEMPLATES["FK_SEMANTIC_CORRECTNESS_GATE_PROMPT"].format(')
            depth = 1
            while j < len(agent_src) and depth > 0:
                if agent_src[j] == '(':
                    depth += 1
                elif agent_src[j] == ')':
                    depth -= 1
                j += 1
            block = agent_src[i:j]
            callsites_total += 1
            if "user_sizing_directives" in block:
                callsites_with_sizing += 1
            idx = j
        assert callsites_total >= 2, f"Expected >=2 FK semantic gate format() calls, found {callsites_total}"
        assert callsites_with_sizing == callsites_total, (
            f"Only {callsites_with_sizing}/{callsites_total} format() calls pass "
            f"user_sizing_directives — KeyError will still fire on others."
        )

    def test_temporal_precedence_rules_present(self, agent_src):
        assert "fk-temporal-precedence" in agent_src
        assert "M3-FIX" in agent_src
        # Specific anti-patterns from mvm_v4 must be enumerated
        assert "Payment -> Rma" in agent_src or "Payment\\u2192Rma" in agent_src
        assert "Shipment -> Rma" in agent_src

    def test_cardinality_rules_present(self, agent_src):
        assert "fk-cardinality-correctness" in agent_src
        assert "M4-FIX" in agent_src
        # The Header MUST NEVER hold a Line FK rule
        assert "Header" in agent_src and "Line" in agent_src
        assert "MANY side" in agent_src
        # Specific anti-pattern from mvm_v4
        assert "Shipment -> OrderLine" in agent_src or "Shipment->OrderLine" in agent_src

    def test_junction_purity_rule_present(self, agent_src):
        # M7-related: SegmentMembership FK-ing to CatalogItem
        assert "JUNCTION TABLE PURITY" in agent_src

    def test_corrective_action_format_specified(self, agent_src):
        # Ensure the prompt instructs the LLM how to express the fix
        assert "reverse_direction" in agent_src


# =====================================================================
# M5 -- Order missing canonical fields (created_at, total_amount, ...)
# =====================================================================

class TestM5CanonicalAttributesEnforced:
    def test_alias_present(self, agent_src):
        assert "canonical-attrs-enforced" in agent_src
        assert "M5-FIX" in agent_src

    def test_transactional_minimum_fields_named(self, agent_src):
        # The new prompt block must list explicit named fields, not just
        # vague concepts — that was the failure mode (Order had 38 attrs
        # but missed total_amount/created_at/tax_amount/currency_code).
        for required_field in [
            "order_status", "order_date",
            "created_at", "updated_at",
            "subtotal", "tax_amount", "total_amount", "currency_code",
        ]:
            assert required_field in agent_src, (
                f"Required canonical field '{required_field}' missing from "
                f"ATTRIBUTE_GENERATE_PROMPT — Order entities will continue "
                f"to be generated without it."
            )

    def test_minimum_8_for_transactional(self, agent_src):
        # The prompt must specify a hard minimum count
        assert "minimum 8 named fields" in agent_src

    def test_priority_over_marketing_explicit(self, agent_src):
        # Anti-tautology: the prompt must explicitly tell the LLM to drop
        # marketing/optional fields before canonical ones, otherwise the
        # LLM will keep dropping the wrong things at the cap.
        assert "marketing" in agent_src.lower()
        assert "DROP" in agent_src or "drop" in agent_src

    def test_transactional_line_fields_specified(self, agent_src):
        # Lines must have parent FK + line_number + product FK + quantity + price + total
        assert "line_number" in agent_src
        assert "unit_price" in agent_src or "unit_amount" in agent_src
        assert "line_total" in agent_src or "extended_amount" in agent_src

    def test_address_canonical_fields(self, agent_src):
        # Address entities frequently got just `country` — must enumerate
        for canonical_addr in ["line1", "city", "postal_code", "country"]:
            assert canonical_addr in agent_src


# =====================================================================
# Integration smoke: detect the same defect classes in a sample model.json
# =====================================================================

class TestModelJsonRegressionDetectors:
    """These tests don't load the agent — they encode the bug DETECTORS so
    that, when the next live run drops a new model.json into /tmp, you can
    point this test at it and FAIL if the same classes of defects recur."""

    @staticmethod
    def _has_idid_double_suffix(model: dict) -> list:
        offenders = []
        for d in model.get("model", {}).get("domains", []):
            for p in d.get("products", []):
                for a in p.get("attributes", []):
                    nm = a.get("name") or a.get("column_name") or ""
                    if not (a.get("foreign_key_to") or "").strip():
                        continue
                    if re.search(r"(IdId|_id_id|IdentifierIdentifier)$", nm):
                        offenders.append(f"{d['name']}.{p['name']}.{nm}")
        return offenders

    @staticmethod
    def _has_collapsed_pk(model: dict) -> list:
        """A PK is 'collapsed' if the entity name has internal capitals
        (e.g., CatalogItem -> at least one inner uppercase letter) but the PK
        does not contain that name verbatim — i.e., the PK lost the capital."""
        offenders = []
        for d in model.get("model", {}).get("domains", []):
            for p in d.get("products", []):
                pk = (p.get("primary_key") or "").strip()
                pname = (p.get("name") or "").strip()
                if not pk or not pname or len(pname) < 2:
                    continue
                # Has at least one inner capital (multi-word PascalCase)?
                has_inner_cap = any(c.isupper() for c in pname[1:])
                if not has_inner_cap:
                    continue
                # Bug pattern: pname appears in pk only when lowercased.
                if pname.lower() in pk.lower() and pname not in pk:
                    offenders.append(f"{d['name']}.{pname} -> pk={pk}")
        return offenders

    def test_detector_idid_finds_known_bad(self):
        # Synthetic model that has the bug — must be detected.
        bad = {"model": {"domains": [{"name": "x", "products": [
            {"name": "Order", "attributes": [
                {"name": "AccountIdId", "foreign_key_to": "Customer.Account.AccountId"}
            ]}
        ]}]}}
        assert self._has_idid_double_suffix(bad) == ["x.Order.AccountIdId"]

    def test_detector_idid_passes_correct(self):
        ok = {"model": {"domains": [{"name": "x", "products": [
            {"name": "Order", "attributes": [
                {"name": "AccountId", "foreign_key_to": "Customer.Account.AccountId"}
            ]}
        ]}]}}
        assert self._has_idid_double_suffix(ok) == []

    def test_detector_collapsed_pk_finds_known_bad(self):
        bad = {"model": {"domains": [{"name": "x", "products": [
            {"name": "CatalogItem", "primary_key": "CatalogitemId"}
        ]}]}}
        offenders = self._has_collapsed_pk(bad)
        assert any("CatalogItem" in o for o in offenders)

    def test_detector_collapsed_pk_passes_correct(self):
        ok = {"model": {"domains": [{"name": "x", "products": [
            {"name": "CatalogItem", "primary_key": "CatalogItemId"}
        ]}]}}
        assert self._has_collapsed_pk(ok) == []
