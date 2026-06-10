#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import threading
import time
from datetime import datetime, timezone
from pathlib import Path

AGENT_PATH = "/Users/amr.ali@databricks.com/dbx_vibe_modelling_agent_v353"
STAGE_DIR = "/tmp/vov_stage"
OUT_DIR = "/tmp/vov_out"
PULSE_FILE = os.path.expanduser("~/claude/vibe-agent/vov2_pulses.txt")
STATE_FILE = os.path.expanduser("~/claude/vibe-agent/vov2_state.json")
KILL_FILE = os.path.expanduser("~/claude/vibe-agent/vov2_KILL")

POLL_S = 120
PULSE_S = 900
JOB_TIMEOUT_S = 21600
INSTALL_TIMEOUT_S = 10800
VOV_TIMEOUT_S = 21600
SHRINK_TIMEOUT_S = 12600

ASSIGN = {
    "fe-gcp": ["travel_hospitality", "consumer_goods", "automotive"],
    "fe-aws": ["ngo", "retail", "healthcare"],
    "my-gcp": ["restaurants", "semiconductors", "media_broadcasting"],
    "my-adp": ["water_utilities", "manufacturing"],
    "my-uae": ["construction", "health_insurance"],
}

WAREHOUSE = {
    "fe-gcp": "d6d89fb9fd47b835",
    "fe-aws": "862f1d757f0424f7",
    "my-gcp": "2023d0a3a188bd24",
    "my-adp": "2ad1b26db73a7c6f",
    "my-uae": "6b2c33b3b2aae3ac",
}

ECM_SCOPE = "Expanded Coverage Model - ECM"
MVM_SCOPE = "Minimum Viable Model - MVM"

_AUTH_HINTS = ("oauth", "token has expired", "refresh token expired", "401",
               "unauthorized", "invalid_grant", "could not refresh",
               "token was revoked", "access_token")

_state_lock = threading.Lock()
_pulse_lock = threading.Lock()


def now():
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def pulse(msg):
    line = f"[{now()}] {msg}"
    with _pulse_lock:
        print(line, flush=True)
        Path(os.path.dirname(PULSE_FILE)).mkdir(parents=True, exist_ok=True)
        with open(PULSE_FILE, "a") as f:
            f.write(line + "\n")


def _run(cmd, timeout):
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                         text=True, stdin=subprocess.DEVNULL, start_new_session=True)
    try:
        out, err = p.communicate(timeout=timeout)
        return p.returncode, out, err
    except subprocess.TimeoutExpired:
        try:
            os.killpg(os.getpgid(p.pid), 9)
        except Exception:
            try:
                p.kill()
            except Exception:
                pass
        try:
            p.communicate(timeout=10)
        except Exception:
            pass
        return 124, "", f"timeout after {timeout}s"


def _refresh(profile):
    _run(["databricks", "auth", "token", "--profile", profile], 60)


def db(args, profile, timeout=300):
    cmd = ["databricks"] + args + ["--profile", profile]
    rc, out, err = _run(cmd, timeout)
    if rc == 0:
        return out
    el = (err or "").lower()
    if any(h in el for h in _AUTH_HINTS):
        _refresh(profile)
        rc, out, err = _run(cmd, timeout)
        if rc == 0:
            return out
    raise RuntimeError(f"databricks {' '.join(args)} -> {rc}: {(err or '')[:600]}")


def dbj(args, profile, timeout=300):
    out = db(args + ["-o", "json"], profile, timeout=timeout)
    return json.loads(out) if out.strip() else {}


def load_state():
    if not os.path.exists(STATE_FILE):
        return {"started_at": now(), "industries": {}}
    try:
        return json.loads(Path(STATE_FILE).read_text())
    except Exception:
        return {"started_at": now(), "industries": {}}


def save_state(state):
    with _state_lock:
        state["updated_at"] = now()
        Path(os.path.dirname(STATE_FILE)).mkdir(parents=True, exist_ok=True)
        tmp = STATE_FILE + ".tmp"
        Path(tmp).write_text(json.dumps(state, indent=2, default=str))
        os.replace(tmp, STATE_FILE)


