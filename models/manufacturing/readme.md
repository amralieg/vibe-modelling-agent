<div align="center">

# Manufacturing Lakehouse Data Models

### Industrial Manufacturing — Automation, Electrification & Smart Infrastructure

[![Version](https://img.shields.io/badge/Version-1-blue?style=for-the-badge)](#model-metrics-comparison)
[![MVM Tables](https://img.shields.io/badge/MVM-205%20Tables-2ea44f?style=for-the-badge)](#mvm-minimum-viable-model)
[![ECM Tables](https://img.shields.io/badge/ECM-603%20Tables-FF3621?style=for-the-badge)](#ecm-expanded-coverage-model)
[![Databricks](https://img.shields.io/badge/Platform-Databricks-FF3621?style=for-the-badge&logo=databricks&logoColor=white)](#)
[![Unity Catalog](https://img.shields.io/badge/Governance-Unity%20Catalog-4B0082?style=for-the-badge)](#)

*Generated on April 16, 2026 — by the [Vibe Modelling Agent](../../readme.md)*

---

[MVM](#mvm-minimum-viable-model) · [ECM](#ecm-expanded-coverage-model) · [Comparison](#head-to-head-comparison) · [Domain Map](#domain--product-comparison)

</div>

---

## Table of Contents

- [Business Description](#business-description)
- [Model Scope Variations](#model-scope-variations)
- [MVM (Minimum Viable Model)](#mvm-minimum-viable-model)
  - [MVM Artifacts](#mvm-artifacts)
- [ECM (Expanded Coverage Model)](#ecm-expanded-coverage-model)
  - [ECM Artifacts](#ecm-artifacts)
- [Head-to-Head Comparison](#head-to-head-comparison)
- [Model Metrics Comparison](#model-metrics-comparison)
- [Domain & Product Comparison](#domain--product-comparison)
  - [asset](#domain-asset)
  - [billing](#domain-billing) *(ECM only)*
  - [compliance](#domain-compliance) *(ECM only)*
  - [customer](#domain-customer)
  - [engineering](#domain-engineering)
  - [finance](#domain-finance)
  - [hse](#domain-hse) *(ECM only)*
  - [inventory](#domain-inventory)
  - [logistics](#domain-logistics)
  - [order](#domain-order)
  - [procurement](#domain-procurement)
  - [product](#domain-product)
  - [production](#domain-production)
  - [quality](#domain-quality)
  - [research](#domain-research) *(ECM only)*
  - [sales](#domain-sales)
  - [service](#domain-service)
  - [shared](#domain-shared) *(MVM only)*
  - [technology](#domain-technology) *(ECM only)*
  - [workforce](#domain-workforce) *(ECM only)*

---

## Business Description

Industrial Manufacturing encompasses the design, production, and delivery of automation systems, electrification solutions, and smart infrastructure components for factories, buildings, transportation, and urban environments.

---

## Model Scope Variations

This data model is available in **two scope variations** — the **MVM (Minimum Viable Model)** and the **ECM (Expanded Coverage Model)** — each designed for different organizational needs and use cases. Both models share the same attribute depth per table; the difference is in breadth (number of domains and tables).

---

## MVM (Minimum Viable Model)

> **Folder:** [`v1_mvm/`](v1_mvm/)

The **MVM** is a production-ready, core data model that covers all essential business functions with full attribute depth. It is the recommended starting point for organizations that want to deploy quickly and expand incrementally.

| Use Case | Description |
|:---|:---|
| **Small-to-Mid Businesses** | A thin, efficient model for organizations that need a complete but focused data platform without the overhead of corporate back-office domains |
| **Production-Ready Foundation** | Deploy to production from day one and grow by adding domains as business needs evolve |
| **Proof-of-Concept & Demos** | Quick deployment for stakeholder presentations and proof-of-concept engagements |
| **Targeted Analytics** | Focused analytical workloads centered on core business processes |
| **Rapid Onboarding** | Simplified structure for teams getting started with the data platform |
| **Development & Testing** | Lightweight model for development environments and integration testing |

The MVM prioritizes **Operations** and **Business** division domains, excludes corporate/back-office functions, minimizes association (many-to-many bridge) tables, and relies on direct foreign key relationships for simplicity. Every table in the MVM has the **same attribute depth** as the ECM.

### MVM Artifacts

> Paths below are populated when the agent runs and copies artifacts into the model folder; only the `readme.md` is tracked in git.

| Artifact | Path |
|:---|:---|
| DDL Schemas | `v1_mvm/schemas/` |
| Metric Views | `v1_mvm/metrics/` |
| Documentation | `v1_mvm/docs/` |
| DBML Diagram | `v1_mvm/diagram/` |
| RDF Ontology | `v1_mvm/ontology/` |
| Vibes Context | `v1_mvm/vibes/` |
| Full Model JSON | `v1_mvm/model.json` |
| Model README | [`v1_mvm/readme.md`](v1_mvm/readme.md) |

---

## ECM (Expanded Coverage Model)

> **Folder:** [`v1_ecm/`](v1_ecm/)

The **ECM** is a comprehensive, full-coverage data model that covers the complete breadth of business operations, including corporate functions, detailed audit trails, association tables, and granular reference data.

| Use Case | Description |
|:---|:---|
| **Large Organizations & Multinationals** | Complete data platform for Fortune 100-class organizations with global operations |
| **Full-Coverage Data Warehousing** | Lakehouse model supporting all business units and divisions |
| **Regulatory & Compliance** | Includes audit, legal, and compliance domains required for governance |
| **Cross-Functional Analytics** | Enables analysis across all divisions including HR, Finance, IT, and more |

The ECM includes all domains from the MVM plus additional **Corporate/Supporting** division domains, many-to-many association tables, helper/lookup tables, and expanded attribute coverage.

### ECM Artifacts

> Paths below are populated when the agent runs and copies artifacts into the model folder; only the `readme.md` is tracked in git.

| Artifact | Path |
|:---|:---|
| DDL Schemas | `v1_ecm/schemas/` |
| Metric Views | `v1_ecm/metrics/` |
| Documentation | `v1_ecm/docs/` |
| DBML Diagram | `v1_ecm/diagram/` |
| RDF Ontology | `v1_ecm/ontology/` |
| Vibes Context | `v1_ecm/vibes/` |
| Full Model JSON | `v1_ecm/model.json` |
| Model README | [`v1_ecm/readme.md`](v1_ecm/readme.md) |

---

## Head-to-Head Comparison

| Dimension | MVM | ECM |
|:---|:---|:---|
| **Folder** | [`v1_mvm/`](v1_mvm/) | [`v1_ecm/`](v1_ecm/) |
| **Target Organization** | Small-to-mid businesses, startups, focused teams | Large organizations, multinationals, Fortune 100 |
| **Domain Coverage** | Core operations + business domains | All domains including corporate back-office |
| **Divisions Included** | Operations, Business | Operations, Business, Corporate |
| **Attribute Depth** | Full (same as ECM) | Full |
| **M:N Associations** | Minimized (direct FKs preferred) | Comprehensive junction tables |
| **Growth Path** | Start here, enlarge to ECM as needed | Complete from day one |
| **Best For** | Quick production deployments, focused analytics, POC | Organization-wide analytics, compliance, global operations |

---

## Model Metrics Comparison

| Metric | MVM | ECM | Delta |
|:---|---:|---:|---:|
| Domains | 14 | 19 | +5 |
| Subdomains | 40 | 80 | +40 |
| Products (Tables) | 205 | 603 | +398 |
| Attributes (Columns) | 8,131 | 22,905 | +14,774 |
| Foreign Keys | 1,036 | 2,775 | +1,739 |
| Avg Attributes/Product | 39.7 | 38.0 | −1.7 |

---

## Domain & Product Comparison

The table below maps every product (table) to its domain and shows availability across both model scopes.

**Legend:** ✅ = included &nbsp;|&nbsp; ❌ = not included

<a id="domain-asset"></a>
<details>
<summary><b>asset</b> — Equipment Registry, Maintenance Operations, Performance Monitoring</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| contract_administration | asset_supply_agreement | ✅ | ❌ | |
| contract_administration | contract_risk_assessment | ✅ | ❌ | |
| contract_administration | control_implementation | ✅ | ❌ | |
| contract_administration | equipment_certification | ✅ | ❌ | |
| contract_administration | equipment_compliance | ✅ | ❌ | |
| contract_administration | equipment_contract_coverage | ✅ | ❌ | |
| contract_administration | equipment_service_contract | ✅ | ❌ | |
| contract_administration | service_contract | ✅ | ✅ | |
| contract_administration | warranty | ✅ | ✅ | |
| equipment_registry | asset_bom | ✅ | ❌ | |
| equipment_registry | asset_document | ✅ | ❌ | |
| equipment_registry | class | ✅ | ✅ | |
| equipment_registry | equipment_allocation | ✅ | ❌ | |
| equipment_registry | lifecycle_event | ✅ | ❌ | |
| financial_planning | asset_valuation | ✅ | ✅ | |
| financial_planning | capex_request | ✅ | ❌ | |
| maintenance_operations | asset_notification | ✅ | ✅ | |
| maintenance_operations | maintenance_item | ✅ | ✅ | |
| maintenance_operations | maintenance_plan | ✅ | ✅ | |
| maintenance_operations | permit_to_work | ✅ | ❌ | |
| maintenance_operations | shutdown_plan | ✅ | ❌ | |
| maintenance_operations | task_list | ✅ | ✅ | |
| maintenance_operations | work_order_operation | ✅ | ❌ | |
| performance_monitoring | calibration_record | ✅ | ✅ | |
| performance_monitoring | condition_assessment | ✅ | ❌ | |
| performance_monitoring | failure_record | ✅ | ❌ | |
| performance_monitoring | iiot_asset_telemetry | ✅ | ❌ | |
| performance_monitoring | measurement_point | ✅ | ✅ | |
| performance_monitoring | measurement_reading | ✅ | ✅ | |
| performance_monitoring | predictive_alert | ✅ | ❌ | |
| performance_monitoring | reliability_record | ✅ | ❌ | |
| service_coverage | contract_coverage | ❌ | ✅ | MVM only |

</details>

<a id="domain-billing"></a>
<details>
<summary><b>billing</b> — Invoice Management, Payment Collections, Revenue Recognition <i>(ECM only)</i></summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| invoice_management | billing_block | ✅ | ❌ | ECM only domain |
| invoice_management | condition | ✅ | ❌ | ECM only domain |
| invoice_management | credit_note | ✅ | ❌ | ECM only domain |
| invoice_management | debit_note | ✅ | ❌ | ECM only domain |
| invoice_management | document_output | ✅ | ❌ | ECM only domain |
| invoice_management | intercompany_invoice | ✅ | ❌ | ECM only domain |
| invoice_management | invoice_dispute | ✅ | ❌ | ECM only domain |
| invoice_management | invoice_line_item | ✅ | ❌ | ECM only domain |
| invoice_management | invoice_service_line | ✅ | ❌ | ECM only domain |
| invoice_management | invoice_status_history | ✅ | ❌ | ECM only domain |
| invoice_management | proforma_invoice | ✅ | ❌ | ECM only domain |
| invoice_management | run | ✅ | ❌ | ECM only domain |
| invoice_management | type | ✅ | ❌ | ECM only domain |
| payment_collections | accounts_receivable_position | ✅ | ❌ | ECM only domain |
| payment_collections | dunning_record | ✅ | ❌ | ECM only domain |
| payment_collections | payment_allocation | ✅ | ❌ | ECM only domain |
| payment_collections | payment_receipt | ✅ | ❌ | ECM only domain |
| payment_collections | write_off | ✅ | ❌ | ECM only domain |
| revenue_recognition | billing_payment_term | ✅ | ❌ | ECM only domain |
| revenue_recognition | performance_obligation | ✅ | ❌ | ECM only domain |
| revenue_recognition | plan | ✅ | ❌ | ECM only domain |
| revenue_recognition | plan_milestone | ✅ | ❌ | ECM only domain |
| revenue_recognition | revenue_recognition_event | ✅ | ❌ | ECM only domain |
| revenue_recognition | tax_determination | ✅ | ❌ | ECM only domain |

</details>

<a id="domain-compliance"></a>
<details>
<summary><b>compliance</b> — Audit, Policy, Privacy, Regulatory Oversight <i>(ECM only)</i></summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| audit_management | assessment | ✅ | ❌ | ECM only domain |
| audit_management | audit_service_scope | ✅ | ❌ | ECM only domain |
| audit_management | certification_audit | ✅ | ❌ | ECM only domain |
| audit_management | compliance_audit_finding | ✅ | ❌ | ECM only domain |
| audit_management | evidence | ✅ | ❌ | ECM only domain |
| audit_management | internal_audit | ✅ | ❌ | ECM only domain |
| policy_governance | compliance_policy | ✅ | ❌ | ECM only domain |
| policy_governance | exception | ✅ | ❌ | ECM only domain |
| policy_governance | policy_acknowledgment | ✅ | ❌ | ECM only domain |
| policy_governance | policy_regulatory_mapping | ✅ | ❌ | ECM only domain |
| policy_governance | training | ✅ | ❌ | ECM only domain |
| privacy_protection | cybersecurity_control | ✅ | ❌ | ECM only domain |
| privacy_protection | cybersecurity_incident | ✅ | ❌ | ECM only domain |
| privacy_protection | data_privacy_record | ✅ | ❌ | ECM only domain |
| privacy_protection | data_subject_request | ✅ | ❌ | ECM only domain |
| privacy_protection | privacy_breach | ✅ | ❌ | ECM only domain |
| privacy_protection | risk_register | ✅ | ❌ | ECM only domain |
| privacy_protection | third_party_risk | ✅ | ❌ | ECM only domain |
| regulatory_oversight | asset_compliance_requirement | ✅ | ❌ | ECM only domain |
| regulatory_oversight | env_compliance_record | ✅ | ❌ | ECM only domain |
| regulatory_oversight | jurisdiction | ✅ | ❌ | ECM only domain |
| regulatory_oversight | obligation | ✅ | ❌ | ECM only domain |
| regulatory_oversight | regulatory_change | ✅ | ❌ | ECM only domain |
| regulatory_oversight | regulatory_filing | ✅ | ❌ | ECM only domain |
| regulatory_oversight | rohs_compliance_record | ✅ | ❌ | ECM only domain |
| regulatory_oversight | sanctions_screening | ✅ | ❌ | ECM only domain |

</details>

<a id="domain-customer"></a>
<details>
<summary><b>customer</b> — Account Management, Engagement, Financial Operations, Service Delivery</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| account_management | account_classification | ✅ | ✅ | |
| account_management | account_contact_role | ✅ | ✅ | |
| account_management | account_document | ✅ | ❌ | |
| account_management | account_hierarchy | ✅ | ❌ | |
| account_management | account_status_history | ✅ | ❌ | |
| account_management | account_team | ✅ | ❌ | |
| account_management | address | ✅ | ❌ | |
| account_management | contact | ✅ | ❌ | |
| account_management | partner_function | ✅ | ✅ | |
| account_management | sales_area_assignment | ✅ | ✅ | |
| account_management | segment | ✅ | ❌ | |
| commercial_relationships | pricing_coverage_assignment | ❌ | ✅ | MVM only |
| compliance_requirements | account_certification_requirement | ✅ | ❌ | |
| compliance_requirements | account_chemical_approval | ✅ | ❌ | |
| compliance_requirements | account_regulatory_applicability | ✅ | ❌ | |
| compliance_requirements | approval | ✅ | ❌ | |
| compliance_requirements | approved_component_list | ✅ | ❌ | |
| engagement_tracking | campaign_enrollment | ✅ | ❌ | |
| engagement_tracking | communication_preference | ✅ | ❌ | |
| engagement_tracking | consent_record | ✅ | ❌ | |
| engagement_tracking | contact_system_access | ✅ | ❌ | |
| engagement_tracking | customer_opportunity | ✅ | ❌ | |
| engagement_tracking | interaction | ✅ | ❌ | |
| engagement_tracking | nps_response | ✅ | ❌ | |
| financial_operations | account_bank_detail | ✅ | ❌ | |
| financial_operations | account_contract | ✅ | ❌ | |
| financial_operations | account_payment_term | ✅ | ❌ | |
| financial_operations | credit_profile | ✅ | ✅ | |
| financial_operations | customer_contract | ✅ | ❌ | |
| financial_operations | license_entitlement | ✅ | ❌ | |
| financial_operations | pricing_agreement | ✅ | ❌ | |
| service_delivery | account_delivery_zone | ✅ | ❌ | |
| service_delivery | case | ✅ | ❌ | |
| service_delivery | collaboration | ✅ | ❌ | |
| service_delivery | installed_base | ✅ | ❌ | |
| service_delivery | preferred_carrier | ✅ | ❌ | |
| service_delivery | sla_agreement | ✅ | ❌ | |

</details>

<a id="domain-engineering"></a>
<details>
<summary><b>engineering</b> — Change Management, Product Structure, Risk Assessment</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| change_management | change_affected_item | ✅ | ✅ | |
| change_management | ecn | ✅ | ❌ | |
| change_management | eco | ✅ | ✅ | |
| change_management | engineering_change_request | ✅ | ❌ | |
| compliance_tracking | component_carrier_qualification | ✅ | ❌ | |
| compliance_tracking | component_certification | ✅ | ❌ | |
| compliance_tracking | component_compliance | ✅ | ❌ | |
| compliance_tracking | component_evaluation | ✅ | ❌ | |
| compliance_tracking | component_measurement_plan | ✅ | ❌ | |
| compliance_tracking | engineering_regulatory_certification | ✅ | ❌ | |
| compliance_tracking | specification_compliance_mapping | ✅ | ❌ | |
| compliance_tracking | test_requirement_verification | ✅ | ❌ | |
| product_structure | bom_line | ✅ | ✅ | |
| product_structure | bop | ✅ | ❌ | |
| product_structure | bop_operation | ✅ | ✅ | |
| product_structure | cad_model | ✅ | ✅ | |
| product_structure | component_revision | ✅ | ❌ | |
| product_structure | component_tooling_assignment | ❌ | ✅ | MVM only |
| product_structure | drawing | ✅ | ❌ | |
| product_structure | engineering_bom | ✅ | ❌ | |
| product_structure | material_specification | ✅ | ❌ | |
| product_structure | product_specification | ✅ | ❌ | |
| product_structure | product_variant | ✅ | ❌ | |
| product_structure | substitute_component | ✅ | ✅ | |
| product_structure | tooling_equipment | ✅ | ❌ | |
| risk_assessment | approved_manufacturer | ✅ | ❌ | |
| risk_assessment | design_review | ✅ | ❌ | |
| risk_assessment | design_review_action | ✅ | ❌ | |
| risk_assessment | design_validation_test | ✅ | ❌ | |
| risk_assessment | dfmea | ✅ | ✅ | |
| risk_assessment | engineering_prototype | ✅ | ❌ | |
| risk_assessment | pfmea | ✅ | ✅ | |
| risk_assessment | plm_lifecycle_state | ✅ | ✅ | |
| risk_assessment | project | ✅ | ❌ | |

</details>

<a id="domain-finance"></a>
<details>
<summary><b>finance</b> — General Ledger, Cost Controlling, Treasury Operations</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| asset_management | asset_transaction | ✅ | ✅ | |
| cash_operations | cash_application | ❌ | ✅ | MVM only |
| cost_controlling | budget | ✅ | ❌ | |
| cost_controlling | budget_line | ✅ | ❌ | |
| cost_controlling | controlling_area | ✅ | ❌ | |
| cost_controlling | copa_posting | ✅ | ❌ | |
| cost_controlling | cost_allocation | ✅ | ❌ | |
| cost_controlling | product_cost_estimate | ✅ | ❌ | |
| cost_controlling | production_order_cost | ✅ | ❌ | |
| cost_controlling | profitability_segment | ✅ | ❌ | |
| general_ledger | chart_of_accounts | ✅ | ✅ | |
| general_ledger | currency_exchange_rate | ✅ | ❌ | |
| general_ledger | fiscal_period | ✅ | ❌ | |
| general_ledger | journal_entry | ✅ | ✅ | |
| general_ledger | journal_entry_line | ✅ | ✅ | |
| general_ledger | ledger | ✅ | ❌ | |
| general_ledger | period_close_activity | ✅ | ❌ | |
| general_ledger | statement_version | ✅ | ❌ | |
| general_ledger | tax_code | ✅ | ❌ | |
| payables_receivables | ap_invoice | ✅ | ❌ | |
| payables_receivables | ar_invoice | ✅ | ❌ | |
| payables_receivables | intercompany_transaction | ✅ | ❌ | |
| treasury_operations | bank_account | ✅ | ✅ | |
| treasury_operations | cash_pool | ✅ | ❌ | |
| treasury_operations | house_bank | ✅ | ❌ | |
| treasury_operations | payment | ✅ | ✅ | |

</details>

<a id="domain-hse"></a>
<details>
<summary><b>hse</b> — Health, Safety & Environment <i>(ECM only)</i></summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| chemical_management | chemical_inventory | ✅ | ❌ | ECM only domain |
| chemical_management | chemical_regulatory_compliance | ✅ | ❌ | ECM only domain |
| chemical_management | chemical_substance | ✅ | ❌ | ECM only domain |
| chemical_management | hse_reach_substance_declaration | ✅ | ❌ | ECM only domain |
| chemical_management | sds | ✅ | ❌ | ECM only domain |
| environmental_compliance | audit_coverage | ✅ | ❌ | ECM only domain |
| environmental_compliance | compliance_evaluation | ✅ | ❌ | ECM only domain |
| environmental_compliance | emission_monitoring | ✅ | ❌ | ECM only domain |
| environmental_compliance | energy_consumption | ✅ | ❌ | ECM only domain |
| environmental_compliance | energy_target | ✅ | ❌ | ECM only domain |
| environmental_compliance | environmental_aspect | ✅ | ❌ | ECM only domain |
| environmental_compliance | environmental_permit | ✅ | ❌ | ECM only domain |
| environmental_compliance | ghg_emission | ✅ | ❌ | ECM only domain |
| environmental_compliance | objective | ✅ | ❌ | ECM only domain |
| environmental_compliance | regulatory_obligation | ✅ | ❌ | ECM only domain |
| environmental_compliance | waste_record | ✅ | ❌ | ECM only domain |
| safety_operations | contractor_qualification | ✅ | ❌ | ECM only domain |
| safety_operations | emergency_drill | ✅ | ❌ | ECM only domain |
| safety_operations | emergency_response_plan | ✅ | ❌ | ECM only domain |
| safety_operations | hazard_assessment | ✅ | ❌ | ECM only domain |
| safety_operations | hse_audit_finding | ✅ | ❌ | ECM only domain |
| safety_operations | hse_capa | ✅ | ❌ | ECM only domain |
| safety_operations | hygiene_monitoring | ✅ | ❌ | ECM only domain |
| safety_operations | incident | ✅ | ❌ | ECM only domain |
| safety_operations | incident_investigation | ✅ | ❌ | ECM only domain |
| safety_operations | management_of_change | ✅ | ❌ | ECM only domain |
| safety_operations | ppe_requirement | ✅ | ❌ | ECM only domain |
| safety_operations | safety_audit | ✅ | ❌ | ECM only domain |
| safety_operations | safety_training | ✅ | ❌ | ECM only domain |
| safety_operations | training_attendance | ✅ | ❌ | ECM only domain |

</details>

<a id="domain-inventory"></a>
<details>
<summary><b>inventory</b> — Material Tracking, Physical Verification, Stock & Warehouse Operations</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| material_tracking | abc_classification | ✅ | ❌ | |
| material_tracking | consignment_stock | ✅ | ❌ | |
| material_tracking | consumption | ✅ | ❌ | |
| material_tracking | lot_batch | ✅ | ❌ | |
| material_tracking | mro_stock | ✅ | ❌ | |
| material_tracking | quarantine_hold | ✅ | ✅ | |
| material_tracking | serialized_unit | ✅ | ❌ | |
| material_tracking | wip_stock | ✅ | ✅ | |
| physical_verification | cycle_count | ✅ | ✅ | |
| physical_verification | cycle_count_result | ✅ | ✅ | |
| physical_verification | inventory_valuation | ✅ | ✅ | |
| physical_verification | physical_inventory | ✅ | ✅ | |
| physical_verification | reorder_policy | ✅ | ✅ | |
| physical_verification | replenishment_order | ✅ | ✅ | |
| physical_verification | sku_pricing | ✅ | ❌ | |
| physical_verification | snapshot | ✅ | ❌ | |
| stock_management | stock_adjustment | ✅ | ✅ | |
| stock_management | stock_position | ✅ | ❌ | |
| stock_management | stock_transfer | ✅ | ✅ | |
| stock_management | transaction | ✅ | ✅ | |
| warehouse_operations | handling_unit | ✅ | ❌ | |
| warehouse_operations | pick_task | ✅ | ❌ | |
| warehouse_operations | putaway_task | ✅ | ❌ | |
| warehouse_operations | storage_location | ✅ | ❌ | |
| warehouse_operations | warehouse_carrier_agreement | ✅ | ❌ | |

</details>

<a id="domain-logistics"></a>
<details>
<summary><b>logistics</b> — Carrier Management, Freight Execution, Network Planning</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| carrier_management | carrier | ✅ | ✅ | |
| carrier_management | carrier_performance | ✅ | ❌ | |
| carrier_management | carrier_qualification | ✅ | ❌ | |
| carrier_management | carrier_service | ✅ | ✅ | |
| carrier_management | carrier_service_agreement | ✅ | ❌ | |
| carrier_management | carrier_territory_coverage | ✅ | ❌ | |
| carrier_management | freight_contract | ✅ | ✅ | |
| carrier_management | freight_rate | ✅ | ✅ | |
| financial_settlement | freight_audit | ✅ | ❌ | |
| financial_settlement | freight_claim | ✅ | ❌ | |
| financial_settlement | freight_invoice | ✅ | ✅ | |
| freight_execution | delivery | ✅ | ✅ | |
| freight_execution | delivery_performance | ✅ | ❌ | |
| freight_execution | freight_order | ✅ | ✅ | |
| freight_execution | load_unit | ✅ | ❌ | |
| freight_execution | logistics_inbound_delivery | ✅ | ❌ | |
| freight_execution | shipment_exception | ✅ | ❌ | |
| freight_execution | shipment_item | ✅ | ✅ | |
| freight_execution | tracking_event | ✅ | ✅ | |
| freight_execution | transport_plan | ✅ | ✅ | |
| network_planning | location | ✅ | ❌ | |
| network_planning | packaging | ✅ | ✅ | |
| network_planning | parts_inventory_position | ✅ | ❌ | |
| network_planning | route | ✅ | ✅ | |
| network_planning | route_stop | ✅ | ✅ | |
| network_planning | route_supplier_pickup | ✅ | ❌ | |
| network_planning | transport_zone | ✅ | ❌ | |
| shipment_delivery | inbound_delivery | ❌ | ✅ | MVM only |
| trade_compliance | customs_declaration | ✅ | ❌ | |
| trade_compliance | dangerous_goods_declaration | ✅ | ❌ | |
| trade_compliance | trade_document | ✅ | ❌ | |

</details>

<a id="domain-order"></a>
<details>
<summary><b>order</b> — Order Execution, Fulfillment, Quotation Management</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| contract_administration | blanket_order | ✅ | ✅ | |
| contract_administration | blanket_order_line | ✅ | ❌ | |
| contract_administration | channel | ✅ | ✅ | |
| contract_administration | service_coverage | ✅ | ❌ | |
| fulfillment_logistics | credit_check | ✅ | ✅ | |
| fulfillment_logistics | export_control_check | ✅ | ❌ | |
| fulfillment_logistics | fulfillment_mode | ✅ | ❌ | |
| fulfillment_logistics | fulfillment_plan | ✅ | ✅ | |
| fulfillment_logistics | goods_issue | ✅ | ✅ | |
| fulfillment_logistics | returns_order | ✅ | ❌ | |
| order_execution | amendment | ✅ | ❌ | |
| order_execution | atp_commitment | ✅ | ✅ | |
| order_execution | customer_po | ✅ | ❌ | |
| order_execution | line_item | ✅ | ❌ | |
| order_execution | order_block | ✅ | ❌ | |
| order_execution | order_configuration | ✅ | ✅ | |
| order_execution | order_confirmation | ✅ | ✅ | |
| order_execution | priority | ✅ | ✅ | |
| order_execution | schedule_line | ✅ | ✅ | |
| order_execution | status_history | ✅ | ✅ | |
| order_execution | text | ✅ | ❌ | |
| quotation_management | order_quotation | ✅ | ❌ | |
| quotation_management | pricing_condition | ✅ | ✅ | |
| quotation_management | quotation | ❌ | ✅ | MVM only |
| quotation_management | quotation_line_item | ✅ | ✅ | |
| quotation_management | rfq_request | ✅ | ✅ | |

</details>

<a id="domain-procurement"></a>
<details>
<summary><b>procurement</b> — Demand Planning, Order Execution, Strategic Sourcing, Supplier Management</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| demand_planning | demand_forecast | ✅ | ✅ | |
| demand_planning | mrp_planned_order | ✅ | ✅ | |
| demand_planning | mrp_run | ✅ | ✅ | |
| demand_planning | supply_network_node | ✅ | ❌ | |
| order_execution | delivery_schedule | ✅ | ✅ | |
| order_execution | goods_receipt | ✅ | ❌ | |
| order_execution | goods_receipt_line | ✅ | ❌ | |
| order_execution | incoterm | ✅ | ❌ | |
| order_execution | po_change_record | ✅ | ❌ | |
| order_execution | po_compliance_verification | ✅ | ❌ | |
| order_execution | po_line_item | ✅ | ❌ | |
| order_execution | procurement_goods_receipt | ✅ | ❌ | |
| order_execution | procurement_inbound_delivery | ✅ | ❌ | |
| order_execution | procurement_payment_term | ✅ | ❌ | |
| order_execution | procurement_po_line_item | ✅ | ❌ | |
| order_execution | procurement_purchase_requisition | ✅ | ❌ | |
| order_execution | procurement_supplier_invoice | ✅ | ❌ | |
| order_execution | purchase_order | ✅ | ❌ | |
| order_execution | purchase_order_amendment | ✅ | ❌ | |
| order_execution | purchase_requisition | ✅ | ✅ | |
| order_execution | purchase_requisition_approval | ✅ | ❌ | |
| order_execution | supplier_invoice | ✅ | ✅ | |
| performance_analytics | procurement_policy | ✅ | ❌ | |
| performance_analytics | procurement_spend_category | ✅ | ❌ | |
| performance_analytics | procurement_supplier_performance | ✅ | ❌ | |
| performance_analytics | savings_initiative | ✅ | ❌ | |
| performance_analytics | spend_category | ✅ | ✅ | |
| performance_analytics | spend_transaction | ✅ | ❌ | |
| performance_analytics | supplier_performance | ✅ | ❌ | |
| performance_analytics | supplier_risk | ✅ | ❌ | |
| performance_analytics | supply_risk | ✅ | ❌ | |
| strategic_sourcing | contract_line_item | ✅ | ❌ | |
| strategic_sourcing | mro_catalog | ✅ | ❌ | |
| strategic_sourcing | procurement_contract | ✅ | ❌ | |
| strategic_sourcing | procurement_material_info_record | ✅ | ❌ | |
| strategic_sourcing | procurement_sourcing_bid | ✅ | ❌ | |
| strategic_sourcing | procurement_sourcing_event | ✅ | ❌ | |
| strategic_sourcing | procurement_supply_agreement | ✅ | ❌ | |
| strategic_sourcing | quota_arrangement | ✅ | ✅ | |
| strategic_sourcing | source_list | ✅ | ✅ | |
| strategic_sourcing | sourcing_award | ✅ | ❌ | |
| strategic_sourcing | sourcing_bid | ✅ | ❌ | |
| strategic_sourcing | sourcing_event | ✅ | ❌ | |
| supplier_management | preferred_supplier | ❌ | ✅ | MVM only |
| supplier_management | preferred_supplier_list | ✅ | ✅ | |
| supplier_management | procurement_supplier_contact | ✅ | ❌ | |
| supplier_management | procurement_supplier_qualification | ✅ | ❌ | |
| supplier_management | supplier | ✅ | ❌ | |
| supplier_management | supplier_audit | ✅ | ❌ | |
| supplier_management | supplier_certificate | ✅ | ❌ | |
| supplier_management | supplier_certification | ✅ | ❌ | |
| supplier_management | supplier_collaboration | ✅ | ❌ | |
| supplier_management | supplier_compliance | ✅ | ❌ | |
| supplier_management | supplier_contact | ✅ | ❌ | |
| supplier_management | supplier_control_plan_approval | ✅ | ❌ | |
| supplier_management | supplier_qualification | ✅ | ❌ | |
| supplier_management | supplier_service_contract | ✅ | ❌ | |
| supplier_management | supply_agreement | ❌ | ✅ | MVM only |

</details>

<a id="domain-product"></a>
<details>
<summary><b>product</b> — Catalog, Pricing, Distribution, Regulatory Compliance</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| catalog_structure | attribute | ✅ | ❌ | |
| catalog_structure | category | ✅ | ❌ | |
| catalog_structure | classification | ✅ | ✅ | |
| catalog_structure | hierarchy | ✅ | ✅ | |
| catalog_structure | lifecycle | ✅ | ❌ | |
| catalog_structure | product_configuration | ✅ | ❌ | |
| catalog_structure | substitution | ✅ | ✅ | |
| catalog_structure | uom | ✅ | ❌ | |
| commercial_pricing | bundle | ✅ | ❌ | |
| commercial_pricing | bundle_component | ✅ | ❌ | |
| commercial_pricing | discount_schedule | ✅ | ❌ | |
| commercial_pricing | document | ❌ | ✅ | MVM only |
| commercial_pricing | price_list_item | ✅ | ✅ | |
| commercial_pricing | product_price_list | ✅ | ❌ | |
| commercial_pricing | warranty_policy | ✅ | ❌ | |
| compliance_safety | regulatory_certification | ❌ | ✅ | MVM only |
| distribution_operations | aftermarket_part | ✅ | ✅ | |
| distribution_operations | market | ✅ | ❌ | |
| distribution_operations | partner_authorization | ✅ | ❌ | |
| distribution_operations | product_material_info_record | ✅ | ❌ | |
| distribution_operations | product_plant | ✅ | ❌ | |
| distribution_operations | quality_specification | ✅ | ❌ | |
| distribution_operations | sales_org | ✅ | ❌ | |
| information_management | change_notice | ✅ | ❌ | |
| information_management | launch | ✅ | ❌ | |
| information_management | media | ✅ | ❌ | |
| information_management | product_document | ✅ | ❌ | |
| regulatory_compliance | compliance | ✅ | ❌ | |
| regulatory_compliance | hazardous_substance | ✅ | ✅ | |
| regulatory_compliance | market_authorization | ✅ | ❌ | |
| regulatory_compliance | product_regulatory_certification | ✅ | ❌ | |
| regulatory_compliance | substance_declaration | ✅ | ❌ | |

</details>

<a id="domain-production"></a>
<details>
<summary><b>production</b> — Order Execution, Equipment Performance, Quality Traceability, Resource Planning</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| equipment_performance | changeover | ✅ | ❌ | |
| equipment_performance | downtime_event | ✅ | ✅ | |
| equipment_performance | iiot_machine_signal | ✅ | ❌ | |
| equipment_performance | oee_event | ✅ | ❌ | |
| equipment_performance | work_center_supplier_service | ✅ | ❌ | |
| order_execution | bom_explosion | ✅ | ❌ | |
| order_execution | cost_estimate | ✅ | ❌ | |
| order_execution | hold | ✅ | ❌ | |
| order_execution | material_staging | ✅ | ✅ | |
| order_execution | operation | ✅ | ❌ | |
| order_execution | order_status | ✅ | ✅ | |
| order_execution | production_confirmation | ✅ | ✅ | |
| order_execution | shop_order_operation | ✅ | ✅ | |
| quality_traceability | batch | ✅ | ✅ | |
| quality_traceability | batch_genealogy | ✅ | ✅ | |
| quality_traceability | line_permit_coverage | ✅ | ❌ | |
| quality_traceability | line_qualification | ✅ | ❌ | |
| quality_traceability | plant_supplier_qualification | ✅ | ❌ | |
| quality_traceability | scrap_record | ✅ | ✅ | |
| resource_planning | capacity_requirement | ✅ | ✅ | |
| resource_planning | order_type | ✅ | ✅ | |
| resource_planning | planned_order | ✅ | ✅ | |
| resource_planning | routing | ✅ | ✅ | |
| resource_planning | routing_operation | ✅ | ✅ | |
| resource_planning | schedule | ✅ | ✅ | |
| resource_planning | shift | ✅ | ✅ | |
| resource_planning | takt_time_standard | ✅ | ❌ | |
| resource_planning | version | ✅ | ✅ | |
| resource_planning | work_center | ✅ | ✅ | |

</details>

<a id="domain-quality"></a>
<details>
<summary><b>quality</b> — Inspection, Issue Resolution, Product Validation, Risk Planning</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| defect_management | capa | ❌ | ✅ | MVM only |
| inspection_management | inspection_lot | ✅ | ✅ | |
| inspection_management | inspection_plan | ✅ | ✅ | |
| inspection_management | inspection_result | ✅ | ✅ | |
| inspection_management | plan_characteristic | ✅ | ❌ | |
| inspection_management | usage_decision | ✅ | ✅ | |
| issue_resolution | customer_complaint | ✅ | ✅ | |
| issue_resolution | defect_code | ✅ | ✅ | |
| issue_resolution | quality_capa | ✅ | ❌ | |
| issue_resolution | quality_notification | ✅ | ✅ | |
| issue_resolution | scrap_rework_transaction | ✅ | ❌ | |
| issue_resolution | supplier_quality_event | ✅ | ❌ | |
| product_validation | apqp_deliverable | ✅ | ❌ | |
| product_validation | apqp_plan | ✅ | ❌ | |
| product_validation | apqp_project | ✅ | ❌ | |
| product_validation | fai_record | ✅ | ✅ | |
| product_validation | ppap_submission | ✅ | ✅ | |
| product_validation | project_team_member | ✅ | ❌ | |
| risk_planning | audit | ✅ | ❌ | |
| risk_planning | certificate | ✅ | ✅ | |
| risk_planning | characteristic | ✅ | ✅ | |
| risk_planning | control_plan | ✅ | ✅ | |
| risk_planning | fmea | ✅ | ✅ | |
| risk_planning | fmea_action | ✅ | ❌ | |
| risk_planning | gauge | ✅ | ✅ | |
| risk_planning | gauge_calibration | ✅ | ✅ | |
| risk_planning | gauge_loan | ✅ | ❌ | |
| risk_planning | measurement_capability | ✅ | ❌ | |
| risk_planning | msa_study | ✅ | ❌ | |
| risk_planning | qms_document | ✅ | ❌ | |
| risk_planning | quality_audit_finding | ✅ | ❌ | |
| risk_planning | spc_chart | ✅ | ✅ | |
| risk_planning | spc_sample | ✅ | ✅ | |

</details>

<a id="domain-research"></a>
<details>
<summary><b>research</b> — R&D, Collaboration, Intellectual Property, Prototyping <i>(ECM only)</i></summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| collaboration_funding | collaboration_agreement | ✅ | ❌ | ECM only domain |
| collaboration_funding | grant_funding | ✅ | ❌ | ECM only domain |
| collaboration_funding | partner | ✅ | ❌ | ECM only domain |
| collaboration_funding | project_partner_assignment | ✅ | ❌ | ECM only domain |
| collaboration_funding | rd_budget | ✅ | ❌ | ECM only domain |
| collaboration_funding | rd_expense | ✅ | ❌ | ECM only domain |
| intellectual_property | ip_asset | ✅ | ❌ | ECM only domain |
| intellectual_property | patent_filing | ✅ | ❌ | ECM only domain |
| intellectual_property | project_certification | ✅ | ❌ | ECM only domain |
| portfolio_strategy | competitive_intelligence | ✅ | ❌ | ECM only domain |
| portfolio_strategy | innovation_pipeline | ✅ | ❌ | ECM only domain |
| portfolio_strategy | rd_risk | ✅ | ❌ | ECM only domain |
| portfolio_strategy | stage_gate_review | ✅ | ❌ | ECM only domain |
| portfolio_strategy | technology_readiness | ✅ | ❌ | ECM only domain |
| portfolio_strategy | technology_roadmap | ✅ | ❌ | ECM only domain |
| prototype_development | experimental_bom | ✅ | ❌ | ECM only domain |
| prototype_development | experimental_bom_line | ✅ | ❌ | ECM only domain |
| prototype_development | prototype_asset_allocation | ✅ | ❌ | ECM only domain |
| prototype_development | prototype_sourcing | ✅ | ❌ | ECM only domain |
| prototype_development | research_prototype | ✅ | ❌ | ECM only domain |
| validation_testing | lab_booking | ✅ | ❌ | ECM only domain |
| validation_testing | lab_resource | ✅ | ❌ | ECM only domain |
| validation_testing | rd_document | ✅ | ❌ | ECM only domain |
| validation_testing | rd_milestone | ✅ | ❌ | ECM only domain |
| validation_testing | rd_test_plan | ✅ | ❌ | ECM only domain |
| validation_testing | rd_test_result | ✅ | ❌ | ECM only domain |

</details>

<a id="domain-sales"></a>
<details>
<summary><b>sales</b> — Opportunity Management, Partner Ecosystem, Pricing, Territory</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| compensation_incentives | commission_plan | ✅ | ❌ | |
| compensation_incentives | commission_record | ✅ | ❌ | |
| compensation_incentives | rebate_accrual | ✅ | ❌ | |
| compensation_incentives | rebate_agreement | ✅ | ❌ | |
| opportunity_management | account_plan | ✅ | ✅ | |
| opportunity_management | activity | ✅ | ✅ | |
| opportunity_management | campaign | ✅ | ✅ | |
| opportunity_management | competitor | ✅ | ✅ | |
| opportunity_management | forecast | ✅ | ✅ | |
| opportunity_management | lead | ✅ | ✅ | |
| opportunity_management | opportunity_competitor | ✅ | ✅ | |
| opportunity_management | opportunity_line | ✅ | ❌ | |
| opportunity_management | opportunity_stage_history | ✅ | ❌ | |
| opportunity_management | opportunity_supplier_sourcing | ✅ | ❌ | |
| opportunity_management | service_inclusion | ✅ | ❌ | |
| opportunity_management | team | ✅ | ✅ | |
| opportunity_management | win_loss_record | ✅ | ❌ | |
| partner_ecosystem | channel_partner_program | ✅ | ❌ | |
| partner_ecosystem | deal_registration | ✅ | ❌ | |
| partner_ecosystem | partner_certification | ✅ | ❌ | |
| partner_ecosystem | partner_rd_collaboration | ✅ | ❌ | |
| partner_ecosystem | partner_supplier_relationship | ✅ | ❌ | |
| partner_ecosystem | partner_territory_authorization | ✅ | ❌ | |
| pricing_discounts | discount_structure | ✅ | ✅ | |
| pricing_discounts | sales_price_list | ✅ | ❌ | |
| pricing_discounts | special_pricing_request | ✅ | ❌ | |
| territory_administration | quota | ✅ | ✅ | |
| territory_administration | sales_territory | ✅ | ❌ | |
| territory_administration | territory_assignment | ✅ | ✅ | |

</details>

<a id="domain-service"></a>
<details>
<summary><b>service</b> — Contracts, Customer Support, Field Operations, Parts Inventory</summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| contract_management | contract_line | ✅ | ✅ | |
| contract_management | entitlement | ✅ | ✅ | |
| contract_management | service_invoice | ✅ | ❌ | |
| contract_management | service_price_list | ✅ | ❌ | |
| contract_management | service_quotation | ✅ | ❌ | |
| contract_management | sla_commitment | ✅ | ✅ | |
| contract_management | sla_tracking | ✅ | ✅ | |
| customer_support | escalation | ✅ | ❌ | |
| customer_support | feedback | ✅ | ❌ | |
| customer_support | nps_survey | ✅ | ❌ | |
| customer_support | product_return | ✅ | ❌ | |
| customer_support | remote_support_session | ✅ | ❌ | |
| customer_support | request | ✅ | ✅ | |
| customer_support | warranty_claim | ✅ | ✅ | |
| field_operations | dispatch_schedule | ✅ | ✅ | |
| field_operations | installation_record | ✅ | ✅ | |
| field_operations | report | ✅ | ✅ | |
| field_operations | service_territory | ✅ | ✅ | |
| field_operations | technician | ✅ | ✅ | |
| parts_inventory | knowledge_article | ✅ | ✅ | |
| parts_inventory | spare_parts_catalog | ✅ | ✅ | |
| parts_inventory | spare_parts_request | ✅ | ✅ | |

</details>

<a id="domain-shared"></a>
<details>
<summary><b>shared</b> — Cross-domain reference tables <i>(MVM only)</i></summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| commercial_operations | account_hierarchy | ❌ | ✅ | In ECM under: customer |
| commercial_operations | address | ❌ | ✅ | In ECM under: customer |
| commercial_operations | asset_bom | ❌ | ✅ | In ECM under: asset |
| commercial_operations | category | ❌ | ✅ | In ECM under: product |
| commercial_operations | contact | ❌ | ✅ | In ECM under: customer |
| commercial_operations | failure_record | ❌ | ✅ | In ECM under: asset |
| commercial_operations | installed_base | ❌ | ✅ | In ECM under: customer |
| commercial_operations | lifecycle | ❌ | ✅ | In ECM under: product |
| commercial_operations | line_item | ❌ | ✅ | In ECM under: order |
| commercial_operations | lot_batch | ❌ | ✅ | In ECM under: inventory |
| commercial_operations | plant | ❌ | ✅ | MVM only |
| commercial_operations | pricing_agreement | ❌ | ✅ | In ECM under: customer |
| commercial_operations | product_configuration | ❌ | ✅ | In ECM under: product |
| commercial_operations | product_price_list | ❌ | ✅ | In ECM under: product |
| commercial_operations | returns_order | ❌ | ✅ | In ECM under: order |
| commercial_operations | sales_org | ❌ | ✅ | In ECM under: product |
| commercial_operations | sales_price_list | ❌ | ✅ | In ECM under: sales |
| commercial_operations | sales_territory | ❌ | ✅ | In ECM under: sales |
| commercial_operations | segment | ❌ | ✅ | In ECM under: customer |
| commercial_operations | serialized_unit | ❌ | ✅ | In ECM under: inventory |
| commercial_operations | sla_agreement | ❌ | ✅ | In ECM under: customer |
| commercial_operations | stock_position | ❌ | ✅ | In ECM under: inventory |
| commercial_operations | storage_location | ❌ | ✅ | In ECM under: inventory |
| commercial_operations | uom | ❌ | ✅ | In ECM under: product |
| commercial_operations | warranty_policy | ❌ | ✅ | In ECM under: product |
| commercial_operations | work_order_operation | ❌ | ✅ | In ECM under: asset |
| financial_controls | ap_invoice | ❌ | ✅ | In ECM under: finance |
| financial_controls | ar_invoice | ❌ | ✅ | In ECM under: finance |
| financial_controls | contract | ❌ | ✅ | In ECM under: workforce |
| financial_controls | controlling_area | ❌ | ✅ | In ECM under: finance |
| financial_controls | cost_allocation | ❌ | ✅ | In ECM under: finance |
| financial_controls | currency_exchange_rate | ❌ | ✅ | In ECM under: finance |
| financial_controls | fiscal_period | ❌ | ✅ | In ECM under: finance |
| financial_controls | goods_receipt | ❌ | ✅ | In ECM under: procurement |
| financial_controls | location | ❌ | ✅ | In ECM under: logistics |
| financial_controls | product_cost_estimate | ❌ | ✅ | In ECM under: finance |
| financial_controls | production_order_cost | ❌ | ✅ | In ECM under: finance |
| financial_controls | profitability_segment | ❌ | ✅ | In ECM under: finance |
| financial_controls | purchase_order | ❌ | ✅ | In ECM under: procurement |
| financial_controls | supplier | ❌ | ✅ | In ECM under: procurement |
| financial_controls | tax_code | ❌ | ✅ | In ECM under: finance |
| product_engineering | approved_manufacturer | ❌ | ✅ | In ECM under: engineering |
| product_engineering | bop | ❌ | ✅ | In ECM under: engineering |
| product_engineering | drawing | ❌ | ✅ | In ECM under: engineering |
| product_engineering | ecn | ❌ | ✅ | In ECM under: engineering |
| product_engineering | engineering_bom | ❌ | ✅ | In ECM under: engineering |
| product_engineering | material_specification | ❌ | ✅ | In ECM under: engineering |
| product_engineering | product_specification | ❌ | ✅ | In ECM under: engineering |
| product_engineering | product_variant | ❌ | ✅ | In ECM under: engineering |
| product_engineering | tooling_equipment | ❌ | ✅ | In ECM under: engineering |

</details>

<a id="domain-technology"></a>
<details>
<summary><b>technology</b> — IT Infrastructure, Portfolio, Security, Service Operations <i>(ECM only)</i></summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| infrastructure_assets | data_integration | ✅ | ❌ | ECM only domain |
| infrastructure_assets | network_device | ✅ | ❌ | ECM only domain |
| infrastructure_assets | software_license | ✅ | ❌ | ECM only domain |
| infrastructure_assets | standard | ✅ | ❌ | ECM only domain |
| portfolio_management | digital_initiative | ✅ | ❌ | ECM only domain |
| portfolio_management | iiot_platform | ✅ | ❌ | ECM only domain |
| portfolio_management | it_project | ✅ | ❌ | ECM only domain |
| portfolio_management | it_project_milestone | ✅ | ❌ | ECM only domain |
| security_compliance | it_risk | ✅ | ❌ | ECM only domain |
| security_compliance | patch_record | ✅ | ❌ | ECM only domain |
| security_compliance | vulnerability | ✅ | ❌ | ECM only domain |
| service_operations | configuration_item | ✅ | ❌ | ECM only domain |
| service_operations | it_service | ✅ | ❌ | ECM only domain |
| service_operations | it_service_outage | ✅ | ❌ | ECM only domain |
| service_operations | service_ticket | ✅ | ❌ | ECM only domain |
| service_operations | sla_definition | ✅ | ❌ | ECM only domain |
| service_operations | sla_performance | ✅ | ❌ | ECM only domain |
| service_operations | technology_change_request | ✅ | ❌ | ECM only domain |
| service_operations | user_access_request | ✅ | ❌ | ECM only domain |
| vendor_relations | it_budget | ✅ | ❌ | ECM only domain |
| vendor_relations | it_contract | ✅ | ❌ | ECM only domain |
| vendor_relations | it_cost_allocation | ✅ | ❌ | ECM only domain |
| vendor_relations | it_vendor | ✅ | ❌ | ECM only domain |

</details>

<a id="domain-workforce"></a>
<details>
<summary><b>workforce</b> — HR, Attendance, Training, Personnel, Resource Allocation <i>(ECM only)</i></summary>

| Subdomain | Product | ECM | MVM | Notes |
|:---|:---|:---:|:---:|:---|
| attendance_operations | absence_record | ✅ | ❌ | ECM only domain |
| attendance_operations | labor_cost_entry | ✅ | ❌ | ECM only domain |
| attendance_operations | labor_standard | ✅ | ❌ | ECM only domain |
| attendance_operations | overtime_request | ✅ | ❌ | ECM only domain |
| attendance_operations | pay_period | ✅ | ❌ | ECM only domain |
| attendance_operations | payroll_result | ✅ | ❌ | ECM only domain |
| attendance_operations | shift_definition | ✅ | ❌ | ECM only domain |
| attendance_operations | shift_schedule | ✅ | ❌ | ECM only domain |
| attendance_operations | time_entry | ✅ | ❌ | ECM only domain |
| attendance_operations | work_permit | ✅ | ❌ | ECM only domain |
| development_training | certification | ✅ | ❌ | ECM only domain |
| development_training | employee_certification | ✅ | ❌ | ECM only domain |
| development_training | employee_skill | ✅ | ❌ | ECM only domain |
| development_training | performance_goal | ✅ | ❌ | ECM only domain |
| development_training | performance_review | ✅ | ❌ | ECM only domain |
| development_training | skill | ✅ | ❌ | ECM only domain |
| development_training | training_completion | ✅ | ❌ | ECM only domain |
| development_training | training_course | ✅ | ❌ | ECM only domain |
| development_training | training_record | ✅ | ❌ | ECM only domain |
| personnel_management | disciplinary_action | ✅ | ❌ | ECM only domain |
| personnel_management | employee | ✅ | ❌ | ECM only domain |
| personnel_management | employee_transfer | ✅ | ❌ | ECM only domain |
| personnel_management | grievance | ✅ | ❌ | ECM only domain |
| personnel_management | headcount_plan | ✅ | ❌ | ECM only domain |
| personnel_management | job_position | ✅ | ❌ | ECM only domain |
| personnel_management | labor_classification | ✅ | ❌ | ECM only domain |
| personnel_management | org_unit | ✅ | ❌ | ECM only domain |
| personnel_management | position_assignment | ✅ | ❌ | ECM only domain |
| personnel_management | union_agreement | ✅ | ❌ | ECM only domain |
| regulatory_compliance | capa_record | ✅ | ❌ | ECM only domain |
| regulatory_compliance | compliance_reach_substance_declaration | ✅ | ❌ | ECM only domain |
| regulatory_compliance | compliance_record | ✅ | ❌ | ECM only domain |
| regulatory_compliance | export_classification | ✅ | ❌ | ECM only domain |
| regulatory_compliance | product_certification | ✅ | ❌ | ECM only domain |
| regulatory_compliance | regulatory_requirement | ✅ | ❌ | ECM only domain |
| resource_allocation | account | ✅ | ❌ | ECM only domain |
| resource_allocation | application | ✅ | ❌ | ECM only domain |
| resource_allocation | asset_register | ✅ | ❌ | ECM only domain |
| resource_allocation | billing_invoice | ✅ | ❌ | ECM only domain |
| resource_allocation | business_unit | ✅ | ❌ | ECM only domain |
| resource_allocation | catalog_item | ✅ | ❌ | ECM only domain |
| resource_allocation | channel_partner | ✅ | ❌ | ECM only domain |
| resource_allocation | component | ✅ | ❌ | ECM only domain |
| resource_allocation | contract | ✅ | ❌ | ECM only domain |
| resource_allocation | cost_center | ✅ | ❌ | ECM only domain |
| resource_allocation | delivery_order | ✅ | ❌ | ECM only domain |
| resource_allocation | equipment | ✅ | ❌ | ECM only domain |
| resource_allocation | field_service_order | ✅ | ❌ | ECM only domain |
| resource_allocation | functional_location | ✅ | ❌ | ECM only domain |
| resource_allocation | gl_account | ✅ | ❌ | ECM only domain |
| resource_allocation | internal_order | ✅ | ❌ | ECM only domain |
| resource_allocation | inventory_sku | ✅ | ❌ | ECM only domain |
| resource_allocation | it_asset | ✅ | ❌ | ECM only domain |
| resource_allocation | legal_entity | ✅ | ❌ | ECM only domain |
| resource_allocation | line | ✅ | ❌ | ECM only domain |
| resource_allocation | ncr | ✅ | ❌ | ECM only domain |
| resource_allocation | order | ✅ | ❌ | ECM only domain |
| resource_allocation | ot_system | ✅ | ❌ | ECM only domain |
| resource_allocation | procurement_purchase_order | ✅ | ❌ | ECM only domain |
| resource_allocation | procurement_supplier | ✅ | ❌ | ECM only domain |
| resource_allocation | product_sku | ✅ | ❌ | ECM only domain |
| resource_allocation | production_plant | ✅ | ❌ | ECM only domain |
| resource_allocation | profit_center | ✅ | ❌ | ECM only domain |
| resource_allocation | project_assignment | ✅ | ❌ | ECM only domain |
| resource_allocation | rd_project | ✅ | ❌ | ECM only domain |
| resource_allocation | sales_opportunity | ✅ | ❌ | ECM only domain |
| resource_allocation | sales_order | ✅ | ❌ | ECM only domain |
| resource_allocation | shipment | ✅ | ❌ | ECM only domain |
| resource_allocation | spare_part | ✅ | ❌ | ECM only domain |
| resource_allocation | warehouse | ✅ | ❌ | ECM only domain |
| resource_allocation | work_order | ✅ | ❌ | ECM only domain |

</details>

---

<div align="center">

*Generated by the [Vibe Modelling Agent](../../readme.md) — describe your business, get a data model, vibe it until it's perfect.*

</div>
