#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path


DEFAULT_PROFILE = "emirates-gcp"
DEFAULT_RUNNER_PATH = "/Users/amr.ali@databricks.com/vibe_runner_v71"
DEFAULT_GLOBAL_VOLUME = "/Volumes/_root/default/root_vol"
DEFAULT_SECTOR_UPLOAD_DIR = "_sectors"
DEFAULT_PULSE_FILE = os.path.expanduser("~/claude/vibe-agent/global_run_pulses.txt")
DEFAULT_STATE_FILE = os.path.expanduser("~/claude/vibe-agent/global_run_state.json")
DEFAULT_JOB_NAME = "dbx_vibe_modelling_sector_runner_v71"

KILL_FILE_NAME = "_kill.json"
PULSE_INTERVAL_S = 600
POLL_INTERVAL_S = 120
SECTOR_TIMEOUT_S = 6 * 3600
SUBMIT_RETRY_COUNT = 2
SUBMIT_RETRY_DELAY_S = 60

SECTOR_FILES_ORDER = [
    "agriculture.json",
    "real_estate_and_professional_services.json",
    "financial_services.json",
    "healthcare_and_life_sciences.json",
    "energy_and_utilities.json",
    "travel_transport_logistics.json",
    "public_sector_education_nonprofit.json",
    "communications_media_entertainment.json",
    "manufacturing.json",
    "retail_and_consumer_goods.json",
]


def now_utc():
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def now_iso_friendly():
    return datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")


def log_pulse(msg, pulse_file=DEFAULT_PULSE_FILE):
    line = f"[{now_iso_friendly()}] {msg}"
    print(line, flush=True)
    Path(os.path.dirname(pulse_file)).mkdir(parents=True, exist_ok=True)
    with open(pulse_file, "a") as f:
        f.write(line + "\n")


def db(args, profile, capture=True, timeout=300):
    cmd = ["databricks"] + args + ["--profile", profile]
    p = subprocess.run(cmd, capture_output=capture, text=True, timeout=timeout)
    if p.returncode != 0:
        raise RuntimeError(
            f"databricks {' '.join(args)} -> code={p.returncode}\nstderr={p.stderr[:1000]}"
        )
    return p.stdout


def db_json(args, profile, timeout=300):
    out = db(args + ["-o", "json"], profile, timeout=timeout)
    return json.loads(out) if out.strip() else {}


def load_state(state_file):
    if not os.path.exists(state_file):
        return {
            "started_at": now_utc(),
            "sectors": {},
            "industries": {},
            "completed_industries": [],
        }
    try:
        return json.loads(Path(state_file).read_text())
    except Exception:
        return {
            "started_at": now_utc(),
            "sectors": {},
            "industries": {},
            "completed_industries": [],
        }


def save_state(state, state_file):
    Path(os.path.dirname(state_file)).mkdir(parents=True, exist_ok=True)
    state["updated_at"] = now_utc()
    tmp = state_file + ".tmp"
    Path(tmp).write_text(json.dumps(state, indent=2, default=str))
    os.replace(tmp, state_file)


def find_or_create_job(profile, runner_path, job_name, pulse_file):
    jobs = db_json(["jobs", "list", "--limit", "100"], profile)
    items = jobs if isinstance(jobs, list) else jobs.get("jobs", [])
    for j in items:
        s = j.get("settings", {})
        if s.get("name", "") == job_name:
            log_pulse(f"[orchestrator FIRED] reusing existing job_id={j['job_id']} name='{job_name}'", pulse_file)
            return j["job_id"]
    spec = {
        "name": job_name,
        "tasks": [
            {
                "task_key": "sector_runner",
                "notebook_task": {
                    "notebook_path": runner_path,
                    "source": "WORKSPACE",
                    "base_parameters": {
                        "business_context": "",
                        "dry_run": "no",
                        "ping_interval": "1m",
                    },
                },
                "timeout_seconds": SECTOR_TIMEOUT_S,
            }
        ],
        "max_concurrent_runs": 1,
    }
    spec_path = f"/tmp/orch_job_create_{int(time.time())}.json"
    Path(spec_path).write_text(json.dumps(spec))
    res = db_json(["jobs", "create", "--json", f"@{spec_path}"], profile)
    log_pulse(f"[orchestrator FIRED] created job_id={res['job_id']} name='{job_name}'", pulse_file)
    return res["job_id"]


