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

The notebook exposes five configurable widgets:

| Widget | Type | Default | Purpose |
|---|---|---|---|
| `business_context` | text | `/Workspace/Users/<your-user>/vibe-modelling/industries.json` | Path to the batch input JSON containing widget values and business definitions to process |
| `vibe_modelling_agent` | text | `""` (empty string) | Path to the agent notebook. Auto-discovers if left blank |
| `folder_path` | text | `./lakehouse-models` | Local output folder for model artifacts |
| `dry_run` | dropdown | `yes` | Whether to use dry-run mode (`yes` / `no`) |
| `ping_interval` | dropdown | `1m` | Status logging frequency during job polling: `10s`, `20s`, `30s`, `1m`, `2m`, `5m`, `10m`, `15m` |

---

## Batch Input JSON Format

The batch input JSON defines the notebook widget values to use and a list of businesses to process. It is simply a programmatic way to pass widget values for multiple businesses in one run. The file must contain two top-level sections: `widget_values` and `businesses`.

### `widget_values` Section

Contains 20 required keys that mirror the notebook widget form:

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
| `widget_values` | No | Object of widget_value overrides for this specific business (any of the 20 keys above) |

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

Each business object requires `name` and `description`. The `model_vibes` field is set per-business (not in `widget_values`). Any of the 20 `widget_values` keys can be overridden at the business level via a nested `widget_values` object.

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

### `sanitize_name(name, strip_stop_words=True)`

Converts a business name into a safe identifier suitable for use in catalog names, job names, and file paths. Strips stop words by default to produce concise identifiers.

### `build_job_tags(business_name, operation, notebook_path, model_scope, version, session_id)`

Constructs a dictionary of job tags prefixed with `dbx_vibe_modelling_*`. These tags are applied to the Databricks job for tracking, filtering, and observability.

### `find_or_create_job(w, job_name, notebook_path, params, job_tags, task_configs, timeout_seconds)`

Creates a new Databricks job or reuses an existing one (matched by name), then triggers a run. Accepts the WorkspaceClient, job configuration parameters, and task definitions. Returns the run ID.

### `load_business_context(json_path)`

Loads and validates the batch input JSON. Performs structural validation of the `widget_values` and `businesses` sections. On parse errors, provides rich diagnostics including surrounding lines around the error location.

### `build_notebook_params(widget_values, business, operation, ...)`

Assembles the full parameter dictionary passed to the agent notebook for a single task. Merges global `widget_values` with business-level overrides and adds operation-specific parameters such as `operation`, `schema_prefix`, catalog names, and model scope.

### `ensure_staging_catalog(spark, catalog_name)`

Drops the staging catalog if it already exists, then recreates it. This guarantees a clean working environment for each pipeline run.

### `ensure_install_catalog(spark, catalog_name)`

Checks whether the install catalog already exists. If it does not exist, creates it. If it does exist, runs clash detection to warn about pre-existing schemas that may conflict with the install.

### `_pre_launch_validate(...)`

Performs pre-flight validation before launching the pipeline for a business. Checks seven or more conditions including:

- Agent notebook path exists and is accessible
- Batch input JSON is structurally valid
- Required widget values are present
- Catalog names are valid identifiers
- No naming collisions between staging and install catalogs
- Workspace client is authenticated
- Sufficient permissions for catalog operations

### `create_dry_run_notebook(w, runner_notebook_dir)`

Generates and uploads a simulated agent notebook to the workspace. This notebook mimics the real agent by creating fake metamodel tables, physical schemas, and volume artifacts without performing actual model generation.

### `submit_notebook_run(...)`

Wraps job creation with standardized naming conventions and job tags. Delegates to `find_or_create_job` after constructing the appropriate job name and tag set.

### `wait_for_run(w, run_id, run_name, ...)`

Polls a single-task Databricks run to completion. Logs status updates at the configured `ping_interval`. Returns the final run status.

### `wait_for_multi_task_run(w, run_id, job_name, task_keys, ...)`

Polls a multi-task Databricks job to completion with per-task status reporting. Tracks the state of each task individually and logs which tasks are pending, running, succeeded, or failed.

### `run_pipeline_for_business(...)`

Core orchestration function for a single industry. Manages the full lifecycle: catalog setup, parameter construction, job submission, monitoring, artifact copying, and cleanup. See [Pipeline Flow per Business](#pipeline-flow-per-business) for details.

### `copy_business_folder(source_catalog, business_name, folder_path)`

Copies volume artifacts from a Unity Catalog volume to a local folder. Attempts `shutil.copytree` first, then falls back to `dbutils.fs.cp` if the initial method fails.

### `verify_copied_files(folder_path, business_name)`

Validates that the expected artifact structure was successfully copied to the local folder. Checks for the presence of required directories and files.

### `save_results(results, folder_path)`

Writes a Markdown report file summarizing the pipeline run. The report includes an overall summary and per-industry results with status, timing, and error details.

### `display_results(results)`

Renders an ASCII table to the notebook output showing the status of each industry pipeline run.

---

## Execution Flow

The notebook executes in the following order:

1. Prints an ASCII art banner.
2. Creates and reads widget values. Auto-discovers the agent notebook path if the `vibe_modelling_agent` widget is left blank.
3. Loads and validates the batch input JSON via `load_business_context()`.
4. Initializes the Databricks `WorkspaceClient` and `SparkSession`.
5. If `dry_run` is set to `yes`: uploads a simulated agent notebook via `create_dry_run_notebook()`.
6. Creates the local output folder specified by `folder_path`.
7. For each business in the `businesses` array (processed sequentially): runs `run_pipeline_for_business()`.
8. Displays an ASCII results table via `display_results()`.
9. Writes a Markdown report file via `save_results()`.
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
| `dbx_vibe_modelling_model` | Model type (ECM or MVM) |
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

A summary report is written to the output folder:

```
vibe_runner_results_{timestamp}.md
```

The report contains an overall summary and per-industry results including status, duration, and any error details.

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
