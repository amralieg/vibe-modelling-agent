"""Behavioral tests for v0.7.5 — MasterActionRegistry + classify_action_cost +
render_master_action_catalog + FindingShape + FindingDispatcher unification.

The v0.7.5 release responds to the user's 2026-04-29 architectural critique:

    "Architect review, Quality Gate, Static Analysis and Next Vibes,
     THESE ARE ALL seems like doing the samething. Architect remediations
     and vibe actions are exactly same actions. Merge remediation into the
     vibe actions, this should be DRY. Pass the master action list to the
     architect, static analysis, next vibes and QA prompts. After each one
     if there is a low hanging fruit action then do it."

Five guarantees this suite enforces:

  1. **Single source of truth** — MASTER_ACTION_REGISTRY enumerates every
     (action_type, scope) tuple the agent will auto-execute. No callsite is
     allowed to invent or maintain a parallel vocabulary; v0.7.4's
     _V074_SA_ACTION_VOCAB is now a thin shim that DERIVES from the registry.

  2. **Per-context cost classification** — classify_action_cost(model, action,
     scope, args) returns LOCAL / REQUIRES_FK_REWIRE / REQUIRES_NORMALIZATION_REDO /
     REQUIRES_FULL_REGEN. Same action can have DIFFERENT cost depending on
     model context (rename of PK vs rename of non-key column, etc.).

  3. **Per-stage safe_cost_classes** — STAGE_SAFE_COST_CLASSES declares which
     cost classes each pipeline stage may auto-apply inline. Static analysis
     post-attribute-gen accepts only LOCAL; quality_gate accepts LOCAL + FK_REWIRE.

  4. **One vocabulary in every review prompt** — VIBE_CREATE_NEXT_PROMPT,
     MODEL_ARCHITECT_REVIEW_PROMPT, DOMAIN_ARCHITECT_REVIEW_PROMPT, and
     VIBE_AUDIT_PROMPT all carry {master_action_catalog} placeholder; the
     central renderer auto-injects render_master_action_catalog() so each
     callsite gets the canonical menu without per-stage maintenance.

  5. **Cost-gated SA dispatcher** — step_static_analysis_autofix now consults
     classify_action_cost before calling each v0.7.4 autofixer. Findings
     whose cost class exceeds the stage's safe set defer to next_vibes
     instead of mutating mid-pipeline.

All v0.7.5 changes are INDUSTRY-AGNOSTIC (CLAUDE.md §8.5), DETERMINISTIC, and
SERVERLESS-COMPATIBLE (CLAUDE.md §2 — pure dict mutation).
"""

import json
import re
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
AGENT_NB = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


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


def _exec_v075_namespace():
    """Build a namespace exposing MASTER_ACTION_REGISTRY + ACTION_COST_* +
    classify_action_cost + render_master_action_catalog + make_finding +
    validate_finding + STAGE_SAFE_COST_CLASSES + FindingDispatcher by exec-ing
    only the relevant function block from cell 3."""
    src = _load_cell_source(AGENT_NB, 3)
    start = src.find("ACTION_COST_LOCAL = 'LOCAL'")
    assert start >= 0, "ACTION_COST_LOCAL constant must be defined in cell 3"
    end = src.find("def _cascade_domain_rename(")
    assert end > start, "_cascade_domain_rename must follow the v0.7.5 block in cell 3"
    block = src[start:end]
    ns = {"__builtins__": __builtins__}
    exec(block, ns)
    return ns


# =====================================================================
# 1. MASTER_ACTION_REGISTRY structure
# =====================================================================

def test_master_action_registry_is_defined():
    ns = _exec_v075_namespace()
    assert "MASTER_ACTION_REGISTRY" in ns
    reg = ns["MASTER_ACTION_REGISTRY"]
    assert isinstance(reg, dict)
    assert len(reg) >= 100, (
        f"MASTER_ACTION_REGISTRY must enumerate >=100 (action_type, scope) tuples; "
        f"saw {len(reg)}"
    )


def test_master_action_registry_keys_are_action_scope_tuples():
    ns = _exec_v075_namespace()
    reg = ns["MASTER_ACTION_REGISTRY"]
    for k in reg.keys():
        assert isinstance(k, tuple) and len(k) == 2, (
            f"MASTER_ACTION_REGISTRY key must be (action_type, scope) tuple; got {k!r}"
        )
        action_type, scope = k
        assert isinstance(action_type, str) and action_type
        assert isinstance(scope, str) and scope


def test_master_action_registry_each_entry_has_cost_default_and_description():
    ns = _exec_v075_namespace()
    reg = ns["MASTER_ACTION_REGISTRY"]
    valid_costs = {
        ns["ACTION_COST_LOCAL"], ns["ACTION_COST_FK_REWIRE"],
        ns["ACTION_COST_NORM_REDO"], ns["ACTION_COST_FULL_REGEN"],
    }
    for k, spec in reg.items():
        assert isinstance(spec, dict), f"Entry {k!r} value must be a dict"
        assert "cost_default" in spec, f"Entry {k!r} missing cost_default"
        assert spec["cost_default"] in valid_costs, (
            f"Entry {k!r} cost_default {spec['cost_default']!r} not in {valid_costs}"
        )
        assert "description" in spec and spec["description"], (
            f"Entry {k!r} missing or empty description"
        )


def test_master_action_registry_covers_critical_actions():
    """The actions that the v0.7.4 dispatcher consumes + the actions that the
    LLM most commonly proposes MUST all exist in the registry."""
    ns = _exec_v075_namespace()
    reg = ns["MASTER_ACTION_REGISTRY"]
    must_have = [
        ("rename", "attribute"), ("rename", "product"), ("rename", "domain"),
        ("drop", "attribute"), ("drop", "product"), ("drop", "domain"),
        ("modify", "attribute"), ("modify", "product"), ("modify", "domain"),
        ("create", "domain"), ("create", "product"),
        ("merge", "product"), ("merge", "domain"),
        ("split", "product"), ("split", "domain"),
        ("add_tag", "attribute"), ("remove_tag", "attribute"),
        ("alter_description", "attribute"), ("alter_description", "product"),
        ("connect_table", "product"),
        ("create_link", "link"), ("drop_link", "link"), ("redirect_fk", "link"),
        ("set_primary_key", "product"),
        ("change_type", "attribute"),
        ("update_glossary", "attribute"), ("update_regex", "attribute"),
        ("move_attribute", "attribute"), ("move_product", "product"),
        ("auto_merge_duplicates", "model"), ("break_cycles", "model"),
        ("fix_siloed", "model"), ("find_missing_fk_links", "model"),
        ("fix_fk_anomalies", "model"), ("link_all_id_columns", "model"),
        ("model_checkup", "model"), ("normalize_to_3nf", "model"),
        ("dedupe_attributes", "model"),
    ]
    missing = [k for k in must_have if k not in reg]
    assert not missing, f"MASTER_ACTION_REGISTRY missing critical entries: {missing}"


