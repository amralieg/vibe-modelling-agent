# Vibe Tester -- End-to-End Integration Test Suite

## Overview

The Vibe Tester is a comprehensive end-to-end integration test suite for the Vibe Modelling Agent. It exercises the full agent lifecycle on Databricks, from model generation through physical deployment, sample data creation, and teardown. The suite is designed to run as a Databricks notebook and produces a weighted quality score alongside consolidated log artifacts.

**Core capabilities:**

- Runs the agent notebook via `dbutils.notebook.run()` with varied parameter combinations
- Validates model generation at both MVM (Minimum Viable Model) and ECM (Enterprise Conceptual Model) scopes
- Verifies physical deployment (schemas, tables, sample data) in Unity Catalog
- Tests the full lifecycle: create, evolve (vibe), resize, install, generate samples, uninstall, reinstall
- Audits convention compliance by querying metamodel tables
- Produces a weighted quality score and consolidated log files

---

## Test Strategy

The suite follows the strategy **"ECM once, ALL ops on MVM + edge cases + negative tests"**. One ECM model is generated to prove full-scope capability, then the remaining lifecycle operations (vibe evolution, install, sample generation, uninstall, reinstall) are exercised against the MVM model. Edge cases and negative/guard-rail tests round out coverage.

### Test Categories

| Category              | Count | Tests                     | Purpose                                  |
|-----------------------|-------|---------------------------|------------------------------------------|
| Core tests            | 13    | 01--11                    | Main lifecycle operations                |
| Verification tests    | 4     | 06c, 07b, 08b, 09c       | Physical artifact validation             |
| Edge case tests       | 2     | 12--13                    | Boundary conditions                      |
| Negative/guard-rail   | 2     | 14--15                    | Error handling quality                   |
| Reinstall test        | 1     | 08c                       | Full uninstall-then-reinstall cycle      |

---

## All 22 Test Cases

### Core Tests (01--11)

| #   | Test Name                   | Label                                          | What It Validates                                        | Expected Outcome                                  |
|-----|-----------------------------|-------------------------------------------------|----------------------------------------------------------|---------------------------------------------------|
| 01  | 01_new_base_model_ecm       | Generate full ECM base model (v1)               | Agent can produce a complete Enterprise Conceptual Model | Agent exits successfully                          |
| 02  | 02_new_base_model_mvm       | Generate full MVM base model (v1)               | Agent can produce a Minimum Viable Model (primary test model) | Agent exits successfully                          |
| 03  | 03_vibe_modeling_mvm        | Evolve MVM model via vibes (v1 to v2)           | Vibe evolution produces a new model version              | Agent produces v2                                 |
| 04  | 04_shrink_ecm_to_mvm        | Shrink ECM model to MVM scope                   | Model can be resized from ECM down to MVM                | Agent exits successfully                          |
| 05  | 05_enlarge_mvm_to_ecm       | Enlarge MVM model to ECM scope                  | Model can be resized from MVM up to ECM                  | Agent exits successfully                          |
| 06  | 06_install_mvm_v1           | Deploy model v1 to target catalog               | Physical deployment creates schemas and tables           | Schemas and tables created in Unity Catalog       |
| 07  | 07_generate_samples_mvm_v1  | Generate sample data into installed tables       | Sample data generation populates deployed tables         | Agent exits successfully                          |
| 08  | 08_uninstall_mvm_v1         | Uninstall deployed model                        | Uninstall removes all physical artifacts                 | Agent exits successfully                          |
| 09  | 09_install_mvm_v2           | Install vibed (v2) model                        | Evolved model can be deployed                            | Agent exits successfully                          |
| 10  | 10_generate_samples_mvm_v2  | Generate sample data for v2                     | Sample data generation works on evolved model            | Agent exits successfully                          |
| 11  | 11_uninstall_mvm_v2         | Uninstall v2 deployment                         | Uninstall works for evolved model version                | Agent exits successfully                          |

### Clash Detection Tests (06b, 09b)

| #    | Test Name                    | Label                                          | What It Validates                                        | Expected Outcome                                  |
|------|------------------------------|-------------------------------------------------|----------------------------------------------------------|---------------------------------------------------|
| 06b  | 06b_clash_detection_mvm_v1   | Reject duplicate install (same conventions)     | Agent detects and rejects duplicate physical deployment   | Failure with `PHYSICAL DEPLOYMENT CLASH` message  |
| 09b  | 09b_clash_detection_mvm_v2   | Reject duplicate v2 install                     | Agent detects and rejects duplicate v2 deployment        | Failure with clash message                        |

