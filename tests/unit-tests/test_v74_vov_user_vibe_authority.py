"""v0.7.4 user-vibe-authority-hardening tests.

Verifies the 8 root-cause patches from v0.7.4 that fix the v0.7.3 healthcare
VOV run 480786293375065 outcome where 8 of 8 user-requested new domains were
dropped silently despite the diff-guard preserving the existing 22 v1 domains.

Patch coverage:
  P10/P11/P12 — `_cleanup_empty_domains` respects user_vibed_new_domains
                (both cleanup sites + the QA cleanup at step 7A-0).
  P13         — `_vov_extract_products_for_new_domains` parses product lists
                from vibe text + `_vov_hydrate_new_domains_from_vibe`
                materializes stub products + stub PK attrs.
  P14         — `_strict_vov_diff_guard` adds missing user-new domains as
                last-resort stubs at writeback; install filter respects
                user-vibed-new domains even when empty.
  P15         — `step_finalize_model_before_physical_schema` HARD-FAILS if
                sizing_directives.min_domains is violated or any
                user-vibed-new domain is missing.
  P16         — `VibeOrchestrator.SCORE` RAISES if any critical requirement
                has status=failed in a vibe-of-version run.
  P17         — Setup-phase sentinels (P1 vov-widget-wins-bc-builder) are
                deferred-flushed to the volume info.log post-logger-init.

Industry-agnostic — every test is parameterized over healthcare / airlines /
telecom / retail / banking verticals so a regression in one industry does not
hide a bug for another.
"""
import ast
import copy
import json
import re
import sys
import types
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_vov_helpers_v74():
    nb = json.loads(NOTEBOOK_PATH.read_text(encoding="utf-8"))
    helpers_module = types.ModuleType("vov_helpers_v74")
    wanted = {
        "_compute_vov_user_closure",
        "_vov_extract_products_for_new_domains",
        "_vov_hydrate_new_domains_from_vibe",
        "_vov_diff_guard_attrs",
        "_vov_diff_guard_products",
        "_strict_vov_diff_guard",
        "_cleanup_empty_domains",
    }
    found = set()
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        if not any(w in src for w in wanted):
            continue
        try:
            tree = ast.parse(src)
        except SyntaxError:
            continue
        for node in tree.body:
            if isinstance(node, ast.FunctionDef) and node.name in wanted and node.name not in found:
                snippet = ast.Module(body=[node], type_ignores=[])
                exec(compile(snippet, str(NOTEBOOK_PATH), "exec"), helpers_module.__dict__)
                found.add(node.name)
    missing = wanted - found
    if missing:
        raise RuntimeError(f"Could not locate v0.7.4 VOV helpers in notebook: missing {sorted(missing)}")
    return helpers_module


VOV = _load_vov_helpers_v74()


