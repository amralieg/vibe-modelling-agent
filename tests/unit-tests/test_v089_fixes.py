"""v0.8.9 fix bundle tests.

Verifies each fix has a deployable sentinel that audits can grep:

  - NEW-1-DIAG (alias=mv-artifact-failure-traceback)
  - BC1-FIX  (alias=install-audit-mirror-multisource)
  - R7-SCHEMA (alias=model-params-subdomain-required + schema additions)
  - NEW-2    (alias=vibe-count-respect-sizing-directives)
  - NEW-3    (alias=arch-domain-skip-empty-quietly)
  - NEW-4    (alias=arch-gate-tier-aware)
  - NEW-5    (alias=ext-system-prefix-string-parse)

These tests are STATIC (read-only against the notebook source) — they
verify the sentinel string + the surrounding contract is in place. The
behavioural verification happens in the live tester run.
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
        if cell.get("cell_type") == "code":
            parts.extend(cell.get("source", []))
    return "".join(parts)


@pytest.fixture(scope="module")
def agent_src() -> str:
    return _read_notebook_source(NOTEBOOK_PATH)


# ---------------------------------------------------------------------------
# NEW-1-DIAG — surface MV-artifact failure traceback
# ---------------------------------------------------------------------------
class TestNew1DiagMvArtifactTraceback:
    def test_alias_present(self, agent_src):
        assert "mv-artifact-failure-traceback" in agent_src

    def test_traceback_module_imported(self, agent_src):
        # The diagnostic block must import traceback INSIDE the except so it
        # works even in environments where traceback isn't pre-imported.
        assert "import traceback as _mv_tb" in agent_src

    def test_format_exc_called(self, agent_src):
        assert "_mv_tb.format_exc()" in agent_src

    def test_per_line_emission(self, agent_src):
        # Multi-line traceback must be split + emitted per line so each line
        # survives the volume-flush truncation cap.
        assert "for _mv_tb_line in _mv_tb.format_exc().splitlines()" in agent_src


# ---------------------------------------------------------------------------
# BC1-FIX — defensive multi-source install audit catalog
# ---------------------------------------------------------------------------
class TestBc1FixMultisourceAuditCatalog:
    def test_alias_present(self, agent_src):
        assert "install-audit-mirror-multisource" in agent_src

    def test_model_folder_fallback_added(self, agent_src):
        # Old code only read `business_context_file_path` and `context_file`.
        # The new code must ALSO read `model_folder` (runner / vibe_tester).
        assert (
            'or widgets_values.get("model_folder", "")'
            in agent_src
        )

    def test_deployment_catalog_lastresort(self, agent_src):
        # If no /Volumes/ path can be parsed, last-resort use deployment_catalog.
        assert "_dep_cat_fallback = str(widgets_values.get" in agent_src
        assert "deployment_catalog" in agent_src


# ---------------------------------------------------------------------------
# R7-SCHEMA — subdomain keys added to AI_MODEL_GENERATION_PARAMETER_SCHEMA
# ---------------------------------------------------------------------------
class TestR7SchemaSubdomainKeys:
    def test_subdomain_props_in_schema(self, agent_src):
        # Both ecm_model and mvm_model property blocks must declare these.
        # Count occurrences in the schema literal — should be exactly 2 each.
        schema_only = ""
        for line in agent_src.splitlines():
            if "_AI_MODEL_GENERATION_PARAMETER_SCHEMA_BASE" in line:
                schema_only += line + "\n"
        for key in (
            "min_business_subdomains",
            "max_business_subdomains",
            "min_products_per_subdomain",
        ):
            cnt = schema_only.count(f'"{key}"')
            assert cnt >= 4, (
                f"key {key!r} should appear ≥4× in schema literal "
                f"(properties+required for ecm + mvm); found {cnt}"
            )

    def test_subdomain_keys_required(self, agent_src):
        # Validator should still demand these (introduced in v0.8.3).
        assert (
            '"min_business_subdomains", "max_business_subdomains",'
            in agent_src
            or '"min_business_subdomains","max_business_subdomains",'
            in agent_src
        )


# ---------------------------------------------------------------------------
# NEW-2 — VIBE COUNT respects sizing_directives
# ---------------------------------------------------------------------------
class TestNew2VibeCountRespectsSizingDirectives:
    def test_alias_present(self, agent_src):
        assert "vibe-count-respect-sizing-directives" in agent_src

    def test_reads_min_max_total_products(self, agent_src):
        assert '_vc_sd.get("min_total_products")' in agent_src
        assert '_vc_sd.get("max_total_products")' in agent_src

    def test_in_target_branch_logs_info(self, agent_src):
        # When new count is in target, must log INFO not WARNING.
        assert "✅ VIBE COUNT WITHIN SIZING DIRECTIVES" in agent_src


# ---------------------------------------------------------------------------
# NEW-3 — empty `shared` domain architect-review skip is INFO not WARNING
# ---------------------------------------------------------------------------
class TestNew3ArchDomainSkipEmptyQuietly:
    def test_alias_present(self, agent_src):
        assert "arch-domain-skip-empty-quietly" in agent_src

    def test_sentinel_message_is_compared_exact(self, agent_src):
        # Must compare against the EXACT sentinel string emitted by
        # _run_one_domain so we don't accidentally downgrade real failures.
        assert (
            '_arch_skip_msg == "no products in domain — skip"'
            in agent_src
        )

    def test_skip_logged_at_info(self, agent_src):
        assert "⏭ Skipping architect review for" in agent_src


# ---------------------------------------------------------------------------
# NEW-4 — gate-hierarchy tier-aware skip
# ---------------------------------------------------------------------------
class TestNew4ArchGateTierAware:
    def test_alias_present(self, agent_src):
        assert "arch-gate-tier-aware" in agent_src

    def test_drop_set_includes_global_standard(self, agent_src):
        # The two gates dropped for tiny vibes must be exactly named.
        assert (
            '_drop_gates = {"propose_for_global_standard", "recommend_to_industry_peers"}'
            in agent_src
        )

    def test_thresholds_match_spec(self, agent_src):
        # max_total_products ≤ 30 OR max_domains ≤ 5 → tiny-vibe.
        assert "_gate_max_p <= 30" in agent_src
        assert "_gate_max_d <= 5" in agent_src


# ---------------------------------------------------------------------------
# NEW-5 — _is_system_identifier_column parses SOR string
# ---------------------------------------------------------------------------
class TestNew5ExtSystemPrefixStringParse:
    def test_alias_present(self, agent_src):
        assert "ext-system-prefix-string-parse" in agent_src

    def test_string_branch_added(self, agent_src):
        assert "isinstance(_bc_sor_raw, str)" in agent_src
        assert '_bc_sor_raw.split(",")' in agent_src

    def test_list_branch_preserved(self, agent_src):
        assert "isinstance(_bc_sor_raw, list)" in agent_src

    def test_default_empty_list(self, agent_src):
        # Final else → empty list (defensive).
        assert "_bc_sor = []" in agent_src