# =====================================================================
# 2. classify_action_cost — context-sensitive
# =====================================================================

def test_classify_unknown_action_returns_full_regen():
    ns = _exec_v075_namespace()
    cost = ns["classify_action_cost"]({}, "totally_made_up_action", "scope_foo", {})
    assert cost == ns["ACTION_COST_FULL_REGEN"], (
        "Unknown actions must default to FULL_REGEN (safest defer)"
    )


def test_classify_rename_attribute_non_key_is_local():
    ns = _exec_v075_namespace()
    model = {
        "domains": [{
            "name": "customer",
            "products": [{
                "name": "account",
                "attributes": [
                    {"name": "account_id", "primary_key": True},
                    {"name": "balance"},
                ],
            }],
        }],
    }
    cost = ns["classify_action_cost"](model, "rename", "attribute", {
        "domain": "customer", "product": "account", "attribute": "balance"
    })
    assert cost == ns["ACTION_COST_LOCAL"], (
        "Rename of non-PK/non-FK attribute is LOCAL"
    )


def test_classify_rename_attribute_pk_is_fk_rewire():
    ns = _exec_v075_namespace()
    model = {
        "domains": [{
            "name": "customer",
            "products": [{
                "name": "account",
                "attributes": [
                    {"name": "account_id", "primary_key": True},
                ],
            }],
        }],
    }
    cost = ns["classify_action_cost"](model, "rename", "attribute", {
        "domain": "customer", "product": "account", "attribute": "account_id"
    })
    assert cost == ns["ACTION_COST_FK_REWIRE"], (
        "Rename of PK attribute is REQUIRES_FK_REWIRE"
    )


def test_classify_rename_attribute_fk_target_is_fk_rewire():
    ns = _exec_v075_namespace()
    model = {
        "domains": [{
            "name": "customer",
            "products": [
                {"name": "account", "attributes": [{"name": "account_id"}]},
                {"name": "address", "attributes": [
                    {"name": "address_id", "primary_key": True},
                    {"name": "account_id", "foreign_key_to": "customer.account.account_id"},
                ]},
            ],
        }],
    }
    cost = ns["classify_action_cost"](model, "rename", "attribute", {
        "domain": "customer", "product": "account", "attribute": "account_id"
    })
    assert cost == ns["ACTION_COST_FK_REWIRE"], (
        "Rename of attribute that is FK target elsewhere is REQUIRES_FK_REWIRE"
    )


def test_classify_drop_attribute_non_key_is_local():
    ns = _exec_v075_namespace()
    model = {
        "domains": [{
            "name": "customer",
            "products": [{"name": "account", "attributes": [{"name": "balance"}]}],
        }],
    }
    cost = ns["classify_action_cost"](model, "drop", "attribute", {
        "domain": "customer", "product": "account", "attribute": "balance"
    })
    assert cost == ns["ACTION_COST_LOCAL"]


def test_classify_drop_product_is_fk_rewire():
    ns = _exec_v075_namespace()
    cost = ns["classify_action_cost"]({}, "drop", "product", {})
    assert cost == ns["ACTION_COST_FK_REWIRE"]


def test_classify_drop_domain_is_norm_redo():
    ns = _exec_v075_namespace()
    cost = ns["classify_action_cost"]({}, "drop", "domain", {})
    assert cost == ns["ACTION_COST_NORM_REDO"]


def test_classify_split_product_is_norm_redo():
    ns = _exec_v075_namespace()
    cost = ns["classify_action_cost"]({}, "split", "product", {})
    assert cost == ns["ACTION_COST_NORM_REDO"]


def test_classify_enlarge_model_falls_back_full_regen():
    """enlarge_model isn't explicitly in the registry but must default safe."""
    ns = _exec_v075_namespace()
    cost = ns["classify_action_cost"]({}, "enlarge_model", "model", {})
    # Either explicit FULL_REGEN entry OR default fallback
    assert cost in (ns["ACTION_COST_NORM_REDO"], ns["ACTION_COST_FULL_REGEN"])


def test_classify_add_tag_attribute_is_local():
    ns = _exec_v075_namespace()
    cost = ns["classify_action_cost"]({}, "add_tag", "attribute", {})
    assert cost == ns["ACTION_COST_LOCAL"]


def test_classify_alter_description_is_local_for_all_scopes():
    ns = _exec_v075_namespace()
    for scope in ("attribute", "product", "domain"):
        cost = ns["classify_action_cost"]({}, "alter_description", scope, {})
        assert cost == ns["ACTION_COST_LOCAL"], f"alter_description on {scope} should be LOCAL"


def test_classify_modify_attribute_with_fk_change_is_fk_rewire():
    ns = _exec_v075_namespace()
    cost = ns["classify_action_cost"]({}, "modify", "attribute", {
        "foreign_key_to": "other.product.id"
    })
    assert cost == ns["ACTION_COST_FK_REWIRE"]


def test_classify_modify_attribute_with_pk_change_is_fk_rewire():
    ns = _exec_v075_namespace()
    cost = ns["classify_action_cost"]({}, "modify", "attribute", {
        "primary_key": True
    })
    assert cost == ns["ACTION_COST_FK_REWIRE"]


# =====================================================================
# 3. render_master_action_catalog
# =====================================================================

def test_render_master_action_catalog_returns_non_empty_markdown():
    ns = _exec_v075_namespace()
    md = ns["render_master_action_catalog"]()
    assert isinstance(md, str)
    assert len(md) > 500
    assert "MASTER ACTION CATALOG" in md
    for scope in ("attribute", "product", "domain", "link", "tag", "model"):
        assert f"scope = `{scope}`" in md, f"Catalog must show scope={scope} section"


def test_render_master_action_catalog_includes_cost_classes():
    ns = _exec_v075_namespace()
    md = ns["render_master_action_catalog"]()
    assert "LOCAL" in md
    assert "REQUIRES_FK_REWIRE" in md
    assert "REQUIRES_NORMALIZATION_REDO" in md
    assert "REQUIRES_FULL_REGEN" in md


