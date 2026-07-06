from agent.vov_2_0.invariants import (
    capture_invariants,
    diff_models_summary,
    diff_within_summary_scope,
    verify_invariants,
)


def _model(domains, mv=None, agent_version="2.0.0"):
    return {
        "agent_version": agent_version,
        "model": {
            "domains": [
                {
                    "name": dn,
                    "products": [
                        {"name": pn, "tags": "", "subdomain": "", "primary_key": "id",
                         "attributes": [{"name": "id", "type": "BIGINT", "tags": "", "foreign_key_to": ""}]}
                        for pn in pnames
                    ],
                }
                for dn, pnames in domains.items()
            ],
            "metric_views": list(mv or []),
        },
    }


def test_capture_extracts_pinned_state():
    m = _model({"hr": ["employee", "position"], "project": ["project"]}, agent_version="1.1.0")
    snap = capture_invariants(m, ["hr", "project"], [("hr", "employee")])
    assert snap.user_pinned_domains == frozenset({"hr", "project"})
    assert ("hr", "employee") in snap.user_pinned_products
    assert snap.agent_version == "1.1.0"


def test_verify_passes_when_pinned_intact():
    m = _model({"hr": ["employee"]})
    snap = capture_invariants(m, ["hr"], [("hr", "employee")])
    ok, diag = verify_invariants(m, snap)
    assert ok, diag


def test_verify_fails_when_user_domain_removed():
    m = _model({"hr": ["employee"]})
    snap = capture_invariants(m, ["hr"], [])
    m2 = _model({"finance": ["account"]})
    ok, diag = verify_invariants(m2, snap)
    assert not ok
    assert "hr" in diag


def test_verify_fails_when_user_product_removed():
    m = _model({"hr": ["employee", "position"]})
    snap = capture_invariants(m, ["hr"], [("hr", "employee")])
    m2 = _model({"hr": ["position"]})
    ok, diag = verify_invariants(m2, snap)
    assert not ok
    assert "employee" in diag


def test_verify_fails_when_agent_version_changes():
    m = _model({"hr": ["employee"]}, agent_version="2.0.0")
    snap = capture_invariants(m, [], [])
    m2 = _model({"hr": ["employee"]}, agent_version="2.0.1")
    ok, diag = verify_invariants(m2, snap)
    assert not ok
    assert "agent_version" in diag


def test_verify_allows_added_domains():
    m = _model({"hr": ["employee"]})
    snap = capture_invariants(m, ["hr"], [("hr", "employee")])
    m2 = _model({"hr": ["employee"], "ext": ["thing"]})
    ok, _ = verify_invariants(m2, snap)
    assert ok


def test_diff_summary_detects_added_domain():
    a = _model({"hr": ["employee"]})
    b = _model({"hr": ["employee"], "fin": ["account"]})
    diff = diff_models_summary(a, b)
    assert "fin" in diff["domains_added"]
    assert not diff["domains_removed"]


def test_diff_summary_detects_added_product():
    a = _model({"hr": ["employee"]})
    b = _model({"hr": ["employee", "position"]})
    diff = diff_models_summary(a, b)
    assert ("hr", "position") in diff["products_added"]


def test_diff_summary_detects_added_fk():
    a = _model({"hr": ["employee"]})
    a["model"]["domains"][0]["products"][0]["attributes"].append(
        {"name": "manager_id", "type": "BIGINT", "tags": "", "foreign_key_to": ""}
    )
    b = _model({"hr": ["employee"]})
    b["model"]["domains"][0]["products"][0]["attributes"].append(
        {"name": "manager_id", "type": "BIGINT", "tags": "", "foreign_key_to": "hr.employee.id"}
    )
    diff = diff_models_summary(a, b)
    assert diff["fks_added"] == 1


def test_diff_within_scope_blocks_unrelated_domain_removal():
    diff = {
        "domains_added": [],
        "domains_removed": ["customer"],
        "products_added": [],
        "products_removed": [],
        "n_products_modified": 0,
        "tags_added_estimate": 0,
        "fks_added": 0,
        "fks_removed": 0,
        "metric_views_delta": 0,
    }
    ok, diag = diff_within_summary_scope(diff, "Add `pii=true` tag to all customer attributes")
    assert not ok
    assert "domains_removed" in diag


def test_diff_within_scope_allows_explicit_domain_removal():
    diff = {
        "domains_added": [],
        "domains_removed": ["legacy"],
        "products_added": [],
        "products_removed": [],
        "n_products_modified": 0,
        "tags_added_estimate": 0,
        "fks_added": 0,
        "fks_removed": 0,
        "metric_views_delta": 0,
    }
    ok, _ = diff_within_summary_scope(diff, "remove domain legacy from model")
    assert ok


def test_diff_within_scope_blocks_unexpected_metric_views():
    diff = {
        "domains_added": [],
        "domains_removed": [],
        "products_added": [],
        "products_removed": [],
        "n_products_modified": 0,
        "tags_added_estimate": 0,
        "fks_added": 0,
        "fks_removed": 0,
        "metric_views_delta": 5,
    }
    ok, diag = diff_within_summary_scope(diff, "rename product foo to bar")
    assert not ok
    assert "metric_views_delta" in diag


def test_invariant_snapshot_fingerprint_stable():
    m = _model({"hr": ["a", "b"]})
    snap1 = capture_invariants(m, ["hr"], [("hr", "a")])
    snap2 = capture_invariants(m, ["hr"], [("hr", "a")])
    assert snap1.fingerprint() == snap2.fingerprint()


def test_invariant_snapshot_fingerprint_distinct_on_change():
    m = _model({"hr": ["a"]})
    s1 = capture_invariants(m, ["hr"], [])
    s2 = capture_invariants(m, ["hr"], [("hr", "a")])
    assert s1.fingerprint() != s2.fingerprint()
