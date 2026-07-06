#!/usr/bin/env python3
"""Finish the 5 in-flight single-task VOV canaries: monitor vov -> shrink -> export.

These canaries were submitted as standalone single-task `vibe modeling of version`
jobs (name dbx_vibe_<ind>_vibe_modeling_of_version_ecm) with NO task timeout, so they
run to functional completion. This driver does NOT drop/recreate their catalogs (that
would destroy live progress); it only reads artifacts, submits a follow-on shrink, and
exports. Remaining (non-canary) industries are handled by vov_v2_marathon.py.
"""
import json
import os
import sys
import threading
import time
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vov_v2_marathon as M  # reuse db/dbj/export_industry/AGENT_PATH/pulse/now/cat_name

CANARIES = {
    "travel_hospitality": ("fe-gcp", 1090375305579926),
    "ngo": ("fe-aws", 1038474851523515),
    "restaurants": ("my-gcp", 928273654399800),
    "water_utilities": ("my-adp", 198227957962821),
    "construction": ("my-uae", 27912144474758),
}

POLL_S = 120
PULSE_S = 900            # 15-min pulse cadence
# Completion is the RUN reaching TERMINATED (guarantees model.json final + catalog installed +
# next_vibes written). next_vibes.txt appears MID-pipeline (during VALIDATE, before physical-schema
# install), so file-presence is NOT a valid 'done' signal — using it submitted shrink prematurely
# and raced vov on the same catalog. The hang-guard (model.json present + log idle this long) is the
# ONLY early-exit, reserved for a genuine GIL teardown-hang where the run never terminates.
HANG_GRACE_S = 1800      # 30m of TRUE log silence + model.json present => teardown-hang -> cancel & advance
# Shrink functional completion (ECM->MVM up to mvm model.json) measured 06-10: fe-gcp travel ~83m,
# my-gcp restaurants ~66m, my-uae construction >90m (slow workspace, missed old 90m cap mid-subdomain
# -> KPI MV gen). 2h gives the slowest workspaces functional headroom; the hang-guard (mj=True + 30m
# substantive idle) still bounds any post-mvm teardown hang, so a larger cap is pure upside.
SHRINK_TIMEOUT_S = 7200  # 120m platform cap on the shrink follow-on task


def vol_logpath(ind, scope):
    cat = M.cat_name(ind)
    return f"dbfs:/Volumes/{cat}/_metamodel/vol_root/logs/{ind}/v2/{scope}/{ind}_info_v2_{scope}.log"


def vol_artifact_dir(ind, scope):
    cat = M.cat_name(ind)
    return f"dbfs:/Volumes/{cat}/_metamodel/vol_root/business/{ind}/v2/{scope}"


def ls(profile, path):
    try:
        out = M.db(["fs", "ls", path], profile, timeout=60)
        return [l.split()[-1] for l in out.strip().splitlines() if l.strip()]
    except Exception:
        return []


def artifacts_ready(profile, ind, scope):
    """model.json + vibes/next_vibes.txt both present => finalization wrote a complete model."""
    base = vol_artifact_dir(ind, scope)
    top = ls(profile, base)
    if "model.json" not in top:
        return False
    nv = ls(profile, f"{base}/vibes")
    return any("next_vibes" in f for f in nv)


import datetime as _dt
import re as _re

_TS_RE = _re.compile(r"^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})")


def substantive_idle_s(profile, ind, scope):
    """Seconds since the last SUBSTANTIVE (non-flush) timestamped log line.

    The background flusher emits '[VolumeLogFlush]' lines every few seconds, which grow the
    file even when the main thread is hung — so raw file-size deltas cannot detect a hang.
    Real progress is a timestamped INFO line that is NOT a flush line. Returns -1 if unknown
    (treated as 'active' so the hang-guard never fires on a transient download failure).
    """
    lf = f"/tmp/idle_{ind}_{scope}.log"
    try:
        M.db(["fs", "cp", vol_logpath(ind, scope), lf, "--overwrite"], profile, timeout=120)
    except Exception:
        return -1
    try:
        last_ts = None
        with open(lf, errors="ignore") as fh:
            for line in fh:
                if "VolumeLogFlush" in line:
                    continue
                m = _TS_RE.match(line)
                if m:
                    last_ts = m.group(1)
        if not last_ts:
            return -1
        t = _dt.datetime.strptime(last_ts, "%Y-%m-%d %H:%M:%S").replace(tzinfo=_dt.timezone.utc)
        return max(0, int((_dt.datetime.now(_dt.timezone.utc) - t).total_seconds()))
    except Exception:
        return -1


def run_state(profile, run_id):
    try:
        info = M.get_run(profile, run_id)
        return info["lc"], info.get("result")
    except Exception:
        return None, None


