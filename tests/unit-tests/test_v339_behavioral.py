import os
import sys

sys.path.insert(0, os.path.dirname(__file__))

from notebook_source_util import notebook_concat_source, exec_function_namespace


def _directive():
    ns = exec_function_namespace("_vibe_exact_metric_view_directive")
    return ns["_vibe_exact_metric_view_directive"]


def test_rc4_toplevel_sizing_fallback_fires_when_nested_empty():
    """RC4: nested vibe_classification.sizing_directives is empty at KPI-first time on the
    base-model path, but the merged directives live at top-level widgets_values['sizing_directives'].
    The directive MUST read the top-level store. (Pre-patch returns (None, []) -> FAIL.)"""
    fn = _directive()
    wv = {
        "vibe_classification": {},  # nested copy lost by KPI-first time
        "sizing_directives": {
            "max_metric_views": 3,
            "min_metric_views": 3,
            "explicit_metric_views": [
                "Vacancy Rate",
                "Retirement Eligibility",
                "Total Positions and Active Employees",
            ],
        },
    }
    count, names = fn(wv)
    assert count == 3, f"expected exact count 3 from top-level sizing, got {count}"
    assert names == [
        "Vacancy Rate",
        "Retirement Eligibility",
        "Total Positions and Active Employees",
    ], names


def test_rc4_nested_sizing_still_preferred_no_regression():
    """When the nested copy HAS the MV keys, it is used; top-level is not needed."""
    fn = _directive()
    wv = {
        "vibe_classification": {"sizing_directives": {"max_metric_views": 2, "explicit_metric_views": ["A", "B"]}},
        "sizing_directives": {"max_metric_views": 9},  # must NOT override the nested copy
    }
    count, names = fn(wv)
    assert count == 2, count
    assert names == ["A", "B"], names


def test_rc4_silent_when_no_mv_directive():
    """No MV count anywhere -> returns None so size-based defaults are untouched (user-vibe-silent)."""
    fn = _directive()
    count, names = fn({"vibe_classification": {}, "sizing_directives": {"max_domains": 2}})
    assert count is None, count
    assert names == [], names


def test_v339_aliases_present():
    src = notebook_concat_source()
    for alias in [
        "mv-exact-sizing-toplevel-fallback",
        "verifier-mv-source-authoritative",
        "verifier-catalog-key-fix",
        "verifier-declared-context-inventory",
        "verifier-subdomain-inventory",
    ]:
        assert src.count(alias) >= 1, f"missing alias {alias}"


def test_v339_version_constant():
    src = notebook_concat_source()
    assert '__AGENT_VERSION__ = "3.3.9"' in src
