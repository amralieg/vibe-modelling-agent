#!/usr/bin/env python3
"""Restaurants-only v3.6.0 live VOV proof run (<profile>).

Reuses the marathon's process_industry end-to-end (prepare_catalog -> stage v1
artifacts -> create/patch job at the _v360 agent path -> run install/vov/shrink
-> export v2 -> VReq audit) for a SINGLE industry, so the v2 ECM next_vibes
score can be compared against the old v358 50/100 artifact. No pipeline logic is
duplicated; this only resets the stale 'green' restaurants state then delegates.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vov_v2_marathon as M

PROFILE = "<profile>"
IND = "restaurants"


def main():
    state = M.load_state()
    # Reset the stale 'green' (old v358 run) so process_industry runs a fresh v360 pipeline.
    state.setdefault("industries", {})[IND] = {"status": "reset_for_v360_proof"}
    M.save_state(state)
    M.pulse(f"=== RESTAURANTS v360 PROOF START on {PROFILE} (agent v{M.AGENT_VER}) ===")
    M.process_industry(PROFILE, IND, state)
    cur = state.get("industries", {}).get(IND, {})
    M.pulse(f"=== RESTAURANTS v360 PROOF DONE status={cur.get('status')} "
            f"terminal={cur.get('terminal')} run_url={cur.get('run_url')} ===")


if __name__ == "__main__":
    main()
