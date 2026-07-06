import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "runner"))
import vov_groundtruth_audit as A


def test_tier_promotion_is_unverifiable():
    v2pd = {"scada_tag": "treatment"}
    v2pa = {"scada_tag": {}}
    for nd in ["mvm", "mvm_tier", "ecm", "ecm_tier", "metric_view_model"]:
        status, _ = A.verify(
            {"action": "move_product", "product": "scada_tag", "new_domain": nd},
            v2pd, v2pa, set())
        assert status == "unverifiable", (nd, status)


def test_real_domain_move_still_scored():
    status, _ = A.verify(
        {"action": "move_product", "product": "lien_waiver", "new_domain": "finance"},
        {"lien_waiver": "bid"}, {"lien_waiver": {}}, set())
    assert status == "missed"
    status, _ = A.verify(
        {"action": "move_product", "product": "lien_waiver", "new_domain": "finance"},
        {"lien_waiver": "finance"}, {"lien_waiver": {}}, set())
    assert status == "fulfilled"


def test_is_tier_target_helper():
    assert A._is_tier_target("mvm")
    assert A._is_tier_target("mvm_tier")
    assert not A._is_tier_target("finance")
    assert not A._is_tier_target("contract")
    assert not A._is_tier_target("")
