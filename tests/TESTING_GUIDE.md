# Vibe Modelling Agent — Testing Guide

**Last updated:** 2026-04-17
**Author:** Testing learnings from iterative debugging session

---

## Quick Reference

| Item | Value |
|---|---|
| Agent notebook | `agent/dbx_vibe_modelling_agent` (70K+ lines, single code cell) |
| Vibe tester | `tests/vibe_tester.ipynb` |
| Vibe runner | `runner/vibe_runner.ipynb` |
| Industries config | `runner/my-industries.json` |
| Branch for development | `dev` |

**Environment-specific values** (set these for your workspace):
```bash
# Set these once per environment
export DBX_PROFILE="your-databricks-cli-profile"
export DBX_REPO_ID="your-repo-object-id"
export DBX_WAREHOUSE_ID="your-sql-warehouse-id"
export DBX_WORKSPACE_PATH="/Workspace/Users/your-email/vibe-modelling-agent"
```

---

## Architecture: How Tests Execute

```
vibe_tester (10 tests)
  └── Test 00: calls vibe_runner via dbutils.notebook.run
        └── vibe_runner creates a 5-task Databricks Job:
              ├── Task 1: ECM Generate (new base model, ECM scope)
              ├── Task 2: ECM Install (install model) [depends on Task 1]
              ├── Task 3: ECM Uninstall Staging [depends on Task 1]
              ├── Task 4: MVM Shrink (shrink ecm) [depends on Task 3]
              └── Task 5: MVM Install (install model) [depends on Task 4]
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

# Edit /tmp/agent_source.py
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
databricks repos update $DBX_REPO_ID --branch dev --profile $DBX_PROFILE
```

### Step 4: VERIFY the sync worked
```bash
databricks api get "/api/2.0/repos/$DBX_REPO_ID" --profile $DBX_PROFILE | python3 -c "
import sys, json
data = json.loads(sys.stdin.read())
print(f'Head: {data.get(\"head_commit_id\", \"?\")[:10]}')
"
# Compare with local
git log --oneline -1
```

**WARNING:** The notebook `modified_at` timestamp does NOT reliably indicate the content version. Always verify by checking `head_commit_id`.

---

## Pre-Test Cleanup (MANDATORY before every run)

```bash
# 1. Drop ALL non-system catalogs
databricks api post "/api/2.0/sql/statements" --profile $DBX_PROFILE --json '{
  "warehouse_id": "'$DBX_WAREHOUSE_ID'",
  "statement": "SELECT catalog_name FROM system.information_schema.catalogs WHERE catalog_name NOT IN ('"'"'system'"'"', '"'"'samples'"'"')",
  "wait_timeout": "50s"
}'
# Then DROP each returned catalog:
# DROP CATALOG IF EXISTS <name> CASCADE

# 2. Delete ALL jobs
databricks api get "/api/2.1/jobs/list" --profile $DBX_PROFILE
# Then delete each: POST /api/2.1/jobs/delete with {"job_id": ...}

# 3. Sync workspace (Step 3 above)
# 4. Verify sync (Step 4 above)
```

---

## How to Submit a Test

### Via vibe_tester (full 10-test suite)
```bash
databricks jobs submit --no-wait --profile $DBX_PROFILE --json '{
  "run_name": "vibe_tester_<name>",
  "tasks": [{
    "task_key": "vibe_tester",
    "notebook_task": {
      "notebook_path": "'$DBX_WORKSPACE_PATH'/tests/vibe_tester",
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

**NOTE:** Running the agent directly via `jobs submit` with `base_parameters` does NOT work — the agent exits in ~33 seconds with no work done. The agent's widgets require `dbutils.notebook.run` invocation (which vibe_tester and vibe_runner provide).

---

## How to Monitor a Running Test

### Check run status
```bash
databricks api get "/api/2.1/jobs/runs/get" --profile $DBX_PROFILE --json '{"run_id": <RUN_ID>}'
```

### Monitor progress via SQL (REAL-TIME)
The agent writes progress to `<catalog>._metamodel._vibe_progress`. This is your LIVE window:

```sql
-- All completed/failed steps
SELECT stage_name, step_name, status, LEFT(message, 160) as msg
FROM <catalog>._metamodel._vibe_progress
WHERE status IN ('stage_succeeded', 'stage_failed', 'stage_warning')
LIMIT 50;

