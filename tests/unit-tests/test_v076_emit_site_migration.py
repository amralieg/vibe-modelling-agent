"""Behavioral tests for v0.7.6 emit-site migration (closes v0.7.5 deferred work).

v0.7.6 closes the architectural gap left by v0.7.5: the MasterActionRegistry +
FindingDispatcher infrastructure was foundationally complete but only one stage
(post-attribute-gen static-analysis autofix) was actually wired through it. The
domain architect (Step 3.6), VIBE_AUDIT.remediate (Phase 6), and
VIBE_CREATE_NEXT priority parser were all still emitting plain dicts to ad-hoc
queues, which meant:
  - no §3b/§3c protected-target gating at the dispatcher level for those stages
  - no uniform observability/SUMMARY log line for those stages
  - no canonical FindingShape stream for downstream audit tooling

v0.7.6 adds the following ADDITIVE migration (no behaviour change to existing
queue consumers):
  1. _emit_finding helper — thin adapter; no-op if dispatcher is None
  2. _protected_targets_from_widgets — builds the canonical user-protected
     target set (business_domains + must_have_data_products) for dispatcher
  3. _local_action_executor — minimal LOCAL-only executor that handles
     alter_description (product/attribute), add_tag (attribute), update_regex
     (attribute). All FK-rewire and norm-redo actions return False -> defer.
  4. Domain architect (_apply_single_domain_review_to_model + parent
     step_domain_architect_review) — 9 emit sites now ALSO submit FindingShape
     via stage-scoped FindingDispatcher with protected_targets.
  5. VIBE_AUDIT VibeOrchestrator.remediate — every action submitted to a
     vibe_audit-stage dispatcher with PROVENANCE_USER_VIBE before being passed
     to apply_mutation_command (audit is enforcing user-vibe requirements).
  6. VIBE_CREATE_NEXT consumer (step_generate_next_vibes) — parses
     **PRIORITY N — <action>: <target>** markdown blocks and submits each as
     a FindingShape to a next_vibes_generation-stage dispatcher (no executor;
     observability-only since priorities feed the next iteration's vibe).

Pre-existing v0.7.2 sentinel `SHRINK-NEW-SILO-ALL-ORPHANS` is also
patched into the empty-plan branch so test_fix3_handles_degenerate_empty_plan
no longer reports a long-standing pre-existing fail.

Aliases under test:
  - emit-finding-helper
  - protected-targets
  - safe-executor
  - architect-dispatcher
  - audit-dispatcher
  - next-vibes-dispatcher
  - shrink-orphan-drop-emptied (re-asserted with v0.7.2 SHRINK-NEW-SILO-ALL-ORPHANS sentinel)
  - agent-version-global   (re-asserted at 0.7.6)
  - agent-version-mirror   (re-asserted at 0.7.6)
"""

import json
import re
import textwrap
from pathlib import Path

AGENT_NB = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _agent_text():
    nb = json.loads(AGENT_NB.read_text())
    parts = []
    for cell in nb["cells"]:
        if cell.get("cell_type") == "code":
            parts.append("".join(cell.get("source", [])))
    return "\n\n".join(parts)


def _agent_cell_3_text():
    """Return source of the code cell that contains FindingDispatcher (where the
    MasterActionRegistry + FindingDispatcher + v0.7.6 helpers live). Located by
    content rather than position so cell-reordering doesn't break tests."""
    nb = json.loads(AGENT_NB.read_text())
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        src = "".join(c.get("source", []))
        if "class FindingDispatcher" in src:
            return src
    raise AssertionError("agent notebook must contain a code cell defining FindingDispatcher")


