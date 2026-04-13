# Vibe Modelling Agent Design Guide

## 1. Philosophy: Industry Data Models vs. Business Data Models

### What is an Industry Data Model?
An industry data model is a generic, one-size-fits-all template designed for an entire vertical — retail, banking, healthcare, telecoms, etc. Organizations like the TM Forum (telecoms), ARTS (retail), ACORD (insurance), HL7 (healthcare), and BIAN (banking) publish canonical schemas attempting to cover every conceivable entity and relationship across an industry.

Problems with industry data models:
- They contain 60-80% of tables your business will never use
- Months of manual pruning, renaming, and reshaping needed
- Committee-standard naming rarely matches your terminology
- Version upgrades mean re-adoption pain
- License fees + adaptation labor costs
- Static and rigid - don't evolve with your business

### What is a Business Data Model?
A business data model is tailored, contextualized, and specific to YOUR organization. It reflects your actual business processes, product lines, org structure, regulatory environment, terminology, and governance requirements.

Key differences table:
| Aspect | Industry Data Model | Business Data Model (Vibe) |
|---|---|---|
| Scope | Entire industry vertical | Your specific business |
| Customization | Post-delivery (manual pruning) | Built-in (LLM-driven from your context) |
| Relevance | 20-40% directly applicable | 90-100% directly applicable |
| Time to production | Months of adaptation | Hours with iterative vibing |
| Naming | Committee-standard naming | Your business terminology |
| Evolution | New version = re-adoption | Vibe the next version |
| Cost | License fees + adaptation labor | Compute cost of LLM generation |

### How Vibe Modelling Bridges the Gap
Vibe Modelling takes the BEST of both worlds:
- It understands your industry deeply (via the 5-tier complexity classification system that evaluates 7 scoring dimensions)
- But the model it produces is shaped entirely by YOUR context
- The LLM has knowledge of industry standards (TM Forum SID, ARTS, HL7, etc.) and uses them as INSPIRATION, not as rigid templates
- Every domain, product, attribute, and relationship is justified by YOUR business processes
- The result: an industry-aware business data model that's 90-100% relevant on day one

### The Vibe Philosophy
```
1. GENERATE  →  Describe your business, get a base model
2. VIBE IT   →  Review output, provide natural-language refinements
3. REPEAT    →  Each iteration = new version; agent auto-suggests next vibes
4. DEPLOY    →  Physical Unity Catalog schemas, tables, FKs, tags, sample data
```

Every organization can "vibe its own model" — no two outputs are the same because no two businesses are the same, even within the same industry. A telecommunications company in the Middle East will get a fundamentally different model than a telecommunications company in Scandinavia, because their regulatory environments, product lines, organizational structures, and business processes differ.

---

## 2. Architecture Overview

### The Four-Level Hierarchy
Every Vibe model follows a strict four-level hierarchy: Divisions → Domains → Products (Tables) → Attributes (Columns).

**Level 1: Divisions** — Top-level organizational grouping
| Division | Purpose | Typical Share |
|---|---|---|
| Operations | Core operational backbone — HOW things get made/delivered/maintained | Combined ≥80% |
| Business | Revenue-generating and customer-facing functions | Combined ≥80% |
| Corporate | Supporting functions for governance (NOT directly revenue-generating) | ≤20% |

Division Balance Rules:
- Operations + Business MUST be ≥80% of all domains
- Corporate is capped at ≤20% of total domains
- No Corporate domain allowed until Operations AND Business each have ≥2 domains
- Interleaved filling: alternate Operations and Business domains when building

**Level 2: Domains** — Logical grouping of related tables (maps 1:1 to Unity Catalog schema)
- Named in snake_case, exactly 1 word, lowercase, max 20 characters
- Must be singular form (exceptions: logistics, sales, operations)
- The `shared` domain is RESERVED — auto-created during SSOT consolidation only
- Forbidden generic names: utilities, infrastructure, services, support, platform, shared, common, core, base, general, misc, other, admin, auxiliary, analytics, reporting, intelligence, insights

