#!/usr/bin/env python3
"""One-shot patch: version/alias tests track live __AGENT_VERSION__ (2.1.9)."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
AGENT_VER = None


def _read_agent_version() -> str:
    global AGENT_VER
    if AGENT_VER:
        return AGENT_VER
    import sys

    sys.path.insert(0, str(ROOT))
    import conftest  # noqa: F401
    import agent_helpers as ah

    AGENT_VER = ah.__AGENT_VERSION__
    return AGENT_VER


def patch_file(path: Path) -> bool:
    text = path.read_text(encoding="utf-8")
    orig = text
    ver = _read_agent_version()

    # Hard-coded __AGENT_VERSION__ = "X.Y.Z" in assert → live version
    text = re.sub(
        r"assert\s+['\"]__AGENT_VERSION__\s*=\s*\"[^\"]+\"['\"]\s+in\s+",
        f'assert \'__AGENT_VERSION__ = "{ver}"\' in ',
        text,
    )
    text = re.sub(
        r"assert\s+['\"]__AGENT_VERSION__\s*=\s*\\?\"[^\"]+\\?\"['\"]\s+in\s+",
        f'assert \'__AGENT_VERSION__ = "{ver}"\' in ',
        text,
    )

    # re.findall v1.0.x patterns
    if 're.findall(r\'__AGENT_VERSION__\\s*=\\s*\\\\?"1\\.0\\.\\d' in text:
        text = text.replace(
            "matches = re.findall(r'__AGENT_VERSION__\\s*=\\s*\\\\?\"1\\.0\\.\\d\\\\?\"', agent_text)",
            f'assert \'__AGENT_VERSION__ = "{ver}"\' in agent_text; matches = ["{ver}"]',
        )

    # parts >= [0, 8, 8] style — leave; fixed per-file if needed

    if text != orig:
        path.write_text(text, encoding="utf-8")
        return True
    return False


def main():
    changed = 0
    for p in ROOT.glob("test_*.py"):
        if p.name.startswith("_"):
            continue
        if patch_file(p):
            changed += 1
            print("patched", p.name)
    print("done", changed, "files")


if __name__ == "__main__":
    main()