def _exec_namespace():
    """Re-exec the slice of cell 3 that defines ACTION_COST_* / MasterActionRegistry /
    classify_action_cost / FindingDispatcher / v076 helpers in a clean namespace.
    Slice ends at _cascade_domain_rename so we don't pull in the entire cell.
    Pre-binds the same standard-library names the agent runtime would normally
    import in earlier cells."""
    src = _agent_cell_3_text()
    start = src.find("ACTION_COST_LOCAL = 'LOCAL'")
    assert start >= 0, "ACTION_COST_LOCAL constant must be defined in the FindingDispatcher cell"
    end = src.find("def _cascade_domain_rename(")
    assert end > start, "_cascade_domain_rename must follow the v0.7.6 block in the FindingDispatcher cell"
    block = src[start:end]
    import re as _re
    from collections import defaultdict as _defaultdict
    ns = {"__builtins__": __builtins__, "re": _re, "defaultdict": _defaultdict}
    exec(
        textwrap.dedent(
            """
            class _MockLogger:
                def __init__(self):
                    self.warnings = []
                    self.infos = []
                def warning(self, msg):
                    self.warnings.append(str(msg))
                def info(self, msg):
                    self.infos.append(str(msg))
                def error(self, msg):
                    pass
            """
        ),
        ns,
    )
    exec(block, ns)
    return ns


# ── Section 1: __AGENT_VERSION__ pin ─────────────────────────────────────────


def test_agent_version_is_076():
    src = _agent_text()
    assert '__AGENT_VERSION__ = "0.7.9"' in src, (
        "must stamp __AGENT_VERSION__ = '0.7.7' (CLAUDE.md §3a-bis)"
    )


def test_agent_version_first_non_comment_line():
    nb = json.loads(AGENT_NB.read_text())
    first_code_cell = next(c for c in nb["cells"] if c.get("cell_type") == "code")
    src_lines = "".join(first_code_cell.get("source", [])).splitlines()
    code_lines = [ln for ln in src_lines if ln.strip() and not ln.lstrip().startswith("#")]
    assert '__AGENT_VERSION__ = "0.7.9"' in code_lines[0], (
        "First non-comment line must be __AGENT_VERSION__ = \"0.7.6\""
    )


# ── Section 2: helper functions exist + correct behaviour ────────────────────


def test_helpers_defined_in_cell_3():
    src = _agent_cell_3_text()
    for fn in ("_emit_finding", "_protected_targets_from_widgets", "_local_action_executor"):
        assert f"def {fn}(" in src, f"helper {fn} must be defined in Cell 3"


def test_emit_finding_no_op_on_none_dispatcher():
    ns = _exec_namespace()
    out = ns["_emit_finding"](
        None,
        stage="domain_architect_review",
        category="test",
        severity=ns["SEVERITY_SHOULD_FIX"],
        scope="product",
        scope_targets=["d.p"],
        summary="hi",
        action_type="rename",
        action_scope="product",
        args={},
    )
    assert out is None, "_emit_finding must be a no-op when dispatcher is None"


def test_emit_finding_submits_canonical_finding():
    ns = _exec_namespace()
    logger = ns["_MockLogger"]()
    disp = ns["FindingDispatcher"](
        stage_name="domain_architect_review",
        model_state={"domains": []},
        logger=logger,
        executor=ns["_local_action_executor"],
        protected_targets=set(),
    )
    out = ns["_emit_finding"](
        disp,
        stage="domain_architect_review",
        category="domain_architect_rename",
        severity=ns["SEVERITY_SHOULD_FIX"],
        scope="product",
        scope_targets=["customer.account"],
        summary="rename customer.account -> customer.client",
        action_type="rename",
        action_scope="product",
        args={"domain": "customer", "product": "account", "new_name": "client"},
        provenance=ns["PROVENANCE_ARCHITECT"],
    )
    assert isinstance(out, dict)
    assert out["stage"] == "domain_architect_review"
    assert out["provenance"] == ns["PROVENANCE_ARCHITECT"]
    assert out["proposed_action"]["action_type"] == "rename"
    assert out["proposed_action"]["scope"] == "product"
    assert len(disp.pending) == 1


