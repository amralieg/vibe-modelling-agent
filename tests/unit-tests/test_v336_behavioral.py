import json, re, os, textwrap, pytest

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")
NB_PRE = "/tmp/agent_pre_v336.ipynb"


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


def _bind_structural(path):
    src = _full_src(path)
    ns = {"re": re}
    exec(_extract_fn(src, "_verify_structural_target"), ns)

    class Dummy:
        logger = _Logger()

    Dummy._verify_structural_target = ns["_verify_structural_target"]
    return Dummy()


class _Req:
    def __init__(self, text, rid="VREQ-T", strategy="llm_verify", scope_targets=None):
        self.original_text = text
        self.id = rid
        self.verification_strategy = strategy
        self.scope_targets = scope_targets or []


def _attrs(rows):
    return [{"domain": d, "product": p, "attribute": a, "foreign_key_to": fk, "tags": tg}
            for d, p, a, fk, tg in rows]


def _prods(pairs):
    return [{"domain": d, "product": p} for d, p in pairs]


# ---------- RC2: remove-FK VREQ whose rationale mentions tag/classification must NOT route to tag branch ----------

# Faithful reproduction of NCDOT VREQ-008: a remove-FK directive whose RATIONALE mentions
# 'classification', where the FK removal did NOT land (column still present, no tags).
REMOVE_FK_TEXT = ("On table hr.eligibility_rule, remove the foreign key on column employee_id, "
                  "because eligibility_rule is a classification reference, not an employee relation.")


def _fk_present_attrs():
    # employee_id still carries its FK (removal never landed) and has no tags.
    return _attrs([("hr", "eligibility_rule", "employee_id", "hr.employee.employee_id", None),
                   ("hr", "eligibility_rule", "rule_id", None, None)])


def test_rc2_remove_fk_diagnosed_as_fk_not_tags():
    obj = _bind_structural(NB)
    req = _Req(REMOVE_FK_TEXT, rid="VREQ-008", scope_targets=["hr.eligibility_rule"])
    v = obj._verify_structural_target(req, _prods([("hr", "eligibility_rule")]), _fk_present_attrs())
    # post-patch: the misrouted tag branch is suppressed -> remove branch diagnoses correctly.
    assert v is not None and v.get("status") == "failed", v
    ev = v.get("evidence", "").lower()
    assert "tag" not in ev, f"tag-branch misroute leaked into diagnosis: {v}"
    assert "fk still present" in ev or "fk removed" in ev, v


@pytest.mark.skipif(not os.path.exists(NB_PRE), reason="pre-v336 backup absent")
def test_rc2_pre_v336_misroutes_to_tag_failure():
    obj = _bind_structural(NB_PRE)
    req = _Req(REMOVE_FK_TEXT, rid="VREQ-008", scope_targets=["hr.eligibility_rule"])
    v = obj._verify_structural_target(req, _prods([("hr", "eligibility_rule")]), _fk_present_attrs())
    # pre-patch: tag branch fires on 'classification' rationale + 'column' -> false 'no tags' diagnosis
    assert v is not None and v.get("status") == "failed", v
    assert "tag" in v.get("evidence", "").lower(), f"expected pre-v336 tag misroute, got {v}"


# ---------- RC3: model-wide PII tagging verified deterministically (not via state_diff) ----------

PII_TEXT = ("Across the model, several attributes match person-data patterns but lack PII tags; "
            "apply pii classification tags to all person columns.")


def test_rc3_model_wide_pii_fulfilled_when_tagged():
    obj = _bind_structural(NB)
    tg = {"pii": "true"}
    attrs = _attrs([
        ("crm", "customer", "email", None, tg),
        ("crm", "customer", "phone", None, tg),
        ("crm", "customer", "ssn", None, tg),
        ("crm", "customer", "full_name", None, tg),
        ("crm", "customer", "customer_id", None, None),  # not a person pattern, ignored
    ])
    req = _Req(PII_TEXT, rid="VREQ-035", scope_targets=["*"])
    v = obj._verify_structural_target(req, _prods([("crm", "customer")]), attrs)
    assert v is not None and v.get("status") == "fulfilled", v
    assert "model-wide-pii-tag" in v.get("evidence", ""), v


def test_rc3_model_wide_pii_failed_when_untagged():
    obj = _bind_structural(NB)
    attrs = _attrs([
        ("crm", "customer", "email", None, None),
        ("crm", "customer", "phone", None, None),
        ("crm", "customer", "ssn", None, None),
    ])
    req = _Req(PII_TEXT, rid="VREQ-035", scope_targets=["*"])
    v = obj._verify_structural_target(req, _prods([("crm", "customer")]), attrs)
    # MUST be able to fail (non-tautology): zero tagged person cols -> failed
    assert v is not None and v.get("status") == "failed", v


