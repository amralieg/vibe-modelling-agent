"""
v3.0.5 behavioral tests for alias=mv-orphan-scrub.

ROOT CAUSE (observed on retail ecm_v3): a metric view whose owner_product was
renamed/removed by a prior VOV/architect iteration made
`_validate_metric_view_ownership` raise MetricViewOwnershipError, aborting
step_generate_data_model_json. An outer retry then re-ran the whole export
(~70min churn, 3 raised tracebacks) before the same MV finally dropped — capping
retail adherence at 77%.

FIX: `_v305_scrub_orphan_metric_views` splits records into (kept, drifted) BEFORE
validation, dropping the recoverable data-drift records (renamed/removed owner
product inside an EXISTING domain) while KEEPING genuinely-malformed records so
the fail-loud validator still fires on real config bugs.

Per CLAUDE.md §8.10 these are behavioral (not static-grep): each test exercises
the real notebook functions end-to-end and asserts an observable state change,
including proof that the PRE-scrub record set raises and the POST-scrub set does
not (the failure mode the patch removes).
"""

import json
import re
from pathlib import Path

import pytest

NB_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _ownership_cell_source():
    nb = json.loads(NB_PATH.read_text())
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        s = "".join(c.get("source", []))
        if "def _validate_metric_view_ownership(" in s and "def _v305_scrub_orphan_metric_views(" in s:
            return s
    raise RuntimeError("MV-ownership cell (validator + scrub helper) not found")


def _slice_block(src, header):
    """Greedy slice of a top-level def/class block up to the next top-level def/class."""
    pattern = rf"^{re.escape(header)}.*?(?=^class \w|^def \w)"
    m = re.search(pattern, src, re.MULTILINE | re.DOTALL)
    if m is None:
        m = re.search(rf"^{re.escape(header)}.*\Z", src, re.MULTILINE | re.DOTALL)
    assert m is not None, f"Could not slice block: {header}"
    return m.group(0)


class _Logger:
    """Minimal logger stub capturing levels so tests can assert side effects."""

    def __init__(self):
        self.records = {"info": [], "warning": [], "error": []}

    def info(self, msg, *a, **k):
        self.records["info"].append(str(msg))

    def warning(self, msg, *a, **k):
        self.records["warning"].append(str(msg))

    def error(self, msg, *a, **k):
        self.records["error"].append(str(msg))


@pytest.fixture(scope="module")
def ns():
    src = _ownership_cell_source()
    blob = "\n\n".join(
        [
            _slice_block(src, "class MetricViewOwnershipError(Exception):"),
            _slice_block(src, "def _v305_scrub_orphan_metric_views(records, domains_data, logger=None):"),
            _slice_block(src, "def _validate_metric_view_ownership(records, domains_data, logger):"),
        ]
    )
    namespace = {}
    exec(compile(blob, "<mv-ownership>", "exec"), namespace)
    assert "_v305_scrub_orphan_metric_views" in namespace
    assert "_validate_metric_view_ownership" in namespace
    assert "MetricViewOwnershipError" in namespace
    return namespace


def _domains():
    # 'customer' domain owns 'service_request' (the product 'service_case' was renamed away).
    return [
        {"domain": "customer", "products": [{"product": "account"}, {"product": "service_request"}]},
        {"domain": "billing", "products": [{"product": "invoice"}]},
    ]


def _records_with_drift():
    return [
        {"view_name": "mv_account", "owner_domain": "customer", "owner_product": "account",
         "sql": "SELECT 1"},
        # orphan: owner_product 'service_case' no longer exists in 'customer' (renamed -> service_request)
        {"view_name": "mv_service_case", "owner_domain": "customer", "owner_product": "service_case",
         "sql": "SELECT 1"},
    ]


def test_scrub_isolates_renamed_owner_product(ns):
    kept, drift = ns["_v305_scrub_orphan_metric_views"](_records_with_drift(), _domains(), _Logger())
    drift_names = {r["view_name"] for r in drift}
    kept_names = {r["view_name"] for r in kept}
    assert drift_names == {"mv_service_case"}
    assert kept_names == {"mv_account"}


def test_validator_raises_pre_scrub_but_passes_post_scrub(ns):
    """§8.10 observable state change: pre-scrub set is FATAL, post-scrub set is clean."""
    records = _records_with_drift()
    domains = _domains()

    # PRE-scrub: the orphan record makes the fail-loud validator raise (the bug the patch removes).
    with pytest.raises(ns["MetricViewOwnershipError"]):
        ns["_validate_metric_view_ownership"](records, domains, _Logger())

    # POST-scrub: the kept set validates cleanly without raising.
    kept, drift = ns["_v305_scrub_orphan_metric_views"](records, domains, _Logger())
    assert len(drift) == 1
    passed = ns["_validate_metric_view_ownership"](kept, domains, _Logger())
    assert passed == 1


def test_genuine_config_bug_is_kept_and_stays_fatal(ns):
    """A non-existent owner_domain is a real bug, NOT recoverable drift — scrub must KEEP it
    so the validator still fails loud."""
    records = [
        {"view_name": "mv_bad", "owner_domain": "does_not_exist", "owner_product": "whatever",
         "sql": "SELECT 1"},
    ]
    kept, drift = ns["_v305_scrub_orphan_metric_views"](records, _domains(), _Logger())
    assert drift == []
    assert len(kept) == 1
    with pytest.raises(ns["MetricViewOwnershipError"]):
        ns["_validate_metric_view_ownership"](kept, _domains(), _Logger())


def test_missing_required_field_is_kept_and_stays_fatal(ns):
    """Missing sql/view_name is a real bug — not drift. Scrub keeps it; validator fails loud."""
    records = [
        {"view_name": "mv_nosql", "owner_domain": "customer", "owner_product": "account", "sql": ""},
    ]
    kept, drift = ns["_v305_scrub_orphan_metric_views"](records, _domains(), _Logger())
    assert drift == []
    assert kept == records
    with pytest.raises(ns["MetricViewOwnershipError"]):
        ns["_validate_metric_view_ownership"](kept, _domains(), _Logger())


def test_all_valid_records_untouched(ns):
    records = [
        {"view_name": "mv_account", "owner_domain": "customer", "owner_product": "account", "sql": "SELECT 1"},
        {"view_name": "mv_invoice", "owner_domain": "billing", "owner_product": "invoice", "sql": "SELECT 1"},
        # domain-scoped (no owner_product) is valid and must be kept untouched.
        {"view_name": "mv_cust_domain", "owner_domain": "customer", "owner_product": "", "sql": "SELECT 1"},
    ]
    kept, drift = ns["_v305_scrub_orphan_metric_views"](records, _domains(), _Logger())
    assert drift == []
    assert kept == records
    assert ns["_validate_metric_view_ownership"](kept, _domains(), _Logger()) == 3


def test_empty_input_is_noop(ns):
    kept, drift = ns["_v305_scrub_orphan_metric_views"]([], _domains(), _Logger())
    assert kept == []
    assert drift == []
