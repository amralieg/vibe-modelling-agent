# EXHAUSTIVE DESIGN DOCUMENT: Next Generation Vibe Modelling Agent (Agentic Rewrite)
**Author:** Gemini 3.1 Pro
**Objective:** 100% Complete Rewrite to a Fully Agentic Architecture

## 1. 100% OF THE GOALS
This rewrite is driven by the following non-negotiable goals:

### 1.1 Input Parity (100% Backward Compatible)
The new agentic system MUST consume the exact same Databricks Widgets and parameters as the legacy procedural pipeline. This includes:
- `business_name`, `business_description`, `model_vibes`
- `business_domains`, `data_model_scopes`, `must_have_data_products`
- `operation`, `model_version`
- `naming_convention`, `generate_samples`, `cataloging_style`
The `VibeOrchestrator` and `_unpack_widgets_core` logic must be perfectly replicated to ensure the ingestion layer behaves identically.

### 1.2 Output Parity (100% Artifact Identical)
The output artifacts must be mathematically identical in structure and formatting to the current implementation. This includes:
- The canonical `model.json` generated for every sub-version (ecm_v1, mvm_v1, etc.)
- `next_vibes.txt` and `next_vibes_early.txt`
- The structured Data Dictionary (Excel)
- DBML relational schema output
- RDFS Ontology output
- Metric Views executed flawlessly against the installed schema
- Physical tables, schemas, and catalogs deployed exactly as requested.

### 1.3 High Quality, Production-Grade Data Model
The agent will enforce structural integrity without exception:
- **3NF Normalization:** No denormalized natural keys.
- **SSOT (Single Source of Truth):** No cross-domain semantic duplication.
- **DAG Enforcement:** Zero cyclic dependencies, zero bidirectional links, zero silos.
- **Proper Naming:** Consistent snake_case, PascalCase, or camelCase handling throughout via `NamingConvention`.

### 1.4 Supreme User Vibe Adherence
Every user directive expressed in `model_vibes` or `business_description` reigns supreme. If a user asks for exactly 3 domains, the system must halt any LLM suggestion that creates 4 domains. This requires a deterministic `VibeContract` enforcement layer at the execution boundary.

### 1.5 Radical Codebase Reduction
The legacy system is an 88k+ line procedural monolith. The new system will reduce this by implementing a unified **Agentic State Machine**. Instead of writing separate logic for `in_domain_linking`, `cross_domain_linking`, and `architect_review_mutations`, the LLM will generate `FindingShapes` that are handled by a universal `FindingDispatcher` and applied by generic mutation actions.

### 1.6 Faster Processing Time
The ECM processing time currently takes up to 10 hours for Tier 1. We will achieve order-of-magnitude speedups by:
- Enforcing strict flat concurrency using `GlobalConcurrencyManager`.
- Removing deep `ThreadPoolExecutor` nesting.
- Employing intelligent batching, C-ladder fallbacks, and exponential backoff for LLM rate limits.

### 1.7 Truly Agentic Architecture
The pipeline will transition from Step 1 -> Step 12 to a continuous evaluation loop: **Discover -> Critique -> Plan -> Execute -> Validate**. The agent will act like a senior data architect, using static analysis tools and LLM reviews iteratively until the model meets the definition of 'Done'.

## 2. 100% LESSONS LEARNED FROM PREVIOUS IMPLEMENTATION
### 2.1 Lesson 1: LLMs Hallucinate Graph Topology
Asking the LLM to detect cycles, bidirectional FKs, or siloed tables fails consistently. Graph integrity must remain deterministic Python algorithms (`_detect_cycles_dfs`, `_detect_direct_bidirectional_links`).

### 2.2 Lesson 2: Nested ThreadPools Cause Deadlocks
Deeply nested thread pools in Databricks Serverless lead to silent hanging. The `GlobalConcurrencyManager` and `ThreadPoolGuard` must be the only mechanism for concurrency.

### 2.3 Lesson 3: User Vibe Supremacy Must Be a Hard Gate
LLMs inherently drift toward their pre-trained defaults. The `VibeContract` must be parsed early and strictly enforced by the `FindingDispatcher`.

### 2.4 Lesson 4: Naming Drift Corrupts Referentials
Spreading `pk_suffix` or string manipulation across multiple files breaks foreign key references. A centralized `NamingConvention` singleton is strictly necessary.

### 2.5 Lesson 5: Regeneration is Too Expensive
Running full LLM generation passes to fix trivial naming issues wastes tokens and time. The `_pre_static_analysis_autofix` pass is essential for surgical corrections.

### 2.6 Lesson 6: Deferring Issues Creates Tech Debt
The 'Defer to v0.8.1' mentality violated the 'Fix Everything Now' rule. The Agentic Loop must block finalization until all MUST_FIX severity findings are resolved.

### 2.7 Lesson 7: Silent Normalization Failures
Orphaned `_id` columns were left behind after failed batches. Deterministic fallback linkers (`_post_normalization_deterministic_fk_linker`) are a required safety net.

### 2.8 Lesson 8: JSON Formatting Issues
Using `ensure_ascii=False` blew up diff sizes. All artifacts must serialize deterministically.

### 2.9 Lesson 9: LLM Parsing Fragility
Regex-based parsing of LLM outputs broke constantly. Strong JSON schemata and robust coercion functions (`_deep_parse_json_values`, `clean_json_response`) are necessary.

### 2.10 Lesson 10: Duplicate Attributes Crash SQL
The LLM occasionally outputs duplicate attribute names in a single product. Deterministic `deduplicate_attributes_in_place` must run before DDL generation.

### 2.11 Lesson 11: Cross-Domain Deduplication is Hard
Exact semantic overlap between domains caused confusion. Consolidating into a `shared` domain is a much better pattern than outright deletion.

### 2.12 Lesson 12: Metric View Generation Scales Poorly
Per-domain metric generation caused dropped views. KPI-first metric view generation (`step_generate_kpi_first_metric_views`) is more robust and scalable.

### 2.13 Lesson 13: Soft Accepts Hide Critical Failures
Logging 'Max retries exhausted. Proceeding with errors' masked fatal FK drops. Soft-accepts are now a RED flag in pulse monitoring and must fail the step.

### 2.14 Lesson 14: Physical Parity Mismatches
The JSON state diverged from the Unity Catalog state. `step_install_parity_audit` must verify that every expected table and view actually materialized.

### 2.15 Lesson 15: Context Window Overflows
Providing the entire Enterprise model to the LLM exceeded token limits. Chunked linking (`_p070_cluster_products_for_chunking`) and pairwise reviews are mandatory.

### 2.16 Lesson 16: Observability Sentinels are Critical
The aliases (`[... FIRED]`) allow deterministic regression testing. The new design must preserve every single alias string exactly as defined.

### 2.17 Lesson 17: Surgical MVM Preserves Value
Overwriting all MVs on a minor surgical update angered users. `_preserve_baseline_metric_views_for_surgical` must rewrite MV SQL instead of dropping it.

### 2.18 Lesson 18: Action Vocabularies Reduce Hallucination
Providing the LLM with a restricted `MASTER_ACTION_REGISTRY` forces it to choose valid mutation operations, reducing syntax errors.

### 2.19 Lesson 19: Cost-Class Autofixing is Essential
Not all fixes are equal. Renaming a PK is `REQUIRES_FK_REWIRE`, renaming a description is `LOCAL`. The Dispatcher must schedule based on cost.

### 2.20 Lesson 20: Catalog Ownership Rule (Rule 12)
Dropping catalogs without explicit user authorization was disastrous. The drop logic MUST strictly verify the owner and the trigger phrase.

## 3. 100% PHILOSOPHY AND DESIGN OBJECTIVES
### 3.1 The In-Memory Metamodel
The system maintains an in-memory graph representation of Domains, Products, Attributes, and Foreign Keys. The LLM does not write SQL or edit JSON directly. It acts as an 'Architect' proposing changes via `FindingShapes`.

### 3.2 The Dispatcher Pattern
All changes flow through the `FindingDispatcher`. This class applies the `VibeContract`, computes the `cost_class` of the mutation, and delegates to deterministic executors (`_local_action_executor`, `_cascade_product_rename`, etc.).

### 3.3 Continuous Validation
Instead of `generate -> validate`, the system uses `propose -> evaluate -> execute -> validate`. Every mutation immediately triggers a fast structural validation (DFS, Null-FK check) before committing the transaction.

### 3.4 Idempotent Artifact Generation
Artifact generation (DBML, DDL, JSON, Markdown) is entirely deterministic and stateless. Given a Metamodel Graph, generation can be re-run safely at any time.

## 4. 100% OF THE DESIGN STEPS (The Agentic Loop)
The legacy linear pipeline is replaced with an iterative state machine comprising 7 core phases.

### Phase 1: Context Ingestion & Vibe Extraction
- **Requires:** User inputs (`model_vibes`, `business_domains`, etc.).
- **Does:** `VibeOrchestrator` parses all inputs. Generates the `VibeContract` which extracts rigid constraints (e.g., 'HARD exactly 5 domains').
- **Produces:** `VibeContract`, `BusinessContext`.

### Phase 2: Skeleton Discovery & Generation
- **Requires:** `VibeContract`, `BusinessContext`.
- **Does:** LLM proposes initial Domains and Products. Agent runs `run_global_product_semantic_dedup` to collapse overlapping entities into the `shared` domain (SSOT enforcement).
- **Produces:** Unpopulated Domains and Products (The Skeleton).

### Phase 3: Attribute Expansion & Pre-Normalization
- **Requires:** The Skeleton.
- **Does:** Populates the skeleton with attributes via parallel LLM calls. Immediately executes `run_normalization_integrity_check_parallel` to deterministically strip denormalized natural keys and format columns via `NamingConvention`.
- **Produces:** Populated but Unlinked Entities.

### Phase 4: Deterministic Graph Linking
- **Requires:** Populated Entities.
- **Does:** Runs `_run_deterministic_fk_linking_file_based` to match PK suffixes. Ambiguous links fall back to `run_batch_semantic_fk_resolution`. Identifies Many-to-Many correlations and creates Association tables.
- **Produces:** Initial Logical Graph.

### Phase 5: The Agentic Critique & Refine Loop
- **Requires:** Logical Graph.
- **Does:** This is the core engine. 
  1. **Analyze:** Python runs DFS cycle detection, silo detection, bidirectional detection.
  2. **Critique:** LLM Principal Architect evaluates business logic.
  3. **Plan:** Issues become `FindingShapes` sent to the `FindingDispatcher`.
  4. **Execute:** Safe `cost_class` operations are autofixed. Complex operations require targeted LLM retries.
  5. **Repeat:** Until 0 structural errors and 0 MUST_FIX findings exist.
- **Produces:** 100% Validated Logical Graph.

### Phase 6: Physical Translation & Artifact Generation
- **Requires:** Validated Logical Graph.
- **Does:** Generates DDL (`execute_ddl_statements`), Semantic Metric Views (`step_generate_kpi_first_metric_views`), DBML, Ontology, Data Dictionary, and populates tables with Faker sample data.
- **Produces:** Physical Unity Catalog objects, JSON/MD artifacts.

### Phase 7: Observability & Finalization
- **Requires:** Physical State.
- **Does:** Runs `step_install_parity_audit` to ensure physical tables match JSON byte-for-byte. Emits `ObservationsLogger` data. Compiles `next_vibes.txt` for future tracking.
- **Produces:** Final Audit Reports, Honesty Score.

## 5. 100% OF THE QUALITY GATES
1. **Vibe Supremacy Gate:** The `FindingDispatcher` strictly denies any mutation to `protected_targets_from_widgets` unless the `provenance` is explicitly `PROVENANCE_USER_VIBE`.
2. **Graph Integrity Gate:** `_detect_cycles_dfs` and `_detect_direct_bidirectional_links` must evaluate to absolute zero before Phase 6 begins.
3. **Silo Gate:** `_get_siloed_products_list` must be empty. Every table must participate in the relational model.
4. **Normalization & SSOT Gate:** Fidelity Precision must exceed 0.85. No two entities across different domains can share the same semantic name unless they are explicitly merged to a `shared` domain.
5. **Semantic Correctness Gate:** Validated by `run_fk_semantic_correctness_gate`. Foreign keys must map business relationships correctly (e.g. OrderItem -> Order, not Order -> OrderItem).
6. **Physical Parity Gate:** `step_install_parity_audit` guarantees that `information_schema.tables` output exactly matches the `model.json` declarations.

## 6. EXHAUSTIVE COMPONENT MAPPING & REFACTORING PLAN (Every Class and Function)
To ensure a 100% complete rewrite without losing a single drop of business logic, rule adherence, or logging fidelity, we have mapped every single node from the 88k line legacy codebase to its purpose in the new Agentic Architecture.

### `Class: AIAgent`
- **Lines of Legacy Code:** 35
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: AIAgentManager`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: CatalogResolver`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: FKResolver`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: FindingDispatcher`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** finding-dispatcher"""
- **Legacy Documentation:**
```text
Single entry point for all 4 review stages (architect / quality_gate /
static_analysis-driven / next_vibes). Each stage submits FindingShape dicts;
the dispatcher decides apply-now vs defer-to-next_vibes based on:
  (a) provenance vs protected_targets (§3b/§3c authority gate — non-user_vibe
      findings touching user-protected entities are HARD-DEFERRED),
  (b) cost_class of the proposed_action in the current model context,
  (c) the stage's safe_cost_classes,
  (d) conflict detection across the batch (different actions on the same
      scope_target),
  (e) severity-aware apply ORDER: MUST_FIX runs before SHOULD_FIX before
      NICE_TO_HAVE; within severity, lowest cost first.

protected_targets is a set of target strings (e.g. domain names from the
business_domains widget, must_have_data_products names) that ONLY user_vibe
findings can touch — this enforces §3b/§3c invariants at the dispatcher level
so no architect/SA/QA proposal can silently overwrite user directives.
alias=finding-dispatcher
```

### `Class: GlobalConcurrencyManager`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Singleton manager for enforcing global concurrency limits across all parallel operations.
Ensures no nested ThreadPoolExecutors and all operations respect max_batches.
Provides performance metrics and timing statistics.
Includes nested ThreadPool detection via ThreadPoolGuard integration.
```

### `Class: HeartbeatWatchdog`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
emits periodic status updates during long-running phases.
Use as: hb = HeartbeatWatchdog(vw, stage="IDL", interval_s=60); hb.start(); ...; hb.stop()
Safe on exceptions: always call stop() in a finally block.
```

### `Class: ImmediateFlushFileHandler`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: InfoFilter`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: JobLauncher`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Self-contained, portable Databricks Job Launcher.

Creates and immediately runs a one-time Databricks notebook job, passing
widget values as base_parameters and attaching tags to the job definition.

Args:
    notebook_path:      Full workspace path to the notebook to run.
    widget_key_values:  dict  {widget_name: value} passed as notebook parameters.
    job_tags:           dict  {tag_key: tag_value} attached to the job.
```

### `Class: MetricViewOwnershipError`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Raised when a metric-view record has malformed/invalid ownership.

we REFUSE to fall back to an `_unassigned` bucket. Every
metric view MUST have a resolvable owner_domain at creation time.
```

### `Class: ModelBundle`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: NamingConvention`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
single source of truth for ALL naming + formatting conventions.

Every site that constructs a PK name, FK name, table name, schema name, catalog name,
tag key, metric view name, or that formats a boolean/date/timestamp value MUST go
through this class. Direct string concatenation with widget values elsewhere is a
DRY violation.

Existing helpers (`build_pk_name`, `apply_convention`, `get_pk_suffix`, `get_fk_suffix`,
`_apply_catalog_affixes`) are used internally — this class does NOT duplicate them,
it COMPOSES them through a unified rule set.

Production bug that motivated this class:
  `t01_new_base__fulfillment_zone.ordermanagement.order` had PK `OrderIdentifier`
  but FKs `Account_identifier`, `Address_identifier` — the SAME widget
  `primary_key_suffix="Identifier"` was being applied DIFFERENTLY by PK vs FK code
  paths. This class enforces byte-identical PK/FK column names for the same
  (entity, convention, suffix) tuple.
```

### `Class: NestedThreadPoolError`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Raised when a ThreadPoolExecutor is created inside an existing thread pool worker.
```

### `Class: NextVibesIssueCollector`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: ObservationsLogger`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Thread-safe logger for honesty scores and justifications.
Writes to a local CSV file immediately (no buffering) and uploads to DBFS on finalize.
```

### `Class: SmartWorkerValidator`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-008, ATT-RUL-017, ATT-RUL-051, DOM-RUL-002, DOM-RUL-015, DOM-RUL-016, DOM-RUL-028, G06-R020, G07-R007, G11-R014, PRD-RUL-004, PRD-RUL-011
- **Legacy Documentation:**
```text
# Rules: DOM-RUL-028 through G11-R014, DOM-RUL-002, PRD-RUL-004, ATT-RUL-008, DOM-RUL-016 through ATT-RUL-017, ATT-RUL-051, DOM-RUL-015, G06-R020, G07-R007, PRD-RUL-011
Code-based validation for Smart Worker outputs.
Extracts validation rules from prompt constraints and enforces them via Python code
BEFORE accepting LLM output. This ensures deterministic validation without relying
on the LLM to self-validate.
```

### `Class: ThreadPoolGuard`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Context manager and decorator to detect and prevent nested ThreadPoolExecutor usage.
Uses thread-local storage to track when code is running inside a ThreadPool worker.
```

### `Class: VibeContract`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: VibeManifest`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: VibeOrchestrator`
- **Lines of Legacy Code:** 33
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: VibeRequirement`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: VibeVerificationClause`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: VibeWriter`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _2r_generate_attrs_for_stub`
- **Lines of Legacy Code:** 477
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** cycle-breaker-deterministic-pass2

### `Class: _Ctx`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _DBUtilsShim`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _FallbackLogger`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _InstallMetricLogger`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _MemoryGuard`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _MiniDiskCache`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _SinkLogger`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _SinkLogger`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _SinkLogger`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _SinkLogger`
- **Lines of Legacy Code:** 2
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _SinkLogger`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _SinkLogger`
- **Lines of Legacy Code:** 2
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Class: _SinkLogger`
- **Lines of Legacy Code:** 2
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __enter__`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __enter__`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __exit__`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __exit__`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __getattr__`
- **Lines of Legacy Code:** 405
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fidelity-bypass-widget-live)")

### `Function: __init__`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 47
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** perf-llm-throttle-16, perf-llm-throttle-16")

### `Function: __init__`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __init__`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: __new__`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _accumulate_finding`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _action_scope_hints`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _add_pfx`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _add_pii_tags`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** sa-autofix-pii_tagging_missing, sa-autofix-pii_tagging_missing")
- **Legacy Documentation:**
```text
[sa-autofix-pii_tagging_missing FIRED]
Add pii_<subtype> tag to person-data attributes that match _V074_PII_NAME_PATTERN
AND are NOT in the false-positive guard list AND are NOT primary keys.
Industry-agnostic — pattern detects human attributes (name/email/phone/...) generically.
```

### `Function: _add_sfx`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _add_tag`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _add_tag`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _all_refs_valid`
- **Lines of Legacy Code:** 101
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** surgical-mv-preserve, surgical-mv-preserve"

### `Function: _apply_affixes`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _apply_architect_essential_links`
- **Lines of Legacy Code:** 41
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Apply architect-proposed essential FK links after attribute generation.

step_architect_review stashes validated-against-products links in
widgets_values['_architect_essential_links']. This function consumes them
now that widgets_values['attributes'] is populated.
```

### `Function: _apply_case_convention`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _apply_case_convention`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _apply_case_to_fk_path`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _apply_catalog_affixes`
- **Lines of Legacy Code:** 340
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** vibe-attr-cap-override, vibe-attr-cap-override")
- **Prompts Used:** ATTRIBUTE_GENERATE_PROMPT, BUSINESS_CONTEXT_PROMPT, DOMAIN_ARCHITECT_REVIEW_PROMPT, DOMAIN_GENERATE_PROMPT, FK_AMBIGUOUS_RESOLVE_PROMPT, FK_ANOMALY_DETECT_PROMPT, FK_COLUMN_RENAME_PROMPT, FK_CROSS_DOMAIN_MESH_PROMPT, FK_FIND_MISSING_PROMPT, FK_IN_DOMAIN_LINK_PROMPT, MODEL_ARCHITECT_REVIEW_PROMPT, MODEL_GENERATION_PARAMETER_PROMPT, PRODUCT_DUPLICATE_DETECT_PROMPT, PRODUCT_GENERATE_PROMPT, PRODUCT_GLOBAL_DEDUP_PROMPT, QUALITY_DOMAIN_FIT_PROMPT, QUALITY_NORMALIZATION_PROMPT, SAMPLE_POOL_PROMPT, VIBE_CREATE_NEXT_PROMPT

### `Function: _apply_contradiction_penalty`
- **Lines of Legacy Code:** 35
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _apply_fks_for_table`
- **Lines of Legacy Code:** 110
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _apply_industry_tier_overrides_from_tiers`
- **Lines of Legacy Code:** 51
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _apply_llm_decisions`
- **Lines of Legacy Code:** 137
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _apply_name_transform`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _apply_resolutions_thread_safe`
- **Lines of Legacy Code:** 88
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Thread-safe helper to apply LLM resolutions to attributes.
```

### `Function: _apply_single_domain_review_to_model`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Apply ONE domain architect review response to ``products_data`` in-place.

Extracted from the previously-inline outer loop in step_domain_architect_review so
the caller can run this review → apply → review cycle iteratively.

All 9 apply branches (rename, remove, description update, add, merge, split,
in_domain_links, next_vibes, gate_failures) are handled here.

Thread-safety note: each per-domain worker only touches products in its own
domain, and the in-memory mutations commute across domains, so calling this
function sequentially after each parallel-LLM batch is safe.

Returns a tuple ``(all_gates_passed: bool, iteration_record: dict)`` where
``iteration_record`` is the dict consumed by ``_render_previous_reviews_context``
on the next iteration.
```

### `Function: _apply_suffix_convention`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _apply_tag_transform`
- **Lines of Legacy Code:** 44
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _apply_to_matching_attrs`
- **Lines of Legacy Code:** 69
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
SINGLE SOURCE OF TRUTH for applying an action to attributes matching a pattern.
Replaces 8+ nearly identical loops in the action execution block.

Args:
    pattern: "domain.product.attribute" pattern with optional wildcards
    apply_fn: function(attr) -> bool, called on each matching attr, returns True if modified
    fuzzy_attr: whether to use fuzzy attribute matching

Returns: count of modified attributes
```

### `Function: _apply_vibe_custom_tags`
- **Lines of Legacy Code:** 171
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** ATTRIBUTE_GENERATE_PROMPT
- **Legacy Documentation:**
```text
Apply custom tags from user vibes to products and attributes.

Scans the raw vibe text for tag instructions like:
- "add tag source_system=SAP to all products in finance domain"
- "tag all products with src_tbl=<original_name>"
- "add tag data_owner=hr to employee product"

This runs AFTER model finalization so all products/attributes exist.
```

### `Function: _apply_widget_override_entries`
- **Lines of Legacy Code:** 52
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _assemble_rows_from_pools`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Build N rows by sampling per-column pools. Returns list of tuples in
stable column order matching fb_col_info.
```

### `Function: _assemble_rows_from_pools`
- **Lines of Legacy Code:** 47
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _assert`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _assert_vibe_version_advances`
- **Lines of Legacy Code:** 45
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _async_flush_wrapper`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _attr_gen_progress`
- **Lines of Legacy Code:** 1158
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _attr_importance`
- **Lines of Legacy Code:** 132
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _attribute_is_pk_or_fk`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Return (is_pk, is_fk_source, is_fk_target). Reads model_state shape:
{'domains': [{'name', 'products': [{'name', 'attributes': [{'name','primary_key','foreign_key_to'}]}]}]}.
Industry-agnostic; pure data inspection.
```

### `Function: _autofix_sanity_check`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Autofixer / Finding Execution
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Synthetic harness for _pre_static_analysis_autofix.

HOW TO INVOKE: either call ``_autofix_sanity_check()`` directly from a
Databricks notebook / vibe_runner (module already imported cleanly), or
from shell with dbutils/spark stubbed:
  python3 -c "import sys; sys.path.insert(0, '/tmp'); \
              exec(open('/tmp/agent_source.py').read().replace( \
                   '__main__', '__autofix_sanity__'))"
Returns True on all-green, False on any failure.
```

### `Function: _batch_insert`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _batch_insert_recovery`
- **Lines of Legacy Code:** 39
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _biz_where`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _break_cycles`
- **Lines of Legacy Code:** 68
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Wrapper for cycle breaking with siloed table validation and retry logic.
Removes FK attributes entirely and validates no siloed tables are created.
A siloed table has no incoming FKs AND no outgoing FKs (completely disconnected).

Returns:
    tuple: (links_broken_count, set of broken_edge_keys)
        broken_edge_keys format: "source_domain.source_product→target_domain.target_product"
```

### `Function: _break_cycles_heuristic_internal`
- **Lines of Legacy Code:** 96
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Deterministic last-resort cycle breaker when LLM fails completely.
Uses multi-signal scoring:
  1. Edge betweenness centrality (graph-theoretic: low betweenness = structurally redundant = safe to break)
  2. Convenience FK prefix (latest_, current_, primary_, etc.)
  3. Cross-domain preference
  4. Target incoming FK resilience
```

### `Function: _break_cycles_internal`
- **Lines of Legacy Code:** 110
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Internal cycle breaking logic. Removes FK attributes entirely (not just clears them).
Supports batching for large cycle sets to avoid context size limits.

Returns:
    tuple: (links_broken, list of removed attribute info dicts)
```

### `Function: _break_cycles_with_retry`
- **Lines of Legacy Code:** 74
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Breaks cycles with siloed table validation and retry logic.

After breaking cycles, checks for siloed tables (no incoming AND no outgoing FKs).
If siloed tables are created, retries with different decisions up to max_retries.

Args:
    cycles: list of cycles from _detect_cycles_dfs
    attributes_data: list of attributes (modified in place)
    products_data: list of products for silo checking
    logger: logger instance
    ai_agent: AI agent instance for LLM calls (optional)
    config: configuration dict (optional)
    business_name: name of the business for context
    industry_alignment: industry context
    max_retries: maximum number of retry attempts

Returns:
    tuple: (links_broken, siloed_tables_created)
```

### `Function: _build_action_vocab_compat`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** V075_RETIRE_V074_VOCAB"""
- **Legacy Documentation:**
```text
Build the shaped vocab dict from MASTER_ACTION_REGISTRY for backward
compatibility only. Code paths must use MASTER_ACTION_REGISTRY +
render_master_action_catalog() instead. alias=V075_RETIRE_V074_VOCAB
```

### `Function: _build_all_fk_links`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_attr_key`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_batch_prompt`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_BROKEN_RESOLVE_PROMPT

### `Function: _build_compact_global_fk_summary`
- **Lines of Legacy Code:** 26
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fk-summary-helper
- **Legacy Documentation:**
```text
[fk-summary-helper FIRED] — Compact FK-only summary so KPI-first
LLM has explicit knowledge of valid joins to propose. Pre-LLM filter
against fabricated joins.
```

### `Function: _build_compact_global_model_summary`
- **Lines of Legacy Code:** 66
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** kpi-first-summary
- **Prompts Used:** KPI_FIRST_GLOBAL_PROMPT
- **Legacy Documentation:**
```text
[kpi-first-summary FIRED] — Build a compact text summary
of the entire data model, suitable for the KPI_FIRST_GLOBAL_PROMPT
LLM context. Output groups products by domain with key columns + FKs.
```

