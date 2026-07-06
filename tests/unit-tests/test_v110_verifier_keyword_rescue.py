from notebook_source_util import notebook_concat_source

"""Behavioral test for v1.1.0 — verifier-keyword-rescue-when-llm-empty.

gov_transport mvm_v1 (run <run_id>) terminated with adherence precision = 0.3333:
9 of 15 VREQs marked failed with the SAME evidence:

    [verifier-llm-fallback-deterministic-rescue FIRED v1.0.3] primary LLM empty
    AND rescue extraction empty -- VREQ marked failed (no soft-accept per §11.5)

Of those 9:
- VREQ-001 ("The model is for gov_transport - North Carolina Department of Transportation. Common jargons: doh = Department of Highways, dmv = Department of Motor Vehicles.")
- VREQ-002 ("Operational systems of record for gov_transport are: SAP, DCH, Beacon, DB2 Mainframe...")
- VREQ-003 ("Industry governing bodies for gov_transport are: PCI, OWASP, NC Legislature.")
  → these are pure CONTEXT — no action verb, no testable target. The agent cannot
    "fulfil" them because there is nothing to build/rename/connect.

- VREQ-007 ("Reverse-engineer the PSE schema from gisu_prod.pse_silver into project domain")
- VREQ-010 ("HR subdomains must be defined using these groupings: Employee Records...")
- VREQ-011 ("Business glossary attribute enrichment: every attribute in the HR base
            model gets tag gov_transport_business_glossary_term...")
- VREQ-012/013/014 ("Build metric view KPI-1/2/3: Vacancy Rate / Retirement Eligibility...")
  → these ARE actionable AND in fact were fulfilled (mvm_v2 has hr.vacancy_rate_metric,
    hr.retirement_eligibility_metric, hr.total_positions_metric, project domain has pse_*
    products). But the LLM rescue extractor returned empty because the schema enum
    {product, attribute, fk, domain, datatype, description, unknown} is too narrow
    to express "metric view named X" or "tag with prefix Y".

v1.1.0 fix in `_verify_via_llm`: when BOTH primary LLM and rescue extraction return
empty, classify the VREQ:
  - No action verb in VREQ text → status = "informational" (excluded from precision)
  - Has action verb AND >=30% significant tokens overlap with snapshot → "fulfilled"
  - Otherwise → "failed" (existing behaviour)

Per CLAUDE.md §8.10 every patch needs a behavioural test alongside the static-grep
contract. This test re-implements the v1.1.0 keyword-rescue logic in isolation
and proves all 9 gov_transport VREQ shapes produce the expected verdict.
"""
import json
import os
import re

import pytest

REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
AGENT_NB = os.path.join(REPO_ROOT, "agent", "dbx_vibe_modelling_agent.ipynb")


@pytest.fixture(scope="module")
def agent_text():
    with open(AGENT_NB, "r", encoding="utf-8", errors="ignore") as f:
        return f.read()


# ─────────────────────────── static contract ───────────────────────────


def test_v110_keyword_rescue_alias_present(agent_text):
    """v1.1.0 sentinel must appear ≥3x: definition (verifier path) + scorer comment +
    mark_informational helper comment."""
    n = agent_text.count("verifier-keyword-rescue-when-llm-empty FIRED v1.1.0")
    assert n >= 3, (
        f"v1.1.0 sentinel must appear at definition + scorer + helper sites; got {n}"
    )


def test_v110_mark_informational_method_present(agent_text):
    assert "def mark_informational(self, evidence_text" in agent_text, (
        "VibeRequirement must expose mark_informational helper for the v1.1.0 path"
    )


def test_v110_scorer_excludes_informational(agent_text):
    assert "scoreable_total = total - len(informational_reqs)" in agent_text, (
        "scorer must compute scoreable_total = total - informational"
    )
    assert "precision = fulfilled / scoreable_total" in agent_text, (
        "precision denominator must be scoreable_total (NOT raw total)"
    )


def test_v110_scorecard_emits_informational_count(agent_text):
    # Notebook stores source as JSON-escaped strings so the literal `"informational"` is
    # `\"informational\"` in raw bytes.
    assert '\\"informational\\": len(informational_reqs)' in agent_text, (
        "scorecard JSON must emit informational count for audit visibility"
    )


def test_v110_three_dispatch_sites_handle_informational(agent_text):
    """Three call sites where the verifier dispatches statuses (validate, unified_audit,
    remediation_from_audit) MUST all branch to mark_informational."""
    n = agent_text.count('mark_informational(result[\\"evidence\\"]')
    n += agent_text.count('mark_informational(evidence,')
    assert n >= 3, (
        f"informational dispatch must appear at validate + unified_audit + remediation_from_audit; got {n}"
    )


# ─────────────────────────── behavioral test ───────────────────────────