**Level 3: Products (Tables)** — First-class business entities
- Every product gets a PK column: `<product_name>_<pk_suffix>` (default: `_id`)
- Must pass the First-Class Entity Test (5 criteria)
- Classified by data_type: master_data, reference_data, transactional_data, association_data
- Classified by function: core or helper
- Named 1-3 words, max 30 characters, no domain prefix

**Level 4: Attributes (Columns)** — Properties of each product
- Named in snake_case, max 50 characters
- No product name prefix (except PK)
- Typed using Spark SQL types: STRING, BIGINT, INT, DECIMAL(p,s), TIMESTAMP, DATE, BOOLEAN
- No complex types (ARRAY, STRUCT, MAP)
- Tagged with classification (restricted, confidential, internal, public) and PII tags when applicable

### Model Scopes: MVM vs ECM
| | MVM (Minimum Viable Model) | ECM (Expanded Coverage Model) |
|---|---|---|
| Size | 30-50% of ECM table count | Full coverage |
| Attribute depth | SAME as ECM — full production-grade | Full production-grade |
| Domains | Essential business functions only | All functions including corporate |
| Ideal for | SMBs, rapid deployments, POCs | Fortune 100, multinational enterprises |

MVM is NOT a skeleton or demo. It is a production-ready subset where every delivered table is fully-featured. MVM lightness comes from fewer domains and fewer tables per domain ONLY — never from thinner attributes.

### Industry Complexity Tiers (5 tiers)

The agent auto-classifies your business into one of five tiers based on 7 scoring dimensions:
1. Regulatory density: 3+ distinct regulatory bodies
2. Party complexity: 3+ distinct party types
3. Product hierarchy depth: 50+ variants with complex bundling
4. Infrastructure/network management: owns physical or digital infrastructure
5. Industry canonical data model: 200+ entity types by standards body
6. Transaction complexity: 10+ distinct transaction types
7. Operational system landscape: 5+ major systems of record

**ECM Tier Sizing:**
| Tier | Label | Domains | Products/Domain | Attrs/Product | Subdomains/Domain |
|---|---|---|---|---|---|
| tier_1 | Ultra-Complex | 15-22 | 14-28 | 15-50 | 3-6 |
| tier_2 | Complex | 12-18 | 14-26 | 12-50 | 2-5 |
| tier_3 | Moderate | 10-15 | 12-24 | 10-45 | 2-5 |
| tier_4 | Standard | 8-12 | 10-20 | 10-40 | 2-4 |
| tier_5 | Simple | 5-8 | 8-18 | 8-35 | 2-4 |

**MVM Tier Sizing:**
| Tier | Domains | Products/Domain | Attrs/Product | Subdomains/Domain |
|---|---|---|---|---|
| tier_1 | 9-14 | 8-16 | 15-50 | 3-6 |
| tier_2 | 8-12 | 8-14 | 12-50 | 2-5 |
| tier_3 | 6-10 | 7-13 | 10-45 | 2-5 |
| tier_4 | 5-8 | 6-11 | 10-40 | 2-4 |
| tier_5 | 3-6 | 5-10 | 8-35 | 2-4 |

Note: Attribute depth (min/max) is the SAME for both MVM and ECM within each tier. Association table uplift factor: 1.2x (applied to base table count). Max attributes buffer factor: 1.25x (allowing exceptional overflow).

---

## 3. How Vibe Modelling Works — Pipeline Stages

The pipeline executes a series of stages, each with a specific purpose, quality checks, and output. Here is the complete stage reference:

### Stage 1: Setup and Configuration
- **Purpose:** Validate inputs, create metamodel tables, initialize session
- **Duration:** 2-10 seconds
- **What happens:** Widget parameters are read, context file is parsed, metamodel tables (_business, _vibe_progress) are created/verified, session row is inserted
- **Quality check:** Input validation (required fields, valid operation, valid scope)
- **Progress budget:** 1.0%

### Stage 2: Interpreting Instructions (Vibe mode only)
- **Purpose:** Parse natural-language vibes into structured action plan
- **Duration:** 10-30 seconds
- **What happens:** The vibe text is analyzed and translated into 190+ specific actions. Hard constraints are extracted ("do not", "must not", "never" → forbidden operations). Mode is classified (surgical/holistic/generative) based on keywords.
- **Quality check:** Constraint extraction, requirement parsing
- **Progress budget:** 1.0%