### `Function: _build_compact_model_summary`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_current_vibes_txt`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_cycles_for_llm`
- **Lines of Legacy Code:** 46
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_df_from_pool_spec`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** pool-spec-decimal-coerce-pre-spark)
- **Legacy Documentation:**
```text
Returns a Spark DataFrame built from pool spec, or None on failure.
```

### `Function: _build_domain_key`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_domain_metric_sql_artifacts`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_domain_metric_sql_artifacts_impl`
- **Lines of Legacy Code:** 206
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** mv-compact-context)

### `Function: _build_domain_metric_sql_artifacts_with_llm`
- **Lines of Legacy Code:** 136
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** mv-linked-tables-context)

### `Function: _build_domain_metric_type_matrix_text`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
COMPACT — Type-matrix block reduced to a 1-line ROLE LEGEND.
Per-attribute role tags are now inlined in `_build_domain_metrics_context_text` (single
source of truth — DRY), so duplicating the matrix here would just burn tokens for no
additional information. The legend below tells the LLM how to read the inline tags.
```

### `Function: _build_domain_metrics_context_text`
- **Lines of Legacy Code:** 65
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
COMPACT — Domain own-product columns in 1-line-per-product compact format.
Each product line: `domain.product(PK=pk_col): col1 TYPE!ROLE*, col2 TYPE!ROLE→fk, ...`
Role: N=NUMERIC_ALLOWED, D=DIMENSION_ONLY, T=TIME_DIMENSION_ONLY. PK gets `*` suffix.
Description / Attribute Name / Tags are deliberately DROPPED — column names are
self-documenting under snake_case naming convention. authoritative_columns_by_product
filtering is preserved so renamed/dropped autofix'd columns never reach the LLM.
```

### `Function: _build_domain_products_inventory`
- **Lines of Legacy Code:** 39
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Per-domain product inventory text for domain-architect review. No attributes (review runs pre-attribute-gen).

full description (up to 2000 chars) — the 400-char cap caused
the architect to repeatedly flag "truncated descriptions" as a gate
blocker across ALL domains in , even though the stored
description was intact. Only the architect's view was truncated.
```

### `Function: _build_enrichment_attr_prompt_vars`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_enrichment_attr_prompt_vars_impl`
- **Lines of Legacy Code:** 57
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_enrichment_prompt_vars`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_enrichment_prompt_vars_impl`
- **Lines of Legacy Code:** 50
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_execution_log`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_fallback_chain`
- **Lines of Legacy Code:** 51
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_fallback_col_info`
- **Lines of Legacy Code:** 42
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_filtered_attrs_by_product`
- **Lines of Legacy Code:** 48
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_fk_adjacency`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_fk_collision_name`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_full_attrs_by_product`
- **Lines of Legacy Code:** 26
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_global_inventory`
- **Lines of Legacy Code:** 72
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Return (model_inventory_str, division_breakdown_str, total_domains, total_products)
computed over the CURRENT domains_data / products_data.
```

### `Function: _build_insert_sql`
- **Lines of Legacy Code:** 21
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_link_postprocessor`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Filter LLM link output by structured `decision` field.

Each link entry is expected to carry decision: "INCLUDE" | "EXCLUDE".
Entries with decision == "EXCLUDE" are stripped (audit trail only).
Entries missing decision default to INCLUDE for backward compat - a warning
is logged so we can spot prompts not yet upgraded.
The top-level integer field named by count_field (e.g. links_to_include)
is verified against the INCLUDE count for an early-warning contract check.
NO PROSE PARSING. NO REGEX ON LLM OUTPUT.
```

### `Function: _build_linked_products_compact`
- **Lines of Legacy Code:** 65
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** mv-linked-tables-context)
- **Legacy Documentation:**
```text
LINKED-PRODUCTS (alias=mv-linked-tables-context) — Walk every FK in the current
domain's attributes, collect each unique target (domain.product) ONCE (dedup), and emit
its compact attribute list so the metric-view LLM can build join-aware metrics WITHOUT
hallucinating columns or whole tables (Issue 2.A). Strictly excludes the current domain's
own products (already in domain_metrics_context). Uses `_compact_attr_token` for the same
1-line-per-product format as the main context.
```

### `Function: _build_next_vibe_llm_context`
- **Lines of Legacy Code:** 223
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** VIBE_CREATE_NEXT_PROMPT

### `Function: _build_next_vibes_txt`
- **Lines of Legacy Code:** 132
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** next-vibes-early-removed

### `Function: _build_other_domains_summary_for_domain`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
One-line summary per OTHER domain for domain-architect context. Never modified by the callee.
```

### `Function: _build_product_columns_reference`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
COMPACT — Whitelist of authoritative product names + PKs in this domain. The
full column detail now lives in `domain_metrics_context` (single source of truth). This
block exists ONLY to give the LLM a tight, scannable list to verify `source_product`
against before emitting any metric view (Issue 1.A HARD-CAP-SOURCE-PRODUCT enforcement).
```

### `Function: _build_product_key`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_relevant_products_str`
- **Lines of Legacy Code:** 94
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_scope_data_from_input`
- **Lines of Legacy Code:** 219
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _build_vibe_audit_report_json`
- **Lines of Legacy Code:** 94
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Build the structured JSON sidecar for the audit report.
```

### `Function: _build_vibe_master_schema`
- **Lines of Legacy Code:** 444
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** G14-R011, G14-R012, G14-R013, PRD-RUL-002, REL-RUL-019
- **Prompts Used:** VIBE_AUDIT_PROMPT, VIBE_CREATE_NEXT_PROMPT, VIBE_DROP_PROMPT, VIBE_PARSE_PROMPT

### `Function: _cached_json_load`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _calculate_next_version`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _call_ai_query`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _call_ai_query_impl`
- **Lines of Legacy Code:** 174
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** LLM-JSON-RECOVERABLE, llm-json-recoverable"

### `Function: _call_ai_query_with_override`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _call_llm_for_cycles`
- **Lines of Legacy Code:** 32
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _canonicalise_p074`
- **Lines of Legacy Code:** 282
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** P0.74-COLLISION-STEM, collision-naming-canonical, collision-naming-canonical", ssot-stem-autofix"
- **Prompts Used:** PRODUCT_GENERATE_PROMPT

### `Function: _capture`
- **Lines of Legacy Code:** 117
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _capture_model_invariants`
- **Lines of Legacy Code:** 460
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** kpi-first-wiring, mv-product-dedup-guard-error"), self-ref-fix-empty-val-guard, self-ref-mem-json-sync, self-ref-mem-json-sync"), user-vibe-tag-applier-error"), vibe-audit-sa-extend-call, vibe-audit-stage-call

### `Function: _carry_over_missing_artifacts_from_previous_version`
- **Lines of Legacy Code:** 110
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _cascade_domain_rename`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** orig-name-tag-removed

### `Function: _cascade_product_rename`
- **Lines of Legacy Code:** 32
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** orig-name-tag-removed

### `Function: _cast`
- **Lines of Legacy Code:** 188
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Cast a value to the specified type. Returns (success, value) tuple.
```

### `Function: _cast_token`
- **Lines of Legacy Code:** 32
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** Metrics][Sanitizer] [mv-measure-agg-wrap, mv-measure-agg-wrap")

### `Function: _check`
- **Lines of Legacy Code:** 50
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _check`
- **Lines of Legacy Code:** 76
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _check_attribute_table_for_siloed_tables`
- **Lines of Legacy Code:** 91
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Checks the attribute table for siloed products (tables with NO incoming AND NO outgoing FKs).
A siloed table is completely disconnected from the relational graph.
[FIXED]: This function now contains a more robust SQL query.
```

### `Function: _check_fk_type_compatibility`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** ATT-RUL-005, REL-RUL-003

### `Function: _check_physical_deployment_clash`
- **Lines of Legacy Code:** 277
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _check_postprocess_gate`
- **Lines of Legacy Code:** 36
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _check_siloed_tables_after_cycle_break`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Check for siloed tables (tables with NO incoming AND NO outgoing FK references).
Returns list of siloed product keys.
```

### `Function: _chunk_validate_response`
- **Lines of Legacy Code:** 406
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_IN_DOMAIN_LINK_PROMPT

### `Function: _ci_find`
- **Lines of Legacy Code:** 106
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Case-insensitive column lookup with underscore-stripped fallback for camelCase↔snake_case.
```

### `Function: _clamp_and_validate_model_params`
- **Lines of Legacy Code:** 45
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _classify_recipe_cost`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** recipe-cost-classifier
- **Legacy Documentation:**
```text
[recipe-cost-classifier FIRED alias=recipe-cost-classifier] —
Multi-step recipe inherits its WORST-case cost (most conservative gate).
A recipe with one LOCAL + one FK_REWIRE step is FK_REWIRE overall, so the
static-analysis autofix dispatcher correctly defers it from a stage that
only allows LOCAL changes.
```

### `Function: _clean_csv_response`
- **Lines of Legacy Code:** 47
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Cleans LLM response to extract pure CSV content.
Removes markdown code fences, explanatory text, etc.
```

### `Function: _cleanup_delete`
- **Lines of Legacy Code:** 47
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _cleanup_empty_domains`
- **Lines of Legacy Code:** 32
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _cleanup_phantom_domains`
- **Lines of Legacy Code:** 27
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Remove domains with placeholder/phantom names that aren't real business domains.
```

### `Function: _clear`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _cn`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _coerce_decimal_to_float`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _coerce_dict`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Safely coerce to dict. Returns {} for non-dict (e.g. when LLM returns list/str instead of dict).
```

### `Function: _coerce_int`
- **Lines of Legacy Code:** 143
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** ATTRIBUTE_GENERATE_PROMPT, DOMAIN_GENERATE_PROMPT, FK_CROSS_DOMAIN_MESH_PROMPT, FK_IN_DOMAIN_LINK_PROMPT, MODEL_ARCHITECT_REVIEW_PROMPT, PRODUCT_GENERATE_PROMPT, PRODUCT_GLOBAL_DEDUP_PROMPT, QUALITY_NORMALIZATION_PROMPT, TAG_CLASSIFY_PROMPT

### `Function: _coerce_list_of_dicts`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Filter non-dict items from a list. Safe for iterating LLM response arrays.
```

### `Function: _coerce_num`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _coerce_num`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _coerce_override_value`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _col_has_role_prefix`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _col_type_is_integer_for_self_ref`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _compact_attr_token`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Render ONE attribute as a single compact token: `col_name TYPE!ROLE` or
`col_name TYPE!ROLE→fk_target` if FK is set. PK is suffixed `*` (e.g. `pax_id BIGINT!D*`).
Description, attribute_name, tags are deliberately DROPPED — column names are
self-documenting per snake_case naming convention. Returns None when the attribute has no
column name.
```

### `Function: _compact_role_for_type`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Return single-char role tag: N=numeric_allowed, T=time_dimension_only, D=dimension_only.
Single source of truth used by both the per-domain compact context and the linked-products
section. Mirrors the legacy NUMERIC_ALLOWED / TIME_DIMENSION_ONLY / DIMENSION_ONLY taxonomy.
```

### `Function: _compose`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
The sole name-composition primitive. Every public method routes through here.

Rules (uniform across PK, FK, table, schema, etc.):
  1. Each part is sanitised via sanitize_name first (ASCII-safe).
  2. All parts joined with `_` internally.
  3. The full joined name + suffix is routed through apply_convention(case).
  4. The suffix is lowercased for snake_case / uppercased for SCREAMING_CASE.
     For camelCase/PascalCase the suffix's first letter is capitalised so a
     widget value of "Identifier" stays "Identifier" (the production bug).
  5. Separator between body and suffix: `_` for snake_case/SCREAMING_CASE;
     no separator for camelCase/PascalCase (suffix appended directly).
```

### `Function: _compute`
- **Lines of Legacy Code:** 34
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _compute`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _compute`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _compute`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _compute`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _compute`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _compute`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _compute`
- **Lines of Legacy Code:** 63
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** ATTRIBUTE_GENERATE_PROMPT, BUSINESS_CONTEXT_PROMPT, DOMAIN_ARCHITECT_REVIEW_PROMPT, DOMAIN_GENERATE_PROMPT, DOMAIN_JUDGE_PROMPT, DOMAIN_METRICS_PROMPT, FK_ANOMALY_DETECT_PROMPT, FK_BATCH_RESOLVE_PROMPT, FK_BROKEN_RESOLVE_PROMPT, FK_CROSS_DOMAIN_MESH_PROMPT, FK_CYCLE_BREAK_PROMPT, FK_FIND_MISSING_PROMPT, FK_IN_DOMAIN_LINK_PROMPT, FK_MANY_TO_MANY_PROMPT, FK_PAIRWISE_LINK_PROMPT, MODEL_ARCHITECT_REVIEW_PROMPT, MODEL_GENERATION_PARAMETER_PROMPT, PRODUCT_GENERATE_PROMPT, PRODUCT_GLOBAL_DEDUP_PROMPT, PRODUCT_MERGE_SIMILAR_PROMPT, QUALITY_DOMAIN_FIT_PROMPT, QUALITY_NORMALIZATION_PROMPT, RESIZE_ENLARGE_DOMAIN_PROMPT, RESIZE_SHRINK_DOMAIN_PROMPT, SAMPLE_POOL_PROMPT, SUBDOMAIN_ALLOCATE_PROMPT, TAG_CLASSIFY_PROMPT

### `Function: _compute`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _compute_deterministic_confidence_and_status`
- **Lines of Legacy Code:** 579
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** master-action-catalog-prompt-inject, next-vibes-dispatcher, vibe-audit-actionable-extend
- **Prompts Used:** VIBE_CREATE_NEXT_PROMPT

### `Function: _compute_edge_betweenness_for_cycles`
- **Lines of Legacy Code:** 65
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Approximate edge betweenness centrality for the FK graph.
Edges with LOW betweenness are structurally redundant (safe to break).
Edges with HIGH betweenness are structurally critical (protect them).
Uses BFS from each node to count how many shortest paths traverse each edge.
```

### `Function: _compute_max_concurrent_batches_for_32gb`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** perf-cap-16, perf-cap-16"), perf-cap-16-emit
- **Legacy Documentation:**
```text
Compute MAX_CONCURRENT_BATCHES for 32GB RAM environments (Phase L3).
(alias: perf-cap-16) — lifted cap from 8 to 16 to halve Step 4
attribute generation, MV15 semantic gate, normalization, and all other
parallel pools that key off MAX_CONCURRENT_BATCHES. Validated safe under
Databricks Serverless 32GB working set: 16 concurrent LLM bodies + JSON
response heap stays well under 12GB observed in telecom MVM at 8.
```

### `Function: _constraints_to_forbidden_ops`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _consume_pending_events_stream`
- **Lines of Legacy Code:** 26
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _convention_name`
- **Lines of Legacy Code:** 63
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Apply configured naming convention to a data asset name (DDL fallback).
```

### `Function: _convert_priority_to_action`
- **Lines of Legacy Code:** 54
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _convert_to_dicts`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Convert to list of dicts (data is always plain Python dicts).
```

### `Function: _copy_single_file`
- **Lines of Legacy Code:** 213
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** install-parity-audit-call

### `Function: _count_metric_aggregate_calls`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _create_association_product_and_attrs`
- **Lines of Legacy Code:** 33
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-056, PRD-RUL-014, PRD-RUL-037
- **Legacy Documentation:**
```text
[PRD-RUL-037, ATT-RUL-056, PRD-RUL-014]
SINGLE SOURCE OF TRUTH for creating an association product with its PK, FKs, and attributes.
Extracted from _process_many_to_many_relationships to reduce its size.

Returns: True if created successfully
```

### `Function: _create_metrics_database_if_needed`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _create_missing_parent_tables_for_unlinked_fks`
- **Lines of Legacy Code:** 382
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-048, REL-RUL-019
- **Legacy Documentation:**
```text
# REL-RUL-019, ATT-RUL-048

FINAL SAFETY NET for unlinked _id FK columns. DOES NOT blindly create tables.

Strategy (in order):
  1. Skip columns that are actually PKs (via pk_map — catches missing is_primary_key flags)
  2. Skip system/external identifiers that are NOT real FK references
  3. Try ends-with PK matching one final time (catches late additions)
  4. Link qualified self-references (parent_, duplicate_of_, etc.)
  5. Try fuzzy product name matching for existing tables
  6. ONLY create a new table if:
     a) Multiple columns (>=2) from DIFFERENT source tables reference the same missing entity
     b) OR the base name exactly matches a well-known business entity pattern
     c) AND the table doesn't already exist (no duplicates)
     d) AND the created table gets proper attributes (not empty — at minimum PK + name + description)
  7. Columns that don't meet criteria are left unlinked (the FK was likely hallucinated)
```

### `Function: _create_new_fk_attribute`
- **Lines of Legacy Code:** 129
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Create a new FK attribute OR update an existing column with FK info.

IMPORTANT: This function first checks if a column with the same column_name already exists.
If it does, it UPDATES that existing attribute with FK info instead of creating a duplicate.
This prevents the "column not found" error when FK constraints are applied, because
during deduplication, the first occurrence is kept - if we create a duplicate, the new
FK version gets discarded while the old non-FK version is kept.

Args:
    source_domain: Domain of the source product
    source_product: Product that will contain the new FK
    fk_attr_name: Name of the new FK attribute (e.g., 'account_id')
    fk_target: Full FK target path (e.g., 'customer.account.account_id')
    target_pk_type: Data type of the target PK (e.g., 'BIGINT')
    attributes_data: List of all attributes (will be modified in place)
    config: Configuration dict with business info
    reasoning: LLM's business justification for the relationship
    logger: Logger instance
    
Returns:
    dict: The newly created or updated attribute, or None if creation failed
```

### `Function: _create_standalone_vibe_writer`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _create_table_if_not_exists`
- **Lines of Legacy Code:** 61
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _cv_count_query`
- **Lines of Legacy Code:** 92
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _date_sub_repl`
- **Lines of Legacy Code:** 84
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** Metrics][Sanitizer] [mv-date-interval-autofix, mv-date-interval-autofix")

### `Function: _db_progress`
- **Lines of Legacy Code:** 87
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _dbml_type`
- **Lines of Legacy Code:** 41
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _decision_of`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _decision_of`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _dedup_mv_as_product_artifacts`
- **Lines of Legacy Code:** 92
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** mv-product-dedup-guard, mv-product-dedup-guard", mv-product-dedup-guard"), mv-product-dedup-guard)
- **Legacy Documentation:**
```text
[mv-product-dedup-guard FIRED] (alias=mv-product-dedup-guard)

Removes "products" that are duplicates of metric views.

The LLM in step_create_logical_schema sometimes creates a physical "table" 
product for each metric view name from the user vibe (e.g. vacancy_rate_mv, 
retirement_eligibility_mv, total_positions_active_employees_mv). These 
duplicate the metric_view definitions and pollute the physical schema with 
redundant "MV-as-product" tables.

Detection: a product is removed if its snake_case name (after stripping 
optional `_mv` / `_metric_view` suffix and optional domain prefix) matches 
any metric_view name (also normalized). This is a STRUCTURAL match — never 
a substring heuristic.

DRY: extends the existing widgets_values["products"] / ["_metric_view_records"]
pipeline; no new data structures introduced. Per CLAUDE.md §3c the user vibe 
is supreme — if the user explicitly wants a separate physical table for MV 
backing, they can name it differently (no `_mv` suffix and no name collision 
with the MV).
```

### `Function: _deep_parse_json_values`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
(Helper) Parses known stringified keys ('attributes', 'domains') within a data object.
Operates on the dictionary, not the JSON string.
```

### `Function: _default_by_type`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Deterministic stdlib fallback when the LLM did not describe a column
(e.g. the JSON was missing it). Uses only random / datetime.
```

### `Function: _default_mutation_budget`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _del_ver_table`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _delete_incomplete_version`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Delete an incomplete version to allow override (PARALLEL).
```

### `Function: _demote_model_order`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _demote_unlinked_fk_attr_to_external_code`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _deploy_warn`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _derive_model_folder`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _derive_scope_defaults_and_guardrails`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _detect_compute_type`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Detect whether the current notebook runs on serverless or classic
compute.

Returns:
    (is_serverless: bool, cluster_id: str | None)
```

### `Function: _detect_conflicts`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _detect_cycles_dfs`
- **Lines of Legacy Code:** 64
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Python-based cycle detection using DFS (Depth-First Search).
Builds a directed graph from FK relationships and detects cycles using Tarjan's-like approach.

IMPORTANT: This function also calls _detect_direct_bidirectional_links to catch the most basic cycles.

Args:
    products_data: list of product dicts
    attributes_data: list of attribute dicts with foreign_key_to field
    logger: logger instance

Returns:
    list: List of detected cycles, each cycle is a list of (source, target) tuples
          Bidirectional links are converted to 2-edge cycles and added first (highest priority)
```

### `Function: _detect_direct_bidirectional_links`
- **Lines of Legacy Code:** 79
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** bidirectional-pointer-auto-resolve)
- **Legacy Documentation:**
```text
Detect direct bidirectional links (A ↔ B) which are the most basic form of cycles.
These are cases where Table A has FK to Table B AND Table B has FK to Table A.

These MUST be eliminated as they create immediate cycles and indicate modeling errors.

Returns:
    list: List of bidirectional link pairs, each is a dict with:
        - a_to_b: {source, target, attribute} info for A→B link
        - b_to_a: {source, target, attribute} info for B→A link
```

### `Function: _detect_post_shrink_silos`
- **Lines of Legacy Code:** 41
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _detect_redundant_columns_deterministic`
- **Lines of Legacy Code:** 62
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Deterministically detect redundant columns in source table that duplicate data from target table.

This function looks for columns in the source table that:
1. Have names containing the target table name prefix (e.g., customer_name, customer_email when FK is customer_id)
2. Match column names in the target table (e.g., source has 'name' and target has 'name')

Args:
    source_domain: Domain of the source table (with the FK)
    source_product: Product name of the source table
    fk_attr_name: The FK column name (e.g., customer_id)
    target_domain: Domain of the target table
    target_product: Product name of the target table
    attributes_data: List of all attributes
    logger: Logger instance
    
Returns:
    list: List of column names in source table that are likely redundant
```

### `Function: _detect_required_product_prefix`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _detect_user_vibes`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _determine_model_parameters`
- **Lines of Legacy Code:** 122
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** MODEL_GENERATION_PARAMETER_PROMPT

### `Function: _df_from_sample_csv`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Parses a CSV string into a Spark DataFrame with proper casting.

Args:
    csv_str: The CSV string to parse
    attr_types: Dict mapping column_name to data type
    column_name_mapping: Dict mapping various possible column names to canonical column_name
```

### `Function: _dfs_cycle`
- **Lines of Legacy Code:** 1219
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** domain-dominance-cap-scale-by-count, fk-density-upper-bound, pii-static-align-with-autofix, pii-static-align-with-autofix"), prefix-static-skip-reserved, prefix-static-skip-reserved"), sa-active-autofix-summary, sa-autofix-{category}, step-sa-active-autofix

### `Function: _dfs_find_cycles_iterative`
- **Lines of Legacy Code:** 160
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _disk_cached_call`
- **Lines of Legacy Code:** 30
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _dispatch_generic_action`
- **Lines of Legacy Code:** 83
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _division_sort_key`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _does_not_end_with_pk_suffix`
- **Lines of Legacy Code:** 609
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_BATCH_RESOLVE_PROMPT
- **Legacy Documentation:**
```text
Catch columns that don't end with the PK suffix (Rule 10).
```

### `Function: _domain_convention`
- **Lines of Legacy Code:** 33
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _domain_count`
- **Lines of Legacy Code:** 186
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _domain_has_inbound_cross_fk`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** cost-cross-fk-domain"""
- **Legacy Documentation:**
```text
Return True if any attribute in a DIFFERENT domain has a foreign_key_to whose
first segment is {target_domain}. Read-only; industry-agnostic.
alias=cost-cross-fk-domain
```

### `Function: _domain_sim`
- **Lines of Legacy Code:** 87
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _drop_denormalized_natural_keys`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** sa-autofix-denormalized_natural_key, sa-autofix-denormalized_natural_key")
- **Legacy Documentation:**
```text
[sa-autofix-denormalized_natural_key FIRED]
When a product has BOTH `<X>_id` (with FK) AND `<X>_code|_number|_no|_key`
(no FK) referencing the same business entity, drop the redundant natural-key
column. Industry-agnostic — operates purely on naming patterns + FK presence.
```

### `Function: _early_clash_detection`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** vov-metrics-teardown, vov-metrics-teardown")

### `Function: _eff_tag`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _emit_finding`
- **Lines of Legacy Code:** 32
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** emit-finding-helper, emit-finding-helper"""
- **Legacy Documentation:**
```text
[emit-finding-helper FIRED alias=emit-finding-helper] thin
adapter that builds a FindingShape and submits it to the dispatcher (no-op when
dispatcher is None — preserves existing call sites that don't yet construct a
dispatcher). Used by domain architect / VIBE_AUDIT remediate / VIBE_CREATE_NEXT
emit-site migrations to ADD dispatcher observability without altering existing
behaviour. Industry-agnostic; safe-by-default. alias=emit-finding-helper
```

