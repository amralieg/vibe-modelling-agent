import copy
import json
import logging
from pathlib import Path

import pytest

import agent_helpers as ah

REPO = Path(__file__).resolve().parents[2]
PRE = Path("/tmp/agent_pre_v400.ipynb")  # v3.9.9 backup (pre-parallel SelfFixer)

LOG = logging.getLogger("v400test")
LOG.addHandler(logging.NullHandler())


def base_model():
    return {"model": {"domains": [
        {"name": "sales", "products": [
            {"product": "order", "primary_key": "order_id", "attributes": [
                {"name": "order_id", "is_primary_key": True, "data_type": "BIGINT"},
                {"name": "customer_id", "data_type": "BIGINT", "foreign_key_to": "sales.customer.customer_id"},
            ]},
            {"product": "customer", "primary_key": "customer_id", "attributes": [
                {"name": "customer_id", "is_primary_key": True, "data_type": "BIGINT"},
                {"name": "email", "data_type": "STRING"},
            ]},
        ]},
        {"name": "ops", "products": [
            {"product": "shipment", "primary_key": "shipment_id", "attributes": [
                {"name": "shipment_id", "is_primary_key": True, "data_type": "BIGINT"},
                {"name": "order_id", "data_type": "BIGINT", "foreign_key_to": "sales.order.order_id"},
            ]},
        ]},
    ]}}


def _find_prod(model, dom, prod):
    for d in model["model"]["domains"]:
        if d["name"] == dom:
            for p in d.get("products", []):
                if (p.get("product") or p.get("name")) == prod:
                    return p
    return None


def _find_attr(p, name):
    for a in p["attributes"]:
        if a["name"] == name:
            return a
    return None


# ---- scripted candidate actions (mutate the deepcopy `work`, return (ok, applied, evidence)) ----

def act_tag(dom, prod, attr, tag):
    # write a STRING field (description) so the real schema-string guard is satisfied;
    # exercises a realistic per-attribute SelfFixer change scoped to one product.
    def a(model, req=None, per_req_retries=2):
        at = _find_attr(_find_prod(model, dom, prod), attr)
        at["description"] = "desc-" + tag
        return True, True, "applied"
    return a


def act_dangling_fk(dom, prod):
    def a(model, req=None, per_req_retries=2):
        _find_prod(model, dom, prod)["attributes"].append(
            {"name": "ghost_id", "data_type": "BIGINT", "foreign_key_to": "nowhere.ghost.ghost_id"}
        )
        return True, True, "applied"
    return a


def act_rename(dom, old, new):
    def a(model, req=None, per_req_retries=2):
        _find_prod(model, dom, old)["product"] = new
        return True, True, "applied"
    return a


def act_noop():
    def a(model, req=None, per_req_retries=2):
        return True, True, "applied"  # verifier "ok" but model unchanged
    return a


def act_fail():
    def a(model, req=None, per_req_retries=2):
        return False, False, "sandbox_or_verifier_failed"
    return a


def make_sf(plan):
    sf = ah.SelfFixer(ai_agent=None, logger=LOG, sandbox_executor=None)

    def fake_fix_one(model, req, per_req_retries=2):
        return plan[req["id"]](model, req, per_req_retries)

    sf._fix_one_req = fake_fix_one
    return sf


def reqs(*ids):
    return [{"id": i, "text": "", "evidence": ""} for i in ids]


@pytest.fixture(autouse=True)
def _pool():
    # enable the global pool so the parallel path engages, reset cleanly after each test
    ah.shutdown_global_llm_pool(wait=False)
    ah._GLOBAL_LLM_POOL["size"] = 0
    ah._GLOBAL_LLM_POOL["pool"] = None
    ah._set_global_llm_pool_size(8)
    yield
    ah.shutdown_global_llm_pool(wait=False)
    ah._GLOBAL_LLM_POOL["size"] = 0
    ah._GLOBAL_LLM_POOL["pool"] = None


# ============================ unit: scope classifier ============================

def test_changed_scopes_identical_is_empty():
    m = base_model()
    assert ah._selffixer_changed_scopes(m, copy.deepcopy(m)) == set()


def test_changed_scopes_attr_change_is_product_scoped():
    base = base_model()
    new = copy.deepcopy(base)
    _find_attr(_find_prod(new, "sales", "order"), "customer_id")["tags"] = ["pii"]
    assert ah._selffixer_changed_scopes(base, new) == {"sales::order"}


def test_changed_scopes_product_rename_is_global():
    base = base_model()
    new = copy.deepcopy(base)
    _find_prod(new, "sales", "order")["product"] = "sales_order"
    assert ah._selffixer_changed_scopes(base, new) == {"__GLOBAL__"}


def test_changed_scopes_model_level_change_is_global():
    base = base_model()
    new = copy.deepcopy(base)
    new["model"]["metric_views"] = [{"name": "rev"}]
    assert ah._selffixer_changed_scopes(base, new) == {"__GLOBAL__"}


# ============================ unit: graft + restore ============================

def test_graft_and_restore_roundtrip():
    live = base_model()
    new = copy.deepcopy(live)
    _find_attr(_find_prod(new, "ops", "shipment"), "order_id")["tags"] = ["fk"]
    saved = ah._selffixer_graft_scopes(live, new, {"ops::shipment"})
    assert saved, "graft should report what it replaced"
    assert _find_attr(_find_prod(live, "ops", "shipment"), "order_id").get("tags") == ["fk"]
    ah._selffixer_restore_scopes(live, saved)
    assert "tags" not in _find_attr(_find_prod(live, "ops", "shipment"), "order_id")


