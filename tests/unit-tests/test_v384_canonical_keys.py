"""
v3.8.4 behavioral test for the canonical-key root-cause fix (alias=canonical-key-apply).

ROOT CAUSE (NCDOT VREQ PK-convention): the vibe declared canonical keys
('`position_number` is the canonical position key') but the agent's surrogate-key heuristic
set product primary_key='position_id', overriding the explicit user directive (CLAUDE.md 3c
violation: heuristic beat vibe). 3/4 NCDOT canonical keys were already correct; position was not.

FIX: _v384_apply_canonical_keys parses vibe-declared canonical keys and honors them as the
product primary_key, AND re-points any FK that referenced the old PK column so FK integrity is
preserved (no 'FK points to non-PK' defect). Generic/industry-agnostic.
"""
import json
import os
import textwrap

REPO = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
NB = os.path.join(REPO, "agent", "dbx_vibe_modelling_agent.ipynb")


def _load_funcs():
    nb = json.load(open(NB))
    src = "\n".join("".join(c.get("source", [])) for c in nb["cells"] if c["cell_type"] == "code")

    def _extract(name):
        # Bound ONLY on the next TOP-LEVEL def (column 0). The function body may contain
        # nested 4-space defs (e.g. def _norm), so a 4-space boundary would truncate it.
        i = src.find("\ndef " + name + "(")
        assert i != -1, name + " missing"
        ls = i + 1
        k = src.find("\ndef ", ls + 1)
        end = k if k != -1 else len(src)
        return textwrap.dedent(src[ls:end])

    ns = {}
    exec(compile(_extract("_v384_parse_canonical_keys"), "<p>", "exec"), ns)
    exec(compile(_extract("_v384_apply_canonical_keys"), "<a>", "exec"), ns)
    return ns["_v384_parse_canonical_keys"], ns["_v384_apply_canonical_keys"]


class _Logger:
    def __init__(self):
        self.msgs = []

    def info(self, m):
        self.msgs.append(m)

    def warning(self, m):
        self.msgs.append(m)


def test_parse_canonical_keys_from_ncdot_phrasing():
    parse, _ = _load_funcs()
    vibe = (
        "- `employee_id` is the canonical employee key\n"
        "- `position_number` is the canonical position key\n"
        "- `job_family_id` is the canonical job-family key\n"
        "- the canonical key for asset is asset_tag\n"
    )
    pairs = dict(parse(vibe))
    assert pairs.get("employee") == "employee_id"
    assert pairs.get("position") == "position_number"
    assert pairs.get("job-family") == "job_family_id"
    assert pairs.get("asset") == "asset_tag"


def test_apply_honors_canonical_and_repoints_fk():
    """fail-pre/pass-post: position PK swaps to canonical AND the FK is re-pointed."""
    parse, apply = _load_funcs()
    products_data = [
        {"domain": "hr", "product": "position", "primary_key": "position_id"},
        {"domain": "hr", "product": "employee", "primary_key": "employee_id"},
    ]
    attributes_data = [
        {"domain": "hr", "product": "position", "attribute": "position_id"},
        {"domain": "hr", "product": "position", "attribute": "position_number"},
        {"domain": "hr", "product": "employee", "attribute": "employee_id"},
        {"domain": "hr", "product": "employee_assignment", "attribute": "position_ref",
         "foreign_key_to": "hr.position.position_id"},
    ]
    vibe = "`position_number` is the canonical position key. `employee_id` is the canonical employee key."

    # PRE-state (the v383 defect): position PK is the surrogate; FK points at surrogate
    assert products_data[0]["primary_key"] == "position_id"
    assert attributes_data[3]["foreign_key_to"] == "hr.position.position_id"

    n = apply(products_data, attributes_data, vibe, {}, _Logger())

    # POST-state: canonical honored, employee untouched (already canonical), FK re-pointed
    assert n == 1, n
    assert products_data[0]["primary_key"] == "position_number"
    assert products_data[1]["primary_key"] == "employee_id"  # no-op, already canonical
    assert attributes_data[3]["foreign_key_to"] == "hr.position.position_number"  # integrity preserved


def test_no_fabrication_when_column_absent():
    """If the declared canonical column does not exist on the product, do NOT change PK."""
    _, apply = _load_funcs()
    products_data = [{"domain": "hr", "product": "position", "primary_key": "position_id"}]
    attributes_data = [{"domain": "hr", "product": "position", "attribute": "position_id"}]
    vibe = "`position_number` is the canonical position key"
    n = apply(products_data, attributes_data, vibe, {}, _Logger())
    assert n == 0
    assert products_data[0]["primary_key"] == "position_id"


def test_noop_when_no_canonical_directive():
    _, apply = _load_funcs()
    products_data = [{"domain": "hr", "product": "position", "primary_key": "position_id"}]
    attributes_data = [{"domain": "hr", "product": "position", "attribute": "position_id"}]
    n = apply(products_data, attributes_data, "a plain vibe with no key directives", {}, _Logger())
    assert n == 0