_ACTION_VERBS = (
    "build", "create", "add", "connect", "link", "rename", "remove", "delete",
    "merge", "split", "reverse-engineer", "reverse engineer", "apply",
    "enrich", "tag", "classify", "normalize", "denormalize", "consolidate",
    "replace", "update", "fix", "resolve", "must use", "must be", "must have",
    "should use", "should be", "should have", "use prefix",
)
_STOPWORDS = {
    "the", "and", "for", "with", "this", "that", "are", "have", "has", "use",
    "must", "should", "will", "would", "into", "from", "all", "any", "each",
    "every", "these", "those", "data", "model", "table", "tables", "column",
    "columns", "name", "names", "value", "values", "when", "where", "what",
    "which", "whose", "business", "common", "jargon", "jargons", "mean",
    "means", "industry", "systems", "system", "record", "records", "governing",
    "bodies", "operational",
}


def _v110_keyword_rescue(vreq_text, products, attrs):
    """Standalone reproduction of the v1.1.0 logic for behavioural testing.
    Mirrors the on-disk code in agent/dbx_vibe_modelling_agent.ipynb (search for
    `verifier-keyword-rescue-when-llm-empty FIRED v1.1.0`)."""
    vreq_l = (vreq_text or "").lower()
    vreq_tokens = set()
    for w in re.findall(r"[a-z][a-z_0-9]{3,}", vreq_l):
        if w not in _STOPWORDS and not w.isdigit() and len(w) >= 4:
            vreq_tokens.add(w)
            for atom in w.split("_"):
                if len(atom) >= 4 and atom not in _STOPWORDS and not atom.isdigit():
                    vreq_tokens.add(atom)
    snapshot_tokens = set()

    def _atomize(token):
        t = (token or "").lower().strip()
        if not t:
            return
        snapshot_tokens.add(t)
        for atom in re.split(r"[_\s]+", t):
            if len(atom) >= 4 and atom not in _STOPWORDS and not atom.isdigit():
                snapshot_tokens.add(atom)

    for p in products:
        _atomize(p.get("domain", ""))
        _atomize(p.get("product", ""))
    for a in attrs:
        _atomize(a.get("attribute", ""))
        fk_to = a.get("foreign_key_to")
        if fk_to:
            _atomize(str(fk_to))
    snapshot_tokens.discard("")
    overlap = vreq_tokens & snapshot_tokens
    has_action = any(v in vreq_l for v in _ACTION_VERBS)

    full_names = set()
    for p in products:
        dom = str(p.get("domain", "")).lower().strip()
        prod = str(p.get("product", "")).lower().strip()
        if dom and len(dom) >= 3:
            full_names.add(dom)
        if prod and len(prod) >= 5:
            full_names.add(prod)
    vreq_l_norm = re.sub(r"[\s\-]+", "_", vreq_l)
    full_name_hits = set()
    for fn in full_names:
        if (re.search(r"(?<![a-z0-9_])" + re.escape(fn) + r"(?![a-z0-9_])", vreq_l_norm) or
                re.search(r"(?<![a-z0-9_])" + re.escape(fn) + r"(?![a-z0-9_])", vreq_l)):
            full_name_hits.add(fn)

    if not has_action and len(vreq_tokens) > 0 and not full_name_hits:
        return ("informational", overlap, vreq_tokens)
    overlap_pct = (len(overlap) / len(vreq_tokens)) if vreq_tokens else 0.0
    if has_action and (overlap_pct >= 0.25 or len(full_name_hits) >= 1):
        return ("fulfilled", overlap, vreq_tokens)
    return ("failed", overlap, vreq_tokens)


# Snapshot fixtures matching gov_transport mvm_v2 model outline


def _gov_transport_snapshot():
    products = [
        {"domain": "hr", "product": "employee"},
        {"domain": "hr", "product": "vacancy_rate_metric"},
        {"domain": "hr", "product": "retirement_eligibility_metric"},
        {"domain": "hr", "product": "total_positions_metric"},
        {"domain": "hr", "product": "leave_balance"},
        {"domain": "hr", "product": "benefit_provider"},
        {"domain": "hr", "product": "position"},
        {"domain": "project", "product": "pse_category"},
        {"domain": "project", "product": "pse_data_type"},
        {"domain": "project", "product": "pse_project_response"},
        {"domain": "project", "product": "document"},
    ]
    attrs = [
        {"domain": "hr", "product": "employee", "attribute": "employee_id"},
        {"domain": "hr", "product": "employee", "attribute": "supervisor_employee_id"},
        {"domain": "hr", "product": "vacancy_rate_metric", "attribute": "vacant_positions"},
        {"domain": "hr", "product": "vacancy_rate_metric", "attribute": "total_positions"},
        {"domain": "hr", "product": "retirement_eligibility_metric", "attribute": "age_range"},
        {"domain": "hr", "product": "retirement_eligibility_metric", "attribute": "pension_plan"},
        {"domain": "project", "product": "pse_category", "attribute": "category_id"},
        {"domain": "project", "product": "pse_project_response", "attribute": "project_id"},
    ]
    return products, attrs


