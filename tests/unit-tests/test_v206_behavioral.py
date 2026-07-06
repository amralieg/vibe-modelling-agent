"""v206 behavioral tests — startup version print + honest F5 labeling.

Two real audit gaps from v205 self-audit closed in v206:

* GAP-1: startup version print MISSING in v205 (user explicitly required it).
* GAP-3: v205 constant claimed "F5 mem/json canonicalize-on-write" but
         shipped `_partial_credit=0.7` (symptom relief, not root cause).
         v206 honest constant flags this and keeps the partial-credit semi-fix.

These tests MUST FAIL on v205 HEAD and pass on v206. They guard the
deployed-archive contract per CLAUDE.md §8.1.
"""

from __future__ import annotations

import json
import re
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NB_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


@pytest.fixture(scope="module")
def notebook_text() -> str:
    nb = json.loads(NB_PATH.read_text())
    return "\n".join("".join(c["source"]) for c in nb["cells"])


@pytest.fixture(scope="module")
def cell0_text() -> str:
    nb = json.loads(NB_PATH.read_text())
    for c in nb["cells"]:
        src = "".join(c["source"])
        if c.get("cell_type") == "code" and "__AGENT_VERSION__" in src:
            return src
    pytest.fail("No code cell containing __AGENT_VERSION__ found")


def test_v206_version_bumped(cell0_text: str) -> None:
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([\d.]+)"', cell0_text)
    assert m is not None, "version constant not found"
    assert tuple(int(_x) for _x in m.group(1).split(".")) >= (2, 0, 6), f"expected 2.0.6, got {m.group(1)!r}"


def test_v206_version_is_first_non_comment_statement(cell0_text: str) -> None:
    """CLAUDE.md §3a-bis: __AGENT_VERSION__ MUST be the first non-comment
    code statement in the agent cell so a visual inspection can verify."""
    lines = cell0_text.splitlines()
    for i, raw in enumerate(lines, start=1):
        stripped = raw.strip()
        if not stripped or stripped.startswith("#"):
            continue
        assert stripped.startswith("__AGENT_VERSION__"), (
            f"first non-comment line at {i} is {stripped[:120]!r}, "
            f"expected to start with __AGENT_VERSION__"
        )
        return
    pytest.fail("no non-comment statement found in cell")


def test_v206_startup_print_to_stdout(notebook_text: str) -> None:
    """The user's hard requirement: every run MUST emit the agent version
    at startup via plain print() so it shows in Databricks run output."""
    pat = re.compile(
        r'print\(f"\[v206-agent-version-startup-print FIRED\][^"]*'
        r'__AGENT_VERSION__=\{__AGENT_VERSION__\}[^"]*channel=stdout'
    )
    assert pat.search(notebook_text), (
        "stdout startup print of __AGENT_VERSION__ missing from main() — "
        "expected a print(f\"[v206-agent-version-startup-print FIRED] ... "
        "channel=stdout ...\") line"
    )


def test_v206_startup_log_to_volume(notebook_text: str) -> None:
    """The same banner via logger.info so it lands in the volume info.log
    (where the audit grep runs in §10.7 step 6)."""
    pat = re.compile(
        r"logger\.info\(f\"\[v206-agent-version-startup-print FIRED\][^\"]*__AGENT_VERSION__="
    )
    assert pat.search(notebook_text), (
        "logger.info startup-print emission of __AGENT_VERSION__ missing "
        "from get_logger init site"
    )


def test_v206_startup_print_fires_after_logger_init(notebook_text: str) -> None:
    """The logger.info site MUST come AFTER get_logger() so the logger
    exists. Order check guards against a regression where the print is
    moved above the logger init."""
    logger_init = notebook_text.find("logger, log_paths = get_logger(")
    log_print = notebook_text.find(
        '[v206-agent-version-startup-print FIRED] __AGENT_VERSION__='
    )
    # find the second occurrence (the logger.info, not the print to stdout)
    second = notebook_text.find(
        '[v206-agent-version-startup-print FIRED] __AGENT_VERSION__=',
        log_print + 1,
    )
    assert logger_init >= 0, "get_logger init site not found"
    assert second >= 0, "second (logger.info) startup-print site not found"
    assert second > logger_init, (
        f"logger.info startup-print at offset {second} comes BEFORE "
        f"get_logger init at {logger_init} — would NameError at runtime"
    )


def test_v206_constant_no_longer_falsely_claims_canonicalize_on_write(
    cell0_text: str,
) -> None:
    """v205 constant said 'F5 mem/json canonicalize-on-write' but shipped
    only partial-credit (symptom). v206 honest constant must either
    (a) flag this as SYMPTOM not root cause, OR
    (b) actually ship canonicalize-on-write logic.

    This guards against future versions silently dropping the honest
    framing and re-claiming root-cause."""
    constant_line = next(
        (l for l in cell0_text.splitlines() if "__AGENT_VERSION__" in l and "=" in l),
        "",
    )
    # If the constant still includes "canonicalize-on-write", it MUST also
    # include "SYMPTOM" so the reader knows it's framed honestly.
    if "canonicalize-on-write" in constant_line:
        assert "SYMPTOM" in constant_line or "symptom" in constant_line, (
            "v206 constant mentions canonicalize-on-write — it must also "
            "flag F5 as SYMPTOM/symptom or actually ship the canonical logic"
        )


def test_v206_retains_all_v205_aliases(notebook_text: str) -> None:
    """v206 is purely additive over v205. None of the v205 alias markers
    may be lost in the bump."""
    for alias in [
        "v204-verifier-stripped",
        "v204-mv-preservation-invariant",
        "v204-ast-class-retry-feedback",
        "v204-pinned-domains-in-prompt",
        "v205-schema-thread-through-tools-fallback",
        "v205-final-cycle-purge",
        "v205-deterministic-overcount-trim",
        "v205-immutable-mutation-lock",
    ]:
        # Each alias must have ≥1 FIRED-emit line.
        pat = re.compile(rf'\[v20[56][^"]*{re.escape(alias.split("-")[-1])}[^"]*FIRED\]')
        # Fall back to a looser pattern: literal alias somewhere on a FIRED line
        loose = [
            l for l in notebook_text.splitlines()
            if "FIRED" in l and alias in l
        ]
        assert loose, f"v205 alias {alias!r} lost its FIRED-emit line in v206"


def test_v206_no_two_digit_semver_segment(cell0_text: str) -> None:
    """CLAUDE.md §3a — every semver segment is single-digit 0-9."""
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', cell0_text)
    assert m, "version constant must be x.y.z"
    for i, seg in enumerate(m.groups()):
        assert 0 <= int(seg) <= 9, (
            f"semver segment {i+1} = {seg!r} violates §3a (must be 0-9)"
        )
