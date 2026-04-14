# Vibe Tester -- End-to-End Integration Test Suite

## Overview

The Vibe Tester is a comprehensive end-to-end integration test suite for the Vibe Modelling Agent. It exercises the full agent lifecycle on Databricks, from model generation through physical deployment, sample data creation, and teardown. The suite is designed to run as a Databricks notebook and produces a weighted quality score alongside consolidated log artifacts.

**Core capabilities:**

- Runs the agent notebook via `dbutils.notebook.run()` with varied parameter combinations
- Validates model generation at both MVM and ECM scopes via the Vibe Runner pipeline
- Verifies physical deployment (schemas, tables, sample data) in Unity Catalog
- Tests the full lifecycle: generate (via runner), evolve (vibe), enlarge, install, generate samples, uninstall, cross-convention install
- Audits convention compliance by querying metamodel tables
- Produces a weighted quality score and consolidated log files

---

## Test Strategy

The suite follows the strategy **"Runner creates ECM+MVM, unique ops + install scenarios on MVM"**. The Vibe Runner (Test 00) generates both ECM and MVM base models via a 4-task job pipeline, then the remaining lifecycle operations (vibe evolution, enlarge, sample generation, uninstall) are exercised against the runner's MVM model. Additional install scenarios test context-file and cross-convention installation paths.

### Test Categories

| Category              | Count | Tests             | Purpose                                  |
|-----------------------|-------|-------------------|------------------------------------------|
| Runner pipeline       | 1     | 00                | Full ECM+MVM generation via Vibe Runner  |
| Core lifecycle        | 4     | 01--04            | Vibe, enlarge, samples, uninstall        |
| Verification          | 3     | 03b, 04b, 10d    | Physical artifact and cleanup validation |
| Install scenarios     | 2     | 10, 10c           | Context-file and cross-convention install|

---

## All 10 Test Cases

### Runner Pipeline (Test 00)

| #   | Test Name         | Label                                              | What It Validates                                               | Expected Outcome                                  |
|-----|-------------------|----------------------------------------------------|-----------------------------------------------------------------|---------------------------------------------------|
| 00  | 00_vibe_runner    | Vibe Runner (create ECM + MVM via runner pipeline) | Full runner pipeline: creates temp JSON, launches runner notebook, verifies both ECM and MVM catalogs exist with metamodel data, copies metamodel and volume files to test catalog | Both `{biz}_ecm_v1` and `{biz}_mvm_v1` catalogs created with populated `_metamodel.business` |

### Core Lifecycle Tests (01--04)

| #    | Test Name                   | Label                            | What It Validates                                              | Expected Outcome                                 |
|------|----------------------------|----------------------------------|----------------------------------------------------------------|--------------------------------------------------|
| 01   | 01_vibe_modeling_mvm       | Vibe Modeling (MVM v1 → v2)     | Vibe evolution produces a new model version from runner's MVM  | Agent produces v2; `vibe_ok` flag set            |
| 02   | 02_enlarge_mvm_to_ecm      | Enlarge MVM v1 → ECM            | Model can be resized from MVM up to ECM scope                  | Agent exits successfully                         |
| 03   | 03_generate_samples_mvm_v1 | Generate Samples (MVM v1)       | Sample data generation populates runner-installed MVM tables   | Agent exits successfully                         |
| 04   | 04_uninstall_mvm_v1        | Uninstall Model (MVM v1)        | Uninstall removes all physical artifacts from runner MVM catalog | Agent exits successfully                       |

### Verification Tests (03b, 04b, 10d)

| #    | Test Name               | Label                                          | What It Validates                                              | Expected Outcome                                          |
|------|------------------------|-------------------------------------------------|----------------------------------------------------------------|-----------------------------------------------------------|
| 03b  | 03b_verify_samples     | Verify Sample Data (MVM v1)                     | Tables in runner MVM catalog actually contain rows             | >= 50% of tables have rows > 0                            |
| 04b  | 04b_verify_uninstall   | Verify Uninstall Cleanup (MVM v1)               | Uninstall cleanly removed all physical artifacts               | 0 remaining tables in deploy catalog                      |
| 10d  | 10d_xconv_verify       | Verify Cross-Convention Physical Layout          | Cross-convention install produced correct PascalCase naming, `_key` PK suffix, `dw_` schema prefix, `_zone` suffix, Catalog per Division layout | Naming/PK/schema compliance each >= 70% |

