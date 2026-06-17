"""v3.6.8 hc-bug4 behavioral tests: find_missing_fk_links validator must GRACEFULLY
DEGRADE (auto-derive / KEEP_AS_IS) on recoverable conditions instead of hard-failing the
CRITICAL step. ROOT CAUSE harvested from healthcare base-MVM 2026-06-17: 8 domains hard-
failed find_missing_fk_links -> 'Max retries (3) exhausted' -> whole run section-10.6
disqualified, for three recoverable reasons:
  (a) CREATE decision missing create_table_name  -> derive from FK stem
  (b) LINK target not canonical (ambiguous stem) -> KEEP_AS_IS (leave unlinked)
  (c) LINK decision missing target_table         -> KEEP_AS_IS

These tests reconstruct the closure (_validate_fmfl + its sibling helpers) from the live
notebook source so they exercise the REAL production code path, not a stub.
"""
import textwrap
import pytest
from notebook_source_util import notebook_concat_source


def _build_validator(products_data, pk_suffix, unlinked_cols):
    """Extract the contiguous _fmfl_* helper + _validate_fmfl region and return a live
    _validate_fmfl bound to the given closure inputs."""
    src = notebook_concat_source()
    start = src.index("_fmfl_canonical_entities = {")
    start = src.rindex("\n", 0, start) + 1  # snap to line start so dedent keeps relative indent
    # take the first _validate_fmfl return after the helpers
    vf = src.index("def _validate_fmfl(", start)
    end_ret = src.index("return len(errors) == 0, errors", vf)
    end = src.index("\n", end_ret) + 1
    region = textwrap.dedent(src[start:end])

    class _Log:
        def __init__(self):
            self.msgs = []
        def warning(self, m):
            self.msgs.append(m)
        def info(self, m):
            self.msgs.append(m)
        def error(self, m):
            self.msgs.append(m)

    log = _Log()
    factory = (
        "def _build(products_data, pk_suffix, unlinked_cols, _log):\n"
        "    import json\n"
        + textwrap.indent(region, "    ")
        + "    return _validate_fmfl\n"
    )
    ns = {}
    exec(compile(factory, "<fmfl_region>", "exec"), ns)
    validate = ns["_build"](products_data, pk_suffix, unlinked_cols, log)
    return validate, log


def _uc(*cols):
    return [{"table": t, "column": c} for (t, c) in cols]


def test_create_missing_name_derives_from_stem():
    """(a) CREATE without create_table_name -> derive stem, validation PASSES."""
    unlinked = _uc(("qc_run", "calibration_id"))
    validate, log = _build_validator(products_data=[{"domain": "lab", "product": "qc_run"}],
                                     pk_suffix="_id", unlinked_cols=unlinked)
    resp = {"decisions": [{"table": "qc_run", "column": "calibration_id", "decision": "CREATE"}]}
    ok, errs = validate(resp)
    assert ok is True, f"expected graceful pass, got errors={errs}"
    assert resp["decisions"][0]["create_table_name"] == "calibration"
    assert any("fmfl-create-name-derive" in m for m in log.msgs)


def test_create_no_stem_coerces_keep():
    """(a-edge) CREATE with no derivable stem -> KEEP_AS_IS, validation PASSES."""
    unlinked = _uc(("t", "_id"))
    validate, _ = _build_validator(products_data=[{"domain": "d", "product": "t"}],
                                   pk_suffix="_id", unlinked_cols=unlinked)
    resp = {"decisions": [{"table": "t", "column": "_id", "decision": "CREATE"}]}
    ok, errs = validate(resp)
    assert ok is True, f"errors={errs}"
    assert resp["decisions"][0]["decision"] == "KEEP_AS_IS"


def test_link_noncanonical_ambiguous_coerces_keep():
    """(b) LINK to non-canonical target with AMBIGUOUS stem matches -> KEEP_AS_IS, PASSES."""
    products = [
        {"domain": "research", "product": "informed_consent"},
        {"domain": "research", "product": "consent_template"},
        {"domain": "patient", "product": "consent_reference"},
        {"domain": "digitalhealth", "product": "rpm_enrollment"},
    ]
    unlinked = _uc(("rpm_enrollment", "consent_id"))
    validate, log = _build_validator(products_data=products, pk_suffix="_id", unlinked_cols=unlinked)
    resp = {"decisions": [{"table": "rpm_enrollment", "column": "consent_id",
                           "decision": "LINK", "target_table": "digitalhealth.digital_consent"}]}
    ok, errs = validate(resp)
    assert ok is True, f"expected graceful pass, got errors={errs}"
    assert resp["decisions"][0]["decision"] == "KEEP_AS_IS"
    assert any("fmfl-noncanon-coerce-keep" in m for m in log.msgs)


def test_link_no_target_coerces_keep():
    """(c) LINK without target_table -> KEEP_AS_IS, validation PASSES."""
    unlinked = _uc(("prescription", "rems_program_id"))
    validate, log = _build_validator(products_data=[{"domain": "pharmacy", "product": "prescription"}],
                                     pk_suffix="_id", unlinked_cols=unlinked)
    resp = {"decisions": [{"table": "prescription", "column": "rems_program_id", "decision": "LINK"}]}
    ok, errs = validate(resp)
    assert ok is True, f"expected graceful pass, got errors={errs}"
    assert resp["decisions"][0]["decision"] == "KEEP_AS_IS"
    assert any("fmfl-linknotarget-coerce-keep" in m for m in log.msgs)


def test_link_unambiguous_still_auto_remaps():
    """NEGATIVE-CONTROL: a single high-confidence stem match still auto-remaps (preserve existing
    fmfl-auto-remap behavior, do not regress it into KEEP_AS_IS)."""
    products = [{"domain": "lab", "product": "calibration"}, {"domain": "lab", "product": "qc_run"}]
    unlinked = _uc(("qc_run", "calibration_id"))
    validate, log = _build_validator(products_data=products, pk_suffix="_id", unlinked_cols=unlinked)
    resp = {"decisions": [{"table": "qc_run", "column": "calibration_id",
                           "decision": "LINK", "target_table": "stale.calibration_thing"}]}
    ok, errs = validate(resp)
    assert ok is True, f"errors={errs}"
    assert resp["decisions"][0]["decision"] == "LINK"
    assert resp["decisions"][0]["target_table"] == "lab.calibration"


def test_invalid_decision_still_errors():
    """NEGATIVE-CONTROL: a genuinely invalid decision type STILL errors (no over-coercion)."""
    unlinked = _uc(("t", "x_id"))
    validate, _ = _build_validator(products_data=[{"domain": "d", "product": "t"}],
                                   pk_suffix="_id", unlinked_cols=unlinked)
    resp = {"decisions": [{"table": "t", "column": "x_id", "decision": "FROBNICATE"}]}
    ok, errs = validate(resp)
    assert ok is False
    assert any("Invalid decision" in e for e in errs)


def test_count_mismatch_still_errors():
    """NEGATIVE-CONTROL: fewer decisions than unlinked columns STILL errors."""
    unlinked = _uc(("t", "a_id"), ("t", "b_id"))
    validate, _ = _build_validator(products_data=[{"domain": "d", "product": "t"}],
                                   pk_suffix="_id", unlinked_cols=unlinked)
    resp = {"decisions": [{"table": "t", "column": "a_id", "decision": "KEEP_AS_IS"}]}
    ok, errs = validate(resp)
    assert ok is False
    assert any("EVERY column MUST have a decision" in e for e in errs)
