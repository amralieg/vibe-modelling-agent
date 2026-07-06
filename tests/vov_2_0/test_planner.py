from vov_2_0.planner import plan_waves, _conflicts, _entities_set
from vov_2_0.types import Handler


def _h(bid, target_entities):
    return Handler(
        batch_id=bid,
        mutator_src="def mutator(model, data):\n    return model\n",
        verifier_src="def verifier(model, data):\n    return (True, '')\n",
        expected_changes_summary="",
        target_entities=tuple(target_entities),
    )


def test_plan_waves_empty():
    assert plan_waves([]) == []


def test_plan_waves_disjoint_targets_run_in_one_wave():
    handlers = [
        _h("B1", [("hr", "employee")]),
        _h("B2", [("project", "schedule")]),
        _h("B3", [("finance", "invoice")]),
    ]
    waves = plan_waves(handlers)
    assert len(waves) == 1
    assert len(waves[0]) == 3


def test_plan_waves_overlapping_targets_split_into_separate_waves():
    handlers = [
        _h("B1", [("hr", "employee")]),
        _h("B2", [("hr", "employee")]),
    ]
    waves = plan_waves(handlers)
    assert len(waves) == 2


def test_plan_waves_global_target_blocks_all():
    handlers = [
        _h("B1", [("*", "*")]),
        _h("B2", [("hr", "employee")]),
        _h("B3", [("project", "schedule")]),
    ]
    waves = plan_waves(handlers)
    assert len(waves) == 2
    global_wave = [w for w in waves if any(h.batch_id == "B1" for h in w)][0]
    other_wave = [w for w in waves if w is not global_wave][0]
    assert len(global_wave) == 1
    assert len(other_wave) == 2


def test_plan_waves_domain_wildcard_blocks_specific_product_in_same_domain():
    handlers = [
        _h("B1", [("hr", "*")]),
        _h("B2", [("hr", "employee")]),
        _h("B3", [("project", "schedule")]),
    ]
    waves = plan_waves(handlers)
    assert len(waves) == 2
    same_wave_b1_b3 = any(
        any(h.batch_id == "B1" for h in w) and any(h.batch_id == "B3" for h in w)
        for w in waves
    )
    assert same_wave_b1_b3


def test_conflicts_logic_simple():
    a = _entities_set([("hr", "employee")])
    b = _entities_set([("hr", "position")])
    assert not _conflicts(a, b)


def test_conflicts_logic_overlapping_pair():
    a = _entities_set([("hr", "employee")])
    b = _entities_set([("hr", "employee")])
    assert _conflicts(a, b)


def test_conflicts_logic_global_against_anything():
    a = _entities_set([("*", "*")])
    b = _entities_set([("hr", "employee")])
    assert _conflicts(a, b)


def test_plan_waves_preserves_all_handlers():
    handlers = [_h(f"B{i}", [(f"d{i}", "p")]) for i in range(7)]
    waves = plan_waves(handlers)
    seen = {h.batch_id for w in waves for h in w}
    assert seen == {h.batch_id for h in handlers}


def test_plan_waves_three_levels():
    handlers = [
        _h("B1", [("*", "*")]),
        _h("B2", [("hr", "*")]),
        _h("B3", [("hr", "employee")]),
    ]
    waves = plan_waves(handlers)
    assert len(waves) == 3
