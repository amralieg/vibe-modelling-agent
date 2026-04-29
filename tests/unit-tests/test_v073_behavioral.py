"""Behavioral tests for v0.7.3 — Vibe Audit Report stage + supporting helpers.

What this version ships (per CLAUDE.md §3d/§5/§7):
  1. Deterministic vibe-compliance SA extension via `_extend_sa_with_vibe_compliance`
     emitting 6 new categories: vibe_hard_count_violation, vibe_canonical_key_drift,
     vibe_ddl_column_dropped, vibe_ddl_type_drift, vibe_subdomain_dataset_gap,
     vibe_glossary_coverage_gap. These flow into next_vibes via the existing
     [SA:*] channel (added to _ACTIONABLE_CATEGORIES).

  2. New pipeline stage `step_generate_vibe_audit_report` slotted in run_track_1
     between SA + parallel artifact pool. Produces deterministic, generic,
     industry-agnostic audit reports as Markdown + JSON sidecar. Stashed in
     widgets_values["_vibe_audit_report_md"] for release notes consumption.

  3. New pipeline stage `step_install_parity_audit` on install path — physical
     vs declared parity check.

  4. `step_generate_release_notes` updated:
       - filename: releasenotes.txt → releasenotes.md
       - appends widgets_values["_vibe_audit_report_md"] when present
       - appends widgets_values["_install_parity_audit_md"] when present

  5. Per-VREQ scorecard rendered with weighted scoring:
       VREQ-A (subdomain coverage), VREQ-B (DDL preservation), VREQ-C (canonical keys),
       VREQ-E (HARD counts), VREQ-G (glossary), VREQ-Z (structural integrity).

Aliases under test:
  - vibe-audit-helpers-block
  - vibe-audit-actionable-extend
  - vibe-audit-stage-fn-defined
  - vibe-audit-stage-call
  - vibe-audit-sa-extend-call
  - release-notes-md-format
  - install-parity-audit-stage
  - install-parity-audit-call
  - vibe-compliance-sa-fired (runtime sentinel — emitted when stage actually runs)

Per Q6=6B: shipped on remodelling_dev as unreleased; __AGENT_VERSION__ stays "0.7.2"
until merge to main bumps it to "0.7.3".
"""

import ast
import json
import re
import textwrap
from pathlib import Path

AGENT = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _agent_cells():
    with AGENT.open() as f:
        nb = json.load(f)
    return nb.get("cells", [])


def _agent_source():
    cells = _agent_cells()
    parts = []
    for c in cells:
        if c.get("cell_type") != "code":
            continue
        src = c.get("source", [])
        if isinstance(src, list):
            parts.append("".join(src))
        else:
            parts.append(src or "")
    return "\n".join(parts)


def _extract_function_source(full_src, func_name):
    """Extract the source of a top-level function by name (handles nested defs by tracking indent)."""
    lines = full_src.split("\n")
    out = []
    in_def = False
    base_indent = 0
    for ln in lines:
        if not in_def:
            m = re.match(r"^(\s*)def\s+" + re.escape(func_name) + r"\s*\(", ln)
            if m:
                in_def = True
                base_indent = len(m.group(1))
                out.append(ln)
        else:
            stripped = ln.lstrip()
            indent = len(ln) - len(stripped)
            if stripped == "" or indent > base_indent:
                out.append(ln)
            else:
                # Function body ended
                break
    return "\n".join(out)


# ─────────────────────────────────────────────────────────────────────────────
# 1. Sentinel grep — verify code on disk
# ─────────────────────────────────────────────────────────────────────────────


def test_v073_helpers_block_present():
    src = _agent_source()
    assert "[vibe-audit-helpers-block FIRED alias=vibe-audit-helpers-block]" in src, (
        "v0.7.3 vibe-audit helpers block sentinel must be present in the agent notebook"
    )


