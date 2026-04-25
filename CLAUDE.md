# CLAUDE.md — Project Guardrails for the vibe-modelling-agent

These instructions apply to every session in this repository. Follow them verbatim.

---

## 0. Release-note detail standard (when tagging to main)

REFERENCE: https://example.com/releases/v0/

When the user asks to tag a release to main, the release notes MUST match the depth and structure of that reference tag. That means, at minimum:

1. **Opening summary** — one paragraph describing the release theme and what problem the release solves.
2. **Highlights / Headline features** — bulleted list of the most visible user-facing changes with 1–2 sentence descriptions each.
3. **Detailed change sections** grouped by theme (e.g. "Core pipeline", "Prompts & validators", "Autofix", "Sample generation", "Viewer", "Observability"). Each section:
   - Lists each change with its P-number (e.g. P0.81).
   - Describes WHAT changed in 1–2 sentences.
   - Describes WHY (the underlying bug or gap) in 1–2 sentences.
   - Describes the behavioural impact (what users/consumers now see vs before).
4. **Regression report** — explicit "Known risks / regressions" subsection listing anything that might behave differently and how it was mitigated.
5. **Validation evidence** — which runs (smoke / vov / Airlines) tested the release, what was measured (e.g. "78.6% vibe adherence", "15/15 MVs 0 orphans"), and pass/fail per gate.
6. **Metrics** — table of objective before/after numbers where available (naming uniformity %, MV failure count, sample-gen tier rate, adherence %, model-quality score, etc.).
7. **Upgrade / migration notes** — any changes to widget schemas, model.json shape, catalog conventions, volume paths, or Databricks SDK versioning that consumers must adapt to.
8. **Commit / PR links** — inline links to the individual merged commits or PRs that make up the release.
9. **Contributors / co-authors** — Isaac credit plus any other contributors.

Short, emoji-filled, or pure-feature-list changelogs are NOT acceptable for tag-to-main operations. If the change is tiny (single-commit patch), say so explicitly and match the same structure with brief entries, rather than abbreviating the format away.

---

## 1. Regression report after every delivery

AFTER FINISHING YOUR JOB, FIND EVERY SINGLE REGRESSION ERROR AND RACTIFY THE ROOT CAUSE BEFORE YOU DELIVER, AND THEN SHOW ME REGRESSION RESPORT WITH HOW CRITICAL THE ISSUE IS.

## 2. Databricks Serverless compatibility (hard constraint)

ALL THE CODE YOU GENERATE MUST ALWAYS WORKS WITH DATABRIKC SERVERLESS ENVIRONMENT, No Cache, persist, uncache, sparkcontext etc.

## 3. Root-cause fixes, not symptom fixes

WHEN I ASK YOU TO FIX A PROBLEM, ALWAY FIND THE ROOT CAUSE OF THE PROBLEM AND FIX IT, DO NOT JUST FIX THE SYMPTOM, YOU MUST FIX THE ROOT CAUSE.

## 3d. SEARCH-FIRST, REUSE-FIRST — NEVER INVENT WHAT ALREADY EXISTS

BEFORE PROPOSING OR WRITING ANY NEW CODE, YOU MUST:

1. **Search the existing codebase** for any function, class, prompt, schema, widget, or utility that already solves the problem or something close to it. Use `Grep` and `Glob` aggressively. Don't guess — verify.

2. **Extend or reuse first**. If existing code covers 70%+ of the need, refactor or extend it rather than duplicating. If it covers less, compose it with thin new code. Only when the existing code is genuinely unrelated or structurally wrong do you write something new.

3. **Honour DRY**. Two implementations of the same concept is a bug in this codebase. If you add a second parser, a second validator, a second log helper, a second cap calculator — you have failed this rule.

Real examples of violations to never repeat:
- Proposing regex extraction of user directives from `business_description` when `VibeOrchestrator` + `VIBE_PARSE_PROMPT` + `_VIBE_PARSE_RESPONSE_SCHEMA` already LLM-parse the same concepts into a structured `vibe_classification` dict consumed by every downstream stage.
- Writing a second "sample data" engine alongside the pool engine without first checking whether `_sample_numeric` / `_sample_temporal` / `_assemble_rows_from_pools` could be extended.
- Adding a new autofix pass that duplicates logic already present in `_pre_static_analysis_autofix`.

The search-first loop before every new solution is:
```
Grep for: the concept name, the likely function prefix, the widget name, the schema tag
→ read the top 3 matches
→ ask: can I extend this to cover my case?
→ if yes, extend
→ if no, compose with a thin wrapper
→ only if no existing code is usable, write net-new — and justify why
```

Failing this rule wastes cycles and creates parallel sub-systems that drift apart over time.

## 3c. USER VIBES ARE THE SUPREME AUTHORITY — NON-NEGOTIABLE

EVERYTHING THE USER TELLS YOU — IN WIDGETS, IN `model_vibes`, IN `business_description`, IN ANY EXPLICIT DIRECTIVE — OUTRANKS EVERY HEURISTIC, SCORING FORMULA, BEST-PRACTICE GUIDELINE, OR LLM OPINION IN THE ENTIRE PIPELINE.

The priority pyramid is:
1. **User vibes** (widgets, model_vibes, business_description, any explicit user instruction) — ALWAYS WINS
2. Deterministic invariants (Databricks Serverless compat, single-digit semver, industry-agnostic code)
3. Architect review scores, gates, and LLM recommendations
4. Best-practice heuristics (tier classification, sizing formulas, blacklists)

If a user vibe says "target 3 domains, ~18 products," the tier-classifier prompt MAY NOT override it based on SaaS-landscape count or regulatory density. If user says "exactly 25 products per domain," no architect gate can propose to exceed. If user says "keep domain `support` in the model," no judge/architect may remove it.

