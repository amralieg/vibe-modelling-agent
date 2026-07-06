import json, re, os, textwrap, pytest

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")
NB_PRE = "/tmp/agent_pre_v411.ipynb"


def _full_src(path):
    nb = json.load(open(path))
    return "".join(
        "".join(c.get("source", [])) if isinstance(c.get("source"), list) else c.get("source", "")
        for c in nb["cells"]
    )


def _extract_fn(src, name):
    m = re.search(rf"\n    def {name}\(self.*?\n    def ", src, re.S)
    assert m, f"{name} not found"
    body = m.group(0)
    body = body[: body.rfind("\n    def ")]
    return textwrap.dedent(body)


class _Logger:
    def info(self, *a, **k): pass
    def warning(self, *a, **k): pass
    def error(self, *a, **k): pass


class _Req:
    def __init__(self, text, rid="VREQ-T", strategy="llm_verify", scope="domain", scope_targets=None):
        self.original_text = text
        self.id = rid
        self.verification_strategy = strategy
        self.scope = scope
        self.scope_targets = scope_targets or []


def _prods(pairs):
    return [{"domain": d, "product": p} for d, p in pairs]


# Faithful reproduction of live retail v2 VREQ-002 (scoreboard scored it 'partial' at 55.9% precision
# while inventory + all 19 named products were physically built).
INVENTORY = ["stock_position", "stock_ledger", "inventory_node", "replenishment_order", "cycle_count",
             "adjustment", "stock_transfer", "goods_receipt", "rfid_tag", "vmi_agreement",
             "expiry_tracking", "reservation", "reorder_policy", "asn", "lot", "node_assortment",
             "promo_stock_allocation", "location_assignment", "assortment_deployment"]
VREQ002_TEXT = ("Create the inventory domain with the following products: " + ", ".join(INVENTORY) + ".")


def _bind(path, name):
    src = _full_src(path)
    ns = {"re": re}
    exec(_extract_fn(src, name), ns)

    class Dummy:
        logger = _Logger()
    setattr(Dummy, name, ns[name])
    return Dummy()


# ---------- helper-level: coverage grading is real (non-tautology: includes MUST-fail cases) ----------

def test_full_coverage_fulfilled():
    obj = _bind(NB, "_verify_domain_create_coverage")
    prods = _prods([("inventory", p) for p in INVENTORY])
    req = _Req(VREQ002_TEXT, rid="VREQ-002", scope_targets=["inventory"])
    v = obj._verify_domain_create_coverage(req, prods)
    assert v is not None and v["status"] == "fulfilled", v
    assert "verifier-domain-create-coverage" in v["evidence"]


def test_ninety_pct_coverage_fulfilled():
    # 17 of 19 present (2 intentionally moved out, as consent/preference were in retail) -> 89.5%?
    # 18/19 = 94.7% >= 0.9 -> fulfilled. Prove the threshold credits a near-complete build.
    obj = _bind(NB, "_verify_domain_create_coverage")
    prods = _prods([("inventory", p) for p in INVENTORY[:18]])
    req = _Req(VREQ002_TEXT, rid="VREQ-002", scope_targets=["inventory"])
    v = obj._verify_domain_create_coverage(req, prods)
    assert v is not None and v["status"] == "fulfilled", v


def test_half_coverage_partial():
    obj = _bind(NB, "_verify_domain_create_coverage")
    prods = _prods([("inventory", p) for p in INVENTORY[:10]])  # 10/19 = 52%
    req = _Req(VREQ002_TEXT, rid="VREQ-002", scope_targets=["inventory"])
    v = obj._verify_domain_create_coverage(req, prods)
    assert v is not None and v["status"] == "partial", v


def test_zero_named_present_failed():
    # MUST-fail (non-tautology): domain exists but none of the NAMED products are present.
    obj = _bind(NB, "_verify_domain_create_coverage")
    prods = _prods([("inventory", x) for x in ["foo", "bar", "baz"]])
    req = _Req(VREQ002_TEXT, rid="VREQ-002", scope_targets=["inventory"])
    v = obj._verify_domain_create_coverage(req, prods)
    assert v is not None and v["status"] == "failed", v


def test_domain_absent_failed():
    obj = _bind(NB, "_verify_domain_create_coverage")
    prods = _prods([("customer", "profile")])  # inventory domain absent entirely
    req = _Req(VREQ002_TEXT, rid="VREQ-002", scope_targets=["inventory"])
    v = obj._verify_domain_create_coverage(req, prods)
    assert v is not None and v["status"] == "failed", v


def test_not_domain_create_returns_none():
    # A non-domain-create VReq must be ignored (return None) so it cannot hijack other verdicts.
    obj = _bind(NB, "_verify_domain_create_coverage")
    req = _Req("Add a foreign key on order.header.customer_id to customer.profile.profile_id",
               rid="VREQ-X", scope="relation", scope_targets=["order.header"])
    v = obj._verify_domain_create_coverage(req, _prods([("order", "header")]))
    assert v is None, v


# ---------- integration through _verify_structural_target (the llm_verify rescue path) ----------

