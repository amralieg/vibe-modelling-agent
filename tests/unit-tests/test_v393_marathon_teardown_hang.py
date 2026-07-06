import importlib.util
import os

_HERE = os.path.dirname(__file__)
_MARATHON = os.path.abspath(os.path.join(_HERE, "..", "..", "runner", "vov_v2_marathon.py"))


def _load():
    spec = importlib.util.spec_from_file_location("vov_v2_marathon_thm", _MARATHON)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def _info_vov_running():
    return {"lc": "RUNNING", "tasks": [{"k": "vov", "lc": "RUNNING", "r": None}]}


def _ind(dir_path):
    # .../logs/<ind>/v2/ecm
    parts = dir_path.split("/")
    return parts[parts.index("logs") + 1]


def _patch_volume(mod, monkeypatch, model_present, log_mtime, log_tail):
    # state captures BOTH any cancel-run (must stay empty: observe-only never cancels) and the
    # pulse lines (so we can assert the teardown-hang was DETECTED + logged without cancellation).
    state = {"cancelled": [], "pulses": []}

    def fake_ls(profile, dir_path, timeout=120):
        if "/business/" in dir_path:
            return [{"name": "model.json"}] if model_present else []
        # live CLI field name is `last_modified` (ISO string), not `modification_time`
        return [{"name": f"{_ind(dir_path)}_info_v2_ecm.log", "last_modified": log_mtime}]

    def fake_db(args, profile, timeout=300):
        if args[:2] == ["fs", "cp"]:
            with open(args[3], "w") as f:
                f.write(log_tail)
            return ""
        if args[:2] == ["jobs", "cancel-run"]:
            state["cancelled"].append(args[2])
            return ""
        return ""

    monkeypatch.setattr(mod, "_ls_json", fake_ls)
    monkeypatch.setattr(mod, "db", fake_db)
    monkeypatch.setattr(mod, "pulse", lambda *a, **k: state["pulses"].append(a[0] if a else ""))
    monkeypatch.setattr(mod, "cat_name", lambda ind: f"vibe_{ind}_v1")
    return state


def _detected(state):
    return any("TEARDOWN-HANG DETECTED (observe-only)" in p for p in state["pulses"])


PKW_TAIL = (
    "2026-06-19 21:16:15 - WARNING - [process-kill-watchdog ARM-LOG FIRED v3.7.1] "
    "source=pipeline-finally grace=300s pkw_grace=360s pid=2819 alias=pkw-arm-volume-log\n"
)

# The LIVE restaurants hang (run <run_id>) ended at exactly these two lines and never
# reached the pkw watchdog. The teardown-hang signature is real, but the marathon must NOT
# cancel: a run-level cancel-run cancels the WHOLE run, so the dependent shrink task goes
# UPSTREAM_CANCELED and the MVM stage is LOST. Instead, the vov task rides its 15h task timeout
# and shrink/MVM runs via run_if=ALL_DONE -> the run ends on its own with full ECM+MVM.
REAL_RESTAURANTS_TAIL = (
    "2026-06-19 21:16:15 - INFO - [JobTags] Updated job tags via sdk (job_id=1107209318913654): "
    "{'dbx_vibe_modelling_domains': '14', 'dbx_vibe_modelling_products': '293'}\n"
    "[VolumeLogFlush][FINAL-FLUSH] periodic_flushes=640 alias=log-no-truncate-on-success\n"
    "[VolumeLogFlush][SAFE-FLUSH] dst=.../restaurants_info_v2_ecm.log prev=1389169 cur=1389981 "
    "delta=+812 alias=log-no-truncate-on-success\n"
)


def _drive_to_stall(mod, monkeypatch, ind, rid, hs):
    """Advance the clock through 3 detector ticks: first record, anchor flatline, exceed HANG_STALL_S."""
    t = [1000.0]
    monkeypatch.setattr(mod.time, "time", lambda: t[0])
    r1 = mod._vov_teardown_hang_cancel("p", ind, rid, _info_vov_running(), hs)
    t[0] += mod.HANG_CHECK_S + 1
    r2 = mod._vov_teardown_hang_cancel("p", ind, rid, _info_vov_running(), hs)
    t[0] += mod.HANG_STALL_S + mod.HANG_CHECK_S + 1
    r3 = mod._vov_teardown_hang_cancel("p", ind, rid, _info_vov_running(), hs)
    return r1, r2, r3


def test_detects_hang_but_never_cancels_pkw_signature(monkeypatch):
    # Observe-only contract: a clear teardown-hang (model.json + flatline + pkw finalization marker)
    # is DETECTED and logged, but NO cancel-run is ever issued and the function returns False.
    mod = _load()
    state = _patch_volume(mod, monkeypatch, model_present=True, log_mtime="111111", log_tail=PKW_TAIL)
    r1, r2, r3 = _drive_to_stall(mod, monkeypatch, "ngo", "RID1", {})
    assert (r1, r2, r3) == (False, False, False)
    assert state["cancelled"] == []          # the MVM-preserving invariant: NEVER cancel the run
    assert _detected(state)                   # but the hang IS surfaced for the operator


