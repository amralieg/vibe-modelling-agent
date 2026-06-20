import importlib.util
import os
import sys
import types

_HERE = os.path.dirname(__file__)
_MARATHON = os.path.abspath(os.path.join(_HERE, "..", "..", "runner", "vov_v2_marathon.py"))


def _load():
    spec = importlib.util.spec_from_file_location("vov_v2_marathon_thm", _MARATHON)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def _info_vov_running():
    return {"lc": "RUNNING", "tasks": [{"k": "vov", "lc": "RUNNING", "r": None}]}


def _patch_volume(mod, monkeypatch, model_present, log_mtime, log_tail):
    state = {"cancelled": []}

    def fake_ls(profile, dir_path, timeout=120):
        if "/business/" in dir_path:
            return [{"name": "model.json"}] if model_present else []
        # live CLI field name is `last_modified` (ISO string), not `modification_time`
        return [{"name": f"{_ind(dir_path)}_info_v2_ecm.log", "last_modified": log_mtime}]

    monkeypatch.setattr(mod, "_ls_json", fake_ls)

    def fake_db(args, profile, timeout=300):
        if args[:2] == ["fs", "cp"]:
            with open(args[3], "w") as f:
                f.write(log_tail)
            return ""
        if args[:2] == ["jobs", "cancel-run"]:
            state["cancelled"].append(args[2])
            return ""
        return ""

    monkeypatch.setattr(mod, "db", fake_db)
    monkeypatch.setattr(mod, "pulse", lambda *a, **k: None)
    monkeypatch.setattr(mod, "cat_name", lambda ind: f"vibe_{ind}_v1")
    return state


def _ind(dir_path):
    # .../logs/<ind>/v2/ecm
    parts = dir_path.split("/")
    return parts[parts.index("logs") + 1]


PKW_TAIL = (
    "2026-06-19 21:16:15 - WARNING - [process-kill-watchdog ARM-LOG FIRED v3.7.1] "
    "source=pipeline-finally grace=300s pkw_grace=360s pid=2819 alias=pkw-arm-volume-log\n"
)


def test_cancels_when_model_written_log_flat_and_pkw_marker(monkeypatch):
    mod = _load()
    state = _patch_volume(mod, monkeypatch, model_present=True, log_mtime=111111, log_tail=PKW_TAIL)
    hs = {}
    t = [1000.0]
    monkeypatch.setattr(mod.time, "time", lambda: t[0])
    # first observation: records mtime, no cancel
    assert mod._vov_teardown_hang_cancel("p", "ngo", "RID1", _info_vov_running(), hs) is False
    # advance past HANG_CHECK_S, mtime unchanged -> 'since' anchored
    t[0] = 1000.0 + mod.HANG_CHECK_S + 1
    assert mod._vov_teardown_hang_cancel("p", "ngo", "RID1", _info_vov_running(), hs) is False
    # advance past HANG_STALL_S of flatline -> cancel fires
    t[0] = t[0] + mod.HANG_STALL_S + mod.HANG_CHECK_S + 1
    fired = mod._vov_teardown_hang_cancel("p", "ngo", "RID1", _info_vov_running(), hs)
    assert fired is True
    assert state["cancelled"] == ["RID1"]


def test_no_cancel_when_log_still_advancing(monkeypatch):
    mod = _load()
    state = {"cancelled": []}
    mt = [111111]

    def fake_ls(profile, dir_path, timeout=120):
        if "/business/" in dir_path:
            return [{"name": "model.json"}]
        return [{"name": f"{_ind(dir_path)}_info_v2_ecm.log", "last_modified": str(mt[0])}]

    monkeypatch.setattr(mod, "_ls_json", fake_ls)
    monkeypatch.setattr(mod, "db", lambda *a, **k: state["cancelled"].append(a) or "")
    monkeypatch.setattr(mod, "pulse", lambda *a, **k: None)
    monkeypatch.setattr(mod, "cat_name", lambda ind: f"vibe_{ind}_v1")
    hs = {}
    t = [1000.0]
    monkeypatch.setattr(mod.time, "time", lambda: t[0])
    for _ in range(6):
        t[0] += mod.HANG_CHECK_S + 1
        mt[0] += 5000  # log keeps advancing -> never stale
        assert mod._vov_teardown_hang_cancel("p", "ngo", "RID2", _info_vov_running(), hs) is False
    assert state["cancelled"] == []


def test_no_cancel_when_model_absent(monkeypatch):
    mod = _load()
    state = _patch_volume(mod, monkeypatch, model_present=False, log_mtime=111111, log_tail=PKW_TAIL)
    hs = {}
    t = [1000.0]
    monkeypatch.setattr(mod.time, "time", lambda: t[0])
    for _ in range(6):
        t[0] += mod.HANG_CHECK_S + mod.HANG_STALL_S + 1
        assert mod._vov_teardown_hang_cancel("p", "ngo", "RID3", _info_vov_running(), hs) is False
    assert state["cancelled"] == []


