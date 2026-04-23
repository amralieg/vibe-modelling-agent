"""Tests for candidate_evaluation helpers — v0.8.0."""
import pytest


def _load_classify():
    # _ce_classify_line_decision is NESTED in _is_link_excluded_by_candidate_eval.
    # We can't import it directly; test via the outer wrapper instead.
    from agent_helpers import _is_link_excluded_by_candidate_eval
    return _is_link_excluded_by_candidate_eval


class TestIsLinkExcludedByCandidateEval:
    def test_empty_ce_returns_false(self):
        fn = _load_classify()
        link = {"source_product":"order","source_attribute":"customer_id","target_product":"customer"}
        assert fn(link, "") is False

    def test_include_decision_returns_false(self):
        fn = _load_classify()
        link = {"source_product":"order","source_attribute":"customer_id","target_product":"customer"}
        ce = "order.customer_id → customer: INCLUDE — child→parent"
        assert fn(link, ce) is False

    def test_exclude_decision_returns_true(self):
        fn = _load_classify()
        link = {"source_product":"order","source_attribute":"customer_id","target_product":"customer"}
        ce = "order.customer_id → customer: EXCLUDE — already exists in EXISTING FK LINKS"
        assert fn(link, ce) is True

    def test_no_matching_line_returns_false(self):
        fn = _load_classify()
        link = {"source_product":"order","source_attribute":"customer_id","target_product":"customer"}
        ce = "invoice.payment_id → payment: INCLUDE"
        assert fn(link, ce) is False

    def test_both_include_and_exclude_include_wins(self):
        fn = _load_classify()
        link = {"source_product":"order","source_attribute":"customer_id","target_product":"customer"}
        ce = ("order.customer_id → customer: INCLUDE — correct\n"
              "order.customer_id → customer: EXCLUDE — wrong duplicate eval\n")
        # INCLUDE wins
        assert fn(link, ce) is False
