"""v4.2.6 anti-lying-scoreboard verifier fixes (fail-pre / pass-post, §8.10).

Root causes (coffee_roastery base-MVM run 907028114518006 reported 33.3% adherence on a ~100% model):
  (a) verifier-domain-create-name-normalize -- vibe display domain names carry spaces
      ("green coffee sourcing and roasting") while the physical domain is space/punct-collapsed
      ("greencoffeesourcingandroasting"), so == / endswith / substring never matched and the domain
      false-scored "absent -> failed".
  (b) verifier-structural-invariant-deterministic -- model-wide structural invariants (PK / FK-resolve /
      silo / cycle) carry scope_target "*", so _verify_deterministic's per-target loop skips them, they
      fall through to a blind-partial, route to the LLM verifier, and false-fail on a transient
      SparkException.
"""
import json, re, os, textwrap, pytest

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")
NB_PRE = "/tmp/agent_pre_v426.ipynb"


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
    def __init__(self, text, rid="VREQ-T", strategy="deterministic", scope="model", scope_targets=None):
        self.original_text = text
        self.id = rid
        self.verification_strategy = strategy
        self.scope = scope
        self.scope_targets = scope_targets if scope_targets is not None else ["*"]


def _bind(path, name):
    src = _full_src(path)
    ns = {"re": re}
    exec(_extract_fn(src, name), ns)

    class Dummy:
        logger = _Logger()
    setattr(Dummy, name, ns[name])
    return Dummy()


def _prods(pairs, pk=None):
    return [{"domain": d, "product": p, "primary_key": pk} for d, p in pairs]


def _attr(dom, prod, name, is_pk=False, fk=None):
    return {"domain": dom, "product": prod, "attribute": name,
            "is_primary_key": is_pk, "foreign_key_to": fk}


# ============================================================================
# FIX (a): name-normalization in _verify_domain_create_coverage
# ============================================================================

# Faithful reproduction of the live coffee_roastery VREQ-002: the vibe names the domain with SPACES
# but the physical/model domain is space+punct collapsed.
DISPLAY = "green coffee sourcing and roasting"
PHYSICAL = "greencoffeesourcingandroasting"
NAMED = ["supplier", "green_lot", "roast_batch", "roast_profile"]
VREQ_TEXT = ("Create a %s domain with the following products: %s." % (DISPLAY, ", ".join(NAMED)))


def _spaced_model_prods():
    return _prods([(PHYSICAL, p) for p in NAMED])


def test_a_post_patch_spaced_domain_name_fulfilled():
    # POST-PATCH: the collapsed-form match credits the physically-present domain -> fulfilled.
    obj = _bind(NB, "_verify_domain_create_coverage")
    req = _Req(VREQ_TEXT, rid="VREQ-002", scope="domain", scope_targets=[DISPLAY])
    v = obj._verify_domain_create_coverage(req, _spaced_model_prods())
    assert v is not None and v["status"] == "fulfilled", v


def test_a_pre_patch_spaced_domain_name_false_fails():
    # FAIL-PRE: the pre-patch matcher (no collapse) cannot match "green coffee sourcing and roasting"
    # against "greencoffeesourcingandroasting" -> domain scored absent -> failed (the lying scoreboard).
    if not os.path.exists(NB_PRE):
        pytest.skip("pre-v426 backup absent")
    assert "verifier-domain-create-name-normalize" not in _full_src(NB_PRE)
    obj = _bind(NB_PRE, "_verify_domain_create_coverage")
    req = _Req(VREQ_TEXT, rid="VREQ-002", scope="domain", scope_targets=[DISPLAY])
    v = obj._verify_domain_create_coverage(req, _spaced_model_prods())
    assert v is not None and v["status"] == "failed", f"expected pre-patch false-fail, got {v}"


def test_a_genuinely_absent_domain_still_failed():
    # NON-TAUTOLOGY must-fail: a domain that truly does not exist anywhere must still fail post-patch.
    obj = _bind(NB, "_verify_domain_create_coverage")
    req = _Req(VREQ_TEXT, rid="VREQ-002", scope="domain", scope_targets=[DISPLAY])
    v = obj._verify_domain_create_coverage(req, _prods([("customer_loyalty", "customer")]))
    assert v is not None and v["status"] == "failed", v


# ============================================================================
# FIX (b): deterministic structural-invariant verifier
# ============================================================================

PK_TXT = "Every table in the model must have a primary key."
FK_TXT = "All foreign keys must resolve to a valid target (no dangling references)."
SILO_TXT = "There must be no siloed tables; every table must connect to the rest of the model."
CYC_TXT = "The foreign-key relationship graph must contain no cycles."


def _clean_model():
    # 3 tables, all with a PK attr; a resolvable FK chain a->b->c; no silo; no cycle.
    prods = _prods([("sales", "a"), ("sales", "b"), ("ref", "c")])
    attrs = [
        _attr("sales", "a", "a_id", is_pk=True),
        _attr("sales", "a", "b_id", fk="sales.b.b_id"),
        _attr("sales", "b", "b_id", is_pk=True),
        _attr("sales", "b", "c_id", fk="ref.c.c_id"),
        _attr("ref", "c", "c_id", is_pk=True),
    ]
    return prods, attrs


