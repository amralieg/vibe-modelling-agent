import json
import os
import re
import textwrap

NB_HEAD = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")
NB_PRE = "/tmp/agent_pre_v416.ipynb"


def _nb_source(path):
    nb = json.load(open(path))
    return "\n".join("".join(c.get("source", [])) for c in nb.get("cells", []) if c.get("cell_type") == "code")


def _extract_deploy_restamp(src):
    """Extract the deploy-copy quality-restamp snippet (Path C). Returns dedented code or None.

    Line-based: the Path C block starts at the `_qb416 = globals().get(...)` line and ends just
    before `_loc_json_str = json.dumps(...)`. Path B uses `_qb416b`, so anchoring on `_qb416 `
    (with trailing space) + the `_loc_json_str` terminator isolates Path C unambiguously.
    """
    lines = src.split("\n")
    for i, l in enumerate(lines):
        if "_qb416 = globals().get('_LAST_VOV_QUALITY_BREAKDOWN')" in l:
            window = lines[i : i + 16]
            if not any("_loc_json_str = json.dumps" in w for w in window):
                continue
            block = []
            for w in lines[i:]:
                if "_loc_json_str = json.dumps" in w:
                    break
                block.append(w)
            return textwrap.dedent("\n".join(block))
    return None


def _run_snippet(code, updated_root, breakdown):
    """Exec the extracted restamp snippet with a controlled namespace; return mutated root."""
    class _L:
        def info(self, *a, **k):
            pass

    g = {"_LAST_VOV_QUALITY_BREAKDOWN": breakdown, "logger": _L()}
    ns = {"_updated_root": updated_root}
    exec(code, g, ns)
    return ns["_updated_root"]


_AUTHORITATIVE = {
    "vreq_adherence_pct": 80.9,
    "native_quality_pct": 47.74,
    "vov_quality_pct": 64.32,
    "adherence_source": "physical_ground_truth",
}
_STALE_ROOT = {"agent_version": "4.1.6", "vreq_adherence_pct": None, "native_quality_pct": 74.63, "vov_quality_pct": 74.63}


def test_post_patch_snippet_present_and_compiles():
    code = _extract_deploy_restamp(_nb_source(NB_HEAD))
    assert code is not None, "v4.1.6 deploy-copy restamp snippet missing from notebook"
    compile(code, "<restamp>", "exec")


def test_rc_quality_restamp_post():
    """POST: authoritative breakdown overwrites the stale pre-physical quality fields."""
    code = _extract_deploy_restamp(_nb_source(NB_HEAD))
    assert code is not None
    root = _run_snippet(code, dict(_STALE_ROOT), dict(_AUTHORITATIVE))
    assert root["vreq_adherence_pct"] == 80.9
    assert root["native_quality_pct"] == 47.74
    assert root["vov_quality_pct"] == 64.32


def test_gate_skips_non_authoritative_breakdown():
    """Gate: a breakdown without an authoritative adherence source (e.g. shrink/base, source=None)
    must NOT overwrite the existing quality fields."""
    code = _extract_deploy_restamp(_nb_source(NB_HEAD))
    assert code is not None
    shrink = {"vreq_adherence_pct": None, "native_quality_pct": 78.56, "vov_quality_pct": 78.56, "adherence_source": None}
    base_root = {"agent_version": "4.1.6", "vreq_adherence_pct": None, "native_quality_pct": 78.56, "vov_quality_pct": 78.56}
    root = _run_snippet(code, dict(base_root), shrink)
    assert root["vov_quality_pct"] == 78.56  # unchanged
    assert root["vreq_adherence_pct"] is None


def test_gate_skips_empty_breakdown():
    code = _extract_deploy_restamp(_nb_source(NB_HEAD))
    assert code is not None
    root = _run_snippet(code, dict(_STALE_ROOT), {})
    assert root["vov_quality_pct"] == 74.63  # stays stale when no global breakdown


def test_rc_quality_restamp_pre_fails():
    """PRE (v4.1.5 baseline): the restamp snippet does not exist, so the stale quality persists
    unchanged. This proves the v4.1.6 patch changes observable model.json output."""
    if not os.path.exists(NB_PRE):
        import pytest

        pytest.skip("pre-patch baseline /tmp/agent_pre_v416.ipynb not present")
    code = _extract_deploy_restamp(_nb_source(NB_PRE))
    assert code is None, "pre-patch baseline must NOT contain the v4.1.6 restamp snippet"
