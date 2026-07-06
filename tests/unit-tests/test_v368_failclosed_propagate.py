"""v3.6.8 hc-bug5 behavioral test: the post-finalization cycle-break pass-2 `except` must NOT
swallow a fail-closed RuntimeError. ROOT CAUSE (healthcare base-MVM 2026-06-17): the nested
pass-3 last-resort block re-raised a [post-finalize-cycle-fail-closed] RuntimeError when a
cyclic graph could not be reduced to a DAG, but the broad `except Exception as _p2_err`
downgraded it to a WARNING ('proceeding with residual cycles') -> step_finalize returned
NORMALLY with a CYCLIC graph -> physical DDL + the entire MV phase ran on a broken model
(run shipped 30 ERRORs + a non-DAG graph while reporting finalization complete).

FIX (alias=cyclebreak-pass2-no-swallow-failclosed): the pass-2 except re-verifies the DAG
invariant via _detect_cycles_dfs; if cycles remain it re-raises (fail-closed) so the outer
run_track_1 except (`raise e`) halts the run. Only swallows when the graph is genuinely a DAG.

This test extracts the LIVE pass-2 except body and drives it with a stubbed cycle detector
to assert the control-flow decision (raise vs warn), proving fail-pre (old body had no raise)
/ pass-post.
"""
import textwrap
import pytest
from notebook_source_util import notebook_concat_source


def _extract_pass2_except_body():
    src = notebook_concat_source()
    anchor = "                except Exception as _p2_err:\n"
    idx = src.index(anchor)
    after = src[idx + len(anchor):]
    lines = after.splitlines(keepends=True)
    except_indent = len(anchor) - len(anchor.lstrip(" "))  # 16
    body = []
    for ln in lines:
        if ln.strip() == "":
            body.append(ln)
            continue
        indent = len(ln) - len(ln.lstrip(" "))
        if indent <= except_indent:
            break
        body.append(ln)
    return textwrap.dedent("".join(body))


def _make_runner():
    # Run the extracted body inside a REAL try/except that binds _p2_err, faithfully
    # reproducing the production active-exception context so a bare `raise` re-raises _p2_err.
    body = _extract_pass2_except_body()
    factory = (
        "def _run(_p2_err_in, _detect_cycles_dfs, products_data, attributes_data, logger):\n"
        "    try:\n"
        "        raise _p2_err_in\n"
        "    except Exception as _p2_err:\n"
        + textwrap.indent(body, "        ")
    )
    ns = {}
    exec(compile(factory, "<pass2_except>", "exec"), ns)
    return ns["_run"]


class _Log:
    def __init__(self):
        self.errors, self.warnings = [], []
    def error(self, m):
        self.errors.append(m)
    def warning(self, m):
        self.warnings.append(m)
    def info(self, m):
        pass


def test_pass2_reraises_when_cycles_remain():
    """Cycles still present after the pass-2 exception -> MUST re-raise (fail-closed)."""
    run = _make_runner()
    log = _Log()
    detect_nonempty = lambda *a, **k: [("a.x", "b.y")]  # 1 residual cycle
    with pytest.raises(RuntimeError):
        run(ValueError("boom"), detect_nonempty, [], [], log)
    assert any("cyclebreak-pass2-no-swallow-failclosed" in m for m in log.errors)


def test_pass2_reraises_original_runtimeerror():
    """A RuntimeError p2_err (the fail-closed signal) with cycles remaining is re-raised as-is."""
    run = _make_runner()
    log = _Log()
    detect_nonempty = lambda *a, **k: [("a.x", "b.y")]
    sentinel = RuntimeError("[post-finalize-cycle-fail-closed v2.0.8] 1 cycle(s) STILL present")
    with pytest.raises(RuntimeError) as ei:
        run(sentinel, detect_nonempty, [], [], log)
    assert "post-finalize-cycle-fail-closed" in str(ei.value)


def test_pass2_warns_when_graph_is_dag():
    """No cycles after the pass-2 exception -> swallow (warn), do NOT raise (incidental error)."""
    run = _make_runner()
    log = _Log()
    detect_empty = lambda *a, **k: []  # graph is a DAG
    run(RuntimeError("incidental"), detect_empty, [], [], log)  # must not raise
    assert any("graph is DAG, proceeding" in m for m in log.warnings)
