
# Healthcare Data Model Review: vibe-business-data-models

Reviewer: Muhammad Zahid, Databricks Solutions Architect — Healthcare  
Date: May 13, 2026  
Repo: github.com/amralieg/vibe-business-data-models/tree/main/healthcare  
Model Agent: github.com/amralieg/vibe-modelling-agent  
Model Version: v1 (ECM + MVM) | Generated May 4, 2026
———

## Overview

This is a review of the Healthcare Lakehouse Data Model produced by the Vibe Modelling Agent. The model is available in two tiers:
MVM (Minimum Viable Model): 16 domains, 43 subdomains, 189 tables, 8,502 attributes, 1,940 FKs
ECM (Expanded Coverage Model): 22 domains, 76 subdomains, 541 tables, 22,423 attributes, 4,093 FKs
The agent's own quality score for this release is 66/100 deterministic / 62/100 LLM-assessed, with 123 known warnings documented in the release notes. The next_vibes.txt file contains 140 prioritized recommended changes from the agent's own static analysis.
This review focuses on high-level structural, healthcare-domain, and Databricks-platform concerns — not line-by-line schema review.
———

## What the Model Does Well


### 1. Exceptional Domain Breadth

22 domains cover the full spectrum of healthcare operations: clinical care, revenue cycle, insurance, compliance, research, interoperability, supply chain, workforce, and more. This is the most complete open healthcare data model I have reviewed for a Lakehouse context, with breadth that rivals comprehensive commercial healthcare data models in scope.

### 2. Smart Two-Tier Architecture (MVM / ECM)

The MVM/ECM design is genuinely valuable for healthcare customers. Most health systems start with 3-5 high-priority domains and expand over time. The MVM gives them a deployable starting point without overwhelming complexity. This is exactly the right approach for Databricks POCs and production onboarding.

### 3. Strong Regulatory Alignment

The model reflects real healthcare regulatory requirements:
Dedicated compliance domain covers HIPAA, CMS Conditions of Participation, Joint Commission, OIG/CIA, OSHA
consent domain covers HIPAA authorization, behavioral health consent, minor consent, research consent, HIE directives (all ECM-tier)
interoperability domain covers HL7v2, FHIR R4, CDA, X12 EDI, DICOM
Quality measures include HEDIS, CAHPS, VBP programs (ECM-tier)

### 4. Correct MPI / Patient Identity Architecture

Using patient.mpi_record as the enterprise SSOT for patient identity is the correct pattern for multi-facility health systems. The mpirecord table is included in both MVM and ECM. In the ECM, this is extended with full mrncrosswalk and identitymergehistory tables for comprehensive multi-system identity resolution — appropriate for the expanded tier.

### 5. Rich Column Documentation

Most attributes include a detailed business-justification comment explaining why the column exists, what it supports, and how it relates to clinical or financial workflows. This is unusually thorough for an open data model and makes the schemas largely self-documenting — a significant advantage for onboarding teams.

### 6. Multi-Format Output

The model ships as SQL DDL, RDF/Turtle ontology, DBML diagram, pre-built metric views (117 views), CSV/Excel docs, and a human-readable README. This is well-suited for Databricks customers who need both technical and business stakeholder artifacts.

### 7. Research Domain Coverage

The research domain covers IRB submissions, informed consent, biospecimen, study management, grant/financial oversight, and protocol management. This is directly relevant to Academic Medical Centers (like Cleveland Clinic) and health systems with active clinical trial programs.

### 8. Interoperability Infrastructure Detail

The interoperability domain goes beyond just FHIR endpoints — it models interface engines (Mirth, Rhapsody, Ensemble), trading partner onboarding, message-level tracking, HIE participation, and exchange standard versioning. This is operationally realistic for health system integration teams.
———

## What the Model Could Improve On


### 1. PII / PHI Classification is a Critical Gap

