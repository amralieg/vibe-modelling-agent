#!/bin/bash
# Emits a compact marathon status digest every 15 min for autonomous-mode pulses.
# Reads the shared state file written by vov_v2_marathon.py; no Databricks calls
# (the marathon owns polling) so this stays cheap and never races the CLI auth.
STATE="$HOME/claude/vibe-agent/vov2_state.json"
while true; do
  python3 - "$STATE" <<'PY'
import json, sys, datetime
st = json.load(open(sys.argv[1]))
inds = st.get("industries", {})
order = ["travel_hospitality","consumer_goods","automotive","ngo","retail","healthcare",
         "restaurants","semiconductors","media_broadcasting","water_utilities","manufacturing",
         "construction","health_insurance"]
now = datetime.datetime.now(datetime.timezone.utc).strftime("%H:%M:%SZ")
green = [i for i in order if inds.get(i,{}).get("status","").startswith("green")]
rows = []
for i in order:
    v = inds.get(i, {})
    s = v.get("status", "-")
    if s.startswith("green"):
        continue
    rows.append(f"{i}={s}")
print(f"PULSE {now} :: GREEN {len(green)}/13 | active: " + (", ".join(rows) if rows else "none"))
PY
  sleep 900
done