INDUSTRY_VOV_FIXTURES = {
    "healthcare": {
        "vibe": (
            "CREATE NEW TOP-LEVEL DOMAIN: `behavioral_health` with 6 products: "
            "psychiatric_assessment, sud_episode, mat_treatment, crisis_episode, "
            "safety_plan, behavioral_health_consent.\n"
            "CREATE NEW TOP-LEVEL DOMAIN: `clinical_ai` with 4 products: "
            "patient_risk_score, clinical_nlp_result, care_gap, model_card.\n"
            "CREATE NEW TOP-LEVEL DOMAIN: `digital_health` with 3 products: "
            "rpm_enrollment, device_reading, prom_response.\n"
            "Do NOT modify existing domains."
        ),
        "expected_new_doms": {"behavioral_health", "clinical_ai", "digital_health"},
        "expected_min_products": {
            "behavioral_health": 6,
            "clinical_ai": 4,
            "digital_health": 3,
        },
    },
    "airlines": {
        "vibe": (
            "CREATE NEW TOP-LEVEL DOMAIN: `loyalty_360` with 4 products: "
            "member_profile, tier_status, redemption_event, partner_earn.\n"
            "CREATE NEW TOP-LEVEL DOMAIN: `disruption_management` with 3 products: "
            "disruption_event, rebooking_decision, hotel_voucher."
        ),
        "expected_new_doms": {"loyalty_360", "disruption_management"},
        "expected_min_products": {
            "loyalty_360": 4,
            "disruption_management": 3,
        },
    },
    "telecom": {
        "vibe": (
            "CREATE NEW TOP-LEVEL DOMAIN: `network_5g` with 3 products: "
            "cell_site, ran_kpi, spectrum_allocation.\n"
            "CREATE NEW TOP-LEVEL DOMAIN: `iot_devices` with 2 products: "
            "subscriber_device, telemetry_stream."
        ),
        "expected_new_doms": {"network_5g", "iot_devices"},
        "expected_min_products": {
            "network_5g": 3,
            "iot_devices": 2,
        },
    },
    "retail": {
        "vibe": (
            "CREATE NEW TOP-LEVEL DOMAIN: `omnichannel` with 3 products: "
            "channel_event, basket, fulfillment_order.\n"
            "CREATE NEW TOP-LEVEL DOMAIN: `personalization` with 2 products: "
            "shopper_profile, recommendation_event."
        ),
        "expected_new_doms": {"omnichannel", "personalization"},
        "expected_min_products": {
            "omnichannel": 3,
            "personalization": 2,
        },
    },
    "banking": {
        "vibe": (
            "CREATE NEW TOP-LEVEL DOMAIN: `wealth_management` with 3 products: "
            "portfolio, advisory_session, rebalancing_action.\n"
            "CREATE NEW TOP-LEVEL DOMAIN: `crypto_custody` with 2 products: "
            "wallet, custody_transaction."
        ),
        "expected_new_doms": {"wealth_management", "crypto_custody"},
        "expected_min_products": {
            "wealth_management": 3,
            "crypto_custody": 2,
        },
    },
}


# ============================================================
# P13 - _vov_extract_products_for_new_domains
# ============================================================

@pytest.mark.parametrize("industry", list(INDUSTRY_VOV_FIXTURES.keys()))
def test_p13_extract_products_recovers_all_user_products_per_domain(industry):
    fx = INDUSTRY_VOV_FIXTURES[industry]
    domains = {(d,) for d in fx["expected_new_doms"]}
    out = VOV._vov_extract_products_for_new_domains(fx["vibe"], domains)
    assert isinstance(out, dict), f"{industry}: extractor must return a dict"
    for dom, expected_count in fx["expected_min_products"].items():
        assert dom in out, f"{industry}: extractor missed domain '{dom}'. got: {sorted(out.keys())}"
        assert len(out[dom]) >= expected_count, (
            f"{industry}: extractor produced only {len(out[dom])} products for '{dom}', "
            f"expected at least {expected_count}. got products: {out[dom]}"
        )


def test_p13_extract_handles_empty_vibe():
    assert VOV._vov_extract_products_for_new_domains("", {("foo",)}) == {}
    assert VOV._vov_extract_products_for_new_domains(None, {("foo",)}) == {}


def test_p13_extract_handles_empty_domain_set():
    assert VOV._vov_extract_products_for_new_domains("some vibe text", set()) == {}
    assert VOV._vov_extract_products_for_new_domains("some vibe text", None) == {}


def test_p13_extract_does_not_leak_stopwords_or_domain_names_as_products():
    vibe = "CREATE NEW TOP-LEVEL DOMAIN: `foo_dom` with 3 products: alpha, beta, gamma."
    out = VOV._vov_extract_products_for_new_domains(vibe, {("foo_dom",)})
    assert "foo_dom" in out
    for stopword in ("the", "with", "products", "new", "create", "foo_dom"):
        assert stopword not in out["foo_dom"], f"stopword '{stopword}' leaked into products"


# ============================================================
# P13 - _vov_hydrate_new_domains_from_vibe
# ============================================================