def test_protected_targets_reads_business_domains_widget():
    ns = _exec_namespace()
    widgets = {"business_domains": "customer, order, product"}
    targets = ns["_protected_targets_from_widgets"](widgets, None)
    assert targets == {"customer", "order", "product"}


def test_protected_targets_reads_must_have_products_widget():
    ns = _exec_namespace()
    widgets = {"must_have_data_products": "invoice; ledger"}
    targets = ns["_protected_targets_from_widgets"](widgets, None)
    assert targets == {"invoice", "ledger"}


def test_protected_targets_falls_back_to_config_business_config():
    ns = _exec_namespace()
    config = {"PROMPT_VARIABLES": {"business_config": {"business_domains": "alpha,beta"}}}
    targets = ns["_protected_targets_from_widgets"]({}, config)
    assert targets == {"alpha", "beta"}


def test_protected_targets_handles_list_input():
    ns = _exec_namespace()
    widgets = {"business_domains": ["customer", "order"], "must_have_data_products": ["invoice"]}
    targets = ns["_protected_targets_from_widgets"](widgets, None)
    assert targets == {"customer", "order", "invoice"}


def test_protected_targets_empty_when_no_input():
    ns = _exec_namespace()
    targets = ns["_protected_targets_from_widgets"]({}, {})
    assert targets == set()


# ── Section 3: _local_action_executor unit tests (LOCAL-only subset) ────────────


def _model_state_with_one_attr():
    return {
        "domains": [
            {
                "domain": "customer",
                "products": [
                    {
                        "product": "account",
                        "description": "old desc",
                        "attributes": [
                            {"attribute": "email", "description": "user email", "tags": "pii"},
                            {"attribute": "id", "primary_key": True},
                        ],
                    }
                ],
            }
        ]
    }


def test_local_action_executor_alter_description_product():
    ns = _exec_namespace()
    state = _model_state_with_one_attr()
    finding = ns["make_finding"](
        stage="vibe_audit",
        category="test",
        severity=ns["SEVERITY_SHOULD_FIX"],
        scope="product",
        scope_targets=["customer.account"],
        summary="alter desc",
        action_type="alter_description",
        action_scope="product",
        args={"domain": "customer", "product": "account", "description": "new prose"},
        provenance=ns["PROVENANCE_USER_VIBE"],
    )
    ok = ns["_local_action_executor"](finding, state, ns["_MockLogger"]())
    assert ok is True
    assert state["domains"][0]["products"][0]["description"] == "new prose"


def test_local_action_executor_add_tag_attribute_idempotent():
    ns = _exec_namespace()
    state = _model_state_with_one_attr()
    finding = ns["make_finding"](
        stage="vibe_audit",
        category="test",
        severity=ns["SEVERITY_SHOULD_FIX"],
        scope="attribute",
        scope_targets=["customer.account.email"],
        summary="add_tag",
        action_type="add_tag",
        action_scope="attribute",
        args={"domain": "customer", "product": "account", "attribute": "email", "tag": "sensitive"},
        provenance=ns["PROVENANCE_USER_VIBE"],
    )
    ok1 = ns["_local_action_executor"](finding, state, ns["_MockLogger"]())
    ok2 = ns["_local_action_executor"](finding, state, ns["_MockLogger"]())
    assert ok1 is True and ok2 is True
    tags = state["domains"][0]["products"][0]["attributes"][0]["tags"]
    assert "sensitive" in tags
    assert "pii" in tags
    assert tags.count("sensitive") == 1, "add_tag must be idempotent"


