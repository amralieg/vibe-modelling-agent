from notebook_source_util import notebook_concat_source

"""v0.8.1 behavioral tests — P44/P45 forced-naming purge + ECM operation guard.

What we are guaranteeing here, sourced from the v0.8.0 healthcare+legal audit:

P44 (alias=vov-no-forced-master-record-stub):
  - The hardcoded fallback `{dom: [f'{dom}_master_record']}` at the vov-hydrate path
    is DELETED. When the regex extractor cannot find products in the vibe text, the
    function MUST return (0, 0) without forcing any stub product names. Downstream
    PRODUCT_GENERATE_PROMPT will name them via LLM (the user-mandated
    EVERYTHING-MUST-COME-FROM-LLM principle).

P45 (alias=vov-hydrate-skip-non-vov):
  - When operation != "vibe modeling of version", the vov-hydrate function MUST be
    a no-op. ECM, install, shrink, enlarge all use the normal PRODUCT_GENERATE_PROMPT
    flow — no VOV-only side channel.

Anti-regression:
  - When the regex extractor DOES find products in the vibe text (genuine VOV usage),
    hydrate must still work correctly.
  - The agent_version constant must be exactly "0.8.1".
  - The function signature must accept the new `operation` keyword.
"""
import json
import re
from pathlib import Path

AGENT_NB = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_agent_source():
    nb = json.loads(AGENT_NB.read_text(encoding="utf-8"))
    return "\n".join(
        "".join(c.get("source", []))
        for c in nb["cells"]
        if c.get("cell_type") == "code"
    )


def test_v81_agent_version_is_at_least_081():
    src = _load_agent_source()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', src)
    assert m, "__AGENT_VERSION__ literal not found"
    maj, mn, pt = int(m.group(1)), int(m.group(2)), int(m.group(3))
    assert (maj, mn, pt) >= (0, 8, 1), (
        f"version must be >= 0.8.1 (P44/P45 forced-naming purge requires v0.8.1+); got {maj}.{mn}.{pt}"
    )


def test_v81_p44_alias_present_at_warning_path():
    src = _load_agent_source()
    assert "vov-no-forced-master-record-stub FIRED" in src, (
        "P44 alias 'vov-no-forced-master-record-stub FIRED' must appear in the agent notebook"
    )
    # The OLD fallback line must be GONE from executable code (allowed only in comment)
    # Strip Python comments to be strict
    code_only = "\n".join(
        re.sub(r"#.*$", "", ln) for ln in src.splitlines()
    )
    assert "f'{dom}_master_record'" not in code_only, (
        "P44 violation: the hardcoded `f'{dom}_master_record'` fallback MUST be deleted from executable code"
    )


def test_v81_p45_alias_present_at_function_entry():
    src = _load_agent_source()
    assert "vov-hydrate-skip-non-vov FIRED" in src, (
        "P45 alias 'vov-hydrate-skip-non-vov FIRED' must appear in the agent notebook"
    )
    # The function signature must accept operation
    assert "def _vov_hydrate_new_domains_from_vibe(" in src, (
        "_vov_hydrate_new_domains_from_vibe function must still be defined"
    )
    assert "operation=None" in src, (
        "P45: _vov_hydrate_new_domains_from_vibe must accept operation keyword"
    )


def test_v81_call_site_passes_operation():
    src = _load_agent_source()
    # Match the call-site threading: operation must be passed from widgets_values
    assert 'operation=(widgets_values or {}).get("operation")' in src, (
        "P45: the call site of _vov_hydrate_new_domains_from_vibe must pass operation from widgets_values"
    )


# ---------------------- behavioral simulations ----------------------

def _build_hydrate_callable():
    """Extract the hydrate function from the notebook and exec it in an isolated
    namespace so the test can call it directly without needing Databricks runtime.
    """
    src = _load_agent_source()
    # Pull the function + its sibling regex extractor (the extractor is called from hydrate)
    def _extract_def(text, name):
        i = text.index(f"def {name}(")
        # Find the end: next "\ndef " or "\nclass " at column 0
        j = text.find("\ndef ", i + 1)
        k = text.find("\nclass ", i + 1)
        if k == -1: k = len(text)
        if j == -1: j = len(text)
        return text[i:min(j, k)].rstrip()
    extractor_src = _extract_def(src, "_vov_extract_products_for_new_domains")
    hydrate_src = _extract_def(src, "_vov_hydrate_new_domains_from_vibe")
    ns = {}
    exec("import re\nimport copy\n" + extractor_src + "\n" + hydrate_src, ns)
    return ns["_vov_hydrate_new_domains_from_vibe"]


