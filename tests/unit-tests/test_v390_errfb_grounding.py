import json, os, re, textwrap

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _synth_cell():
    nb = json.load(open(NB))
    for c in nb["cells"]:
        if c["cell_type"] != "code":
            continue
        s = "".join(c["source"])
        if "vov-errfb-reground-failed-target" in s and "vov-errfb-grounded-retry" in s:
            return s
    raise AssertionError("synthesize_handler cell not found")


def _extract(s, start_anchor, end_anchor):
    i = s.index(start_anchor)
    j = s.index(end_anchor, i) + len(end_anchor)
    return textwrap.dedent(s[i:j])


# ---- FIX B2: re-grounding the failed named target from the trace ----
def test_reground_failed_named_target_from_trace():
    s = _synth_cell()
    block = _extract(
        s,
        "if prior_failure_trace:\n            _mc_blacklist",
        "_tgt_pairs.add((_fd, _fp))\n",
    )
    # Real failure traces seen live: named targets + a method-call false-match that MUST be filtered.
    trace = ("attempt 3: ValueError: mutator did not touch target spa.product | "
             "did not find procurement_employee_id FK to remove on channel.channel | "
             "site.instruction retype failed; used col.lower() and ast.walk()")
    ns = {"re": re, "prior_failure_trace": trace, "_tgt_pairs": set()}
    exec(block, ns)
    pairs = ns["_tgt_pairs"]
    assert ("spa", "product") in pairs, pairs           # named target grounded
    assert ("channel", "channel") in pairs, pairs        # 'on channel.channel' grounded
    assert ("site", "instruction") in pairs, pairs       # 'site.instruction' grounded
    # method-call / module false-matches MUST be filtered
    assert ("col", "lower") not in pairs, pairs
    assert ("ast", "walk") not in pairs, pairs


def test_reground_noop_when_no_trace():
    # §8.10 pre-condition: with no prior_failure_trace, nothing is grounded (the block is guarded).
    s = _synth_cell()
    block = _extract(
        s,
        "if prior_failure_trace:\n            _mc_blacklist",
        "_tgt_pairs.add((_fd, _fp))\n",
    )
    ns = {"re": re, "prior_failure_trace": "", "_tgt_pairs": set()}
    exec(block, ns)
    assert ns["_tgt_pairs"] == set()


# ---- FIX B1: full-trace cap + actionable empty-diff directive ----
def test_feedback_cap_and_directive():
    s = _synth_cell()
    block = _extract(
        s,
        '        user += f"\\n\\nPRIOR ATTEMPT FAILED. Trace:\\n{prior_failure_trace[:8000]}',
        "user += _v204_ast_class_hints(prior_failure_trace)\n",
    )
    # 5000-char trace naming a missed target; pre-fix cap (3000) would have amputated the tail directive.
    long_trace = ("X" * 4000) + " ValueError: mutator did not touch any target entity " + ("Y" * 1000)
    ns = {"user": "", "prior_failure_trace": long_trace, "_v204_ast_class_hints": lambda t: ""}
    exec(block, ns)
    out = ns["user"]
    # full 8000-cap means the 'did not touch' phrase past char 3000 still reached the prompt
    assert "did not touch any target entity" in out
    # actionable directive fired
    assert "EMPTY DIFF (it did not touch the target)" in out
    assert "CASE-INSENSITIVELY" in out


def test_no_directive_without_empty_diff_signal():
    s = _synth_cell()
    block = _extract(
        s,
        '        user += f"\\n\\nPRIOR ATTEMPT FAILED. Trace:\\n{prior_failure_trace[:8000]}',
        "user += _v204_ast_class_hints(prior_failure_trace)\n",
    )
    ns = {"user": "", "prior_failure_trace": "unsafe_ast: forbidden AST node: Import",
          "_v204_ast_class_hints": lambda t: ""}
    exec(block, ns)
    # an import error is NOT an empty-diff -> the navigate directive must NOT fire
    assert "EMPTY DIFF (it did not touch the target)" not in ns["user"]


if __name__ == "__main__":
    test_reground_failed_named_target_from_trace(); print("B2 reground OK")
    test_reground_noop_when_no_trace(); print("B2 noop-guard OK")
    test_feedback_cap_and_directive(); print("B1 cap+directive OK")
    test_no_directive_without_empty_diff_signal(); print("B1 directive-gating OK")
    print("ALL PASS")
