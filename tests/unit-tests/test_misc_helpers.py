"""Tests for miscellaneous helpers identified as critical in honesty audit."""
import pytest


class TestModuleLoads:
    """Baseline: verify agent_helpers module loaded with expected critical functions."""
    def test_core_functions_present(self):
        import agent_helpers as ah
        # Core parsing / validation
        assert hasattr(ah, '_parse_ce_counts')
        assert hasattr(ah, '_is_link_excluded_by_candidate_eval')
        # Catalog / DDL
        assert hasattr(ah, '_ensure_catalog_exists')
        assert hasattr(ah, '_resolve_managed_location')
        # Chunking helpers
        assert hasattr(ah, 'run_batch_with_halving_on_timeout')
        assert hasattr(ah, 'run_with_context_ladder')
        # Heartbeat
        assert hasattr(ah, 'HeartbeatWatchdog')
        # Sanitization
        assert hasattr(ah, 'sanitize_name')
        assert hasattr(ah, 'replace_single_quote')

    def test_no_critical_load_errors(self):
        import agent_helpers as ah
        # load_error is the first error during per-node exec;
        # load_errors is the full list. Acceptable (non-blocking) errors: ImportError on
        # optional runtime deps. Critical errors: NameError on core constants.
        errors = getattr(ah, '_load_errors', [])
        critical = [e for e in errors
                   if 'NameError' in e and
                      any(c in e for c in ('_resolve_managed_location',
                                           'run_with_context_ladder',
                                           'HeartbeatWatchdog'))]
        assert not critical, f"critical NameErrors: {critical[:3]}"


class TestResolveManagedLocationSignature:
    def test_accepts_keyword_logger(self):
        from agent_helpers import _resolve_managed_location
        class _Broken:
            def sql(self, q): raise RuntimeError("no")
        # Should not raise
        result = _resolve_managed_location(_Broken(), logger=None)
        assert result == ""

    def test_accepts_positional_logger(self):
        from agent_helpers import _resolve_managed_location
        class _Broken:
            def sql(self, q): raise RuntimeError("no")
        result = _resolve_managed_location(_Broken())
        assert result == ""


class TestRunBatchHalving:
    def test_happy_path_no_halving(self):
        from agent_helpers import run_batch_with_halving_on_timeout
        calls = []
        def _run(items):
            calls.append(len(items))
            return f"done-{len(items)}"
        result = run_batch_with_halving_on_timeout([1,2,3,4], _run)
        assert result == "done-4"
        assert calls == [4]

    def test_halves_on_timeout(self):
        from agent_helpers import run_batch_with_halving_on_timeout
        calls = []
        def _run(items):
            calls.append(len(items))
            if len(items) == 4:
                raise TimeoutError("timeout")
            return [f"ok-{i}" for i in items]
        result = run_batch_with_halving_on_timeout([1,2,3,4], _run)
        # Should have tried 4, then 2+2
        assert calls[0] == 4
        assert 2 in calls

    def test_reraises_non_timeout(self):
        from agent_helpers import run_batch_with_halving_on_timeout
        def _run(items):
            raise ValueError("schema invalid")
        with pytest.raises(ValueError):
            run_batch_with_halving_on_timeout([1,2,3,4], _run)

    def test_min_batch_size_reraises_after_reaching(self):
        from agent_helpers import run_batch_with_halving_on_timeout
        def _run(items):
            raise TimeoutError("always times out")
        with pytest.raises(TimeoutError):
            run_batch_with_halving_on_timeout([1,2,3,4], _run, min_batch_size=1)
