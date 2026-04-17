# Vibe Modelling Agent — Testing Guide

**Last updated:** 2026-04-17
**Author:** Testing learnings from iterative debugging session

---

## Quick Reference

| Item | Value |
|---|---|
| Workspace | `https://8259555029405006.6.gcp.databricks.com` |
| Databricks CLI profile | `emirates-gcp` |
| Workspace path | `/Workspace/Users/amr.ali@databricks.com/vibe-modelling-agent` |
| Repo object ID | `488885014400345` |
| SQL Warehouse ID | `2023d0a3a188bd24` |
| Agent notebook | `agent/dbx_vibe_modelling_agent` (70K+ lines, single code cell) |
| Vibe tester | `tests/vibe_tester.ipynb` |
| Vibe runner | `runner/vibe_runner.ipynb` |
| Industries config | `runner/my-industries.json` |
| Git repo | `https://github.com/amralieg/vibe-modelling-agent` |
| Branch for development | `dev` |

---

## Architecture: How Tests Execute

```
vibe_tester (10 tests)
  └── Test 00: calls vibe_runner via dbutils.notebook.run
        └── vibe_runner creates a 4-task Databricks Job:
              ├── Task 1: ECM Generate (agent notebook, new base model, ECM scope)
              ├── Task 2: ECM Install (agent notebook, install model) [depends on Task 1]
              ├── Task 3: MVM Shrink (agent notebook, shrink ecm) [depends on Task 1]
              └── Task 4: MVM Install (agent notebook, install model) [depends on Task 3]
  └── Tests 01-04: call agent directly via dbutils.notebook.run
  └── Tests 10/10c/10d: context-file install tests
```

**CRITICAL:** The vibe_tester's Phase 8 cleanup DROPS ALL TEST CATALOGS after tests complete. This destroys all logs, progress data, and model artifacts. You MUST capture evidence DURING the run, not after.

---

## How to Deploy Code Changes

### Step 1: Edit the agent source
The notebook is too large (5MB) to edit directly. Use this workflow:

```bash
# Extract Python source for editing
python3 -c "
import json
with open('agent/dbx_vibe_modelling_agent.ipynb') as f:
    nb = json.load(f)
src = ''.join(nb['cells'][1]['source'])
with open('/tmp/agent_source.py', 'w') as f:
    f.write(src)
"

# Edit /tmp/agent_source.py using the Edit tool
# ...

# Rebuild the notebook from edited source
python3 /tmp/rebuild_notebook.py /tmp/agent_source.py agent/dbx_vibe_modelling_agent.ipynb agent/dbx_vibe_modelling_agent.ipynb
```

The rebuild script (`/tmp/rebuild_notebook.py`):
```python
import json
def rebuild(source_py_path, original_ipynb_path, output_ipynb_path):
    with open(original_ipynb_path) as f:
        nb = json.load(f)
    with open(source_py_path) as f:
        new_source = f.read()
    lines = new_source.split('\n')
    source_lines = []
    for i, line in enumerate(lines):
        if i < len(lines) - 1:
            source_lines.append(line + '\n')
        else:
            if line:
                source_lines.append(line)
    nb['cells'][1]['source'] = source_lines
    with open(output_ipynb_path, 'w') as f:
        json.dump(nb, f, indent=1, ensure_ascii=False)
if __name__ == "__main__":
    import sys
    rebuild(sys.argv[1], sys.argv[2], sys.argv[3])
```

### Step 2: Commit and push
```bash
git add agent/dbx_vibe_modelling_agent.ipynb
git commit -m "description"
git push origin dev
```

### Step 3: Sync workspace
```bash
databricks repos update 488885014400345 --branch dev --profile emirates-gcp
```

### Step 4: VERIFY the sync worked
```bash
# Check head commit matches
databricks api get "/api/2.0/repos/488885014400345" --profile emirates-gcp | python3 -c "
import sys, json
data = json.loads(sys.stdin.read())
print(f'Head: {data.get(\"head_commit_id\", \"?\")[:10]}')
"

# Compare with local
git log --oneline -1
```

**WARNING:** The notebook `modified_at` timestamp does NOT change if the repo sync pulls the same commit. Always verify by checking `head_commit_id`.

---

## Pre-Test Cleanup (MANDATORY before every run)

