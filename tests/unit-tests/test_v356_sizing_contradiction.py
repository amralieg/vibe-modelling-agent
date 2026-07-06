"""Behavioral tests for v3.5.6 root-cause fixes from the media_broadcasting/ngo VOV explosion audit.

aliases:
  v356-sizing-contradiction-sanitizer
  v356-source-trace-parse-tags-coerce

Regression target (live VOV2 marathon, 2026-06-11):
  media_broadcasting v2 ECM exploded 421 -> 4465 products (10.6x, quality 50/100) and
  ngo v2 ECM exploded 302 -> 835 products (2.76x), while the other 11 industries stayed at
  ~target (ratio <= 1.05). The differentiator, proven from the merged-sizing log line:

    automotive (healthy):  max_domains=19, min_domains=19, max_total_products=548, min=548   (clean: max==min)
    media_broadcasting:    max_domains=3,  min_domains=17, max_total_products=18,  min=421   (CONTRADICTION max<min)

  The LLM VIBE_PARSE hallucinated tiny max_* values (3/18/6 -- the qualitative-smallness
  constants) from template PROSE ("It has THREE sections", "Section 3"); the LLM+regex merge
  combined them with the regex-extracted EXPLICIT floor (min_domains=17 / min_total_products=421),
  producing max_total_products=18 < min_total_products=421. Downstream ceiling logic discards a
  max<min contradiction -> NO product ceiling -> unbounded VOV expansion. The v0.7.6
  source-scale-guard was inert (business_context_raw empty at merge time).

Fix 1 (this version): a DETERMINISTIC, source-INDEPENDENT sanitizer in the sizing merge lifts any
  max_* that is < its min_* floor up to the floor (explicit floor outranks a contradicting
  hallucinated max), and widens max_products_per_domain when too small to hold the product floor
  across the domain floor. Fires ONLY on max<min so 'exactly N' / tiny-test vibes (max>=min) are
  untouched.

Fix 2 (this version): _enforce_source_trace_tags._parse_tags did `(s or "").split(",")` on
  product/attr `tags` that VOV/sandbox mutations emit as list/dict -> AttributeError
  'list' object has no attribute 'split' (media_broadcasting [source-trace-enforce ERROR] +
  B0040 rejected_unsafe mutator). Fix reuses _coerce_tags_to_string_v250 (DRY) at the parse boundary.

Tests:
- Static: aliases + FIRED sentinels present, version >= 3.5.6.
- Behavioral: the REAL extracted sanitizer block repairs the media_broadcasting contradiction
  (max_total_products 18->421, max_domains 3->17, max_products_per_domain 6->25).
- Behavioral: clean (automotive max==min) and tiny-test (max>=min) directives are left untouched.
- Behavioral pre/post: `(list or "").split(",")` crashes pre-coerce; the v356 _parse_tags coercion
  makes the identical pattern safe.
- DRY: _parse_tags reuses _coerce_tags_to_string_v250.
"""

import json
import pathlib
import re
import textwrap

import pytest


NB_PATH = pathlib.Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_source() -> str:
    nb = json.loads(NB_PATH.read_text())
    out = []
    for c in nb["cells"]:
        if c.get("cell_type") != "code":
            continue
        out.append("".join(c.get("source", [])))
    return "\n".join(out)


SRC = _read_source()


class _MockLogger:
    def __init__(self):
        self.warnings = []

    def warning(self, msg):
        self.warnings.append(msg)

    def info(self, msg):
        pass


class _MockSelf:
    def __init__(self):
        self.logger = _MockLogger()


def _extract_sanitizer_block() -> str:
    """Pull the REAL v356 sizing-contradiction sanitizer try/except block out of the notebook so the
    test exercises production code (not a reimplementation). Pre-patch this raises -> test fails."""
    anchor = SRC.find("import math as _san_math")
    assert anchor > 0, "v356 sanitizer block (import math as _san_math) not found — patch missing"
    # back up to the `try:` that opens the block, then to the START of that line so its leading
    # indentation is preserved (otherwise textwrap.dedent sees a 0-indent first line and no-ops).
    try_kw = SRC.rfind("try:", 0, anchor)
    assert try_kw > 0
    line_start = SRC.rfind("\n", 0, try_kw) + 1
    # the block ends at the first `except Exception: pass` following the un-sanitized warning
    warn_end = SRC.find("un-sanitized sizing_directives", anchor)
    assert warn_end > 0, "v356 sanitizer except-branch not found"
    block_end = SRC.find("except Exception: pass", warn_end)
    assert block_end > 0
    block_end = SRC.find("\n", block_end)
    block = SRC[line_start:block_end]
    return textwrap.dedent(block)


def _run_sanitizer(merged_sd: dict) -> tuple:
    block = _extract_sanitizer_block()
    self_obj = _MockSelf()
    ns = {"_merged_sd": merged_sd, "self": self_obj}
    exec(compile(block, "<v356-sanitizer>", "exec"), ns)
    return merged_sd, self_obj.logger.warnings


def test_v356_version_bump():
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', SRC)
    assert m, "__AGENT_VERSION__ not found"
    assert tuple(int(x) for x in m.group(1).split(".")) >= (3, 5, 6), \
        f"__AGENT_VERSION__ should be >= 3.5.6, got {m.group(1)}"


def test_v356_aliases_and_sentinels_present():
    assert "v356-sizing-contradiction-sanitizer" in SRC, "sizing-sanitizer alias missing"
    assert "[v356-sizing-contradiction-sanitizer FIRED]" in SRC, "sizing-sanitizer FIRED sentinel missing"
    assert "v356-source-trace-parse-tags-coerce" in SRC, "parse-tags-coerce alias missing"


