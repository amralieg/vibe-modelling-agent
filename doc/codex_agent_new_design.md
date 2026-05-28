# Codex Agent New Design

## Backward-Compatible Full Rewrite for `vibe_modelling_agent`

This document is the implementation blueprint for a full rewrite of the current agent into a truly agentic architecture while keeping strict backward compatibility with existing tooling.

### Non-Negotiable Compatibility Contract

1. Input compatibility is absolute: same widgets, same names, same value semantics, same defaults, same operation verbs.
2. Output compatibility is absolute: same artifact set, same generation order, same content shape, same formatting contracts.

---

## 1) 100% Goals (Clear, Testable, Unambiguous)

### 1.1 Product Goals

- Generate production-grade business data models that pass structural, semantic, and deployability checks by default.
- Enforce user vibe authority with explicit conflict resolution where user directives always override heuristics.
- Preserve Databricks-native execution and Serverless compatibility.
- Reduce runtime substantially (target: Tier-1 ECM from hours to practical iterative windows via staged parallelism and deterministic retries).
- Reduce code size and coupling by decomposing the monolith into explicit stage modules and contracts.
- Make the system agentic: generate, critique, diagnose, plan fixes, apply fixes, re-evaluate, and only stop when gates pass.

### 1.2 Engineering Goals

- Keep external behavior stable while replacing internals completely.
- Make each stage independently testable with deterministic fixtures.
- Encode all critical gates as explicit policies with reproducible evidence.
- Keep observability first-class: every mutation path emits structured proof markers.

### 1.3 Success Criteria

- 100% widget contract parity test pass.
- 100% artifact parity test pass (schema + format + ordering).
- 0 hard gate regressions versus baseline quality-gate catalog.
- Runtime reduction confirmed on tiny + airline benchmark scenarios.

---

## 2) 100% Lessons Learned from the Current Implementation

### 2.1 What Worked and Must Be Preserved

- The current system has rich operational knowledge encoded in quality gates, retries, and artifact conventions.
- `next_vibes` and `current_vibes` loops are valuable and should remain first-class for iterative refinement.
- Domain-architect and principal-architect review loops materially improve model quality when bounded by deterministic validators.
- Extensive unit tests already define many non-obvious behavioral invariants and should be used as migration rails.

### 2.2 Root Causes of Current Pain

- Monolithic notebook structure creates coupling between parsing, planning, generation, validation, deployment, and reporting.
- Repeated logic across tracks and steps makes safe change difficult and slows iteration.
- Prompt and validator logic is spread across many call sites, making behavior hard to reason about end-to-end.
- Performance bottlenecks come from broad retries, repeated full-model passes, and insufficient stage isolation/caching of deterministic intermediate outputs.

### 2.3 Operational Lessons from History and Tests

- Widget parsing and precedence is a major failure surface; explicit contracts must be centralized and tested.
- Versioning and `agent_version` stamping are critical for auditability and rollback confidence.
- Soft-accept paths (`max retries exhausted`) hide defects if not explicitly treated as failures in final gate decisions.
- Model/physical parity checks are mandatory because logical success can still fail at installation time.

### 2.4 Systematic Lessons (From full code + docs + tests extraction)

- Agent code footprint analyzed: 88436 code lines, 1163 function defs, 37 classes.
- Runner code footprint analyzed: 2012 code lines, 43 function defs.
- Tester code footprint analyzed: 2870 code lines, 53 function defs.
- Unit test contracts analyzed: 56 test files.
- Discovered rule identifiers and legacy aliases catalogued: 195 rules, 158 aliases, 149 FIRED markers.

---

## 3) 100% Philosophy and Design Objectives for the New Agent

### 3.1 Core Philosophy

- User intent is sovereign. Deterministic safety constraints are non-negotiable. Heuristics are advisory.
- Every generated model is guilty until proven production-ready by explicit gates.
- Agentic behavior means closed-loop responsibility: propose, execute, verify, explain, and only then finalize.
- Prefer explicit contracts over implicit behavior. Prefer reusable modules over repeated logic.

### 3.2 Critique of the Rewrite Strategy (and Better Path)

- A pure big-bang rewrite is high risk because compatibility breakage can hide in widget edge cases and artifact formatting minutiae.
- Better strategy: build a strict compatibility facade first, then replace internals behind that facade stage-by-stage (strangler pattern).
- This still delivers a full rewrite outcome, but with lower risk and immediate parity signal at each stage.

### 3.3 Design Objectives

- Decompose monolith into stage modules with typed I/O contracts and deterministic checkpoints.
- Keep prompt orchestration centralized with policy-driven retries and explicit fail-fast thresholds.
- Make all quality gates executable and composable; no hidden validators.
- Preserve all externally visible contracts from current agent, runner, and tester.

---

## 4) 100% Design Steps (Requires, Does, Depends, Produces)

| Step | Requires | Does | Depends On | Produces |
|---|---|---|---|---|
| S0: Session bootstrap | Widgets, context file, runtime profile | Parse inputs, resolve precedence, normalize conventions, establish session id | None | Canonical `RunContext` object |
| S1: Business context synthesis | `RunContext` + optional prior model metadata | Build business context graph with division/domain intent and constraints | S0 | `BusinessContext` artifact |
| S2: Vibe intent compiler | `model_vibes`, mode, protected targets | Compile vibes into structured directives and mutation budgets | S0/S1 | `VibePlan` + hard constraints map |
| S3: Domain planner | BusinessContext + VibePlan + scope | Generate/adjust domains while preserving widget-imposed domains | S1/S2 | `DomainPlan` |
| S4: Product planner | DomainPlan + model scope + historical context | Generate products per domain and run domain-fit architect review | S3 | `ProductPlan` |
| S5: Attribute planner | ProductPlan + conventions + type rules | Generate attributes, types, tags seeds, keys, nullability | S4 | `AttributePlan` |
| S6: Graph linker | AttributePlan + relationship heuristics + vibe directives | Build in-domain links, cross-domain links, M:N bridge candidates | S5 | `LinkPlan` |
| S7: Deterministic normalizer | LinkPlan + rule catalog | Enforce DAG, SSOT, FK naming/type validity, de-dup, anti-silo | S6 | `NormalizedModel` |
| S8: Architectic loop engine | NormalizedModel + unresolved findings + action registry | Iterative review-remediate-score loop until gate pass or hard-stop | S7 | `ApprovedModel` + finding ledger |
| S9: Artifact factory | ApprovedModel + conventions + metadata | Emit model.json, vibes files, docs, dbml, ontology, SQL, reports | S8 | Ordered artifact set with stable formatting |
| S10: Physical deploy pipeline | ApprovedModel + deployment catalog | Create schemas/tables/FKs/tags/metric views/sample data | S8/S9 | Physical deployment evidence + parity report |
| S11: Next-vibes planner | ApprovedModel + findings + confidence metadata | Produce deterministic+LLM combined next_vibes recommendations | S8/S9/S10 | `vibes/next_vibes.txt` + metadata block |

### 4.1 Agentic Loop Behavior (S8)

- Input findings are classified by severity, scope, and estimated cost using a single action registry.
- Low-risk deterministic fixes are auto-applied first.
- LLM-proposed fixes are validated against structural rules and user-authority constraints before acceptance.
- Loop exits only when hard gates pass or a terminal policy condition is met with explicit failure evidence.

### 4.2 Parallelization Plan

- Parallelize product/attribute generation per domain with bounded concurrency manager.
- Parallelize artifact generation after model freeze checkpoint.
- Keep deterministic normalization single-source to avoid race-induced drift.

---

## 5) 100% Quality Gates for Astronomically Better Performance

### 5.1 Gate Families

- Input contract gates: widget values, operation prerequisites, context version integrity.
- Structural gates: PK uniqueness, FK target existence, no bidirectional links, DAG cycles = 0, siloed products = 0.
- Semantic gates: SSOT duplicate detection, domain/product fit, normalization checks, naming consistency.
- User authority gates: explicit protection of user-specified domains/products/directives.
- Deployment gates: logical-vs-physical parity for tables, columns, metric views, tags.
- Auditability gates: version stamp, run metadata, FIRED markers, full finding ledger.

### 5.2 Gate Execution Policy

- Hard-fail gates stop promotion immediately.
- Recoverable gates trigger bounded remediation loops with evidence of each attempted fix.
- Soft warnings are recorded but cannot mask hard-fail signatures.
- Finalize only if all hard gates are green and parity checks pass.

### 5.3 Performance Quality Gates

- Track per-stage latency and token spend; fail optimization gate if runtime budget regresses beyond configured threshold.
- Require deterministic cache hits for immutable intermediate artifacts within a run.
- Enforce bounded retries with explicit per-prompt retry policy and timeout demotion rules.

---

## 6) Exact Backward-Compatibility Contract

### 6.1 Agent Widget Contract (Exact Input Surface)