def set_ind(state, ind, **kv):
    with _state_lock:
        state.setdefault("industries", {}).setdefault(ind, {}).update(kv)
        state["industries"][ind]["ts"] = now()
    save_state(state)


def cat_name(ind):
    return f"vibe_{ind}_v1"


def vol_base(ind):
    return f"/Volumes/{cat_name(ind)}/_staging/src"


def _try(args, profile, ok_substrings=(), timeout=180):
    try:
        db(args, profile, timeout=timeout)
        return True
    except Exception as e:
        s = str(e).lower()
        if any(o in s for o in ok_substrings):
            return True
        raise


def sql_exec(profile, stmt, timeout=180):
    wh = WAREHOUSE[profile]
    payload = {"warehouse_id": wh, "statement": stmt, "wait_timeout": "50s"}
    pf = f"/tmp/vov_sql_{profile}_{abs(hash(stmt)) % 100000}.json"
    Path(pf).write_text(json.dumps(payload))
    res = dbj(["api", "post", "/api/2.0/sql/statements", "--json", f"@{pf}"], profile, timeout=120)
    sid = res.get("statement_id")
    status = (res.get("status", {}) or {}).get("state")
    deadline = time.time() + timeout
    while status in ("PENDING", "RUNNING") and time.time() < deadline:
        time.sleep(4)
        res = dbj(["api", "get", f"/api/2.0/sql/statements/{sid}"], profile, timeout=120)
        status = (res.get("status", {}) or {}).get("state")
    if status != "SUCCEEDED":
        err = (res.get("status", {}) or {}).get("error", {})
        raise RuntimeError(f"SQL '{stmt[:60]}' -> {status}: {str(err)[:300]}")
    return res


def _rows(res):
    return (res.get("result", {}) or {}).get("data_array", []) or []


def _managed_bases(profile):
    res = sql_exec(profile, "SHOW CATALOGS")
    cats = [str(r[0]) for r in _rows(res)
            if r and not str(r[0]).lower().startswith(("_", "system", "samples", "main", "hive_metastore", "__"))]
    cats.sort(key=lambda c: (0 if any(c.endswith(s) for s in ("_ecm_v1", "_mvm_v1", "_v1", "_v2")) else 1))
    bases, seen = [], set()
    for cn in cats:
        try:
            d = sql_exec(profile, f"DESCRIBE CATALOG EXTENDED `{cn}`")
            for row in _rows(d):
                if len(row) >= 2 and str(row[0]).lower() in ("storage_root", "storage root") \
                        and str(row[1]).startswith(("abfss://", "s3://", "gs://")):
                    b = str(row[1]).rsplit("/__unitystorage/", 1)[0]
                    if b not in seen:
                        seen.add(b)
                        bases.append(b)
        except Exception:
            continue
    return bases


def prepare_catalog(profile, ind):
    cat = cat_name(ind)
    sql_exec(profile, f"DROP CATALOG IF EXISTS `{cat}` CASCADE", timeout=600)
    try:
        sql_exec(profile, f"CREATE CATALOG `{cat}`")
    except Exception as e:
        el = str(e).lower()
        if not ("storage root" in el or "default storage" in el or "managed location" in el):
            raise
        created, last = False, str(e)[:200]
        for base in _managed_bases(profile):
            for loc in (base, f"{base}/{cat}"):
                try:
                    sql_exec(profile, f"CREATE CATALOG `{cat}` MANAGED LOCATION '{loc}'")
                    created = True
                    break
                except Exception as e2:
                    last = str(e2)[:200]
                    le = last.lower()
                    if "overlap" in le:
                        continue
                    if "permission_denied" in le or "not accessible" in le or "forbidden" in le:
                        break
                    break
            if created:
                break
        if not created:
            raise RuntimeError(f"[{ind}] could not create catalog on {profile}: {last}")
    sql_exec(profile, f"CREATE SCHEMA IF NOT EXISTS `{cat}`.`_staging`")
    sql_exec(profile, f"CREATE VOLUME IF NOT EXISTS `{cat}`.`_staging`.`src`")


