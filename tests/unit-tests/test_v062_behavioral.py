"""Behavioral tests for v0.6.2 fixes.

Covers 3 regressions found in the v0.6.1 telecom MVM v1+v2 audit (2026-04-27):

  REG-1  vov-auto-next-vibes          — vibe modeling of version with empty model_vibes
                                         now auto-loads v_{N-1}/vibes/next_vibes.txt as
                                         the mutation plan. Previously became no-op.
  REG-2  rename-product-convention-   — rename_product normalises target_state through
         enforce                        apply_convention(snake_case by default) so LLM
                                         PascalCase drift no longer leaks into products.
  REG-4  self-ref-banned-prefix-      — _pre_static_analysis_autofix now tries to RENAME
         autorename                     banned-prefix self-ref FK columns to parent_<pk>
                                         before clearing the FK entirely.
"""
import ast
import json
import re

NB = "/Users/amr.ali/Documents/projects/vibe-modelling-agent/agent/dbx_vibe_modelling_agent.ipynb"


def _agent_src() -> str:
    nb = json.load(open(NB))
    return "\n".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


# =============================================================================
# REG-1 — vov-auto-next-vibes
# =============================================================================

def test_v062_reg1_alias_present():
    src = _agent_src()
    assert "[vov-auto-next-vibes FIRED]" in src
    assert "[vov-auto-next-vibes SKIP]" in src


def test_v062_reg1_only_fires_for_vov_operation():
    """Auto-load ONLY fires when operation == 'vibe modeling of version'."""
    src = _agent_src()
    idx = src.find("[vov-auto-next-vibes FIRED]")
    assert idx > 0
    window = src[max(0, idx - 2000):idx + 4000]
    assert 'operation == "vibe modeling of version"' in window


def test_v062_reg1_only_fires_when_user_vibes_empty():
    """The auto-load MUST respect §3c: explicit user model_vibes always win."""
    src = _agent_src()
    idx = src.find("vov-auto-next-vibes FIRED")
    window = src[max(0, idx - 2000):idx + 4000]
    assert 'not widgets_values.get("vibe_modelling_instructions", "").strip()' in window


def test_v062_reg1_uses_base_version_path():
    src = _agent_src()
    idx = src.find("vov-auto-next-vibes FIRED")
    window = src[max(0, idx - 2000):idx + 4000]
    assert 'base_version_for_review' in window
    assert 'vibes' in window
    assert 'next_vibes.txt' in window


def test_v062_reg1_path_uses_model_scope_and_sanitized_business():
    """Path is {root_loc}/business/{sanitized_name}/{model_scope}_v{base}/vibes/next_vibes.txt"""
    src = _agent_src()
    idx = src.find("vov-auto-next-vibes FIRED")
    window = src[max(0, idx - 2000):idx + 4000]
    assert 'os.path.join(root_loc, "business", sanitized_name' in window
    assert 'f"{model_scope}_v{_base_ver_auto}"' in window


def test_v062_reg1_has_dbutils_fs_head_fallback():
    """If POSIX open fails, fall back to dbutils.fs.head with 1MB cap."""
    src = _agent_src()
    idx = src.find("vov-auto-next-vibes FIRED")
    window = src[max(0, idx - 2000):idx + 4000]
    assert "dbutils.fs.head(_source_vibes_path" in window
    assert "1024 * 1024" in window


def test_v062_reg1_assigns_to_widget_vibes_key():
    src = _agent_src()
    idx = src.find("vov-auto-next-vibes FIRED")
    window = src[max(0, idx - 2000):idx + 4000]
    assert 'widgets_values["vibe_modelling_instructions"] = _auto_vibes_content' in window


def test_v062_reg1_records_source_version_marker():
    """Auditor needs to verify the auto-load fired — record which version it came from."""
    src = _agent_src()
    idx = src.find("vov-auto-next-vibes FIRED")
    window = src[max(0, idx - 2000):idx + 4000]
    assert '_auto_loaded_next_vibes_from_version' in window


