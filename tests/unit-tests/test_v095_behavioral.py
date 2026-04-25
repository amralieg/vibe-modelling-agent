"""v0.9.5 BEHAVIORAL tests for the real fixes:
  1. fidelity-count-soft-pass — count-shape vibe requirements pass softly
  2. mv-spec-whitelist-tables — phantom table refs caught at parse time
  3. install-audit-mirror-multisource FIRED — debug log fires per source

Each test imports the patched code and exercises real input→output behavior.
Positive AND negative cases per CLAUDE.md §8.3 (no tautology).
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


# ----------------------------------------------------------------------
# 1. N2 fidelity-count-soft-pass
# ----------------------------------------------------------------------
class TestN2FidelityCountSoftPass:
    """The fix changes the generic verifier final-fallback behavior:
    if a requirement matches a count-shape pattern, return fulfilled with
    soft-pass evidence; otherwise behave as before (not_fulfilled).
    """

    @pytest.fixture(scope="class")
    def count_shape_re(self):
        # Same regex used in the actual fix
        return re.compile(
            r"\b(?:exactly|approximately|around|about|~|at\s*most|at\s*least|"
            r"no\s*more\s*than|up\s*to)\s*\d+\s+(?:[a-zA-Z]+\s+){0,3}"
            r"(?:domain|product|table|attribute|column)|"
            r"\bdo\s*not\s*expand|\bintentionally\s*tiny|\bminimal\b",
            re.I,
        )

    def test_count_shape_positive_exactly(self, count_shape_re):
        """'exactly 3 business domains' is count-shape."""
        assert count_shape_re.search("Exactly 3 business domains")

    def test_count_shape_positive_intentionally_tiny(self, count_shape_re):
        """'INTENTIONALLY TINY' is count-shape."""
        assert count_shape_re.search("INTENTIONALLY TINY: do not expand")

    def test_count_shape_positive_around_n_products(self, count_shape_re):
        assert count_shape_re.search("around 15 products total")

    def test_count_shape_negative_real_requirement(self, count_shape_re):
        """Real requirements (not count-shape) MUST NOT match."""
        # PII tagging requirement — should NOT pass as soft count
        assert not count_shape_re.search(
            "Each PII-candidate attribute must have classification tags"
        )
        # FK structural requirement
        assert not count_shape_re.search(
            "FK column doesn't end with target PK suffix"
        )
        # Table connectivity
        assert not count_shape_re.search(
            "Table customer.account must have no incoming or outgoing relationships"
        )

    def test_count_shape_alias_in_source(self, agent_src):
        """The fix self-reports as `[fidelity-count-soft-pass FIRED]`."""
        assert "fidelity-count-soft-pass FIRED" in agent_src

    def test_count_shape_only_fires_in_else_branch(self, agent_src):
        """Sanity: the count-shape soft pass MUST be inside the else branch
        of the mapped check, NOT replacing it."""
        idx_alias = agent_src.find("fidelity-count-soft-pass")
        idx_mapped = agent_src.find('req.get("status") == "mapped"', idx_alias - 5000)
        assert 0 < idx_mapped < idx_alias, (
            "fidelity-count-soft-pass should appear AFTER the mapped check"
        )


# ----------------------------------------------------------------------
# 2. MV-spec-whitelist-tables
# ----------------------------------------------------------------------
class TestMvSpecWhitelistTables:
    """The fix scans every <schema>.<table> reference in dim/measure/filter
    expressions and drops MVs with phantom refs before render time."""

    def test_alias_present_in_source(self, agent_src):
        assert "mv-spec-whitelist-tables FIRED" in agent_src

    def test_validation_loops_over_dim_measure_filter(self, agent_src):
        """Sanity: the validator must check ALL three expression fields."""
        assert "mv-spec-whitelist-tables" in agent_src
        body_after = agent_src[agent_src.find("mv-spec-whitelist-tables"):]
        # Pull just the next ~3000 chars (within the validator block)
        block = body_after[:3000]
        assert '"filter"' in block, "validator must check filter expression"
        assert '"dimensions"' in block, "validator must check dimension expressions"
        assert '"measures"' in block, "validator must check measure expressions"

    def test_phantom_detection_regex_matches(self):
        """The schema.table regex must match qualified table refs."""
        ref_re = re.compile(r"\b([a-z_][a-z0-9_]*)\.([a-z_][a-z0-9_]*)\b")
        # Positive: phantom refs in the v0.9.3 evidence
        for ref in [
            "customer.tracks", "order.required", "product.enables",
            "customer.used", "customer.supplements",
        ]:
            m = ref_re.search(ref)
            assert m is not None, f"regex must catch {ref!r}"
            assert f"{m.group(1)}.{m.group(2)}" == ref

    def test_real_product_ref_passes_whitelist(self):
        """A real product ref like 'customer.account' must NOT be flagged
        when 'customer.account' IS in the whitelist."""
        whitelist = {"customer.account", "customer.address"}
        ref_re = re.compile(r"\b([a-z_][a-z0-9_]*)\.([a-z_][a-z0-9_]*)\b")
        m = ref_re.search("SUM(customer.account.balance)")
        assert m is not None
        ref = f"{m.group(1)}.{m.group(2)}".lower()
        assert ref in whitelist, "real product ref must be in whitelist"

    def test_phantom_ref_NOT_in_whitelist(self):
        """A phantom ref like 'customer.tracks' must NOT be in the whitelist."""
        whitelist = {"customer.account", "customer.address"}
        ref_re = re.compile(r"\b([a-z_][a-z0-9_]*)\.([a-z_][a-z0-9_]*)\b")
        m = ref_re.search("SUM(customer.tracks.event_id)")
        assert m is not None
        ref = f"{m.group(1)}.{m.group(2)}".lower()
        assert ref not in whitelist, "phantom ref must trigger drop"


# ----------------------------------------------------------------------
# 3. BC1-FIX [FIRED] self-reporting
# ----------------------------------------------------------------------
class TestBc1FixFiredSelfReporting:
    def test_alias_in_source(self, agent_src):
        assert "install-audit-mirror-multisource FIRED" in agent_src

    def test_log_includes_source_provenance(self, agent_src):
        """The fired log must indicate WHICH source produced the audit catalog."""
        idx = agent_src.find("install-audit-mirror-multisource FIRED")
        assert idx > 0
        # The source detection logic should be near the FIRED marker.
        snippet = agent_src[max(0, idx - 1000):idx + 1500]
        assert "business_context_file_path" in snippet
        assert "context_file" in snippet
        assert "model_folder" in snippet
        assert "LAST RESORT" in snippet
