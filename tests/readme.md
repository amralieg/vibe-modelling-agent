# Vibe Modelling Agent — Test Suite & Development Guide

> Complete testing, development, and CI/CD reference for the Vibe Modelling Agent. Covers the full 10-test integration suite, autonomous development loop, monitoring, surgical mode fixes, and troubleshooting.

[← Back to project root](../readme.md) · [Runner guide](../runner/readme.md) · [Design guide](../docs/design-guide.md) · [Integration guide](../docs/integration-guide.md)

---

## Table of Contents

1. [Overview](#overview)
2. [CI/CD Testing Pipeline](#cicd-testing-pipeline)
3. [Development Workflow](#development-workflow)
4. [Vibe Tester](#vibe-tester)
5. [Vibe Runner](#vibe-runner)
6. [Monitoring & Debugging](#monitoring--debugging)
7. [Surgical Mode Fixes](#surgical-mode-fixes)
8. [Test Results](#test-results)
9. [Common Failure Patterns](#common-failure-patterns)
10. [Known Issues](#known-issues)

---

## 1. Overview

The Vibe Tester is a comprehensive end-to-end integration test suite for the Vibe Modelling Agent. It exercises the full agent lifecycle on Databricks, from model generation through physical deployment, sample data creation, and teardown. The suite is designed to run as a Databricks notebook and produces a weighted quality score alongside consolidated log artifacts.

**Core capabilities:**

- Runs the agent notebook via `dbutils.notebook.run()` with varied parameter combinations
- Validates model generation at both MVM and ECM scopes via the Vibe Runner pipeline
- Verifies physical deployment (schemas, tables, sample data) in Unity Catalog
- Tests the full lifecycle: generate (via runner), evolve (vibe), enlarge, install, generate samples, uninstall, cross-convention install
- Audits convention compliance by querying metamodel tables
- Produces a weighted quality score and consolidated log files

### Quick Reference

| Item | Value |
|---|---|
| Agent notebook | `agent/dbx_vibe_modelling_agent` (70K+ lines, single code cell) |
| Vibe tester | `tests/vibe_tester.ipynb` |
| Vibe runner | `runner/vibe_runner.ipynb` |
| Industries config | `runner/my-industries.json` |
| Branch for development | `dev` |

**Environment-specific values** (set these once per workspace):
```bash
export DBX_PROFILE="<profile>"
export DBX_REPO_ID="<repo-object-id>"
export DBX_WAREHOUSE_ID="<sql-warehouse-id>"
export DBX_WORKSPACE_PATH="<workspace_path>"
```

---

## 2. CI/CD Testing Pipeline

The agent development follows a strict CI/CD loop. Every code change goes through this cycle before being promoted to production.

### The Loop

```
Run → Inspect → Fix → Honesty Report → if quality >= target → push main (new tag) → sync dev → repeat
```

### Step-by-Step

1. **Run** — Submit a test run (surgical iteration on existing model, or fresh base model)
2. **Inspect** — Read volume logs mid-run (30s streaming), check progress table, verify physical model via SQL
3. **Fix** — If issues found: diagnose from logs, fix in `/tmp/agent_source.py`, rebuild notebook, deploy, resubmit
4. **Honesty Report** — After run completes, produce a brutally honest assessment:
   - Deterministic score + delta from previous version
   - What worked, what didn't, what partially worked
   - Physical integrity check (tables, columns, FKs match JSON artifacts)
   - Static analysis findings (promoted to priorities, not hidden)
5. **Push** — Only if quality meets target:
   ```bash
   git checkout main && git merge dev --no-edit
   git tag v<X.Y.Z> -m "description"
   git push origin main --tags
   git checkout dev && git merge main --no-edit && git push origin dev
   ```
6. **Deploy** — Upload notebook to workspace:
   ```bash
   databricks -p <profile> workspace import <workspace_path> --file agent/dbx_vibe_modelling_agent.ipynb --format JUPYTER --overwrite
   ```
7. **Repeat** — Run next iteration with the fixed code

### Rules

- **NEVER push to main without inspection passing**
- **NEVER claim success without verifying physical model** (query `information_schema.columns`, `information_schema.table_constraints`)
- **NEVER report LLM score as headline** — use deterministic score only
- **Score MUST go up when vibes are applied** — if it doesn't, the scoring formula is wrong, not the model
- **All static analysis warnings MUST be visible** — never hide in "minor issues" appendix
- **Artifacts MUST be complete for reinstallation** — `model.json` must match physical model exactly

### Version Tagging Convention

- `v0.X.0` — Major feature (e.g., surgical mode, deterministic scoring)
- `v0.X.Y` — Bug fix or optimization within the feature
- After `v0.X.9` → `v0.(X+1).0`

---

## 3. Development Workflow

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

### Pre-Test Cleanup (MANDATORY before every run)

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

## 4. Vibe Tester

### Architecture: How Tests Execute

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

### Test Strategy

The suite follows the strategy **"Runner creates ECM+MVM, unique ops + install scenarios on MVM"**. The Vibe Runner (Test 00) generates both ECM and MVM base models via a 4-task job pipeline, then the remaining lifecycle operations (vibe evolution, enlarge, sample generation, uninstall) are exercised against the runner's MVM model. Additional install scenarios test context-file and cross-convention installation paths.

#### Test Categories

| Category              | Count | Tests             | Purpose                                  |
|-----------------------|-------|-------------------|------------------------------------------|
| Runner pipeline       | 1     | 00                | Full ECM+MVM generation via Vibe Runner  |
| Core lifecycle        | 4     | 01--04            | Vibe, enlarge, samples, uninstall        |
| Verification          | 3     | 03b, 04b, 10d    | Physical artifact and cleanup validation |
| Install scenarios     | 2     | 10, 10c           | Context-file and cross-convention install|

### All 10 Test Cases

#### Runner Pipeline (Test 00)

| #   | Test Name         | Label                                              | What It Validates                                               | Expected Outcome                                  |
|-----|-------------------|----------------------------------------------------|-----------------------------------------------------------------|---------------------------------------------------|
| 00  | 00_vibe_runner    | Vibe Runner (create ECM + MVM via runner pipeline) | Full runner pipeline: creates temp JSON, launches runner notebook, verifies both ECM and MVM catalogs exist with metamodel data, copies metamodel and volume files to test catalog | Both `{biz}_ecm_v1` and `{biz}_mvm_v1` catalogs created with populated `_metamodel.business` |

#### Core Lifecycle Tests (01-04)

| #    | Test Name                   | Label                            | What It Validates                                              | Expected Outcome                                 |
|------|----------------------------|----------------------------------|----------------------------------------------------------------|--------------------------------------------------|
| 01   | 01_vibe_modeling_mvm       | Vibe Modeling (MVM v1 → v2)     | Vibe evolution produces a new model version from runner's MVM  | Agent produces v2; `vibe_ok` flag set            |
| 02   | 02_enlarge_mvm_to_ecm      | Enlarge MVM v1 → ECM            | Model can be resized from MVM up to ECM scope                  | Agent exits successfully                         |
| 03   | 03_generate_samples_mvm_v1 | Generate Samples (MVM v1)       | Sample data generation populates runner-installed MVM tables   | Agent exits successfully                         |
| 04   | 04_uninstall_mvm_v1        | Uninstall Model (MVM v1)        | Uninstall removes all physical artifacts from runner MVM catalog | Agent exits successfully                       |

#### Verification Tests (03b, 04b, 10d)

| #    | Test Name               | Label                                          | What It Validates                                              | Expected Outcome                                          |
|------|------------------------|-------------------------------------------------|----------------------------------------------------------------|-----------------------------------------------------------|
| 03b  | 03b_verify_samples     | Verify Sample Data (MVM v1)                     | Tables in runner MVM catalog actually contain rows             | >= 50% of tables have rows > 0                            |
| 04b  | 04b_verify_uninstall   | Verify Uninstall Cleanup (MVM v1)               | Uninstall cleanly removed all physical artifacts               | 0 remaining tables in deploy catalog                      |
| 10d  | 10d_xconv_verify       | Verify Cross-Convention Physical Layout          | Cross-convention install produced correct PascalCase naming, `_key` PK suffix, `dw_` schema prefix, `_zone` suffix, Catalog per Division layout | Naming/PK/schema compliance each >= 70% |

#### Install Scenario Tests (10, 10c)

| #    | Test Name          | Label                                              | What It Validates                                              | Expected Outcome                                          |
|------|--------------------|-----------------------------------------------------|----------------------------------------------------------------|-----------------------------------------------------------|
| 10   | 10_ctx_install     | Context-File Install (MVM v1)                       | Agent installs from a pre-existing model.json with random conventions | Install succeeds, schemas and tables created, cleanup uninstalls |
| 10c  | 10c_xconv_install  | Cross-Convention Install (MVM v1 → different layout) | Agent installs with deliberately different conventions (PascalCase, `_key`, `dw_` prefix, Catalog per Division) | Install succeeds; 10d verifies physical layout |

### Dependency Chain

Tests cascade -- if a prerequisite fails, all dependents are **SKIPPED** rather than run against a broken state. Test 00 (Vibe Runner) is the root dependency for all subsequent tests.

```
Test 00 (Vibe Runner) fails  [mvm_ok = False]
  +-- Test 01 (vibe modeling) .................. SKIPPED
  +-- Test 02 (enlarge MVM to ECM) ............. SKIPPED
  +-- Test 03 (generate samples MVM v1) ........ SKIPPED
  +-- Test 04 (uninstall MVM v1) ............... SKIPPED
  +-- Test 10  (ctx install) ................... SKIPPED
  +-- Test 10c (xconv install) ................. SKIPPED
  +-- Test 10d (xconv verify) .................. SKIPPED

Test 03 (generate samples) fails
  +-- Test 03b (verify samples) ................ SKIPPED

Test 04 (uninstall) fails
  +-- Test 04b (verify uninstall) .............. SKIPPED

Test 10c (xconv install) fails
  +-- Test 10d (xconv verify) .................. SKIPPED
```

### Special Pass/Fail Logic

Not all tests follow the standard "agent exits 0 = pass" pattern. Several tests customize their success criteria.

| Test   | Pass Condition                                                        |
|--------|-----------------------------------------------------------------------|
| 03b    | >= 50% of installed tables have `rows > 0`                            |
| 04b    | Exactly 0 remaining tables after uninstall                            |
| 10d    | PascalCase, PK suffix, and schema naming compliance each >= 70%       |

### Parameter Randomization

Each test receives a randomized set of conventions drawn from the pools below. This ensures the agent is tested against a wide variety of formatting and naming configurations rather than a single hardcoded setup.

#### Convention Pools

| Parameter                  | Possible Values                                                                 |
|----------------------------|---------------------------------------------------------------------------------|
| `naming_convention`        | `snake_case`, `camelCase`, `PascalCase`, `SCREAMING_CASE`                       |
| `table_id_type`            | `BIGINT`, `INT`, `LONG`, `STRING`                                               |
| `boolean_format`           | `Boolean (True/False)`, `Int (0/1)`, `String (Y/N)`                            |
| `date_format`              | 5 formats                                                                       |
| `timestamp_format`         | 4 formats                                                                       |
| `housekeeping_columns`     | `Yes`, `No`                                                                     |
| `history_tracking_columns` | `Yes`, `No`                                                                     |
| `cataloging_style`         | `One Catalog`, `Catalog per Division`, `Catalog per Domain`                     |
| `primary_key_suffix`       | `_id`, `_key`, `_pk`, `Id`, `_identifier`                                       |
| `schema_prefix`            | `stg_`, `raw_`, `src_`, `dw_`                                                  |
| `schema_suffix`            | (empty), `_layer`, `_zone`                                                      |
| `tag_prefix`               | `dbx_`, `tag_`, `meta_`, (empty)                                                |
| `tag_suffix`               | (empty), `_v1`, `_tag`                                                          |
| `catalog_prefix`           | `cat_`, `uc_`, `db_`                                                            |
| `catalog_suffix`           | (empty), `_zone`, `_catalog`                                                    |
| `classification_levels`    | 3 different schemes                                                             |

Each test ID seeds a distinct random draw so that results are reproducible across re-runs of the same test.

### Execution Phases

The test suite executes in nine sequential phases.

#### Phase 1 — Read Widgets

Reads the four notebook widgets that parameterize the test run. See [Widgets](#widgets) for the full list.

#### Phase 2 — Resolve Notebook Path

Uses the hardcoded agent notebook path `./../agent/dbx_vibe_modelling_agent` (resolved relative to the tester notebook location).

#### Phase 3 — Clean Slate (Fixture Setup)

Ensures a pristine environment before tests begin:

```sql
DROP CATALOG IF EXISTS <test_catalog> CASCADE;
CREATE CATALOG <test_catalog>;
CREATE SCHEMA <test_catalog>._metamodel;
-- Create vol_root volume and log output directory
```

#### Phase 4 — Run All Tests

Executes all 10 test definitions in sequence, respecting the dependency chain. Each test invokes the agent notebook with the test's parameter dictionary.

#### Phase 5 — Merge All Logs

Consolidates per-test log files into unified artifacts:

- `merged_info.log` -- combined info and error summaries per test
- `merged_error.log` -- combined error logs per test

Stack traces are stripped during the merge process.

#### Phase 6 — Convention Verification and Vibe Effectiveness Audit

Queries metamodel tables to check convention compliance and compares v1 vs v2 models to measure vibe effectiveness. See [Convention Verification](#convention-verification) and [Vibe Effectiveness Audit](#vibe-effectiveness-audit).

#### Phase 7 — Quality Report

Computes the weighted quality score and writes `quality_report.log`. See [Quality Scoring](#quality-scoring).

#### Phase 8 — Cleanup

Drops all test catalogs created during the run (runner ECM/MVM catalogs, ctx_install catalog, xconv catalogs, etc.) while preserving the base test catalog.

#### Phase 9 — Final Results Summary

Prints the consolidated test results and overall pass/fail determination. Writes `test_summary.log`.

### Convention Verification

After tests run, the suite queries metamodel tables in the test catalog and checks adherence to the randomized conventions that were assigned to each test.

**Checks performed:**

| Check                     | What It Validates                                                  |
|---------------------------|--------------------------------------------------------------------|
| Naming convention         | `column_name` and `table_name` follow the selected naming style    |
| Primary key suffix        | PK columns end with the selected suffix (e.g., `_id`, `_key`)     |
| Schema prefix/suffix      | `database_name` values use the selected prefix and suffix          |
| Tag prefix/suffix         | Tag values use the selected prefix and suffix                      |
| Table ID type             | PK columns use the selected data type (e.g., `BIGINT`, `STRING`)  |

Each check produces a compliance percentage. These are averaged into a single convention compliance score used in quality scoring.

### Vibe Effectiveness Audit

After the vibe evolution test (Test 01), the suite compares the v1 and v2 metamodel snapshots to determine whether the vibe evolution actually changed the model in the expected ways.

**Metrics collected:**

| Metric               | Description                                            |
|----------------------|--------------------------------------------------------|
| Domain count delta   | Difference in number of domains between v1 and v2      |
| Product count delta  | Difference in number of products between v1 and v2     |
| Attribute count delta| Difference in number of attributes between v1 and v2   |

**Vibe-specific checks:**

| Vibe Intent         | Validation                                              |
|---------------------|---------------------------------------------------------|
| "add domain"        | Confirms new domains were actually added                |
| "rename domain"     | Confirms domains were actually renamed                  |
| "add product"       | Confirms new products were actually added               |

The effectiveness score is used as the "Vibe Effectiveness" component in quality scoring.

### Quality Scoring

Phase 7 computes a weighted overall quality score from four components.

#### Score Components

| Component               | Weight | Calculation                              |
|--------------------------|--------|------------------------------------------|
| Test Pass Rate           | 40%    | `passed / (passed + failed)`             |
| Convention Compliance    | 30%    | Average compliance score across checks   |
| Vibe Effectiveness       | 20%    | v1 vs v2 comparison score                |
| Sample Generation        | 10%    | Sample test pass rate                    |

#### Sentiment Thresholds

| Score Range   | Sentiment    |
|---------------|--------------|
| >= 90%        | EXCELLENT    |
| >= 75%        | GOOD         |
| >= 50%        | NEEDS WORK   |
| < 50%         | POOR         |

### Widgets

The test notebook exposes four widgets that control the test run.

| Widget                  | Type | Default                          | Purpose                                         |
|-------------------------|------|----------------------------------|------------------------------------------------|
| `business_name`         | text | `""`                             | The business entity used across all test cases  |
| `business_description`  | text | `""`                             | Description passed to the agent                 |
| `model_vibes`           | text | `""`                             | Vibes text used for the evolution test (Test 03)|
| `catalog`               | text | `""`                             | Name of the test catalog in Unity Catalog       |

**Agent notebook path:** Hardcoded as `./../agent/dbx_vibe_modelling_agent` (resolved relative to the tester notebook location).

### Log Artifacts

The suite produces four log files, written to the log output directory within the test catalog volume.

| File                | Contents                                                                 |
|---------------------|--------------------------------------------------------------------------|
| `merged_info.log`   | Consolidated info-level and error-summary entries from all tests         |
| `merged_error.log`  | Consolidated error-level logs from all tests                             |
| `test_summary.log`  | Per-test results including status, duration, and parameter snapshots     |
| `quality_report.log`| Convention compliance audit, vibe effectiveness audit, and quality score |

Stack traces are stripped from merged logs to keep them readable.

### Test Result Fields

Each test produces a result with the following fields:

| Field | Description |
|---|---|
| **Test Name** | Identifier for the test (e.g., `01_vibe_modeling_mvm`) |
| **Label** | Human-readable description |
| **Status** | `PASSED`, `FAILED`, or `SKIPPED` |
| **Duration** | Wall-clock execution time in seconds |
| **Error** | Error message if the test failed, empty otherwise |

### Example Test Flow

```
Phase 1  Read widgets (business_name, business_description, model_vibes, catalog)
Phase 2  Resolve notebook path (./../agent/dbx_vibe_modelling_agent)
Phase 3  DROP CASCADE + recreate test catalog, _metamodel schema, vol_root volume
Phase 4  Execute tests:
           00   Vibe Runner (create ECM + MVM via runner pipeline)
           01   Vibe Modeling (MVM v1 → v2)
           02   Enlarge MVM v1 → ECM
           03   Generate Samples (MVM v1)
           03b  Verify Sample Data (MVM v1)
           04   Uninstall Model (MVM v1)
           04b  Verify Uninstall Cleanup (MVM v1)
           10   Context-File Install (MVM v1)
           10c  Cross-Convention Install (MVM v1 → different layout)
           10d  Verify Cross-Convention Physical Layout
Phase 5  Merge all test logs
Phase 6  Convention verification + vibe effectiveness audit
Phase 7  Compute weighted quality score
Phase 8  Cleanup — drop all test catalogs except base
Phase 9  Print final summary
```

---

## 5. Vibe Runner

The Vibe Runner orchestrates the full ECM+MVM pipeline as a multi-task Databricks job. It is invoked by the tester (Test 00) or can be submitted directly.

### Submit via vibe_tester (full 10-test suite)

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

### Submit via vibe_runner (full ECM+MVM pipeline)

```bash
databricks -p <profile> jobs submit --no-wait --json '{
  "run_name": "vibe_runner_<name>",
  "timeout_seconds": 43200,
  "tasks": [{
    "task_key": "vibe_runner",
    "notebook_task": {
      "notebook_path": "<workspace_path>/runner/vibe_runner",
      "source": "WORKSPACE",
      "base_parameters": {
        "business_context": "<workspace_path>/runner/my-industries.json",
        "dry_run": "no",
        "ping_interval": "1m"
      }
    },
    "timeout_seconds": 43200
  }]
}'
```

The runner creates a multi-task DAG job (ECM generate → install → uninstall staging → MVM shrink → MVM install).

### Direct agent run (for surgical iterations)

```bash
databricks -p <profile> jobs submit --no-wait --json '{
  "run_name": "<name>",
  "timeout_seconds": 7200,
  "tasks": [{
    "task_key": "ecm_generate",
    "notebook_task": {
      "notebook_path": "<workspace_path>/agent/dbx_vibe_modelling_agent",
      "source": "WORKSPACE",
      "base_parameters": {
        "business_name": "<name>",
        "business_description": "<description>",
        "operation": "vibe modeling of version",
        "model_version": "<version_number>",
        "data_model_scopes": "Minimum Viable Model - MVM",
        "model_vibes": "<vibes text>",
        "deployment_catalog": "<catalog>"
      }
    },
    "timeout_seconds": 7200
  }]
}'
```

The outer job exits in ~45s after launching a background job. Find the real job:
```bash
databricks -p <profile> jobs list --output json
```

### Known Pipeline Stages and Timing

For a 3-domain, 10-15 product model:

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

## 6. Monitoring & Debugging

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

# Read info log
curl -s "https://<workspace-host>/api/2.0/fs/files/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/ecm_v1/<business>_info_v1_ecm.log" \
  -H "Authorization: Bearer $TOKEN"

# Read error log
curl -s "https://<workspace-host>/api/2.0/fs/files/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/ecm_v1/<business>_error_v1_ecm.log" \
  -H "Authorization: Bearer $TOKEN"

# Read vibe_tester summary
curl -s "https://<workspace-host>/api/2.0/fs/files/Volumes/<catalog>/_metamodel/vol_root/logs/vibe_tester/<run_name>/test_summary.log" \
  -H "Authorization: Bearer $TOKEN"

# Read next_vibes
curl -s "https://<workspace-host>/api/2.0/fs/files/Volumes/<catalog>_ecm_v1/_metamodel/vol_root/business/<business>/ecm_v1/vibes/next_vibes.txt" \
  -H "Authorization: Bearer $TOKEN"
curl -s "https://<workspace-host>/api/2.0/fs/files/Volumes/<catalog>_mvm_v1/_metamodel/vol_root/business/<business>/mvm_v1/vibes/next_vibes.txt" \
  -H "Authorization: Bearer $TOKEN"
```

**CRITICAL:** Logs are written to LOCAL temp files during the run and only uploaded to the volume at the END. During the run, volume log files are 0 bytes. The ONLY real-time visibility is:
1. The `_vibe_progress` table (SQL queries above)
2. The notebook output in the Databricks UI

### Pulse Check — Exact Commands

**One-shot pulse (run anytime during an ECM/MVM run):**
```bash
TOTAL=$(databricks -p <profile> fs cat "dbfs:/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/<version>/<business>_info_<version>.log" 2>/dev/null | wc -l | tr -d ' ')
ERRORS=$(databricks -p <profile> fs cat "dbfs:/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/<version>/<business>_info_<version>.log" 2>/dev/null | grep -c " ERROR \| FAILED " || echo 0)
WARNINGS=$(databricks -p <profile> fs cat "dbfs:/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/<version>/<business>_info_<version>.log" 2>/dev/null | grep -c "WARNING" || echo 0)
STEP=$(databricks -p <profile> fs cat "dbfs:/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/<version>/<business>_info_<version>.log" 2>/dev/null | grep -i "Step\|Completed\|Generated\|Attempt\|Validation\|Starting\|TRACK" | tail -1 | sed 's/^[0-9-]* [0-9:]* - INFO - //')
echo "PULSE | ${TOTAL} lines | E:${ERRORS} W:${WARNINGS} | ${STEP}"
```

**Check errors only:**
```bash
databricks -p <profile> fs cat "dbfs:/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/<version>/<business>_info_<version>.log" 2>/dev/null | grep -i "ERROR\|FAILED\|Exception\|Traceback" | grep -v "0 failed"
```

**Progress table (real-time, works before logs flush):**
```bash
databricks -p <profile> api post /api/2.0/sql/statements --json '{
  "warehouse_id": "<warehouse_id>",
  "statement": "SELECT status, SUBSTRING(message, 1, 120) FROM <catalog>._metamodel._vibe_progress ORDER BY last_updated DESC LIMIT 5",
  "wait_timeout": "30s"
}'
```

**Task-level pipeline status (for multi-task runner jobs):**
```bash
databricks -p <profile> jobs get-run <RUN_ID> --output json | python3 -c "
import sys, json, time
d = json.load(sys.stdin)
start = d.get('start_time', 0)
elapsed = (time.time() * 1000 - start) / 60000 if start else 0
print(f'Pipeline: {elapsed:.0f} min')
for t in d.get('tasks', []):
    ts = t.get('state', {})
    print(f'  {t.get(\"task_key\",\"?\"):30s}: {ts.get(\"life_cycle_state\",\"?\")} {ts.get(\"result_state\",\"\")}')
"
```

**Attribute generation progress (during the longest phase):**
```bash
databricks -p <profile> fs cat "dbfs:/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/<version>/<business>_info_<version>.log" 2>/dev/null | grep -c "Completed:"
# Compare against total: grep "Starting parallel execution of N" to find N
```

**Physical model verification (after deploy):**
```bash
# Table count per schema
databricks -p <profile> api post /api/2.0/sql/statements --json '{
  "warehouse_id": "<warehouse_id>",
  "statement": "SELECT table_schema, COUNT(*) FROM <catalog>.information_schema.tables WHERE table_type = '\''MANAGED'\'' AND table_schema NOT IN ('\''_metamodel'\'', '\''_metrics'\'', '\''_files'\'', '\''information_schema'\'') GROUP BY table_schema ORDER BY table_schema",
  "wait_timeout": "30s"
}'

# FK constraint count
databricks -p <profile> api post /api/2.0/sql/statements --json '{
  "warehouse_id": "<warehouse_id>",
  "statement": "SELECT COUNT(*) FROM <catalog>.information_schema.table_constraints WHERE constraint_type = '\''FOREIGN KEY'\''",
  "wait_timeout": "30s"
}'

# Verify model.json matches physical
databricks -p <profile> fs cat "dbfs:/Volumes/<catalog>/_metamodel/vol_root/business/<business>/<version>/model.json" | python3 -c "
import sys, json
m = json.load(sys.stdin).get('model', {})
domains = m.get('domains', [])
total_p = sum(len(d.get('products', [])) for d in domains)
total_a = sum(sum(len(p.get('attributes', [])) for p in d.get('products', [])) for d in domains)
total_fk = sum(sum(1 for a in p.get('attributes', []) if a.get('foreign_key_to')) for d in domains for p in d.get('products', []))
print(f'JSON: {len(domains)} domains, {total_p} products, {total_a} attrs, {total_fk} FKs')
"
```

### CI/CD Monitoring During Runs

```bash
# Live logs (30s refresh)
databricks -p <profile> fs cat "dbfs:/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/<version>/<business>_info_<version>.log"

# Progress table
SELECT status, SUBSTRING(message, 1, 120) FROM <catalog>._metamodel._vibe_progress ORDER BY last_updated DESC LIMIT 5

# Physical model verification
SELECT table_schema, COUNT(*) FROM <catalog>.information_schema.tables WHERE table_type = 'MANAGED' GROUP BY table_schema
SELECT COUNT(*) FROM <catalog>.information_schema.table_constraints WHERE constraint_type = 'FOREIGN KEY'
```

### Key Log Markers to Search For

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

### Model Quality Inspection Queries

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

### Cleanup Commands

```bash
# Drop all catalogs except protected ones
KEEP="system samples"
# Query SHOW CATALOGS, drop anything not in KEEP:
# DROP CATALOG IF EXISTS <name> CASCADE

# Delete all jobs
databricks -p <profile> jobs list --output json | python3 -c "
import sys, json
data = json.load(sys.stdin)
jobs = data if isinstance(data, list) else data.get('jobs', [])
for j in jobs:
    print(j.get('job_id', ''))
" | while read jid; do
  databricks -p <profile> api post /api/2.1/jobs/delete --json "{\"job_id\": $jid}"
done

# Clean workspace models folder
databricks -p <profile> workspace delete <workspace_path>/models --recursive
databricks -p <profile> workspace mkdirs <workspace_path>/models
```

### Key Tricks and Shortcuts

1. **Log streaming works on serverless** — 30s daemon thread copies local logs to volume. Read mid-run, no need to wait for completion.
2. **The outer notebook exits in ~45s** — it submits a background job. Find the real job via `jobs list`.
3. **`information_schema` queries verify physical state** — don't trust log counts alone, verify with SQL.
4. **Cancel and resubmit is free** — `databricks jobs cancel-run <RUN_ID>` then resubmit with fixes. No penalty.
5. **Workspace repo sync conflicts** — if `repos update` fails due to conflicts, upload files directly via `workspace import`.
6. **`my-industries.json` must have `model_vibes` key** in `widget_values` section (even if empty string).
7. **Progress table is real-time** — logs may be 30s stale but progress table updates immediately.
8. **Attribute generation is the bottleneck** — 60-90% of ECM runtime. Track with `grep -c "Completed:"`.
9. **False positive error count** — `grep "FAILED"` catches "0 failed" success messages. Filter with `grep -v "0 failed"`.
10. **Tag application order** — tags are the last step. If run completes but tags fail, the model is still usable (tags are metadata-only).

---

## 7. Surgical Mode Fixes

The v0.4.0 through v0.5.1 releases introduced a series of targeted fixes to surgical mode, scoring, and deployment.

### Self-Referencing FK Rename Creates New Column (v0.4.0)

**Problem:** When renaming a self-referencing FK column, the agent was renaming the PK column itself instead of creating a new FK column with the correct prefix.

**Fix:** Self-referencing FK rename now creates a **new column** with the hierarchical prefix (e.g., `parent_category_id`) instead of renaming the existing PK (`category_id`). The PK is never touched.

**How to verify:**
```sql
-- After deployment, confirm the PK still exists unchanged
SELECT attribute, foreign_key_to
FROM <catalog>._metamodel.attribute
WHERE product = '<product>' AND attribute = '<product>_id';
-- Expect: PK row with no foreign_key_to

-- Confirm the self-ref FK is a separate column
SELECT attribute, foreign_key_to
FROM <catalog>._metamodel.attribute
WHERE product = '<product>' AND foreign_key_to LIKE CONCAT('%', '<product>', '.', '<product>_id');
-- Expect: a different column name (e.g., parent_<product>_id)
```

### Bidirectional FK Protection for User-Vibed Links (v0.4.1)

**Problem:** The bidirectional FK removal pass was deleting FK links that the user explicitly requested via vibes.

**Fix:** FK links that originate from user vibe instructions are now **protected from bidirectional removal**. The bidirectional check skips any link that is flagged as user-vibed.

**How to verify:**
```sql
SELECT a.domain, a.product, a.attribute, a.foreign_key_to
FROM <catalog>._metamodel.attribute a
WHERE a.foreign_key_to IS NOT NULL
  AND a.attribute LIKE '%<user_vibed_fk>%';
-- Expect: the user-vibed FK link is present
```

### Surgical Fast Path — Skip Subdomain + Metric Views (v0.4.2)

**Problem:** Surgical mode was running the full pipeline including subdomain allocation and metric view generation, even though surgical vibes typically only modify a few tables or attributes.

**Fix:** When the agent detects surgical mode, it now skips subdomain allocation (Stage 11) and metric view generation (Stage 15/19) entirely, taking a **fast path** through the pipeline.

**How to verify:**
- Monitor `_vibe_progress` during a surgical vibe run
- Confirm no rows appear for `stage_name LIKE '%Subdomain%'` or `stage_name LIKE '%Metric%'`
- Total pipeline time should be notably shorter than a holistic or generative run

### Surgical Deploy — IF NOT EXISTS for Untouched Tables (v0.5.0)

**Problem:** Surgical deploy was running full `CREATE TABLE` statements for every table in the model, even when only a few tables were modified.

**Fix:** During surgical deploy, tables that were **not touched** by the current vibe iteration are deployed with `CREATE TABLE IF NOT EXISTS`. Only tables that were actually modified get a full redeploy.

**How to verify:**
- Check the SQL DDL artifact for the surgical run
- Untouched tables should use `IF NOT EXISTS`
- Modified tables should use standard `CREATE TABLE` (or `CREATE OR REPLACE`)

### Tag Batching — 34% Fewer SQL Calls (v0.5.0)

**Problem:** The tag application stage was issuing individual SQL statements for each tag on each entity, resulting in thousands of SQL calls for large models.

**Fix:** Tags are now **batched** by table, combining multiple column-level tag operations into fewer SQL statements.

**How to verify:**
- Compare the number of SQL statements in the tag application stage between v0.4.x and v0.5.x runs
- Monitor `_vibe_progress` for the tag stage duration; expect it to be shorter

### Deterministic Scoring — Not LLM-Based (v0.5.0)

**Problem:** Model quality scoring was delegated to an LLM, which produced non-reproducible scores across runs for identical models.

**Fix:** Quality scoring is now **fully deterministic** using a formula-based approach. The score is computed from measurable model properties (FK coverage, PII tagging, naming compliance, domain balance, etc.) without any LLM involvement.

**How to verify:**
- Run the same model through scoring twice; expect identical scores
- Check the progress log for `[SCORE]` entries showing the breakdown by dimension

### Iteration Bonus Scoring (v0.5.1)

**Problem:** When a user successfully applied vibes to improve a model, the quality score sometimes decreased or stayed flat, even though the model was objectively better.

**Fix:** The scoring formula now includes an **iteration bonus** that rewards successful vibe application. When vibes are parsed and successfully fulfilled, a bonus is added to the score proportional to the fulfillment rate.

**How to verify:**
- Generate a base model (v1) and record the quality score
- Apply vibes that fix known issues (v2)
- The v2 score should be higher than the v1 score
- Check the progress log for `[SCORE]` entries showing the iteration bonus component

### Surgical Mode Test Checklist

| Check | Expected |
|---|---|
| Self-ref FK creates new column | PK unchanged, new FK column exists |
| User-vibed links survive bidirectional check | Vibed FK present after QA |
| Subdomain stage skipped | No subdomain rows in `_vibe_progress` |
| Metric view stage skipped | No metric view rows in `_vibe_progress` |
| Untouched tables use IF NOT EXISTS | Check DDL artifact |
| Tag batching active | Fewer SQL calls in tag stage |
| Score is deterministic | Identical score on re-run |
| Score increases on successful vibe | v2 score > v1 score |

---

## 8. Test Results

### Surgical Iteration Test Results (v0.4.0 — v0.5.1)

Full 11-iteration surgical test cycle run on a large MVM model (12 domains, 159 products).

#### Base Model (v1)
- **Operation:** `new base model` (organic, no vibes)
- **Runtime:** ~160 min
- **Result:** 12 domains, 159 products, 7,621 attributes, 726 FKs
- **Static analysis:** 36 warnings, 1 unlinked, 0 siloed, 0 cycles
- **Next vibes score:** 62/100 (LLM, 15 priorities — self-ref FKs, orphan tables, missing links)

#### Surgical Iterations (v2-v11)

All iterations used operation `vibe modeling of version` with 20 surgical instructions:
- 10 self-ref FK renames
- 6 create_link FKs (cross-domain connections)
- 4 generic FK renames (role-specific naming)

| Ver | Code | Runtime | Attrs | FKs | Phys FKs | Score | Key Finding |
|-----|------|---------|-------|-----|----------|-------|-------------|
| v2 | v0.3.10 | 39 min | 7,622 | 730 | — | 62 | Descriptive vibes — barely changed |
| v3 | v0.3.10 | 40 min | 7,626 | 732 | — | 62 | Surgical vibes — actions executed but PK consistency reverted renames |
| v4 | v0.4.0 | 19.5 min | 7,635 | 742 | — | 88 | Self-ref fix: CREATE new column. Bidirectional protection. Fast path |
| v5 | v0.4.0 | 20.7 min | 7,635 | 742 | — | 88 | Key name fix: profile_id FK persisted |
| v6 | v0.4.1 | 17.5 min | 7,635 | 742 | — | 82→87 | Tag batching (34%). Deterministic score replaced LLM score |
| v7 | v0.4.2 | 16.8 min | 7,635 | 742 | — | 87 | SA promotion. LLM gave 62 (proves deterministic score was right) |
| v8 | v0.4.3 | 18.4 min | 7,635 | 742 | — | 87 | No cap. Orphan distinction. SKIP filter |
| v10 | v0.5.0 | 10.9 min | 7,635 | 742 | **145** | 87 | Surgical deploy: IF NOT EXISTS + surgical tags. BUT broke FK integrity |
| v11 | v0.5.1 | 11.7 min | 7,635 | 742 | **742** | 87 | FK integrity restored. Surgical FK filter reverted |

#### Key Bugs Found and Fixed

| Bug | Version Found | Version Fixed | Root Cause |
|-----|--------------|---------------|-----------|
| Self-ref FK renames PK column | v3 | v0.4.0 | Only column matching PK name is the PK itself. Now creates new FK column |
| Bidirectional removal kills user-vibed FKs | v4 | v0.4.0 | `_dynamically_created` flag not checked. Now protected |
| Key name mismatch (`_user_vibed_artifacts`) | v4 | v0.4.1 | Stored as `user_vibed_artifacts`, read as `_user_vibed_artifacts` |
| Self-ref guard too aggressive | v3 | v0.4.0 | `merged_into_profile_id` removed because `merged_into_` not in prefix list |
| Subdomain/metric views run in surgical mode | v3 | v0.4.2 | `if not _surgical_fast_path:` only guarded step setup, not execution |
| LLM score non-deterministic (88→62 for same model) | v6 | v0.4.2 | LLM assigned random scores. Now deterministic formula |
| SA warnings buried as "minor issues" | v1-v5 | v0.4.2 | 36 warnings in appendix, LLM picked different 20 each time |
| LLM cap at 20 hides issues | v1-v8 | v0.4.3 | Issues cycled in/out of top 20. Cap removed |
| Surgical FK filter breaks untouched tables | v10 | v0.5.1 | CREATE OR REPLACE invalidates incoming FK refs. Filter reverted |
| Duplicate self-ref columns | v4-v8 | v0.5.0 | Original v1 column + new surgical column. Now renames existing |

#### Physical Integrity Verification (v11 — Final State)

| Check | Result |
|-------|--------|
| Tables | 159/159 — all 12 schemas |
| Columns | 7,635 — matches model.json |
| Physical FK constraints | 742 — all 12 schemas have FKs |
| Self-ref FK columns (10) | All 10 present |
| Cross-domain FK links | All 6 present |
| Renamed generic FKs (4) | All 4 present |
| Broken/empty tables | 0 |
| model.json completeness | Matches physical model exactly |

#### Runtime Progression

```
v1 base:     159.7 min (full generation)
v3 surgical:  39.8 min (no fast path, all steps run)
v4 surgical:  19.5 min (fast path: skip subdomain + metric views)
v6 surgical:  17.5 min (+ tag batching)
v10 surgical: 10.9 min (+ surgical deploy: IF NOT EXISTS + surgical tags)
v11 surgical: 11.7 min (+ full FK re-application for integrity)
```

#### Score Progression

```
v1:  ~84 (deterministic, 36 warnings)
v4:  88 (deterministic, 26 warnings — surgical fixes applied)
v7:  87 (deterministic, 25 warnings — stable)
v11: 87 (deterministic, 25 warnings — FK integrity restored)
```

Note: LLM scores were 62, 88, 82, 62, 72, 82 across runs for the SAME model — proving LLM scoring is unreliable. Deterministic scoring (v0.4.2+) is based on weighted warning counts and is reproducible.

### Known Vibe Compliance Results (v0.3.5)

| Test | Score | Pass | Fail |
|---|---|---|---|
| V1 | 100% | All domain names exact | - |
| V2 | 84% | Domains, products, FKs | Tags initially failed (fixed) |
| V3 | 83% | 8/8 tables, 10/10 FKs | Source tags failed |
| V5 | 63% | Custom prefix 100% | FK suffix override failed |
| V6 | 73% | 5/6 tables, PII good | Source tags failed |
| ULTIMATE | 84% | 18/18 products, 13/13 FKs | Bare naming initially failed |
| ULTIMATE v2 (post-fix) | ~95% | Bare naming 0 violations, all physical tags applied | - |

### 5-Industry Stress Test

The 5-industry stress test validates pipeline stability and model quality across diverse industries in a single batch. Run this after any structural change to the agent.

#### Industries and Expected Sizing

| Industry | Domains | Products | Key Quality Signals |
|---|---|---|---|
| Healthcare | 3 | 12 | PII tagging on patient data, compliance tags |
| Retail Banking | 4 | 18 | Cross-domain FKs between accounts/transactions/customer |
| Logistics | 2 | 10 | Operational domain coverage, warehouse/shipment links |
| University | 4 | 20 | Enrollment M:N, academic hierarchy |
| Oil & Gas | 3 | 15 | Asset management, safety/compliance domains |

Submit each industry as a separate vibe_tester run (see [Submit via vibe_tester](#submit-via-vibe_tester-full-10-test-suite)). All five can run in parallel on separate clusters.

#### Stress Test Verification Queries

```sql
-- 1. Self-referencing FK guard: MUST be 0 violations
SELECT a.domain, a.product, a.attribute, a.foreign_key_to
FROM <catalog>._metamodel.attribute a
WHERE a.foreign_key_to IS NOT NULL
  AND a.foreign_key_to LIKE CONCAT('%', a.product, '.', a.attribute)
  AND a.attribute = (
    SELECT a2.attribute FROM <catalog>._metamodel.attribute a2
    WHERE a2.domain = a.domain AND a2.product = a.product
    AND a2.attribute LIKE '%_id' LIMIT 1
  );

-- 2. PII tagging coverage: expect near-zero missing tags
SELECT a.domain, a.product, a.attribute
FROM <catalog>._metamodel.attribute a
WHERE (LOWER(a.attribute) LIKE '%email%'
    OR LOWER(a.attribute) LIKE '%phone%'
    OR LOWER(a.attribute) LIKE '%ssn%'
    OR LOWER(a.attribute) LIKE '%address%'
    OR LOWER(a.attribute) LIKE '%name%')
  AND (a.tags IS NULL OR a.tags = '' OR a.tags NOT LIKE '%pii%')
  AND LOWER(a.attribute) NOT LIKE '%_name' -- exclude product/domain names
  AND a.attribute NOT LIKE '%_id';

-- 3. Cross-domain FK count: expect 9-28 per model
SELECT COUNT(*)
FROM <catalog>._metamodel.attribute a
WHERE a.foreign_key_to IS NOT NULL AND a.foreign_key_to != ''
  AND a.domain != SUBSTRING_INDEX(a.foreign_key_to, '.', 1);

-- 4. Phantom domain check: MUST be 0
SELECT domain FROM <catalog>._metamodel.domain WHERE domain LIKE 'domain_%';
```

#### Stress Test Pass Criteria

| Metric | Target |
|---|---|
| Pipeline completion | 100% (all 5 industries complete) |
| Self-ref PK=FK violations | 0 |
| Missing PII tags | <= 5 per model |
| Cross-domain FKs | >= 9 per model |
| Phantom domains | 0 |

### Vibe Compliance Test Suite (V1-V6 + ULTIMATE)

These tests verify that user vibes are correctly parsed, distributed to pipeline workers, and enforced in the final model.

#### Test Definitions

| Test | Industry | Focus | Key Vibes |
|---|---|---|---|
| V1 | Pet Store | Explicit domain naming | "use these exact domains: ..." |
| V2 | Construction | Rich multi-vibe | Domains + products + FKs + tags |
| V3 | Food Delivery | Reverse engineer | Existing schema -> model reconstruction |
| V4 | Insurance | Negative rules | "do NOT create ...", "never include ..." |
| V5 | Gym | Naming conventions | Custom prefix (gym_), FK suffix override (_ref) |
| V6 | Car Dealer | Rubbish schema cleanup | Messy input -> clean model with PII + tags |
| ULTIMATE | Smart City | 50+ vibes | All vibe types combined in one run |

#### Vibe Verification Queries

**Domain vibes** — Check that all requested domain names appear exactly:
```sql
SELECT domain FROM <catalog>._metamodel.domain ORDER BY domain;
-- Compare with the list of domains specified in the vibe text
```

**Product vibes** — Verify requested tables exist in the correct domains:
```sql
SELECT domain, product FROM <catalog>._metamodel.product
WHERE product IN ('requested_table_1', 'requested_table_2')
ORDER BY domain, product;
```

**FK vibes** — Confirm requested relationships were created:
```sql
SELECT a.domain, a.product, a.attribute, a.foreign_key_to
FROM <catalog>._metamodel.attribute a
WHERE a.foreign_key_to IS NOT NULL AND a.foreign_key_to != ''
ORDER BY a.domain, a.product;
```

**Attribute vibes** — Check that specific columns exist on the right tables:
```sql
SELECT domain, product, attribute, type, tags
FROM <catalog>._metamodel.attribute
WHERE attribute IN ('requested_col_1', 'requested_col_2');
```

**Negative rule vibes** — Verify forbidden items do NOT exist:
```sql
-- Example: user said "do NOT create a billing domain"
SELECT * FROM <catalog>._metamodel.domain WHERE domain = 'billing';
-- Expect 0 rows
```

**Tag vibes** — Verify custom tags were applied at all levels:
```sql
-- Product-level tags
SELECT domain, product, tags FROM <catalog>._metamodel.product
WHERE tags IS NOT NULL AND tags != '';

-- Attribute-level tags
SELECT domain, product, attribute, tags FROM <catalog>._metamodel.attribute
WHERE tags LIKE '%custom_tag%';

-- Physical table tags (in Unity Catalog)
DESCRIBE TABLE EXTENDED <catalog>.<schema>.<table>;
-- Check the Tags section in output
```

#### Bare Naming Violations Check

Bare generic attribute names (status, type, name, description, date) without business-context prefixes are violations:

```sql
SELECT domain, product, attribute
FROM <catalog>._metamodel.attribute
WHERE attribute IN ('status', 'type', 'name', 'description', 'date',
                    'code', 'category', 'level', 'priority', 'amount',
                    'quantity', 'rate', 'score', 'value', 'count')
  AND attribute NOT LIKE '%_%'  -- no prefix at all
ORDER BY domain, product;
-- Expect 0 rows. Each should be prefixed: order_status, account_type, etc.
```

#### Custom Tags in Physical Tables

After physical deployment, verify that custom tags from vibes persist to Unity Catalog:

```sql
-- Check table-level tags
SELECT tag_name, tag_value
FROM system.information_schema.table_tags
WHERE catalog_name = '<catalog>'
  AND schema_name = '<domain>'
  AND table_name = '<product>';

-- Check column-level tags
SELECT column_name, tag_name, tag_value
FROM system.information_schema.column_tags
WHERE catalog_name = '<catalog>'
  AND schema_name = '<domain>'
  AND table_name = '<product>';
```

#### next_vibes Iteration Test

1. Generate a base model (ecm_v1)
2. Read the next_vibes.txt file from the volume
3. Submit a new vibe_tester run with operation `vibe modeling of version`, setting model_vibes to the content of next_vibes.txt
4. Verify the v2 model addresses the findings from v1
5. Check that v2 next_vibes contains NEW findings (not repeats of v1)

```bash
# Read next_vibes from v1
curl -s "https://<workspace-host>/api/2.0/fs/files/Volumes/<catalog>_ecm/_metamodel/vol_root/business/<name>/ecm_v1/vibes/next_vibes.txt" \
  -H "Authorization: Bearer $TOKEN"
```

#### Vibe Compliance Verification Checklist

When testing with vibes that constrain the model, verify:

1. **Domain count** matches the vibe's requested count
2. **Product count per domain** matches the vibe's requested count
3. **Architect review changes > 0** (balanced protection allows quality improvements)
4. **Architect review preserves counts** (even after changes, domain/product counts match)
5. **No phantom domains** created from vibe text
6. **All 43 model-decision prompts** receive the vibe (check `_USER_VIBES_SECTION` presence)
7. **Next_vibes** reflects real quality issues, not vibe-compliance issues

#### Honesty Check Template

After each vibe compliance test, fill in this template:

| Vibe Category | Requested | Delivered | Compliant? | Notes |
|---|---|---|---|---|
| Domain naming | (list) | (list) | Y/N | |
| Domain count | N | M | Y/N | |
| Product list | (list) | (list) | Y/N | |
| Product count | N | M | Y/N | |
| FK relationships | (list) | (list) | Y/N | |
| Negative rules | (list) | (verify absent) | Y/N | |
| Custom tags | (list) | (verify present) | Y/N | |
| Naming overrides | (list) | (verify applied) | Y/N | |
| Bare name violations | 0 expected | (count) | Y/N | |

### Next Vibes Validation

After model generation, check next_vibes files for:

1. **Are the findings REAL?** Each finding should describe a genuine model quality issue
2. **Are they ACTIONABLE?** Each should have a concrete fix the user can apply
3. **Do they match your own review?** Compare your SQL-based inspection with the judge's findings
4. **Do they catch known issues?** Missing domains, orphan FKs, PII gaps, etc.
5. **Are there FALSE POSITIVES?** Domain bloat warnings for 2-domain models (expected at 50%) are false positives

### Run Comparison Template

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

## 9. Common Failure Patterns

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

## 10. Known Issues

1. ~~**Lost 3rd domain**~~ — Resolved by balanced vibe protection in architect review.
2. **Product under-generation** — User asks for 5 per domain (15 total) but LLM generates 8-12. The MODEL_GENERATION_PARAMETER_PROMPT sets the correct bounds but PRODUCT_GENERATE_PROMPT doesn't always produce the exact count.
3. **Log preservation** — Vibe tester destroys catalogs (and logs) after Phase 8 cleanup. Logs should be copied to a persistent location before cleanup.
4. **Job URL tracking** — Agent, runner, and tester should log their job URLs to the volume for monitoring.
5. ~~**TypeError in vibe modeling**~~ — Fixed in v0.4.0 (classification override + action handler improvements).
6. **MVM attribute depth** — MVM should have thinner attributes than ECM but currently produces the same depth. Needs parameter-based control, NOT variant-specific prompts.
7. **FK suffix override** — User vibes requesting custom FK suffixes (e.g., `_ref` instead of `_id`) are not fully respected (V5 test). Suffix detection from vibes is implemented but not all FK generation paths honor it.
8. **Source tag persistence** — Custom source tags from vibes (e.g., `source=legacy_db`) fail to persist in some test scenarios (V3, V6). The tag injection path needs end-to-end verification.
9. **Duplicate self-ref columns not fully resolved** — Some tables still have both the original v1 self-ref column AND the surgical fix column. The dedup logic renames when possible but may miss cases where the existing column name doesn't match expectations.
10. **Generic FK rename coverage** — Some tables have generic FK columns that should be role-specific. Only a subset were addressed in the surgical vibes. The remaining need additional iterations.
11. **Score plateau at 87** — The model has maxed out what the current 20 surgical instructions can achieve. Further improvement requires new vibes targeting the remaining 25 warnings (generic FK names, PII tags, etc.).

---

[← Back to project root](../readme.md)
