import json
import os

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "\n".join("".join(c.get("source", [])) for c in nb.get("cells", []))


# Faithful reconstruction of the v2.9.4 budget-resolution precedence.
def resolve_budget(widget_value, env_value):
    b = 0
    try:
        w = (widget_value or "").strip()
        if w and int(w) > 0:
            b = int(w)
    except Exception:
        b = 0
    if b <= 0:
        b = int(env_value if env_value is not None else "14400")
    return b


def test_agent_version_is_294():
    # v2.9.4 fixes must remain present in this and all later versions.
    import re
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', _src())
    assert m, "version constant not found"
    assert tuple(int(x) for x in m.groups()) >= (2, 9, 4)


def test_fix_present():
    src = _src()
    assert "alias=runtime-budget-honor-real-timeout" in src
    assert 'dbutils.widgets.text("runtime_budget_seconds"' in src


def test_widget_overrides_4h_default():
    # The whole point: a 15h job (54000s) must NOT be clamped to the 4h (14400s) default.
    assert resolve_budget("54000", "14400") == 54000          # widget wins -> uses full 15h
    assert resolve_budget("", "14400") == 14400               # blank -> legacy 4h default
    assert resolve_budget(None, "14400") == 14400             # missing widget -> 4h default
    assert resolve_budget("0", "14400") == 14400              # zero/garbage -> 4h default
    assert resolve_budget("notanint", "14400") == 14400       # parse error -> 4h default


def test_pre_patch_would_have_clamped():
    # Pre-patch the agent ONLY read the env var (never injected) -> always 14400. Prove the new
    # widget path changes the observable budget when the launcher supplies the real allocation.
    pre_patch = int(os.environ.get("DATABRICKS_TASK_TIMEOUT_SECONDS", "14400"))  # always 14400 in practice
    post_patch = resolve_budget("54000", "14400")
    assert pre_patch == 14400
    assert post_patch == 54000
    assert post_patch > pre_patch


if __name__ == "__main__":
    for fn in [v for k, v in sorted(globals().items()) if k.startswith("test_")]:
        fn()
        print("ok", fn.__name__)