def test_render_master_action_catalog_supports_scope_filter():
    ns = _exec_v075_namespace()
    md_attr = ns["render_master_action_catalog"](scope_filter={"attribute"})
    md_full = ns["render_master_action_catalog"]()
    assert len(md_attr) < len(md_full), (
        "Filtered render must be shorter than full render"
    )
    assert "scope = `attribute`" in md_attr
    assert "scope = `product`" not in md_attr
    assert "scope = `model`" not in md_attr


def test_render_master_action_catalog_industry_agnostic():
    ns = _exec_v075_namespace()
    md = ns["render_master_action_catalog"]()
    forbidden = [
        "airline", "airlines", "emirates", "telecom", "banking",
        "healthcare", "retail", "patient", "boeing", "iata",
    ]
    md_lower = md.lower()
    for word in forbidden:
        assert word not in md_lower, (
            f"render_master_action_catalog leaks industry-specific term '{word}'"
        )


# =====================================================================
# 4. FindingShape (make_finding + validate_finding)
# =====================================================================

def test_make_finding_returns_canonical_dict():
    ns = _exec_v075_namespace()
    f = ns["make_finding"](
        stage="static_analysis_post_attribute_gen",
        category="missing_attribute_description",
        severity="warning",
        scope="attribute",
        scope_targets=["customer.account.balance"],
        summary="Balance attribute missing description",
        action_type="alter_description",
        action_scope="attribute",
        args={"domain": "customer", "product": "account", "attribute": "balance"},
        reasoning="LLM should generate a 1-line description",
    )
    assert f["stage"] == "static_analysis_post_attribute_gen"
    assert f["category"] == "missing_attribute_description"
    assert f["severity"] == "warning"
    assert f["scope"] == "attribute"
    assert f["scope_targets"] == ["customer.account.balance"]
    assert f["summary"] == "Balance attribute missing description"
    assert f["proposed_action"]["action_type"] == "alter_description"
    assert f["proposed_action"]["scope"] == "attribute"
    assert f["proposed_action"]["args"] == {
        "domain": "customer", "product": "account", "attribute": "balance"
    }


def test_make_finding_handles_string_scope_targets():
    ns = _exec_v075_namespace()
    f = ns["make_finding"](
        stage="x", category="y", severity=ns["SEVERITY_SHOULD_FIX"], scope="attribute",
        scope_targets="single.target.string",  # string, not list
        summary="s", action_type="add_tag", action_scope="attribute", args={},
    )
    assert f["scope_targets"] == ["single.target.string"]


def test_validate_finding_accepts_canonical():
    ns = _exec_v075_namespace()
    f = ns["make_finding"](
        stage="x", category="y", severity=ns["SEVERITY_SHOULD_FIX"], scope="attribute",
        scope_targets=["a.b.c"], summary="s",
        action_type="add_tag", action_scope="attribute", args={},
        provenance=ns["PROVENANCE_SA"],
    )
    ok, err = ns["validate_finding"](f)
    assert ok, f"Canonical finding should validate; got error: {err}"


def test_validate_finding_rejects_unknown_action():
    ns = _exec_v075_namespace()
    f = ns["make_finding"](
        stage="x", category="y", severity=ns["SEVERITY_SHOULD_FIX"], scope="attribute",
        scope_targets=["a.b.c"], summary="s",
        action_type="invented_action", action_scope="attribute", args={},
        provenance=ns["PROVENANCE_AUTOFIX"],
    )
    ok, err = ns["validate_finding"](f)
    assert not ok
    assert "MASTER_ACTION_REGISTRY" in err


def test_validate_finding_rejects_missing_required_keys():
    ns = _exec_v075_namespace()
    ok, err = ns["validate_finding"]({"stage": "x"})
    assert not ok
    assert "missing required key" in err


def test_validate_finding_rejects_non_dict():
    ns = _exec_v075_namespace()
    ok, err = ns["validate_finding"]("not a dict")
    assert not ok


# =====================================================================
# 5. STAGE_SAFE_COST_CLASSES
# =====================================================================

def test_stage_safe_cost_classes_defines_all_4_review_stages():
    ns = _exec_v075_namespace()
    safes = ns["STAGE_SAFE_COST_CLASSES"]
    for stage in (
        "static_analysis_post_attribute_gen", "architect_review",
        "domain_architect_review", "model_checkup", "quality_gate",
        "next_vibes_generation", "vibe_audit",
    ):
        assert stage in safes, f"STAGE_SAFE_COST_CLASSES missing stage {stage!r}"


def test_static_analysis_stage_only_allows_local():
    ns = _exec_v075_namespace()
    safes = ns["STAGE_SAFE_COST_CLASSES"]
    sa_safes = safes["static_analysis_post_attribute_gen"]
    assert sa_safes == {ns["ACTION_COST_LOCAL"]}, (
        "Static analysis post-attribute-gen must only allow LOCAL fixes "
        "(everything else risks corrupting downstream FK linking)"
    )


def test_quality_gate_allows_local_and_fk_rewire():
    ns = _exec_v075_namespace()
    safes = ns["STAGE_SAFE_COST_CLASSES"]
    qg_safes = safes["quality_gate"]
    assert ns["ACTION_COST_LOCAL"] in qg_safes
    assert ns["ACTION_COST_FK_REWIRE"] in qg_safes


def test_architect_review_only_allows_local():
    ns = _exec_v075_namespace()
    safes = ns["STAGE_SAFE_COST_CLASSES"]
    ar_safes = safes["architect_review"]
    assert ar_safes == {ns["ACTION_COST_LOCAL"]}, (
        "Architect review must only allow LOCAL fixes (FK linking is stable)"
    )


def test_next_vibes_only_allows_local():
    ns = _exec_v075_namespace()
    safes = ns["STAGE_SAFE_COST_CLASSES"]
    nv_safes = safes["next_vibes_generation"]
    assert nv_safes == {ns["ACTION_COST_LOCAL"]}, (
        "Next vibes is the terminal stage — only LOCAL is safe to apply now; "
        "everything else queues to the next pipeline run"
    )


# =====================================================================
# 6. FindingDispatcher
# =====================================================================

class _FakeLogger:
    def __init__(self):
        self.lines = []
    def info(self, msg):
        self.lines.append(("INFO", msg))
    def warning(self, msg):
        self.lines.append(("WARNING", msg))
    def error(self, msg):
        self.lines.append(("ERROR", msg))


