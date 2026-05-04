#!/usr/bin/env python3
"""v0.7.4 (alias=sync-watchdog) — out-of-band per-industry repo-sync daemon.

ROOT CAUSE this fixes:
The original sync_to_repo hook in orchestrate_sectors.py only fires at the END of
each sector (after all retries done). When sector_runner times out (e.g. AWS
Retail 8.5h consumed the 14h budget; Azure Oil Gas 17h consumed it; both forced
6+/3+ siblings into one-by-one retry), green industries sit on the workspace
volume for HOURS (sometimes overnight) before the auto-sync fires. Plus, older
orchestrators (e.g. GCP PID 59630 from May 1 using vibe_runner_v71) never had
the sync hook at all.

This watchdog runs OUT-OF-BAND from every orchestrator. It polls the per-industry
pipeline jobs across all 3 clouds (GCP, AWS, Azure), detects TERMINATED/SUCCESS
runs whose industry is not yet in the repo, and pushes via sync_to_repo
immediately. ZERO disruption to running orchestrators — they don't even know
this is running.

Behaviour:
  - Polls every POLL_INTERVAL_S (default 120s)
  - For each cloud, lists job names matching 'dbx_vibe_*_pipeline_ecm_mvm_v1'
  - For each job, gets latest run; if TERMINATED/SUCCESS and industry not in
    /Users/amr.ali/Documents/projects/vibe-business-data-models/<industry>/,
    runs sync_to_repo for that industry
  - Tracks pushed-industries in state file so we don't redo work on restart
  - Logs everything to a single rotating log file

Use:
  nohup python3 runner/sync_watchdog.py > ~/claude/vibe-agent/sync_watchdog.log 2>&1 &
  disown
"""
import json
import os
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path


REPO_PATH = "/Users/amr.ali/Documents/projects/vibe-business-data-models"
STATE_FILE = os.path.expanduser("~/claude/vibe-agent/sync_watchdog_state.json")
LOG_FILE = os.path.expanduser("~/claude/vibe-agent/sync_watchdog.log")
LOCK_FILE = os.path.expanduser("~/claude/vibe-agent/repo_sync.lock")
POLL_INTERVAL_S = 120

QUALITY_GATE_MIN_PRODUCTS = 5
QUALITY_GATE_MIN_ATTRIBUTES = 50
QUALITY_GATE_MIN_DOMAINS = 3
QUALITY_GATE_PROBE_DEPTH = 5
GLOBAL_VOLUME = "/Volumes/_root/default/root_vol"
QUALITY_GATE_MIN_FILES_COPIED = 30
QUALITY_GATE_MIN_FILES_ECM = 20
QUALITY_GATE_MIN_FILES_MVM = 15
JOB_NAME_PREFIX = "dbx_vibe_"
JOB_NAME_SUFFIX = "_pipeline_ecm_mvm_v1"
CLOUDS = [
    {"name": "GCP", "profile": "emirates-gcp"},
    {"name": "AWS", "profile": "fe-aws"},
    {"name": "AZURE", "profile": "fe-vm-feip"},
]


def log(msg):
    ts = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    line = f"[{ts}] {msg}"
    print(line, flush=True)
    try:
        with open(LOG_FILE, "a") as f:
            f.write(line + "\n")
    except Exception:
        pass


def load_state():
    if os.path.isfile(STATE_FILE):
        try:
            return json.loads(Path(STATE_FILE).read_text())
        except Exception:
            pass
    return {"pushed": {}, "last_poll": None, "started_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")}


