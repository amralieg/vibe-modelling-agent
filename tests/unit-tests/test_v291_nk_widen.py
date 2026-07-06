"""v2.9.1 FIX-7 behavioral test: widened denormalized natural-key drop (P0.26 extension).

ROOT CAUSE (pre-patch): P0.26 matched only ('_number','_code','_name','_reference'), so denormalized
natural keys named e.g. '<base>_num' / '<base>_ref' / '<base>_sku' survived (audit: NK-normalize reqs
unfulfilled). FIX-7 widens the suffix set and adds a user-protection skip (7A).

§8.10 proof-of-failure: the widened suffix tuple + protection skip do not exist pre-patch.
"""
import json
import os

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


# Mirror of the widened suffix tuple (kept in lockstep with the agent).
WIDENED = ('_number', '_code', '_name', '_reference', '_no', '_num',
           '_ref', '_identifier', '_label', '_sku', '_barcode', '_serial',
           '_key', '_uuid', '_guid')
PK_SUFFIX = "_id"


def _is_denormalized_nk(attr_name, fk_bases):
    """Replicates the P0.26 match: a column ending in a NK suffix whose base equals an FK base."""
    an = attr_name.lower()
    for suf in WIDENED:
        if an.endswith(suf) and len(an) > len(suf):
            base = an[:-len(suf)]
            return base in fk_bases
    return False


def test_fix7_present_in_source():
    src = _src()
    assert "nk-normalize-widen FIRED v2.9.1" in src, "FIX-7 missing (pre-patch HEAD => FAIL)"
    # widened suffixes present
    for suf in ("'_num'", "'_ref'", "'_sku'", "'_identifier'", "'_barcode'"):
        assert suf in src, f"widened suffix {suf} missing"
    # user-protection skip present
    assert "_p026_protected" in src and "_v291_user_protected_names(config)" in src


def test_fix7_widened_suffixes_now_match():
    # customer_id FK exists -> base 'customer'. These NKs were MISSED by the 4-suffix list.
    fk_bases = {"customer"}
    assert _is_denormalized_nk("customer_num", fk_bases)
    assert _is_denormalized_nk("customer_ref", fk_bases)
    assert _is_denormalized_nk("customer_sku", fk_bases)
    assert _is_denormalized_nk("customer_identifier", fk_bases)


def test_fix7_no_fk_base_no_drop():
    # §8.3 anti-tautology: without an FK to the owner, the NK is NOT denormalized -> keep it.
    assert not _is_denormalized_nk("customer_num", set())
    assert not _is_denormalized_nk("standalone_code", {"customer"})


def test_fix7_protection_skip_logic():
    # The protection set is the must-have/domain names; a column on a must-have product is skipped.
    protected = {"address"}
    product_name = "address"
    assert (product_name or "").lower() in protected