def test_dispatcher_applies_lhf_via_executor():
    ns = _exec_v075_namespace()
    log = _FakeLogger()
    applied_calls = []
    def executor(finding, model, lg):
        applied_calls.append(finding["proposed_action"]["action_type"])
        return True
    disp = ns["FindingDispatcher"](
        stage_name="next_vibes_generation",
        model_state={},
        logger=log,
        executor=executor,
    )
    f = ns["make_finding"](
        stage="x", category="y", severity=ns["SEVERITY_SHOULD_FIX"], scope="attribute",
        scope_targets=["a.b.c"], summary="s",
        action_type="add_tag", action_scope="attribute", args={},
    )
    disp.submit(f)
    result = disp.process_batch()
    assert result["applied"] == 1
    assert result["deferred"] == 0
    assert applied_calls == ["add_tag"]


def test_dispatcher_defers_high_cost_action():
    ns = _exec_v075_namespace()
    log = _FakeLogger()
    def executor(finding, model, lg):
        return True
    disp = ns["FindingDispatcher"](
        stage_name="static_analysis_post_attribute_gen",  # only LOCAL safe
        model_state={},
        logger=log,
        executor=executor,
    )
    f = ns["make_finding"](
        stage="x", category="y", severity=ns["SEVERITY_SHOULD_FIX"], scope="product",
        scope_targets=["a.b"], summary="s",
        action_type="merge", action_scope="product", args={},  # NORM_REDO
    )
    disp.submit(f)
    result = disp.process_batch()
    assert result["applied"] == 0
    assert result["deferred"] == 1


def test_dispatcher_marks_invalid_findings():
    ns = _exec_v075_namespace()
    log = _FakeLogger()
    disp = ns["FindingDispatcher"](
        stage_name="next_vibes_generation",
        model_state={},
        logger=log,
        executor=lambda f, m, lg: True,
    )
    f = ns["make_finding"](
        stage="x", category="y", severity=ns["SEVERITY_SHOULD_FIX"], scope="attribute",
        scope_targets=["a.b.c"], summary="s",
        action_type="invented_action", action_scope="attribute", args={},
    )
    disp.submit(f)
    result = disp.process_batch()
    assert result["invalid"] == 1
    assert result["applied"] == 0


def test_dispatcher_detects_conflicts():
    """Two findings on the same scope_target with DIFFERENT proposed actions
    (e.g. drop vs rename) must both defer (conflict)."""
    ns = _exec_v075_namespace()
    log = _FakeLogger()
    disp = ns["FindingDispatcher"](
        stage_name="next_vibes_generation",
        model_state={},
        logger=log,
        executor=lambda f, m, lg: True,
    )
    f1 = ns["make_finding"](
        stage="x", category="y1", severity=ns["SEVERITY_SHOULD_FIX"], scope="attribute",
        scope_targets=["a.b.c"], summary="s",
        action_type="add_tag", action_scope="attribute", args={},
    )
    f2 = ns["make_finding"](
        stage="x", category="y2", severity=ns["SEVERITY_SHOULD_FIX"], scope="attribute",
        scope_targets=["a.b.c"], summary="s",
        action_type="alter_description", action_scope="attribute", args={},
    )
    disp.submit_many([f1, f2])
    result = disp.process_batch()
    assert result["conflicts"] >= 2
    assert result["deferred"] >= 2
    assert result["applied"] == 0


def test_dispatcher_handles_executor_exception():
    ns = _exec_v075_namespace()
    log = _FakeLogger()
    def boom(f, m, lg):
        raise ValueError("simulated executor failure")
    disp = ns["FindingDispatcher"](
        stage_name="next_vibes_generation",
        model_state={},
        logger=log,
        executor=boom,
    )
    f = ns["make_finding"](
        stage="x", category="y", severity=ns["SEVERITY_SHOULD_FIX"], scope="attribute",
        scope_targets=["a.b.c"], summary="s",
        action_type="add_tag", action_scope="attribute", args={},
    )
    disp.submit(f)
    result = disp.process_batch()
    assert result["applied"] == 0
    assert result["deferred"] == 1


def test_dispatcher_no_executor_defers_everything():
    ns = _exec_v075_namespace()
    log = _FakeLogger()
    disp = ns["FindingDispatcher"](
        stage_name="next_vibes_generation",
        model_state={},
        logger=log,
        executor=None,
    )
    f = ns["make_finding"](
        stage="x", category="y", severity=ns["SEVERITY_SHOULD_FIX"], scope="attribute",
        scope_targets=["a.b.c"], summary="s",
        action_type="add_tag", action_scope="attribute", args={},
    )
    disp.submit(f)
    result = disp.process_batch()
    assert result["applied"] == 0
    assert result["deferred"] == 1


# =====================================================================
# 7. Per-prompt injection (prompts must contain {master_action_catalog})
# =====================================================================

def test_vibe_create_next_prompt_has_master_action_catalog_placeholder():
    src = _load_nb_source(AGENT_NB)
    pos = src.find('PROMPT_TEMPLATES["VIBE_CREATE_NEXT_PROMPT"]')
    assert pos >= 0
    # Check the prompt body contains the placeholder
    block = src[pos:pos + 8000]
    assert "{master_action_catalog}" in block, (
        "VIBE_CREATE_NEXT_PROMPT must inject {master_action_catalog} placeholder"
    )


def test_model_architect_review_prompt_has_master_action_catalog_placeholder():
    src = _load_nb_source(AGENT_NB)
    pos = src.find('PROMPT_TEMPLATES["MODEL_ARCHITECT_REVIEW_PROMPT"]')
    assert pos >= 0
    block = src[pos:pos + 6000]
    assert "{master_action_catalog}" in block, (
        "MODEL_ARCHITECT_REVIEW_PROMPT must inject {master_action_catalog} placeholder"
    )


def test_domain_architect_review_prompt_has_master_action_catalog_placeholder():
    src = _load_nb_source(AGENT_NB)
    pos = src.find('PROMPT_TEMPLATES["DOMAIN_ARCHITECT_REVIEW_PROMPT"]')
    assert pos >= 0
    block = src[pos:pos + 6000]
    assert "{master_action_catalog}" in block, (
        "DOMAIN_ARCHITECT_REVIEW_PROMPT must inject {master_action_catalog} placeholder"
    )


