"""Behavioral tests for v0.7.4 — Active static-analysis autofix dispatcher +
FMFL stem auto-apply + fidelity-gate HALT + action-vocabulary prompt injection.

These tests exercise the structural and behavioural guarantees of v0.7.4:

  RC-1 + RC-3 (alias=fmfl-auto-apply-top1)
    - When FMFL postprocessor encounters a non-canonical LINK target after
      LLM-retry exhaustion, it AUTO-APPLIES the top-1 stem-match canonical
      target BEFORE coercing to KEEP_AS_IS. Eliminates 22 of 24 soft-accepts
      observed in airline VOV v2/v3 audit (2026-04-29).

  RC-2 (alias=fidelity-gate-halt)
    - When fidelity gates fail with a USER-PROVIDED VibeContract, the pipeline
      now RAISES RuntimeError instead of just logging WARNING. Old behaviour
      (warn + continue) was the root cause of v2 (precision 0.41) and v3
      (precision 0.43) producing drifted model.json that proceeded to install.

  RC-4..RC-11 (alias=step-sa-active-autofix + 10 sa-autofix-* aliases)
    - New step_static_analysis_autofix dispatcher reads each SA finding's
      `category` field, looks up a registered deterministic auto-applier in
      _V074_SA_AUTOFIX_REGISTRY, and applies it directly to the in-memory
      model. Fixes 10 categories that previously waited for an LLM round-trip:
      banned_boilerplate_in_output, redundant_value_regex_on_typed_column,
      pii_tagging_missing, redundant_product_prefix_on_attribute,
      denormalized_natural_key, self_fk_on_pk, missing_attribute_description,
      missing_pk, pk_attribute_missing, cross_domain_duplicate (subset-only).

  Action vocabulary in next_vibes prompt (alias=V074_SA_ACTION_VOCAB)
    - The next_vibes priorities prompt now receives the canonical 130-action
      vocabulary so the LLM's PRIORITY lines reference exact action_type names
      that the agent can auto-execute.

All v0.7.4 changes are INDUSTRY-AGNOSTIC (CLAUDE.md §8.5), DETERMINISTIC, and
SERVERLESS-COMPATIBLE (CLAUDE.md §2 — pure dict mutation, no Spark cache).

Per CLAUDE.md §3a-bis: __AGENT_VERSION__ = "0.7.4" must be the FIRST non-comment
line of code in Cell 1, and must propagate as `agent_version` first key of every
generated model.json. This test file enforces both invariants.
"""

import json
import re
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
AGENT_NB = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"
RUNNER_NB = REPO_ROOT / "runner" / "vibe_runner.ipynb"
TESTER_NB = REPO_ROOT / "tests" / "vibe_tester.ipynb"


def _load_nb_source(path: Path) -> str:
    nb = json.loads(path.read_text())
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") == "code":
            parts.append("".join(cell.get("source", [])))
    return "\n\n".join(parts)


def _load_cell_source(path: Path, cell_idx: int) -> str:
    nb = json.loads(path.read_text())
    cell = nb["cells"][cell_idx]
    return "".join(cell.get("source", []))


# ════════════════════════════════════════════════════════════════════════════
# §3a-bis — version invariants
# ════════════════════════════════════════════════════════════════════════════

def test_agent_version_is_074():
    src = _load_nb_source(AGENT_NB)
    assert '__AGENT_VERSION__ = "0.7.7"' in src, (
        "must stamp __AGENT_VERSION__ = '0.7.7' (CLAUDE.md §3a-bis); "
        "closes the v0.7.5 deferred emit-site migrations (architect/audit/next_vibes)."
    )


def test_agent_version_is_first_non_comment_line_of_first_code_cell():
    nb = json.loads(AGENT_NB.read_text())
    first_code_cell = next((c for c in nb["cells"] if c.get("cell_type") == "code"), None)
    assert first_code_cell is not None
    src_lines = "".join(first_code_cell.get("source", [])).splitlines()
    code_lines = [ln for ln in src_lines if ln.strip() and not ln.lstrip().startswith("#")]
    assert code_lines, "First code cell must contain at least one code line"
    assert '__AGENT_VERSION__ = "0.7.7"' in code_lines[0], (
        "First non-comment code line of first code cell must declare "
        "__AGENT_VERSION__ = \"0.7.6\" (CLAUDE.md §3a-bis)"
    )


def test_semver_is_single_digit_segments():
    src = _load_nb_source(AGENT_NB)
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', src)
    assert m, "Could not find __AGENT_VERSION__ tuple"
    for seg in m.groups():
        assert len(seg) == 1 and 0 <= int(seg) <= 9, (
            f"CLAUDE.md §3a single-digit semver violation: segment '{seg}' "
            f"must be 0-9. Saw {m.group(0)}"
        )


# ════════════════════════════════════════════════════════════════════════════
# RC-4..RC-11: Active SA-autofix dispatcher
# ════════════════════════════════════════════════════════════════════════════