```bash
# 1. Drop ALL non-system catalogs
databricks api post "/api/2.0/sql/statements" --profile emirates-gcp --json '{
  "warehouse_id": "2023d0a3a188bd24",
  "statement": "SELECT catalog_name FROM system.information_schema.catalogs WHERE catalog_name NOT IN ('"'"'lakehouse_data_models_feip_186'"'"', '"'"'system'"'"', '"'"'samples'"'"')",
  "wait_timeout": "50s"
}'
# Then DROP each one:
# DROP CATALOG IF EXISTS <name> CASCADE

# 2. Delete ALL jobs
databricks api get "/api/2.1/jobs/list" --profile emirates-gcp
# Then delete each: POST /api/2.1/jobs/delete with {"job_id": ...}

# 3. Sync workspace (Step 3 above)
# 4. Verify sync (Step 4 above)
```

---

## How to Submit a Test

### Option A: Via vibe_tester (full 10-test suite)
```bash
databricks jobs submit --no-wait --profile emirates-gcp --json '{
  "run_name": "vibe_tester_<name>",
  "tasks": [{
    "task_key": "vibe_tester",
    "notebook_task": {
      "notebook_path": "/Workspace/Users/amr.ali@databricks.com/vibe-modelling-agent/tests/vibe_tester",
      "base_parameters": {
        "business_name": "<name>",
        "business_description": "<description>",
        "model_vibes": "<vibes or empty>",
        "catalog": "<catalog_name>"
      },
      "source": "WORKSPACE"
    },
    "environment_key": "Default",
    "timeout_seconds": 43200
  }],
  "environments": [{"environment_key": "Default", "spec": {"client": "1"}}]
}'
```

**WARNING:** vibe_tester destroys catalogs after tests. You CANNOT inspect results post-mortem unless you capture them during the run.

### Option B: Via vibe_runner (ECM+MVM generation only, catalogs survive)
The runner needs `my-industries.json` at a workspace path. Running it directly via `jobs submit` with `base_parameters` does NOT work — it looks for the JSON file.

### Option C: Direct agent call
Running the agent directly via `jobs submit` with `base_parameters` exits in 33 seconds with no work done. The agent's widgets are designed for `dbutils.notebook.run` invocation, not standalone job parameters.

**RECOMMENDED:** Use vibe_tester but monitor aggressively during the run.

---

## How to Monitor a Running Test

### Check run status
```bash
databricks api get "/api/2.1/jobs/runs/get" --profile emirates-gcp --json '{"run_id": <RUN_ID>}'
```

### Monitor progress via SQL (REAL-TIME)
The agent writes progress to `<catalog>._metamodel._vibe_progress`. This is your LIVE window:

```bash
# All completed/failed steps
databricks api post "/api/2.0/sql/statements" --profile emirates-gcp --json '{
  "warehouse_id": "2023d0a3a188bd24",
  "statement": "SELECT stage_name, step_name, status, LEFT(message, 160) as msg FROM <catalog>._metamodel._vibe_progress WHERE status IN ('"'"'stage_succeeded'"'"', '"'"'stage_failed'"'"', '"'"'stage_warning'"'"') LIMIT 50",
  "wait_timeout": "50s"
}'

# Check for failures specifically
"SELECT stage_name, step_name, LEFT(message, 250) as msg FROM <catalog>._metamodel._vibe_progress WHERE status = 'stage_failed' LIMIT 10"

# Check attribute generation progress
"SELECT COUNT(*) FROM <catalog>._metamodel._vibe_progress WHERE stage_name LIKE '%Enriching%' AND status = 'stage_in_progress'"

# Check for FK linking / MV14 / MV15 / deployment
"SELECT stage_name, step_name, status, LEFT(message, 160) as msg FROM <catalog>._metamodel._vibe_progress WHERE stage_name LIKE '%Cross%' OR stage_name LIKE '%FK%' OR stage_name LIKE '%Integrity%' OR stage_name LIKE '%Naming%' OR stage_name LIKE '%Physical%' OR step_name LIKE '%MV14%' OR step_name LIKE '%MV15%'"

# Check deployed products
"SELECT domain, COUNT(*) as products FROM <catalog>._metamodel.product GROUP BY domain ORDER BY domain"

# Check deployed attributes
"SELECT COUNT(*) FROM <catalog>._metamodel.attribute"
```