def test_detects_hang_but_never_cancels_real_restaurants_signature(monkeypatch):
    # The real restaurants signature (FINAL-FLUSH + JobTags, NO pkw pair) must be DETECTED yet
    # NOT cancelled — this is the exact run whose early cancel previously cost the MVM stage.
    mod = _load()
    assert "process-kill-watchdog ARM-LOG FIRED" not in REAL_RESTAURANTS_TAIL
    assert "source=pipeline-finally" not in REAL_RESTAURANTS_TAIL
    state = _patch_volume(mod, monkeypatch, model_present=True,
                          log_mtime="2026-06-19T22:16:15.557+01:00", log_tail=REAL_RESTAURANTS_TAIL)
    r1, r2, r3 = _drive_to_stall(mod, monkeypatch, "restaurants", "RIDR", {})
    assert (r1, r2, r3) == (False, False, False)
    assert state["cancelled"] == []
    assert _detected(state)


def test_no_detect_no_cancel_when_log_still_advancing(monkeypatch):
    mod = _load()
    state = {"cancelled": [], "pulses": []}
    mt = [111111]

    def fake_ls(profile, dir_path, timeout=120):
        if "/business/" in dir_path:
            return [{"name": "model.json"}]
        return [{"name": f"{_ind(dir_path)}_info_v2_ecm.log", "last_modified": str(mt[0])}]

    monkeypatch.setattr(mod, "_ls_json", fake_ls)
    # v4.0.7 marathon-harvest-latest-version added latest_version(profile, ind) INSIDE the detector,
    # which issues benign `db ["fs","ls",...]` version-discovery calls. Stub it to the version the
    # fake log uses ("v2") so (a) log_name == fake_ls's name and the advancing-log path is genuinely
    # exercised, and (b) only a real `jobs cancel-run` counts as a cancel (mirrors _patch_volume's
    # fake_db) -- the pre-v4.0.7 naive "append every db call" stub wrongly counted fs-ls as a cancel.
    monkeypatch.setattr(mod, "latest_version", lambda profile, ind: "v2")

    def _fake_db(args, profile, timeout=300):
        if args[:2] == ["jobs", "cancel-run"]:
            state["cancelled"].append(args[2])
        return ""

    monkeypatch.setattr(mod, "db", _fake_db)
    monkeypatch.setattr(mod, "pulse", lambda *a, **k: state["pulses"].append(a[0] if a else ""))
    monkeypatch.setattr(mod, "cat_name", lambda ind: f"vibe_{ind}_v1")
    hs = {}
    t = [1000.0]
    monkeypatch.setattr(mod.time, "time", lambda: t[0])
    for _ in range(6):
        t[0] += mod.HANG_CHECK_S + 1
        mt[0] += 5000  # log keeps advancing -> never stale
        assert mod._vov_teardown_hang_cancel("p", "ngo", "RID2", _info_vov_running(), hs) is False
    assert state["cancelled"] == []
    assert not _detected(state)


def test_no_detect_no_cancel_when_model_absent(monkeypatch):
    mod = _load()
    state = _patch_volume(mod, monkeypatch, model_present=False, log_mtime="111111", log_tail=PKW_TAIL)
    hs = {}
    t = [1000.0]
    monkeypatch.setattr(mod.time, "time", lambda: t[0])
    for _ in range(6):
        t[0] += mod.HANG_CHECK_S + mod.HANG_STALL_S + 1
        assert mod._vov_teardown_hang_cancel("p", "ngo", "RID3", _info_vov_running(), hs) is False
    assert state["cancelled"] == []
    assert not _detected(state)


def test_no_detect_no_cancel_without_finalization_marker(monkeypatch):
    mod = _load()
    state = _patch_volume(mod, monkeypatch, model_present=True, log_mtime="111111",
                          log_tail="2026-06-19 21:16:15 - INFO - [UC-DDL] still grinding\n")
    r1, r2, r3 = _drive_to_stall(mod, monkeypatch, "ngo", "RID4", {})
    assert (r1, r2, r3) == (False, False, False)
    assert state["cancelled"] == []
    assert not _detected(state)


def test_reads_last_modified_iso_field_not_modification_time(monkeypatch):
    # Regression: live `databricks fs ls -o json` reports mtime as `last_modified` (ISO string).
    # A detector that only reads `modification_time`/`mtime` gets None -> never anchors flatline ->
    # never DETECTS. Proven by the observe-only detection pulse firing on the ISO-only signature.
    mod = _load()
    state = _patch_volume(mod, monkeypatch, model_present=True,
                          log_mtime="2026-06-19T22:16:15.404+01:00", log_tail=PKW_TAIL)
    r1, r2, r3 = _drive_to_stall(mod, monkeypatch, "ngo", "RID6", {})
    assert (r1, r2, r3) == (False, False, False)
    assert state["cancelled"] == []
    assert _detected(state)


def test_no_detect_when_vov_not_running(monkeypatch):
    mod = _load()
    state = _patch_volume(mod, monkeypatch, model_present=True, log_mtime="111111", log_tail=PKW_TAIL)
    info = {"lc": "RUNNING", "tasks": [{"k": "vov", "lc": "TERMINATED", "r": "SUCCESS"}]}
    assert mod._vov_teardown_hang_cancel("p", "ngo", "RID5", info, {}) is False
    assert state["cancelled"] == []
    assert not _detected(state)