def stage_files(profile, ind):
    base = vol_base(ind)
    _try(["fs", "mkdir", f"dbfs:{base}/model"], profile, ("already exists",))
    db(["fs", "cp", f"{STAGE_DIR}/{ind}/model/model.json",
        f"dbfs:{base}/model/model.json", "--overwrite"], profile, timeout=600)
    db(["fs", "cp", f"{STAGE_DIR}/{ind}/next_vibes.txt",
        f"dbfs:{base}/next_vibes.txt", "--overwrite"], profile, timeout=300)


def industry_desc(ind):
    p = f"{STAGE_DIR}/{ind}/description.txt"
    d = Path(p).read_text().strip() if os.path.exists(p) else ""
    return d or f"{ind.replace('_', ' ')} industry enterprise data model."


def build_job_spec(ind):
    cat = cat_name(ind)
    base = vol_base(ind)
    desc = industry_desc(ind)
    common = {"business_name": ind, "business_description": desc,
              "deployment_catalog": cat, "generate_samples": "0"}
    install = dict(common, operation="install model", model_version="1",
                   data_model_scopes=ECM_SCOPE,
                   context_file=f"{base}/model/model.json", model_vibes="")
    vov = dict(common, operation="vibe modeling of version", model_version="1",
               data_model_scopes=ECM_SCOPE,
               model_vibes=f"{base}/next_vibes.txt", context_file="")
    shrink = dict(common, operation="shrink ecm", model_version="2",
                  data_model_scopes=MVM_SCOPE, model_vibes="", context_file="")
    def task(key, params, tmo, dep=None):
        t = {"task_key": key,
             "notebook_task": {"notebook_path": AGENT_PATH, "source": "WORKSPACE",
                               "base_parameters": params},
             "timeout_seconds": tmo}
        if dep:
            t["depends_on"] = [{"task_key": dep}]
        return t
    return {
        "name": f"dbx_vibe_vov2_{ind}_v353",
        "timeout_seconds": JOB_TIMEOUT_S,
        "max_concurrent_runs": 1,
        "tasks": [
            task("install", install, INSTALL_TIMEOUT_S),
            task("vov", vov, VOV_TIMEOUT_S, dep="install"),
            task("shrink", shrink, SHRINK_TIMEOUT_S, dep="vov"),
        ],
    }


def find_or_create_job(profile, ind):
    name = f"dbx_vibe_vov2_{ind}_v353"
    jobs = dbj(["jobs", "list", "--limit", "100"], profile)
    items = jobs if isinstance(jobs, list) else jobs.get("jobs", [])
    for j in items:
        if (j.get("settings", {}) or {}).get("name") == name:
            spec = build_job_spec(ind)
            patch = {"job_id": j["job_id"], "new_settings": spec}
            pp = f"/tmp/vov_jobpatch_{ind}.json"
            Path(pp).write_text(json.dumps(patch))
            db(["jobs", "reset", "--json", f"@{pp}"], profile)
            return j["job_id"]
    spec = build_job_spec(ind)
    sp = f"/tmp/vov_jobspec_{ind}.json"
    Path(sp).write_text(json.dumps(spec))
    res = dbj(["jobs", "create", "--json", f"@{sp}"], profile)
    return res["job_id"]


def run_now(profile, job_id):
    res = dbj(["jobs", "run-now", str(job_id), "--no-wait"], profile)
    return res["run_id"]


def get_run(profile, run_id):
    info = dbj(["jobs", "get-run", str(run_id)], profile)
    st = info.get("state", {})
    return {
        "lc": st.get("life_cycle_state"),
        "result": st.get("result_state"),
        "msg": (st.get("state_message", "") or "")[:200],
        "url": info.get("run_page_url"),
        "tasks": [{"k": t.get("task_key"),
                   "lc": (t.get("state", {}) or {}).get("life_cycle_state"),
                   "r": (t.get("state", {}) or {}).get("result_state")}
                  for t in info.get("tasks", [])],
    }


