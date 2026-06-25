import json, re, os, textwrap, pytest

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")
NB_PRE = "/tmp/agent_pre_v411.ipynb"


def _full_src(path):
    nb = json.load(open(path))
    return "".join(
        "".join(c.get("source", [])) if isinstance(c.get("source"), list) else c.get("source", "")
        for c in nb["cells"]
        if c.get("cell_type") == "code"
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
    def __init__(self, text, rid="VREQ-T"):
        self.original_text = text
        self.id = rid


def _attrs(spec):
    """spec: list of (domain, product, n_data, n_pk, n_fk)."""
    out = []
    for d, p, nd, npk, nfk in spec:
        for i in range(nd):
            out.append({"domain": d, "product": p, "name": f"data_{i}"})
        for i in range(npk):
            out.append({"domain": d, "product": p, "name": f"pk_{i}", "is_primary_key": True})
        for i in range(nfk):
            out.append({"domain": d, "product": p, "name": f"fk_{i}",
                        "foreign_key_to": "other.x.id"})
    return out


def _bind(path):
    src = _full_src(path)
    ns = {"re": re}
    exec(_extract_fn(src, "_verify_stub_thin_enrichment"), ns)

    class Dummy:
        logger = _Logger()
    Dummy._verify_stub_thin_enrichment = ns["_verify_stub_thin_enrichment"]
    return Dummy()


# --- fail-pre proof: the helper does not exist in the pre-patch notebook ---
def test_pre_patch_helper_absent():
    src = _full_src(NB_PRE)
    assert "_verify_stub_thin_enrichment" not in src


# --- post-patch: zero violators -> fulfilled (range threshold "4-8 data attributes") ---
def test_thin_range_all_satisfied_fulfilled():
    d = _bind(NB)
    req = _Req("Expand the thin products that currently have only 4-8 data attributes "
               "into full data products.")
    attrs = _attrs([("ops", "a", 12, 1, 3), ("ops", "b", 9, 1, 2), ("sales", "c", 20, 1, 0)])
    r = d._verify_stub_thin_enrichment(req, attrs)
    assert r is not None and r["status"] == "fulfilled"


# --- post-patch: one violator -> abstain (None), never partial/failed ---
def test_thin_range_one_violator_abstains():
    d = _bind(NB)
    req = _Req("Expand the thin products that currently have only 4-8 data attributes.")
    # product b has 5 data attrs < parsed threshold 9 -> violator
    attrs = _attrs([("ops", "a", 12, 1, 3), ("ops", "b", 5, 1, 2)])
    assert d._verify_stub_thin_enrichment(req, attrs) is None


# --- PK/FK are excluded from the data-attribute count ---
def test_pk_fk_excluded_from_count():
    d = _bind(NB)
    req = _Req("Fix the stub products that have only a handful of attributes.")  # stub -> thr 5
    # product has 8 TOTAL attrs but only 2 data attrs (rest PK+FK) -> violator under data count
    attrs = _attrs([("ops", "a", 2, 1, 5)])
    assert d._verify_stub_thin_enrichment(req, attrs) is None
    # same product with 6 data attrs -> satisfied
    attrs2 = _attrs([("ops", "a", 6, 1, 5)])
    r = d._verify_stub_thin_enrichment(req, attrs2)
    assert r is not None and r["status"] == "fulfilled"


# --- stub / PK+FK phrasing default threshold ---
def test_stub_pk_fk_skeleton_threshold():
    d = _bind(NB)
    req = _Req("Populate full attribute sets for the skeleton products that have only PK+FK.")
    # skeleton/only pk -> thr 3; products with >=3 data attrs satisfy
    attrs = _attrs([("ops", "a", 3, 1, 1), ("ops", "b", 7, 1, 2)])
    r = d._verify_stub_thin_enrichment(req, attrs)
    assert r is not None and r["status"] == "fulfilled"


# --- structural-verb HARD guard: rename/move/drop -> None even with 'thin' keyword ---
@pytest.mark.parametrize("verb", ["rename", "relocate", "move the", "drop the", "remove the"])
def test_structural_verb_guard_abstains(verb):
    d = _bind(NB)
    req = _Req(f"{verb} thin attribute on the order product.")
    attrs = _attrs([("ops", "a", 1, 1, 0)])  # would be a violator if not guarded
    assert d._verify_stub_thin_enrichment(req, attrs) is None


# --- no enrichment intent + no threshold -> abstain ---
def test_no_intent_abstains():
    d = _bind(NB)
    req = _Req("Create the inventory domain with products stock_position and stock_ledger.")
    attrs = _attrs([("inventory", "stock_position", 2, 1, 0)])
    assert d._verify_stub_thin_enrichment(req, attrs) is None


# --- 'total attribute' phrasing counts PK+FK toward the threshold ---
def test_total_attribute_includes_pk_fk():
    d = _bind(NB)
    req = _Req("Expand the thin products with fewer than 6 total attributes.")
    # product has 3 data + 1 pk + 3 fk = 7 total >= 6 -> satisfied
    attrs = _attrs([("ops", "a", 3, 1, 3)])
    r = d._verify_stub_thin_enrichment(req, attrs)
    assert r is not None and r["status"] == "fulfilled"


# --- empty attribute universe -> abstain (cannot prove) ---
def test_empty_universe_abstains():
    d = _bind(NB)
    # carries an attribute anchor so it passes the anchor gate and reaches the
    # empty-universe guard specifically
    req = _Req("Fix the stub products that have only PK + FK columns.")
    assert d._verify_stub_thin_enrichment(req, []) is None


# --- missing attribute-noun anchor -> abstain (domain product-count / description VReqs) ---
@pytest.mark.parametrize("text", [
    "Expand the stub domains that have fewer than 5 products with real entities.",
    "Expand the shared stub domain (currently 1 product) with real entities so it has 5 products.",
    "Expand operational commentary in table descriptions to reflect the real stack.",
    "Create the workforce domain; in v1 it is a stub domain with only 1 product, expand it.",
])
def test_no_attribute_anchor_abstains(text):
    d = _bind(NB)
    req = _Req(text)
    # a 1-data-attr product would be a violator if the verifier wrongly fired
    attrs = _attrs([("ops", "a", 1, 1, 1)])
    assert d._verify_stub_thin_enrichment(req, attrs) is None


# --- description directive WITHOUT enrichment markers -> abstain; WITH markers -> evaluated ---
def test_description_directive_guard():
    d = _bind(NB)
    # incidental 'description' mention but real attribute enrichment -> evaluated (fulfilled)
    req_real = _Req("Fix the stub product order_line which has only PK + FK columns despite a "
                    "description promising rich content; add real data attributes.")
    attrs = _attrs([("ops", "order_line", 8, 1, 2)])
    r = d._verify_stub_thin_enrichment(req_real, attrs)
    assert r is not None and r["status"] == "fulfilled"


# --- call site wired into _verify_deterministic AFTER the domain-create block ---
def test_call_site_wired_after_domain_create():
    src = _full_src(NB)
    assert src.count("self._verify_stub_thin_enrichment(") == 1
    dcc = src.find("return _v411_dcc")
    stub = src.find("_v411_stub = self._verify_stub_thin_enrichment(")
    desc = src.find("_v395_desc = self._v395_verify_description_cov")
    assert dcc != -1 and stub != -1 and desc != -1
    assert dcc < stub < desc


# --- alias sentinel present for audit grep ---
def test_alias_sentinel_present():
    src = _full_src(NB)
    assert "verifier-stub-thin-enrichment" in src
    assert "verifier-stub-thin-enrichment FIRED v4.1.1" in src