-- Check for failures specifically
SELECT stage_name, step_name, LEFT(message, 250) as msg
FROM <catalog>._metamodel._vibe_progress
WHERE status = 'stage_failed'
LIMIT 10;

-- Check attribute generation progress
SELECT COUNT(*)
FROM <catalog>._metamodel._vibe_progress
WHERE stage_name LIKE '%Enriching%' AND status = 'stage_in_progress';

-- Check for FK linking / MV14 / MV15 / deployment
SELECT stage_name, step_name, status, LEFT(message, 160) as msg
FROM <catalog>._metamodel._vibe_progress
WHERE stage_name LIKE '%Cross%' OR stage_name LIKE '%FK%'
   OR stage_name LIKE '%Integrity%' OR stage_name LIKE '%Naming%'
   OR stage_name LIKE '%Physical%' OR step_name LIKE '%MV14%'
   OR step_name LIKE '%MV15%';

-- Check deployed products
SELECT domain, COUNT(*) as products
FROM <catalog>._metamodel.product
GROUP BY domain ORDER BY domain;

-- Check deployed attributes
SELECT COUNT(*) FROM <catalog>._metamodel.attribute;
```

Run SQL via CLI:
```bash
databricks api post "/api/2.0/sql/statements" --profile $DBX_PROFILE --json '{
  "warehouse_id": "'$DBX_WAREHOUSE_ID'",
  "statement": "<SQL>",
  "wait_timeout": "50s"
}'
```

**The catalog name depends on the test:**
- vibe_tester Test 00 creates: `<name>_ecm`, `<name>_mvm_v1`, `<name>_ecm_v1`
- The ECM generation writes to `<name>_ecm._metamodel`
- The base catalog `<name>` is created by the tester

### Monitor runner child job tasks
```bash
# Find the runner job
databricks api get "/api/2.1/jobs/list" --profile $DBX_PROFILE
# Get its run
databricks api get "/api/2.1/jobs/runs/list" --profile $DBX_PROFILE --json '{"job_id": <JOB_ID>, "limit": 1}'
# Get task details
databricks api get "/api/2.1/jobs/runs/get" --profile $DBX_PROFILE --json '{"run_id": <RUN_ID>}'
```

### Read logs from volume (only available AFTER run completes)
```bash
TOKEN=$(databricks auth token --profile $DBX_PROFILE | python3 -c "import sys,json; print(json.load(sys.stdin).get('access_token',''))")
WORKSPACE_HOST=$(databricks auth token --profile $DBX_PROFILE | python3 -c "import sys,json; print(json.load(sys.stdin).get('token_type',''))" 2>/dev/null || echo "")
# Get host from profile config instead if needed

# Read info log
curl -s "https://<workspace-host>/api/2.0/fs/files/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/v1_ecm/<business>_info_v1_ecm.log" \
  -H "Authorization: Bearer $TOKEN"

# Read error log
curl -s "https://<workspace-host>/api/2.0/fs/files/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/v1_ecm/<business>_error_v1_ecm.log" \
  -H "Authorization: Bearer $TOKEN"

# Read vibe_tester summary
curl -s "https://<workspace-host>/api/2.0/fs/files/Volumes/<catalog>/_metamodel/vol_root/logs/vibe_tester/<run_name>/test_summary.log" \
  -H "Authorization: Bearer $TOKEN"

# Read next_vibes
curl -s "https://<workspace-host>/api/2.0/fs/files/Volumes/<catalog>_ecm_v1/_metamodel/vol_root/business/<business>/v1_ecm/vibes/next_vibes.txt" \
  -H "Authorization: Bearer $TOKEN"
curl -s "https://<workspace-host>/api/2.0/fs/files/Volumes/<catalog>_mvm_v1/_metamodel/vol_root/business/<business>/v1_mvm/vibes/next_vibes.txt" \
  -H "Authorization: Bearer $TOKEN"
