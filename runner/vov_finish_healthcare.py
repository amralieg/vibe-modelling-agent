#!/usr/bin/env python3
"""Resubmit ONLY the healthcare shrink (v2 ECM -> v2 MVM) with an extended cap.

The first shrink hit the 2h SHRINK_TIMEOUT_S cap (TERMINATED/TIMEDOUT) before writing the MVM —
healthcare is the largest ECM (22 domains / 563 products / 24259 attrs) and ran on the slower
fe-aws endpoint. The v2 ECM is fully persisted in vibe_healthcare_v1._metamodel (audit: precision
0.889 / recall 0.889, 344 metric views), so a shrink-only resubmit with a 5h cap recovers the MVM.

Reuse-first: vov_canary_finish.submit_shrink + wait_for_completion (hang-aware MVM detection),
then M.export_industry + vov_audit_extract.extract. Only difference vs vov_finish3: a wider cap.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vov_v2_marathon as M
import vov_canary_finish as C
import vov_audit_extract as A

C.SHRINK_TIMEOUT_S = 18000  # 5h cap (was 2h) — healthcare large-model shrink on slow endpoint

IND = "healthcare"
PROFILE = "fe-aws"


def main():
    M.pulse(f"=== FINISH_HC start (resubmit {IND} shrink, cap={C.SHRINK_TIMEOUT_S}s) ===")
    state = M.load_state()
    if "model.json" in C.ls(PROFILE, C.vol_artifact_dir(IND, "mvm")):
        M.pulse(f"[{IND}] mvm already present — skip shrink")
    else:
        sjob, srun = C.submit_shrink(PROFILE, IND)
        M.set_ind(state, IND, status="shrink_running", shrink_job=sjob, shrink_run=srun)
        M.pulse(f"[{IND}] shrink resubmitted job={sjob} run={srun}")
        res = C.wait_for_completion(IND, PROFILE, srun, "mvm", "shrink")
        if res == "kill":
            M.pulse(f"[{IND}] KILL during shrink wait")
            return
    got = M.export_industry(PROFILE, IND)
    status = "green" if (got.get("ecm") and got.get("mvm")) else ("partial" if got.get("ecm") else "red")
    M.set_ind(state, IND, status=status, exported=got)
    M.pulse(f"[{IND}] {status.upper()} exported ecm={got.get('ecm')} mvm={got.get('mvm')}")
    if got.get("ecm"):
        try:
            audit = A.extract(IND, PROFILE)
            sb = (audit or {}).get("scoreboard", {})
            M.pulse(f"[{IND}] FINISH_HC AUDIT precision={sb.get('precision')} recall={sb.get('recall')} "
                    f"fulfilled={sb.get('fulfilled')}/{sb.get('total_requirements')} "
                    f"partial={sb.get('partial')} failed={sb.get('failed')}")
        except Exception as e:
            M.pulse(f"[{IND}] FINISH_HC audit failed: {str(e)[:200]}")
    M.pulse("=== FINISH_HC DONE ===")


if __name__ == "__main__":
    main()