def wait_terminal(profile, ind, run_id):
    started = time.time()
    last = 0
    while True:
        if os.path.exists(KILL_FILE):
            pulse(f"[{ind}] KILL file present — leaving run {run_id} as-is and exiting watcher")
            return {"lc": "ABORTED", "result": "KILLED"}
        try:
            info = get_run(profile, run_id)
        except Exception as e:
            pulse(f"[{ind}] poll err (retry): {str(e)[:160]}")
            time.sleep(POLL_S)
            continue
        if info["lc"] in ("TERMINATED", "INTERNAL_ERROR", "SKIPPED"):
            return info
        if time.time() - last >= PULSE_S:
            ts = ", ".join(f"{t['k']}={t['lc'] or '?'}/{t['r'] or '-'}" for t in info["tasks"])
            pulse(f"[{ind}] {profile} elapsed={int((time.time()-started)/60)}m lc={info['lc']} [{ts}]")
            last = time.time()
        time.sleep(POLL_S)


def export_industry(profile, ind):
    cat = cat_name(ind)
    root = f"/Volumes/{cat}/_metamodel/vol_root/business/{ind}"
    dest = f"{OUT_DIR}/{ind}"
    Path(dest).mkdir(parents=True, exist_ok=True)
    got = {}
    for scope in ("ecm", "mvm"):
        src = f"dbfs:{root}/v2/{scope}"
        d = f"{dest}/v2/{scope}"
        Path(os.path.dirname(d)).mkdir(parents=True, exist_ok=True)
        try:
            db(["fs", "cp", "-r", src, d, "--overwrite"], profile, timeout=1200)
            got[scope] = os.path.exists(f"{d}/model.json")
        except Exception as e:
            pulse(f"[{ind}] export {scope} failed: {str(e)[:160]}")
            got[scope] = False
    for fn in ("readme.md",):
        try:
            db(["fs", "cp", f"dbfs:{root}/v2/{fn}", f"{dest}/v2/{fn}", "--overwrite"],
               profile, timeout=120)
        except Exception:
            pass
    return got


def process_industry(profile, ind, state):
    if os.path.exists(KILL_FILE):
        return
    cur = state.get("industries", {}).get(ind, {})
    if cur.get("status", "").startswith("green"):
        pulse(f"[{ind}] already green — skip")
        return
    rid = cur.get("run_id")
    if cur.get("status") in ("running", "submitted", "exporting") and rid:
        try:
            info = get_run(profile, rid)
            if info["lc"] in ("PENDING", "RUNNING", "TERMINATED", "INTERNAL_ERROR", "SKIPPED", "BLOCKED"):
                pulse(f"[{ind}] RE-ATTACH run={rid} lc={info['lc']}")
                if info["lc"] not in ("TERMINATED", "INTERNAL_ERROR", "SKIPPED"):
                    info = wait_terminal(profile, ind, rid)
                if info.get("result") == "KILLED":
                    return
                _finish(profile, ind, state, info)
                return
        except Exception as e:
            pulse(f"[{ind}] re-attach failed ({str(e)[:120]}) — restarting")
    pulse(f"=== START {ind} on {profile} ===")
    set_ind(state, ind, status="preparing", profile=profile)
    try:
        prepare_catalog(profile, ind)
        stage_files(profile, ind)
    except Exception as e:
        pulse(f"[{ind}] PREP FAILED: {str(e)[:300]}")
        set_ind(state, ind, status="prep_failed", error=str(e)[:300])
        return
    try:
        job_id = find_or_create_job(profile, ind)
        set_ind(state, ind, job_id=job_id, status="submitted")
        run_id = run_now(profile, job_id)
        set_ind(state, ind, run_id=run_id, status="running")
        pulse(f"[{ind}] submitted job={job_id} run={run_id}")
    except Exception as e:
        pulse(f"[{ind}] SUBMIT FAILED: {str(e)[:300]}")
        set_ind(state, ind, status="submit_failed", error=str(e)[:300])
        return
    info = wait_terminal(profile, ind, run_id)
    if info.get("result") == "KILLED":
        return
    _finish(profile, ind, state, info)


def _finish(profile, ind, state, info):
    ts = ", ".join(f"{t['k']}={t['r'] or t['lc']}" for t in info.get("tasks", []))
    pulse(f"[{ind}] TERMINAL lc={info['lc']} result={info.get('result')} tasks=[{ts}] url={info.get('url')}")
    set_ind(state, ind, status="exporting", terminal=info.get("result"),
            tasks=info.get("tasks"), run_url=info.get("url"))
    got = export_industry(profile, ind)
    status = "green" if (info.get("result") == "SUCCESS" and got.get("ecm")) else \
             ("partial" if got.get("ecm") else "red")
    set_ind(state, ind, status=status, exported=got)
    pulse(f"[{ind}] {status.upper()} exported ecm={got.get('ecm')} mvm={got.get('mvm')}")


