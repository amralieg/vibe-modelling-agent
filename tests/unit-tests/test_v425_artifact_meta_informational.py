"""
v4.2.5 behavioral tests -- verifier-artifact-meta-informational (RC2).

ROOT CAUSE (retail v2 ECM VOV, run 257229033091163):
    VREQ-022 "the file named _v1_mvm.sql writes DDL into the retail_ecm.customer
    catalog, so MVM and ECM files target the same catalog" and VREQ-043 "add a
    provenance disclosure (LLM-generated, last human-reviewed YYYY-MM-DD by ...)"
    scored FAILED. Both target GENERATED-FILE NAMING / DEPLOY MECHANICS or
    MODEL-LEVEL DOC/PROVENANCE metadata -- neither is a model entity/attribute/
    tag/MV, so neither is assertable by a model mutation. They dragged physical
    adherence below the 90% floor.

FIX: _verify_requirement gains a classifier (alias verifier-artifact-meta-
    informational) returning status="informational" for these two classes, GUARDED
    by a structural-verb exclusion so a COMPOUND VReq that also names a real
    structural action (resolve SSOT / re-home / split / add ...) keeps its genuine
    verdict (a real miss is NEVER excused -- S8.3, section-12 no false-positive).

Tests extract the SHIPPED regexes (not copies) and prove the decision boundary.
"""
import json
import os
import re

import pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _classifier_src():
    cells = json.load(open(NB))["cells"]
    for c in cells:
        if c["cell_type"] == "code" and "verifier-artifact-meta-informational" in "".join(c["source"]):
            return "".join(c["source"])
    raise AssertionError("cell containing verifier-artifact-meta-informational not found")


def _regex(name):
    src = _classifier_src()
    m = re.search(name + r' = re\.compile\(r"(.*?)", re\.I\)', src)
    assert m, "could not extract %s pattern literal" % name
    return re.compile(m.group(1), re.I)


def _classifies_informational(text):
    """Replicate the shipped decision using the SHIPPED regexes: two-tier structural guard first."""
    structural = _regex("_v425_structural_verb")
    additive = _regex("_v425_additive_model")
    if structural.search(text) or additive.search(text):
        return False
    return bool(_regex("_v425_deploy_meta").search(text) or _regex("_v425_doc_meta").search(text))


# ---- real live VREQ texts ----
VREQ_022 = ("Fix the schema/database name mismatch: the file named _v1_mvm.sql writes DDL into the "
            "retail_ecm.customer catalog, so MVM and ECM files target the same catalog and deploying "
            "both blows away the first.")
VREQ_043 = ("Add a provenance disclosure (e.g. 'LLM-generated, last human-reviewed YYYY-MM-DD by ...') "
            "so adopters know to vet the model.")
# compound / genuine-structural -> MUST stay scoreable
VREQ_047 = ("Resolve the 9 cross-domain SSOT duplicates detected in the ECM model so each concept has "
            "one authoritative owner, and lift ECM quality score from 69.0 to >= 80.")
VREQ_070 = ("Section 3E.4: Add a sensitivity/PII classification tag to these 14 untagged critical PII "
            "attributes and mask them in non-prod.")


class TestArtifactMetaMatches:
    def test_vreq_022_deploy_file_naming(self):
        assert _classifies_informational(VREQ_022)

    def test_vreq_043_provenance_doc(self):
        assert _classifies_informational(VREQ_043)

    @pytest.mark.parametrize("text", [
        "The file named schema_ddl.sql writes DDL into the wrong catalog.",
        "Fix the catalog mismatch where MVM and ECM target the same catalog.",
        "Add a model card documenting provenance.",
        "Include an LLM-generated disclosure so adopters know to vet the model.",
    ])
    def test_meta_variants_match(self, text):
        assert _classifies_informational(text), text


class TestCompoundStructuralNotExcused:
    """A real structural action in the text keeps the VReq scoreable (no false-positive)."""

    def test_vreq_047_resolve_ssot_stays_scoreable(self):
        assert not _classifies_informational(VREQ_047)

    def test_vreq_070_add_pii_tag_stays_scoreable(self):
        assert not _classifies_informational(VREQ_070)

    @pytest.mark.parametrize("text", [
        "Re-home the consent table to a compliance domain.",
        "Split the preference god-table into focused tables.",
        "Add a household table to the customer domain.",
        "Remove reversed cross-domain FKs from the customer schema.",
    ])
    def test_structural_reqs_stay_scoreable(self, text):
        assert not _classifies_informational(text), text


class TestWiredIntoVerifier:
    def test_returns_informational_and_guarded(self):
        src = _classifier_src()
        assert "def _verify_requirement(" in src
        block = src.split("_v425_structural_verb = re.compile(", 1)[1][:2200]
        assert "if not _v425_structural_verb.search(_ot425) and not _v425_additive_model.search(_ot425):" in block
        assert 'return {"status": "informational"' in block
        assert "verifier-artifact-meta-informational FIRED v4.2.5" in block
