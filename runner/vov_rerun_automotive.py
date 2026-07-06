#!/usr/bin/env python3
"""Clean re-run of automotive on an idle workspace for QUALITY.

The first automotive run (fe-gcp, 3-task install->vov->shrink) was externally CANCELLED at ~10.7h
("Run cancelled by user") during vov finalization, BEFORE the selffixer applied residual VReq fixes
(selffixer_applied=[]). Its ECM is structurally complete (581 products) but VReq adherence is only
~40% (27/69) — below the mission's 90% floor. healthcare + media_broadcasting (same age, different
workspaces) are still running, so the cancel was workspace-specific / one-off, not systematic.

This re-runs the FULL pipeline on my-adp (idle, no observed cancel) reusing the marathon's own
prepare/stage/submit/wait/export/audit functions, so the model is rebuilt identically with the full
vov + selffixer pass. Install cap trimmed to 40m (install functionally completes in <10m and only
loads _metamodel; the 2h cap just burned teardown-hang time and delayed vov). Exports overwrite
/tmp/vov_out/automotive only on success; the fe-gcp ECM remains on its volume as a recoverable
fallback. Does NOT touch the shared marathon state file (avoids the cross-process write race).
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vov_v2_marathon as M
import vov_audit_extract as A

PROFILE = "my-adp"
IND = "automotive"
M.INSTALL_TIMEOUT_S = 2400  # 40m: install loads _metamodel in <10m; trim the teardown-hang tail


def main():
    M.pulse(f"=== RERUN {IND} on {PROFILE} (clean full pipeline; prior fe-gcp run CANCELLED @~40% adherence) ===")
    try:
        M.prepare_catalog(PROFILE, IND)
        M.stage_files(PROFILE, IND)
    except Exception as e:
        M.pulse(f"[{IND}] RERUN prep failed: {str(e)[:300]}")
        return
    try:
        job_id = M.find_or_create_job(PROFILE, IND)
        run_id = M.run_now(PROFILE, job_id)
        M.pulse(f"[{IND}] RERUN submitted job={job_id} run={run_id}")
    except Exception as e:
        M.pulse(f"[{IND}] RERUN submit failed: {str(e)[:300]}")
        return
    info = M.wait_terminal(PROFILE, IND, run_id)
    M.pulse(f"[{IND}] RERUN terminal lc={info.get('lc')} result={info.get('result')} url={info.get('url')}")
    got = M.export_industry(PROFILE, IND)
    M.pulse(f"[{IND}] RERUN exported ecm={got.get('ecm')} mvm={got.get('mvm')}")
    if got.get("ecm"):
        try:
            audit = A.extract(IND, PROFILE)
            sb = (audit or {}).get("scoreboard", {})
            M.pulse(f"[{IND}] RERUN AUDIT precision={sb.get('precision')} recall={sb.get('recall')} "
                    f"fulfilled={sb.get('fulfilled')}/{sb.get('total_requirements')} "
                    f"partial={sb.get('partial')} failed={sb.get('failed')}")
        except Exception as e:
            M.pulse(f"[{IND}] RERUN audit failed: {str(e)[:160]}")
    M.pulse(f"=== RERUN {IND} DONE ecm={got.get('ecm')} mvm={got.get('mvm')} ===")


if __name__ == "__main__":
    main()
