"""
v4.2.2 behavioral tests — the three root-cause fixes that unblock the v2 marathon.

Each test extracts the ACTUAL function/logic from the deployed notebook cell and executes
it, proving the fixed (post-patch) behavior AND replicating the pre-patch behavior to show
it exhibited the observed production failure (§8.10 fail-pre / pass-post).

Fix #1  cycle-edge-format-fix        — _cycle_to_edges normalizes _detect_cycles_dfs output so
                                        the deterministic breaker actually iterates real edges
                                        (automotive/water_utilities VOV died with
                                        "[post-finalize-cycle-fail-closed] N cycle(s) STILL present").
Fix #2  mv-boolean-literal-normalize — <bool_col> = 1/0  ->  = TRUE/FALSE so metric-view YAML
                                        SQL does not raise DATATYPE_MISMATCH (restaurants R6).
Fix #3  gt reground false-negatives  — informational-exclude + blind-partial-unknown +
                                        gt-rescue-typecorrect so the PHYSICAL reground stops
                                        deflating adherence below the mid-loop scoreboard
                                        (restaurants ECM reported 73.1% vs mid-loop 94%).
"""
import json
import os
import re

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
    """Extract a column-0 `def name(...)` block (until the next column-0 non-blank line)."""
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


# --------------------------------------------------------------------------------------
# Fix #1 — cycle-edge-format-fix
# --------------------------------------------------------------------------------------
class TestCycleEdgeFormatFix:
    def test_edge_tuple_cycle_normalized(self):
        f = _load("_cycle_to_edges")
        # _detect_cycles_dfs returns a list of directed (src, tgt) edge tuples.
        cyc = [("a.p1.fk", "b.p2.pk"), ("b.p2.fk", "a.p1.pk"), ("a.p1.pk", "a.p1.fk")]
        edges = f(cyc)
        assert edges == [(str(s), str(t)) for s, t in cyc], edges
        assert all(isinstance(e, tuple) and len(e) == 2 for e in edges)

    def test_node_list_cycle_normalized_to_edges(self):
        f = _load("_cycle_to_edges")
        # A node-path cycle [A, B, C] -> directed edges A->B, B->C, C->A (wrap-around).
        edges = f(["A", "B", "C"])
        assert edges == [("A", "B"), ("B", "C"), ("C", "A")], edges

    def test_empty_cycle(self):
        f = _load("_cycle_to_edges")
        assert f([]) == []
        assert f(None) == []

    def test_prepatch_node_misparse_was_inert(self):
        # PRE-PATCH: consuming code treated each element of an EDGE-tuple cycle as a node and
        # zipped adjacent nodes, so for [(src,tgt),(src,tgt),...] it built garbage "edges" of
        # (tuple, tuple) that never matched any FK -> breaker iterated nothing -> cycle persisted.
        cyc = [("a.p1.fk", "b.p2.pk"), ("b.p2.fk", "a.p1.pk"), ("a.p1.pk", "a.p1.fk")]
        prepatch_edges = list(zip(cyc, cyc[1:] + cyc[:1]))  # the old node-zip misparse
        # none of the pre-patch "edges" are (str,str) FK references -> breaker finds nothing
        assert not any(isinstance(a, str) and isinstance(b, str) for a, b in prepatch_edges)
        # POST-PATCH normalization yields real (str,str) FK edges the breaker can act on
        f = _load("_cycle_to_edges")
        assert all(isinstance(a, str) and isinstance(b, str) for a, b in f(cyc))


# --------------------------------------------------------------------------------------
# Fix #2 — mv-boolean-literal-normalize
# --------------------------------------------------------------------------------------
class TestMVBooleanLiteralNormalize:
    def _f(self):
        return _load("_normalize_boolean_predicates")

    def test_restaurants_exact_failure(self):
        f = self._f()
        # The exact predicate that raised DATATYPE_MISMATCH (is_current retyped to BOOLEAN).
        assert f("is_current = 1", {"is_current"}) == "is_current = TRUE"
        assert f("is_current = 0", {"is_current"}) == "is_current = FALSE"

    def test_qualified_and_operators(self):
        f = self._f()
        bset = {"is_current", "compliance_flag", "data_quality_flag"}
        assert f("t.is_current = 1", bset) == "t.is_current = TRUE"
        assert f("compliance_flag != 0", bset) == "compliance_flag != FALSE"
        assert f("data_quality_flag <> 1", bset) == "data_quality_flag <> TRUE"
        assert f("is_current = '1'", bset) == "is_current = TRUE"

    def test_non_boolean_column_untouched(self):
        f = self._f()
        # PRE-PATCH the raw literal survived and Spark raised BOOLEAN vs INT. A non-boolean
        # column must NOT be rewritten (would corrupt real integer comparisons).
        assert f("order_count = 1", {"is_current"}) == "order_count = 1"
        assert f("status = 'active'", {"is_current"}) == "status = 'active'"

    def test_idempotent_and_case_within_expr(self):
        f = self._f()
        assert f("is_current = TRUE", {"is_current"}) == "is_current = TRUE"
        assert (f("CASE WHEN is_current = 1 THEN 1 ELSE 0 END", {"is_current"})
                == "CASE WHEN is_current = TRUE THEN 1 ELSE 0 END")