```

**CRITICAL:** Logs are written to LOCAL temp files during the run and only uploaded to the volume at the END. During the run, volume log files are 0 bytes. The ONLY real-time visibility is:
1. The `_vibe_progress` table (SQL queries above)
2. The notebook output in the Databricks UI

---

## Known Pipeline Stages and Timing

For a 3-domain, 10-15 product airline model:

| Time | Stage | Notes |
|---|---|---|
| 0-1 min | Setup, Vibe Parsing | Session init, widget parsing |
| 1-2 min | Business Context (Step 1) | LLM generates 12 Phase F fields |
| 2-4 min | Domain Generation (Step 2) | 3 ensemble LLM calls + judge |
| 4-5 min | Product Generation (Step 3) | Parallel across domains |
| 5-6 min | Architect Review (Step 3.7) | Score + recommendations |
| 6-15 min | Attribute Generation (Step 4) | 8 concurrent LLM calls |
| 15-16 min | Normalization (Step 4.6) | Batched parallel |
| 16-18 min | FK Linking (Steps 5-7) | In-domain + cross-domain + pairwise |
| 18-19 min | MV14 Process-Flow FK Gate | Adds missing FK edges |
| 18-19 min | MV15 FK Semantic Gate | Removes wrong FK edges |
| 19-20 min | Naming Conventions (Step 8) | Prefixes/suffixes |
| 20-21 min | Subdomain Allocation (Step 8c) | Products to subdomains |
| 21-25 min | Physical Schema Deploy (Track 2) | CREATE TABLE + consolidation |
| 25-30 min | Artifacts (Track 3) | README, DBML, JSON, Excel |
| 30+ min | Cleanup + Log Upload (Track 4) | Logs written to volume |

**MVM Shrink** (after ECM completes): ~10-15 minutes additional.
**Total for full pipeline** (ECM + install + uninstall + MVM shrink + install): ~45-60 minutes.

---

## Common Failure Patterns

### 1. NameError / UnboundLocalError: name 'X' is not defined
**Root cause:** A function references a variable that's not in its parameter list or closure scope. Most common when adding `config.get()` calls inside functions that don't take `config`.

**Fix pattern:** Add `config=None` as a default parameter. Use `(config or {}).get(...)` to guard against None.

**Prevention:** After any edit that adds a variable reference, verify the enclosing function's parameter list. Run:
```bash
grep -n "def <function_name>" /tmp/agent_source.py
```

### 2. AttributeError: 'NoneType' object has no attribute 'get'
**Root cause:** Calling `.get()` on a None value. Happens when `config` is None in optional-parameter functions.

**Fix:** Replace `config.get(...)` with `(config or {}).get(...)` in ALL new code.

### 3. Physical Deployment Clash (MVM shrink fails)
**Root cause:** The staging catalog has residual schemas from the ECM generate step. When MVM shrink tries to deploy, it finds existing databases.

**Fix (implemented):** The `_early_clash_detection` function drops all non-system schemas from the staging catalog when operation is "shrink ecm" or "enlarge mvm".

**What to check:** If MVM shrink fails with "PHYSICAL DEPLOYMENT CLASH DETECTED", verify the staging catalog's schemas:
```sql
SHOW SCHEMAS IN <name>_ecm;
```

### 4. Phantom Domains (domain_1_of_3, domain_2_of_3, etc.)
**Root cause:** User vibe text (e.g., "only generate 3 domains") gets injected into prompts and the LLM interprets it as domain creation instructions.

**Fix (implemented):** Anti-phantom rules in DOMAIN_GENERATE_PROMPT and DOMAIN_JUDGE_PROMPT, plus `_cleanup_phantom_domains()` deterministic guard.

**What to check:**
```sql
SELECT domain FROM <catalog>._metamodel.domain WHERE domain LIKE 'domain_%';
```

### 5. vibe_tester Test 00 FAILED — cascade skip
**Root cause:** The vibe_runner's 5-task job failed. Check which task failed via the runner job's run page.

**How to investigate:** Find the runner job and check task states:
```bash
databricks api get "/api/2.1/jobs/list" --profile $DBX_PROFILE
```

### 6. Lost Domain (3 generated but only 2 deployed)
**Root cause:** The architect review, global dedup, or domain-fit step merges two domains. Despite vibe protection, the LLM may reorganize products across domains in ways that empty one domain.

**What to check:** Compare progress table "Generated N domains" with deployed domain count. If mismatch, the domain was lost during a post-generation step.

**Known persistent issue:** The "3 domains → 2 deployed" problem occurs because the LLM sometimes generates overlapping domains for constrained models. The balanced vibe protection preserves counts at the architect review level, but the dedup or consolidation steps may still merge domain contents.

### 7. TypeError in vibe modeling path
**Root cause:** `TypeError: cannot unpack non-iterable int object` in the "vibe modeling of version" operation. This is a pre-existing issue in the vibe interpretation path.

### 8. Stale code after sync
**Root cause:** The workspace repo sync completed but the runner job was created BEFORE the sync (it snapshots the notebook at job creation time).

**Prevention:** Always verify `head_commit_id` matches your latest commit BEFORE submitting a test. Submit the test AFTER verification.

---

## Key Log Markers to Search For

In the info log, search for these markers:

| Marker | What it tells you |
|---|---|
| `[Phase F]` | Which of the 12 business context fields were populated |
| `[Phase F] Extended context: X/12 fields populated` | Summary of context quality |
| `[MV2]` | MVM size clamp result |
| `[MV4]` | Industry anchor entity check |
| `[MV5]` | Shared domain cap check |
| `[MV8]` | MVM metadata reset after shrink |
| `[MV14]` | Process-flow FK completeness (edges added) |
| `[MV15]` | FK semantic correctness (invalid FKs removed) |
| `[MEM]` | Memory usage at step boundaries |
| `[Sanity]` | Prompt audit and smoke render results |
| `[QUALITY]` | Domain name validation |
| `[VIBE PROTECTION]` | Vibe count constraint logging |
| `[PHANTOM CLEANUP]` | Phantom domain removal |
| `NEXT-VIBES FEEDBACK` | End-of-run summary |

---

## Model Quality Inspection Queries

Run these DURING the run (before tester cleanup) or on surviving catalogs:

```sql
-- Domain structure
SELECT domain, division, description
FROM <catalog>._metamodel.domain
WHERE domain NOT LIKE 'domain_%'
ORDER BY domain;