def upload_sector_to_volume(local_path, profile, remote_volume_dir):
    remote_dir = f"dbfs:{remote_volume_dir}"
    try:
        db(["fs", "mkdir", remote_dir], profile, timeout=60)
    except Exception as _mke:
        if "RESOURCE_ALREADY_EXISTS" not in str(_mke) and "already exists" not in str(_mke).lower():
            raise
    remote_path = f"{remote_dir}/{os.path.basename(local_path)}"
    db(["fs", "cp", str(local_path), remote_path, "--overwrite"], profile)
    return f"{remote_volume_dir}/{os.path.basename(local_path)}"


def kill_switch_present(profile, global_volume):
    remote = f"dbfs:{global_volume}/{KILL_FILE_NAME}"
    try:
        db(["fs", "ls", remote], profile, timeout=30)
        return True
    except Exception:
        return False


def submit_sector_run(profile, job_id, business_context_path):
    payload = {
        "job_id": job_id,
        "notebook_params": {
            "business_context": business_context_path,
            "dry_run": "no",
            "ping_interval": "1m",
        },
    }
    payload_path = f"/tmp/orch_run_now_{int(time.time())}.json"
    Path(payload_path).write_text(json.dumps(payload))
    res = db_json(["jobs", "run-now", "--no-wait", "--json", f"@{payload_path}"], profile)
    return res["run_id"]


def get_run_state(profile, run_id):
    info = db_json(["jobs", "get-run", str(run_id)], profile)
    state = info.get("state", {})
    return {
        "life_cycle_state": state.get("life_cycle_state"),
        "result_state": state.get("result_state"),
        "state_message": state.get("state_message", "")[:300],
        "run_page_url": info.get("run_page_url"),
        "tasks": [
            {
                "task_key": t.get("task_key"),
                "state": t.get("state", {}).get("life_cycle_state"),
                "result": t.get("state", {}).get("result_state"),
            }
            for t in info.get("tasks", [])
        ],
    }


def wait_for_run_terminal(profile, run_id, sector_label, total_industries, pulse_file, state, state_file):
    started = time.time()
    last_pulse = started
    state["sectors"].setdefault(sector_label, {})["run_id"] = run_id
    save_state(state, state_file)
    while True:
        try:
            info = get_run_state(profile, run_id)
        except Exception as e:
            log_pulse(f"  WARN poll error (will retry): {str(e)[:200]}", pulse_file)
            time.sleep(POLL_INTERVAL_S)
            continue
        lc = info.get("life_cycle_state")
        if lc in ("TERMINATED", "INTERNAL_ERROR", "SKIPPED"):
            log_pulse(
                f"  [{sector_label}] runner job terminated: life_cycle={lc} "
                f"result={info.get('result_state')} url={info.get('run_page_url')}",
                pulse_file,
            )
            return info
        elapsed = time.time() - started
        if (time.time() - last_pulse) >= PULSE_INTERVAL_S:
            tasks_summary = ", ".join(
                f"{t['task_key']}={t['state'] or '?'}/{t['result'] or '?'}" for t in info.get("tasks", [])
            )
            log_pulse(
                f"  PULSE [{sector_label}] elapsed={int(elapsed/60)}min "
                f"life_cycle={lc} tasks=[{tasks_summary}] "
                f"completed_industries={len(state.get('completed_industries', []))}/40",
                pulse_file,
            )
            last_pulse = time.time()
        if elapsed > SECTOR_TIMEOUT_S:
            log_pulse(
                f"  [{sector_label}] HARD TIMEOUT after {SECTOR_TIMEOUT_S}s — cancelling run {run_id}",
                pulse_file,
            )
            try:
                db(["jobs", "cancel-run", str(run_id)], profile)
            except Exception:
                pass
            return {"life_cycle_state": "TERMINATED", "result_state": "CANCELED",
                    "state_message": "orchestrator hard timeout"}
        time.sleep(POLL_INTERVAL_S)


def sanitize_name(name):
    import re
    s = name.lower().strip()
    s = re.sub(r"[^a-z0-9]+", "_", s)
    s = re.sub(r"_+", "_", s).strip("_")
    return s