def test_vibe_audit_prompt_has_master_action_catalog_placeholder():
    src = _load_nb_source(AGENT_NB)
    pos = src.find('PROMPT_TEMPLATES["VIBE_AUDIT_PROMPT"]')
    assert pos >= 0
    block = src[pos:pos + 4000]
    assert "{master_action_catalog}" in block, (
        "VIBE_AUDIT_PROMPT must inject {master_action_catalog} placeholder"
    )


def test_load_and_format_prompt_auto_injects_master_action_catalog():
    src = _load_nb_source(AGENT_NB)
    # The central renderer must auto-fill master_action_catalog if the template
    # has the placeholder and the caller didn't supply it
    pos = src.find("def load_and_format_prompt(")
    assert pos >= 0
    block = src[pos:pos + 3000]
    assert "master-action-catalog-auto-inject FIRED" in block, (
        "load_and_format_prompt must emit auto-inject sentinel"
    )
    # v0.7.5 Risk-1 patch: per-prompt scope-filtered render via
    # _resolve_master_action_catalog_for_prompt — architects get strategic-only.
    assert "_resolve_master_action_catalog_for_prompt" in block, (
        "load_and_format_prompt must use the per-prompt scope-filtered renderer "
        "(_resolve_master_action_catalog_for_prompt) so architects get a strategic "
        "subset of the catalog instead of all 149 actions"
    )


def test_safe_format_prompt_auto_injects_master_action_catalog():
    src = _load_nb_source(AGENT_NB)
    pos = src.find("def _safe_format_prompt(")
    assert pos >= 0
    # Find next def to bound the function
    nxt = src.find("\ndef ", pos + 1)
    block = src[pos:nxt if nxt > 0 else pos + 2000]
    assert "{master_action_catalog}" in block
    assert "render_master_action_catalog()" in block


def test_vibe_audit_quick_sweep_passes_master_action_catalog_in_format():
    src = _load_nb_source(AGENT_NB)
    # quick_sweep callsite (cell 3)
    quick_sweep = src.find('audit_depth="quick_sweep"')
    assert quick_sweep > 0
    # window around the .format()
    window = src[max(0, quick_sweep - 200):quick_sweep + 300]
    assert "master_action_catalog=render_master_action_catalog" in window, (
        "quick_sweep .format() must pass master_action_catalog explicitly"
    )


def test_vibe_audit_full_audit_passes_master_action_catalog_in_format():
    src = _load_nb_source(AGENT_NB)
    full_audit = src.find('audit_depth="full_audit"')
    assert full_audit > 0
    window = src[max(0, full_audit - 200):full_audit + 300]
    assert "master_action_catalog=render_master_action_catalog" in window, (
        "full_audit .format() must pass master_action_catalog explicitly"
    )


# =====================================================================
# 8. v0.7.4 retirement shim
# =====================================================================

def test_v074_sa_action_vocab_now_derives_from_master():
    src = _load_nb_source(AGENT_NB)
    assert "_V074_SA_ACTION_VOCAB = _v075_build_v074_vocab_compat()" in src, (
        "v0.7.4 _V074_SA_ACTION_VOCAB must now be derived from MASTER_ACTION_REGISTRY"
    )
    assert "def _v075_build_v074_vocab_compat" in src
    assert "V075_RETIRE_V074_VOCAB FIRED" in src


def test_v074_render_action_vocab_block_is_thin_shim():
    src = _load_nb_source(AGENT_NB)
    # find the function body
    pos = src.find("def _v074_render_action_vocab_block():")
    assert pos > 0
    body_end = src.find("\ndef ", pos + 1)
    body = src[pos:body_end if body_end > 0 else pos + 2000]
    assert "return render_master_action_catalog()" in body, (
        "_v074_render_action_vocab_block must now delegate to canonical render"
    )


def test_v074_action_vocab_dict_no_longer_hardcoded():
    """The hardcoded dict literal _V074_SA_ACTION_VOCAB = { ... } must be GONE.
    It's now derived. Detect by checking the IMMEDIATE next char after the
    assignment isn't '{' (a literal dict)."""
    src = _load_nb_source(AGENT_NB)
    occurrences = re.findall(r"_V074_SA_ACTION_VOCAB\s*=\s*(\{|_v075_build_v074_vocab_compat\(\))", src)
    # Must have exactly one assignment, and it must be the shim call
    assignments_to_dict_literal = [o for o in occurrences if o == "{"]
    assert not assignments_to_dict_literal, (
        f"_V074_SA_ACTION_VOCAB must NOT be assigned a literal dict; "
        f"found {len(assignments_to_dict_literal)} hardcoded assignments"
    )


# =====================================================================
# 9. Cost-class gating in step_static_analysis_autofix
# =====================================================================

def test_sa_dispatcher_consults_classify_action_cost():
    src = _load_nb_source(AGENT_NB)
    pos = src.find("def step_static_analysis_autofix(")
    assert pos > 0
    nxt = src.find("\ndef ", pos + 1)
    body = src[pos:nxt if nxt > 0 else pos + 8000]
    assert "classify_action_cost(" in body, (
        "step_static_analysis_autofix must call classify_action_cost on every issue"
    )
    assert "STAGE_SAFE_COST_CLASSES" in body, (
        "step_static_analysis_autofix must consult STAGE_SAFE_COST_CLASSES"
    )
    assert "step-sa-active-autofix-deferred-high-cost FIRED" in body, (
        "Must emit deferred-high-cost sentinel when cost class exceeds stage safe set"
    )


def test_sa_dispatcher_has_category_to_action_mapping():
    src = _load_nb_source(AGENT_NB)
    assert "_V075_SA_CATEGORY_TO_ACTION = {" in src
    # Check a few critical mappings exist
    for cat in (
        "banned_boilerplate_in_output", "pii_tagging_missing",
        "denormalized_natural_key", "self_fk_on_pk",
        "missing_attribute_description", "cross_domain_duplicate",
    ):
        assert f"'{cat}':" in src, (
            f"_V075_SA_CATEGORY_TO_ACTION missing mapping for category '{cat}'"
        )


def test_sa_dispatcher_returns_deferred_high_cost_field():
    src = _load_nb_source(AGENT_NB)
    pos = src.find("def step_static_analysis_autofix(")
    nxt = src.find("\ndef ", pos + 1)
    body = src[pos:nxt if nxt > 0 else pos + 8000]
    # Must include 'issues_deferred_high_cost' in returned dict
    assert "'issues_deferred_high_cost'" in body, (
        "step_static_analysis_autofix return dict must include 'issues_deferred_high_cost'"
    )