def test_v073_actionable_categories_extended():
    src = _agent_source()
    assert "[vibe-audit-actionable-extend FIRED alias=vibe-audit-actionable-extend]" in src
    for cat in [
        "'vibe_hard_count_violation'",
        "'vibe_canonical_key_drift'",
        "'vibe_ddl_column_dropped'",
        "'vibe_ddl_type_drift'",
        "'vibe_subdomain_dataset_gap'",
        "'vibe_glossary_coverage_gap'",
    ]:
        assert cat in src, f"_ACTIONABLE_CATEGORIES must contain {cat}"


def test_v073_audit_stage_function_defined():
    src = _agent_source()
    assert "[vibe-audit-stage-fn-defined FIRED alias=vibe-audit-stage-fn-defined]" in src
    assert "def step_generate_vibe_audit_report(widgets_values):" in src


def test_v073_audit_stage_called_in_track1():
    src = _agent_source()
    assert "[vibe-audit-stage-call FIRED alias=vibe-audit-stage-call]" in src
    assert "step_generate_vibe_audit_report(widgets_values)" in src


def test_v073_sa_extension_called_in_capture_invariants():
    src = _agent_source()
    assert "[vibe-audit-sa-extend-call FIRED alias=vibe-audit-sa-extend-call]" in src
    assert "_extend_sa_with_vibe_compliance(" in src


def test_v073_release_notes_md_format():
    src = _agent_source()
    assert "[release-notes-md-format FIRED alias=release-notes-md-format]" in src
    # Must use .md path
    assert "/docs/releasenotes.md" in src
    # Old .txt path must be fully replaced (not co-existing)
    assert src.count("/docs/releasenotes.txt") == 0, (
        "All releasenotes.txt references must be replaced with .md"
    )


def test_v073_release_notes_appends_audit_md():
    src = _agent_source()
    # Must read the stashed audit + parity markdown
    assert "_vibe_audit_report_md" in src
    assert "_install_parity_audit_md" in src


def test_v073_install_parity_audit_stage_defined():
    src = _agent_source()
    assert "[install-parity-audit-stage FIRED alias=install-parity-audit-stage]" in src
    assert "def step_install_parity_audit(widgets_values):" in src


def test_v073_install_parity_audit_called_in_deploy():
    src = _agent_source()
    assert "[install-parity-audit-call FIRED alias=install-parity-audit-call]" in src
    assert "step_install_parity_audit(widgets_values)" in src


def test_v073_progress_table_uses_canonical_lifecycle():
    """Stage emit_step calls must use 'stage_started' → 'stage_succeeded' lifecycle
    (and 'stage_warning' on failure), per VibeWriter._VALID_STATUSES."""
    src = _agent_source()
    # Both new stages should emit started + succeeded
    for stage_name in ('"Vibe Audit Report"', '"Install Parity Audit"'):
        # stage_started
        m_started = re.search(
            r'stage_name=' + re.escape(stage_name) + r'.*?status="stage_started"',
            src, re.DOTALL,
        )
        assert m_started, f"{stage_name} must emit stage_started"
        # stage_succeeded
        m_succ = re.search(
            r'stage_name=' + re.escape(stage_name) + r'.*?status="stage_succeeded"',
            src, re.DOTALL,
        )
        assert m_succ, f"{stage_name} must emit stage_succeeded"


# ─────────────────────────────────────────────────────────────────────────────
# 2. Deterministic helpers — pure-Python tests (extract from notebook + exec)
# ─────────────────────────────────────────────────────────────────────────────


def _load_helper_namespace():
    """Extract the 6 vibe-audit helpers from the notebook and exec them in an isolated ns."""
    src = _agent_source()
    helper_names = [
        "_vibe_audit_extract_ddl_blocks",
        "_vibe_audit_extract_glossary_table",
        "_vibe_audit_extract_hard_counts",
        "_vibe_audit_extract_canonical_keys",
        "_vibe_audit_extract_subdomain_hints",
        "_vibe_audit_walk_model",
        "_extend_sa_with_vibe_compliance",
        "_vibe_audit_compute_per_domain_breakdown",
        "_vibe_audit_score_vreq",
        "_build_vibe_audit_report_json",
        "_render_vibe_audit_report_md",
    ]
    ns = {"json": json, "__AGENT_VERSION__": "0.7.2"}
    blob = []
    for name in helper_names:
        fn_src = _extract_function_source(src, name)
        assert fn_src, f"could not extract {name} from notebook"
        blob.append(textwrap.dedent(fn_src))
    exec("\n\n".join(blob), ns)
    for name in helper_names:
        assert name in ns, f"{name} did not load into namespace"
    return ns