-- Products per domain
SELECT domain, subdomain, product, type, description
FROM <catalog>._metamodel.product
WHERE domain NOT LIKE 'domain_%'
ORDER BY domain, subdomain, product;

-- Attribute count per product
SELECT domain, product, COUNT(*) as attrs,
       SUM(CASE WHEN foreign_key_to IS NOT NULL AND foreign_key_to != '' THEN 1 ELSE 0 END) as fks
FROM <catalog>._metamodel.attribute
WHERE domain NOT LIKE 'domain_%'
GROUP BY domain, product ORDER BY domain, product;

-- Cross-domain FKs (most important for quality)
SELECT CONCAT(a.domain, '.', a.product, '.', a.attribute) as src, a.foreign_key_to
FROM <catalog>._metamodel.attribute a
WHERE a.foreign_key_to IS NOT NULL AND a.foreign_key_to != ''
  AND a.domain != SUBSTRING_INDEX(a.foreign_key_to, '.', 1)
ORDER BY a.domain;

-- Orphan FK check (target doesn't exist)
WITH targets AS (
  SELECT LOWER(CONCAT(SUBSTRING_INDEX(foreign_key_to, '.', 1), '.', 
         SUBSTRING_INDEX(SUBSTRING_INDEX(foreign_key_to, '.', 2), '.', -1))) as tgt
  FROM <catalog>._metamodel.attribute
  WHERE foreign_key_to IS NOT NULL AND foreign_key_to != ''
),
prods AS (
  SELECT LOWER(CONCAT(domain, '.', product)) as pk
  FROM <catalog>._metamodel.product
)
SELECT DISTINCT tgt FROM targets WHERE tgt NOT IN (SELECT pk FROM prods);

-- Domain bloat (>25%)
SELECT domain, COUNT(DISTINCT product) as prods,
       ROUND(COUNT(DISTINCT product)*100.0 / 
             (SELECT COUNT(DISTINCT product) FROM <catalog>._metamodel.product), 1) as pct
FROM <catalog>._metamodel.product
WHERE domain NOT LIKE 'domain_%'
GROUP BY domain ORDER BY prods DESC;

-- PII tags
SELECT tags, COUNT(*)
FROM <catalog>._metamodel.attribute
WHERE tags LIKE '%pii%' OR tags LIKE '%restricted%' OR tags LIKE '%confidential%'
GROUP BY tags ORDER BY COUNT(*) DESC;

-- Boilerplate check
SELECT COUNT(*)
FROM <catalog>._metamodel.attribute
WHERE LOWER(description) LIKE '%fortune%'
   OR LOWER(description) LIKE '%multinational%'
   OR LOWER(description) LIKE '%enterprise-wide%';

-- Phantom domain check
SELECT domain, LEFT(description, 100)
FROM <catalog>._metamodel.domain
WHERE domain LIKE 'domain_%' OR description LIKE '%exact_domain_count%';

-- Vibe compliance check (compare with user's requested counts)
SELECT 'domains' as metric, COUNT(DISTINCT domain) as actual
FROM <catalog>._metamodel.product
WHERE domain NOT LIKE 'domain_%'
UNION ALL
SELECT 'products', COUNT(*)
FROM <catalog>._metamodel.product
WHERE domain NOT LIKE 'domain_%';
```

---

## Vibe Compliance Verification

When testing with vibes that constrain the model, verify:

1. **Domain count** matches the vibe's requested count
2. **Product count per domain** matches the vibe's requested count
3. **Architect review changes > 0** (balanced protection allows quality improvements)
4. **Architect review preserves counts** (even after changes, domain/product counts match)
5. **No phantom domains** created from vibe text
6. **All 43 model-decision prompts** receive the vibe (check `_USER_VIBES_SECTION` presence)
7. **Next_vibes** reflects real quality issues, not vibe-compliance issues

---

## Next Vibes Validation

After model generation, check next_vibes files for:

1. **Are the findings REAL?** Each finding should describe a genuine model quality issue
2. **Are they ACTIONABLE?** Each should have a concrete fix the user can apply
3. **Do they match your own review?** Compare your SQL-based inspection with the judge's findings
4. **Do they catch known issues?** Missing domains, orphan FKs, PII gaps, etc.
5. **Are there FALSE POSITIVES?** Domain bloat warnings for 2-domain models (expected at 50%) are false positives

---

## Run Comparison Template

Track these metrics across runs:

| Metric | V_prev | V_current | Notes |
|---|---|---|---|
| Domains generated | | | Progress: "Generated N domains" |
| Domains deployed | | | `SELECT COUNT(DISTINCT domain)` |
| Products generated | | | Progress: "Generated N products across M domains" |
| Products deployed | | | `SELECT COUNT(*)` |
| Architect score | | | Progress: "score N/100, M changes" |
| Architect changes | | | Should be > 0 (balanced protection) |
| FK count (in-domain) | | | Progress: "In-domain: N links" |
| FK count (cross-domain) | | | Progress: "Cross-domain: N links" |
| MV14 edges added | | | Progress: "MV14 complete: N FK(s) added" |
| MV15 FKs removed | | | Progress: "MV15 complete: N invalid FK(s) removed" |
| Phantom domains | | | Should be 0 |
| Boilerplate count | | | Should be 0 |
| PII-tagged attrs | | | Should be > 0 |
| MVM shrink | | | SUCCESS or FAILED + reason |
| Total pipeline time | | | All 5 runner tasks |

---

## TODO: Known Issues to Fix

1. **Lost 3rd domain** — User requests 3 domains but only 2 survive deployment. Persistent across V7-V11. Root cause: dedup or consolidation merges domain contents.
2. **Product under-generation** — User asks for 5 per domain (15 total) but LLM generates 8-12. The MODEL_GENERATION_PARAMETER_PROMPT sets the correct bounds but PRODUCT_GENERATE_PROMPT doesn't always produce the exact count.
3. **Log preservation** — Vibe tester destroys catalogs (and logs) after Phase 8 cleanup. Logs should be copied to a persistent location before cleanup.
4. **Job URL tracking** — Agent, runner, and tester should log their job URLs to the volume for monitoring.
5. **TypeError in vibe modeling** — `cannot unpack non-iterable int object` in the vibe modeling path. Needs stack trace to fix.
6. **MVM attribute depth** — MVM should have thinner attributes than ECM but currently produces the same depth. Needs parameter-based control, NOT variant-specific prompts.