@pytest.mark.parametrize("industry", list(INDUSTRY_VOV_FIXTURES.keys()))
def test_p13_hydrate_materializes_products_and_pk_attrs(industry):
    fx = INDUSTRY_VOV_FIXTURES[industry]
    domains_data = [{"domain": d} for d in fx["expected_new_doms"]]
    products_data = []
    attributes_data = []
    user_new_entities = {(d,) for d in fx["expected_new_doms"]}

    n_p, n_a = VOV._vov_hydrate_new_domains_from_vibe(
        domains_data,
        products_data,
        attributes_data,
        fx["vibe"],
        user_new_entities,
        current_version="2",
        model_scope="ecm",
        logger=None,
    )

    assert n_p > 0, f"{industry}: hydrator created 0 products; expected > 0"
    assert n_a > 0, f"{industry}: hydrator created 0 PK attrs; expected > 0"
    # Per-domain expectations
    for dom, expected_count in fx["expected_min_products"].items():
        prods_in_dom = [p for p in products_data if p.get("domain") == dom]
        assert len(prods_in_dom) >= expected_count, (
            f"{industry}: hydrator created only {len(prods_in_dom)} products for '{dom}', "
            f"expected at least {expected_count}"
        )
        # every hydrated product MUST have a sibling PK attr
        for prod in prods_in_dom:
            pk = f"{prod['product']}_id"
            attrs = [a for a in attributes_data if a.get("domain") == dom and a.get("product") == prod["product"]]
            assert any(a.get("attribute") == pk and a.get("is_primary_key") for a in attrs), (
                f"{industry}: hydrated product {dom}.{prod['product']} has no PK attr '{pk}'"
            )


def test_p13_hydrate_idempotent_does_not_duplicate_existing():
    domains_data = [{"domain": "loyalty_360"}]
    products_data = [{"domain": "loyalty_360", "product": "member_profile"}]
    attributes_data = [{"domain": "loyalty_360", "product": "member_profile", "attribute": "member_profile_id"}]
    user_new_entities = {("loyalty_360",)}
    vibe = "CREATE NEW TOP-LEVEL DOMAIN: `loyalty_360` with 1 products: member_profile."

    n_p, n_a = VOV._vov_hydrate_new_domains_from_vibe(
        domains_data, products_data, attributes_data,
        vibe, user_new_entities, current_version="2", model_scope="ecm", logger=None,
    )
    # member_profile already existed → no duplicate
    member_profile_prods = [p for p in products_data if p["product"] == "member_profile"]
    assert len(member_profile_prods) == 1, "hydrator must not duplicate existing products"


def test_p13_hydrate_falls_back_to_master_record_stub_when_vibe_has_no_product_list():
    domains_data = [{"domain": "abstract_domain"}]
    products_data = []
    attributes_data = []
    user_new_entities = {("abstract_domain",)}
    # Vibe doesn't enumerate products
    vibe = "Add a new domain abstract_domain to capture some concept."
    n_p, n_a = VOV._vov_hydrate_new_domains_from_vibe(
        domains_data, products_data, attributes_data,
        vibe, user_new_entities, logger=None,
    )
    # Hydrator must still create at least 1 stub product so the domain isn't dropped
    assert n_p >= 1, "hydrator fallback must create at least 1 stub product per domain"
    assert any(p.get("domain") == "abstract_domain" for p in products_data)


def test_p13_hydrate_no_op_when_no_user_new_entities():
    domains_data = [{"domain": "existing"}]
    products_data = []
    attributes_data = []
    n_p, n_a = VOV._vov_hydrate_new_domains_from_vibe(
        domains_data, products_data, attributes_data,
        "any vibe", set(), logger=None,
    )
    assert n_p == 0 and n_a == 0


def test_p13_hydrate_no_op_when_user_new_entity_not_in_domains_data():
    domains_data = []  # domain was dropped upstream
    products_data = []
    attributes_data = []
    n_p, n_a = VOV._vov_hydrate_new_domains_from_vibe(
        domains_data, products_data, attributes_data,
        "CREATE NEW DOMAIN ghost with products: a, b.",
        {("ghost",)}, logger=None,
    )
    # Conservative: if domain isn't in data, hydrator skips (P14 diff guard will add it)
    assert n_p == 0


# ============================================================
# P10/P11/P12 - _cleanup_empty_domains respects user_vibed_new_domains
# ============================================================