def test_structural_target_rescues_domain_create():
    obj = _bind(NB, "_verify_structural_target")
    # _verify_structural_target requires the helper as a sibling method; bind it too.
    src = _full_src(NB)
    ns = {"re": re}
    exec(_extract_fn(src, "_verify_domain_create_coverage"), ns)
    type(obj)._verify_domain_create_coverage = ns["_verify_domain_create_coverage"]
    # other early-return helpers it calls must exist as no-op-safe; bind the two it invokes first.
    for fn in ("_v395_verify_description_coverage", "_v394_verify_move_type_count"):
        exec(_extract_fn(src, fn), ns)
        setattr(type(obj), fn, ns[fn])
    prods = _prods([("inventory", p) for p in INVENTORY])
    req = _Req(VREQ002_TEXT, rid="VREQ-002", scope_targets=["inventory"])
    v = obj._verify_structural_target(req, prods, [])
    assert v is not None and v["status"] == "fulfilled", v


# ---------- pre-patch proof: the FN existed (domain-create VReq not resolvable -> not fulfilled) ----------

@pytest.mark.skipif(not os.path.exists(NB_PRE), reason="pre-v411 backup absent")
def test_pre_patch_structural_target_not_fulfilled():
    pre = _full_src(NB_PRE)
    assert "_verify_domain_create_coverage" not in pre, "pre-patch must lack the helper"
    ns = {"re": re}
    exec(_extract_fn(pre, "_verify_structural_target"), ns)
    for fn in ("_v395_verify_description_coverage", "_v394_verify_move_type_count"):
        exec(_extract_fn(pre, fn), ns)

    class Dummy:
        logger = _Logger()
    Dummy._verify_structural_target = ns["_verify_structural_target"]
    Dummy._v395_verify_description_coverage = ns["_v395_verify_description_coverage"]
    Dummy._v394_verify_move_type_count = ns["_v394_verify_move_type_count"]
    obj = Dummy()
    prods = _prods([("inventory", p) for p in INVENTORY])
    req = _Req(VREQ002_TEXT, rid="VREQ-002", scope_targets=["inventory"])
    v = obj._verify_structural_target(req, prods, [])
    # pre-patch: no domain-create branch -> cannot resolve a bare-domain create VReq to fulfilled
    assert not (v is not None and v.get("status") == "fulfilled"), f"expected pre-patch non-fulfilled, got {v}"


def test_v411_alias_present():
    full = _full_src(NB)
    assert "verifier-domain-create-coverage" in full


# ---------- v4.1.1 model-wide-with-domain-preference matching (the automotive regression fix) ----------

def test_cross_domain_redistribution_fulfilled():
    # Mirrors live automotive VREQ-015 aftersales: the directive names 19 products but the architect
    # legitimately re-homes most of them to better domains (vehicle/product/compliance). Domain-scoped
    # matching would FALSE-PARTIAL this good build; model-wide presence must credit it -> fulfilled.
    obj = _bind(NB, "_verify_domain_create_coverage")
    # only 2 of the 19 stay in the target domain; the rest are placed elsewhere. Short tokens
    # (asn, lot) are matched via EXACT model-wide presence (length-independent); long tokens via the
    # guarded prefix/suffix path. Proves a legit re-home is credited -> fulfilled.
    prods = _prods(
        [("inventory", INVENTORY[0]), ("inventory", INVENTORY[1])]       # 2 in target domain
        + [("product", p) for p in INVENTORY[2:15]]                      # 13 exact in another domain
        + [("vehicle", "rehomed_" + p) for p in INVENTORY[15:]]          # 4 long-named, suffix match
    )
    req = _Req(VREQ002_TEXT, rid="VREQ-015", scope_targets=["inventory"])
    v = obj._verify_domain_create_coverage(req, prods)
    assert v is not None and v["status"] == "fulfilled", v


def test_genuinely_absent_stays_partial_modelwide():
    # Mirrors live water_utilities wastewater 10/30: most named products exist NOWHERE in the model.
    # Model-wide matching must NOT rescue them -> honest partial (anti-lying-scoreboard in reverse).
    obj = _bind(NB, "_verify_domain_create_coverage")
    prods = _prods(
        [("inventory", p) for p in INVENTORY[:10]]            # 10 named present in domain
        + [("unrelated", "alpha_widget"), ("misc", "beta_gadget")]  # decoys, no overlap with named
    )
    req = _Req(VREQ002_TEXT, rid="VREQ-006", scope_targets=["inventory"])
    v = obj._verify_domain_create_coverage(req, prods)
    assert v is not None and v["status"] == "partial", v


def test_guarded_suffix_no_short_token_overmatch():
    # The guard (len>=6 or contains "_") prevents a short generic named token from matching an
    # unrelated *_token product model-wide. Named 'sku' (len 3) must NOT be credited by 'dealer_sku'
    # via suffix; it is only credited by an EXACT 'sku' product. Prove the guard is not a tautology.
    obj = _bind(NB, "_verify_domain_create_coverage")
    text = "Create the catalog domain with the following products: sku, ima."
    # model has 'dealer_sku' and 'schema' (endswith _ima? no) -> neither should credit 'sku'/'ima' by suffix
    prods = _prods([("inventory", "dealer_sku"), ("inventory", "max_ima"), ("catalog", "listing")])
    req = _Req(text, rid="VREQ-G", scope_targets=["catalog"])
    v = obj._verify_domain_create_coverage(req, prods)
    # 0 of the 2 short named tokens credited (catalog present but neither sku nor ima built) -> failed
    assert v is not None and v["status"] == "failed", v
    # now add an EXACT 'sku' product -> 1/2 credited -> partial (proves exact match still works)
    prods2 = prods + _prods([("catalog", "sku")])
    v2 = obj._verify_domain_create_coverage(req, prods2)
    assert v2 is not None and v2["status"] == "partial", v2
