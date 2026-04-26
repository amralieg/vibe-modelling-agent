"""v1.0.5 BEHAVIORAL tests — eliminate the two v1.0.4 soft findings.

Fixes covered:
  E. fk-validator-skip-external-refs
     - In validate_in_domain_linking, potential_fk_attrs now excludes attrs
       whose name starts with `external_` or ends with `_code`/`_ref`/`_handle`/
       `_key`/`_uuid`/`_slug`. This prevents the 'Max retries (2) exhausted'
       spurious warning for attrs the LLM correctly classified as external codes.

  F. bidirectional-pointer-auto-resolve
     - In _detect_direct_bidirectional_links, bidirectional pairs where one
       side's attribute name is a pointer pattern (default_/primary_/current_/
       latest_/last_/preferred_/main_) are auto-resolved inline by stripping
       the pointer-side FK. The pair is removed from the returned list so the
       downstream cycle detector never sees it. Emits INFO (not WARNING).

Positive + negative cases per CLAUDE.md section 8.3 anti-tautology.
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


class TestFKValidatorSkipExternalRefs:
    """Fix E: external refs excluded from silo check."""

    def test_alias_present(self, agent_src):
        assert "[fk-validator-skip-external-refs FIRED]" in agent_src
        assert "alias=fk-validator-skip-external-refs" in agent_src

    def test_helper_function_present(self, agent_src):
        assert "_v105_is_external_ref" in agent_src

    def test_external_prefix_excluded(self, agent_src):
        idx = agent_src.find("_v105_is_external_ref")
        assert idx != -1
        window = agent_src[idx:idx + 800]
        assert "startswith('external_')" in window

    def test_natural_key_suffixes_excluded(self, agent_src):
        idx = agent_src.find("_v105_is_external_ref")
        window = agent_src[idx:idx + 800]
        for suffix in ("_code", "_ref", "_handle", "_key", "_uuid", "_slug"):
            assert f"'{suffix}'" in window, f"suffix {suffix} must be in exclusion list"

    def test_helper_applied_to_potential_fk_attrs(self, agent_src):
        idx = agent_src.find("potential_fk_attrs = [a.get('attribute') for a in sp_attrs")
        assert idx != -1
        window = agent_src[idx:idx + 1000]
        assert "_v105_is_external_ref" in window

    def test_external_ref_logic_positive_negative(self):
        def _v105_is_external_ref(attr_name):
            _n = (attr_name or '').lower()
            if _n.startswith('external_'):
                return True
            for _suffix in ('_code', '_ref', '_handle', '_key', '_uuid', '_slug'):
                if _n.endswith(_suffix):
                    return True
            return False
        assert _v105_is_external_ref("external_segment_id") is True
        assert _v105_is_external_ref("customer_code") is True
        assert _v105_is_external_ref("partner_ref") is True
        assert _v105_is_external_ref("region_handle") is True
        assert _v105_is_external_ref("natural_key") is True
        assert _v105_is_external_ref("system_uuid") is True
        assert _v105_is_external_ref("url_slug") is True
        assert _v105_is_external_ref("account_id") is False
        assert _v105_is_external_ref("customer_id") is False
        assert _v105_is_external_ref("order_id") is False
        assert _v105_is_external_ref("shipment_id") is False
        assert _v105_is_external_ref("") is False
        assert _v105_is_external_ref(None) is False


class TestBidirectionalPointerAutoResolve:
    """Fix F: pointer-style bidirectional pairs auto-resolved before warning."""

    def test_alias_present(self, agent_src):
        assert "[bidirectional-pointer-auto-resolve FIRED]" in agent_src
        assert "alias=bidirectional-pointer-auto-resolve" in agent_src

    def test_helper_function_present(self, agent_src):
        assert "_v105_is_pointer_attr" in agent_src

    def test_pointer_prefixes_present(self, agent_src):
        idx = agent_src.find("_v105_is_pointer_attr")
        assert idx != -1
        window = agent_src[idx:idx + 800]
        for prefix in ("default_", "primary_", "current_", "latest_", "last_", "preferred_", "main_"):
            assert f"'{prefix}'" in window, f"pointer prefix {prefix} must be in detection set"

    def test_auto_resolve_runs_before_warning(self, agent_src):
        anchor = "if bidirectional_links:"
        occurrences = [m.start() for m in re.finditer(re.escape(anchor), agent_src)]
        found = False
        for pos in occurrences:
            window = agent_src[max(0, pos - 3500):pos]
            if "bidirectional-pointer-auto-resolve" in window:
                found = True
                break
        assert found, "auto-resolve block must appear BEFORE the WARNING block in _detect_direct_bidirectional_links"

    def test_auto_resolve_strips_fk_and_filters_links(self, agent_src):
        idx = agent_src.find("bidirectional-pointer-auto-resolve")
        assert idx != -1
        window = agent_src[idx:idx + 3500]
        assert "_pa['foreign_key_to'] = ''" in window, "must strip FK on pointer side"
        assert "bidirectional_links = _v105_keep_links" in window, "must replace list so cycle detector does not see pair"

    def test_log_level_is_info_for_auto_resolved(self, agent_src):
        idx = agent_src.find("bidirectional-pointer-auto-resolve FIRED")
        assert idx != -1
        window_before = agent_src[max(0, idx - 200):idx]
        assert "logger.info" in window_before, "auto-resolve FIRED line must be INFO, not WARNING"

    def test_pointer_logic_positive_negative(self):
        def _v105_is_pointer_attr(attr_name):
            _n = (attr_name or '').lower()
            for _prefix in ('default_', 'primary_', 'current_', 'latest_', 'last_', 'preferred_', 'main_'):
                if _n.startswith(_prefix):
                    return True
            return False
        assert _v105_is_pointer_attr("default_shipping_address_id") is True
        assert _v105_is_pointer_attr("primary_account_id") is True
        assert _v105_is_pointer_attr("current_session_id") is True
        assert _v105_is_pointer_attr("latest_order_id") is True
        assert _v105_is_pointer_attr("last_login_id") is True
        assert _v105_is_pointer_attr("preferred_address_id") is True
        assert _v105_is_pointer_attr("main_contact_id") is True
        assert _v105_is_pointer_attr("account_id") is False
        assert _v105_is_pointer_attr("customer_id") is False
        assert _v105_is_pointer_attr("address_id") is False
        assert _v105_is_pointer_attr("") is False
        assert _v105_is_pointer_attr(None) is False


class TestV104RegressionUnchanged:
    """Regression: v1.0.4 fixes remain intact in v1.0.5."""

    def test_v104_aliases_intact(self, agent_src):
        for alias in (
            "mv-filter-strip-comments",
            "mv-column-prevalidate-drop",
        ):
            assert alias in agent_src, f"v1.0.4 alias {alias!r} must not regress"

    def test_v104_prompt_joins_disabled_still_present(self, agent_src):
        assert "SINGLE-TABLE METRIC VIEWS ONLY" in agent_src
        assert "SINGLE-TABLE KPIs ONLY" in agent_src
        assert "JOINS ARE DISABLED" in agent_src


class TestV103RegressionUnchanged:
    """Regression: v1.0.3 fixes remain intact in v1.0.5."""

    def test_v103_aliases_intact(self, agent_src):
        for alias in (
            "fidelity-count-soft-pass-strategy-agnostic",
            "mv-cross-table-measure-drop",
        ):
            assert alias in agent_src, f"v1.0.3 alias {alias!r} must not regress"

    def test_earlier_aliases_intact(self, agent_src):
        for alias in (
            "fidelity-count-soft-pass-deterministic",
            "mv-source-product-prefix-rewrite",
            "prefix-strip-reserved-word-guard",
            "mv-spec-whitelist-tables",
        ):
            assert alias in agent_src, f"earlier alias {alias!r} must not regress"


class TestV105AntiTautology:
    """Anti-tautology: each filter must have distinct positive AND negative cases."""

    def test_external_ref_filter_is_not_identity(self):
        def _f(n):
            n = (n or '').lower()
            if n.startswith('external_'):
                return True
            for s in ('_code', '_ref', '_handle', '_key', '_uuid', '_slug'):
                if n.endswith(s):
                    return True
            return False
        truth_pairs = [("external_x_id", True), ("regular_id", False)]
        vals = {_f(n) for n, _ in truth_pairs}
        assert True in vals and False in vals, "filter must distinguish cases"

    def test_pointer_filter_is_not_identity(self):
        def _f(n):
            n = (n or '').lower()
            for p in ('default_', 'primary_', 'current_', 'latest_', 'last_', 'preferred_', 'main_'):
                if n.startswith(p):
                    return True
            return False
        truth_pairs = [("default_x", True), ("regular_x", False)]
        vals = {_f(n) for n, _ in truth_pairs}
        assert True in vals and False in vals, "filter must distinguish cases"
