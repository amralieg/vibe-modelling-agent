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