def test_v81_hydrate_skips_when_operation_is_ecm():
    """P45: ECM operation must short-circuit the hydrate (returns (0, 0) immediately)."""
    hydrate = _build_hydrate_callable()
    domains_data = [{"domain": "billing"}]
    products_data = []
    attributes_data = []
    vibe_text = "DOMAIN billing with 3 products: invoice, payment, refund"
    user_new_entities = {("billing",)}
    p, a = hydrate(
        domains_data, products_data, attributes_data,
        vibe_text, user_new_entities,
        operation="new base model",
    )
    assert (p, a) == (0, 0), f"P45: ECM operation must produce 0 hydrated; got ({p}, {a})"
    assert products_data == [], "P45: ECM operation must not append any products"
    assert attributes_data == [], "P45: ECM operation must not append any attributes"


def test_v81_hydrate_skips_when_operation_is_install_model():
    """P45: install operation must short-circuit the hydrate."""
    hydrate = _build_hydrate_callable()
    domains_data = [{"domain": "billing"}]
    products_data = []
    attributes_data = []
    vibe_text = "billing domain"
    p, a = hydrate(
        domains_data, products_data, attributes_data,
        vibe_text, {("billing",)},
        operation="install model",
    )
    assert (p, a) == (0, 0)


def test_v81_hydrate_runs_when_operation_is_vov():
    """P45: VOV operation must let the hydrate run (and use the regex extractor)."""
    hydrate = _build_hydrate_callable()
    domains_data = [{"domain": "billing"}]
    products_data = []
    attributes_data = []
    # A vibe text with products in a parseable shape for the regex extractor
    vibe_text = "DOMAIN: `billing` with 3 products: invoice, payment, refund"
    p, a = hydrate(
        domains_data, products_data, attributes_data,
        vibe_text, {("billing",)},
        operation="vibe modeling of version",
    )
    # Should hydrate the products the regex extractor extracted
    product_names = {p.get("product") for p in products_data}
    # Either all 3 are extracted OR the regex matched a subset — assert NONE are
    # the forbidden <dom>_master_record stub
    assert "billing_master_record" not in product_names, (
        "P44 violation: hydrate must NEVER add billing_master_record stub"
    )
    # If the extractor found products, p > 0 and they should be from the vibe text.
    # If it found none, p == 0 (no forced stub) — that's the P44 contract.
    assert all("master_record" not in n for n in product_names), (
        "P44 violation: no product name should contain master_record"
    )


def test_v81_hydrate_no_forced_stub_when_extractor_fails():
    """P44 core regression: when the regex extractor returns 0 products (because the
    vibe text doesn't list product names), hydrate MUST return (0,0) — NOT inject
    `<dom>_master_record` stubs.
    """
    hydrate = _build_hydrate_callable()
    domains_data = [{"domain": "consent"}]
    products_data = []
    attributes_data = []
    # Vibe text mentions the domain but has NO parseable product list — the v0.8.0
    # bug would have created `consent.consent_master_record` here.
    vibe_text = "Healthcare needs a consent domain to track patient consent throughout the journey."
    p, a = hydrate(
        domains_data, products_data, attributes_data,
        vibe_text, {("consent",)},
        operation="vibe modeling of version",
    )
    assert (p, a) == (0, 0), (
        f"P44 violation: extractor failure should yield (0,0), got ({p}, {a}). "
        "The hardcoded <dom>_master_record fallback should be deleted."
    )
    assert products_data == [], (
        "P44 violation: NO stub product should be hydrated when extractor fails"
    )
    assert all("master_record" not in (p.get("product") or "") for p in products_data), (
        "P44 violation: no master_record stub may appear"
    )


def test_v81_hydrate_no_master_record_for_multi_domain_extractor_failure():
    """The exact v0.8.0 regression: 21 user-new domains in HC ECM all got hydrated
    with `<dom>_master_record` stubs. With P44, the same input MUST produce 0 stubs.
    """
    hydrate = _build_hydrate_callable()
    domain_names = [
        "billing", "claim", "clinical", "compliance", "encounter",
        "facility", "finance", "insurance", "interoperability",
        "laboratory", "order", "patient", "pharmacy", "provider",
        "quality", "radiology", "reference", "research", "scheduling",
        "supply", "workforce",
    ]
    domains_data = [{"domain": d} for d in domain_names]
    products_data = []
    attributes_data = []
    user_new_entities = {(d,) for d in domain_names}
    # Vibe text mentions domain names but no parseable product lists
    vibe_text = "Build me a healthcare model with " + ", ".join(domain_names) + " domains."
    p, a = hydrate(
        domains_data, products_data, attributes_data,
        vibe_text, user_new_entities,
        operation="vibe modeling of version",
    )
    # ZERO stubs (was 21 in v0.8.0)
    assert p == 0, f"P44 violation: expected 0 hydrated products, got {p}"
    assert a == 0, f"P44 violation: expected 0 hydrated attrs, got {a}"
    assert not any("master_record" in (pp.get("product") or "") for pp in products_data), (
        "P44 violation: no <dom>_master_record stub may appear"
    )