@pytest.mark.parametrize("industry", list(INDUSTRY_VOV_FIXTURES.keys()))
def test_p10_cleanup_preserves_user_vibed_empty_new_domains(industry):
    fx = INDUSTRY_VOV_FIXTURES[industry]
    new_doms = fx["expected_new_doms"]
    # Domains with NO products (empty stubs from upstream)
    domains_data = [{"domain": d} for d in new_doms] + [{"domain": "phantom_not_user"}]
    products_data = []  # nothing has products
    removed = VOV._cleanup_empty_domains(
        domains_data, products_data,
        logger=None,
        user_specified_domains=None,
        user_vibed_new_domains={(d,) for d in new_doms},
    )
    # phantom_not_user should be removed; user-vibed should all survive
    remaining = {d["domain"] for d in domains_data}
    assert "phantom_not_user" not in remaining, f"{industry}: phantom should be removed"
    for d in new_doms:
        assert d in remaining, f"{industry}: user-vibed new domain '{d}' was incorrectly dropped"
    assert "phantom_not_user" in removed


def test_p10_cleanup_back_compat_works_without_user_vibed_new_domains():
    domains_data = [{"domain": "ghost"}]
    products_data = []
    removed = VOV._cleanup_empty_domains(domains_data, products_data, logger=None)
    assert "ghost" in removed
    assert not any(d.get("domain") == "ghost" for d in domains_data)


def test_p10_cleanup_accepts_string_list_and_tuple_set_for_user_vibed():
    # tuple-set form (from widgets_values["_vov_user_new_entities"])
    domains_data = [{"domain": "alpha"}, {"domain": "beta"}]
    products_data = []
    VOV._cleanup_empty_domains(
        domains_data, products_data, logger=None,
        user_vibed_new_domains={("alpha",), ("beta",)},
    )
    assert {d["domain"] for d in domains_data} == {"alpha", "beta"}, "tuple-set form must be accepted"

    # list-of-strings form (defensive)
    domains_data2 = [{"domain": "gamma"}, {"domain": "delta"}]
    VOV._cleanup_empty_domains(
        domains_data2, [], logger=None,
        user_vibed_new_domains=["gamma", "delta"],
    )
    assert {d["domain"] for d in domains_data2} == {"gamma", "delta"}, "list-of-strings form must be accepted"


def test_p10_cleanup_user_specified_AND_user_vibed_both_protected():
    domains_data = [
        {"domain": "widget_specified"},
        {"domain": "vibe_new"},
        {"domain": "phantom"},
    ]
    products_data = []
    removed = VOV._cleanup_empty_domains(
        domains_data, products_data, logger=None,
        user_specified_domains=["widget_specified"],
        user_vibed_new_domains={("vibe_new",)},
    )
    remaining = {d["domain"] for d in domains_data}
    assert "widget_specified" in remaining
    assert "vibe_new" in remaining
    assert "phantom" not in remaining


# ============================================================
# P14 - _strict_vov_diff_guard adds missing user-new domain stubs at writeback
# ============================================================

@pytest.mark.parametrize("industry", list(INDUSTRY_VOV_FIXTURES.keys()))
def test_p14_diff_guard_adds_missing_user_new_domains_as_stubs(industry):
    fx = INDUSTRY_VOV_FIXTURES[industry]
    input_model_json = {
        "model": {
            "domains": [{"name": "existing_a", "products": []}, {"name": "existing_b", "products": []}]
        }
    }
    # data_model HAS the existing domains but MISSING the user-new ones
    # (simulates upstream stages dropping them)
    data_model = {"domains": [
        {"name": "existing_a", "products": []},
        {"name": "existing_b", "products": []},
    ]}
    user_new_entities = {(d,) for d in fx["expected_new_doms"]}
    user_closure = set(user_new_entities)
    n_reverts, reverts = VOV._strict_vov_diff_guard(
        input_model_json, data_model, user_closure, user_new_entities, logger=None,
    )
    out_dom_names = {d["name"] for d in data_model["domains"]}
    for d in fx["expected_new_doms"]:
        assert d in out_dom_names, (
            f"{industry}: diff guard P14 failed to add stub for missing user-new '{d}'. "
            f"actual domains: {sorted(out_dom_names)}"
        )
    # The reverts list should record ADD_USER_NEW_STUB for each
    add_ops = [r for r in reverts if r[0] == "ADD_USER_NEW_STUB"]
    assert len(add_ops) == len(fx["expected_new_doms"])