def test_local_action_executor_update_regex_attribute():
    ns = _exec_namespace()
    state = _model_state_with_one_attr()
    finding = ns["make_finding"](
        stage="vibe_audit",
        category="test",
        severity=ns["SEVERITY_SHOULD_FIX"],
        scope="attribute",
        scope_targets=["customer.account.email"],
        summary="update regex",
        action_type="update_regex",
        action_scope="attribute",
        args={"domain": "customer", "product": "account", "attribute": "email", "regex": "^[a-z]+$"},
        provenance=ns["PROVENANCE_USER_VIBE"],
    )
    ok = ns["_local_action_executor"](finding, state, ns["_MockLogger"]())
    assert ok is True
    assert state["domains"][0]["products"][0]["attributes"][0]["value_regex"] == "^[a-z]+$"


def test_local_action_executor_returns_false_for_unsafe_action():
    ns = _exec_namespace()
    state = _model_state_with_one_attr()
    finding = ns["make_finding"](
        stage="vibe_audit",
        category="test",
        severity=ns["SEVERITY_MUST_FIX"],
        scope="product",
        scope_targets=["customer.account"],
        summary="rename product",
        action_type="rename",
        action_scope="product",
        args={"domain": "customer", "product": "account", "new_name": "client"},
        provenance=ns["PROVENANCE_USER_VIBE"],
    )
    ok = ns["_local_action_executor"](finding, state, ns["_MockLogger"]())
    assert ok is False, "rename product (FK_REWIRE cost) MUST be deferred by safe executor"


def test_local_action_executor_returns_false_when_target_missing():
    ns = _exec_namespace()
    state = _model_state_with_one_attr()
    finding = ns["make_finding"](
        stage="vibe_audit",
        category="test",
        severity=ns["SEVERITY_SHOULD_FIX"],
        scope="product",
        scope_targets=["nonexistent.fake"],
        summary="alter desc on missing",
        action_type="alter_description",
        action_scope="product",
        args={"domain": "nonexistent", "product": "fake", "description": "x"},
        provenance=ns["PROVENANCE_USER_VIBE"],
    )
    ok = ns["_local_action_executor"](finding, state, ns["_MockLogger"]())
    assert ok is False


# ── Section 4: domain architect emit-site migration ──────────────────────────


def test_apply_single_domain_review_accepts_dispatcher_arg():
    src = _agent_text()
    sig_pat = re.compile(
        r"def _apply_single_domain_review_to_model\([^)]*_finding_dispatcher=None",
        re.MULTILINE | re.DOTALL,
    )
    assert sig_pat.search(src), (
        "_apply_single_domain_review_to_model MUST accept _finding_dispatcher=None "
        "(default None preserves existing call sites)"
    )


def test_architect_dispatcher_constructed_in_step():
    src = _agent_text()
    assert "architect-dispatcher FIRED" in src, (
        "step_domain_architect_review MUST emit [architect-dispatcher FIRED] "
        "when constructing the per-stage FindingDispatcher"
    )
    assert "stage_name='domain_architect_review'" in src, (
        "Architect dispatcher MUST use stage_name='domain_architect_review'"
    )
    assert "executor=_local_action_executor," in src, (
        "Architect dispatcher MUST register _local_action_executor"
    )


def test_architect_dispatcher_passes_protected_targets():
    src = _agent_text()
    assert "_protected_targets_from_widgets(widgets_values, config)" in src, (
        "architect dispatcher MUST derive protected_targets from §3b/§3c widgets"
    )


def test_architect_dispatcher_calls_process_batch():
    src = _agent_text()
    assert "architect-dispatcher SUMMARY" in src, (
        "architect dispatcher MUST call process_batch() and emit SUMMARY log"
    )


def test_all_9_architect_emit_sites_migrated():
    src = _agent_text()
    expected_categories = [
        "domain_architect_rename",
        "domain_architect_remove",
        "domain_architect_add_deferred",
        "domain_architect_merge",
        "domain_architect_split",
        "domain_architect_next_vibes",
    ]
    for cat in expected_categories:
        assert (
            f"category='{cat}'" in src
        ), f"architect emit site for category={cat} MUST submit a FindingShape via _emit_finding"
    assert "category=f'domain_architect_self_review_priority:" in src, (
        "architect self-review priority emit site MUST submit FindingShape"
    )
    assert "category=f'domain_architect_gate:" in src, (
        "architect gate-failure emit sites MUST submit FindingShape"
    )


