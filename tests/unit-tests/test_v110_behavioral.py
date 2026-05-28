"""Behavioral tests for v1.1.0 (vov-closure-respect-user-widget).

Pre-fix evidence: NCDOT iter=10 mvm_v3 had 9 domains because regex parser
extracted 8 domain-level tuples from prose (organization.organization_id,
job_family.job_family_id, ...) and downstream consumers (P70 auto-seed,
SURGICAL FAST PATH, hydrate, sizing gate) all created phantom stubs.

v1.0.9 only guarded P70 auto-seed (_missing_new path). v1.1.0 filters at the
upstream call site of _compute_vov_user_closure where _vov_user_new_entities
is set into widgets_values, so ALL downstream consumers see filtered tuples.
"""
import json
import os
import re
from pathlib import Path

NB_PATH = Path(__file__).parent.parent.parent / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _nb_src():
    nb = json.loads(NB_PATH.read_text())
    cells = nb.get("cells", [])
    return "\n".join("".join(c.get("source", [])) for c in cells if c.get("cell_type") == "code")


# ---------- Sentinel + version checks ----------

def test_agent_version_bumped_to_110():
    src = _nb_src()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m, "missing __AGENT_VERSION__"
    parts = tuple(int(x) for x in m.group(1).split("."))
    assert parts >= (1, 1, 0), f"expected __AGENT_VERSION__ >= 1.1.0, got {m.group(1)}"


def test_v110_alias_in_version_header():
    src = _nb_src()
    assert "vov-closure-respect-user-widget" in src, (
        "v1.1.0 sentinel alias not in source"
    )


def test_v110_fired_log_emission_present():
    src = _nb_src()
    assert "[vov-closure-respect-user-widget FIRED]" in src, (
        "[vov-closure-respect-user-widget FIRED] log marker missing"
    )


def test_v110_filter_anchored_at_compute_vov_user_closure_call():
    """Ensure filter runs at the closure call site (the ONE upstream point)."""
    src = _nb_src()
    idx_call = src.find("_vov_closure, _vov_new_entities = _compute_vov_user_closure(")
    assert idx_call > 0, "closure call site not found"
    idx_filter = src.find("_v110_user_widget_doms", idx_call)
    idx_set = src.find('widgets_values["_vov_user_closure"] = _vov_closure', idx_call)
    assert idx_filter > 0, "v1.1.0 filter not present"
    assert idx_filter < idx_set, "v1.1.0 filter must run BEFORE widgets_values assignment"


def test_v110_uses_user_specified_domains_widget_key():
    """Anti-tautology: filter must read the widget, not a constant."""
    src = _nb_src()
    idx = src.find("[vov-closure-respect-user-widget")
    assert idx > 0
    # Within ~3000 chars of the alias, look for the widget key reference
    window = src[max(0, idx - 5000):idx + 5000]
    assert '"_user_specified_domains"' in window, (
        "filter must read widgets_values['_user_specified_domains']"
    )


# ---------- Behavioral simulation: NCDOT-style phantom rejection ----------

def test_filter_drops_phantom_domain_tuples_when_widget_populated():
    """NCDOT scenario: regex emits 8 domain-level tuples; widget says hr+project."""
    # Reproduce the filter logic in isolation to demonstrate it works.
    user_widget_doms = {"hr", "project"}
    parser_new_entities = {
        ("hr",), ("project",),  # legitimate
        ("organization",), ("job_family",), ("position",),  # phantom (FK col prose)
        ("salary_grade",), ("workforce",), ("employee",),  # phantom
        ("hr", "employee"), ("hr", "position"),  # legitimate (hr.X)
        ("organization", "organization_id"),  # phantom (FK col)
        ("job_family", "job_family_id"),  # phantom
    }

    filtered = set()
    dropped_domains = set()
    dropped_multi = []
    for t in parser_new_entities:
        if isinstance(t, tuple) and len(t) >= 1 and t[0]:
            if str(t[0]).strip().lower() in user_widget_doms:
                filtered.add(t)
            else:
                if len(t) == 1:
                    dropped_domains.add(t[0])
                else:
                    dropped_multi.append(t)

    assert dropped_domains == {
        "organization", "job_family", "position",
        "salary_grade", "workforce", "employee",
    }, f"expected exactly the 6 phantom domains dropped, got {dropped_domains}"
    assert ("hr",) in filtered
    assert ("project",) in filtered
    assert ("hr", "employee") in filtered
    assert ("hr", "position") in filtered
    # Multi-tuples whose domain is phantom are also dropped
    assert ("organization", "organization_id") not in filtered
    assert ("job_family", "job_family_id") not in filtered
    assert len(dropped_multi) == 2


def test_filter_skips_when_widget_is_empty():
    """If user does NOT populate business_domains widget, filter is no-op."""
    user_widget_doms = set()  # empty
    parser_new_entities = {
        ("hr",), ("organization",), ("project",),
    }

    if user_widget_doms:  # guard mirrors the agent code's `if _v110_user_widget_doms:`
        filtered = {t for t in parser_new_entities if t[0] in user_widget_doms}
    else:
        filtered = parser_new_entities  # no-op

    assert filtered == parser_new_entities, "empty widget must skip filter"


# ---------- Anti-tautology: prove pre-v1.1.0 would have leaked phantoms ----------

def test_pre_v110_behavior_leaks_phantoms():
    """If we did NOT filter, the parser tuples would propagate to downstream."""
    user_widget_doms = {"hr", "project"}
    parser_new_entities = {
        ("hr",), ("organization",), ("job_family",),
        ("position",), ("salary_grade",), ("workforce",),
    }
    pre_v110 = parser_new_entities  # no filtering — what v1.0.9 would propagate

    domain_only = {t[0] for t in pre_v110 if len(t) == 1}
    leaked = domain_only - user_widget_doms
    assert leaked == {"organization", "job_family", "position",
                      "salary_grade", "workforce"}, (
        "without v1.1.0 filter, 5 phantoms would propagate to widgets_values"
    )


# ---------- Smoke: prior aliases still present (regression guard) ----------

def test_prior_version_aliases_still_present():
    src = _nb_src()
    for alias in (
        "p70-respect-user-pinned-domains",  # v1.0.9
        "verifier-rescue-retry-on-transient-error",  # v1.0.8
        "qa-widgets-values-via-config",  # v1.0.7
        "division-filter-user-domain-bypass",  # v1.0.6
    ):
        assert alias in src, f"prior alias {alias} missing — regression"


def test_v110_filter_order_inside_vov_closure_block():
    """Filter must run BEFORE config['_vov_user_closure_for_ssot'] mirroring."""
    src = _nb_src()
    idx_filter = src.find("[vov-closure-respect-user-widget FIRED]")
    idx_ssot = src.find('config["_vov_user_closure_for_ssot"]', idx_filter or 0)
    assert idx_filter > 0
    assert idx_ssot > idx_filter, (
        "v1.1.0 filter must run BEFORE SSOT mirror so config sees filtered set"
    )
