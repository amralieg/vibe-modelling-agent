import copy
import json
from typing import Any

from vov_2_0.llm import CannedResponse, MockLLM
from vov_2_0.pipeline import run_vov_pipeline
from tests.vov_2_0.fixtures.simulated_vibes import (
    ADVERSARIAL_VIBE,
    HEALTHCARE_VIBE,
    NCDOT_MINIMAL,
    PROSE_ONLY_VIBE,
)


def _initial_ncdot_model():
    return {
        "agent_version": "2.0.0",
        "model": {
            "domains": [
                {"name": "hr", "products": [
                    {"name": "employee", "tags": "", "subdomain": "", "primary_key": "employee_id",
                     "attributes": [
                         {"name": "employee_id", "type": "BIGINT", "tags": "", "foreign_key_to": ""},
                         {"name": "first_name", "type": "STRING", "tags": "", "foreign_key_to": ""},
                         {"name": "last_name", "type": "STRING", "tags": "", "foreign_key_to": ""},
                     ]},
                    {"name": "position", "tags": "", "subdomain": "", "primary_key": "position_id",
                     "attributes": [
                         {"name": "position_id", "type": "BIGINT", "tags": "", "foreign_key_to": ""},
                     ]},
                    {"name": "job", "tags": "", "subdomain": "", "primary_key": "job_id",
                     "attributes": [
                         {"name": "job_id", "type": "BIGINT", "tags": "", "foreign_key_to": ""},
                     ]},
                ]},
                {"name": "project", "products": [
                    {"name": "project", "tags": "", "subdomain": "", "primary_key": "project_id",
                     "attributes": [{"name": "project_id", "type": "BIGINT", "tags": "", "foreign_key_to": ""}]},
                    {"name": "material", "tags": "", "subdomain": "", "primary_key": "material_id",
                     "attributes": [{"name": "material_id", "type": "BIGINT", "tags": "", "foreign_key_to": ""}]},
                    {"name": "schedule", "tags": "", "subdomain": "", "primary_key": "schedule_id",
                     "attributes": [{"name": "schedule_id", "type": "BIGINT", "tags": "", "foreign_key_to": ""}]},
                ]},
            ],
            "metric_views": [],
        },
    }


def _ncdot_outline_response():
    return {
        "sections": [
            {"section_id": "S1", "title": "NCDOT — base model", "summary": "intro", "declared_entities": ["NCDOT"], "cross_references": [], "constraints": []},
            {"section_id": "S2", "title": "Tag prefix", "summary": "ncdot_ tag prefix", "declared_entities": [], "cross_references": [], "constraints": ["ncdot_ tag prefix"]},
            {"section_id": "S3", "title": "Domains and products (BUILD EXACTLY THESE 2 DOMAINS — NOTHING ELSE)", "summary": "domain list", "declared_entities": ["hr", "project"], "cross_references": [], "constraints": ["EXACTLY 2 DOMAINS"]},
            {"section_id": "S4", "title": "HR base-model: strictly follow this DDL from `hr_devtest.hr_silver`", "summary": "ddl tagging", "declared_entities": ["emp_history"], "cross_references": [], "constraints": ["MUST add ncdot_source_table tag", "MUST add ncdot_source_attribute tag"]},
            {"section_id": "S5", "title": "Final ground rules", "summary": "ground rules", "declared_entities": [], "cross_references": [], "constraints": ["snake_case", "_id PK suffix", "BIGINT id type", "ncdot_ tag prefix"]},
        ],
        "global_constraints": ["snake_case", "ncdot_ tag prefix", "_id PK suffix", "BIGINT id type"],
        "declared_entities_global": ["hr", "project", "employee", "position", "job", "emp_history"],
    }