# =====================================================================
# 10. Industry-agnostic guarantees (CLAUDE.md §8.5)
# =====================================================================

def test_v075_module_no_industry_strings():
    src = _load_cell_source(AGENT_NB, 3)
    start = src.find("ACTION_COST_LOCAL = 'LOCAL'")
    end = src.find("def _cascade_domain_rename(")
    block = src[start:end].lower()
    forbidden = [
        "airline", "airlines", "emirates", "telecom", "banking",
        "healthcare", "retail", "patient", "boeing", "iata",
        "ncdot",
    ]
    for word in forbidden:
        assert word not in block, (
            f"v0.7.5 MasterActionRegistry/dispatcher block leaks industry term '{word}'"
        )


def test_v075_no_persist_or_cache_or_sparkcontext():
    src = _load_cell_source(AGENT_NB, 3)
    start = src.find("ACTION_COST_LOCAL = 'LOCAL'")
    end = src.find("def _cascade_domain_rename(")
    block = src[start:end]
    # Strip pure-comment lines
    code_lines = [ln for ln in block.split("\n") if not ln.lstrip().startswith("#")]
    code_only = "\n".join(code_lines)
    forbidden = [".cache(", ".persist(", "sparkContext", ".uncache(", "Broadcast"]
    for tok in forbidden:
        assert tok not in code_only, (
            f"CLAUDE.md §2 violation: v0.7.5 block uses '{tok}' (not serverless-compat)"
        )


# =====================================================================
# 11. Version pin (single-digit semver per CLAUDE.md §3a)
# =====================================================================

def test_v075_agent_version_constant():
    src = _load_nb_source(AGENT_NB)
    assert '__AGENT_VERSION__ = "0.7.5"' in src


def test_v075_semver_single_digit_segments():
    src = _load_nb_source(AGENT_NB)
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', src)
    assert m
    for seg in m.groups():
        assert len(seg) == 1, (
            f"CLAUDE.md §3a: every semver segment must be single-digit; saw {m.group(0)}"
        )


# =====================================================================
# 10. v0.7.5 Risk-1 PATCH — scope-filtered catalog per prompt
# =====================================================================

def test_v075_risk1_per_prompt_scope_filter_registry_exists():
    src = _load_nb_source(AGENT_NB)
    assert "_PROMPT_ACTION_CATALOG_SCOPE_FILTER" in src, (
        "Risk-1 patch: per-prompt scope filter registry must exist so architects "
        "get strategic-only actions and don't get token-bombed with all 149 actions"
    )
    assert '"MODEL_ARCHITECT_REVIEW_PROMPT"' in src
    assert '"DOMAIN_ARCHITECT_REVIEW_PROMPT"' in src


def test_v075_risk1_resolve_master_action_catalog_for_prompt_exists():
    src = _load_nb_source(AGENT_NB)
    assert "def _resolve_master_action_catalog_for_prompt(" in src, (
        "Risk-1 patch: per-prompt resolver function must exist"
    )
    assert "master-catalog-scope-filtered FIRED" in src


def test_v075_risk1_render_master_action_catalog_supports_scope_filter():
    ns = _exec_v075_namespace()
    full = ns["render_master_action_catalog"]()
    strategic_only = ns["render_master_action_catalog"](scope_filter={'domain', 'product', 'model'})
    assert len(strategic_only) < len(full), (
        "Risk-1 patch: scope-filtered render must be SHORTER than full render"
    )
    assert "scope = `attribute`" not in strategic_only, (
        "Strategic catalog must NOT include attribute-scope actions"
    )
    assert "scope = `tag`" not in strategic_only, (
        "Strategic catalog must NOT include tag-scope actions"
    )
    assert "scope = `product`" in strategic_only or "scope = `domain`" in strategic_only or "scope = `model`" in strategic_only, (
        "Strategic catalog must contain at least one strategic-scope section"
    )


# =====================================================================
# 11. v0.7.5 Risk-2 PATCH — severity axis orthogonal to cost
# =====================================================================

def test_v075_risk2_severity_constants_defined():
    ns = _exec_v075_namespace()
    assert ns["SEVERITY_MUST_FIX"] == "MUST_FIX"
    assert ns["SEVERITY_SHOULD_FIX"] == "SHOULD_FIX"
    assert ns["SEVERITY_NICE_TO_HAVE"] == "NICE_TO_HAVE"


def test_v075_risk2_validate_finding_rejects_invalid_severity():
    ns = _exec_v075_namespace()
    f = ns["make_finding"](
        stage="x", category="y", severity="not_a_real_severity",
        scope="attribute", scope_targets=["a.b.c"], summary="s",
        action_type="add_tag", action_scope="attribute", args={},
    )
    ok, err = ns["validate_finding"](f)
    assert not ok, "Invalid severity must be rejected"
    assert "severity" in err.lower()


def test_v075_risk2_dispatcher_applies_must_fix_before_nice_to_have():
    """Severity-aware ordering: MUST_FIX runs before NICE_TO_HAVE within the
    same cost class. Verifies the dispatcher honours severity for apply order."""
    ns = _exec_v075_namespace()
    log = _FakeLogger()
    apply_log = []
    def executor(f, m, lg):
        apply_log.append((f["category"], f["severity"]))
        return True
    disp = ns["FindingDispatcher"](
        stage_name="next_vibes_generation",
        model_state={},
        logger=log,
        executor=executor,
    )
    nice = ns["make_finding"](
        stage="x", category="cosmetic", severity=ns["SEVERITY_NICE_TO_HAVE"],
        scope="attribute", scope_targets=["a.b.cosmetic"], summary="s",
        action_type="add_tag", action_scope="attribute", args={},
    )
    must = ns["make_finding"](
        stage="x", category="critical", severity=ns["SEVERITY_MUST_FIX"],
        scope="attribute", scope_targets=["a.b.critical"], summary="s",
        action_type="add_tag", action_scope="attribute", args={},
    )
    disp.submit_many([nice, must])  # submit in WRONG order intentionally
    disp.process_batch()
    assert apply_log[0][1] == ns["SEVERITY_MUST_FIX"], (
        f"MUST_FIX must apply BEFORE NICE_TO_HAVE; saw apply order: {apply_log}"
    )


# =====================================================================
# 12. v0.7.5 Risk-3 PATCH — provenance gating (\u00a73b/\u00a73c authority)
# =====================================================================