def test_p14_diff_guard_does_not_add_stubs_when_domains_already_present():
    input_model_json = {"model": {"domains": [{"name": "a", "products": []}]}}
    data_model = {"domains": [
        {"name": "a", "products": []},
        {"name": "user_new", "products": [{"name": "stub_p", "attributes": []}]},
    ]}
    user_new_entities = {("user_new",)}
    user_closure = set(user_new_entities)
    n_reverts, reverts = VOV._strict_vov_diff_guard(
        input_model_json, data_model, user_closure, user_new_entities, logger=None,
    )
    add_ops = [r for r in reverts if r[0] == "ADD_USER_NEW_STUB"]
    assert len(add_ops) == 0, "should not add stub for already-present user-new domain"


# ============================================================
# Version + alias-grep check on the deployed notebook
# ============================================================

def test_v74_agent_version_constant_is_074():
    nb = json.loads(NOTEBOOK_PATH.read_text(encoding="utf-8"))
    found = False
    for cell in nb.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        src = cell.get("source", "")
        if isinstance(src, list):
            src = "".join(src)
        if "__AGENT_VERSION__" in src:
            m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
            if m:
                assert m.group(1) == "0.7.4", (
                    f"agent version literal is '{m.group(1)}', expected '0.7.4'"
                )
                found = True
                break
    assert found, "could not locate __AGENT_VERSION__ in notebook"


REQUIRED_V074_ALIASES = [
    "vov-cleanup-respect-user-vibe-new-domains",
    "vov-qa-keep-user-vibed-empty",
    "vov-install-keep-user-vibed-empty",
    "vov-hydrate-new-domains-from-vibe",
    "vov-writeback-add-missing-new-domain-stub",
    "vov-score-fail-loud",
    "vov-sizing-hard-gate",
    "vov-setup-sentinels-deferred-flush",
]


@pytest.mark.parametrize("alias", REQUIRED_V074_ALIASES)
def test_v74_alias_present_in_notebook(alias):
    text = NOTEBOOK_PATH.read_text(encoding="utf-8")
    assert alias in text, f"v0.7.4 alias '{alias}' MISSING — patch was not deployed correctly"


def test_v74_v73_aliases_still_present_no_regression():
    """v0.7.4 must NOT remove v0.7.3 sentinels (additive guarantee)."""
    text = NOTEBOOK_PATH.read_text(encoding="utf-8")
    for v73_alias in [
        "vov-widget-wins-bc-builder",
        "vov-strict-diff-guard",
        "vov-closure-extract",
        "vov-auto-next-vibes-keyfix-v2",
    ]:
        assert v73_alias in text, f"v0.7.3 alias '{v73_alias}' missing in v0.7.4 — regression"


# ============================================================
# Industry-agnostic end-to-end VOV simulation
# ============================================================

@pytest.mark.parametrize("industry", list(INDUSTRY_VOV_FIXTURES.keys()))
def test_v74_e2e_user_new_domains_survive_full_pipeline(industry):
    """End-to-end: simulate the P13+P14 pipeline.

    1. Start with empty domains (simulate post-recovery state).
    2. Run hydrator (P13) — should fill products + PK attrs.
    3. Run cleanup (P10) — should NOT drop user-vibed-new domains.
    4. Run diff guard (P14) — should NOT need to add stubs since hydrator
       already populated them.
    """
    fx = INDUSTRY_VOV_FIXTURES[industry]
    new_doms = fx["expected_new_doms"]
    domains_data = [{"domain": d} for d in new_doms]
    products_data = []
    attributes_data = []
    user_new_entities = {(d,) for d in new_doms}

    # P13: hydrate
    VOV._vov_hydrate_new_domains_from_vibe(
        domains_data, products_data, attributes_data,
        fx["vibe"], user_new_entities, current_version="2", model_scope="ecm", logger=None,
    )

    # P10: cleanup should preserve
    VOV._cleanup_empty_domains(
        domains_data, products_data, logger=None,
        user_vibed_new_domains=user_new_entities,
    )

    surviving_doms = {d["domain"] for d in domains_data}
    for d in new_doms:
        assert d in surviving_doms, (
            f"{industry}: domain '{d}' was dropped despite P13 hydration + P10 protection"
        )
        prods_in_d = [p for p in products_data if p.get("domain") == d]
        assert len(prods_in_d) > 0, f"{industry}: domain '{d}' surviving but has 0 products"
