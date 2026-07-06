#!/usr/bin/env python3
"""Hang-aware finisher for the 3 v3.5.5 reruns (automotive, healthcare, media_broadcasting).

Their full install->vov->shrink jobs each completed the ECM functionally (model.json +
next_vibes on the volume, _metamodel populated) but the vov task wedged in the post-FINAL-FLUSH
teardown (GIL-bound FUSE volume log-copy starves the daemon finalize-watchdog, so os._exit never
runs -> task stuck RUNNING until the 15h VOV_TIMEOUT). Waiting that out wastes ~6h/industry, and
shrink stays BLOCKED behind the hung vov.

Reuse-first: vov_canary_finish.drive() already encodes the exact recovery — Phase 1 waits for the
ECM with 30m substantive-idle hang-detection and CANCELS the wedged vov once model.json is present,
Phase 2 submits a bounded standalone shrink (operation='shrink ecm', model_version='2', 2h cap on
M.AGENT_PATH=_v355) and waits the MVM hang-aware, Phase 3 exports. We add the per-industry VReq
audit the user requires after each goes green.

vov run_ids captured from the v3.5.5 rerun submit (vov_rerun_v355.out):
  automotive@my-adp           run=85666859313119
  healthcare@fe-aws           run=72712100735100
  media_broadcasting@my-gcp   run=245895494291044
"""
import os
import sys
import threading

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vov_v2_marathon as M
import vov_canary_finish as C
import vov_audit_extract as A

TARGETS = {
    "automotive": ("my-adp", "85666859313119"),
    "healthcare": ("fe-aws", "72712100735100"),
    "media_broadcasting": ("my-gcp", "245895494291044"),
}


def run_one(ind, profile, vov_run_id, state):
    tag = f"[{ind}@{profile}]"
    try:
        C.drive(ind, profile, vov_run_id, state)
    except Exception as e:
        M.pulse(f"{tag} FINISH3 drive failed: {str(e)[:300]}")
        return
    # per-industry VReq audit once the ECM is exported (user directive: audit each as it completes)
    got = (state.get("industries", {}).get(ind, {}) or {}).get("exported", {})
    if got.get("ecm"):
        try:
            audit = A.extract(ind, profile)
            sb = (audit or {}).get("scoreboard", {})
            M.pulse(f"{tag} FINISH3 AUDIT precision={sb.get('precision')} recall={sb.get('recall')} "
                    f"fulfilled={sb.get('fulfilled')}/{sb.get('total_requirements')} "
                    f"partial={sb.get('partial')} failed={sb.get('failed')}")
        except Exception as e:
            M.pulse(f"{tag} FINISH3 audit failed: {str(e)[:200]}")


def main():
    M.pulse(f"=== FINISH3 start ({len(TARGETS)} industries, hang-aware ECM->shrink->MVM) ===")
    state = M.load_state()
    threads = []
    for ind, (profile, rid) in TARGETS.items():
        t = threading.Thread(target=run_one, args=(ind, profile, rid, state), name=ind, daemon=False)
        t.start()
        threads.append(t)
    for t in threads:
        t.join()
    M.pulse("=== FINISH3 DONE ===")


if __name__ == "__main__":
    main()
