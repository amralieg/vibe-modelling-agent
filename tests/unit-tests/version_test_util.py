"""Version assertions that track live __AGENT_VERSION__, not frozen semver strings."""
from __future__ import annotations

import re

import agent_helpers as ah


def agent_version() -> str:
    return getattr(ah, "__AGENT_VERSION__", "")


def assert_valid_single_digit_semver(version: str | None = None) -> None:
    version = version or agent_version()
    parts = version.split(".")
    assert parts, f"invalid __AGENT_VERSION__: {version!r}"
    for p in parts:
        assert len(p) == 1 and p.isdigit(), (
            f"segment {p!r} in {version!r} violates single-digit semver (CLAUDE.md §3a)"
        )


def assert_version_in_notebook(agent_text: str, version: str | None = None) -> None:
    version = version or agent_version()
    import re

    assert re.search(
        rf'__AGENT_VERSION__\s*=\s*\\?"{re.escape(version)}\\?"',
        agent_text,
    ), f"__AGENT_VERSION__ = {version!r} not found in notebook source"


def assert_alias_in_notebook(agent_text: str, alias: str) -> None:
    assert alias in agent_text, f"alias={alias} not found in notebook source"


def semver_tuple(version: str | None = None) -> tuple[int, ...]:
    version = version or agent_version()
    return tuple(int(x) for x in version.split("."))


def assert_version_at_least(min_version: str, agent_text: str | None = None) -> None:
    """True for single-digit semver segments when min_version <= current."""
    current = semver_tuple()
    minimum = semver_tuple(min_version)
    assert current >= minimum, f"agent {agent_version()!r} < required {min_version!r}"


def assert_aliases_present(agent_text: str, aliases: list[str]) -> None:
    """Assert each alias exists; skip removed aliases only when allow_missing=True."""
    missing = [a for a in aliases if a not in agent_text]
    assert not missing, f"aliases missing from notebook: {missing}"
