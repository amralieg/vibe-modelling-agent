"""Tests that exercise REALISTIC LLM-generated code shapes through the sandbox.

These mimic what a real Claude/Opus would emit for typical NCDOT-style mutations.
Each test pairs a hand-written-but-LLM-shape mutator with the matching verifier
and proves the sandbox executes them and produces the expected end state.
"""
import copy

from vov_2_0.sandbox import execute_in_sandbox
from vov_2_0.invariants import (
    capture_invariants,
    diff_models_summary,
    diff_within_summary_scope,
    verify_invariants,
)


def _ncdot_initial():
    return {
        "agent_version": "2.0.0",
        "model": {
            "domains": [
                {"name": "hr", "products": [
                    {"name": "employee", "tags": "", "subdomain": "Employee Records",
                     "primary_key": "employee_id", "attributes": [
                         {"name": "employee_id", "type": "BIGINT", "tags": "", "foreign_key_to": "", "business_glossary_term": ""},
                         {"name": "first_name", "type": "STRING", "tags": "", "foreign_key_to": "", "business_glossary_term": ""},
                         {"name": "position_id", "type": "BIGINT", "tags": "", "foreign_key_to": "", "business_glossary_term": ""},
                         {"name": "job_id", "type": "BIGINT", "tags": "", "foreign_key_to": "", "business_glossary_term": ""},
                     ]},
                    {"name": "position", "tags": "", "subdomain": "",
                     "primary_key": "position_id", "attributes": [
                         {"name": "position_id", "type": "BIGINT", "tags": "", "foreign_key_to": "", "business_glossary_term": ""},
                         {"name": "title", "type": "STRING", "tags": "", "foreign_key_to": "", "business_glossary_term": ""},
                     ]},
                    {"name": "job", "tags": "", "subdomain": "",
                     "primary_key": "job_id", "attributes": [
                         {"name": "job_id", "type": "BIGINT", "tags": "", "foreign_key_to": "", "business_glossary_term": ""},
                         {"name": "code", "type": "STRING", "tags": "", "foreign_key_to": "", "business_glossary_term": ""},
                     ]},
                ]},
                {"name": "project", "products": [
                    {"name": "project", "tags": "", "subdomain": "",
                     "primary_key": "project_id", "attributes": [
                         {"name": "project_id", "type": "BIGINT", "tags": "", "foreign_key_to": "", "business_glossary_term": ""},
                         {"name": "name", "type": "STRING", "tags": "", "foreign_key_to": "", "business_glossary_term": ""},
                     ]},
                ]},
            ],
            "metric_views": [],
        },
    }