def industry_manifest_path(global_volume, industry_name):
    return f"{global_volume}/{sanitize_name(industry_name)}/_manifest.json"


def industry_is_done(profile, global_volume, industry_name):
    remote = f"dbfs:{industry_manifest_path(global_volume, industry_name)}"
    try:
        local = f"/tmp/orch_manifest_{sanitize_name(industry_name)}_{int(time.time())}.json"
        db(["fs", "cp", remote, local, "--overwrite"], profile, timeout=30)
        m = json.loads(Path(local).read_text())
        return bool(m.get("run_metadata", {}).get("all_tasks_succeeded"))
    except Exception:
        return False


def build_single_industry_payload(sector_payload, industry_name):
    return {
        "widget_values": sector_payload["widget_values"],
        "businesses": [b for b in sector_payload["businesses"] if b["name"] == industry_name],
    }


def process_sector(profile, job_id, sector_label, sector_local_path, global_volume,
                   sector_upload_dir, pulse_file, state, state_file):
    sector_payload = json.loads(Path(sector_local_path).read_text())
    industries = [b["name"] for b in sector_payload["businesses"]]
    log_pulse(f"=== SECTOR START: {sector_label} ({len(industries)} industries: {', '.join(industries)}) ===", pulse_file)

    pending = []
    for ind in industries:
        if industry_is_done(profile, global_volume, ind):
            log_pulse(f"  [{sector_label}] SKIP {ind} — manifest indicates already done", pulse_file)
            if ind not in state.get("completed_industries", []):
                state.setdefault("completed_industries", []).append(ind)
            state.setdefault("industries", {})[ind] = {"status": "skipped_already_done", "ts": now_utc()}
        else:
            pending.append(ind)
    save_state(state, state_file)

    if not pending:
        log_pulse(f"  [{sector_label}] all {len(industries)} industries already complete — skipping sector run", pulse_file)
        return

    if pending == industries:
        upload_path = upload_sector_to_volume(sector_local_path, profile, sector_upload_dir)
        run_payload_label = sector_label
    else:
        partial_payload = {
            "widget_values": sector_payload["widget_values"],
            "businesses": [b for b in sector_payload["businesses"] if b["name"] in pending],
        }
        partial_local = f"/tmp/orch_partial_{sanitize_name(sector_label)}_{int(time.time())}.json"
        Path(partial_local).write_text(json.dumps(partial_payload, indent=2))
        upload_path = upload_sector_to_volume(partial_local, profile, sector_upload_dir)
        run_payload_label = f"{sector_label}_partial"
        log_pulse(f"  [{sector_label}] partial-resume: running {len(pending)}/{len(industries)} industries", pulse_file)

    submit_attempt = 0
    run_id = None
    while submit_attempt <= SUBMIT_RETRY_COUNT:
        try:
            run_id = submit_sector_run(profile, job_id, upload_path)
            break
        except Exception as e:
            submit_attempt += 1
            log_pulse(f"  [{sector_label}] submit attempt {submit_attempt} failed: {str(e)[:200]}", pulse_file)
            time.sleep(SUBMIT_RETRY_DELAY_S)
    if run_id is None:
        log_pulse(f"  [{sector_label}] FAILED to submit after {SUBMIT_RETRY_COUNT+1} attempts — skipping sector", pulse_file)
        state.setdefault("sectors", {})[sector_label] = {"status": "submit_failed", "ts": now_utc()}
        save_state(state, state_file)
        return

    log_pulse(f"  [{sector_label}] submitted run_id={run_id}", pulse_file)
    info = wait_for_run_terminal(profile, run_id, run_payload_label, len(pending), pulse_file, state, state_file)

    log_pulse(f"  [{sector_label}] post-run manifest scan...", pulse_file)
    failed = []
    for ind in pending:
        if industry_is_done(profile, global_volume, ind):
            if ind not in state.get("completed_industries", []):
                state.setdefault("completed_industries", []).append(ind)
            state.setdefault("industries", {})[ind] = {"status": "green", "ts": now_utc(), "run_id": run_id}
            log_pulse(f"    GREEN {ind}", pulse_file)
        else:
            failed.append(ind)
            state.setdefault("industries", {})[ind] = {"status": "red", "ts": now_utc(), "run_id": run_id}
            log_pulse(f"    RED   {ind} (no manifest or all_tasks_succeeded=false)", pulse_file)
    save_state(state, state_file)

    if failed:
        log_pulse(f"  [{sector_label}] retrying {len(failed)} failed industries one-by-one", pulse_file)
        for ind in failed:
            single_payload = build_single_industry_payload(sector_payload, ind)
            single_local = f"/tmp/orch_retry_{sanitize_name(ind)}_{int(time.time())}.json"
            Path(single_local).write_text(json.dumps(single_payload, indent=2))
            single_remote = upload_sector_to_volume(single_local, profile, sector_upload_dir)
            try:
                retry_run_id = submit_sector_run(profile, job_id, single_remote)
                log_pulse(f"    RETRY {ind} run_id={retry_run_id}", pulse_file)
                wait_for_run_terminal(profile, retry_run_id, f"{sector_label}_retry_{sanitize_name(ind)}",
                                      1, pulse_file, state, state_file)
                if industry_is_done(profile, global_volume, ind):
                    if ind not in state.get("completed_industries", []):
                        state.setdefault("completed_industries", []).append(ind)
                    state["industries"][ind] = {"status": "green_after_retry", "ts": now_utc(), "run_id": retry_run_id}
                    log_pulse(f"    RECOVERED {ind} after retry", pulse_file)
                else:
                    state["industries"][ind] = {"status": "red_after_retry", "ts": now_utc(), "run_id": retry_run_id}
                    log_pulse(f"    PERMANENT-RED {ind} after retry", pulse_file)
                save_state(state, state_file)
            except Exception as e:
                log_pulse(f"    RETRY-SUBMIT-FAIL {ind}: {str(e)[:300]}", pulse_file)
                state["industries"][ind] = {"status": "retry_submit_failed", "ts": now_utc()}
                save_state(state, state_file)

    state.setdefault("sectors", {})[sector_label] = {
        "status": "complete",
        "ts": now_utc(),
        "industries_total": len(industries),
        "industries_done": sum(
            1 for ind in industries
            if state.get("industries", {}).get(ind, {}).get("status", "").startswith("green")
        ),
    }
    save_state(state, state_file)
    log_pulse(f"=== SECTOR END:   {sector_label} ===", pulse_file)


