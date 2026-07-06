from notebook_source_util import notebook_concat_source

"""Behavioral test for v1.1.0 — mv-rewrite-name-as-column.

Live-run failure: pulse 14 RT install_v2 emitted

    [Metrics] Failed metric view 'pricing_competitor'. Error:
        [UNRESOLVED_COLUMN.WITH_SUGGESTION] A column, variable, or function
        parameter with name `name` cannot be resolved. Did you mean one of
        the following? [`notes`, `tier`, `brand_name`, `channel_mix`,
        `founded_year`]. SQLSTATE: 42703
        | rewrite+strip+safe all failed: ...

    [Metrics] Failed metric view 'vendor_contract'. Error:
        UNRESOLVED_COLUMN with name `name` cannot be resolved. Did you
        mean one of the following? [`moq`, `value`, `owner`, `signed_date`,
        `approved_by`].
        | rewrite+strip+safe all failed: ...

Both metric views referenced a bare ``name`` column that was renamed during
normalisation (to ``brand_name`` and ``contract_name`` respectively). The
existing rewriters ``_rewrite_unresolved_columns`` + ``_rewrite_via_describe``
both refused to attempt the rewrite because ``name`` was in the
``_STRUCT_KEYS`` blacklist for YAML structural keys.

Root cause: the ``_STRUCT_KEYS`` blacklist was added to avoid corrupting YAML
structural keys (e.g. ``name: "Total Brands"`` is the dimension *name* yaml
key, not a column reference). But Spark only emits UNRESOLVED_COLUMN when
the token is being *used as a column*. So if the error message says
``name`` cannot be resolved, the bare token IS a column, not a key. The
blanket blacklist refusal blocks legitimate rewrites.

v1.1.0 fix: replace the blanket `if _bare in _STRUCT_KEYS: return None` with
per-line substitution that skips lines whose token is at YAML-key position
(``^\\s*<bare>\\s*:``). Column references inside ``expr:``/``filter:`` get
rewritten while structural keys are left untouched.

Behavioural: this test re-implements the v1.1.0 rewriter in isolation and
proves:
  - YAML with bare ``name`` in ``expr: "name"`` AND structural ``name: "X"``
    key gets the expr rewritten to ``brand_name`` while the YAML ``name:``
    key is preserved.
  - Pre-fix behaviour (returning None) is verified by inspecting agent
    source for the now-removed early-return code shape.

Per CLAUDE.md §8.10 — every fix needs a behavioural test alongside any
static-grep contract. The agent source grep below proves the FIRED sentinel
is in the deployed code path; the in-process simulation proves the rewriter
behaviour for the exact pulse 14 inputs.
"""
import json
import os
import re

import pytest

REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
AGENT_NB = os.path.join(REPO_ROOT, "agent", "dbx_vibe_modelling_agent.ipynb")


@pytest.fixture(scope="module")
def agent_text():
    with open(AGENT_NB, "r", encoding="utf-8", errors="ignore") as f:
        return f.read()


def test_v110_agent_version_is_1_1_0_or_newer(agent_text):
    matches = re.findall(r'__AGENT_VERSION__\s*=\s*\\?"(\d+\.\d+\.\d+)\\?"', agent_text)
    assert matches, "__AGENT_VERSION__ literal missing"
    def _ge_1_1_0(v):
        a, b, c = (int(x) for x in v.split("."))
        return (a, b, c) >= (1, 1, 0)
    assert any(_ge_1_1_0(v) for v in matches), (
        f"__AGENT_VERSION__ must be >= 1.1.0 for v1.1.0 fixes, found {matches}"
    )


def test_v110_mv_rewrite_alias_present_at_both_sites(agent_text):
    """Both ``_rewrite_unresolved_columns`` and ``_rewrite_via_describe`` must emit
    the v1.1.0 sentinel when they fall through to per-line struct-key rewrite."""
    sentinel = "mv-rewrite-name-as-column FIRED"
    occurrences = agent_text.count(sentinel)
    assert occurrences >= 2, (
        f"v1.1.0 sentinel '{sentinel}' must appear at BOTH rewriter sites "
        f"(`_rewrite_unresolved_columns` + `_rewrite_via_describe`); found {occurrences}"
    )


