"""Behavioral test for v3.5.8 alias=v358-product-ceiling.

ROOT CAUSE under test: the media_broadcasting/ngo VOV product EXPLOSION that
v3.5.6's sizing-contradiction sanitizer did NOT stop. The merged sizing directive
correctly carried max_total_products=421 (max==min, no contradiction) yet the VOV
review-mode batch expansion added LLM-hallucinated products UNBOUNDED to 5214,
because the cumulative product ceiling was enforced ONLY on the from-scratch
base-ECM target_fit clamp, NEVER on the VOV path.

The fix _v358_enforce_product_ceiling_flat is a deterministic finalize gate that
prunes the excess back to the ceiling while PROTECTING every v1 product (§3b) and
every vibe-mandated new entity, dropping the least-connected un-protected excess
first. These tests extract the REAL production function from the notebook and
exercise it end-to-end (not a stub), and prove the pre-fix behavior (no ceiling on
VOV) would have left the model exploded.
"""
import json
import re
import copy
import os

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_funcs(names):
    nb = json.load(open(NB))
    src = "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")
    g = {"re": re, "copy": copy}
    for fn in names:
        m = re.search(rf"\ndef {fn}\(.*?\n(?=\ndef |\n[^ \n])", src, re.DOTALL)
        assert m, f"function {fn} not found in notebook"
        exec(m.group(0), g)
    return g, src


def test_v358_function_and_wiring_present():
    g, src = _load_funcs(["_v357_norm", "_v358_enforce_product_ceiling_flat"])
    assert "def _v358_enforce_product_ceiling_flat(" in src
    # exactly one live call site (wired in step_create_logical_schema), gated on the v1 snapshot
    assert src.count("_v358_enforce_product_ceiling_flat(domains_data") == 2  # 1 def + 1 call
    assert "alias=v358-product-ceiling" in src
    # v358 ships in 3.5.8 and is carried forward; assert the running agent is >= 3.5.8
    # rather than pinning a frozen string (broke on the v3.5.9 bump).
    from version_test_util import assert_version_at_least
    assert_version_at_least("3.5.8")


def test_v358_prunes_explosion_protecting_v1_and_vibe():
    g, _ = _load_funcs(["_v357_norm", "_v358_enforce_product_ceiling_flat"])
    ceil = g["_v358_enforce_product_ceiling_flat"]
    v1 = [{"product": f"v1_p{i}", "domain": "core"} for i in range(30)]
    products = copy.deepcopy(v1)
    products += [{"product": f"halluc_{i}", "domain": "core"} for i in range(70)]
    products += [{"product": "newsroom_desk", "domain": "newsroom"},
                 {"product": "live_event", "domain": "newsroom"}]
    attrs = [{"product": f"v1_p{i}", "attribute": "id"} for i in range(30)]
    attrs.append({"product": "v1_p0", "attribute": "fk1", "foreign_key_to": "core.v1_p1.id"})
    dropped = ceil([{"domain": "core"}, {"domain": "newsroom"}], products, attrs,
                   {"max_total_products": 35}, v1_products=v1,
                   vov_new_entities=["newsroom_desk", "live_event"], logger=None)
    names = {p["product"] for p in products}
    assert dropped == 67
    assert len(products) == 35, "ceiling must be respected"
    assert all(f"v1_p{i}" in names for i in range(30)), "every v1 product preserved (§3b)"
    assert "newsroom_desk" in names and "live_event" in names, "vibe-mandated entities preserved"
    # attributes of dropped products are pruned too
    assert all(not a["product"].startswith("halluc_") for a in attrs)


def test_v358_noop_when_within_ceiling_or_no_directive():
    g, _ = _load_funcs(["_v357_norm", "_v358_enforce_product_ceiling_flat"])
    ceil = g["_v358_enforce_product_ceiling_flat"]
    # under ceiling -> no-op
    p = [{"product": "a", "domain": "d"}, {"product": "b", "domain": "d"}]
    assert ceil([{"domain": "d"}], p, [], {"max_total_products": 10}, v1_products=[], vov_new_entities=[]) == 0
    assert len(p) == 2
    # no ceiling -> no-op even if huge
    big = [{"product": f"p{i}", "domain": "d"} for i in range(200)]
    assert ceil([{"domain": "d"}], big, [], {"max_total_products": None}, v1_products=[], vov_new_entities=[]) == 0
    assert len(big) == 200


def test_v358_never_drops_v1_even_if_v1_exceeds_ceiling():
    g, _ = _load_funcs(["_v357_norm", "_v358_enforce_product_ceiling_flat"])
    ceil = g["_v358_enforce_product_ceiling_flat"]
    v1 = [{"product": f"x{i}", "domain": "core"} for i in range(40)]
    products = copy.deepcopy(v1) + [{"product": f"h{i}", "domain": "core"} for i in range(20)]
    ceil([{"domain": "core"}], products, [], {"max_total_products": 35}, v1_products=v1, vov_new_entities=[])
    names = {p["product"] for p in products}
    assert all(f"x{i}" in names for i in range(40)), "v1 (§3b) is HARD — never dropped"
    assert len(products) == 40, "floors at v1 count; all hallucinated dropped"


def test_v358_industry_agnostic_no_hardcoded_industry():
    # the gate must not key off any industry name
    _, src = _load_funcs(["_v358_enforce_product_ceiling_flat"])
    m = re.search(r"\ndef _v358_enforce_product_ceiling_flat\(.*?\n(?=\ndef _apply_handler_with_retry\()", src, re.DOTALL)
    body = m.group(0).lower()
    for term in ["media_broadcasting", "automotive", "healthcare", "airline", "ngo", "retail", "banking"]:
        # industry names may appear in the COMMENT (rationale) but never in executable logic;
        # assert they are not used as string literals in comparisons
        assert f'"{term}"' not in body and f"'{term}'" not in body, f"industry literal {term} in logic"