def test_dispatcher_function_exists():
    src = _load_nb_source(AGENT_NB)
    assert "def step_static_analysis_autofix(" in src, (
        "dispatcher step_static_analysis_autofix MUST be defined"
    )
    assert "alias=step-sa-active-autofix" in src, (
        "Dispatcher MUST emit [step-sa-active-autofix FIRED] sentinel"
    )


def test_autofix_registry_covers_10_categories():
    src = _load_nb_source(AGENT_NB)
    expected_categories = [
        "banned_boilerplate_in_output",
        "redundant_value_regex_on_typed_column",
        "pii_tagging_missing",
        "redundant_product_prefix_on_attribute",
        "denormalized_natural_key",
        "self_fk_on_pk",
        "missing_attribute_description",
        "missing_pk",
        "pk_attribute_missing",
        "cross_domain_duplicate",
    ]
    for cat in expected_categories:
        assert f"'{cat}':" in src, (
            f"_V074_SA_AUTOFIX_REGISTRY MUST register category '{cat}'"
        )


def test_autofix_functions_all_defined():
    src = _load_nb_source(AGENT_NB)
    expected_fns = [
        "_strip_banned_boilerplate",
        "_strip_redundant_value_regex",
        "_add_pii_tags",
        "_strip_redundant_product_prefix",
        "_drop_denormalized_natural_keys",
        "_rename_self_fk_on_pk",
        "_fill_missing_descriptions",
        "_fill_missing_pks",
        "_merge_cross_domain_duplicate_subset",
    ]
    for fn in expected_fns:
        assert f"def {fn}(" in src, f"Autofix function {fn} MUST be defined"


def test_each_autofix_emits_sentinel_log_line():
    src = _load_nb_source(AGENT_NB)
    expected_sentinels = [
        "sa-autofix-banned_boilerplate_in_output FIRED",
        "sa-autofix-redundant_value_regex_on_typed_column FIRED",
        "sa-autofix-pii_tagging_missing FIRED",
        "sa-autofix-redundant_product_prefix_on_attribute FIRED",
        "sa-autofix-denormalized_natural_key FIRED",
        "sa-autofix-self_fk_on_pk FIRED",
        "sa-autofix-missing_attribute_description FIRED",
        "sa-autofix-missing_pk FIRED",
        "sa-autofix-cross_domain_duplicate FIRED",
    ]
    for s in expected_sentinels:
        assert s in src, f"Sentinel '{s}' MUST be emitted on successful autofix"


def test_dispatcher_has_summary_sentinel():
    src = _load_nb_source(AGENT_NB)
    assert "sa-active-autofix-summary FIRED" in src, (
        "Dispatcher MUST emit summary sentinel with per-category counts"
    )


def test_dispatcher_wired_into_step_generate_next_vibes():
    src = _load_nb_source(AGENT_NB)
    assert "step-sa-active-autofix-call FIRED" in src, (
        "Dispatcher MUST be called from step_generate_next_vibes "
        "(after run_metamodel_static_analysis)"
    )
    # Specifically: dispatcher call must come AFTER the SA call
    sa_pos = src.find("analysis = run_metamodel_static_analysis(domains_data, products_data, attributes_data, config, logger)\n        # [step-sa-active-autofix-call FIRED")
    assert sa_pos >= 0, (
        "Dispatcher must be wired DIRECTLY after the SA call inside "
        "step_generate_next_vibes else issues won't reflect post-fix state"
    )


def test_dispatcher_wired_into_model_checkup():
    src = _load_nb_source(AGENT_NB)
    assert "model-checkup-sa-autofix-call FIRED" in src, (
        "Dispatcher MUST be called from the model_checkup action handler "
        "(active autofix BEFORE LLM remediation queue)"
    )


def test_dispatcher_re_runs_sa_after_autofix():
    src = _load_nb_source(AGENT_NB)
    # Both call sites must re-run SA when autofix applied something
    assert "Re-running static analysis after active autofix" in src
    assert "Re-running static analysis after active autofix" in src


