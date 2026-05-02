"""
Unit tests for runner/vibe_runner.ipynb's per-industry pipeline DAG.

Root-cause fix verification for 2026-05-02 18:23 UTC Staffing HR MVM-shrink failure:

  [SCHEMA_NOT_FOUND] The schema `staffing_hr_ecm._metamodel` cannot be found.

The original DAG was:

    ecm_gen ──┬─→ ecm_inst
              └─→ ecm_uninstall ──→ mvm_shrink ──→ mvm_inst

Problem: `ecm_uninstall` drops the staging catalog (e.g. `staffing_hr_ecm`),
then `mvm_shrink` tries to write a domain registration into
`staffing_hr_ecm._metamodel.domain` — schema is gone, the task fails, the
whole MVM phase is lost.

Agriculture and Real Estate happened to survive because their tasks overlapped
(uninstall reported completion 1s after shrink started), but the bug is real
and timing-dependent.

The fix re-orders to:

    ecm_gen → ecm_inst → mvm_shrink → mvm_inst → ecm_uninstall

so the staging catalog is preserved through the entire MVM phase.
"""

import json
import re
from pathlib import Path

import pytest


REPO = Path(__file__).resolve().parent.parent.parent
RUNNER_NB = REPO / "runner" / "vibe_runner.ipynb"


def _load_runner_source() -> str:
    nb = json.load(RUNNER_NB.open())
    src = ""
    for cell in nb.get("cells", []):
        if cell.get("cell_type") == "code":
            src += "".join(cell.get("source", []))
    return src


def _parse_task_dependencies():
    """Return dict[task_key_var_name, list[dep_var_names]]."""
    src = _load_runner_source()
    idx = src.find("task_configs = [")
    assert idx > 0, "task_configs block not found in vibe_runner.ipynb"
    end = src.find("        ]\n\n        job_id", idx)
    assert end > idx, "task_configs block end not found"
    block = src[idx : end + 10]

    task_blocks = re.findall(r'\{\s*"task_key":\s*(\w+),(.*?)\}', block, re.DOTALL)
    deps_map = {}
    for tk, body in task_blocks:
        dm = re.search(r'"depends_on":\s*\[([^\]]+)\]', body)
        deps_map[tk] = (
            [d.strip() for d in dm.group(1).split(",") if d.strip()] if dm else []
        )
    return deps_map


def test_runner_dag_has_all_five_tasks():
    deps = _parse_task_dependencies()
    expected = {
        "tk_ecm_gen",
        "tk_ecm_inst",
        "tk_mvm_shrink",
        "tk_mvm_inst",
        "tk_ecm_uninstall",
    }
    missing = expected - set(deps.keys())
    extra = set(deps.keys()) - expected
    assert not missing and not extra, f"DAG mismatch: missing={missing} extra={extra}"


def test_runner_dag_ecm_gen_has_no_dependencies():
    deps = _parse_task_dependencies()
    assert deps["tk_ecm_gen"] == [], (
        "ecm_gen is the root of the DAG and must have no dependencies"
    )


def test_runner_dag_ecm_inst_depends_on_ecm_gen():
    deps = _parse_task_dependencies()
    assert deps["tk_ecm_inst"] == ["tk_ecm_gen"], (
        "ecm_inst MUST depend only on ecm_gen — install ECM as soon as generation finishes"
    )


def test_runner_dag_mvm_shrink_does_NOT_depend_on_ecm_uninstall():
    """ROOT-CAUSE FIX for 2026-05-02 SCHEMA_NOT_FOUND on mvm_shrink.

    The original DAG had mvm_shrink depend on ecm_uninstall, which dropped
    the staging catalog before shrink could write its domain registration.
    Shrink MUST depend on ecm_inst (so we know ECM is durable in _v1) but
    NOT on ecm_uninstall (so the staging catalog is still alive).
    """
    deps = _parse_task_dependencies()
    assert "tk_ecm_uninstall" not in deps["tk_mvm_shrink"], (
        "mvm_shrink MUST NOT depend on ecm_uninstall — that's the bug "
        "that produced [SCHEMA_NOT_FOUND] staffing_hr_ecm._metamodel "
        "on 2026-05-02 18:23 UTC. Shrink writes to the staging catalog; "
        "uninstall_staging drops it. The two cannot run in this order."
    )
    assert deps["tk_mvm_shrink"] == ["tk_ecm_inst"], (
        "mvm_shrink MUST depend on ecm_inst (ECM durable in _v1) so the "
        "staging catalog is still alive when shrink writes its domain "
        "registration to staging._metamodel.domain"
    )


def test_runner_dag_mvm_inst_depends_on_mvm_shrink():
    deps = _parse_task_dependencies()
    assert deps["tk_mvm_inst"] == ["tk_mvm_shrink"], (
        "mvm_inst MUST depend only on mvm_shrink"
    )


def test_runner_dag_ecm_uninstall_depends_on_mvm_inst():
    """Staging catalog uninstall MUST be the LAST task in the pipeline.

    Both ECM and MVM use the same staging catalog (e.g. `staffing_hr_ecm`)
    as their working catalog. We can only drop it after BOTH ECM and MVM
    are durable in their final _v1 catalogs. Since mvm_inst transitively
    depends on ecm_inst (via mvm_shrink), depending on mvm_inst alone is
    sufficient to guarantee both are done.
    """
    deps = _parse_task_dependencies()
    assert deps["tk_ecm_uninstall"] == ["tk_mvm_inst"], (
        "ecm_uninstall MUST depend on mvm_inst — drop staging catalog "
        "ONLY after both ECM and MVM are durable in _v1 catalogs"
    )


def test_runner_dag_topological_order_is_linear():
    """The corrected DAG should be a linear chain:
    ecm_gen → ecm_inst → mvm_shrink → mvm_inst → ecm_uninstall
    """
    deps = _parse_task_dependencies()
    chain = ["tk_ecm_gen", "tk_ecm_inst", "tk_mvm_shrink", "tk_mvm_inst", "tk_ecm_uninstall"]
    for i in range(1, len(chain)):
        assert deps[chain[i]] == [chain[i - 1]], (
            f"Linear-chain ordering broken at {chain[i]}: "
            f"depends_on={deps[chain[i]]}, expected=[{chain[i-1]}]"
        )


if __name__ == "__main__":
    raise SystemExit(pytest.main([__file__, "-v"]))