### Verification Tests (06c, 07b, 08b, 09c)

| #    | Test Name               | Label                                                    | What It Validates                                              | Expected Outcome                                          |
|------|-------------------------|----------------------------------------------------------|----------------------------------------------------------------|-----------------------------------------------------------|
| 06c  | 06c_verify_install      | Physical artifacts exist (schemas, tables, cataloging)   | Schemas and tables were actually created with correct style     | Schemas > 0, tables > 0                                   |
| 07b  | 07b_verify_samples      | Tables actually contain rows                             | Sample data generation populated tables with real data         | >= 50% of tables have rows > 0                            |
| 08b  | 08b_verify_uninstall    | No leftover tables after uninstall                       | Uninstall cleanly removed all physical artifacts               | 0 remaining tables                                        |
| 09c  | 09c_verify_v2           | Physical v2 artifacts exist, compare v1 vs v2            | Evolved model deployment differs from v1                       | Schemas > 0, tables > 0, prints delta between v1 and v2  |

### Reinstall Test (08c)

| #    | Test Name        | Label                                    | What It Validates                              | Expected Outcome                                  |
|------|------------------|------------------------------------------|------------------------------------------------|---------------------------------------------------|
| 08c  | 08c_reinstall    | Full cycle: uninstall then reinstall     | Complete uninstall-reinstall cycle works        | Install succeeds, cleanup uninstalls again        |

### Edge Case Tests (12--13)

| #   | Test Name          | Label                                       | What It Validates                                | Expected Outcome                                   |
|-----|--------------------|---------------------------------------------|--------------------------------------------------|----------------------------------------------------|
| 12  | 12_empty_vibes     | Handle empty model_vibes gracefully         | Agent handles absent or empty vibes without crash | Clean exit or "no vibes"/"empty vibes" type error  |
| 13  | 13_ctx_install     | Install from context file (model.json)      | Agent can install from a pre-existing model file  | Install succeeds, schemas and tables created       |

### Negative / Guard-Rail Tests (14--15)

| #   | Test Name          | Label                                                          | What It Validates                                       | Expected Outcome                                               |
|-----|--------------------|----------------------------------------------------------------|---------------------------------------------------------|----------------------------------------------------------------|
| 14  | 14_invalid_ctx     | Reject invalid context files (2 sub-tests)                     | Agent rejects non-existent path and pasted JSON alike   | Both sub-tests fail with clear error messages                  |
| 15  | 15_no_biz_name     | Reject empty business_name                                     | Agent enforces required business_name parameter         | Fails with error mentioning `business_name`                    |

---

## Dependency Chain

Tests cascade -- if a prerequisite fails, all dependents are **SKIPPED** rather than run against a broken state.

```
Test 01 (ECM base model) fails
  +-- Test 04 (shrink ECM to MVM) .............. SKIPPED

Test 02 (MVM base model) fails
  +-- Test 03 (vibe modeling) .................. SKIPPED
  +-- Test 05 (enlarge MVM to ECM) ............. SKIPPED
  +-- Test 06 (install v1) ..................... SKIPPED
  +-- Test 07 (generate samples v1) ............ SKIPPED
  +-- Test 08 (uninstall v1) ................... SKIPPED
  +-- Test 09 (install v2) ..................... SKIPPED
  +-- Test 10 (generate samples v2) ............ SKIPPED
  +-- Test 11 (uninstall v2) ................... SKIPPED
  +-- Test 12 (empty vibes) .................... SKIPPED
  +-- Test 13 (ctx install) .................... SKIPPED

Test 03 (vibe modeling) fails
  +-- Test 09  (install v2) .................... SKIPPED
  +-- Test 09b (clash detection v2) ............ SKIPPED
  +-- Test 09c (verify v2) .................... SKIPPED
  +-- Test 10  (generate samples v2) ........... SKIPPED
  +-- Test 11  (uninstall v2) .................. SKIPPED
```

---

## Special Pass/Fail Logic

Not all tests follow the standard "agent exits 0 = pass" pattern. Several tests invert or customize their success criteria.

| Test   | Pass Condition                                                        |
|--------|-----------------------------------------------------------------------|
| 06b    | Agent **fails** with a message containing `PHYSICAL DEPLOYMENT CLASH` |
| 09b    | Agent **fails** with a clash message                                  |
| 12     | Clean exit **or** error containing "no vibes" / "empty vibes"         |
| 14     | Two sub-tests; **both** must reject their invalid input               |
| 15     | Agent **fails** (any error) -- validates required-field enforcement    |
| 07b    | >= 50% of installed tables have `rows > 0`                            |
| 08b    | Exactly 0 tables remain after uninstall                               |

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