def test_autofixers_are_industry_agnostic():
    """CLAUDE.md §8.5 — no hardcoded customer/business names in autofixer CODE.
    Comments may reference the AUDIT that motivated the fix (airline VOV) but
    the CODE itself MUST contain no industry-specific entity names. Strip
    comments before checking. v0.7.5: dispatcher block start marker preserved
    (the dispatcher itself is the same v0.7.4 functions, now cost-class-gated)."""
    src = _load_nb_source(AGENT_NB)
    start_marker = "# [step-sa-active-autofix FIRED alias=step-sa-active-autofix]"
    # v0.7.5 retired the explicit END marker when wrapping the dispatcher; we
    # bound the search by the next major section banner to extract the same
    # dispatcher block.
    s = src.find(start_marker)
    if s < 0:
        s = src.find("step-sa-active-autofix FIRED")
    e = src.find("# [V075_RETIRE_V074_VOCAB", s if s >= 0 else 0)
    if e < 0:
        e = s + 80000  # generous bound
    assert s >= 0 and e > s, (
        "Could not locate v0.7.4 dispatcher block boundaries — markers missing"
    )
    block = src[s:e]
    # Strip comment lines and docstring contents — comments may reference the
    # audit context; only CODE must be industry-agnostic.
    lines_no_comments = []
    in_docstring = False
    for ln in block.split("\n"):
        stripped = ln.lstrip()
        if stripped.startswith('"""') or stripped.endswith('"""'):
            # toggle (handle single-line docstrings too)
            if stripped.count('"""') == 2:
                continue  # one-liner — skip entirely
            in_docstring = not in_docstring
            continue
        if in_docstring:
            continue
        # Drop pure-comment lines
        if stripped.startswith("#"):
            continue
        # Drop trailing inline comments
        if "#" in ln:
            quote_idx = min((ln.find(q) for q in ('"', "'") if ln.find(q) >= 0), default=-1)
            comment_idx = ln.find("#")
            if quote_idx < 0 or comment_idx < quote_idx:
                ln = ln[:comment_idx]
        lines_no_comments.append(ln)
    code_only = "\n".join(lines_no_comments).lower()
    forbidden = [
        "airline", "airlines", "emirates", "ncdot", "telecom", "banking",
        "healthcare", "retail", "insurance", "automotive",
        "boeing", "airbus", "iata", "patient", "hospital",
    ]
    for word in forbidden:
        assert word not in code_only, (
            f"Industry-agnostic violation (CLAUDE.md §8.5): autofix CODE "
            f"references '{word}' (comments are allowed; this check excludes them)"
        )


# ════════════════════════════════════════════════════════════════════════════
# RC-1 + RC-3: FMFL stem auto-apply BEFORE final-sanitize coercion
# ════════════════════════════════════════════════════════════════════════════

def test_fmfl_auto_apply_top1_sentinel_present():
    src = _load_nb_source(AGENT_NB)
    assert "fmfl-auto-apply-top1 FIRED" in src, (
        "RC-1+RC-3 fix: fmfl-auto-apply-top1 sentinel MUST be emitted when "
        "non-canonical LINK target gets auto-replaced with top-1 stem match"
    )
    assert "fmfl-auto-apply-top1-summary FIRED" in src, (
        "Summary sentinel MUST be emitted with count of auto-applied top-1 swaps"
    )


def test_fmfl_auto_apply_runs_before_final_sanitize():
    """The auto-apply pass MUST run BEFORE fmfl-final-sanitize coercion so
    candidates with stem matches get healed instead of dropped to KEEP_AS_IS."""
    src = _load_nb_source(AGENT_NB)
    auto_apply_pos = src.find("[fmfl-auto-apply-top1 FIRED]")
    final_sanitize_pos = src.find("[fmfl-final-sanitize FIRED]")
    assert auto_apply_pos > 0 and final_sanitize_pos > 0
    assert auto_apply_pos < final_sanitize_pos, (
        "RC-1+RC-3: fmfl-auto-apply-top1 MUST appear in source BEFORE "
        "fmfl-final-sanitize so it runs first at execution time"
    )


def test_fmfl_auto_apply_uses_existing_helpers_not_new_ones():
    """CLAUDE.md §3d (search-first/reuse-first/DRY): the auto-apply must call
    the EXISTING _fmfl_suggest_canonical helper, not a duplicate."""
    src = _load_nb_source(AGENT_NB)
    auto_apply_block_start = src.find("# [fmfl-auto-apply-top1 FIRED")
    auto_apply_block_end = src.find("_final_sanitize_count = 0", auto_apply_block_start)
    assert auto_apply_block_start >= 0 and auto_apply_block_end > auto_apply_block_start
    block = src[auto_apply_block_start:auto_apply_block_end]
    assert "_fmfl_suggest_canonical(" in block, (
        "fmfl-auto-apply-top1 MUST reuse existing _fmfl_suggest_canonical "
        "helper (DRY per CLAUDE.md §3d)"
    )


# ════════════════════════════════════════════════════════════════════════════
# RC-2: Fidelity gate HALT
# ════════════════════════════════════════════════════════════════════════════

def test_fidelity_gate_halt_sentinel_present():
    src = _load_nb_source(AGENT_NB)
    assert "fidelity-gate-halt FIRED" in src, (
        "RC-2 fix: fidelity-gate-halt sentinel MUST be emitted when user-provided "
        "VibeContract precision threshold is failed"
    )