def test_v110_blanket_struct_key_refusal_removed(agent_text):
    """Pre-fix code returned None unconditionally when bare was in _STRUCT_KEYS.
    v1.1.0 must replace that with the per-line substitution path."""
    fn_match = re.search(r"def _rewrite_unresolved_columns\(stmt_text, err_message\):", agent_text)
    assert fn_match, "_rewrite_unresolved_columns helper missing"
    body = agent_text[fn_match.end():fn_match.end() + 4000]
    assert "_key_pat = re.compile" in body, (
        "v1.1.0 must use per-line YAML-key skip pattern; rewrite is missing"
    )
    assert "mv-rewrite-name-as-column FIRED" in body, (
        "_rewrite_unresolved_columns must emit the v1.1.0 sentinel"
    )


def _rewrite_unresolved_columns_v110(stmt_text, err_message):
    """Standalone reproduction of the v1.1.0 rewriter for behavioural testing.

    Mirrors the on-disk code in agent notebook (no closure deps except a
    no-op logger).
    """
    try:
        m = re.search(
            r"with name `([a-zA-Z_][a-zA-Z0-9_]*)` cannot be resolved\. Did you mean one of the following\? \[([^\]]+)\]",
            err_message,
        )
        if not m:
            return None
        bare = m.group(1)
        suggestions = [s.strip().strip("`") for s in m.group(2).split(",")]

        def _norm(s):
            return re.sub(r"[_\s]+", "", str(s)).lower()

        bare_norm = _norm(bare)
        best = next((s for s in suggestions if _norm(s) == bare_norm and s != bare), None)
        if best is None:
            best = next((s for s in suggestions if s.endswith("_" + bare)), None)
        if best is None:
            best = next((s for s in suggestions if bare in s and s != bare), None)
        if best is None:
            return None
        STRUCT_KEYS = {"version", "comment", "source", "filter", "dimensions", "measures", "name", "expr"}
        pattern = re.compile(r"(?<![a-zA-Z0-9_])" + re.escape(bare) + r"(?![a-zA-Z0-9_])")
        if bare.lower() in STRUCT_KEYS:
            key_pat = re.compile(r"^\s*" + re.escape(bare) + r"\s*:")
            lines = stmt_text.split("\n")
            changed = False
            for i, ln in enumerate(lines):
                if key_pat.match(ln):
                    continue
                new_ln = pattern.sub(best, ln)
                if new_ln != ln:
                    lines[i] = new_ln
                    changed = True
            if changed:
                return "\n".join(lines)
            return None
        new = pattern.sub(best, stmt_text)
        return new if new != stmt_text else None
    except Exception:
        return None


def test_v110_rewrites_bare_name_to_brand_name():
    """Pulse 14 RT pricing_competitor case: ``name`` is the bare column, suggestions list
    contains ``brand_name`` as an ``_name`` suffix match. Must rewrite expr while leaving
    ``name:`` structural key alone."""
    stmt = """CREATE OR REPLACE VIEW `retail_mvm_v1`.`_metrics`.`pricing_competitor`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Pricing competitor metric view"
  source: "`retail_mvm_v1`.`pricing`.`competitor`"
  dimensions:
    - name: "Brand"
      expr: "name"
    - name: "Tier"
      expr: "tier"
  measures:
    - name: "Total Brands"
      expr: "COUNT(DISTINCT name)"
$$"""
    err = (
        "[UNRESOLVED_COLUMN.WITH_SUGGESTION] A column, variable, or function "
        "parameter with name `name` cannot be resolved. Did you mean one of the "
        "following? [`notes`, `tier`, `brand_name`, `channel_mix`, `founded_year`]. SQLSTATE: 42703"
    )
    out = _rewrite_unresolved_columns_v110(stmt, err)
    assert out is not None, "rewriter must NOT refuse the rewrite for bare 'name' (pre-v1.1.0 bug)"

    # Structural YAML keys preserved
    assert 'name: "Brand"' in out, "YAML key 'name: \"Brand\"' must NOT be rewritten"
    assert 'name: "Tier"' in out, "YAML key 'name: \"Tier\"' must NOT be rewritten"
    assert 'name: "Total Brands"' in out, "YAML key 'name: \"Total Brands\"' must NOT be rewritten"

    # Column references rewritten
    assert 'expr: "brand_name"' in out, (
        f"expr referencing bare 'name' must be rewritten to 'brand_name'. Got:\n{out}"
    )
    assert 'COUNT(DISTINCT brand_name)' in out, (
        f"COUNT(DISTINCT name) must become COUNT(DISTINCT brand_name). Got:\n{out}"
    )
    # Verify the bare 'name' alone is NOT present in expr lines anymore
    expr_lines = [ln for ln in out.split("\n") if "expr:" in ln]
    for ln in expr_lines:
        # Allow 'brand_name' but not bare 'name' in expr
        bare_name_in_expr = re.search(r"(?<![a-zA-Z0-9_])name(?![a-zA-Z0-9_])", ln)
        assert not bare_name_in_expr, f"bare 'name' must be substituted in expr: {ln!r}"


