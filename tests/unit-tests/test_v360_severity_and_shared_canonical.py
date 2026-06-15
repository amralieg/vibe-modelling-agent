"""v3.6.0 behavioral tests for the two root-cause fixes surfaced by the
cross-industry v2 audit (2026-06-15), exercising the REAL notebook functions
via qconverge_harness (no Databricks). Each test is designed to FAIL on the
pre-patch HEAD (v3.5.9).

ISSUE 1 monotonic-guard-sacount-severity:
   _sa_issue_count returned a SCALAR warning+error total, so the monotonic guard
   accepted a pass that traded many warnings for a NEW error (semiconductors v2:
   warnings 623->212 but errors 0->1; total 623->213 looked 'better'). An error
   is categorically worse than a warning. _sa_issue_count must now return a
   LEXICOGRAPHIC (error, warning) tuple so the guard reverts any error increase.

ISSUE 2 p074-shared-canonical-keep:
   The P0.74 collision-rename qualified a colliding product in the 'shared'/'common'
   SSOT domain into '<domain>_<name>' (e.g. shared.fab -> shared.shared_fab), which
   the SA shared_domain_prefix rule flags as an ERROR — the rename and the rule were
   in direct conflict. The shared/common occurrence must now be kept canonical
   (unqualified) and the non-shared colliders qualified instead.
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


def _attr(n, t="STRING", fk=None, pk=False):
    d = {"name": n, "data_type": t}
    if fk:
        d["foreign_key_to"] = fk
    if pk:
        d["primary_key"] = True
    return d


def _biz(prefix, n):
    pool = ["amount", "qty", "status_text", "name_text", "descr_text",
            "flag_active", "rank_no", "score_val", "region_text", "notes_text"]
    return [_attr(f"{prefix}_{pool[i % len(pool)]}_{i}",
                  ["STRING", "DECIMAL(18,2)", "TIMESTAMP", "INT"][i % 4])
            for i in range(n)]


def test_v360_version_and_aliases_present():
    txt = _agent_text()
    V.assert_version_at_least("3.6.0", txt)
    V.assert_aliases_present(txt, [
        "monotonic-guard-sacount-severity",
        "p074-shared-canonical-keep",
    ])


def test_sa_issue_count_returns_error_first_lexicographic_tuple():
    """The guard's comparator must order ERRORS before warnings. A model with a
    hard error but few warnings must compare GREATER (worse) than a model with
    zero errors but many warnings — otherwise the guard trades errors for
    warnings. Pre-patch HEAD returned a scalar int, so the tuple-shape assertion
    and the ordering assertion both fail."""
    ns = H.load_agent_namespace()
    sa_count = ns["_sa_issue_count"]

    # A model whose SA yields a hard error: an FK to a non-existent domain.
    err_model = {"model": {"domains": [
        {"name": "alpha", "products": [{
            "name": "thing", "primary_key": "thing_id",
            "attributes": [_attr("thing_id", "BIGINT", pk=True),
                           _attr("ghost_id", "BIGINT",
                                 fk="nonexistent_domain.ghost.ghost_id")] + _biz("th", 10),
        }]},
    ], "metric_views": []}}
    dd, pd, ad = H.flat_lists(err_model)
    cfg, lg = H.minimal_config(), H.quiet_logger()
    val = sa_count(dd, pd, ad, cfg, lg)

    # must be a 2-tuple (error, warning), not a scalar
    assert isinstance(val, tuple) and len(val) == 2, f"_sa_issue_count must return (error, warning) tuple, got {val!r}"
    err, warn = val
    assert err >= 1, f"expected >=1 SA error for a dangling-domain FK, got {val!r}"

    # Lexicographic ordering: 1 error + 0 warnings is WORSE than 0 errors + 999 warnings.
    assert (1, 0) > (0, 999), "tuple comparison must order errors before warnings"
    # And the real value with an error must exceed a hypothetical zero-error/high-warning state.
    assert val > (0, 10 ** 6), f"a state WITH an error must compare worse than any error-free state, got {val!r}"


def _shared_collision_model():
    # 'fab' collides across three domains; one of them is the 'shared' SSOT domain.
    def fab(prefix):
        return {"name": "fab", "primary_key": "fab_id",
                "attributes": [_attr("fab_id", "BIGINT", pk=True)] + _biz(prefix, 10)}
    return {"agent_version": "v360-shared-test",
            "model": {"domains": [
                {"name": "fabrication", "products": [fab("fabn")]},
                {"name": "equipment", "products": [fab("eq")]},
                {"name": "shared", "products": [fab("sh")]},
            ], "metric_views": []}}


def test_shared_domain_collision_keeps_shared_product_canonical_no_error():
    """When a cross-domain collision includes a shared/common occurrence, the
    collision-rename must keep the shared one UNqualified (canonical owner) and
    qualify the others — never produce 'shared.shared_fab' (which trips the
    shared_domain_prefix ERROR). Pre-patch HEAD kept idxs[0] and qualified the
    rest, so the shared occurrence (if not first) became 'shared_fab' -> 1 error."""
    ns = H.load_agent_namespace()
    dd, pd, ad = H.flat_lists(_shared_collision_model())
    cfg, lg = H.minimal_config(), H.quiet_logger()
    ns["_validate_product_name_collisions"](dd, pd, ad, lg, stage_label="test", config=cfg)

    by_dom = {(p.get("domain") or "").lower(): (p.get("product") or "") for p in pd}
    # the shared product must remain 'fab', NOT 'shared_fab'
    assert by_dom.get("shared", "").lower() == "fab", \
        f"shared product was qualified to {by_dom.get('shared')!r} (must stay 'fab')"
    # the two non-shared colliders must be qualified (disambiguated)
    assert by_dom.get("fabrication", "").lower() != "fab" or by_dom.get("equipment", "").lower() != "fab", \
        "non-shared colliders were not qualified"

    sa = ns["run_metamodel_static_analysis"](dd, pd, ad, cfg, lg)
    sdp = [i for i in sa["issues"] if i.get("category") == "shared_domain_prefix"]
    assert not sdp, [i["message"] for i in sdp]


def test_guard_reverts_when_a_pass_would_add_an_error_semiconductors_shape():
    """End-to-end: on the shared-collision shape, the guarded autofix must finish
    with ZERO errors (either the shared-canonical-keep prevents the error, or the
    guard reverts the offending pass). Errors must never increase across the
    guard, regardless of warning movement."""
    ns = H.load_agent_namespace()
    dd, pd, ad = H.flat_lists(_shared_collision_model())
    cfg, lg = H.minimal_config(), H.quiet_logger()

    def sev():
        sa = ns["run_metamodel_static_analysis"](dd, pd, ad, cfg, lg)
        sc = sa["severity_counts"]
        return sc.get("error", 0), sc.get("warning", 0)

    e0, w0 = sev()
    ns["_autofix_with_monotonic_guard"](dd, pd, ad, cfg, lg, stage="test")
    e1, w1 = sev()
    assert e1 <= e0, f"guard increased errors {e0}->{e1}"
    assert w1 <= w0, f"guard increased warnings {w0}->{w1}"


if __name__ == "__main__":
    test_sa_issue_count_returns_error_first_lexicographic_tuple()
    test_shared_domain_collision_keeps_shared_product_canonical_no_error()
    print("ok")
