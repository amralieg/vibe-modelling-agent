# Vibe Runner Guide

## Table of Contents

- [Overview](#overview)
- [Widgets](#widgets)
- [Batch Input JSON Format](#batch-input-json-format)
- [Task DAG](#task-dag)
- [Key Functions](#key-functions)
- [Execution Flow](#execution-flow)
- [Pipeline Flow per Business](#pipeline-flow-per-business)
- [Catalog Naming](#catalog-naming)
- [Job Tags](#job-tags)
- [Dry-Run Mode](#dry-run-mode)
- [Output Artifacts](#output-artifacts)
- [Error Handling](#error-handling)
- [Constants](#constants)
- [Dependencies](#dependencies)

---

## Overview

The Vibe Runner is a multi-industry data model pipeline orchestrator implemented as a Databricks notebook. It reads a batch input JSON containing the notebook widget values and one or more business/industry definitions, then for each industry orchestrates a 4-task Databricks job pipeline:

1. **Generate an ECM** (Expanded Coverage Model)
2. **Install the ECM** into a dedicated Unity Catalog catalog
3. **Shrink the ECM** into an MVM (Minimum Viable Model)
4. **Install the MVM** into a dedicated Unity Catalog catalog

After all tasks succeed, the runner copies volume artifacts to a local folder and drops the staging catalog. The runner supports both production mode and dry-run mode.

---

## Widgets

The notebook exposes three configurable widgets:

| Widget | Type | Default | Purpose |
|---|---|---|---|
| `business_context` | text | `/Workspace/Users/<your-user>/vibe-modelling/industries.json` | Path to the batch input JSON containing widget values and business definitions to process |
| `dry_run` | dropdown | `yes` | Whether to use dry-run mode (`yes` / `no`) |
| `ping_interval` | dropdown | `1m` | Status logging frequency during job polling: `10s`, `20s`, `30s`, `1m`, `2m`, `5m`, `10m`, `15m` |

**Auto-discovered settings:**

| Setting | Value | Behavior |
|---|---|---|
| Agent notebook path | Auto-discovered relative to runner | Resolved via `posixpath.join(runner_dir, "./../agent/dbx_vibe_modelling_agent")`. Falls back to `./../agent/dbx_vibe_modelling_agent` if auto-discovery fails. |
| Output folder path | `./../models` | Hardcoded relative path where model artifacts are copied after successful pipeline runs. |

---

## Batch Input JSON Format

The batch input JSON defines the notebook widget values to use and a list of businesses to process. It is simply a programmatic way to pass widget values for multiple businesses in one run. The file must contain two top-level sections: `widget_values` and `businesses`.

### `widget_values` Section

Contains 19 required keys that mirror the notebook convention widgets:

| Key | Description |
|---|---|
| `business_domains` | Comma-separated list of business domains to model |
| `org_divisions` | Organizational divisions to include |
| `cataloging_style` | Strategy for organizing catalogs |
| `catalog_prefix` | Prefix applied to catalog names |
| `catalog_suffix` | Suffix applied to catalog names |
| `generate_samples` | Whether to generate sample data |
| `naming_convention` | Naming convention for database objects (e.g., `snake_case`) |
| `primary_key_suffix` | Suffix for primary key columns |
| `schema_prefix` | Prefix applied to schema names |
| `schema_suffix` | Suffix applied to schema names |
| `tag_prefix` | Prefix for tags |
| `tag_suffix` | Suffix for tags |
| `table_id_type` | Data type for table identity columns |
| `boolean_format` | Format for boolean columns |
| `date_format` | Format for date columns |
| `timestamp_format` | Format for timestamp columns |
| `classification_levels` | Data classification levels to apply |
| `housekeeping_columns` | Standard housekeeping/audit columns to include |
| `history_tracking_columns` | Columns used for history/SCD tracking |

### `businesses` Array

An array of objects, each representing one industry/business to process:

| Key | Required | Description |
|---|---|---|
| `name` | Yes | Business/industry name |
| `description` | Yes | Detailed description of the business |
| `model_vibes` | No | Natural-language refinement instructions — inline text (max 2,000 chars) or file path to `.txt` on a UC Volume. Defaults to empty string if omitted. |
| `widget_values` | No | Object of widget_value overrides for this specific business (any of the 19 keys above) |

```json
{
  "widget_values": {
    "business_domains": "",
    "org_divisions": "Operations, Business and Corporate",
    "cataloging_style": "One Catalog",
    "catalog_prefix": "",
    "catalog_suffix": "",
    "generate_samples": "0",
    "naming_convention": "snake_case",
    "primary_key_suffix": "_id",
    "schema_prefix": "",
    "schema_suffix": "",
    "tag_prefix": "dbx_",
    "tag_suffix": "",
    "table_id_type": "BIGINT",
    "boolean_format": "Boolean (True/False)",
    "date_format": "yyyy-MM-dd",
    "timestamp_format": "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",
    "classification_levels": "restricted=restricted, confidential=confidential, internal=Internal, public=public",
    "housekeeping_columns": "No",
    "history_tracking_columns": "No"
  },
  "businesses": [
    {
      "name": "Acme Retail",
      "description": "A mid-size retail chain specializing in home goods and electronics.",
      "model_vibes": "retail-focused, inventory-heavy"
    },
    {
      "name": "Global Logistics Corp",
      "description": "International freight and supply chain management company."
    }
  ]
}
```

Each business object requires `name` and `description`. The `model_vibes` field is set per-business (not in `widget_values`). Any of the 19 `widget_values` keys can be overridden at the business level via a nested `widget_values` object.

---

## Task DAG

The runner creates a multi-task Databricks job with four tasks arranged in the following dependency graph:

```
ECM Generate (task 1)
|-- ECM Install (task 2)   [depends on task 1]
+-- MVM Shrink (task 3)    [depends on task 1]
    +-- MVM Install (task 4)   [depends on task 3]
```

**Parallelism:** Tasks 2 (ECM Install) and 3 (MVM Shrink) run in parallel after Task 1 (ECM Generate) completes. Task 4 (MVM Install) runs only after Task 3 finishes.

---

## Key Functions

### Utility Functions

#### `log(msg="")`

Prints a timestamped log line. Empty string prints a blank line for visual separation.

#### `generate_session_id()`

Returns a positive 64-bit integer session ID derived from `uuid.uuid4()` (masked with `MAX_SIGNED_INT64`). Used to uniquely identify pipeline runs.

#### `_sanitize_tag(value)`

Replaces unsafe characters with `_`, collapses repeating underscores, and strips leading/trailing underscores. Used to produce Databricks-safe job tag values.

#### `sanitize_name(name, strip_stop_words=True)`

Converts a business name into a safe identifier suitable for use in catalog names, job names, and file paths. Strips stop words by default to produce concise identifiers.

### Widget and Configuration Functions

#### `create_widgets()`

Removes all existing widgets and creates the three runner widgets: `business_context`, `dry_run`, and `ping_interval`.

#### `read_widgets()`

Reads widget values, resolves `folder_path` (hardcoded to `./../models`), parses `ping_interval` to seconds, auto-discovers the agent notebook path via `posixpath.join`, and returns a configuration dictionary.

#### `load_business_context(json_path)`

Loads and validates the batch input JSON. Performs structural validation of the `widget_values` and `businesses` sections. On parse errors, provides rich diagnostics including surrounding lines around the error location.

#### `build_notebook_params(widget_values, business, operation, deployment_catalog, data_model_scopes, context_file, model_version, generate_samples)`

Assembles the full parameter dictionary passed to the agent notebook for a single task. Copies all `WIDGET_VALUE_KEYS` from `widget_values`, adds operation-specific parameters, merges per-business overrides, and optionally overrides `generate_samples`.

### Job Management Functions

#### `build_job_tags(business_name, operation, notebook_path, model_scope, version, session_id)`

Constructs a dictionary of job tags prefixed with `dbx_vibe_modelling_*`. These tags are applied to the Databricks job for tracking, filtering, and observability.

#### `find_or_create_job(w, job_name, notebook_path, params, job_tags, task_configs, timeout_seconds)`

Builds `jobs.Task` list from `task_configs` (or a single task if none provided), finds a job by name or creates it, resets/creates settings, calls `run_now`, and returns `(job_id, run_id, reused)`.

#### `submit_notebook_run(w, notebook_path, params, run_name, timeout_seconds, business_name, operation, model_scope, version)`

Wraps job creation with standardized naming conventions and job tags. Delegates to `find_or_create_job` after constructing the appropriate job name and tag set. Returns `run_id` or `None` on failure.

#### `wait_for_run(w, run_id, run_name, job_id, poll_interval)`

Polls a single-task Databricks run to completion. Prints the run URL, logs status updates at the configured `poll_interval`. Returns `(result_state, duration_hrs)`.

#### `wait_for_multi_task_run(w, run_id, job_name, task_keys, biz_name, biz_idx, biz_total, ping_interval, job_id, poll_interval)`

Polls a multi-task Databricks job to completion with per-task status reporting. Tracks the state of each task individually, fetches notebook output for successful tasks to parse exit JSON and warnings. Returns `(task_results_dict, total_hrs)`.

#### `_parse_exit_json(raw_value, default_status="unknown")`

Parses the notebook exit JSON value to extract `(status, warnings_list)`. Handles missing, empty, and malformed input defensively.

#### `_get_workspace_host_and_org()`

Attempts to retrieve `(host, org_id)` from `dbruntime.databricks_repl_context.getContext().toJson()`, falling back to `WorkspaceClient().config.host`. Returns `("", "")` on failure.

### Catalog Management Functions

#### `ensure_staging_catalog(spark, catalog_name)`

`DROP CATALOG IF EXISTS ... CASCADE` then `CREATE CATALOG`. Guarantees a clean working environment for each pipeline run. Returns `bool`.

#### `ensure_install_catalog(spark, catalog_name)`

Checks whether the install catalog already exists. If it does not exist, creates it. If it does exist, runs clash detection for pre-existing user schemas (excluding `default`, `information_schema`, `_metamodel`, `_metrics`). Returns `(ok: bool, user_schemas: list)`.

#### `drop_catalog(spark, catalog_name)`

`DROP CATALOG IF EXISTS ... CASCADE`. Logs success/failure. Returns `bool`.

#### `_pre_launch_validate(spark, biz_name, staging_catalog, ecm_v1_catalog, mvm_v1_catalog, business, widget_values, notebook_path, effective_notebook)`

Performs pre-flight validation before launching the pipeline for a business. Builds an `errors` list for missing/invalid inputs, calls `ensure_install_catalog` for ECM/MVM and `ensure_staging_catalog`. Raises `ValueError` with a formatted message listing all errors, or logs success.

### Pipeline Orchestration Functions

#### `run_pipeline_for_business(w, spark, business, widget_values, notebook_path, folder_path, ping_interval, session_id, dry_run, biz_idx, biz_total, effective_notebook)`

Core orchestration function for a single industry. Manages the full lifecycle: catalog setup, parameter construction, multi-task job submission, monitoring, artifact copying, and cleanup. See [Pipeline Flow per Business](#pipeline-flow-per-business) for details.

#### `create_dry_run_notebook(w, runner_notebook_dir)`

Generates and uploads a simulated agent notebook to the workspace at `{runner_notebook_dir}/vibe_runner_dry_run`. This notebook mimics the real agent by creating fake metamodel tables, physical schemas, and volume artifacts without performing actual model generation. Returns the path string or `None` on failure.

### Artifact and Volume Functions

#### `get_model_json_path(catalog_name, business_name, version, scope)`

Returns the full Volume path to `model.json`: `/Volumes/{catalog_name}/_metamodel/vol_root/business/{sanitized}/v{version}_{scope}/model.json`.

#### `get_business_volume_root(catalog_name, business_name)`

Returns the Volume root path for a business: `/Volumes/{catalog_name}/_metamodel/vol_root/business/{sanitized}`.

#### `copy_business_folder(source_catalog, business_name, folder_path)`

Copies volume artifacts from a Unity Catalog volume to a local folder. Attempts `shutil.copytree` first, then falls back to `dbutils.fs.cp` if the initial method fails. Returns `bool`.

#### `verify_copied_files(folder_path, business_name)`

Walks the destination directory, requires files and ideally `model.json`. Logs `VERIFY OK` or `VERIFY FAILED`. Returns `bool`.

### Results and Reporting Functions

#### `save_results(results, folder_path)`

Placeholder for writing a summary report. Currently a no-op (`pass`). When implemented, will write a Markdown report file summarizing the pipeline run with per-industry results, status, timing, and error details.

#### `display_results(results)`

Logs a wide ASCII summary table with per-industry results including status, duration, and warning counts.

#### `main()`

Entry point. Prints ASCII art banner, creates/reads widgets, loads context, initializes `WorkspaceClient` and Spark, optionally creates dry-run notebook, loops `run_pipeline_for_business` for each industry, calls `display_results` and `save_results`, builds a DataFrame `display`, raises `RuntimeError` if any industry failed, and returns the results list.

---

## Execution Flow

The notebook executes in the following order:

1. Prints an ASCII art banner.
2. Creates and reads widget values. Auto-discovers the agent notebook path relative to the runner notebook location.
3. Loads and validates the batch input JSON via `load_business_context()`.
4. Initializes the Databricks `WorkspaceClient` and `SparkSession`.
5. If `dry_run` is set to `yes`: uploads a simulated agent notebook via `create_dry_run_notebook()`.
6. Creates the local output folder specified by `folder_path`.
7. For each business in the `businesses` array (processed sequentially): runs `run_pipeline_for_business()`.
8. Displays an ASCII results table via `display_results()`.
9. Calls `save_results()` (currently a no-op placeholder).
10. Returns the results list.

---

## Pipeline Flow per Business

The `run_pipeline_for_business()` function executes the following steps for each industry:

### 1. Derive Catalog Names

Three catalogs are derived from the sanitized business name:

| Catalog | Naming Pattern | Purpose |
|---|---|---|
| Staging | `{sanitized_name}_temp` | Temporary workspace for model generation |
| ECM Install | `{sanitized_name}_ecm_v1` | Permanent home for the Expanded Coverage Model |
| MVM Install | `{sanitized_name}_mvm_v1` | Permanent home for the Minimum Viable Model |

### 2. Pre-Launch Validation

Runs `_pre_launch_validate()` to confirm all prerequisites are met.

### 3. Build Parameters for All Four Tasks

Each task receives a tailored parameter dictionary:

| Task | Operation | Schema Prefix | Target Catalog |
|---|---|---|---|
| ECM Generate | `new base model` | `ecm_` | Staging catalog |
| ECM Install | `install model` | `""` (empty) | ECM install catalog |
| MVM Shrink | `shrink ecm` | `mvm_` | Staging catalog |
| MVM Install | `install model` | `""` (empty) | MVM install catalog |

### 4. Create Multi-Task Job

Calls `find_or_create_job()` to create (or reuse) a Databricks job with the four-task DAG and triggers a run.

### 5. Monitor Execution

Calls `wait_for_multi_task_run()` to poll the job, reporting per-task progress at the configured interval.

### 6. On Success

- Copies volume artifacts from the staging catalog to the local output folder via `copy_business_folder()`.
- Verifies the copied artifacts via `verify_copied_files()`.
- Drops the staging catalog to clean up temporary resources.

### 7. On Failure

- Logs which specific tasks failed.
- Skips artifact copying and staging catalog cleanup (preserves state for debugging).

---

## Catalog Naming

### Naming Conventions

| Catalog Type | Pattern | Example |
|---|---|---|
| Staging | `{sanitized_name}_temp` | `acme_retail_temp` |
| ECM Install | `{sanitized_name}_ecm_v1` | `acme_retail_ecm_v1` |
| MVM Install | `{sanitized_name}_mvm_v1` | `acme_retail_mvm_v1` |

### Clash Detection Exclusions

The following internal schemas are excluded from clash detection when checking existing install catalogs:

- `default`
- `information_schema`
- `_metamodel`
- `_metrics`

---

## Job Tags

All job tags are prefixed with `dbx_vibe_modelling_` and include the following:

| Tag | Description |
|---|---|
| `dbx_vibe_modelling_business` | Business/industry name |
| `dbx_vibe_modelling_model` | Model scope and version (e.g., `ecm_v1`, `mvm_v1`) |
| `dbx_vibe_modelling_operation` | Current operation (e.g., `new base model`, `install model`) |
| `dbx_vibe_modelling_notebook` | Path to the agent notebook |
| `dbx_vibe_modelling_session_id` | Unique session identifier for the run |
| `dbx_vibe_modelling_domains` | Business domains being modeled |
| `dbx_vibe_modelling_products` | Products/offerings included |
| `dbx_vibe_modelling_attributes` | Model attributes |
| `dbx_vibe_modelling_foreign_keys` | Foreign key configuration |
| `dbx_vibe_modelling_tags` | Applied tags |
| `dbx_vibe_modelling_metrics` | Metrics configuration |

---

## Dry-Run Mode

When `dry_run` is set to `yes`, the runner creates and uploads a simulated agent notebook that mimics the real agent without performing actual model generation. The simulated notebook:

- Creates fake metamodel tables in the staging catalog.
- Creates physical schemas to simulate the install process.
- Generates volume artifacts that mirror the real agent output:
  - `model.json` -- Model definition file
  - SQL schema files (`schemas/*.sql`)
  - Metrics SQL files (`metrics/*.sql`)
  - DBML diagram files
  - README documentation
  - Vibes configuration files
  - RDF ontology files
  - Release notes
  - CSV documentation files
  - Sample data files

Dry-run mode is useful for testing the pipeline orchestration, validating the batch input JSON, and verifying infrastructure without consuming compute resources for actual model generation.

---

## Output Artifacts

### Markdown Report

The `save_results()` function is currently a placeholder (no-op). When implemented, it will write a summary report to the output folder with per-industry results, status, duration, and error details.

### Model Artifacts

For each successfully processed business, artifacts are copied to:

```
{folder_path}/{sanitized_name}/v{version}_{scope}/
```

The artifact directory structure:

```
{sanitized_name}/v{version}_{scope}/
|-- model.json
|-- readme.md
|-- schemas/
|   +-- *.sql
|-- metrics/
|   +-- *.sql
|-- docs/
|   +-- *.csv
|-- vibes/
|-- ontology/
|   +-- *.rdf
|-- diagram/
|   +-- *.dbml
|-- samples/
+-- release_notes/
```

### Unity Catalog Catalogs

Two permanent catalogs are created for each business:

- `{sanitized_name}_ecm_v1` -- Contains the Expanded Coverage Model
- `{sanitized_name}_mvm_v1` -- Contains the Minimum Viable Model

The staging catalog (`{sanitized_name}_temp`) is dropped after successful completion.

---

## Error Handling

The runner implements multiple layers of error handling:

| Error Scenario | Handling Strategy |
|---|---|
| JSON parse errors | Rich diagnostics with surrounding lines around the error location |
| Missing widget keys | Explicit validation that enumerates all missing keys in the error message |
| Pre-launch validation failures | Seven or more pre-flight checks run before any job is submitted |
| Catalog clash detection | Warns if install catalogs contain existing schemas (excluding internal schemas) |
| Per-industry isolation | An exception in one industry does not stop processing of subsequent industries |
| Job submission/monitoring failures | Caught and logged with details; the pipeline continues to the next business |
| Copy failures | Attempts `shutil.copytree` first, then falls back to `dbutils.fs.cp` |
| Notebook auto-discovery failure | Raises `ValueError` with instructions on how to set the path manually |

---

## Constants

| Constant | Value | Purpose |
|---|---|---|
| `POLL_INTERVAL_SECONDS` | `30` | Default interval (in seconds) between job status polls |
| `JOB_TIMEOUT_SECONDS` | `43200` (12 hours) | Maximum allowed runtime per task before timeout |
| `MAX_SIGNED_INT64` | `9223372036854775807` | Upper bound for random session ID generation |

---

## Dependencies

### Required

| Package | Purpose |
|---|---|
| `databricks-sdk` | Workspace client, job management, file operations |
| `pyspark` | SparkSession for catalog/schema DDL operations |
| `dbutils` | Databricks utilities for file system operations and widgets |
| `json` | Batch input JSON parsing |
| `os` | File system path operations |
| `re` | Regular expressions for name sanitization |
| `time` | Sleep/polling intervals |
| `uuid` | Session ID generation |
| `shutil` | Local file copy operations |
| `datetime` | Timestamps for reports and artifact naming |
| `base64` | Encoding notebook content for upload |

### Optional

| Package | Purpose |
|---|---|
| `pandas` | Enhanced display of results tables |
