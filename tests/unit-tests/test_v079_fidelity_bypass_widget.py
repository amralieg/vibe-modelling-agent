import json
import re
from pathlib import Path

import pytest

NB_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"
EXPECTED_VERSION = "0.7.9"
EXPECTED_ALIAS = "fidelity-bypass-widget-live"
WIDGET_NAME = "vibe_fidelity_gate_halt_disabled"


@pytest.fixture(scope="module")
def nb():
    with open(NB_PATH) as f:
        return json.load(f)


@pytest.fixture(scope="module")
def code_cells(nb):
    return [c for c in nb["cells"] if c.get("cell_type") == "code"]


@pytest.fixture(scope="module")
def all_code_text(code_cells):
    return "\n".join("".join(c["source"]) for c in code_cells)


def test_agent_version_bumped(all_code_text):
    assert f'__AGENT_VERSION__ = "{EXPECTED_VERSION}"' in all_code_text, (
        f"__AGENT_VERSION__ must be {EXPECTED_VERSION!r} per CLAUDE.md §3a-bis"
    )


def test_widget_declared_via_dbutils(all_code_text):
    pattern = rf'dbutils\.widgets\.(text|dropdown)\(\s*"{re.escape(WIDGET_NAME)}"'
    assert re.search(pattern, all_code_text), (
        f"widget {WIDGET_NAME!r} must be declared via dbutils.widgets.text/dropdown "
        "at notebook top — closes §8.3 dead-code violation from v0.7.5/v0.7.7"
    )


def test_widget_declaration_appears_after_vibe_session_id(code_cells):
    """The widget MUST be declared on cell 7 right after vibe_session_id (deterministic position)."""
    cell_with_vibe_session = None
    for i, c in enumerate(code_cells):
        s = "".join(c["source"])
        if 'dbutils.widgets.text("vibe_session_id"' in s:
            cell_with_vibe_session = i
            break
    assert cell_with_vibe_session is not None
    src = "".join(code_cells[cell_with_vibe_session]["source"])
    vs_idx = src.find('dbutils.widgets.text("vibe_session_id"')
    fb_idx = src.find(f'"{WIDGET_NAME}"')
    assert fb_idx > vs_idx, (
        f"{WIDGET_NAME} declaration must come AFTER vibe_session_id widget "
        "(deterministic ordering required for ops to find widget #25 in UI)"
    )


def test_widget_in_notebook_widget_names(all_code_text):
    m = re.search(r"_NOTEBOOK_WIDGET_NAMES\s*=\s*\[(.+?)\]", all_code_text, re.DOTALL)
    assert m, "_NOTEBOOK_WIDGET_NAMES list not found"
    listed = m.group(1)
    assert f'"{WIDGET_NAME}"' in listed, (
        f"{WIDGET_NAME!r} must be listed in _NOTEBOOK_WIDGET_NAMES "
        "so widget-clearing helpers don't strip it on re-init"
    )


def test_widget_read_via_safe_widget(all_code_text):
    pattern = rf'_safe_widget\(\s*"{re.escape(WIDGET_NAME)}"'
    assert re.search(pattern, all_code_text), (
        f"{WIDGET_NAME} must be READ via _safe_widget() in get_widget_values, "
        "not just appear in widget declaration. Without this read the value never "
        "enters widget_values dict and the bypass is dead code (§8.3)."
    )


def test_widget_parsed_to_bool(all_code_text):
    """The string widget value (since dbutils returns strings) must be parsed to bool BEFORE
    being placed in widget_values. Using bool(str) directly is wrong because bool('False') = True."""
    assert "w_vibe_fidelity_gate_halt_disabled = str(_w_fidbypass_raw).strip().lower() in" in all_code_text, (
        "Widget value must be parsed via str-lower-membership-check (not bool(str)) "
        "to correctly handle 'False'/'True'/'0'/'1'/'yes'/'no'. bool('False') = True is a known foot-gun."
    )


def test_widget_propagated_to_widget_values_dict(all_code_text):
    pattern = rf'widget_values\[\s*"{re.escape(WIDGET_NAME)}"\s*\]\s*=\s*w_vibe_fidelity_gate_halt_disabled'
    assert re.search(pattern, all_code_text), (
        f"{WIDGET_NAME} must be assigned into widget_values dict so it propagates "
        "to VibeOrchestrator(widget_values).widgets_values where the fidelity-halt site reads it"
    )


def test_widget_in_raw_values_dict(all_code_text):
    """The _widget_raw_values dict (used for downstream display + audit) must include the new widget."""
    assert f'"{WIDGET_NAME}": w_vibe_fidelity_gate_halt_disabled' in all_code_text, (
        f"{WIDGET_NAME} must appear in _widget_raw_values so audit/log paths see the operator opt-in"
    )


def test_alias_present_in_code(all_code_text):
    assert f"alias={EXPECTED_ALIAS}" in all_code_text, (
        f"alias={EXPECTED_ALIAS} must appear in code so deploy-grep verification can prove the fix is live"
    )


def test_alias_count_at_least_three(all_code_text):
    """The alias should fire on the version-comment + at least 2 code sites (parse + propagate)."""
    n = all_code_text.count(EXPECTED_ALIAS)
    assert n >= 3, f"alias={EXPECTED_ALIAS} should appear ≥3× (got {n}) — version comment + parse + propagate"


def test_no_dead_code_bypass_anymore(all_code_text):
    """The fidelity-halt read site (line ~26734) must STILL be there — we kept it, just made it live."""
    assert "self.widgets_values.get(\"vibe_fidelity_gate_halt_disabled\", False)" in all_code_text, (
        "The fidelity-halt read site must remain — v0.7.9 makes it LIVE, not removes it"
    )


def test_bool_parser_handles_all_truthy_strings():
    """Verify the in-tuple membership semantics catch every reasonable opt-in form."""
    parser = lambda raw: str(raw).strip().lower() in ("true", "1", "yes", "y", "on")
    for truthy in ["True", "TRUE", "true", "1", "yes", "Yes", "YES", " on ", "y", "Y", "on"]:
        assert parser(truthy), f"Parser must accept {truthy!r} as opt-in"
    for falsy in ["False", "false", "0", "no", "n", "off", "", " ", "FALSE", "  False  "]:
        assert not parser(falsy), f"Parser must REJECT {falsy!r} as opt-out (NOT bypass)"


def test_bool_parser_rejects_bool_string_foot_gun():
    """Critical: bool('False') = True. Our parser must NOT use bool() directly."""
    parser = lambda raw: str(raw).strip().lower() in ("true", "1", "yes", "y", "on")
    assert not parser("False"), "REGRESSION: bool('False') is True in Python — we MUST NOT use bool() to parse"