def test_realistic_ddl_table_and_attribute_tagging():
    mutator = """def mutator(model, data):
    if not data:
        return model
    spec = data[0]
    target_product = spec.get('product_name')
    source_table = spec.get('source_table')
    cols = spec.get('columns', [])
    col_map = {}
    for c in cols:
        pa = c.get('product_attribute')
        sa = c.get('source_attribute')
        if pa and sa:
            col_map[pa] = sa
    for d in model.get('model', {}).get('domains', []):
        if d.get('name') != 'hr':
            continue
        for p in d.get('products', []):
            if p.get('name') != target_product:
                continue
            tags = p.get('tags', '') or ''
            wanted = 'ncdot_source_table=' + source_table
            tag_list = [t.strip() for t in tags.split(',') if t.strip()]
            if wanted not in tag_list:
                tag_list.append(wanted)
                p['tags'] = ','.join(tag_list)
            for a in p.get('attributes', []):
                an = a.get('name')
                src = col_map.get(an)
                if not src:
                    continue
                at = a.get('tags', '') or ''
                tag_list_a = [t.strip() for t in at.split(',') if t.strip()]
                wanted_a = 'ncdot_source_attribute=' + src
                if wanted_a not in tag_list_a:
                    tag_list_a.append(wanted_a)
                    a['tags'] = ','.join(tag_list_a)
    return model
"""
    verifier = """def verifier(model, data):
    if not data:
        return (True, '')
    spec = data[0]
    target_product = spec.get('product_name')
    source_table = spec.get('source_table')
    cols = spec.get('columns', [])
    expected_attrs = {}
    for c in cols:
        pa = c.get('product_attribute')
        sa = c.get('source_attribute')
        if pa and sa:
            expected_attrs[pa] = sa
    found_product = False
    for d in model.get('model', {}).get('domains', []):
        if d.get('name') != 'hr':
            continue
        for p in d.get('products', []):
            if p.get('name') != target_product:
                continue
            found_product = True
            if 'ncdot_source_table=' + source_table not in (p.get('tags', '') or ''):
                return (False, 'missing source_table tag on ' + target_product)
            for a in p.get('attributes', []):
                an = a.get('name', '')
                src = expected_attrs.get(an)
                if not src:
                    continue
                if 'ncdot_source_attribute=' + src not in (a.get('tags', '') or ''):
                    return (False, 'missing source_attribute tag on ' + target_product + '.' + an)
    if not found_product:
        return (False, 'product not found: ' + target_product)
    return (True, '')
"""

    model = _ncdot_initial()
    data = [{
        "product_name": "employee",
        "source_table": "emp_history",
        "columns": [
            {"product_attribute": "employee_id", "source_attribute": "Employee_ID"},
            {"product_attribute": "first_name", "source_attribute": "First_Name"},
            {"product_attribute": "position_id", "source_attribute": "Position_Number"},
            {"product_attribute": "job_id", "source_attribute": "Job_Code"},
        ],
    }]

    result = execute_in_sandbox(mutator, verifier, model, data=data)
    assert result.ok, result.error
    assert result.verifier_ok, result.verifier_diag

    employee = result.new_model["model"]["domains"][0]["products"][0]
    assert "ncdot_source_table=emp_history" in employee["tags"]
    emp_id = next(a for a in employee["attributes"] if a["name"] == "employee_id")
    assert "ncdot_source_attribute=Employee_ID" in emp_id["tags"]
    pos_id = next(a for a in employee["attributes"] if a["name"] == "position_id")
    assert "ncdot_source_attribute=Position_Number" in pos_id["tags"]


def test_realistic_fk_addition_passes_invariants():
    mutator = """def mutator(model, data):
    fk_specs = data or []
    for spec in fk_specs:
        src_dom = spec.get('source_domain')
        src_prod = spec.get('source_product')
        src_attr = spec.get('source_attribute')
        target = spec.get('foreign_key_to')
        if not (src_dom and src_prod and src_attr and target):
            continue
        for d in model.get('model', {}).get('domains', []):
            if d.get('name') != src_dom:
                continue
            for p in d.get('products', []):
                if p.get('name') != src_prod:
                    continue
                for a in p.get('attributes', []):
                    if a.get('name') == src_attr and not a.get('foreign_key_to'):
                        a['foreign_key_to'] = target
    return model
"""
    verifier = """def verifier(model, data):
    fk_specs = data or []
    for spec in fk_specs:
        src_dom = spec.get('source_domain')
        src_prod = spec.get('source_product')
        src_attr = spec.get('source_attribute')
        target = spec.get('foreign_key_to')
        ok = False
        for d in model.get('model', {}).get('domains', []):
            if d.get('name') != src_dom:
                continue
            for p in d.get('products', []):
                if p.get('name') != src_prod:
                    continue
                for a in p.get('attributes', []):
                    if a.get('name') == src_attr and a.get('foreign_key_to') == target:
                        ok = True
        if not ok:
            return (False, 'FK missing on ' + src_dom + '.' + src_prod + '.' + src_attr + ' -> ' + target)
    return (True, '')
"""

    model = _ncdot_initial()
    snap = capture_invariants(model, ["hr", "project"], [("hr", "employee"), ("project", "project")])
    data = [
        {"source_domain": "hr", "source_product": "employee", "source_attribute": "position_id", "foreign_key_to": "hr.position.position_id"},
        {"source_domain": "hr", "source_product": "employee", "source_attribute": "job_id", "foreign_key_to": "hr.job.job_id"},
    ]
    result = execute_in_sandbox(mutator, verifier, copy.deepcopy(model), data=data)
    assert result.ok and result.verifier_ok

    ok, _ = verify_invariants(result.new_model, snap)
    assert ok

    diff = diff_models_summary(model, result.new_model)
    assert diff["fks_added"] == 2
    ok_scope, _ = diff_within_summary_scope(diff, "Add FK from employee to position and job")
    assert ok_scope


