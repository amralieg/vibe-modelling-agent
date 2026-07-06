from vov_2_0.deduper import (
    cluster_vreqs,
    dedupe_vreqs,
    jaccard,
    merge_cluster,
    _shingle_set,
)
from vov_2_0.types import RawVREQ


def _v(vid, intent, target="x", quote="...", chunk="C1"):
    return RawVREQ(vreq_id=vid, intent=intent, target=target, source_quote=quote, source_chunk_id=chunk)


def test_jaccard_identical_strings_is_1():
    a = _shingle_set("snake_case naming")
    assert jaccard(a, a) == 1.0


def test_jaccard_disjoint_is_0():
    a = _shingle_set("aaaa")
    b = _shingle_set("zzzz")
    assert jaccard(a, b) == 0.0


def test_cluster_groups_near_duplicates():
    vreqs = [
        _v("V1", "use snake_case naming for all entities"),
        _v("V2", "use snake_case naming for all entities"),
        _v("V3", "use snake_case naming convention for all entities"),
        _v("V4", "build 3 metric views"),
    ]
    clusters = cluster_vreqs(vreqs, threshold=0.7)
    snake_cluster = [c for c in clusters if any("snake" in v.intent for v in c)]
    assert len(snake_cluster) == 1
    assert len(snake_cluster[0]) == 3


def test_cluster_keeps_distinct_vreqs_separate():
    vreqs = [
        _v("V1", "use BIGINT for ids"),
        _v("V2", "tag pii=true on customer attrs"),
        _v("V3", "build 4 domains"),
    ]
    clusters = cluster_vreqs(vreqs, threshold=0.85)
    assert len(clusters) == 3


def test_merge_cluster_no_llm_returns_longest():
    cluster = [
        _v("V1", "short"),
        _v("V2", "the longest intent specification of them all", target="t1", quote="quote1"),
        _v("V3", "medium intent here"),
    ]
    merged = merge_cluster(cluster, llm=None)
    assert merged.intent == "the longest intent specification of them all"


def test_merge_cluster_singleton():
    v = _v("V1", "only one")
    out = merge_cluster([v], llm=None)
    assert out.vreq_id == "V1"


def test_dedupe_vreqs_renames_consistently():
    vreqs = [
        _v("V1", "use snake_case for naming"),
        _v("V2", "use snake_case for naming"),
        _v("V3", "tag pii=true for customer fields"),
    ]
    out = dedupe_vreqs(vreqs, threshold=0.8, llm=None)
    assert len(out) == 2
    ids = [v.vreq_id for v in out]
    assert all(i.startswith("VREQ-") for i in ids)
    assert len(set(ids)) == len(ids)


def test_dedupe_vreqs_handles_empty():
    out = dedupe_vreqs([], threshold=0.8, llm=None)
    assert out == []


def test_dedupe_preserves_unique_vreqs():
    vreqs = [
        _v("V1", "domain hr products: employee position job"),
        _v("V2", "domain project products: project material schedule"),
        _v("V3", "tag prefix is ncdot_"),
        _v("V4", "PK suffix is _id"),
        _v("V5", "type for ids is BIGINT"),
        _v("V6", "metric view 1: vacancy rate"),
        _v("V7", "metric view 2: headcount"),
    ]
    out = dedupe_vreqs(vreqs, threshold=0.85, llm=None)
    assert len(out) == 7


def test_dedupe_high_threshold_keeps_more_separate():
    vreqs = [
        _v("V1", "use snake_case naming throughout the model"),
        _v("V2", "use snake_case naming convention throughout the model"),
    ]
    high = dedupe_vreqs(vreqs, threshold=0.99, llm=None)
    low = dedupe_vreqs(vreqs, threshold=0.6, llm=None)
    assert len(high) >= len(low)