### `Function: _emit_run_summary_query_tag`
- **Lines of Legacy Code:** 64
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _enforce_m2m_ratio`
- **Lines of Legacy Code:** 9442
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-001, ATT-RUL-002, ATT-RUL-004, ATT-RUL-006, ATT-RUL-007, ATT-RUL-008, ATT-RUL-009, ATT-RUL-012, ATT-RUL-013, ATT-RUL-014, ATT-RUL-015, ATT-RUL-016, ATT-RUL-017, ATT-RUL-018, ATT-RUL-019, ATT-RUL-020, ATT-RUL-021, ATT-RUL-022, ATT-RUL-023, ATT-RUL-024, ATT-RUL-025, ATT-RUL-027, ATT-RUL-029, ATT-RUL-032, ATT-RUL-034, ATT-RUL-036, ATT-RUL-038, ATT-RUL-040, ATT-RUL-042, ATT-RUL-043, ATT-RUL-044, ATT-RUL-045, ATT-RUL-050, ATT-RUL-052, ATT-RUL-056, DOM-RUL-001, DOM-RUL-002, DOM-RUL-004, DOM-RUL-008, DOM-RUL-009, DOM-RUL-010, DOM-RUL-011, DOM-RUL-012, DOM-RUL-013, DOM-RUL-014, DOM-RUL-016, DOM-RUL-017, DOM-RUL-018, DOM-RUL-023, DOM-RUL-028, DOM-RUL-030, G08-R011, G08-R012, G11-R010, G11-R011, G11-R012, G11-R017, G13-R009, GEN-RUL-003, GEN-RUL-005, PRD-RUL-001, PRD-RUL-002, PRD-RUL-003, PRD-RUL-004, PRD-RUL-005, PRD-RUL-006, PRD-RUL-007, PRD-RUL-008, PRD-RUL-009, PRD-RUL-010, PRD-RUL-012, PRD-RUL-013, PRD-RUL-014, PRD-RUL-015, PRD-RUL-016, PRD-RUL-017, PRD-RUL-018, PRD-RUL-019, PRD-RUL-020, PRD-RUL-024, PRD-RUL-027, PRD-RUL-029, PRD-RUL-030, PRD-RUL-033, PRD-RUL-034, PRD-RUL-035, PRD-RUL-036, PRD-RUL-037, PRD-RUL-038, PRD-RUL-040, PRD-RUL-042, PRD-RUL-044, PRD-RUL-045, REL-RUL-001, REL-RUL-002, REL-RUL-004, REL-RUL-006, REL-RUL-007, REL-RUL-008, REL-RUL-009, REL-RUL-010, REL-RUL-012, REL-RUL-013, REL-RUL-014, REL-RUL-017, REL-RUL-018, REL-RUL-019, REL-RUL-020, REL-RUL-021, REL-RUL-022, REL-RUL-023, REL-RUL-024, REL-RUL-025, REL-RUL-026
- **Observability Aliases (Must be preserved):** fk-cardinality-correctness):**, fk-temporal-precedence):**, junction-purity):**, mv-no-phantom-source):**, mv-prompt-joins-enabled)
- **Prompts Used:** ATTRIBUTE_DEDUP_PROMPT, ATTRIBUTE_GENERATE_PROMPT, BUSINESS_CONTEXT_PROMPT, DOMAIN_ARCHITECT_REVIEW_PROMPT, DOMAIN_GENERATE_PROMPT, DOMAIN_JUDGE_PROMPT, DOMAIN_METRICS_PROMPT, FK_AMBIGUOUS_RESOLVE_PROMPT, FK_ANOMALY_DETECT_PROMPT, FK_BATCH_RESOLVE_PROMPT, FK_BROKEN_RESOLVE_PROMPT, FK_COLUMN_RENAME_PROMPT, FK_CROSS_DOMAIN_MESH_PROMPT, FK_CYCLE_BREAK_PROMPT, FK_EDGE_SYNTHESIS_PROMPT, FK_FIND_MISSING_PROMPT, FK_IN_DOMAIN_LINK_PROMPT, FK_MANY_TO_MANY_PROMPT, FK_PAIRWISE_LINK_PROMPT, FK_SEMANTIC_CORRECTNESS_GATE_PROMPT, IMPORT_CSV_PROMPT, KPI_FIRST_GLOBAL_PROMPT, LLM_FALLBACK_CLASSIFY_PROMPT, LLM_FALLBACK_EXECUTE_PROMPT, LLM_FALLBACK_QUERY_PROMPT, MODEL_ARCHITECT_REVIEW_PROMPT, MODEL_GENERATION_PARAMETER_PROMPT, M_PROMPT, NF_PROMPT, PROCESS_FLOW_FK_GATE_PROMPT, PRODUCT_DUPLICATE_DETECT_PROMPT, PRODUCT_GENERATE_PROMPT, PRODUCT_GLOBAL_DEDUP_PROMPT, PRODUCT_IDENTIFY_CORE_PROMPT, PRODUCT_MERGE_SIMILAR_PROMPT, PRODUCT_MERGE_SMALL_PROMPT, QA_DENORMALIZE_PROMPT, QA_ESTIMATE_ROWS_PROMPT, QA_GENERATE_DESCRIPTIONS_PROMPT, QA_INDUSTRY_TEMPLATE_PROMPT, QA_REVERSE_ENGINEER_PROMPT, QA_SUGGEST_ATTRS_PROMPT, QA_SUGGEST_TABLES_PROMPT, QUALITY_DOMAIN_FIT_PROMPT, QUALITY_NORMALIZATION_PROMPT, RESIZE_ENLARGE_DOMAIN_PROMPT, RESIZE_SHRINK_DOMAIN_PROMPT, SAMPLE_POOL_PROMPT, SSOT_BLOCK_GATE_PROMPT, SUBDOMAIN_ALLOCATE_PROMPT, TAG_CLASSIFY_PROMPT
- **Legacy Documentation:**
```text
[PRD-RUL-036]
SINGLE SOURCE OF TRUTH for M:N ratio enforcement.
Extracted from _process_many_to_many_relationships.
Ensures association tables don't exceed target ratio of total tables.
```

### `Function: _enrich_domain_with_products`
- **Lines of Legacy Code:** 52
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _enrich_product_with_attributes`
- **Lines of Legacy Code:** 138
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _ens_variant_json`
- **Lines of Legacy Code:** 26
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _ensure_catalog_exists`
- **Lines of Legacy Code:** 57
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _ensure_dict`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Convert a Spark Row (or any object with .asDict()) to a plain dict. Pass-through for dicts.
```

### `Function: _ensure_domain_exists`
- **Lines of Legacy Code:** 36
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _ensure_identity_fields`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Ensure all records in a list have business, version, and model_scope fields set.
Patches in-place; returns count of fields that were missing.
```

### `Function: _ensure_model_stats`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _ensure_shared_domain`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _ensure_tables`
- **Lines of Legacy Code:** 55
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _enum_values`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _esc`
- **Lines of Legacy Code:** 58
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _esc`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _escape_sql`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _escape_sql`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _escape_sql_str`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _estimate_norm_batch_timeout`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _estimate_total_tables`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _execute_queued_vibe_operations`
- **Lines of Legacy Code:** 1215
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_FIND_MISSING_PROMPT, NF_PROMPT, PRODUCT_IDENTIFY_CORE_PROMPT, QA_DENORMALIZE_PROMPT, QA_ESTIMATE_ROWS_PROMPT, QA_GENERATE_DESCRIPTIONS_PROMPT, QA_INDUSTRY_TEMPLATE_PROMPT, QA_REVERSE_ENGINEER_PROMPT
- **Legacy Documentation:**
```text
Execute queued quality checks, linking operations, and generation operations from vibe mode.

This function processes user-requested operations in the correct dependency order:
1. Linking operations (run_linking, run_in_domain_linking, run_cross_domain_linking)
2. Detection operations (detect_duplicates, detect_cycles, detect_siloed, review_links)
3. Fix operations (fix_duplicates, break_cycles, fix_siloed, fix_fk_anomalies)
4. Generation operations (generate_samples)

Args:
    queued_quality_checks: Dict of quality check operations to execute
    queued_linking_ops: Dict of linking operations to execute
    queued_generation_ops: Dict of generation operations to execute
    domains_data: List of domain dictionaries
    products_data: List of product dictionaries
    attributes_data: List of attribute dictionaries
    pk_map: Primary key mapping
    logger: Logger instance
    ai_agent: AIAgent instance
    config: Configuration dictionary
    widgets_values: Widget values dictionary
    protected_artifacts: User-vibed artifacts to protect
    vibe_changed_domains: List of changed domain names
    
Returns:
    dict: Results summary with issues found and fixed
```

### `Function: _execute_sql_parallel_core`
- **Lines of Legacy Code:** 97
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** UC-DDL] [install-ddl-retry-skip, install-ddl-retry-skip"

### `Function: _execute_tags_fast`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Fast parallel execution for tags with high concurrency. Integrates with GCM.
```

### `Function: _extend_sa_with_vibe_compliance`
- **Lines of Legacy Code:** 203
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** vibe-compliance-sa-fired, vibe-compliance-sa-no-vibe
- **Legacy Documentation:**
```text
[vibe-compliance-sa FIRED alias=vibe-compliance-sa-fired]
EXTENDS run_metamodel_static_analysis result with vibe-aware compliance categories.
Generic + industry-agnostic.
Categories added to sa_result['issues']:
  - vibe_hard_count_violation        (HARD count constraint exceeded)
  - vibe_canonical_key_drift         (user-named canonical key not used as PK/FK target)
  - vibe_ddl_column_dropped          (DDL column missing entirely from model)
  - vibe_ddl_type_drift              (DDL column present but type changed)
  - vibe_glossary_coverage_gap       (user-provided glossary term not represented)
  - vibe_subdomain_dataset_gap       (user-named subdomain header has no products)
Mutates sa_result in place; counts updated.
```

### `Function: _extract_and_log_honesty`
- **Lines of Legacy Code:** 56
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Extract honesty_score and honesty_justification from AI output and log it.
```

### `Function: _extract_bare_arithmetic_operands`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_business_role_prefix`
- **Lines of Legacy Code:** 71
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_column_refs_from_expr`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_explicit_requests`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_hard_constraints`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_metric_view_name_from_statement`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_metric_view_source_from_statement`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** mv-source-extract, mv-source-extract)
- **Legacy Documentation:**
```text
[mv-source-extract FIRED] (alias=mv-source-extract) — pull the
`source: "..."` value from a metric-view DDL so the failure-fallback path
in install can emit a minimal row-count view that ACTUALLY references the
original source. Required by mv-fallback-emit-live (A-2 fix).
```

### `Function: _extract_metric_view_target_from_statement`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** mv-target-extract
- **Legacy Documentation:**
```text
[mv-target-extract FIRED] — pull `catalog.schema.view` triple from CREATE OR REPLACE VIEW.
```

### `Function: _extract_model_lists_for_executor`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_must_do_only_vibe_text`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_new_links`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_pk_name`
- **Lines of Legacy Code:** 78
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_requested_transforms_from_vibe`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_role_from_product`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Extract a role hint from the product name (e.g., customer in 'customer_profile' → 'customer').
```

### `Function: _extract_sizing_directives_from_text`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_version_from_model_folder`
- **Lines of Legacy Code:** 239
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _extract_vibe_modelling_instructions`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _fill_missing_descriptions`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** sa-autofix-missing_attribute_description, sa-autofix-missing_attribute_description")
- **Legacy Documentation:**
```text
[sa-autofix-missing_attribute_description FIRED]
Fill empty/short attribute descriptions with a humanized placeholder derived
from the attribute and product names. Industry-agnostic. Only fills when
description is empty or shorter than 10 chars.
```

### `Function: _fill_missing_pks`
- **Lines of Legacy Code:** 38
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** sa-autofix-missing_pk, sa-autofix-missing_pk")
- **Legacy Documentation:**
```text
[sa-autofix-missing_pk FIRED]
For each product that has an attribute matching `<product>_id` (or the configured
PK pattern) but no `is_primary_key`/`primary_key` tag, mark it as PK and update
the product's `primary_key` field. Industry-agnostic.
```

### `Function: _filter_by_decision`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _filter_by_prefix`
- **Lines of Legacy Code:** 103
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _finalize_common`
- **Lines of Legacy Code:** 42
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _finalize_generate_attrs_for_stub`
- **Lines of Legacy Code:** 282
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** mv15-gap-rerun

### `Function: _finalize_logs`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Shuts down logging and copies local log files to their final DBFS destination.
Also finalizes the ObservationsLogger to upload observations CSV.

Uses multi-strategy write (put -> SDK upload -> cp) for compatibility
with all Databricks compute types including shared/serverless.
```

### `Function: _finalize_session`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _find_attr`
- **Lines of Legacy Code:** 152
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** safe-executor

### `Function: _find_attribute`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Locate attribute row matching (domain, product, attribute). Tries original parts,
then applies rename maps, then tries the INVERSE (caller gave post-rename name but
row still under old name).
```

### `Function: _find_best_person_table`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _find_domain`
- **Lines of Legacy Code:** 461
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _find_existing_fk_candidate`
- **Lines of Legacy Code:** 53
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Find an existing attribute that could serve as the FK column.
This prevents adding new attributes that don't exist in the physical table.

Checks for:
1. Exact match by attribute name
2. Match with classification prefixes (restricted_pii_, confidential_pii_, internal_, public_, etc.)
3. Match based on target PK name
4. SEMANTIC MATCH: Uses synonym map to find columns with equivalent business meaning

Returns:
    tuple: (found_attr, match_type) or (None, None) if not found
```

### `Function: _find_fk_target_products`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
DRY helper: Returns set of lowercase product names that are FK targets (referenced by other products).
Used by reduction logic to avoid removing products that other tables depend on.
```

### `Function: _find_matching_paren`
- **Lines of Legacy Code:** 21
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _find_next_available_version`
- **Lines of Legacy Code:** 381
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** log-append-on-retry, log-append-on-retry"), vov-auto-next-vibes
- **Legacy Documentation:**
```text
Find the next version number that doesn't already exist as a completed version.
```

### `Function: _find_product`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _find_product`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _find_removable_attributes`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
DRY helper: Returns list of removable attribute dicts for a product (excludes PKs and FKs).
Sorted by "importance" — audit/log/temp/flag attrs first (least important).
```

### `Function: _find_removable_products`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
DRY helper: Returns list of (product_dict, attr_count) sorted by attr_count (smallest first).
Excludes FK-target products. Used by reduction logic.
```

### `Function: _find_replace_attr`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _finding_to_mutation_action`
- **Lines of Legacy Code:** 59
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _fix_bare_attribute_names`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Autofixer / Finding Execution
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Deterministic fixer: rename bare generic attribute names to prefixed versions.

Bare 'status', 'type', 'name', 'description', 'date' are meaningless without context.
Prefix them with the product name for clarity.
E.g., sensor.status → sensor.sensor_status, incident.type → incident.incident_type
```

### `Function: _fix_expr_line`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Autofixer / Finding Execution
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _fk_batch_variant`
- **Lines of Legacy Code:** 52
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _fk_update_for_product`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _flush_domain`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _flush_log_handlers`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _flush_standalone`
- **Lines of Legacy Code:** 168
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** DOMAIN_GENERATE_PROMPT, MODEL_ARCHITECT_REVIEW_PROMPT, PRODUCT_GENERATE_PROMPT

### `Function: _fmfl_normalise_target`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _fmfl_postprocessor`
- **Lines of Legacy Code:** 394
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fmfl-auto-apply-top1, fmfl-auto-apply-top1", fmfl-auto-apply-top1-summary, fmfl-final-sanitize, fmfl-final-sanitize", fmfl-final-sanitize-summary
- **Prompts Used:** FK_FIND_MISSING_PROMPT

### `Function: _fmfl_suggest_canonical`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _fmt_hms`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _force_safe_measures`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _format_boolean`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _format_boolean`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _format_date_value`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Return a python date/datetime (not string) — Spark will format it via
the target schema. We keep the value typed for createDataFrame.
```

### `Function: _format_distributed_vibes_impl`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _format_eta`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _format_product_lines_with_attrs`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _format_scope_label`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _fuzzy_find_entity`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
DRY helper: Find entity by exact then fuzzy match. Returns the dict or None.
```

### `Function: _fuzzy_match_attr`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _fuzzy_match_domain`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _fuzzy_match_product`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _fuzzy_name_match`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _gate_is_pass`
- **Lines of Legacy Code:** 21
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Returns True if a gate entry represents a pass. Accepts dict-shaped
gate (with ``answer``/``pass`` keys) and bare strings/booleans. Matches
the common affirmative tokens the LLM emits.
```

### `Function: _gd_halve`
- **Lines of Legacy Code:** 82
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** QA_GENERATE_DESCRIPTIONS_PROMPT, QA_SUGGEST_ATTRS_PROMPT, QA_SUGGEST_TABLES_PROMPT

### `Function: _gd_try_call`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** QA_GENERATE_DESCRIPTIONS_PROMPT

### `Function: _gen_decision_ranges`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _gen_guardrails_tables`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _gen_pk`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _gen_self_ref`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _gen_sizing_targets`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _gen_tier_brief`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _gen_tier_detailed`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _generate_and_insert_samples_for_product`
- **Lines of Legacy Code:** 48
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** SAMPLE_POOL_PROMPT
- **Legacy Documentation:**
```text
Pool-based sample generation. The LLM returns ONE JSON
object per product describing per-column value pools (categorical,
temporal, numeric, boolean, freetext) and optional correlated groups.
Local stdlib helpers then assemble N rows deterministically. This
eliminates the old CSV row-wise prompt and every third-party fallback entirely.

Tiers:
  Tier 1: SAMPLE_POOL_PROMPT LLM call (+ 1 retry). Returns JSON pool spec.
  Tier 2: Stdlib random-only fallback (_generate_random_samples) if the
          LLM fails or returns an unparseable spec.

FK columns are always set to None here — Phase 2 patches them with real
PK values from their target tables.
```

### `Function: _generate_attributes_for_product`
- **Lines of Legacy Code:** 57
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
[MODIFIED]: Now passes 'valid_product_targets' into the prompt_vars
to help the LLM avoid hallucinations. Uses thread-safe logger if provided.
```

### `Function: _generate_ddl_from_enriched_json`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Generate all DDL statements (databases, tables, FKs, tags) from enriched model.json.
```

### `Function: _generate_model_csv`
- **Lines of Legacy Code:** 228
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _generate_random_samples`
- **Lines of Legacy Code:** 236
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _generate_rdf_schema`
- **Lines of Legacy Code:** 176
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Internal worker function to generate the RDFS schema file.
```

### `Function: _generic_handle_add_columns_from_template`
- **Lines of Legacy Code:** 25
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _generic_handle_generate_artifact`
- **Lines of Legacy Code:** 74
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _generic_handle_query`
- **Lines of Legacy Code:** 486
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _generic_handle_set_property`
- **Lines of Legacy Code:** 39
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _generic_handle_tag`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _generic_handle_transform_name`
- **Lines of Legacy Code:** 75
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get`
- **Lines of Legacy Code:** 26
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Get attribute from dict.
```

### `Function: _get`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get`
- **Lines of Legacy Code:** 47
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get`
- **Lines of Legacy Code:** 177
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_available_action_catalog`
- **Lines of Legacy Code:** 194
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_bc_val`
- **Lines of Legacy Code:** 70
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_bc_value`
- **Lines of Legacy Code:** 161
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** DOMAIN_GENERATE_PROMPT

### `Function: _get_bc_value_samples`
- **Lines of Legacy Code:** 62
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_columns`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_embedded_fk_re`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_embedded_tags_re`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_fallback_model`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_file_sql_name`
- **Lines of Legacy Code:** 39
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_findings_by_type`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_latest_completed_version`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Get the latest completed version, preferring completion_date then numeric version.
```

### `Function: _get_latest_version`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_model_config_for_prompt`
- **Lines of Legacy Code:** 50
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Get the model configuration for a specific prompt.
```

### `Function: _get_model_scope_instruction`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_next_try_num`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_pk_type_for_fk_target`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** REL-RUL-003

### `Function: _get_pk_type_for_fk_target_impl`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_related_products_in_domain`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Returns set of product names in the same domain that are FK-related to the given product.
Related = (products that have an FK pointing TO this product) OR (this product has FK TO them).
Closure: include all such products transitively. Used when relocating: move product + all related (no half measures).
```

### `Function: _get_resilient_fallback_model`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_scope_flat`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_session_processing_status`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_siloed_products_list`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Returns list of siloed product keys (domain.product) that have no FK relationships.
A siloed table has NO incoming FKs AND NO outgoing FKs (completely disconnected).
```

### `Function: _get_tier_specific_target_fit`
- **Lines of Legacy Code:** 171
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** DOM-RUL-001, DOM-RUL-003, DOM-RUL-005, DOM-RUL-006, DOM-RUL-007, DOM-RUL-008, DOM-RUL-009, DOM-RUL-017
- **Prompts Used:** BUSINESS_CONTEXT_PROMPT

### `Function: _get_user_vibe_instructions`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_val`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_vibe_cache`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_vibe_constraints`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** G14-R001, G14-R008, G14-R015, G14-R016, G14-R017
- **Legacy Documentation:**
```text
[G14-R001 through G14-R008, G14-R015, G14-R016, G14-R017]
SINGLE SOURCE OF TRUTH for reading vibe constraints from the classification LLM output.
Uses diskcache when available.
```

### `Function: _get_vibe_constraints_impl`
- **Lines of Legacy Code:** 84
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _get_vibe_parse_model_config`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** VIBE_PARSE_PROMPT

### `Function: _get_workspace_context`
- **Lines of Legacy Code:** 27
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Return (host_url, org_id) for building job run URLs.
```

### `Function: _group_metric_views_by_domain`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Backwards-compat helper for install / legacy consumers expecting
``{domain: concatenated_sql_string}``. Use this ONLY at the consumer edge;
the canonical persisted shape is a LIST via `_metric_views_to_export_records`.
```

### `Function: _has_action`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _has_action_type`
- **Lines of Legacy Code:** 273
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _has_any_action`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _has_enum`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Column has a pipe-delimited enum value_regex → treat as categorical.
```

### `Function: _has_fk_to_target`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Check if source table already has ANY FK column pointing to the target table.
```

### `Function: _has_nested_aggregate_depth_aware`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _has_tag`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _heuristic_edge_break_score`
- **Lines of Legacy Code:** 39
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Multi-signal edge break scoring. Higher = preferred to break.

Signals (in priority order):
1. Convenience FK prefix (+10000) — always safe to break
2. Edge betweenness centrality (INVERTED: low betweenness = safe to break)
3. Target incoming FK count (high = resilient target, safe to break one link)
4. Cross-domain penalty (-500 for same-domain, as cross-domain is preferred)
```

### `Function: _infer_naming_convention_from_identifier`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _infer_tier_from_model_stats`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _inject`
- **Lines of Legacy Code:** 1840
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** rename-product-convention-enforce

### `Function: _inject_missing_must_do_actions`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Parses MUST DO steps from the vibe instructions text and injects any
missing actions that the LLM failed to generate.
Returns the count of injected actions.
```

### `Function: _inject_tag`
- **Lines of Legacy Code:** 49
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** user-vibe-tag-applier, user-vibe-tag-applier"

### `Function: _inject_user_vibe_block`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _insert_product_samples`
- **Lines of Legacy Code:** 26
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
(Sub-function) Inserts a DataFrame of samples into its target Delta table.
Validates source columns against target table schema to prevent column mismatch errors.
```

### `Function: _insert_progress_chunk`
- **Lines of Legacy Code:** 53
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _install_log_write`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_already_linked_in_model`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Catch attributes that already have a foreign_key_to in the actual model data (Rule 7).
```

### `Function: _is_ambiguous_pk`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Returns True if the PK base name is generic enough to cause cross-domain mislinks.
```

### `Function: _is_convenience_fk`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Returns True if the FK attribute name suggests a convenience/denormalized reference.
```

### `Function: _is_core_for_domain`
- **Lines of Legacy Code:** 676
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_external_ref`
- **Lines of Legacy Code:** 61
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fk-validator-skip-external-refs, fk-validator-skip-external-refs")

### `Function: _is_global_rewrite_action`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_hierarchical_self_ref`
- **Lines of Legacy Code:** 36
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_high_reference_domain`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_high_reference_product`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** DOM-RUL-014

### `Function: _is_metric_dimension_eligible`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_metric_measure_eligible`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_metric_numeric_type`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_metric_temporal_type`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_model_broken`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_model_enabled`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_model_enabled_value`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_mvm_scope`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_new_model_json_format`
- **Lines of Legacy Code:** 209
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_non_person_table`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_person_role_column`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_pii_match`
- **Lines of Legacy Code:** 34
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
True iff `pattern` matches `column_name` as a word-bounded
contiguous token subsequence (not substring).

Both `pattern` and `column_name` are tokenized to lowercase snake_case
tokens; the match is exact-token contiguous sub-sequence.

Positive examples:
  _is_pii_match('customer_email',    'email')        -> True
  _is_pii_match('PrimaryEmail',      'email')        -> True
  _is_pii_match('TaxId',             'tax_id')       -> True
  _is_pii_match('tax_id_number',     'tax_id')       -> True
  _is_pii_match('tin_value',         'tin')          -> True
  _is_pii_match('DateOfBirth',       'date_of_birth')-> True

Negative examples (root cause of false positives):
  _is_pii_match('MARKETING_OPT_IN',          'tin') -> False
  _is_pii_match('DISCONTINUATION_DATE',      'tin') -> False
  _is_pii_match('DESTINATION_COUNTRY_CODE',  'tin') -> False
  _is_pii_match('shipment_destination',      'tin') -> False
```

### `Function: _is_pk_in_orphaned`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Catch PKs that slipped into orphaned_fks_to_link despite prompt rules.
```

### `Function: _is_pk_pattern`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_pointer_attr`
- **Lines of Legacy Code:** 49
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** bidirectional-pointer-auto-resolve, bidirectional-pointer-auto-resolve")

### `Function: _is_protected`
- **Lines of Legacy Code:** 33
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_protected_parent_child_fk`
- **Lines of Legacy Code:** 25
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** REL-RUL-012, REL-RUL-020

### `Function: _is_reasoning_response_parse_error`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_rename`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_role_labeled_self_ref`
- **Lines of Legacy Code:** 56
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
BUG #6 — Relaxed self-ref FK check.

Allow a self-referencing FK when ALL of:
  (1) FK column name != PK column name (strict inequality).
  (2) FK column name is NOT a trivial rename (e.g., just `parent`, `prev`,
      `orig` with no qualifier) — must have substance.
  (3) FK name contains a recognizable role prefix OR suffix from
      _SELF_REF_ROLE_TOKENS.
  (4) The column type matches PK's integer type (BIGINT/INT/LONG).
      If attr_type or pk_type is unknown, this sub-check is treated as
      permissive (we do not reject solely on a missing type hint).
Returns (allowed: bool, role: str | None).
```

### `Function: _is_safe_aggregate_ratio`
- **Lines of Legacy Code:** 49
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_self_referencing_orphan`
- **Lines of Legacy Code:** 65
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _is_system_identifier_column`
- **Lines of Legacy Code:** 80
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** REL-RUL-006
- **Observability Aliases (Must be preserved):** ext-system-prefix-string-parse, ext-system-prefix-string-parse), ext-system-prefix-string-parse-FIRED), logger-propagate-fired, sor-fallback-llm-generated
- **Legacy Documentation:**
```text
[REL-RUL-006]
Returns True if base_name is a system/external identifier pattern that
should NOT be treated as a FK to a parent table.
These are reference numbers, codes, or technical identifiers — NOT business entity FKs.

Also detects external system identifier prefixes (e.g., <vendor>_org_unit_id, <product>_plan_id,
sharepoint_user_id) which should NOT be linked to internal model tables because
they reference entities in external systems, not internal model entities.
```

### `Function: _lint_prompt_templates`
- **Lines of Legacy Code:** 433
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** ATTRIBUTE_GENERATE_PROMPT, DOMAIN_GENERATE_PROMPT, DOMAIN_JUDGE_PROMPT, FK_BROKEN_RESOLVE_PROMPT, FK_CROSS_DOMAIN_MESH_PROMPT, FK_IN_DOMAIN_LINK_PROMPT, FK_MANY_TO_MANY_PROMPT, FK_PAIRWISE_LINK_PROMPT, MODEL_ARCHITECT_REVIEW_PROMPT, PRODUCT_DUPLICATE_DETECT_PROMPT, PRODUCT_GENERATE_PROMPT, PRODUCT_GLOBAL_DEDUP_PROMPT, QUALITY_DOMAIN_FIT_PROMPT, QUALITY_NORMALIZATION_PROMPT, RESIZE_ENLARGE_DOMAIN_PROMPT, RESIZE_SHRINK_DOMAIN_PROMPT, VIBE_DROP_PROMPT, VIBE_DROP_RELEVANCE_PROMPT, VIBE_MASTER_PROMPT, VIBE_PRUNE_PROMPT
- **Legacy Documentation:**
```text
Static linter for PROMPT_TEMPLATES. Catches unescaped format placeholders
(like `{product}` in FK_PAIRWISE_LINK_PROMPT that broke 171 pairwise calls with KeyError).

For every template, extract every `{name}` placeholder. A placeholder is OK if:
- it's a known legit kwarg used by at least one caller in the module (heuristic: contains _ or is
  one of the common vars business_name, domain_a, etc.), OR
- it's escaped as `{{` `}}` in the source.

Unknown bare placeholders (like `{product}`) are flagged as WARNING so developers see them.
Does NOT raise — logs a warning with the placeholder list. Runs once at import time.
```

