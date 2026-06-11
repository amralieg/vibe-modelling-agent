#!/usr/bin/env python3
"""Re-run shrink (at the current SHRINK_TIMEOUT_S cap) for industries that ended ecm-only.

A shrink whose platform run is killed by too-tight a timeout BEFORE the mvm model.json is
written leaves the industry with a valid v2 ECM but no MVM (status 'partial'). The ECM is
already on the volume, so this re-submits ONLY the shrink (reads ECM model.json -> MVM),
waits for functional completion via the same terminal-state + substantive-idle hang-guard,
exports, and writes the VReq audit. Safe to run alongside the main canary driver ONLY for
industries whose driver thread has already finished (i.e. already exported partial) — never
for one with a shrink still RUNNING (that would double-submit on the same catalog).

Usage: python3 vov_finish_partials.py <industry> <profile> [<industry2> <profile2> ...]
"""
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vov_canary_finish as C
import vov_v2_marathon as M
import vov_audit_extract as A


def finish(ind, profile):
    # Guard: never double-submit if a shrink is already live on this catalog.
    if "model.json" in C.ls(profile, C.vol_artifact_dir(ind, "mvm")):
        M.pulse(f"[{ind}] mvm model.json already present — exporting + auditing only")
    else:
        sjob, srun = C.submit_shrink(profile, ind)
        M.pulse(f"[{ind}] RESUBMIT shrink job={sjob} run={srun} cap={C.SHRINK_TIMEOUT_S}s")
        res = C.wait_for_completion(ind, profile, srun, "mvm", "shrink")
        if res == "kill":
            return
    got = M.export_industry(profile, ind)
    status = "green" if (got.get("ecm") and got.get("mvm")) else ("partial" if got.get("ecm") else "red")
    state = M.load_state()
    M.set_ind(state, ind, status=status, exported=got)
    M.pulse(f"[{ind}] {status.upper()} exported ecm={got.get('ecm')} mvm={got.get('mvm')}")
    try:
        A.extract(ind, profile)
    except Exception as e:
        M.pulse(f"[{ind}] audit failed: {str(e)[:160]}")


if __name__ == "__main__":
    args = sys.argv[1:]
    pairs = list(zip(args[0::2], args[1::2]))
    import threading
    ts = [threading.Thread(target=finish, args=(i, p), name=i, daemon=False) for i, p in pairs]
    for t in ts:
        t.start()
    for t in ts:
        t.join()
    M.pulse(f"=== FINISH-PARTIALS DONE :: {[i for i,_ in pairs]} ===")