def tick_profile(profile, state):
    for ind in ASSIGN[profile]:
        if os.path.exists(KILL_FILE):
            return
        cur = state.get("industries", {}).get(ind, {})
        st = cur.get("status", "")
        if st.startswith("green"):
            continue
        rid = cur.get("run_id")
        if rid and st in ("running", "submitted", "exporting"):
            try:
                info = get_run(profile, rid)
            except Exception as e:
                pulse(f"[{ind}] {profile} poll err: {str(e)[:140]}")
                return
            if info["lc"] in ("TERMINATED", "INTERNAL_ERROR", "SKIPPED"):
                _finish(profile, ind, state, info)
                continue
            ts = ", ".join(f"{t['k']}={t['lc'] or '?'}/{t['r'] or '-'}" for t in info["tasks"])
            pulse(f"[{ind}] {profile} lc={info['lc']} [{ts}]")
            return
        pulse(f"=== START {ind} on {profile} ===")
        set_ind(state, ind, status="preparing", profile=profile)
        try:
            prepare_catalog(profile, ind)
            stage_files(profile, ind)
            job_id = find_or_create_job(profile, ind)
            set_ind(state, ind, job_id=job_id)
            run_id = run_now(profile, job_id)
            set_ind(state, ind, run_id=run_id, status="running")
            pulse(f"[{ind}] submitted job={job_id} run={run_id}")
        except Exception as e:
            pulse(f"[{ind}] START FAILED: {str(e)[:280]}")
            set_ind(state, ind, status="prep_failed", error=str(e)[:280])
        return
    pulse(f"[{profile}] all industries done")


def tick(profiles, state):
    pulse(f"--- TICK {now()} profiles={profiles} ---")
    threads = []
    for p in profiles:
        t = threading.Thread(target=tick_profile, args=(p, state), name=p)
        t.start()
        threads.append(t)
    for t in threads:
        t.join()
    inds = state.get("industries", {})
    done = [i for i, v in inds.items() if v.get("status", "").startswith(("green", "partial", "red"))]
    green = [i for i, v in inds.items() if v.get("status", "").startswith("green")]
    total = sum(len(v) for v in ASSIGN.values())
    pulse(f"--- TICK DONE green={len(green)} done={len(done)}/{total} ---")
    return len(done) >= total


def worker(profile, state):
    for ind in ASSIGN[profile]:
        if os.path.exists(KILL_FILE):
            pulse(f"[{profile}] KILL — stopping worker")
            return
        try:
            process_industry(profile, ind, state)
        except Exception as e:
            pulse(f"[{profile}] UNCAUGHT {ind}: {str(e)[:300]}")
            set_ind(state, ind, status="uncaught", error=str(e)[:300])
    pulse(f"[{profile}] worker done")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--profiles", default=",".join(ASSIGN.keys()))
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--once", action="store_true")
    args = ap.parse_args()
    profiles = [p.strip() for p in args.profiles.split(",") if p.strip()]
    state = load_state()
    save_state(state)
    if args.once:
        tick(profiles, state)
        return
    pulse(f"=== VOV2 MARATHON START profiles={profiles} ===")
    if args.dry_run:
        for p in profiles:
            for ind in ASSIGN[p]:
                spec = build_job_spec(ind)
                pulse(f"[dry] {p}/{ind} cat={cat_name(ind)} tasks={[t['task_key'] for t in spec['tasks']]}")
        pulse("=== DRY RUN DONE ===")
        return
    threads = []
    for p in profiles:
        t = threading.Thread(target=worker, args=(p, state), name=p, daemon=False)
        t.start()
        threads.append(t)
    for t in threads:
        t.join()
    inds = state.get("industries", {})
    green = [i for i, v in inds.items() if v.get("status", "").startswith("green")]
    pulse(f"=== VOV2 MARATHON DONE green={len(green)}/{sum(len(v) for v in ASSIGN.values())} :: {sorted(green)} ===")


if __name__ == "__main__":
    main()