def test_v075_risk3_provenance_constants_defined():
    ns = _exec_v075_namespace()
    assert ns["PROVENANCE_USER_VIBE"] == "user_vibe"
    assert ns["PROVENANCE_ARCHITECT"] == "architect"
    assert ns["PROVENANCE_SA"] == "sa"
    assert ns["PROVENANCE_QA"] == "qa"
    assert ns["PROVENANCE_AUTOFIX"] == "autofix"


def test_v075_risk3_validate_finding_rejects_invalid_provenance():
    ns = _exec_v075_namespace()
    f = {
        "stage": "x", "category": "y",
        "severity": ns["SEVERITY_SHOULD_FIX"],
        "provenance": "not_real_prov",
        "scope": "attribute", "scope_targets": ["a.b.c"], "summary": "s",
        "proposed_action": {"action_type": "add_tag", "scope": "attribute", "args": {}},
    }
    ok, err = ns["validate_finding"](f)
    assert not ok
    assert "provenance" in err.lower()


def test_v075_risk3_dispatcher_protects_user_specified_targets():
    """Non-user_vibe finding touching a protected target must HARD-DEFER (\u00a73b/\u00a73c)."""
    ns = _exec_v075_namespace()
    log = _FakeLogger()
    apply_log = []
    def executor(f, m, lg):
        apply_log.append(f["scope_targets"])
        return True
    disp = ns["FindingDispatcher"](
        stage_name="next_vibes_generation",
        model_state={},
        logger=log,
        executor=executor,
        protected_targets={"customer_specified_domain", "another_user_protected"},
    )
    architect_proposal = ns["make_finding"](
        stage="x", category="rename", severity=ns["SEVERITY_SHOULD_FIX"],
        scope="domain",
        scope_targets=["customer_specified_domain"],  # tries to touch protected
        summary="rename customer_specified_domain to fancier_name",
        action_type="rename", action_scope="domain", args={},
        provenance=ns["PROVENANCE_ARCHITECT"],
    )
    disp.submit(architect_proposal)
    result = disp.process_batch()
    assert result["applied"] == 0, "architect proposal must NOT apply to protected target"
    assert result["protected_violations"] >= 1
    assert len(apply_log) == 0


def test_v075_risk3_dispatcher_lets_user_vibe_pass_through():
    """User_vibe provenance is exempt from the PROTECTED-TARGET check (\u00a73c top of pyramid).

    Cost gating still applies orthogonally (a user-asked FK_REWIRE may still defer
    when only LOCAL is safe in the current stage). This test isolates the
    provenance gate by using a LOCAL action on a protected target."""
    ns = _exec_v075_namespace()
    log = _FakeLogger()
    apply_log = []
    def executor(f, m, lg):
        apply_log.append(f["scope_targets"])
        return True
    disp = ns["FindingDispatcher"](
        stage_name="next_vibes_generation",
        model_state={},
        logger=log,
        executor=executor,
        protected_targets={"customer_specified_domain"},
    )
    user_directive = ns["make_finding"](
        stage="x", category="user_request", severity=ns["SEVERITY_MUST_FIX"],
        scope="domain", scope_targets=["customer_specified_domain"],
        summary="user explicitly asked for description tweak (LOCAL action)",
        action_type="alter_description", action_scope="domain", args={},
        provenance=ns["PROVENANCE_USER_VIBE"],
    )
    disp.submit(user_directive)
    result = disp.process_batch()
    assert result["protected_violations"] == 0, (
        "user_vibe finding MUST NOT be counted as a protected violation \u2014 \u00a73c authority"
    )
    assert result["applied"] == 1, (
        f"user_vibe finding with LOCAL cost MUST apply on protected target; "
        f"got applied={result['applied']} deferred={result['deferred']} "
        f"protected_violations={result['protected_violations']}"
    )

    # And the equivalent non-user_vibe finding MUST be blocked.
    disp2 = ns["FindingDispatcher"](
        stage_name="next_vibes_generation",
        model_state={},
        logger=log,
        executor=lambda f, m, lg: True,
        protected_targets={"customer_specified_domain"},
    )
    architect_proposal = ns["make_finding"](
        stage="x", category="rename", severity=ns["SEVERITY_SHOULD_FIX"],
        scope="domain", scope_targets=["customer_specified_domain"],
        summary="architect-proposed description tweak on protected domain",
        action_type="alter_description", action_scope="domain", args={},
        provenance=ns["PROVENANCE_ARCHITECT"],
    )
    disp2.submit(architect_proposal)
    result2 = disp2.process_batch()
    assert result2["applied"] == 0
    assert result2["protected_violations"] >= 1


def test_v075_risk3_dotted_target_first_segment_is_protected():
    """If protected_targets contains 'domain_name', a finding targeting
    'domain_name.product.attr' must also be rejected (first-segment match)."""
    ns = _exec_v075_namespace()
    log = _FakeLogger()
    disp = ns["FindingDispatcher"](
        stage_name="next_vibes_generation",
        model_state={},
        logger=log,
        executor=lambda f, m, lg: True,
        protected_targets={"customer_domain"},
    )
    sa_proposal = ns["make_finding"](
        stage="x", category="rename", severity=ns["SEVERITY_SHOULD_FIX"],
        scope="attribute",
        scope_targets=["customer_domain.orders.id"],  # first-segment match
        summary="rename id column",
        action_type="rename", action_scope="attribute", args={},
        provenance=ns["PROVENANCE_SA"],
    )
    disp.submit(sa_proposal)
    result = disp.process_batch()
    assert result["protected_violations"] >= 1, (
        "First-segment match must also trigger protected-target gate"
    )
    assert result["applied"] == 0


# =====================================================================
# 13. v0.7.5 Risk-4 PATCH — recipe-based SA category map
# =====================================================================

def test_v075_risk4_sa_category_map_values_are_lists():
    src = _load_nb_source(AGENT_NB)
    pos = src.find("_V075_SA_CATEGORY_TO_ACTION = {")
    assert pos >= 0
    block_end = src.find("\n}", pos)
    block = src[pos:block_end]
    # Every value must be a [(action, scope), ...] LIST not a single tuple
    assert "[(" in block, (
        "Risk-4 patch: _V075_SA_CATEGORY_TO_ACTION must use LIST values "
        "(action recipes), not single tuples"
    )


