"""Behavioral tests for v3.6.4 alias=clash-ignore-underscore-meta.

ROOT CAUSE this fixes: the physical-deployment clash guard treated ANY schema
that is not one of {_metamodel, _metrics, default, information_schema} as a
business-database clash. Both the heuristic scanner (`_early_clash_detection` ->
`_list_user_schemas`) and the comparator (`_check_physical_deployment_clash`)
used that same closed set.

A leading-underscore META schema therefore tripped the guard. Concretely, a
`_staging` schema (where the driver / a real user stages the `model_vibes` input
file before a `new base model` run, or a real user's `_tmp` / `_archive`) was
read as an existing business database, so `_check_physical_deployment_clash`
raised the hostile `PHYSICAL DEPLOYMENT CLASH DETECTED` ValueError and aborted
the operation at ~4 min.

Business domain schemas are NEVER underscore-prefixed (the agent's own meta
schemas `_metamodel` / `_metrics` already use that convention), so both clash
filters now additionally exclude every `schema.startswith("_")`.

These tests extract the REAL production helper from the notebook and exercise it
with a fake spark. They FAIL on pre-v3.6.4 HEAD (a `_staging` schema raises the
clash ValueError) and PASS post-fix (`_staging` is a clean no-op) while a real
business-domain clash STILL raises (proves the guard is selective, not disabled).
"""
import json
import re
import os

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def _extract(name):
    src = _src()
    m = re.search(r"\ndef " + re.escape(name) + r"\(.*?\n(?=\ndef |\n@|\n[^ \n])", src, re.DOTALL)
    assert m, f"def {name} not found in notebook"
    return m.group(0).lstrip("\n")


class _FakeCol:
    def __init__(self, schemas):
        self._schemas = schemas

    def collect(self):
        return [(s,) for s in self._schemas]


class _FakeSpark:
    """Returns the configured existing-schema list for any `SHOW SCHEMAS IN`."""

    def __init__(self, schemas):
        self._schemas = schemas

    def sql(self, query):
        return _FakeCol(self._schemas)


class _CapLogger:
    def __init__(self):
        self.lines = []

    def info(self, msg):
        self.lines.append(("INFO", msg))

    def warning(self, msg):
        self.lines.append(("WARN", msg))

    def error(self, msg):
        self.lines.append(("ERROR", msg))


def _load_clash():
    g = {}
    exec(_extract("_check_physical_deployment_clash"), g)
    return g["_check_physical_deployment_clash"]


# ── static: both filter sites carry the underscore guard ──────────────────────

def test_both_filter_sites_have_underscore_guard():
    src = _src()
    assert src.count("clash-ignore-underscore-meta") >= 2, (
        "expected the underscore-meta guard at BOTH clash filter sites "
        "(_check_physical_deployment_clash + _list_user_schemas)"
    )


# ── behavior: underscore-meta schema is a clean no-op (was a fatal clash) ─────

def test_staging_underscore_schema_is_noop_not_clash():
    fn = _load_clash()
    spark = _FakeSpark(["_metamodel", "_metrics", "_staging", "default", "information_schema"])
    log = _CapLogger()
    # Pre-v3.6.4 HEAD: `_staging` survives the filter, exists in the catalog,
    # and the empty-widgets path raises the hostile clash ValueError.
    fn(spark, [("vibe_gov_transport_basemvm", "_staging")], {}, log)  # must NOT raise
    joined = " ".join(m for _, m in log.lines)
    assert "all internal schemas" in joined, (
        "underscore-meta-only targets must short-circuit as an all-internal no-op; "
        f"logger said: {joined!r}"
    )


def test_any_leading_underscore_schema_is_noop():
    fn = _load_clash()
    for meta in ("_tmp", "_archive", "_scratch", "_input"):
        spark = _FakeSpark([meta])
        fn(spark, [("cat", meta)], {}, _CapLogger())  # must NOT raise for any of them


# ── selectivity: a REAL business-domain clash STILL raises (no tautology) ─────

def test_real_business_domain_clash_still_raises():
    fn = _load_clash()
    spark = _FakeSpark(["hr"])  # a real, existing, non-underscore domain
    import pytest
    with pytest.raises(Exception):
        # empty widgets => no vov-successor soft-replace => hard clash error
        fn(spark, [("cat", "hr")], {}, _CapLogger())