### `Function: _list_user_schemas`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _llm_fallback_apply_mutations`
- **Lines of Legacy Code:** 32
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _llm_fallback_build_model_snapshot`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _llm_fallback_handler`
- **Lines of Legacy Code:** 205
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** LLM_FALLBACK_CLASSIFY_PROMPT, LLM_FALLBACK_EXECUTE_PROMPT, LLM_FALLBACK_QUERY_PROMPT

### `Function: _llm_fallback_validate`
- **Lines of Legacy Code:** 61
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _load_file_from_path`
- **Lines of Legacy Code:** 35
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _load_sample_for_product`
- **Lines of Legacy Code:** 122
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _local_action_executor`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _local_execute_sql_no_halt`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Executes SQL statements in parallel, non-grouped, and does NOT halt on failure.
Retries each statement individually. Integrates with GlobalConcurrencyManager.
```

### `Function: _log_banner`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _log_console`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _log_step_end`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Logs the end of a step and its duration.
```

### `Function: _log_step_start`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Logs the start of a step and returns its start time.
```

### `Function: _looks_like_model_json`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _loop`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _ls`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _m2m_attr`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _main_rollback_delete`
- **Lines of Legacy Code:** 61
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _make_cache_key`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _make_log_console`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _make_table`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _make_tracked_worker`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _mark_model_broken`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _match_attribute`
- **Lines of Legacy Code:** 27
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
SINGLE SOURCE OF TRUTH for checking if an attribute matches a pattern.
Used by add_tag, remove_tag, update_glossary, update_reference, update_regex, change_type, etc.

Args:
    fuzzy_attr: If True, supports prefix/suffix/substring matching on attr name.
```

### `Function: _maybe_cull`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _merge_cross_domain_duplicate_subset`
- **Lines of Legacy Code:** 86
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** sa-autofix-cross_domain_duplicate, sa-autofix-cross_domain_duplicate")
- **Legacy Documentation:**
```text
[sa-autofix-cross_domain_duplicate FIRED]
SAFE SUBSET-MERGE for cross-domain duplicates. Only fires when ALL conditions hold:
  1. Two products share the same name across two domains
  2. The smaller product's attributes are a >=80% subset of the larger's
  3. The smaller product has zero unique attributes vs the larger
  4. The smaller product has zero incoming FKs (safe to drop)
When triggered, drops the subset (no FK redirect needed since no incoming FKs).
Risky multi-way merges or large overlaps fall through to next_vibes for the LLM.
Industry-agnostic — operates purely on attribute set overlap + FK graph.
```

### `Function: _merge_read_json`
- **Lines of Legacy Code:** 58
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _metadata_model_consistency_check`
- **Lines of Legacy Code:** 92
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** G10-R001, G10-R002
- **Legacy Documentation:**
```text
# G10-R001, G10-R002

Check consistency between metadata structures: ensure all attributes reference
valid domains and products, and all FK targets exist in the product set.
This catches metadata drift where the attributes list references entities
that don't exist in the products/domains lists.
```

### `Function: _metric_label`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _metric_view_ownership_sanity_check`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
verify ownership validator + export helpers.

INVARIANTS:
  - Export helper produces deterministically-ordered list of dicts.
  - Grouping helper returns dict keyed by sanitized owner_domain.
  - Validator raises on missing owner_domain / blank view_name.
  - Validator raises on owner_domain that is not in domains_data.
  - Validator raises on owner_product that is not in the domain's products.
  - Happy-path validator returns N (number validated) and logs no errors.
```

### `Function: _metric_views_to_export_records`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Canonical serialisable export shape for metric_views.

Returns a deterministically-ordered list of dicts. Persisted as
``data_model["metric_views"]``.
Ordering: owner_domain, then owner_product (empty last), then view_name.
```

### `Function: _metric_worker`
- **Lines of Legacy Code:** 191
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** domain-to-db-from-config, domain-to-db-from-config), metric-view-joins-global-map, mv-attrs-by-key-stash, mv-attrs-by-key-stash"), mv-attrs-by-key-stash)
- **Prompts Used:** DOMAIN_METRICS_PROMPT

### `Function: _metric_yaml_quote`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _migrate_json_in_dir`
- **Lines of Legacy Code:** 119
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _migrate_obj`
- **Lines of Legacy Code:** 38
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _mm_attr_type`
- **Lines of Legacy Code:** 38
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _mm_cn`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _mm_col_name`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _mm_pk_name`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _mm_table_name`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _mock_try_faker_for_column`
- **Lines of Legacy Code:** 71
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _model_scope_clause`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Build SQL AND clause for model_scope, tolerating legacy NULL values.
```

### `Function: _move_attrs_to_association`
- **Lines of Legacy Code:** 50
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
SINGLE SOURCE OF TRUTH for moving relationship attributes from a parent product to an association.
Extracted from _process_many_to_many_relationships.

Returns: count of attributes moved
```

### `Function: _multi_pass_substitute`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _mut_sort_key`
- **Lines of Legacy Code:** 32
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _mv_refs_installed`
- **Lines of Legacy Code:** 117
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** mv-column-prevalidate-drop, mv-column-prevalidate-drop), mv-filter-strip-comments, mv-filter-strip-comments"), mv-filter-strip-comments)

### `Function: _mvcp_get_cols`
- **Lines of Legacy Code:** 171
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** mv-column-llm-repair, mv-column-llm-repair"), mv-column-llm-repair-error"), mv-column-llm-repair-failed"), mv-column-prevalidate-drop, mv-column-prevalidate-drop")

### `Function: _naming_convention_sanity_check`
- **Lines of Legacy Code:** 40
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
assert PK and FK naming are mutually consistent across
all 4 naming conventions × 6 PK suffixes.

INVARIANT (root of the production bug):
  For any (convention, suffix) pair, `NamingConvention.pk_column(entity)` and
  `NamingConvention.fk_column(entity)` MUST return byte-identical strings.
  A FK that references `order.order_id` must use column name `order_id`
  regardless of case convention, suffix variant, or call path.
```

### `Function: _nc_read_json`
- **Lines of Legacy Code:** 92
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _nc_write_json`
- **Lines of Legacy Code:** 51
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _next_step_id`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _norm`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _norm`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _norm_attr`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _norm_col_entry`
- **Lines of Legacy Code:** 97
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _norm_col_entry`
- **Lines of Legacy Code:** 157
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _norm_for_rename`
- **Lines of Legacy Code:** 227
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _norm_response_postprocessor`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Filter normalization mutations by structured `decision` field.

Each entry in orphaned_fks_to_link / denormalized_attributes_to_remove /
duplicate_fks_to_remove is expected to carry decision: "INCLUDE" | "EXCLUDE".
Entries with decision == "EXCLUDE" are stripped (audit trail only).
Entries missing decision default to INCLUDE (legacy / backward compat),
with a warning logged.
Top-level integer fields orphaned_fks_to_include /
denormalized_attrs_to_include / duplicate_fks_to_include are verified
against the surviving INCLUDE counts.
NO PROSE PARSING. NO REGEX ON LLM OUTPUT.
```

### `Function: _normalize_attr_name`
- **Lines of Legacy Code:** 119
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_FIND_MISSING_PROMPT

### `Function: _normalize_boolean_format_label`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _normalize_business_context_keys`
- **Lines of Legacy Code:** 27
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _normalize_classification`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Normalize and validate LLM classification value.
```

### `Function: _normalize_column_name`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _normalize_gate_hierarchy`
- **Lines of Legacy Code:** 38
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
/ If a harder gate passes, force all easier
gates to pass.

``gate_outcomes`` is the dict of per-gate objects as emitted by the LLM
(keys are gate names, values are dicts with at least ``answer``). Returns
a **deep-copied** dict where lower-tier gates have been auto-upgraded to
"Yes" when a higher-tier gate passes. Each inferred upgrade is logged and
annotated with an ``inferred_from`` field so downstream reporting can
still show the auto-promotion.

switched from shallow ``dict(gate_outcomes)`` to
``copy.deepcopy`` so mutation of any nested dict (e.g. the per-gate
``{"answer", "evidence", ...}`` payloads) cannot leak back into the
caller's prior-iteration bookkeeping. Shallow-copying only the OUTER
dict meant ``existing = dict(existing)`` on a nested gate still shared
deeper references (e.g. lists of evidence strings) across iterations.

ALWAYS emits a summary ``[Gate Hierarchy] normalize`` line
even when no auto-upgrade was needed, so ops can distinguish "feature
didn't fire" (no log) from "feature fired and found nothing to do"
(summary with auto_upgraded=0).
```

### `Function: _normalize_metric_view_name`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _normalize_model_size`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _normalize_numeric_string`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Normalize numeric string by replacing Unicode characters with ASCII equivalents.
```

### `Function: _normalize_override_key`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _normalize_progress_increment`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _normalize_scope_name`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _normalize_version_token`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _overlap`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** metric-view-bare-via-describe")

### `Function: _p025_pick_tier`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _p068_faker_provider_map`
- **Lines of Legacy Code:** 64
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Returns an ordered list of (token_tuple, provider_name, callable) rows.
Ordering matters: more specific multi-token patterns come first so that
('customer_name',) wins over ('name',) even though both would match.
```

### `Function: _p068_faker_tier2_sanity_check`
- **Lines of Legacy Code:** 56
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
verify Tier-2 Faker integration.

INVARIANTS:
  - `_p068_pick_faker_provider` returns a provider for PII-ish cols when
    Faker is available; returns (None, None) if unavailable.
  - Multi-token patterns beat single-token patterns (e.g. 'customer_name'
    picks faker.name, not a generic faker.user_name).
  - '_p068_try_faker_for_column' returns STRING-typed Faker values for
    STRING cols and (None, None) for non-STRING types (BIGINT/DATE).
  - When Faker is UNAVAILABLE, stdlib fallback still produces values for
    every column (no Tier-2 crash path).
  - Mock product with mixed cols (BIGINT account_id, STRING email/name/phone,
    DATE created_date): Faker values for email/first_name/phone; BIGINT +
    DATE fall through to Tier 3.
```

### `Function: _p068_pick_faker_provider`
- **Lines of Legacy Code:** 45
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
choose a Faker provider for a column.

Reuses P0.73's `_p073_tokenize` and the contiguous-subsequence semantics
of `_is_pii_match` for DRY — same word-boundary algorithm, no duplicate
tokenizer.

Returns (provider_name:str, callable) on match, else (None, None).

Ordering: first entry in _P068_FAKER_PROVIDERS whose token-tuple is a
contiguous subsequence of `column_name`'s tokens wins. The provider
map's token tuples may themselves contain multi-token strings
(e.g. ('first_name',) means "first" + "name"); we re-tokenize each
entry through _p073_tokenize so the match semantics match column
semantics exactly.
```

### `Function: _p068_try_faker_for_column`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _p070_chunked_linking_sanity_check`
- **Lines of Legacy Code:** 94
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
verify the in-domain chunking heuristic.

INVARIANTS:
  - Domain with ≤12 products → 1 chunk, identical to input.
  - Domain with 30 products (12 A + 10 B + 8 C subdomains) → 3 chunks
    of sizes (12, 10, 8) exactly matching subdomain boundaries.
  - Domain with 100 products in ONE subdomain → chunked to ≤12 each via
    alphabetical fallback → at least 9 chunks (ceil(100/12)=9).
  - Union of chunks equals input set (no product lost or duplicated).
  - Each chunk size ≤ _P070_CHUNK_SIZE.
```

### `Function: _p070_cluster_products_for_chunking`
- **Lines of Legacy Code:** 59
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
cluster products into ≤chunk_size buckets.

Strategy:
  1. Group by subdomain (products sharing a subdomain go together).
  2. Subdomain buckets larger than chunk_size are re-split alphabetically
     by product name into sub-chunks of ≤chunk_size.
  3. Subdomain buckets smaller than chunk_size are merged (greedy bin-pack)
     with other small buckets to approach but never exceed chunk_size.
  4. Products without a subdomain fall into an '__no_subdomain__' bucket.

Returns a list of chunks, each chunk is a list of product dicts. The union
of all chunks equals `products_in_domain` (no product is dropped or duplicated).
```

### `Function: _p071_early_next_vibes_sanity_check`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
verify early/late next_vibes split wrappers exist, are
callable, and honour the _next_vibes_early_written / _next_vibes_late_emitted
flag invariants.

This harness does NOT invoke the LLM-heavy step_generate_next_vibes (no
AI agent is available in the synthetic test environment); instead it
monkey-patches the underlying function with a stub and verifies the
wrapper contracts:

  - step_generate_next_vibes_early calls the underlying step exactly once
    and sets _next_vibes_early_emitted=True.
  - step_generate_next_vibes_late sets _next_vibes_early_written=True
    BEFORE calling the underlying step (so the inner function's early-file
    write is suppressed on the late pass) and sets _next_vibes_late_emitted.
  - Both wrappers swallow exceptions raised by the underlying step
    (non-critical degrade path).
```

### `Function: _p073_tokenize`
- **Lines of Legacy Code:** 33
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Split snake_case / PascalCase / camelCase / SCREAMING_CASE / dotted /
mixed strings into a list of lower-case tokens.

Pure-string implementation (no dependency on apply_convention which is
defined later in the module). Idempotent & side-effect free.

Examples:
  'customer_email'           -> ['customer', 'email']
  'PrimaryEmail'             -> ['primary', 'email']
  'AccountEmailAddress'      -> ['account', 'email', 'address']
  'MARKETING_OPT_IN'         -> ['marketing', 'opt', 'in']
  'DestinationCountryCode'   -> ['destination', 'country', 'code']
  'TaxId'                    -> ['tax', 'id']
  'tax_id_number'            -> ['tax', 'id', 'number']
  'customer.Email'           -> ['customer', 'email']
```

### `Function: _p073_would_substring_match`
- **Lines of Legacy Code:** 249
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _p074_qualified_rename`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Build a PascalCase-concatenated qualified rename.

- `Invoice` + `Vendor` → `VendorInvoice`
- `status_history` + `order` → `OrderStatusHistory`
- `address` + `customer` → `CustomerAddress`

Industry-agnostic, case-preserving for mixed inputs. The OUTPUT naming
convention is then normalised by the enforcement pass (snake_case,
camelCase, etc.) downstream; we ONLY care that the qualified string
uniquely identifies the concept.
```

### `Function: _p081_resync_model_files_to_disk`
- **Lines of Legacy Code:** 76
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Re-serialize the in-memory data model to its mirror JSON files.

Call after any pass that renames/removes/adds entities so subsequent readers
(including consolidation steps that re-load from disk) see the post-autofix
state. Industry-agnostic; Databricks Serverless compatible.

Args:
    config: pipeline config dict (reads DOMAINS_FILE_PATH, PRODUCTS_FILE_PATH,
        ATTRIBUTES_FILE_PATH, BUSINESS_BASE_PATH).
    logger: logger for the [P0.81-RESYNC] summary line.
    phase: free-form string identifying WHERE the call came from (e.g.
        'post_ar_autofix', 'post_qa_autofix', 'post_finalize_autofix',
        'post_naming_conventions'). Shows up in the summary line.
    domains_data / products_data / attributes_data: pass the authoritative
        in-memory lists. Any of them may be None — the helper simply skips
        that file.

Returns:
    dict with per-section counts. Never raises.
```

### `Function: _p081_resync_sanity_check`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
verify the mirror-JSON resync helper.

INVARIANTS:
  - All three JSON files (domains/products/attributes) are rewritten with
    the in-memory lists after the helper call.
  - Missing file paths in config are no-ops (no crash).
  - After an autofix-style rename on the in-memory list, the disk file
    reflects the NEW name (not the old).
  - Counter in the [P0.81-RESYNC] log line equals len() of each list.
```

### `Function: _p083_emit_raw_pool_log`
- **Lines of Legacy Code:** 26
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Emit the first 200 chars of a raw pool-spec response. Module-level so
the nested sample helper can call it without closure gymnastics. Capped
at 3 logs per process run so we don't spam the driver log.
Databricks Serverless compatible (stdlib only).
```

### `Function: _p083_pool_parse_sanity_check`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
verify the pool-spec parser accepts multiple LLM-response
shapes that previously failed 100% of the time.

SHAPES TESTED:
  (A) Canonical {columns: {col: {bucket, pool}}} — must pass.
  (B) Array of column objects — must normalise into canonical shape.
  (C) {columns: [...]} array variant — must normalise.
  (D) `pool_type` / `values` aliases — must remap.
  (E) Single-quoted JSON — must fall back and parse.
  (F) Markdown-fenced JSON — must strip fences.
  (G) Genuinely-unparseable prose — must return None, not crash.

Mirrors the in-step-local `_parse_pool_json`, but we call a module-level
stand-in that replicates the logic byte-for-byte.
```

### `Function: _p089_validate_product_name`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Return True if the RAW LLM-returned product name is NOT VREQ bleed.

Validates BEFORE sanitize_name. The raw name may be in any case and must
still be a clean single identifier. Industry-agnostic; stdlib only.
```

### `Function: _p089_vreq_bleed_sanity_check`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
verify `_p089_validate_product_name` rejects VREQ bleed.

6 positive cases, 6 negative (VREQ-bleed) cases.
```

### `Function: _p091_is_valid_identifier`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Return (is_valid, reason) for a proposed identifier (column/product name).

A valid identifier:
  - is a non-empty string,
  - matches ``^[a-z][a-z0-9_]{0,62}$``,
  - contains NONE of the prose tokens (word-boundary match on
    underscore-split tokens so ``status`` is fine but ``status_column``
    fails on ``column``).

Invariants:
  - pure stdlib (re + set); Databricks Serverless compatible.
  - Industry-agnostic — no vertical-specific words in the blacklist.
```

### `Function: _p091_prose_validator_sanity_check`
- **Lines of Legacy Code:** 41
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
verify `_p091_is_valid_identifier` accepts clean names and
rejects prose-bearing names.

12 positive cases (accepted), 8 negative cases (rejected for prose/length/etc).
```

### `Function: _p091_reject_name_mutation`
- **Lines of Legacy Code:** 42
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Helper: validate the given field value on the mutation; if invalid, log
a [P0.91-PROSE-REJECT] line, append to skipped, bump counter, return True
(meaning the caller should `continue` — i.e., the mutation was rejected).
Otherwise return False.

Industry-agnostic; stdlib only; safe under Databricks Serverless.
```

### `Function: _parallel_batch_insert`
- **Lines of Legacy Code:** 56
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _parse_attr_pattern`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
SINGLE SOURCE OF TRUTH for parsing a domain.product.attribute pattern.
Supports wildcards (*). Used by all action execution blocks.
Returns (pat_domain, pat_product, pat_attr).
```

### `Function: _parse_context_file_business_data`
- **Lines of Legacy Code:** 337
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fidelity-bypass-widget-live

### `Function: _parse_deterministic`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _parse_pool_json`
- **Lines of Legacy Code:** 54
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Extract and json.loads the pool spec. Strips markdown fences and any
leading/trailing prose the LLM might have added despite instructions.

tolerate common LLM response shapes that previously
failed 100% of parse attempts:
  - Array-of-objects shape: [{column_name, pool_type, ...}, ...]
    normalised into {columns: {col_name: {bucket: ..., ...}}}
  - {columns: [{column_name, pool_type, ...}, ...]} array variant
  - {columns: {col: {pool_type, ...}}} with pool_type instead of bucket
  - Partial markdown fences / stray leading prose ("Here is the
    JSON:") stripped before the first {.
  - Single-quote JSON tolerated by a targeted .replace().
Returns the normalised dict or None if no recoverable shape is found.
```

### `Function: _parse_pool_json`
- **Lines of Legacy Code:** 36
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _parse_priority_directives`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** det-priority-parse

### `Function: _parse_product_lists_from_vibes`
- **Lines of Legacy Code:** 101
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _parse_tags_to_kv_j`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _parse_tags_to_kv_pairs`
- **Lines of Legacy Code:** 149
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _parse_with_llm`
- **Lines of Legacy Code:** 36
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** VIBE_PARSE_PROMPT

### `Function: _pascal`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _path`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _pii_match_sanity_check`
- **Lines of Legacy Code:** 100
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
verify `_is_pii_match` word-boundary tokenization.

Positives MUST match, negatives (the false positives caught in
production: MARKETING_OPT_IN / DISCONTINUATION_DATE / DESTINATION_COUNTRY_CODE
against `tin`) MUST NOT match.
```

### `Function: _pk_like_norms_for_product`
- **Lines of Legacy Code:** 142
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _post_normalization_deterministic_fk_linker`
- **Lines of Legacy Code:** 139
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-040, REL-RUL-002, REL-RUL-010
- **Legacy Documentation:**
```text
DETERMINISTIC post-normalization fallback for linking unlinked _id columns.

This is a SAFETY NET that runs AFTER the LLM-based normalization check (Step 4.6).
When normalization batches fail (honesty score too low, timeout, exception), their
unlinked _id columns are left behind. This function catches them using ENDS-WITH
PK matching — NO LLM calls, NO batches that can fail.

FK NAMING RULE: FK columns do NOT need to exactly match the target table name.
They MUST END WITH the target table's PK. This supports descriptive prefixes:
  - driver_employee_id  → ends with employee_id  → links to employee table
  - source_warehouse_id → ends with warehouse_id → links to warehouse table
  - billing_address_id  → ends with address_id   → links to address table

Algorithm:
1. Build a PK reverse lookup: pk_value -> domain.table (e.g., employee_id -> workforce.employee)
2. Sort PK values by length DESCENDING (longest first to avoid false matches)
3. Scan all attributes for unlinked _id columns (ending in pk_suffix, no foreign_key_to)
4. For each unlinked column, check if it ENDS WITH any known PK value
5. Prefer longest PK match, then same-domain match
6. Skip self-references and bidirectional links

Returns:
    int: number of FKs linked
```

### `Function: _post_normalization_verification`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Post-normalization verification: count and log all remaining unlinked _id columns.
This provides visibility into what the normalization step + deterministic linker missed.
```

### `Function: _postprocess`
- **Lines of Legacy Code:** 35
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _postprocess_subdomain_allocations`
- **Lines of Legacy Code:** 140
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _pre_static_analysis_autofix`
- **Lines of Legacy Code:** 486
- **Role in New Architecture:** Autofixer / Finding Execution
- **Rules Enforced:** ATT-RUL-017, G10-R012, REL-RUL-002, REL-RUL-004, REL-RUL-005
- **Observability Aliases (Must be preserved):** PRE-FIX][self-ref-banned-prefix-autorename, prefix-strip-reserved-word-guard, prefix-strip-reserved-word-guard"), self-ref-banned-prefix-autorename
- **Legacy Documentation:**
```text
# G10-R012, REL-RUL-002, REL-RUL-004, REL-RUL-005, ATT-RUL-017

Pre-static-analysis auto-fix pass.
Fixes trivially fixable issues BEFORE static analysis runs, so the next vibe
only reflects genuinely remaining issues — NOT issues caused by pipeline laziness.

Fixes:
1. FK type mismatches (FK column type != PK type) - sync FK type to PK type
2. Incomplete FK refs (domain.product without column) - append PK column name
3. column_name != attribute name mismatches - sync column_name to attribute name
4. Missing column_name - set to attribute name
5. Dangling FK refs to non-existent tables - clear the FK
6. Self-referencing FKs - clear the FK
7. FK PK column mismatch - fix to actual PK
8. Embedded FK/tag metadata in type field - extract to proper fields
9. Duplicate attributes within products - keep most complete version

counter reset hardening.
This pass is invoked up to THREE times per modeling run (after Step 3.7
architect review, after Step 7 QA, and before physical schema emission —
see P0.55). Every per-pass counter used below (``_p024_pk_self_fk_cleared``,
``_p025_added``, ``_p026_removed_count``, ``_ambig_rename_count``,
``_p016_groups_scanned``, ``_p016_groups_with_generics``, etc.) MUST be
declared as a LOCAL variable inside this function body so each call starts
at zero. DO NOT promote any of these to module scope — that would make the
[AUTOFIX-SUMMARY] line monotonically accumulate across calls and the
summary would stop being a per-pass signal. A grep confirms no ``_p\d+_``
globals exist at module scope.
```

### `Function: _pre_static_analysis_llm_relink`
- **Lines of Legacy Code:** 71
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_BATCH_RESOLVE_PROMPT
- **Legacy Documentation:**
```text
LLM-based final pass to resolve remaining unlinked FK columns before static analysis.
Uses FK_BATCH_RESOLVE_PROMPT to semantically match unlinked _id columns to tables.
Only runs if there are unlinked FK columns remaining after all pipeline steps.
```

### `Function: _precheck_read`
- **Lines of Legacy Code:** 100
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _precompute_attr_count_by_product`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _precompute_attr_index`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _preseed_rename_maps`
- **Lines of Legacy Code:** 70
- **Role in New Architecture:** Autofixer / Finding Execution
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
scan ALL rename mutations BEFORE applying any mutation so
later modifies/removes can resolve either the pre-rename OR post-rename
reference from mutation 0.

The previous behaviour only populated the rename maps WHEN the engine
applied the rename. If the LLM ordered a ``modify product rename`` FIRST
and a dependent ``modify attribute on renamed product`` later (order
reversed from the topological sort guarantee), and the architect had
already performed the rename directly in an earlier pipeline stage, the
modify lookup resolved against the wrong key space and silently dropped.
Preseeding lets the resolver handle both sides from the start.

Rename detection: a mutation is a rename when operation == 'modify' AND
field == entity_type (e.g. ``field='product'`` on an ``entity_type='product'``
modify). Returns three dicts: domain, product, attribute rename maps
keyed the same way the main apply function uses them.
```

### `Function: _preserve_baseline_metric_views_for_surgical`
- **Lines of Legacy Code:** 128
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** surgical-mv-preserve, surgical-mv-preserve"), surgical-mv-rewrite, surgical-mv-rewrite"
- **Legacy Documentation:**
```text
(alias: surgical-mv-preserve FIRED) — surgical fast path
skips Step 8d (metric-view generation), which previously caused all 92
metric_views to be dropped from v2's model.json.

(alias: surgical-mv-rewrite FIRED) — the original 
helper conservatively dropped any MV whose owner_product OR any referenced
product was renamed by surgical mutations (e.g. customer.case →
customer.customer_case). On a real vov run this would still drop ~all
baseline MVs because surgical mutations RENAME, not delete, products.
adds a SQL rename-rewriter:
  1. Read v1 model.json → metric_views AND v1 products list.
  2. Diff v1 vs v2 product (domain, product) sets → infer rename map by
     qualified-rename heuristic (`_p074_qualified_rename`) and stem
     match (substring + suffix), industry-agnostic.
  3. Rewrite each MV's SQL: substitute every `<old_d>.<old_p>` →
     `<new_d>.<new_p>` (with backtick variants, case-insensitive).
  4. Re-validate refs against v2 products; preserve if all refs resolve,
     else drop with logged reason.
Always emits a [surgical-mv-preserve FIRED] line regardless of outcome
so audits can prove the helper executed.
```

### `Function: _preserve_boundaries`
- **Lines of Legacy Code:** 21
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _print_success_banner`
- **Lines of Legacy Code:** 33
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _process_ambiguous_fk_batch`
- **Lines of Legacy Code:** 93
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _process_batch_task`
- **Lines of Legacy Code:** 68
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Worker function to process a single batch task.
```

### `Function: _process_broken_fk_batch`
- **Lines of Legacy Code:** 97
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_BROKEN_RESOLVE_PROMPT

### `Function: _process_cycle_batch_with_retry`
- **Lines of Legacy Code:** 116
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_CYCLE_BREAK_PROMPT

### `Function: _process_domain`
- **Lines of Legacy Code:** 217
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** QUALITY_DOMAIN_FIT_PROMPT

### `Function: _process_domain_pair`
- **Lines of Legacy Code:** 347
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_PAIRWISE_LINK_PROMPT
- **Legacy Documentation:**
```text
Worker function to process a single domain pair - makes LLM call.
```

### `Function: _process_many_to_many_relationships`
- **Lines of Legacy Code:** 67
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_MANY_TO_MANY_PROMPT
- **Legacy Documentation:**
```text
Process potential Many-to-Many relationships detected during linking.

For each M:N candidate:
1. Validate with FK_MANY_TO_MANY_PROMPT
2. If validated, create the association product
3. Create FK links from association to both parent products
4. Move relationship attributes from parent products to association

Args:
    m2m_candidates: list of potential M:N relationships from linking steps
    domains_data: list of domain dicts
    products_data: list of all products (will be modified in place)
    attributes_data: list of all attributes (will be modified in place)
    pk_map: dict mapping "domain.product" to PK info
    logger: logger instance
    ai_agent: AIAgent instance
    config: configuration dict

Returns:
    tuple: (associations_created: int, associations_rejected: int)
```

### `Function: _process_one_mv15_batch`
- **Lines of Legacy Code:** 154
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fk-semantic-gate-no-keyerror, perf-mv15-parallel
- **Prompts Used:** FK_SEMANTIC_CORRECTNESS_GATE_PROMPT

### `Function: _process_relink_resolutions`
- **Lines of Legacy Code:** 48
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _process_small_tables_for_domain`
- **Lines of Legacy Code:** 256
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** PRODUCT_MERGE_SMALL_PROMPT
- **Legacy Documentation:**
```text
Worker function to get LLM decisions for a domain's small tables.
```

### `Function: _product_collision_sanity_check`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
verify product-name collision guard.

INVARIANTS:
  - Domain-name collision is detected & renamed.
  - Cross-domain duplicate is detected & renamed (later occurrence).
  - FK references are propagated after rename.
  - Idempotent: running twice on cleaned data produces zero changes.
  - `_p074_qualified_rename` is industry-agnostic (no hard-coded names).
```

### `Function: _product_gen_progress`
- **Lines of Legacy Code:** 448
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _product_has_inbound_cross_fk`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** cost-cross-fk-detect"""
- **Legacy Documentation:**
```text
Return True if any attribute (in any product, including other domains) has a
foreign_key_to pointing INTO {target_domain}.{target_product}.*. Read-only structural
inspection; industry-agnostic. alias=cost-cross-fk-detect
```

### `Function: _products_data_lookup`
- **Lines of Legacy Code:** 265
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _proof`
- **Lines of Legacy Code:** 203
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** "evidence"] = "[fidelity-count-soft-pass, fidelity-count-soft-pass)