# ── Section 5: VIBE_AUDIT remediate migration ────────────────────────────────


def test_audit_dispatcheratcher_constructed_in_remediate():
    src = _agent_text()
    assert "audit-dispatcher FIRED" in src, (
        "VibeOrchestrator.remediate MUST emit [audit-dispatcher FIRED] "
        "when constructing the vibe_audit-stage dispatcher"
    )
    assert "stage_name='vibe_audit'" in src, (
        "Audit dispatcher MUST use stage_name='vibe_audit'"
    )
    assert "audit-dispatcher SUMMARY" in src, (
        "audit dispatcher MUST call process_batch() and emit SUMMARY log"
    )


def test_audit_emit_uses_user_vibe_provenance():
    src = _agent_text()
    assert "provenance=PROVENANCE_USER_VIBE" in src, (
        "VIBE_AUDIT remediate MUST submit findings with PROVENANCE_USER_VIBE "
        "(audit is enforcing user-vibe requirements per §3c)"
    )


def test_audit_emit_resolves_action_type_scope_from_master_registry():
    src = _agent_text()
    assert "(_at, _sc) in MASTER_ACTION_REGISTRY" in src, (
        "audit emit MUST gate on MASTER_ACTION_REGISTRY membership "
        "to avoid submitting findings with unknown action_type+scope tuples"
    )


# ── Section 6: VIBE_CREATE_NEXT priority parser migration ────────────────────


def test_next_vibes_dispatcher_constructed():
    src = _agent_text()
    assert "next-vibes-dispatcher FIRED" in src, (
        "step_generate_next_vibes MUST emit [next-vibes-dispatcher FIRED]"
    )
    assert "stage_name='next_vibes_generation'" in src, (
        "Next-vibes dispatcher MUST use stage_name='next_vibes_generation'"
    )


def test_next_vibes_priority_parser_present():
    src = _agent_text()
    assert "_priority_re" in src, (
        "next-vibes consumer MUST parse PRIORITY blocks via _priority_re"
    )


def test_next_vibes_executor_is_none_observability_only():
    src = _agent_text()
    pat = re.compile(
        r"stage_name='next_vibes_generation',[\s\S]{0,800}?executor=None",
    )
    assert pat.search(src), (
        "next-vibes dispatcher MUST register executor=None (observability-only "
        "since priorities feed the next iteration's vibe, not direct mutation)"
    )


def test_next_vibes_emits_qa_provenance():
    src = _agent_text()
    assert "provenance=PROVENANCE_QA" in src, (
        "next-vibes priorities MUST be submitted with PROVENANCE_QA "
        "(LLM-generated quality recommendations)"
    )


# ── Section 7: pre-existing v0.7.2 sentinel patched ──────────────────────────


def test_shrink_orphan_drop_emptied_sentinel_present():
    src = _agent_text()
    assert "SHRINK-NEW-SILO-ALL-ORPHANS" in src, (
        "patches the long-pending v0.7.2 fix3 sentinel into the empty-plan branch "
        "(test_fix3_handles_degenerate_empty_plan)"
    )
    assert "shrink-orphan-drop-emptied" in src, (
        "alias=shrink-orphan-drop-emptied for grep audit"
    )


# ── Section 8: industry-agnostic + serverless-compat invariants ──────────────


def test_helpers_industry_agnostic():
    """helpers MUST NOT name any specific industry/customer (CLAUDE.md §8.5)."""
    src = _agent_cell_3_text()
    forbidden = ["airline", "emirates", "telco", "banking", "ecommerce", "healthcare", "retail", "manufacturing"]
    for word in forbidden:
        v076_block_start = src.find("def _emit_finding")
        v076_block_end = src.find("def _cascade_domain_rename")
        assert v076_block_start > 0 and v076_block_end > v076_block_start
        block = src[v076_block_start:v076_block_end].lower()
        assert word not in block, (
            f"helper block leaks industry term '{word}' (industry-agnostic invariant)"
        )