### Stage 3: Collecting Business Context
- **Purpose:** Enrich the business description across 7 classification dimensions
- **Duration:** 10-30 seconds
- **What happens:** LLM enriches the business context with industry alignment, complexity tier classification, organization divisions, domain hints, common business jargon (30+ items), operational systems of record, and industry governing bodies. Empty fields are filled with exactly 10 distinct items each.
- **Quality check:** Tier classification validation, minimum jargon count (30+), domain count within tier range
- **Progress budget:** 1.0%

### Stage 4: Designing Domains
- **Purpose:** Generate domains following division model + SSOT
- **Duration:** 15-60 seconds
- **What happens:** LLM generates domains within the tier range. Each domain must pass the Org Chart Test ("Would I find a department named this?"). Fragmentation Test checks for 30%+ product overlap between domain pairs. Division balance is enforced.
- **Quality check:** Division balance (Ops+Business ≥80%), forbidden name check, fragmentation test, SSOT pre-check, naming validation (1 word, lowercase, singular, max 20 chars)
- **Progress budget:** 2.0%

### Stage 5: Creating Data Products
- **Purpose:** Generate products per domain with architect review
- **Duration:** 1-10 minutes
- **What happens:** Products generated per domain in parallel batches. Each product must pass the 5-point First-Class Entity Test. 3-tier entity selection (Core → Supporting → Reference). After generation, a Model Architect Review runs 15 holistic tests and scores the model.
- **Quality check:** First-Class Entity Test, Anti-Bloat Self-Check, product count within tier range, forbidden product check, naming validation, architect review (score-based action thresholds)
- **Progress budget:** 5.0%

### Stage 6: Enriching Data Products with Attributes
- **Purpose:** Generate all columns for every product
- **Duration:** 5-40 minutes
- **What happens:** Attributes generated per product in parallel. Each attribute has name, type, tags, value_regex, business_glossary_term, description, reference. Mandatory attributes enforced by product type. Semantic distinction rules prevent false-positive dedup. Attribute dedup runs per product (>80% confidence threshold).
- **Quality check:** Attribute count within tier range (with 1.25x buffer max), PK present, no product name prefix, tag classification validation, PII classification matrix, data type validation, semantic distinction rules
- **Progress budget:** 25.0%

### Stage 7: Cross-Domain Linking
- **Purpose:** Establish FK relationships forming a DAG
- **Duration:** 1-5 minutes
- **What happens:** Three-phase linking: (1) In-domain linking within each domain, (2) Global cross-domain sweep, (3) Pairwise domain comparison. M:N detection with 3-indicator confidence framework. MVM mode forbids cross-domain M:N.
- **Quality check:** DAG enforcement (no cycles), no bidirectional FKs, no self-referencing FKs, FK naming (must end with target PK), zero siloed tables, each domain ≥2 cross-domain connections, M:N confidence (≥2 of 3 strong indicators), association ratio limits (ECM ≤15%, MVM ≤5%)
- **Progress budget:** 8.0%

### Stage 8: Quality Assurance
- **Purpose:** Comprehensive model validation and auto-remediation
- **Duration:** 30 seconds - 3 minutes
- **What happens:** 9+ sub-checks run sequentially:
  1. Core Product Identification (1-3 per domain, protected from removal)
  2. Empty Domain Removal
  3. Naming & Schema Validation (enforce naming conventions)
  4. PK & Data Type Validation (auto-insert missing PKs, fix types)
  5. Name Overlap Detection (cross-domain duplicate names → prefix-based rename)
  6. Graph Topology Analysis (cycle detection via DFS, siloed table detection)
  7. Auto-Remediation (cycle breaking, consolidation, FK ref updates)
  8. QA Checks Summary
  9. FK Reference Validation (broken/ambiguous FK resolution)
  10. Post-Linking Validation (complete model snapshot)
- **Quality check:** All rules enforced, auto-fixes applied, cycle-free DAG verified
- **Progress budget:** 5.0%