def preflight(profile, runner_path, global_volume, pulse_file):
    log_pulse(f"=== PRE-FLIGHT (profile={profile}) ===", pulse_file)

    me = db_json(["current-user", "me"], profile)
    log_pulse(f"  [preflight FIRED] auth ok user={me.get('userName')}", pulse_file)

    try:
        db(["workspace", "get-status", runner_path], profile)
        log_pulse(f"  [preflight FIRED] runner notebook reachable: {runner_path}", pulse_file)
    except Exception as e:
        log_pulse(f"  [preflight] FAILED: runner notebook unreachable at {runner_path}: {str(e)[:200]}", pulse_file)
        return False

    try:
        db(["fs", "ls", f"dbfs:{global_volume}"], profile, timeout=60)
        log_pulse(f"  [preflight FIRED] global_collection_volume reachable: {global_volume}", pulse_file)
    except Exception as e:
        log_pulse(f"  [preflight] FAILED: global volume unreachable {global_volume}: {str(e)[:200]}", pulse_file)
        return False

    sectors_subdir = f"{global_volume.rstrip('/')}/_sectors"
    try:
        db(["fs", "mkdir", f"dbfs:{sectors_subdir}"], profile, timeout=60)
        log_pulse(f"  [preflight FIRED] sectors upload subdir ready: {sectors_subdir}", pulse_file)
    except Exception as e:
        if "RESOURCE_ALREADY_EXISTS" in str(e) or "already exists" in str(e).lower():
            log_pulse(f"  [preflight FIRED] sectors upload subdir already present: {sectors_subdir}", pulse_file)
        else:
            log_pulse(f"  [preflight] FAILED: cannot create sectors upload subdir {sectors_subdir}: {str(e)[:200]}", pulse_file)
            return False

    try:
        active = db_json(["jobs", "list-runs", "--active-only", "--limit", "25"], profile)
        runs = active if isinstance(active, list) else active.get("runs", [])
        if runs:
            log_pulse(f"  [preflight] WARN: {len(runs)} active runs already on workspace", pulse_file)
            for r in runs[:5]:
                log_pulse(f"    active run_id={r.get('run_id')} job_id={r.get('job_id')}", pulse_file)
        else:
            log_pulse(f"  [preflight FIRED] no active runs on workspace", pulse_file)
    except Exception as e:
        log_pulse(f"  [preflight] WARN active-runs probe failed: {str(e)[:200]}", pulse_file)

    return True


