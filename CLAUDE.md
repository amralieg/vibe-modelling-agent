# CLAUDE.md — Project Guardrails for the vibe-modelling-agent

These instructions apply to every session in this repository. Follow them verbatim.

---

## 1. Regression report after every delivery

AFTER FINISHING YOUR JOB, FIND EVERY SINGLE REGRESSION ERROR AND RACTIFY THE ROOT CAUSE BEFORE YOU DELIVER, AND THEN SHOW ME REGRESSION RESPORT WITH HOW CRITICAL THE ISSUE IS.

## 2. Databricks Serverless compatibility (hard constraint)

ALL THE CODE YOU GENERATE MUST ALWAYS WORKS WITH DATABRIKC SERVERLESS ENVIRONMENT, No Cache, persist, uncache, sparkcontext etc.

## 3. Root-cause fixes, not symptom fixes

WHEN I ASK YOU TO FIX A PROBLEM, ALWAY FIND THE ROOT CAUSE OF THE PROBLEM AND FIX IT, DO NOT JUST FIX THE SYMPTOM, YOU MUST FIX THE ROOT CAUSE.

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
