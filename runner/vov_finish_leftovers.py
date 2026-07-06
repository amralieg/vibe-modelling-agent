#!/usr/bin/env python3
"""Finish the 4 leftovers from the old-cap marathon wave.

Two classes, both reduced to "ECM is (or will be) on the volume -> shrink -> MVM -> export -> audit":
  - partials  (consumer_goods, semiconductors): ECM written, shrink was cap-killed before MVM.
                Their old marathon run is terminal, so drive() Phase-1 sees ecm-ready+terminal and
                goes straight to a fresh shrink.
  - reds      (retail, health_insurance): the marathon 3-task run hit the old 4h vov cap (-> no/late
                ECM), BUT an earlier UNCAPPED single-task `vibe modeling of version` run is still
                finishing the ECM naturally (~6.8h). drive() Phase-1 waits on THAT run, then shrinks.

Reuses vov_canary_finish.drive (wait-vov / submit-shrink / export) + vov_audit_extract.extract, so no
new orchestration logic. Shrink cap bumped to 5h to match the marathon's new policy; the substantive-
idle hang-guard in wait_for_completion still bounds any post-MVM teardown hang, so the larger cap is
pure upside. Safe to run alongside the marathon daemon: it only touches industries the daemon has
already finished and moved past, and submit_shrink reuses the existing ECM catalog (never drops it).
"""
import os
import sys
import threading

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vov_canary_finish as C
import vov_v2_marathon as M
import vov_audit_extract as A

C.SHRINK_TIMEOUT_S = 18000  # 5h (hang-guard bounds teardown; never truncates a slow functional shrink)

# industry -> (profile, vov_run_id)
#   vov_run_id is the run whose ECM Phase-1 waits on; if already terminal + ecm present it proceeds.
LEFTOVERS = {
    "consumer_goods":   ("fe-gcp", 526234627113671),  # partial: old marathon run (terminal) + ecm present
    "semiconductors":   ("my-gcp", 72769833656327),   # partial: old marathon run (terminal) + ecm present
    "retail":           ("fe-aws", 276358972114126),  # red: uncapped single-task vov still finishing ECM
    "health_insurance": ("my-uae", 710485709140431),  # red: uncapped single-task vov still finishing ECM
}


def run_one(ind, profile, vov_run, state):
    try:
        C.drive(ind, profile, vov_run, state)
    except Exception as e:
        M.pulse(f"[{ind}] LEFTOVER DRIVER FAILED: {str(e)[:240]}")
        return
    try:
        A.extract(ind, profile)
        M.pulse(f"[{ind}] audit stored")
    except Exception as e:
        M.pulse(f"[{ind}] audit failed: {str(e)[:160]}")


def main():
    state = M.load_state()
    M.pulse(f"=== FINISH-LEFTOVERS START :: {list(LEFTOVERS)} shrink_cap={C.SHRINK_TIMEOUT_S}s ===")
    ts = [threading.Thread(target=run_one, args=(i, p, r, state), name=i, daemon=False)
          for i, (p, r) in LEFTOVERS.items()]
    for t in ts:
        t.start()
    for t in ts:
        t.join()
    inds = state.get("industries", {})
    green = [i for i in LEFTOVERS if inds.get(i, {}).get("status") == "green"]
    M.pulse(f"=== FINISH-LEFTOVERS DONE green={len(green)}/{len(LEFTOVERS)} :: {sorted(green)} ===")


if __name__ == "__main__":
    main()