def test_v075_risk4_denormalized_natural_key_has_multi_step_recipe():
    src = _load_nb_source(AGENT_NB)
    # Search inside the _V075_SA_CATEGORY_TO_ACTION block specifically (not the
    # v0.7.4 callback registry, which still contains the same key).
    map_pos = src.find("_V075_SA_CATEGORY_TO_ACTION = {")
    assert map_pos > 0
    map_end = src.find("\n}", map_pos)
    map_block = src[map_pos:map_end]
    pos = map_block.find("'denormalized_natural_key':")
    assert pos > 0, "denormalized_natural_key key must exist in V075 map"
    line_end = map_block.find("\n", pos)
    line = map_block[pos:line_end]
    # Multi-step recipe: drop the natural-key attribute + add the FK
    assert "drop" in line and "add_foreign_key" in line, (
        f"Risk-4 patch: 'denormalized_natural_key' needs multi-step recipe "
        f"(drop natural-key + add_foreign_key); single-step misses 60%% of the fix; "
        f"saw line: {line!r}"
    )


def test_v075_risk4_classify_recipe_cost_helper_exists():
    ns = _exec_v075_namespace()
    assert "_v075_classify_recipe_cost" in ns, (
        "Risk-4 patch: _v075_classify_recipe_cost helper must exist"
    )
    helper = ns["_v075_classify_recipe_cost"]
    # All-LOCAL recipe
    cost = helper({}, [("add_tag", "attribute"), ("alter_description", "attribute")], {})
    assert cost == ns["ACTION_COST_LOCAL"], (
        f"All-LOCAL recipe must classify as LOCAL; got {cost}"
    )


def test_v075_risk4_recipe_cost_inherits_worst_case():
    """Multi-step recipe MUST inherit its highest-cost step (most conservative)."""
    ns = _exec_v075_namespace()
    helper = ns["_v075_classify_recipe_cost"]
    # 1 LOCAL + 1 default-FK_REWIRE => overall FK_REWIRE
    cost = helper({}, [
        ("add_tag", "attribute"),
        ("merge", "product"),  # NORM_REDO default
    ], {})
    assert cost in {ns["ACTION_COST_NORM_REDO"], ns["ACTION_COST_FK_REWIRE"]}, (
        f"Recipe cost must inherit the worst step; got {cost}"
    )


# =====================================================================
# 14. v0.7.5 Risk-5 PATCH — combinatorial cost classifier
# =====================================================================

def test_v075_risk5_product_drop_with_inbound_cross_fk_is_fk_rewire():
    """Dropping a product that has FKs pointing INTO it from other domains
    must be FK_REWIRE, not LOCAL — leaves dangling refs otherwise."""
    ns = _exec_v075_namespace()
    model = {
        "domains": [
            {
                "domain": "orders",
                "products": [
                    {
                        "product": "order",
                        "primary_key": "order_id",
                        "attributes": [{"attribute": "order_id"}],
                    },
                ],
            },
            {
                "domain": "shipping",
                "products": [
                    {
                        "product": "shipment",
                        "attributes": [
                            {"attribute": "shipment_id"},
                            {
                                "attribute": "order_ref",
                                "foreign_key_to": "orders.order.order_id",
                            },
                        ],
                    },
                ],
            },
        ],
    }
    cost = ns["classify_action_cost"](
        model, "drop", "product",
        {"domain": "orders", "product": "order"},
    )
    assert cost == ns["ACTION_COST_FK_REWIRE"], (
        f"Risk-5 patch: dropping a product with inbound cross-FKs must be FK_REWIRE; got {cost}"
    )


def test_v075_risk5_product_drop_no_inbound_cross_fk_uses_default():
    """Dropping a product with NO inbound cross-FK uses the registry default."""
    ns = _exec_v075_namespace()
    model = {
        "domains": [
            {"domain": "orders", "products": [
                {"product": "order", "attributes": [{"attribute": "order_id"}]},
            ]},
        ],
    }
    cost = ns["classify_action_cost"](
        model, "drop", "product",
        {"domain": "orders", "product": "order"},
    )
    assert cost == ns["MASTER_ACTION_REGISTRY"][("drop", "product")]["cost_default"], (
        "No inbound cross-FK -> use registry default cost"
    )


def test_v075_risk5_domain_drop_with_inbound_cross_fk_is_norm_redo():
    ns = _exec_v075_namespace()
    model = {
        "domains": [
            {"domain": "ref", "products": [
                {"product": "currency", "primary_key": "currency_code",
                 "attributes": [{"attribute": "currency_code"}]},
            ]},
            {"domain": "txn", "products": [
                {"product": "payment", "attributes": [
                    {"attribute": "payment_id"},
                    {"attribute": "currency_ref",
                     "foreign_key_to": "ref.currency.currency_code"},
                ]},
            ]},
        ],
    }
    cost = ns["classify_action_cost"](
        model, "drop", "domain", {"domain": "ref"},
    )
    assert cost == ns["ACTION_COST_NORM_REDO"], (
        f"Risk-5 patch: dropping a domain with inbound cross-FKs must be NORM_REDO; got {cost}"
    )


def test_v075_risk5_helpers_are_industry_agnostic():
    """The cross-FK detection helpers must use no business-specific names."""
    src = _load_nb_source(AGENT_NB)
    pos = src.find("def _product_has_inbound_cross_fk(")
    assert pos >= 0
    end = src.find("def classify_action_cost(", pos)
    block = src[pos:end]
    # No customer/industry strings
    forbidden = ["airline", "emirates", "ncdot", "telecom", "ecomm", "banking", "healthcare"]
    for word in forbidden:
        assert word.lower() not in block.lower(), (
            f"Risk-5 helper must be industry-agnostic; saw {word!r}"
        )


# =====================================================================
# 15. v0.7.5 Risk-6 PATCH — dispatcher reports protected_violations
# =====================================================================

def test_v075_risk6_process_batch_returns_protected_violations_count():
    ns = _exec_v075_namespace()
    log = _FakeLogger()
    disp = ns["FindingDispatcher"](
        stage_name="next_vibes_generation",
        model_state={},
        logger=log,
        executor=lambda f, m, lg: True,
        protected_targets=set(),  # nothing protected
    )
    f = ns["make_finding"](
        stage="x", category="y", severity=ns["SEVERITY_SHOULD_FIX"],
        scope="attribute", scope_targets=["a.b.c"], summary="s",
        action_type="add_tag", action_scope="attribute", args={},
    )
    disp.submit(f)
    result = disp.process_batch()
    assert "protected_violations" in result, (
        "Risk-6 patch: process_batch result must include protected_violations key"
    )
    assert result["protected_violations"] == 0