### Stage 9: Applying Naming Conventions
- **Purpose:** Final consistency pass on all names
- **Duration:** 10-30 seconds
- **Progress budget:** 1.0%

### Stage 10: Model Finalization
- **Purpose:** Finalize the logical model, generate next vibes
- **Duration:** 10-30 seconds
- **What happens:** Final model state captured with complete products_by_domain and fk_links. Product count may increase vs QA (parent/bridge tables added). Next vibes and model context files generated.
- **Progress budget:** 1.0%

### Stage 11: Subdomain Allocation
- **Purpose:** Group products within each domain into semantic subdomains
- **Duration:** 10-30 seconds
- **What happens:** LLM allocates products to subdomains. Rules: exactly 2 words per subdomain name, min products per subdomain enforced per tier, no overlapping words between subdomain names, no placeholder names, balanced distribution.
- **Quality check:** Subdomain count within tier range, naming rules, balanced distribution
- **Progress budget:** 1.0%
- **Note:** Can emit stage_warning on non-critical failure

### Stage 12: Physical Schema Construction (when catalog is set)
- **Purpose:** Create Unity Catalog schemas + Delta tables
- **Duration:** 1-10 minutes
- **Progress budget:** 10.0%

### Stage 13: Applying Foreign Keys
- **Purpose:** Create physical FK constraints on tables
- **Duration:** 30 seconds - 2 minutes
- **Progress budget:** 3.0%

### Stage 14: Applying Tags
- **Purpose:** Apply Unity Catalog tags on schemas, tables, and columns
- **Duration:** 2-15 minutes
- **What happens:** Classification tags (division, data_type) applied to schemas and tables. PII tags applied to columns. Custom user tags applied.
- **Progress budget:** 18.0%

### Stage 15: Applying Metric Views
- **Purpose:** Create Databricks metric views for KPI tracking
- **Duration:** 30 seconds - 5 minutes
- **Quality check:** No nested aggregates, max 16 dimensions, max 12 numeric measures, ineligible column filtering
- **Progress budget:** 2.0%
- **Note:** Can emit stage_warning on partial failure

### Stage 16: Generating Sample Data (when configured)
- **Purpose:** Generate synthetic records respecting FK relationships
- **Duration:** 1-15 minutes
- **Quality check:** Exact record count, sequential PK from 10001, FK random from [10001, 10001+N-1], regex compliance, 3-letter country codes, no Lorem Ipsum, realistic business data
- **Progress budget:** 8.0%

### Stage 17: Generating Artifacts
- **Purpose:** Generate documentation and export files
- **Duration:** 30 seconds - 2 minutes
- **What happens:** Core artifacts are generated in parallel (README, Excel/CSV export, model JSON, data dictionary, model report). Depending on queued actions, additional artifacts can also be produced (for example ontology, DBML, release notes, and test cases).
- **Progress budget:** 5.0%

### Stage 18: Consolidation and Cleanup
- **Purpose:** Merge temporary artifacts, cleanup
- **Duration:** 10-30 seconds
- **Progress budget:** 2.0%

### Stage 19: Generating Metric View Artifacts
- **Purpose:** Export metric view definitions as SQL/YAML files
- **Duration:** 10-30 seconds
- **Progress budget:** 1.0%
- **Execution note:** In the current orchestrator, this stage is emitted during finalization before artifact generation and physical deployment, while keeping stage ID `19` for compatibility.

Total progress through stages: 99.0%. The final Vibe Session / Session Ended event adds 1.0% to reach 100.0%.

---

## 4. Core Principles and Governance

### Single Source of Truth (SSOT)
Each core business concept has exactly ONE authoritative domain and ONE authoritative product that owns it. No concept is duplicated across domains.

Enforcement:
- Generation: LLM places each entity in its authoritative domain
- QA Deduplication: Global pass detects same-name products + synonym pairs with 60%+ attribute overlap
- Consolidation: Overlapping products merged into shared domain with discriminator column
- Cross-Domain References: Other domains use FK columns — no duplication

