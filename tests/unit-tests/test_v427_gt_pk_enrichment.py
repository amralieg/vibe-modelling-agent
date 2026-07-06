"""v4.2.7 anti-lying-scoreboard: physical ground-truth PK enrichment (fail-pre / pass-post, §8.10).

Root cause (coffee_roastery re-val run 933671823193704): _run_ground_truth_audit rebuilt the
physical verification snapshot from information_schema.columns and enriched foreign_key_to from
physical FK constraints, but carried NO primary key -- products_data = [{"domain","product"}] and
phys_attrs had no is_primary_key. Delta/UC has no enforced PK constraint, so the physical snapshot
had zero PK signal, and the v4.2.6 deterministic PK invariant false-failed every table on the
physical pass (logical pass 22:24:28 scored VREQ-005 fulfilled 13/13; physical pass 22:26:20 scored
it failed 13/13 -> gt-headline-reground made 'failed' authoritative -> 88.9% instead of honest 100%).

Fix alias=gt-pk-from-model-declared: enrich the physical snapshot with the MODEL's declared PK when
every declared PK column PHYSICALLY EXISTS. These tests exec the REAL patched enrichment block from
the notebook (not a reimplementation) and feed its products_data into the REAL
_verify_structural_invariant so the whole seam is exercised end-to-end.
"""
import json, re, os, textwrap, pytest

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")
NB_PRE = "/tmp/agent_pre_v427.ipynb"


def _full_src(path):
    nb = json.load(open(path))
    return "".join(
        "".join(c.get("source", [])) if isinstance(c.get("source"), list) else c.get("source", "")
        for c in nb["cells"]
    )


def _extract_fn(src, name):
    m = re.search(rf"\n    def {name}\(self.*?\n    def ", src, re.S)
    assert m, f"{name} not found"
    body = m.group(0)
    body = body[: body.rfind("\n    def ")]
    return textwrap.dedent(body)


def _extract_enrich_block(src):
    """Pull the REAL v4.2.7 PK-enrichment block (from `_phys_cols_by_pp = {}` through the
    `products_data = [...]` assignment) out of _run_ground_truth_audit and dedent it so it can run
    at module scope in the test namespace with products / phys_attrs / phys_pp / logger seeded."""
    # back up to the START of the line so the baked-in 8-space indent is included and dedent works
    start = src.rindex("\n", 0, src.index("_phys_cols_by_pp = {}")) + 1
    end_marker = "products_data = [{\"domain\": d, \"product\": p, \"primary_key\": _pk_by_pp.get((d, p))} for d, p in phys_pp]"
    end = src.index(end_marker) + len(end_marker)
    block = src[start:end]
    return textwrap.dedent(block)


class _Logger:
    def info(self, *a, **k): pass
    def warning(self, *a, **k): pass
    def error(self, *a, **k): pass


class _Req:
    def __init__(self, text, rid="VREQ-005", scope_targets=None):
        self.original_text = text
        self.id = rid
        self.verification_strategy = "deterministic"
        self.scope = "model"
        self.scope_targets = scope_targets if scope_targets is not None else ["*"]


def _bind_struct(path):
    src = _full_src(path)
    ns = {"re": re}
    exec(_extract_fn(src, "_verify_structural_invariant"), ns)

    class Dummy:
        logger = _Logger()
    Dummy._verify_structural_invariant = ns["_verify_structural_invariant"]
    return Dummy()


PK_TXT = "Keep the model clean and production-grade: every table must have a primary key."


# The faithful reproduction of the live coffee_roastery model shape: products carry a PRODUCT-LEVEL
# primary_key (as the real model.json does -- 13/13 product.primary_key, 0 is_primary_key attrs), and
# the physical columns (phys_attrs) include the PK column but with is_primary_key absent.
def _model_products():
    return [
        {"domain": "caferetailsales", "product": "store", "primary_key": "store_id"},
        {"domain": "caferetailsales", "product": "ticket", "primary_key": "ticket_id"},
        {"domain": "customerloyalty", "product": "loyalty_account", "primary_key": "loyalty_account_id"},
    ]


def _phys_attrs_all_present():
    # physical columns from information_schema.columns; the PK column exists but no is_primary_key flag.
    return [
        {"domain": "caferetailsales", "product": "store", "attribute": "store_id", "foreign_key_to": ""},
        {"domain": "caferetailsales", "product": "store", "attribute": "store_name", "foreign_key_to": ""},
        {"domain": "caferetailsales", "product": "ticket", "attribute": "ticket_id", "foreign_key_to": ""},
        {"domain": "caferetailsales", "product": "ticket", "attribute": "store_id", "foreign_key_to": "caferetailsales.store.store_id"},
        {"domain": "customerloyalty", "product": "loyalty_account", "attribute": "loyalty_account_id", "foreign_key_to": ""},
    ]


