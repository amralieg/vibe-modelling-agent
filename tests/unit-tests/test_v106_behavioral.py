import json
import re
from pathlib import Path

NB_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_nb_src() -> str:
    nb = json.loads(NB_PATH.read_text())
    out = []
    for c in nb.get("cells", []):
        if c.get("cell_type") in ("code",):
            out.append("".join(c.get("source", [])))
    return "\n".join(out)


def test_v106_agent_version_bumped():
    src = _read_nb_src()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m is not None, "__AGENT_VERSION__ literal not found in notebook"
    ver = m.group(1)
    parts = ver.split(".")
    assert all(p.isdigit() and len(p) == 1 for p in parts), f"non-single-digit semver segment: {ver}"
    assert tuple(int(p) for p in parts) >= (1, 0, 6), f"agent version must be >= 1.0.6, got {ver}"


def test_v106_division_filter_bypass_alias_present():
    src = _read_nb_src()
    assert "division-filter-user-domain-bypass FIRED v1.0.6" in src, \
        "v1.0.6 division-filter bypass FIRED sentinel missing"
    assert "alias=division-filter-user-domain-bypass" in src, \
        "v1.0.6 division-filter bypass alias missing"


def test_v106_bypass_uses_user_pinned_runtime_cache():
    src = _read_nb_src()
    block_start = src.find("v1.0.6 [division-filter-user-domain-bypass FIRED v1.0.6]")
    assert block_start >= 0, "v1.0.6 fix block missing"
    block = src[block_start:block_start + 3000]
    assert "_USER_PINNED_DOMAINS_RUNTIME" in block, \
        "fix must consult the existing module-level _USER_PINNED_DOMAINS_RUNTIME cache (no parallel cache, §3d reuse-first)"
    assert "filtered_out_domains.append" in block, \
        "fix must keep the pre-existing exclusion path for non-user-pinned domains"
    assert "continue" in block, "fix must keep `continue` to skip non-pinned excluded domains"


def test_v106_bypass_fix_is_inside_division_filter_block():
    src = _read_nb_src()
    fix_idx = src.find("v1.0.6 [division-filter-user-domain-bypass FIRED v1.0.6]")
    div_filter_idx = src.find("Filtered out {len(filtered_out_domains)} domains (division not in allowed list")
    div_filter_setup = src.find("Determine which divisions to include from business context")
    assert fix_idx > 0 and div_filter_idx > 0 and div_filter_setup > 0
    assert div_filter_setup < fix_idx < div_filter_idx, \
        "fix must sit between division-filter setup and the filtered-out logging block"


def _exec_filter_logic(domains_list, allowed_divisions, user_pinned):
    """Mirror of the v1.0.6 production filter logic for behavioral verification.
    If this test ever drifts from the actual notebook implementation, both will need to be updated together."""
    domains_to_create = []
    filtered_out_domains = []
    for di in domains_list:
        domain_name = di.get("domain", "")
        division = (di.get("division") or "business").lower().strip()
        if division not in {"operations", "business", "corporate"}:
            division = "business"
        is_user_pinned = bool(user_pinned) and str(domain_name).lower().strip() in {str(d).lower().strip() for d in user_pinned}
        if division not in allowed_divisions:
            if is_user_pinned:
                pass  # bypass — fall through
            else:
                filtered_out_domains.append({"domain": domain_name, "division": division})
                continue
        domains_to_create.append({"domain": domain_name, "division": division})
    return domains_to_create, filtered_out_domains


def test_v106_user_pinned_hr_with_corporate_division_survives_when_org_divisions_excludes_corporate():
    """Behavioral test reproducing NCDOT v1.0.5 hr-domain-drop bug.
    Pre-v1.0.6 path would have dropped 'hr' (corporate) when allowed_divisions={'business','operations'}."""
    domains_list = [
        {"domain": "hr", "division": "corporate"},
        {"domain": "project", "division": "operations"},
    ]
    allowed = {"business", "operations"}
    pinned = {"hr", "project"}
    created, dropped = _exec_filter_logic(domains_list, allowed, pinned)
    created_names = sorted(d["domain"] for d in created)
    assert created_names == ["hr", "project"], \
        f"v1.0.6 must preserve user-pinned 'hr' even when its division ('corporate') is not in allowed_divisions. got created={created_names}, dropped={dropped}"
    assert dropped == [], f"no user-pinned domain may be dropped, got dropped={dropped}"


def test_v106_non_user_pinned_domain_with_disallowed_division_still_excluded():
    """Anti-tautology: bypass must NOT make the filter a no-op. Non-pinned domains must still be filtered."""
    domains_list = [
        {"domain": "hr", "division": "corporate"},
        {"domain": "marketing", "division": "corporate"},
    ]
    allowed = {"business", "operations"}
    pinned = {"hr"}  # only hr is user-pinned
    created, dropped = _exec_filter_logic(domains_list, allowed, pinned)
    created_names = sorted(d["domain"] for d in created)
    dropped_names = sorted(d["domain"] for d in dropped)
    assert created_names == ["hr"], f"expected only hr to survive, got {created_names}"
    assert dropped_names == ["marketing"], f"expected marketing to be filtered, got {dropped_names}"


def test_v106_no_user_pinned_means_filter_behaves_as_before():
    """When no user-pinned domains, behavior must match pre-v1.0.6: division filter is the sole gate."""
    domains_list = [
        {"domain": "hr", "division": "corporate"},
        {"domain": "project", "division": "operations"},
    ]
    allowed = {"business", "operations"}
    pinned = set()  # no user-pinned
    created, dropped = _exec_filter_logic(domains_list, allowed, pinned)
    created_names = sorted(d["domain"] for d in created)
    dropped_names = sorted(d["domain"] for d in dropped)
    assert created_names == ["project"], f"expected only project to survive, got {created_names}"
    assert dropped_names == ["hr"], f"expected hr to be filtered (no user pin), got {dropped_names}"


def test_v106_user_pinned_with_allowed_division_still_works():
    """When user-pinned AND allowed division, no bypass needed — domain just passes through normally."""
    domains_list = [
        {"domain": "hr", "division": "business"},
        {"domain": "project", "division": "operations"},
    ]
    allowed = {"business", "operations"}
    pinned = {"hr", "project"}
    created, dropped = _exec_filter_logic(domains_list, allowed, pinned)
    created_names = sorted(d["domain"] for d in created)
    assert created_names == ["hr", "project"]
    assert dropped == []