def _ncdot_extraction_response():
    return {"vreqs": [
        {"vreq_id": "V1", "intent": "Use ncdot_ as the tag prefix for all NCDOT-specific tags", "target": "tag-keys", "source_quote": "All NCDOT-specific tags MUST use prefix `ncdot_`."},
        {"vreq_id": "V2", "intent": "Build exactly 2 domains: hr and project", "target": "domain count", "source_quote": "BUILD EXACTLY THESE 2 DOMAINS"},
        {"vreq_id": "V3", "intent": "Add table-level tag ncdot_source_table=emp_history to HR products derived from emp_history DDL", "target": "hr.* products from DDL", "source_quote": "TABLE-LEVEL tag `ncdot_source_table=<original_table>`"},
        {"vreq_id": "V4", "intent": "Add attribute-level tag ncdot_source_attribute=<column> to HR product attrs derived from DDL", "target": "hr.*.* attributes from DDL", "source_quote": "ATTRIBUTE-LEVEL tag `ncdot_source_attribute=<original_column>`"},
        {"vreq_id": "V5", "intent": "Use snake_case naming throughout the model", "target": "naming convention", "source_quote": "Naming convention: `snake_case`."},
    ]}


def _ncdot_batch_response():
    return {"batches": [
        {
            "batch_id": "B0001",
            "vreq_ids": ["VREQ-0001", "VREQ-0002"],
            "intent_summary": "Apply ncdot_ tag-prefix and 2-domain count constraints",
            "target_entities": [["hr", "*"], ["project", "*"]],
            "data_payload": [],
        },
        {
            "batch_id": "B0002",
            "vreq_ids": ["VREQ-0003", "VREQ-0004"],
            "intent_summary": "Apply ncdot_source_table and ncdot_source_attribute tag rules to HR products derived from emp_history DDL",
            "target_entities": [["hr", "employee"]],
            "data_payload": [
                {"product_name": "employee", "source_table": "emp_history",
                 "columns": [
                     {"product_attribute": "employee_id", "source_attribute": "Employee_ID"},
                     {"product_attribute": "first_name", "source_attribute": "First_Name"},
                     {"product_attribute": "last_name", "source_attribute": "Last_Name"},
                 ]},
            ],
        },
        {
            "batch_id": "B0003",
            "vreq_ids": ["VREQ-0005"],
            "intent_summary": "Enforce snake_case naming convention",
            "target_entities": [["*", "*"]],
            "data_payload": [],
        },
    ]}


SAFE_PREFIX_CHECK_MUTATOR = """def mutator(model, data):
    return model
"""

SAFE_PREFIX_CHECK_VERIFIER = """def verifier(model, data):
    mdl = model.get("model", model)
    domains = mdl.get("domains", [])
    if len(domains) != 2:
        return (False, "expected exactly 2 domains, found " + str(len(domains)))
    names = sorted(d.get("name", "") for d in domains)
    if names != ["hr", "project"]:
        return (False, "expected [hr, project], got " + json.dumps(names))
    return (True, "")
"""


SAFE_DDL_TAG_MUTATOR = """def mutator(model, data):
    if not data:
        return model
    spec = data[0]
    target_product = spec.get("product_name", "")
    source_table = spec.get("source_table", "")
    cols = spec.get("columns", []) or []
    col_map = {}
    for c in cols:
        pa = c.get("product_attribute", "")
        sa = c.get("source_attribute", "")
        if pa and sa:
            col_map[pa] = sa
    for d in model.get("model", {}).get("domains", []):
        if d.get("name") != "hr":
            continue
        for p in d.get("products", []):
            if p.get("name") != target_product:
                continue
            tt = p.get("tags", "") or ""
            wanted = "ncdot_source_table=" + source_table
            if wanted not in tt:
                p["tags"] = (tt + "," + wanted) if tt else wanted
            for a in p.get("attributes", []):
                an = a.get("name", "")
                src = col_map.get(an)
                if not src:
                    continue
                at = a.get("tags", "") or ""
                wanted_a = "ncdot_source_attribute=" + src
                if wanted_a not in at:
                    a["tags"] = (at + "," + wanted_a) if at else wanted_a
    return model
"""