def test_helpers_serverless_compatible():
    """helpers MUST NOT use cache/persist/uncache/sparkcontext (CLAUDE.md §2)."""
    src = _agent_cell_3_text()
    v076_block_start = src.find("def _emit_finding")
    v076_block_end = src.find("def _cascade_domain_rename")
    assert v076_block_start > 0 and v076_block_end > v076_block_start
    block = src[v076_block_start:v076_block_end]
    forbidden_tokens = [".cache(", ".persist(", ".uncache(", "SparkContext(", "sc.parallelize("]
    for tok in forbidden_tokens:
        assert tok not in block, (
            f"CLAUDE.md §2 violation: v0.7.6 helper block uses '{tok}' (not serverless-compat)"
        )


# ── Section 9: end-to-end dispatcher integration via mock ────────────────────


def test_architect_dispatcheratcher_protects_user_targets_from_architect():
    """Integration: an architect finding (PROVENANCE_ARCHITECT) targeting a user-protected
    domain MUST be DEFERRED by the dispatcher with reason starting protected_by_user_vibe."""
    ns = _exec_namespace()
    logger = ns["_MockLogger"]()
    state = {"domains": [{"domain": "customer", "products": []}]}
    disp = ns["FindingDispatcher"](
        stage_name="domain_architect_review",
        model_state=state,
        logger=logger,
        executor=ns["_local_action_executor"],
        protected_targets={"customer"},
    )
    ns["_emit_finding"](
        disp,
        stage="domain_architect_review",
        category="domain_architect_remove",
        severity=ns["SEVERITY_MUST_FIX"],
        scope="domain",
        scope_targets=["customer"],
        summary="remove customer domain",
        action_type="drop",
        action_scope="domain",
        args={"domain": "customer"},
        provenance=ns["PROVENANCE_ARCHITECT"],
    )
    summary = disp.process_batch()
    assert summary["protected_violations"] == 1, (
        "Architect finding touching user-protected target MUST register as protected_violation"
    )
    assert summary["applied"] == 0
    assert disp.deferred[0]["_dispatch_reason"].startswith("protected_by_user_vibe")


def test_architect_dispatcheratcher_lets_user_vibe_audit_through_protected():
    """Integration: a user-vibe finding (PROVENANCE_USER_VIBE) IS allowed to touch a user-protected
    target — that's the whole point of §3c (user vibes are supreme authority).
    Test specifically isolates provenance gating from cost gating by using a LOCAL action."""
    ns = _exec_namespace()
    logger = ns["_MockLogger"]()
    state = _model_state_with_one_attr()
    disp = ns["FindingDispatcher"](
        stage_name="vibe_audit",
        model_state=state,
        logger=logger,
        executor=ns["_local_action_executor"],
        protected_targets={"customer"},
    )
    ns["_emit_finding"](
        disp,
        stage="vibe_audit",
        category="vibe_audit_remediation:test",
        severity=ns["SEVERITY_MUST_FIX"],
        scope="product",
        scope_targets=["customer.account"],
        summary="user vibe alter desc",
        action_type="alter_description",
        action_scope="product",
        args={"domain": "customer", "product": "account", "description": "user-driven"},
        provenance=ns["PROVENANCE_USER_VIBE"],
    )
    summary = disp.process_batch()
    assert summary["protected_violations"] == 0, (
        "User-vibe finding MUST bypass protected_targets gate (§3c authority)"
    )
    assert summary["applied"] == 1, "User-vibe LOCAL action MUST be applied by safe executor"
    assert state["domains"][0]["products"][0]["description"] == "user-driven"
