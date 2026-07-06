"""
v4.2.4 behavioral tests -- verifier-pipeline-meta-informational classifier.

ROOT CAUSE (water_utilities v2 ECM VOV, run <run_id>):
    VREQ-029 asked to "introduce an ontology-first stage to the GENERATION
    PIPELINE (e.g. via OntoBricks producing an OWL ontology)". That targets the
    AGENT'S generation pipeline / tooling, NOT any model entity/attribute/tag/MV,
    so it is UNSATISFIABLE by any model mutation. The verifier scored it FAILED,
    dragging physical adherence to 49/56 = 87.5% -- below the 90% floor. With the
    req correctly excluded (informational), scoreable_total becomes 55.

FIX: _verify_requirement gains an early classifier (alias
    verifier-pipeline-meta-informational) that returns status="informational"
    (excluded from precision/recall via the v4.2.2 gt-informational-exclude path)
    for requirements whose text names the generation PROCESS/TOOLING.

These tests extract the ACTUAL shipped regex from the notebook cell (not a copy)
and prove the decision boundary: pipeline/tooling meta-reqs are matched, while
genuine model-content reqs (add a table / add an ontology domain) are NOT (so
they still count toward precision -- no scoreboard gaming, S8.3).
"""
import json
import os
import re

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _pipeline_meta_regex():
    cells = json.load(open(NB))["cells"]
    for c in cells:
        if c["cell_type"] != "code":
            continue
        s = "".join(c["source"])
        if "_v424_pipeline_meta = re.compile(" in s:
            m = re.search(r'_v424_pipeline_meta = re\.compile\(r"(.*?)", re\.I\)', s)
            assert m, "could not extract _v424_pipeline_meta pattern literal"
            return re.compile(m.group(1), re.I)
    raise AssertionError("cell containing _v424_pipeline_meta not found")


# The exact VREQ-029 text that false-failed on the live wu run.
VREQ_029 = (
    "Consider introducing an ontology-first stage to the generation pipeline "
    "(e.g. via OntoBricks producing an OWL ontology) that captures PFAS-specific "
    "entities (long-chain vs short-chain PFAS, PFAS compound taxonomy)."
)


class TestPipelineMetaMatches:
    """Requirements that target the agent's generation process/tooling."""

    def test_vreq_029_ontology_first_pipeline_matches(self):
        assert _pipeline_meta_regex().search(VREQ_029)

    @pytest.mark.parametrize("text", [
        "add a code generation stage to the pipeline",
        "introduce a codegen step in the generation pipeline",
        "add an ontology-first generation phase",
        "integrate OntoBricks into the model build",
        "add a new stage to the generation pipeline",
        "insert a pipeline stage that seeds an OWL ontology",
    ])
    def test_tooling_meta_variants_match(self, text):
        assert _pipeline_meta_regex().search(text), text


class TestModelContentNotMatched:
    """Genuine model-content reqs MUST still be scored (not excluded)."""

    @pytest.mark.parametrize("text", [
        # wu VREQ-023 / VREQ-024 -- real create-entity gaps, MUST stay scoreable
        "Add a generic prediction_event entity with predicted_value, actual_value, confidence.",
        "Add a customer-impact linkage entity connecting main_break to affected customers.",
        # an ontology *domain/table* is model content, not a pipeline stage
        "Add an ontology domain with owl_class and rdf_triple tables.",
        "Add a jurisdiction dimension to compliance.regulatory_requirement.",
        "Promote treatment.scada_tag to MVM with a basic tag taxonomy.",
        "Ship 50-100 pre-baked KPI metric views such as non-revenue-water percent.",
        "Remove value_regex from typed DATE/BOOLEAN columns where it is redundant.",
    ])
    def test_model_content_not_matched(self, text):
        assert not _pipeline_meta_regex().search(text), text


class TestClassifierWiredIntoVerifier:
    """The classifier must live in _verify_requirement and return informational."""

    def test_returns_informational_status(self):
        cells = json.load(open(NB))["cells"]
        src = ""
        for c in cells:
            if c["cell_type"] == "code" and "verifier-pipeline-meta-informational" in "".join(c["source"]):
                src = "".join(c["source"])
                break
        assert src, "classifier cell not found"
        # the FIRED classifier branch must return status informational
        assert "def _verify_requirement(" in src
        block = src.split("_v424_pipeline_meta = re.compile(", 1)[1]
        head = block[:1200]
        assert 'return {"status": "informational"' in head
        assert "verifier-pipeline-meta-informational FIRED v4.2.4" in head
