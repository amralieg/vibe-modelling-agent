#!/usr/bin/env python3
"""Non-blocking healthcare base-MVM launch on v3.6.6 (<profile>).

Driver-side wait was unreliable (background process reaped between shell calls), so
this ONLY drops the catalog + submits, then exits. The job runs independently on
Databricks; we poll the run from the shell. Reuses base_mvm_proof helpers (DRY).
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import base_mvm_proof as B  # noqa: E402

M = B.M
IND, PROF, DOMAINS = "healthcare", "<profile>", ""


def main():
    M.prepare_catalog(PROF, IND)
    vibe_path = B.stage_vibe(PROF, IND)
    desc = B.read_desc(IND)
    spec = B.build_spec(IND, PROF, vibe_path, desc, DOMAINS)
    job_id = B.find_or_create_job(PROF, IND, spec)
    run_id = M.run_now(PROF, job_id)
    print(f"HEALTHCARE JOBID {job_id} RUNID {run_id} VIBE {vibe_path} AGENT {B.AGENT_PATH}")


if __name__ == "__main__":
    main()