SAFE_DDL_TAG_VERIFIER = """def verifier(model, data):
    if not data:
        return (True, "")
    spec = data[0]
    target_product = spec.get("product_name", "")
    source_table = spec.get("source_table", "")
    cols = spec.get("columns", [])
    expected_attrs = {}
    for c in cols:
        pa = c.get("product_attribute", "")
        sa = c.get("source_attribute", "")
        if pa and sa:
            expected_attrs[pa] = sa
    for d in model.get("model", {}).get("domains", []):
        if d.get("name") != "hr":
            continue
        for p in d.get("products", []):
            if p.get("name") != target_product:
                continue
            if "ncdot_source_table=" + source_table not in (p.get("tags", "") or ""):
                return (False, "missing ncdot_source_table on " + target_product)
            for a in p.get("attributes", []):
                an = a.get("name", "")
                src = expected_attrs.get(an)
                if not src:
                    continue
                if "ncdot_source_attribute=" + src not in (a.get("tags", "") or ""):
                    return (False, "missing ncdot_source_attribute on " + target_product + "." + an)
            return (True, "")
    return (False, "product " + target_product + " not found in hr domain")
"""


SAFE_NOOP_MUTATOR = "def mutator(model, data):\n    return model\n"
SAFE_TRUE_VERIFIER = "def verifier(model, data):\n    return (True, '')\n"


def _ncdot_synth_responses():
    return [
        {"mutator_source": SAFE_PREFIX_CHECK_MUTATOR, "verifier_source": SAFE_PREFIX_CHECK_VERIFIER, "expected_changes_summary": "no mutation; verify domain count + names"},
        {"mutator_source": SAFE_DDL_TAG_MUTATOR, "verifier_source": SAFE_DDL_TAG_VERIFIER, "expected_changes_summary": "add ncdot_source_table at table level and ncdot_source_attribute at attribute level for HR products derived from DDL"},
        {"mutator_source": SAFE_NOOP_MUTATOR, "verifier_source": SAFE_TRUE_VERIFIER, "expected_changes_summary": "naming convention check (no mutation needed)"},
    ]


class _SequencedLLM:
    def __init__(self, sequence):
        self.sequence = list(sequence)
        self.idx = 0
        self.call_log = []

    def _next(self):
        if self.idx < len(self.sequence):
            r = self.sequence[self.idx]
            self.idx += 1
            return r
        return self.sequence[-1] if self.sequence else {}

    def complete_json(self, system, user, temperature=0.0):
        self.call_log.append({"system_head": system[:80], "user_head": user[:80]})
        if "STRUCTURED OUTLINE" in system:
            return _ncdot_outline_response()
        if "RawVREQ" in system:
            return _ncdot_extraction_response()
        if "group VREQs into BATCHES" in system:
            return _ncdot_batch_response()
        if "mutator_source" in user:
            return self._next()
        return {}

    def complete_with_tools(self, system, user, tools, tool_handlers, max_iters=6, temperature=0.0):
        return self.complete_json(system, user, temperature)


def test_pipeline_end_to_end_ncdot_applies_ddl_tags_and_passes_invariants():
    initial = _initial_ncdot_model()
    llm = _SequencedLLM(_ncdot_synth_responses())

    result = run_vov_pipeline(
        vibe_text=NCDOT_MINIMAL,
        initial_model=initial,
        llm=llm,
        user_pinned_domains=["hr", "project"],
        user_pinned_products=[("hr", "employee"), ("hr", "position"), ("hr", "job"),
                              ("project", "project"), ("project", "material"), ("project", "schedule")],
        parallel=False,
    )

    final = result.final_model
    domains = final["model"]["domains"]
    domain_names = sorted(d["name"] for d in domains)
    assert domain_names == ["hr", "project"]

    hr_domain = next(d for d in domains if d["name"] == "hr")
    employee = next(p for p in hr_domain["products"] if p["name"] == "employee")
    assert "ncdot_source_table=emp_history" in employee.get("tags", "")
    employee_id_attr = next(a for a in employee["attributes"] if a["name"] == "employee_id")
    assert "ncdot_source_attribute=Employee_ID" in employee_id_attr.get("tags", "")

    statuses = [o.status for o in result.outcomes]
    assert "applied" in statuses
    assert result.coverage_pct > 0