### `Function: _protected_targets_from_widgets`
- **Lines of Legacy Code:** 49
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** protected-targets, protected-targets"""
- **Legacy Documentation:**
```text
[protected-targets FIRED alias=protected-targets] return the
set[str] of user-protected targets (lowercased) for stage-scoped FindingDispatcher
construction. Honours §3b (business_domains widget verbatim) and §3c (must_have_data_products
widget verbatim) — these targets are protected from non-user_vibe findings at the
dispatcher level. Reads widgets first, then PROMPT_VARIABLES.business_config as fallback.
Industry-agnostic — pure string parsing; never names a vertical. alias=protected-targets
```

### `Function: _query_scope_data_from_db`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _quick_deterministic_check`
- **Lines of Legacy Code:** 40
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _raw_answer`
- **Lines of Legacy Code:** 51
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _re_derive_column_name`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _re_derive_pk`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _re_derive_table_name`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _read_json_for_sync`
- **Lines of Legacy Code:** 84
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _rec_write`
- **Lines of Legacy Code:** 50
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _record_success`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _record_timeout`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _recover_model_data_from_volume`
- **Lines of Legacy Code:** 52
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Attempt to recover domain/product/attribute data from the data_model JSON file
stored in the volume when the metamodel tables are missing data.
Returns True if recovery succeeded.
```

### `Function: _recovery_read`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _recursive_files`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _recursive_list_files`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _reduce_domain_products`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _reduce_product_attributes`
- **Lines of Legacy Code:** 121
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _regex_cleanup_sanity_check`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
W7: verify the typed-column / oversize-enum regex cleanup.

Build a mock attribute list with:
  - 5 typed-col value_regex (should be cleared).
  - 2 oversize-enum value_regex with > 6 alternatives (should be cleared
    and description annotated).
  - 1 valid STRING phone regex (should be preserved unchanged).
Run _pre_static_analysis_autofix and assert the counts + annotations.
```

### `Function: _remove_products_and_attributes`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
DRY helper: Removes products and their attributes from the data lists in-place.
Returns (products_removed_count, attributes_removed_count).
```

### `Function: _remove_stream_handlers`
- **Lines of Legacy Code:** 54
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _rename_self_fk_on_pk`
- **Lines of Legacy Code:** 48
- **Role in New Architecture:** Autofixer / Finding Execution
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** sa-autofix-self_fk_on_pk, sa-autofix-self_fk_on_pk")
- **Legacy Documentation:**
```text
[sa-autofix-self_fk_on_pk FIRED]
When an FK column shares the PK column name (e.g. `awb.mawb_id` where PK is
`awb_id`), auto-rename the FK to a descriptive prefix. Industry-agnostic —
derives the prefix from the FK target product name.
```

### `Function: _render_action_vocab_block`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** V075_RETIRE_V074_VOCAB"""
- **Legacy Documentation:**
```text
Backward-compatible alias for render_master_action_catalog. New code
should call render_master_action_catalog directly. alias=V075_RETIRE_V074_VOCAB
```

### `Function: _render_metric_sql_for_domain_from_llm_spec`
- **Lines of Legacy Code:** 369
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** Metrics][LLM] [metric-view-joins-render, Metrics][LLM] [mv-joins-disabled-pending-syntax-fix, Metrics][LLM] [mv-spec-whitelist-tables, Metrics][LLM] [mv-valid-columns-merge-joins, Metrics][LLM] [mv-yaml-no-type-field, Metrics][LLM][joins] [mv-joins-alias-normalize, domain-to-db-from-config, domain-to-db-from-config), metric-view-dedup-domain-prefix, metric-view-joins-global-lookup, metric-view-joins-render, metric-views-no-char-iter"), mv-joins-alias-normalize, mv-joins-alias-normalize"), mv-joins-disabled-pending-syntax-fix, mv-joins-disabled-pending-syntax-fix), mv-joins-expr-alias-rewrite, mv-joins-reenabled, mv-spec-whitelist-tables"), mv-spec-whitelist-tables), mv-valid-columns-merge-joins, mv-valid-columns-merge-joins"), mv-valid-columns-merge-joins), mv-yaml-no-type-field, mv-yaml-no-type-field), valid-joins-init-unconditional, valid-joins-init-unconditional)
- **Legacy Documentation:**
```text
`records_out` (optional list) is appended with authoritative
ownership records ``{view_name, owner_domain, owner_product, sql,
description, dimensions_count, measures_count}`` captured AT CREATION TIME.
Callers that need ownership metadata pass a list; legacy callers pass None
and get just the SQL statements back via the return value.
```

### `Function: _render_previous_reviews_context`
- **Lines of Legacy Code:** 52
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Render a human-readable summary of prior architect-review iterations.

Each entry in ``prior_iterations`` is a dict with keys:
  - iteration_number: int
  - gates: dict[gate_name] -> "Yes"/"No"/"" (trust/support/peers/standard)
  - summary: str (assessment.summary narrative)
  - blockers: list[str]
  - actions: list[str]

Returns the empty string when ``prior_iterations`` is falsy so the prompt
block collapses naturally. When filled, it renders the format described in
the task spec so the next iteration can re-judge whether its own concerns
are now resolved in the freshly-mutated model.
```

### `Function: _render_vibe_audit_report_md`
- **Lines of Legacy Code:** 97
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Render the JSON audit data as a Markdown report mirroring the canonical
per-VREQ scorecard format (industry-agnostic).
```

### `Function: _repair_json_string`
- **Lines of Legacy Code:** 134
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _repl`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _repl2`
- **Lines of Legacy Code:** 119
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** jobtags-metrics-install-count, mv-stale-catalog-rewrite, mv-stale-catalog-rewrite")

### `Function: _resolve_ambiguous_fks_with_llm`
- **Lines of Legacy Code:** 39
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Use LLM to resolve ambiguous FK relationships where the FK name matches tables in multiple domains.
Batches FKs into chunks of ~75 per LLM call and processes them in parallel.
```

### `Function: _resolve_boolean_type`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _resolve_broken_fk_columns_with_llm`
- **Lines of Legacy Code:** 98
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Use LLM to resolve broken FK column references where the FK points to a non-existent column.
Batches FKs into configurable chunks and processes them in parallel to avoid LLM timeouts.
```

### `Function: _resolve_business_scratch_path`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _resolve_cat`
- **Lines of Legacy Code:** 251
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _resolve_catalog_for_domain`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _resolve_fidelity_gates`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _resolve_managed_location`
- **Lines of Legacy Code:** 44
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Single source of truth for Default-Storage MANAGED LOCATION discovery.
Returns the storage root URL (abfss/s3/gs) from:
  (1) DESCRIBE METASTORE if accessible
  (2) Any accessible existing catalog's storage_root (excluding system catalogs)
  (3) "" (caller falls through to bare CREATE CATALOG).
(alias: managed-location-accessibility-check) — every candidate
storage_root is now validated with _validate_storage_accessible() before being
returned, so we never hand back an External Location the caller can't read.
Used by agent._ensure_catalog_exists, runner.ensure_install_catalog, and vibe_tester.
```

### `Function: _resolve_master_action_catalog_for_prompt`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** master-catalog-scope-filtered
- **Legacy Documentation:**
```text
[master-catalog-scope-filtered FIRED alias=master-catalog-scope-filtered] —
Architect prompts focus on strategic actions (scope ∈ domain/product/model);
Vibe-audit + next-vibes prompts get the full catalog because they are user-
facing and may need any action. Token + LLM-confusion mitigation per
Risk-1 from the architectural critique.
```

### `Function: _resolve_naming_convention`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _resolve_price_for_model`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _resolve_product_key`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Given 'domain.product', return current key after applying domain+product renames.
```

### `Function: _resolve_rollout_mode`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _resolve_sample_catalog_db`
- **Lines of Legacy Code:** 186
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _resolve_table_key`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _resolve_user_model_json_path`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _resolve_vibes_from_file`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _retry_delta_write`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _rewrite_column_refs_in_expr`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _rewrite_expr`
- **Lines of Legacy Code:** 134
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** Metrics][ColCheck] [mv-cross-table-measure-drop, Metrics][LLM] [mv-joins-expr-alias-rewrite, Metrics][TypeCheck] [mv-cross-table-measure-drop, mv-cross-table-measure-drop)"), mv-joins-expr-alias-rewrite")

### `Function: _rewrite_multi_sum_to_single_sum`
- **Lines of Legacy Code:** 34
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _rewrite_sql_via_rename_map`
- **Lines of Legacy Code:** 25
- **Role in New Architecture:** Autofixer / Finding Execution
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _rewrite_stmt`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _rewrite_unresolved_columns`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
If metric DDL failed with UNRESOLVED_COLUMN, parse Spark's 'Did you mean X?' suggestion
and rewrite the stale column name in the SQL. Handles cases where AUTOFIX renamed bare columns
(status -> leg_status) but the metric view SQL was generated with the old name.
Allow mixed-case column names (camelCase, PascalCase) and match by normalized form
(lowercase no-underscore) so snake_case↔camelCase naming-convention drift is auto-repaired.
Returns rewritten SQL or None if we can't infer a rewrite.
```

### `Function: _rewrite_via_describe`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Q6 (alias: metric-view-bare-via-describe) — DESCRIBE-driven prefixed rewrite.
Bug observed in Airlines run: 8/79 metric views failed at DDL apply with
UNRESOLVED_COLUMN on bare 'status' / 'type'. Spark's 'Did you mean' list returns only
the top-N closest matches (by edit distance), so a real '*_status' or '*_type' column
on the same physical table is often invisible to _rewrite_unresolved_columns. This
helper queries the actual table schema via DESCRIBE TABLE and searches for a
'<anything>_<bare>' suffix match. If exactly one is found, rewrite. If multiple,
prefer the one whose prefix shares the most token-overlap with the table name.
Returns rewritten SQL or None if we can't infer a rewrite.
```

### `Function: _rm_pfx`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _rm_sfx`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _rm_tag`
- **Lines of Legacy Code:** 42
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _rm_tag`
- **Lines of Legacy Code:** 1248
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _rollback_delete`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _row`
- **Lines of Legacy Code:** 110
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _run_bulk_drop_batch`
- **Lines of Legacy Code:** 153
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** VIBE_DROP_PROMPT, VIBE_PRUNE_PROMPT

### `Function: _run_cross_domain_linking_smart_worker`
- **Lines of Legacy Code:** 68
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Smart Worker for Step 6: Cross-Domain Linking
Uses Generate -> Validate -> Feedback -> Retry loop globally.
Ensures no domain is siloed.

Args:
    domains_data: list of domain dicts
    products_data: list of all products
    attributes_data: list of all attributes (will be modified in place)
    pk_map: dict mapping "domain.product" to PK info
    logger: logger instance
    ai_agent: AIAgent instance
    config: configuration dict

Returns:
    tuple: (links_created: int, errors: list)
```

### `Function: _run_deploy_model`
- **Lines of Legacy Code:** 108
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** install-audit-mirror-multisource, install-audit-mirror-multisource), logger-propagate-fired
- **Legacy Documentation:**
```text
Standalone install model function - completely independent of business_context.
Reads everything from Model Folder, no metamodel database operations.
Uses shared: read_file_for_ddl, detect_catalog_from_sql, replace_catalog_in_sql, parse_sql_statements.
```

### `Function: _run_deterministic_fk_linking`
- **Lines of Legacy Code:** 185
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Runs a deterministic, rule-based pass to link foreign keys based on ENDS-WITH PK matching.
It uses the 'pk_map' (derived from the product.primary_key column) as the 
source of truth for what a Primary Key is.

FK NAMING RULE: FK columns MUST END WITH the target PK name. This supports
descriptive prefixes like driver_employee_id -> employee_id, billing_address_id -> address_id.

It finds attributes in the attr_table that:
1. Have a name that ENDS WITH a PK in the pk_map (with optional prefix separated by underscore).
2. Are NOT themselves a PK (according to the pk_map).
3. Are not already linked to something.
```

### `Function: _run_deterministic_fk_linking_file_based`
- **Lines of Legacy Code:** 174
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** REL-RUL-002, REL-RUL-010, REL-RUL-012, REL-RUL-017
- **Legacy Documentation:**
```text
# REL-RUL-010, REL-RUL-002, REL-RUL-017, REL-RUL-012

File-based version of deterministic FK linking.
ONLY links FKs within the same domain to avoid ambiguous cross-domain matches.
Cross-domain linking requires LLM validation.
Updates attributes_data in place.
```

### `Function: _run_deterministic_silo_pk_linking`
- **Lines of Legacy Code:** 112
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Deterministic silo recovery with semantic validation.

Two passes:
  Pass 1 (same-domain, exact PK match): Highest confidence — same domain guarantees semantic relevance
  Pass 2 (cross-domain or product-name match): Only if semantic check passes

Ambiguity guard: Generic PKs (type_id, status_id, category_id) require same-domain match
or explicit product-name presence in the attribute name/description.
```

### `Function: _run_domain_generation_variant`
- **Lines of Legacy Code:** 158
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** ensemble-singleshot-fallback, ensemble-singleshot-fallback", ensemble-singleshot-fallback), ensemble-singleshot-fallback-crashed", ensemble-singleshot-fallback-failed"
- **Legacy Documentation:**
```text
Run a single domain generation variant with specific model/temperature.
```

### `Function: _run_find_missing_fk_links`
- **Lines of Legacy Code:** 67
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Investigates ALL unlinked _id columns by asking the LLM to classify each as:
LINK (to existing table), CREATE (missing table), DROP (hallucination), or KEEP_AS_IS (external ID).
Processes per-domain for manageable LLM context.
Returns dict with counts of each decision type.
```

### `Function: _run_fmfl_for_domain`
- **Lines of Legacy Code:** 38
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _run_foreign_key_anomaly_review`
- **Lines of Legacy Code:** 78
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _run_generate_samples`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Generate sample data for an existing deployed model.
Reads all model metadata from the deployed _metamodel tables (business,
domain, product, attribute) — no dependency on model.json or any other
file artefact.  Only requires `deployment_catalog`.
```

### `Function: _run_in_domain_linking_smart_worker`
- **Lines of Legacy Code:** 108
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Smart Worker for Step 5: In-Domain Linking
Uses Generate -> Validate -> Feedback -> Retry loop for each domain.

For domains with > _P070_CHUNK_SIZE products, we split the
domain into chunks of ≤_P070_CHUNK_SIZE products and invoke the linker
once per chunk (chunk-local prompt only sees that chunk's products).
Then we run a bounded number of cross-chunk pair unions to catch links
that span chunks. FKs are deduplicated across chunk results.

Args:
    domain_data: dict with 'domain' and 'description' keys
    products_data: list of all products
    attributes_data: list of all attributes (will be modified in place)
    pk_map: dict mapping "domain.product" to PK info
    logger: main logger
    ai_agent: AIAgent instance
    config: configuration dict
    thread_safe_logger: optional thread-safe logger for concurrent execution
    existing_links: optional list of existing FK links to preserve (for vibe mode)

Returns:
    tuple: (links_created: int, errors: list, m2m_candidates: list)
```

### `Function: _run_m2m_validation`
- **Lines of Legacy Code:** 211
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_MANY_TO_MANY_PROMPT, M_PROMPT

### `Function: _run_metamodel_population`
- **Lines of Legacy Code:** 44
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Thread 1: Populate _metamodel database.
```

### `Function: _run_next_vibes_parallel`
- **Lines of Legacy Code:** 194
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _run_one`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _run_one_domain`
- **Lines of Legacy Code:** 220
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** arch-domain-skip-empty-quietly"), arch-domain-skip-empty-quietly), architect-dispatcher
- **Prompts Used:** DOMAIN_ARCHITECT_REVIEW_PROMPT

### `Function: _run_pairwise_silo_remediation`
- **Lines of Legacy Code:** 130
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Attempts to link siloed products to other domains using pairwise comparison.
A siloed table has NO incoming FKs AND NO outgoing FKs (completely disconnected).
Stops after first successful match for each siloed table.
Returns number of links created.
```

### `Function: _run_parallel_artifacts`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Run artifact generation steps in parallel with error collection and join timeout.
```

### `Function: _run_physical_model_creation`
- **Lines of Legacy Code:** 157
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Create physical model (databases, tables, FKs, tags, metrics) entirely from model.json.
```

### `Function: _run_post_linking_fk_validations`
- **Lines of Legacy Code:** 160
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
SINGLE SOURCE OF TRUTH for post-linking FK validations (Steps 7E-7H).
Extracted from step_create_logical_schema to reduce its size.

Performs:
- 7E: FK reference validation (auto-fixes broken FKs)
- 7F: Domain isolation validation (remediation for isolated domains)
- 7G: FK column existence validation (adds missing FK columns)
- 7H: FK attribute domain/product correction
```

### `Function: _run_prune_batch`
- **Lines of Legacy Code:** 2777
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** model-checkup-sa-autofix-call, model-checkup-sa-autofix-call-error")
- **Prompts Used:** FK_COLUMN_RENAME_PROMPT, IMPORT_CSV_PROMPT, QA_ESTIMATE_ROWS_PROMPT, QA_GENERATE_DESCRIPTIONS_PROMPT, QA_INDUSTRY_TEMPLATE_PROMPT, QA_SUGGEST_TABLES_PROMPT, VIBE_DROP_PROMPT, VIBE_DROP_RELEVANCE_PROMPT, VIBE_PRUNE_PROMPT

### `Function: _run_psr_batch`
- **Lines of Legacy Code:** 99
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_BATCH_RESOLVE_PROMPT

### `Function: _run_relink_batch`
- **Lines of Legacy Code:** 119
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_BATCH_RESOLVE_PROMPT

### `Function: _run_resize_model`
- **Lines of Legacy Code:** 44
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Seed a resize operation: shrink ecm→mvm or enlarge mvm→ecm.

This function ONLY handles the resize-specific LLM analysis (which domains/products
to keep/remove/add). It then seeds the results into widgets_values as review_base_*
data, letting the standard pipeline (step_create_logical_schema → naming → physical
→ consolidate → artifacts) handle attribute generation, enrichment, linking, QA,
normalization, release notes, and metamodel writes.

direction: "shrink" or "enlarge"
```

### `Function: _run_serial_statements_for_table`
- **Lines of Legacy Code:** 230
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Runs serially for a single table. Retries each statement.
Returns a list of statements that ultimately failed.
Uses timeout to prevent hanging. Tracks with GCM.
```

### `Function: _run_single_batch`
- **Lines of Legacy Code:** 57
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_BATCH_RESOLVE_PROMPT
- **Legacy Documentation:**
```text
Run a single batch of FK resolution.
```

### `Function: _run_single_norm_batch`
- **Lines of Legacy Code:** 78
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _run_sql`
- **Lines of Legacy Code:** 69
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _run_step`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _run_tag`
- **Lines of Legacy Code:** 162
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _run_tc_batch`
- **Lines of Legacy Code:** 871
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** ddl-skip-duplicate-column-names), ddl-skip-duplicate-column-names)")

### `Function: _run_undeploy_model`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _run_with_progress`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _safe_as_completed`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _safe_copy_local_to_dbfs`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Copies a local driver file to a DBFS/Volumes destination.

Strategy order (thread-safe first, no stdout interference):
  1. WorkspaceClient SDK files.upload — no stdout side-effects, API-based
  2. dbutils.fs.put — works on all compute types for UC Volumes
  3. dbutils.fs.cp — works on classic compute only (file: scheme blocked on shared/serverless)

Returns (success: bool, method: str, error: str|None)
```

### `Function: _safe_format_prompt`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _safe_future_result`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _safe_get`
- **Lines of Legacy Code:** 390
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** agent-version-mirror, agent-version-mirror"), glossary-backfill, tag-persist-pii, vibe-metadata-honest, vibe-metadata-honest"), vibe-metadata-honest)

### `Function: _safe_json_str`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _safe_load_json`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _safe_notebook_exit`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _safe_remove_redundant_column`
- **Lines of Legacy Code:** 58
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Safely remove a redundant column while updating any FK references that point to it.

**CONFLICT PREVENTION:**
- Checks config['_normalization_processed_attrs'] to see if this column was already processed
- If already processed by normalization check, skips removal to avoid duplicate operations

Args:
    domain: Domain name of the column being removed
    product: Product name of the column being removed
    col_to_remove: Attribute name to remove
    replacement_attr: The new FK attribute name that replaces this column (or None)
    replacement_fk_target: The FK target path that the replacement points to (e.g., domain.product.pk)
    attributes_data: List of all attributes (modified in place)
    logger: Logger instance
    config: Optional config dict to check for already-processed attributes
    
Returns:
    tuple: (was_removed: bool, fk_refs_updated: int)
```

### `Function: _safe_volume_flush`
- **Lines of Legacy Code:** 65
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** log-no-truncate-on-success", r3-sentinels-to-volume)

### `Function: _safe_widget`
- **Lines of Legacy Code:** 68
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fidelity-bypass-widget-live

### `Function: _sample_boolean`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sample_boolean`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sample_enum`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sample_helpers_sanity_check`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Exercise every sample-generation bucket and assert expected Python types.

IMPORTANT: this harness re-implements the nested helpers (`_sample_temporal`,
`_sample_numeric`, `_sample_boolean`, `_sample_pool`, `_assemble_rows_from_pools`)
AS THEY LIVE INSIDE `_generate_and_insert_samples_for_product`. If you change
one side, change the other — intentional duplication keeps the smoke check
free of Spark/Databricks coupling.
```

### `Function: _sample_numeric`
- **Lines of Legacy Code:** 54
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sample_numeric`
- **Lines of Legacy Code:** 41
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sample_pool`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sample_pool`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sample_temporal`
- **Lines of Legacy Code:** 32
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sample_temporal`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sanitize_cached`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sanitize_metric_measure_expr`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Normalize LLM metric expressions without mutating SQL semantics.
The previous implementation token-casted SQL keywords/functions and produced
invalid output such as CAST(ROUND AS DOUBLE)(...), which breaks metric view YAML.
```

### `Function: _sanitize_metric_stmt_nested_agg`
- **Lines of Legacy Code:** 2
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sanitize_tag`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Sanitize a Databricks job tag key or value so it matches the API
regex ``^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$``.

Replaces spaces and illegal characters with ``_``, collapses
consecutive ``_``, and strips leading/trailing non-alphanumeric
characters.  Returns ``""`` (allowed by the regex) if nothing
remains.
```

### `Function: _sanitize_tag_key`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sanitize_tag_key_j`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _scope_clause`
- **Lines of Legacy Code:** 1077
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** shrink-cascade-fallback-crashed", shrink-cascade-fallback-crashed):, shrink-cascade-iterate, shrink-cascade-iterate", shrink-cascade-iterate).", shrink-fk-densest-fallback, shrink-fk-densest-fallback", shrink-fk-densest-fallback)., shrink-fk-densest-fallback).", shrink-fk-densest-fallback-crashed", shrink-fk-densest-fallback-crashed):, shrink-fk-densest-fallback-empty):, shrink-fk-densest-fallback-empty-cascade):, shrink-input-silo-pass-through", shrink-input-silo-pass-through), shrink-llm-malformed, shrink-llm-malformed"), shrink-llm-malformed-summary, shrink-orphan-drop, shrink-orphan-drop", shrink-orphan-drop-cascade, shrink-orphan-drop-cleared, shrink-orphan-drop-cleared", shrink-orphan-drop-emptied, shrink-phantom-drop, shrink-phantom-drop"
- **Prompts Used:** RESIZE_ENLARGE_DOMAIN_PROMPT, RESIZE_SHRINK_DOMAIN_PROMPT

### `Function: _score_and_split`
- **Lines of Legacy Code:** 1062
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _search_prefix_in_text`
- **Lines of Legacy Code:** 26
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _select_model_for_requirement`
- **Lines of Legacy Code:** 27
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _separate_user_and_system_vibes`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Separates user-authored vibe instructions from system-generated REMEDIATION text.
Returns (user_vibes, system_vibes) tuple.

System-generated vibes start with markers like 'REMEDIATION MODE' or '--- MUST DO ---'.
User vibes are the original instructions the customer typed.
```

### `Function: _set_prop`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _set_tag_prop`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sever_fk_progress`
- **Lines of Legacy Code:** 163
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sg_log_write`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _should_process_table`
- **Lines of Legacy Code:** 55
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Check if table should be processed based on scope and skip list.
```

### `Function: _silo_link_semantic_check`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Validates that linking attr to the siloed table makes semantic sense.
Returns True if the link is semantically plausible.