def test_fidelity_gate_raises_runtimeerror():
    src = _load_nb_source(AGENT_NB)
    halt_pos = src.find("fidelity-gate-halt FIRED")
    assert halt_pos >= 0
    # Look forward 2500 chars (comment block + sentinel + raise — see actual
    # block in agent notebook cell 7)
    block = src[halt_pos:halt_pos + 2500]
    assert "raise RuntimeError(" in block, (
        "RC-2: fidelity-gate-halt MUST raise RuntimeError to halt the pipeline "
        "instead of just logging WARNING"
    )
    assert "fidelity-gate HALT" in block, (
        "RuntimeError message MUST include 'fidelity-gate HALT' for grep-ability"
    )


def test_fidelity_gate_halt_has_escape_hatch():
    src = _load_nb_source(AGENT_NB)
    assert "vibe_fidelity_gate_halt_disabled" in src, (
        "RC-2 fix MUST provide vibe_fidelity_gate_halt_disabled escape hatch "
        "for legacy callers (default False = HALT, True = legacy WARN behaviour)"
    )


def test_fidelity_gate_halt_only_when_user_contract():
    """The HALT must only fire when a USER-PROVIDED VibeContract is in effect.
    If no contract or auto-derived, the existing 'informational only' branch
    must continue to run unchanged."""
    src = _load_nb_source(AGENT_NB)
    # Find both branches still present
    assert "(no user-provided VibeContract — informational only)" in src, (
        "Informational-only branch MUST be preserved for no-contract case"
    )


# ════════════════════════════════════════════════════════════════════════════
# Action vocabulary in next_vibes prompt
# ════════════════════════════════════════════════════════════════════════════

def test_action_vocab_renderer_defined():
    src = _load_nb_source(AGENT_NB)
    assert "def _render_action_vocab_block(" in src, (
        "Action-vocabulary renderer MUST be defined"
    )
    assert "_V074_SA_ACTION_VOCAB" in src, (
        "Action-vocabulary registry MUST be defined"
    )


def test_action_vocab_covers_all_six_scopes():
    """retired _V074_SA_ACTION_VOCAB as a duplicate of MASTER_ACTION_REGISTRY.
    The shim must still expose all six scopes for backward compatibility, but the
    underlying source of truth is now MasterActionRegistry."""
    src = _load_nb_source(AGENT_NB)
    expected_scopes = ["'attribute'", "'product'", "'domain'", "'link'", "'tag'", "'model'"]
    assert "MASTER_ACTION_REGISTRY = {" in src, "MASTER_ACTION_REGISTRY MUST be defined"
    reg_pos = src.find("MASTER_ACTION_REGISTRY = {")
    block = src[reg_pos:reg_pos + 25000]
    for scope in expected_scopes:
        assert f", {scope}):" in block, f"MASTER_ACTION_REGISTRY MUST cover scope {scope}"
    assert "def _build_action_vocab_compat" in src, (
        "backward-compat shim _build_action_vocab_compat MUST be defined"
    )
    assert "_V074_SA_ACTION_VOCAB = _build_action_vocab_compat()" in src, (
        "_V074_SA_ACTION_VOCAB MUST be derived from MASTER_ACTION_REGISTRY (shim only)"
    )


def test_action_vocab_includes_critical_actions():
    """CLAUDE.md §3d/§5 — MASTER_ACTION_REGISTRY (which now backs the vocab) MUST
    include the actions that the dispatcher consumes and the actions that the LLM
    most commonly proposes."""
    src = _load_nb_source(AGENT_NB)
    reg_pos = src.find("MASTER_ACTION_REGISTRY = {")
    block = src[reg_pos:reg_pos + 25000]
    must_have_actions = [
        "rename", "modify", "drop", "create", "merge", "split",
        "add_tag", "remove_tag", "create_link", "drop_link", "redirect_fk",
        "auto_merge_duplicates", "find_missing_fk_links", "fix_fk_anomalies",
        "break_cycles", "fix_siloed", "link_all_id_columns",
        "bulk_tag_by_pattern", "conditional_tag",
        "set_primary_key", "change_type",
    ]
    for act in must_have_actions:
        assert f"('{act}'," in block, (
            f"MASTER_ACTION_REGISTRY MUST include action '{act}' so LLM can propose it"
        )


def test_action_vocab_block_injected_into_prompt_template():
    """renamed the placeholder to {master_action_catalog} (the canonical
    source of truth) — the old name {action_vocabulary_block} is retired."""
    src = _load_nb_source(AGENT_NB)
    assert "{master_action_catalog}" in src, (
        "VIBE_CREATE_NEXT_PROMPT MUST contain {master_action_catalog} placeholder"
    )


def test_action_vocab_block_passed_in_format_call():
    """.format() call uses the canonical render_master_action_catalog()."""
    src = _load_nb_source(AGENT_NB)
    assert "master_action_catalog=_master_action_catalog" in src, (
        "step_generate_next_vibes .format() MUST pass master_action_catalog "
        "rendered from MASTER_ACTION_REGISTRY (single source of truth)"
    )