def _bind_struct():
    return _bind(NB, "_verify_structural_invariant")


def test_b_clean_model_all_invariants_fulfilled():
    obj = _bind_struct()
    prods, attrs = _clean_model()
    for txt, kind in [(PK_TXT, "PK"), (FK_TXT, "FK"), (SILO_TXT, "silo"), (CYC_TXT, "cycle")]:
        v = obj._verify_structural_invariant(_Req(txt), [], prods, attrs)
        assert v is not None and v["status"] == "fulfilled", (kind, v)
        assert "verifier-structural-invariant-deterministic" in v["evidence"], (kind, v)


def test_b_missing_pk_failed():
    # NON-TAUTOLOGY: table 'c' loses its PK -> PK invariant must fail.
    obj = _bind_struct()
    prods, attrs = _clean_model()
    attrs = [a for a in attrs if not (a["product"] == "c" and a["is_primary_key"])]
    attrs.append(_attr("ref", "c", "c_id", is_pk=False, fk=None))
    v = obj._verify_structural_invariant(_Req(PK_TXT), [], prods, attrs)
    assert v is not None and v["status"] == "failed", v
    assert "ref.c" in v["evidence"], v


def test_b_dangling_fk_failed():
    # NON-TAUTOLOGY: b.c_id points at a non-existent table -> FK-resolve invariant must fail.
    obj = _bind_struct()
    prods, attrs = _clean_model()
    for a in attrs:
        if a["attribute"] == "c_id" and a["product"] == "b":
            a["foreign_key_to"] = "ref.does_not_exist.x_id"
    v = obj._verify_structural_invariant(_Req(FK_TXT), [], prods, attrs)
    assert v is not None and v["status"] == "failed", v


def test_b_silo_failed():
    # NON-TAUTOLOGY: add an island table with no FK in and no FK out -> silo invariant must fail.
    obj = _bind_struct()
    prods, attrs = _clean_model()
    prods = prods + _prods([("misc", "island")])
    attrs = attrs + [_attr("misc", "island", "island_id", is_pk=True)]
    v = obj._verify_structural_invariant(_Req(SILO_TXT), [], prods, attrs)
    assert v is not None and v["status"] == "failed", v
    assert "misc.island" in v["evidence"], v


def test_b_cycle_failed():
    # NON-TAUTOLOGY: close the chain c->a so a->b->c->a is a cycle -> cycle invariant must fail.
    obj = _bind_struct()
    prods, attrs = _clean_model()
    attrs = attrs + [_attr("ref", "c", "a_id", fk="sales.a.a_id")]
    v = obj._verify_structural_invariant(_Req(CYC_TXT), [], prods, attrs)
    assert v is not None and v["status"] == "failed", v


def test_b_targeted_vreq_returns_none():
    # A targeted (non-model-wide) VReq has no universal quantifier and scope_targets != "*" -> None,
    # so it cannot hijack the targeted verification paths.
    obj = _bind_struct()
    req = _Req("Add a primary key column order_id to the order.header table.",
               scope="table", scope_targets=["order.header"])
    v = obj._verify_structural_invariant(req, [], *_clean_model())
    assert v is None, v


def test_b_non_structural_vreq_returns_none():
    # A model-wide but non-structural VReq (tagging) must not be claimed by the structural verifier.
    obj = _bind_struct()
    req = _Req("Every attribute must carry a business glossary tag.")
    v = obj._verify_structural_invariant(req, [], *_clean_model())
    assert v is None, v


# ============================================================================
# Wiring / fail-pre proofs (§8.4 no dead code, §8.10 fail-pre)
# ============================================================================

def test_b_call_site_exists_in_verify_deterministic():
    # §8.4: the new helper must have a live call site (not dead code).
    src = _full_src(NB)
    m = re.search(r"\n    def _verify_deterministic\(self.*?\n    def ", src, re.S)
    assert m, "_verify_deterministic not found"
    body = m.group(0)
    assert "self._verify_structural_invariant(" in body, "structural verifier not called from _verify_deterministic"


def test_b_pre_patch_lacks_helper_and_callsite():
    # FAIL-PRE: pre-patch build has neither the helper nor its call site.
    if not os.path.exists(NB_PRE):
        pytest.skip("pre-v426 backup absent")
    pre = _full_src(NB_PRE)
    assert "def _verify_structural_invariant(" not in pre
    assert "_v426_struct" not in pre


def test_version_bumped_to_426():
    src = _full_src(NB)
    assert re.search(r'__AGENT_VERSION__ = "4\.2\.[6-9]"', src), "engine build must be >= 4.2.6 (monotonic; v4.2.6 fixes remain live)"


def test_aliases_present():
    src = _full_src(NB)
    assert "verifier-domain-create-name-normalize" in src
    assert "verifier-structural-invariant-deterministic" in src