def test_pipeline_invariants_block_mutation_that_removes_user_domain():
    initial = _initial_ncdot_model()
    bad_synth = [
        {"mutator_source": "def mutator(model, data):\n    model['model']['domains'] = []\n    return model\n",
         "verifier_source": SAFE_TRUE_VERIFIER,
         "expected_changes_summary": "wipe everything"},
        {"mutator_source": "def mutator(model, data):\n    model['model']['domains'] = []\n    return model\n",
         "verifier_source": SAFE_TRUE_VERIFIER,
         "expected_changes_summary": "wipe everything"},
        {"mutator_source": "def mutator(model, data):\n    model['model']['domains'] = []\n    return model\n",
         "verifier_source": SAFE_TRUE_VERIFIER,
         "expected_changes_summary": "wipe everything"},
    ]
    llm = _SequencedLLM(bad_synth)
    result = run_vov_pipeline(
        vibe_text=NCDOT_MINIMAL,
        initial_model=initial,
        llm=llm,
        user_pinned_domains=["hr", "project"],
        user_pinned_products=[],
        parallel=False,
    )
    domain_names = sorted(d["name"] for d in result.final_model["model"]["domains"])
    assert domain_names == ["hr", "project"]
    assert any(o.status in ("invariant_violation", "scope_mismatch", "exhausted_retries") for o in result.outcomes)


def test_pipeline_rejects_unsafe_synthesized_code():
    initial = _initial_ncdot_model()
    bad_synth = [
        {"mutator_source": "import os\ndef mutator(model, data):\n    os.system('echo pwned')\n    return model\n",
         "verifier_source": SAFE_TRUE_VERIFIER,
         "expected_changes_summary": "evil"},
    ] * 6
    llm = _SequencedLLM(bad_synth)
    result = run_vov_pipeline(
        vibe_text=NCDOT_MINIMAL,
        initial_model=initial,
        llm=llm,
        user_pinned_domains=["hr", "project"],
        user_pinned_products=[],
        parallel=False,
    )
    assert any(o.status == "rejected_unsafe" for o in result.outcomes)
    assert result.final_model["model"]["domains"] == initial["model"]["domains"]


