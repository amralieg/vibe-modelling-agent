"""
v4.2.3 behavioral tests — foreign_key_to:string boundary invariant.

ROOT CAUSE (restaurants v2 ECM VOV, run 680029593930392 attempt-0):
    AttributeError: 'list' object has no attribute 'split'
    File _build_fk_adjacency.<locals>._compute, line ...: fk_parts = fk.split('.')
An unnormalized multi-FK LLM mutation stored `foreign_key_to` as a LIST on an
attribute; every one of the 30+ `fk.split('.')` consumers (cycle-detection,
finalize, metric-view gen, PK consistency) then crashed on the non-str value.

FIX (mirrors the proven _coerce_tags_to_string_v250 / _enforce_string_tags_invariant_v250):
  * _coerce_fk_to_string_v423        — canonical list/None/non-str -> string coercion.
  * _enforce_string_fk_invariant_v423 — model-wide boundary sweep (4 call sites).
  * _build_fk_adjacency._compute      — iterates list targets, coerces each (crash site).
  * parse_fk_reference                — coerces input via the SSOT helper.

Each test proves the post-patch behavior AND replicates the pre-patch crash (§8.10).
"""
import json
import os
import re

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _cells():
    return json.load(open(NB))["cells"]


def _src_containing(needle):
    for c in _cells():
        if c["cell_type"] != "code":
            continue
        s = "".join(c["source"])
        if needle in s:
            return s
    raise AssertionError(f"cell containing {needle!r} not found")


def _extract_toplevel_func(src, name):
    lines = src.split("\n")
    start = None
    for i, ln in enumerate(lines):
        if ln.startswith(f"def {name}("):
            start = i
            break
    assert start is not None, f"def {name}( not found"
    out = [lines[start]]
    for ln in lines[start + 1:]:
        if ln.strip() == "" or ln[:1] in (" ", "\t"):
            out.append(ln)
        else:
            break
    return "\n".join(out)


def _load(name, extra_globals=None):
    src = _src_containing(f"def {name}(")
    g = {"re": re}
    if extra_globals:
        g.update(extra_globals)
    exec(_extract_toplevel_func(src, name), g)
    return g[name]


class TestCoerceFkToString:
    def test_string_passthrough(self):
        f = _load("_coerce_fk_to_string_v423")
        assert f("dom.prod.pk_id") == "dom.prod.pk_id"

    def test_none_and_empty(self):
        f = _load("_coerce_fk_to_string_v423")
        assert f(None) == ""
        assert f([]) == ""

    def test_list_collapses_to_primary_dotted(self):
        f = _load("_coerce_fk_to_string_v423")
        # multi-FK list -> first dotted target wins (primary); label mechanism keeps the rest
        assert f(["a.p.pk", "b.q.pk"]) == "a.p.pk"
        # non-dotted junk elements skipped in favour of the first dotted ref
        assert f(["notdotted", "c.r.pk"]) == "c.r.pk"

    def test_non_str_scalar(self):
        f = _load("_coerce_fk_to_string_v423")
        assert f(123) == "123"


class TestEnforceStringFkInvariant:
    def test_coerces_list_fk_and_counts(self):
        coerce = _load("_coerce_fk_to_string_v423")
        enforce = _load("_enforce_string_fk_invariant_v423",
                        {"_coerce_fk_to_string_v423": coerce})
        attrs = [
            {"domain": "a", "product": "p1", "attribute": "b_id", "foreign_key_to": ["b.p2.pk"]},
            {"domain": "a", "product": "p1", "attribute": "name", "foreign_key_to": ""},
            {"domain": "a", "product": "p1", "attribute": "c_id", "foreign_key_to": "c.p3.pk"},
        ]
        n = enforce(attrs, logger=None, site_alias="test")
        assert n == 1, n
        assert attrs[0]["foreign_key_to"] == "b.p2.pk"   # list coerced to string
        assert isinstance(attrs[0]["foreign_key_to"], str)
        assert attrs[2]["foreign_key_to"] == "c.p3.pk"   # already-string untouched

    def test_string_only_model_no_coercion(self):
        coerce = _load("_coerce_fk_to_string_v423")
        enforce = _load("_enforce_string_fk_invariant_v423",
                        {"_coerce_fk_to_string_v423": coerce})
        attrs = [{"domain": "a", "product": "p", "attribute": "x", "foreign_key_to": "b.q.pk"}]
        assert enforce(attrs, logger=None, site_alias="test") == 0


class TestBuildFkAdjacencyListFk:
    def _build(self):
        return _load("_build_fk_adjacency", {"_disk_cached_call": lambda pfx, key, fn: fn()})

    def test_prepatch_list_fk_would_crash(self):
        # PRE-PATCH: `fk = attr.get('foreign_key_to','')` then `fk.split('.')` on a list -> AttributeError
        def _prepatch_compute(attributes_data):
            adj = {}
            for attr in attributes_data:
                fk = attr.get("foreign_key_to", "")
                if not fk:
                    continue
                fk_parts = fk.split(".")  # crashes when fk is a list
                if len(fk_parts) < 2:
                    continue
                adj.setdefault("x", set()).add("y")
            return adj
        with pytest.raises(AttributeError):
            _prepatch_compute([{"domain": "a", "product": "p1", "foreign_key_to": ["b.p2.pk"]}])

    def test_postpatch_list_fk_builds_edge(self):
        build = self._build()
        attrs = [{"domain": "a", "product": "p1", "foreign_key_to": ["b.p2.pk"]}]
        adj = build(attrs)  # must NOT raise
        assert "a.p1" in adj
        assert "b.p2" in adj["a.p1"]

    def test_postpatch_multi_target_list_all_edges(self):
        build = self._build()
        attrs = [{"domain": "a", "product": "p1", "foreign_key_to": ["b.p2.pk", "c.p3.pk"]}]
        adj = build(attrs)
        assert adj["a.p1"] == {"b.p2", "c.p3"}

    def test_postpatch_string_fk_unchanged(self):
        build = self._build()
        attrs = [{"domain": "a", "product": "p1", "foreign_key_to": "b.p2.pk"}]
        adj = build(attrs)
        assert adj["a.p1"] == {"b.p2"}


class TestParseFkReferenceListInput:
    def _load_pfr(self):
        coerce = _load("_coerce_fk_to_string_v423")
        return _load("parse_fk_reference", {"_coerce_fk_to_string_v423": coerce})

    def test_prepatch_list_returns_all_none(self):
        # PRE-PATCH: `'.' not in fk_string` on a list is True (membership, not substring) -> (None,None,None)
        def _prepatch(fk_string):
            if not fk_string or "." not in fk_string:
                return None, None, None
            parts = fk_string.split(".")
            return parts[0], parts[1] if len(parts) > 1 else None, parts[2] if len(parts) > 2 else None
        assert _prepatch(["d.p.pk"]) == (None, None, None)

    def test_postpatch_list_parsed(self):
        pfr = self._load_pfr()
        assert pfr(["d.p.pk"]) == ("d", "p", "pk")

    def test_postpatch_string_unchanged(self):
        pfr = self._load_pfr()
        assert pfr("d.p.pk") == ("d", "p", "pk")