The test suite executes in eight sequential phases.

### Phase 1 -- Read Widgets

Reads the five notebook widgets that parameterize the test run. See [Widgets](#widgets) for the full list.

### Phase 2 -- Resolve Notebook Path

Auto-discovers the agent notebook via `_discover_latest_notebook(directory)` or uses the explicit path provided in the `vibe_modelling_agent` widget.

### Phase 3 -- Clean Slate (Fixture Setup)

Ensures a pristine environment before tests begin:

```sql
DROP CATALOG IF EXISTS <test_catalog> CASCADE;
CREATE CATALOG <test_catalog>;
CREATE SCHEMA <test_catalog>._metamodel;
-- Create vol_root volume and log output directory
```

### Phase 4 -- Run All 22 Tests

Executes every test definition in sequence, respecting the dependency chain. Each test is invoked via `run_test()` or `run_test_expect_clash()` depending on its expected outcome.

### Phase 5 -- Merge All Logs

Consolidates per-test log files into unified artifacts using `merge_all_logs(test_results)`:

- `merged_info.log` -- combined info and error summaries per test
- `merged_error.log` -- combined error logs per test

Stack traces are stripped during the merge process.

### Phase 6 -- Convention Verification and Vibe Effectiveness Audit

Runs the `verify_conventions()` function against metamodel tables and the `audit_vibe_effectiveness()` function to compare v1 and v2 models. See the dedicated sections below.

### Phase 7 -- Quality Report

Computes the weighted quality score and writes `quality_report.log`. See [Quality Scoring](#quality-scoring).

### Phase 8 -- Final Results Summary

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
| `run_test(test_def, timeout_seconds=43200)` | Calls `dbutils.notebook.run()` with the test definition parameters. Returns a `TestResult`.         |
| `run_test_expect_clash(test_def)`         | Wrapper around `run_test()` that inverts pass/fail -- used for clash detection tests.                |

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
| `_discover_latest_notebook(directory)` | Auto-discovers the agent notebook in the given workspace directory.           |
| `_random_conventions(test_id)`        | Generates a randomized set of convention parameters for a test.              |
| `_random_catalog_widgets(test_id)`    | Generates randomized catalog-related parameters for a test.                  |
| `_find_model_json(version, scope)`    | Locates the `model.json` file on the volume for a given version and scope.   |
| `_extract_real_error(test_params)`    | Reads the agent error log to extract diagnostic information on failure.       |

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

The test notebook exposes five widgets that control the test run.

| Widget                  | Type | Default                          | Purpose                                         |
|-------------------------|------|----------------------------------|------------------------------------------------|
| `business_name`         | text | `"Bank"`                         | The business entity used across all test cases  |
| `business_description`  | text | `"very small bank"`              | Description passed to the agent                 |
| `model_vibes`           | text | `"maximum tables are 5..."`      | Vibes text used for the evolution test (Test 03)|
| `catalog`               | text | `"_test_vibes_01"`               | Name of the test catalog in Unity Catalog       |
| `vibe_modelling_agent`  | text | `""`                             | Explicit path to the agent notebook (optional)  |

When `vibe_modelling_agent` is left empty, Phase 2 auto-discovers the notebook using `_discover_latest_notebook()`.

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
Phase 1  Read widgets (business_name, catalog, etc.)
Phase 2  Resolve notebook path
Phase 3  DROP CASCADE + recreate test catalog, _metamodel schema, vol_root volume
Phase 4  Execute tests:
           01  Generate ECM base model (v1)
           02  Generate MVM base model (v1)         <-- primary model
           03  Evolve MVM via vibes (v1 -> v2)
           04  Shrink ECM to MVM
           05  Enlarge MVM to ECM
           06  Install MVM v1
           06b Attempt duplicate install (expect clash)
           06c Verify install artifacts
           07  Generate sample data for v1
           07b Verify sample data presence
           08  Uninstall MVM v1
           08b Verify uninstall completeness
           08c Reinstall cycle (uninstall + reinstall + cleanup)
           09  Install MVM v2
           09b Attempt duplicate v2 install (expect clash)
           09c Verify v2 artifacts and delta
           10  Generate sample data for v2
           11  Uninstall MVM v2
           12  Empty vibes edge case
           13  Context file install
           14  Invalid context files (2 sub-tests)
           15  Missing business_name
Phase 5  Merge all test logs
Phase 6  Convention verification + vibe effectiveness audit
Phase 7  Compute weighted quality score
Phase 8  Print final summary
```