### Install Scenario Tests (10, 10c)

| #    | Test Name          | Label                                              | What It Validates                                              | Expected Outcome                                          |
|------|--------------------|-----------------------------------------------------|----------------------------------------------------------------|-----------------------------------------------------------|
| 10   | 10_ctx_install     | Context-File Install (MVM v1)                       | Agent installs from a pre-existing model.json with random conventions | Install succeeds, schemas and tables created, cleanup uninstalls |
| 10c  | 10c_xconv_install  | Cross-Convention Install (MVM v1 → different layout) | Agent installs with deliberately different conventions (PascalCase, `_key`, `dw_` prefix, Catalog per Division) | Install succeeds; 10d verifies physical layout |

---

## Dependency Chain

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

---

## Special Pass/Fail Logic

Not all tests follow the standard "agent exits 0 = pass" pattern. Several tests customize their success criteria.

| Test   | Pass Condition                                                        |
|--------|-----------------------------------------------------------------------|
| 03b    | >= 50% of installed tables have `rows > 0`                            |
| 04b    | Exactly 0 remaining tables after uninstall                            |
| 10d    | PascalCase, PK suffix, and schema naming compliance each >= 70%       |

---

## Parameter Randomization

Each test receives a randomized set of conventions drawn from the pools below. This ensures the agent is tested against a wide variety of formatting and naming configurations rather than a single hardcoded setup.

### Convention Pools

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

Randomization is performed by the `_random_conventions(test_id)` and `_random_catalog_widgets(test_id)` helper functions. Each test ID seeds a distinct random draw so that results are reproducible across re-runs of the same test.

---

## Execution Phases

The test suite executes in nine sequential phases.

### Phase 1 -- Read Widgets