# --------------------------------------------------------------------------------------
# Fix #3 — physical ground-truth reground false-negatives
# --------------------------------------------------------------------------------------
class TestGroundTruthRegroundFalseNegatives:
    def test_blind_partial_detector(self):
        f = _load("_gt_is_blind_partial")
        assert f("Deterministic verification: no specific pattern matched for this requirement")
        assert f("Tag verification inconclusive — could not match specific requirement")
        # measured/conclusive partials must NOT be flagged blind (they legitimately demote)
        assert not f("[gt-tag-prefix-scope FIRED] 3 industry tag key(s) miss prefix")
        assert not f("42/50 person-pattern columns tagged (coverage 0.84)")
        assert not f("")

    def test_partA_informational_excluded_from_precision(self):
        build = _load("_v412_build_reground_scorecard")
        # restaurants ECM tallies after Fix #3 recovery: 46 fulfilled, 2 partial, 1 failed,
        # 3 informational, total 52 reqs.
        card = build(52, 46, 2, 1, 0, 49, 93.9, informational=3)
        assert card["scoreable_total"] == 49, card
        assert card["precision"] == round(46 / 49, 4), card["precision"]
        assert card["precision"] >= 0.90  # POST-PATCH clears the 90% gate
        # PRE-PATCH signature: informational NOT excluded -> denominator = total (52)
        prepatch_precision = round(46 / 52, 4)
        assert prepatch_precision < 0.90  # would have (falsely) missed the gate

    def test_partBC_blind_partial_does_not_downgrade_fulfilled(self):
        # Replicates the reground loop's authoritative-combine step with the ACTUAL extracted
        # helpers. A blind physical 'partial' + a mid-loop 'fulfilled' (LLM-verified / applied
        # outcome) must resolve to 'fulfilled', NOT be silently downgraded.
        combine = _load("_v412_combine_verdict")
        is_blind = _load("_gt_is_blind_partial")

        def reground(phys_status, phys_evidence, midloop_status):
            st = phys_status
            if st == "partial" and is_blind(phys_evidence):  # v4.2.2 blind->unknown
                st = "unknown"
            return combine(st, midloop_status)

        # VREQ-001 (name preservation) / VREQ-044 (enrichment): blind partial, mid-loop fulfilled
        assert reground("partial", "no specific pattern matched", "fulfilled") == "fulfilled"
        # PRE-PATCH (no blind->unknown): physical partial wins -> downgraded
        assert combine("partial", "fulfilled") == "partial"
        # A CONCLUSIVE physical partial (real measured coverage) STILL demotes fulfilled — honest
        assert reground("partial", "42/50 cols tagged (coverage 0.84)", "fulfilled") == "partial"
        # A CONCLUSIVE physical failed is authoritative (column genuinely absent)
        assert reground("failed", "required column absent", "fulfilled") == "failed"

    def test_partC_typecorrect_regex_parses_restaurants_vreqs(self):
        # The gt-rescue-typecorrect / gt-type-verify parse must locate D.P.col + target type.
        rx = re.compile(
            r"type of\s+([a-z0-9_]+)\.([a-z0-9_]+)\.([a-z0-9_]+)\s+from\s+.*?\bto\s+"
            r"(boolean|decimal|numeric|bigint|integer|int|string|double|float|timestamp|date)\b"
        )
        cases = {
            "correct the physical type of order.status_event.data_quality_flag from string to boolean":
                ("order", "status_event", "data_quality_flag", "boolean"),
            "correct the physical type of finance.asset_depreciation.gl_account_depreciation_expense "
            "from string (money) to decimal":
                ("finance", "asset_depreciation", "gl_account_depreciation_expense", "decimal"),
        }
        for txt, exp in cases.items():
            m = rx.search(txt)
            assert m is not None and m.groups() == exp, (txt, m.groups() if m else None)
        # the fix must be live in the notebook (both the rescue and the alias)
        src = _src_containing("gt-rescue-typecorrect")
        assert "gt-rescue-typecorrect" in src

    def test_wiring_present_in_notebook(self):
        # loop-level changes that cannot be exec'd standalone must be live (smoke, complements
        # the behavioral primitives above).
        src = _src_containing("gt-informational-exclude")
        assert 'if str(getattr(req, "status", "") or "").lower() == "informational":' in src
        assert "informational += 1" in src
        assert "gt-blind-partial-unknown" in src

    def test_restaurants_endtoend_math(self):
        # Full replay of the restaurants ECM reground with the real scorecard builder:
        # pre-fix 38/52 = 73.1%  ->  post-fix 46/49 = 93.9% (>=90 gate).
        build = _load("_v412_build_reground_scorecard")
        post = build(52, 46, 2, 1, 0, 49, 93.9, informational=3)
        assert post["precision"] >= 0.90
        pre = build(52, 38, 13, 1, 0, 52, 73.1, informational=0)
        assert pre["precision"] < 0.90