Priority: Must Fix for Healthcare
The agent's own analysis flags 656 attributes matching person-data patterns that lack pii_ classification tags. In a healthcare context, this is a HIPAA compliance risk. Every Databricks healthcare customer using this model will need Unity Catalog column-level tags for PHI/PII before they can govern data access, apply dynamic data masking, or pass a compliance audit.
Recommendation: Add pii_phi, pii_pii, and pii_sensitive classification tags to all PHI-containing attributes as part of the next vibe iteration. These should map to Unity Catalog tag values so customers can directly apply row-level security and dynamic masking policies.

### 2. facility.organization is Completely Disconnected

Priority: Must Fix
facility.organization has zero inbound and zero outbound FK relationships — it is a completely isolated table. For healthcare, the organization hierarchy (health system → hospital → clinic → department → unit) is foundational to almost every analytic and operational workflow. This is listed as Priority 1 in next_vibes.txt and needs to be resolved before v1 is considered production-ready.
Recommendation: Add self-referential parentorganizationid and FK to facility.care_site as the anchor point of the facility hierarchy.

### 3. Behavioral Health and 42 CFR Part 2 Are Missing

Priority: High for US Healthcare
There is no dedicated behavioral health / mental health domain. Mental health and substance use disorder (SUD) treatment data are subject to 42 CFR Part 2 — a federal privacy law more restrictive than HIPAA — requiring explicit patient consent before any disclosure. A healthcare model that does not model this separately creates a data governance risk for customers.
Specific gaps:
No psychiatric assessment tables (PHQ-9, GAD-7, Columbia Suicide Severity Rating Scale)
No SUD treatment episode tables
No 42 CFR Part 2 consent tracking (the ECM consent domain includes substance_use_consent and behavioral_health_consent tables, but these are consent records only — there are no linked behavioral health clinical tables to govern)
No medication-assisted treatment (MAT) or opioid treatment program (OTP) tables
Recommendation: Add a behavioral_health domain (or subdomain) with: psychiatricassessment, sudepisode, mattreatment, otpenrollment, crisisepisode, and a full 42cfr_part2 consent workflow that links to clinical treatment tables.

### 4. No AI/ML Result or Feature Store Layer

Priority: High for Databricks Customers
This is a Databricks healthcare model — yet there are no tables for storing ML model outputs, risk scores, or feature vectors. Healthcare AI use cases (readmission prediction, sepsis scores, care gap identification, prior auth automation) all require storing model inference results back to the lakehouse.
Specific gaps:
No patientriskscore table (readmission risk, sepsis risk, fall risk, deterioration index)
No clinicalnlpresult table (NER extractions from clinical notes)
No care_gap table (patient x measure x gap status for quality programs)
No modelinferencelog table (MLflow model lineage to clinical decision)
No featurestoreentity table (patient/encounter-level feature snapshots)
Recommendation: Add a clinical_ai or population_health domain with risk score storage, NLP result tables, and model inference log linking back to MLflow run IDs.

### 5. SDOH Coverage is Thin

Priority: High — CMS and Joint Commission now require SDOH screening
Social Determinants of Health (SDOH) are increasingly mandatory. CMS requires SDOH screening for many value-based programs; The Joint Commission added SDOH to accreditation standards. The model includes patient.sdoh_assessment (ECM only) and quality.sdoh_screening (ECM only) but lacks:
SDOH referral and community resource linkage tables
SDOH need closure tracking (was the housing/food need resolved?)
Community health worker (CHW) intervention tables
SDOH risk stratification / priority score storage
ICD-10-Z code (Z-codes) mapping to SDOH categories
Recommendation: Expand SDOH into a proper subdomain with referral management, need closure tracking, and community resource directory.

### 6. Cross-Domain SSOT Violations (network_participation duplicated 4x)