Reads the four notebook widgets that parameterize the test run. See [Widgets](#widgets) for the full list.

### Phase 2 -- Resolve Notebook Path

Uses the hardcoded agent notebook path `./../agent/dbx_vibe_modelling_agent` (resolved relative to the tester notebook location).

### Phase 3 -- Clean Slate (Fixture Setup)

Ensures a pristine environment before tests begin:

```sql
DROP CATALOG IF EXISTS <test_catalog> CASCADE;
CREATE CATALOG <test_catalog>;
CREATE SCHEMA <test_catalog>._metamodel;
-- Create vol_root volume and log output directory
```

### Phase 4 -- Run All Tests

Executes all 10 test definitions in sequence, respecting the dependency chain. Each test is invoked via `run_test()` which calls `dbutils.notebook.run()` with the test's parameter dict.

### Phase 5 -- Merge All Logs

Consolidates per-test log files into unified artifacts using `merge_all_logs(test_results)`:

- `merged_info.log` -- combined info and error summaries per test
- `merged_error.log` -- combined error logs per test

Stack traces are stripped during the merge process.

### Phase 6 -- Convention Verification and Vibe Effectiveness Audit

Runs the `verify_conventions()` function against metamodel tables and the `audit_vibe_effectiveness()` function to compare v1 and v2 models. See the dedicated sections below.

### Phase 7 -- Quality Report

Computes the weighted quality score and writes `quality_report.log`. See [Quality Scoring](#quality-scoring).

### Phase 8 -- Cleanup

Drops all test catalogs created during the run (runner ECM/MVM catalogs, ctx_install catalog, xconv catalogs, etc.) while preserving the base test catalog.

### Phase 9 -- Final Results Summary

Prints the consolidated test results and overall pass/fail determination. Writes `test_summary.log`.

---

## Convention Verification

The `verify_conventions(test_result, version, scope)` function queries metamodel tables in the test catalog and checks adherence to the randomized conventions that were assigned to each test.

**Checks performed:**

| Check                     | What It Validates                                                  |
|---------------------------|--------------------------------------------------------------------|
| Naming convention         | `column_name` and `table_name` follow the selected naming style    |
| Primary key suffix        | PK columns end with the selected suffix (e.g., `_id`, `_key`)     |
| Schema prefix/suffix      | `database_name` values use the selected prefix and suffix          |
| Tag prefix/suffix         | Tag values use the selected prefix and suffix                      |
| Table ID type             | PK columns use the selected data type (e.g., `BIGINT`, `STRING`)  |

Each check produces a compliance percentage. These are averaged into a single convention compliance score used in quality scoring.

---

## Vibe Effectiveness Audit

The `audit_vibe_effectiveness(base_version, new_version, scope, vibes_text)` function compares the v1 and v2 metamodel snapshots to determine whether the vibe evolution actually changed the model in the expected ways.

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

---

## Quality Scoring

Phase 7 computes a weighted overall quality score from four components.

### Score Components

| Component               | Weight | Calculation                              |
|--------------------------|--------|------------------------------------------|
| Test Pass Rate           | 40%    | `passed / (passed + failed)`             |
| Convention Compliance    | 30%    | Average compliance score across checks   |
| Vibe Effectiveness       | 20%    | v1 vs v2 comparison score                |
| Sample Generation        | 10%    | Sample test pass rate                    |

### Sentiment Thresholds

| Score Range   | Sentiment    |
|---------------|--------------|
| >= 90%        | EXCELLENT    |
| >= 75%        | GOOD         |
| >= 50%        | NEEDS WORK   |
| < 50%         | POOR         |

---

## Key Functions

### Test Execution

| Function                                  | Description                                                                                         |
|-------------------------------------------|-----------------------------------------------------------------------------------------------------|
| `run_test(test_def, timeout_seconds=43200)` | Calls `dbutils.notebook.run()` with the test definition parameters. Returns a `TestResult`. Captures notebook exit JSON, parses status and warnings, snapshots error logs before/after for failure diagnostics. |

### Verification and Auditing

| Function                                                              | Description                                                               |
|-----------------------------------------------------------------------|---------------------------------------------------------------------------|
| `verify_conventions(test_result, version, scope)`                     | Queries metamodel tables and checks convention compliance.                |
| `audit_vibe_effectiveness(base_version, new_version, scope, vibes_text)` | Compares v1 and v2 metamodel snapshots to measure vibe impact.           |

### Log Management

| Function                        | Description                                                                  |
|---------------------------------|------------------------------------------------------------------------------|
| `merge_all_logs(test_results)`  | Consolidates all per-test log files into merged artifacts. Strips stack traces. |

### Discovery and Helpers

| Function                              | Description                                                                  |
|---------------------------------------|------------------------------------------------------------------------------|
| `_random_conventions(test_id)`        | Generates a randomized set of convention parameters for a test.              |
| `_random_catalog_widgets(test_id)`    | Generates randomized catalog-related parameters for a test.                  |
| `_find_model_json(version, scope)`    | Locates the `model.json` file on the volume for a given version and scope.   |
| `_extract_real_error(test_params, pre_snapshot)` | Reads new error log lines (comparing against pre-run snapshot) to extract diagnostic information on failure. |

### Data Classes

**`TestResult`** -- Holds the outcome of a single test execution.

| Field              | Type   | Description                                      |
|--------------------|--------|--------------------------------------------------|
| `test_name`        | str    | Identifier for the test (e.g., `01_new_base_model_ecm`) |
| `test_label`       | str    | Human-readable description                       |
| `status`           | str    | `PASSED`, `FAILED`, or `SKIPPED`                 |
| `duration_seconds` | float  | Wall-clock execution time                        |
| `error_msg`        | str    | Error message if the test failed, empty otherwise |
| `params`           | dict   | The full parameter dictionary passed to the agent |

---

## Widgets

The test notebook exposes four widgets that control the test run.

| Widget                  | Type | Default                          | Purpose                                         |
|-------------------------|------|----------------------------------|------------------------------------------------|
| `business_name`         | text | `""`                             | The business entity used across all test cases  |
| `business_description`  | text | `""`                             | Description passed to the agent                 |
| `model_vibes`           | text | `""`                             | Vibes text used for the evolution test (Test 03)|
| `catalog`               | text | `""`                             | Name of the test catalog in Unity Catalog       |

**Agent notebook path:** Hardcoded as `./../agent/dbx_vibe_modelling_agent` (resolved relative to the tester notebook location).

---

## Log Artifacts

The suite produces four log files, written to the log output directory within the test catalog volume.

| File                | Contents                                                                 |
|---------------------|--------------------------------------------------------------------------|
| `merged_info.log`   | Consolidated info-level and error-summary entries from all tests         |
| `merged_error.log`  | Consolidated error-level logs from all tests                             |
| `test_summary.log`  | Per-test results including status, duration, and parameter snapshots     |
| `quality_report.log`| Convention compliance audit, vibe effectiveness audit, and quality score |

Stack traces are stripped from merged logs to keep them readable.

---

## Example Test Flow

The following illustrates the logical progression through a typical test run:

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