def test_v073_extract_ddl_blocks_generic():
    """DDL extraction must be industry-agnostic — works for retail, healthcare, finance."""
    ns = _load_helper_namespace()
    extract = ns["_vibe_audit_extract_ddl_blocks"]
    # Retail
    text_retail = """
    CREATE TABLE retail.silver.product (
        sku STRING,
        name STRING,
        price DECIMAL(10,2),
        category_id BIGINT,
        created_at TIMESTAMP
    )
    """
    blocks = extract(text_retail)
    assert len(blocks) == 1
    assert blocks[0]["table"] == "product"
    cols = dict(blocks[0]["columns"])
    assert cols["sku"] == "STRING"
    assert cols["price"] == "DECIMAL(10,2)"
    assert cols["category_id"] == "BIGINT"
    # Healthcare
    text_hc = """
    CREATE MATERIALIZED VIEW hc.silver.encounter (
        encounter_id BIGINT,
        patient_id BIGINT,
        diagnosis_code STRING,
        admission_date DATE
    )
    """
    blocks_hc = extract(text_hc)
    assert len(blocks_hc) == 1
    assert blocks_hc[0]["table"] == "encounter"
    assert ("encounter_id", "BIGINT") in blocks_hc[0]["columns"]
    # No DDL → empty
    assert extract("just a free-text vibe with no DDL") == []
    assert extract("") == []
    assert extract(None) == []


def test_v073_extract_hard_counts_detects_exactly_and_hard_qualifier():
    ns = _load_helper_namespace()
    extract = ns["_vibe_audit_extract_hard_counts"]
    # EXACTLY THREE (HARD) — generic any noun
    text = "We need EXACTLY THREE metric views (HARD). Add at most 5 domains."
    out = extract(text)
    assert "metric_views" in out
    assert out["metric_views"]["count"] == 3
    assert out["metric_views"]["qualifier"] == "exactly_hard"
    # Numeric variants
    out2 = extract("Build exactly 5 domains for this run")
    assert "domains" in out2
    assert out2["domains"]["count"] == 5
    # No HARD qualifier → exactly_soft
    assert out2["domains"]["qualifier"] in ("exactly_soft", "exactly_hard")
    # Empty / negative
    assert extract("") == {}
    assert extract("just some free text without counts") == {}


def test_v073_extract_canonical_keys_handles_multiple_phrasings():
    ns = _load_helper_namespace()
    extract = ns["_vibe_audit_extract_canonical_keys"]
    # Multiple phrasing patterns
    text = "Canonical keys are: customer_id, order_id, product_sku"
    keys = extract(text)
    assert "customer_id" in keys and "order_id" in keys and "product_sku" in keys
    # 'a == b' aliasing
    text2 = "keys: employee_id, position_number, job_id == job_code_object_id"
    keys2 = extract(text2)
    assert "employee_id" in keys2
    assert "job_id" in keys2
    assert "job_code_object_id" in keys2
    # Empty
    assert extract("") == []


def test_v073_extract_subdomain_hints_widget_first():
    """business_domains widget OUTRANKS vibe text per CLAUDE.md §3b."""
    ns = _load_helper_namespace()
    extract = ns["_vibe_audit_extract_subdomain_hints"]
    widgets = {"business_domains": "Customer, Order, Product"}
    hints = extract("## Some Header\n## Another Header", widgets)
    # Widget hints come FIRST and override
    idents = [h[0] for h in hints]
    assert "customer" in idents
    assert "order" in idents
    assert "product" in idents