def submit_shrink(profile, ind):
    cat = M.cat_name(ind)
    desc = M.industry_desc(ind)
    params = {"business_name": ind, "business_description": desc,
              "deployment_catalog": cat, "generate_samples": "0",
              "operation": "shrink ecm", "model_version": "2",
              "data_model_scopes": M.MVM_SCOPE, "model_vibes": "", "context_file": ""}
    spec = {"name": f"dbx_vibe_shrink2_{ind}",
            "timeout_seconds": SHRINK_TIMEOUT_S + 600,
            "max_concurrent_runs": 1,
            "tasks": [{"task_key": "shrink",
                       "notebook_task": {"notebook_path": M.AGENT_PATH, "source": "WORKSPACE",
                                         "base_parameters": params},
                       "timeout_seconds": SHRINK_TIMEOUT_S}]}
    sp = f"/tmp/vov_shrinkspec_{ind}.json"
    Path(sp).write_text(json.dumps(spec))
    # find existing job by name or create
    jobs = M.dbj(["jobs", "list", "--limit", "100"], profile)
    items = jobs if isinstance(jobs, list) else jobs.get("jobs", [])
    job_id = None
    for j in items:
        if (j.get("settings", {}) or {}).get("name") == spec["name"]:
            job_id = j["job_id"]
            patch = {"job_id": job_id, "new_settings": spec}
            pp = f"/tmp/vov_shrinkpatch_{ind}.json"
            Path(pp).write_text(json.dumps(patch))
            M.db(["jobs", "reset", "--json", f"@{pp}"], profile)
            break
    if job_id is None:
        res = M.dbj(["jobs", "create", "--json", f"@{sp}"], profile)
        job_id = res["job_id"]
    res = M.dbj(["jobs", "run-now", str(job_id), "--no-wait"], profile)
    return job_id, res["run_id"]


def wait_for_completion(ind, profile, run_id, scope, phase):
    """Block until the run for `scope` (ecm|mvm) is functionally complete.

    Returns: 'done' (run TERMINATED + model.json present),
             'hang_done' (teardown-hang: model.json present + log idle HANG_GRACE_S -> run cancelled),
             'failed' (run terminal without model.json),
             'kill' (KILL file).
    Authoritative signal is the RUN reaching a terminal state — NOT file presence (next_vibes.txt
    is written mid-pipeline, before the physical-schema/catalog install completes).
    """
    last_pulse = 0
    while not M.os.path.exists(M.KILL_FILE):
        lc, rs = run_state(profile, run_id)
        has_mj = "model.json" in ls(profile, vol_artifact_dir(ind, scope))
        if lc in ("TERMINATED", "INTERNAL_ERROR", "SKIPPED"):
            if has_mj:
                M.pulse(f"[{ind}] {phase} run terminal lc={lc}/{rs} + model.json present -> done")
                return "done"
            M.pulse(f"[{ind}] {phase} run terminal lc={lc}/{rs} but NO model.json -> FAILED")
            return "failed"
        # idle = seconds since last NON-flush log line (flush noise cannot mask a hang)
        idle = substantive_idle_s(profile, ind, scope)
        if lc in ("RUNNING", "PENDING") and has_mj and idle >= 0 and idle > HANG_GRACE_S:
            M.pulse(f"[{ind}] {phase} model.json present + substantive log idle {int(idle/60)}m "
                    f"(hang) -> cancel & advance")
            try:
                M.db(["jobs", "cancel-run", str(run_id)], profile, timeout=120)
            except Exception:
                pass
            return "hang_done"
        if time.time() - last_pulse >= PULSE_S:
            M.pulse(f"[{ind}] {profile} {phase} lc={lc} idle={idle if idle>=0 else '?'}s mj={has_mj}")
            last_pulse = time.time()
        time.sleep(POLL_S)
    return "kill"


def drive(ind, profile, vov_run_id, state):
    def setk(**kv):
        M.set_ind(state, ind, **kv)

    M.pulse(f"[{ind}] DRIVER start vov_run={vov_run_id} profile={profile}")

    # ---- Phase 1: wait for vov (ECM) to fully complete ----
    if artifacts_ready(profile, ind, "ecm") and run_state(profile, vov_run_id)[0] in (
            "TERMINATED", "INTERNAL_ERROR", "SKIPPED"):
        M.pulse(f"[{ind}] ecm already complete")
    else:
        res = wait_for_completion(ind, profile, vov_run_id, "ecm", "vov")
        if res == "kill":
            return
        if res == "failed":
            setk(status="red_vov_no_artifact")
            return
    setk(status="ecm_done")

    # ---- Phase 2: submit + wait shrink (MVM) ----
    if "model.json" in ls(profile, vol_artifact_dir(ind, "mvm")):
        M.pulse(f"[{ind}] mvm already present — skip shrink")
    else:
        try:
            sjob, srun = submit_shrink(profile, ind)
            setk(status="shrink_running", shrink_job=sjob, shrink_run=srun)
            M.pulse(f"[{ind}] shrink submitted job={sjob} run={srun}")
        except Exception as e:
            M.pulse(f"[{ind}] SHRINK SUBMIT FAILED: {str(e)[:240]}")
            setk(status="shrink_submit_failed", error=str(e)[:240])
            srun = None
        if srun:
            res = wait_for_completion(ind, profile, srun, "mvm", "shrink")
            if res == "kill":
                return

    # ---- Phase 3: export ----
    got = M.export_industry(profile, ind)
    status = "green" if (got.get("ecm") and got.get("mvm")) else ("partial" if got.get("ecm") else "red")
    setk(status=status, exported=got)
    M.pulse(f"[{ind}] {status.upper()} exported ecm={got.get('ecm')} mvm={got.get('mvm')}")


def main():
    state = M.load_state()
    threads = []
    for ind, (profile, rid) in CANARIES.items():
        t = threading.Thread(target=drive, args=(ind, profile, rid, state), name=ind, daemon=False)
        t.start()
        threads.append(t)
    for t in threads:
        t.join()
    inds = state.get("industries", {})
    green = [i for i in CANARIES if inds.get(i, {}).get("status") == "green"]
    M.pulse(f"=== CANARY FINISH DONE green={len(green)}/5 :: {sorted(green)} ===")


if __name__ == "__main__":
    main()