def main():
    parser = argparse.ArgumentParser(description="Sequentially submit 10 sector runs through the canonical runner job on emirates-gcp.")
    parser.add_argument("--profile", default=DEFAULT_PROFILE)
    parser.add_argument("--runner-path", default=DEFAULT_RUNNER_PATH)
    parser.add_argument("--global-volume", default=DEFAULT_GLOBAL_VOLUME)
    parser.add_argument("--sector-upload-subdir", default=DEFAULT_SECTOR_UPLOAD_DIR)
    parser.add_argument("--job-name", default=DEFAULT_JOB_NAME)
    parser.add_argument("--pulse-file", default=DEFAULT_PULSE_FILE)
    parser.add_argument("--state-file", default=DEFAULT_STATE_FILE)
    parser.add_argument("--sectors-dir", default=str(Path(__file__).resolve().parent / "industry-sectors"))
    parser.add_argument("--dry-preflight", action="store_true",
                        help="Run pre-flight checks only and exit without submitting any sector.")
    args = parser.parse_args()

    sectors_dir = Path(args.sectors_dir)
    if not sectors_dir.exists():
        print(f"FATAL: sectors_dir not found: {sectors_dir}", file=sys.stderr)
        sys.exit(2)

    sector_paths = []
    for fname in SECTOR_FILES_ORDER:
        p = sectors_dir / fname
        if not p.exists():
            print(f"FATAL: sector file missing: {p}", file=sys.stderr)
            sys.exit(2)
        sector_paths.append(p)

    sector_upload_dir = f"{args.global_volume}/{args.sector_upload_subdir}"
    state = load_state(args.state_file)
    save_state(state, args.state_file)

    if not preflight(args.profile, args.runner_path, args.global_volume, args.pulse_file):
        print("FATAL: pre-flight failed", file=sys.stderr)
        sys.exit(3)

    if args.dry_preflight:
        log_pulse("[orchestrator] --dry-preflight specified — exiting before any sector submission", args.pulse_file)
        return

    job_id = find_or_create_job(args.profile, args.runner_path, args.job_name, args.pulse_file)
    state["job_id"] = job_id
    save_state(state, args.state_file)

    log_pulse(f"[orchestrator FIRED] starting 10-sector loop "
              f"profile={args.profile} job_id={job_id} runner={args.runner_path} "
              f"global_volume={args.global_volume}", args.pulse_file)

    for spath in sector_paths:
        sector_label = spath.stem
        if kill_switch_present(args.profile, args.global_volume):
            log_pulse(f"[orchestrator] KILL-SWITCH detected at "
                      f"{args.global_volume}/{KILL_FILE_NAME} — exiting cleanly before {sector_label}",
                      args.pulse_file)
            return
        try:
            process_sector(
                args.profile, job_id, sector_label, str(spath),
                args.global_volume, sector_upload_dir,
                args.pulse_file, state, args.state_file
            )
        except KeyboardInterrupt:
            log_pulse(f"[orchestrator] KeyboardInterrupt during {sector_label} — saving state and exiting",
                      args.pulse_file)
            save_state(state, args.state_file)
            return
        except Exception as e:
            log_pulse(f"[orchestrator] UNCAUGHT during {sector_label}: {str(e)[:500]}",
                      args.pulse_file)
            state.setdefault("sectors", {})[sector_label] = {
                "status": "uncaught_exception",
                "error": str(e)[:500],
                "ts": now_utc(),
            }
            save_state(state, args.state_file)

    completed = len(state.get("completed_industries", []))
    log_pulse(f"=== ORCHESTRATOR DONE — {completed}/40 industries green ===", args.pulse_file)


if __name__ == "__main__":
    main()