### DAG Enforcement
FK relationships MUST form a Directed Acyclic Graph (DAG):
- Detect: Python DFS cycle detection during QA
- Break: LLM Cycle Break specialist determines which FK to remove (weakest link)
- Verify: Re-run DFS to confirm DAG
- Iterate: Up to 5 rounds for all cycles
- Exception: Hierarchical self-referencing FKs are permitted (parent_*, manager_*, reporting_*, supervisor_*, alternate_*, original_*, superseded_*)

Cycle breaking priority: computed references broken first (latest_*, current_*, primary_*, active_*, default_*, first_*, last_*, preferred_*). Parent-child FKs are NEVER broken.

### First-Class Entity Test (5 criteria)
Every product must pass ALL:
1. Identity Test: Own primary key and distinct identity
2. Lifecycle Test: Own lifecycle independent of parent
3. Richness Test: 5+ unique business attributes beyond id/name/code/description/status
4. Ownership Test: This domain is the natural business owner
5. Uniqueness Test: Semantically distinct from every other product in the domain

### The Org Chart Test
For every domain: "If I walked into the business headquarters, would I find a department named this?" If NO → domain is generic and must be renamed.

### The Fragmentation Test
Before creating two similar domains, ask:
1. Will they have 30%+ of the same product types? → MERGE
2. Would a data consumer be confused about which owns a concept? → MERGE
3. Does the industry treat these as one function? → MERGE

---

## 5. Quality Assurance Rules Reference

### Naming Convention Rules (G01)
- G01-R001: All names must use snake_case by default
- G01-R002: Domain names — exactly 1 word, lowercase, max 20 chars
- G01-R003: Domain names — singular (exceptions: logistics, sales, operations)
- G01-R004: Table names — 1-3 words, max 30 chars
- G01-R005: Table names — MUST NOT repeat domain name as prefix
- G01-R006: Column names — MUST NOT repeat table name as prefix (except PK)
- G01-R007: PK names — pattern: table_name + suffix (e.g., customer_id)
- G01-R008: FK column names — MUST END WITH target table's PK name
- G01-R009: Column names — max 50 characters
- G01-R010: All names — lowercase, letters/numbers/underscores only, no digit start
- G01-R011: Association table names — no domain prefix
- G01-R012: Merged table names — most generic, domain-agnostic name
- G01-R013: Column names — clear, semantic, human-readable
- G01-R014: Preserve unit qualifiers (kg, mwh, per_min)
- G01-R015: Industry jargon — only universally recognized abbreviations

### FK Rules (G03)
- G03-R001: FK target must exist in the model
- G03-R002: No bidirectional FKs between same tables
- G03-R003: No circular dependencies (DAG required)
- G03-R004: FK type compatibility (numeric→numeric, string→string)
- G03-R005: FK attribute must exist in source product
- G03-R006: FK must reference PK of target product
- G03-R007: System identifier columns are NOT FK columns (external_reference, legacy_*, integration_*, *_ref, *_code, *_number, *_hash, *_token)
- G03-R010: No self-referencing FKs unless hierarchical
- G03-R015: Parent-child FKs NEVER broken during cycle resolution

### PK Rules (G04)
- G04-R001: Every product has exactly one PK
- G04-R002: PK naming: {product_name}_{suffix}
- G04-R003: PK data type must be configured type (default BIGINT)
- G04-R008: PK exempt from product prefix stripping

### Tag Rules (G08)
- G08-R001: Classification in tags only, NOT in attribute names
- G08-R002: Must include PII tags when applicable (pii_email, pii_phone, pii_identifier, pii_address, pii_financial, pii_health, pii_biometric, pii_name, pii_dob, pii_national_id, pii_passport, pii_ip, pii_device)
- G08-R003: No primary_key or foreign_key tags
- G08-R004: PII = RESTRICTED classification
- G08-R005: PHI = RESTRICTED
- G08-R006: PCI = RESTRICTED
- G08-R007: CONFIDENTIAL for non-PII sensitive business data
- G08-R008: Empty tags for regular operational data