def test_realistic_metric_view_addition():
    mutator = """def mutator(model, data):
    mvs = data or []
    mv_list = model.get('model', {}).setdefault('metric_views', [])
    existing = {m.get('view_name', '') for m in mv_list}
    for m in mvs:
        name = m.get('view_name')
        if name and name not in existing:
            mv_list.append({
                'view_name': name,
                'owner_domain': m.get('owner_domain', ''),
                'owner_product': m.get('owner_product', ''),
                'sql': m.get('sql', ''),
                'description': m.get('description', ''),
            })
            existing.add(name)
    return model
"""
    verifier = """def verifier(model, data):
    mvs = data or []
    existing = {m.get('view_name', '') for m in model.get('model', {}).get('metric_views', [])}
    for m in mvs:
        if m.get('view_name') not in existing:
            return (False, 'metric view missing: ' + m.get('view_name', ''))
    return (True, '')
"""

    model = _ncdot_initial()
    data = [
        {"view_name": "vacancy_rate", "owner_domain": "hr", "owner_product": "position", "sql": "SELECT 1", "description": "vacancy"},
        {"view_name": "headcount", "owner_domain": "hr", "owner_product": "employee", "sql": "SELECT 1", "description": "hc"},
    ]
    result = execute_in_sandbox(mutator, verifier, copy.deepcopy(model), data=data)
    assert result.ok and result.verifier_ok
    mvs = result.new_model["model"]["metric_views"]
    names = {m["view_name"] for m in mvs}
    assert names == {"vacancy_rate", "headcount"}

    result2 = execute_in_sandbox(mutator, verifier, copy.deepcopy(result.new_model), data=data)
    assert result2.ok and result2.verifier_ok
    assert len(result2.new_model["model"]["metric_views"]) == 2


def test_realistic_subdomain_assignment():
    mutator = """def mutator(model, data):
    rules = data or []
    for r in rules:
        dom = r.get('domain')
        prod = r.get('product')
        sub = r.get('subdomain', '')
        for d in model.get('model', {}).get('domains', []):
            if d.get('name') != dom:
                continue
            for p in d.get('products', []):
                if p.get('name') == prod:
                    p['subdomain'] = sub
    return model
"""
    verifier = """def verifier(model, data):
    rules = data or []
    for r in rules:
        for d in model.get('model', {}).get('domains', []):
            if d.get('name') != r.get('domain'):
                continue
            for p in d.get('products', []):
                if p.get('name') == r.get('product'):
                    if p.get('subdomain', '') != r.get('subdomain', ''):
                        return (False, 'subdomain mismatch on ' + r.get('domain', '') + '.' + r.get('product', ''))
    return (True, '')
"""

    model = _ncdot_initial()
    data = [
        {"domain": "hr", "product": "employee", "subdomain": "Employee Records"},
        {"domain": "hr", "product": "position", "subdomain": "Compensation & Benefits"},
        {"domain": "hr", "product": "job", "subdomain": "Compensation & Benefits"},
    ]
    result = execute_in_sandbox(mutator, verifier, copy.deepcopy(model), data=data)
    assert result.ok and result.verifier_ok
    hr = result.new_model["model"]["domains"][0]
    subs = {p["name"]: p["subdomain"] for p in hr["products"]}
    assert subs["employee"] == "Employee Records"
    assert subs["position"] == "Compensation & Benefits"
    assert subs["job"] == "Compensation & Benefits"


