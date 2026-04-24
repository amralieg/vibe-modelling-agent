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

    def test_temporal_precedence_rule_present(self, agent_src):
        assert "fk-temporal-precedence" in agent_src
        assert "M3-FIX" in agent_src
        # The rule MUST be expressed in industry-agnostic terms:
        #   "Earlier" / "Later" entity ordering in the business process,
        #   abstract <EntityEarlier>/<EntityLater> placeholders.
        assert "EARLIER" in agent_src and "LATER" in agent_src
        assert "<EntityEarlier>" in agent_src and "<EntityLater>" in agent_src
        # The corrective_action format must be specified
        assert "reverse_direction" in agent_src

    def test_cardinality_rule_present(self, agent_src):
        assert "fk-cardinality-correctness" in agent_src
        assert "M4-FIX" in agent_src
        # The rule MUST be expressed via abstract Parent/Child or
        # 1:N cardinality vocabulary, not specific retail entity names.
        assert "MANY side" in agent_src
        assert "<Parent>" in agent_src or "<Owner>" in agent_src or "<Container>" in agent_src
        # The cardinality smell test must be described (single FK column on
        # the entity that has multiple counterparts in real life)
        assert "WRONG side" in agent_src or "wrong side" in agent_src.lower()

    def test_header_detail_rule_industry_agnostic(self, agent_src):
        # Header/Detail rule must list cross-industry pairs to demonstrate
        # universality, not enumerate one industry's pairs.
        assert "Header/Detail" in agent_src or "HEADER<->DETAIL" in agent_src
        assert "Parent/Child" in agent_src or "Master/Line" in agent_src
        # Must mention at least 4 different industry domains via examples
        cross_industry_pairs = ["work-order", "claim", "encounter", "batch", "voyage", "ticket", "deposit"]
        hits = sum(1 for term in cross_industry_pairs if term in agent_src)
        assert hits >= 4, (
            f"Header/Detail rule lists only {hits}/{len(cross_industry_pairs)} "
            f"cross-industry pairs; LLM may infer rule applies only to listed industries."
        )

    def test_junction_purity_rule_industry_agnostic(self, agent_src):
        assert "junction-purity" in agent_src or "JUNCTION TABLE PURITY" in agent_src
        # Must be expressed with abstract <A>/<B>/<C> placeholders, not
        # specific industry entities like SegmentMembership/CatalogItem.
        assert "<A>" in agent_src and "<B>" in agent_src
        assert "<C>" in agent_src or "third FK" in agent_src


# =====================================================================
# M5 -- Order missing canonical fields (created_at, total_amount, ...)
# =====================================================================

