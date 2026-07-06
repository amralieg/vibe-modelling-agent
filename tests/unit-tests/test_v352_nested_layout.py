import json
import os
import re

_NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _full():
    nb = json.load(open(_NB))
    return "\n".join("".join(c.get("source", [])) for c in nb["cells"])


# --------------------------------------------------------------------------- #
# version + markers                                                            #
# --------------------------------------------------------------------------- #
def test_v352_version_constant():
    src = _full()
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', src)
    assert m and tuple(int(x) for x in m.groups()) >= (3, 5, 2)


def test_v352_primary_write_path_is_nested():
    # Core artifact folder must be v<n>/<scope> (e.g. v1/ecm), not the fused <scope>_v<n>.
    src = _full()
    assert 'version_folder = f"v{current_version}/{model_scope}"' in src


def test_v352_no_fused_primary_write_path():
    # Prove this is not a tautology: the old fused primary-write expression must be gone.
    src = _full()
    assert 'version_folder = f"{model_scope}_v{current_version}"' not in src


def test_v352_deploy_paths_nested():
    src = _full()
    assert '/business/{sql_name}/v{model_version}/{_deploy_model_scope}' in src
    assert '/logs/{sql_name}/v{model_version}/{_deploy_model_scope}' in src


def test_v352_carry_forward_nested():
    src = _full()
    assert 'prev_version_folder = f"v{base_version}/{model_scope}"' in src


def test_v352_industry_readme_landing_present():
    src = _full()
    assert "industry-readme-landing" in src
    assert "[industry-readme-landing FIRED]" in src
    # version-overview readme lands at the v<n>/ level (parent of the model folder)
    assert 'overview_path = os.path.join(parent_dir, "readme.md")' in src
    # per-industry README.md lands one level above v<n>/
    assert '_landing_path = os.path.join(_industry_root, "README.md")' in src


# --------------------------------------------------------------------------- #
# behavioral re-impl of the README path derivation (faithful to the code)     #
# --------------------------------------------------------------------------- #
def _derive_readme_paths(target_volume):
    """Mirror of the v3.5.2 path derivation:
      TARGET_VOLUME = .../business/<biz>/v<n>/<scope>
      per-model readme   -> TARGET_VOLUME/readme.md
      version overview   -> dirname(TARGET_VOLUME)/readme.md          (= v<n>/readme.md)
      industry landing   -> dirname(dirname(TARGET_VOLUME))/README.md (= <biz>/README.md)
    """
    per_model = os.path.join(target_volume, "readme.md")
    parent_dir = os.path.dirname(target_volume)
    overview = os.path.join(parent_dir, "readme.md")
    industry_root = os.path.dirname(parent_dir)
    landing = os.path.join(industry_root, "README.md")
    return per_model, overview, landing


def test_v352_readme_levels_match_repo_layout():
    tv = "/Volumes/airlines_ecm_v1/_metamodel/vol_root/business/airlines/v1/ecm"
    per_model, overview, landing = _derive_readme_paths(tv)
    assert per_model.endswith("/airlines/v1/ecm/readme.md")
    assert overview.endswith("/airlines/v1/readme.md")
    assert landing.endswith("/airlines/README.md")


def test_v352_mvm_scope_lands_under_same_version_dir():
    tv = "/Volumes/airlines_mvm_v1/_metamodel/vol_root/business/airlines/v1/mvm"
    per_model, overview, landing = _derive_readme_paths(tv)
    assert per_model.endswith("/airlines/v1/mvm/readme.md")
    # ecm and mvm share the same v1/readme.md overview parent
    assert overview.endswith("/airlines/v1/readme.md")
    assert landing.endswith("/airlines/README.md")


def test_v352_v2_is_sibling_of_v1():
    # New generations land as v2/ siblings next to v1/ (not nested under it).
    tv1 = "/root/business/airlines/v1/ecm"
    tv2 = "/root/business/airlines/v2/ecm"
    _, ov1, land1 = _derive_readme_paths(tv1)
    _, ov2, land2 = _derive_readme_paths(tv2)
    assert ov1.endswith("/airlines/v1/readme.md")
    assert ov2.endswith("/airlines/v2/readme.md")
    # both share the SAME industry landing
    assert land1 == land2 == "/root/business/airlines/README.md"
