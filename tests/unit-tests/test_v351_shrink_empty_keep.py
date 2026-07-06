"""v3.5.1 — shrink empty-keep fallback.

Root cause fixed: the deterministic FK-densest survivor picker existed but was
reachable ONLY through the `if _new_silos:` orphan-drop branch. When the LLM shrink
plan returned an empty `tables_to_keep` (degenerate output, or all-phantom product
names dropped by phantom-drop), no NEW silos existed to drop, so the picker never
fired and `_run_resize_model` aborted at the empty-model gate
("Shrink produced an empty model (0 domains, 0 products)").

Fix: extract the picker to a single module-level `_shrink_fk_densest_pick` (DRY,
replacing two copy-pasted inline blocks) and call it UNCONDITIONALLY whenever
`tables_to_keep` is empty, before survivors are built.
"""
from __future__ import annotations

import re

from notebook_source_util import notebook_concat_source, exec_function_namespace


def _picker():
    ns = exec_function_namespace("_shrink_fk_densest_pick")
    return ns["_shrink_fk_densest_pick"]


def _model_with_fks():
    products = [
        {"domain": "sales", "product": "order"},
        {"domain": "sales", "product": "order_line"},
        {"domain": "sales", "product": "customer"},
        {"domain": "ops", "product": "shipment"},
        {"domain": "ref", "product": "country"},  # zero-degree island
    ]
    attrs = [
        {"product": "order_line", "foreign_key_to": "sales.order.order_id"},
        {"product": "order", "foreign_key_to": "sales.customer.customer_id"},
        {"product": "shipment", "foreign_key_to": "sales.order.order_id"},
    ]
    return products, attrs


def test_picker_returns_top_fk_dense_survivors():
    pick = _picker()
    products, attrs = _model_with_fks()
    got = pick(products, attrs, 3)
    assert len(got) == 3
    names = {p for (_d, p) in got}
    # order has the highest degree (out:1 to customer, in:2 from order_line+shipment) -> must be kept
    assert "order" in names
    # the zero-degree island must NOT win over FK-connected products at target_size=3
    assert "country" not in names


def test_picker_non_empty_even_without_any_fks():
    """Degree-0 source must still yield survivors (never empty) so the MVM is non-empty."""
    pick = _picker()
    products = [
        {"domain": "a", "product": "p1"},
        {"domain": "a", "product": "p2"},
        {"domain": "b", "product": "p3"},
    ]
    got = pick(products, [], 5)
    assert len(got) == 3  # all kept (target exceeds count), none dropped to empty


def test_picker_empty_source_returns_empty():
    pick = _picker()
    assert pick([], [], 3) == []
    assert pick(None, None, 3) == []


def test_picker_respects_target_size():
    pick = _picker()
    products, attrs = _model_with_fks()
    got = pick(products, attrs, 2)
    assert len(got) == 2


def test_unconditional_empty_keep_fallback_present_and_ordered():
    """Structural proof the reachability gap is closed: the unconditional empty-keep
    fallback must call the picker BEFORE survivors are built, NOT only under _new_silos."""
    src = notebook_concat_source()
    assert "shrink-empty-keep-fallback FIRED" in src
    # the empty-keep guard exists
    guard = src.index("alias=shrink-empty-keep-fallback")
    # it must precede the surviving_products build in the shrink path
    surv = src.index("surviving_products = []\n            for p in products_data:")
    assert guard < surv, "empty-keep fallback must run before surviving_products is built"
    # and the block is a bare `if not tables_to_keep:` (unconditional), then picker call
    block = src[src.index("[shrink-empty-keep-fallback]"):surv]
    assert "if not tables_to_keep:" in block
    assert "_shrink_fk_densest_pick(products_data, attributes_data, _ekf_target)" in block


def test_dry_inline_fk_density_copies_removed():
    """The two copy-pasted inline FK-density loops must be gone (replaced by the helper)."""
    src = notebook_concat_source()
    assert "_v74_fk_count = {" not in src
    assert "_v74_fk_count2 = {" not in src
    # both recovery paths now call the shared helper
    assert src.count("_shrink_fk_densest_pick(products_data, attributes_data, _v74_target_size)") == 1
    assert src.count("_shrink_fk_densest_pick(products_data, attributes_data, _v74_target_size2)") == 1


def test_agent_version_is_351():
    import re
    src = notebook_concat_source()
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', src)
    assert m and tuple(int(x) for x in m.groups()) >= (3, 5, 1)