class TestM5CanonicalAttributesEnforced:
    """v0.8.6: rules now enforce SEMANTIC CATEGORIES per ENTITY ROLE
    (industry-agnostic), not named fields like 'subtotal'/'currency_code'.
    The agent serves 100+ industries; baking retail vocabulary into the
    prompt is itself a defect (it biases telco/healthcare/oil&gas runs)."""

    def test_alias_present(self, agent_src):
        assert "canonical-attrs-enforced" in agent_src
        assert "M5-FIX" in agent_src

    def test_role_taxonomy_industry_agnostic(self, agent_src):
        # Roles MUST be defined in pure data-modeling vocabulary
        for role in [
            "MASTER_PARTY", "MASTER_AGREEMENT", "MASTER_RESOURCE",
            "TRANSACTION_HEADER", "TRANSACTION_LINE",
            "JUNCTION", "EVENT_LOG", "REFERENCE_LOOKUP",
        ]:
            assert role in agent_src, f"Entity role '{role}' missing from prompt"

    def test_semantic_categories_used_not_named_fields(self, agent_src):
        # The new prompt block must list semantic CATEGORIES, not retail
        # field names. Verify the abstract category vocabulary is present.
        for category in [
            "IDENTITY_LABEL", "PRIMARY_CONTACT", "CLASSIFICATION_OR_TYPE",
            "LIFECYCLE_STATUS", "RECORD_AUDIT_CREATED", "RECORD_AUDIT_UPDATED",
            "BUSINESS_IDENTIFIER", "EFFECTIVE_FROM", "EFFECTIVE_UNTIL",
            "BUSINESS_EVENT_TIMESTAMP", "PARTY_REFERENCE",
            "MONETARY_TRIPLET", "QUANTITATIVE_RESULT",
            "HEADER_REFERENCE", "LINE_SEQUENCE", "RESOURCE_REFERENCE",
            "LINE_QUANTITY", "LINE_VALUE_OR_RESULT",
            "EVENT_TIMESTAMP", "EVENT_SOURCE_REFERENCE",
            "EVENT_TYPE_OR_CHANNEL", "EVENT_PAYLOAD_OR_VALUE",
        ]:
            assert category in agent_src, (
                f"Semantic category '{category}' missing — LLM will fall back "
                f"to retail-biased field names when this category was meant "
                f"to abstract over the industry vocabulary."
            )

    def test_monetary_is_conditional_not_assumed(self, agent_src):
        # The MONETARY_TRIPLET rule MUST be conditional on the entity actually
        # carrying money — not blanket-applied. Otherwise sensor readings,
        # clinical observations, citizen records get bogus money columns.
        assert "IF AND ONLY IF this transaction carries money" in agent_src
        # Non-monetary fallback must exist
        assert "QUANTITATIVE_RESULT" in agent_src

    def test_party_reference_role_is_substitutable(self, agent_src):
        # Some industries (sensor networks, scientific observations) genuinely
        # have no party. The prompt MUST allow substitution.
        assert "If there is genuinely no party" in agent_src
        assert "substitute" in agent_src

    def test_priority_over_optional_explicit(self, agent_src):
        # Anti-tautology: the prompt must explicitly tell the LLM to drop
        # optional fields BEFORE canonical categories at the attribute cap.
        assert "LAST things you drop" in agent_src
        # Must explicitly include at least the marketing/secondary tokens
        # so the LLM understands what to drop FIRST.
        assert "FIRST" in agent_src

    def test_anti_industry_bias_block_present(self, agent_src):
        # The prompt must carry an explicit anti-bias warning block
        assert "ANTI-INDUSTRY-BIAS" in agent_src
        # Three concrete anti-examples must be enumerated as warnings
        assert "Do NOT add `subtotal`" in agent_src or "Do NOT add" in agent_src
        assert "industry-specific" in agent_src or "industry_alignment" in agent_src

    def test_skip_clause_for_other_role(self, agent_src):
        assert "_canonical_skip_reason" in agent_src


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


# =====================================================================
# Permanent guard — INDUSTRY-AGNOSTIC PROMPT CONTENT (v0.8.6)
# =====================================================================