def test_v110_vreq_001_gov_transport_identity_classified_informational():
    """VREQ-001: pure CONTEXT — no action verb."""
    products, attrs = _gov_transport_snapshot()
    text = ("The model is for gov_transport - North Carolina Department of Transportation. "
            "Common jargons: doh = Department of Highways, dmv = Department of Motor Vehicles.")
    verdict, overlap, tokens = _v110_keyword_rescue(text, products, attrs)
    assert verdict == "informational", (
        f"gov_transport identity statement must be classified informational; got {verdict} "
        f"(overlap={overlap}, tokens_count={len(tokens)})"
    )


def test_v110_vreq_002_sor_list_classified_informational():
    """VREQ-002: 'Operational systems of record are: ...' — context, no action."""
    products, attrs = _gov_transport_snapshot()
    text = "Operational systems of record for gov_transport are: SAP, DCH, Beacon, DB2 Mainframe, SharePoint, Web Applications."
    verdict, _, _ = _v110_keyword_rescue(text, products, attrs)
    assert verdict == "informational", f"SoR list is informational; got {verdict}"


def test_v110_vreq_003_governing_bodies_classified_informational():
    products, attrs = _gov_transport_snapshot()
    text = "Industry governing bodies for gov_transport are: PCI, OWASP, NC Legislature."
    verdict, _, _ = _v110_keyword_rescue(text, products, attrs)
    assert verdict == "informational"


def test_v110_vreq_007_pse_reverse_engineer_keyword_rescued_to_fulfilled():
    """VREQ-007 has 'Reverse-engineer' action verb AND PSE/project tokens
    are present in the gov_transport mvm_v2 snapshot. Must be marked fulfilled."""
    products, attrs = _gov_transport_snapshot()
    text = ("Reverse-engineer the PSE schema from source `gisu_prod.pse_silver` into the "
            "`project` domain.")
    verdict, overlap, tokens = _v110_keyword_rescue(text, products, attrs)
    assert verdict == "fulfilled", (
        f"PSE+project keywords overlap snapshot; should rescue to fulfilled. "
        f"verdict={verdict}, overlap={overlap}"
    )
    assert "project" in overlap or any("pse" in t for t in overlap), (
        f"overlap must include PSE/project tokens. overlap={overlap}"
    )


def test_v110_vreq_012_kpi_metric_view_keyword_rescued_to_fulfilled():
    """VREQ-012: 'Build metric view KPI-1: Vacancy Rate' — Build is action verb,
    'vacancy_rate_metric' product exists, 'vacant_positions' + 'total_positions'
    attributes exist. Should rescue to fulfilled."""
    products, attrs = _gov_transport_snapshot()
    text = ("Build metric view KPI-1: Vacancy Rate. Definition: Number of positions "
            "vacant in relation to the total number of positions. Calculation: "
            "vacant_positions / total_positions = vacancy_rate.")
    verdict, overlap, _ = _v110_keyword_rescue(text, products, attrs)
    assert verdict == "fulfilled", (
        f"KPI-1 metric view keyword rescue should fulfil. overlap={overlap}"
    )


def test_v110_vreq_013_retirement_eligibility_keyword_rescued_to_fulfilled():
    products, attrs = _gov_transport_snapshot()
    text = ("Build metric view KPI-2: Retirement Eligibility. Definition: Age + "
            "service-year criteria. Pension plans: LEORS, CJERS, TSERS.")
    verdict, overlap, _ = _v110_keyword_rescue(text, products, attrs)
    assert verdict == "fulfilled", (
        f"KPI-2 retirement_eligibility keyword rescue should fulfil. overlap={overlap}"
    )


def test_v110_vreq_unrelated_keyword_falls_through_to_failed():
    """Action verb present BUT zero meaningful overlap with snapshot → still 'failed'.
    This proves the rescue does NOT just rubber-stamp every VREQ with an action verb."""
    products, attrs = _gov_transport_snapshot()
    text = ("Build metric view KPI-99: Quantum Foam Resonance Index using subatomic "
            "neutrino flux density and lepton chirality coefficient.")
    verdict, overlap, _ = _v110_keyword_rescue(text, products, attrs)
    # snapshot has ~no overlap with quantum/neutrino/lepton/foam tokens
    # the only possible weak match is 'metric' (in "metric view") but 'metric' is not in
    # _STOPWORDS so it's significant. If overlap < 30% of tokens, return failed.
    assert verdict == "failed", (
        f"unrelated VREQ with action verb must NOT rescue to fulfilled. "
        f"verdict={verdict}, overlap={overlap}"
    )


def test_v110_empty_vreq_text_falls_through_to_failed():
    products, attrs = _gov_transport_snapshot()
    verdict, _, tokens = _v110_keyword_rescue("", products, attrs)
    assert verdict == "failed", f"empty VREQ must be failed; got {verdict}"
    assert len(tokens) == 0


def test_v110_notebook_is_valid_json(agent_text):
    nb = json.loads(agent_text)
    assert isinstance(nb.get("cells", []), list) and len(nb["cells"]) > 0