def test_pipeline_adversarial_vibe_does_not_execute_unsafe_code():
    initial = {"agent_version": "2.0.0", "model": {"domains": [
        {"name": "shop", "products": [
            {"name": "item", "tags": "", "subdomain": "", "primary_key": "item_id",
             "attributes": [
                 {"name": "item_id", "type": "BIGINT", "tags": "", "foreign_key_to": ""},
                 {"name": "name", "type": "STRING", "tags": "", "foreign_key_to": ""},
             ]}
        ]}
    ], "metric_views": []}}

    adversarial_synth = [
        {"mutator_source": """def mutator(model, data):
    return open('/etc/passwd').read()
""",
         "verifier_source": SAFE_TRUE_VERIFIER, "expected_changes_summary": "leak passwd"},
        {"mutator_source": """def mutator(model, data):
    eval("__import__('os').system('rm -rf /')")
    return model
""",
         "verifier_source": SAFE_TRUE_VERIFIER, "expected_changes_summary": "evil"},
        {"mutator_source": """def mutator(model, data):
    import subprocess
    subprocess.run(['ls'])
    return model
""",
         "verifier_source": SAFE_TRUE_VERIFIER, "expected_changes_summary": "evil2"},
        {"mutator_source": """def mutator(model, data):
    os.unlink('/tmp/leak')
    return model
""",
         "verifier_source": SAFE_TRUE_VERIFIER, "expected_changes_summary": "evil3"},
    ]

    class _AdvLLM:
        def __init__(self):
            self.idx = 0
            self.call_log = []
        def complete_json(self, system, user, temperature=0.0):
            self.call_log.append({"system_head": system[:80], "user_head": user[:80]})
            if "STRUCTURED OUTLINE" in system:
                return {"sections": [{"section_id": "S1", "title": "Adversarial test vibe", "summary": "", "declared_entities": ["shop", "item"], "cross_references": [], "constraints": []}], "global_constraints": [], "declared_entities_global": ["shop", "item"]}
            if "RawVREQ" in system:
                return {"vreqs": [{"vreq_id": "V1", "intent": "tag attrs with __class__=item", "target": "shop.item.*", "source_quote": "Tag every attribute with `__class__=item`."}]}
            if "group VREQs into BATCHES" in system:
                return {"batches": [{"batch_id": "B0001", "vreq_ids": ["VREQ-0001"], "intent_summary": "tag attrs", "target_entities": [["shop", "item"]], "data_payload": []}]}
            if "mutator_source" in user:
                r = adversarial_synth[min(self.idx, len(adversarial_synth) - 1)]
                self.idx += 1
                return r
            return {}
        def complete_with_tools(self, system="", user="", tools=None, tool_handlers=None, max_iters=6, temperature=0.0):
            return self.complete_json(system, user, temperature)

    result = run_vov_pipeline(
        vibe_text=ADVERSARIAL_VIBE,
        initial_model=copy.deepcopy(initial),
        llm=_AdvLLM(),
        user_pinned_domains=["shop"],
        user_pinned_products=[("shop", "item")],
        parallel=False,
    )
    assert any(o.status == "rejected_unsafe" for o in result.outcomes), [o.status for o in result.outcomes]
    final = result.final_model
    assert final["model"]["domains"][0]["name"] == "shop"
    assert final["model"]["domains"][0]["products"][0]["name"] == "item"


def test_pipeline_prose_only_vibe_produces_no_mutations():
    initial = _initial_ncdot_model()
    class _ProseLLM:
        def __init__(self):
            self.call_log = []
        def complete_json(self, system, user, temperature=0.0):
            if "STRUCTURED OUTLINE" in system:
                return {"sections": [{"section_id": "S1", "title": "", "summary": "", "declared_entities": [], "cross_references": [], "constraints": []}], "global_constraints": [], "declared_entities_global": []}
            if "RawVREQ" in system:
                return {"vreqs": []}
            if "group VREQs into BATCHES" in system:
                return {"batches": []}
            return {}
        def complete_with_tools(self, system="", user="", tools=None, tool_handlers=None, max_iters=6, temperature=0.0):
            return self.complete_json(system, user, temperature)

    result = run_vov_pipeline(
        vibe_text=PROSE_ONLY_VIBE,
        initial_model=initial,
        llm=_ProseLLM(),
        user_pinned_domains=["hr", "project"],
        user_pinned_products=[],
        parallel=False,
    )
    assert result.final_model == initial
    assert result.batches == []
    assert result.outcomes == []


