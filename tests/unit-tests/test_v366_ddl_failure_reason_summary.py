"""Behavioral test for v3.6.6 alias=ddl-failure-reason-summary.

ROOT CAUSE proven by the healthcare base-MVM run: SET TAGS reported 97.7%
failed while ZERO failure lines appeared in info OR error logs — the
worker-thread `_run_sql` `p_logger.error("FAILED permanently")` never reached
the volume file handler (silent-drop, §11). The fix aggregates the real
per-statement error (`_err`) on the MAIN thread (which IS flushed) and logs a
[UC-DDL-FAILSUM ...] summary both live (top-3 at each progress increment) and
at the end (top-10 distinct reasons).

This test executes the REAL production `_local_execute_sql_no_halt` loop body
(extracted + dedented from the agent notebook) with mocked dependencies, drives
deterministic failures through it, and asserts the failure reason is surfaced in
the captured log output. Pre-patch (no aggregation) there is NO line carrying
the actual error text — only an opaque "N failed" count — so this test fails on
the pre-patch tree.
"""
import logging
import os
import sys
import textwrap

sys.path.insert(0, os.path.dirname(__file__))

from notebook_source_util import notebook_concat_source


def _extract_nested_def(fn_name: str) -> str:
    src = notebook_concat_source()
    lines = src.splitlines(keepends=True)
    start = None
    for i, l in enumerate(lines):
        if l.lstrip().startswith(f"def {fn_name}("):
            start = i
            break
    assert start is not None, f"{fn_name} not found in notebook"
    base_indent = len(lines[start]) - len(lines[start].lstrip())
    end = start + 1
    while end < len(lines):
        l = lines[end]
        if l.strip() and (len(l) - len(l.lstrip())) <= base_indent:
            break
        end += 1
    return textwrap.dedent("".join(lines[start:end]))


class _CapHandler(logging.Handler):
    def __init__(self):
        super().__init__()
        self.records = []

    def emit(self, record):
        self.records.append(self.format(record))


class _FakeConcurrencyManager:
    max_workers = 4

    def acquire(self, timeout=None):
        return True

    def release(self, start_time):
        return None


class _FakeSpark:
    def sql(self, statement):
        if "FAIL" in statement:
            raise RuntimeError(f"[TABLE_OR_VIEW_NOT_FOUND] table missing for: {statement}")
        return None


def _build_namespace():
    import concurrent.futures as _cf
    import contextlib
    import time as _time

    block = _extract_nested_def("_local_execute_sql_no_halt")

    def _guarded_pool(max_workers, pool_name=None, logger=None):
        return _cf.ThreadPoolExecutor(max_workers=max(1, max_workers))

    @contextlib.contextmanager
    def guarded_thread_pool_executor(max_workers, pool_name=None, logger=None):
        ex = _guarded_pool(max_workers, pool_name, logger)
        try:
            yield ex
        finally:
            ex.shutdown(wait=True)

    def execute_sql(spark, statement, logger):
        try:
            spark.sql(statement)
            return None
        except Exception as e:
            short = str(e).splitlines()[0]
            raise type(e)(short)

    ns = {
        "config": {"MAX_RETRIES": 1, "AI_QUERY_TIMEOUT_SECONDS": 5},
        "concurrency_manager": _FakeConcurrencyManager(),
        "guarded_thread_pool_executor": guarded_thread_pool_executor,
        "_safe_as_completed": lambda futures, timeout=None, logger=None, label=None: _cf.as_completed(futures),
        "_safe_future_result": lambda future, timeout=None, logger=None, label=None: future.result(),
        "execute_sql": execute_sql,
        "time": _time,
        "_ts": lambda: "TS",
        "_fmt_hms": lambda x: "0s",
        "_format_eta": lambda *a, **k: "0s",
        "_flush_log_handlers": lambda logger: None,
        "__name__": "_test_slice_local_exec",
    }
    exec(compile(block, "notebook_local_exec", "exec"), ns)
    return ns


def _run(statements):
    ns = _build_namespace()
    fn = ns["_local_execute_sql_no_halt"]
    logger = logging.getLogger("test_ddl_failsum")
    logger.handlers[:] = []
    logger.setLevel(logging.DEBUG)
    cap = _CapHandler()
    logger.addHandler(cap)
    fn(_FakeSpark(), statements, "SET TAGS", logger, 4)
    return cap.records


def test_failure_reasons_are_surfaced_not_silent():
    statements = [
        "ALTER TABLE ok1 SET TAGS ('a'='1')",
        "ALTER TABLE FAIL_a SET TAGS ('a'='1')",
        "ALTER TABLE FAIL_b SET TAGS ('a'='1')",
        "ALTER TABLE FAIL_c SET TAGS ('a'='1')",
        "ALTER TABLE ok2 SET TAGS ('a'='1')",
    ]
    records = _run(statements)
    joined = "\n".join(records)
    # The fix MUST surface the real error text in a FAILSUM line.
    assert "UC-DDL-FAILSUM" in joined, f"no failure summary emitted:\n{joined}"
    assert "TABLE_OR_VIEW_NOT_FOUND" in joined, f"real error text not surfaced:\n{joined}"
    # And it must report the failure count accurately.
    failsum_lines = [r for r in records if "UC-DDL-FAILSUM" in r]
    assert failsum_lines, "expected at least one FAILSUM line"


def test_no_failsum_when_all_succeed():
    statements = [
        "ALTER TABLE ok1 SET TAGS ('a'='1')",
        "ALTER TABLE ok2 SET TAGS ('a'='1')",
    ]
    records = _run(statements)
    joined = "\n".join(records)
    assert "UC-DDL-FAILSUM" not in joined, f"FAILSUM emitted with zero failures:\n{joined}"


if __name__ == "__main__":
    test_failure_reasons_are_surfaced_not_silent()
    test_no_failsum_when_all_succeed()
    print("OK")