def test_v073_walk_model_counts_correct():
    ns = _load_helper_namespace()
    walk = ns["_vibe_audit_walk_model"]
    domains = [{"domain": "customer"}, {"domain": "order"}]
    products = [
        {"domain": "customer", "product": "person"},
        {"domain": "order", "product": "order_header"},
    ]
    attributes = [
        {"domain": "customer", "product": "person", "attribute": "person_id", "tags": "primary_key"},
        {"domain": "customer", "product": "person", "attribute": "name", "data_type": "STRING"},
        {"domain": "order", "product": "order_header", "attribute": "order_id", "tags": "primary_key"},
        {"domain": "order", "product": "order_header", "attribute": "person_id",
         "foreign_key_to": "customer.person.person_id"},
    ]
    walked = walk(domains, products, attributes)
    assert walked["model_stats"]["n_domains"] == 2
    assert walked["model_stats"]["n_products"] == 2
    assert walked["model_stats"]["n_attributes"] == 4
    assert walked["model_stats"]["n_fks"] == 1
    assert "customer.person" in walked["fk_targets_set"]


def test_v073_extend_sa_emits_hard_count_violation_when_exceeded():
    """When user vibe says 'EXACTLY THREE metric views (HARD)' and model has 5 → must emit."""
    ns = _load_helper_namespace()
    extend = ns["_extend_sa_with_vibe_compliance"]

    class _Logger:
        def info(self, *a, **k): pass
        def warning(self, *a, **k): pass

    sa_result = {"issues": [], "severity_counts": {"error": 0, "warning": 0, "info": 0}, "summary_by_category": {}}
    widgets = {
        "vibe_modelling_instructions": "We need EXACTLY THREE metric views (HARD).",
        "metric_view_count": 5,
    }
    extend(sa_result, widgets, [], [], [], {}, _Logger())
    cats = [i["category"] for i in sa_result["issues"]]
    assert "vibe_hard_count_violation" in cats
    found = next(i for i in sa_result["issues"] if i["category"] == "vibe_hard_count_violation")
    assert found["details"]["expected"] == 3
    assert found["details"]["actual"] == 5


def test_v073_extend_sa_emits_canonical_key_drift_when_missing():
    ns = _load_helper_namespace()
    extend = ns["_extend_sa_with_vibe_compliance"]

    class _Logger:
        def info(self, *a, **k): pass
        def warning(self, *a, **k): pass

    sa_result = {"issues": [], "severity_counts": {"error": 0, "warning": 0, "info": 0}, "summary_by_category": {}}
    # User says 'employee_number' is canonical, but model uses 'employee_id'
    widgets = {
        "vibe_modelling_instructions": "Canonical keys are: employee_number, position_id",
    }
    domains = [{"domain": "hr"}]
    products = [{"domain": "hr", "product": "person"}]
    attributes = [
        {"domain": "hr", "product": "person", "attribute": "employee_id", "tags": "primary_key"},
        {"domain": "hr", "product": "person", "attribute": "position_id",
         "tags": "primary_key"},  # position_id IS used as PK → no drift for it
    ]
    extend(sa_result, widgets, domains, products, attributes, {}, _Logger())
    drift_issues = [i for i in sa_result["issues"] if i["category"] == "vibe_canonical_key_drift"]
    drift_keys = [i["details"]["canonical_key"] for i in drift_issues]
    assert "employee_number" in drift_keys
    assert "position_id" not in drift_keys  # this one IS used as PK


