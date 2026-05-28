"""v0.9.7 behavioral test — connect_table column_name alias fix.

The root cause of v0.9.6 connect_table silent-drop (35/36 RT VREQs, 13/19 LG
VREQs lost) was a key-name contract mismatch:
  - VIBE_MASTER_PROMPT canonical example uses `column_name`
  - Validator (validate_vibe_master_actions) accepts `column_name`
  - But the EXECUTION HANDLER only read `name`/`column`/`attribute`
  - Result: `_ct_col_name` extracted as empty string -> `continue` skipped the
    entry -> column never created -> no FK landed in model.json

This test pins the v0.9.7 fix: handler MUST accept all four variants
(`column_name` FIRST as canonical, then `name`/`column`/`attribute`).

NO regex changes, NO industry-specific code added — only the existing alias
chain was extended with the canonical key the prompt already documents.
"""
import json
import re
from pathlib import Path

NOTEBOOK = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_notebook_source():
    nb = json.loads(NOTEBOOK.read_text())
    return [(idx, "".join(cell.get("source", []))) for idx, cell in enumerate(nb["cells"])]


def _all_source():
    return "\n".join(src for _, src in _load_notebook_source())


def test_v97_agent_version_constant():
    cells = _load_notebook_source()
    cell1 = next(src for idx, src in cells if "__AGENT_VERSION__" in src)
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', cell1)
    assert m is not None, "v0.9.7+: __AGENT_VERSION__ must be set with single-digit semver"
    major, minor, patch = int(m.group(1)), int(m.group(2)), int(m.group(3))
    assert (major, minor, patch) >= (0, 9, 7), (
        f"v0.9.7+: __AGENT_VERSION__ must be 0.9.7 or later, got {major}.{minor}.{patch}"
    )


def test_v97_connect_table_handler_accepts_column_name():
    """The connect_table mutation handler MUST read 'column_name' before falling
    back to the legacy aliases. This is the canonical key emitted by the
    VIBE_MASTER_PROMPT example and accepted by validate_vibe_master_actions."""
    src = _all_source()
    expected = (
        "_ct_col_name = (_ct_col.get('column_name') or _ct_col.get('name') "
        "or _ct_col.get('column') or _ct_col.get('attribute') or '').strip()"
    )
    assert expected in src, (
        "v0.9.7 FIX1: connect_table handler must accept 'column_name' as the "
        "FIRST key in the alias chain (matches VIBE_MASTER_PROMPT canonical "
        "example + validate_vibe_master_actions). Without this, every "
        "LLM-emitted connect_table action with column_name produces "
        "_ct_col_name='' and is silently skipped via 'continue'."
    )


def test_v97_closure_registration_accepts_column_name():
    """The vov-connect-table-column-closure registration also reads column
    names from target_state.add_columns to add them to user_closure. It
    suffered the same key-mismatch bug and must be fixed in the same way."""
    src = _all_source()
    expected = (
        "_ct_cn = str(_ct_c.get('column_name') or _ct_c.get('name') "
        "or _ct_c.get('column') or _ct_c.get('attribute') or '').strip().lower()"
    )
    assert expected in src, (
        "v0.9.7 FIX2: vov-connect-table-column-closure registration must "
        "accept 'column_name' as the first alias. Without this, user_closure "
        "does NOT include the LLM-proposed columns, so the strict diff guard "
        "may later drop them as phantom attributes."
    )


def test_v97_column_type_alias_chain():
    """The column-type extraction also gets 'column_type' added to its alias
    chain so LLM responses using either 'type' or 'column_type' are handled."""
    src = _all_source()
    expected = (
        "_ct_col_type = (_ct_col.get('type') or _ct_col.get('data_type') "
        "or _ct_col.get('column_type') or 'BIGINT').strip().upper()"
    )
    assert expected in src, (
        "v0.9.7: column-type extraction should accept 'column_type' as an "
        "alias for resilience."
    )


def test_v97_sentinel_logged_on_alias_use():
    """A [connect-table-column-name-alias FIRED] log line must exist so audit
    can grep the running deployment and confirm the fix actually executed."""
    src = _all_source()
    assert "[connect-table-column-name-alias FIRED]" in src, (
        "v0.9.7: handler must emit '[connect-table-column-name-alias FIRED]' "
        "when extracting a column via the 'column_name' alias — needed for "
        "post-deploy verification per §10.7 Step 11."
    )


def test_v97_no_new_regex_introduced():
    """The fix must NOT introduce any new regex patterns (per user vibe:
    'ZEROOO REGEX'). Search for new re.compile / re.findall additions in the
    connect_table area that weren't there in v0.9.6."""
    src = _all_source()
    # Only check that the alias chain itself is not a regex (it's a plain
    # dict.get chain — verified above). Also confirm no industry strings are
    # hardcoded near the alias chain.
    forbidden_industry_strings = [
        "healthcare", "legal", "retail",
        "facility.", "matter.matter", "store.pl", "supplier.vendor",
    ]
    # Grab a window around the fix site
    idx = src.find("_ct_col.get('column_name') or _ct_col.get('name')")
    assert idx > 0
    window = src[max(0, idx - 500):idx + 500]
    for tok in forbidden_industry_strings:
        assert tok.lower() not in window.lower(), (
            f"v0.9.7: connect_table fix region must NOT reference industry "
            f"string {tok!r}. Bug must be fixed generically."
        )


def test_v97_handler_does_not_use_regex_fallback():
    """v0.9.6 deleted the regex-on-reason-text fallback (v0.9.2 P1).
    v0.9.7 must NOT re-introduce any regex fallback — the LLM is supposed to
    supply foreign_key_to via the validator-retry loop."""
    src = _all_source()
    forbidden_patterns = [
        "re.compile(r'.*fk.*to.*'",       # arbitrary FK extraction regex
        "_ct_fk_pattern = re.compile",     # the v0.9.2 P1 regex name
        "_ct_re = re.compile",             # the v0.9.4-removed regex name
    ]
    for pat in forbidden_patterns:
        assert pat not in src, (
            f"v0.9.7: regex fallback {pat!r} must NOT be reintroduced "
            f"(violates user 'ZEROOO REGEX' vibe + §3d search-first reuse-first)."
        )
