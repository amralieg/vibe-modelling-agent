"""Behavioral tests for v2.8.6 — VOV BATCH-SPLIT (alias=vov-batch-split) + targeted-cap safety net.

Live Pulse 6 on the v2.8.5 swarm: VOV_2_SANDBOX synthesis prompts crossed the Claude Opus
context limit -> HARD `ValueError: Context size exceeded` (fe-adp/consumer_goods 955,579 chars,
<profile>/manufacturing 889,151 chars, <profile>/healthcare 1033K). Root cause: TARGET_ENTITIES_FULL
was the ONE uncapped field; v2.8.5 Fix 1A made many VREQs resolve to DOMAIN-LEVEL (d,'*')
targets and each domain expanded to all 60+ products x attrs in a SINGLE prompt.

The FIRST attempt (truncate at 65KB) was wrong: it silently drops products so the VREQ never
reaches them -> coverage loss on exactly the wide models that need it. Per the user directive
("do not just cap and strip valuable content, split the prompt into pieces by domain/product"),
the PRIMARY strategy is now SPLIT, not strip:

  _vov286_split_batches_by_budget partitions an oversized batch's target PRODUCTS into groups
  <= budget bytes along (domain,product) boundaries. Every product's full attributes travel
  intact in exactly ONE sub-batch; sub-batches keep the same vreq_ids/intent/data_payload and
  carry DISJOINT concrete targets so plan_waves co-schedules them in ONE parallel wave.

These tests exec the REAL notebook splitter + synthesize_handler and assert the OBSERVABLE
contrasts: split happens, NO product is lost, every sub-prompt is under budget, small/global
batches pass through untouched, and the split sub-batches schedule into a single parallel wave.
"""
import ast
import json
import re
import dataclasses

from notebook_source_util import notebook_concat_source, slice_function_source

SRC = notebook_concat_source()


@dataclasses.dataclass(frozen=True)
class _Batch:
    batch_id: str
    vreq_ids: tuple
    intent_summary: str
    target_entities: tuple
    data_payload: tuple


def _wide_model(n_domains=1, n_products=80, n_attrs=120):
    domains = []
    for d in range(n_domains):
        prods = []
        for i in range(n_products):
            attrs = [{"name": f"col_{i}_{j}", "data_type": "STRING",
                      "foreign_key_to": None, "tags": {}} for j in range(n_attrs)]
            prods.append({"name": f"product_{i:02d}", "attributes": attrs})
        domains.append({"name": f"dom{d}" if n_domains > 1 else "ops", "products": prods})
    return {"model": {"domains": domains, "metric_views": []}}


# ---------- version + sentinel contract ----------

def test_version_286_and_split_alias_present():
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', SRC)
    # v2.8.6 ships the split; later patches keep it. Pin >= 2.8.6 (exact-version pin lives in the
    # latest version's test file) so this regression test survives subsequent single-digit bumps.
    assert m, "no __AGENT_VERSION__"
    seg = tuple(int(x) for x in m.group(1).split("."))
    assert seg >= (2, 8, 6), f"expected >= 2.8.6, got {m.group(1)}"
    assert "vov-batch-split FIRED" in SRC
    assert "_vov286_split_batches_by_budget" in SRC
    # split is applied to _batches BEFORE synthesis (contract preserved)
    assert "_batches = _vov286_split_batches_by_budget(_batches, model, budget=48000)" in SRC


# ---------- splitter behavior ----------

def _exec_splitter_ns():
    ns = {"__name__": "_v286_split", "json": json, "_Batch": _Batch}
    for name in ["_vov286_ser_attr", "_vov286_split_batches_by_budget"]:
        exec(compile(slice_function_source(name, source=SRC), f"<{name}>", "exec"), ns)
    return ns


def _mk_batch(target_entities, bid="b1"):
    return _Batch(batch_id=bid, vreq_ids=("vreq_1", "vreq_2"),
                  intent_summary="tag every table with source-trace",
                  target_entities=tuple(target_entities), data_payload=({"row": 1},))


def test_domain_level_batch_is_split_not_truncated():
    """A domain-level (d,'*') target on a wide model must split into >1 sub-batch, and the
    UNION of sub-batch targets must equal ALL products in the domain (zero loss)."""
    ns = _exec_splitter_ns()
    model = _wide_model(n_products=80, n_attrs=120)
    out = ns["_vov286_split_batches_by_budget"]([_mk_batch([("ops", "*")])], model, budget=48000)
    assert len(out) > 1, f"wide domain batch must split, got {len(out)} sub-batches"
    # no product lost
    union = set()
    for b in out:
        for te in b.target_entities:
            union.add(te)
    expected = {("ops", f"product_{i:02d}") for i in range(80)}
    assert union == expected, f"products lost in split: missing {expected - union}, extra {union - expected}"