@pytest.mark.skipif(not os.path.exists(NB_PRE), reason="pre-v336 backup absent")
def test_rc3_pre_v336_returns_none_for_model_wide():
    obj = _bind_structural(NB_PRE)
    tg = {"pii": "true"}
    attrs = _attrs([("crm", "customer", "email", None, tg), ("crm", "customer", "ssn", None, tg)])
    req = _Req(PII_TEXT, rid="VREQ-035", scope_targets=["*"])
    v = obj._verify_structural_target(req, _prods([("crm", "customer")]), attrs)
    # pre-patch: no model-wide branch -> cannot resolve a model-wide tag VREQ to fulfilled
    assert not (v is not None and v.get("status") == "fulfilled"), f"expected pre-v336 non-fulfilled, got {v}"


# ---------- RC1: DDL FK MISSING uses column_name (self-FK col_name != attribute is NOT flagged) ----------

def _extract_rc1_block(path):
    src = _full_src(path)
    # Capture full lines (including leading indentation) so dedent normalises cleanly.
    m = re.search(r"\n( *)expected_fk_cols = set\(\)\n(?:.*\n){2,8}? *expected_fk_cols\.add\(_fkcn_v336\)", src)
    assert m, "RC1 v336 block not found"
    return textwrap.dedent(m.group(0))


def test_rc1_selffk_colname_not_flagged():
    # Replicate the shipped derivation against the production helper get_attr_value.
    def get_attr_value(a, key, default=None):
        return a.get(key, default)
    product_attrs = [
        {"attribute": "parent_pse_category_id", "column_name": "parent_pse_category_dsctr_category_id",
         "foreign_key_to": "dsctr.dsctr_category.dsctr_category_id"},
        {"attribute": "pse_category_id", "column_name": "pse_category_id", "foreign_key_to": None},
    ]
    generated_columns = {"parent_pse_category_dsctr_category_id", "pse_category_id"}
    ns = {"product_attrs": product_attrs, "get_attr_value": get_attr_value}
    exec(_extract_rc1_block(NB), ns)
    expected_fk_cols = ns["expected_fk_cols"]
    missing = expected_fk_cols - generated_columns
    assert expected_fk_cols == {"parent_pse_category_dsctr_category_id"}, expected_fk_cols
    assert missing == set(), f"v336 falsely flagged columns that exist: {missing}"


def test_rc1_pre_v336_attr_name_would_false_flag():
    # Pre-patch behaviour: expected built from ATTRIBUTE name -> spurious 'missing'
    fk_attrs_after_dedup = [("parent_pse_category_id",)]
    generated_columns = {"parent_pse_category_dsctr_category_id"}
    expected_fk_cols = set(fk[0] for fk in fk_attrs_after_dedup)
    missing = expected_fk_cols - generated_columns
    assert missing == {"parent_pse_category_id"}, "demonstrates the pre-v336 false positive"


# ---------- RC5: subprocess runner exposes _re / _cp aliases for LLM-generated mutators ----------

def _extract_prefix(path):
    src = _full_src(path)
    m = re.search(r'SUBPROCESS_RUNNER_PREFIX = r"""(.*?)"""', src, re.S)
    assert m, "SUBPROCESS_RUNNER_PREFIX not found"
    body = m.group(1)
    # cut at the stdin read so exec does not block on input
    cut = body.find("_input = _sys_internal.stdin.read()")
    return body[:cut]


def test_rc5_runner_defines_re_cp_aliases():
    ns = {}
    exec(_extract_prefix(NB), ns)
    import re as _re_mod, copy as _copy_mod
    assert ns.get("_re") is _re_mod, "subprocess runner must alias _re = re"
    assert ns.get("_cp") is _copy_mod, "subprocess runner must alias _cp = copy"
    # a mutator body using _re/_cp must resolve without NameError
    mut = "def _m(model):\n    m2 = _cp.deepcopy(model)\n    return {'k': bool(_re.search('a','abc'))}\n"
    exec(mut, ns)
    assert ns["_m"]({"x": 1}) == {"k": True}


@pytest.mark.skipif(not os.path.exists(NB_PRE), reason="pre-v336 backup absent")
def test_rc5_pre_v336_mutator_using_aliases_raises_nameerror():
    ns = {}
    exec(_extract_prefix(NB_PRE), ns)
    mut = "def _m(model):\n    return _cp.deepcopy(model)\n"
    exec(mut, ns)
    with pytest.raises(NameError):
        ns["_m"]({"x": 1})


# ---------- version + alias presence ----------

def test_version_is_336():
    full = _full_src(NB)
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', full)
    assert m and tuple(int(g) for g in m.groups()) >= (3, 3, 6), m.group(0) if m else "missing"


def test_v336_aliases_present():
    full = _full_src(NB)
    for alias in ("mutator-runner-alias", "ddl-fk-missing-colname-check",
                  "tag-vs-remove-precedence", "verifier-model-wide-pii-tag"):
        assert alias in full, f"missing alias {alias}"
