import json, re, os, textwrap, pytest

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")
NB_PRE = "/tmp/agent_pre_v334.ipynb"  # pre-v334 backup for no-tautology proof


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


def _bind(path):
    src = _full_src(path)
    fn_src = _extract_fn(src, "_verify_structural_target")
    ns = {}
    exec(fn_src, ns)
    fn = ns["_verify_structural_target"]

    class Dummy:
        logger = _Logger()
    Dummy._verify_structural_target = fn
    return Dummy()


class _Req:
    def __init__(self, text, rid="VREQ-T", scope_targets=None):
        self.original_text = text
        self.id = rid
        self.scope_targets = scope_targets or []


def _attrs(rows):
    return [{"domain": d, "product": p, "attribute": a, "foreign_key_to": fk, "tags": tg}
            for d, p, a, fk, tg in rows]


def _prods(pairs):
    return [{"domain": d, "product": p} for d, p in pairs]


# ---------- Fix 1: multi-FK disambiguation rename (gov_transport 036/039/041/042) ----------

def test_multifk_disambig_generic_gone_with_variants_is_fulfilled():
    obj = _bind(NB)
    # generic employee_id is GONE; role-specific variants ending in employee_id exist
    attrs = _attrs([
        ("hr", "onboarding", "onboarding_employee_id", "hr.employee.employee_id", None),
        ("hr", "onboarding", "supervisor_employee_id", "hr.employee.employee_id", None),
        ("hr", "onboarding", "assigned_buddy_employee_id", "hr.employee.employee_id", None),
    ])
    req = _Req("Rename column employee_id to onboarded_employee_id on hr.onboarding because the table "
               "has four FKs to hr.employee and the generic one needs a business-meaningful role.",
               scope_targets=["hr.onboarding"])
    v = obj._verify_structural_target(req, _prods([("hr", "onboarding")]), attrs)
    assert v and v["status"] == "fulfilled", v
    assert "disambig" in v["evidence"], v


def test_multifk_disambig_bare_generic_still_present_is_failed():
    # No-tautology: if the bare generic employee_id still exists, must NOT claim fulfilled.
    obj = _bind(NB)
    attrs = _attrs([
        ("hr", "onboarding", "employee_id", "hr.employee.employee_id", None),
        ("hr", "onboarding", "supervisor_employee_id", "hr.employee.employee_id", None),
    ])
    req = _Req("Rename column employee_id to onboarded_employee_id on hr.onboarding because the table "
               "has four FKs to hr.employee and the generic one needs a business-meaningful role.",
               scope_targets=["hr.onboarding"])
    v = obj._verify_structural_target(req, _prods([("hr", "onboarding")]), attrs)
    assert v and v["status"] == "failed", v


def test_multifk_disambig_no_variants_returns_none():
    # No-tautology: generic gone but NO role-suffixed variant -> cannot claim disambiguation -> None.
    obj = _bind(NB)
    attrs = _attrs([
        ("hr", "onboarding", "start_date", "", None),
        ("hr", "onboarding", "status", "", None),
    ])
    req = _Req("Rename column employee_id to onboarded_employee_id on hr.onboarding because the table "
               "has four FKs to hr.employee and the generic one needs a business-meaningful role.",
               scope_targets=["hr.onboarding"])
    v = obj._verify_structural_target(req, _prods([("hr", "onboarding")]), attrs)
    assert v is None, v


def test_multifk_disambig_requires_cue_no_cue_no_false_fulfill():
    # Plain rename (no multi-FK/role cue) with both names absent must NOT trigger disambig fulfill.
    obj = _bind(NB)
    attrs = _attrs([("hr", "onboarding", "onboarding_employee_id", "", None)])
    req = _Req("Rename column employee_id to onboarded_employee_id on hr.onboarding.",
               scope_targets=["hr.onboarding"])
    v = obj._verify_structural_target(req, _prods([("hr", "onboarding")]), attrs)
    # "role" is not present, no "fk to"/"generic" cue -> disambig case must not fire
    assert v is None or v["status"] != "fulfilled", v


# ---------- Fix 2: fully-qualified attribute name (gov_transport VREQ-062) ----------

def test_fqn_attr_tag_absent_is_failed_not_none():
    obj = _bind(NB)
    # subject is fully-qualified, no "on D.P" phrase, attribute present but untagged
    attrs = _attrs([("hr", "compensation", "compensation_subject_employee_id", "", None)])
    req = _Req("Classify the PII-candidate attribute hr.compensation.compensation_subject_employee_id "
               "with restricted/confidential classification and a PII tag, since it currently has no "
               "classification tags.")
    v = obj._verify_structural_target(req, _prods([("hr", "compensation")]), attrs)
    assert v and v["status"] == "failed", v


def test_fqn_attr_tag_present_is_fulfilled():
    obj = _bind(NB)
    attrs = _attrs([("hr", "compensation", "compensation_subject_employee_id", "",
                     {"gov_transport_pii": "true", "classification": "restricted"})])
    req = _Req("Classify the PII-candidate attribute hr.compensation.compensation_subject_employee_id "
               "with restricted/confidential classification and a PII tag.")
    v = obj._verify_structural_target(req, _prods([("hr", "compensation")]), attrs)
    assert v and v["status"] == "fulfilled", v


# ---------- No-tautology vs pre-v334 backup ----------

@pytest.mark.skipif(not os.path.exists(NB_PRE), reason="pre-v334 backup absent")
def test_pre_v334_does_not_verify_disambig():
    obj = _bind(NB_PRE)
    attrs = _attrs([
        ("hr", "onboarding", "onboarding_employee_id", "hr.employee.employee_id", None),
        ("hr", "onboarding", "supervisor_employee_id", "hr.employee.employee_id", None),
    ])
    req = _Req("Rename column employee_id to onboarded_employee_id on hr.onboarding because the table "
               "has four FKs to hr.employee and the generic one needs a business-meaningful role.",
               scope_targets=["hr.onboarding"])
    v = obj._verify_structural_target(req, _prods([("hr", "onboarding")]), attrs)
    # pre-v334: no disambig branch -> both names absent -> falls through -> None
    assert v is None, f"expected pre-v334 to NOT verify disambig, got {v}"


# ---------- version + aliases ----------

def test_version_is_334():
    full = _full_src(NB)
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', full)
    assert m, "version constant missing"
    assert tuple(int(g) for g in m.groups()) >= (3, 3, 4), m.group(0)


def test_v334_aliases_present():
    full = _full_src(NB)
    assert "verifier-fqn-attr FIRED v3.3.4" in full
    assert "verifier-rename-disambig FIRED v3.3.4" in full
