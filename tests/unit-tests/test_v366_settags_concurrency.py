"""Behavioral tests for v3.6.6 SET TAGS Spark-Connect resilience fixes.

Root cause (proven 2026-06-16): healthcare base-MVM SET TAGS failed 18292/18731
(97.65%). The column-tag DDL runs via execute_sql -> spark.sql() on the SHARED
serverless Spark Connect session. A warehouse-REST repro fired the identical 1800
column tags @ 60 workers with 0.0% failure, proving the loss is Spark-Connect
session saturation (a server-side concurrent-DDL limit tripped by ~20-way fan-out),
NOT UC metadata throttling.

Two fixes, both exercised here against the REAL notebook source fragments (not
copies, so not tautological):
  1. settags-sparkconnect-concurrency-cap  -- cap DDL fan-out to TAG_DDL_MAX_WORKERS (default 8)
  2. settags-transient-backoff             -- fail fast on permanent errors, backoff+retry transient
"""
import re
import textwrap

from notebook_source_util import notebook_concat_source


def _extract(pattern, src, flags=re.MULTILINE):
    m = re.search(pattern, src, flags)
    assert m, f"could not locate source fragment for pattern: {pattern!r}"
    return m


def test_concurrency_cap_clamps_to_ceiling():
    """The real source cap formula must clamp tag_workers to the DDL ceiling (8)."""
    src = notebook_concat_source()
    # Pull the two real source lines that compute the ceiling + tag_workers.
    ceil_line = _extract(r"_ddl_ceiling = int\(config\.get\('TAG_DDL_MAX_WORKERS'.*?\)\n", src, re.DOTALL).group(0)
    tw_line = _extract(r"tag_workers = max\(1, min\(max_batches \* 3, len\(tag_statements\), _ddl_ceiling\)\)\n", src).group(0)
    code = textwrap.dedent(ceil_line + tw_line)

    # Big inputs: cap must win (default ceiling 8).
    ns = {"config": {}, "max_batches": 20, "tag_statements": list(range(18731))}
    exec(code, ns)
    assert ns["tag_workers"] == 8, f"default ceiling not applied: {ns['tag_workers']}"

    # Configurable override is honored.
    ns = {"config": {"TAG_DDL_MAX_WORKERS": 4}, "max_batches": 20, "tag_statements": list(range(500))}
    exec(code, ns)
    assert ns["tag_workers"] == 4

    # Small statement count: never exceed actual work.
    ns = {"config": {}, "max_batches": 20, "tag_statements": list(range(3))}
    exec(code, ns)
    assert ns["tag_workers"] == 3


def test_permanent_error_classifier_fails_fast_vs_transient():
    """The real _permanent predicate must classify permanent vs transient DDL errors."""
    src = notebook_concat_source()
    frag = _extract(
        r"_permanent = any\(_p in _es for _p in \((.*?)\)\)\n",
        src,
        re.DOTALL,
    ).group(0)
    code = textwrap.dedent(
        "def _classify(_es):\n"
        + textwrap.indent(frag, "    ")
        + "    return _permanent\n"
    )
    ns = {}
    exec(code, ns)
    classify = ns["_classify"]

    # Permanent -> fail fast (True).
    for msg in (
        "[COLUMN_NOT_FOUND_IN_TABLE] column foo not found",
        "cannot resolve 'bar' given input columns",
        "PARSE_SYNTAX_ERROR near 'SET'",
        "[TABLE_OR_VIEW_NOT_FOUND] table x",
        "sqlstate: 42501 permission denied",
    ):
        assert classify(msg.lower()) is True, f"should be permanent: {msg}"

    # Transient -> retry (False).
    for msg in (
        "[RequestId=dc56a6f0-... ErrorClass=INTERNAL] transient server error",
        "operation aborted due to concurrent update",
        "503 service unavailable",
        "deadline exceeded waiting for response",
    ):
        assert classify(msg.lower()) is False, f"should be transient: {msg}"


def test_aliases_present_in_source():
    """Smoke: both fix aliases live in the deployed notebook source."""
    src = notebook_concat_source()
    assert "settags-sparkconnect-concurrency-cap" in src
    assert "settags-transient-backoff" in src