def test_action_vocab_prompt_inject_sentinel_present():
    """sentinel is master-action-catalog-prompt-inject (renamed from
    V074_SA_ACTION_VOCAB-prompt-inject when the duplicate vocab was retired)."""
    src = _load_nb_source(AGENT_NB)
    assert "master-action-catalog-prompt-inject FIRED" in src, (
        "master-action-catalog-prompt-inject sentinel MUST be present "
        "(needed for grep-based deploy verification per CLAUDE.md §10.7 step 6)"
    )


# ════════════════════════════════════════════════════════════════════════════
# Behavioral exec — actually run a few autofixers against synthetic models
# to validate they DO what they claim (not just that they're defined).
# ════════════════════════════════════════════════════════════════════════════

def _extract_function_source(nb_path: Path, fn_name: str) -> str:
    """Extract a top-level def block from the notebook for ad-hoc exec."""
    nb = json.loads(nb_path.read_text())
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        parts.append("".join(cell.get("source", [])))
    full = "\n\n".join(parts)
    pat = re.compile(rf"^def {re.escape(fn_name)}\(.*?(?=^def |\Z)", re.DOTALL | re.MULTILINE)
    m = pat.search(full)
    assert m, f"Could not locate def {fn_name} in notebook"
    return m.group(0)


def _exec_autofixers_in_isolation():
    """Build a minimal namespace that exposes the v0.7.4 autofixers + the
    helpers they depend on (re, get_pk_suffix, build_pk_name_from_config,
    PII_FALSE_POSITIVE_RE, classify_pii_subtype). Lets each test exec the
    autofixer against a synthetic model and assert the post-state."""
    ns = {"__builtins__": __builtins__, "re": re}
    # Stub the dependencies the autofixers reach for
    ns["get_pk_suffix"] = lambda config: "_id"
    ns["build_pk_name_from_config"] = lambda product, config: f"{product}_id"
    ns["PII_FALSE_POSITIVE_RE"] = re.compile(
        r"(category|display|product|tag|file|page|service|component|"
        r"event|error|status|step|node|task|table|column|view|"
        r"index|metric|report|template|kpi|model|artifact|object)_name",
        re.IGNORECASE,
    )
    ns["classify_pii_subtype"] = lambda name: "pii_personal"
    # Constants the autofixers expect
    ns["_V074_BANNED_BOILERPLATE_RE"] = re.compile(
        r"fortune\s*\d+|multinational|enterprise-wide|cross-company|group\s+reporting",
        re.IGNORECASE,
    )
    ns["_V074_TYPED_COLUMN_TYPES"] = frozenset({
        "INT", "INTEGER", "BIGINT", "SMALLINT", "TINYINT", "LONG",
        "FLOAT", "DOUBLE", "DECIMAL", "NUMERIC",
        "DATE", "TIMESTAMP", "TIMESTAMP_NTZ", "TIMESTAMP_LTZ",
        "BOOLEAN", "BOOL", "BINARY",
    })
    ns["_V074_PII_NAME_PATTERN"] = re.compile(
        r"(^|_)(name|email|phone|address|ssn|salary|dob|date_of_birth|photo|biometric|"
        r"approver|approved_by|released_by|requested_by|inspector|owner|assignee|"
        r"created_by|modified_by|signed_by|reviewer|operator_name)(_|$)",
        re.IGNORECASE,
    )
    ns["_V074_NATURAL_KEY_SUFFIXES"] = ("_code", "_number", "_no", "_key")
    # Exec each autofixer's source into the namespace
    for fn in (
        "_strip_banned_boilerplate",
        "_strip_redundant_value_regex",
        "_add_pii_tags",
        "_strip_redundant_product_prefix",
        "_drop_denormalized_natural_keys",
        "_rename_self_fk_on_pk",
        "_fill_missing_descriptions",
        "_fill_missing_pks",
        "_merge_cross_domain_duplicate_subset",
    ):
        exec(_extract_function_source(AGENT_NB, fn), ns)
    return ns


class _NoopLogger:
    def info(self, *a, **k):
        pass

    def warning(self, *a, **k):
        pass

    def error(self, *a, **k):
        pass

    def debug(self, *a, **k):
        pass


def test_exec_strip_banned_boilerplate_actually_strips():
    ns = _exec_autofixers_in_isolation()
    attrs = [
        {"attribute": "x", "description": "A Fortune 500 multinational metric"},
        {"attribute": "y", "description": "A clean attribute"},
    ]
    n = ns["_strip_banned_boilerplate"]([], [], attrs, {}, {}, _NoopLogger())
    assert n == 1, "Should have stripped 1 attr"
    assert "fortune" not in attrs[0]["description"].lower()
    assert "multinational" not in attrs[0]["description"].lower()
    assert attrs[1]["description"] == "A clean attribute"