Checks:
1. Attribute description mentions the siloed product name
2. Attribute name contains the siloed product name (compound FK like order_type_id)
3. Products are in the same domain (strongest signal)
```

### `Function: _smart_generate_attributes_for_product`
- **Lines of Legacy Code:** 68
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Smart Worker for attribute generation per product with validation loop.
```

### `Function: _smart_generate_products_for_domain`
- **Lines of Legacy Code:** 58
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Smart Worker for product generation per domain with validation loop.
```

### `Function: _smart_split`
- **Lines of Legacy Code:** 49
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _snapshot_fk_links`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sort_key`
- **Lines of Legacy Code:** 111
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sort_key`
- **Lines of Legacy Code:** 108
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _spec_for`
- **Lines of Legacy Code:** 135
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _spill_to_disk_if_large`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _split_top_level_add_sub`
- **Lines of Legacy Code:** 40
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sql`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _stable_percent_for_key`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _step_boundary_force_flush`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** step-boundary-flush\n"

### `Function: _strip_baked_catalog_from_model`
- **Lines of Legacy Code:** 26
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _strip_banned_boilerplate`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** sa-autofix-banned_boilerplate_in_output, sa-autofix-banned_boilerplate_in_output")
- **Legacy Documentation:**
```text
[sa-autofix-banned_boilerplate_in_output FIRED]
Strip banned phrases from descriptions/references. Industry-agnostic regex.
```

### `Function: _strip_bare_column_entries`
- **Lines of Legacy Code:** 212
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** mv-fallback-emit-live, mv-fallback-emit-live"), mv-fallback-emit-live)

### `Function: _strip_id_suffix`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _strip_metric_from_view_name`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _strip_redundant_product_prefix`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** sa-autofix-redundant_product_prefix_on_attribute, sa-autofix-redundant_product_prefix_on_attribute")
- **Legacy Documentation:**
```text
[sa-autofix-redundant_product_prefix_on_attribute FIRED]
Rename attributes whose names redundantly start with their product name + '_'.
Skip primary keys (PK pattern is `<product>_id` by design). Industry-agnostic.
```

### `Function: _strip_redundant_value_regex`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** sa-autofix-redundant_value_regex_on_typed_column, sa-autofix-redundant_value_regex_on_typed_column")
- **Legacy Documentation:**
```text
[sa-autofix-redundant_value_regex_on_typed_column FIRED]
Drop value_regex on typed columns (INT/DATE/TIMESTAMP/BOOLEAN/etc.) — type already constrains.
Industry-agnostic.
```

### `Function: _strip_source_product_prefix_in_expr`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _strip_tags_from_prompt_vars`
- **Lines of Legacy Code:** 25
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _strip_trailing_suffix`
- **Lines of Legacy Code:** 45
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
case-insensitive strip of a trailing PK/FK suffix from an
attribute name. Used by NamingConvention refactor sites so we can recompose
a consistent `{base}{suffix}` pair regardless of the incoming case form.

- Strips `suffix`, `_suffix`, suffix.lower(), `_suffix.lower()` — whichever matches.
- Returns "" if the input was empty or consisted solely of the suffix.
```

### `Function: _stub_fail`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _stub_success`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sub`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** Metrics][LLM] [mv-source-product-prefix-rewrite, mv-source-product-prefix-rewrite")

### `Function: _sub_biz`
- **Lines of Legacy Code:** 220
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fidelity-bypass-widget-live

### `Function: _substitute_business_variable`
- **Lines of Legacy Code:** 32
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _suffix_rename`
- **Lines of Legacy Code:** 217
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _suppress_dbutils_stdout`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _sync_fk_type_with_pk`
- **Lines of Legacy Code:** 68
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-010, REL-RUL-003
- **Legacy Documentation:**
```text
# REL-RUL-003, ATT-RUL-010

Helper function to sync FK attribute type with its target PK type.
Returns True if type was updated, False otherwise.

Handles two formats:
1. "domain.product.pk_name" - full path with column name
2. "domain.product" - just table reference (will look up the PK)
```

### `Function: _table_progress`
- **Lines of Legacy Code:** 179
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** '_mv_count_at_handoff']} statements (any divergence will be visible in [jobtags-metrics-install-count, mv-drop-surface

### `Function: _tag_add_pfx`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _tag_add_sfx`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _tag_rm_pfx`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _tag_rm_sfx`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _test`
- **Lines of Legacy Code:** 186
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** perf-cap-16
- **Prompts Used:** ATTRIBUTE_GENERATE_PROMPT, AUDIT_PROMPT, FK_EDGE_SYNTHESIS_PROMPT, FK_LINKING_PROMPT, FK_SEMANTIC_CORRECTNESS_GATE_PROMPT, MODEL_ARCHITECT_REVIEW_PROMPT, NAMING_CONVENTION_PROMPT, NF_PROMPT, PROCESS_FLOW_FK_GATE_PROMPT, QA_DENORMALIZE_PROMPT, QA_ESTIMATE_ROWS_PROMPT, QA_GENERATE_DESCRIPTIONS_PROMPT, QA_INDUSTRY_TEMPLATE_PROMPT, QA_PROMPT, QA_REVERSE_ENGINEER_PROMPT, QA_SUGGEST_ATTRS_PROMPT, QA_SUGGEST_TABLES_PROMPT, RESIZE_ANALYSIS_PROMPT, RESIZE_SHRINK_DOMAIN_PROMPT, SSOT_BLOCK_GATE_PROMPT, TEST_QA_PROMPT, VIBE_MASTER_PROMPT, _GATE_PROMPT, _SYNTHESIS_PROMPT

### `Function: _thread_safe_print`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _to_bool`
- **Lines of Legacy Code:** 257
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _to_convention`
- **Lines of Legacy Code:** 289
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** datatype-name-coercion-autofix, datatype-name-coercion-autofix")

### `Function: _to_dict`
- **Lines of Legacy Code:** 121
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Convert to dictionary (data is always plain Python dicts).
```

### `Function: _to_dict_list`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Convert list of dict objects to list of dicts (data is always plain Python dicts).
```

### `Function: _touches_protected`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _tracked_sample_worker`
- **Lines of Legacy Code:** 172
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _tracked_sql`
- **Lines of Legacy Code:** 78
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _tracked_sql_with_retries`
- **Lines of Legacy Code:** 34
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _trigger_async_flush`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _trim_model_names`
- **Lines of Legacy Code:** 93
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _truncate_large_vars`
- **Lines of Legacy Code:** 331
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** immutable-early-exit", immutable-violation-critical"), {step_name}] [IMMUTABLE-EARLY-EXIT

### `Function: _try_extract_honesty_for_direct_call`
- **Lines of Legacy Code:** 44
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _try_read_and_validate`
- **Lines of Legacy Code:** 72
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _try_reclaim_stale_threads`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _ts`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _ts_print`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _type_is_int`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _type_is_int`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _type_is_numeric`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _undeploy_drop_db`
- **Lines of Legacy Code:** 98
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _unpack_widgets_core`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _update_session_ready`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _val`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _validate_attribute_response`
- **Lines of Legacy Code:** 182
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _validate_domains_quality`
- **Lines of Legacy Code:** 41
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _validate_domains_structural`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _validate_fmfl`
- **Lines of Legacy Code:** 50
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fmfl-auto-coerce-keep, fmfl-auto-coerce-keep", fmfl-canonical-target"

### `Function: _validate_metric_view_count`
- **Lines of Legacy Code:** 27
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _validate_metric_view_ownership`
- **Lines of Legacy Code:** 77
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Fails loud on any metric-view record with missing/invalid ownership.

Args:
    records:        list of dicts with owner_domain / owner_product / view_name / sql.
    domains_data:   list of domain dicts (looks up {name, domain} + products list).
    logger:         project logger.

Returns:
    int — number of records validated.

Raises:
    MetricViewOwnershipError on any failure.
```

### `Function: _validate_new_domain_products`
- **Lines of Legacy Code:** 400
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** arch-gate-tier-aware"), arch-gate-tier-aware), vibe-count-respect-sizing-directives"), vibe-count-respect-sizing-directives)
- **Prompts Used:** PRODUCT_GENERATE_PROMPT

### `Function: _validate_product_list_compliance`
- **Lines of Legacy Code:** 177
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _validate_product_name_collisions`
- **Lines of Legacy Code:** 45
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Detect and fix product-name collisions.

Args:
    domains_data, products_data, attributes_data: pipeline in-memory lists.
    logger: project logger.
    stage_label: "pre-architect" or "post-architect" — used in log marker.
    config: optional pipeline config dict; when present, the autofix output
        is re-canonicalised through apply_convention(naming_convention) so
        renamed products inherit the model's naming style (snake_case,
        PascalCase, camelCase, SCREAMING_CASE). fix —
        without this, NEW-5 stem autofix emitted PascalCase names like
        customer.CustomerAccount into a snake_case model, which downstream
        enforcement would not always re-normalise (notably in surgical mode
        where the enforce_naming_conventions pass is skipped for already-
        named products). Industry-agnostic: the convention is taken from
        config['MODEL_CONVENTIONS']['data_asset_naming_convention'].

Returns:
    dict with counts:
        renamed_domain_collisions: products renamed because they collided
            with a domain name.
        cross_domain_duplicates: cross-domain duplicate names that got
            qualified (one kept unchanged, the other(s) renamed).
        fk_refs_updated: FK references updated to follow a rename.
        rename_map: {old_key: new_key} dict ({dom.prod: dom.NewProd}).
```

### `Function: _validate_products_for_domain`
- **Lines of Legacy Code:** 53
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _validate_storage_accessible`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _validate_subdomain_names`
- **Lines of Legacy Code:** 152
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** SUBDOMAIN_ALLOCATE_PROMPT

### `Function: _validate_vibe_length`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _verify_and_sync_from_memory`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _verify_deterministic`
- **Lines of Legacy Code:** 144
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fidelity-count-soft-pass-deterministic, fidelity-count-soft-pass-deterministic"), fidelity-deterministic-attr-count, fidelity-deterministic-attr-count"), fidelity-deterministic-fk-density, fidelity-deterministic-fk-density")

### `Function: _verify_requirement`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fidelity-count-soft-pass-strategy-agnostic, fidelity-count-soft-pass-strategy-agnostic")

### `Function: _verify_state_diff`
- **Lines of Legacy Code:** 34
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _verify_table`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _verify_via_llm`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _verify_vibe_requirements`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _version_exists`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _version_has_model_data`
- **Lines of Legacy Code:** 30
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _version_is_incomplete`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Check if a version exists but is not 100% complete.
```

### `Function: _vibe_apply_template_to_tables`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _vibe_attr_gen_progress`
- **Lines of Legacy Code:** 468
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _vibe_audit_compute_per_domain_breakdown`
- **Lines of Legacy Code:** 27
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Return per-domain breakdown for the audit report.
{domain: {n_products, n_attributes, n_fks_in, n_fks_out}}.
```

### `Function: _vibe_audit_extract_canonical_keys`
- **Lines of Legacy Code:** 40
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Detect user-named canonical keys from vibe text.
Industry-agnostic. Catches: 'keys are: a, b, c', 'canonical keys: x', 'join keys: y'.
Returns list of canonical key names (lowercased, deduped).
```

### `Function: _vibe_audit_extract_ddl_blocks`
- **Lines of Legacy Code:** 21
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Parse CREATE TABLE / CREATE MATERIALIZED VIEW blocks from vibe text.
Returns list of dicts: [{table, columns: [(col_lc, type_uc)], raw}].
Industry-agnostic: matches any catalog.schema.table or schema.table or table.
```

### `Function: _vibe_audit_extract_glossary_table`
- **Lines of Legacy Code:** 56
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Parse pipe-table style business glossary from vibe text.
Heuristic: header row contains 'Business Data Element' OR 'Term' OR 'Glossary',
rows are pipe-delimited with ID + name + definition columns. Industry-agnostic.
Returns list of dicts: [{id, name, definition}].
```

### `Function: _vibe_audit_extract_hard_counts`
- **Lines of Legacy Code:** 60
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Detect HARD count constraints from vibe free-text.
Industry-agnostic. Catches: 'EXACTLY N <noun>', 'must be N', '(HARD)', 'no more than N'.
Returns dict like {'metric_views': {'count': 3, 'qualifier': 'exactly_hard'}}.
```

### `Function: _vibe_audit_extract_subdomain_hints`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Extract subdomain/domain hints from vibe text + widgets.
Industry-agnostic. Returns list of (identifier, optional_label) tuples.
```

### `Function: _vibe_audit_score_vreq`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Map (category, count) to a 0-100 score for that VREQ.
Severity mapping: warning = -10, error = -25, info = -3 per finding, capped at 0.
```

### `Function: _vibe_audit_walk_model`
- **Lines of Legacy Code:** 51
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Build a unified model index for vibe-audit checks.
Returns dict with keys: products_by_key, attrs_by_product, all_attr_names,
fk_targets (set of target product keys), hub_pks (dict product_key -> pk_col),
domain_names (set), product_names (set), attr_names_lc (set),
model_stats (dict).
```

### `Function: _vibe_domain_enrich_progress`
- **Lines of Legacy Code:** 69
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _vibe_enrich_domain`
- **Lines of Legacy Code:** 48
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Smart Worker for domain enrichment using standard pipeline.
```

### `Function: _vibe_generate_attributes_for_product`
- **Lines of Legacy Code:** 64
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Smart Worker for vibe mode attribute generation - mirrors standard pipeline.
```

### `Function: _vibe_generate_products_for_domain`
- **Lines of Legacy Code:** 57
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Smart Worker for vibe mode product generation - mirrors standard pipeline.
```

### `Function: _vibe_get_system_meta`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _vibe_matches_glob`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _vibe_product_gen_progress`
- **Lines of Legacy Code:** 96
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _vibe_set_entity_tag`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _vibe_set_system_meta`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _view_name_to_domain_key`
- **Lines of Legacy Code:** 146
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** SAMPLE_POOL_PROMPT

### `Function: _volume_log_flush_loop`
- **Lines of Legacy Code:** 76
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** log-no-truncate-on-success", perf-llm-throttle-16, r3-sentinels-to-volume)

### `Function: _w7_is_pipe_enum`
- **Lines of Legacy Code:** 89
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _w7_is_typed_col`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _work`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _would_create_bidirectional_fk`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** REL-RUL-017, REL-RUL-018

### `Function: _would_create_bidirectional_fk_impl`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _would_create_cycle`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _wrapped`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _write_attributes`
- **Lines of Legacy Code:** 35
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _write_domains`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: _write_products`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: acquire`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Acquire a slot for concurrent execution. 

Args:
    timeout: Max seconds to wait. None = use default (1800s for ECM). 0 = non-blocking.
    blocking: If False, return immediately if no slot available.
    
Returns:
    float: Start time if acquired successfully
    False: If timeout expired or non-blocking and no slot available
```

### `Function: acquire`
- **Lines of Legacy Code:** 33
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: add`
- **Lines of Legacy Code:** 36
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: add_product_if_exists`
- **Lines of Legacy Code:** 118
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fk-validator-skip-external-refs)
- **Legacy Documentation:**
```text
Case-insensitive add to products_with_links
```

### `Function: all_catalogs`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: apply_case`
- **Lines of Legacy Code:** 153
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: apply_contract_transforms_to_config`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: apply_convention`
- **Lines of Legacy Code:** 57
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
SINGLE SOURCE OF TRUTH for naming convention conversion.
Accepts ANY input format (snake_case, PascalCase, camelCase, SCREAMING_CASE,
"Space Separated", "hyphen-separated", mixed) and converts to the target convention.

Conventions:
    snake_case:      all_lower_with_underscores
    PascalCase:      EveryWordCapitalized (no separators)
    camelCase:       firstWordLowerThenCapitalized (no separators)
    SCREAMING_CASE:  ALL_UPPER_WITH_UNDERSCORES

Args:
    dedup: If True, removes leading word repetitions (e.g., element_element_id → element_id).
           Set to False for FK attributes to preserve semantic prefixes.
```

### `Function: apply_convention_changes`
- **Lines of Legacy Code:** 268
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: apply_mutation_command`
- **Lines of Legacy Code:** 156
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** remove-fk-handler

### `Function: apply_naming_conventions`
- **Lines of Legacy Code:** 30
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Naming Convention Application (Case Convention ONLY)
ONLY applies case conventions (snake_case, camelCase, etc.) - NO prefixes/suffixes.
All prefix/suffix operations are deferred to step_apply_naming_conventions (Step 8).

Respects domain_naming_overrides from config["MODEL_CONVENTIONS"]["domain_naming_overrides"].
If a domain has an override, entities in that domain use the override convention
instead of the global data_asset_naming_convention.

Returns:
    dict: Summary of naming changes applied
```

### `Function: apply_vibe_authority_overrides`
- **Lines of Legacy Code:** 50
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: apply_vibe_widget_overrides_from_prompt`
- **Lines of Legacy Code:** 64
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: assert_no_blocking`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: assert_no_unfilled_placeholders`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: attrs_by_product`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: audit_all`
- **Lines of Legacy Code:** 90
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** llm-audit-residual, llm-audit-residual")
- **Prompts Used:** VIBE_AUDIT_PROMPT

### `Function: audit_prompt_templates`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: box_bottom`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: box_line`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: box_sep`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: box_title`
- **Lines of Legacy Code:** 410
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** release-notes-md-format

### `Function: box_top`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: build_attrs_by_product`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
SINGLE SOURCE OF TRUTH for building a domain.product -> attributes index.
Replaces 10+ inline defaultdict(list) constructions. Uses diskcache when available.
```

### `Function: build_business_context_section`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Build a rich business context block from config for injection into prompts.
Uses disk cache when USE_DISK_CACHE_BUSINESS_CONTEXT is True (saves memory for ECM scope models).
```

### `Function: build_default_columns`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: build_fidelity_scorecard`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: build_fk_graph`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** REL-RUL-017, REL-RUL-019
- **Legacy Documentation:**
```text
[REL-RUL-017, REL-RUL-019]
SINGLE SOURCE OF TRUTH for building incoming/outgoing FK reference counts.
Replaces 6+ inline defaultdict(int) constructions for FK graph analysis.
Uses diskcache when available.
```

### `Function: build_pk_map`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-048, ATT-RUL-049, REL-RUL-001
- **Legacy Documentation:**
```text
[ATT-RUL-048, ATT-RUL-049, REL-RUL-001]
SINGLE SOURCE OF TRUTH for building primary key maps.
Replaces 10+ duplicated PK map constructions throughout the codebase.
Uses diskcache when available to save memory.
```

### `Function: build_pk_name`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: build_pk_name_from_config`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: build_product_keys_set`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
SINGLE SOURCE OF TRUTH for building the set of 'domain.product' keys.
Replaces 10+ inline set comprehensions. Uses diskcache when available.
```

### `Function: build_products_by_domain`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
SINGLE SOURCE OF TRUTH for building a domain -> products index.
Replaces 15+ inline defaultdict(list) constructions. Uses diskcache when available.
```

### `Function: by_domain`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: calculate_grade`
- **Lines of Legacy Code:** 286
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** jobtags-deleted-job-info-not-warn"), jobtags-deleted-job-info-not-warn)

### `Function: canonicalize_domain_product_casing`
- **Lines of Legacy Code:** 35
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: capture_snapshot`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: capture_vibe_model_snapshot`
- **Lines of Legacy Code:** 59
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Captures a snapshot of the current model state for change tracking.
Returns a deep copy of the state with computed relationships.
```

### `Function: catalog_name`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: check`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: check_no_nesting`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Check that we're not trying to create a nested ThreadPool.
Raises NestedThreadPoolError if nesting is detected.
```

### `Function: classify_action_cost`
- **Lines of Legacy Code:** 35
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** classify-action-cost"""
- **Legacy Documentation:**
```text
Return cost_class (one of ACTION_COST_*) for a specific action application.
Reads MASTER_ACTION_REGISTRY default and overrides for context-sensitive cases
(rename of PK -> REQUIRES_FK_REWIRE; rename of non-key attribute -> LOCAL;
delete of product/domain with inbound cross-FKs -> REQUIRES_FK_REWIRE/FULL_REGEN).
Industry-agnostic; pure structure inspection. alias=classify-action-cost
```

### `Function: classify_attribute`
- **Lines of Legacy Code:** 34
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** G08-R012
- **Legacy Documentation:**
```text
Classifies an attribute into one of: 'history_tracking', 'housekeeping', or 'business'.
```

### `Function: classify_pii_subtype`
- **Lines of Legacy Code:** 33
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: clean_json_response`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: clean_json_response`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: clear_active`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: column_name`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: compare_to_previous`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: compile_vibe_contract`
- **Lines of Legacy Code:** 66
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: create_table_sql`
- **Lines of Legacy Code:** 185
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: create_thread_safe_logger`
- **Lines of Legacy Code:** 32
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Creates a thread-safe logger wrapper using QueueHandler to avoid I/O blocking
in concurrent contexts. The base logger continues to use ImmediateFlushFileHandler
for persistence, but threads write to a queue first.

Args:
    base_logger: The main logger with file/console handlers
    
Returns:
    tuple: (thread_safe_logger, queue_listener) - listener must be started/stopped
```

### `Function: datatype_to_sql`
- **Lines of Legacy Code:** 49
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: debug`
- **Lines of Legacy Code:** 51
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: debug`
- **Lines of Legacy Code:** 2
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: debug`
- **Lines of Legacy Code:** 90
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: debug`
- **Lines of Legacy Code:** 88
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: debug`
- **Lines of Legacy Code:** 59
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: debug`
- **Lines of Legacy Code:** 110
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: debug`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: debug`
- **Lines of Legacy Code:** 87
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: debug`
- **Lines of Legacy Code:** 38
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: decorator`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: deduplicate_attributes_in_place`
- **Lines of Legacy Code:** 44
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Remove duplicate attributes within each product, keeping the most complete version.
Returns number of duplicates removed.
```

### `Function: detect_catalog_from_sql`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: detect_convention_changes`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: dfs`
- **Lines of Legacy Code:** 65
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: disable`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Disable nested ThreadPool detection (use with caution).
```

### `Function: domain_to_catalog_map`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: emit`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: emit_step`
- **Lines of Legacy Code:** 71
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** session-end-status-honest

### `Function: emit_vibe_event`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: enable`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Enable nested ThreadPool detection.
```

### `Function: enforce_configured_pk_consistency`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Enforce one canonical PK per product using configured PK suffix.
```

### `Function: enforce_naming_conventions`
- **Lines of Legacy Code:** 137
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-004, GEN-RUL-004, PRD-RUL-006, PRD-RUL-022
- **Observability Aliases (Must be preserved):** naming-reserved-word-guard, orig-name-tag-removed
- **Legacy Documentation:**
```text
[PRD-RUL-006, ATT-RUL-004, PRD-RUL-022, GEN-RUL-004]
SINGLE SOURCE OF TRUTH for enforcing naming rules:
1. No product should have its domain name as prefix
2. No attribute should have its product name as prefix (except PK)

Cascades ALL downstream effects when a product is renamed:
- Updates product primary_key
- Updates PK attribute name/column_name
- Updates FK column names in child tables referencing the old PK
- Updates foreign_key_to references (both domain.product and PK column parts)

Modifies data in place. Returns count of fixes applied.
```

### `Function: enhance_description_with_source_domains`
- **Lines of Legacy Code:** 129
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: ensure_product_has_pk_attribute`
- **Lines of Legacy Code:** 42
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-048, ATT-RUL-049, ATT-RUL-050, ATT-RUL-055
- **Legacy Documentation:**
```text
[ATT-RUL-048, ATT-RUL-049, ATT-RUL-050, ATT-RUL-055]
SINGLE SOURCE OF TRUTH for ensuring a product has a PK attribute.
Replaces duplicated PK validation/insertion in Steps 7A-0.9 and 7A-1.

Returns True if a PK attribute was added (was missing).
```

### `Function: error`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: error`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: error`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: error`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: error`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: error`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: error`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: error`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: error`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: estimate_cost_usd`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: evaluate_action_against_contract`
- **Lines of Legacy Code:** 25
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: evaluate_fidelity_gates`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: evaluate_scope_leakage`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: execute_alter_table_in_parallel_grouped`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Executes ALTER TABLE statements in parallel, grouped by table, with batch retries.
This is for ADD FOREIGN KEY, which can deadlock if run concurrently on the same table.
Integrates with GlobalConcurrencyManager for centralized control.
```

### `Function: execute_ddl_statements`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: execute_metric_views_in_parallel_no_halt`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: execute_sql`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: execute_sql_in_parallel`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: execute_sql_in_parallel_no_halt`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: execute_sql_with_timeout`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: extract_fk_base_name`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Extract the base name from a FK column name by removing the suffix.

Example with suffix '_id':
- 'customer_id' -> 'customer'
- 'primary_address_id' -> 'primary_address'
- 'billing_address_id' -> 'billing_address'

Note: The base name may contain business qualifiers (primary_, billing_, etc.)
that should be preserved for semantic matching.
```

### `Function: extract_requested_pk_suffix_from_texts`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: extract_vibe_modelling_instructions`
- **Lines of Legacy Code:** 46
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: filter`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: filter_actions_by_contract`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: finalize`
- **Lines of Legacy Code:** 27
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: finalize`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: finalize_instance`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: finalize_pipeline`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: finalize_pipeline_error`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** session-end-status-honest

### `Function: find_product_in_model`
- **Lines of Legacy Code:** 21
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** PRD-RUL-021
- **Legacy Documentation:**
```text
[PRD-RUL-021]
SINGLE SOURCE OF TRUTH for finding a product by name in the model.
Handles case-insensitive matching and optional domain filtering.

Returns: matching product dict or None
```

### `Function: fk_column`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
FK column name. `role` is an optional semantic prefix like 'parent', 'original', 'source'.
```

### `Function: fk_edges`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: flush_pending`
- **Lines of Legacy Code:** 71
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: format_bool`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: format_date`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: format_distributed_vibes_for_prompt`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Formats the distributed vibes for a specific prompt into a human-readable instruction block.
Uses diskcache when available.
```

### `Function: format_duration`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: format_label`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Creates a human-friendly label from a snake_case name.
```

### `Function: format_timestamp`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: from_triple`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: fulfilled_requirements`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: generate_vibe_model_change_log`
- **Lines of Legacy Code:** 196
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Compares initial snapshot with final state and generates a detailed change log.
Returns a dictionary with categorized changes including history tracking and housekeeping columns.
```

### `Function: get`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_attr_sort_key`
- **Lines of Legacy Code:** 125
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_attr_value`
- **Lines of Legacy Code:** 97
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_available_workers`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Get number of workers respecting global limit.
```

### `Function: get_current_notebook_path`
- **Lines of Legacy Code:** 30
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Return the workspace path of the currently running notebook.
```

### `Function: get_current_pool_name`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Get the name of the current ThreadPool (if inside one).
```

### `Function: get_distributed_vibes_for_prompt`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_division_taxonomy`
- **Lines of Legacy Code:** 132
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** G11-R001, G11-R002, G11-R003

### `Function: get_domain_for_table`
- **Lines of Legacy Code:** 64
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Determine domain for a new table based on existing domains and semantic matching.
```

### `Function: get_efficiency_score`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Calculate efficiency score (0-100%) based on success rate and concurrency utilization.
```

### `Function: get_fk_suffix`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** REL-RUL-015
- **Legacy Documentation:**
```text
Get foreign key suffix from config (default: same as PK suffix). [REL-RUL-015]
```

### `Function: get_instance`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_logger`
- **Lines of Legacy Code:** 74
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Sets up a logger that flushes immediately to both console and files.

Creates a temporary directory for local log files and returns the
logger instance and a dict of paths for final artifact movement.
```

### `Function: get_manager_stats_report`
- **Lines of Legacy Code:** 73
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_pinned_text_for_prompt`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_pk_suffix`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-049, G03-R019
- **Legacy Documentation:**
```text
Get primary key suffix from config (default: '_id'). [G03-R019, ATT-RUL-049]
```

### `Function: get_requirements_for_prompt`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** ATTRIBUTE_GENERATE_PROMPT, DOMAIN_ARCHITECT_REVIEW_PROMPT, DOMAIN_GENERATE_PROMPT, FK_BROKEN_RESOLVE_PROMPT, FK_CROSS_DOMAIN_MESH_PROMPT, FK_IN_DOMAIN_LINK_PROMPT, FK_MANY_TO_MANY_PROMPT, FK_PAIRWISE_LINK_PROMPT, MODEL_ARCHITECT_REVIEW_PROMPT, PRODUCT_DUPLICATE_DETECT_PROMPT, PRODUCT_GENERATE_PROMPT, PRODUCT_GLOBAL_DEDUP_PROMPT, PRODUCT_MERGE_SIMILAR_PROMPT, QUALITY_DOMAIN_FIT_PROMPT, QUALITY_NORMALIZATION_PROMPT, RESIZE_ENLARGE_DOMAIN_PROMPT, RESIZE_SHRINK_DOMAIN_PROMPT

### `Function: get_requirements_for_step`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_stats`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Get concurrency statistics with calculated metrics.
```

### `Function: get_stats_summary`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_summary`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_summary_report`
- **Lines of Legacy Code:** 42
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_token_summary`
- **Lines of Legacy Code:** 24
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_vibes_from_config`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: get_widget_values`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: guarded_thread_pool_executor`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Factory function that creates a ThreadPoolExecutor with nested pool detection.
Use this instead of ThreadPoolExecutor directly to ensure flat architecture.

Args:
    max_workers: Maximum number of worker threads
    pool_name: Name for identification in error messages
    logger: Optional logger for warnings

Returns:
    ThreadPoolExecutor instance

Raises:
    NestedThreadPoolError: If called from inside another ThreadPool worker
```

### `Function: handlers`
- **Lines of Legacy Code:** 168
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: hard_constraints`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: has_vibes`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: id_type_spark`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: info`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: info`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: info`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: info`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: info`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: info`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: info`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: info`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: info`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: initialize`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Initialize the concurrency manager with global limits.
```

### `Function: initialize`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: initialize_session`
- **Lines of Legacy Code:** 36
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: insert_business_row`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: insert_deployed_business_row`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: invalidate_cache`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: is_enabled`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: is_inside_thread_pool`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Check if current code is running inside a ThreadPool worker.
```

### `Function: is_potential_fk_column`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-045, REL-RUL-010
- **Legacy Documentation:**
```text
[REL-RUL-010, ATT-RUL-045]
Check if an attribute name looks like a FK column based on configured suffix.

This checks if the column ends with the configured PK suffix, indicating
it's likely a foreign key reference. Example: 'customer_id', 'primary_address_id',
'billing_address_id' all end with '_id' suffix.

Note: Multiple FK columns can reference the same table with business-meaningful names:
- primary_address_id -> address table
- billing_address_id -> address table
- shipping_address_id -> address table
```

### `Function: launch`
- **Lines of Legacy Code:** 112
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Find or create a Databricks job and trigger a new run.

If a job with the given name already exists, its settings (task,
tags) are updated in place and a new run is started.  This avoids
duplicate job entries when the notebook is run repeatedly.

Returns a dict with keys:
    success   (bool)
    job_id    (int | None)
    run_id    (int | None)
    job_name  (str)
    run_name  (str)
    job_url   (str)
    error     (str | None)
    reused    (bool)  — True if an existing job was reused
```

### `Function: list_metric_sql_files_for_version`
- **Lines of Legacy Code:** 25
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: load_and_format_prompt`
- **Lines of Legacy Code:** 50
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** master-action-catalog-auto-inject
- **Prompts Used:** DOMAINS_WORKER_PROMPT
- **Legacy Documentation:**
```text
Loads a prompt from the PROMPT_TEMPLATES dictionary and formats it with variables.
Uses multi-pass substitution so that variable values containing placeholders
(e.g. DOMAIN_PRIORITY_GUIDANCE containing {business}) are fully resolved.

Args:
    prompt_key: The key/name of the prompt in PROMPT_TEMPLATES (e.g., "DOMAINS_WORKER_PROMPT")
    variables: Dictionary of variables to substitute in the prompt
    logger: Logger instance for warnings

Returns:
    Formatted prompt string
```

### `Function: load_previous_version_conventions`
- **Lines of Legacy Code:** 63
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** G08-R012

### `Function: log_observation`
- **Lines of Legacy Code:** 40
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: log_step`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: log_summary`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Log concurrency summary with performance metrics.
```

### `Function: main`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: make_attribute_dict`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-017, G15-R011
- **Legacy Documentation:**
```text
[G15-R011, ATT-RUL-017]
SINGLE SOURCE OF TRUTH factory for creating attribute dicts.
Replaces 20+ inline dict constructions across the codebase.
```

### `Function: make_finding`
- **Lines of Legacy Code:** 27
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** make-finding-shape"""
- **Legacy Documentation:**
```text
Build a canonical FindingShape dict. ALL four stages emit findings in this format
so the FindingDispatcher can route them uniformly.

severity must be one of SEVERITY_MUST_FIX/SEVERITY_SHOULD_FIX/SEVERITY_NICE_TO_HAVE.
severity is ORTHOGONAL to cost_class — a NICE_TO_HAVE FK_REWIRE will defer; a MUST_FIX LOCAL
runs first. Apply order = (severity ASC index, cost ASC index).

provenance must be one of PROVENANCE_* — gates §3b/§3c authority. user_vibe findings are
NEVER blocked by protected-target check; non-user_vibe findings touching user-protected
entities are hard-deferred. alias=make-finding-shape
```