# ============================ behavioral: parallel round ============================

def test_disjoint_fixes_both_commit_one_round():
    sf = make_sf({
        "A": act_tag("sales", "order", "customer_id", "labelA"),
        "B": act_tag("ops", "shipment", "order_id", "labelB"),
    })
    model = base_model()
    res = sf.fix_all_unfulfilled(model, reqs("A", "B"), max_rounds=5, per_req_retries=0)
    assert res["fixed_count"] == 2, res
    # disjoint scopes must BOTH commit in the first compute round -> each attempted exactly once
    assert res["per_req_results"]["A"]["rounds_attempted"] == 1, res
    assert res["per_req_results"]["B"]["rounds_attempted"] == 1, res
    assert _find_attr(_find_prod(model, "sales", "order"), "customer_id")["description"] == "desc-labelA"
    assert _find_attr(_find_prod(model, "ops", "shipment"), "order_id")["description"] == "desc-labelB"


def test_overlapping_fixes_serialize_across_rounds():
    sf = make_sf({
        "A": act_tag("sales", "order", "order_id", "labelA"),
        "B": act_tag("sales", "order", "customer_id", "labelB"),
    })
    model = base_model()
    res = sf.fix_all_unfulfilled(model, reqs("A", "B"), max_rounds=5, per_req_retries=0)
    assert res["fixed_count"] == 2, res
    assert res["rounds"] >= 2, "same-product scopes must not both commit in one round"
    assert _find_attr(_find_prod(model, "sales", "order"), "order_id")["description"] == "desc-labelA"
    assert _find_attr(_find_prod(model, "sales", "order"), "customer_id")["description"] == "desc-labelB"


def test_regression_candidate_rolled_back_and_not_counted():
    sf = make_sf({"A": act_dangling_fk("sales", "order")})
    model = base_model()
    res = sf.fix_all_unfulfilled(model, reqs("A"), max_rounds=3, per_req_retries=0)
    assert res["fixed_count"] == 0, "a fix that adds a dangling FK must be rejected"
    # rollback must have removed the ghost attribute from the live model
    assert all(a["name"] != "ghost_id" for a in _find_prod(model, "sales", "order")["attributes"])


def test_noop_candidate_not_counted():
    sf = make_sf({"A": act_noop()})
    model = base_model()
    res = sf.fix_all_unfulfilled(model, reqs("A"), max_rounds=2, per_req_retries=0)
    assert res["fixed_count"] == 0
    assert res["per_req_results"]["A"]["fixed"] is False


def test_global_change_serializes_with_scoped():
    sf = make_sf({
        "A": act_rename("sales", "order", "sales_order"),   # structural -> GLOBAL
        "B": act_tag("ops", "shipment", "order_id", "labelB"),
    })
    model = base_model()
    res = sf.fix_all_unfulfilled(model, reqs("A", "B"), max_rounds=5, per_req_retries=0)
    assert res["fixed_count"] == 2, res
    assert res["rounds"] >= 2, "a global change cannot share a round with another commit"


def test_failed_candidate_requeues_then_can_be_skipped():
    sf = make_sf({"A": act_fail(), "B": act_tag("ops", "shipment", "order_id", "x")})
    model = base_model()
    res = sf.fix_all_unfulfilled(model, reqs("A", "B"), max_rounds=3, per_req_retries=0)
    assert res["per_req_results"]["B"]["fixed"] is True
    assert res["per_req_results"]["A"]["fixed"] is False


# ============================ serial fallback ============================

def test_serial_path_when_pool_disabled():
    ah.shutdown_global_llm_pool(wait=False)
    ah._GLOBAL_LLM_POOL["size"] = 0
    ah._GLOBAL_LLM_POOL["pool"] = None
    sf = make_sf({
        "A": act_tag("sales", "order", "customer_id", "labelA"),
        "B": act_tag("ops", "shipment", "order_id", "labelB"),
    })
    assert sf._selffixer_parallel_enabled() is False
    model = base_model()
    res = sf.fix_all_unfulfilled(model, reqs("A", "B"), max_rounds=5, per_req_retries=0)
    assert res["fixed_count"] == 2
    assert _find_attr(_find_prod(model, "sales", "order"), "customer_id")["description"] == "desc-labelA"


def test_parallel_enabled_true_when_pool_live():
    sf = make_sf({})
    assert sf._selffixer_parallel_enabled() is True


# ============================ fail-pre + version ============================

def _concat(p):
    nb = json.loads(Path(p).read_text(encoding="utf-8"))
    return "\n".join("".join(c["source"]) if isinstance(c["source"], list) else c["source"]
                     for c in nb.get("cells", []) if c.get("cell_type") == "code")


def test_fail_pre_parallel_absent_in_v399():
    if not PRE.exists():
        pytest.skip("pre-v400 backup not present")
    pre = _concat(PRE)
    assert "_fix_round_parallel" not in pre
    assert "_selffixer_changed_scopes" not in pre
    assert "selffixer-parallel-round" not in pre


def test_version_bumped_to_400():
    nb = REPO / "agent" / "dbx_vibe_modelling_agent.ipynb"
    assert '__AGENT_VERSION__ = "4.0.0"' in _concat(nb)