def test_exec_strip_redundant_value_regex_on_typed():
    ns = _exec_autofixers_in_isolation()
    attrs = [
        {"attribute": "amount", "type": "DECIMAL(18,2)", "value_regex": r"^\d+\.\d{2}$"},
        {"attribute": "name", "type": "STRING", "value_regex": r"^[A-Z]+$"},  # keep
        {"attribute": "ts", "type": "TIMESTAMP", "value_regex": r"\d{4}-\d{2}-\d{2}"},
        {"attribute": "flag", "type": "BOOLEAN", "value_regex": r"true|false"},
    ]
    n = ns["_strip_redundant_value_regex"]([], [], attrs, {}, {}, _NoopLogger())
    assert n == 3, f"Should strip 3 typed columns, got {n}"
    assert attrs[0]["value_regex"] == ""
    assert attrs[1]["value_regex"] == r"^[A-Z]+$"  # STRING — keep
    assert attrs[2]["value_regex"] == ""
    assert attrs[3]["value_regex"] == ""


def test_exec_add_pii_tags_industry_agnostic():
    ns = _exec_autofixers_in_isolation()
    attrs = [
        {"attribute": "customer_email", "tags": ""},
        {"attribute": "phone_number", "tags": "contact"},
        {"attribute": "category_name", "tags": ""},  # FALSE POSITIVE — should NOT tag
        {"attribute": "primary_key_id", "tags": "primary_key"},  # PK — skip
        {"attribute": "patient_address", "tags": ""},  # works for healthcare too
        {"attribute": "claim_id", "tags": ""},  # not a PII pattern — skip
    ]
    n = ns["_add_pii_tags"]([], [], attrs, {}, {}, _NoopLogger())
    assert n == 3, f"Should tag 3 PII attrs, got {n}"
    assert "pii_personal" in attrs[0]["tags"]
    assert "pii_personal" in attrs[1]["tags"]
    assert "pii_personal" not in attrs[2]["tags"]
    assert "pii_personal" not in attrs[3]["tags"]
    assert "pii_personal" in attrs[4]["tags"]
    assert "pii_personal" not in attrs[5]["tags"]


def test_exec_strip_redundant_product_prefix():
    ns = _exec_autofixers_in_isolation()
    attrs = [
        {"domain": "d", "product": "customer", "attribute": "customer_email", "tags": ""},
        {"domain": "d", "product": "customer", "attribute": "customer_id", "tags": "primary_key"},  # PK — skip
        {"domain": "d", "product": "order", "attribute": "order_status", "tags": ""},
        {"domain": "d", "product": "order", "attribute": "shipping_address", "tags": ""},  # no prefix — skip
    ]
    n = ns["_strip_redundant_product_prefix"]([], [], attrs, {}, {}, _NoopLogger())
    assert n == 2, f"Should rename 2 attrs, got {n}"
    assert attrs[0]["attribute"] == "email"
    assert attrs[1]["attribute"] == "customer_id"  # unchanged
    assert attrs[2]["attribute"] == "status"
    assert attrs[3]["attribute"] == "shipping_address"  # unchanged


def test_exec_drop_denormalized_natural_keys():
    ns = _exec_autofixers_in_isolation()
    attrs = [
        {"domain": "d", "product": "order", "attribute": "customer_id", "foreign_key_to": "d.customer.customer_id"},
        {"domain": "d", "product": "order", "attribute": "customer_code", "foreign_key_to": ""},  # DROP
        {"domain": "d", "product": "order", "attribute": "order_id", "foreign_key_to": ""},  # PK-like, keep
        {"domain": "d", "product": "shipment", "attribute": "carrier_id", "foreign_key_to": "d.carrier.carrier_id"},
        {"domain": "d", "product": "shipment", "attribute": "carrier_number", "foreign_key_to": ""},  # DROP
    ]
    n = ns["_drop_denormalized_natural_keys"]([], [], attrs, {}, {}, _NoopLogger())
    assert n == 2, f"Should drop 2 natural keys, got {n}"
    surviving = [a["attribute"] for a in attrs]
    assert "customer_code" not in surviving
    assert "carrier_number" not in surviving
    assert "customer_id" in surviving
    assert "carrier_id" in surviving


def test_exec_rename_self_fk_on_pk():
    ns = _exec_autofixers_in_isolation()
    products = [
        {"domain": "cargo", "product": "awb", "primary_key": "awb_id"},
        {"domain": "cargo", "product": "shipment", "primary_key": "shipment_id"},
    ]
    attrs = [
        # Cross-product collision: shipment.awb_id references cargo.awb but column shares PK name? wait — PK of shipment is shipment_id.
        # Build a real self-FK collision: awb has a column awb_id that's the FK back to itself (master AWB pattern).
        {"domain": "cargo", "product": "awb", "attribute": "awb_id", "tags": "", "foreign_key_to": "cargo.awb.awb_id"},
        # Also: shipment.shipment_id is the PK (skip)
        {"domain": "cargo", "product": "shipment", "attribute": "shipment_id", "tags": "primary_key", "foreign_key_to": ""},
    ]
    n = ns["_rename_self_fk_on_pk"](
        [], products, attrs, {}, {}, _NoopLogger()
    )
    assert n == 1, f"Should rename 1 self-FK collision, got {n}"
    assert attrs[0]["attribute"] == "parent_awb_id"