def _run_enrich(path, products, phys_attrs):
    """Exec the REAL enrichment block from `path` and return the resulting products_data + phys_attrs."""
    src = _full_src(path)
    block = _extract_enrich_block(src)
    phys_pp = sorted({(a["domain"], a["product"]) for a in phys_attrs})
    ns = {"products": products, "phys_attrs": phys_attrs, "phys_pp": phys_pp, "logger": _Logger()}
    exec(block, ns)
    return ns["products_data"], phys_attrs


# ============================================================================
# POST-PATCH: enrichment populates primary_key -> deterministic verifier scores fulfilled
# ============================================================================

def test_post_patch_enriches_pk_and_scores_fulfilled():
    products_data, phys_attrs = _run_enrich(NB, _model_products(), _phys_attrs_all_present())
    # every physically-present table with a model-declared PK column now carries primary_key
    assert all(pd.get("primary_key") for pd in products_data), products_data
    obj = _bind_struct(NB)
    v = obj._verify_structural_invariant(_Req(PK_TXT), [], products_data, phys_attrs)
    assert v is not None and v["status"] == "fulfilled", v
    assert "gt" not in v["evidence"].lower() or "primary" in v["evidence"].lower()


def test_post_patch_sets_is_primary_key_on_phys_attr():
    _, phys_attrs = _run_enrich(NB, _model_products(), _phys_attrs_all_present())
    pk_flagged = {(a["domain"], a["product"], a["attribute"]) for a in phys_attrs if a.get("is_primary_key")}
    assert ("caferetailsales", "store", "store_id") in pk_flagged, pk_flagged
    assert ("customerloyalty", "loyalty_account", "loyalty_account_id") in pk_flagged, pk_flagged


# ============================================================================
# NON-TAUTOLOGY must-fail: a declared PK column that is NOT physically present -> no PK -> failed
# ============================================================================

def test_post_patch_declared_pk_absent_physically_still_failed():
    products = _model_products()
    phys = _phys_attrs_all_present()
    # drop the physical store_id column -> the declared PK no longer physically exists
    phys = [a for a in phys if not (a["product"] == "store" and a["attribute"] == "store_id")]
    products_data, phys_attrs = _run_enrich(NB, products, phys)
    store_pd = [pd for pd in products_data if pd["product"] == "store"][0]
    assert not store_pd.get("primary_key"), store_pd
    obj = _bind_struct(NB)
    v = obj._verify_structural_invariant(_Req(PK_TXT), [], products_data, phys_attrs)
    assert v is not None and v["status"] == "failed", v
    assert "caferetailsales.store" in v["evidence"], v


# ============================================================================
# FAIL-PRE: the pre-v427 build has no PK enrichment -> products_data lacks primary_key -> false-fail
# ============================================================================

def test_pre_patch_no_pk_enrichment_false_fails():
    if not os.path.exists(NB_PRE):
        pytest.skip("pre-v427 backup absent")
    pre = _full_src(NB_PRE)
    assert "gt-pk-from-model-declared" not in pre
    # pre-patch products_data (no primary_key) exactly reproduces the lying-scoreboard physical pass
    phys_attrs = _phys_attrs_all_present()
    phys_pp = sorted({(a["domain"], a["product"]) for a in phys_attrs})
    products_data = [{"domain": d, "product": p} for d, p in phys_pp]
    obj = _bind_struct(NB_PRE)
    v = obj._verify_structural_invariant(_Req(PK_TXT), [], products_data, phys_attrs)
    assert v is not None and v["status"] == "failed", f"expected pre-patch false-fail, got {v}"


# ============================================================================
# Wiring / version
# ============================================================================

def test_alias_and_callsite_present():
    src = _full_src(NB)
    assert "gt-pk-from-model-declared" in src
    # the enriched products_data assignment must be the live line in _run_ground_truth_audit
    assert '"primary_key": _pk_by_pp.get((d, p))' in src


def test_version_bumped_to_427():
    src = _full_src(NB)
    assert re.search(r'__AGENT_VERSION__ = "4\.2\.7"', src), "version not bumped to 4.2.7"