# =============================================================================
# REG-2 — rename-product-convention-enforce
# =============================================================================

def test_v062_reg2_alias_present():
    src = _agent_src()
    assert "[rename-product-convention-enforce FIRED]" in src


def test_v062_reg2_calls_apply_convention_on_product():
    src = _agent_src()
    idx = src.find("[rename-product-convention-enforce FIRED]")
    assert idx > 0
    window = src[max(0, idx - 2000):idx + 4000]
    assert "apply_convention(new_product, _rename_convention, dedup=False)" in window


def test_v062_reg2_convention_pulled_from_config():
    src = _agent_src()
    idx = src.find("[rename-product-convention-enforce FIRED]")
    window = src[max(0, idx - 2000):idx + 4000]
    assert 'config.get("MODEL_CONVENTIONS")' in window
    assert '"data_asset_naming_convention"' in window
    assert '"snake_case"' in window


def test_v062_reg2_also_normalises_domain_when_cross_domain_rename():
    """If target_state is 'new_domain.new_product', new_domain must also be normalised."""
    src = _agent_src()
    idx = src.find("[rename-product-convention-enforce FIRED]")
    window = src[max(0, idx - 2000):idx + 4000]
    assert "apply_convention(new_domain, _rename_convention, dedup=False)" in window


def test_v062_reg2_apply_convention_snake_case_pascal_input():
    """Direct unit test of the canonical conversion used in REG-2.

    Replicates apply_convention's core logic for snake_case target on a
    PascalCase input — matches the v2 regression where LLM emitted
    'CustomerAgent' when convention was snake_case.
    """
    def _apply(name, convention="snake_case"):
        s = str(name).strip().replace(' ', '_').replace('-', '_')
        s = re.sub(r'([A-Z]+)([A-Z][a-z])', r'\1_\2', s)
        s = re.sub(r'([a-z\d])([A-Z])', r'\1_\2', s)
        s = re.sub(r'[^a-zA-Z0-9_]', '_', s)
        s = re.sub(r'_+', '_', s).strip('_')
        words = [w.lower() for w in s.split('_') if w]
        return '_'.join(words)

    assert _apply("CustomerAgent") == "customer_agent"
    assert _apply("customer_agent") == "customer_agent"  # idempotent
    assert _apply("NotificationTemplate") == "notification_template"
    assert _apply("UsageNotificationTemplate") == "usage_notification_template"
    assert _apply("already_snake") == "already_snake"


# =============================================================================
# REG-4 — self-ref-banned-prefix-autorename
# =============================================================================

def test_v062_reg4_alias_present():
    src = _agent_src()
    assert "[self-ref-banned-prefix-autorename FIRED]" in src


def test_v062_reg4_attempts_rename_before_clearing():
    """The new branch must try to rename to parent_<pk> before falling through to clear."""
    src = _agent_src()
    idx = src.find("[self-ref-banned-prefix-autorename FIRED]")
    assert idx > 0
    window = src[max(0, idx - 4000):idx + 4000]
    assert 'f"parent_{_own_pk}"' in window
    assert "_autoren" in window


def test_v062_reg4_collision_check_before_rename():
    """Rename must not clobber an existing attribute on the same product."""
    src = _agent_src()
    idx = src.find("[self-ref-banned-prefix-autorename FIRED]")
    window = src[max(0, idx - 4000):idx + 4000]
    assert "_existing_attrs_on_prod" in window
    assert "if _cand_new not in _existing_attrs_on_prod" in window


def test_v062_reg4_handles_exact_pk_equality_case():
    """attr_name == pk (e.g., attr 'fallout_id' on table fallout with FK to itself)."""
    src = _agent_src()
    idx = src.find("[self-ref-banned-prefix-autorename FIRED]")
    window = src[max(0, idx - 4000):idx + 4000]
    assert "_a_low == _p_low" in window