def test_v356_sanitizer_repairs_media_broadcasting_contradiction():
    """The EXACT live media_broadcasting merged-sizing dict that exploded -> must be repaired."""
    merged = {
        "max_domains": 3, "min_domains": 17,
        "max_total_products": 18, "min_total_products": 421,
        "max_products_per_domain": 6, "min_products_per_domain": None,
        "single_domain_mode": False,
    }
    out, warns = _run_sanitizer(merged)
    assert out["max_total_products"] == 421, "max_total_products must be lifted to the 421 floor"
    assert out["max_domains"] == 17, "max_domains must be lifted to the 17 floor"
    # ceil(421 / 17) = 25
    assert out["max_products_per_domain"] == 25, \
        f"max_products_per_domain must widen to hold the floor, got {out['max_products_per_domain']}"
    assert any("v356-sizing-contradiction-sanitizer FIRED" in w for w in warns), \
        "sanitizer must log a FIRED warning when it repairs a contradiction"


def test_v356_sanitizer_leaves_clean_directive_untouched():
    """automotive (clean: max==min==N) must NOT be modified and must NOT log a fix."""
    merged = {
        "max_domains": 19, "min_domains": 19,
        "max_total_products": 548, "min_total_products": 548,
        "max_products_per_domain": None, "min_products_per_domain": None,
        "single_domain_mode": False,
    }
    out, warns = _run_sanitizer(merged)
    assert out["max_domains"] == 19
    assert out["max_total_products"] == 548
    assert out["max_products_per_domain"] is None
    assert not any("v356-sizing-contradiction-sanitizer FIRED" in w for w in warns), \
        "sanitizer must stay silent on a clean (max==min) directive"


def test_v356_sanitizer_leaves_tiny_test_vibe_untouched():
    """'exactly 3 domains and ~15 products' tiny-test instrumentation (max>=min) must be untouched."""
    merged = {
        "max_domains": 3, "min_domains": 3,
        "max_total_products": 15, "min_total_products": 15,
        "max_products_per_domain": 6, "min_products_per_domain": None,
        "single_domain_mode": False,
    }
    out, warns = _run_sanitizer(merged)
    assert out["max_domains"] == 3
    assert out["max_total_products"] == 15
    assert out["max_products_per_domain"] == 6
    assert not warns, "tiny-test vibe (max>=min) must not trip the sanitizer"


def test_v356_sanitizer_partial_contradiction_products_only():
    """Only max_total_products contradicts; domains clean -> only the product max is lifted."""
    merged = {
        "max_domains": 20, "min_domains": 17,
        "max_total_products": 18, "min_total_products": 421,
        "max_products_per_domain": None, "min_products_per_domain": None,
    }
    out, warns = _run_sanitizer(merged)
    assert out["max_total_products"] == 421
    assert out["max_domains"] == 20, "a non-contradicting max_domains must be left alone"


def _parse_tags_block() -> str:
    start = SRC.find("def _parse_tags(s):")
    assert start > 0, "_parse_tags not found"
    # take through the `return d` that closes it
    ret = SRC.find("return d", start)
    assert ret > 0
    block = SRC[start:SRC.find("\n", ret)]
    return textwrap.dedent(block)


def _coercer_block() -> str:
    start = SRC.find("def _coerce_tags_to_string_v250(")
    assert start > 0
    nxt = SRC.find("\ndef ", start + 1)
    return textwrap.dedent(SRC[start:nxt] if nxt > 0 else SRC[start:])


def test_v356_parse_tags_is_dry_reuses_coercer():
    block = _parse_tags_block()
    assert "_coerce_tags_to_string_v250(" in block, \
        "DRY violation: _parse_tags must reuse _coerce_tags_to_string_v250, not duplicate coercion"


def test_v356_parse_tags_pre_patch_crash_then_post_patch_clean():
    """Pre-patch the raw pattern crashes on a list; the v356 coercion makes the identical path safe."""
    # PRE-PATCH reality: tags arrives as a list, raw code does `(s or "").split(",")`.
    s_list = ["confidential", "pii_address"]
    with pytest.raises(AttributeError, match="split"):
        (s_list or "").split(",")  # noqa: replicates the pre-v356 crash line

    # POST-PATCH: exec the REAL extracted _parse_tags (which first coerces via the v250 coercer).
    ns = {}
    exec(compile(_coercer_block(), "<coercer>", "exec"), ns)
    exec(compile(_parse_tags_block(), "<parse_tags>", "exec"), ns)
    parse = ns["_parse_tags"]

    # list input no longer crashes and parses each element as a bare key
    out = parse(["confidential", "ncdot_source_table=foo"])
    assert out["confidential"] == ""
    assert out["ncdot_source_table"] == "foo"
    # dict input also handled
    out2 = parse({"a": "1", "b": "2"})
    assert out2["a"] == "1" and out2["b"] == "2"
    # the normal string path is unchanged
    out3 = parse("k1=v1,k2")
    assert out3["k1"] == "v1" and out3["k2"] == ""
    # None -> empty dict, no crash
    assert parse(None) == {}


if __name__ == "__main__":
    test_v356_version_bump()
    test_v356_aliases_and_sentinels_present()
    test_v356_sanitizer_repairs_media_broadcasting_contradiction()
    test_v356_sanitizer_leaves_clean_directive_untouched()
    test_v356_sanitizer_leaves_tiny_test_vibe_untouched()
    test_v356_sanitizer_partial_contradiction_products_only()
    test_v356_parse_tags_is_dry_reuses_coercer()
    test_v356_parse_tags_pre_patch_crash_then_post_patch_clean()
    print("OK -- all v3.5.6 sizing-contradiction + parse-tags-coerce tests pass")