def test_pipeline_retries_on_verifier_failure_then_succeeds():
    initial = _initial_ncdot_model()

    failing_synth = {
        "mutator_source": "def mutator(model, data):\n    return model\n",
        "verifier_source": "def verifier(model, data):\n    return (False, 'pretend the user constraint is unmet')\n",
        "expected_changes_summary": "noop attempt 1",
    }
    succeeding_synth = {
        "mutator_source": "def mutator(model, data):\n    return model\n",
        "verifier_source": "def verifier(model, data):\n    return (True, '')\n",
        "expected_changes_summary": "noop attempt N",
    }

    class _RetryLLM:
        def __init__(self):
            self.idx = 0
            self.call_log = []
        def complete_json(self, system, user, temperature=0.0):
            if "STRUCTURED OUTLINE" in system:
                return {"sections": [{"section_id": "S1", "title": "NCDOT", "summary": "", "declared_entities": [], "cross_references": [], "constraints": []}], "global_constraints": [], "declared_entities_global": []}
            if "RawVREQ" in system:
                return {"vreqs": [{"vreq_id": "V1", "intent": "x", "target": "x", "source_quote": "x"}]}
            if "group VREQs into BATCHES" in system:
                return {"batches": [{"batch_id": "B0001", "vreq_ids": ["VREQ-0001"], "intent_summary": "i", "target_entities": [["hr", "*"]], "data_payload": []}]}
            if "mutator_source" in user:
                self.idx += 1
                if self.idx <= 2:
                    return failing_synth
                return succeeding_synth
            return {}
        def complete_with_tools(self, system="", user="", tools=None, tool_handlers=None, max_iters=6, temperature=0.0):
            return self.complete_json(system, user, temperature)

    llm = _RetryLLM()
    result = run_vov_pipeline(
        vibe_text=NCDOT_MINIMAL,
        initial_model=initial,
        llm=llm,
        user_pinned_domains=["hr", "project"],
        user_pinned_products=[],
        parallel=False,
    )
    statuses = [o.status for o in result.outcomes]
    assert "applied" in statuses
    applied_outcome = next(o for o in result.outcomes if o.status == "applied")
    assert applied_outcome.attempts >= 1


def test_pipeline_coverage_pct_reflects_applied_ratio():
    initial = _initial_ncdot_model()

    class _MixedLLM:
        def __init__(self):
            self.idx = 0
            self.call_log = []
        def complete_json(self, system, user, temperature=0.0):
            if "STRUCTURED OUTLINE" in system:
                return {"sections": [{"section_id": "S1", "title": "", "summary": "", "declared_entities": [], "cross_references": [], "constraints": []}], "global_constraints": [], "declared_entities_global": []}
            if "RawVREQ" in system:
                return {"vreqs": [{"vreq_id": f"V{i}", "intent": f"i{i}", "target": "x", "source_quote": "q"} for i in range(4)]}
            if "group VREQs into BATCHES" in system:
                return {"batches": [
                    {"batch_id": "B0001", "vreq_ids": ["VREQ-0001", "VREQ-0002"], "intent_summary": "good batch", "target_entities": [["hr", "*"]], "data_payload": []},
                    {"batch_id": "B0002", "vreq_ids": ["VREQ-0003", "VREQ-0004"], "intent_summary": "bad batch", "target_entities": [["project", "*"]], "data_payload": []},
                ]}
            if "mutator_source" in user:
                self.idx += 1
                if "good batch" in user:
                    return {"mutator_source": SAFE_NOOP_MUTATOR, "verifier_source": SAFE_TRUE_VERIFIER, "expected_changes_summary": "noop"}
                return {"mutator_source": "import os\ndef mutator(model, data): return model\n", "verifier_source": SAFE_TRUE_VERIFIER, "expected_changes_summary": "x"}
            return {}
        def complete_with_tools(self, system="", user="", tools=None, tool_handlers=None, max_iters=6, temperature=0.0):
            return self.complete_json(system, user, temperature)

    llm = _MixedLLM()
    result = run_vov_pipeline(
        vibe_text=NCDOT_MINIMAL,
        initial_model=initial,
        llm=llm,
        user_pinned_domains=["hr", "project"],
        user_pinned_products=[],
        parallel=False,
    )
    statuses = [o.status for o in result.outcomes]
    assert "applied" in statuses
    assert "rejected_unsafe" in statuses
    assert 0 < result.coverage_pct < 100