### `Function: make_product_dict`
- **Lines of Legacy Code:** 34
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-049, G15-R010, PRD-RUL-011, PRD-RUL-031, PRD-RUL-032
- **Legacy Documentation:**
```text
[G15-R010, ATT-RUL-049, PRD-RUL-031, PRD-RUL-011, PRD-RUL-032]
SINGLE SOURCE OF TRUTH factory for creating product dicts.
Replaces 9+ inline dict constructions across the codebase.
```

### `Function: map_data_type`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: map_sql_to_xsd`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Maps common SQL data types to XSD types for RDF ranges.
```

### `Function: mark_executing`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: mark_failed`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** det-priority-parse
- **Prompts Used:** VIBE_MASTER_PROMPT

### `Function: mark_fulfilled`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: mark_inside_pool`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Mark current thread as being inside a ThreadPool worker.
```

### `Function: mark_partial`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: master_analyze`
- **Lines of Legacy Code:** 204
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** VIBE_MASTER_PROMPT

### `Function: max_batches`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: max_concurrent`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: max_workers`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Alias for max_batches for compatibility with ThreadPoolExecutor naming.
```

### `Function: metric_view_name`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: migrate_to_model_scope`
- **Lines of Legacy Code:** 44
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
One-time migration: converts existing metamodel DB and volume artifacts from
the legacy model_size (small/large/full/enterprise) naming to the new model_scope (mvm/ecm).

Phases:
  1. DB columns  — model_size → model_scope across all 4 metamodel tables
  2. DB values   — "small" → "mvm", "large"/"full"/"enterprise" → "ecm"
  3. Folders     — v{N}_small → v{N}_mvm, v{N}_large → v{N}_ecm, v{N}_enterprise → v{N}_ecm
  4. File names  — *_small.ext → *_mvm.ext, *_large.ext → *_ecm.ext, *_enterprise.ext → *_ecm.ext
  5. JSON content — model_size keys/values updated in business_context & next_vibes
  6. Location col — business.location paths updated to new folder names

Safe to run multiple times (idempotent). Always run with dry_run=True first.

Usage (in a Databricks notebook cell):
    migrate_to_model_scope("my_catalog", dry_run=True)   # preview
    migrate_to_model_scope("my_catalog", dry_run=False)  # apply
```

### `Function: normalize_fk_column_name`
- **Lines of Legacy Code:** 126
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-057
- **Observability Aliases (Must be preserved):** fk-name-helper-field-widen")
- **Legacy Documentation:**
```text
[ATT-RUL-057] SINGLE SOURCE OF TRUTH for enforcing FK column naming convention.
Ensures the FK column's attribute/column_name ends with the target table's PK.

Call this AFTER setting attr['foreign_key_to'] to enforce the naming convention.
Returns True if the column was renamed, False otherwise.
```

### `Function: normalize_llm_response_names`
- **Lines of Legacy Code:** 74
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Recursively normalizes LLM response data to enforce lowercase naming conventions.

This ensures consistency across all entity names (domains, products, attributes, 
tags, FK references) regardless of how the LLM generated them.

Keys that get lowercased:
- Entity names: domain, product, attribute, primary_key, table_name, database_name
- FK/link related: source_domain, source_product, source_attribute, 
                   target_domain, target_product, target_product_pk
- Dedup related: domain_a, domain_b, product_a, product_b, product_to_keep, 
                 product_to_remove, merged_product_name, merged_product_domain
- Special: foreign_key_to (compound reference like "domain.product.attr")
- Tags: tags field values are lowercased
- Arrays: columns_to_remove, attributes_to_transfer, overlapping_products

Args:
    data: dict, list, or primitive value from LLM response
    
Returns:
    Normalized data with lowercase entity names
```

### `Function: parse`
- **Lines of Legacy Code:** 87
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: parse_fk`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: parse_fk_reference`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** PRD-RUL-014, REL-RUL-001
- **Legacy Documentation:**
```text
[PRD-RUL-014, REL-RUL-001]
SINGLE SOURCE OF TRUTH for parsing a foreign key reference string.
Replaces 30+ occurrences of fk.split('.') scattered throughout the codebase.

Args:
    fk_string: FK reference like "domain.product.pk_column" or "domain.product"

Returns:
    tuple: (target_domain, target_product, target_column) - column may be None
```

### `Function: parse_sql_statements`
- **Lines of Legacy Code:** 45
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: parse_target_state`
- **Lines of Legacy Code:** 62
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Universal parser for action target_state values.

expected: "auto" | "dict" | "list" | "int" | "bool" | "string"
Returns parsed value or default on failure.
```

### `Function: parse_user_vibes_to_requirements`
- **Lines of Legacy Code:** 49
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Parses user vibe text into discrete, trackable requirements.
Each requirement gets a unique ID for fulfillment tracking.

Returns list of dicts: [{"req_id": "REQ-1", "text": "...", "status": "pending", "evidence": ""}]
```

### `Function: pending_requirements`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: pk_column`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: plan`
- **Lines of Legacy Code:** 59
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: print`
- **Lines of Legacy Code:** 706
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** SAMPLE_POOL_PROMPT

### `Function: print_vibe_model_change_summary`
- **Lines of Legacy Code:** 152
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Prints a formatted summary of all changes that occurred during the Vibe Modelling Agent session.
Includes special sections for history tracking and housekeeping columns.
```

### `Function: process_batch`
- **Lines of Legacy Code:** 88
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** finding-dispatcher, finding-dispatcher-process-batch""", finding-dispatcher-protected
- **Legacy Documentation:**
```text
Process all pending findings. Returns dict with applied/deferred/invalid/conflicts/protected counts.
Per-finding decision recorded in finding['_dispatch_decision'].
Apply order: severity ASC index (MUST_FIX first) then cost ASC index (LOCAL first).
alias=finding-dispatcher-process-batch
```

### `Function: read_bytes_from_workspace`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: read_file_for_ddl`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: record_call`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: record_error`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: record_success`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: record_task`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Record task completion.
```

### `Function: record_task_duration`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Record task duration for stats without affecting semaphore.
```

### `Function: record_timeout`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: recover_tracked_entities`
- **Lines of Legacy Code:** 119
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-013, G10-R001
- **Legacy Documentation:**
```text
[G10-R001, ATT-RUL-013]
SINGLE SOURCE OF TRUTH for recovering dynamically created entities.
Replaces 3 duplicated recovery blocks (step_interpret, step_create_logical, step_create_physical).

Args:
    target_collections: dict with 'domains', 'products', 'attributes' lists to merge into

Returns:
    dict with counts: {'domains': N, 'products': N, 'attributes': N}
```

### `Function: register_active`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: register_validator`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: release`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Release a slot after execution. Track duration if start_time provided.
IMPORTANT: Only call this if acquire() returned a truthy value (not False).
```

### `Function: release`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: remediate`
- **Lines of Legacy Code:** 100
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** audit-dispatcher
- **Prompts Used:** VIBE_AUDIT_PROMPT

### `Function: remove_product_and_references`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** G03-R016, G10-R005
- **Legacy Documentation:**
```text
[G10-R005, G03-R016]
SINGLE SOURCE OF TRUTH for removing a product and cleaning up all references.
Removes the product, its attributes, and clears all FK references pointing to it.

Returns: (products_removed: int, attrs_removed: int, fks_cleared: int)
```

### `Function: render_master_action_catalog`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** render-master-action-catalog"""
- **Legacy Documentation:**
```text
Render MASTER_ACTION_REGISTRY as a markdown block to inject into LLM prompts.
All four review prompts (architect, quality_gate, static_analysis-driven, next_vibes)
receive the same catalog so the LLM picks an action_type+scope tuple that the
downstream mutation handler actually recognises (replaces _V074_SA_ACTION_VOCAB
duplicate per CLAUDE.md §3d). Industry-agnostic. alias=render-master-action-catalog
```

### `Function: repl`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** DOMAIN_ARCHITECT_REVIEW_PROMPT, MODEL_ARCHITECT_REVIEW_PROMPT

### `Function: replace_catalog_in_sql`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: replace_single_quote`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Sanitizes a string for use inside a SQL COMMENT or TAG.
Removes single quotes, backslashes, newlines.
```

### `Function: resolve_catalog`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: resolve_full`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: resolve_schema`
- **Lines of Legacy Code:** 22
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: rewrite_fk_after_relocation`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: run_batch_semantic_fk_resolution`
- **Lines of Legacy Code:** 93
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Batch semantic FK resolution using LLM with fallback to PARALLEL per-domain processing.

Collects ALL unlinked FK columns (ending in _id without foreign_key_to) and
resolves them in ONE LLM call using semantic understanding. If the batch call
fails (e.g., context size exceeded), falls back to PARALLEL per-domain processing.

PARALLELIZATION: Domain batches are processed in parallel using guarded_thread_pool_executor
with max_concurrent_batches to significantly reduce execution time.

Args:
    products_data: list of all products
    attributes_data: list of all attributes (will be modified in place)
    pk_map: dict mapping "domain.product" to PK info
    logger: logger instance
    ai_agent: AIAgent instance
    config: configuration dict
    concurrency_manager: Optional GlobalConcurrencyManager for thread control

Returns:
    tuple: (links_created: int, tables_suggested: list)
```

### `Function: run_batch_with_halving_on_timeout`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Run run_batch_fn(chunk). On TimeoutError (or exception with 'timeout' in message),
retry using half the batch size one after the other: run_batch_fn(chunk[:half]) then
run_batch_fn(chunk[half:]). Recurses until chunk size <= min_batch_size (then re-raises).
Apply this pattern everywhere ai_query is called with a specific batch size and it times out.
```

### `Function: run_fk_semantic_correctness_gate`
- **Lines of Legacy Code:** 75
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** MV15] [perf-mv15-parallel
- **Legacy Documentation:**
```text
MV15 — FK Semantic Correctness Gate.
Evaluates every cross-domain FK for business validity.
Removes invalid FKs and flags suspect ones in NEXT_VIBES.
```

### `Function: run_global_product_semantic_dedup`
- **Lines of Legacy Code:** 169
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-013, PRD-RUL-001, PRD-RUL-012, PRD-RUL-015
- **Prompts Used:** PRODUCT_IDENTIFY_CORE_PROMPT
- **Legacy Documentation:**
```text
# PRD-RUL-001, PRD-RUL-012, PRD-RUL-015, ATT-RUL-013

Step 3.6: Global Product Semantic Deduplication with MERGE_TO_SHARED Support
Runs AFTER all products are generated but BEFORE attribute generation.

SSOT-FIRST approach with CONSOLIDATION (not just deletion):
1. LLM-BASED: Detect semantic duplicates and decide MERGE_TO_SHARED vs REMOVE
2. MERGE_TO_SHARED: Consolidate cross-domain overlaps into 'shared' domain with discriminator columns
3. CODE-BASED: Handle remaining same-name products with smarter naming

CRITICAL FIX: When MERGE_TO_SHARED is executed, attributes from BOTH source products
are now copied to the merged product. FK references are also updated to point to the
merged product instead of the removed source products.

Args:
    domains_data: list of domain dicts
    products_data: list of all product dicts (will be modified in place)
    logger: logger instance
    ai_agent: AIAgent instance
    config: configuration dict
    attributes_data: list of attribute dicts (optional, will be modified in place if MERGE_TO_SHARED)
    
Returns:
    dict: Results including products merged, removed, renamed, and stats
```

### `Function: run_in_domain_linking_parallel`
- **Lines of Legacy Code:** 131
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Orchestrates parallel in-domain linking across all domains using Smart Workers.
Uses a flat ThreadPoolExecutor with max_batches concurrency.
Integrates with GlobalConcurrencyManager for centralized control.
Uses ThreadPoolGuard to prevent nested ThreadPool violations.

THREAD SAFETY NOTE: Workers are partitioned by domain so each worker modifies a
disjoint subset of attributes_data entries. Cross-domain attribute mutations are
NOT safe without external serialization. If domain partitioning is ever removed,
a structure-wide lock MUST be added around attributes_data mutations.

Args:
    domains_data: list of domain dicts
    products_data: list of all products
    attributes_data: list of all attributes (will be modified in place by domain-partitioned workers)
    pk_map: dict mapping "domain.product" to PK info
    logger: logger instance
    ai_agent: AIAgent instance
    config: configuration dict
    concurrency_manager: Optional GlobalConcurrencyManager

Returns:
    tuple: (total links created, all M:N candidates collected)

Raises:
    NestedThreadPoolError: If called from inside another ThreadPool worker
```

### `Function: run_metamodel_static_analysis`
- **Lines of Legacy Code:** 165
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** G10-R001, G10-R012, REL-RUL-004, REL-RUL-019
- **Legacy Documentation:**
```text
# REL-RUL-019, REL-RUL-004, G10-R001, G10-R012

STATIC ANALYSIS OF THE FINAL METAMODEL

Runs comprehensive checks on the completed metamodel (domains, products, attributes)
AFTER all processing is finished. For every action in the Vibe Modelling Agent system, this
function identifies what errors would trigger that action and searches for those errors
in the metamodel data. Only issues actually found become part of the next vibe.

Runs on the final metamodel state, not half-baked intermediate processing artifacts.

Returns:
    dict with keys:
        - issues: list of issue dicts (category, severity, message, details, remediation_actions)
        - model_stats: dict with counts
        - severity_counts: dict with error/warning/info counts
        - summary_by_category: dict grouped by category
```

### `Function: run_normalization_integrity_check_parallel`
- **Lines of Legacy Code:** 65
- **Role in New Architecture:** Validation Guard / Static Analyzer
- **Rules Enforced:** ATT-RUL-040, REL-RUL-010, REL-RUL-014, REL-RUL-026
- **Legacy Documentation:**
```text
# REL-RUL-010, ATT-RUL-040, REL-RUL-014, REL-RUL-026

Step 4.6: Normalization Integrity Check (Parallelized by Domain)

Runs AFTER attribute generation and BEFORE linking to enforce 3NF:
1. Orphaned FK Detection: *_id columns without foreign_key_to
2. Semantic Ownership Violation: Attributes that belong to another table (denormalized)

Runs in PARALLEL across domains to maximize throughput.

**SELECTIVE EXECUTION MODES:**
- scope="all": Run on all tables (default)
- scope="domains": Run only on specified domains (from normalization_scope_domains)
- scope="tables": Run only on specified tables (from normalization_scope_tables)

**SKIP TABLES:**
- Tables in normalization_skip_tables are excluded (for intentional denormalization like data marts)

**CONFLICT PREVENTION:**
- Tracks processed attributes in config['_normalization_processed_attrs'] 
- IN_DOMAIN_LINKING should check this before removing columns to avoid duplicate operations

Args:
    domains_data: list of domain dicts
    products_data: list of all products
    attributes_data: list of all attributes (will be modified in place)
    pk_map: dict mapping "domain.product" to PK info
    logger: logger instance
    ai_agent: AIAgent instance
    config: configuration dict
    concurrency_manager: Optional GlobalConcurrencyManager

Returns:
    dict: Summary of corrections made {orphaned_linked, denormalized_removed, fks_added}
```

### `Function: run_one`
- **Lines of Legacy Code:** 49
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: run_one_tag_batch`
- **Lines of Legacy Code:** 55
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** TAG_CLASSIFY_PROMPT

### `Function: run_pairwise_cross_domain_linking`
- **Lines of Legacy Code:** 101
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Step 6 ENHANCED: Pairwise Cross-Domain Linking (PARALLELIZED)
Runs O(n*(n-1)/2) pairwise comparisons - each unique domain pair is checked once.
Domain A vs B is the same as B vs A, so we only compare each pair once.
This ensures no logical cross-domain links are missed.
Also detects potential Many-to-Many relationships between domain pairs.

PARALLELIZATION: Domain pairs are now processed in parallel using ThreadPoolExecutor
to significantly reduce execution time for ECM scope models.

Args:
    domains_data: list of domain dicts
    products_data: list of all products
    attributes_data: list of all attributes (will be modified in place)
    pk_map: dict mapping "domain.product" to PK info
    logger: logger instance
    ai_agent: AIAgent instance
    config: configuration dict
    concurrency_manager: Optional GlobalConcurrencyManager
    changed_domains: Optional list of domain names - if provided, only process pairs 
                    where at least one domain is in this list (optimization for review mode)

Returns:
    tuple: (total links created, all M:N candidates collected)
```

### `Function: run_parallel_smart_workers`
- **Lines of Legacy Code:** 76
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Runs smart worker tasks in parallel with FLAT ThreadPool (no nesting).

Thread pool size = max_workers (from max_concurrent_batches config).
LLM throttling is handled by AIAgentManager's BoundedSemaphore inside AIAgent.
The thread pool allows tasks to run concurrently and queue for LLM slots naturally.
GlobalConcurrencyManager is used only for stats tracking, NOT for blocking.
```

### `Function: run_parallel_with_rate_limit_backoff`
- **Lines of Legacy Code:** 110
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Smart parallelism with rate-limit concurrency backoff.

Runs work_fn(item) on each item in parallel. On detected rate-limit error
(HTTP 429, 'rate_limit', 'too many requests', 'quota', 'throttl'), retry
the failed items with a lower worker count. Ladder: 20 → 15 → 10 → 5 → 1.

G9-FIX — non-rate-limit errors are now surfaced explicitly:
  • logged at ERROR level WITH traceback (was WARNING with no traceback)
  • optional on_error(idx, item, exc) callback fires per failure
  • optional raise_on_non_rate_limit_error re-raises an AggregateException at
    the end if any non-rate-limit failure occurred
  • optional return_errors=True returns (results, errors_by_idx) tuple

Args:
  items: list of items to process
  work_fn: callable (item) -> result
  start_workers: initial pool size (default 20, the greedy high-parallelism value)
  logger: optional logger
  label: identifier for log messages
  on_error: optional callable(idx, item, exc) called for non-rate-limit errors
  raise_on_non_rate_limit_error: if True, raise RuntimeError summarising failures at end
  return_errors: if True, return (results, errors_by_idx) instead of just results

Returns:
  list of results in original order (None for items that failed at min-concurrency too).
  If return_errors=True, returns (results, dict[int -> Exception]).
```

### `Function: run_process_flow_fk_gate`
- **Lines of Legacy Code:** 177
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_EDGE_SYNTHESIS_PROMPT, PROCESS_FLOW_FK_GATE_PROMPT
- **Legacy Documentation:**
```text
MV14 — Process-flow FK completeness gate.
Reads industry_process_flows from business_context, builds FK edge summary,
calls PROCESS_FLOW_FK_GATE_PROMPT to evaluate completeness, then calls
FK_EDGE_SYNTHESIS_PROMPT to fill critical gaps.
```

### `Function: run_product_domain_location_fit`
- **Lines of Legacy Code:** 21
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** DOM-RUL-010, DOM-RUL-011, DOM-RUL-014
- **Prompts Used:** QUALITY_DOMAIN_FIT_PROMPT
- **Legacy Documentation:**
```text
# DOM-RUL-010, DOM-RUL-011, DOM-RUL-014

Master step for product relocation. Runs QUALITY_DOMAIN_FIT_PROMPT in parallel per domain.
For each domain: pass all products in that domain (name, description, tags) and list of all other domains.
LLM decides per product: KEEP or RELOCATE (with optional new name, description, tags).
Applies relocations; when relocating a product, also relocates all tables related to that product (FK-linked in same domain).
products_scope: if set, only run for these product keys (domain.product); else run for all domains.
protected_products: set of "domain.product" to leave as-is (user-vibed or core); no relocation applied.
```

### `Function: run_quality_assurance_checks`
- **Lines of Legacy Code:** 1253
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-048, ATT-RUL-055, DOM-RUL-019, DOM-RUL-028, G06-R020, PRD-RUL-034
- **Prompts Used:** PRODUCT_IDENTIFY_CORE_PROMPT
- **Legacy Documentation:**
```text
# DOM-RUL-028, PRD-RUL-034, ATT-RUL-048, ATT-RUL-055, DOM-RUL-019, G06-R020

Step 7: Global Model Quality Assurance
Performs sequential checks:
- 7A-0: Remove empty/siloed domains (domains with 0 products)
- 7A-1: Merge small tables (products with <5 attributes)
- 7A-2: Validate and auto-insert missing PK attributes
- 7A: Semantic duplication across domains
- 7B: Global product name/function overlaps
- 7C: Graph topology (cycles, global siloed tables) - NOW WITH PYTHON DFS CYCLE DETECTION
- 7D: Auto-remediation with siloed table recovery triggering In-Domain Linking retry

STRICT SSOT ENFORCEMENT: NO protected tables - ALL products are subject to deduplication.
Each business concept has ONE and ONLY ONE owner across the model.

Args:
    vibe_mode_changed_domains: Optional list of domain names to focus QA on (for vibe mode)

Returns:
    dict: QA results with issues found and fixes applied
```

### `Function: run_query`
- **Lines of Legacy Code:** 39
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: run_regression_tests`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Run regression test suite. Returns (passed, failed, skipped) counts.
```

### `Function: run_signoff_checks`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: run_track_1`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Runs Track 1: Sequential steps for schema creation.

Smart Worker Architecture Steps:
- Steps 1-7: Logical Schema Generation (business context, domains, products, 
            attributes, in-domain linking, cross-domain linking, QA)
- Step 8: Naming Convention Application (prefixes/suffixes with recursive FK updates)
- Step 9: Physical Schema Construction (databases, tables, FK constraints)
```

### `Function: run_track_2`
- **Lines of Legacy Code:** 7
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Track 2 is now a no-op: all artifact generation (README, Excel, JSON, RDFS)
has been moved into Track 1 to ensure files are in the volume BEFORE physical creation.
```