def test_each_subbatch_under_budget():
    """Every sub-batch's serialized TARGET_ENTITIES_FULL must be <= budget (the whole point)."""
    ns = _exec_splitter_ns()
    model = _wide_model(n_products=80, n_attrs=120)
    budget = 48000
    out = ns["_vov286_split_batches_by_budget"]([_mk_batch([("ops", "*")])], model, budget=budget)
    prod_attrs = {(d["name"], p["name"]): p["attributes"]
                  for d in model["model"]["domains"] for p in d["products"]}
    for b in out:
        ser = [{"domain": d, "name": p,
                "attributes": [ns["_vov286_ser_attr"](a) for a in prod_attrs[(d, p)][:160]]}
               for d, p in b.target_entities]
        assert len(json.dumps(ser)) <= budget, f"sub-batch {b.batch_id} exceeds budget"


def test_subbatch_targets_are_concrete_and_disjoint():
    ns = _exec_splitter_ns()
    model = _wide_model(n_products=80)
    out = ns["_vov286_split_batches_by_budget"]([_mk_batch([("ops", "*")])], model, budget=48000)
    seen = set()
    for b in out:
        for te in b.target_entities:
            assert te[1] != "*", "sub-batch target must be concrete (no '*')"
            assert te not in seen, "sub-batch targets must be disjoint"
            seen.add(te)


def test_subbatches_preserve_vreq_intent_payload():
    ns = _exec_splitter_ns()
    model = _wide_model(n_products=80)
    parent = _mk_batch([("ops", "*")])
    out = ns["_vov286_split_batches_by_budget"]([parent], model, budget=48000)
    for b in out:
        assert b.vreq_ids == parent.vreq_ids
        assert b.intent_summary == parent.intent_summary
        assert b.data_payload == parent.data_payload


def test_small_batch_passes_through_unchanged():
    ns = _exec_splitter_ns()
    model = _wide_model(n_products=80)
    b = _mk_batch([("ops", "product_00")])
    out = ns["_vov286_split_batches_by_budget"]([b], model, budget=48000)
    assert len(out) == 1 and out[0].batch_id == "b1", "small batch must pass through unchanged"


def test_global_batch_passes_through_unchanged():
    """Global ('*','*') carries an empty TARGET_ENTITIES_FULL -> no size risk -> untouched."""
    ns = _exec_splitter_ns()
    model = _wide_model(n_products=80)
    b = _mk_batch([("*", "*")])
    out = ns["_vov286_split_batches_by_budget"]([b], model, budget=48000)
    assert len(out) == 1 and out[0].target_entities == (("*", "*"),)


# ---------- split sub-batches schedule into ONE parallel wave ----------

def _exec_planwaves_ns():
    ns = {"__name__": "_v286_pw"}
    for name in ["_entities_set", "_has_global", "_conflicts", "plan_waves"]:
        exec(compile(slice_function_source(name, source=SRC), f"<{name}>", "exec"), ns)
    return ns


class _H:
    def __init__(self, te):
        self.target_entities = tuple(te)


def test_split_subbatches_share_one_parallel_wave():
    """End-to-end: split a wide domain batch -> disjoint concrete sub-batches -> plan_waves
    co-schedules ALL of them in ONE wave (parallel apply), unlike the pre-split single
    oversized batch which could not even be synthesized."""
    sp = _exec_splitter_ns()
    pw = _exec_planwaves_ns()
    model = _wide_model(n_products=80)
    out = sp["_vov286_split_batches_by_budget"]([_mk_batch([("ops", "*")])], model, budget=48000)
    waves = pw["plan_waves"]([_H(b.target_entities) for b in out])
    assert len(waves) == 1, f"disjoint sub-batches must be one parallel wave, got {len(waves)}"
    assert len(waves[0]) == len(out)


# ---------- safety-net cap still present (defense in depth) ----------

def test_targeted_cap_safety_net_present():
    assert "vov-targeted-cap" in SRC
    assert "_TGT_BUDGET" in SRC
    # the shared DRY serializer replaced the per-call nested copy
    assert "_vov283_ser_attr = _vov286_ser_attr" in SRC