**The catalog name depends on the test:**
- vibe_tester Test 00 creates: `<name>_ecm`, `<name>_mvm_v1`, `<name>_ecm_v1`
- The ECM generation writes to `<name>_ecm._metamodel`
- The base catalog `<name>` is created by the tester for its own use

### Read logs from volume (only available AFTER run completes)
```bash
TOKEN=$(databricks auth token --profile emirates-gcp 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('access_token',''))")

# List log directories
curl -s "https://8259555029405006.6.gcp.databricks.com/api/2.0/fs/directories/Volumes/<catalog>/_metamodel/vol_root/logs/" \
  -H "Authorization: Bearer $TOKEN"

# Read info log (contains [Phase F], [MV14], [MV15], [MV2], [MV4], [MV5] markers)
curl -s "https://8259555029405006.6.gcp.databricks.com/api/2.0/fs/files/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/v1_ecm/<business>_info_v1_ecm.log" \
  -H "Authorization: Bearer $TOKEN"

# Read error log (contains stack traces)
curl -s "https://8259555029405006.6.gcp.databricks.com/api/2.0/fs/files/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/v1_ecm/<business>_error_v1_ecm.log" \
  -H "Authorization: Bearer $TOKEN"

# Read vibe_tester summary
curl -s "https://8259555029405006.6.gcp.databricks.com/api/2.0/fs/files/Volumes/<catalog>/_metamodel/vol_root/logs/vibe_tester/<run_name>/test_summary.log" \
  -H "Authorization: Bearer $TOKEN"
```

**CRITICAL:** Logs are written to LOCAL temp files during the run and only uploaded to the volume at the END (`_finalize_logs` in the `finally` block). During the run, volume log files are 0 bytes. The ONLY way to see live logs is from the notebook output in the Databricks UI or from the progress table.

---

## Known Pipeline Stages and Timing

For a 3-domain, 15-product airline model:

| Time | Stage | Notes |
|---|---|---|
| 0-1 min | Setup, Vibe Parsing | Session init, widget parsing |
| 1-2 min | Business Context (Step 1) | LLM generates 12 Phase F fields |
| 2-4 min | Domain Generation (Step 2) | 3 ensemble LLM calls + judge |
| 4-5 min | Product Generation (Step 3) | Parallel across domains |
| 5-6 min | Architect Review (Step 3.7) | Score + recommendations |
| 6-12 min | Attribute Generation (Step 4) | 8 concurrent LLM calls |
| 12-13 min | Normalization (Step 4.6) | 9 batches parallel |
| **13-16 min** | **FK Linking (Steps 5-7)** | **CRASH POINT for NameError bugs** |
| 16-17 min | MV14 Process-Flow FK Gate | New — adds missing FK edges |
| 17-18 min | MV15 FK Semantic Gate | New — removes wrong FK edges |
| 18-19 min | Naming Conventions (Step 8) | Prefixes/suffixes |
| 19-20 min | Subdomain Allocation (Step 8c) | Products to subdomains |
| 20-25 min | Physical Schema Deploy (Track 2) | CREATE TABLE statements |
| 25-30 min | Artifacts (Track 3) | README, DBML, JSON, Excel |
| 30+ min | Cleanup + Log Upload (Track 4) | Logs written to volume |

---

## Common Failure Patterns

### 1. NameError: name 'X' is not defined
**Root cause:** A function references a variable that's not in its parameter list or closure scope. Most common when adding `config.get()` calls inside functions that don't take `config`.

**How to find:** Search for the function name from the error, check its parameter list, find the line that references the undefined variable.

**Fix pattern:** Add `config=None` as a default parameter to the function.

**Prevention:** After any edit that adds `config.get()`, `bc.get()`, or similar to a function, VERIFY the function signature includes that variable. Run:
```python
grep -n "def <function_name>" /tmp/agent_source.py
```

### 2. AttributeError: 'NoneType' object has no attribute 'get'
**Root cause:** Calling `.get()` on a None value. Common when `config` is None in optional-parameter functions.

**Fix pattern:** Replace `config.get(...)` with `(config or {}).get(...)`.

**Prevention:** ALL `config.get()` calls in new code should use `(config or {}).get()`.

### 3. KeyError in .format()
**Root cause:** A prompt template has a `{placeholder}` that isn't provided in the `.format()` call.

