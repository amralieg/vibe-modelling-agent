"""v3.5.9 behavioral tests for the agent-side autofix fixes surfaced by the
restaurants VOV audit (2026-06-14). These exercise the REAL
_pre_static_analysis_autofix + run_metamodel_static_analysis from the notebook
(via qconverge_harness, no Databricks) and assert the three root-cause fixes
hold. Each test is designed to FAIL on pre-patch HEAD:

  ISSUE 1 self-ref-preserve-correct-target: a labeled self-ref whose column uses
     a SHORTER stem than the PK (comparative_prior_period_id vs financial_period_id)
     was stripped -> became unlinked_fk. Must now be preserved.
  ISSUE 2 p074-pk-attr-sync: P0.74 qualify-rename set product.primary_key to the
     qualified form but left the PK attribute under the old name -> pk_attribute_missing
     error. Must now reconcile (0 errors).
  ISSUE 3 ssot-distinct-stemkey: _v291 marks a low-overlap cross-domain pair
     distinct, then P0.74 renames one side -> the exact-product distinct key went
     stale and SA re-flagged cross_domain_duplicate. The stem+domains key must
     survive the rename (0 cross_domain_duplicate).
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import qconverge_harness as H
import version_test_util as V


def _agent_text():
    p = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                     "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")
    with open(p, "r") as f:
        return f.read()


def test_v359_version_and_aliases_present():
    txt = _agent_text()
    # v3.5.9 introduced these aliases; carried forward. The running constant has
    # advanced past 3.5.9 (>= because each later patch bumps it), so assert the
    # floor rather than pinning an exact frozen string.
    V.assert_version_at_least("3.5.9", txt)
    V.assert_aliases_present(txt, [
        "vov-run-autofix-default",
        "autofix-monotonic-guard",
        "next-vibes-fresh-sa",
        "unlinked-fk-deterministic-relink",
        "self-ref-preserve-correct-target",
        "p074-pk-attr-sync",
        "ssot-distinct-stemkey",
    ])


def _attr(n, t="STRING", fk=None, pk=False):
    d = {"name": n, "data_type": t}
    if fk:
        d["foreign_key_to"] = fk
    if pk:
        d["primary_key"] = True
    return d


def _biz(prefix, n):
    out = []
    pool = ["amount", "qty", "status_text", "name_text", "descr_text",
            "flag_active", "rank_no", "score_val", "region_text", "notes_text"]
    for i in range(n):
        out.append(_attr(f"{prefix}_{pool[i % len(pool)]}_{i}",
                         ["STRING", "DECIMAL(18,2)", "TIMESTAMP", "INT"][i % 4]))
    return out


def _model():
    # finance.financial_period: a valid LABELED self-ref whose column uses a
    # shorter stem ('period') than the PK ('financial_period_id').
    financial_period = {
        "name": "financial_period", "primary_key": "financial_period_id",
        "attributes": [
            _attr("financial_period_id", "BIGINT", pk=True),
            _attr("comparative_prior_period_id", "BIGINT",
                  fk="finance.financial_period.financial_period_id"),
        ] + _biz("fp", 12),
    }
    # restaurant.department and workforce.department: same stem 'department',
    # LOW business-attribute overlap (distinct prefixes) so _v291 marks them
    # distinct; P0.74 then qualifies workforce.department -> workforce_department.
    rest_dept = {
        "name": "department", "primary_key": "department_id",
        "attributes": [_attr("department_id", "BIGINT", pk=True)] + _biz("rest", 9),
    }
    wf_dept = {
        "name": "department", "primary_key": "department_id",
        "attributes": [_attr("department_id", "BIGINT", pk=True),
                       _attr("parent_department_id", "BIGINT",
                             fk="workforce.department.department_id")] + _biz("wf", 9),
    }
    return {"agent_version": "v359-autofix-test",
            "model": {"domains": [
                {"name": "finance", "products": [financial_period]},
                {"name": "restaurant", "products": [rest_dept]},
                {"name": "workforce", "products": [wf_dept]},
            ], "metric_views": []}}


def _cat(sa, name):
    c = sa["summary_by_category"].get(name, {})
    return c.get("warning", 0) + c.get("error", 0)


def _run():
    ns = H.load_agent_namespace()
    dd, pd, ad = H.flat_lists(_model())
    cfg, lg = H.minimal_config(), H.quiet_logger()
    ns["_pre_static_analysis_autofix"](dd, pd, ad, cfg, lg)
    sa = ns["run_metamodel_static_analysis"](dd, pd, ad, cfg, lg)
    return dd, pd, ad, sa


def test_labeled_self_ref_shorter_stem_is_preserved_not_stripped():
    dd, pd, ad, sa = _run()
    # The labeled self-ref must be PRESERVED as a self-referencing FK on
    # financial_period pointing at its own PK. A later canonical-naming pass may
    # rename the column (comparative_prior_period_id ->
    # comparative_prior_period_financial_period_id), so match by relationship,
    # not by the original column name. Pre-patch HEAD STRIPPED the FK entirely
    # (became unlinked), so this list would be empty.
    sref = [a for a in ad
            if a.get("domain") == "finance" and a.get("product") == "financial_period"
            and (a.get("foreign_key_to") or "").strip()
            and not a.get("primary_key")
            and (a.get("foreign_key_to") or "").strip().endswith("financial_period_id")]
    assert sref, "labeled self-ref FK was stripped/removed (regression)"
    # it must NOT be reported as an unlinked FK
    assert _cat(sa, "unlinked_fk") == 0, \
        [i["message"] for i in sa["issues"] if i.get("category") == "unlinked_fk"]


def test_p074_qualify_rename_does_not_orphan_primary_key():
    dd, pd, ad, sa = _run()
    assert sa["severity_counts"].get("error", 0) == 0, \
        [i["message"] for i in sa["issues"] if i.get("severity") == "error"]
    # every product's declared PK must have a matching attribute
    names = {(a.get("domain"), a.get("product")): set() for a in ad}
    for a in ad:
        names[(a.get("domain"), a.get("product"))].add((a.get("attribute") or "").lower())
    for p in pd:
        pk = (p.get("primary_key") or "").lower()
        key = (p.get("domain"), p.get("product"))
        assert pk in names.get(key, set()), f"orphaned PK {pk} on {key}"


def test_ssot_distinct_pair_survives_p074_rename():
    dd, pd, ad, sa = _run()
    assert _cat(sa, "cross_domain_duplicate") == 0, \
        [i["message"] for i in sa["issues"] if i.get("category") == "cross_domain_duplicate"]


def _relink_model():
    # supplier.contract.supplier_id -> a UNIQUE clean target supplier.supplier (no
    # reverse edge) MUST be linked. order.line.product_id where product already links
    # back to order.line (a reverse edge exists) MUST be deferred (would cycle).
    supplier = {"name": "supplier", "primary_key": "supplier_id",
                "attributes": [_attr("supplier_id", "BIGINT", pk=True)] + _biz("sup", 8)}
    contract = {"name": "contract", "primary_key": "contract_id",
                "attributes": [_attr("contract_id", "BIGINT", pk=True),
                               _attr("supplier_id", "BIGINT")] + _biz("con", 8)}
    # cycle case: product links to line (product.line_id), and line has unlinked
    # product_id -> linking it would close line<->product cycle.
    product = {"name": "product", "primary_key": "product_id",
               "attributes": [_attr("product_id", "BIGINT", pk=True),
                              _attr("line_id", "BIGINT", fk="sales.line.line_id")] + _biz("prd", 8)}
    line = {"name": "line", "primary_key": "line_id",
            "attributes": [_attr("line_id", "BIGINT", pk=True),
                           _attr("product_id", "BIGINT")] + _biz("ln", 8)}
    return {"agent_version": "v359-relink-test",
            "model": {"domains": [
                {"name": "procurement", "products": [supplier, contract]},
                {"name": "sales", "products": [product, line]},
            ], "metric_views": []}}


def test_unlinked_fk_deterministic_relink_links_clean_defers_cyclic():
    ns = H.load_agent_namespace()
    dd, pd, ad = H.flat_lists(_relink_model())
    cfg, lg = H.minimal_config(), H.quiet_logger()
    ns["_pre_static_analysis_autofix"](dd, pd, ad, cfg, lg)
    # clean target: contract.supplier_id MUST be linked to procurement.supplier
    contract_fk = [a for a in ad if a.get("domain") == "procurement"
                   and a.get("product") == "contract" and a.get("attribute") == "supplier_id"]
    assert contract_fk and (contract_fk[0].get("foreign_key_to") or "").endswith("supplier.supplier_id"), \
        ("clean unlinked FK was not relinked", contract_fk)
    # cyclic target: sales.line.product_id MUST remain unlinked (no cycle introduced)
    sa = ns["run_metamodel_static_analysis"](dd, pd, ad, cfg, lg)
    assert _cat(sa, "fk_cycle") == 0, \
        [i["message"] for i in sa["issues"] if i.get("category") == "fk_cycle"]


def test_monotonic_guard_never_increases_sa_issues():
    # ISSUE 4 autofix-monotonic-guard: the pre-SA autofix is not idempotent on
    # every input (restaurants v2: a 2nd raw pass exploded multi_fk_missing_label
    # 18->152). The guard wrapper must guarantee post-SA issue count <= pre-SA,
    # AND a repeated guarded pass must never increase issues. Pre-patch HEAD has
    # no guard helper at all, so this fails (KeyError) on HEAD.
    ns = H.load_agent_namespace()
    assert "_autofix_with_monotonic_guard" in ns
    dd, pd, ad = H.flat_lists(_model())
    cfg, lg = H.minimal_config(), H.quiet_logger()

    def issues():
        sa = ns["run_metamodel_static_analysis"](dd, pd, ad, cfg, lg)
        return sa["severity_counts"].get("warning", 0) + sa["severity_counts"].get("error", 0)

    pre = issues()
    ns["_autofix_with_monotonic_guard"](dd, pd, ad, cfg, lg, stage="test")
    post1 = issues()
    assert post1 <= pre, f"guard increased SA issues {pre}->{post1}"
    ns["_autofix_with_monotonic_guard"](dd, pd, ad, cfg, lg, stage="test2")
    post2 = issues()
    assert post2 <= post1, f"repeated guarded pass increased SA issues {post1}->{post2}"


if __name__ == "__main__":
    dd, pd, ad, sa = _run()
    print("errors:", sa["severity_counts"].get("error", 0))
    print("cross_domain_duplicate:", _cat(sa, "cross_domain_duplicate"))
    print("unlinked_fk:", _cat(sa, "unlinked_fk"))
    print("self_referencing_fk:", _cat(sa, "self_referencing_fk"))
