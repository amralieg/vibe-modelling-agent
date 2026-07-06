import json, re, os, types, textwrap, pytest

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")
NB_PRE = "/tmp/agent_pre_v333.ipynb"  # pre-patch backup (optional, for no-tautology proof)


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
    body = body[: body.rfind("\n    def ")]  # drop trailing next-def
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
    # rows: list of (domain, product, attribute, fk, tags)
    out = []
    for d, p, a, fk, tg in rows:
        out.append({"domain": d, "product": p, "attribute": a, "foreign_key_to": fk, "tags": tg})
    return out


def _prods(pairs):
    return [{"domain": d, "product": p} for d, p in pairs]


# ---------------- RENAME (RC-1) ----------------

def test_rename_applied_is_fulfilled():
    obj = _bind(NB)
    attrs = _attrs([("hr", "employee", "home_organization_id", "hr.organization.organization_id", None),
                    ("hr", "employee", "employee_id", "", None)])
    req = _Req("Rename column organization_id to home_organization_id on hr.employee because role.",
               scope_targets=["hr.employee"])
    v = obj._verify_structural_target(req, _prods([("hr", "employee")]), attrs)
    assert v and v["status"] == "fulfilled", v


def test_rename_not_applied_is_failed():
    # OLD still present, NEW absent -> must FAIL (no-tautology proof)
    obj = _bind(NB)
    attrs = _attrs([("hr", "employee", "organization_id", "hr.organization.organization_id", None)])
    req = _Req("Rename column organization_id to home_organization_id on hr.employee because role.",
               scope_targets=["hr.employee"])
    v = obj._verify_structural_target(req, _prods([("hr", "employee")]), attrs)
    assert v and v["status"] == "failed", v


def test_rename_both_present_is_partial():
    obj = _bind(NB)
    attrs = _attrs([("hr", "employee", "organization_id", "", None),
                    ("hr", "employee", "home_organization_id", "", None)])
    req = _Req("Rename column organization_id to home_organization_id on hr.employee.",
               scope_targets=["hr.employee"])
    v = obj._verify_structural_target(req, _prods([("hr", "employee")]), attrs)
    assert v and v["status"] == "partial", v


# ---------------- TAG (RC-3) ----------------

def test_tag_present_is_fulfilled():
    obj = _bind(NB)
    attrs = _attrs([("hr", "compensation", "compensation_employee_id", "", {"gov_transport_pii": "true", "classification": "restricted"})])
    req = _Req("Add classification tags restricted/confidential and gov_transport_pii to column compensation_employee_id in hr.compensation.",
               scope_targets=["hr.compensation"])
    v = obj._verify_structural_target(req, _prods([("hr", "compensation")]), attrs)
    assert v and v["status"] == "fulfilled", v


def test_tag_absent_is_failed():
    obj = _bind(NB)
    attrs = _attrs([("hr", "compensation", "compensation_employee_id", "", None)])
    req = _Req("Add classification tags restricted/confidential and gov_transport_pii to column compensation_employee_id in hr.compensation.",
               scope_targets=["hr.compensation"])
    v = obj._verify_structural_target(req, _prods([("hr", "compensation")]), attrs)
    assert v and v["status"] == "failed", v


# ---------------- REMOVE FK (RC-4) "foreign key" phrasing ----------------

def test_remove_foreign_key_phrasing_fulfilled_when_gone():
    obj = _bind(NB)
    # column present but no FK -> remove satisfied
    attrs = _attrs([("project", "dsctr_dropdown_lookup", "dsctr_group_control_id", "", None)])
    req = _Req("Remove the foreign key on column dsctr_group_control_id in project.dsctr_dropdown_lookup because dup.",
               scope_targets=["project.dsctr_dropdown_lookup"])
    v = obj._verify_structural_target(req, _prods([("project", "dsctr_dropdown_lookup")]), attrs)
    assert v and v["status"] == "fulfilled", v


def test_remove_foreign_key_phrasing_failed_when_present():
    obj = _bind(NB)
    attrs = _attrs([("project", "dsctr_dropdown_lookup", "dsctr_group_control_id", "project.x.y", None)])
    req = _Req("Remove the foreign key on column dsctr_group_control_id in project.dsctr_dropdown_lookup because dup.",
               scope_targets=["project.dsctr_dropdown_lookup"])
    v = obj._verify_structural_target(req, _prods([("project", "dsctr_dropdown_lookup")]), attrs)
    assert v and v["status"] == "failed", v


# ---------------- NO-TAUTOLOGY: pre-patch backup must NOT verify rename ----------------

@pytest.mark.skipif(not os.path.exists(NB_PRE), reason="pre-v333 backup absent")
def test_pre_patch_does_not_verify_rename():
    obj = _bind(NB_PRE)
    attrs = _attrs([("hr", "employee", "home_organization_id", "", None)])
    req = _Req("Rename column organization_id to home_organization_id on hr.employee.",
               scope_targets=["hr.employee"])
    v = obj._verify_structural_target(req, _prods([("hr", "employee")]), attrs)
    # pre-patch: no rename branch -> returns None (falls through to coarse diff)
    assert v is None, f"expected pre-patch to NOT verify rename, got {v}"


# ---------------- version + aliases ----------------

def test_version_is_333():
    full = _full_src(NB)
    m = re.search(r'__AGENT_VERSION__\s*=\s*"(\d+)\.(\d+)\.(\d+)"', full)
    assert m, "version constant missing"
    assert tuple(int(g) for g in m.groups()) >= (3, 3, 3), m.group(0)


def test_aliases_present():
    full = _full_src(NB)
    assert "verifier-rename-structural FIRED v3.3.3" in full
    assert "verifier-tag-structural FIRED v3.3.3" in full
    assert "prod_tags" in full