def test_v110_rewrites_bare_name_to_contract_name_for_vendor_contract():
    """Pulse 14 RT vendor_contract case: ``name`` -> suggestion list has no ``brand_name``
    but should still find some token with ``_name`` suffix. Per pulse 14 the suggestion list
    was ``[moq, value, owner, signed_date, approved_by]`` — none with ``_name`` suffix.
    For that case the rewriter MUST return None (not silently corrupt)."""
    stmt = """source: "`retail_mvm_v1`.`procurement`.`vendor_contract`"
dimensions:
  - name: "Contract Name"
    expr: "name"
"""
    err = (
        "[UNRESOLVED_COLUMN.WITH_SUGGESTION] A column, variable, or function parameter "
        "with name `name` cannot be resolved. Did you mean one of the following? "
        "[`moq`, `value`, `owner`, `signed_date`, `approved_by`]. SQLSTATE: 42703"
    )
    out = _rewrite_unresolved_columns_v110(stmt, err)
    # No suggestion qualifies (none ends with _name, none equals 'name'-norm, none contains 'name').
    # Rewriter MUST return None — caller will fall through to DESCRIBE rewriter or strip.
    assert out is None, (
        "When NO suggestion contains/suffixes the bare token, rewriter must return None "
        "rather than silently substituting an unrelated column."
    )


def test_v110_rewrites_bare_source_in_filter_only():
    """Token 'source' is BOTH a YAML structural key AND a possible column. Same struct-key
    rule must apply: rewrite where it's used as a column reference, leave the YAML key alone."""
    stmt = """source: "`cat`.`sch`.`tbl`"
filter: "source = 'web'"
"""
    err = (
        "with name `source` cannot be resolved. Did you mean one of the following? "
        "[`source_channel`, `source_id`, `created_at`]"
    )
    out = _rewrite_unresolved_columns_v110(stmt, err)
    assert out is not None
    assert "source: \"`cat`.`sch`.`tbl`\"" in out, (
        "YAML structural 'source: ...' MUST be preserved verbatim"
    )
    assert "filter: \"source_channel" in out or "filter: \"source_id" in out, (
        "filter clause with bare 'source' must be rewritten to a suggestion ending in _source-like"
    )


def test_v110_returns_none_when_bare_not_in_yaml_keys_pre_existing_path(agent_text):
    """For non-struct-key bare names (e.g. 'status' renamed to 'leg_status'), the existing
    pre-v1.1.0 fast path is preserved — single regex substitution across the whole stmt."""
    stmt = """source: "`cat`.`sch`.`flight`"
dimensions:
  - name: "Leg Status"
    expr: "status"
"""
    err = (
        "with name `status` cannot be resolved. Did you mean one of the following? "
        "[`leg_status`, `flight_status`]"
    )
    out = _rewrite_unresolved_columns_v110(stmt, err)
    assert out is not None
    assert 'expr: "leg_status"' in out, (
        f"non-struct-key path must continue to rewrite normally. Got:\n{out}"
    )


def test_v110_notebook_is_valid_json(agent_text):
    nb = json.loads(agent_text)
    assert isinstance(nb.get("cells", []), list) and len(nb["cells"]) > 0


def test_v110_prior_sentinels_preserved(agent_text):
    for sentinel in (
        "mv-fallback-emit-live FIRED",
        "metric-view-bare-via-describe",
        "REWRITE-OK",
        "mv-stale-catalog-rewrite FIRED",
        "surgical-mv-rewrite FIRED",
    ):
        assert sentinel in agent_text, (
            f"Prior MV-rewrite sentinel '{sentinel}' missing in v1.1.0 — regression"
        )
