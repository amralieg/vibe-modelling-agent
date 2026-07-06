"""Behavioral version + alias-sentinel tests for v2.9.1.

v2.9.1 ships 7 root-cause fixes from the 6-business swarm adherence audit:
  FIX-3 verifier-json-harden, FIX-2 verifier-metascore-informational,
  FIX-1 verifier-snapshot-target-first, FIX-4 verifier-budget-scale,
  FIX-5 verifier-fuzzy-product-match, FIX-6 ssot-cross-domain-merge,
  FIX-7 nk-normalize-widen.

§3a-bis: __AGENT_VERSION__ == 2.9.1 and is the first code statement in Cell 1.
§8.10 sentinel: every alias has a runtime [<alias> FIRED] log emission site.
"""
import json
import re
from pathlib import Path

NB_PATH = Path(__file__).parent.parent.parent / "agent" / "dbx_vibe_modelling_agent.ipynb"

V291_ALIASES = [
    "verifier-json-harden",
    "verifier-metascore-informational",
    "verifier-snapshot-target-first",
    "verifier-budget-scale",
    "verifier-fuzzy-product-match",
    "ssot-cross-domain-merge",
    "nk-normalize-widen",
]


def _nb():
    return json.loads(NB_PATH.read_text())


def _nb_src():
    cells = _nb().get("cells", [])
    return "\n".join("".join(c.get("source", [])) for c in cells if c.get("cell_type") == "code")


def test_agent_version_is_291():
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', _nb_src())
    assert m, "__AGENT_VERSION__ missing"
    # v291 shipped 2.9.1; later versions bump beyond it. Assert a monotonic floor so this
    # historical test stays meaningful without breaking on every future bump — the exact
    # version pin lives in the current-version behavioral test (test_v292_behavioral).
    ver = tuple(int(s) for s in m.group(1).split("."))
    assert ver >= (2, 9, 1), f"expected >= 2.9.1, got {m.group(1)}"
    # single-digit semver (§3a)
    assert all(len(seg) == 1 for seg in m.group(1).split(".")), "single-digit semver violated"


def test_version_is_first_code_statement_in_cell1():
    cells = _nb().get("cells", [])
    code_cells = [c for c in cells if c.get("cell_type") == "code"]
    src = "".join(code_cells[0].get("source", []))
    for ln in src.splitlines():
        s = ln.strip()
        if not s or s.startswith("#"):
            continue
        assert s.startswith("__AGENT_VERSION__"), f"first code stmt is not the version: {s[:60]}"
        break


def test_all_seven_aliases_have_fired_log_site():
    src = _nb_src()
    for alias in V291_ALIASES:
        # a runtime FIRED log line referencing the alias must exist (not only a comment)
        assert re.search(rf"\[{re.escape(alias)} FIRED", src), f"no [{alias} FIRED] log site"
        assert f"alias={alias}" in src, f"no alias={alias} grep anchor"
