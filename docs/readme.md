# Vibe Modelling Agent — Documentation

> Index of reference docs for the Vibe Modelling Agent. Start with the Whitepaper if you want the philosophy, the Design Guide if you want the internals, or the Integration Guide if you are building a UI or downstream consumer.

[← Back to project root](../readme.md)

---

## Table of Contents

- [Reference Documents](#reference-documents)
- [Where to Start](#where-to-start)
- [Related Guides](#related-guides)

---

## Reference Documents

| Document | Purpose |
|:---|:---|
| [whitepaper.md](whitepaper.md) | Philosophy, methodology, and the complete data modeling rules catalog (G01–G12, SUB). |
| [design-guide.md](design-guide.md) | Technical design reference — architecture, 19 pipeline stages (including Step 3.6 per-domain Domain Architect Review and Step 3.7 global Architect Review), LLM ensemble, sizing, widgets, artifacts, and error-handling patterns. |
| [integration-guide.md](integration-guide.md) | Producer-consumer protocol for UIs and downstream consumers — handshake, progress events, `result_json` schemas, and SQL quick reference. |
| [quality-gates.md](quality-gates.md) | Every quality gate at every stage — what each gate asserts, the yes/no questions it asks, failure modes, and a per-run count of enforced checks. Also carries the **v0.6.x → v0.7.x fix roll-up affecting gates** table (P0.11, P0.20, P0.43, P0.52, P0.55, P0.67, P0.70 REVERT, P0.96, P0.99+PE12, P0.105+M6, …). Start here to build confidence in a specific generated model. |

---

## Where to Start

| If you want to… | Read |
|:---|:---|
| Understand **why** Vibe Modelling exists and how the methodology works | [whitepaper.md](whitepaper.md) |
| Understand **how the agent works internally** — stages, LLMs, governance rules | [design-guide.md](design-guide.md) |
| **Build a UI or consumer** that observes the agent end-to-end | [integration-guide.md](integration-guide.md) |
| Understand **what a generated model has passed** before you trust it | [quality-gates.md](quality-gates.md) |
| See the **rules catalog** the agent enforces (G01–G12, SUB, semantic distinction) | [whitepaper.md § Appendix](whitepaper.md#appendix-data-modeling-rules-catalog) |

---

## Related Guides

| Location | Purpose |
|:---|:---|
| [../readme.md](../readme.md) | Project overview, quick start, widgets, and end-to-end architecture |
| [../runner/readme.md](../runner/readme.md) | Multi-industry pipeline orchestrator (batch ECM + MVM generation) |
| [../tests/readme.md](../tests/readme.md) | End-to-end integration test suite |
| [../models/manufacturing/readme.md](../models/manufacturing/readme.md) | Sample generated model (MVM vs ECM overview) |

---

[← Back to project root](../readme.md)
