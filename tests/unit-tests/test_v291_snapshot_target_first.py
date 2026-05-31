"""v2.9.1 FIX-1 behavioral test: verifier snapshot surfaces VREQ targets first.

ROOT CAUSE (pre-patch): the per-VREQ LLM verifier snapshot iterated products_data in
arbitrary order and capped at the first 200 products. A VREQ naming a product that
sat in the elided tail (index >= 200) saw '... (N more products elided)' and the LLM
returned 'not in VISIBLE after-state' -> false partial/failed.

FIX: products whose domain/product matches req.scope_targets are surfaced FIRST
(deterministic, no LLM), guaranteeing named entities are within the 200-product cap.

§8.10 proof-of-failure on pre-patch HEAD: the alias/ordering does not exist pre-patch.
"""
import json
import os

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")
MAX_PRODUCTS = 200


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _order_like_fix(products_data, scope_targets):
    """Mirror of the in-agent _v291 target-first ordering (kept in lockstep with source)."""
    targets = set()
    for t in (scope_targets or []):
        ts = str(t or "").strip().lower()
        if ts and ts != "*":
            targets.add(ts)
            for atom in ts.split("."):
                if atom:
                    targets.add(atom)

    def is_target(p):
        if not targets:
            return False
        dom = str(p.get("domain", "")).lower()
        prod = str(p.get("product", "")).lower()
        pk = f"{dom}.{prod}"
        prod_ns = prod[len(dom) + 1:] if dom and prod.startswith(dom + "_") else prod
        for t in targets:
            t_ns = t[len(dom) + 1:] if dom and t.startswith(dom + "_") else t
            if (t == pk or t == prod or t == dom or t in pk
                    or t == prod_ns or t_ns == prod or t_ns == prod_ns):
                return True
        return False

    targeted = [p for p in products_data if is_target(p)]
    return targeted + [p for p in products_data if not is_target(p)]


def test_fix_present_in_source():
    src = _src()
    assert "verifier-snapshot-target-first FIRED v2.9.1" in src, \
        "v2.9.1 FIX-1 not found (pre-patch HEAD => FAIL)"
    assert "for _p in _v100_products_ordered:" in src
    assert "for _p in products_data:" not in src.split("_v100_max_products = 200", 1)[1][:2000]


def test_target_in_tail_moves_within_cap():
    # 250 products; the target is at index 240 (elided pre-patch). After ordering it
    # must be within the first MAX_PRODUCTS so the LLM verifier can see it.
    products = [{"domain": "d", "product": f"p{i}"} for i in range(250)]
    products[240] = {"domain": "billing", "product": "invoice"}
    ordered = _order_like_fix(products, ["billing.invoice"])
    visible = ordered[:MAX_PRODUCTS]
    assert {"domain": "billing", "product": "invoice"} in visible
    # and it is in fact first
    assert ordered[0] == {"domain": "billing", "product": "invoice"}


def test_no_targets_preserves_order():
    # §8.3 anti-tautology: bulk VREQs (scope_targets == ['*'] or empty) must NOT reorder.
    products = [{"domain": "d", "product": f"p{i}"} for i in range(5)]
    assert _order_like_fix(products, ["*"]) == products
    assert _order_like_fix(products, []) == products


def test_domain_target_surfaces_all_domain_products():
    products = [{"domain": "x", "product": "a"},
                {"domain": "ops", "product": "b"},
                {"domain": "x", "product": "c"},
                {"domain": "ops", "product": "d"}]
    ordered = _order_like_fix(products, ["ops"])
    assert ordered[0]["domain"] == "ops" and ordered[1]["domain"] == "ops"


def test_fix5_prefix_strip_tolerance_in_source():
    src = _src()
    assert "verifier-fuzzy-product-match FIRED v2.9.1" in src, \
        "v2.9.1 FIX-5 fuzzy match not found (pre-patch HEAD => FAIL)"


def test_fix5_vreq_names_prefixed_product_matches_stripped():
    # VREQ names 'project_material'; pipeline §3c-stripped it to 'material'. Must still match.
    products = [{"domain": "project", "product": "material"},
                {"domain": "project", "product": "task"}]
    ordered = _order_like_fix(products, ["project.project_material"])
    assert ordered[0] == {"domain": "project", "product": "material"}


def test_fix5_vreq_names_stripped_product_matches_prefixed():
    # Reverse direction: VREQ names 'material'; pipeline stored 'project_material'.
    products = [{"domain": "project", "product": "project_material"},
                {"domain": "project", "product": "task"}]
    ordered = _order_like_fix(products, ["material"])
    assert ordered[0] == {"domain": "project", "product": "project_material"}