### M:N Rules (G12)
- G12-R001: M:N valid only when: (1) bidirectional reality, (2) ≥2 relationship attributes, (3) business has name for relationship
- G12-R010: Association ratio limits: ECM ≤15%, MVM ≤5%
- G12-R012: Only HIGH confidence M:N accepted
- G12-R013: HIGH confidence requires ≥2 of 3 strong indicators (reciprocity_confirmed, relationship_data_confirmed, semantic_name_found)
- G12-R021: MVM forbids cross-domain M:N

### Subdomain Rules
- SUB-R001: Min/max subdomains per domain per tier. Never exactly 1 subdomain.
- SUB-R002: Exactly 2 words per subdomain name
- SUB-R003: Min products per subdomain enforced per tier
- SUB-R004: No overlapping words between subdomains in same domain
- SUB-R005: Business-focused names, not technical terms
- SUB-R006: Balanced product distribution across subdomains
- SUB-R007: No placeholder names (Sub Domain1, Category 1, Group A, N/A, Other, General, Miscellaneous)
- SUB-R008: Each subdomain belongs to exactly one parent domain

---

## 6. LLM Architecture

### Multi-Model Ensemble
| Role | Purpose | Models |
|---|---|---|
| Thinker | Complex reasoning, architecture reviews, QA decisions | Claude Opus 4.6, Claude Opus 4.5 |
| Worker (large) | High-volume: products, attributes, FKs, dedup | Claude Sonnet 4.6, Claude Sonnet 4.5 |
| Worker (small) | Simpler: domain generation, tag classification | GPT-OSS 120B |
| Worker (tiny) | Sample data generation | GPT-OSS 20B |

### Automatic Model Demotion
If a model fails after N consecutive attempts (default: 3), the agent demotes to the next model in the chain. The pipeline always completes.

### Honesty Scoring System
Every LLM response includes a self-assessed honesty_score (0-100):
- 90-100: Rules followed, output complete, no gaps
- 80-89: Minor issues
- 70-79: Notable gaps
- 50-69: Significant issues
- Below 50: Major problems

Enforcement:
- Below 55: PERMANENTLY DISCARDED (no retries)
- 55-70: Borderline — triggers retry logic
- Above 90: Accepted (configurable threshold)

### Prompt Architecture
40+ specialized prompts, each mapped to a specific model role and temperature:
- Thinker prompts: temperature 0 (deterministic reasoning)
- Worker prompts: temperature 0-0.3 (controlled generation)
- Sample generation: temperature 0.5 (creative variety)

---

## 7. Sizing and Configuration Constants

### Key Constants
| Constant | Default | Purpose |
|---|---|---|
| product_sample_records | 10 | Records per table for sample data |
| max_concurrent_batches | 20 | Max parallel LLM calls |
| batch_size | 20 | Items per LLM batch |
| max_retries | 3 | LLM retry count |
| product_attributes_dedupe_threshold | 40 | Attribute overlap % for dedup |
| min_honesty_score_threshold | 65 | Min acceptable honesty score |
| ai_query_timeout_seconds | 480 | LLM call timeout |
| model_demotion_after_n_failures | 3 | Failures before model demotion |
| association_table_uplift | 1.2 | Factor for junction tables |
| max_attributes_buffer_factor | 1.25 | Attribute overflow buffer |
| domain_hard_ceiling_factor | 1.5 | Domain count hard ceiling |
| resize_tolerance_pct | 15 | ±% for resize targets |

### Vibe Constraints
| Constraint | Default | Purpose |
|---|---|---|
| dedup_min_overlap | 85% | Min overlap to consider duplicates |
| max_relocation_pct | 5% | Max products relocated in one pass |
| min_overlap_for_removal | 85% (95% in remediation) | Overlap to recommend removal |
| min_overlap_for_merge | 60% | Overlap to recommend merge |
| min_overlap_for_shared | 60% | Overlap to move to shared domain |
| normalization_confidence | 95% | Min confidence for normalization decisions |

### Mutation Budgets by Mode
| Mode | Global Rewrites | Domains | Products | Attributes |
|---|---|---|---|---|
| Surgical | 0 | 4 | 80 | 1,200 |
| Holistic | 4 | 30 | 400 | 12,000 |
| Generative | 12 | 100 | 1,000 | 50,000 |