def test_no_cancel_without_pkw_marker(monkeypatch):
    mod = _load()
    state = _patch_volume(mod, monkeypatch, model_present=True, log_mtime=111111,
                          log_tail="2026-06-19 21:16:15 - INFO - [UC-DDL] still grinding\n")
    hs = {}
    t = [1000.0]
    monkeypatch.setattr(mod.time, "time", lambda: t[0])
    assert mod._vov_teardown_hang_cancel("p", "ngo", "RID4", _info_vov_running(), hs) is False
    t[0] += mod.HANG_CHECK_S + 1
    assert mod._vov_teardown_hang_cancel("p", "ngo", "RID4", _info_vov_running(), hs) is False
    t[0] += mod.HANG_STALL_S + mod.HANG_CHECK_S + 1
    assert mod._vov_teardown_hang_cancel("p", "ngo", "RID4", _info_vov_running(), hs) is False
    assert state["cancelled"] == []


def test_reads_last_modified_iso_field_not_modification_time(monkeypatch):
    # Regression: live `databricks fs ls -o json` reports mtime as `last_modified` (ISO string).
    # A detector that only reads `modification_time`/`mtime` gets None -> never fires (silent no-op).
    mod = _load()
    state = {"cancelled": []}

    def fake_ls(profile, dir_path, timeout=120):
        if "/business/" in dir_path:
            return [{"name": "model.json"}]
        return [{"name": f"{_ind(dir_path)}_info_v2_ecm.log",
                 "last_modified": "2026-06-19T22:16:15.404+01:00"}]  # ONLY last_modified present

    monkeypatch.setattr(mod, "_ls_json", fake_ls)

    def fake_db(args, profile, timeout=300):
        if args[:2] == ["fs", "cp"]:
            with open(args[3], "w") as f:
                f.write(PKW_TAIL)
            return ""
        if args[:2] == ["jobs", "cancel-run"]:
            state["cancelled"].append(args[2])
        return ""

    monkeypatch.setattr(mod, "db", fake_db)
    monkeypatch.setattr(mod, "pulse", lambda *a, **k: None)
    monkeypatch.setattr(mod, "cat_name", lambda ind: f"vibe_{ind}_v1")
    hs = {}
    t = [1000.0]
    monkeypatch.setattr(mod.time, "time", lambda: t[0])
    assert mod._vov_teardown_hang_cancel("p", "ngo", "RID6", _info_vov_running(), hs) is False
    t[0] += mod.HANG_CHECK_S + 1
    assert mod._vov_teardown_hang_cancel("p", "ngo", "RID6", _info_vov_running(), hs) is False
    t[0] += mod.HANG_STALL_S + mod.HANG_CHECK_S + 1
    assert mod._vov_teardown_hang_cancel("p", "ngo", "RID6", _info_vov_running(), hs) is True
    assert state["cancelled"] == ["RID6"]


# The LIVE restaurants hang (run 83272126670362) ended at exactly these two lines and never
# reached the pkw watchdog. Before the gate-d broadening this tail returned False (false-negative
# no-op). After: any finalization marker (FINAL-FLUSH / JobTags) cancels.
REAL_RESTAURANTS_TAIL = (
    "2026-06-19 21:16:15 - INFO - [JobTags] Updated job tags via sdk (job_id=1107209318913654): "
    "{'dbx_vibe_modelling_domains': '14', 'dbx_vibe_modelling_products': '293'}\n"
    "[VolumeLogFlush][FINAL-FLUSH] periodic_flushes=640 alias=log-no-truncate-on-success\n"
    "[VolumeLogFlush][SAFE-FLUSH] dst=.../restaurants_info_v2_ecm.log prev=1389169 cur=1389981 "
    "delta=+812 alias=log-no-truncate-on-success\n"
)


def test_cancels_on_real_restaurants_signature_no_pkw_marker(monkeypatch):
    # Fail-pre/pass-post for the gate-d broadening: model.json written + 20m flatline + a genuine
    # finalization marker (FINAL-FLUSH/JobTags) but NO pkw pair must now fire the loss-free cancel.
    mod = _load()
    assert "process-kill-watchdog ARM-LOG FIRED" not in REAL_RESTAURANTS_TAIL
    assert "source=pipeline-finally" not in REAL_RESTAURANTS_TAIL
    state = _patch_volume(mod, monkeypatch, model_present=True, log_mtime="2026-06-19T22:16:15.557+01:00",
                          log_tail=REAL_RESTAURANTS_TAIL)
    hs = {}
    t = [1000.0]
    monkeypatch.setattr(mod.time, "time", lambda: t[0])
    assert mod._vov_teardown_hang_cancel("p", "restaurants", "RIDR", _info_vov_running(), hs) is False
    t[0] += mod.HANG_CHECK_S + 1
    assert mod._vov_teardown_hang_cancel("p", "restaurants", "RIDR", _info_vov_running(), hs) is False
    t[0] += mod.HANG_STALL_S + mod.HANG_CHECK_S + 1
    assert mod._vov_teardown_hang_cancel("p", "restaurants", "RIDR", _info_vov_running(), hs) is True
    assert state["cancelled"] == ["RIDR"]


def test_no_cancel_when_vov_not_running(monkeypatch):
    mod = _load()
    state = _patch_volume(mod, monkeypatch, model_present=True, log_mtime=111111, log_tail=PKW_TAIL)
    hs = {}
    monkeypatch.setattr(mod, "pulse", lambda *a, **k: None)
    info = {"lc": "RUNNING", "tasks": [{"k": "vov", "lc": "TERMINATED", "r": "SUCCESS"}]}
    assert mod._vov_teardown_hang_cancel("p", "ngo", "RID5", info, hs) is False
    assert state["cancelled"] == []