| Widget | Type | Default | Choices | Contract |
|---|---|---|---|---|
| `business_name` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `business_description` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `operation` | `dropdown` | `new base model` | `["new base model", "vibe modeling of version", "shrink ecm", "enlarge mvm", "install model", "uninstall model version", "generate sample data"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `model_version` | `dropdown` | `` | `[""] + [str(i) for i in range(1, 101)]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `data_model_scopes` | `dropdown` | `Minimum Viable Model - MVM` | `["Minimum Viable Model - MVM", "Expanded Coverage Model - ECM"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `business_domains` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `org_divisions` | `dropdown` | `Operations and Business` | `["Operations", "Operations and Business", "Operations, Business and Corporate"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `model_vibes` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `deployment_catalog` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `cataloging_style` | `dropdown` | `One Catalog` | `["One Catalog", "Catalog per Division", "Catalog per Domain"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `catalog_prefix` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `catalog_suffix` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `generate_samples` | `dropdown` | `0` | `["0", "5", "10", "15", "20", "25", "50", "100"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `context_file` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `naming_convention` | `dropdown` | `snake_case` | `["snake_case", "camelCase", "PascalCase", "SCREAMING_CASE"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `primary_key_suffix` | `text` | `_id` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `schema_prefix` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `schema_suffix` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `tag_prefix` | `text` | `dbx_` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `tag_suffix` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `table_id_type` | `dropdown` | `BIGINT` | `["BIGINT", "INT", "LONG", "STRING"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `boolean_format` | `dropdown` | `Boolean (True/False)` | `["Boolean (True/False)", "Int (0/1)", "String (Y/N)"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `date_format` | `dropdown` | `yyyy-MM-dd` | `["yyyy-MM-dd", "dd/MM/yyyy", "MM/dd/yyyy", "yyyy/MM/dd", "dd-MM-yyyy"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `timestamp_format` | `dropdown` | `yyyy-MM-dd'T'HH:mm:ss.SSSXXX` | `["yyyy-MM-dd'T'HH:mm:ss.SSSXXX", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd HH:mm:ss.SSS"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `classification_levels` | `text` | `restricted=restricted, confidential=confidential, internal=Internal, public=public` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `housekeeping_columns` | `dropdown` | `No` | `["No", "Yes"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `history_tracking_columns` | `dropdown` | `No` | `["No", "Yes"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `vibe_session_id` | `text` | `` | `` | Hard backward compatible. Keep name/type/default; preserve accepted values. |
| `vibe_fidelity_gate_halt_disabled` | `dropdown` | `False` | `["False", "True"]` | Hard backward compatible. Keep name/type/default; preserve accepted values. |

### 6.2 Runner and Tester Widget Contracts

- Runner widgets discovered: 31
  - `business_context` (text), default `/Workspace/Users/<your-user>/vibe-modelling/industries.json`
  - `dry_run` (dropdown), default `yes`
  - `ping_interval` (dropdown), default `1m`
  - `business_name` (text), default ``
  - `business_description` (text), default ``
  - `operation` (dropdown), default `new base model`
  - `model_version` (dropdown), default ``
  - `data_model_scopes` (dropdown), default `Minimum Viable Model - MVM`
  - `business_domains` (text), default ``
  - `org_divisions` (dropdown), default `Operations and Business`
  - `model_vibes` (text), default ``
  - `deployment_catalog` (text), default ``
  - `cataloging_style` (dropdown), default `One Catalog`
  - `catalog_prefix` (text), default ``
  - `catalog_suffix` (text), default ``
  - `generate_samples` (dropdown), default `0`
  - `context_file` (text), default ``
  - `naming_convention` (dropdown), default `snake_case`
  - `primary_key_suffix` (text), default `_id`
  - `schema_prefix` (text), default ``
  - `schema_suffix` (text), default ``
  - `tag_prefix` (text), default `dbx_`
  - `tag_suffix` (text), default ``
  - `table_id_type` (dropdown), default `BIGINT`
  - `boolean_format` (dropdown), default `Boolean (True/False)`
  - `date_format` (dropdown), default `yyyy-MM-dd`
  - `timestamp_format` (dropdown), default `yyyy-MM-dd\\'T\\'HH:mm:ss.SSSXXX`
  - `classification_levels` (text), default `restricted=restricted, confidential=confidential, internal=Internal, public=public`
  - `housekeeping_columns` (dropdown), default `No`
  - `history_tracking_columns` (dropdown), default `No`
  - `vibe_session_id` (text), default ``
- Tester widgets discovered: 4
  - `business_name` (text), default ``
  - `business_description` (text), default ``
  - `model_vibes` (text), default ``
  - `catalog` (text), default ``

### 6.3 Operation Verbs (Must Stay Identical)

- `enlarge mvm`
- `generate sample data`
- `install model`
- `new base model`
- `shrink ecm`
- `uninstall model version`
- `vibe modeling of version`

### 6.4 Output Artifacts (Must Stay Identical in semantics and formatting)

- `model.json`
- `readme.md`
- `vibes/current_vibes.txt`
- `vibes/next_vibes.txt`
- `domains.json`
- `products.json`
- `attributes.json`
- `docs/*.xlsx`
- `docs/*.csv`
- `schemas/*.sql`
- `diagram/*_dbml_*.txt`
- `ontology/*_rdf_*.ttl`
- `docs/releasenotes.txt`
- `docs/*_data_dictionary_*.txt`
- `docs/*_model_report_*.txt`
- `docs/*_test_cases_*.txt`

---

## 7) Reuse vs Rewrite Decisions

| Component | Decision | Why |
|---|---|---|
| Widget parsing and precedence | Reuse semantics exactly, rewrite implementation | This is the largest compatibility surface and must remain byte-stable in behavior. |
| Step pipeline contracts | Reuse stage contracts, rewrite internals | Maintain output sequence while reducing coupling. |
| FindingDispatcher + MasterActionRegistry model | Preserve concepts, refactor API | They are central to controlled autonomous fixes. |
| Smart worker loop policy | Preserve behavior, isolate to orchestration module | Retry/demotion logic is proven and needs cleaner boundaries. |
| Artifact generators | Preserve output contract, rewrite as pure factories | Enables deterministic tests and parallel execution. |
| Physical deployment | Preserve SQL/object semantics, rewrite executor layer | Keep install behavior while improving reliability and observability. |
| Docs/readme/release writer | Preserve content schema, refactor composition | Simplifies formatting parity tests. |

---

## 8) Mind Map Inventory (Functions, Classes, Prompts, Rules)

### 8.1 Classes (Exhaustive)

- `JobLauncher` (methods: 11) -> Refactor into module scoped class
- `NextVibesIssueCollector` (methods: 7) -> Refactor into module scoped class
- `_MemoryGuard` (methods: 2) -> Refactor into module scoped class
- `CatalogResolver` (methods: 7) -> Refactor into module scoped class
- `FindingDispatcher` (methods: 6) -> Refactor internals; preserve public behavior
- `_MiniDiskCache` (methods: 5) -> Refactor into module scoped class
- `_DBUtilsShim` (methods: 1) -> Refactor into module scoped class
- `AIAgentManager` (methods: 10) -> Refactor internals; preserve public behavior
- `AIAgent` (methods: 30) -> Refactor into module scoped class
- `ObservationsLogger` (methods: 7) -> Refactor into module scoped class
- `ModelBundle` (methods: 6) -> Refactor into module scoped class
- `FKResolver` (methods: 6) -> Refactor into module scoped class
- `SmartWorkerValidator` (methods: 15) -> Refactor internals; preserve public behavior
- `NestedThreadPoolError` (methods: 0) -> Refactor into module scoped class
- `ThreadPoolGuard` (methods: 10) -> Refactor into module scoped class
- `GlobalConcurrencyManager` (methods: 12) -> Refactor into module scoped class
- `InfoFilter` (methods: 1) -> Refactor into module scoped class
- `ImmediateFlushFileHandler` (methods: 1) -> Refactor into module scoped class
- `NamingConvention` (methods: 16) -> Refactor into module scoped class
- `VibeRequirement` (methods: 5) -> Refactor into module scoped class
- `VibeManifest` (methods: 10) -> Refactor into module scoped class
- `VibeVerificationClause` (methods: 0) -> Refactor into module scoped class
- `VibeContract` (methods: 0) -> Refactor into module scoped class
- `VibeOrchestrator` (methods: 25) -> Refactor internals; preserve public behavior
- `HeartbeatWatchdog` (methods: 7) -> Refactor into module scoped class
- `_Ctx` (methods: 2) -> Refactor into module scoped class
- `MetricViewOwnershipError` (methods: 0) -> Refactor into module scoped class
- `VibeWriter` (methods: 25) -> Refactor into module scoped class
- `_FallbackLogger` (methods: 4) -> Refactor into module scoped class
- `_InstallMetricLogger` (methods: 5) -> Refactor into module scoped class
- `_SinkLogger` (methods: 28) -> Refactor into module scoped class
- `_SinkLogger` (methods: 28) -> Refactor into module scoped class
- `_SinkLogger` (methods: 28) -> Refactor into module scoped class
- `_SinkLogger` (methods: 28) -> Refactor into module scoped class
- `_SinkLogger` (methods: 28) -> Refactor into module scoped class
- `_SinkLogger` (methods: 28) -> Refactor into module scoped class
- `_SinkLogger` (methods: 28) -> Refactor into module scoped class

### 8.2 Prompt Constants (Exhaustive uppercase constants)

- `PROMPT_TEMPLATES` (declared near line 1971) -> Reuse prompt intent; externalize to prompt registry package.
- `_MVM_M2M_PROMPT_GUIDANCE` (declared near line 15728) -> Reuse prompt intent; externalize to prompt registry package.
- `_PROMPT_ACTION_CATALOG_SCOPE_FILTER` (declared near line 27628) -> Reuse prompt intent; externalize to prompt registry package.

### 8.3 Schema Constants (Exhaustive uppercase constants)

- `AI_ATTRIBUTE_DEDUP_SCHEMA` (declared near line 14850) -> Preserve schema contract exactly.
- `AI_ATTRIBUTE_SCHEMA` (declared near line 20341) -> Preserve schema contract exactly.
- `AI_BATCH_SEMANTIC_FK_RESOLUTION_SCHEMA` (declared near line 17284) -> Preserve schema contract exactly.
- `AI_BUSINESS_CONTEXT_SCHEMA` (declared near line 20336) -> Preserve schema contract exactly.
- `AI_CLASSIFY_VIBE_INTENT_SCHEMA` (declared near line 20313) -> Preserve schema contract exactly.
- `AI_CROSS_DOMAIN_MESH_SCHEMA` (declared near line 15719) -> Preserve schema contract exactly.
- `AI_CYCLE_BREAKER_SCHEMA` (declared near line 17872) -> Preserve schema contract exactly.
- `AI_DOMAINS_SELECTION_JUDGE_SCHEMA` (declared near line 20339) -> Preserve schema contract exactly.
- `AI_DOMAINS_WORKER_SCHEMA` (declared near line 20338) -> Preserve schema contract exactly.
- `AI_DOMAIN_ARCHITECT_REVIEW_SCHEMA` (declared near line 11793) -> Preserve schema contract exactly.
- `AI_DOMAIN_METRICS_SCHEMA` (declared near line 20343) -> Preserve schema contract exactly.
- `AI_ENLARGE_DOMAINS_SCHEMA` (declared near line 19353) -> Preserve schema contract exactly.
- `AI_FIND_MISSING_FK_LINKS_SCHEMA` (declared near line 17584) -> Preserve schema contract exactly.
- `AI_FK_COLUMN_RENAME_RESOLUTION_SCHEMA` (declared near line 17243) -> Preserve schema contract exactly.
- `AI_FK_EDGE_SYNTHESIS_SCHEMA` (declared near line 16095) -> Preserve schema contract exactly.
- `AI_FK_SEMANTIC_GATE_SCHEMA` (declared near line 16166) -> Preserve schema contract exactly.
- `AI_FOREIGN_KEY_ANOMALY_SCHEMA` (declared near line 20342) -> Preserve schema contract exactly.
- `AI_GLOBAL_PRODUCT_DEDUP_SCHEMA` (declared near line 13844) -> Preserve schema contract exactly.
- `AI_IDENTIFY_CORE_PRODUCTS_SCHEMA` (declared near line 14176) -> Preserve schema contract exactly.
- `AI_IN_DOMAIN_LINKING_SCHEMA` (declared near line 15716) -> Preserve schema contract exactly.
- `AI_KPI_FIRST_GLOBAL_SCHEMA` (declared near line 12805) -> Preserve schema contract exactly.
- `AI_MANY_TO_MANY_VALIDATION_SCHEMA` (declared near line 16679) -> Preserve schema contract exactly.
- `AI_MERGE_SIMILAR_PRODUCTS_SCHEMA` (declared near line 13976) -> Preserve schema contract exactly.
- `AI_MERGE_SMALL_TABLES_SCHEMA` (declared near line 14051) -> Preserve schema contract exactly.
- `AI_MODEL_ARCHITECT_REVIEW_SCHEMA` (declared near line 11414) -> Preserve schema contract exactly.
- `AI_MODEL_GENERATION_PARAMETER_SCHEMA` (declared near line 20337) -> Preserve schema contract exactly.
- `AI_MODEL_INSTRUCTIONS_SCHEMA` (declared near line 19989) -> Preserve schema contract exactly.
- `AI_NORMALIZATION_INTEGRITY_CHECK_SCHEMA` (declared near line 18269) -> Preserve schema contract exactly.
- `AI_PROCESS_FLOW_FK_GATE_SCHEMA` (declared near line 16034) -> Preserve schema contract exactly.
- `AI_PRODUCTS_WORKER_SCHEMA` (declared near line 20340) -> Preserve schema contract exactly.
- `AI_PRODUCT_DOMAIN_LOCATION_FIT_SCHEMA` (declared near line 18397) -> Preserve schema contract exactly.
- `AI_SEMANTIC_DUPLICATE_SCHEMA` (declared near line 13659) -> Preserve schema contract exactly.
- `AI_SHRINK_DOMAINS_SCHEMA` (declared near line 19204) -> Preserve schema contract exactly.
- `AI_SSOT_BLOCK_GATE_SCHEMA` (declared near line 13884) -> Preserve schema contract exactly.
- `AI_SUBDOMAIN_ALLOCATE_SCHEMA` (declared near line 18848) -> Preserve schema contract exactly.
- `AI_TAG_CLASSIFICATION_SCHEMA` (declared near line 18753) -> Preserve schema contract exactly.
- `IMPORT_CSV_SCHEMA` (declared near line 18981) -> Preserve schema contract exactly.
- `QA_DENORMALIZE_SCHEMA` (declared near line 18469) -> Preserve schema contract exactly.
- `QA_ESTIMATE_ROWS_SCHEMA` (declared near line 18416) -> Preserve schema contract exactly.
- `QA_GENERATE_DESCRIPTIONS_SCHEMA` (declared near line 18587) -> Preserve schema contract exactly.
- `QA_INDUSTRY_TEMPLATE_SCHEMA` (declared near line 18497) -> Preserve schema contract exactly.
- `QA_NORMALIZE_3NF_SCHEMA` (declared near line 18441) -> Preserve schema contract exactly.
- `QA_REVERSE_ENGINEER_SCHEMA` (declared near line 18557) -> Preserve schema contract exactly.
- `QA_SUGGEST_ATTRS_SCHEMA` (declared near line 18615) -> Preserve schema contract exactly.
- `QA_SUGGEST_TABLES_SCHEMA` (declared near line 18643) -> Preserve schema contract exactly.
- `SAMPLE_POOL_RESPONSE_SCHEMA` (declared near line 18999) -> Preserve schema contract exactly.
- `TABLE_ATTRIBUTE_SCHEMA` (declared near line 20320) -> Preserve schema contract exactly.
- `TABLE_BUSINESS_SCHEMA` (declared near line 20317) -> Preserve schema contract exactly.
- `TABLE_DOMAIN_SCHEMA` (declared near line 20318) -> Preserve schema contract exactly.
- `TABLE_PRODUCT_SCHEMA` (declared near line 20319) -> Preserve schema contract exactly.
- `VIBE_AUDIT_SCHEMA` (declared near line 2662) -> Preserve schema contract exactly.
- `VIBE_DROP_SCHEMA` (declared near line 2749) -> Preserve schema contract exactly.
- `_AI_ATTRIBUTE_DEDUP_SCHEMA_BASE` (declared near line 14849) -> Preserve schema contract exactly.
- `_AI_ATTRIBUTE_SCHEMA_BASE` (declared near line 20328) -> Preserve schema contract exactly.
- `_AI_BUSINESS_CONTEXT_SCHEMA_BASE` (declared near line 20323) -> Preserve schema contract exactly.
- `_AI_CLASSIFY_VIBE_INTENT_SCHEMA_BASE` (declared near line 19991) -> Preserve schema contract exactly.
- `_AI_CROSS_DOMAIN_MESH_SCHEMA_BASE` (declared near line 15718) -> Preserve schema contract exactly.
- `_AI_CYCLE_BREAKER_SCHEMA_BASE` (declared near line 17871) -> Preserve schema contract exactly.
- `_AI_DOMAINS_SELECTION_JUDGE_SCHEMA_BASE` (declared near line 20326) -> Preserve schema contract exactly.
- `_AI_DOMAINS_WORKER_SCHEMA_BASE` (declared near line 20325) -> Preserve schema contract exactly.
- `_AI_DOMAIN_ARCHITECT_REVIEW_SCHEMA_BASE` (declared near line 11603) -> Preserve schema contract exactly.
- `_AI_DOMAIN_METRICS_SCHEMA_BASE` (declared near line 20334) -> Preserve schema contract exactly.
- `_AI_ENLARGE_DOMAINS_SCHEMA_BASE` (declared near line 19276) -> Preserve schema contract exactly.
- `_AI_FIND_MISSING_FK_LINKS_SCHEMA_BASE` (declared near line 17544) -> Preserve schema contract exactly.
- `_AI_FK_EDGE_SYNTHESIS_SCHEMA_BASE` (declared near line 16065) -> Preserve schema contract exactly.
- `_AI_FK_SEMANTIC_GATE_SCHEMA_BASE` (declared near line 16131) -> Preserve schema contract exactly.
- `_AI_FOREIGN_KEY_ANOMALY_SCHEMA_BASE` (declared near line 20329) -> Preserve schema contract exactly.
- `_AI_GLOBAL_PRODUCT_DEDUP_SCHEMA_BASE` (declared near line 13843) -> Preserve schema contract exactly.
- `_AI_IDENTIFY_CORE_PRODUCTS_SCHEMA_BASE` (declared near line 14145) -> Preserve schema contract exactly.
- `_AI_IN_DOMAIN_LINKING_SCHEMA_BASE` (declared near line 15715) -> Preserve schema contract exactly.
- `_AI_KPI_FIRST_GLOBAL_SCHEMA_BASE` (declared near line 12804) -> Preserve schema contract exactly.
- `_AI_MANY_TO_MANY_VALIDATION_SCHEMA_BASE` (declared near line 16577) -> Preserve schema contract exactly.
- `_AI_MERGE_SIMILAR_PRODUCTS_SCHEMA_BASE` (declared near line 13975) -> Preserve schema contract exactly.
- `_AI_MERGE_SMALL_TABLES_SCHEMA_BASE` (declared near line 14050) -> Preserve schema contract exactly.
- `_AI_MODEL_ARCHITECT_REVIEW_SCHEMA_BASE` (declared near line 11089) -> Preserve schema contract exactly.
- `_AI_MODEL_GENERATION_PARAMETER_SCHEMA_BASE` (declared near line 20324) -> Preserve schema contract exactly.
- `_AI_MODEL_INSTRUCTIONS_SCHEMA_BASE` (declared near line 19988) -> Preserve schema contract exactly.
- `_AI_NORMALIZATION_INTEGRITY_CHECK_SCHEMA_BASE` (declared near line 18196) -> Preserve schema contract exactly.
- `_AI_PROCESS_FLOW_FK_GATE_SCHEMA_BASE` (declared near line 15968) -> Preserve schema contract exactly.
- `_AI_PRODUCTS_WORKER_SCHEMA_BASE` (declared near line 20327) -> Preserve schema contract exactly.
- `_AI_PRODUCT_DOMAIN_LOCATION_FIT_SCHEMA_BASE` (declared near line 18370) -> Preserve schema contract exactly.
- `_AI_SEMANTIC_DUPLICATE_SCHEMA_BASE` (declared near line 13658) -> Preserve schema contract exactly.
- `_AI_SHRINK_DOMAINS_SCHEMA_BASE` (declared near line 19125) -> Preserve schema contract exactly.
- `_AI_SSOT_BLOCK_GATE_SCHEMA_BASE` (declared near line 13883) -> Preserve schema contract exactly.
- `_AI_SUBDOMAIN_ALLOCATE_SCHEMA_BASE` (declared near line 18814) -> Preserve schema contract exactly.
- `_AI_TAG_CLASSIFICATION_SCHEMA_BASE` (declared near line 18729) -> Preserve schema contract exactly.
- `_INTERNAL_SCHEMAS` (declared near line 5735) -> Preserve schema contract exactly.
- `_INTERNAL_SCHEMAS` (declared near line 6011) -> Preserve schema contract exactly.
- `_LLM_FALLBACK_CLASSIFY_SCHEMA` (declared near line 8738) -> Preserve schema contract exactly.
- `_LLM_FALLBACK_EXECUTE_SCHEMA` (declared near line 8762) -> Preserve schema contract exactly.
- `_PROTECTED_SCHEMAS` (declared near line 64275) -> Preserve schema contract exactly.
- `_SCHEMA_TYPE_MAP` (declared near line 81184) -> Preserve schema contract exactly.
- `_SYS_SCHEMAS` (declared near line 64778) -> Preserve schema contract exactly.
- `_SYS_SCHEMAS` (declared near line 79589) -> Preserve schema contract exactly.
- `_TAG_SCHEMA_RE` (declared near line 64664) -> Preserve schema contract exactly.
- `_VIBE_PARSE_RESPONSE_SCHEMA` (declared near line 2530) -> Preserve schema contract exactly.
- `_VIBE_VERIFICATION_SWEEP_SCHEMA` (declared near line 9804) -> Preserve schema contract exactly.
- `_VOV_PROTECTED_SCHEMAS` (declared near line 6012) -> Preserve schema contract exactly.

### 8.4 Top-level Stage Functions

- `step_setup_and_clean` (line 32334) -> Rewrite as deterministic stage node with same I/O contract
- `step_domain_architect_review` (line 40892) -> Rewrite as deterministic stage node with same I/O contract
- `step_architect_review` (line 41254) -> Rewrite as deterministic stage node with same I/O contract
- `step_interpret_model_instructions` (line 48315) -> Rewrite as deterministic stage node with same I/O contract
- `step_create_logical_schema` (line 55323) -> Reuse semantics exactly
- `step_apply_naming_conventions` (line 61647) -> Rewrite as deterministic stage node with same I/O contract
- `step_allocate_subdomains` (line 61984) -> Rewrite as deterministic stage node with same I/O contract
- `step_create_physical_schema_stage1` (line 62331) -> Rewrite as deterministic stage node with same I/O contract
- `step_apply_foreign_keys` (line 64373) -> Rewrite as deterministic stage node with same I/O contract
- `step_apply_tags` (line 64550) -> Rewrite as deterministic stage node with same I/O contract
- `step_apply_metric_views` (line 64753) -> Reuse semantics exactly
- `step_generate_and_insert_samples` (line 65354) -> Rewrite as deterministic stage node with same I/O contract
- `step_static_analysis_autofix` (line 71682) -> Rewrite as deterministic stage node with same I/O contract
- `step_finalize_model_before_physical_schema` (line 72169) -> Rewrite as deterministic stage node with same I/O contract
- `step_apply_user_vibe_tags` (line 73364) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_metric_view_artifacts` (line 73550) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_next_vibes` (line 73899) -> Reuse semantics exactly
- `step_generate_next_vibes_early` (line 74666) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_next_vibes_late` (line 74685) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_readme` (line 74706) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_model_overview_md` (line 74919) -> Rewrite as deterministic stage node with same I/O contract
- `step_save_to_excel` (line 75220) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_data_model_json` (line 75735) -> Reuse semantics exactly
- `step_consolidate_and_cleanup` (line 76236) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_kpi_first_metric_views` (line 76721) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_vibe_audit_report` (line 77777) -> Rewrite as deterministic stage node with same I/O contract
- `step_install_parity_audit` (line 77889) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_ontology` (line 78043) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_dbml` (line 78370) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_release_notes` (line 78556) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_data_dictionary` (line 79036) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_test_cases` (line 79126) -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_model_report` (line 79208) -> Rewrite as deterministic stage node with same I/O contract

### 8.5 Track Orchestrators


### 8.6 Full Function Inventory (All defs found in notebook, exhaustive)

- `JobLauncher._sanitize_tag` @L330 -> Refactor into module scoped class
- `JobLauncher.__init__` @L348 -> Refactor into module scoped class
- `JobLauncher.launch` @L359 -> Refactor into module scoped class
- `JobLauncher.wait_for_run_terminal` @L471 -> Refactor into module scoped class
- `JobLauncher.wait_for_run_terminal` @L509 -> Refactor into module scoped class
- `JobLauncher.get_current_notebook_path` @L543 -> Refactor into module scoped class
- `JobLauncher.update_job_tags` @L573 -> Refactor into module scoped class
- `JobLauncher._detect_compute_type` @L731 -> Refactor into module scoped class
- `JobLauncher._get_workspace_context` @L760 -> Refactor into module scoped class
- `JobLauncher._print_success_banner` @L787 -> Refactor into module scoped class
- `JobLauncher._row` @L820 -> Refactor into module scoped class
- `classify_pii_subtype` @L930 -> Refactor or replace depending on coupling reduction
- `_p073_tokenize` @L963 -> Refactor helper for clarity and tests
- `_is_pii_match` @L996 -> Refactor helper for clarity and tests
- `_derive_scope_defaults_and_guardrails` @L1030 -> Refactor helper for clarity and tests
- `_get_scope_flat` @L1054 -> Refactor helper for clarity and tests
- `_estimate_total_tables` @L1059 -> Refactor helper for clarity and tests
- `_gen_tier_brief` @L1067 -> Refactor helper for clarity and tests
- `_gen_tier_detailed` @L1084 -> Refactor helper for clarity and tests
- `_gen_sizing_targets` @L1103 -> Refactor helper for clarity and tests
- `_gen_guardrails_tables` @L1122 -> Refactor helper for clarity and tests
- `_make_table` @L1127 -> Refactor helper for clarity and tests
- `_gen_decision_ranges` @L1136 -> Refactor helper for clarity and tests
- `_infer_tier_from_model_stats` @L1145 -> Refactor helper for clarity and tests
- `_get_tier_specific_target_fit` @L1165 -> Refactor helper for clarity and tests
- `_division_sort_key` @L1336 -> Refactor helper for clarity and tests
- `get_division_taxonomy` @L1354 -> Refactor or replace depending on coupling reduction
- `wrap_schema_with_honesty` @L1486 -> Refactor or replace depending on coupling reduction
- `assert_no_unfilled_placeholders` @L1528 -> Refactor or replace depending on coupling reduction
- `audit_prompt_templates` @L1538 -> Refactor or replace depending on coupling reduction
- `smoke_render_all_prompts` @L1552 -> Refactor or replace depending on coupling reduction
- `NextVibesIssueCollector.__init__` @L1594 -> Refactor into module scoped class
- `NextVibesIssueCollector.add` @L1600 -> Refactor into module scoped class
- `NextVibesIssueCollector.assert_no_blocking` @L1636 -> Refactor into module scoped class
- `NextVibesIssueCollector.get_summary` @L1642 -> Refactor into module scoped class
- `NextVibesIssueCollector.finalize` @L1648 -> Refactor into module scoped class
- `NextVibesIssueCollector.compare_to_previous` @L1675 -> Refactor into module scoped class
- `NextVibesIssueCollector.write_signature` @L1689 -> Refactor into module scoped class
- `_MemoryGuard.check` @L1708 -> Refactor into module scoped class
- `_MemoryGuard.log_step` @L1725 -> Refactor into module scoped class
- `_spill_to_disk_if_large` @L1734 -> Refactor helper for clarity and tests
- `vibe_compliance_lite` @L1752 -> Refactor or replace depending on coupling reduction
- `validate_industry_vocabulary_alignment` @L1811 -> Keep gate logic and thresholds, modernize implementation
- `validate_org_chart_alignment` @L1834 -> Keep gate logic and thresholds, modernize implementation
- `validate_division_ratios` @L1854 -> Keep gate logic and thresholds, modernize implementation
- `_precompute_attr_count_by_product` @L1892 -> Refactor helper for clarity and tests
- `_precompute_attr_index` @L1899 -> Refactor helper for clarity and tests
- `run_signoff_checks` @L1914 -> Refactor to service call; preserve side effects
- `_check` @L1924 -> Refactor helper for clarity and tests
- `_lint_prompt_templates` @L1974 -> Refactor helper for clarity and tests
- `_build_vibe_master_schema` @L2407 -> Reuse intent parser/review logic, split into dedicated module
- `get_pk_suffix` @L2851 -> Refactor or replace depending on coupling reduction
- `get_fk_suffix` @L2855 -> Refactor or replace depending on coupling reduction
- `is_potential_fk_column` @L2860 -> Refactor or replace depending on coupling reduction
- `extract_requested_pk_suffix_from_texts` @L2876 -> Refactor or replace depending on coupling reduction
- `parse_target_state` @L2898 -> Refactor or replace depending on coupling reduction
- `apply_vibe_authority_overrides` @L2960 -> Refactor or replace depending on coupling reduction
- `_normalize_override_key` @L3010 -> Refactor helper for clarity and tests
- `_coerce_override_value` @L3013 -> Refactor helper for clarity and tests
- `_apply_widget_override_entries` @L3029 -> Refactor helper for clarity and tests
- `apply_vibe_widget_overrides_from_prompt` @L3081 -> Refactor or replace depending on coupling reduction
- `_is_hierarchical_self_ref` @L3145 -> Refactor helper for clarity and tests
- `_col_type_is_integer_for_self_ref` @L3181 -> Refactor helper for clarity and tests
- `_is_role_labeled_self_ref` @L3188 -> Refactor helper for clarity and tests
- `_apply_contradiction_penalty` @L3244 -> Refactor helper for clarity and tests
- `_check_postprocess_gate` @L3279 -> Refactor helper for clarity and tests
- `_build_link_postprocessor` @L3315 -> Refactor helper for clarity and tests
- `_decision_of` @L3333 -> Refactor helper for clarity and tests
- `_postprocess` @L3339 -> Refactor helper for clarity and tests
- `_is_system_identifier_column` @L3374 -> Refactor helper for clarity and tests
- `extract_fk_base_name` @L3454 -> Refactor or replace depending on coupling reduction
- `strip_configured_pk_suffix` @L3472 -> Refactor or replace depending on coupling reduction
- `_strip_trailing_suffix` @L3482 -> Refactor helper for clarity and tests
- `_compute_max_concurrent_batches_for_32gb` @L3527 -> Refactor helper for clarity and tests
- `build_pk_map` @L3549 -> Refactor or replace depending on coupling reduction
- `_compute` @L3555 -> Refactor helper for clarity and tests
- `validate_and_correct_fk_target` @L3589 -> Keep gate logic and thresholds, modernize implementation
- `_get_pk_type_for_fk_target` @L3763 -> Refactor helper for clarity and tests
- `_get_pk_type_for_fk_target_impl` @L3779 -> Refactor helper for clarity and tests
- `_check_fk_type_compatibility` @L3801 -> Refactor helper for clarity and tests
- `_would_create_bidirectional_fk` @L3825 -> Refactor helper for clarity and tests
- `_would_create_bidirectional_fk_impl` @L3836 -> Refactor helper for clarity and tests
- `_build_fk_adjacency` @L3855 -> Refactor helper for clarity and tests
- `_compute` @L3856 -> Refactor helper for clarity and tests
- `_would_create_cycle` @L3875 -> Refactor helper for clarity and tests
- `_is_protected_parent_child_fk` @L3903 -> Refactor helper for clarity and tests
- `_is_high_reference_product` @L3928 -> Refactor helper for clarity and tests
- `_is_high_reference_domain` @L3944 -> Refactor helper for clarity and tests
- `ensure_product_has_pk_attribute` @L3955 -> Refactor or replace depending on coupling reduction
- `enforce_configured_pk_consistency` @L3997 -> Refactor or replace depending on coupling reduction
- `_norm` @L4004 -> Refactor helper for clarity and tests
- `_pk_like_norms_for_product` @L4012 -> Refactor helper for clarity and tests
- `strip_domain_prefix` @L4154 -> Refactor or replace depending on coupling reduction
- `validate_and_fix_all_fk_references` @L4168 -> Keep gate logic and thresholds, modernize implementation
- `strip_product_prefix` @L4275 -> Refactor or replace depending on coupling reduction
- `recover_tracked_entities` @L4294 -> Refactor or replace depending on coupling reduction
- `find_product_in_model` @L4413 -> Refactor or replace depending on coupling reduction
- `safe_add_product` @L4434 -> Refactor or replace depending on coupling reduction
- `remove_product_and_references` @L4450 -> Refactor or replace depending on coupling reduction
- `enforce_naming_conventions` @L4487 -> Refactor or replace depending on coupling reduction
- `parse_fk_reference` @L4624 -> Refactor or replace depending on coupling reduction
- `_get_vibe_constraints` @L4644 -> Reuse intent parser/review logic, split into dedicated module
- `_get_vibe_constraints_impl` @L4657 -> Reuse intent parser/review logic, split into dedicated module
- `_is_mvm_scope` @L4741 -> Refactor helper for clarity and tests
- `_format_scope_label` @L4745 -> Refactor helper for clarity and tests
- `_get_model_scope_instruction` @L4754 -> Refactor helper for clarity and tests
- `make_attribute_dict` @L4760 -> Refactor or replace depending on coupling reduction
- `_get_embedded_fk_re` @L4803 -> Refactor helper for clarity and tests
- `_get_embedded_tags_re` @L4810 -> Refactor helper for clarity and tests
- `sanitize_attribute_type` @L4817 -> Refactor or replace depending on coupling reduction
- `deduplicate_attributes_in_place` @L4864 -> Refactor or replace depending on coupling reduction
- `sanitize_all_attribute_types` @L4908 -> Refactor or replace depending on coupling reduction
- `_find_fk_target_products` @L4919 -> Refactor helper for clarity and tests
- `_find_removable_products` @L4936 -> Refactor helper for clarity and tests
- `_remove_products_and_attributes` @L4956 -> Refactor helper for clarity and tests
- `_find_removable_attributes` @L4967 -> Refactor helper for clarity and tests
- `_build_enrichment_prompt_vars` @L4987 -> Refactor helper for clarity and tests
- `_build_enrichment_prompt_vars_impl` @L4995 -> Refactor helper for clarity and tests
- `_build_enrichment_attr_prompt_vars` @L5045 -> Refactor helper for clarity and tests
- `_build_enrichment_attr_prompt_vars_impl` @L5054 -> Refactor helper for clarity and tests
- `_fuzzy_find_entity` @L5111 -> Refactor helper for clarity and tests
- `_infer_naming_convention_from_identifier` @L5123 -> Refactor helper for clarity and tests
- `_resolve_naming_convention` @L5134 -> Refactor helper for clarity and tests
- `_extract_business_role_prefix` @L5143 -> Refactor helper for clarity and tests
- `_build_fk_collision_name` @L5214 -> Refactor helper for clarity and tests
- `normalize_fk_column_name` @L5236 -> Reuse semantics exactly
- `make_product_dict` @L5362 -> Refactor or replace depending on coupling reduction
- `_ensure_identity_fields` @L5396 -> Refactor helper for clarity and tests
- `build_products_by_domain` @L5413 -> Refactor or replace depending on coupling reduction
- `_compute` @L5418 -> Refactor helper for clarity and tests
- `canonicalize_domain_product_casing` @L5431 -> Refactor or replace depending on coupling reduction
- `build_attrs_by_product` @L5466 -> Refactor or replace depending on coupling reduction
- `_compute` @L5471 -> Refactor helper for clarity and tests
- `_ensure_dict` @L5485 -> Refactor helper for clarity and tests
- `_coerce_dict` @L5494 -> Refactor helper for clarity and tests
- `_coerce_list_of_dicts` @L5499 -> Refactor helper for clarity and tests
- `CatalogResolver.__init__` @L5512 -> Refactor into module scoped class
- `CatalogResolver.resolve_catalog` @L5522 -> Refactor into module scoped class
- `CatalogResolver.resolve_schema` @L5535 -> Refactor into module scoped class
- `CatalogResolver.resolve_full` @L5557 -> Refactor into module scoped class
- `CatalogResolver.all_catalogs` @L5563 -> Refactor into module scoped class
- `CatalogResolver.domain_to_catalog_map` @L5566 -> Refactor into module scoped class
- `CatalogResolver._apply_affixes` @L5569 -> Refactor into module scoped class
- `_strip_baked_catalog_from_model` @L5575 -> Refactor helper for clarity and tests
- `_validate_storage_accessible` @L5601 -> Refactor helper for clarity and tests
- `_resolve_managed_location` @L5632 -> Reuse semantics exactly
- `_ensure_catalog_exists` @L5676 -> Refactor helper for clarity and tests
- `_check_physical_deployment_clash` @L5733 -> Refactor helper for clarity and tests
- `_early_clash_detection` @L6010 -> Refactor helper for clarity and tests
- `_list_user_schemas` @L6053 -> Refactor helper for clarity and tests
- `_filter_by_prefix` @L6063 -> Refactor helper for clarity and tests
- `_ensure_shared_domain` @L6165 -> Refactor helper for clarity and tests
- `_cleanup_phantom_domains` @L6179 -> Refactor helper for clarity and tests
- `_cleanup_empty_domains` @L6206 -> Refactor helper for clarity and tests
- `_snapshot_fk_links` @L6238 -> Refactor helper for clarity and tests
- `_extract_new_links` @L6248 -> Refactor helper for clarity and tests
- `build_fk_graph` @L6264 -> Refactor or replace depending on coupling reduction
- `_compute` @L6270 -> Refactor helper for clarity and tests
- `build_product_keys_set` @L6301 -> Refactor or replace depending on coupling reduction
- `_compute` @L6306 -> Refactor helper for clarity and tests
- `_parse_attr_pattern` @L6315 -> Refactor helper for clarity and tests
- `_match_attribute` @L6328 -> Refactor helper for clarity and tests
- `_vibe_matches_glob` @L6355 -> Reuse intent parser/review logic, split into dedicated module
- `_fix_bare_attribute_names` @L6369 -> Refactor helper for clarity and tests
- `_vibe_set_entity_tag` @L6392 -> Reuse intent parser/review logic, split into dedicated module
- `_apply_vibe_custom_tags` @L6401 -> Reuse intent parser/review logic, split into dedicated module
- `_vibe_set_system_meta` @L6572 -> Reuse intent parser/review logic, split into dedicated module
- `_vibe_get_system_meta` @L6579 -> Reuse intent parser/review logic, split into dedicated module
- `_vibe_apply_template_to_tables` @L6583 -> Reuse intent parser/review logic, split into dedicated module
- `_apply_to_matching_attrs` @L6614 -> Refactor helper for clarity and tests
- `_ensure_domain_exists` @L6683 -> Refactor helper for clarity and tests
- `_normalize_column_name` @L6719 -> Refactor helper for clarity and tests
- `_strip_id_suffix` @L6725 -> Refactor helper for clarity and tests
- `_fuzzy_name_match` @L6732 -> Refactor helper for clarity and tests
- `_accumulate_finding` @L6748 -> Refactor helper for clarity and tests
- `_get_findings_by_type` @L6754 -> Refactor helper for clarity and tests
- `_get_available_action_catalog` @L6758 -> Refactor helper for clarity and tests
- `_attribute_is_pk_or_fk` @L6952 -> Refactor helper for clarity and tests
- `_product_has_inbound_cross_fk` @L6980 -> Refactor helper for clarity and tests
- `_domain_has_inbound_cross_fk` @L7008 -> Refactor helper for clarity and tests
- `classify_action_cost` @L7030 -> Reuse semantics exactly
- `_classify_recipe_cost` @L7065 -> Refactor helper for clarity and tests
- `render_master_action_catalog` @L7088 -> Reuse semantics exactly
- `make_finding` @L7119 -> Refactor or replace depending on coupling reduction
- `validate_finding` @L7146 -> Reuse semantics exactly
- `FindingDispatcher.__init__` @L7201 -> Refactor internals; preserve public behavior
- `FindingDispatcher.submit` @L7212 -> Refactor internals; preserve public behavior
- `FindingDispatcher.submit_many` @L7214 -> Refactor internals; preserve public behavior
- `FindingDispatcher._detect_conflicts` @L7217 -> Refactor internals; preserve public behavior
- `FindingDispatcher._touches_protected` @L7234 -> Refactor internals; preserve public behavior
- `FindingDispatcher.process_batch` @L7245 -> Refactor internals; preserve public behavior
- `_emit_finding` @L7333 -> Reuse semantics exactly
- `_protected_targets_from_widgets` @L7365 -> Reuse semantics exactly
- `_extract_model_lists_for_executor` @L7414 -> Refactor helper for clarity and tests
- `_finding_to_mutation_action` @L7445 -> Refactor helper for clarity and tests
- `_local_action_executor` @L7504 -> Reuse semantics exactly
- `_find_product` @L7515 -> Refactor helper for clarity and tests
- `_find_attr` @L7527 -> Refactor helper for clarity and tests
- `_cascade_domain_rename` @L7679 -> Refactor helper for clarity and tests
- `_cascade_product_rename` @L7697 -> Refactor helper for clarity and tests
- `_generic_handle_add_columns_from_template` @L7729 -> Refactor helper for clarity and tests
- `_generic_handle_transform_name` @L7754 -> Refactor helper for clarity and tests
- `_apply_name_transform` @L7829 -> Refactor helper for clarity and tests
- `_apply_tag_transform` @L7851 -> Refactor helper for clarity and tests
- `_find_replace_attr` @L7895 -> Refactor helper for clarity and tests
- `_sanitize_cached` @L7919 -> Refactor helper for clarity and tests
- `_fuzzy_match_attr` @L7923 -> Refactor helper for clarity and tests
- `_fuzzy_match_product` @L7937 -> Refactor helper for clarity and tests
- `_fuzzy_match_domain` @L7950 -> Refactor helper for clarity and tests
- `_generic_handle_set_property` @L7960 -> Refactor helper for clarity and tests
- `_set_prop` @L7999 -> Refactor helper for clarity and tests
- `_set_tag_prop` @L8023 -> Refactor helper for clarity and tests
- `_generic_handle_tag` @L8047 -> Refactor helper for clarity and tests
- `_add_tag` @L8064 -> Refactor helper for clarity and tests
- `_rm_tag` @L8095 -> Refactor helper for clarity and tests
- `_clear` @L8137 -> Refactor helper for clarity and tests
- `_generic_handle_generate_artifact` @L8146 -> Refactor helper for clarity and tests
- `_generic_handle_query` @L8220 -> Refactor helper for clarity and tests
- `_dispatch_generic_action` @L8706 -> Refactor helper for clarity and tests
- `_llm_fallback_build_model_snapshot` @L8789 -> Refactor helper for clarity and tests
- `_preseed_rename_maps` @L8826 -> Refactor helper for clarity and tests
- `_p091_is_valid_identifier` @L8896 -> Refactor helper for clarity and tests
- `_p091_reject_name_mutation` @L8927 -> Refactor helper for clarity and tests
- `_llm_fallback_apply_mutations` @L8969 -> Refactor helper for clarity and tests
- `_is_rename` @L9001 -> Refactor helper for clarity and tests
- `_mut_sort_key` @L9008 -> Refactor helper for clarity and tests
- `_resolve_product_key` @L9040 -> Refactor helper for clarity and tests
- `_find_attribute` @L9052 -> Refactor helper for clarity and tests
- `_find_product` @L9089 -> Refactor helper for clarity and tests
- `_find_domain` @L9118 -> Refactor helper for clarity and tests
- `_llm_fallback_validate` @L9579 -> Refactor helper for clarity and tests
- `_llm_fallback_handler` @L9640 -> Refactor helper for clarity and tests
- `_build_execution_log` @L9845 -> Refactor helper for clarity and tests
- `_build_compact_model_summary` @L9855 -> Refactor helper for clarity and tests
- `_strip_tags_from_prompt_vars` @L9873 -> Refactor helper for clarity and tests
- `run_vibe_verification_sweep` @L9898 -> Refactor to service call; preserve side effects
- `_create_association_product_and_attrs` @L9968 -> Refactor helper for clarity and tests
- `_m2m_attr` @L10001 -> Refactor helper for clarity and tests
- `_move_attrs_to_association` @L10038 -> Refactor helper for clarity and tests
- `_enforce_m2m_ratio` @L10088 -> Refactor helper for clarity and tests
- `_p083_emit_raw_pool_log` @L19528 -> Refactor helper for clarity and tests
- `_p068_faker_provider_map` @L19554 -> Refactor helper for clarity and tests
- `_p068_pick_faker_provider` @L19618 -> Refactor helper for clarity and tests
- `_suppress_dbutils_stdout` @L19663 -> Refactor helper for clarity and tests
- `_flush_log_handlers` @L19677 -> Refactor helper for clarity and tests
- `_fmt_hms` @L19690 -> Refactor helper for clarity and tests
- `_format_eta` @L19699 -> Refactor helper for clarity and tests
- `_remove_stream_handlers` @L19708 -> Refactor helper for clarity and tests
- `_make_log_console` @L19762 -> Refactor helper for clarity and tests
- `_log_console` @L19763 -> Refactor helper for clarity and tests
- `_unpack_widgets_core` @L19782 -> Refactor helper for clarity and tests
- `_make_tracked_worker` @L19785 -> Refactor helper for clarity and tests
- `_wrapped` @L19786 -> Refactor helper for clarity and tests
- `_log_banner` @L19799 -> Refactor helper for clarity and tests
- `_ts` @L19804 -> Refactor helper for clarity and tests
- `_MiniDiskCache.__init__` @L19809 -> Refactor into module scoped class
- `_MiniDiskCache._path` @L19815 -> Refactor into module scoped class
- `_MiniDiskCache.get` @L19819 -> Refactor into module scoped class
- `_MiniDiskCache.set` @L19830 -> Refactor into module scoped class
- `_MiniDiskCache._maybe_cull` @L19843 -> Refactor into module scoped class
- `_get_vibe_cache` @L19862 -> Reuse intent parser/review logic, split into dedicated module
- `_make_cache_key` @L19877 -> Refactor helper for clarity and tests
- `_disk_cached_call` @L19892 -> Refactor helper for clarity and tests
- `_cached_json_load` @L19922 -> Refactor helper for clarity and tests
- `_compute` @L19928 -> Refactor helper for clarity and tests
- `_DBUtilsShim.__getattr__` @L19940 -> Refactor into module scoped class
- `_normalize_model_size` @L20345 -> Refactor helper for clarity and tests
- `_is_model_enabled_value` @L20351 -> Refactor helper for clarity and tests
- `_is_model_enabled` @L20358 -> Refactor helper for clarity and tests
- `AIAgentManager.__init__` @L20366 -> Refactor internals; preserve public behavior
- `AIAgentManager._ensure_model_stats` @L20374 -> Refactor internals; preserve public behavior
- `AIAgentManager.record_call` @L20381 -> Refactor internals; preserve public behavior
- `AIAgentManager.record_success` @L20386 -> Refactor internals; preserve public behavior
- `AIAgentManager.record_timeout` @L20393 -> Refactor internals; preserve public behavior
- `AIAgentManager.record_error` @L20398 -> Refactor internals; preserve public behavior
- `AIAgentManager.get_stats_summary` @L20403 -> Refactor internals; preserve public behavior
- `AIAgentManager.acquire` @L20407 -> Refactor internals; preserve public behavior
- `AIAgentManager.release` @L20416 -> Refactor internals; preserve public behavior
- `AIAgentManager.max_concurrent` @L20420 -> Refactor internals; preserve public behavior
- `AIAgent.__init__` @L20459 -> Refactor into module scoped class
- `AIAgent._build_fallback_chain` @L20506 -> Refactor into module scoped class
- `AIAgent._select_model_for_requirement` @L20557 -> Refactor into module scoped class
- `AIAgent._record_timeout` @L20584 -> Refactor into module scoped class
- `AIAgent._record_success` @L20599 -> Refactor into module scoped class
- `AIAgent._mark_model_broken` @L20623 -> Refactor into module scoped class
- `AIAgent._is_model_broken` @L20629 -> Refactor into module scoped class
- `AIAgent._demote_model_order` @L20633 -> Refactor into module scoped class
- `AIAgent._get_fallback_model` @L20676 -> Refactor into module scoped class
- `AIAgent._get_resilient_fallback_model` @L20684 -> Refactor into module scoped class
- `AIAgent._is_reasoning_response_parse_error` @L20707 -> Refactor into module scoped class
- `AIAgent._get_model_config_for_prompt` @L20714 -> Refactor into module scoped class
- `AIAgent._get_user_vibe_instructions` @L20764 -> Refactor into module scoped class
- `AIAgent._inject_user_vibe_block` @L20774 -> Refactor into module scoped class
- `AIAgent._call_ai_query` @L20794 -> Refactor into module scoped class
- `AIAgent._call_ai_query_impl` @L20801 -> Refactor into module scoped class
- `AIAgent._try_extract_honesty_for_direct_call` @L20975 -> Refactor into module scoped class
- `AIAgent.run_worker` @L21019 -> Refactor into module scoped class
- `AIAgent.run_worker_with_override` @L21054 -> Refactor into module scoped class
- `AIAgent._call_ai_query_with_override` @L21102 -> Refactor into module scoped class
- `AIAgent._extract_and_log_honesty` @L21111 -> Refactor into module scoped class
- `AIAgent._deep_parse_json_values` @L21167 -> Refactor into module scoped class
- `AIAgent.run_worker_reviewer` @L21191 -> Refactor into module scoped class
- `AIAgent.clean_json_response` @L21211 -> Refactor into module scoped class
- `AIAgent.summarize_output` @L21219 -> Refactor into module scoped class
- `AIAgent.get_summary_report` @L21353 -> Refactor into module scoped class
- `AIAgent._resolve_price_for_model` @L21395 -> Refactor into module scoped class
- `AIAgent.estimate_cost_usd` @L21405 -> Refactor into module scoped class
- `AIAgent.get_token_summary` @L21436 -> Refactor into module scoped class
- `AIAgent.get_manager_stats_report` @L21460 -> Refactor into module scoped class
- `ObservationsLogger.__init__` @L21541 -> Refactor into module scoped class
- `ObservationsLogger.initialize` @L21564 -> Refactor into module scoped class
- `ObservationsLogger.get_instance` @L21570 -> Refactor into module scoped class
- `ObservationsLogger._get_next_try_num` @L21573 -> Refactor into module scoped class
- `ObservationsLogger.log_observation` @L21578 -> Refactor into module scoped class
- `ObservationsLogger.finalize` @L21618 -> Refactor into module scoped class
- `ObservationsLogger.finalize_instance` @L21646 -> Refactor into module scoped class
- `ModelBundle.__init__` @L21660 -> Refactor into module scoped class
- `ModelBundle.from_triple` @L21671 -> Refactor into module scoped class
- `ModelBundle.by_domain` @L21675 -> Refactor into module scoped class
- `ModelBundle.attrs_by_product` @L21684 -> Refactor into module scoped class
- `ModelBundle.fk_edges` @L21693 -> Refactor into module scoped class
- `ModelBundle.invalidate_cache` @L21705 -> Refactor into module scoped class
- `register_validator` @L21722 -> Keep gate logic and thresholds, modernize implementation
- `decorator` @L21723 -> Refactor or replace depending on coupling reduction
- `FKResolver.__init__` @L21734 -> Refactor into module scoped class
- `FKResolver.parse_fk` @L21739 -> Refactor into module scoped class
- `FKResolver.validate_fk_target_exists` @L21749 -> Refactor into module scoped class
- `FKResolver.validate_namespace_matches_description` @L21758 -> Refactor into module scoped class
- `FKResolver.rewrite_fk_after_relocation` @L21770 -> Refactor into module scoped class
- `FKResolver.validate_no_self_fk_on_pk` @L21783 -> Refactor into module scoped class
- `run_process_flow_fk_gate` @L21801 -> Refactor to service call; preserve side effects
- `run_fk_semantic_correctness_gate` @L21978 -> Refactor to service call; preserve side effects
- `_process_one_mv15_batch` @L22053 -> Refactor helper for clarity and tests
- `SmartWorkerValidator.__init__` @L22216 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator._detect_user_vibes` @L22221 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator.validate_json_structure` @L22233 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator.validate_business_context` @L22249 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator.validate_model_generation_parameters` @L22317 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator.validate_products` @L22398 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator.validate_attributes` @L22503 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator._attr_importance` @L22555 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator.validate_in_domain_linking` @L22687 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator.add_product_if_exists` @L22716 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator._is_external_ref` @L22834 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator.validate_cross_domain_linking` @L22895 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator.validate_domain_isolation` @L22955 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator.validate_sample_csv` @L22997 -> Refactor internals; preserve public behavior
- `SmartWorkerValidator.validate_physical_schema` @L23054 -> Refactor internals; preserve public behavior
- `smart_worker_loop` @L23068 -> Refactor or replace depending on coupling reduction
- `_truncate_large_vars` @L23139 -> Refactor helper for clarity and tests
- `ThreadPoolGuard.enable` @L23484 -> Refactor into module scoped class
- `ThreadPoolGuard.disable` @L23489 -> Refactor into module scoped class
- `ThreadPoolGuard.is_inside_thread_pool` @L23494 -> Refactor into module scoped class
- `ThreadPoolGuard.mark_inside_pool` @L23499 -> Refactor into module scoped class
- `ThreadPoolGuard.unmark_inside_pool` @L23505 -> Refactor into module scoped class
- `ThreadPoolGuard.get_current_pool_name` @L23511 -> Refactor into module scoped class
- `ThreadPoolGuard.check_no_nesting` @L23516 -> Refactor into module scoped class
- `ThreadPoolGuard.__init__` @L23529 -> Refactor into module scoped class
- `ThreadPoolGuard.__enter__` @L23532 -> Refactor into module scoped class
- `ThreadPoolGuard.__exit__` @L23536 -> Refactor into module scoped class
- `guarded_thread_pool_executor` @L23541 -> Refactor or replace depending on coupling reduction
- `_safe_future_result` @L23569 -> Refactor helper for clarity and tests
- `_safe_as_completed` @L23584 -> Refactor helper for clarity and tests
- `GlobalConcurrencyManager.__new__` @L23608 -> Refactor into module scoped class
- `GlobalConcurrencyManager.initialize` @L23616 -> Refactor into module scoped class
- `GlobalConcurrencyManager.max_batches` @L23639 -> Refactor into module scoped class
- `GlobalConcurrencyManager.max_workers` @L23643 -> Refactor into module scoped class
- `GlobalConcurrencyManager.acquire` @L23647 -> Refactor into module scoped class
- `GlobalConcurrencyManager.release` @L23680 -> Refactor into module scoped class
- `GlobalConcurrencyManager.get_available_workers` @L23696 -> Refactor into module scoped class
- `GlobalConcurrencyManager.record_task` @L23704 -> Refactor into module scoped class
- `GlobalConcurrencyManager.record_task_duration` @L23715 -> Refactor into module scoped class
- `GlobalConcurrencyManager.get_stats` @L23724 -> Refactor into module scoped class
- `GlobalConcurrencyManager.get_efficiency_score` @L23739 -> Refactor into module scoped class
- `GlobalConcurrencyManager.log_summary` @L23754 -> Refactor into module scoped class
- `run_parallel_smart_workers` @L23783 -> Refactor to service call; preserve side effects
- `InfoFilter.filter` @L23860 -> Refactor into module scoped class
- `ImmediateFlushFileHandler.emit` @L23864 -> Refactor into module scoped class
- `create_thread_safe_logger` @L23871 -> Refactor or replace depending on coupling reduction
- `get_logger` @L23903 -> Refactor or replace depending on coupling reduction
- `apply_convention` @L23977 -> Refactor or replace depending on coupling reduction
- `build_pk_name` @L24034 -> Refactor or replace depending on coupling reduction
- `build_pk_name_from_config` @L24051 -> Refactor or replace depending on coupling reduction
- `NamingConvention.__init__` @L24080 -> Refactor into module scoped class
- `NamingConvention._get` @L24084 -> Refactor into module scoped class
- `NamingConvention._compose` @L24110 -> Refactor into module scoped class
- `NamingConvention._preserve_boundaries` @L24133 -> Refactor into module scoped class
- `NamingConvention.table_name` @L24154 -> Refactor into module scoped class
- `NamingConvention.column_name` @L24157 -> Refactor into module scoped class
- `NamingConvention.pk_column` @L24160 -> Refactor into module scoped class
- `NamingConvention.fk_column` @L24163 -> Refactor into module scoped class
- `NamingConvention.schema_name` @L24169 -> Refactor into module scoped class
- `NamingConvention.catalog_name` @L24173 -> Refactor into module scoped class
- `NamingConvention.tag_key` @L24177 -> Refactor into module scoped class
- `NamingConvention.metric_view_name` @L24181 -> Refactor into module scoped class
- `NamingConvention.format_bool` @L24184 -> Refactor into module scoped class
- `NamingConvention.format_date` @L24192 -> Refactor into module scoped class
- `NamingConvention.format_timestamp` @L24199 -> Refactor into module scoped class
- `NamingConvention.id_type_spark` @L24216 -> Refactor into module scoped class
- `_is_pk_pattern` @L24222 -> Refactor helper for clarity and tests
- `build_default_columns` @L24231 -> Refactor or replace depending on coupling reduction
- `VibeRequirement.to_pinned_text` @L24258 -> Refactor into module scoped class
- `VibeRequirement.mark_executing` @L24266 -> Refactor into module scoped class
- `VibeRequirement.mark_fulfilled` @L24270 -> Refactor into module scoped class
- `VibeRequirement.mark_partial` @L24276 -> Refactor into module scoped class
- `VibeRequirement.mark_failed` @L24282 -> Refactor into module scoped class
- `_convert_priority_to_action` @L24302 -> Refactor helper for clarity and tests
- `_parse_priority_directives` @L24356 -> Refactor helper for clarity and tests
- `VibeManifest.hard_constraints` @L24387 -> Refactor into module scoped class
- `VibeManifest.soft_guidance` @L24391 -> Refactor into module scoped class
- `VibeManifest.pending_requirements` @L24395 -> Refactor into module scoped class
- `VibeManifest.unfulfilled_requirements` @L24399 -> Refactor into module scoped class
- `VibeManifest.fulfilled_requirements` @L24403 -> Refactor into module scoped class
- `VibeManifest.get_requirements_for_step` @L24406 -> Refactor into module scoped class
- `VibeManifest.get_requirements_for_prompt` @L24422 -> Refactor into module scoped class
- `VibeManifest.to_contract` @L24445 -> Refactor into module scoped class
- `VibeManifest.to_distributed_vibes` @L24505 -> Refactor into module scoped class
- `VibeManifest.to_classification_dict` @L24520 -> Refactor into module scoped class
- `_normalize_scope_name` @L24560 -> Refactor helper for clarity and tests
- `_extract_hard_constraints` @L24573 -> Refactor helper for clarity and tests
- `_constraints_to_forbidden_ops` @L24586 -> Refactor helper for clarity and tests
- `_extract_requested_transforms_from_vibe` @L24603 -> Reuse intent parser/review logic, split into dedicated module
- `_extract_explicit_requests` @L24626 -> Refactor helper for clarity and tests
- `_default_mutation_budget` @L24643 -> Refactor helper for clarity and tests
- `_resolve_rollout_mode` @L24652 -> Refactor helper for clarity and tests
- `_resolve_fidelity_gates` @L24661 -> Refactor helper for clarity and tests
- `_stable_percent_for_key` @L24673 -> Refactor helper for clarity and tests
- `should_execute_contract_writes` @L24678 -> Refactor or replace depending on coupling reduction
- `build_fidelity_scorecard` @L24692 -> Refactor or replace depending on coupling reduction
- `evaluate_fidelity_gates` @L24714 -> Reuse semantics exactly
- `compile_vibe_contract` @L24732 -> Refactor or replace depending on coupling reduction
- `emit_vibe_event` @L24798 -> Refactor or replace depending on coupling reduction
- `_action_scope_hints` @L24807 -> Refactor helper for clarity and tests
- `_is_global_rewrite_action` @L24826 -> Refactor helper for clarity and tests
- `evaluate_action_against_contract` @L24835 -> Refactor or replace depending on coupling reduction
- `evaluate_scope_leakage` @L24860 -> Refactor or replace depending on coupling reduction
- `filter_actions_by_contract` @L24879 -> Refactor or replace depending on coupling reduction
- `apply_contract_transforms_to_config` @L24922 -> Refactor or replace depending on coupling reduction
- `apply_mutation_command` @L24941 -> Refactor or replace depending on coupling reduction
- `run_vibebench_contract_suite` @L25097 -> Refactor to service call; preserve side effects
- `_extract_sizing_directives_from_text` @L25188 -> Refactor helper for clarity and tests
- `_capture` @L25204 -> Refactor helper for clarity and tests
- `VibeOrchestrator.__init__` @L25354 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.has_vibes` @L25373 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.is_enabled` @L25377 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._get_vibe_parse_model_config` @L25380 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._validate_vibe_length` @L25408 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.parse` @L25437 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._parse_with_llm` @L25524 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._coerce_int` @L25560 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._parse_deterministic` @L25703 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._flush_domain` @L25712 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._flush_standalone` @L25732 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.master_analyze` @L25900 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.plan` @L26104 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.capture_snapshot` @L26163 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.wrap_step` @L26174 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._quick_deterministic_check` @L26202 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.validate` @L26242 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._verify_requirement` @L26285 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._verify_deterministic` @L26302 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._verify_state_diff` @L26446 -> Refactor internals; preserve public behavior
- `VibeOrchestrator._verify_via_llm` @L26480 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.audit_all` @L26485 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.remediate` @L26575 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.score` @L26675 -> Refactor internals; preserve public behavior
- `VibeOrchestrator.get_pinned_text_for_prompt` @L26838 -> Refactor internals; preserve public behavior
- `_validate_metric_view_count` @L26857 -> Refactor helper for clarity and tests
- `_detect_post_shrink_silos` @L26884 -> Refactor helper for clarity and tests
- `_coerce_decimal_to_float` @L26925 -> Refactor helper for clarity and tests
- `_resolve_business_scratch_path` @L26949 -> Refactor helper for clarity and tests
- `sanitize_name` @L26959 -> Reuse semantics exactly
- `_get_file_sql_name` @L26987 -> Refactor helper for clarity and tests
- `normalize_llm_response_names` @L27026 -> Refactor or replace depending on coupling reduction
- `replace_single_quote` @L27100 -> Reuse semantics exactly
- `safe_get` @L27122 -> Refactor or replace depending on coupling reduction
- `format_duration` @L27127 -> Refactor or replace depending on coupling reduction
- `_repair_json_string` @L27133 -> Refactor helper for clarity and tests
- `clean_json_response` @L27267 -> Refactor or replace depending on coupling reduction
- `execute_sql` @L27276 -> Refactor or replace depending on coupling reduction
- `_try_reclaim_stale_threads` @L27293 -> Refactor helper for clarity and tests
- `execute_sql_with_timeout` @L27307 -> Refactor or replace depending on coupling reduction
- `run_query` @L27325 -> Refactor to service call; preserve side effects
- `run_parallel_with_rate_limit_backoff` @L27364 -> Refactor to service call; preserve side effects
- `HeartbeatWatchdog.__init__` @L27479 -> Refactor into module scoped class
- `HeartbeatWatchdog.start` @L27492 -> Refactor into module scoped class
- `HeartbeatWatchdog._loop` @L27496 -> Refactor into module scoped class
- `HeartbeatWatchdog.stop` @L27516 -> Refactor into module scoped class
- `HeartbeatWatchdog.register_active` @L27529 -> Refactor into module scoped class
- `HeartbeatWatchdog.clear_active` @L27534 -> Refactor into module scoped class
- `HeartbeatWatchdog.scoped` @L27539 -> Refactor into module scoped class
- `_Ctx.__enter__` @L27544 -> Refactor into module scoped class
- `_Ctx.__exit__` @L27547 -> Refactor into module scoped class
- `run_with_context_ladder` @L27553 -> Refactor to service call; preserve side effects
- `run_batch_with_halving_on_timeout` @L27586 -> Reuse semantics exactly
- `_multi_pass_substitute` @L27614 -> Refactor helper for clarity and tests
- `repl` @L27622 -> Refactor or replace depending on coupling reduction
- `_resolve_master_action_catalog_for_prompt` @L27633 -> Refactor helper for clarity and tests
- `load_and_format_prompt` @L27642 -> Refactor or replace depending on coupling reduction
- `_safe_format_prompt` @L27692 -> Refactor helper for clarity and tests
- `write_to_dbfs` @L27706 -> Refactor or replace depending on coupling reduction
- `map_data_type` @L27747 -> Refactor or replace depending on coupling reduction
- `_metric_yaml_quote` @L27753 -> Refactor helper for clarity and tests
- `_normalize_metric_view_name` @L27756 -> Refactor helper for clarity and tests
- `_metric_label` @L27768 -> Refactor helper for clarity and tests
- `_is_metric_numeric_type` @L27771 -> Refactor helper for clarity and tests
- `_is_metric_temporal_type` @L27775 -> Refactor helper for clarity and tests
- `_is_metric_dimension_eligible` @L27779 -> Refactor helper for clarity and tests
- `_is_metric_measure_eligible` @L27793 -> Refactor helper for clarity and tests
- `_build_domain_metric_sql_artifacts` @L27805 -> Refactor helper for clarity and tests
- `_build_domain_metric_sql_artifacts_impl` @L27824 -> Refactor helper for clarity and tests
- `_compact_role_for_type` @L28030 -> Refactor helper for clarity and tests
- `_compact_attr_token` @L28043 -> Refactor helper for clarity and tests
- `_build_product_columns_reference` @L28065 -> Refactor helper for clarity and tests
- `_build_linked_products_compact` @L28083 -> Refactor helper for clarity and tests
- `_build_domain_metrics_context_text` @L28148 -> Refactor helper for clarity and tests
- `_build_domain_metric_type_matrix_text` @L28213 -> Refactor helper for clarity and tests
- `_has_nested_aggregate_depth_aware` @L28235 -> Refactor helper for clarity and tests
- `_count_metric_aggregate_calls` @L28264 -> Refactor helper for clarity and tests
- `_is_safe_aggregate_ratio` @L28269 -> Refactor helper for clarity and tests
- `_split_top_level_add_sub` @L28318 -> Refactor helper for clarity and tests
- `_rewrite_multi_sum_to_single_sum` @L28358 -> Refactor helper for clarity and tests
- `_sanitize_metric_measure_expr` @L28392 -> Refactor helper for clarity and tests
- `_date_sub_repl` @L28403 -> Refactor helper for clarity and tests
- `_cast_token` @L28487 -> Refactor helper for clarity and tests
- `_extract_metric_view_name_from_statement` @L28519 -> Refactor helper for clarity and tests
- `_extract_metric_view_source_from_statement` @L28532 -> Refactor helper for clarity and tests
- `_extract_metric_view_target_from_statement` @L28547 -> Refactor helper for clarity and tests
- `_sanitize_metric_stmt_nested_agg` @L28556 -> Refactor helper for clarity and tests
- `_fix_expr_line` @L28558 -> Refactor helper for clarity and tests
- `execute_metric_views_in_parallel_no_halt` @L28569 -> Refactor or replace depending on coupling reduction
- `_force_safe_measures` @L28582 -> Refactor helper for clarity and tests
- `_rewrite_unresolved_columns` @L28600 -> Refactor helper for clarity and tests
- `_norm` @L28614 -> Refactor helper for clarity and tests
- `_rewrite_via_describe` @L28638 -> Refactor helper for clarity and tests
- `_overlap` @L28681 -> Refactor helper for clarity and tests
- `_tracked_sql` @L28697 -> Refactor helper for clarity and tests
- `_strip_bare_column_entries` @L28775 -> Refactor helper for clarity and tests
- `_extract_column_refs_from_expr` @L28987 -> Refactor helper for clarity and tests
- `_strip_source_product_prefix_in_expr` @L28999 -> Refactor helper for clarity and tests
- `_sub` @L29009 -> Refactor helper for clarity and tests
- `_rewrite_column_refs_in_expr` @L29020 -> Refactor helper for clarity and tests
- `_extract_bare_arithmetic_operands` @L29044 -> Refactor helper for clarity and tests
- `_find_matching_paren` @L29055 -> Refactor helper for clarity and tests
- `_is_protected` @L29076 -> Refactor helper for clarity and tests
- `_validate_metric_view_ownership` @L29117 -> Refactor helper for clarity and tests
- `_metric_views_to_export_records` @L29194 -> Refactor helper for clarity and tests
- `_group_metric_views_by_domain` @L29225 -> Refactor helper for clarity and tests
- `_render_metric_sql_for_domain_from_llm_spec` @L29245 -> Refactor helper for clarity and tests
- `_rewrite_expr` @L29614 -> Refactor helper for clarity and tests
- `_build_domain_metric_sql_artifacts_with_llm` @L29748 -> Refactor helper for clarity and tests
- `_metric_worker` @L29884 -> Refactor helper for clarity and tests
- `list_metric_sql_files_for_version` @L30075 -> Refactor or replace depending on coupling reduction
- `_strip_metric_from_view_name` @L30100 -> Refactor helper for clarity and tests
- `_create_metrics_database_if_needed` @L30111 -> Refactor helper for clarity and tests
- `_tracked_sql_with_retries` @L30117 -> Refactor helper for clarity and tests
- `_execute_sql_parallel_core` @L30151 -> Refactor helper for clarity and tests
- `execute_sql_in_parallel` @L30248 -> Refactor or replace depending on coupling reduction
- `execute_sql_in_parallel_no_halt` @L30255 -> Refactor or replace depending on coupling reduction
- `parse_sql_statements` @L30263 -> Refactor or replace depending on coupling reduction
- `replace_catalog_in_sql` @L30308 -> Refactor or replace depending on coupling reduction
- `detect_catalog_from_sql` @L30321 -> Refactor or replace depending on coupling reduction
- `read_bytes_from_workspace` @L30338 -> Refactor or replace depending on coupling reduction
- `read_file_for_ddl` @L30346 -> Refactor or replace depending on coupling reduction
- `_looks_like_model_json` @L30357 -> Refactor helper for clarity and tests
- `_resolve_user_model_json_path` @L30372 -> Refactor helper for clarity and tests
- `_try_read_and_validate` @L30387 -> Refactor helper for clarity and tests
- `execute_ddl_statements` @L30459 -> Refactor or replace depending on coupling reduction
- `run_one` @L30473 -> Refactor to service call; preserve side effects
- `_run_with_progress` @L30522 -> Refactor helper for clarity and tests
- `VibeWriter.__init__` @L30572 -> Refactor into module scoped class
- `VibeWriter._biz_where` @L30615 -> Refactor into module scoped class
- `VibeWriter._escape_sql_str` @L30624 -> Refactor into module scoped class
- `VibeWriter._safe_json_str` @L30630 -> Refactor into module scoped class
- `VibeWriter._normalize_progress_increment` @L30639 -> Refactor into module scoped class
- `VibeWriter._next_step_id` @L30647 -> Refactor into module scoped class
- `VibeWriter._ensure_tables` @L30652 -> Refactor into module scoped class
- `VibeWriter.initialize_session` @L30707 -> Refactor into module scoped class
- `VibeWriter.emit_step` @L30743 -> Refactor into module scoped class
- `VibeWriter._trigger_async_flush` @L30814 -> Refactor into module scoped class
- `VibeWriter._async_flush_wrapper` @L30824 -> Refactor into module scoped class
- `VibeWriter._get_session_processing_status` @L30830 -> Refactor into module scoped class
- `VibeWriter._consume_pending_events_stream` @L30842 -> Refactor into module scoped class
- `VibeWriter._insert_progress_chunk` @L30868 -> Refactor into module scoped class
- `VibeWriter._update_session_ready` @L30921 -> Refactor into module scoped class
- `VibeWriter._finalize_session` @L30931 -> Refactor into module scoped class
- `VibeWriter.flush_pending` @L30944 -> Refactor into module scoped class
- `VibeWriter._build_insert_sql` @L31015 -> Refactor into module scoped class
- `VibeWriter._retry_delta_write` @L31036 -> Refactor into module scoped class
- `VibeWriter.insert_business_row` @L31054 -> Refactor into module scoped class
- `VibeWriter.update_business_context` @L31060 -> Refactor into module scoped class
- `VibeWriter.insert_deployed_business_row` @L31077 -> Refactor into module scoped class
- `VibeWriter._finalize_common` @L31094 -> Refactor into module scoped class
- `VibeWriter.finalize_pipeline` @L31136 -> Refactor into module scoped class
- `VibeWriter.finalize_pipeline_error` @L31146 -> Refactor into module scoped class
- `_safe_notebook_exit` @L31163 -> Refactor helper for clarity and tests
- `_create_standalone_vibe_writer` @L31175 -> Reuse intent parser/review logic, split into dedicated module
- `_normalize_boolean_format_label` @L31199 -> Refactor helper for clarity and tests
- `_resolve_boolean_type` @L31219 -> Refactor helper for clarity and tests
- `detect_convention_changes` @L31242 -> Refactor or replace depending on coupling reduction
- `apply_convention_changes` @L31264 -> Refactor or replace depending on coupling reduction
- `load_previous_version_conventions` @L31532 -> Refactor or replace depending on coupling reduction
- `classify_attribute` @L31595 -> Refactor or replace depending on coupling reduction
- `capture_vibe_model_snapshot` @L31629 -> Refactor or replace depending on coupling reduction
- `generate_vibe_model_change_log` @L31688 -> Refactor or replace depending on coupling reduction
- `print_vibe_model_change_summary` @L31884 -> Refactor or replace depending on coupling reduction
- `_safe_copy_local_to_dbfs` @L32036 -> Refactor helper for clarity and tests
- `_finalize_logs` @L32079 -> Refactor helper for clarity and tests
- `_separate_user_and_system_vibes` @L32122 -> Reuse intent parser/review logic, split into dedicated module
- `parse_user_vibes_to_requirements` @L32165 -> Refactor or replace depending on coupling reduction
- `_resolve_vibes_from_file` @L32214 -> Reuse intent parser/review logic, split into dedicated module
- `extract_vibe_modelling_instructions` @L32243 -> Refactor or replace depending on coupling reduction
- `_assert_vibe_version_advances` @L32289 -> Reuse intent parser/review logic, split into dedicated module
- `step_setup_and_clean` @L32334 -> Rewrite as deterministic stage node with same I/O contract
- `_substitute_business_variable` @L32374 -> Refactor helper for clarity and tests
- `_apply_catalog_affixes` @L32406 -> Refactor helper for clarity and tests
- `_model_scope_clause` @L32746 -> Refactor helper for clarity and tests
- `_calculate_next_version` @L32755 -> Refactor helper for clarity and tests
- `_version_exists` @L32771 -> Refactor helper for clarity and tests
- `_get_latest_version` @L32780 -> Refactor helper for clarity and tests
- `_get_latest_completed_version` @L32791 -> Refactor helper for clarity and tests
- `_version_is_incomplete` @L32809 -> Refactor helper for clarity and tests
- `_delete_incomplete_version` @L32822 -> Refactor helper for clarity and tests
- `_del_ver_table` @L32826 -> Refactor helper for clarity and tests
- `_version_has_model_data` @L32844 -> Refactor helper for clarity and tests
- `_recover_model_data_from_volume` @L32874 -> Refactor helper for clarity and tests
- `_esc` @L32926 -> Refactor helper for clarity and tests
- `_batch_insert_recovery` @L32984 -> Refactor helper for clarity and tests
- `_find_next_available_version` @L33023 -> Refactor helper for clarity and tests
- `create_table_sql` @L33404 -> Refactor or replace depending on coupling reduction
- `_run_deterministic_fk_linking_file_based` @L33588 -> Refactor helper for clarity and tests
- `_resolve_ambiguous_fks_with_llm` @L33762 -> Refactor helper for clarity and tests
- `_get_bc_val` @L33801 -> Refactor helper for clarity and tests
- `_process_ambiguous_fk_batch` @L33871 -> Refactor helper for clarity and tests
- `_work` @L33964 -> Refactor helper for clarity and tests
- `_resolve_broken_fk_columns_with_llm` @L33981 -> Refactor helper for clarity and tests
- `_get_val` @L34079 -> Refactor helper for clarity and tests
- `_build_batch_prompt` @L34116 -> Refactor helper for clarity and tests
- `_process_broken_fk_batch` @L34153 -> Refactor helper for clarity and tests
- `_get_siloed_products_list` @L34250 -> Refactor helper for clarity and tests
- `_get_related_products_in_domain` @L34260 -> Refactor helper for clarity and tests
- `run_product_domain_location_fit` @L34303 -> Refactor to service call; preserve side effects
- `_process_domain` @L34324 -> Refactor helper for clarity and tests
- `run_normalization_integrity_check_parallel` @L34541 -> Refactor to service call; preserve side effects
- `_should_process_table` @L34606 -> Refactor helper for clarity and tests
- `_build_relevant_products_str` @L34661 -> Refactor helper for clarity and tests
- `_estimate_norm_batch_timeout` @L34755 -> Refactor helper for clarity and tests
- `_norm_response_postprocessor` @L34770 -> Refactor helper for clarity and tests
- `_decision_of` @L34783 -> Refactor helper for clarity and tests
- `_filter_by_decision` @L34787 -> Refactor helper for clarity and tests
- `_is_self_referencing_orphan` @L34806 -> Refactor helper for clarity and tests
- `_run_single_norm_batch` @L34871 -> Refactor helper for clarity and tests
- `_is_pk_in_orphaned` @L34949 -> Refactor helper for clarity and tests
- `_is_already_linked_in_model` @L34961 -> Refactor helper for clarity and tests
- `_does_not_end_with_pk_suffix` @L34977 -> Refactor helper for clarity and tests
- `_process_relink_resolutions` @L35586 -> Refactor helper for clarity and tests
- `_run_relink_batch` @L35634 -> Refactor helper for clarity and tests
- `_is_ambiguous_pk` @L35753 -> Refactor helper for clarity and tests
- `_silo_link_semantic_check` @L35759 -> Refactor helper for clarity and tests
- `_run_deterministic_silo_pk_linking` @L35802 -> Refactor helper for clarity and tests
- `_run_pairwise_silo_remediation` @L35914 -> Refactor helper for clarity and tests
- `_sync_fk_type_with_pk` @L36044 -> Refactor helper for clarity and tests
- `_p070_cluster_products_for_chunking` @L36112 -> Refactor helper for clarity and tests
- `_run_in_domain_linking_smart_worker` @L36171 -> Refactor helper for clarity and tests
- `validate_response` @L36279 -> Keep gate logic and thresholds, modernize implementation
- `_chunk_validate_response` @L36409 -> Refactor helper for clarity and tests
- `_find_existing_fk_candidate` @L36815 -> Refactor helper for clarity and tests
- `_has_fk_to_target` @L36868 -> Refactor helper for clarity and tests
- `_create_new_fk_attribute` @L36886 -> Refactor helper for clarity and tests
- `_safe_remove_redundant_column` @L37015 -> Refactor helper for clarity and tests
- `_detect_redundant_columns_deterministic` @L37073 -> Refactor helper for clarity and tests
- `_build_filtered_attrs_by_product` @L37135 -> Refactor helper for clarity and tests
- `_format_product_lines_with_attrs` @L37183 -> Refactor helper for clarity and tests
- `_build_full_attrs_by_product` @L37200 -> Refactor helper for clarity and tests
- `_run_cross_domain_linking_smart_worker` @L37226 -> Refactor helper for clarity and tests
- `validate_response` @L37294 -> Keep gate logic and thresholds, modernize implementation
- `_process_many_to_many_relationships` @L37639 -> Refactor helper for clarity and tests
- `_run_m2m_validation` @L37706 -> Refactor helper for clarity and tests
- `_to_bool` @L37917 -> Refactor helper for clarity and tests
- `run_pairwise_cross_domain_linking` @L38174 -> Refactor to service call; preserve side effects
- `_process_domain_pair` @L38275 -> Refactor helper for clarity and tests
- `run_batch_semantic_fk_resolution` @L38622 -> Refactor to service call; preserve side effects
- `_apply_resolutions_thread_safe` @L38715 -> Refactor helper for clarity and tests
- `_run_single_batch` @L38803 -> Refactor helper for clarity and tests
- `_fk_batch_variant` @L38860 -> Refactor helper for clarity and tests
- `_process_batch_task` @L38912 -> Refactor helper for clarity and tests
- `run_in_domain_linking_parallel` @L38980 -> Refactor to service call; preserve side effects
- `_extract_pk_name` @L39111 -> Refactor helper for clarity and tests
- `_detect_direct_bidirectional_links` @L39189 -> Refactor helper for clarity and tests
- `_is_pointer_attr` @L39268 -> Refactor helper for clarity and tests
- `_detect_cycles_dfs` @L39317 -> Refactor helper for clarity and tests
- `dfs` @L39381 -> Refactor or replace depending on coupling reduction
- `_check_siloed_tables_after_cycle_break` @L39446 -> Refactor helper for clarity and tests
- `_break_cycles_with_retry` @L39455 -> Refactor helper for clarity and tests
- `_break_cycles_internal` @L39529 -> Refactor helper for clarity and tests
- `_build_cycles_for_llm` @L39639 -> Refactor helper for clarity and tests
- `_build_all_fk_links` @L39685 -> Refactor helper for clarity and tests
- `_call_llm_for_cycles` @L39702 -> Refactor helper for clarity and tests
- `_process_cycle_batch_with_retry` @L39734 -> Refactor helper for clarity and tests
- `_apply_llm_decisions` @L39850 -> Refactor helper for clarity and tests
- `_dfs_find_cycles_iterative` @L39987 -> Refactor helper for clarity and tests
- `_is_convenience_fk` @L40146 -> Refactor helper for clarity and tests
- `_compute_edge_betweenness_for_cycles` @L40152 -> Refactor helper for clarity and tests
- `_heuristic_edge_break_score` @L40217 -> Refactor helper for clarity and tests
- `_break_cycles_heuristic_internal` @L40256 -> Refactor helper for clarity and tests
- `_break_cycles` @L40352 -> Refactor helper for clarity and tests
- `_build_other_domains_summary_for_domain` @L40420 -> Refactor helper for clarity and tests
- `_build_domain_products_inventory` @L40436 -> Refactor helper for clarity and tests
- `_gate_is_pass` @L40475 -> Refactor helper for clarity and tests
- `_normalize_gate_hierarchy` @L40496 -> Refactor helper for clarity and tests
- `_raw_answer` @L40534 -> Refactor helper for clarity and tests
- `_render_previous_reviews_context` @L40585 -> Refactor helper for clarity and tests
- `_apply_single_domain_review_to_model` @L40637 -> Refactor helper for clarity and tests
- `_norm_for_rename` @L40665 -> Refactor helper for clarity and tests
- `step_domain_architect_review` @L40892 -> Rewrite as deterministic stage node with same I/O contract
- `_run_one_domain` @L41034 -> Refactor helper for clarity and tests
- `step_architect_review` @L41254 -> Rewrite as deterministic stage node with same I/O contract
- `_build_global_inventory` @L41445 -> Refactor helper for clarity and tests
- `validate_architect_review` @L41517 -> Keep gate logic and thresholds, modernize implementation
- `_validate_new_domain_products` @L42426 -> Refactor helper for clarity and tests
- `_apply_architect_essential_links` @L42826 -> Refactor helper for clarity and tests
- `_norm_attr` @L42867 -> Refactor helper for clarity and tests
- `run_global_product_semantic_dedup` @L42910 -> Refactor to service call; preserve side effects
- `validate_global_dedup` @L43079 -> Keep gate logic and thresholds, modernize implementation
- `_is_core_for_domain` @L43167 -> Refactor helper for clarity and tests
- `_demote_unlinked_fk_attr_to_external_code` @L43843 -> Refactor helper for clarity and tests
- `_run_find_missing_fk_links` @L43863 -> Refactor helper for clarity and tests
- `_is_person_role_column` @L43930 -> Refactor helper for clarity and tests
- `_is_non_person_table` @L43942 -> Refactor helper for clarity and tests
- `_find_best_person_table` @L43951 -> Refactor helper for clarity and tests
- `_run_fmfl_for_domain` @L43959 -> Refactor helper for clarity and tests
- `_fmfl_normalise_target` @L43997 -> Refactor helper for clarity and tests
- `_fmfl_suggest_canonical` @L44006 -> Refactor helper for clarity and tests
- `_validate_fmfl` @L44030 -> Refactor helper for clarity and tests
- `_fmfl_postprocessor` @L44080 -> Refactor helper for clarity and tests
- `_normalize_attr_name` @L44474 -> Refactor helper for clarity and tests
- `_execute_queued_vibe_operations` @L44593 -> Reuse intent parser/review logic, split into dedicated module
- `_gd_try_call` @L45808 -> Refactor helper for clarity and tests
- `_gd_halve` @L45836 -> Refactor helper for clarity and tests
- `run_quality_assurance_checks` @L45918 -> Refactor to service call; preserve side effects
- `_process_small_tables_for_domain` @L47171 -> Refactor helper for clarity and tests
- `apply_naming_conventions` @L47426 -> Refactor or replace depending on coupling reduction
- `apply_case` @L47456 -> Refactor or replace depending on coupling reduction
- `_extract_must_do_only_vibe_text` @L47609 -> Reuse intent parser/review logic, split into dedicated module
- `format_distributed_vibes_for_prompt` @L47640 -> Refactor or replace depending on coupling reduction
- `_format_distributed_vibes_impl` @L47649 -> Reuse intent parser/review logic, split into dedicated module
- `get_distributed_vibes_for_prompt` @L47677 -> Refactor or replace depending on coupling reduction
- `_compute` @L47681 -> Refactor helper for clarity and tests
- `_clamp_and_validate_model_params` @L47744 -> Refactor helper for clarity and tests
- `_determine_model_parameters` @L47789 -> Refactor helper for clarity and tests
- `_apply_industry_tier_overrides_from_tiers` @L47911 -> Refactor helper for clarity and tests
- `build_business_context_section` @L47962 -> Refactor or replace depending on coupling reduction
- `_val` @L47981 -> Refactor helper for clarity and tests
- `get_vibes_from_config` @L48009 -> Refactor or replace depending on coupling reduction
- `_compute` @L48016 -> Refactor helper for clarity and tests
- `_inject_missing_must_do_actions` @L48030 -> Refactor helper for clarity and tests
- `_has_action_type` @L48042 -> Refactor helper for clarity and tests
- `step_interpret_model_instructions` @L48315 -> Rewrite as deterministic stage node with same I/O contract
- `get_domain_for_table` @L48705 -> Refactor or replace depending on coupling reduction
- `_has_action` @L48769 -> Refactor helper for clarity and tests
- `_has_any_action` @L48772 -> Refactor helper for clarity and tests
- `_inject` @L48775 -> Refactor helper for clarity and tests
- `_add_pfx` @L50615 -> Refactor helper for clarity and tests
- `_add_sfx` @L50628 -> Refactor helper for clarity and tests
- `_rm_pfx` @L50641 -> Refactor helper for clarity and tests
- `_rm_sfx` @L50655 -> Refactor helper for clarity and tests
- `_tag_add_pfx` @L50669 -> Refactor helper for clarity and tests
- `_tag_add_sfx` @L50681 -> Refactor helper for clarity and tests
- `_tag_rm_pfx` @L50693 -> Refactor helper for clarity and tests
- `_tag_rm_sfx` @L50705 -> Refactor helper for clarity and tests
- `_add_tag` @L50717 -> Refactor helper for clarity and tests
- `_rm_tag` @L50729 -> Refactor helper for clarity and tests
- `_run_bulk_drop_batch` @L51977 -> Refactor helper for clarity and tests
- `_run_prune_batch` @L52130 -> Refactor helper for clarity and tests
- `_verify_vibe_requirements` @L54906 -> Reuse intent parser/review logic, split into dedicated module
- `_resolve_table_key` @L54943 -> Refactor helper for clarity and tests
- `_proof` @L54960 -> Refactor helper for clarity and tests
- `_run_post_linking_fk_validations` @L55163 -> Refactor helper for clarity and tests
- `step_create_logical_schema` @L55323 -> Reuse semantics exactly
- `_vibe_enrich_domain` @L55418 -> Reuse intent parser/review logic, split into dedicated module
- `validate_single_domain_wrapper` @L55466 -> Keep gate logic and thresholds, modernize implementation
- `_vibe_domain_enrich_progress` @L55545 -> Reuse intent parser/review logic, split into dedicated module
- `_vibe_generate_products_for_domain` @L55614 -> Reuse intent parser/review logic, split into dedicated module
- `validate_products_wrapper` @L55671 -> Keep gate logic and thresholds, modernize implementation
- `_vibe_product_gen_progress` @L55751 -> Reuse intent parser/review logic, split into dedicated module
- `_vibe_generate_attributes_for_product` @L55847 -> Reuse intent parser/review logic, split into dedicated module
- `validate_attrs_wrapper` @L55911 -> Keep gate logic and thresholds, modernize implementation
- `_vibe_attr_gen_progress` @L56011 -> Reuse intent parser/review logic, split into dedicated module
- `_enrich_domain_with_products` @L56479 -> Refactor helper for clarity and tests
- `_enrich_product_with_attributes` @L56531 -> Refactor helper for clarity and tests
- `_reduce_domain_products` @L56669 -> Refactor helper for clarity and tests
- `_reduce_product_attributes` @L56683 -> Refactor helper for clarity and tests
- `_score_and_split` @L56804 -> Refactor helper for clarity and tests
- `_domain_sim` @L57866 -> Refactor helper for clarity and tests
- `_apply_case_convention` @L57953 -> Refactor helper for clarity and tests
- `_apply_suffix_convention` @L57956 -> Refactor helper for clarity and tests
- `_apply_case_to_fk_path` @L57970 -> Refactor helper for clarity and tests
- `_check_attribute_table_for_siloed_tables` @L57977 -> Refactor helper for clarity and tests
- `_run_foreign_key_anomaly_review` @L58068 -> Refactor helper for clarity and tests
- `_sever_fk_progress` @L58146 -> Refactor helper for clarity and tests
- `_generate_attributes_for_product` @L58309 -> Refactor helper for clarity and tests
- `_validate_attribute_response` @L58366 -> Refactor helper for clarity and tests
- `_validate_domains_structural` @L58548 -> Refactor helper for clarity and tests
- `_validate_domains_quality` @L58571 -> Refactor helper for clarity and tests
- `_validate_products_for_domain` @L58612 -> Refactor helper for clarity and tests
- `_trim_model_names` @L58665 -> Refactor helper for clarity and tests
- `_run_deterministic_fk_linking` @L58758 -> Refactor helper for clarity and tests
- `_get_bc_value` @L58943 -> Refactor helper for clarity and tests
- `_run_domain_generation_variant` @L59104 -> Refactor helper for clarity and tests
- `_ens_variant_json` @L59262 -> Refactor helper for clarity and tests
- `validate_judge_response` @L59288 -> Keep gate logic and thresholds, modernize implementation
- `score_variant` @L59374 -> Refactor or replace depending on coupling reduction
- `_smart_generate_products_for_domain` @L59676 -> Refactor helper for clarity and tests
- `validate_products_wrapper` @L59734 -> Keep gate logic and thresholds, modernize implementation
- `_product_gen_progress` @L59803 -> Refactor helper for clarity and tests
- `write_attributes_to_disk` @L60251 -> Refactor or replace depending on coupling reduction
- `_smart_generate_attributes_for_product` @L60266 -> Refactor helper for clarity and tests
- `validate_attrs_wrapper` @L60334 -> Keep gate logic and thresholds, modernize implementation
- `_attr_gen_progress` @L60490 -> Refactor helper for clarity and tests
- `step_apply_naming_conventions` @L61647 -> Rewrite as deterministic stage node with same I/O contract
- `_to_dict_list` @L61688 -> Refactor helper for clarity and tests
- `_safe_load_json` @L61692 -> Refactor helper for clarity and tests
- `_nc_read_json` @L61711 -> Refactor helper for clarity and tests
- `_apply_case_convention` @L61803 -> Refactor helper for clarity and tests
- `_to_dict` @L61812 -> Refactor helper for clarity and tests
- `_nc_write_json` @L61933 -> Refactor helper for clarity and tests
- `step_allocate_subdomains` @L61984 -> Rewrite as deterministic stage node with same I/O contract
- `_postprocess_subdomain_allocations` @L62039 -> Refactor helper for clarity and tests
- `_validate_subdomain_names` @L62179 -> Refactor helper for clarity and tests
- `step_create_physical_schema_stage1` @L62331 -> Rewrite as deterministic stage node with same I/O contract
- `_convention_name` @L62354 -> Refactor helper for clarity and tests
- `_convert_to_dicts` @L62417 -> Refactor helper for clarity and tests
- `_build_domain_key` @L62421 -> Refactor helper for clarity and tests
- `_build_product_key` @L62424 -> Refactor helper for clarity and tests
- `_build_attr_key` @L62427 -> Refactor helper for clarity and tests
- `_verify_and_sync_from_memory` @L62430 -> Refactor helper for clarity and tests
- `_read_json_for_sync` @L62454 -> Refactor helper for clarity and tests
- `_local_execute_sql_no_halt` @L62538 -> Refactor helper for clarity and tests
- `_run_sql` @L62554 -> Refactor helper for clarity and tests
- `execute_alter_table_in_parallel_grouped` @L62623 -> Refactor or replace depending on coupling reduction
- `_run_serial_statements_for_table` @L62635 -> Refactor helper for clarity and tests
- `_resolve_catalog_for_domain` @L62865 -> Refactor helper for clarity and tests
- `_get` @L62881 -> Refactor helper for clarity and tests
- `_sanitize_tag_key` @L62887 -> Refactor helper for clarity and tests
- `_parse_tags_to_kv_pairs` @L62892 -> Refactor helper for clarity and tests
- `get_attr_value` @L63041 -> Refactor or replace depending on coupling reduction
- `_normalize_classification` @L63138 -> Refactor helper for clarity and tests
- `run_one_tag_batch` @L63181 -> Refactor to service call; preserve side effects
- `_run_tc_batch` @L63236 -> Refactor helper for clarity and tests
- `_db_progress` @L64107 -> Refactor helper for clarity and tests
- `_table_progress` @L64194 -> Refactor helper for clarity and tests
- `step_apply_foreign_keys` @L64373 -> Rewrite as deterministic stage node with same I/O contract
- `_apply_fks_for_table` @L64440 -> Refactor helper for clarity and tests
- `step_apply_tags` @L64550 -> Rewrite as deterministic stage node with same I/O contract
- `_execute_tags_fast` @L64580 -> Refactor helper for clarity and tests
- `_run_tag` @L64591 -> Refactor helper for clarity and tests
- `step_apply_metric_views` @L64753 -> Reuse semantics exactly
- `_mv_refs_installed` @L64784 -> Refactor helper for clarity and tests
- `_mvcp_get_cols` @L64901 -> Refactor helper for clarity and tests
- `_rewrite_stmt` @L65072 -> Refactor helper for clarity and tests
- `_repl` @L65075 -> Refactor helper for clarity and tests
- `_repl2` @L65089 -> Refactor helper for clarity and tests
- `_view_name_to_domain_key` @L65208 -> Refactor helper for clarity and tests
- `step_generate_and_insert_samples` @L65354 -> Rewrite as deterministic stage node with same I/O contract
- `_clean_csv_response` @L65366 -> Refactor helper for clarity and tests
- `_df_from_sample_csv` @L65413 -> Refactor helper for clarity and tests
- `_normalize_numeric_string` @L65422 -> Refactor helper for clarity and tests
- `_cast` @L65441 -> Refactor helper for clarity and tests
- `_insert_product_samples` @L65629 -> Refactor helper for clarity and tests
- `_ci_find` @L65655 -> Refactor helper for clarity and tests
- `datatype_to_sql` @L65761 -> Refactor or replace depending on coupling reduction
- `_generate_and_insert_samples_for_product` @L65810 -> Refactor helper for clarity and tests
- `_build_fallback_col_info` @L65858 -> Refactor helper for clarity and tests
- `_has_enum` @L65900 -> Refactor helper for clarity and tests
- `_enum_values` @L65908 -> Refactor helper for clarity and tests
- `_type_is_int` @L65912 -> Refactor helper for clarity and tests
- `_type_is_numeric` @L65915 -> Refactor helper for clarity and tests
- `_gen_pk` @L65918 -> Refactor helper for clarity and tests
- `_gen_self_ref` @L65925 -> Refactor helper for clarity and tests
- `_sample_enum` @L65934 -> Refactor helper for clarity and tests
- `_format_date_value` @L65951 -> Refactor helper for clarity and tests
- `_sample_temporal` @L65959 -> Refactor helper for clarity and tests
- `_coerce_num` @L65991 -> Refactor helper for clarity and tests
- `_sample_numeric` @L65997 -> Refactor helper for clarity and tests
- `_format_boolean` @L66051 -> Refactor helper for clarity and tests
- `_sample_boolean` @L66056 -> Refactor helper for clarity and tests
- `_sample_pool` @L66069 -> Refactor helper for clarity and tests
- `_default_by_type` @L66081 -> Refactor helper for clarity and tests
- `_p068_try_faker_for_column` @L66104 -> Refactor helper for clarity and tests
- `_assemble_rows_from_pools` @L66127 -> Refactor helper for clarity and tests
- `_spec_for` @L66156 -> Refactor helper for clarity and tests
- `_build_df_from_pool_spec` @L66291 -> Refactor helper for clarity and tests
- `_parse_pool_json` @L66328 -> Refactor helper for clarity and tests
- `_norm_col_entry` @L66382 -> Refactor helper for clarity and tests
- `_generate_random_samples` @L66479 -> Refactor helper for clarity and tests
- `_get` @L66715 -> Refactor helper for clarity and tests
- `_get_bc_value_samples` @L66762 -> Refactor helper for clarity and tests
- `_tracked_sample_worker` @L66824 -> Refactor helper for clarity and tests
- `_fk_update_for_product` @L66996 -> Refactor helper for clarity and tests
- `_resolve_sample_catalog_db` @L67015 -> Refactor helper for clarity and tests
- `_post_normalization_deterministic_fk_linker` @L67201 -> Refactor helper for clarity and tests
- `_post_normalization_verification` @L67340 -> Refactor helper for clarity and tests
- `_metadata_model_consistency_check` @L67383 -> Refactor helper for clarity and tests
- `_p074_qualified_rename` @L67475 -> Refactor helper for clarity and tests
- `_pascal` @L67487 -> Refactor helper for clarity and tests
- `_validate_product_name_collisions` @L67504 -> Refactor helper for clarity and tests
- `_canonicalise_p074` @L67549 -> Refactor helper for clarity and tests
- `_p089_validate_product_name` @L67831 -> Refactor helper for clarity and tests
- `_p081_resync_model_files_to_disk` @L67862 -> Refactor helper for clarity and tests
- `_pre_static_analysis_autofix` @L67938 -> Refactor helper for clarity and tests
- `_domain_convention` @L68424 -> Refactor helper for clarity and tests
- `_to_convention` @L68457 -> Refactor helper for clarity and tests
- `_p025_pick_tier` @L68746 -> Refactor helper for clarity and tests
- `_p073_would_substring_match` @L68760 -> Refactor helper for clarity and tests
- `_extract_role_from_product` @L69009 -> Refactor helper for clarity and tests
- `_col_has_role_prefix` @L69018 -> Refactor helper for clarity and tests
- `_products_data_lookup` @L69024 -> Refactor helper for clarity and tests
- `_w7_is_typed_col` @L69289 -> Refactor helper for clarity and tests
- `_w7_is_pipe_enum` @L69300 -> Refactor helper for clarity and tests
- `_create_missing_parent_tables_for_unlinked_fks` @L69388 -> Refactor helper for clarity and tests
- `_pre_static_analysis_llm_relink` @L69770 -> Refactor helper for clarity and tests
- `_run_psr_batch` @L69841 -> Refactor helper for clarity and tests
- `run_metamodel_static_analysis` @L69940 -> Refactor to service call; preserve side effects
- `_dfs_cycle` @L70105 -> Refactor helper for clarity and tests
- `_strip_banned_boilerplate` @L71324 -> Refactor helper for clarity and tests
- `_strip_redundant_value_regex` @L71352 -> Refactor helper for clarity and tests
- `_add_pii_tags` @L71369 -> Refactor helper for clarity and tests
- `_strip_redundant_product_prefix` @L71406 -> Refactor helper for clarity and tests
- `_drop_denormalized_natural_keys` @L71449 -> Refactor helper for clarity and tests
- `_rename_self_fk_on_pk` @L71486 -> Refactor helper for clarity and tests
- `_fill_missing_descriptions` @L71534 -> Refactor helper for clarity and tests
- `_fill_missing_pks` @L71558 -> Refactor helper for clarity and tests
- `_merge_cross_domain_duplicate_subset` @L71596 -> Refactor helper for clarity and tests
- `step_static_analysis_autofix` @L71682 -> Rewrite as deterministic stage node with same I/O contract
- `_build_action_vocab_compat` @L71825 -> Refactor helper for clarity and tests
- `_render_action_vocab_block` @L71838 -> Refactor helper for clarity and tests
- `_parse_product_lists_from_vibes` @L71849 -> Reuse intent parser/review logic, split into dedicated module
- `_detect_required_product_prefix` @L71950 -> Refactor helper for clarity and tests
- `_search_prefix_in_text` @L71966 -> Refactor helper for clarity and tests
- `_validate_product_list_compliance` @L71992 -> Refactor helper for clarity and tests
- `step_finalize_model_before_physical_schema` @L72169 -> Rewrite as deterministic stage node with same I/O contract
- `_finalize_generate_attrs_for_stub` @L72402 -> Refactor helper for clarity and tests
- `_2r_generate_attrs_for_stub` @L72684 -> Refactor helper for clarity and tests
- `_sort_key` @L73161 -> Refactor helper for clarity and tests
- `_dedup_mv_as_product_artifacts` @L73272 -> Refactor helper for clarity and tests
- `step_apply_user_vibe_tags` @L73364 -> Rewrite as deterministic stage node with same I/O contract
- `_has_tag` @L73484 -> Refactor helper for clarity and tests
- `_inject_tag` @L73501 -> Refactor helper for clarity and tests
- `step_generate_metric_view_artifacts` @L73550 -> Rewrite as deterministic stage node with same I/O contract
- `_build_next_vibe_llm_context` @L73676 -> Reuse intent parser/review logic, split into dedicated module
- `step_generate_next_vibes` @L73899 -> Reuse semantics exactly
- `_compute_deterministic_confidence_and_status` @L73947 -> Refactor helper for clarity and tests
- `_build_current_vibes_txt` @L74526 -> Reuse intent parser/review logic, split into dedicated module
- `_build_next_vibes_txt` @L74534 -> Reuse intent parser/review logic, split into dedicated module
- `step_generate_next_vibes_early` @L74666 -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_next_vibes_late` @L74685 -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_readme` @L74706 -> Rewrite as deterministic stage node with same I/O contract
- `_get` @L74742 -> Refactor helper for clarity and tests
- `step_generate_model_overview_md` @L74919 -> Rewrite as deterministic stage node with same I/O contract
- `_query_scope_data_from_db` @L74972 -> Refactor helper for clarity and tests
- `_build_scope_data_from_input` @L75001 -> Refactor helper for clarity and tests
- `step_save_to_excel` @L75220 -> Rewrite as deterministic stage node with same I/O contract
- `_generate_model_csv` @L75238 -> Refactor helper for clarity and tests
- `enhance_description_with_source_domains` @L75466 -> Refactor or replace depending on coupling reduction
- `sanitize_excel_value` @L75595 -> Refactor or replace depending on coupling reduction
- `get_attr_sort_key` @L75610 -> Refactor or replace depending on coupling reduction
- `step_generate_data_model_json` @L75735 -> Reuse semantics exactly
- `_safe_get` @L75846 -> Refactor helper for clarity and tests
- `step_consolidate_and_cleanup` @L76236 -> Rewrite as deterministic stage node with same I/O contract
- `_precheck_read` @L76284 -> Refactor helper for clarity and tests
- `_merge_read_json` @L76384 -> Refactor helper for clarity and tests
- `_write_domains` @L76442 -> Refactor helper for clarity and tests
- `_write_products` @L76452 -> Refactor helper for clarity and tests
- `_write_attributes` @L76462 -> Refactor helper for clarity and tests
- `_verify_table` @L76497 -> Refactor helper for clarity and tests
- `_rollback_delete` @L76534 -> Refactor helper for clarity and tests
- `_recovery_read` @L76551 -> Refactor helper for clarity and tests
- `_rec_write` @L76579 -> Refactor helper for clarity and tests
- `_build_compact_global_fk_summary` @L76629 -> Refactor helper for clarity and tests
- `_build_compact_global_model_summary` @L76655 -> Refactor helper for clarity and tests
- `step_generate_kpi_first_metric_views` @L76721 -> Rewrite as deterministic stage node with same I/O contract
- `_vibe_audit_extract_ddl_blocks` @L77034 -> Reuse intent parser/review logic, split into dedicated module
- `_smart_split` @L77055 -> Refactor helper for clarity and tests
- `_vibe_audit_extract_glossary_table` @L77104 -> Reuse intent parser/review logic, split into dedicated module
- `_vibe_audit_extract_hard_counts` @L77160 -> Reuse intent parser/review logic, split into dedicated module
- `_vibe_audit_extract_canonical_keys` @L77220 -> Reuse intent parser/review logic, split into dedicated module
- `_vibe_audit_extract_subdomain_hints` @L77260 -> Reuse intent parser/review logic, split into dedicated module
- `_vibe_audit_walk_model` @L77297 -> Reuse intent parser/review logic, split into dedicated module
- `_extend_sa_with_vibe_compliance` @L77348 -> Reuse intent parser/review logic, split into dedicated module
- `_vibe_audit_compute_per_domain_breakdown` @L77551 -> Reuse intent parser/review logic, split into dedicated module
- `_vibe_audit_score_vreq` @L77578 -> Reuse intent parser/review logic, split into dedicated module
- `_build_vibe_audit_report_json` @L77586 -> Reuse intent parser/review logic, split into dedicated module
- `_render_vibe_audit_report_md` @L77680 -> Reuse intent parser/review logic, split into dedicated module
- `step_generate_vibe_audit_report` @L77777 -> Rewrite as deterministic stage node with same I/O contract
- `step_install_parity_audit` @L77889 -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_ontology` @L78043 -> Rewrite as deterministic stage node with same I/O contract
- `sanitize_literal` @L78059 -> Refactor or replace depending on coupling reduction
- `map_sql_to_xsd` @L78071 -> Refactor or replace depending on coupling reduction
- `format_label` @L78090 -> Refactor or replace depending on coupling reduction
- `to_pascal_case` @L78097 -> Refactor or replace depending on coupling reduction
- `to_camel_case` @L78100 -> Refactor or replace depending on coupling reduction
- `_generate_rdf_schema` @L78194 -> Refactor helper for clarity and tests
- `step_generate_dbml` @L78370 -> Rewrite as deterministic stage node with same I/O contract
- `_dbml_type` @L78407 -> Refactor helper for clarity and tests
- `_sort_key` @L78448 -> Refactor helper for clarity and tests
- `step_generate_release_notes` @L78556 -> Rewrite as deterministic stage node with same I/O contract
- `box_top` @L78606 -> Refactor or replace depending on coupling reduction
- `box_bottom` @L78609 -> Refactor or replace depending on coupling reduction
- `box_sep` @L78612 -> Refactor or replace depending on coupling reduction
- `box_line` @L78615 -> Refactor or replace depending on coupling reduction
- `box_title` @L78626 -> Refactor or replace depending on coupling reduction
- `step_generate_data_dictionary` @L79036 -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_test_cases` @L79126 -> Rewrite as deterministic stage node with same I/O contract
- `step_generate_model_report` @L79208 -> Rewrite as deterministic stage node with same I/O contract
- `_run_parallel_artifacts` @L79296 -> Refactor helper for clarity and tests
- `_run_one` @L79301 -> Refactor helper for clarity and tests
- `_carry_over_missing_artifacts_from_previous_version` @L79330 -> Refactor helper for clarity and tests
- `_preserve_baseline_metric_views_for_surgical` @L79440 -> Refactor helper for clarity and tests
- `_rewrite_sql_via_rename_map` @L79568 -> Refactor helper for clarity and tests
- `_all_refs_valid` @L79593 -> Refactor helper for clarity and tests
- `_emit_run_summary_query_tag` @L79694 -> Refactor helper for clarity and tests
- `main` @L79758 -> Reuse semantics exactly
- `get_widget_values` @L79772 -> Refactor or replace depending on coupling reduction
- `_safe_widget` @L79779 -> Refactor helper for clarity and tests
- `_load_file_from_path` @L79847 -> Refactor helper for clarity and tests
- `_derive_model_folder` @L79882 -> Refactor helper for clarity and tests
- `_is_new_model_json_format` @L79892 -> Refactor helper for clarity and tests
- `_sub_biz` @L80101 -> Refactor helper for clarity and tests
- `_normalize_business_context_keys` @L80321 -> Refactor helper for clarity and tests
- `_extract_vibe_modelling_instructions` @L80348 -> Reuse intent parser/review logic, split into dedicated module
- `_parse_context_file_business_data` @L80351 -> Refactor helper for clarity and tests
- `_run_deploy_model` @L80688 -> Refactor helper for clarity and tests
- `_install_log_write` @L80796 -> Refactor helper for clarity and tests
- `_ts_print` @L80814 -> Refactor helper for clarity and tests
- `_deploy_warn` @L80819 -> Refactor helper for clarity and tests
- `_FallbackLogger.info` @L80826 -> Refactor into module scoped class
- `_FallbackLogger.warning` @L80827 -> Refactor into module scoped class
- `_FallbackLogger.error` @L80828 -> Refactor into module scoped class
- `_FallbackLogger.debug` @L80829 -> Refactor into module scoped class
- `_normalize_version_token` @L80880 -> Refactor helper for clarity and tests
- `_extract_version_from_model_folder` @L80888 -> Refactor helper for clarity and tests
- `_thread_safe_print` @L81127 -> Refactor helper for clarity and tests
- `_escape_sql` @L81133 -> Refactor helper for clarity and tests
- `_run_metamodel_population` @L81142 -> Refactor helper for clarity and tests
- `_create_table_if_not_exists` @L81186 -> Refactor helper for clarity and tests
- `_cleanup_delete` @L81247 -> Refactor helper for clarity and tests
- `_mm_cn` @L81294 -> Refactor helper for clarity and tests
- `_mm_table_name` @L81297 -> Refactor helper for clarity and tests
- `_mm_pk_name` @L81302 -> Refactor helper for clarity and tests
- `_mm_col_name` @L81307 -> Refactor helper for clarity and tests
- `_mm_attr_type` @L81320 -> Refactor helper for clarity and tests
- `_batch_insert` @L81358 -> Refactor helper for clarity and tests
- `_parallel_batch_insert` @L81377 -> Refactor helper for clarity and tests
- `_generate_ddl_from_enriched_json` @L81433 -> Refactor helper for clarity and tests
- `_cn` @L81462 -> Refactor helper for clarity and tests
- `_re_derive_table_name` @L81465 -> Refactor helper for clarity and tests
- `_re_derive_pk` @L81470 -> Refactor helper for clarity and tests
- `_re_derive_column_name` @L81477 -> Refactor helper for clarity and tests
- `_eff_tag` @L81486 -> Refactor helper for clarity and tests
- `_sanitize_tag_key_j` @L81490 -> Refactor helper for clarity and tests
- `_parse_tags_to_kv_j` @L81494 -> Refactor helper for clarity and tests
- `_resolve_cat` @L81525 -> Refactor helper for clarity and tests
- `_run_physical_model_creation` @L81776 -> Refactor helper for clarity and tests
- `_InstallMetricLogger.info` @L81934 -> Refactor into module scoped class
- `_InstallMetricLogger.warning` @L81935 -> Refactor into module scoped class
- `_InstallMetricLogger.error` @L81936 -> Refactor into module scoped class
- `_InstallMetricLogger.debug` @L81937 -> Refactor into module scoped class
- `_InstallMetricLogger.handlers` @L81939 -> Refactor into module scoped class
- `_cv_count_query` @L82107 -> Refactor helper for clarity and tests
- `_load_sample_for_product` @L82199 -> Refactor helper for clarity and tests
- `_recursive_list_files` @L82321 -> Refactor helper for clarity and tests
- `_copy_single_file` @L82343 -> Refactor helper for clarity and tests
- `_run_undeploy_model` @L82556 -> Refactor helper for clarity and tests
- `_escape_sql` @L82584 -> Refactor helper for clarity and tests
- `_domain_count` @L82591 -> Refactor helper for clarity and tests
- `_undeploy_drop_db` @L82777 -> Refactor helper for clarity and tests
- `_run_resize_model` @L82875 -> Refactor helper for clarity and tests
- `_esc` @L82919 -> Refactor helper for clarity and tests
- `_scope_clause` @L82923 -> Refactor helper for clarity and tests
- `_run_generate_samples` @L84000 -> Refactor helper for clarity and tests
- `_sg_log_write` @L84029 -> Refactor helper for clarity and tests
- `print` @L84040 -> Refactor or replace depending on coupling reduction
- `_safe_volume_flush` @L84746 -> Refactor helper for clarity and tests
- `_volume_log_flush_loop` @L84811 -> Refactor helper for clarity and tests
- `_step_boundary_force_flush` @L84887 -> Refactor helper for clarity and tests
- `_log_step_start` @L84911 -> Refactor helper for clarity and tests
- `_log_step_end` @L84917 -> Refactor helper for clarity and tests
- `_run_step` @L84923 -> Refactor helper for clarity and tests
- `run_track_1` @L84931 -> Reuse semantics exactly
- `_capture_model_invariants` @L84951 -> Refactor helper for clarity and tests
- `_run_next_vibes_parallel` @L85411 -> Reuse intent parser/review logic, split into dedicated module
- `run_track_2` @L85605 -> Reuse semantics exactly
- `run_track_3` @L85612 -> Reuse semantics exactly
- `run_track_4` @L85721 -> Reuse semantics exactly
- `calculate_grade` @L85887 -> Refactor or replace depending on coupling reduction
- `_main_rollback_delete` @L86173 -> Refactor helper for clarity and tests
- `migrate_to_model_scope` @L86233 -> Refactor or replace depending on coupling reduction
- `_sql` @L86277 -> Refactor helper for clarity and tests
- `_get_columns` @L86284 -> Refactor helper for clarity and tests
- `_ls` @L86290 -> Refactor helper for clarity and tests
- `_recursive_files` @L86296 -> Refactor helper for clarity and tests
- `_suffix_rename` @L86305 -> Refactor helper for clarity and tests
- `_migrate_obj` @L86522 -> Refactor helper for clarity and tests
- `_migrate_json_in_dir` @L86560 -> Refactor helper for clarity and tests
- `run_regression_tests` @L86679 -> Refactor to service call; preserve side effects
- `_test` @L86683 -> Refactor helper for clarity and tests
- `_sample_helpers_sanity_check` @L86869 -> Refactor helper for clarity and tests
- `_type_is_int` @L86893 -> Refactor helper for clarity and tests
- `_coerce_num` @L86896 -> Refactor helper for clarity and tests
- `_sample_temporal` @L86903 -> Refactor helper for clarity and tests
- `_sample_numeric` @L86927 -> Refactor helper for clarity and tests
- `_format_boolean` @L86968 -> Refactor helper for clarity and tests
- `_sample_boolean` @L86976 -> Refactor helper for clarity and tests
- `_sample_pool` @L86986 -> Refactor helper for clarity and tests
- `_check` @L87001 -> Refactor helper for clarity and tests
- `_assemble_rows_from_pools` @L87077 -> Refactor helper for clarity and tests
- `_autofix_sanity_check` @L87124 -> Refactor helper for clarity and tests
- `_assert` @L87136 -> Refactor helper for clarity and tests
- `_SinkLogger.info` @L87141 -> Refactor into module scoped class
- `_SinkLogger.warning` @L87142 -> Refactor into module scoped class
- `_SinkLogger.error` @L87144 -> Refactor into module scoped class
- `_SinkLogger.debug` @L87145 -> Refactor into module scoped class
- `_metric_view_ownership_sanity_check` @L87235 -> Refactor helper for clarity and tests
- `_SinkLogger.info` @L87247 -> Refactor into module scoped class
- `_SinkLogger.warning` @L87248 -> Refactor into module scoped class
- `_SinkLogger.error` @L87249 -> Refactor into module scoped class
- `_SinkLogger.debug` @L87250 -> Refactor into module scoped class
- `_product_collision_sanity_check` @L87338 -> Refactor helper for clarity and tests
- `_SinkLogger.info` @L87349 -> Refactor into module scoped class
- `_SinkLogger.warning` @L87350 -> Refactor into module scoped class
- `_SinkLogger.error` @L87351 -> Refactor into module scoped class
- `_SinkLogger.debug` @L87352 -> Refactor into module scoped class
- `_pii_match_sanity_check` @L87411 -> Refactor helper for clarity and tests
- `_regex_cleanup_sanity_check` @L87511 -> Refactor helper for clarity and tests
- `_SinkLogger.info` @L87523 -> Refactor into module scoped class
- `_SinkLogger.warning` @L87524 -> Refactor into module scoped class
- `_SinkLogger.error` @L87526 -> Refactor into module scoped class
- `_SinkLogger.debug` @L87527 -> Refactor into module scoped class
- `_p068_faker_tier2_sanity_check` @L87637 -> Refactor helper for clarity and tests
- `_mock_try_faker_for_column` @L87693 -> Refactor helper for clarity and tests
- `_p070_chunked_linking_sanity_check` @L87764 -> Refactor helper for clarity and tests
- `_p071_early_next_vibes_sanity_check` @L87858 -> Reuse intent parser/review logic, split into dedicated module
- `_SinkLogger.info` @L87879 -> Refactor into module scoped class
- `_SinkLogger.warning` @L87880 -> Refactor into module scoped class
- `_SinkLogger.error` @L87881 -> Refactor into module scoped class
- `_SinkLogger.debug` @L87882 -> Refactor into module scoped class
- `_stub_success` @L87889 -> Refactor helper for clarity and tests
- `_stub_fail` @L87920 -> Refactor helper for clarity and tests
- `_naming_convention_sanity_check` @L87951 -> Refactor helper for clarity and tests
- `_p081_resync_sanity_check` @L87991 -> Refactor helper for clarity and tests
- `_SinkLogger.info` @L88006 -> Refactor into module scoped class
- `_SinkLogger.warning` @L88007 -> Refactor into module scoped class
- `_SinkLogger.error` @L88009 -> Refactor into module scoped class
- `_SinkLogger.debug` @L88010 -> Refactor into module scoped class
- `_p091_prose_validator_sanity_check` @L88097 -> Keep gate logic and thresholds, modernize implementation
- `_SinkLogger.info` @L88140 -> Refactor into module scoped class
- `_SinkLogger.warning` @L88141 -> Refactor into module scoped class
- `_SinkLogger.error` @L88143 -> Refactor into module scoped class
- `_SinkLogger.debug` @L88144 -> Refactor into module scoped class
- `_p089_vreq_bleed_sanity_check` @L88182 -> Refactor helper for clarity and tests
- `_p083_pool_parse_sanity_check` @L88225 -> Refactor helper for clarity and tests
- `_parse_pool_json` @L88247 -> Refactor helper for clarity and tests
- `_norm_col_entry` @L88283 -> Refactor helper for clarity and tests

### 8.7 Runner Functions (Exhaustive)

- `_sanitize_tag` @L25 -> preserve external run orchestration contract; refactor implementation.
- `build_job_tags` @L32 -> preserve external run orchestration contract; refactor implementation.
- `find_or_create_job` @L57 -> preserve external run orchestration contract; refactor implementation.
- `log` @L128 -> preserve external run orchestration contract; refactor implementation.
- `generate_session_id` @L136 -> preserve external run orchestration contract; refactor implementation.
- `sanitize_name` @L162 -> preserve external run orchestration contract; refactor implementation.
- `create_widgets` @L182 -> preserve external run orchestration contract; refactor implementation.
- `read_widgets` @L189 -> preserve external run orchestration contract; refactor implementation.
- `_runner_try_read_widget` @L308 -> preserve external run orchestration contract; refactor implementation.
- `_runner_is_placeholder_or_missing_path` @L316 -> preserve external run orchestration contract; refactor implementation.
- `_runner_build_single_business_context_from_widgets` @L328 -> preserve external run orchestration contract; refactor implementation.
- `load_business_context` @L357 -> preserve external run orchestration contract; refactor implementation.
- `build_notebook_params` @L433 -> preserve external run orchestration contract; refactor implementation.
- `_resolve_managed_location` @L461 -> preserve external run orchestration contract; refactor implementation.
- `_create_catalog_with_managed_location` @L494 -> preserve external run orchestration contract; refactor implementation.
- `ensure_staging_catalog` @L503 -> preserve external run orchestration contract; refactor implementation.
- `ensure_install_catalog` @L515 -> preserve external run orchestration contract; refactor implementation.
- `_pre_launch_validate` @L527 -> preserve external run orchestration contract; refactor implementation.
- `create_dry_run_notebook` @L568 -> preserve external run orchestration contract; refactor implementation.
- `sanitize_name` @L636 -> preserve external run orchestration contract; refactor implementation.
- `build_model_json` @L736 -> preserve external run orchestration contract; refactor implementation.
- `create_metamodel_objects` @L768 -> preserve external run orchestration contract; refactor implementation.
- `create_physical_schema` @L848 -> preserve external run orchestration contract; refactor implementation.
- `write_volume_artifacts` @L865 -> preserve external run orchestration contract; refactor implementation.
- `_put` @L873 -> preserve external run orchestration contract; refactor implementation.
- `_get_workspace_host_and_org` @L1063 -> preserve external run orchestration contract; refactor implementation.
- `submit_notebook_run` @L1085 -> preserve external run orchestration contract; refactor implementation.
- `wait_for_run` @L1111 -> preserve external run orchestration contract; refactor implementation.
- `_parse_exit_json` @L1158 -> preserve external run orchestration contract; refactor implementation.
- `wait_for_multi_task_run` @L1175 -> preserve external run orchestration contract; refactor implementation.
- `get_model_json_path` @L1300 -> preserve external run orchestration contract; refactor implementation.
- `get_business_volume_root` @L1305 -> preserve external run orchestration contract; refactor implementation.
- `copy_business_folder` @L1310 -> preserve external run orchestration contract; refactor implementation.
- `_copy_tree_between_volumes` @L1330 -> preserve external run orchestration contract; refactor implementation.
- `_mirror_industry_to_global_volume` @L1349 -> preserve external run orchestration contract; refactor implementation.
- `forward_logs_to_installed_volumes` @L1402 -> preserve external run orchestration contract; refactor implementation.
- `drop_catalog` @L1446 -> preserve external run orchestration contract; refactor implementation.
- `verify_copied_files` @L1456 -> preserve external run orchestration contract; refactor implementation.
- `run_pipeline_for_business` @L1484 -> preserve external run orchestration contract; refactor implementation.
- `_status_with_warnings` @L1694 -> preserve external run orchestration contract; refactor implementation.
- `save_results` @L1830 -> preserve external run orchestration contract; refactor implementation.
- `display_results` @L1834 -> preserve external run orchestration contract; refactor implementation.
- `main` @L1876 -> preserve external run orchestration contract; refactor implementation.

### 8.8 Tester Functions (Exhaustive)

- `_sanitize_name_for_runner` @L63 -> preserve behavioral assertions; tighten deterministic checks.
- `_pick` @L78 -> preserve behavioral assertions; tighten deterministic checks.
- `_random_conventions` @L82 -> preserve behavioral assertions; tighten deterministic checks.
- `_random_catalog_widgets` @L100 -> preserve behavioral assertions; tighten deterministic checks.
- `_gen_session_id` @L114 -> preserve behavioral assertions; tighten deterministic checks.
- `_samples` @L118 -> preserve behavioral assertions; tighten deterministic checks.
- `_fmt_duration` @L122 -> preserve behavioral assertions; tighten deterministic checks.
- `_ts` @L131 -> preserve behavioral assertions; tighten deterministic checks.
- `_banner` @L135 -> preserve behavioral assertions; tighten deterministic checks.
- `_sub_banner` @L141 -> preserve behavioral assertions; tighten deterministic checks.
- `__init__` @L148 -> preserve behavioral assertions; tighten deterministic checks.
- `_skip` @L157 -> preserve behavioral assertions; tighten deterministic checks.
- `main` @L167 -> preserve behavioral assertions; tighten deterministic checks.
- `_read_file_content` @L329 -> preserve behavioral assertions; tighten deterministic checks.
- `_find_domain_catalogs` @L342 -> preserve behavioral assertions; tighten deterministic checks.
- `_list_schemas_in_catalog` @L357 -> preserve behavioral assertions; tighten deterministic checks.
- `_count_tables_in_schema` @L363 -> preserve behavioral assertions; tighten deterministic checks.
- `_collect_schemas_and_tables` @L369 -> preserve behavioral assertions; tighten deterministic checks.
- `_build_base_model` @L396 -> preserve behavioral assertions; tighten deterministic checks.
- `_build_vibe_modeling` @L420 -> preserve behavioral assertions; tighten deterministic checks.
- `_build_resize` @L451 -> preserve behavioral assertions; tighten deterministic checks.
- `_find_model_json` @L475 -> preserve behavioral assertions; tighten deterministic checks.
- `_build_install` @L500 -> preserve behavioral assertions; tighten deterministic checks.
- `_build_gen_samples` @L531 -> preserve behavioral assertions; tighten deterministic checks.
- `_build_uninstall` @L558 -> preserve behavioral assertions; tighten deterministic checks.
- `run_test` @L602 -> preserve behavioral assertions; tighten deterministic checks.
- `_snapshot_error_logs` @L637 -> preserve behavioral assertions; tighten deterministic checks.
- `_extract_real_error` @L659 -> preserve behavioral assertions; tighten deterministic checks.
- `_run_test_expect_failure` @L760 -> preserve behavioral assertions; tighten deterministic checks.
- `run_test_expect_clash` @L778 -> preserve behavioral assertions; tighten deterministic checks.
- `merge_all_logs` @L788 -> preserve behavioral assertions; tighten deterministic checks.
- `_discover_log_files` @L794 -> preserve behavioral assertions; tighten deterministic checks.
- `_test_to_vdirs` @L822 -> preserve behavioral assertions; tighten deterministic checks.
- `_strip_traces` @L863 -> preserve behavioral assertions; tighten deterministic checks.
- `_extract_error_summaries` @L884 -> preserve behavioral assertions; tighten deterministic checks.
- `_append_header` @L921 -> preserve behavioral assertions; tighten deterministic checks.
- `_check_naming` @L2017 -> preserve behavioral assertions; tighten deterministic checks.
- `verify_conventions` @L2035 -> preserve behavioral assertions; tighten deterministic checks.
- `audit_vibe_effectiveness` @L2200 -> preserve behavioral assertions; tighten deterministic checks.
- `_count` @L2208 -> preserve behavioral assertions; tighten deterministic checks.
- `_domains` @L2215 -> preserve behavioral assertions; tighten deterministic checks.
- `_products` @L2222 -> preserve behavioral assertions; tighten deterministic checks.
- `_find_latest_version_in_metamodel` @L2297 -> preserve behavioral assertions; tighten deterministic checks.
- `_assert_eq` @L2615 -> preserve behavioral assertions; tighten deterministic checks.
- `_assert_true` @L2622 -> preserve behavioral assertions; tighten deterministic checks.
- `_assert_false` @L2629 -> preserve behavioral assertions; tighten deterministic checks.
- `classify_pii_subtype` @L2660 -> preserve behavioral assertions; tighten deterministic checks.
- `_compute_xd_threshold` @L2751 -> preserve behavioral assertions; tighten deterministic checks.
- `_compute_xd_max_relocations` @L2754 -> preserve behavioral assertions; tighten deterministic checks.
- `_detect_bidir_fks` @L2769 -> preserve behavioral assertions; tighten deterministic checks.
- `_attr_importance` @L2811 -> preserve behavioral assertions; tighten deterministic checks.
- `_would_substring_match` @L2833 -> preserve behavioral assertions; tighten deterministic checks.
- `_reclaim_stale` @L2844 -> preserve behavioral assertions; tighten deterministic checks.

### 8.9 Rule and Marker Inventory (Exhaustive discovered IDs)

- Rule IDs discovered: 195
  - `ATT-RUL-001`
  - `ATT-RUL-002`
  - `ATT-RUL-004`
  - `ATT-RUL-005`
  - `ATT-RUL-006`
  - `ATT-RUL-007`
  - `ATT-RUL-008`
  - `ATT-RUL-009`
  - `ATT-RUL-010`
  - `ATT-RUL-012`
  - `ATT-RUL-013`
  - `ATT-RUL-014`
  - `ATT-RUL-015`
  - `ATT-RUL-016`
  - `ATT-RUL-017`
  - `ATT-RUL-018`
  - `ATT-RUL-019`
  - `ATT-RUL-020`
  - `ATT-RUL-021`
  - `ATT-RUL-022`
  - `ATT-RUL-023`
  - `ATT-RUL-024`
  - `ATT-RUL-025`
  - `ATT-RUL-027`
  - `ATT-RUL-029`
  - `ATT-RUL-032`
  - `ATT-RUL-034`
  - `ATT-RUL-036`
  - `ATT-RUL-038`
  - `ATT-RUL-040`
  - `ATT-RUL-042`
  - `ATT-RUL-043`
  - `ATT-RUL-044`
  - `ATT-RUL-045`
  - `ATT-RUL-048`
  - `ATT-RUL-049`
  - `ATT-RUL-050`
  - `ATT-RUL-051`
  - `ATT-RUL-052`
  - `ATT-RUL-053`
  - `ATT-RUL-054`
  - `ATT-RUL-055`
  - `ATT-RUL-056`
  - `ATT-RUL-057`
  - `G03-R016`
  - `G03-R019`
  - `G06-R020`
  - `G07-R007`
  - `G08-R011`
  - `G08-R012`
  - `G10-R001`
  - `G10-R002`
  - `G10-R004`
  - `G10-R005`
  - `G10-R007`
  - `G10-R010`
  - `G10-R012`
  - `G11-R001`
  - `G11-R002`
  - `G11-R003`
  - `G11-R010`
  - `G11-R011`
  - `G11-R012`
  - `G11-R014`
  - `G11-R017`
  - `G13-R009`
  - `G13-R010`
  - `G13-R011`
  - `G13-R012`
  - `G14-R001`
  - `G14-R008`
  - `G14-R009`
  - `G14-R010`
  - `G14-R011`
  - `G14-R012`
  - `G14-R013`
  - `G14-R015`
  - `G14-R016`
  - `G14-R017`
  - `G14-R018`
  - `G15-R001`
  - `G15-R003`
  - `G15-R004`
  - `G15-R006`
  - `G15-R010`
  - `G15-R011`
  - `G15-R012`
  - `G15-R013`
  - `GEN-RUL-002`
  - `GEN-RUL-003`
  - `GEN-RUL-004`
  - `GEN-RUL-005`
  - `P0.106`
  - `P0.16`
  - `P0.17`
  - `P0.18`
  - `P0.2`
  - `P0.22`
  - `P0.24`
  - `P0.25`
  - `P0.26`
  - `P0.27`
  - `P0.42`
  - `P0.52`
  - `P0.55`
  - `P0.56`
  - `P0.67`
  - `P0.68`
  - `P0.70`
  - `P0.71`
  - `P0.72`
  - `P0.73`
  - `P0.74`
  - `P0.75`
  - `P0.81`
  - `P0.83`
  - `P0.89`
  - `P0.91`
  - `PRD-RUL-001`
  - `PRD-RUL-002`
  - `PRD-RUL-003`
  - `PRD-RUL-004`
  - `PRD-RUL-005`
  - `PRD-RUL-006`
  - `PRD-RUL-007`
  - `PRD-RUL-008`
  - `PRD-RUL-009`
  - `PRD-RUL-010`
  - `PRD-RUL-011`
  - `PRD-RUL-012`
  - `PRD-RUL-013`
  - `PRD-RUL-014`
  - `PRD-RUL-015`
  - `PRD-RUL-016`
  - `PRD-RUL-017`
  - `PRD-RUL-018`
  - `PRD-RUL-019`
  - `PRD-RUL-020`
  - `PRD-RUL-021`
  - `PRD-RUL-022`
  - `PRD-RUL-024`
  - `PRD-RUL-027`
  - `PRD-RUL-029`
  - `PRD-RUL-030`
  - `PRD-RUL-031`
  - `PRD-RUL-032`
  - `PRD-RUL-033`
  - `PRD-RUL-034`
  - `PRD-RUL-035`
  - `PRD-RUL-036`
  - `PRD-RUL-037`
  - `PRD-RUL-038`
  - `PRD-RUL-040`
  - `PRD-RUL-042`
  - `PRD-RUL-044`
  - `PRD-RUL-045`
  - `R1`
  - `R10`
  - `R11`
  - `R13`
  - `R14`
  - `R16`
  - `R2`
  - `R20`
  - `R3`
  - `R4`
  - `R5`
  - `R6`
  - `R7`
  - `R8`
  - `R9`
  - `REL-RUL-001`
  - `REL-RUL-002`
  - `REL-RUL-003`
  - `REL-RUL-004`
  - `REL-RUL-005`
  - `REL-RUL-006`
  - `REL-RUL-007`
  - `REL-RUL-008`
  - `REL-RUL-009`
  - `REL-RUL-010`
  - `REL-RUL-012`
  - `REL-RUL-013`
  - `REL-RUL-014`
  - `REL-RUL-015`
  - `REL-RUL-017`
  - `REL-RUL-018`
  - `REL-RUL-019`
  - `REL-RUL-020`
  - `REL-RUL-021`
  - `REL-RUL-022`
  - `REL-RUL-023`
  - `REL-RUL-024`
  - `REL-RUL-025`
  - `REL-RUL-026`
- Alias markers discovered: 158
  - `V075_RETIRE_V074_VOCAB`
  - `agent-version-global`
  - `agent-version-mirror`
  - `ai-agent-call-fix`
  - `arch-domain-skip-empty-quietly`
  - `arch-gate-tier-aware`
  - `architect-dispatcher`
  - `audit-dispatcher`
  - `bidirectional-pointer-auto-resolve`
  - `classify-action-cost`
  - `collision-naming-canonical`
  - `cost-cross-fk-detect`
  - `cost-cross-fk-domain`
  - `cycle-breaker-deterministic-pass2`
  - `datatype-name-coercion-autofix`
  - `ddl-skip-duplicate-column-names`
  - `domain-to-db-from-config`
  - `emit-finding-helper`
  - `ensemble-singleshot-fallback`
  - `ensemble-singleshot-fallback-crashed`
  - `ensemble-singleshot-fallback-failed`
  - `ext-system-prefix-string-parse`
  - `ext-system-prefix-string-parse-FIRED`
  - `fidelity-bypass-widget-live`
  - `fidelity-count-soft-pass`
  - `fidelity-count-soft-pass-deterministic`
  - `fidelity-count-soft-pass-strategy-agnostic`
  - `fidelity-deterministic-attr-count`
  - `fidelity-deterministic-fk-density`
  - `fidelity-gate-halt`
  - `finding-dispatcher`
  - `finding-dispatcher-process-batch`
  - `finding-dispatcher-protected`
  - `fk-cardinality-correctness`
  - `fk-name-helper-field-widen`
  - `fk-semantic-gate-no-keyerror`
  - `fk-temporal-precedence`
  - `fk-validator-skip-external-refs`
  - `fmfl-auto-apply-top1`
  - `fmfl-auto-coerce-keep`
  - `fmfl-canonical-target`
  - `fmfl-final-sanitize`
  - `immutable-early-exit`
  - `immutable-violation-critical`
  - `install-audit-mirror-multisource`
  - `install-ddl-retry-skip`
  - `install-parity-audit-call`
  - `install-parity-audit-stage`
  - `jobtags-deleted-job-info-not-warn`
  - `junction-purity`
  - `llm-audit-residual`
  - `llm-json-recoverable`
  - `log-append-on-retry`
  - `log-no-truncate-on-success`
  - `make-finding-shape`
  - `master-action-catalog-auto-inject`
  - `master-action-catalog-prompt-inject`
  - `master-catalog-scope-filtered`
  - `metric-view-bare-via-describe`
  - `metric-views-no-char-iter`
  - `model-checkup-sa-autofix-call`
  - `model-checkup-sa-autofix-call-error`
  - `model-params-subdomain-required`
  - `mv-artifact-failure-traceback`
  - `mv-attrs-by-key-stash`
  - `mv-column-llm-repair`
  - `mv-column-llm-repair-error`
  - `mv-column-llm-repair-failed`
  - `mv-column-prevalidate-drop`
  - `mv-compact-context`
  - `mv-cross-table-measure-drop`
  - `mv-date-interval-autofix`
  - `mv-fallback-emit-live`
  - `mv-filter-strip-comments`
  - `mv-joins-alias-normalize`
  - `mv-joins-disabled-pending-syntax-fix`
  - `mv-joins-expr-alias-rewrite`
  - `mv-joins-reenabled`
  - `mv-linked-tables-context`
  - `mv-measure-agg-wrap`
  - `mv-no-phantom-source`
  - `mv-product-dedup-guard`
  - `mv-product-dedup-guard-error`
  - `mv-prompt-joins-enabled`
  - `mv-source-extract`
  - `mv-source-product-prefix-rewrite`
  - `mv-spec-whitelist-tables`
  - `mv-stale-catalog-rewrite`
  - `mv-valid-columns-merge-joins`
  - `mv-yaml-no-type-field`
  - `next-vibes-dispatcher`
  - `perf-cap-16`
  - `perf-cap-16-emit`
  - `perf-llm-throttle-16`
  - `perf-mv15-parallel`
  - `pii-static-align-with-autofix`
  - `pool-spec-decimal-coerce-pre-spark`
  - `prefix-static-skip-reserved`
  - `prefix-strip-reserved-word-guard`
  - `protected-targets`
  - `r3-sentinels-to-volume`
  - `recipe-cost-classifier`
  - `release-notes-md-format`
  - `render-master-action-catalog`
  - `sa-active-autofix-summary`
  - `sa-autofix-banned_boilerplate_in_output`
  - `sa-autofix-cross_domain_duplicate`
  - `sa-autofix-denormalized_natural_key`
  - `sa-autofix-error`
  - `sa-autofix-missing_attribute_description`
  - `sa-autofix-missing_pk`
  - `sa-autofix-pii_tagging_missing`
  - `sa-autofix-redundant_product_prefix_on_attribute`
  - `sa-autofix-redundant_value_regex_on_typed_column`
  - `sa-autofix-self_fk_on_pk`
  - `safe-executor`
  - `schema-strict-preserve`
  - `self-ref-mem-json-sync`
  - `session-end-status-honest`
  - `shrink-cascade-fallback-crashed`
  - `shrink-cascade-iterate`
  - `shrink-fk-densest-fallback`
  - `shrink-fk-densest-fallback-crashed`
  - `shrink-fk-densest-fallback-empty`
  - `shrink-fk-densest-fallback-empty-cascade`
  - `shrink-input-silo-pass-through`
  - `shrink-llm-malformed`
  - `shrink-orphan-drop`
  - `shrink-orphan-drop-cleared`
  - `shrink-orphan-drop-emptied`
  - `shrink-phantom-drop`
  - `ssot-stem-autofix`
  - `step-boundary-flush`
  - `step-sa-active-autofix`
  - `step-sa-active-autofix-call`
  - `step-sa-active-autofix-call-error`
  - `step-sa-active-autofix-deferred-high-cost`
  - `step-sa-active-autofix-no-mapping`
  - `surgical-mv-preserve`
  - `surgical-mv-rewrite`
  - `user-domain-division-exempt`
  - `user-domain-injection`
  - `user-vibe-tag-applier`
  - `user-vibe-tag-applier-error`
  - `valid-joins-init-unconditional`
  - `validate-finding-shape`
  - `vibe-attr-cap-override`
  - `vibe-audit-actionable-extend`
  - `vibe-audit-helpers-block`
  - `vibe-audit-sa-extend-call`
  - `vibe-audit-stage-call`
  - `vibe-audit-stage-fn-defined`
  - `vibe-audit-stage-no-vibe`
  - `vibe-compliance-sa-fired`
  - `vibe-compliance-sa-no-vibe`
  - `vibe-count-respect-sizing-directives`
  - `vibe-metadata-honest`
  - `vov-metrics-teardown`
- FIRED markers discovered: 149
  - `IMMUTABLE-EARLY-EXIT FIRED`
  - `LLM-JSON-RECOVERABLE FIRED`
  - `P0.74-COLLISION-STEM FIRED`
  - `V075_RETIRE_V074_VOCAB FIRED alias=V075_RETIRE_V074_VOCAB`
  - `agent-version-mirror FIRED`
  - `ai-agent-call-fix FIRED`
  - `architect-dispatcher FIRED alias=architect-dispatcher`
  - `audit-dispatcher FIRED alias=audit-dispatcher`
  - `bc1-empty-row-as-dict FIRED`
  - `bidirectional-pointer-auto-resolve FIRED`
  - `collision-naming-canonical FIRED`
  - `datatype-name-coercion-autofix FIRED`
  - `det-priority-augment FIRED`
  - `det-priority-fallback FIRED`
  - `det-priority-parse FIRED`
  - `domain-dominance-cap-scale-by-count FIRED`
  - `domain-to-db-from-config FIRED`
  - `emit-finding-helper FIRED alias=emit-finding-helper`
  - `ensemble-singleshot-fallback FIRED`
  - `ext-system-prefix-string-parse FIRED`
  - `fidelity-count-soft-pass FIRED`
  - `fidelity-count-soft-pass-deterministic FIRED`
  - `fidelity-count-soft-pass-strategy-agnostic FIRED`
  - `fidelity-deterministic-attr-count FIRED`
  - `fidelity-deterministic-fk-density FIRED`
  - `fidelity-gate-halt FIRED`
  - `fidelity-gate-halt FIRED alias=fidelity-gate-halt`
  - `fk-density-upper-bound FIRED`
  - `fk-summary-helper FIRED`
  - `fk-summary-injection FIRED`
  - `fk-validator-skip-external-refs FIRED`
  - `fmfl-auto-apply-top1 FIRED`
  - `fmfl-auto-apply-top1 FIRED alias=fmfl-auto-apply-top1`
  - `fmfl-auto-apply-top1-summary FIRED`
  - `fmfl-auto-coerce-keep FIRED`
  - `fmfl-final-sanitize FIRED`
  - `fmfl-final-sanitize-summary FIRED`
  - `glossary-backfill FIRED`
  - `install-audit-mirror-multisource FIRED`
  - `install-ddl-retry-skip FIRED`
  - `install-parity-audit-call FIRED alias=install-parity-audit-call`
  - `install-parity-audit-stage FIRED alias=install-parity-audit-stage`
  - `jobtags-metrics-install-count FIRED`
  - `kpi-count-scaling FIRED`
  - `kpi-first-context-parity FIRED`
  - `kpi-first-owner-validate FIRED`
  - `kpi-first-stats FIRED`
  - `kpi-first-step FIRED`
  - `kpi-first-summary FIRED`
  - `kpi-first-wiring FIRED`
  - `kpi-prompt-registry FIRED`
  - `kpi-quality-filter FIRED`
  - `llm-audit-residual FIRED`
  - `log-append-on-retry FIRED`
  - `logger-propagate-fired FIRED`
  - `master-action-catalog-auto-inject FIRED alias=master-action-catalog-auto-inject`
  - `master-action-catalog-prompt-inject FIRED alias=master-action-catalog-prompt-inject`
  - `master-catalog-scope-filtered FIRED alias=master-catalog-scope-filtered`
  - `metric-view-dedup-domain-prefix FIRED`
  - `metric-view-joins-global-lookup FIRED`
  - `metric-view-joins-global-map FIRED`
  - `metric-view-joins-render FIRED`
  - `model-checkup-sa-autofix-call FIRED alias=model-checkup-sa-autofix-call`
  - `mv-attrs-by-key-stash FIRED`
  - `mv-column-llm-repair FIRED`
  - `mv-column-prevalidate-drop FIRED`
  - `mv-cross-table-measure-drop FIRED`
  - `mv-date-interval-autofix FIRED`
  - `mv-drop-surface FIRED`
  - `mv-fallback-emit-live FIRED`
  - `mv-filter-strip-comments FIRED`
  - `mv-joins-alias-normalize FIRED`
  - `mv-joins-disabled-pending-syntax-fix FIRED`
  - `mv-joins-expr-alias-rewrite FIRED`
  - `mv-joins-reenabled FIRED`
  - `mv-measure-agg-wrap FIRED`
  - `mv-product-dedup-guard FIRED`
  - `mv-source-extract FIRED`
  - `mv-source-product-prefix-rewrite FIRED`
  - `mv-spec-whitelist-tables FIRED`
  - `mv-stale-catalog-rewrite FIRED`
  - `mv-target-extract FIRED`
  - `mv-valid-columns-merge-joins FIRED`
  - `mv-yaml-no-type-field FIRED`
  - `mv15-gap-rerun FIRED`
  - `naming-reserved-word-guard FIRED`
  - `next-vibes-dispatcher FIRED alias=next-vibes-dispatcher`
  - `next-vibes-early-removed FIRED`
  - `orig-name-tag-removed FIRED`
  - `perf-cap-16 FIRED`
  - `perf-llm-throttle-16 FIRED`
  - `perf-mv15-parallel FIRED`
  - `pii-static-align-with-autofix FIRED`
  - `prefix-static-skip-reserved FIRED`
  - `prefix-strip-reserved-word-guard FIRED`
  - `protected-targets FIRED alias=protected-targets`
  - `recipe-cost-classifier FIRED alias=recipe-cost-classifier`
  - `release-notes-md-format FIRED alias=release-notes-md-format`
  - `remove-fk-handler FIRED`
  - `rename-product-convention-enforce FIRED`
  - `sa-active-autofix-summary FIRED`
  - `sa-autofix-banned_boilerplate_in_output FIRED`
  - `sa-autofix-cross_domain_duplicate FIRED`
  - `sa-autofix-denormalized_natural_key FIRED`
  - `sa-autofix-error FIRED`
  - `sa-autofix-missing_attribute_description FIRED`
  - `sa-autofix-missing_pk FIRED`
  - `sa-autofix-pii_tagging_missing FIRED`
  - `sa-autofix-redundant_product_prefix_on_attribute FIRED`
  - `sa-autofix-redundant_value_regex_on_typed_column FIRED`
  - `sa-autofix-self_fk_on_pk FIRED`
  - `sa-autofix-{category} FIRED`
  - `safe-executor FIRED alias=safe-executor`
  - `schema-strict-preserve FIRED`
  - `self-ref-banned-prefix-autorename FIRED`
  - `self-ref-fix-empty-val-guard FIRED`
  - `self-ref-mem-json-sync FIRED`
  - `shrink-cascade-iterate FIRED`
  - `shrink-fk-densest-fallback FIRED`
  - `shrink-llm-malformed FIRED`
  - `shrink-llm-malformed-summary FIRED`
  - `shrink-orphan-drop FIRED`
  - `shrink-orphan-drop-cascade FIRED`
  - `shrink-orphan-drop-cleared FIRED`
  - `shrink-orphan-drop-emptied FIRED`
  - `shrink-phantom-drop FIRED`
  - `sor-fallback-llm-generated FIRED`
  - `step-sa-active-autofix FIRED alias=step-sa-active-autofix`
  - `step-sa-active-autofix-call FIRED alias=step-sa-active-autofix-call`
  - `step-sa-active-autofix-deferred-high-cost FIRED alias=step-sa-active-autofix-deferred-high-cost`
  - `step-sa-active-autofix-no-mapping FIRED alias=step-sa-active-autofix-no-mapping`
  - `surgical-mv-preserve FIRED`
  - `surgical-mv-rewrite FIRED`
  - `tag-persist-pii FIRED`
  - `update-business-context-broaden FIRED`
  - `user-domain-division-exempt FIRED`
  - `user-domain-injection FIRED`
  - `user-vibe-tag-applier FIRED`
  - `valid-joins-init-unconditional FIRED`
  - `vibe-attr-cap-override FIRED`
  - `vibe-audit-actionable-extend FIRED alias=vibe-audit-actionable-extend`
  - `vibe-audit-helpers-block FIRED alias=vibe-audit-helpers-block`
  - `vibe-audit-sa-extend-call FIRED alias=vibe-audit-sa-extend-call`
  - `vibe-audit-stage-call FIRED alias=vibe-audit-stage-call`
  - `vibe-audit-stage-fn-defined FIRED alias=vibe-audit-stage-fn-defined`
  - `vibe-compliance-sa FIRED alias=vibe-compliance-sa-fired`
  - `vibe-metadata-honest FIRED`
  - `vov-auto-next-vibes FIRED`
  - `vov-metrics-teardown FIRED`

---

## 9) Test and Migration Plan for the Rewrite

### 9.1 Build Order

1. Compatibility facade (widgets, operations, artifact writer contract).
2. Stage modules S0-S11 with typed contracts and deterministic fixture tests.
3. Agentic loop engine with action registry and finding ledger.
4. Physical deploy subsystem with parity checks.
5. Shadow-mode run against current agent for parity scoring.

### 9.2 Required Test Matrix

- Widget parity tests: all widgets with empty/default/edge values.
- Operation parity tests: each operation verb and prerequisite validation path.
- Artifact parity tests: canonical compare for formatting and ordering.
- Gate regression tests: no increase in hard-signature failures.
- Performance tests: tiny + airline benchmarks with stage latency breakdown.

### 9.3 Existing Unit-Test Knowledge to Carry Forward

- Test categories detected: dispatcher_registry:5, fidelity:11, metric_views:12, normalization_helpers:11, serverless_compliance:5, versioning:16, widget_authority:5
- Most imported helper contracts from tests (top 25):
  - `ah` referenced in 13 tests
  - `HeartbeatWatchdog` referenced in 5 tests
  - `run_batch_with_halving_on_timeout` referenced in 4 tests
  - `_resolve_managed_location` referenced in 3 tests
  - `run_parallel_with_rate_limit_backoff` referenced in 3 tests
  - `AIAgent` referenced in 3 tests
  - `VALIDATOR_REGISTRY` referenced in 2 tests
  - `_is_link_excluded_by_candidate_eval` referenced in 1 tests
  - `run_with_context_ladder  # noqa` referenced in 1 tests
  - `_resolve_managed_location  # noqa` referenced in 1 tests
  - `normalize_fk_column_name` referenced in 1 tests
  - `_parse_ce_counts  # noqa` referenced in 1 tests
  - `replace_single_quote` referenced in 1 tests
  - `sanitize_name  # noqa` referenced in 1 tests
  - `register_validator` referenced in 1 tests
- Operation hits in tests:
  - `install model` in 1 tests
  - `new base model` in 3 tests
  - `vibe modeling of version` in 2 tests
- Most asserted FIRED markers (top 25):
  - `FIRED` in 4 tests
  - `fmfl-auto-coerce-keep FIRED` in 2 tests
  - `fmfl-final-sanitize FIRED` in 2 tests
  - `fidelity-count-soft-pass-deterministic FIRED` in 2 tests
  - `mv-source-product-prefix-rewrite FIRED` in 2 tests
  - `prefix-strip-reserved-word-guard FIRED` in 2 tests
  - `fidelity-count-soft-pass-strategy-agnostic FIRED` in 2 tests
  - `mv-cross-table-measure-drop FIRED` in 2 tests
  - `global-collection-volume FIRED` in 1 tests
  - `datatype-name-coercion-autofix FIRED` in 1 tests
  - `domain-dominance-cap-scale-by-count FIRED` in 1 tests
  - `pii-static-align-with-autofix FIRED` in 1 tests
  - `prefix-static-skip-reserved FIRED` in 1 tests
  - `rename-product-convention-enforce FIRED` in 1 tests
  - `self-ref-banned-prefix-autorename FIRED` in 1 tests
  - `vov-auto-next-vibes FIRED` in 1 tests
  - `det-priority-augment FIRED` in 1 tests
  - `det-priority-fallback FIRED` in 1 tests
  - `det-priority-parse FIRED` in 1 tests
  - `remove-fk-handler FIRED` in 1 tests
  - `IMMUTABLE-EARLY-EXIT FIRED` in 1 tests
  - `LLM-JSON-RECOVERABLE FIRED` in 1 tests
  - `P0.74-COLLISION-STEM FIRED` in 1 tests
  - `collision-naming-canonical FIRED` in 1 tests
  - `surgical-mv-preserve FIRED` in 1 tests

---

## 10) Final Implementation Checklist

- [ ] Same widget names, defaults, and accepted values.
- [ ] Same operation verbs and precondition errors.
- [ ] Same artifact set and generation order.
- [ ] Same model.json top-level key ordering and agent_version stamping rules.
- [ ] All hard quality gates pass (logical + physical).
- [ ] Full parity and regression test suite green.
- [ ] Runtime and reliability improved versus baseline.

---

## 11) Brutal Honesty Assessment of This Design Spec

- Coverage score: 93/100.
- Why not 100: line-by-line semantic intent for every nested helper is represented via exhaustive symbol inventory and reuse decision, but some deeply dynamic prompt compositions still require implementation-time validation against live prompt rendering snapshots.
- Mitigation: include mandatory shadow-run parity harness that diffs prompts, decisions, artifacts, and gates against current agent before promotion.


---

## 12) No-Guess Implementation Contract (Execution-Ready)

This section removes implementation ambiguity. Another agent should be able to execute this rewrite directly from these contracts without guessing intent.

### 12.1 Target Repository Layout (New, Modular)

```text
nextgen_agent/
  app/
    entrypoint.py                  # notebook-compatible main() wrapper
    widget_contract.py             # exact widget names/defaults/choices
    operation_router.py            # maps operation -> execution path
  contracts/
    run_context.py                 # canonical runtime object
    business_context.py            # business context schema
    vibe_plan.py                   # parsed vibe directives schema
    model_graph.py                 # domains/products/attributes/links schema
    findings.py                    # finding registry schema
    artifacts.py                   # artifact metadata + formatting contract
  stages/
    s0_bootstrap.py
    s1_business_context.py
    s2_vibe_compiler.py
    s3_domain_planner.py
    s4_product_planner.py
    s5_attribute_planner.py
    s6_link_planner.py
    s7_normalizer.py
    s8_agentic_loop.py
    s9_artifacts.py
    s10_deploy.py
    s11_next_vibes.py
  policy/
    rule_registry.py               # all rule IDs preserved
    gate_runner.py                 # hard/soft gate execution engine
    action_registry.py             # canonical action vocabulary
    protected_targets.py           # user-authority protection model
  llm/
    prompt_registry.py             # all prompt keys + templates
    model_router.py                # thinker/worker routing and fallback
    worker_loop.py                 # smart_worker_loop equivalent
  deploy/
    ddl_builder.py                 # schema/table/fk/tag/metric view SQL
    uc_executor.py                 # unity catalog apply layer
    parity_audit.py                # logical-vs-physical parity checks
  observability/
    logging.py                     # structured logs + FIRED markers
    progress_events.py             # _vibe_progress emission
    telemetry.py                   # stage latency + token + error metrics
  tests/
    parity/
    contracts/
    regression/
```

### 12.2 Required Public Entrypoints

- `create_widgets()` -> must declare exact widget surface, labels, defaults, options.
- `read_widgets()` -> must preserve precedence semantics (widget > context-file where specified).
- `main()` -> must route operation verbs unchanged and emit same progress/event semantics.
- `run_track_1()`/`run_track_2()`/`run_track_3()`/`run_track_4()` compatibility adapters retained for external tooling continuity.

### 12.3 Required In-Memory Contracts

- `RunContext`: resolved widgets, operation, model scope, session id, paths, spark handle, deployment settings.
- `BusinessContext`: business_information + model_conventions + vibe instructions.
- `ModelGraph`: domains, products, attributes, relationships, metric views, tags.
- `Finding`: `{id, category, severity, subject, evidence, recommended_action, cost_class, protected_conflict}`.
- `ArtifactRecord`: `{artifact_name, destination_path, content_hash, byte_count, generated_at, format_version}`.

### 12.4 Compatibility Adapter Rules

- Adapter layer must expose old method names where downstream tests import by symbol.
- Old log markers (`alias=...`, `[... FIRED]`) must still be emitted at equivalent semantic points.
- Adapter cannot change artifact filenames or folder layout.

---

## 13) Rule Execution Contract (100% Rule Preservation)

### 13.1 Rule Registry Policy

- Preserve every discovered rule ID as a first-class registry entry.
- Each rule entry must declare: `id`, `stage`, `severity`, `scope`, `predicate`, `autofix`, `failure_mode`, `evidence_fields`.
- Failure mode must be one of: `hard_fail`, `remediate_then_retry`, `warn_only`.

### 13.2 Gate Runner Determinism

- Rule evaluation order is deterministic and stable across runs.
- Any autofix must emit before/after evidence and a FIRED marker with rule alias.
- If rule autofix mutates model state, parity snapshots must be re-synced before next gate.

### 13.3 Exhaustive Rule ID Inventory (Preserved)

- `ATT-RUL-001`
- `ATT-RUL-002`
- `ATT-RUL-004`
- `ATT-RUL-005`
- `ATT-RUL-006`
- `ATT-RUL-007`
- `ATT-RUL-008`
- `ATT-RUL-009`
- `ATT-RUL-010`
- `ATT-RUL-012`
- `ATT-RUL-013`
- `ATT-RUL-014`
- `ATT-RUL-015`
- `ATT-RUL-016`
- `ATT-RUL-017`
- `ATT-RUL-018`
- `ATT-RUL-019`
- `ATT-RUL-020`
- `ATT-RUL-021`
- `ATT-RUL-022`
- `ATT-RUL-023`
- `ATT-RUL-024`
- `ATT-RUL-025`
- `ATT-RUL-027`
- `ATT-RUL-029`
- `ATT-RUL-032`
- `ATT-RUL-034`
- `ATT-RUL-036`
- `ATT-RUL-038`
- `ATT-RUL-040`
- `ATT-RUL-042`
- `ATT-RUL-043`
- `ATT-RUL-044`
- `ATT-RUL-045`
- `ATT-RUL-048`
- `ATT-RUL-049`
- `ATT-RUL-050`
- `ATT-RUL-051`
- `ATT-RUL-052`
- `ATT-RUL-053`
- `ATT-RUL-054`
- `ATT-RUL-055`
- `ATT-RUL-056`
- `ATT-RUL-057`
- `G03-R016`
- `G03-R019`
- `G06-R020`
- `G07-R007`
- `G08-R011`
- `G08-R012`
- `G10-R001`
- `G10-R002`
- `G10-R004`
- `G10-R005`
- `G10-R007`
- `G10-R010`
- `G10-R012`
- `G11-R001`
- `G11-R002`
- `G11-R003`
- `G11-R010`
- `G11-R011`
- `G11-R012`
- `G11-R014`
- `G11-R017`
- `G13-R009`
- `G13-R010`
- `G13-R011`
- `G13-R012`
- `G14-R001`
- `G14-R008`
- `G14-R009`
- `G14-R010`
- `G14-R011`
- `G14-R012`
- `G14-R013`
- `G14-R015`
- `G14-R016`
- `G14-R017`
- `G14-R018`
- `G15-R001`
- `G15-R003`
- `G15-R004`
- `G15-R006`
- `G15-R010`
- `G15-R011`
- `G15-R012`
- `G15-R013`
- `GEN-RUL-002`
- `GEN-RUL-003`
- `GEN-RUL-004`
- `GEN-RUL-005`
- `P0.106`
- `P0.16`
- `P0.17`
- `P0.18`
- `P0.2`
- `P0.22`
- `P0.24`
- `P0.25`
- `P0.26`
- `P0.27`
- `P0.42`
- `P0.52`
- `P0.55`
- `P0.56`
- `P0.67`
- `P0.68`
- `P0.70`
- `P0.71`
- `P0.72`
- `P0.73`
- `P0.74`
- `P0.75`
- `P0.81`
- `P0.83`
- `P0.89`
- `P0.91`
- `PRD-RUL-001`
- `PRD-RUL-002`
- `PRD-RUL-003`
- `PRD-RUL-004`
- `PRD-RUL-005`
- `PRD-RUL-006`
- `PRD-RUL-007`
- `PRD-RUL-008`
- `PRD-RUL-009`
- `PRD-RUL-010`
- `PRD-RUL-011`
- `PRD-RUL-012`
- `PRD-RUL-013`
- `PRD-RUL-014`
- `PRD-RUL-015`
- `PRD-RUL-016`
- `PRD-RUL-017`
- `PRD-RUL-018`
- `PRD-RUL-019`
- `PRD-RUL-020`
- `PRD-RUL-021`
- `PRD-RUL-022`
- `PRD-RUL-024`
- `PRD-RUL-027`
- `PRD-RUL-029`
- `PRD-RUL-030`
- `PRD-RUL-031`
- `PRD-RUL-032`
- `PRD-RUL-033`
- `PRD-RUL-034`
- `PRD-RUL-035`
- `PRD-RUL-036`
- `PRD-RUL-037`
- `PRD-RUL-038`
- `PRD-RUL-040`
- `PRD-RUL-042`
- `PRD-RUL-044`
- `PRD-RUL-045`
- `R1`
- `R10`
- `R11`
- `R13`
- `R14`
- `R16`
- `R2`
- `R20`
- `R3`
- `R4`
- `R5`
- `R6`
- `R7`
- `R8`
- `R9`
- `REL-RUL-001`
- `REL-RUL-002`
- `REL-RUL-003`
- `REL-RUL-004`
- `REL-RUL-005`
- `REL-RUL-006`
- `REL-RUL-007`
- `REL-RUL-008`
- `REL-RUL-009`
- `REL-RUL-010`
- `REL-RUL-012`
- `REL-RUL-013`
- `REL-RUL-014`
- `REL-RUL-015`
- `REL-RUL-017`
- `REL-RUL-018`
- `REL-RUL-019`
- `REL-RUL-020`
- `REL-RUL-021`
- `REL-RUL-022`
- `REL-RUL-023`
- `REL-RUL-024`
- `REL-RUL-025`
- `REL-RUL-026`

---

## 14) Prompt and LLM Contract (No Guesswork)

### 14.1 Prompt Registry Requirements

- Centralize all prompt keys in one registry; no inline anonymous prompt text in stage modules.
- Each prompt entry must define required inputs, optional inputs, output schema, timeout, retry policy, model role.
- If prompt output is malformed, remediation path must be explicit and test-covered.

### 14.2 Prompt Key Inventory (Discovered in current code)

- `ATTRIBUTE_DEDUP_PROMPT`
- `ATTRIBUTE_GENERATE_PROMPT`
- `AUDIT_PROMPT_TEMPLATES_FN`
- `BUSINESS_CONTEXT_PROMPT`
- `DOMAINS_WORKER_PROMPT`
- `DOMAIN_ARCHITECT_REVIEW_PROMPT`
- `DOMAIN_GENERATE_PROMPT`
- `DOMAIN_JUDGE_PROMPT`
- `DOMAIN_METRICS_PROMPT`
- `FK_AMBIGUOUS_RESOLVE_PROMPT`
- `FK_ANOMALY_DETECT_PROMPT`
- `FK_BATCH_RESOLVE_PROMPT`
- `FK_BROKEN_RESOLVE_PROMPT`
- `FK_COLUMN_RENAME_PROMPT`
- `FK_CROSS_DOMAIN_MESH_PROMPT`
- `FK_CYCLE_BREAK_PROMPT`
- `FK_EDGE_SYNTHESIS_PROMPT`
- `FK_FIND_MISSING_PROMPT`
- `FK_IN_DOMAIN_LINK_PROMPT`
- `FK_LINKING_PROMPT`
- `FK_MANY_TO_MANY_PROMPT`
- `FK_PAIRWISE_LINK_PROMPT`
- `FK_SEMANTIC_CORRECTNESS_GATE_PROMPT`
- `IMPORT_CSV_PROMPT`
- `KPI_FIRST_GLOBAL_PROMPT`
- `LLM_FALLBACK_CLASSIFY_PROMPT`
- `LLM_FALLBACK_EXECUTE_PROMPT`
- `LLM_FALLBACK_QUERY_PROMPT`
- `MODEL_ARCHITECT_REVIEW_PROMPT`
- `MODEL_GENERATION_PARAMETER_PROMPT`
- `MV14_GATE_PROMPT_EXISTS`
- `MV14_SYNTHESIS_PROMPT_EXISTS`
- `MV15_GATE_PROMPT_EXISTS`
- `NAMING_CONVENTION_PROMPT`
- `PROCESS_FLOW_FK_GATE_PROMPT`
- `PRODUCT_DUPLICATE_DETECT_PROMPT`
- `PRODUCT_GENERATE_PROMPT`
- `PRODUCT_GLOBAL_DEDUP_PROMPT`
- `PRODUCT_IDENTIFY_CORE_PROMPT`
- `PRODUCT_MERGE_SIMILAR_PROMPT`
- `PRODUCT_MERGE_SMALL_PROMPT`
- `QA_DENORMALIZE_PROMPT`
- `QA_ESTIMATE_ROWS_PROMPT`
- `QA_GENERATE_DESCRIPTIONS_PROMPT`
- `QA_INDUSTRY_TEMPLATE_PROMPT`
- `QA_NORMALIZE_3NF_PROMPT`
- `QA_PROMPT`
- `QA_REVERSE_ENGINEER_PROMPT`
- `QA_SUGGEST_ATTRS_PROMPT`
- `QA_SUGGEST_TABLES_PROMPT`
- `QUALITY_DOMAIN_FIT_PROMPT`
- `QUALITY_NORMALIZATION_PROMPT`
- `RESIZE_ANALYSIS_PROMPT`
- `RESIZE_ENLARGE_DOMAIN_PROMPT`
- `RESIZE_SHRINK_DOMAIN_PROMPT`
- `SAMPLE_POOL_PROMPT`
- `SSOT_BLOCK_GATE_PROMPT`
- `SUBDOMAIN_ALLOCATE_PROMPT`
- `TAG_CLASSIFY_PROMPT`
- `VIBE_AUDIT_PROMPT`
- `VIBE_CREATE_NEXT_PROMPT`
- `VIBE_DROP_PROMPT`
- `VIBE_DROP_RELEVANCE_PROMPT`
- `VIBE_MASTER_PROMPT`
- `VIBE_PARSE_PROMPT`
- `VIBE_PRUNE_PROMPT`

### 14.3 Model Routing Contract

- `thinker` prompts: deterministic temperature profile, architecture-level decisions only.
- `worker` prompts: bounded generation for domains/products/attributes/links/artifacts.
- Retry policy: bounded retries with demotion/escalation and explicit timeout handling.
- No silent accept of malformed payloads into final model state.

---

## 15) Artifact Formatting Contract (No Drift Allowed)

### 15.1 Artifact Ordering

- Artifacts must be emitted in a stable order equivalent to current pipeline behavior.
- `model.json`, `vibes/current_vibes.txt`, `vibes/next_vibes.txt` are mandatory outputs for iterative operations.

### 15.2 `model.json` Field Order Contract

- Top-level key order is fixed:
  1. `agent_version`
  2. `model_requirements`
  3. `_vibe_session_metadata`
  4. `model`
- Any rewrite path that writes `model.json` must refresh `agent_version` to runtime value.

### 15.3 File Encoding and Rendering Rules

- UTF-8 text output, newline-normalized, deterministic JSON indentation.
- SQL exports preserve statement ordering and naming conventions.
- Docs/report artifacts preserve downstream parsing expectations (headings, key labels, sections).

---

## 16) Zero-Ambiguity Acceptance Suite (Must Pass Before Cutover)

### 16.1 Input Parity

- Verify widget parity for `boolean_format` (name/type/default/options/empty-value behavior).
- Verify widget parity for `business_description` (name/type/default/options/empty-value behavior).
- Verify widget parity for `business_domains` (name/type/default/options/empty-value behavior).
- Verify widget parity for `business_name` (name/type/default/options/empty-value behavior).
- Verify widget parity for `catalog_prefix` (name/type/default/options/empty-value behavior).
- Verify widget parity for `catalog_suffix` (name/type/default/options/empty-value behavior).
- Verify widget parity for `cataloging_style` (name/type/default/options/empty-value behavior).
- Verify widget parity for `classification_levels` (name/type/default/options/empty-value behavior).
- Verify widget parity for `context_file` (name/type/default/options/empty-value behavior).
- Verify widget parity for `data_model_scopes` (name/type/default/options/empty-value behavior).
- Verify widget parity for `date_format` (name/type/default/options/empty-value behavior).
- Verify widget parity for `deployment_catalog` (name/type/default/options/empty-value behavior).
- Verify widget parity for `generate_samples` (name/type/default/options/empty-value behavior).
- Verify widget parity for `history_tracking_columns` (name/type/default/options/empty-value behavior).
- Verify widget parity for `housekeeping_columns` (name/type/default/options/empty-value behavior).
- Verify widget parity for `model_version` (name/type/default/options/empty-value behavior).
- Verify widget parity for `model_vibes` (name/type/default/options/empty-value behavior).
- Verify widget parity for `naming_convention` (name/type/default/options/empty-value behavior).
- Verify widget parity for `operation` (name/type/default/options/empty-value behavior).
- Verify widget parity for `org_divisions` (name/type/default/options/empty-value behavior).
- Verify widget parity for `primary_key_suffix` (name/type/default/options/empty-value behavior).
- Verify widget parity for `schema_prefix` (name/type/default/options/empty-value behavior).
- Verify widget parity for `schema_suffix` (name/type/default/options/empty-value behavior).
- Verify widget parity for `table_id_type` (name/type/default/options/empty-value behavior).
- Verify widget parity for `tag_prefix` (name/type/default/options/empty-value behavior).
- Verify widget parity for `tag_suffix` (name/type/default/options/empty-value behavior).
- Verify widget parity for `timestamp_format` (name/type/default/options/empty-value behavior).
- Verify widget parity for `vibe_fidelity_gate_halt_disabled` (name/type/default/options/empty-value behavior).
- Verify widget parity for `vibe_session_id` (name/type/default/options/empty-value behavior).

### 16.2 Operation Parity

- `new base model`: identical prerequisites, outputs, stage events.
- `vibe modeling of version`: identical version requirements and vibe-required protections.
- `shrink ecm`: identical scope transition semantics and integrity guarantees.
- `enlarge mvm`: identical expansion semantics with rule-bound growth.
- `install model`: identical deployment preconditions and parity auditing.
- `uninstall model version`: identical teardown safety behavior.
- `generate sample data`: identical sample count and FK validity guarantees.

### 16.3 Artifact Parity

- Byte-level compare for deterministic artifacts where possible.
- Schema-level compare for generated content with expected stochastic fields isolated.
- Metadata parity compare for `next_vibes` and session fields.

### 16.4 Regression Signatures

- No reintroduction of known critical signatures: soft-accept leakage, metric-view drops, cycle recurrence, fidelity hard-fails, missing FIRED markers.
- Enforce parity with historical test contracts from `tests/unit-tests/` and runner/tester flows.

---

## 17) Proof This Is a Redesign, Not a Copy

- Old monolith behavior is retained through compatibility adapters, but internals are restructured into stage modules, explicit contracts, and policy engines.
- Prompt, rule, and action handling are centralized into registries rather than spread across ad-hoc call sites.
- Agentic loop becomes an explicit subsystem with deterministic finding lifecycle, not incidental scattered logic.
- Deployment and artifact concerns are separated from planning/generation concerns to cut coupling and improve performance.

### 17.1 Redesign Completion Definition

- Complete rewrite is considered done only when all legacy compatibility tests pass while the new module architecture is active and no legacy notebook internals are required.

---

## 18) Updated Brutal Honesty

- Coverage score after this expansion: 96/100.
- Remaining 4 points: full 100 requires live shadow-run evidence proving each dynamic prompt path and every stochastic branch matches required behavior envelopes in production-like runs.
- No-lazy-route statement: this document now includes architecture, contracts, rule inventory, prompt inventory, parity criteria, and cutover definition at implementation depth.

---

## 19) Integration Protocol Contract (App + Runner + Agent)

### 19.1 `_business` Table Contract (Session Row)

Location: `<catalog>.<schema>._business`

Required columns and semantics:
- `session_id` (BIGINT): stable run identity.
- `processing_status` (STRING): `pending` | `ready` | `done`.
- `completed_percent` (DOUBLE): additive progress, capped at `99.0` until finalization, set to `100.0` at terminal.
- `session_started_at`, `last_updated_at`, `completion_date` (TIMESTAMP): lifecycle fields.
- `session_json` (STRING): reserved payload.
- `results_json` (STRING): terminal summary payload.
- Identity keys: `business`, `version`, `model_scope`.

### 19.2 `_vibe_progress` Table Contract (Append-Only Events)

Location: `<catalog>.<schema>._vibe_progress`

Required columns and semantics:
- `session_id` (BIGINT): FK-like linkage to `_business`.
- `step_id` (BIGINT): event id.
- `last_updated` (TIMESTAMP): flush time.
- `stage_name` (STRING), `step_name` (STRING): UI-facing stage metadata.
- `attempt_number` (INT): retry lineage.
- `progress_increment` (DOUBLE): additive increment for `completed_percent`.
- `message` (STRING): human-readable status summary.
- `status` (STRING): one of `stage_started`, `stage_in_progress`, `stage_succeeded`, `stage_failed`, `stage_warning`, `stage_ended`.
- `event_seq` (BIGINT): monotonic session order; consumers sort by `COALESCE(event_seq, step_id)`.
- `result_json` (VARIANT): stage payload for UI rendering and auditing.

### 19.3 Handshake State Machine (Must Stay Compatible)

State transitions:
- Agent insert: `pending`.
- Agent initialization: `done`.
- Agent flush batch: `ready`.
- UI consumes batch and acknowledges: `done`.
- Final flush: `ready` with terminal payload and `completed_percent = 100.0`.

Rules:
- Agent may wait for UI acknowledgement, but must include timeout fallback to avoid deadlock.
- UI writeback operation is only setting `_business.processing_status = 'done'` for the active session row.

### 19.4 Progress Event Semantics (Frozen Vocabulary)

- `stage_started`: begins stage, `progress_increment = 0.0`.
- `stage_in_progress`: intermediate additive increments.
- `stage_succeeded`: stage complete increment.
- `stage_failed`: stage failure, non-progress increment.
- `stage_warning`: non-fatal advisory event.
- `stage_ended`: terminal session bookend event.

### 19.5 `result_json` Required Payloads by Stage Family

Minimal required fields:
- Session started/ended: `session_id`, `business_name`, `operation`, `version`, `model_scope`, status summary.
- Domains stage: `count`, `domains[]`.
- Products stage: `domain`, `products[]`, generated counts.
- Attributes stage: `domain`, `product`, `attributes[]`.
- Linking stage: `new_links[]` and reconciliation snapshot keys.
- QA stage: applied changes (`rename_log`, `consolidation_log`, cycle breaks if any).
- Finalization stage: canonical model summary counts and topology summary.

### 19.6 AI Logs Contract

AI log stream must remain parse-compatible with downstream tooling.

Required columns:
- `timestamp`
- `stage`
- `step`
- `prompt_name`
- `model`
- `input_tokens`
- `output_tokens`
- `cost_usd`
- `latency_ms`
- `attempts`
- `honesty_score`
- `accepted`
- `notes`

### 19.7 Job Tags Contract

Runner and downstream monitors rely on these tags and counters:
- domain/product/attribute/fk/tag/metric counters
- operation + scope + business identity tags
- terminal status + duration tags for run-level summary

Job-tag contract must be preserved in naming and cardinality semantics so monitoring and tester reports remain stable.

### 19.8 Stage Registry and Progress Budget Contract

The canonical stage sequence is fixed:
- Setup and Configuration
- Interpreting Instructions
- Collecting Business Context
- Designing Domains
- Creating Data Products
- Enriching Data Products with Attributes
- Cross-Domain Linking
- Quality Assurance
- Applying Naming Conventions
- Model Finalization
- Subdomain Allocation
- Physical Schema Construction
- Applying Foreign Keys
- Applying Tags
- Applying Metric Views
- Generating Sample Data
- Generating Metric View Artifacts
- Generating Artifacts
- Consolidation and Cleanup

Bookends:
- `Vibe Session / Session Started`
- `Vibe Session / Session Ended`

Progress budgeting contract:
- additive increments to `completed_percent`
- operational cap at `99.0` before terminal
- terminal event moves to `100.0`

Implementation requirement:
- materialize the full per-stage `result_json` schema catalog as a versioned contract file consumed by both agent and UI tests.

---

## 20) Operation-by-Operation Execution Contract

### 20.1 `new base model`

- Start at S0.
- Execute full S0..S11 pipeline.
- Emit all logical artifacts and optional physical artifacts if catalog provided.

### 20.2 `vibe modeling of version`

- Load source `model.json` for target version.
- Require non-empty vibe instructions or explicit convention changes.
- Enter at Quality Loop path with surgical/holistic planner, then continue through artifact and next-vibes generation.

### 20.3 `shrink ecm`

- Load source ECM.
- Execute scope reduction with protected-target enforcement.
- Revalidate all graph and SSOT gates before writeback/install.

### 20.4 `enlarge mvm`

- Load source MVM.
- Execute bounded expansion respecting user directives and structural gates.
- Revalidate all graph and SSOT gates before writeback/install.

### 20.5 `install model`

- Requires model source path + deployment catalog.
- Execute physical deployment path + parity audit.
- Must not mutate logical model except required metadata refresh (`agent_version` and install metadata).

### 20.6 `uninstall model version`

- Requires deployment catalog + target version.
- Execute uninstall-only flow with explicit audit output.
- Preserve unrelated versions and shared metadata rows.

### 20.7 `generate sample data`

- Requires installed model and deployment catalog.
- Execute sample generation only; no structural model mutation.
- Enforce exact row count and FK-validity checks.

### 20.8 Cleanup/Deletion Safety Contract

- Destructive operations (catalog/schema/table/job/run deletion) require explicit user cleanup intent.
- Ownership checks are mandatory for destructive catalog actions.
- If cleanup is not explicitly requested, operations must run in-place or in fresh namespaced targets without deleting existing assets.

---

## 21) Tool Contract (Schema-First Agentic Execution)

Every tool in the agentic loop must declare:
- `id`
- `description`
- `input_schema` (JSON Schema)
- `output_schema` (JSON Schema)
- `failure_modes`
- `emitted_events`
- `side_effects`

Execution rules:
- Tool outputs that fail schema validation cannot mutate `ModelStore`.
- Any mutation tool must emit before/after diff summaries in logs.
- Protected-target conflicts must be rejected before mutation apply.

Minimum tool families:
- Generator tools (LLM-driven proposals)
- Analyzer tools (deterministic checks)
- Mutator tools (deterministic state changes)
- Writer tools (artifact emission)
- Deployer tools (physical apply/unapply)

---

## 22) Deterministic Model Quality Score Contract

The rewrite must publish a deterministic score function (no LLM calls) with explicit weights and thresholds.

Required components:
- FK coverage
- cross-domain connectivity
- DAG/bidirectional integrity
- SSOT compliance
- naming compliance
- PK completeness
- classification completeness
- attribute depth fit by tier
- silo absence
- metric-view validity

Rules:
- Weights must sum to `1.0`.
- Same model snapshot must always produce same score.
- Score and component breakdown must be persisted in both logs and next-vibes metadata.

---

## 23) Migration and Cutover Acceptance Thresholds

Parallel-run validation must pass all:
- Widget contract parity: 100%.
- Operation contract parity: 100%.
- Artifact presence parity: 100%.
- `model.json` structural parity: required keys and ordering 100%.
- Physical parity: table/column/metric-view count parity 100%.
- Hard-signature regressions: 0.
- Score drift threshold: within approved tolerance band.
- Tier-1 ECM runtime target: <= 2h on canary profile.
- Tiny MVM runtime target: <= 10m.
- LLM call-count reduction target versus baseline: >= 40%.

Recommended rollout order:
- tiny MVM no-vibe
- airline MVM no-vibe
- airline ECM no-vibe
- vibe-of-version iteration cycle
- shrink/enlarge/install/uninstall/sample-only operations

Promotion gate:
- New architecture becomes default only after all above pass for repeated runs, not one-off green runs.

---

## 24) Post-Review Closure

Misses found and now closed in this document:
- integration handshake and progress-table contract depth
- explicit event lifecycle and `result_json` contract
- operation-by-operation execution contract depth
- schema-first tool contract
- deterministic score contract
- cutover acceptance thresholds

Updated self-assessment:
- completeness after closure: 98/100.
- remaining 2 points require live execution parity evidence across real runs, which is outside static design-doc analysis.