def save_state(state):
    state["last_poll"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    Path(STATE_FILE).write_text(json.dumps(state, indent=2))


def db_cli(args, profile, timeout=180):
    """v0.7.4 (alias=sync-watchdog) — wrap CLI with explicit timeout.

    Default 180s — AWS workspace e2-demo-field-eng is heavily shared and the
    `jobs list` call can take 60-120s on bad days. 30s timeout was too tight."""
    cmd = ["databricks"] + args + ["--profile", profile, "-o", "json"]
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
    if proc.returncode != 0:
        raise RuntimeError(f"{' '.join(cmd[:5])}... -> code={proc.returncode}\nstderr={proc.stderr[:300]}")
    return proc.stdout


def list_pipeline_jobs(profile):
    """List all dbx_vibe_*_pipeline_ecm_mvm_v1 jobs on the workspace."""
    out = db_cli(["jobs", "list", "--limit", "100"], profile, timeout=180)
    d = json.loads(out)
    jobs = d if isinstance(d, list) else d.get("jobs", [])
    pipeline_jobs = []
    for j in jobs:
        name = j.get("settings", {}).get("name", "")
        if name.startswith(JOB_NAME_PREFIX) and name.endswith(JOB_NAME_SUFFIX):
            ind_snake = name[len(JOB_NAME_PREFIX):-len(JOB_NAME_SUFFIX)]
            pipeline_jobs.append({"job_id": j.get("job_id"), "name": name, "industry_snake": ind_snake})
    return pipeline_jobs


def get_latest_run(profile, job_id):
    out = db_cli(["jobs", "list-runs", "--job-id", str(job_id), "--limit", "1"], profile, timeout=120)
    d = json.loads(out)
    runs = d if isinstance(d, list) else d.get("runs", [])
    return runs[0] if runs else None


def _model_counts(model_obj):
    """Return (n_domains, n_products, n_attributes, n_metric_views)."""
    if not isinstance(model_obj, dict):
        return 0, 0, 0, 0
    nested = model_obj.get("model", model_obj)
    domains = nested.get("domains", [])
    n_d = len(domains)
    n_p = 0
    n_a = 0
    for dom in domains:
        prods = dom.get("products") or dom.get("data_products") or []
        n_p += len(prods)
        for p in prods:
            n_a += len(p.get("attributes", []))
    n_mv = len(nested.get("metric_views", []))
    return n_d, n_p, n_a, n_mv


def _read_volume_manifest(profile, industry_snake):
    """Download and parse the orchestrator's per-industry _manifest.json from the
    global volume. Returns parsed dict on success, None on failure."""
    remote = f"dbfs:{GLOBAL_VOLUME}/{industry_snake}/_manifest.json"
    local = f"/tmp/qg_manifest_{industry_snake}_{int(time.time())}.json"
    try:
        if os.path.isfile(local):
            os.remove(local)
        out = subprocess.run(
            ["databricks", "fs", "cp", remote, local, "--overwrite", "--profile", profile],
            capture_output=True, text=True, timeout=60,
        )
        if out.returncode != 0:
            return None
        return json.loads(Path(local).read_text())
    except Exception:
        return None
    finally:
        try:
            os.remove(local)
        except OSError:
            pass


def passes_quality_gate(profile, industry_snake, cloud_name, log_fn=log):
    """v0.7.4 (alias=sync-watchdog-quality-gate) — verify the orchestrator's volume
    manifest declares a real, finished model before pushing.

    ROOT CAUSE this fixes (within v0.7.4):
    The first watchdog cycle pushed `semiconductors`, `chemical_mfg`, and
    `manufacturing` from leftover Azure test runs that produced 6KB shell
    model.json files (3 domains, 0 products, 0 attributes — generation
    aborted very early but the run still terminated TERMINATED/SUCCESS due to a
    soft-accept hatch). Without a content gate, any TERMINATED/SUCCESS pipeline
    run was eligible for push. Reverted those 3 commits via force-push, then
    added this gate.

    Originally tried to download model.json from the workspace, but the CLI's
    `workspace export` has a 10MB limit and real models are 14MB+. Switched to
    the orchestrator's volume `_manifest.json` (always small, written ONLY when
    all 5 task states are OK, contains per-scope file counts that distinguish
    real models from empty shells).

    Gate criteria (must satisfy ALL):
      - manifest exists at <GLOBAL_VOLUME>/<industry>/_manifest.json
      - manifest['run_metadata']['all_tasks_succeeded'] == True
      - manifest['files_copied'] >= QUALITY_GATE_MIN_FILES_COPIED (30)
      - manifest['scopes']['ecm_v1']['files'] >= QUALITY_GATE_MIN_FILES_ECM (20)
      - manifest['scopes']['mvm_v1']['files'] >= QUALITY_GATE_MIN_FILES_MVM (15)
    Reference: healthcare manifest = 211 files copied, ecm_v1=59, mvm_v1=47.
    Empty shells produce <10 files because metric-view + schema generation
    aborts before the volume mirror runs.
    """
    manifest = _read_volume_manifest(profile, industry_snake)
    if not manifest:
        log_fn(f"  [{cloud_name}] [quality-gate REJECT] {industry_snake}: no _manifest.json on volume")
        return False
    rm = manifest.get("run_metadata", {})
    if not rm.get("all_tasks_succeeded"):
        log_fn(f"  [{cloud_name}] [quality-gate REJECT] {industry_snake}: all_tasks_succeeded=False (failed_parts={rm.get('failed_parts')})")
        return False
    files_copied = manifest.get("files_copied", 0)
    scopes = manifest.get("scopes", {})
    ecm_files = scopes.get("ecm_v1", {}).get("files", 0)
    mvm_files = scopes.get("mvm_v1", {}).get("files", 0)
    if (files_copied < QUALITY_GATE_MIN_FILES_COPIED
            or ecm_files < QUALITY_GATE_MIN_FILES_ECM
            or mvm_files < QUALITY_GATE_MIN_FILES_MVM):
        log_fn(
            f"  [{cloud_name}] [quality-gate REJECT] {industry_snake}: "
            f"files_copied={files_copied} ecm={ecm_files} mvm={mvm_files} — "
            f"below thresholds (min copied={QUALITY_GATE_MIN_FILES_COPIED} "
            f"ecm={QUALITY_GATE_MIN_FILES_ECM} mvm={QUALITY_GATE_MIN_FILES_MVM})"
        )
        return False
    log_fn(
        f"  [{cloud_name}] [quality-gate PASS] {industry_snake}: "
        f"files_copied={files_copied} ecm={ecm_files} mvm={mvm_files}"
    )
    return True


def industry_in_repo(industry_snake):
    p = os.path.join(REPO_PATH, industry_snake)
    return os.path.isdir(p) and bool(os.listdir(p))


def acquire_repo_lock(timeout_s=900):
    """Acquire exclusive lock to serialise git pushes vs orchestrator's repo_sync hook.

    Lock TTL is 15 min — orchestrator's sync_completed_industries can take 5-10
    min for a large industry (workspace export-dir is slow). Stale lock files
    older than TTL are reclaimed.
    """
    deadline = time.time() + timeout_s
    while time.time() < deadline:
        if os.path.isfile(LOCK_FILE):
            try:
                age = time.time() - os.path.getmtime(LOCK_FILE)
            except OSError:
                age = 0
            if age > 900:
                try:
                    os.remove(LOCK_FILE)
                    log(f"  [sync-watchdog] reclaimed stale lock (age={age:.0f}s)")
                except OSError:
                    pass
        try:
            fd = os.open(LOCK_FILE, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
            os.write(fd, f"{os.getpid()}".encode())
            os.close(fd)
            return True
        except FileExistsError:
            time.sleep(15)
    return False


def release_repo_lock():
    try:
        os.remove(LOCK_FILE)
    except OSError:
        pass


def push_industry(profile, industry_snake, cloud_name):
    """Run sync_to_repo CLI for one industry, holding repo lock to avoid clash."""
    repo_root = os.path.dirname(os.path.abspath(__file__))
    sync_script = os.path.join(repo_root, "sync_to_repo.py")
    display_name = " ".join(w.capitalize() for w in industry_snake.split("_"))
    log(f"  [{cloud_name}] [sync-watchdog FIRED] pushing '{industry_snake}' (display='{display_name}') to repo")
    if not acquire_repo_lock():
        log(f"  [{cloud_name}] [sync-watchdog SKIP] could not acquire repo lock for {industry_snake} — will retry next cycle")
        return False
    try:
        proc = subprocess.run(
            [sys.executable, sync_script, "--profile", profile, "--industry", display_name],
            capture_output=True, text=True, timeout=900,
        )
    finally:
        release_repo_lock()
    out_tail = "\n".join((proc.stdout + proc.stderr).splitlines()[-15:])
    if proc.returncode == 0 and '"synced"' in proc.stdout and industry_snake in proc.stdout:
        log(f"  [{cloud_name}] [sync-watchdog SUCCESS] {industry_snake} pushed")
        return True
    log(f"  [{cloud_name}] [sync-watchdog FAILED] {industry_snake} sync did not complete cleanly:\n{out_tail}")
    return False


def poll_one_cloud(cloud, state):
    """Poll one cloud for new SUCCESS per-industry runs and push them."""
    profile = cloud["profile"]
    name = cloud["name"]
    try:
        jobs = list_pipeline_jobs(profile)
    except Exception as e:
        log(f"  [{name}] WARN list_pipeline_jobs failed: {str(e)[:200]}")
        return 0
    pushed_count = 0
    pushed_set = set(state.get("pushed", {}).get(name, []))
    for j in jobs:
        ind = j["industry_snake"]
        if ind in pushed_set or industry_in_repo(ind):
            continue
        try:
            r = get_latest_run(profile, j["job_id"])
        except Exception as e:
            log(f"  [{name}] WARN get_latest_run({ind}) failed: {str(e)[:150]}")
            continue
        if not r:
            continue
        s = r.get("state", {})
        if s.get("life_cycle_state") != "TERMINATED" or s.get("result_state") != "SUCCESS":
            continue
        if not passes_quality_gate(profile, ind, name):
            state.setdefault("rejected", {}).setdefault(name, {})[ind] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
            save_state(state)
            continue
        ok = push_industry(profile, ind, name)
        if ok:
            state.setdefault("pushed", {}).setdefault(name, []).append(ind)
            pushed_count += 1
            save_state(state)
    return pushed_count


def main():
    log(f"=== sync_watchdog starting (poll_interval={POLL_INTERVAL_S}s) ===")
    log(f"  repo: {REPO_PATH}")
    log(f"  state_file: {STATE_FILE}")
    log(f"  clouds: {[c['name'] for c in CLOUDS]}")
    state = load_state()
    log(f"  loaded state: pushed={ {k: len(v) for k,v in state.get('pushed',{}).items()} }")
    cycle = 0
    while True:
        cycle += 1
        cycle_start = time.time()
        log(f"--- cycle {cycle} start ---")
        cycle_pushed = 0
        for cloud in CLOUDS:
            try:
                pushed = poll_one_cloud(cloud, state)
                cycle_pushed += pushed
                if pushed > 0:
                    log(f"  [{cloud['name']}] cycle {cycle}: pushed {pushed} industries")
            except Exception as e:
                log(f"  [{cloud['name']}] cycle {cycle} threw: {str(e)[:300]}")
        elapsed = time.time() - cycle_start
        log(f"--- cycle {cycle} done in {elapsed:.0f}s, cycle_pushed={cycle_pushed}, total_pushed={sum(len(v) for v in state.get('pushed',{}).values())} ---")
        time.sleep(POLL_INTERVAL_S)


if __name__ == "__main__":
    main()