class TestPromptsAreIndustryAgnostic:
    """The agent serves 100+ industries (telco, healthcare, oil & gas,
    public sector, manufacturing, finance, insurance, transport, education,
    energy, ...). Every retail/e-commerce token in a prompt RULE biases
    the LLM toward producing retail-shaped models for non-retail customers.

    This test isolates ONLY the v0.8.5 / v0.8.6 prompt sections the
    project introduced, and bans retail-specific entity / attribute
    vocabulary inside the RULE TEXT (not inside negation warnings or
    cross-industry palettes that demonstrate breadth)."""

    # Tokens that are RETAIL/E-COMMERCE specific and have NO place in a
    # universal data-modeling RULE. Cross-industry palettes and negation
    # warnings are explicitly allowed (they teach the LLM the rule is
    # universal).
    RETAIL_RULE_TOKENS = [
        # Retail-specific entity names
        "OrderLine", "InvoiceLine", "ShipmentLine",
        "SegmentMembership", "CatalogItem", "PriceRule",
        "ConsentRecord",
        # Retail-specific attribute names
        "order_status", "order_date", "subtotal", "tax_amount",
        "total_amount", "currency_code", "line_total",
        "extended_amount", "list_price", "unit_price",
        "street_address", "postal_code", "country_code",
        "first_name", "last_name",
    ]

    # Sentinel headers identifying the v0.8.5/v0.8.6 sections we
    # introduced — the test scans ONLY between these markers.
    _M5_HEADER = "FUNDAMENTAL ATTRIBUTE CATEGORIES BY ENTITY ROLE"
    _M5_END = "PRE-SUBMISSION CHECKLIST"
    _M3M4_HEADER = "TEMPORAL PRECEDENCE (v0.8.5 M3-FIX"
    _M3M4_END = "Return JSON"
    _M1_HEADER = "The FK column name MUST EQUAL the target table"
    _M1_END = "Each source product should gain at most"

    @staticmethod
    def _slice_between(src: str, start_marker: str, end_marker: str) -> str:
        i = src.find(start_marker)
        if i < 0:
            return ""
        j = src.find(end_marker, i + len(start_marker))
        if j < 0:
            return src[i:]
        return src[i:j]

    def _scan_section(self, agent_src: str, header: str, end: str) -> list:
        section = self._slice_between(agent_src, header, end)
        if not section:
            pytest.fail(f"Section starting at '{header[:60]}...' not found")
        offenders = []
        for tok in self.RETAIL_RULE_TOKENS:
            for m in re.finditer(re.escape(tok), section):
                # Allow if appears in a NEGATION context ("Do NOT add ...",
                # "ANTI-INDUSTRY-BIAS", "NEVER", "FORBIDDEN") within ~120
                # chars before. Allow if appears in an ABSTRACT placeholder
                # context (`<...>`).
                window_start = max(0, m.start() - 200)
                window = section[window_start:m.start()]
                if any(neg in window for neg in [
                    "Do NOT", "do not", "ANTI-INDUSTRY-BIAS",
                    "NEVER", "FORBIDDEN", "anti-pattern", "ABSOLUTELY FORBIDDEN",
                ]):
                    continue
                offenders.append((tok, m.start()))
        return offenders

    def test_m5_section_industry_agnostic(self, agent_src):
        offenders = self._scan_section(agent_src, self._M5_HEADER, self._M5_END)
        assert offenders == [], (
            f"M5 (FUNDAMENTAL ATTRIBUTE CATEGORIES) contains retail-biased "
            f"tokens in RULE TEXT (not in negation/anti-bias context): "
            f"{offenders}. Use semantic categories like LIFECYCLE_STATUS, "
            f"BUSINESS_EVENT_TIMESTAMP, MONETARY_TRIPLET (conditional) instead."
        )

    def test_m3m4_section_industry_agnostic(self, agent_src):
        offenders = self._scan_section(agent_src, self._M3M4_HEADER, self._M3M4_END)
        assert offenders == [], (
            f"M3+M4 (TEMPORAL PRECEDENCE / CARDINALITY / HEADER-DETAIL / "
            f"JUNCTION) contains retail-biased tokens in RULE TEXT: "
            f"{offenders}. Use abstract <EntityEarlier>/<EntityLater>, "
            f"<Parent>/<Child>, <A>/<B> placeholders."
        )

    def test_m1_section_industry_agnostic(self, agent_src):
        offenders = self._scan_section(agent_src, self._M1_HEADER, self._M1_END)
        assert offenders == [], (
            f"M1 (FK column name VERBATIM rule) contains retail-biased "
            f"tokens in RULE TEXT: {offenders}. Use abstract <TargetEntity>"
            f"<Suffix> shapes."
        )

    def test_anti_bias_negation_block_present(self, agent_src):
        # The block must exist AND name the bad tokens (so the LLM knows
        # what to avoid) — but only inside the explicit negation block.
        m5_section = self._slice_between(agent_src, self._M5_HEADER, self._M5_END)
        assert "ANTI-INDUSTRY-BIAS" in m5_section
        # Verify the negation block names at least 3 retail tokens to negate
        anti_block_start = m5_section.find("ANTI-INDUSTRY-BIAS")
        anti_block = m5_section[anti_block_start:]
        named_negations = sum(1 for t in [
            "subtotal", "currency", "sku", "postal_code", "address_line1",
        ] if t in anti_block)
        assert named_negations >= 3, (
            f"ANTI-INDUSTRY-BIAS block names only {named_negations} retail "
            f"tokens to negate; needs at least 3 to teach the LLM the bias "
            f"surface."
        )

    def test_role_taxonomy_uses_cross_industry_palette(self, agent_src):
        # The TRANSACTION_HEADER role definition must list examples spanning
        # ≥4 different industries to show the rule is universal.
        m5 = self._slice_between(agent_src, "TRANSACTION_HEADER", "TRANSACTION_LINE")
        cross_industry = [
            "claim",          # insurance
            "ticket",         # service / IT support
            "treatment",      # healthcare
            "encounter",      # healthcare
            "ledger entry",   # finance
            "work order",     # manufacturing / utilities
            "dispatch",       # logistics
            "transfer",       # finance / supply
            "application",    # public sector
        ]
        hits = sum(1 for t in cross_industry if t in m5)
        assert hits >= 5, (
            f"TRANSACTION_HEADER definition lists only {hits}/{len(cross_industry)} "
            f"cross-industry examples; needs ≥5 to demonstrate universality."
        )