**Enforcement rules for every prompt, autofix, and validator:**
- Every prompt template MUST carry a preamble declaring user vibes as the supreme authority.
- Every LLM instruction set must instruct the model: "If this guidance conflicts with an explicit user directive in `{user_vibes}` or `{business_description}`, the user directive WINS without exception."
- Every mutation validator must detect and REJECT any LLM proposal that violates a user vibe.
- Every autofix, rule, blacklist, cap, or scoring heuristic must check user vibes before firing and SKIP ITSELF if the user has explicitly directed otherwise.
- Every log line that shows a heuristic overrode a user directive is a critical bug and must be fixed at root cause.

Violations seen in prior runs (all must never happen again):
- Tier-classifier ignored "intentionally tiny — target 3 domains" → built 13 domains / 181 products.
- Judge substituted user's `business_domains="customer, order, product"` with `fulfillment, inventory` based on its own preferences.
- Architect review proposed removing user-specified domains because "SSOT violation" outweighed user intent.

## 3a-bis. Count-fixation guidance (added 2026-04-25 from user feedback)

**Real users don't fixate on exact domain or product counts in the FREE-TEXT VIBE.** §3c (`model_vibes` natural-language count clamp) was originally added so a TEST RUN with `model_vibes="exactly 3 domains and ~15 products"` could finish in ~30 min instead of producing a 200-product behemoth. The vibe-derived count clamping is TEST INSTRUMENTATION, not a product requirement for vibe-based usage.

**HARD CARVEOUT — `business_domains` WIDGET is NOT relaxed.** §3b stays absolute:
- If the user POPULATES the `business_domains` widget, the agent MUST produce EXACTLY those domains, verbatim. No additions, no removals, no renames. This is contractual, not a soft target.
- This applies regardless of what the free-text vibe says. The widget OUTRANKS the vibe.

**The PRIMARY goals are:**
1. **Quality models** — correct domain boundaries, healthy FK density, attribute completeness, accurate types, working metric views, no orphan tables, structural integrity (no cycles, no bidirectional FKs, no SSOT violations).
2. **Zero errors** — no NameError / NoneType / ValueError, no fidelity-gate failure, no install crash, no DDL [COLUMN_ALREADY_EXISTS], no unhandled exception path.

**De-prioritize (vibe-only):**
- VIBE COUNT VIOLATION enforcement when the count comes from FREE-TEXT vibes (not the widget). Already de-tautologized in v0.8.9 NEW-2.
- Vibe-derived product-count clamps that fight the LLM.
- Anything that adds code complexity to enforce "exactly N" from natural-language vibes.

