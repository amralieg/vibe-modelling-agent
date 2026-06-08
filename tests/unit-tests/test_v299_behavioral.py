"""Behavioral tests for v2.9.9 VREQ-explosion root-cause fix (user audit 2026-06-01).

Root cause: an 848-line next_vibes whose Section 1 listed 556 products under a single
'preserve every domain/product' directive was atomised by EXTRACTION_SYSTEM_PROMPT into 556
separate critical 'preserve <d>.<p>' VREQs (the one-VREQ-per-name rule). Those VREQs are
redundant with the structural pinning that already preserves them, so they wasted the apply
budget. v2.9.9 adds:
  FIX-1A  EXTRACTION_SYSTEM_PROMPT EXCEPTION (a bare preservation name-list is ONE VREQ).
  FIX-1B  deterministic _v299_collapse_preservation_vreqs guard that collapses pure-preservation
          VREQs into ONE granularity=all VREQ (independent of the LLM).
  FIX-2   apply-loop batch cap 10 -> 25.

These tests exercise the REAL production helpers sliced from the notebook. PRE-PATCH the guard
did not exist, so the 556-VREQ degenerate input below would pass through un-collapsed -> these
assertions FAIL on pre-patch HEAD (per CLAUDE.md 8.10).
"""
import re
import textwrap
from dataclasses import dataclass, field

from notebook_source_util import notebook_concat_source

SRC = notebook_concat_source()


@dataclass
class RawVREQ:
    vreq_id: str
    intent: str
    target: str
    source_quote: str
    source_chunk_id: str = "c0"
    severity: str = "medium"
    is_user_directive: bool = False
    priority_id: int = 9999


def _load_collapse_helpers():
    """Slice the v299 collapse block (import re as _re299 .. before _V296_SEV_RANK) and exec it
    as real code, injecting a RawVREQ stub so the collapse function can construct the merged VREQ."""
    m = re.search(r"import re as _re299.*?(?=\n_V296_SEV_RANK\s*=)", SRC, re.DOTALL)
    assert m, "v299 collapse block not found in agent notebook"
    block = textwrap.dedent(m.group(0))
    ns = {"RawVREQ": RawVREQ}
    exec(compile(block, "agent_notebook", "exec"), ns)
    return ns


HELPERS = _load_collapse_helpers()
is_preservation_only = HELPERS["_v299_is_preservation_only"]
collapse = HELPERS["_v299_collapse_preservation_vreqs"]


def _v(vid, intent, target, sev="critical", user=False):
    return RawVREQ(vreq_id=vid, intent=intent, target=target, source_quote=f"  - {target}",
                   severity=sev, is_user_directive=user)


# --- FIX-1B detection: preservation-only vs substantive --------------------

def test_pure_preserve_is_preservation_only():
    assert is_preservation_only(_v("V1", "Preserve product patient.demographics", "patient.demographics"))
    assert is_preservation_only(_v("V2", "Keep domain support in the model", "support"))
    assert is_preservation_only(_v("V3", "Do not remove domain billing", "billing"))
    assert is_preservation_only(_v("V4", "Product encounter.visit must exist in v2", "encounter.visit"))


def test_substantive_vreq_is_NOT_preservation_only():
    # these CHANGE the model -> must never be collapsed (recall preserved)
    assert not is_preservation_only(_v("V5", "Add core attributes to patient.program_enrollment", "patient.program_enrollment"))
    assert not is_preservation_only(_v("V6", "Rename product foo to bar", "x.foo"))
    assert not is_preservation_only(_v("V7", "Link claim.status_history.claim_id as FK to claim.claim", "claim.status_history"))
    assert not is_preservation_only(_v("V8", "Expand thin product supply.location_audit", "supply.location_audit"))
    assert not is_preservation_only(_v("V9", "Set the type of finance.invoice.total to DECIMAL", "finance.invoice.total"))
    assert not is_preservation_only(_v("V10", "Add a business-justification comment to every attribute", "all"))


# --- FIX-1B collapse behaviour ---------------------------------------------

def test_many_preserve_vreqs_collapse_to_one():
    vreqs = [_v(f"P{i}", f"Preserve product d.p{i}", f"d.p{i}") for i in range(556)]
    out = collapse(vreqs)
    assert len(out) == 1, f"556 preservation VREQs must collapse to 1, got {len(out)}"
    assert out[0].vreq_id == "V299-PRESERVE-ALL"
    assert out[0].severity == "critical"
    assert "556" in out[0].intent


def test_collapse_preserves_substantive_vreqs_untouched():
    preserve = [_v(f"P{i}", f"Preserve product d.p{i}", f"d.p{i}") for i in range(10)]
    substantive = [
        _v("S1", "Add core attributes to a.b", "a.b"),
        _v("S2", "Link x.y.z FK to x.w", "x.y"),
    ]
    out = collapse(preserve + substantive)
    # 10 preserve -> 1 collapsed; 2 substantive untouched => 3 total
    assert len(out) == 3, f"expected 2 substantive + 1 collapsed = 3, got {len(out)}"
    ids = {v.vreq_id for v in out}
    assert "S1" in ids and "S2" in ids, "substantive VREQs must survive collapse (recall preserved)"
    assert "V299-PRESERVE-ALL" in ids


def test_single_preserve_vreq_is_not_collapsed():
    one = [_v("P0", "Preserve product d.p0", "d.p0")]
    out = collapse(one)
    assert len(out) == 1 and out[0].vreq_id == "P0", "a lone preservation VREQ must pass through unchanged"


def test_collapse_carries_user_directive_flag_and_min_priority():
    vreqs = [
        _v("P0", "Preserve product d.p0", "d.p0", user=False),
        _v("P1", "Preserve product d.p1", "d.p1", user=True),
    ]
    vreqs[1].priority_id = 3
    out = collapse(vreqs)
    assert len(out) == 1
    assert out[0].is_user_directive is True, "collapsed VREQ inherits user-directive if any source was user"
    assert out[0].priority_id == 3, "collapsed VREQ keeps the strongest (lowest) priority_id"


def test_empty_input_is_safe():
    assert collapse([]) == []


# --- FIX-1A + FIX-2 wiring (static contract) -------------------------------

def test_extraction_prompt_has_preservation_exception():
    assert "EXCEPTION - STRUCTURE-PRESERVATION" in SRC
    assert "vov-collapse-preserve" in SRC


def test_collapse_is_wired_before_the_sort():
    assert "_v299_collapse_preservation_vreqs(list(deduped), logger)" in SRC, \
        "collapse must run on deduped before _v296_sort_vreqs"


def test_batch_cap_raised_to_25():
    assert "_max_per_call=25))" in SRC, "FIX-2 must raise the apply-loop batch cap to 25"
    assert "_max_per_call=10))" not in SRC, "no apply-loop call site may keep the old cap of 10"