def test_v073_extend_sa_skip_when_no_vibe_text():
    """If no vibe and no business_domains widget → skip cleanly (no issues added)."""
    ns = _load_helper_namespace()
    extend = ns["_extend_sa_with_vibe_compliance"]

    class _Logger:
        def info(self, *a, **k): pass
        def warning(self, *a, **k): pass

    sa_result = {"issues": [], "severity_counts": {"error": 0, "warning": 0, "info": 0}, "summary_by_category": {}}
    widgets = {"vibe_modelling_instructions": "", "business_domains": ""}
    extend(sa_result, widgets, [], [], [], {}, _Logger())
    # No vibe-* categories should be added
    vibe_cats = [i for i in sa_result["issues"] if (i.get("category") or "").startswith("vibe_")]
    assert len(vibe_cats) == 0


def test_v073_render_audit_report_includes_required_sections():
    """The rendered Markdown report must contain all canonical sections."""
    ns = _load_helper_namespace()
    render = ns["_render_vibe_audit_report_md"]
    fake_report = {
        "agent_version": "0.7.2",
        "business": "acme",
        "operation": "new base model",
        "version": "1",
        "model_scope": "mvm",
        "verdict": "MEETS MOST OF USER VIBE (production-deployable as v1)",
        "overall_score": 87.5,
        "scorecard": {
            "vibe_subdomain_dataset_gap": {"label": "VREQ-A", "score_pct": 100, "weight": 15, "n_issues": 0, "weighted": 15.0},
            "structural_integrity":       {"label": "VREQ-Z", "score_pct": 92,  "weight": 25, "n_issues": 1, "weighted": 23.0},
        },
        "model_stats": {"n_domains": 3, "n_products": 12, "n_attributes": 145, "n_fks": 38, "n_metric_views": 4},
        "per_domain_breakdown": {"customer": {"n_products": 4, "n_attributes": 50, "n_fks_in": 5, "n_fks_out": 3}},
        "vibe_extracted_requirements": {
            "ddl_block_count": 2, "ddl_total_columns": 24, "glossary_term_count": 5,
            "hard_counts": {"metric_views": {"count": 3, "qualifier": "exactly_hard", "verbatim": "EXACTLY THREE metric views"}},
            "canonical_keys": ["customer_id", "order_id"],
            "subdomain_hints": [("customer", "Customer"), ("order", "Order")],
        },
        "violations": [
            {"severity": "warning", "category": "vibe_hard_count_violation",
             "message": "User vibe declared HARD count: 'EXACTLY THREE metric views' but model has 4",
             "details": {"expected": 3, "actual": 4},
             "remediation_actions": ["trim_to_count"]},
        ],
        "structural_findings_count": 1,
    }
    md = render(fake_report)
    # Required sections
    assert "# Vibe Audit Report" in md
    assert "## Verdict" in md
    assert "## Per-Requirement Scorecard" in md
    assert "## Model Statistics" in md
    assert "## Per-Domain Breakdown" in md
    assert "## Vibe-Extracted Requirements" in md
    assert "## Violations" in md
    assert "## Brutal-honesty note" in md
    # Specific values
    assert "87.5" in md
    assert "MEETS MOST OF USER VIBE" in md
    assert "vibe_hard_count_violation" in md
    assert "EXACTLY THREE metric views" in md  # verbatim
    assert "customer_id" in md  # canonical key shown
    assert "Customer" in md  # subdomain hint label


def test_v073_score_vreq_weighting():
    """Score must deduct: error=-25, warning=-10, info=-3 per finding, capped at 0."""
    ns = _load_helper_namespace()
    score = ns["_vibe_audit_score_vreq"]
    assert score("x", {"error": 0, "warning": 0, "info": 0}, 0) == 100
    assert score("x", {"error": 0, "warning": 1, "info": 0}, 1) == 90
    assert score("x", {"error": 0, "warning": 5, "info": 0}, 5) == 50
    assert score("x", {"error": 1, "warning": 0, "info": 0}, 1) == 75
    assert score("x", {"error": 0, "warning": 0, "info": 5}, 5) == 85
    # Capped at 0
    assert score("x", {"error": 10, "warning": 10, "info": 10}, 30) == 0