Priority: Should Fix
The agent identified 19 cross-domain SSOT violations. One example is network_participation appearing across four domains:
billing.billing_network_participation
insurance.insurance_network_participation
pharmacy.pharmacy_network_participation (pharmacy benefit network participation — more specialized)
provider.provider_network_participation
While the pharmacy variant covers pharmacy benefit networks specifically, the billing, insurance, and provider variants represent the same underlying concept split across domains, creating join complexity for customers building provider network analytics.
Recommendation: Consolidate the billing, insurance, and provider variants into a single insurance.network_participation table with a participant_type column. Retain pharmacy.pharmacy_network_participation as a separate entity given its distinct business domain (PBM/pharmacy benefit network contracts differ materially from medical network participation).

### 7. Generic Table Names Create SQL Reserved Word Conflicts

Priority: Should Fix Before Production
Several tables in the consent domain use SQL reserved words as table names: consent.record, consent.event, consent.exception, consent.translation, consent.verification, consent.workflow. Similarly, order.set and research.grant are SQL reserved words.
These will cause issues for customers who use these table names in queries without proper escaping. The next_vibes.txt already lists renaming these as priorities 56-74.
Recommendation: Apply the next_vibes.txt renaming pass before publishing v1 as production-ready.

### 8. Patient-Generated Health Data / Remote Patient Monitoring is Missing

Priority: Medium — Growing Rapidly in Healthcare
Wearable devices, RPM (Remote Patient Monitoring), and patient-reported outcomes (PROs) are increasingly central to chronic disease management programs. The model has no tables for:
Device/sensor readings (heart rate, glucose, SpO2, weight)
RPM program enrollment and alert thresholds
Patient-reported outcome measures (PROMs) — standardized questionnaire responses
Patient portal engagement metrics (message reads, portal logins, appointment self-scheduling)
Recommendation: Add a patient_engagement subdomain or digital_health domain covering RPM device readings, PROM responses, and portal engagement events.

### 9. Value-Based Care / MIPS / APM Reporting is Underdeveloped

Priority: Medium
VBC and MIPS reporting are core analytics use cases for health systems. The model has insurance.vbc_performance (ECM only) and HEDIS/CAHPS tables (ECM only) but lacks:
MIPS (Merit-based Incentive Payment System) measure tracking per clinician
APM (Alternative Payment Model) participant registry
Care gap closure tracking per patient per payer contract per measurement period
Quality measure attribution (which patients are attributed to which clinician under which program)
Risk adjustment factor (RAF) score storage per member per year
Recommendation: Expand the quality domain with MIPS clinician-level measure reporting, APM program enrollment, and care gap closure tables.

### 10. Missing Databricks-Specific Governance Patterns

Priority: Medium — Specific to Databricks Deployment
The model is missing patterns that healthcare customers deploying on Databricks will immediately need:
| Gap | Why It Matters |
| No Unity Catalog tag definitions in DDL | Customers need column-level `pii_phi` tags to apply masking policies |
| No row-level security (RLS) example predicates | Multi-tenant health systems need care_site-scoped RLS |
| No SCD Type 2 (effective_from/effective_to) on reference tables | ICD/CPT code sets change annually; version history is required |
| No Delta table properties (TBLPROPERTIES) | OPTIMIZE/ZORDER hints, delta.autoOptimize not included |
| No liquid clustering recommendations | High-cardinality patient/encounter tables would benefit from liquid clustering |
| No data retention annotations | HIPAA requires 6-year retention for many record types |
Recommendation: Add a Databricks deployment guide section to the README with Unity Catalog tag definitions, RLS predicate examples, and Delta table property recommendations.
———

## Other Observations


### Agent's Own Known Issues (from next_vibes.txt)

