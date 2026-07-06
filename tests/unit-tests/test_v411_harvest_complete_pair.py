import importlib.util
import os
import sys

_RUNNER = os.path.join(os.path.dirname(__file__), "..", "..", "runner", "vov_v2_marathon.py")


def _load_marathon():
    spec = importlib.util.spec_from_file_location("vov_v2_marathon_t", os.path.abspath(_RUNNER))
    mod = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = mod
    spec.loader.exec_module(mod)
    return mod


def _install_fakes(mod, layout):
    # layout: {"versions": [int,...], "complete": {ver_int: set(scopes_with_model_json)}}
    mod.pulse = lambda *a, **k: None
    mod.cat_name = lambda ind: "vibe_test_v1"

    def fake_db(args, profile, timeout=90):
        # args like ["fs", "ls", "<path>"]
        path = args[-1]
        tail = path.rstrip("/").split("/")
        # base listing: ".../business/<ind>"
        if tail[-2] == "business":
            return "\n".join(f"v{n}" for n in layout["versions"])
        # scope listing: ".../<ind>/v<N>/<scope>"
        scope = tail[-1]
        ver = tail[-2]
        n = int(ver[1:])
        if scope in layout["complete"].get(n, set()):
            return "model.json\nreadme.md"
        return "some_other_file.txt"

    mod.db = fake_db


def test_picks_latest_complete_pair_not_half_baked_max():
    # manufacturing-shaped pollution: v8 is the latest but ecm-only (mvm no-op'd);
    # v3 is the latest COMPLETE ecm+mvm pair. Must harvest v3, never the half-baked v8.
    mod = _load_marathon()
    _install_fakes(mod, {
        "versions": [1, 2, 3, 8],
        "complete": {1: {"ecm"}, 2: {"ecm", "mvm"}, 3: {"ecm", "mvm"}, 8: {"ecm"}},
    })
    assert mod.latest_version("<profile>", "manufacturing") == "v3"


def test_picks_max_when_all_complete():
    # healthy case: every version has the full pair -> latest wins, unchanged behaviour.
    mod = _load_marathon()
    _install_fakes(mod, {
        "versions": [1, 2, 3],
        "complete": {1: {"ecm", "mvm"}, 2: {"ecm", "mvm"}, 3: {"ecm", "mvm"}},
    })
    assert mod.latest_version("<profile>", "retail") == "v3"


def test_falls_back_to_ecm_only_when_no_complete_pair():
    # no version has mvm at all -> harvest the highest ecm-only version (honest partial, never crash).
    mod = _load_marathon()
    _install_fakes(mod, {
        "versions": [1, 2, 5],
        "complete": {1: {"ecm"}, 2: {"ecm"}, 5: {"ecm"}},
    })
    assert mod.latest_version("<profile>", "semiconductors") == "v5"
