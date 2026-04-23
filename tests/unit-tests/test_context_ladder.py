"""Tests for run_with_context_ladder — v0.8.0 greedy-first ladder."""
import pytest


def _load():
    from agent_helpers import run_with_context_ladder  # noqa
    return run_with_context_ladder


class TestContextLadder:
    def test_empty_items_returns_none(self):
        fn = _load()
        assert fn([], lambda items, variant=None: "ok") is None

    def test_rung1_full_success(self):
        fn = _load()
        calls = []
        def _run(items, variant=None):
            calls.append(variant)
            return f"processed-{len(items)}"
        result = fn([1,2,3], _run)
        assert result == "processed-3"
        assert calls == ["full"]  # rung 1 wins

    def test_rung2_on_context_overflow(self):
        fn = _load()
        calls = []
        def _run(items, variant=None):
            calls.append(variant)
            if variant == "full":
                raise RuntimeError("context length exceeded")
            return "ok"
        result = fn([1,2,3], _run)
        assert calls == ["full", "no_desc"]
        assert result == "ok"

    def test_rung3_on_timeout(self):
        fn = _load()
        calls = []
        def _run(items, variant=None):
            calls.append(variant)
            if variant in ("full","no_desc"):
                raise TimeoutError("timeout")
            return "ok"
        result = fn([1,2,3], _run)
        assert "trunc_attrs" in calls

    def test_non_recoverable_error_reraises(self):
        fn = _load()
        def _run(items, variant=None):
            raise ValueError("bad input, not recoverable")
        with pytest.raises(ValueError):
            fn([1,2,3], _run)

    def test_greedy_cap_skip_to_halve(self):
        fn = _load()
        calls = []
        def _run(items, variant=None):
            calls.append((variant, len(items)))
            return "ok"
        # 100 items, cap=10 → skips greedy rungs, goes to halving
        result = fn(list(range(100)), _run, greedy_cap=10)
        # Rung 4 halving is called (via trunc_attrs variant)
        assert any(v == "trunc_attrs" for v,_ in calls)
