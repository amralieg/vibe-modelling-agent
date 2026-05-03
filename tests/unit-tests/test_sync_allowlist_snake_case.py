"""v0.7.2 (alias=sync-allowlist-snake-case) — unit tests for the
sync_to_repo allowlist-normalization fix.

ROOT CAUSE under test:
The orchestrator (orchestrate_sectors.py L463-475) builds `green_industries`
from `state.industries[ind].status.startswith('green')` — those `ind` keys
preserve the original widget capitalization (e.g. "Health Insurance",
"Payments Fintech"). It then passes that list verbatim as
`sync_completed_industries(industry_allowlist=green_industries)`.

Inside sync_to_repo, `_list_workspace_industries()` returns the SANITIZED
basenames of `/Users/.../vibe_runner_models/<industry>/` — those folder
names are written by the runner using `sanitize_name()` which lowercases
and snake_cases ("Health Insurance" → "health_insurance"). The pre-fix
intersection (`industries = [i for i in industries if i in allow]`) was
ALWAYS empty when the orchestrator was the caller, producing the silent
zero-push that left Banking + Health Insurance sitting in the workspace
for hours after their sectors completed.

This test exercises the fix in isolation by importing sync_to_repo and
monkeypatching the workspace-list helper.
"""
import sys
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT / "runner"))

import sync_to_repo as _sr


@pytest.fixture(autouse=True)
def _no_external_calls(monkeypatch):
    """Make sure the test never touches git or the network."""
    def _bail_repo(*a, **k):
        return True
    monkeypatch.setattr(_sr, "_ensure_repo_clone", _bail_repo)


def _patch_ws_list(monkeypatch, names):
    monkeypatch.setattr(_sr, "_list_workspace_industries", lambda *a, **k: list(names))


def _capture_log():
    out = []
    return out, lambda m: out.append(m)


class TestAllowlistSnakeCaseNormalization:
    def test_display_name_allowlist_matches_snake_case_dirs(self, tmp_path, monkeypatch):
        """The exact orchestrator scenario: allowlist contains 'Health Insurance'
        (display name from state.json), workspace dir is 'health_insurance'."""
        _patch_ws_list(monkeypatch, ["agriculture", "health_insurance", "banking"])
        # Simulate "already in repo" so we don't actually export — we only need
        # to prove the matching produced a non-empty `industries` list.
        for d in ["health_insurance", "banking"]:
            (tmp_path / d).mkdir()
            (tmp_path / d / "readme.md").write_text("placeholder")

        log_lines, log_fn = _capture_log()
        result = _sr.sync_completed_industries(
            repo_path=str(tmp_path),
            industry_allowlist=["Health Insurance", "Banking"],
            log=log_fn,
        )

        assert "sync-allowlist-snake-case FIRED" in "\n".join(log_lines)
        # Both should be detected as already-present (non-empty intersection).
        assert sorted(result["skipped_existing"]) == ["banking", "health_insurance"]
        assert result["synced"] == []
        assert result["failed"] == []

    def test_mixed_case_with_special_chars_normalized(self, tmp_path, monkeypatch):
        _patch_ws_list(monkeypatch, ["payments_fintech", "real_estate", "media_broadcasting"])
        for d in ["payments_fintech", "real_estate", "media_broadcasting"]:
            (tmp_path / d).mkdir()
            (tmp_path / d / "readme.md").write_text("placeholder")

        log_lines, log_fn = _capture_log()
        result = _sr.sync_completed_industries(
            repo_path=str(tmp_path),
            industry_allowlist=["Payments Fintech", "Real Estate", "Media-Broadcasting"],
            log=log_fn,
        )

        assert sorted(result["skipped_existing"]) == sorted(
            ["payments_fintech", "real_estate", "media_broadcasting"]
        )

    def test_already_snake_case_passes_through_unchanged(self, tmp_path, monkeypatch):
        _patch_ws_list(monkeypatch, ["banking", "health_insurance"])
        for d in ["banking", "health_insurance"]:
            (tmp_path / d).mkdir()
            (tmp_path / d / "readme.md").write_text("placeholder")

        log_lines, log_fn = _capture_log()
        result = _sr.sync_completed_industries(
            repo_path=str(tmp_path),
            industry_allowlist=["banking", "health_insurance"],
            log=log_fn,
        )
        assert sorted(result["skipped_existing"]) == ["banking", "health_insurance"]

    def test_unknown_allowlist_entry_does_not_match(self, tmp_path, monkeypatch):
        """A typo or stale name in allowlist should produce zero matches and a clear log."""
        _patch_ws_list(monkeypatch, ["banking", "health_insurance"])
        log_lines, log_fn = _capture_log()
        result = _sr.sync_completed_industries(
            repo_path=str(tmp_path),
            industry_allowlist=["NonExistentIndustry"],
            log=log_fn,
        )
        assert result["synced"] == []
        assert result["skipped_existing"] == []
        assert "no industries found" in "\n".join(log_lines)

    def test_no_allowlist_returns_all(self, tmp_path, monkeypatch):
        """Backwards-compat: no allowlist should still process every workspace dir."""
        _patch_ws_list(monkeypatch, ["banking", "health_insurance"])
        for d in ["banking", "health_insurance"]:
            (tmp_path / d).mkdir()
            (tmp_path / d / "readme.md").write_text("placeholder")

        log_lines, log_fn = _capture_log()
        result = _sr.sync_completed_industries(
            repo_path=str(tmp_path),
            industry_allowlist=None,
            log=log_fn,
        )
        assert sorted(result["skipped_existing"]) == ["banking", "health_insurance"]
        assert "sync-allowlist-snake-case FIRED" not in "\n".join(log_lines)