def test_v062_reg4_handles_banned_prefix_case():
    """attr_name like 'related_fallout_id' with PK 'fallout_id'."""
    src = _agent_src()
    idx = src.find("[self-ref-banned-prefix-autorename FIRED]")
    window = src[max(0, idx - 4000):idx + 4000]
    assert "_BANNED_SELF_REF_PREFIXES" in window
    assert "_a_low.endswith(_p_low)" in window


def test_v062_reg4_preserves_fk_when_renaming():
    """When renaming, the FK target must be fixed to point at the correct PK."""
    src = _agent_src()
    idx = src.find("[self-ref-banned-prefix-autorename FIRED]")
    window = src[max(0, idx - 4000):idx + 4000]
    assert "attr['foreign_key_to'] = f\"{td}.{tp}.{_own_pk}\"" in window


def test_v062_reg4_fallback_clear_still_exists():
    """If rename fails (collision), fall through to old clear-FK behaviour."""
    src = _agent_src()
    idx = src.find("[self-ref-banned-prefix-autorename FIRED]")
    window = src[max(0, idx - 4000):idx + 6000]
    assert "if not _autoren:" in window
    assert "Removed unlabeled self-referencing FK:" in window


# =============================================================================
# Integration: ensure all three v0.6.2 aliases co-exist and notebook parses
# =============================================================================

def test_v062_all_three_aliases_present_in_notebook():
    src = _agent_src()
    for alias in (
        "[vov-auto-next-vibes FIRED]",
        "[rename-product-convention-enforce FIRED]",
        "[self-ref-banned-prefix-autorename FIRED]",
    ):
        assert alias in src, f"missing {alias} — v0.6.2 fix not deployed"


def test_v062_notebook_cells_all_parse():
    """No syntax errors introduced by the three patches."""
    nb = json.load(open(NB))
    for i, c in enumerate(nb["cells"]):
        if c.get("cell_type") != "code":
            continue
        src = "".join(c["source"])
        ast.parse(src)  # raises if any syntax error


def test_v062_version_marker_v062_in_notebook_and_readme():
    src = _agent_src()
    assert "v0.6.2" in src
    readme = open("/Users/amr.ali/Documents/projects/vibe-modelling-agent/readme.md").read()
    assert "Current version: **v0.6.2**" in readme


# =============================================================================
# PK invariant audit (REG-3 diagnostic)
# =============================================================================
# Not a pipeline fix, but a testing helper: confirms how PKs are actually
# represented in model.json so future audit scripts don't miss them.

def test_v062_pk_invariant_helper():
    """Helper: verify the set of fields/patterns used to identify a PK in model.json."""
    # From the notebook's enforce_configured_pk_consistency + make_attribute_dict,
    # a PK attribute may be identified by ANY of these in model.json:
    #   - attribute name matches product.primary_key
    #   - 'is_primary_key' == True (optional key)
    #   - 'is_pk' == True (optional key)
    #   - 'tags' contains 'primary_key' (substring)
    # The raw boolean 'primary_key' flag is NOT a direct attribute key; the
    # 'primary_key' field exists on PRODUCTS (as the PK column name), not
    # on ATTRIBUTES. Audit scripts that grep attributes for
    # `primary_key: true` will find zero — that's expected, not a bug.

    def is_pk_attr(attr, product_pk):
        if attr.get("attribute") == product_pk:
            return True
        if attr.get("is_primary_key"):
            return True
        if attr.get("is_pk"):
            return True
        if "primary_key" in (attr.get("tags") or "").lower():
            return True
        return False

    # positive cases
    assert is_pk_attr({"attribute": "agent_id", "tags": "primary_key"}, "agent_id")
    assert is_pk_attr({"attribute": "agent_id"}, "agent_id")
    assert is_pk_attr({"attribute": "pk_col", "is_pk": True}, "wrong_name")
    assert is_pk_attr({"attribute": "other", "is_primary_key": True}, "agent_id")
    # negative
    assert not is_pk_attr({"attribute": "email"}, "agent_id")
    assert not is_pk_attr({"attribute": "email", "tags": "pii"}, "agent_id")