### `Function: run_track_3`
- **Lines of Legacy Code:** 109
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Runs Track 3: Generate Samples + Apply Tags.
This is the last track before cleanup, ensuring samples and tags are applied.
```

### `Function: run_track_4`
- **Lines of Legacy Code:** 166
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Runs Track 4: Sequential step for cleanup.
Final track after samples and tags are applied.
```

### `Function: run_vibe_verification_sweep`
- **Lines of Legacy Code:** 70
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** VIBE_AUDIT_PROMPT

### `Function: run_vibebench_contract_suite`
- **Lines of Legacy Code:** 91
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: run_with_context_ladder`
- **Lines of Legacy Code:** 33
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
C-ladder — universal greedy-first fallback ladder.

Rung 1: run_batch_fn(items, variant="full")           — full context, full descriptions
Rung 2: run_batch_fn(items, variant="no_desc")        — descriptions dropped
Rung 3: run_batch_fn(items, variant="trunc_attrs")    — per-product attrs capped at 100
Rung 4: run_batch_with_halving_on_timeout(...)        — last-resort batch split

`run_batch_fn` MUST accept a `variant` kwarg; if not ready, it can ignore it and rely on rung 4.
Greedy_cap is advisory: if len(items) > cap, skip rungs 1-3 and go straight to rung 4.
```

### `Function: run_worker`
- **Lines of Legacy Code:** 35
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: run_worker_reviewer`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Executes the AI Worker loop with "Smart Worker" self-correction.
Merges Worker and Reviewer concepts: The Worker iterates on its own output if validation fails.
```

### `Function: run_worker_with_override`
- **Lines of Legacy Code:** 48
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Run AI worker with explicit model, temperature, timeout, and retry overrides.
Used for ensemble generation and fast-path sample generation.
```

### `Function: safe_add_product`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** G10-R004, PRD-RUL-021

### `Function: safe_get`
- **Lines of Legacy Code:** 5
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: sanitize_all_attribute_types`
- **Lines of Legacy Code:** 11
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Run sanitize_attribute_type on all attributes. Returns count of fixed attributes.
```

### `Function: sanitize_attribute_type`
- **Lines of Legacy Code:** 47
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Extract FK/tag metadata accidentally embedded in the type field.
LLMs sometimes echo the snapshot display format 'STRING | FK→D.T.PK | tags=x'
as the type value. This function splits it back into proper fields.
Returns True if the attribute was modified.
```

### `Function: sanitize_excel_value`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: sanitize_literal`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Sanitizes a string to be safely included in a Turtle literal.
```

### `Function: sanitize_name`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** GEN-RUL-002

### `Function: schema_name`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: scoped`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Returns a context manager that starts/stops a heartbeat using the registered active vibe_writer.
```

### `Function: score`
- **Lines of Legacy Code:** 163
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** fidelity-gate-halt, fidelity-gate-halt"

### `Function: score_variant`
- **Lines of Legacy Code:** 302
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** user-domain-division-exempt, user-domain-injection

### `Function: set`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: should_execute_contract_writes`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: smart_worker_loop`
- **Lines of Legacy Code:** 71
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Generic Smart Worker loop implementing Generate -> Validate -> Feedback -> Retry pattern.

Args:
    ai_agent: AIAgent instance for LLM calls
    logger: Logger instance
    step_name: Name of the current step for logging
    prompt_key: Key to load the prompt template
    prompt_vars: Variables to format the prompt
    response_schema: JSON schema for response validation
    validator_func: Callable(response_text) -> (is_valid, errors_list)
    config: Configuration dict containing MAX_RETRIES
    max_retries: Override for max retry attempts
    progress_context: Optional tuple (current_index, total_count) for progress display
    honesty_threshold_override: Override for min honesty score acceptance threshold
    response_postprocess_func: Optional Callable(response_data, logger) -> response_data
        Runs after JSON parsing/normalization but BEFORE honesty check evaluation.
        Can clean self-contradictions and recalculate honesty_score in the response.
    allow_honesty_retry: If False, do not run additional attempts for honesty-threshold misses.
    allow_borderline_retry: If True, retry once when score is between reject and borderline thresholds.
    borderline_threshold: Score threshold for borderline zone upper bound (default: 70).

Returns:
    tuple: (success: bool, response_data: dict or str, errors: list)
```

### `Function: smoke_render_all_prompts`
- **Lines of Legacy Code:** 41
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** VIBE_CREATE_NEXT_PROMPT

### `Function: soft_guidance`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: start`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_allocate_subdomains`
- **Lines of Legacy Code:** 55
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Allocate products into subdomains within each domain using LLM.
```

### `Function: step_apply_foreign_keys`
- **Lines of Legacy Code:** 67
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** G15-R003, G15-R004
- **Legacy Documentation:**
```text
# G15-R003, G15-R004

Apply Foreign Key Constraints.
This runs right after database and table creation (Stage 1).
Foreign keys are grouped by target table and run in parallel across tables,
but serially within each table to avoid concurrent write exceptions.

Step 9 in the Smart Worker Architecture:
- FK constraints grouped by table for safe parallel execution
- Concurrent write exceptions handled with exponential backoff + jitter
```

### `Function: step_apply_metric_views`
- **Lines of Legacy Code:** 31
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_apply_naming_conventions`
- **Lines of Legacy Code:** 41
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Step 8: Naming Convention Application

This step applies configuration prefixes/suffixes to table names and
RECURSIVELY updates ALL foreign key references to prevent broken links.

Per the Smart Worker Architecture:
- Apply schema prefix to all table names (e.g., 'stg_', '_tbl')
- Update all FK references to point to the renamed tables
- Ensure referential integrity is maintained after renaming

This step must run AFTER logical schema generation (Steps 1-7)
and BEFORE physical schema creation (Step 9).
```

### `Function: step_apply_tags`
- **Lines of Legacy Code:** 30
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Apply Column Tags.
This runs BEFORE sample generation to ensure schema is fully tagged.
Tags run in parallel with high concurrency for speed.
```

### `Function: step_apply_user_vibe_tags`
- **Lines of Legacy Code:** 120
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** user-vibe-tag-applier, user-vibe-tag-applier"), user-vibe-tag-applier)
- **Legacy Documentation:**
```text
[user-vibe-tag-applier FIRED] (alias=user-vibe-tag-applier)

Applies user-vibe-specified custom tag-presence-invariants to all attributes/products
BEFORE physical schema creation, so the existing step_create_physical_schema_stage1
SET TAGS emission picks them up naturally (DRY: extends, does not duplicate).

Process:
1. Reads vibe text from widgets_values["model_vibes"] + ["business_description"]
2. ONE LLM call to extract tag-presence-invariants 
   (per CLAUDE.md §3c USE LLM ALL THE WAY, NEVER regex on user vibes; per §3d 
   extends VibeOrchestrator's parsing pattern with a structured invariant extractor)
3. For each invariant, walks model attributes/products and injects the tag with the
   LLM-suggested default_value if the tag is MISSING (LLM-emitted tags from prior
   steps take priority - this is a SAFETY NET, not an override)

Per CLAUDE.md §3c the user vibe is SUPREME AUTHORITY - this step ensures vibe-mandated
tag presence is HONORED on every relevant entity, closing the prior version gap where 0 of 531
attributes carried user-mandated NCDOT custom tags.
```

### `Function: step_architect_review`
- **Lines of Legacy Code:** 191
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** PRODUCT_GLOBAL_DEDUP_PROMPT, PRODUCT_IDENTIFY_CORE_PROMPT
- **Legacy Documentation:**
```text
Step 3.7: Principal Data Architect Review — holistic model evaluation.

Runs AFTER product generation, BEFORE attribute generation.
Evaluates the entire model for completeness, coverage, duplication, usefulness,
industry alignment, and 10 additional quality dimensions.

Outputs actionable changes: domains/products to add, remove, or rename.
Replaces Step 3.6 (PRODUCT_GLOBAL_DEDUP_PROMPT).

Returns:
    dict with keys: assessment, domains_added, domains_removed, domains_renamed,
                    products_added, products_removed, products_renamed, stats
```

### `Function: step_consolidate_and_cleanup`
- **Lines of Legacy Code:** 48
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** G10-R010, G15-R012
- **Legacy Documentation:**
```text
FINAL MERGE STEP:
This step performs the final complete merge of all metadata to the metamodel database.

Note: Domains and products are registered early (in step_create_physical_schema_stage1) 
BEFORE physical creation for safety and cleanup tracking. This step re-merges them with 
complete data including attributes to ensure full and consistent metadata.

Database write operations in the pipeline:
1. Initial business insert (in step_setup_and_clean)
2. Early domain registration BEFORE database creation (in step_create_physical_schema_stage1)
3. Early product registration BEFORE table creation (in step_create_physical_schema_stage1)
4. Final complete merge with attributes (this step)

Why this approach:
- Early registration ensures cleanup tracking even if pipeline fails during creation
- Final merge ensures complete, enriched metadata with all relationships
```

### `Function: step_create_logical_schema`
- **Lines of Legacy Code:** 95
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
FILE-BASED ARCHITECTURE:
This step has been refactored to use driver file system for all operations.
- All domains, products, and attributes are stored in JSON files during processing
- NO database merge operations occur during this step
- Data is written to metamodel database ONLY at the end in step_consolidate_and_cleanup
- This eliminates intermediate database I/O and improves performance

REVIEW MODE:
When use_review_base_data is True, skips generation and uses pre-modified data from
step_interpret_model_instructions instead.
```

### `Function: step_create_physical_schema_stage1`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** G15-R001, G15-R006
- **Legacy Documentation:**
```text
# G15-R001 through G15-R006

STAGE 1: Create Databases and Tables only.
This stage is part of Track 1 (schema creation).
```

### `Function: step_domain_architect_review`
- **Lines of Legacy Code:** 142
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** architect-dispatcher
- **Legacy Documentation:**
```text
Step 3.6: DOMAIN-SCOPED Architect Review .

Runs AFTER product generation, BEFORE global architect review (Step 3.7).
One LLM call per domain in parallel (bounded by MAX_CONCURRENT_BATCHES).
Dual persona per call: Principal Data Architect + Senior Business SME for that domain.
Industry-agnostic — the prompt never names any industry; all framing uses
{industry_alignment} and {domain_name} placeholders.

Splits duty with step_architect_review:
- Domain architect: within-domain completeness, granularity, SSOT, in-domain FKs,
  descriptions, products to add/rename/remove/merge/split within this domain.
- Global architect (3.7): cross-domain SSOT, domain structure, essential cross-domain FKs.

Actionable outputs are applied immediately; unfixable items are deferred to next_vibes.
If a domain's context exceeds the LLM budget, the domain is processed in
product-level batches and the per-batch findings are merged.

Returns:
    dict with keys: stats, per_domain_results, domain_gate_failures, applied_changes.
```

### `Function: step_finalize_model_before_physical_schema`
- **Lines of Legacy Code:** 233
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_generate_and_insert_samples`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** G13-R010, G13-R011, G13-R012

### `Function: step_generate_data_dictionary`
- **Lines of Legacy Code:** 90
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_generate_data_model_json`
- **Lines of Legacy Code:** 111
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** bc1-empty-row-as-dict

### `Function: step_generate_dbml`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_generate_kpi_first_metric_views`
- **Lines of Legacy Code:** 313
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** ai-agent-call-fix, ai-agent-call-fix"), ai-agent-call-fix), fk-summary-injection, kpi-count-scaling, kpi-first-context-parity, kpi-first-owner-validate, kpi-first-stats, kpi-first-step, kpi-first-summary, kpi-quality-filter, mv-attrs-by-key-stash, mv-attrs-by-key-stash"), mv-attrs-by-key-stash), vibe-audit-helpers-block
- **Prompts Used:** DOMAIN_METRICS_PROMPT, KPI_FIRST_GLOBAL_PROMPT
- **Legacy Documentation:**
```text
[kpi-first-step FIRED] — KPI-first global metric view generation.

Replaces the per-domain Step 8d approach with a SINGLE global LLM call
that asks "what are the top N KPIs of this business?" and authors
multi-table joined metric views to satisfy each KPI.

The output is appended to widgets_values["metric_view_statements"]
(so this step COMPLEMENTS — does not replace — step_generate_metric_view_artifacts;
callers can choose to skip the per-domain step).
```

### `Function: step_generate_metric_view_artifacts`
- **Lines of Legacy Code:** 126
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** mv-artifact-failure-traceback)

### `Function: step_generate_model_overview_md`
- **Lines of Legacy Code:** 53
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_generate_model_report`
- **Lines of Legacy Code:** 88
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_generate_next_vibes`
- **Lines of Legacy Code:** 48
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** step-sa-active-autofix-call, step-sa-active-autofix-call-error")

### `Function: step_generate_next_vibes_early`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
structural-only next_vibes snapshot after physical schema,
BEFORE sample gen / tags / metric view execution.

Writes both next_vibes.txt AND next_vibes_early.txt via the inner
step_generate_next_vibes helper (the early file is tagged via the
_next_vibes_early_written flag).
```

### `Function: step_generate_next_vibes_late`
- **Lines of Legacy Code:** 21
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
enriched next_vibes generation AFTER sample gen, overwrites
next_vibes.txt with observations gathered in Step 12 (sample-gen tier counts,
any per-product sample failures). next_vibes_early.txt is preserved untouched
so diffing early-vs-late is possible.
```

### `Function: step_generate_ontology`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** ATT-RUL-001, G15-R013
- **Legacy Documentation:**
```text
Fetches metamodel data once and generates an RDFS 
ontology file.
```

### `Function: step_generate_readme`
- **Lines of Legacy Code:** 36
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_generate_release_notes`
- **Lines of Legacy Code:** 50
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_generate_test_cases`
- **Lines of Legacy Code:** 82
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_generate_vibe_audit_report`
- **Lines of Legacy Code:** 112
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** vibe-audit-stage-call, vibe-audit-stage-fn-defined, vibe-audit-stage-no-vibe
- **Legacy Documentation:**
```text
[vibe-audit-stage-fn-defined FIRED alias=vibe-audit-stage-fn-defined]
NEW pipeline stage — Vibe Audit Report.
Generic, industry-agnostic, deterministic. Slotted between SA and parallel
artifact generation so step_generate_release_notes can append it to release notes.
Reuses _static_analysis_result populated by run_metamodel_static_analysis +
_extend_sa_with_vibe_compliance.
```

### `Function: step_install_parity_audit`
- **Lines of Legacy Code:** 155
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** install-parity-audit-call, install-parity-audit-stage
- **Legacy Documentation:**
```text
[install-parity-audit-stage FIRED alias=install-parity-audit-stage]
NEW pipeline stage — runs on install path. Compares declared model.json
artifacts to physically materialized catalog (information_schema-backed).
Writes {volume}/vibes/install_parity_audit.md.
Generic — works for any deployment catalog.
```

### `Function: step_interpret_model_instructions`
- **Lines of Legacy Code:** 390
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** ATT-RUL-053, ATT-RUL-054, G10-R007, G14-R009, G14-R010, G14-R018
- **Observability Aliases (Must be preserved):** det-priority-augment, det-priority-fallback
- **Prompts Used:** VIBE_MASTER_PROMPT
- **Legacy Documentation:**
```text
Interprets and EXECUTES user model generation instructions for 'vibe modeling of version' operation.
1. Uses LLM to translate natural language instructions into specific model modification actions
2. Executes the actions on the base model data
3. For 'create product' actions, calls the product and attribute generation prompts
4. Runs FK linking for new products
5. Stores the modified model data for subsequent steps
```

### `Function: step_save_to_excel`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_setup_and_clean`
- **Lines of Legacy Code:** 40
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: step_static_analysis_autofix`
- **Lines of Legacy Code:** 143
- **Role in New Architecture:** Legacy Pipeline Step -> Migrates to Agentic Phase State
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** V075_RETIRE_V074_VOCAB, sa-active-autofix-summary, sa-active-autofix-summary", sa-autofix-error, sa-autofix-error"), step-sa-active-autofix, step-sa-active-autofix-deferred-high-cost, step-sa-active-autofix-no-mapping
- **Legacy Documentation:**
```text
[step-sa-active-autofix FIRED alias=step-sa-active-autofix]

ACTIVE STATIC-ANALYSIS AUTOFIX DISPATCHER (now cost-class-gated).

For each finding's `category`:
  1. Look up the canonical (action_type, scope) tuple in _V075_SA_CATEGORY_TO_ACTION.
  2. Compute cost_class via classify_action_cost(model, action_type, scope, args)
     — context-sensitive (e.g. rename of a PK becomes REQUIRES_FK_REWIRE).
  3. Check if cost_class is in STAGE_SAFE_COST_CLASSES[stage_name]. If yes,
     apply via the existing autofixer in _V074_SA_AUTOFIX_REGISTRY.
     If no, defer (the issue still flows to next_vibes for the LLM in v+1).
  4. Issues with no registered (action_type, scope) skip with reason
     'no_master_action_mapping' and flow to next_vibes.

This implements the user's explicit ask (2026-04-29 architectural critique):
'after each one if there is a low hanging fruit action then do it, a low
hanging fruit is a low cost operation, for example rename, etc that DOES NOT
JEOPARDISE the model integrity and forces you to redo a whole step again
(relinking, etc)'.

Returns:
    dict with keys:
        - issues_fixed: list of {category, applied_count, action_alias}
        - issues_skipped: list of {category, message, skip_reason}
        - issues_deferred_high_cost: list of {category, message, cost_class}
        - per_category_counts: dict[category, count_applied]
        - total_fixes_applied: int
        - stage_name: str
        - safe_cost_classes: list[str]
```

### `Function: stop`
- **Lines of Legacy Code:** 13
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: strip_configured_pk_suffix`
- **Lines of Legacy Code:** 10
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: strip_domain_prefix`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** PRD-RUL-006
- **Legacy Documentation:**
```text
[PRD-RUL-006]
SINGLE SOURCE OF TRUTH for removing domain name prefix from product name.
Example: domain='sales', product='sales_order' -> 'order'
Returns original name if no prefix found or result would be empty.
```

### `Function: strip_product_prefix`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** ATT-RUL-004
- **Legacy Documentation:**
```text
[ATT-RUL-004]
SINGLE SOURCE OF TRUTH for removing product name prefix from attribute name.
PK attributes (e.g., product_id) are EXEMPT.
Example: product='warehouse', attr='warehouse_location' -> 'location'
```

### `Function: submit`
- **Lines of Legacy Code:** 2
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: submit_many`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: summarize_output`
- **Lines of Legacy Code:** 134
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: table_name`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: tag_key`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: to_camel_case`
- **Lines of Legacy Code:** 94
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: to_classification_dict`
- **Lines of Legacy Code:** 19
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: to_contract`
- **Lines of Legacy Code:** 60
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: to_distributed_vibes`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: to_pascal_case`
- **Lines of Legacy Code:** 3
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: to_pinned_text`
- **Lines of Legacy Code:** 8
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: unfulfilled_requirements`
- **Lines of Legacy Code:** 4
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: unmark_inside_pool`
- **Lines of Legacy Code:** 6
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Unmark current thread as being inside a ThreadPool worker.
```

### `Function: update_business_context`
- **Lines of Legacy Code:** 17
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** update-business-context-broaden

### `Function: update_job_tags`
- **Lines of Legacy Code:** 158
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Update tags on the Databricks job that is currently executing this
notebook.  Reads existing tags first and MERGES the updates so
identity tags (business, model, operation) are preserved.

Returns a dict:
    success  (bool)
    method   (str)   "sdk" | "rest" | None
    error    (str | None)
    job_id   (int | None)
```

### `Function: validate`
- **Lines of Legacy Code:** 43
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: validate_and_correct_fk_target`
- **Lines of Legacy Code:** 174
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** REL-RUL-001, REL-RUL-004, REL-RUL-005, REL-RUL-007, REL-RUL-008
- **Legacy Documentation:**
```text
[REL-RUL-001, REL-RUL-004, REL-RUL-005, REL-RUL-007, REL-RUL-008]
SINGLE SOURCE OF TRUTH for FK target validation and correction.

Ensures that an FK target (e.g., "maintenance.plant.source_system") always
references the actual PK column of the target table. If the target table
exists in pk_map but the column is wrong, corrects it to the real PK.

Args:
    fk_target: str like "domain.product.column"
    pk_map: dict mapping "domain.product" -> pk_name
    logger: optional logger

Returns:
    tuple: (corrected_fk_target: str, is_valid: bool)
           - corrected target string (or empty string if table not found)
           - whether the target is valid (table exists)
```

### `Function: validate_and_fix_all_fk_references`
- **Lines of Legacy Code:** 107
- **Role in New Architecture:** Autofixer / Finding Execution
- **Rules Enforced:** PRD-RUL-006, REL-RUL-001, REL-RUL-004, REL-RUL-008
- **Legacy Documentation:**
```text
[REL-RUL-004, REL-RUL-008, REL-RUL-001, PRD-RUL-006]
SINGLE SOURCE OF TRUTH for validating FK references and auto-fixing broken ones.
Replaces duplicated logic in SmartWorkerValidator.validate_fk_references,
Step 7E, and action execution validate_fk_targets.

Strategies for auto-fix:
1. Exact match
2. Domain-prefixed name (domain.incident -> domain.domain_incident)
3. Shared domain (domain.incident -> shared.incident)
4. Product found in different domain
5. Similar name match (substring)

Returns: (is_valid, errors_list, fixes_applied_list)
```

### `Function: validate_architect_review`
- **Lines of Legacy Code:** 909
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** orig-name-tag-removed
- **Prompts Used:** MODEL_ARCHITECT_REVIEW_PROMPT, PRODUCT_GENERATE_PROMPT

### `Function: validate_attributes`
- **Lines of Legacy Code:** 52
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Step 4 Validation: Attribute Generation per Product
- Count between min_attributes_per_product and max_attributes_per_product
- No duplicate attribute names
- PK follows product_name_id convention
- Valid Spark SQL data types
```

### `Function: validate_attrs_wrapper`
- **Lines of Legacy Code:** 100
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: validate_attrs_wrapper`
- **Lines of Legacy Code:** 156
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: validate_business_context`
- **Lines of Legacy Code:** 68
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Step 1 Validation: Business Context
- JSON validity
- Non-empty required fields
- Domain count within bounds
```

### `Function: validate_cross_domain_linking`
- **Lines of Legacy Code:** 60
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Step 6 Validation: Cross-Domain Linking
- No siloed domains: every domain must have at least one cross-domain connection
- No self-referencing FKs (source_domain.source_product == target_domain.target_product)
```

### `Function: validate_division_ratios`
- **Lines of Legacy Code:** 38
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: validate_domain_isolation`
- **Lines of Legacy Code:** 42
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Validates domain isolation requirements:
- Each domain has its own set of products
- Products don't reference products in completely unrelated domains without explicit links
- Domain boundaries are respected
```

### `Function: validate_finding`
- **Lines of Legacy Code:** 37
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** validate-finding-shape"""
- **Legacy Documentation:**
```text
Return (is_valid, error_message). Verifies finding has required keys and that
proposed_action.action_type+scope exists in MASTER_ACTION_REGISTRY.
Severity must be in _VALID_SEVERITIES; provenance must be in _VALID_PROVENANCES.
alias=validate-finding-shape
```

### `Function: validate_fk_target_exists`
- **Lines of Legacy Code:** 9
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: validate_global_dedup`
- **Lines of Legacy Code:** 88
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** PRODUCT_GLOBAL_DEDUP_PROMPT

### `Function: validate_in_domain_linking`
- **Lines of Legacy Code:** 29
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Step 5 Validation: In-Domain Linking
- Zero siloed tables policy: every product must have at least one relationship (incoming or outgoing)
- No circular dependencies within domain

Args:
    existing_links: List of existing FK links FROM this domain (outgoing)
    all_attributes: List of ALL attributes across ALL domains (to find incoming FKs)
                   MUST be loaded from metamodel database - do NOT use JSON files
```

### `Function: validate_industry_vocabulary_alignment`
- **Lines of Legacy Code:** 23
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: validate_json_structure`
- **Lines of Legacy Code:** 16
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Validates JSON is parseable and contains required keys.
```

### `Function: validate_judge_response`
- **Lines of Legacy Code:** 86
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** DOMAIN_JUDGE_PROMPT
- **Legacy Documentation:**
```text
Validate the judge response has required fields and respects min/max domains.
```

### `Function: validate_model_generation_parameters`
- **Lines of Legacy Code:** 81
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Observability Aliases (Must be preserved):** model-params-subdomain-required"

### `Function: validate_namespace_matches_description`
- **Lines of Legacy Code:** 12
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: validate_no_self_fk_on_pk`
- **Lines of Legacy Code:** 18
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: validate_org_chart_alignment`
- **Lines of Legacy Code:** 20
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: validate_physical_schema`
- **Lines of Legacy Code:** 14
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Step 9 Validation: Physical Schema Construction
- All tables created
- No siloed tables (tables with no incoming AND no outgoing FKs)
```

### `Function: validate_products`
- **Lines of Legacy Code:** 105
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Step 3 Validation: Product Generation per Domain
- Count between min_data_products_per_domain and max_data_products_per_domain
- Product names: 1-3 words max, lowercase, max 30 chars
- No duplicate product names within domain
- Primary key follows product_name_id pattern
- data_type must be one of: master_data, reference_data, transactional_data, association_data
```

### `Function: validate_products_wrapper`
- **Lines of Legacy Code:** 80
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: validate_products_wrapper`
- **Lines of Legacy Code:** 69
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: validate_response`
- **Lines of Legacy Code:** 130
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_IN_DOMAIN_LINK_PROMPT

### `Function: validate_response`
- **Lines of Legacy Code:** 345
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Prompts Used:** FK_CROSS_DOMAIN_MESH_PROMPT

### `Function: validate_sample_csv`
- **Lines of Legacy Code:** 57
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Step 11 Validation: Sample Data Generation
- CSV format validity
- Column matching with schema
- Minimum row count
```

### `Function: validate_single_domain_wrapper`
- **Lines of Legacy Code:** 79
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.
- **Legacy Documentation:**
```text
Validate that the response contains exactly the expected domain.
```

### `Function: vibe_compliance_lite`
- **Lines of Legacy Code:** 59
- **Role in New Architecture:** Vibe Contract & Orchestration
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: wait_for_run_terminal`
- **Lines of Legacy Code:** 38
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: wait_for_run_terminal`
- **Lines of Legacy Code:** 34
- **Role in New Architecture:** LLM Integration / Parsing
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: warning`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: warning`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: warning`
- **Lines of Legacy Code:** 2
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: warning`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: warning`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: warning`
- **Lines of Legacy Code:** 2
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: warning`
- **Lines of Legacy Code:** 1
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: warning`
- **Lines of Legacy Code:** 2
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: warning`
- **Lines of Legacy Code:** 2
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: wrap_schema_with_honesty`
- **Lines of Legacy Code:** 42
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** G11-R001
- **Observability Aliases (Must be preserved):** logger-propagate-fired, schema-strict-preserve, schema-strict-preserve)
- **Legacy Documentation:**
```text
[G11-R001] Wraps an AI response schema to include honesty_score and honesty_justification fields.
```

### `Function: wrap_step`
- **Lines of Legacy Code:** 28
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: write_attributes_to_disk`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: write_signature`
- **Lines of Legacy Code:** 15
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

### `Function: write_to_dbfs`
- **Lines of Legacy Code:** 41
- **Role in New Architecture:** Utility / Helper
- **Rules Enforced:** Implicit structural rules or utility.