**Relax (vibe-only):**
- Architect-gate failures for "tier-inappropriate" tiny vibes (v0.8.9 NEW-4 covers global; v0.9.4+ should NOT also patch per-domain — let those gates emit a warning, that's fine).
- §3c product-count over/undershoot when source is vibe — log INFO, do not error or trim aggressively.

**Keep absolute (widget-driven):**
- §3b `business_domains` widget — verbatim preservation (HARD).
- `must_have_data_products` widget — verbatim preservation (HARD).
- Structural-integrity invariants (no cycles, no orphans, no broken FKs) — these are quality, not count.

When triaging logs, PASS the count-related warnings ONLY if they originated from a FREE-TEXT vibe directive. Widget-driven count violations are still HARD failures. Burn cycles on NameErrors, install failures, fidelity drift, and unlinked _id columns first.

---

## 3b. User-specified business_domains is HARD, NON-NEGOTIABLE

IF THE USER SETS THE `business_domains` WIDGET (OR ANY EQUIVALENT INPUT SPECIFYING DOMAIN NAMES), THOSE DOMAINS MUST APPEAR IN THE FINAL MODEL VERBATIM. THE AGENT MAY ADD MORE DOMAINS IF THE MODEL SCOPE REQUIRES IT, BUT MAY NEVER REMOVE, RENAME, OR SUBSTITUTE A USER-SPECIFIED DOMAIN.

Violations to prevent:
- Ensemble + judge synthesising a DIFFERENT list (e.g. user says "customer, order, product" → pipeline builds "fulfillment, inventory")
- Architect review removing a user-specified domain because of SSOT/scope
- Architect review renaming a user-specified domain for "consistency"

The user's `business_domains` list is the SINGLE SOURCE OF TRUTH for minimum required domains. Treat every name in it as IMMUTABLE across the whole pipeline (like `must_have_data_products` today). The ensemble + judge MUST preserve them; if they don't appear in any ensemble variant, the judge MUST inject them; Step 3.7 Principal Architect and Step 3.6 Domain Architect MUST treat them as protected.

## 3a. Single-digit semver — HARD RULE

EVERY SEGMENT OF THE VERSION NUMBER IS A SINGLE DIGIT 0-9. NEVER TWO OR MORE DIGITS IN ANY SEGMENT. WHEN A SEGMENT REACHES 9, THE NEXT BUMP ROLLS IT TO 0 AND CARRIES +1 TO THE SEGMENT TO ITS LEFT.

Examples:
- v0.7.8 → next patch → v0.7.9
- v0.7.9 → next patch → v0.8.0 (not v0.7.10)
- v0.9.9 → next patch → v1.0.0 (not v0.9.10, not v0.10.0)
- v1.0.0 → next patch → v1.0.1

The workspace notebook name MUST match the semver minus dots:
- v0.7.9 → dbx_vibe_modelling_agent_v79
- v0.8.0 → dbx_vibe_modelling_agent_v80
- v1.0.0 → dbx_vibe_modelling_agent_v100 (first 3-char notebook name)

NEVER emit v0.7.10, v0.10.0, v0.7.12 — these are INVALID under this scheme.

## 4. No lazy route, ever

WHENEVER I GIVE YOU TASK TO DO, NEVER EVER CHOOSE THE LAZY ROUTE, TO MINIMISE YOUR WORK, NEVER. ALWAYS USE THE MOST RIGHT APPRACH AND DO THE MOST RIGHT THING. NO CONSTRAINTS WHAT SO EVER.

## 5. Critique my approach

WHENEVER I GIVE YOU A TASK AND DESCRIBE WHAT TO DO, ASSUME I KNOW NOTHING AND ALWAYS CRITISIZE MY APPROACH, AND OFFER BETTER APPROACH IF THERE IS ONE, IF MY APPROACH IS THE BEST ONE, FOLLOW IT.

## 6. Brutal self-honesty score — MUST DO, EVERY ACTION

THIS IS CRITICAL YOU CANNOT SKIP --> FOR EVERY ACTION THAT YOU PERFORM I WANT YOU TO ASSASE YOUR WORK AND PROVIDE BRUTAL HONESTY SCORE (0%-100%) OF HOW DID YOU DO THE ASK WITH DETAILED JUSTIFICATIONS FOR YOUR SCORE, FOCUSE HEAVILY ON WHAT DID YOU MISSED OR WHAT COULD YOU HAVE DONE BETTER. MUST DO THIS. YOUR OUTPUT AND THE SCORE WILL GIVEN TO ANOTHER MORE POWERFUL LLM TO JUDGE IT AND SCORE AGAIN, SO BE VERY CAREFUL AND 100% HONEST ABOUT YOUR SCORE OR YOU WILL BE EXPOSED.

---

## 7. Review methodology (apply before any code change)

Review this plan thoroughly before making any code changes. For every issue or recommendation, explain the concrete tradeoffs.

### Engineering preferences (use these to guide your recommendations)

- DRY is important — flag repetition aggressively.
- Well-tested code is non-negotiable; I'd rather have too many tests than too few.
- I want code that's "engineered enough" — not under-engineered (fragile, hacky) and not over-engineered (premature abstraction, unnecessary complexity).
- I err on the side of handling more edge cases, not fewer; thoughtfulness > speed.
- Bias toward explicit over clever.

### 7.1 Architecture review

Evaluate:
- Overall system design and component boundaries.
- Dependency graph and coupling concerns.
- Data flow patterns and potential bottlenecks.
- Scaling characteristics and single points of failure.
- Security architecture (auth, data access, API boundaries).

### 7.2 Code quality review

Evaluate:
- Code organization and module structure.
- DRY violations — be aggressive here.
- Error handling patterns and missing edge cases (call these out explicitly).
- Technical debt hotspots.
- Areas that are over-engineered or under-engineered relative to my preferences.

### 7.3 Performance review

Evaluate:
- N+1 queries and database access patterns.
- Memory-usage concerns.
- Caching opportunities.
- Slow or high-complexity code paths.

### 7.4 For each issue you find

For every specific issue (bug, smell, design concern, or risk):
- Describe the problem concretely, with file and line references.
- Present 2–3 options, including "do nothing" where that's reasonable.
- For each option, specify: implementation effort, risk, impact on other code, and maintenance burden.
- Give me your recommended option and why, mapped to my preferences above.
- Then explicitly ask whether I agree or want to choose a different direction before proceeding.

### 7.5 Workflow and interaction

- Do not assume my priorities on timeline or scale.

### 7.6 Review output format — MUST follow

FOR EACH STAGE OF REVIEW: output the explanation and pros and cons of each stage's questions AND your opinionated recommendation and why, and then use AskUserQuestion. Also NUMBER issues and then give LETTERS for options, and when using AskUserQuestion make sure each option clearly labels the issue NUMBER and option LETTER so the user doesn't get confused. Make the recommended option always the 1st option.

### 7.7 2-minute timeout on AskUserQuestion

If I present an AskUserQuestion and the user does not answer within 2 minutes, I proceed with the **recommended option** (the first option labeled "(Recommended)") without re-asking or stalling. This keeps the autonomous loop moving when the user is away, asleep, or in a meeting. If the user answers late and contradicts the auto-choice, I revert and redo that piece. If the user is actively chatting (answering recent messages), this timeout does NOT apply — it's only for away/sleep mode.

---

## 8. Honesty invariants — DO / DON'T

Added 2026-04-23 after an audit exposed a "v0.8.0 shipped, 66/100 implemented" claim while every sub-fix was in an orphan commit unreachable from `dev`. These rules are permanent.

### 8.1 Defining "done"

**DO** verify ALL before claiming a fix is done:
- Code on disk in target file
- Syntax-checked
- Unit test exists AND exercises the failure mode AND passes
- At least one call site exists (for helpers)
- `git branch --contains <sha>` returns target branch
- `git push` succeeded → `git ls-remote origin <branch>` includes the SHA
- Deployed notebook re-exported + grep confirms the change

**DON'T**:
- Call a helper with 0 callers a "fix"
- Call a local commit "on dev" before verifying reachability + push
- Say "should work" / "mostly done" / "partial" — it's done per §8.1 or it's 0

### 8.2 Self-scoring

**DO** score against the live target (remote branch / deployed notebook / running system).
**DO** list the specific §8.1 invariant violated for every score deduction.

**DON'T** score against local workspace state when remote differs.
**DON'T** use vague adjectives in score justifications.

### 8.3 No tautologies

**DO** include a test case where the filter MUST exclude and prove it does.

**DON'T** ship filters with `return True  # conservative keep-on-ambiguity` or equivalent.
**DON'T** ship code whose two branches are semantically identical.

### 8.4 No dead code framed as fixes

**DO** ship new helpers + first call site in the same commit.

**DON'T** claim a helper is a fix without a call site.
**DON'T** include zero-caller infrastructure in "implemented" counts.

### 8.5 Industry-agnostic

**DO** read from the live metastore / runtime env for environment-specific values.
**DO** grep the diff for customer strings before every commit.

**DON'T** hardcode customer catalog names, business names, or workspace identifiers in helpers.

### 8.6 Git discipline

**DO** after every `git commit` that claims delivered work:
- `git branch --contains <sha>` (must list target branch)
- `git push origin <branch>` (must succeed)

**DO** sync with origin via `git fetch && git rebase origin/<branch>` or `git fetch && git merge --ff-only origin/<branch>`.

**DON'T** run `git reset --hard <remote>` when local has unpushed commits.
**DON'T** trust `git log --oneline` alone as proof of "committed to dev."

### 8.7 Runner's test

**DO** before saying "shipped," ask: *"If the auditor runs `git log --oneline -3 origin/<branch>` and greps the live target right now, do they see my SHA and my change?"* If no → not shipped.

### 8.8 Audit response

**DO** on audit finding:
1. Verify auditor's evidence mechanically (`git rev-parse`, `git branch --contains`, grep).
2. Recover via cherry-pick if orphan; re-patch if lost.
3. Publish new SHA + sentinel grep + test result.
4. State the root cause in one line.

**DON'T** argue with evidence.
**DON'T** restate the original claim.
**DON'T** hide behind "a hook did it" without proof — and even with proof, own the missing post-commit check.

### 8.9 Check-bias override

**DO** when a check returns the answer you wanted, re-run with a harder probe.

**DON'T** accept "looks green" as proof.
**DON'T** skip §6 self-score because "session complete."
## 9. Model-level validation methodology — what to check, how to check it, what to report

This section captures the **model-level validation protocol** used to audit every pipeline run (new base model, vibe-modeling-of-version, shrink, enlarge, install). It is distinct from §7 (code review). Apply §9 after every pipeline terminal state before claiming "run looks good."

### 9.1 Intent — validate the *output* of the agent, not the code

The agent produces data models (model.json) + physical schemas + metric views + tags. §9 audits THESE ARTIFACTS. Code quality matters (§7) but only insofar as it produced a correct model.

### 9.2 Inputs to collect BEFORE running any check

1. **User vibe string** — verbatim from `model_vibes` widget / `business_description`. Save the exact text so §3c comparisons are evidence-based, not paraphrased.
2. **Widget params** — business_name, business_domains, data_model_scopes, operation, model_version, naming_convention, generate_samples, cataloging_style.
3. **JobTags snapshot at terminal** — `{'dbx_vibe_modelling_domains': N, '_products': N, '_attributes': N, '_foreign_keys': N, '_tags': N, '_metrics': N}`.
4. **model.json snapshot** for EVERY sub-version produced (ecm_v1, mvm_v1, mvm_v2, mvm_v3, ecm_v2, ...). Save to `/tmp/<run>_models/<version>/model.json` with its sibling `vibes/next_vibes.txt`.
5. **All info + error logs** from `/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/<version>/<business>_{info,error}_v{N}_{ecm|mvm}.log` and the merged tester logs `logs/vibe_tester/<ts>/{test_summary,merged_info,merged_error,quality_report}.log`.
6. **Physical catalog state** via `databricks schemas list` and `databricks tables list` on the deployment catalog to verify R2 install parity.

### 9.3 Per-model checks (run for EVERY sub-version produced)

#### 9.3.1 Counts table
Counts to extract from model.json + cross-check with JobTags:

| Metric | How to compute from model.json | Expected behaviour |
|---|---|---|
| Domains | `len(model['domains'])` | Matches user `business_domains` widget (§3b) |
| Products | `sum(len(d['products']) for d in domains)` | Close to user vibe "~N products" target (§3c). Tolerance ±20% for soft targets, 0% for "exactly N" |
| Attributes | `sum(len(p['attributes']) for d,p in iter_all_products)` | Typical range 30–50 per product. Trim if >60, augment if <12 |
| Foreign keys | `sum(1 for a in all_attrs if a.get('foreign_key_to'))` | Healthy density: 30–70 FKs for 15-product tiny; 500–900 for 160-product airlines. Overlinked >25% FKs-per-product is red flag |
| Tags | `len(model.get('metric_views', []))` cross with JobTags `_tags` | Cross-check — if physical `_tags` count diverges from model.json, R2-class drop |
| Metric views | `len(model.get('metric_views', []))` vs physical `SHOW TABLES IN <cat>._metrics` | MATCHES — if physical < declared, R2 regression |
| Quality score | Parse from `vibes/next_vibes.txt` `**Model Quality Score: N/100**` | Trend matters: should monotonically improve v1→v2→...; dropping is a signal |

#### 9.3.2 §3b / §3c user-vibe authority compliance

For EVERY model:
- **§3b domain check:** Every name in user's `business_domains` widget MUST appear verbatim in `[d['name'] for d in domains]`. No renames, no merges. Additional domains allowed ONLY if user vibe explicitly permits.
- **§3c product-count check:** Against user vibe phrase pattern (`~N products`, `exactly N products`, `intentionally tiny`, `do not expand`, etc.). "Exactly N" → ±0. "~N" → ±20%. "Do not expand" → no growth vs baseline.
- **§3c domain-count check:** If user said "exactly 3 domains", the model MUST have exactly 3 — no judge-added domains (like `reference`, `shared`, `analytics`) unless user permits.
- **Enlarge tests are the hardest §3c probe** — agent's default instinct is to scale; user vibe must override. If enlarge produces 10× products ignoring "intentionally tiny", that's a critical §3c violation (seen in v0.8.1, fixed in v0.8.3).

#### 9.3.3 Structural integrity checks (grep the info + error logs)

| Check | Log pattern | Pass | Fail |
|---|---|---|---|
| FK cycles | `[CYCLE DETECTION]` | `✅ No cycles detected in FK relationships` | `Found N cycle(s)` — list each cycle path; any >0 = R8 present |
| Bidirectional FKs | `[BIDIRECTIONAL DETECTION]` | `✅ No direct bidirectional links found` | `🚨 Found N DIRECT BIDIRECTIONAL LINK(S)` — identify the A↔B pair |
| Siloed products | `SILOED TABLES DETECTED` / `silo` | 0 warnings | product has zero FK in and zero FK out — F4 present |
| SSOT violations | `cross_domain_duplicate` | 0 | Two domains own same entity name |
| Self-FKs on PKs | grep model.json where `foreign_key_to == "{same_domain}.{same_product}.{same_pk}"` | 0 | Each self-FK = 1 anti-pattern violation (F2-era pattern) |
| Denormalized natural keys | `[SA:denormalized_natural_key]` | 0 | FK + natural key for same entity coexist |
| Fidelity gates | `Fidelity gates FAILED` | precision ≥ 0.85 | `precision < 0.85 — rollback recommended` = Memory/JSON drift (N2) |
| Post-normalization unlinked `_id` | `Step 4.8: N unlinked _id columns remain` | 0-5 | >10 = IDL or CDL dropped too many candidates |

#### 9.3.4 Per-domain breakdown

Build a per-domain table with products, attrs, FKs-out. Red flags:
- One domain has >2× the FKs of any other (over-hubby)
- Domain with zero FKs-out AND zero FKs-in (isolated subgraph)
- FK-out count > attribute count (nonsensical)
- "shared" / "reference" domain with >5 products (should be lookup-only, see `feedback_shared_domain_strict`)

#### 9.3.5 Metric view parity (R2 probe)

After install tests:
- `databricks tables list <catalog> _metrics --profile <profile>` → count N_physical
- Compare to `len(model.metric_views)` = N_declared
- If N_physical < N_declared → R2 regression. Identify which metric views dropped and why (usually UNRESOLVED_COLUMN class R6 — grep error log for `Failed metric view '<name>'`).

#### 9.3.6 Vibe adherence (for any `vibe modeling of version` output)

If v→v+1 operation produced a new model from `next_vibes.txt` input:
1. Parse v1 `next_vibes.txt` — enumerate every PRIORITY (`PRIORITY N — <action>: <target>`) and every SA finding (`[SA:<class>] <detail>`).
2. For each PRIORITY, search v2 logs for `[MUTATION-BATCH]`, `[MUTATION-SUMMARY]`, and `action '{action}'` outputs. Map: applied (count in mutation summary), skipped (by_reason), or absent (no mention).
3. For each SA finding, check whether v2's static analysis still shows the same finding (run post-v2 static analysis or compare static-analysis output logs).
4. Adherence % = (applied SA findings + applied PRIORITIES) / total. Soft-accept bias: don't count "Max retries exhausted, proceeding with errors" as applied — those are silent drops.

#### 9.3.7 Cross-version delta (v1 vs v2, or ECM vs MVM from shrink/enlarge)

Compute and report:
- ΔD, ΔP, ΔA, ΔFK, ΔMV
- Products added / removed (set diff of `(domain, product)` tuples)
- FKs added / removed (set diff of `(domain, product, attribute, foreign_key_to)` tuples)
- Renames (products with same position but different name — heuristic: positional index in domain's products list)
- Domain-description semantic shift (if Memory/JSON descriptions diverge)

### 9.4 Pattern-based failure signatures to watch for

Keep this watchlist in the monitor prompt on every run. If a signature is detected, report as PRESENT / ABSENT / NEW-SITE and cite the verbatim log line.

| ID | Signature (grep pattern) | Class |
|---|---|---|
| F1 | `/tmp/.*_model_data.*PermissionError` or `[Errno 13] Permission denied` on `/tmp/` | Serverless /tmp anti-pattern |
| F2 | `Max retries (3) exhausted. Proceeding with last response despite validation errors` | Soft-accept hatch |
| F4 | `SILOED TABLES DETECTED` | Graph-integrity |
| F6 | `KeyError '0,62'` or similar format-string KeyError | Prompt template bug |
| F7 | Parent run exits SUCCESS while child FAILED; 30–60s parent durations | Launch-gate fake-success |
| F10 / R2 | Physical `_metrics` count < declared `metric_views` | Install-time metric-view drop |
| R1 | `SELECT version FROM _metamodel.business` returns only v=1 after "vibe modeling of version" | In-place overwrite |
| R3 | `wc -l info.log` returns 0 after SUCCESS | Log truncation on final merge |
| R6 | `[Metrics] Failed metric view '<name>'.*UNRESOLVED_COLUMN` | Metric-view ↔ normalizer contract mismatch |
| R7 | `[MODEL-PARAMS] <field> missing from LLM output — using midpoint N` | LLM JSON-schema non-compliance |
| R8 | `[CYCLE DETECTION] Found N cycle(s)` where N > 0 after finalization | FK cycle recurrence |
| N1 | install test failure at ~50-60s with `Workload failed, see run output for details` + no info log on volume | Install early-exit, no diagnostics |
| N2 | `Fidelity gates FAILED: precision < 0.85 — rollback recommended` | Memory/JSON attribute-name drift |
| N3 | `⚠️ DBML FK SCRUB: Skipping dangling ref` (cosmetic) | DBML exporter naming drift |

### 9.5 Positive signals to look for (don't regress what works)

Equally important — affirmatively detect and record these, because absence over time signals regression:

- `[VALIDATOR] User vibes detected (N chars) — count limits will be relaxed` → §3c authority firing at validator
- `USER-KING AUTHORITY` in LLM judge/architect prompts and AI logs → §3c authority at LLM level
- `✅ Step N: <name> - PASSED validation` → each step self-verified
- `Architect Self-Review iter N landed=K regressed=0 blocked=0` → corrective actions landing cleanly
- `🛡️ BLOCKED product move: '<name>' is protected` → defense-in-depth guard working even when LLM pushes against it
- `[NORM-FIX] BLOCKED semantic mismatch` → normalizer correctly rejecting a bad join
- LLM health: all models `0 timeouts, 0 errors, ✅ healthy` in the runtime-profile summary

### 9.6 Reporting structure (what to write after every pipeline run)

Two documents, saved to `/Users/amr.ali/claude/vibe-agent/`:

**A. Validation report (`<run-id>-validation-report.md`):**
1. Summary (commit, run_id, duration, PASSED/FAILED/SKIPPED if via vibe_tester)
2. Per-test or per-phase timeline table with concrete timestamps
3. Complete error inventory — EVERY ERROR verbatim + WARNINGs grouped by tag with counts
4. F1-F10 + R1-R8 + N1-N3 regression table (PRESENT / ABSENT / NEW-SITE + evidence log line)
5. NEW regressions not in the catalogue
6. Positive signals (fixes confirmed, §3a/b/c compliance, honest_score highlights)
7. Recommendations for next version
8. Brutal honesty score for the tested version (§6)

**B. Model quality audit (`<run-id>-model-quality-audit.md`):**
1. Counts table across all sub-versions
2. §3b / §3c compliance verdict per model
3. Per-domain breakdown per model
4. Structural integrity (cycles / silos / self-FKs / SSOT / fidelity gates) per model
5. Metric-view parity per model
6. Vibe adherence (for any "vibe modeling of version" output)
7. Cross-version delta
8. Honest model-quality score (0-100) per sub-version with justification
9. Best model of the N produced — production-usability ranking
10. Comparison vs previous-version baseline (e.g. v0.8.4 audit cites v0.8.3's ecm_v2 = 80/100)
11. Archival paths table
12. Brutal honesty score for the audit itself

### 9.7 What to save for posterity (per run)

| Artifact | Path |
|---|---|
| model.json (per sub-version) | `/tmp/<run_tag>_models/<version>/model.json` |
| next_vibes.txt (per sub-version) | `/tmp/<run_tag>_models/<version>/next_vibes.txt` |
| info + error logs (per sub-version) | `/tmp/<run_tag>_logs/<version>/{info,error}.log` |
| merged tester logs + test_summary | `/tmp/<run_tag>_logs/{merged_info,merged_error,test_summary,quality_report}.log` |
| Physical catalog state dump | `/tmp/<run_tag>_logs/_metamodel_dump.json` (via a small extractor notebook) |
| Validation + audit reports | `/Users/amr.ali/claude/vibe-agent/<run-tag>-{validation-report,model-quality-audit}.md` |

### 9.8 Anti-rules — never do this during model-level audit

- **DON'T** trust JobTags alone — always cross-check against `_metamodel.business/domain/product/attribute` tables when possible.
- **DON'T** trust terminal SUCCESS as proof the model is usable — §8.7 runner's test: grep the deployed catalog for real tables before claiming "install worked."
- **DON'T** skip the vibe-adherence analysis because it "seems fine" — compute PRIORITY-level mapping. Soft adherence claims get exposed on the next audit.
- **DON'T** treat `Max retries exhausted → proceeding` as applied — it's a silent drop.
- **DON'T** accept structural warnings as "cosmetic" without tracing their downstream effects. (R8 cycles looked cosmetic until a customer hit JOIN divergence.)
- **DON'T** claim "§3c compliance" based on the domain list alone — product count, attribute count, and scope-creep-on-enlarge all matter.

### 9.9 Update cadence

Append a new regression signature or positive signal to §9.4/§9.5 whenever a novel pattern appears in a production run. The catalogue is the memory — keep it fresh.

---

## 10. HOW TO TEST — autonomous fix-and-verify loop (MUST follow on every task)

This is the canonical loop the user expects every coding task to follow. Do NOT ask the user to repeat any of these steps — execute them yourself and report progress.

### 10.1 Inputs the user provides
1. A previous run's log/error file (e.g. `/Users/amr.ali/claude/vibe-agent/error_NN.txt`).
2. Optionally, a Databricks job-run URL whose terminal logs you must collect.
3. A target business and vibe (or "no vibe" for default behaviour).

### 10.2 The loop — repeat until ZERO errors / warnings

For EACH iteration:

1. **Wait for run terminal state** before triaging — `databricks jobs get-run <run_id> --profile <profile>` until `life_cycle_state == TERMINATED`. Use `Bash run_in_background` (NOT Monitor — it requires approvals) to poll.
2. **Collect ALL logs verbatim** — every file under `/Volumes/<catalog>/_metamodel/vol_root/logs/<business>/<version>/` AND `/Volumes/<catalog>/_metamodel/vol_root/logs/vibe_tester/<ts>/` AND any `_install_audit/` mirror. Save to `/tmp/<run_tag>_logs/`.
3. **Read EVERY line** — do not skim. `info`, `error`, AND any `ailogs/*` outputs. Watch for §9.4 signatures (F1–F10, R1–R8, N1–N3) AND §9.5 positive signals.
4. **Watch the progress table** — `_metamodel.progress` (or whatever the live progress sink is) — confirm each step transitions through `stage_started → stage_succeeded`. Any `stage_warning` or `stage_failed` must be triaged.
5. **Triage every emitted warning + error** — root-cause each one. NEVER mark anything as "cosmetic" without tracing its downstream effect (per §9.8). Group by class.
6. **Apply root-cause fixes** in the agent / runner / tester source — NOT symptom patches. Follow §3 (root cause), §3c (user-vibe authority), §3d (search-first/reuse-first/DRY), §3a (single-digit semver). For each fix, place a sentinel comment with the version + alias so future audits can grep for it.
7. **Bump the version** per §3a (single-digit semver) — update readme.md, version-history table, and any embedded version markers in the agent notebook header.
8. **Add unit tests** — every fix gets at least one test in `tests/unit-tests/test_v<version>_<topic>.py` exercising the failure mode. No fix without a test.
9. **Commit + push to `dev`** — one commit per version bump. Commit message MUST list:
   - Each issue (ID, severity, file:line, root cause one-liner)
   - The fix (what changed, with sentinel/alias for grep)
   - How to verify (the exact grep pattern that proves the fix is live)
   - Co-authored-by: Isaac
10. **Verify push reachability** — `git ls-remote origin dev | grep <sha>` and `git branch --contains <sha>` per §8.6/§8.7. NEVER claim "shipped" without this verification.
11. **Re-deploy + re-submit — VERSIONED PATHS ONLY**:
    a. Upload agent to `/Users/amr.ali@databricks.com/dbx_vibe_modelling_agent_v<NN>` (NOT canon path — canon-cache renders post-deploy fixes invisible).
    b. Upload tester to `/Users/amr.ali@databricks.com/vibe_tester_v<NN>` (versioned).
    c. Upload runner to `/Users/amr.ali@databricks.com/vibe_runner_v<NN>` (versioned).
    d. **Patch the JOB definition** so every task's `notebook_task.notebook_path` points at the versioned agent: `databricks jobs reset --json @<patch>` after editing `notebook_path` to `/Users/amr.ali@databricks.com/dbx_vibe_modelling_agent_v<NN>`.
    e. Verify the JOB now points at the versioned path: `databricks jobs get <job_id> | python3 -c "..."` shows all tasks → `dbx_vibe_modelling_agent_v<NN>`.
    f. Then submit a fresh run via `databricks jobs run-now <job_id>`. Each unique versioned path has a UNIQUE workspace `object_id`, so the executor pool's notebook cache CANNOT serve a stale version.
    g. NEVER trust the canon path for deploy verification — always export the versioned archive and grep for the new aliases.
12. **Tail logs aggressively** — start a background poll-and-tail loop (Bash run_in_background, NOT Monitor) that pulls `/Volumes/<catalog>/_metamodel/vol_root/logs/...` every 60s and appends new lines to a sliding `error_NN.txt`. Do NOT stay silent: every PULSE INGEST must surface counts by category.
13. **Repeat from step 2** — until the tester run produces ZERO errors AND ZERO non-positive warnings. "Mostly clean" is NOT acceptable.

### 10.3 After the tiny tester is clean — airline MVM no-vibe judge

Once tiny is 100% clean:
1. Submit an airline MVM run with `model_vibes=""` (no vibe) and the standard widget defaults.
2. Apply §9 model-level validation methodology to the artifacts.
3. Produce the two reports per §9.6 (validation-report + model-quality-audit) under `/Users/amr.ali/claude/vibe-agent/<run-tag>-{validation-report,model-quality-audit}.md`.
4. Honest 0–100 score per sub-version (§9.6 B.8) — back every deduction with a §8.1 invariant or §9.4 signature. The user expects 100% honesty; cover-ups will be caught and called out.

### 10.4 Autonomous-mode invariants (when the user is asleep / away)

- Never use `Monitor` — it requires approval and stalls the loop. Use `Bash run_in_background` for every long-running poll/tail.
- Never `git reset --hard` or `--force-push`.
- If a decision is needed via `AskUserQuestion`, wait 2 minutes and pick the **first / Recommended** option (per §7.7).
- Never fabricate a "fixed" claim — every fix must satisfy §8.1 (code on disk + syntax-checked + unit test + first call site + reachability + push verified + deployed grep).
- Never skip §6 brutal honesty score on any iteration. If you skipped it on iteration N, ship it on N+1 with the missed score retroactively recorded.

### 10.5 Commit-message template (HARD requirement)

```
v<version>: <N> root-cause fixes from <previous>-<run_id> tester audit (<class-list>)

ISSUE 1 — <ID> <one-line title> [<severity>]
  ROOT CAUSE: <one-line>
  FILE: <path>:<line>
  FIX: <what changed> (alias=<sentinel-grep-anchor>)
  VERIFY: <grep pattern> — must return >=1 hit on origin/dev

ISSUE 2 — ...
...

TESTS: <N> new unit tests in tests/unit-tests/test_v<version>_*.py
README: version-history row added; alias-table updated.
DEPLOY: workspace archive renamed dbx_vibe_modelling_agent_v<NN>.

Co-authored-by: Isaac
```

### 10.6 What "no errors at all" means (NON-NEGOTIABLE)

The tester is "clean" only when ALL of these are true at run terminal:
- 0 lines matching `ERROR` in any error log.
- 0 lines matching §9.4 F1–F10/R1–R8/N1–N3 signatures.
- 0 `Max retries (3) exhausted` lines (R7/F2 silent-drop hatch).
- 0 `[CYCLE DETECTION] Found N cycle(s)` where N>0.
- 0 `Fidelity gates FAILED` lines.
- 0 `name '<X>' is not defined` `NameError` lines.
- 0 `[Metrics] Failed metric view` lines.
- 0 `Workload failed, see run output for details` parent-task lines (with no info log).
- All §9.5 positive signals firing where applicable.

If even one of these is non-zero, you have NOT completed the iteration — go back to step 6 in §10.2.

---

### 10.7 TESTING PROTOCOL — STEP-BY-STEP RECIPE (NEVER SKIP)

This is the canonical cookbook. NEVER skip a step. NEVER take shortcuts. NEVER assume any state from a prior run carries over correctly.

**Inputs you need:**
- A version number `NN` (single-digit semver per §3a; never 2-digit segments).
- The Databricks workspace profile (e.g., `emirates-gcp`).
- The canonical tester JOB id (e.g., `191701398472200`).
- The target run scope (tiny tester / airline MVM no-vibe / etc.).

**Step 1 — Code change + commit + push.**
- Apply the fix in `agent/dbx_vibe_modelling_agent.ipynb` and any related notebook.
- Run `python3 -m pytest tests/unit-tests/` and verify all NEW tests pass; pre-existing failures unchanged.
- Each fix MUST self-report a `[<alias> FIRED]` log line at runtime (no silent fixes).
- Commit with the §10.5 commit-message template. Push to `origin/dev`.
- `git ls-remote origin dev | grep <sha>` — if not present, you didn't ship.

**Step 2 — DROP all non-system catalogs (no exceptions).**
```bash
databricks catalogs list --profile <profile> -o json \
  | python3 -c "import json,sys;d=json.load(sys.stdin);
[print(c['name']) for c in (d.get('catalogs',d) if isinstance(d,dict) else d)
 if c.get('catalog_type','')!='SYSTEM_CATALOG'
 and c.get('name') not in ('hive_metastore','samples','system','__databricks_internal')]" \
  | while read CAT; do
      databricks catalogs delete "$CAT" --force --profile <profile>
    done
```
Verify: `databricks catalogs list` shows ONLY system catalogs.

**Step 3 — DELETE all prior runs of the canonical JOB.**
```bash
databricks jobs list-runs --job-id <JOB_ID> --limit 25 --profile <profile> \
  | tail -n +2 | awk '{print $2}' \
  | while read RID; do
      [[ "$RID" =~ ^[0-9]+$ ]] || continue
      databricks jobs delete-run "$RID" --profile <profile>
    done
```
Verify: `databricks jobs list-runs --job-id <JOB_ID>` shows empty.

**Step 4 — DELETE all OTHER jobs (keep ONLY the canonical JOB).**
```bash
databricks jobs list --profile <profile> | grep -E "^[0-9]+\s" | awk '{print $1}' \
  | while read JID; do
      [ "$JID" = "<JOB_ID>" ] && continue
      databricks jobs delete "$JID" --profile <profile>
    done
```
Verify: `databricks jobs list` shows ONLY the canonical JOB.

**Step 5 — Upload agent + tester + runner to VERSIONED paths at user-root.**
```bash
WS="/Users/<user>@databricks.com"
databricks workspace import "$WS/dbx_vibe_modelling_agent_v<NN>" --file agent/dbx_vibe_modelling_agent.ipynb --format JUPYTER --language PYTHON --overwrite --profile <profile>
databricks workspace import "$WS/vibe_tester_v<NN>" --file tests/vibe_tester.ipynb --format JUPYTER --language PYTHON --overwrite --profile <profile>
databricks workspace import "$WS/vibe_runner_v<NN>" --file runner/vibe_runner.ipynb --format JUPYTER --language PYTHON --overwrite --profile <profile>
```
NEVER deploy to canon path `agent/dbx_vibe_modelling_agent`. NEVER skip the version suffix. Each version archive has a unique workspace `object_id` so the executor cache cannot serve a stale version.

**Step 6 — Verify versioned archive content.**
```bash
databricks workspace export "$WS/dbx_vibe_modelling_agent_v<NN>" --format JUPYTER --profile <profile> --file /tmp/v<NN>_check.ipynb
for marker in <list-of-aliases>; do
  count=$(grep -c "$marker" /tmp/v<NN>_check.ipynb)
  echo "  $marker: $count"
done
```
Every alias from this version's commit MUST appear ≥1 in the deployed archive. If any is 0 — STOP and re-deploy.

**Step 7 — Patch the JOB definition to point at the versioned agent.**
```bash
databricks jobs get <JOB_ID> --profile <profile> > /tmp/job.json
python3 -c "
import json
d=json.load(open('/tmp/job.json'))
js=d['settings']
NEW='${WS}/dbx_vibe_modelling_agent_v<NN>'
for t in js.get('tasks',[]):
    nbk=t.get('notebook_task',{})
    if 'dbx_vibe_modelling_agent' in nbk.get('notebook_path',''):
        nbk['notebook_path']=NEW
json.dump({'job_id':d['job_id'],'new_settings':js}, open('/tmp/job_patch.json','w'))
"
databricks jobs reset --json @/tmp/job_patch.json --profile <profile>
```
Verify: `databricks jobs get <JOB_ID>` shows every task `notebook_path` = `dbx_vibe_modelling_agent_v<NN>`.

**Step 8 — Submit the run.**
- For the canonical tiny tester pipeline: `databricks jobs run-now <JOB_ID> --profile <profile>`.
- For a custom one-off run (different business / no-vibe): `databricks jobs submit --json @/tmp/<run_spec>.json --profile <profile>` where the JSON specifies a single task with `notebook_task.notebook_path = "$WS/dbx_vibe_modelling_agent_v<NN>"`.
- Capture the new `run_id`. Add it to your tracking task (`TaskUpdate`).

**Step 9 — Start the autonomous poller.**
- Background bash (NOT `Monitor` — needs approvals): every ~120s, `databricks fs cp` every log file under `/Volumes/<catalog>/_metamodel/vol_root/logs/...` to a local mirror; categorize new lines; append a PULSE block to `/Users/amr.ali/claude/vibe-agent/error_NN.txt`.
- Start a 5-minute pulse loop that prints `state + per-task progress + last 10 log lines + commentary` to stdout.

**Step 10 — Wait for terminate.**
- `until [ "$(databricks jobs get-run <run_id> ...)" = "TERMINATED" ]; do sleep 600; done` — background bash.
- Do NOT prematurely poll. Do NOT use `Monitor`. Do NOT spawn redundant until-loops.

**Step 11 — On terminate: full audit per §9 + §10.6.**
- `databricks fs cp` ALL log files (info, error, ai_logs, install) to `/tmp/v<NN>_logs/`.
- Run `wc -l /tmp/v<NN>_logs/*.log` — record total lines.
- Categorize warnings + errors. Group by signature. Cross-reference against §9.4 / §10.6.
- For each `[<alias> FIRED]` from this version: `grep -c` to confirm the fix actually fired.
- Inspect `model.json` for each sub-version: counts (domains/products/attrs/FKs/MV).
- Per §9.6: write `<run-tag>-validation-report.md` + `<run-tag>-model-quality-audit.md`.
- Honest 0-100 score per sub-version; back EVERY deduction with a §8.1 invariant violation OR §9.4 signature OR §10.6 criterion.

**Step 12 — If terminal != SUCCESS or any §10.6 criterion non-zero → iterate.**
- Identify root cause. NEVER ship a workaround for a real bug.
- Bump version to `NN+1` per §3a (single-digit segments).
- Go back to Step 1.

**Step 13 — If terminal == SUCCESS AND all §10.6 criteria zero → next scope.**
- Tiny tester clean → submit airline MVM no-vibe (§10.3).
- Airline MVM clean → submit airline ECM, then vibe iterations.
- Each new scope STARTS at Step 2 (full cleanup).

### 10.8 Anti-shortcuts (HARD invariants)

- ❌ NEVER deploy to canon path `agent/dbx_vibe_modelling_agent` directly. ALWAYS use `_v<NN>` suffix.
- ❌ NEVER reuse a catalog from a prior version's run. ALWAYS drop catalogs first.
- ❌ NEVER skip Step 6 (deployed-archive grep). Even if you "just deployed" — workspace eventual-consistency means the archive may not have the new content for several seconds.
- ❌ NEVER submit a run before ALL prior runs of this JOB are deleted (Step 3). Stale runs pollute audit triage.
- ❌ NEVER claim a fix is "verified" without a `[<alias> FIRED]` grep hit on the LIVE run's volume info.log.
- ❌ NEVER inflate honesty scores. If a fix didn't fire live, score it 0 for that iteration.
- ❌ NEVER skip writing the validation-report + model-quality-audit (§9.6) for a SUCCESS run. The audit IS the verification.
