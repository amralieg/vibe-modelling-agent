#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import threading
import time
from datetime import datetime, timezone
from pathlib import Path

AGENT_VER = "385"  # matches __AGENT_VERSION__ 3.8.5 (semver minus dots, §3a); never run stale
AGENT_PATH = f"/Users/amr.ali@databricks.com/dbx_vibe_modelling_agent_v{AGENT_VER}"
STAGE_DIR = "/tmp/vov_stage"
OUT_DIR = "/tmp/vov_out"
PULSE_FILE = os.path.expanduser("~/claude/vibe-agent/vov2_pulses.txt")
STATE_FILE = os.path.expanduser("~/claude/vibe-agent/vov2_state.json")
KILL_FILE = os.path.expanduser("~/claude/vibe-agent/vov2_KILL")

POLL_S = 120
PULSE_S = 900
# Per-task caps reflect the user directive "timeout for any agent run is 15h" applied to the
# QUALITY-CRITICAL agent run (vov), tempered by the proven teardown-hang reality of install/shrink:
#   - vov SELF-COMPLETES (writes ECM model.json + finalizes) and is the run whose truncation costs
#     quality, so it gets the full 15h ceiling => NEVER truncated mid-finalization. (Was 4h, which
#     sat dangerously close to observed 3.3h vov runtimes on tier-1-size models.)
#   - install + shrink PROVABLY hang in a GIL-held teardown AFTER writing their artifacts (installs
#     observed TERMINATED/TIMEDOUT; canary shrinks hit their cap then exported a written mvm). In the
#     3-task job, run_if=ALL_DONE means the NEXT task waits for the current to be 'done', so a 15h cap
#     on install/shrink would block the pipeline for up to 15h of pure teardown hang — slower, not
#     faster. They therefore get generous-but-bounded caps well above measured functional times
#     (install functional <=40m on the slow my-uae workspace; shrink functional 66-106m), so real work
#     never truncates while teardown waste stays bounded. Artifacts (model.json, next_vibes) are on the
#     volume BEFORE teardown, so a cap-killed-but-functionally-complete task still exports + advances.
JOB_TIMEOUT_S = 82800        # 23h job ceiling (>= 1h install + 15h vov + 2.5h shrink, with margin)
# v385 marathon EVIDENCE (2026-06-19): all 13 installs finished functional work (physical schema +
# tags + MVs + model.json deploy) in 14-17m, then hung in a GIL-held serverless teardown for ~90m
# with NO new log lines and NO self-cancel marker (the in-driver self-cancel/faulthandler _exit kills
# the DRIVER but does NOT flip the serverless RUN to TERMINATED -- only a control-plane cancel does).
# The control-plane JOB TIMEOUT is that reliable external terminator. Install/shrink have short,
# predictable functional times, so a tight cap bounds the teardown-hang waste WITHOUT truncating real
# work. vov is quality-critical (variable multi-hour real work) so it keeps the full 15h ceiling and
# relies on artifacts-before-teardown + the in-driver self-cancel (live-watched this run).
INSTALL_TIMEOUT_S = 3600     # 60m: functional install <=40m even on slow my-uae; bounds the PROVEN
                             #      teardown hang to ~20-45m (was 120m -> ~100m wasted) and unblocks
                             #      vov (run_if=ALL_DONE) ~60m sooner. Never truncates <=40m functional.
VOV_TIMEOUT_S = 54000        # 15h: user directive — the quality-critical agent run is never truncated
SHRINK_TIMEOUT_S = 9000      # 2.5h: functional shrink 66-106m; same serverless teardown-hang mechanism
                             #       as install -> bound via control-plane timeout (was 5h)

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
    # stage inputs INSIDE the agent's own _metamodel/vol_root volume (a folder),
    # never a separate _staging database (user directive 2026-06-18). The agent
    # creates _metamodel/vol_root with CREATE ... IF NOT EXISTS, so pre-creating
    # them here and reusing is safe; the staged file survives the agent run.
    return f"/Volumes/{cat_name(ind)}/_metamodel/vol_root/_input"


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


def _external_location_bases(profile):
    # When the metastore has NO default storage, a plain CREATE CATALOG fails and we must
    # supply an explicit MANAGED LOCATION. The metastore's own WRITABLE external locations are
    # the most reliable candidates (the principal is, by definition, permitted to use them),
    # unlike sibling-catalog storage_roots which are frequently owned by other principals.
    # Generic/industry-agnostic: reads live UC config, never special-cases any workspace.
    try:
        d = dbj(["external-locations", "list"], profile, timeout=120)
    except Exception:
        return []
    locs = d if isinstance(d, list) else d.get("external_locations", [])
    bases = []
    for l in locs:
        url = (l.get("url") or "").rstrip("/")
        if url and not l.get("read_only") and url.startswith(("abfss://", "s3://", "gs://")):
            bases.append(url)
    return bases


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
        cand_bases, seen_b = [], set()
        for b in _external_location_bases(profile) + _managed_bases(profile):
            if b not in seen_b:
                seen_b.add(b)
                cand_bases.append(b)
        for base in cand_bases:
            for loc in (f"{base}/{cat}", base):
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
    # reuse the agent's own meta schema/volume; do NOT create a separate _staging
    # database (user directive 2026-06-18). The agent re-uses these via IF NOT EXISTS.
    sql_exec(profile, f"CREATE SCHEMA IF NOT EXISTS `{cat}`.`_metamodel`")
    sql_exec(profile, f"CREATE VOLUME IF NOT EXISTS `{cat}`.`_metamodel`.`vol_root`")


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
            # run_if=ALL_DONE: upstream task may be killed by the platform timeout while in a
            # GIL-held teardown hang AFTER its functional work + volume artifacts completed.
            # ALL_DONE lets the downstream operation proceed (it reads the installed catalog /
            # volume model.json, both populated before teardown) instead of being skipped.
            t["depends_on"] = [{"task_key": dep}]
            t["run_if"] = "ALL_DONE"
        return t
    return {
        "name": f"dbx_vibe_vov2_{ind}_v{AGENT_VER}",
        "timeout_seconds": JOB_TIMEOUT_S,
        "max_concurrent_runs": 1,
        "tasks": [
            task("install", install, INSTALL_TIMEOUT_S),
            task("vov", vov, VOV_TIMEOUT_S, dep="install"),
            task("shrink", shrink, SHRINK_TIMEOUT_S, dep="vov"),
        ],
    }


def find_or_create_job(profile, ind):
    name = f"dbx_vibe_vov2_{ind}_v{AGENT_VER}"
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
    status = "green" if (got.get("ecm") and got.get("mvm")) else \
             ("partial" if got.get("ecm") else "red")
    set_ind(state, ind, status=status, exported=got)
    pulse(f"[{ind}] {status.upper()} exported ecm={got.get('ecm')} mvm={got.get('mvm')}")
    # User directive: full VReq audit on EVERY industry as it completes (stored for later v3 use).
    # Runs whenever an ECM exists (green or partial) — audit reads the ECM vov log + exported model.json.
    if got.get("ecm"):
        try:
            import vov_audit_extract as _audit  # lazy: avoids circular import at module load
            audit = _audit.extract(ind, profile)
            sb = (audit or {}).get("scoreboard", {})
            pulse(f"[{ind}] AUDIT stored total={sb.get('total_requirements')} "
                  f"fulfilled={sb.get('fulfilled')} partial={sb.get('partial')} "
                  f"failed={sb.get('failed')} precision={sb.get('precision')} recall={sb.get('recall')}")
        except Exception as e:
            pulse(f"[{ind}] AUDIT FAILED: {str(e)[:200]}")


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
