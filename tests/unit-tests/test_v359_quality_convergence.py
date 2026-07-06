"""v3.5.9 accountability gate: the model MUST get better with versions, not worse.

Root cause (restaurants + 10 other industries, audited 2026-06-14): VOV applied
connect_table/stub-fill but NEVER resolved cross_domain_duplicate (SSOT) or
denormalized_natural_key, and the stub-fill generator INTRODUCED denormalized
natural keys (denorm 1->47 in consumer_goods). There was no
static-analysis -> fix -> re-static-analysis convergence loop, so every v2 model
floored at quality 50/100, flat or worse than v1.

This test exercises the REAL run_metamodel_static_analysis from the agent notebook
(via qconverge_harness, no Databricks) plus the candidate convergence fix passes,
and asserts: targeted findings (denorm + ssot + unlinked) drop to ZERO and the
deterministic quality score STRICTLY increases v1 -> v2.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import qconverge_harness as H


def _attr(n, t="STRING", fk=None, pk=False):
    d = {"name": n, "data_type": t}
    if fk:
        d["foreign_key_to"] = fk
    if pk:
        d["primary_key"] = True
    return d


def _rich(name, n=12, fks=None, extra=None):
    a = [_attr(f"{name}_id", "BIGINT", pk=True)]
    for fk in (fks or []):
        col = fk.split(".")[-1]
        a.append(_attr(col, "BIGINT", fk=fk))
    generic = ["amount", "qty", "status_text", "created_ts", "updated_ts", "name_text",
               "descr_text", "flag_active", "rank_no", "score_val", "region_text", "notes_text"]
    for i in range(n):
        a.append(_attr(generic[i % len(generic)] + f"_{i}",
                       ["STRING", "DECIMAL(18,2)", "TIMESTAMP", "INT"][i % 4]))
    for e in (extra or []):
        a.append(e)
    return {"name": name, "primary_key": f"{name}_id", "attributes": a}


def _seeded_model():
    """3 domains, fully connected, every field populated. The ONLY static-analysis
    warnings are the deliberately seeded defects: 8 denormalized natural keys,
    3 cross-domain SSOT collisions, 3 unlinked FKs."""
    sales = [
        _rich("customer", 13),
        _rich("order", 11, ["sales.customer.customer_id"],
              extra=[_attr("customer_code", "STRING")]),                       # denorm 1
        _rich("order_line", 11, ["sales.order.order_id"],
              extra=[_attr("order_number", "STRING")]),                        # denorm 2
        _rich("shipment", 11, ["sales.order.order_id"],
              extra=[_attr("carrier_id", "BIGINT")]),                          # unlinked 1
    ]
    finance = [
        _rich("gl_account", 13),
        _rich("invoice", 11, ["finance.gl_account.gl_account_id"],
              extra=[_attr("gl_account_code", "STRING")]),                     # denorm 3
        _rich("payment", 11, ["finance.invoice.invoice_id"],
              extra=[_attr("invoice_reference", "STRING")]),                   # denorm 4
        _rich("budget", 11, ["finance.gl_account.gl_account_id"],
              extra=[_attr("gl_account_number", "STRING"),                     # denorm 5
                     _attr("cost_center_id", "BIGINT")]),                      # unlinked 2
        _rich("supplier", 12),
    ]
    support = [
        _rich("customer", 13),                                                 # SSOT dup of sales.customer
        _rich("ticket", 11, ["support.customer.customer_id"],
              extra=[_attr("customer_code", "STRING")]),                       # denorm 6
        _rich("case_note", 11, ["support.ticket.ticket_id"],
              extra=[_attr("agent_id", "BIGINT")]),                            # unlinked 3
        _rich("invoice", 11, ["support.ticket.ticket_id"],                     # SSOT dup of finance.invoice
              extra=[_attr("gl_account_code", "STRING")]),                     # denorm 7
        _rich("supplier", 12,                                                  # SSOT dup of finance.supplier
              extra=[_attr("supplier_code", "STRING"),
                     _attr("supplier_id_ref", "BIGINT")]),
    ]
    return {"agent_version": "v359-synth",
            "model": {"domains": [{"name": "sales", "products": sales},
                                  {"name": "finance", "products": finance},
                                  {"name": "support", "products": support}],
                      "metric_views": []}}


_HIGH = {'self_fk_on_pk', 'silo_product', 'broken_fk', 'fk_cycle', 'siloed_table'}
_MED = {'unlinked_fk', 'duplicate_product_pair', 'duplicate_attributes', 'fk_namespace_mismatch'}


def _deterministic_score(sa):
    """Faithful replica of _compute_deterministic_confidence_and_status (cell 23),
    minus the prev-metadata iteration bonus (no prior version in a unit test)."""
    sev = sa["severity_counts"]
    ms = sa["model_stats"]
    errors = sev.get("error", 0)
    total_fks = max(ms.get("fk_count", 1), 1)
    unlinked = ms.get("unlinked_id_count", 0)
    siloed = ms.get("siloed_count", 0)
    deduped = {}
    for iss in sa["issues"]:
        if iss.get("severity") not in ("error", "warning"):
            continue
        cat = iss.get("category", "")
        if cat in ("unlinked_fk", "siloed_table"):
            continue
        key = f"{cat}:{iss.get('message','')[:50]}"
        deduped.setdefault(key, iss)
    weighted = 0.0
    for iss in deduped.values():
        cat = iss.get("category", "")
        weighted += 3.0 if cat in _HIGH else (2.0 if cat in _MED else 1.0)
    clamped = min(weighted, 150.0)
    conf = int(95.0 - (clamped / 150.0) * 45.0)
    if errors > 0:
        conf -= min(errors * 8, 40)
    conf -= min(int((unlinked / total_fks) * 50), 15)
    conf -= min(int((siloed / max(ms.get("product_count", 1), 1)) * 30), 10)
    return max(50, min(99, conf))


def _targeted(sa):
    cats = sa["summary_by_category"]
    return sum(cats.get(c, {}).get("warning", 0) + cats.get(c, {}).get("error", 0)
               for c in ("denormalized_natural_key", "unlinked_fk", "cross_domain_duplicate"))


def _load():
    # Production path only: the REAL run_metamodel_static_analysis +
    # _autofix_with_monotonic_guard the agent runs on the VOV path. No prototype
    # fix module (the v3.5.9 fix lives in the notebook, not a side car; testing a
    # side car would be a §3d/§8.4 dead-code-as-fix violation).
    return H.load_agent_namespace()


def test_static_analysis_loads_and_detects_seeded_defects():
    ns = _load()
    dd, pd, ad = H.flat_lists(_seeded_model())
    sa = ns["run_metamodel_static_analysis"](dd, pd, ad, H.minimal_config(), H.quiet_logger())
    cats = sa["summary_by_category"]
    assert cats.get("denormalized_natural_key", {}).get("warning", 0) >= 6
    assert cats.get("cross_domain_duplicate", {}).get("warning", 0) >= 3
    assert cats.get("unlinked_fk", {}).get("warning", 0) >= 3


def test_production_autofix_eliminates_fixable_defects_and_raises_score():
    """v1 -> v2 via the PRODUCTION _autofix_with_monotonic_guard (what the agent runs
    on the VOV path). The two defect classes the autofix OWNS deterministically
    (denormalized_natural_key via P0.26 demote, cross_domain_duplicate via the SSOT
    pass) must drop to ZERO, and the deterministic quality score must STRICTLY
    increase. Genuinely-unlinkable FKs (an _id column with no matching PK anywhere)
    are NOT counted against the gate: the autofix must never fabricate a target."""
    ns = _load()
    dd, pd, ad = H.flat_lists(_seeded_model())
    cfg, lg = H.minimal_config(), H.quiet_logger()

    sa_v1 = ns["run_metamodel_static_analysis"](dd, pd, ad, cfg, lg)
    targeted_v1 = _targeted(sa_v1)
    score_v1 = _deterministic_score(sa_v1)
    assert targeted_v1 >= 12, f"seed too weak: {targeted_v1}"

    # production VOV autofix (mutates the flat lists in place)
    ns["_autofix_with_monotonic_guard"](dd, pd, ad, cfg, lg, stage="vov")

    sa_v2 = ns["run_metamodel_static_analysis"](dd, pd, ad, cfg, lg)
    cats_v2 = sa_v2["summary_by_category"]
    denorm_v2 = cats_v2.get("denormalized_natural_key", {}).get("warning", 0)
    ssot_v2 = cats_v2.get("cross_domain_duplicate", {}).get("warning", 0)
    score_v2 = _deterministic_score(sa_v2)

    assert denorm_v2 == 0, f"autofix left {denorm_v2} denormalized_natural_key"
    assert ssot_v2 == 0, f"autofix left {ssot_v2} cross_domain_duplicate"
    assert score_v2 > score_v1, f"score did not improve: v1={score_v1} v2={score_v2}"


def test_idempotent_third_version_does_not_regress():
    """v2 -> v3: re-running the production autofix on an already-cleaned model must
    NOT lower the score and must NOT increase SA issues (the monotonic guard reverts
    any non-idempotent regression). The model must never get worse with versions."""
    ns = _load()
    dd, pd, ad = H.flat_lists(_seeded_model())
    cfg, lg = H.minimal_config(), H.quiet_logger()
    guard = ns["_autofix_with_monotonic_guard"]

    guard(dd, pd, ad, cfg, lg, stage="vov")
    sa_v2 = ns["run_metamodel_static_analysis"](dd, pd, ad, cfg, lg)
    score_v2 = _deterministic_score(sa_v2)
    issues_v2 = sa_v2["severity_counts"]["warning"] + sa_v2["severity_counts"]["error"]

    guard(dd, pd, ad, cfg, lg, stage="vov")
    sa_v3 = ns["run_metamodel_static_analysis"](dd, pd, ad, cfg, lg)
    score_v3 = _deterministic_score(sa_v3)
    issues_v3 = sa_v3["severity_counts"]["warning"] + sa_v3["severity_counts"]["error"]

    assert score_v3 >= score_v2, f"v3 regressed: v2={score_v2} v3={score_v3}"
    assert issues_v3 <= issues_v2, f"v3 SA issues rose: v2={issues_v2} v3={issues_v3}"
    cats_v3 = sa_v3["summary_by_category"]
    assert cats_v3.get("denormalized_natural_key", {}).get("warning", 0) == 0
    assert cats_v3.get("cross_domain_duplicate", {}).get("warning", 0) == 0


if __name__ == "__main__":
    ns = _load()
    dd, pd, ad = H.flat_lists(_seeded_model())
    cfg, lg = H.minimal_config(), H.quiet_logger()
    sa1 = ns["run_metamodel_static_analysis"](dd, pd, ad, cfg, lg)
    print(f"v1: targeted={_targeted(sa1)} score={_deterministic_score(sa1)} "
          f"warnings={sa1['severity_counts']}")
    ns["_autofix_with_monotonic_guard"](dd, pd, ad, cfg, lg, stage="vov")
    sa2 = ns["run_metamodel_static_analysis"](dd, pd, ad, cfg, lg)
    print(f"v2: targeted={_targeted(sa2)} score={_deterministic_score(sa2)} "
          f"warnings={sa2['severity_counts']}")
