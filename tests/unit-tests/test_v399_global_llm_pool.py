import ast
import json
import threading
import time
from pathlib import Path

import pytest

REPO = Path(__file__).resolve().parents[2]
NB = REPO / "agent" / "dbx_vibe_modelling_agent.ipynb"
PRE = Path("/tmp/agent_pre_v399.ipynb")


def _concat(nb_path):
    nb = json.loads(Path(nb_path).read_text(encoding="utf-8"))
    out = []
    for c in nb.get("cells", []):
        if c.get("cell_type") == "code":
            s = c.get("source", "")
            out.append("".join(s) if isinstance(s, list) else s)
    return "\n\n".join(out)


# Names we need to rebuild the global-pool subsystem in isolation, in dependency order.
_WANT = [
    "NestedThreadPoolError",      # class (exception)
    "ThreadPoolGuard",            # class
    "_GLOBAL_LLM_POOL",           # module assign (+ the import beside it)
    "_set_global_llm_pool_size",  # func
    "_get_or_create_global_llm_pool",  # func
    "shutdown_global_llm_pool",   # func
    "_SharedPoolHandle",          # class
    "guarded_thread_pool_executor",   # func
]


def _build_namespace(src):
    tree = ast.parse(src)
    segs = {}
    extra_imports = []
    for node in tree.body:
        if isinstance(node, ast.Import) and any(a.asname == "_glp_threading" for a in node.names):
            extra_imports.append(ast.get_source_segment(src, node))
        name = None
        if isinstance(node, (ast.FunctionDef, ast.ClassDef)):
            name = node.name
        elif isinstance(node, ast.Assign):
            for t in node.targets:
                if isinstance(t, ast.Name) and t.id == "_GLOBAL_LLM_POOL":
                    name = "_GLOBAL_LLM_POOL"
        if name in _WANT:
            segs[name] = ast.get_source_segment(src, node)  # last definition wins
    missing = [n for n in _WANT if n not in segs]
    assert not missing, f"missing defs: {missing}"
    ns = {}
    exec("from concurrent.futures import ThreadPoolExecutor\nimport threading\n", ns)
    for imp in extra_imports:
        exec(imp, ns)
    for n in _WANT:
        exec(segs[n], ns)
    return ns


@pytest.fixture(scope="module")
def ns():
    n = _build_namespace(_concat(NB))
    yield n
    try:
        n["shutdown_global_llm_pool"](wait=False)
    except Exception:
        pass


def _reset(ns):
    ns["shutdown_global_llm_pool"](wait=False)
    ns["_GLOBAL_LLM_POOL"]["size"] = 0
    ns["_GLOBAL_LLM_POOL"]["pool"] = None


def test_factory_returns_real_tpe_when_disabled(ns):
    _reset(ns)  # size == 0 -> disabled
    with ns["guarded_thread_pool_executor"](3, pool_name="t") as ex:
        assert ex.__class__.__name__ == "ThreadPoolExecutor"
        fs = [ex.submit(lambda x: x * 2, i) for i in range(3)]
        assert sorted(f.result() for f in fs) == [0, 2, 4]


def test_factory_returns_shared_handle_when_enabled(ns):
    _reset(ns)
    ns["_set_global_llm_pool_size"](8)
    pool_objs = set()
    for _ in range(3):
        with ns["guarded_thread_pool_executor"](4, pool_name="t") as ex:
            assert isinstance(ex, ns["_SharedPoolHandle"])
            fs = [ex.submit(lambda x: x + 1, i) for i in range(5)]
            assert sorted(f.result() for f in fs) == [1, 2, 3, 4, 5]
            pool_objs.add(id(ex._pool))
    # all three blocks reused the SAME underlying pool (one per model)
    assert len(pool_objs) == 1, "handle must reuse the single global pool across phases"
    _reset(ns)


def test_handle_exit_does_not_close_pool(ns):
    _reset(ns)
    ns["_set_global_llm_pool_size"](4)
    with ns["guarded_thread_pool_executor"](2, pool_name="a") as ex1:
        ex1.submit(lambda: 1).result()
        pool1 = ex1._pool
    # after the with-block, the shared pool must still accept work (not shut down)
    with ns["guarded_thread_pool_executor"](2, pool_name="b") as ex2:
        assert ex2._pool is pool1
        assert ex2.submit(lambda: 42).result() == 42
    _reset(ns)


def test_handle_shutdown_is_noop(ns):
    _reset(ns)
    ns["_set_global_llm_pool_size"](4)
    with ns["guarded_thread_pool_executor"](2, pool_name="a") as ex:
        ex.shutdown(wait=True)  # must NOT kill the global pool
        assert ex.submit(lambda: 7).result() == 7
    # pool still alive afterwards
    assert ns["_GLOBAL_LLM_POOL"]["pool"] is not None
    _reset(ns)


def test_per_handle_semaphore_bounds_concurrency(ns):
    _reset(ns)
    ns["_set_global_llm_pool_size"](16)  # big pool...
    live = {"n": 0, "max": 0}
    lock = threading.Lock()

    def work(_):
        with lock:
            live["n"] += 1
            live["max"] = max(live["max"], live["n"])
        time.sleep(0.05)
        with lock:
            live["n"] -= 1

    with ns["guarded_thread_pool_executor"](3, pool_name="bound") as ex:  # ...but handle wants only 3
        fs = [ex.submit(work, i) for i in range(20)]
        for f in fs:
            f.result()
    assert live["max"] <= 3, f"handle must cap concurrency at requested 3, saw {live['max']}"
    _reset(ns)


def test_nesting_guard_preserved(ns):
    _reset(ns)
    ns["_set_global_llm_pool_size"](4)
    with ns["guarded_thread_pool_executor"](2, pool_name="outer"):
        with pytest.raises(ns["NestedThreadPoolError"]):
            ns["guarded_thread_pool_executor"](2, pool_name="inner")
    _reset(ns)


def test_shutdown_global_pool_clears_and_idempotent(ns):
    _reset(ns)
    ns["_set_global_llm_pool_size"](4)
    p = ns["_get_or_create_global_llm_pool"]()
    assert ns["_GLOBAL_LLM_POOL"]["pool"] is p
    ns["shutdown_global_llm_pool"](wait=True)
    assert ns["_GLOBAL_LLM_POOL"]["pool"] is None
    ns["shutdown_global_llm_pool"](wait=True)  # idempotent, no raise
    _reset(ns)


def test_fail_pre_subsystem_absent_in_pre_patch():
    if not PRE.exists():
        pytest.skip("pre-patch backup not present")
    pre = _concat(PRE)
    assert "_SharedPoolHandle" not in pre
    assert "_GLOBAL_LLM_POOL" not in pre
    assert "shutdown_global_llm_pool" not in pre


def test_teardown_and_exit_call_shutdown(ns):
    src = _concat(NB)
    # finally + safe_notebook_exit must invoke the single shutdown
    assert src.count("shutdown_global_llm_pool(wait=True") >= 1
    assert "shutdown_global_llm_pool(wait=False" in src
    # factory + helper both route to the shared pool
    assert "_SharedPoolHandle(_get_or_create_global_llm_pool(), pool_name" in src
    assert "mark_guard=False" in src  # run_parallel uses non-guarded handle


def test_version_bumped(ns):
    assert '__AGENT_VERSION__ = "4.0.0"' in _concat(NB)
