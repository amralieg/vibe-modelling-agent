"""
v3.8.5 behavioral test for the verifier-blindness fix (alias=verifier-after-state-inventory).

ROOT CAUSE (gov_transport v3.8.4 audit, VREQ-011/012/013/014/015/016 false-fails): VibeOrchestrator.audit_all
built the unified-audit after_state from ONLY domain+product names (both truncated). The LLM verifier
therefore could not SEE the applied attributes/tags/subdomains/stewards/PKs/metric-views and false-FAILED
every metadata VREQ on a model that physically carried them (the same "lying scoreboard" class as the
v3.3.2 per-VREQ snapshot fix, but on the audit_all path).

FIX: a new method _v385_after_state_inventory_lines builds authoritative, untruncatable inventory lines
(subdomain/steward/pk per product, attribute TAG INVENTORY, is_primary_key PRIMARY-KEY FLAGS,
METRIC-VIEW INVENTORY, CATALOG); audit_all appends them to after_state.

fail-pre/pass-post:
  - test_method_emits_all_inventories: pre-patch the method does not exist (loader returns None) -> fail.
  - test_tag_inventory_counts: glossary/source_attr tag-keys surface with counts.
  - test_audit_all_wires_inventory: the call site + FIRED alias exist in audit_all (no dead code, sec.8.4).
"""
import json
import os
import textwrap
import types

REPO = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")


def _nb_code():
    nb = json.load(open(NB))
    return "\n".join("".join(c.get("source", [])) for c in nb["cells"] if c["cell_type"] == "code")


def _load_inventory_fn():
    """Extract the method body and expose it as a standalone fn taking an explicit `self`."""
    src = _nb_code()
    i = src.find("    def _v385_after_state_inventory_lines(self, ")
    if i == -1:
        return None
    j = src.find("\n    def ", i + 1)
    end = j if j != -1 else len(src)
    body = textwrap.dedent(src[i:end])
    ns = {}
    exec(compile(body, "<inventory>", "exec"), ns)
    return ns.get("_v385_after_state_inventory_lines")


def _fake_self(metric_views=None, statements=None, catalog="vibe_gov_transport_basemvm"):
    wv = {}
    if metric_views is not None:
        wv["metric_views"] = metric_views
    if statements is not None:
        wv["metric_view_statements"] = statements
    if catalog:
        wv["deployment_catalog"] = catalog
    return types.SimpleNamespace(widgets_values=wv, catalog=catalog)


def _model():
    domains = [{"domain": "hr"}, {"domain": "project"}]
    products = [
        {"domain": "hr", "product": "employee", "subdomain": "Employee Records",
         "steward": "HR Data Office", "primary_key": "employee_id"},
        {"domain": "hr", "product": "applicant", "subdomain": "Recruitment & Onboarding",
         "steward": "Talent Acquisition", "primary_key": "applicant_id"},
    ]
    attributes = [
        {"domain": "hr", "product": "employee", "attribute": "employee_id",
         "is_primary_key": True, "tags": "primary_key,gov_transport_business_glossary_term=Employee Identifier"},
        {"domain": "hr", "product": "employee", "attribute": "hire_date",
         "is_primary_key": False, "tags": "gov_transport_business_glossary_term=Hire Date,gov_transport_source_attribute=hire_dt"},
        {"domain": "hr", "product": "applicant", "attribute": "applicant_id",
         "is_primary_key": True, "tags": "primary_key,gov_transport_source_attribute=appl_id"},
    ]
    return domains, products, attributes


def test_method_emits_all_inventories():
    fn = _load_inventory_fn()
    assert fn is not None, "PRE-PATCH: _v385_after_state_inventory_lines missing (expected fail before fix)"
    domains, products, attributes = _model()
    mvs = [{"name": "hr_vacancy_rate"}, {"name": "hr_turnover_rate"}, {"name": "hr_headcount"}]
    lines = fn(_fake_self(metric_views=mvs), domains, products, attributes)
    blob = "\n".join(lines)
    assert "SUBDOMAIN/STEWARD/PK INVENTORY" in blob
    assert "subdomain=Employee Records" in blob and "steward=HR Data Office" in blob and "pk=employee_id" in blob
    assert "TAG INVENTORY" in blob
    assert "PRIMARY-KEY FLAGS" in blob and "hr.employee.employee_id" in blob
    assert "METRIC-VIEW INVENTORY" in blob and "hr_vacancy_rate" in blob and "hr_turnover_rate" in blob and "hr_headcount" in blob
    assert "CATALOG (authoritative): vibe_gov_transport_basemvm" in blob


def test_tag_inventory_counts():
    fn = _load_inventory_fn()
    assert fn is not None
    domains, products, attributes = _model()
    lines = fn(_fake_self(), domains, products, attributes)
    blob = "\n".join(lines)
    # glossary appears on 2 attrs, source_attribute on 2 attrs
    assert "gov_transport_business_glossary_term(2)" in blob
    assert "gov_transport_source_attribute(2)" in blob


def test_metric_views_parsed_from_statements():
    fn = _load_inventory_fn()
    assert fn is not None
    domains, products, attributes = _model()
    stmts = ["CREATE OR REPLACE VIEW vibe_gov_transport_basemvm._metrics.hr_vacancy_rate AS SELECT 1"]
    lines = fn(_fake_self(statements=stmts), domains, products, attributes)
    blob = "\n".join(lines)
    assert "METRIC-VIEW INVENTORY" in blob and "hr_vacancy_rate" in blob


def test_audit_all_wires_inventory():
    """No dead code (sec.8.4): audit_all must actually call the helper + emit the FIRED alias."""
    src = _nb_code()
    a = src.find("    def audit_all(self, domains_data, products_data, attributes_data):")
    assert a != -1
    end = src.find("\n    def ", a + 1)
    audit_body = src[a:end if end != -1 else len(src)]
    assert "self._v385_after_state_inventory_lines(domains_data, products_data, attributes_data)" in audit_body
    assert "verifier-after-state-inventory FIRED v3.8.5" in audit_body