def test_realistic_business_glossary_term_assignment_72_rows():
    mutator = """def mutator(model, data):
    rules = data or []
    rule_map = {}
    for r in rules:
        bg = r.get('business_data_element', '')
        for ref in r.get('attribute_refs', []):
            d = ref.get('domain')
            p = ref.get('product')
            a = ref.get('attribute')
            if d and p and a and bg:
                rule_map[(d, p, a)] = bg
    for d in model.get('model', {}).get('domains', []):
        for p in d.get('products', []):
            for a in p.get('attributes', []):
                key = (d.get('name'), p.get('name'), a.get('name'))
                if key in rule_map:
                    a['business_glossary_term'] = rule_map[key]
                    tags = a.get('tags', '') or ''
                    tag_list = [t.strip() for t in tags.split(',') if t.strip()]
                    wanted = 'ncdot_business_glossary_term=' + rule_map[key]
                    if wanted not in tag_list:
                        tag_list.append(wanted)
                        a['tags'] = ','.join(tag_list)
    return model
"""
    verifier = """def verifier(model, data):
    rules = data or []
    expected = {}
    for r in rules:
        bg = r.get('business_data_element', '')
        for ref in r.get('attribute_refs', []):
            expected[(ref.get('domain'), ref.get('product'), ref.get('attribute'))] = bg
    for d in model.get('model', {}).get('domains', []):
        for p in d.get('products', []):
            for a in p.get('attributes', []):
                k = (d.get('name'), p.get('name'), a.get('name'))
                if k in expected:
                    if a.get('business_glossary_term', '') != expected[k]:
                        return (False, 'wrong glossary on ' + str(k))
                    if 'ncdot_business_glossary_term=' + expected[k] not in (a.get('tags', '') or ''):
                        return (False, 'missing glossary tag on ' + str(k))
    return (True, '')
"""

    model = _ncdot_initial()
    data = [
        {"business_data_element": "Employee", "attribute_refs": [
            {"domain": "hr", "product": "employee", "attribute": "employee_id"},
            {"domain": "hr", "product": "employee", "attribute": "first_name"},
        ]},
        {"business_data_element": "Position", "attribute_refs": [
            {"domain": "hr", "product": "position", "attribute": "position_id"},
            {"domain": "hr", "product": "position", "attribute": "title"},
            {"domain": "hr", "product": "employee", "attribute": "position_id"},
        ]},
        {"business_data_element": "Job", "attribute_refs": [
            {"domain": "hr", "product": "job", "attribute": "job_id"},
            {"domain": "hr", "product": "job", "attribute": "code"},
            {"domain": "hr", "product": "employee", "attribute": "job_id"},
        ]},
    ]
    result = execute_in_sandbox(mutator, verifier, copy.deepcopy(model), data=data)
    assert result.ok, result.error
    assert result.verifier_ok, result.verifier_diag

    employee_attrs = result.new_model["model"]["domains"][0]["products"][0]["attributes"]
    by_name = {a["name"]: a for a in employee_attrs}
    assert by_name["employee_id"]["business_glossary_term"] == "Employee"
    assert "ncdot_business_glossary_term=Employee" in by_name["employee_id"]["tags"]
    assert by_name["position_id"]["business_glossary_term"] == "Position"
    assert by_name["job_id"]["business_glossary_term"] == "Job"


