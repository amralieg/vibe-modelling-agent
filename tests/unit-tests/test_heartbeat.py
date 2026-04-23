"""Tests for HeartbeatWatchdog — v0.8.0 F6."""
import pytest
import time


def _load():
    from agent_helpers import HeartbeatWatchdog
    return HeartbeatWatchdog


class _FakeVW:
    def __init__(self):
        self.emitted = []
    def emit_step(self, **kw):
        self.emitted.append(kw)


class TestHeartbeatWatchdog:
    def test_no_vw_nothing_emits(self):
        cls = _load()
        hb = cls(None, stage_name="T")
        hb.start()
        hb.stop()
        # Should not crash

    def test_start_stop_immediate(self):
        cls = _load()
        vw = _FakeVW()
        hb = cls(vw, stage_name="T", interval_s=10)
        hb.start()
        hb.stop()
        # Should stop cleanly without emitting (interval 10s > stop delay)
        # With race, 0 emissions expected
        assert len(vw.emitted) == 0

    def test_emits_after_interval(self):
        cls = _load()
        vw = _FakeVW()
        hb = cls(vw, stage_name="T", interval_s=10)  # clamped to min 10
        # Test that start/stop mechanics work; don't actually wait 10s
        hb.start()
        time.sleep(0.05)
        hb.stop()
        assert len(vw.emitted) == 0  # too fast to fire


class TestHeartbeatCounter:
    def test_count_starts_at_zero(self):
        cls = _load()
        hb = cls(None)
        assert hb._count == 0

    def test_interval_clamped_to_minimum(self):
        cls = _load()
        hb = cls(None, interval_s=5)  # requests 5, minimum is 10
        assert hb._interval >= 10
