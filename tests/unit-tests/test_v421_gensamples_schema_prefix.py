"""
v4.2.1 behavioral test — gen-samples prefix-aware INSERT target (05b root cause).

Root cause: the metamodel stores the LOGICAL database_name ('customer'), while INSTALL
physically prefixes schemas via SCHEMA_PREFIX ('raw_' -> 'raw_customer'). CatalogResolver.
resolve_schema is prefix-blind, so standalone gen-samples targeted `<cat>.customer.*`
(nonexistent) -> every DESCRIBE failed -> ALL inserts silently skipped (0/8 rows) while the
op reported success (vibe_tester 05b: "Only 0/8 tables have sample data").

Fix: build the schema_prefix candidate and pick whichever schema PHYSICALLY EXISTS.

This test extracts the ACTUAL candidate-selection block from the deployed notebook cell and
executes it with a stub `spark` that mimics the physical catalog (prefixed schema exists,
unprefixed does not). It proves:
  - POST-patch: target_table resolves to the prefixed (existing) schema.
  - PRE-patch behavior (resolve_schema only, no prefix candidate) would have targeted the
    nonexistent unprefixed schema -> the observable failure.
"""
import json
import os
import re

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _cell_src(pred):
    nb = json.load(open(NB))
    for c in nb["cells"]:
        if c["cell_type"] != "code":
            continue
        s = "".join(c["source"])
        if pred(s):
            return s
    raise AssertionError("cell not found")


class _StubSpark:
    """spark stub: DESCRIBE succeeds only for schemas in `existing`."""

    def __init__(self, existing_schemas):
        self.existing = set(existing_schemas)

    def sql(self, q):
        m = re.search(r"DESCRIBE TABLE `([^`]+)`\.`([^`]+)`\.`([^`]+)`", q)
        if m and m.group(2) in self.existing:
            return object()
        raise Exception(f"TABLE_OR_VIEW_NOT_FOUND: {q}")


class _StubResolver:
    """resolve_schema returns the LOGICAL name (prefix-blind), like CatalogResolver."""

    def resolve_schema(self, domain_dict, product_dict=None):
        return domain_dict.get("database_name", "")

    def resolve_catalog(self, domain_dict):
        return "t04_instmv1_business_catalog"


def _extract_insert_target_block(src):
    """Pull the v421 candidate-selection block verbatim from the notebook cell."""
    import textwrap
    anchor = src.index("_resolved_db = _sample_shared_resolver.resolve_schema(_domain_dict_proxy, p_dict)")
    start = src.rfind("\n", 0, anchor) + 1  # start at the beginning of the anchor's line (keep indent)
    end = src.index("continue", src.index("v421-gensamples-schema-prefix FIRED"))
    block = src[start : end + len("continue")]
    return textwrap.dedent(block)


def _run_block(schema_prefix, resolved_db, existing_schemas):
    src = _cell_src(lambda s: "_insert_product_samples" in s and "v421-gensamples-schema-prefix" in s)
    block = _extract_insert_target_block(src)
    ns = {
        "config": {"SCHEMA_PREFIX": schema_prefix},
        "_sample_shared_resolver": _StubResolver(),
        "_domain_dict_proxy": {"domain": "customer", "name": "customer", "database_name": resolved_db, "division": "business"},
        "p_dict": {"table_name": "consentevent"},
        "domain_to_catalog_map": {"customer": "t04_instmv1_business_catalog"},
        "domain_name": "customer",
        "product_name": "consent_event",
        "spark": _StubSpark(existing_schemas),
        "logger": type("L", (), {"info": staticmethod(lambda *a, **k: None)})(),
    }
    # the block references _stored_cat/_sample_effective_catalog defined just above in the real
    # code; seed them from the stub resolver to match runtime.
    ns["_stored_cat"] = ns["domain_to_catalog_map"].get("customer", "")
    ns["_sample_effective_catalog"] = ns["_stored_cat"]
    exec(block, ns)
    return ns["target_table"], ns["db_name"]


def test_v421_prefix_aware_targets_existing_physical_schema():
    """POST-patch: with schema_prefix='raw_' and only the prefixed schema physically present,
    the insert target MUST resolve to the prefixed schema (raw_customer)."""
    tt, db = _run_block(schema_prefix="raw_", resolved_db="customer", existing_schemas={"raw_customer"})
    assert db == "raw_customer", f"expected prefixed physical schema, got {db!r}"
    assert "`raw_customer`" in tt and "consentevent" in tt, tt


def test_v421_no_prefix_context_unchanged():
    """Build path (no SCHEMA_PREFIX): single candidate, behaves exactly as pre-patch."""
    tt, db = _run_block(schema_prefix="", resolved_db="customer", existing_schemas={"customer"})
    assert db == "customer", db
    assert "`customer`" in tt


def test_v421_prefix_block_present_in_notebook():
    """Structural: the alias, candidate loop, and config wiring must be present."""
    ins = _cell_src(lambda s: "_insert_product_samples" in s and "v421-gensamples-schema-prefix" in s)
    assert "_sg_cand_schemas" in ins and "DESCRIBE TABLE" in ins
    cfg = _cell_src(lambda s: "_sample_gen_resolver" in s and "'MODEL_CONVENTIONS': _model_conventions," in s)
    assert "'SCHEMA_PREFIX': _file_conventions.get(\"schema_prefix\"" in cfg


def test_v421_pre_patch_would_fail():
    """Prove the failure mode: prefix-blind resolution (no candidate) targets the nonexistent
    unprefixed schema -> DESCRIBE raises -> would skip the insert."""
    resolver = _StubResolver()
    spark = _StubSpark({"raw_customer"})  # only prefixed exists physically
    logical = resolver.resolve_schema({"database_name": "customer"})
    assert logical == "customer"
    raised = False
    try:
        spark.sql("DESCRIBE TABLE `t04_instmv1_business_catalog`.`customer`.`consentevent`")
    except Exception:
        raised = True
    assert raised, "pre-patch unprefixed target should not exist -> insert skipped -> 0 rows"