---

## 8. Operations Reference

| Operation | Purpose | Key Requirements |
|---|---|---|
| new base model | Generate brand-new model | Business name + description |
| vibe modeling of version | Apply NL refinements | Version + vibes |
| shrink ecm | Convert ECM to MVM | Version + catalog |
| enlarge mvm | Expand MVM to ECM | Version + catalog |
| install model | Deploy to UC | Context file + catalog |
| uninstall model version | Remove physical artifacts | Business + version + catalog |
| generate sample data | Generate synthetic records | Context file + catalog |

### Resize Rules
**Shrink (ECM→MVM):**
1. Reduce corporate domains first
2. Reduce association tables
3. Reduce non-core tables
4. Consolidate domains
5. Verify within ±tolerance%
- MUST NOT invent new domains or products

**Enlarge (MVM→ECM):**
- ALL existing domains MUST be retained
- ALL existing products MUST be retained
- Can only ADD new products and domains

---

## 9. Metric Views

The agent generates Databricks metric views — reusable KPI definitions:
- Dimensions: Grouping columns (max 16 per view, max 2 temporal)
- Measures: Single-aggregate expressions (max 12 numeric)
- Filters: Row-level predicates

Safety rules:
- Nested aggregates auto-replaced with COUNT(1)
- Invalid token-cast fragments blocked (9 patterns)
- SUM/AVG/MEAN columns auto-wrapped with CAST(col AS DOUBLE)
- System/audit columns ineligible as dimensions
- PK and boolean columns ineligible as measures

---

## 10. Sample Data Generation Rules

- Exact N records per table (configurable)
- BIGINT PKs: sequential from 10001, never NULL
- STRING PKs: valid UUIDs
- FK values: random from [10001, 10001+N-1]
- A column is NEVER both PK and FK simultaneously
- All values comply with value_regex patterns
- Country codes: 3-letter uppercase (USA not United States)
- No Lorem Ipsum — realistic, business-appropriate data
- If source systems specified, generate realistic data from those systems
- CSV column headers use column_name field (not attribute field)
- Boolean format follows widget configuration

---

## 11. Column Templates

Pre-built column sets that can be added to any table via vibe instructions:

| Template | Columns Added |
|---|---|
| SCD Type 2 | effective_from, effective_to, is_current, row_hash |
| Audit | created_at, updated_at, created_by, updated_by |
| Soft Delete | is_deleted, deleted_at, deleted_by |
| Temporal | valid_from, valid_to, system_from, system_to |
| Versioning | version_number, version_valid_from, version_valid_to, is_latest_version |
| Multi-tenancy | tenant_id |
| Lineage | source_system, source_table, ingestion_timestamp, etl_job_id |
| GDPR | consent_status, consent_date, data_subject_request_id, right_to_erasure_date |

---

## 12. Semantic Distinction Rules (What Is NOT a Duplicate)

These rules prevent false-positive dedup:
| Pattern | Example | Decision |
|---|---|---|
| Method vs Channel | payment_method vs payment_channel | KEEP BOTH |
| ID vs Name | customer_id vs customer_name | KEEP BOTH |
| Target vs Actual | sla_target_time vs sla_actual_time | KEEP BOTH |
| Lifecycle Timestamps | created_at, modified_at, approved_at | KEEP ALL |
| Different Granularity | scheduled_date (DATE) vs scheduled_start_time (TIMESTAMP) | KEEP BOTH |
| Design vs Regulatory | design_speed_mph vs speed_limit_mph | KEEP BOTH |
| Rated vs Actual | rated_capacity vs actual_capacity | KEEP BOTH |
| Book vs Market | book_value vs market_value | KEEP BOTH |

What IS a duplicate:
- creation_date vs created_at vs insert_date → SAME CONCEPT
- modified_date vs updated_at vs last_update → SAME CONCEPT
- status vs state vs condition → SAME CONCEPT
- quantity vs qty vs count → SAME CONCEPT

---

*Built on Databricks Serverless Compute with Unity Catalog governance*
