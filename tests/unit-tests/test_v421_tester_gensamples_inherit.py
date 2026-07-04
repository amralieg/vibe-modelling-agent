import json
import os
import re
import textwrap

_REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
_TESTER = os.path.join(_REPO, "tests", "vibe_tester.ipynb")


def _tester_cell0_src():
    nb = json.load(open(_TESTER))
    for c in nb["cells"]:
        if c["cell_type"] == "code":
            src = "".join(c["source"])
            if "def _build_gen_samples" in src:
                return src
    raise AssertionError("_build_gen_samples not found in any tester code cell")


def _extract_func(src, name):
    lines = src.splitlines()
    start = None
    indent = None
    for i, ln in enumerate(lines):
        m = re.match(r"^(\s*)def %s\b" % re.escape(name), ln)
        if m:
            start = i
            indent = len(m.group(1))
            break
    assert start is not None, f"def {name} not found"
    body = [lines[start]]
    for ln in lines[start + 1:]:
        if ln.strip() == "":
            body.append(ln)
            continue
        cur = len(ln) - len(ln.lstrip())
        if cur <= indent:
            break
        body.append(ln)
    return textwrap.dedent("\n".join(body))


def _make_ns():
    # Stub every global the closure references. The random helpers return
    # sentinel values so we can prove inheritance overrides them.
    def _random_conventions(test_id=""):
        return {
            "naming_convention": "RANDOM_NC",
            "primary_key_suffix": "RANDOM_PK",
            "schema_prefix": "RANDOM_SP",
            "schema_suffix": "RANDOM_SS",
            "tag_prefix": "RANDOM_TP",
            "tag_suffix": "RANDOM_TS",
            "table_id_type": "RANDOM_TID",
            "boolean_format": "RANDOM_BF",
            "date_format": "RANDOM_DF",
            "timestamp_format": "RANDOM_TF",
            "classification_levels": "RANDOM_CL",
            "housekeeping_columns": "RANDOM_HK",
            "history_tracking_columns": "RANDOM_HT",
        }

    def _random_catalog_widgets(test_id=""):
        return {
            "cataloging_style": "RANDOM_STYLE",
            "catalog_prefix": "RANDOM_CP",
            "catalog_suffix": "RANDOM_CS",
        }

    return {
        "_random_conventions": _random_conventions,
        "_random_catalog_widgets": _random_catalog_widgets,
        "_gen_session_id": lambda: "SID",
        "_samples": lambda: "3",
        "w_business_name": "brew_haven",
        "w_business_description": "desc",
        "w_model_vibes": "",
    }


_INSTALL_PARAMS = {
    "cataloging_style": "Catalog per Domain",
    "catalog_prefix": "t04_instmv1_",
    "catalog_suffix": "_catalog",
    "schema_prefix": "dw_",
    "schema_suffix": "_zone",
    "naming_convention": "snake_case",
    "primary_key_suffix": "_id",
    "tag_prefix": "dbx_",
    "table_id_type": "STRING",
    "boolean_format": "String (Y/N)",
    "housekeeping_columns": "No",
    "history_tracking_columns": "Yes",
}

# Resolution-affecting keys that MUST match the install for gen-samples to
# target the same physical FQN the install created.
_RESOLUTION_KEYS = (
    "cataloging_style", "catalog_prefix", "catalog_suffix",
    "schema_prefix", "schema_suffix", "naming_convention", "primary_key_suffix",
)


def _build_and_call(install_params):
    src = _tester_cell0_src()
    fn_src = _extract_func(src, "_build_gen_samples")
    ns = _make_ns()
    exec(fn_src, ns)
    return ns["_build_gen_samples"](5, "1", "mvm", "deploy_cat", "/vol/model.json",
                                    install_params=install_params)["params"]


def test_signature_accepts_install_params():
    src = _tester_cell0_src()
    assert "def _build_gen_samples(test_num, version, scope, deploy_catalog, model_json_path, install_params=None)" in src, \
        "builder must accept install_params (post-fix signature)"


def test_alias_sentinel_present():
    src = _tester_cell0_src()
    assert "v421-tester-gensamples-inherit-install-conventions" in src, \
        "alias sentinel must be present for audit grep"


def test_post_fix_inherits_install_conventions():
    params = _build_and_call(_INSTALL_PARAMS)
    for k in _RESOLUTION_KEYS:
        assert params[k] == _INSTALL_PARAMS[k], \
            f"gen-samples param '{k}'={params[k]!r} must inherit install value {_INSTALL_PARAMS[k]!r}"
    # And it must NOT have used the random sentinels for those keys.
    for k in _RESOLUTION_KEYS:
        assert not str(params[k]).startswith("RANDOM_"), \
            f"param '{k}' still random ({params[k]!r}) — inheritance did not fire"


def test_fallback_random_when_no_install_params():
    # Pre-fix behavior path: without install_params, the builder must fall back
    # to the random helpers (proves the inheritance branch is conditional, not
    # a tautology that always returns install values).
    params = _build_and_call(None)
    assert params["cataloging_style"] == "RANDOM_STYLE"
    assert params["schema_prefix"] == "RANDOM_SP"
    assert params["naming_convention"] == "RANDOM_NC"


def test_pre_patch_random_would_mismatch_install():
    # Fail-pre proof: the OLD logic (always random) produces conventions that
    # DIFFER from the install, which is exactly what caused 05b to see 0 rows.
    ns = _make_ns()
    random_params = {}
    random_params.update(ns["_random_conventions"]())
    random_params.update(ns["_random_catalog_widgets"]())
    mismatches = [k for k in _RESOLUTION_KEYS if random_params[k] != _INSTALL_PARAMS[k]]
    assert mismatches == list(_RESOLUTION_KEYS), \
        "pre-patch random conventions must mismatch install on every resolution key"