**Prevention:** The `smoke_render_all_prompts()` function (Phase A) catches these at notebook load.

### 4. vibe_tester Test 00 FAILED — cascade skip
**Root cause:** The vibe_runner's 4-task job failed. Could be any of the 4 tasks. The error message is generic ("Workload failed").

**How to investigate:** Check the progress table in the ECM catalog DURING the run. The failure details are in the ECM error log which is destroyed when the tester cleans up.

### 5. Stale code after sync
**Root cause:** The workspace repo sync completed but the notebook wasn't updated (timing issue, or sync happened after job creation).

**Prevention:** Always verify `head_commit_id` matches your latest commit BEFORE submitting a test.

---

## Key Log Markers to Search For

In the info log, search for these markers added by the overhaul:

| Marker | What it tells you |
|---|---|
| `[Phase F]` | Which of the 12 business context fields were populated |
| `[Phase F] Extended context: X/12 fields populated` | Summary of context quality |
| `[MV2]` | MVM size clamp result (within bounds or triggered) |
| `[MV4]` | Industry anchor entity check (present or missing) |
| `[MV5]` | Shared domain cap check (within 15% or exceeded) |
| `[MV8]` | MVM metadata reset after shrink |
| `[MV14]` | Process-flow FK completeness (edges added) |
| `[MV15]` | FK semantic correctness (invalid FKs removed) |
| `[MEM]` | Memory usage at step boundaries |
| `[Sanity]` | Prompt audit and smoke render results |
| `[QUALITY]` | Domain name validation against forbidden list |
| `NEXT-VIBES FEEDBACK` | End-of-run summary with BLOCKING/SAFE_IGNORE counts |

---

## How to Inspect Generated Model Quality

After a successful run (before tester cleanup), query:

```sql
-- Domain structure
SELECT domain, division, description FROM <catalog>._metamodel.domain ORDER BY domain;

-- Products per domain
SELECT domain, product, description, type, division
FROM <catalog>._metamodel.product ORDER BY domain, product;

-- Attribute count per product
SELECT p.domain, p.product, COUNT(a.attribute) as attrs
FROM <catalog>._metamodel.product p
JOIN <catalog>._metamodel.attribute a ON p.domain = a.domain AND p.product = a.product
GROUP BY p.domain, p.product ORDER BY p.domain, p.product;

-- FK integrity check
SELECT a.domain, a.product, a.attribute, a.foreign_key_to
FROM <catalog>._metamodel.attribute a
WHERE a.foreign_key_to IS NOT NULL AND a.foreign_key_to != ''
ORDER BY a.domain, a.product;

-- Check for domain bloat (>25%)
SELECT domain, COUNT(*) as products,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM <catalog>._metamodel.product), 1) as pct
FROM <catalog>._metamodel.product GROUP BY domain ORDER BY products DESC;

-- Check for orphan FKs (FK target doesn't exist)
SELECT a.domain, a.product, a.attribute, a.foreign_key_to,
       SPLIT(a.foreign_key_to, '\\.')[0] as fk_domain,
       SPLIT(a.foreign_key_to, '\\.')[1] as fk_product
FROM <catalog>._metamodel.attribute a
WHERE a.foreign_key_to != ''
  AND CONCAT(SPLIT(a.foreign_key_to, '\\.')[0], '.', SPLIT(a.foreign_key_to, '\\.')[1])
      NOT IN (SELECT CONCAT(domain, '.', product) FROM <catalog>._metamodel.product);
```

---

## IP ACL Warning

The workspace has IP access lists. Your IP may get blocked intermittently:
```
Error: Source IP address: X.X.X.X is blocked by Databricks IP ACL
```

This is transient — retry in a few minutes. If persistent, check with the workspace admin.

---

## TODO: Log Preservation (Not Yet Implemented)

The vibe_tester destroys catalogs (and therefore logs) after Phase 8 cleanup. A future improvement should:
1. Have the vibe_tester pass a persistent `log_catalog` to the vibe_runner
2. Have the runner copy all logs to `{log_catalog}._metadata.run_logs` before the tester drops test catalogs
3. Have the agent write its run URL to `/Volumes/{catalog}/_metamodel/vol_root/logs/jobs/` at startup for tracking child jobs