The model ships with 140 prioritized recommended changes and a quality score of 66/100. The most impactful ones to address before broader distribution:
| Priority | Issue | Impact |
| 1 | facility.organization completely isolated | Blocks facility hierarchy queries |
| Auto | TIME datatype in facility.block_assignment | Breaks Databricks/Spark SQL DDL execution |
| Auto | billing.charge has 26 outgoing FKs (max 25) | FK density suggests table should be split |
| Auto | pharmacy.prescription has 27 outgoing FKs | Same — consider splitting prescriptions from encounters |
| Auto | 89 attributes with redundant product-name prefix | Naming inconsistency |
| Auto | 18 attributes contain banned boilerplate phrases | Description quality |

### MVM Inconsistencies Worth Noting

Several tables appear in the MVM but NOT in the ECM (marked "MVM only (stub or new)"), which is architecturally backwards — the ECM should be a superset of the MVM. Examples:
scheduling.appointment (MVM) vs scheduling.scheduling_appointment (ECM) — these appear to be the same concept with different names
encounter.authorization (MVM only)
provider.location, provider.location_specialty (MVM only)
radiology.study (MVM only)
Recommendation: Reconcile MVM-only tables to ensure the ECM is a true superset. The appointment naming inconsistency in particular will create confusion.

### What's Notably Absent for Academic Medical Centers / IDNs

For large health systems like Cleveland Clinic or Advocate (top-tier Databricks customers):
Genomics / Precision Medicine — No genetic variant, biobank, or pharmacogenomics tables
Post-Acute Care — No SNF (skilled nursing facility), home health, or hospice data
Population Health Cohort Management — No dynamic cohort definition or membership tracking tables
Clinical Trial Matching — No eligibility criteria evaluation tables (relevant for CCF's cancer trial matching use case)
Clinical AI Governance — No model card, bias monitoring, or FDA SaMD (Software as a Medical Device) regulatory tracking tables
———

## Summary Scorecard

| Dimension | Score | Notes |
| Domain Coverage | 9/10 | Exceptional breadth; only gaps are behavioral health and digital health |
| Structural Integrity | 6/10 | 66/100 agent score; facility.organization isolated; FK density issues |
| Healthcare Regulatory Fit | 7/10 | Strong HIPAA/CMS/JC coverage; 42 CFR Part 2 and SDOH gaps |
| Databricks Platform Fit | 5/10 | Missing UC tags, RLS patterns, Delta properties |
| AI/ML Readiness | 4/10 | No risk score storage, NLP results, or feature store tables |
| Naming Conventions | 6/10 | SQL reserved word conflicts; cross-domain SSOT violations |
| Documentation Quality | 9/10 | Column-level comments are thorough for most attributes |
| MVM/ECM Design | 8/10 | Smart architecture; MVM-only stub inconsistencies need resolution |
———

## Top 5 Recommended Next Steps

Run next_vibes.txt iteration through the Vibe Modelling Agent to address the 140 flagged structural issues (especially facility.organization isolation, generic table naming, and FK deduplication). This is the fastest path to quality score improvement.
Add PHI/PII classification tags to all 656 flagged attributes, mapped to Unity Catalog tag values (pii_phi, pii_pii, pii_de_identified). This is non-negotiable for healthcare customer adoption.
Add behavioral health subdomain with 42 CFR Part 2 consent tracking linked to clinical tables, and psychiatric/SUD assessment tables. US health systems cannot use a healthcare model that does not address this regulatory dimension.
Add AI/ML result storage layer — at minimum a patient_risk_score table and clinical_ai_inference_log. This directly enables the Databricks AI/ML use cases that are the primary reason customers adopt the platform.
Add a Databricks deployment guide to the README covering: Unity Catalog tag definitions, row-level security predicate patterns, recommended Delta table properties, and HIPAA data retention annotations.
———
Review conducted by Muhammad Zahid (muhammad.zahid@databricks.com). Model repo: [github.com/amralieg/vibe-business-data-models](https://github.com/amralieg/vibe-business-data-models). Agent repo: [github.com/amralieg/vibe-modelling-agent](https://github.com/amralieg/vibe-modelling-agent).