def test_realistic_multiple_mutations_compose_correctly():
    """Apply DDL tagging, then FK addition, then subdomain — model survives all three."""
    ddl_mutator = """def mutator(model, data):
    spec = (data or [{}])[0]
    for d in model.get('model', {}).get('domains', []):
        if d.get('name') != 'hr':
            continue
        for p in d.get('products', []):
            if p.get('name') != spec.get('product_name'):
                continue
            tags = (p.get('tags', '') or '').split(',')
            tags = [t for t in tags if t.strip()]
            wanted = 'ncdot_source_table=' + spec.get('source_table', '')
            if wanted not in tags:
                tags.append(wanted)
                p['tags'] = ','.join(tags)
    return model
"""
    ddl_verifier = """def verifier(model, data):
    spec = (data or [{}])[0]
    for d in model.get('model', {}).get('domains', []):
        if d.get('name') != 'hr':
            continue
        for p in d.get('products', []):
            if p.get('name') == spec.get('product_name'):
                if 'ncdot_source_table=' + spec.get('source_table', '') in (p.get('tags', '') or ''):
                    return (True, '')
    return (False, 'tag missing')
"""
    fk_mutator = """def mutator(model, data):
    for spec in (data or []):
        for d in model.get('model', {}).get('domains', []):
            if d.get('name') != spec.get('source_domain'):
                continue
            for p in d.get('products', []):
                if p.get('name') != spec.get('source_product'):
                    continue
                for a in p.get('attributes', []):
                    if a.get('name') == spec.get('source_attribute') and not a.get('foreign_key_to'):
                        a['foreign_key_to'] = spec.get('foreign_key_to', '')
    return model
"""
    fk_verifier = """def verifier(model, data):
    for spec in (data or []):
        ok = False
        for d in model.get('model', {}).get('domains', []):
            if d.get('name') != spec.get('source_domain'):
                continue
            for p in d.get('products', []):
                if p.get('name') != spec.get('source_product'):
                    continue
                for a in p.get('attributes', []):
                    if a.get('name') == spec.get('source_attribute') and a.get('foreign_key_to') == spec.get('foreign_key_to'):
                        ok = True
        if not ok:
            return (False, 'fk missing')
    return (True, '')
"""

    model = _ncdot_initial()

    r1 = execute_in_sandbox(ddl_mutator, ddl_verifier, copy.deepcopy(model),
                             data=[{"product_name": "employee", "source_table": "emp_history"}])
    assert r1.ok and r1.verifier_ok

    r2 = execute_in_sandbox(fk_mutator, fk_verifier, r1.new_model,
                             data=[{"source_domain": "hr", "source_product": "employee", "source_attribute": "position_id", "foreign_key_to": "hr.position.position_id"}])
    assert r2.ok and r2.verifier_ok

    employee = r2.new_model["model"]["domains"][0]["products"][0]
    assert "ncdot_source_table=emp_history" in employee["tags"]
    pos_id_attr = next(a for a in employee["attributes"] if a["name"] == "position_id")
    assert pos_id_attr["foreign_key_to"] == "hr.position.position_id"


def test_realistic_count_enforcement_verifier_catches_violation():
    """Verifier should reject a model that doesn't meet 'exactly 2 domains' constraint."""
    mutator = "def mutator(model, data):\n    return model\n"
    verifier = """def verifier(model, data):
    domains = model.get('model', {}).get('domains', [])
    if len(domains) != 2:
        return (False, 'expected 2 domains, got ' + str(len(domains)))
    names = sorted(d.get('name', '') for d in domains)
    if names != ['hr', 'project']:
        return (False, 'expected [hr, project], got ' + json.dumps(names))
    return (True, '')
"""

    good_model = _ncdot_initial()
    r = execute_in_sandbox(mutator, verifier, good_model)
    assert r.ok and r.verifier_ok

    bad_model = copy.deepcopy(good_model)
    bad_model["model"]["domains"].append({"name": "phantom", "products": []})
    r2 = execute_in_sandbox(mutator, verifier, bad_model)
    assert r2.ok
    assert not r2.verifier_ok
    assert "expected 2 domains" in r2.verifier_diag


def test_realistic_safe_against_data_injection():
    """LLM-generated mutator should treat data as data, not as code."""
    mutator = """def mutator(model, data):
    for spec in (data or []):
        target = spec.get('target', '')
        for d in model.get('model', {}).get('domains', []):
            for p in d.get('products', []):
                if (d.get('name') + '.' + p.get('name')) == target:
                    p['marked'] = True
    return model
"""
    verifier = """def verifier(model, data):
    return (True, '')
"""
    model = _ncdot_initial()
    data = [
        {"target": "hr.employee"},
        {"target": "'; DROP TABLE users; --"},
        {"target": "__import__('os').system('rm -rf /')"},
        {"target": "../../etc/passwd"},
    ]
    result = execute_in_sandbox(mutator, verifier, copy.deepcopy(model), data=data)
    assert result.ok
    employee = result.new_model["model"]["domains"][0]["products"][0]
    assert employee.get("marked") is True
    position = result.new_model["model"]["domains"][0]["products"][1]
    assert position.get("marked") is None
