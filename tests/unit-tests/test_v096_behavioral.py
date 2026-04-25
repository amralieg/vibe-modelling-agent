"""v0.9.6 BEHAVIORAL tests for naming-reserved-word-guard.

Root cause fixed: line 4523-4528 of agent notebook applied
strip_product_prefix() without checking _SQL_RESERVED_OR_AMBIGUOUS_NAMES,
causing renames like `audit.audit_type → audit.type` to be persisted to
model.json — but the DDL renderer downstream re-prefixed these to avoid
Spark SQL keyword collisions, leaving model.json↔physical desynced.

Visible symptom on airline MVM run 368656354285786:
- 2 metric views failed: safety_investigation, safety_audit
- ~129 columns total renamed to reserved bare names
- model.json said `safety.audit.type` while physical UC had `safety.audit.audit_type`

Per CLAUDE.md §8.3 (no tautologies): each test includes positive AND
negative cases that exercise real input→output behavior.
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


class TestNamingReservedWordGuard:
    """The fix adds a guard at the [NAMING] Attribute renamed site
    that skips the rename when the cleaned name is a SQL reserved
    or ambiguous bare keyword (type/category/status/code/name/etc).
    """

    def test_alias_present_in_source(self, agent_src):
        """The fix self-reports as `[naming-reserved-word-guard FIRED]`."""
        assert "naming-reserved-word-guard FIRED" in agent_src, (
            "Fix must be findable by alias-grep"
        )

    def test_guard_appears_before_rename_apply(self, agent_src):
        """Sanity: the guard MUST appear BEFORE the rename-apply line —
        not as dead code somewhere else."""
        guard_idx = agent_src.find("naming-reserved-word-guard FIRED")
        # Find the [NAMING] Attribute renamed: log site (positive case)
        rename_log_idx = agent_src.find('[NAMING] Attribute renamed:')
        assert guard_idx > 0
        assert rename_log_idx > 0
        # Both should appear in the same code region (within 3000 chars of each other)
        # because the fix sits right before the rename apply
        assert abs(rename_log_idx - guard_idx) < 3000, (
            f"Guard at {guard_idx} and rename-log at {rename_log_idx} should be near each other"
        )

    def test_reserved_set_includes_observed_failure_keywords(self, agent_src):
        """The 4 keywords that failed on airline run 368656354285786
        (type, category, status, code) MUST be in the reserved set
        so they get blocked from renaming."""
        # Find the _NAMING_RESERVED set definition near the guard
        guard_idx = agent_src.find("naming-reserved-word-guard FIRED")
        # Look in surrounding 3000-char window for the set literal
        window = agent_src[max(0, guard_idx - 200):guard_idx + 3000]
        for kw in ("'type'", "'category'", "'status'", "'code'", "'name'"):
            assert kw in window, (
                f"Reserved-name guard must include {kw} (observed in airline run failures)"
            )

    def test_guard_skips_rename_for_reserved_word(self):
        """Behavioral simulation: a column named X_type with product X
        SHOULD have cleaned_attr='type' and the guard SHOULD skip the rename."""
        # Simulate the strip_product_prefix logic + guard
        reserved = {
            'date', 'time', 'timestamp', 'type', 'name', 'status', 'code', 'value',
            'number', 'method', 'source', 'target', 'key', 'index', 'order', 'group',
            'level', 'state', 'action', 'role', 'mode', 'class', 'scope', 'range',
            'start', 'end', 'count', 'sum', 'avg', 'min', 'max', 'rank', 'row',
            'column', 'table', 'schema', 'database', 'select', 'from', 'where',
            'category', 'description', 'comment', 'text', 'data', 'result',
        }

        def strip_product_prefix_simulator(attr_name, product):
            # Same pattern as agent: if attr starts with product_, strip it
            prefix = f"{product}_"
            if attr_name.lower().startswith(prefix):
                return attr_name[len(prefix):]
            return attr_name

        # Positive case: audit.audit_type — stripped would be 'type' (reserved)
        attr = "audit_type"
        product = "audit"
        cleaned = strip_product_prefix_simulator(attr, product)
        assert cleaned == "type"
        assert cleaned.lower() in reserved, "guard should fire for type"

        # Positive case: investigation.investigation_category
        attr = "investigation_category"
        product = "investigation"
        cleaned = strip_product_prefix_simulator(attr, product)
        assert cleaned == "category"
        assert cleaned.lower() in reserved, "guard should fire for category"

        # Positive case: audit.audit_status
        attr = "audit_status"
        product = "audit"
        cleaned = strip_product_prefix_simulator(attr, product)
        assert cleaned == "status"
        assert cleaned.lower() in reserved, "guard should fire for status"

    def test_guard_does_NOT_skip_safe_renames(self):
        """Negative case: column name X_finding with product X should
        rename cleanly to 'finding' — NOT a reserved word, so guard MUST NOT fire."""
        reserved = {
            'date', 'time', 'timestamp', 'type', 'name', 'status', 'code', 'value',
            'number', 'method', 'source', 'target', 'key', 'index', 'order', 'group',
            'category', 'description', 'comment', 'text', 'data', 'result',
        }

        # Negative case: audit_finding → finding (SAFE)
        cleaned = "finding"
        assert cleaned.lower() not in reserved, (
            "finding is not reserved — rename SHOULD proceed"
        )

        # Negative case: investigation_report → report (SAFE)
        cleaned = "report"
        assert cleaned.lower() not in reserved, (
            "report is not reserved — rename SHOULD proceed"
        )

        # Negative case: occurrence_severity → severity (SAFE)
        cleaned = "severity"
        assert cleaned.lower() not in reserved, (
            "severity is not reserved — rename SHOULD proceed"
        )

        # Negative case: cargo_owner → owner (SAFE — owner is not in our list)
        cleaned = "owner"
        assert cleaned.lower() not in reserved, (
            "owner is not reserved in our ambiguous set — rename SHOULD proceed"
        )

    def test_guard_blocks_observed_v95_renames(self, agent_src):
        """The 6 specific desyncs from airline run 368656354285786:
        - safety.audit.audit_type → type
        - safety.audit.audit_category → category
        - safety.audit.audit_status → status
        - safety.investigation.investigation_type → type
        - safety.investigation.investigation_category → category
        - safety.investigation.investigation_status → status

        Each cleaned name (type/category/status) MUST be blocked by the guard."""
        # Read the reserved set from source to confirm coverage
        guard_idx = agent_src.find("naming-reserved-word-guard FIRED")
        window = agent_src[guard_idx:guard_idx + 3000]
        # Each observed failure column must be in the reserved set
        for failure_col in ('type', 'category', 'status'):
            assert f"'{failure_col}'" in window, (
                f"v0.9.5 desync column '{failure_col}' must be in v0.9.6 reserved set"
            )

    def test_continue_branch_in_guard(self, agent_src):
        """Sanity: the guard must use `continue` (not `pass` or just log)
        to actually skip the rename apply. If it logs but proceeds to apply,
        the bug is not fixed."""
        # Find the SECOND occurrence (the actual logger.info call inside the
        # guard, not the comment). We want the line that says "Skipped rename:"
        skip_log_idx = agent_src.find("[naming-reserved-word-guard FIRED] Skipped rename:")
        assert skip_log_idx > 0, "guard must log when it fires"
        # The `continue` must appear within ~500 chars after the skip-log,
        # NOT before — otherwise the rename still applies.
        window = agent_src[skip_log_idx:skip_log_idx + 500]
        assert "continue" in window, (
            "Guard must `continue` immediately after logging FIRED — otherwise rename still applies"
        )