def test_v073_extract_glossary_table_pipe_format():
    """Pipe-table glossary parsing — works for any business glossary header style."""
    ns = _load_helper_namespace()
    extract = ns["_vibe_audit_extract_glossary_table"]
    text = """
    Some preamble text.

    | Glossary Term | Business Data Element | Definition |
    |---|---|---|
    | CDE-1 | Customer ID | Unique identifier for a customer entity |
    | CDE-2 | Order Total Value | Monetary sum of all line items in an order |
    | CDE-3 | Product SKU | Stock keeping unit code for a product |

    Some text after.
    """
    entries = extract(text)
    names = [e["name"] for e in entries]
    assert "Customer ID" in names
    assert "Order Total Value" in names
    assert "Product SKU" in names
    # Definitions captured
    cust_def = next(e for e in entries if e["name"] == "Customer ID")["definition"]
    assert "identifier" in cust_def.lower()


def test_v073_full_pipeline_smoke():
    """End-to-end: extract → extend SA → render report — generic vibe."""
    ns = _load_helper_namespace()
    extract_ddl = ns["_vibe_audit_extract_ddl_blocks"]
    extract_hc = ns["_vibe_audit_extract_hard_counts"]
    extract_ck = ns["_vibe_audit_extract_canonical_keys"]
    walk = ns["_vibe_audit_walk_model"]
    extend = ns["_extend_sa_with_vibe_compliance"]
    build_json = ns["_build_vibe_audit_report_json"]
    render = ns["_render_vibe_audit_report_md"]

    class _Logger:
        def info(self, *a, **k): pass
        def warning(self, *a, **k): pass

    vibe = """
    # Customer Analytics Project

    DDL:
    CREATE TABLE silver.customer (
        customer_id BIGINT,
        email STRING,
        signup_date DATE
    )

    Subdomains:
    - Customer
    - Order

    Canonical keys: customer_id, order_id

    Build EXACTLY THREE metric views (HARD).
    """
    widgets = {
        "vibe_modelling_instructions": vibe,
        "metric_view_count": 5,  # violates HARD count
        "current_version": "1",
        "operation": "new base model",
        "model_scope": "mvm",
        "business_domains": "Customer, Order",
    }
    domains = [{"domain": "customer"}, {"domain": "order"}]
    products = [
        {"domain": "customer", "product": "customer"},
        {"domain": "order", "product": "order"},
    ]
    attributes = [
        {"domain": "customer", "product": "customer", "attribute": "customer_id", "tags": "primary_key", "data_type": "BIGINT"},
        {"domain": "customer", "product": "customer", "attribute": "email", "data_type": "STRING"},
        {"domain": "order", "product": "order", "attribute": "order_id", "tags": "primary_key", "data_type": "BIGINT"},
        {"domain": "order", "product": "order", "attribute": "customer_id",
         "foreign_key_to": "customer.customer.customer_id", "data_type": "BIGINT"},
    ]
    sa_result = {"issues": [], "severity_counts": {"error": 0, "warning": 0, "info": 0}, "summary_by_category": {}}
    extend(sa_result, widgets, domains, products, attributes, {"business_name": "acme"}, _Logger())
    # HARD count violation expected
    assert any(i["category"] == "vibe_hard_count_violation" for i in sa_result["issues"])
    # Build report
    extracted = {
        "ddl_block_count": len(extract_ddl(vibe)),
        "ddl_total_columns": sum(len(b["columns"]) for b in extract_ddl(vibe)),
        "glossary_term_count": 0,
        "hard_counts": extract_hc(vibe),
        "canonical_keys": extract_ck(vibe),
        "subdomain_hints": [("customer", "Customer"), ("order", "Order")],
    }
    rj = build_json(widgets, sa_result, extracted, domains, products, attributes, {"business_name": "acme"})
    assert rj["overall_score"] >= 0
    assert rj["overall_score"] <= 100
    assert "scorecard" in rj
    assert any(v["category"] == "vibe_hard_count_violation" for v in rj["violations"])
    md = render(rj)
    assert "# Vibe Audit Report" in md
    assert "vibe_hard_count_violation" in md