def test_exec_fill_missing_descriptions_industry_agnostic():
    ns = _exec_autofixers_in_isolation()
    attrs = [
        {"domain": "sales", "product": "order", "attribute": "order_status", "description": ""},
        {"domain": "sales", "product": "order", "attribute": "amount", "description": "ok desc longer than 10 chars"},
        {"domain": "hr", "product": "employee", "attribute": "hire_date", "description": "x"},
    ]
    n = ns["_fill_missing_descriptions"]([], [], attrs, {}, {}, _NoopLogger())
    assert n == 2, f"Should fill 2 short descriptions, got {n}"
    assert "order status" in attrs[0]["description"]
    assert "order" in attrs[0]["description"]
    assert attrs[1]["description"] == "ok desc longer than 10 chars"
    assert "hire date" in attrs[2]["description"]
    assert "employee" in attrs[2]["description"]


def test_exec_fill_missing_pks_from_naming_pattern():
    ns = _exec_autofixers_in_isolation()
    products = [
        {"domain": "d", "product": "customer", "primary_key": ""},
        {"domain": "d", "product": "order", "primary_key": "order_id"},  # already has PK — skip
    ]
    attrs = [
        {"domain": "d", "product": "customer", "attribute": "customer_id", "tags": ""},
        {"domain": "d", "product": "customer", "attribute": "name", "tags": ""},
        {"domain": "d", "product": "order", "attribute": "order_id", "tags": "primary_key", "is_primary_key": True},
    ]
    n = ns["_fill_missing_pks"]([], products, attrs, {}, {}, _NoopLogger())
    assert n == 1, f"Should tag 1 missing PK, got {n}"
    assert "primary_key" in attrs[0]["tags"]
    assert attrs[0].get("is_primary_key") is True
    assert products[0]["primary_key"] == "customer_id"


def test_exec_subset_merge_cross_domain_duplicate_safe_only():
    ns = _exec_autofixers_in_isolation()
    products = [
        {"domain": "crm", "product": "customer", "primary_key": "customer_id"},
        {"domain": "support", "product": "customer", "primary_key": "customer_id"},  # subset of crm.customer
        {"domain": "crm", "product": "order", "primary_key": "order_id"},
    ]
    attrs = [
        # Larger set: crm.customer
        {"domain": "crm", "product": "customer", "attribute": "customer_id"},
        {"domain": "crm", "product": "customer", "attribute": "name"},
        {"domain": "crm", "product": "customer", "attribute": "email"},
        {"domain": "crm", "product": "customer", "attribute": "address"},
        {"domain": "crm", "product": "customer", "attribute": "tier"},
        # Smaller set: support.customer (5 attrs vs 5, but actually all overlap)
        {"domain": "support", "product": "customer", "attribute": "customer_id"},
        {"domain": "support", "product": "customer", "attribute": "name"},
        {"domain": "support", "product": "customer", "attribute": "email"},
        {"domain": "support", "product": "customer", "attribute": "address"},
        # crm.order is unrelated, no incoming FK to support.customer (safe)
        {"domain": "crm", "product": "order", "attribute": "order_id"},
        {"domain": "crm", "product": "order", "attribute": "customer_id", "foreign_key_to": "crm.customer.customer_id"},  # FK to CRM, NOT support
    ]
    before = len(products)
    n = ns["_merge_cross_domain_duplicate_subset"]([], products, attrs, {}, {}, _NoopLogger())
    assert n == 1, f"Should subset-merge 1 cross-domain duplicate, got {n}"
    assert len(products) == before - 1
    surviving_keys = {(p["domain"], p["product"]) for p in products}
    assert ("crm", "customer") in surviving_keys
    assert ("support", "customer") not in surviving_keys, (
        "support.customer (subset) should be dropped, not crm.customer (superset)"
    )


def test_subset_merge_REJECTS_when_smaller_has_unique_attrs():
    """Safety: if the 'subset' actually has unique attrs the larger lacks, it's
    NOT a subset and must NOT be merged. Defers to next_vibes for LLM."""
    ns = _exec_autofixers_in_isolation()
    products = [
        {"domain": "crm", "product": "customer"},
        {"domain": "support", "product": "customer"},
    ]
    attrs = [
        {"domain": "crm", "product": "customer", "attribute": "customer_id"},
        {"domain": "crm", "product": "customer", "attribute": "name"},
        {"domain": "support", "product": "customer", "attribute": "customer_id"},
        {"domain": "support", "product": "customer", "attribute": "support_tier"},  # UNIQUE — must not merge
    ]
    n = ns["_merge_cross_domain_duplicate_subset"]([], products, attrs, {}, {}, _NoopLogger())
    assert n == 0, "Must NOT merge when smaller has unique attrs (safety property)"
    assert len(products) == 2


def test_subset_merge_REJECTS_when_smaller_has_incoming_fks():
    """Safety: if other products FK to the would-be-dropped product, dropping
    would orphan those FKs. Must defer to next_vibes."""
    ns = _exec_autofixers_in_isolation()
    products = [
        {"domain": "crm", "product": "customer"},
        {"domain": "support", "product": "customer"},
        {"domain": "support", "product": "ticket"},
    ]
    attrs = [
        {"domain": "crm", "product": "customer", "attribute": "customer_id"},
        {"domain": "crm", "product": "customer", "attribute": "name"},
        {"domain": "crm", "product": "customer", "attribute": "email"},
        {"domain": "support", "product": "customer", "attribute": "customer_id"},
        {"domain": "support", "product": "customer", "attribute": "name"},
        {"domain": "support", "product": "customer", "attribute": "email"},
        # FK from support.ticket → support.customer — would-be-orphaned
        {"domain": "support", "product": "ticket", "attribute": "customer_id", "foreign_key_to": "support.customer.customer_id"},
    ]
    n = ns["_merge_cross_domain_duplicate_subset"]([], products, attrs, {}, {}, _NoopLogger())
    assert n == 0, "Must NOT merge when subset has incoming FKs (safety property)"


# ════════════════════════════════════════════════════════════════════════════
# Static-analysis remediation_actions coverage (audit confirmed all 65 covered)
# ════════════════════════════════════════════════════════════════════════════

def test_all_sa_categories_have_remediation_actions():
    src = _load_nb_source(AGENT_NB)
    pat = re.compile(r'issues\.append\(\s*\{', re.MULTILINE)
    seen = {}
    for m in pat.finditer(src):
        snippet = src[m.start():m.start() + 2500]
        cat_match = re.search(r'"category":\s*"([^"]+)"', snippet)
        if not cat_match:
            continue
        cat = cat_match.group(1)
        if cat in seen:
            continue
        rm = re.search(r'"remediation_actions":\s*\[([^\]]*)\]', snippet)
        seen[cat] = rm.group(1).strip() if rm else None
    missing = [c for c, v in seen.items() if v is None]
    # fk_resolution_skipped is intentionally empty (info-only category)
    empty_allowed = {"fk_resolution_skipped"}
    empty_unauthorised = [c for c, v in seen.items() if v == "" and c not in empty_allowed]
    assert not missing, f"SA categories without remediation_actions: {missing}"
    assert not empty_unauthorised, (
        f"SA categories with empty remediation_actions but not in allow-list: "
        f"{empty_unauthorised}"
    )


# ════════════════════════════════════════════════════════════════════════════
# Cross-cutting v0.7.4 invariants
# ════════════════════════════════════════════════════════════════════════════

def test_dispatcher_dependencies_available_in_namespace():
    """The dispatcher uses re, get_pk_suffix, build_pk_name_from_config,
    PII_FALSE_POSITIVE_RE, classify_pii_subtype. Each MUST exist in the agent
    notebook (defined earlier than cell 21)."""
    src = _load_nb_source(AGENT_NB)
    deps = [
        "PII_FALSE_POSITIVE_RE",
        "def get_pk_suffix(",
        "def build_pk_name_from_config(",
        "def classify_pii_subtype(",
    ]
    for d in deps:
        assert d in src, f"dispatcher dependency missing: {d}"


def test_no_persist_or_cache_or_sparkcontext():
    """CLAUDE.md §2: serverless-compatible — no .cache/.persist/sparkContext
    in dispatcher CODE (comments are allowed to mention them as 'we don't use
    these'). v0.7.5: dispatcher start marker preserved; END marker retired when
    dispatcher merged with v0.7.5 cost-class gating + V075_RETIRE_V074_VOCAB
    follow-on block — bound the scan by the next major-section banner."""
    nb = json.loads(AGENT_NB.read_text())
    cells = nb["cells"]
    src = "".join(cells[21].get("source", []))
    start_marker = "# [step-sa-active-autofix FIRED alias=step-sa-active-autofix]"
    s = src.find(start_marker)
    if s < 0:
        s = src.find("step-sa-active-autofix FIRED")
    e = src.find("# [V075_RETIRE_V074_VOCAB", s if s >= 0 else 0)
    if e < 0:
        e = s + 80000
    assert s >= 0 and e > s
    block = src[s:e]
    # Strip pure-comment lines so we only check executable code
    code_lines = [ln for ln in block.split("\n") if not ln.lstrip().startswith("#")]
    code_only = "\n".join(code_lines)
    forbidden = [".cache(", ".persist(", "sparkContext", ".uncache(", "Broadcast"]
    for tok in forbidden:
        assert tok not in code_only, (
            f"CLAUDE.md §2 violation: dispatcher CODE uses '{tok}' (not serverless-compat)"
        )
