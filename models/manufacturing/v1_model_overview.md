# Manufacturing Lakehouse Data Models

**Version 1** | Generated on April 16, 2026 at 09:51 AM

**Industry:** Industrial Manufacturing

## Business Description

Industrial Manufacturing encompasses the design, production, and delivery of automation systems, electrification solutions, and smart infrastructure components for factories, buildings, transportation, and urban environments.

## Model Scope Variations

This data model is available in **two scope variations** — the **MVM (Minimum Viable Model)** and the **ECM (Expanded Coverage Model)** — each designed for different organizational needs and use cases. Both models share the same attribute depth per table; the difference is in breadth (number of domains and tables).

### MVM (Minimum Viable Model) — `v1_mvm`

The **MVM** is a production-ready, core data model that covers all essential business functions with full attribute depth. It is the recommended starting point for organizations that want to deploy quickly and expand incrementally. The MVM is ideal for:

- **Small-to-Mid Businesses** — A thin, efficient model for organizations that need a complete but focused data platform without the overhead of corporate back-office domains
- **Production-Ready Foundation** — Deploy to production from day one and grow by adding domains as business needs evolve
- **Proof-of-Concept & Demos** — Quick deployment for stakeholder presentations and proof-of-concept engagements
- **Targeted Analytics** — Focused analytical workloads centered on core business processes
- **Rapid Onboarding** — Simplified structure for teams getting started with the data platform
- **Development & Testing** — Lightweight model for development environments and integration testing

The MVM prioritizes **Operations** and **Business** division domains, excludes corporate/back-office functions, minimizes association (many-to-many bridge) tables, and relies on direct foreign key relationships for simplicity. Every table in the MVM has the **same attribute depth** as the ECM.

### ECM (Expanded Coverage Model) — `v1_ecm`

The **ECM** is a comprehensive, full-coverage data model that covers the complete breadth of business operations, including corporate functions, detailed audit trails, association tables, and granular reference data. It is designed for:

- **Large Organizations & Multinationals** — Complete data platform for Fortune 100-class organizations with global operations
- **Full-Coverage Data Warehousing** — Lakehouse model supporting all business units and divisions
- **Regulatory & Compliance** — Includes audit, legal, and compliance domains required for governance
- **Cross-Functional Analytics** — Enables analysis across all divisions including HR, Finance, IT, and more

The ECM includes all domains from the MVM plus additional **Corporate/Supporting** division domains, many-to-many association tables, helper/lookup tables, and expanded attribute coverage.


## Head-to-Head Comparison

| Dimension | MVM (Minimum Viable Model) | ECM (Expanded Coverage Model) |
|---|---|---|
| **Folder Convention** | `v1_mvm` | `v1_ecm` |
| **Target Organization** | Small-to-mid businesses, startups, focused teams | Large organizations, multinationals, Fortune 100 |
| **Domain Coverage** | Core operations + business domains | All domains including corporate back-office |
| **Divisions Included** | Operations, Business | Operations, Business, Corporate |
| **Attribute Depth** | Full (same as ECM) | Full |
| **M:N Associations** | Minimized (direct FKs preferred) | Comprehensive junction tables |
| **Growth Path** | Start here, enlarge to ECM as needed | Complete from day one |
| **Best For** | Quick production deployments, focused analytics, POC, growing businesses | Organization-wide analytics, compliance, global operations |

## Model Metrics Comparison

| Metric | MVM (Minimum Viable Model) | ECM (Expanded Coverage Model) |
|---|---|---|
| Domains | 14 | 19 |
| Subdomains | 40 | 80 |
| Products (Tables) | 205 | 603 |
| Attributes (Columns) | 8131 | 22905 |
| Foreign Keys | 1036 | 2775 |
| Avg Attributes/Product | 39.7 | 38.0 |

## Domain & Product Comparison

| Domain | Subdomain | Product | ECM | MVM (Minimum Viable Model) | Notes |
|---|---|---|:---:|:---:|---|
| **asset** | contract_administration | asset_supply_agreement | ✅ | ❌ | Excluded from MVM |
|  | contract_administration | contract_risk_assessment | ✅ | ❌ | Excluded from MVM |
|  | contract_administration | control_implementation | ✅ | ❌ | Excluded from MVM |
|  | contract_administration | equipment_certification | ✅ | ❌ | Excluded from MVM |
|  | contract_administration | equipment_compliance | ✅ | ❌ | Excluded from MVM |
|  | contract_administration | equipment_contract_coverage | ✅ | ❌ | Excluded from MVM |
|  | contract_administration | equipment_service_contract | ✅ | ❌ | Excluded from MVM |
|  | contract_administration | service_contract | ✅ | ✅ |  |
|  | contract_administration | warranty | ✅ | ✅ |  |
|  | equipment_registry | asset_bom | ✅ | ❌ | Excluded from MVM |
|  | equipment_registry | asset_document | ✅ | ❌ | Excluded from MVM |
|  | equipment_registry | class | ✅ | ✅ |  |
|  | equipment_registry | equipment_allocation | ✅ | ❌ | Excluded from MVM |
|  | equipment_registry | lifecycle_event | ✅ | ❌ | Excluded from MVM |
|  | financial_planning | asset_valuation | ✅ | ✅ |  |
|  | financial_planning | capex_request | ✅ | ❌ | Excluded from MVM |
|  | maintenance_operations | asset_notification | ✅ | ✅ |  |
|  | maintenance_operations | maintenance_item | ✅ | ✅ |  |
|  | maintenance_operations | maintenance_plan | ✅ | ✅ |  |
|  | maintenance_operations | permit_to_work | ✅ | ❌ | Excluded from MVM |
|  | maintenance_operations | shutdown_plan | ✅ | ❌ | Excluded from MVM |
|  | maintenance_operations | task_list | ✅ | ✅ |  |
|  | maintenance_operations | work_order_operation | ✅ | ❌ | Excluded from MVM |
|  | performance_monitoring | calibration_record | ✅ | ✅ |  |
|  | performance_monitoring | condition_assessment | ✅ | ❌ | Excluded from MVM |
|  | performance_monitoring | failure_record | ✅ | ❌ | Excluded from MVM |
|  | performance_monitoring | iiot_asset_telemetry | ✅ | ❌ | Excluded from MVM |
|  | performance_monitoring | measurement_point | ✅ | ✅ |  |
|  | performance_monitoring | measurement_reading | ✅ | ✅ |  |
|  | performance_monitoring | predictive_alert | ✅ | ❌ | Excluded from MVM |
|  | performance_monitoring | reliability_record | ✅ | ❌ | Excluded from MVM |
|  | service_coverage | contract_coverage | ❌ | ✅ | MVM only (stub or new) |
| **billing** | invoice_management | billing_block | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | condition | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | credit_note | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | debit_note | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | document_output | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | intercompany_invoice | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | invoice_dispute | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | invoice_line_item | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | invoice_service_line | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | invoice_status_history | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | proforma_invoice | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | run | ✅ | ❌ | Domain not in MVM |
|  | invoice_management | type | ✅ | ❌ | Domain not in MVM |
|  | payment_collections | accounts_receivable_position | ✅ | ❌ | Domain not in MVM |
|  | payment_collections | dunning_record | ✅ | ❌ | Domain not in MVM |
|  | payment_collections | payment_allocation | ✅ | ❌ | Domain not in MVM |
|  | payment_collections | payment_receipt | ✅ | ❌ | Domain not in MVM |
|  | payment_collections | write_off | ✅ | ❌ | Domain not in MVM |
|  | revenue_recognition | billing_payment_term | ✅ | ❌ | Domain not in MVM |
|  | revenue_recognition | performance_obligation | ✅ | ❌ | Domain not in MVM |
|  | revenue_recognition | plan | ✅ | ❌ | Domain not in MVM |
|  | revenue_recognition | plan_milestone | ✅ | ❌ | Domain not in MVM |
|  | revenue_recognition | revenue_recognition_event | ✅ | ❌ | Domain not in MVM |
|  | revenue_recognition | tax_determination | ✅ | ❌ | Domain not in MVM |
| **compliance** | audit_management | assessment | ✅ | ❌ | Domain not in MVM |
|  | audit_management | audit_service_scope | ✅ | ❌ | Domain not in MVM |
|  | audit_management | certification_audit | ✅ | ❌ | Domain not in MVM |
|  | audit_management | compliance_audit_finding | ✅ | ❌ | Domain not in MVM |
|  | audit_management | evidence | ✅ | ❌ | Domain not in MVM |
|  | audit_management | internal_audit | ✅ | ❌ | Domain not in MVM |
|  | policy_governance | compliance_policy | ✅ | ❌ | Domain not in MVM |
|  | policy_governance | exception | ✅ | ❌ | Domain not in MVM |
|  | policy_governance | policy_acknowledgment | ✅ | ❌ | Domain not in MVM |
|  | policy_governance | policy_regulatory_mapping | ✅ | ❌ | Domain not in MVM |
|  | policy_governance | training | ✅ | ❌ | Domain not in MVM |
|  | privacy_protection | cybersecurity_control | ✅ | ❌ | Domain not in MVM |
|  | privacy_protection | cybersecurity_incident | ✅ | ❌ | Domain not in MVM |
|  | privacy_protection | data_privacy_record | ✅ | ❌ | Domain not in MVM |
|  | privacy_protection | data_subject_request | ✅ | ❌ | Domain not in MVM |
|  | privacy_protection | privacy_breach | ✅ | ❌ | Domain not in MVM |
|  | privacy_protection | risk_register | ✅ | ❌ | Domain not in MVM |
|  | privacy_protection | third_party_risk | ✅ | ❌ | Domain not in MVM |
|  | regulatory_oversight | asset_compliance_requirement | ✅ | ❌ | Domain not in MVM |
|  | regulatory_oversight | env_compliance_record | ✅ | ❌ | Domain not in MVM |
|  | regulatory_oversight | jurisdiction | ✅ | ❌ | Domain not in MVM |
|  | regulatory_oversight | obligation | ✅ | ❌ | Domain not in MVM |
|  | regulatory_oversight | regulatory_change | ✅ | ❌ | Domain not in MVM |
|  | regulatory_oversight | regulatory_filing | ✅ | ❌ | Domain not in MVM |
|  | regulatory_oversight | rohs_compliance_record | ✅ | ❌ | Domain not in MVM |
|  | regulatory_oversight | sanctions_screening | ✅ | ❌ | Domain not in MVM |
| **customer** | account_management | account_classification | ✅ | ✅ |  |
|  | account_management | account_contact_role | ✅ | ✅ |  |
|  | account_management | account_document | ✅ | ❌ | Excluded from MVM |
|  | account_management | account_hierarchy | ✅ | ❌ | Excluded from MVM |
|  | account_management | account_status_history | ✅ | ❌ | Excluded from MVM |
|  | account_management | account_team | ✅ | ❌ | Excluded from MVM |
|  | account_management | address | ✅ | ❌ | Excluded from MVM |
|  | account_management | contact | ✅ | ❌ | Excluded from MVM |
|  | account_management | partner_function | ✅ | ✅ |  |
|  | account_management | sales_area_assignment | ✅ | ✅ |  |
|  | account_management | segment | ✅ | ❌ | Excluded from MVM |
|  | commercial_relationships | pricing_coverage_assignment | ❌ | ✅ | MVM only (stub or new) |
|  | compliance_requirements | account_certification_requirement | ✅ | ❌ | Excluded from MVM |
|  | compliance_requirements | account_chemical_approval | ✅ | ❌ | Excluded from MVM |
|  | compliance_requirements | account_regulatory_applicability | ✅ | ❌ | Excluded from MVM |
|  | compliance_requirements | approval | ✅ | ❌ | Excluded from MVM |
|  | compliance_requirements | approved_component_list | ✅ | ❌ | Excluded from MVM |
|  | engagement_tracking | campaign_enrollment | ✅ | ❌ | Excluded from MVM |
|  | engagement_tracking | communication_preference | ✅ | ❌ | Excluded from MVM |
|  | engagement_tracking | consent_record | ✅ | ❌ | Excluded from MVM |
|  | engagement_tracking | contact_system_access | ✅ | ❌ | Excluded from MVM |
|  | engagement_tracking | customer_opportunity | ✅ | ❌ | Excluded from MVM |
|  | engagement_tracking | interaction | ✅ | ❌ | Excluded from MVM |
|  | engagement_tracking | nps_response | ✅ | ❌ | Excluded from MVM |
|  | financial_operations | account_bank_detail | ✅ | ❌ | Excluded from MVM |
|  | financial_operations | account_contract | ✅ | ❌ | Excluded from MVM |
|  | financial_operations | account_payment_term | ✅ | ❌ | Excluded from MVM |
|  | financial_operations | credit_profile | ✅ | ✅ |  |
|  | financial_operations | customer_contract | ✅ | ❌ | Excluded from MVM |
|  | financial_operations | license_entitlement | ✅ | ❌ | Excluded from MVM |
|  | financial_operations | pricing_agreement | ✅ | ❌ | Excluded from MVM |
|  | service_delivery | account_delivery_zone | ✅ | ❌ | Excluded from MVM |
|  | service_delivery | case | ✅ | ❌ | Excluded from MVM |
|  | service_delivery | collaboration | ✅ | ❌ | Excluded from MVM |
|  | service_delivery | installed_base | ✅ | ❌ | Excluded from MVM |
|  | service_delivery | preferred_carrier | ✅ | ❌ | Excluded from MVM |
|  | service_delivery | sla_agreement | ✅ | ❌ | Excluded from MVM |
| **engineering** | change_management | change_affected_item | ✅ | ✅ |  |
|  | change_management | ecn | ✅ | ❌ | Excluded from MVM |
|  | change_management | eco | ✅ | ✅ |  |
|  | change_management | engineering_change_request | ✅ | ❌ | Excluded from MVM |
|  | compliance_tracking | component_carrier_qualification | ✅ | ❌ | Excluded from MVM |
|  | compliance_tracking | component_certification | ✅ | ❌ | Excluded from MVM |
|  | compliance_tracking | component_compliance | ✅ | ❌ | Excluded from MVM |
|  | compliance_tracking | component_evaluation | ✅ | ❌ | Excluded from MVM |
|  | compliance_tracking | component_measurement_plan | ✅ | ❌ | Excluded from MVM |
|  | compliance_tracking | engineering_regulatory_certification | ✅ | ❌ | Excluded from MVM |
|  | compliance_tracking | specification_compliance_mapping | ✅ | ❌ | Excluded from MVM |
|  | compliance_tracking | test_requirement_verification | ✅ | ❌ | Excluded from MVM |
|  | product_structure | bom_line | ✅ | ✅ |  |
|  | product_structure | bop | ✅ | ❌ | Excluded from MVM |
|  | product_structure | bop_operation | ✅ | ✅ |  |
|  | product_structure | cad_model | ✅ | ✅ |  |
|  | product_structure | component_revision | ✅ | ❌ | Excluded from MVM |
|  | product_structure | component_tooling_assignment | ❌ | ✅ | MVM only (stub or new) |
|  | product_structure | drawing | ✅ | ❌ | Excluded from MVM |
|  | product_structure | engineering_bom | ✅ | ❌ | Excluded from MVM |
|  | product_structure | material_specification | ✅ | ❌ | Excluded from MVM |
|  | product_structure | product_specification | ✅ | ❌ | Excluded from MVM |
|  | product_structure | product_variant | ✅ | ❌ | Excluded from MVM |
|  | product_structure | substitute_component | ✅ | ✅ |  |
|  | product_structure | tooling_equipment | ✅ | ❌ | Excluded from MVM |
|  | risk_assessment | approved_manufacturer | ✅ | ❌ | Excluded from MVM |
|  | risk_assessment | design_review | ✅ | ❌ | Excluded from MVM |
|  | risk_assessment | design_review_action | ✅ | ❌ | Excluded from MVM |
|  | risk_assessment | design_validation_test | ✅ | ❌ | Excluded from MVM |
|  | risk_assessment | dfmea | ✅ | ✅ |  |
|  | risk_assessment | engineering_prototype | ✅ | ❌ | Excluded from MVM |
|  | risk_assessment | pfmea | ✅ | ✅ |  |
|  | risk_assessment | plm_lifecycle_state | ✅ | ✅ |  |
|  | risk_assessment | project | ✅ | ❌ | Excluded from MVM |
| **finance** | asset_management | asset_transaction | ✅ | ✅ |  |
|  | cash_operations | cash_application | ❌ | ✅ | MVM only (stub or new) |
|  | cost_controlling | budget | ✅ | ❌ | Excluded from MVM |
|  | cost_controlling | budget_line | ✅ | ❌ | Excluded from MVM |
|  | cost_controlling | controlling_area | ✅ | ❌ | Excluded from MVM |
|  | cost_controlling | copa_posting | ✅ | ❌ | Excluded from MVM |
|  | cost_controlling | cost_allocation | ✅ | ❌ | Excluded from MVM |
|  | cost_controlling | product_cost_estimate | ✅ | ❌ | Excluded from MVM |
|  | cost_controlling | production_order_cost | ✅ | ❌ | Excluded from MVM |
|  | cost_controlling | profitability_segment | ✅ | ❌ | Excluded from MVM |
|  | general_ledger | chart_of_accounts | ✅ | ✅ |  |
|  | general_ledger | currency_exchange_rate | ✅ | ❌ | Excluded from MVM |
|  | general_ledger | fiscal_period | ✅ | ❌ | Excluded from MVM |
|  | general_ledger | journal_entry | ✅ | ✅ |  |
|  | general_ledger | journal_entry_line | ✅ | ✅ |  |
|  | general_ledger | ledger | ✅ | ❌ | Excluded from MVM |
|  | general_ledger | period_close_activity | ✅ | ❌ | Excluded from MVM |
|  | general_ledger | statement_version | ✅ | ❌ | Excluded from MVM |
|  | general_ledger | tax_code | ✅ | ❌ | Excluded from MVM |
|  | payables_receivables | ap_invoice | ✅ | ❌ | Excluded from MVM |
|  | payables_receivables | ar_invoice | ✅ | ❌ | Excluded from MVM |
|  | payables_receivables | intercompany_transaction | ✅ | ❌ | Excluded from MVM |
|  | treasury_operations | bank_account | ✅ | ✅ |  |
|  | treasury_operations | cash_pool | ✅ | ❌ | Excluded from MVM |
|  | treasury_operations | house_bank | ✅ | ❌ | Excluded from MVM |
|  | treasury_operations | payment | ✅ | ✅ |  |
| **hse** | chemical_management | chemical_inventory | ✅ | ❌ | Domain not in MVM |
|  | chemical_management | chemical_regulatory_compliance | ✅ | ❌ | Domain not in MVM |
|  | chemical_management | chemical_substance | ✅ | ❌ | Domain not in MVM |
|  | chemical_management | hse_reach_substance_declaration | ✅ | ❌ | Domain not in MVM |
|  | chemical_management | sds | ✅ | ❌ | Domain not in MVM |
|  | environmental_compliance | audit_coverage | ✅ | ❌ | Domain not in MVM |
|  | environmental_compliance | compliance_evaluation | ✅ | ❌ | Domain not in MVM |
|  | environmental_compliance | emission_monitoring | ✅ | ❌ | Domain not in MVM |
|  | environmental_compliance | energy_consumption | ✅ | ❌ | Domain not in MVM |
|  | environmental_compliance | energy_target | ✅ | ❌ | Domain not in MVM |
|  | environmental_compliance | environmental_aspect | ✅ | ❌ | Domain not in MVM |
|  | environmental_compliance | environmental_permit | ✅ | ❌ | Domain not in MVM |
|  | environmental_compliance | ghg_emission | ✅ | ❌ | Domain not in MVM |
|  | environmental_compliance | objective | ✅ | ❌ | Domain not in MVM |
|  | environmental_compliance | regulatory_obligation | ✅ | ❌ | Domain not in MVM |
|  | environmental_compliance | waste_record | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | contractor_qualification | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | emergency_drill | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | emergency_response_plan | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | hazard_assessment | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | hse_audit_finding | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | hse_capa | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | hygiene_monitoring | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | incident | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | incident_investigation | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | management_of_change | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | ppe_requirement | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | safety_audit | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | safety_training | ✅ | ❌ | Domain not in MVM |
|  | safety_operations | training_attendance | ✅ | ❌ | Domain not in MVM |
| **inventory** | material_tracking | abc_classification | ✅ | ❌ | Excluded from MVM |
|  | material_tracking | consignment_stock | ✅ | ❌ | Excluded from MVM |
|  | material_tracking | consumption | ✅ | ❌ | Excluded from MVM |
|  | material_tracking | lot_batch | ✅ | ❌ | Excluded from MVM |
|  | material_tracking | mro_stock | ✅ | ❌ | Excluded from MVM |
|  | material_tracking | quarantine_hold | ✅ | ✅ |  |
|  | material_tracking | serialized_unit | ✅ | ❌ | Excluded from MVM |
|  | material_tracking | wip_stock | ✅ | ✅ |  |
|  | physical_verification | cycle_count | ✅ | ✅ |  |
|  | physical_verification | cycle_count_result | ✅ | ✅ |  |
|  | physical_verification | inventory_valuation | ✅ | ✅ |  |
|  | physical_verification | physical_inventory | ✅ | ✅ |  |
|  | physical_verification | reorder_policy | ✅ | ✅ |  |
|  | physical_verification | replenishment_order | ✅ | ✅ |  |
|  | physical_verification | sku_pricing | ✅ | ❌ | Excluded from MVM |
|  | physical_verification | snapshot | ✅ | ❌ | Excluded from MVM |
|  | stock_management | stock_adjustment | ✅ | ✅ |  |
|  | stock_management | stock_position | ✅ | ❌ | Excluded from MVM |
|  | stock_management | stock_transfer | ✅ | ✅ |  |
|  | stock_management | transaction | ✅ | ✅ |  |
|  | warehouse_operations | handling_unit | ✅ | ❌ | Excluded from MVM |
|  | warehouse_operations | pick_task | ✅ | ❌ | Excluded from MVM |
|  | warehouse_operations | putaway_task | ✅ | ❌ | Excluded from MVM |
|  | warehouse_operations | storage_location | ✅ | ❌ | Excluded from MVM |
|  | warehouse_operations | warehouse_carrier_agreement | ✅ | ❌ | Excluded from MVM |
| **logistics** | carrier_management | carrier | ✅ | ✅ |  |
|  | carrier_management | carrier_performance | ✅ | ❌ | Excluded from MVM |
|  | carrier_management | carrier_qualification | ✅ | ❌ | Excluded from MVM |
|  | carrier_management | carrier_service | ✅ | ✅ |  |
|  | carrier_management | carrier_service_agreement | ✅ | ❌ | Excluded from MVM |
|  | carrier_management | carrier_territory_coverage | ✅ | ❌ | Excluded from MVM |
|  | carrier_management | freight_contract | ✅ | ✅ |  |
|  | carrier_management | freight_rate | ✅ | ✅ |  |
|  | financial_settlement | freight_audit | ✅ | ❌ | Excluded from MVM |
|  | financial_settlement | freight_claim | ✅ | ❌ | Excluded from MVM |
|  | financial_settlement | freight_invoice | ✅ | ✅ |  |
|  | freight_execution | delivery | ✅ | ✅ |  |
|  | freight_execution | delivery_performance | ✅ | ❌ | Excluded from MVM |
|  | freight_execution | freight_order | ✅ | ✅ |  |
|  | freight_execution | load_unit | ✅ | ❌ | Excluded from MVM |
|  | freight_execution | logistics_inbound_delivery | ✅ | ❌ | Excluded from MVM |
|  | freight_execution | shipment_exception | ✅ | ❌ | Excluded from MVM |
|  | freight_execution | shipment_item | ✅ | ✅ |  |
|  | freight_execution | tracking_event | ✅ | ✅ |  |
|  | freight_execution | transport_plan | ✅ | ✅ |  |
|  | network_planning | location | ✅ | ❌ | Excluded from MVM |
|  | network_planning | packaging | ✅ | ✅ |  |
|  | network_planning | parts_inventory_position | ✅ | ❌ | Excluded from MVM |
|  | network_planning | route | ✅ | ✅ |  |
|  | network_planning | route_stop | ✅ | ✅ |  |
|  | network_planning | route_supplier_pickup | ✅ | ❌ | Excluded from MVM |
|  | network_planning | transport_zone | ✅ | ❌ | Excluded from MVM |
|  | shipment_delivery | inbound_delivery | ❌ | ✅ | MVM only (stub or new) |
|  | trade_compliance | customs_declaration | ✅ | ❌ | Excluded from MVM |
|  | trade_compliance | dangerous_goods_declaration | ✅ | ❌ | Excluded from MVM |
|  | trade_compliance | trade_document | ✅ | ❌ | Excluded from MVM |
| **order** | contract_administration | blanket_order | ✅ | ✅ |  |
|  | contract_administration | blanket_order_line | ✅ | ❌ | Excluded from MVM |
|  | contract_administration | channel | ✅ | ✅ |  |
|  | contract_administration | service_coverage | ✅ | ❌ | Excluded from MVM |
|  | fulfillment_logistics | credit_check | ✅ | ✅ |  |
|  | fulfillment_logistics | export_control_check | ✅ | ❌ | Excluded from MVM |
|  | fulfillment_logistics | fulfillment_mode | ✅ | ❌ | Excluded from MVM |
|  | fulfillment_logistics | fulfillment_plan | ✅ | ✅ |  |
|  | fulfillment_logistics | goods_issue | ✅ | ✅ |  |
|  | fulfillment_logistics | returns_order | ✅ | ❌ | Excluded from MVM |
|  | order_execution | amendment | ✅ | ❌ | Excluded from MVM |
|  | order_execution | atp_commitment | ✅ | ✅ |  |
|  | order_execution | customer_po | ✅ | ❌ | Excluded from MVM |
|  | order_execution | line_item | ✅ | ❌ | Excluded from MVM |
|  | order_execution | order_block | ✅ | ❌ | Excluded from MVM |
|  | order_execution | order_configuration | ✅ | ✅ |  |
|  | order_execution | order_confirmation | ✅ | ✅ |  |
|  | order_execution | priority | ✅ | ✅ |  |
|  | order_execution | schedule_line | ✅ | ✅ |  |
|  | order_execution | status_history | ✅ | ✅ |  |
|  | order_execution | text | ✅ | ❌ | Excluded from MVM |
|  | quotation_management | order_quotation | ✅ | ❌ | Excluded from MVM |
|  | quotation_management | pricing_condition | ✅ | ✅ |  |
|  | quotation_management | quotation | ❌ | ✅ | MVM only (stub or new) |
|  | quotation_management | quotation_line_item | ✅ | ✅ |  |
|  | quotation_management | rfq_request | ✅ | ✅ |  |
| **procurement** | demand_planning | demand_forecast | ✅ | ✅ |  |
|  | demand_planning | mrp_planned_order | ✅ | ✅ |  |
|  | demand_planning | mrp_run | ✅ | ✅ |  |
|  | demand_planning | supply_network_node | ✅ | ❌ | Excluded from MVM |
|  | order_execution | delivery_schedule | ✅ | ✅ |  |
|  | order_execution | goods_receipt | ✅ | ❌ | Excluded from MVM |
|  | order_execution | goods_receipt_line | ✅ | ❌ | Excluded from MVM |
|  | order_execution | incoterm | ✅ | ❌ | Excluded from MVM |
|  | order_execution | po_change_record | ✅ | ❌ | Excluded from MVM |
|  | order_execution | po_compliance_verification | ✅ | ❌ | Excluded from MVM |
|  | order_execution | po_line_item | ✅ | ❌ | Excluded from MVM |
|  | order_execution | procurement_goods_receipt | ✅ | ❌ | Excluded from MVM |
|  | order_execution | procurement_inbound_delivery | ✅ | ❌ | Excluded from MVM |
|  | order_execution | procurement_payment_term | ✅ | ❌ | Excluded from MVM |
|  | order_execution | procurement_po_line_item | ✅ | ❌ | Excluded from MVM |
|  | order_execution | procurement_purchase_requisition | ✅ | ❌ | Excluded from MVM |
|  | order_execution | procurement_supplier_invoice | ✅ | ❌ | Excluded from MVM |
|  | order_execution | purchase_order | ✅ | ❌ | Excluded from MVM |
|  | order_execution | purchase_order_amendment | ✅ | ❌ | Excluded from MVM |
|  | order_execution | purchase_requisition | ✅ | ✅ |  |
|  | order_execution | purchase_requisition_approval | ✅ | ❌ | Excluded from MVM |
|  | order_execution | supplier_invoice | ✅ | ✅ |  |
|  | performance_analytics | procurement_policy | ✅ | ❌ | Excluded from MVM |
|  | performance_analytics | procurement_spend_category | ✅ | ❌ | Excluded from MVM |
|  | performance_analytics | procurement_supplier_performance | ✅ | ❌ | Excluded from MVM |
|  | performance_analytics | savings_initiative | ✅ | ❌ | Excluded from MVM |
|  | performance_analytics | spend_category | ✅ | ✅ |  |
|  | performance_analytics | spend_transaction | ✅ | ❌ | Excluded from MVM |
|  | performance_analytics | supplier_performance | ✅ | ❌ | Excluded from MVM |
|  | performance_analytics | supplier_risk | ✅ | ❌ | Excluded from MVM |
|  | performance_analytics | supply_risk | ✅ | ❌ | Excluded from MVM |
|  | strategic_sourcing | contract_line_item | ✅ | ❌ | Excluded from MVM |
|  | strategic_sourcing | mro_catalog | ✅ | ❌ | Excluded from MVM |
|  | strategic_sourcing | procurement_contract | ✅ | ❌ | Excluded from MVM |
|  | strategic_sourcing | procurement_material_info_record | ✅ | ❌ | Excluded from MVM |
|  | strategic_sourcing | procurement_sourcing_bid | ✅ | ❌ | Excluded from MVM |
|  | strategic_sourcing | procurement_sourcing_event | ✅ | ❌ | Excluded from MVM |
|  | strategic_sourcing | procurement_supply_agreement | ✅ | ❌ | Excluded from MVM |
|  | strategic_sourcing | quota_arrangement | ✅ | ✅ |  |
|  | strategic_sourcing | source_list | ✅ | ✅ |  |
|  | strategic_sourcing | sourcing_award | ✅ | ❌ | Excluded from MVM |
|  | strategic_sourcing | sourcing_bid | ✅ | ❌ | Excluded from MVM |
|  | strategic_sourcing | sourcing_event | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | preferred_supplier | ❌ | ✅ | MVM only (stub or new) |
|  | supplier_management | preferred_supplier_list | ✅ | ✅ |  |
|  | supplier_management | procurement_supplier_contact | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | procurement_supplier_qualification | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | supplier | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | supplier_audit | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | supplier_certificate | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | supplier_certification | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | supplier_collaboration | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | supplier_compliance | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | supplier_contact | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | supplier_control_plan_approval | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | supplier_qualification | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | supplier_service_contract | ✅ | ❌ | Excluded from MVM |
|  | supplier_management | supply_agreement | ❌ | ✅ | MVM only (stub or new) |
| **product** | catalog_structure | attribute | ✅ | ❌ | Excluded from MVM |
|  | catalog_structure | category | ✅ | ❌ | Excluded from MVM |
|  | catalog_structure | classification | ✅ | ✅ |  |
|  | catalog_structure | hierarchy | ✅ | ✅ |  |
|  | catalog_structure | lifecycle | ✅ | ❌ | Excluded from MVM |
|  | catalog_structure | product_configuration | ✅ | ❌ | Excluded from MVM |
|  | catalog_structure | substitution | ✅ | ✅ |  |
|  | catalog_structure | uom | ✅ | ❌ | Excluded from MVM |
|  | commercial_pricing | bundle | ✅ | ❌ | Excluded from MVM |
|  | commercial_pricing | bundle_component | ✅ | ❌ | Excluded from MVM |
|  | commercial_pricing | discount_schedule | ✅ | ❌ | Excluded from MVM |
|  | commercial_pricing | document | ❌ | ✅ | MVM only (stub or new) |
|  | commercial_pricing | price_list_item | ✅ | ✅ |  |
|  | commercial_pricing | product_price_list | ✅ | ❌ | Excluded from MVM |
|  | commercial_pricing | warranty_policy | ✅ | ❌ | Excluded from MVM |
|  | compliance_safety | regulatory_certification | ❌ | ✅ | MVM only (stub or new) |
|  | distribution_operations | aftermarket_part | ✅ | ✅ |  |
|  | distribution_operations | market | ✅ | ❌ | Excluded from MVM |
|  | distribution_operations | partner_authorization | ✅ | ❌ | Excluded from MVM |
|  | distribution_operations | product_material_info_record | ✅ | ❌ | Excluded from MVM |
|  | distribution_operations | product_plant | ✅ | ❌ | Excluded from MVM |
|  | distribution_operations | quality_specification | ✅ | ❌ | Excluded from MVM |
|  | distribution_operations | sales_org | ✅ | ❌ | Excluded from MVM |
|  | information_management | change_notice | ✅ | ❌ | Excluded from MVM |
|  | information_management | launch | ✅ | ❌ | Excluded from MVM |
|  | information_management | media | ✅ | ❌ | Excluded from MVM |
|  | information_management | product_document | ✅ | ❌ | Excluded from MVM |
|  | regulatory_compliance | compliance | ✅ | ❌ | Excluded from MVM |
|  | regulatory_compliance | hazardous_substance | ✅ | ✅ |  |
|  | regulatory_compliance | market_authorization | ✅ | ❌ | Excluded from MVM |
|  | regulatory_compliance | product_regulatory_certification | ✅ | ❌ | Excluded from MVM |
|  | regulatory_compliance | substance_declaration | ✅ | ❌ | Excluded from MVM |
| **production** | equipment_performance | changeover | ✅ | ❌ | Excluded from MVM |
|  | equipment_performance | downtime_event | ✅ | ✅ |  |
|  | equipment_performance | iiot_machine_signal | ✅ | ❌ | Excluded from MVM |
|  | equipment_performance | oee_event | ✅ | ❌ | Excluded from MVM |
|  | equipment_performance | work_center_supplier_service | ✅ | ❌ | Excluded from MVM |
|  | order_execution | bom_explosion | ✅ | ❌ | Excluded from MVM |
|  | order_execution | cost_estimate | ✅ | ❌ | Excluded from MVM |
|  | order_execution | hold | ✅ | ❌ | Excluded from MVM |
|  | order_execution | material_staging | ✅ | ✅ |  |
|  | order_execution | operation | ✅ | ❌ | Excluded from MVM |
|  | order_execution | order_status | ✅ | ✅ |  |
|  | order_execution | production_confirmation | ✅ | ✅ |  |
|  | order_execution | shop_order_operation | ✅ | ✅ |  |
|  | quality_traceability | batch | ✅ | ✅ |  |
|  | quality_traceability | batch_genealogy | ✅ | ✅ |  |
|  | quality_traceability | line_permit_coverage | ✅ | ❌ | Excluded from MVM |
|  | quality_traceability | line_qualification | ✅ | ❌ | Excluded from MVM |
|  | quality_traceability | plant_supplier_qualification | ✅ | ❌ | Excluded from MVM |
|  | quality_traceability | scrap_record | ✅ | ✅ |  |
|  | resource_planning | capacity_requirement | ✅ | ✅ |  |
|  | resource_planning | order_type | ✅ | ✅ |  |
|  | resource_planning | planned_order | ✅ | ✅ |  |
|  | resource_planning | routing | ✅ | ✅ |  |
|  | resource_planning | routing_operation | ✅ | ✅ |  |
|  | resource_planning | schedule | ✅ | ✅ |  |
|  | resource_planning | shift | ✅ | ✅ |  |
|  | resource_planning | takt_time_standard | ✅ | ❌ | Excluded from MVM |
|  | resource_planning | version | ✅ | ✅ |  |
|  | resource_planning | work_center | ✅ | ✅ |  |
| **quality** | defect_management | capa | ❌ | ✅ | MVM only (stub or new) |
|  | inspection_management | inspection_lot | ✅ | ✅ |  |
|  | inspection_management | inspection_plan | ✅ | ✅ |  |
|  | inspection_management | inspection_result | ✅ | ✅ |  |
|  | inspection_management | plan_characteristic | ✅ | ❌ | Excluded from MVM |
|  | inspection_management | usage_decision | ✅ | ✅ |  |
|  | issue_resolution | customer_complaint | ✅ | ✅ |  |
|  | issue_resolution | defect_code | ✅ | ✅ |  |
|  | issue_resolution | quality_capa | ✅ | ❌ | Excluded from MVM |
|  | issue_resolution | quality_notification | ✅ | ✅ |  |
|  | issue_resolution | scrap_rework_transaction | ✅ | ❌ | Excluded from MVM |
|  | issue_resolution | supplier_quality_event | ✅ | ❌ | Excluded from MVM |
|  | product_validation | apqp_deliverable | ✅ | ❌ | Excluded from MVM |
|  | product_validation | apqp_plan | ✅ | ❌ | Excluded from MVM |
|  | product_validation | apqp_project | ✅ | ❌ | Excluded from MVM |
|  | product_validation | fai_record | ✅ | ✅ |  |
|  | product_validation | ppap_submission | ✅ | ✅ |  |
|  | product_validation | project_team_member | ✅ | ❌ | Excluded from MVM |
|  | risk_planning | audit | ✅ | ❌ | Excluded from MVM |
|  | risk_planning | certificate | ✅ | ✅ |  |
|  | risk_planning | characteristic | ✅ | ✅ |  |
|  | risk_planning | control_plan | ✅ | ✅ |  |
|  | risk_planning | fmea | ✅ | ✅ |  |
|  | risk_planning | fmea_action | ✅ | ❌ | Excluded from MVM |
|  | risk_planning | gauge | ✅ | ✅ |  |
|  | risk_planning | gauge_calibration | ✅ | ✅ |  |
|  | risk_planning | gauge_loan | ✅ | ❌ | Excluded from MVM |
|  | risk_planning | measurement_capability | ✅ | ❌ | Excluded from MVM |
|  | risk_planning | msa_study | ✅ | ❌ | Excluded from MVM |
|  | risk_planning | qms_document | ✅ | ❌ | Excluded from MVM |
|  | risk_planning | quality_audit_finding | ✅ | ❌ | Excluded from MVM |
|  | risk_planning | spc_chart | ✅ | ✅ |  |
|  | risk_planning | spc_sample | ✅ | ✅ |  |
| **research** | collaboration_funding | collaboration_agreement | ✅ | ❌ | Domain not in MVM |
|  | collaboration_funding | grant_funding | ✅ | ❌ | Domain not in MVM |
|  | collaboration_funding | partner | ✅ | ❌ | Domain not in MVM |
|  | collaboration_funding | project_partner_assignment | ✅ | ❌ | Domain not in MVM |
|  | collaboration_funding | rd_budget | ✅ | ❌ | Domain not in MVM |
|  | collaboration_funding | rd_expense | ✅ | ❌ | Domain not in MVM |
|  | intellectual_property | ip_asset | ✅ | ❌ | Domain not in MVM |
|  | intellectual_property | patent_filing | ✅ | ❌ | Domain not in MVM |
|  | intellectual_property | project_certification | ✅ | ❌ | Domain not in MVM |
|  | portfolio_strategy | competitive_intelligence | ✅ | ❌ | Domain not in MVM |
|  | portfolio_strategy | innovation_pipeline | ✅ | ❌ | Domain not in MVM |
|  | portfolio_strategy | rd_risk | ✅ | ❌ | Domain not in MVM |
|  | portfolio_strategy | stage_gate_review | ✅ | ❌ | Domain not in MVM |
|  | portfolio_strategy | technology_readiness | ✅ | ❌ | Domain not in MVM |
|  | portfolio_strategy | technology_roadmap | ✅ | ❌ | Domain not in MVM |
|  | prototype_development | experimental_bom | ✅ | ❌ | Domain not in MVM |
|  | prototype_development | experimental_bom_line | ✅ | ❌ | Domain not in MVM |
|  | prototype_development | prototype_asset_allocation | ✅ | ❌ | Domain not in MVM |
|  | prototype_development | prototype_sourcing | ✅ | ❌ | Domain not in MVM |
|  | prototype_development | research_prototype | ✅ | ❌ | Domain not in MVM |
|  | validation_testing | lab_booking | ✅ | ❌ | Domain not in MVM |
|  | validation_testing | lab_resource | ✅ | ❌ | Domain not in MVM |
|  | validation_testing | rd_document | ✅ | ❌ | Domain not in MVM |
|  | validation_testing | rd_milestone | ✅ | ❌ | Domain not in MVM |
|  | validation_testing | rd_test_plan | ✅ | ❌ | Domain not in MVM |
|  | validation_testing | rd_test_result | ✅ | ❌ | Domain not in MVM |
| **sales** | compensation_incentives | commission_plan | ✅ | ❌ | Excluded from MVM |
|  | compensation_incentives | commission_record | ✅ | ❌ | Excluded from MVM |
|  | compensation_incentives | rebate_accrual | ✅ | ❌ | Excluded from MVM |
|  | compensation_incentives | rebate_agreement | ✅ | ❌ | Excluded from MVM |
|  | opportunity_management | account_plan | ✅ | ✅ |  |
|  | opportunity_management | activity | ✅ | ✅ |  |
|  | opportunity_management | campaign | ✅ | ✅ |  |
|  | opportunity_management | competitor | ✅ | ✅ |  |
|  | opportunity_management | forecast | ✅ | ✅ |  |
|  | opportunity_management | lead | ✅ | ✅ |  |
|  | opportunity_management | opportunity_competitor | ✅ | ✅ |  |
|  | opportunity_management | opportunity_line | ✅ | ❌ | Excluded from MVM |
|  | opportunity_management | opportunity_stage_history | ✅ | ❌ | Excluded from MVM |
|  | opportunity_management | opportunity_supplier_sourcing | ✅ | ❌ | Excluded from MVM |
|  | opportunity_management | service_inclusion | ✅ | ❌ | Excluded from MVM |
|  | opportunity_management | team | ✅ | ✅ |  |
|  | opportunity_management | win_loss_record | ✅ | ❌ | Excluded from MVM |
|  | partner_ecosystem | channel_partner_program | ✅ | ❌ | Excluded from MVM |
|  | partner_ecosystem | deal_registration | ✅ | ❌ | Excluded from MVM |
|  | partner_ecosystem | partner_certification | ✅ | ❌ | Excluded from MVM |
|  | partner_ecosystem | partner_rd_collaboration | ✅ | ❌ | Excluded from MVM |
|  | partner_ecosystem | partner_supplier_relationship | ✅ | ❌ | Excluded from MVM |
|  | partner_ecosystem | partner_territory_authorization | ✅ | ❌ | Excluded from MVM |
|  | pricing_discounts | discount_structure | ✅ | ✅ |  |
|  | pricing_discounts | sales_price_list | ✅ | ❌ | Excluded from MVM |
|  | pricing_discounts | special_pricing_request | ✅ | ❌ | Excluded from MVM |
|  | territory_administration | quota | ✅ | ✅ |  |
|  | territory_administration | sales_territory | ✅ | ❌ | Excluded from MVM |
|  | territory_administration | territory_assignment | ✅ | ✅ |  |
| **service** | contract_management | contract_line | ✅ | ✅ |  |
|  | contract_management | entitlement | ✅ | ✅ |  |
|  | contract_management | service_invoice | ✅ | ❌ | Excluded from MVM |
|  | contract_management | service_price_list | ✅ | ❌ | Excluded from MVM |
|  | contract_management | service_quotation | ✅ | ❌ | Excluded from MVM |
|  | contract_management | sla_commitment | ✅ | ✅ |  |
|  | contract_management | sla_tracking | ✅ | ✅ |  |
|  | customer_support | escalation | ✅ | ❌ | Excluded from MVM |
|  | customer_support | feedback | ✅ | ❌ | Excluded from MVM |
|  | customer_support | nps_survey | ✅ | ❌ | Excluded from MVM |
|  | customer_support | product_return | ✅ | ❌ | Excluded from MVM |
|  | customer_support | remote_support_session | ✅ | ❌ | Excluded from MVM |
|  | customer_support | request | ✅ | ✅ |  |
|  | customer_support | warranty_claim | ✅ | ✅ |  |
|  | field_operations | dispatch_schedule | ✅ | ✅ |  |
|  | field_operations | installation_record | ✅ | ✅ |  |
|  | field_operations | report | ✅ | ✅ |  |
|  | field_operations | service_territory | ✅ | ✅ |  |
|  | field_operations | technician | ✅ | ✅ |  |
|  | parts_inventory | knowledge_article | ✅ | ✅ |  |
|  | parts_inventory | spare_parts_catalog | ✅ | ✅ |  |
|  | parts_inventory | spare_parts_request | ✅ | ✅ |  |
| **shared** | commercial_operations | account_hierarchy | ❌ | ✅ | In ECM under domain(s): customer |
|  | commercial_operations | address | ❌ | ✅ | In ECM under domain(s): customer |
|  | commercial_operations | asset_bom | ❌ | ✅ | In ECM under domain(s): asset |
|  | commercial_operations | category | ❌ | ✅ | In ECM under domain(s): product |
|  | commercial_operations | contact | ❌ | ✅ | In ECM under domain(s): customer |
|  | commercial_operations | failure_record | ❌ | ✅ | In ECM under domain(s): asset |
|  | commercial_operations | installed_base | ❌ | ✅ | In ECM under domain(s): customer |
|  | commercial_operations | lifecycle | ❌ | ✅ | In ECM under domain(s): product |
|  | commercial_operations | line_item | ❌ | ✅ | In ECM under domain(s): order |
|  | commercial_operations | lot_batch | ❌ | ✅ | In ECM under domain(s): inventory |
|  | commercial_operations | plant | ❌ | ✅ | MVM only (stub or new) |
|  | commercial_operations | pricing_agreement | ❌ | ✅ | In ECM under domain(s): customer |
|  | commercial_operations | product_configuration | ❌ | ✅ | In ECM under domain(s): product |
|  | commercial_operations | product_price_list | ❌ | ✅ | In ECM under domain(s): product |
|  | commercial_operations | returns_order | ❌ | ✅ | In ECM under domain(s): order |
|  | commercial_operations | sales_org | ❌ | ✅ | In ECM under domain(s): product |
|  | commercial_operations | sales_price_list | ❌ | ✅ | In ECM under domain(s): sales |
|  | commercial_operations | sales_territory | ❌ | ✅ | In ECM under domain(s): sales |
|  | commercial_operations | segment | ❌ | ✅ | In ECM under domain(s): customer |
|  | commercial_operations | serialized_unit | ❌ | ✅ | In ECM under domain(s): inventory |
|  | commercial_operations | sla_agreement | ❌ | ✅ | In ECM under domain(s): customer |
|  | commercial_operations | stock_position | ❌ | ✅ | In ECM under domain(s): inventory |
|  | commercial_operations | storage_location | ❌ | ✅ | In ECM under domain(s): inventory |
|  | commercial_operations | uom | ❌ | ✅ | In ECM under domain(s): product |
|  | commercial_operations | warranty_policy | ❌ | ✅ | In ECM under domain(s): product |
|  | commercial_operations | work_order_operation | ❌ | ✅ | In ECM under domain(s): asset |
|  | financial_controls | ap_invoice | ❌ | ✅ | In ECM under domain(s): finance |
|  | financial_controls | ar_invoice | ❌ | ✅ | In ECM under domain(s): finance |
|  | financial_controls | contract | ❌ | ✅ | In ECM under domain(s): workforce |
|  | financial_controls | controlling_area | ❌ | ✅ | In ECM under domain(s): finance |
|  | financial_controls | cost_allocation | ❌ | ✅ | In ECM under domain(s): finance |
|  | financial_controls | currency_exchange_rate | ❌ | ✅ | In ECM under domain(s): finance |
|  | financial_controls | fiscal_period | ❌ | ✅ | In ECM under domain(s): finance |
|  | financial_controls | goods_receipt | ❌ | ✅ | In ECM under domain(s): procurement |
|  | financial_controls | location | ❌ | ✅ | In ECM under domain(s): logistics |
|  | financial_controls | product_cost_estimate | ❌ | ✅ | In ECM under domain(s): finance |
|  | financial_controls | production_order_cost | ❌ | ✅ | In ECM under domain(s): finance |
|  | financial_controls | profitability_segment | ❌ | ✅ | In ECM under domain(s): finance |
|  | financial_controls | purchase_order | ❌ | ✅ | In ECM under domain(s): procurement |
|  | financial_controls | supplier | ❌ | ✅ | In ECM under domain(s): procurement |
|  | financial_controls | tax_code | ❌ | ✅ | In ECM under domain(s): finance |
|  | product_engineering | approved_manufacturer | ❌ | ✅ | In ECM under domain(s): engineering |
|  | product_engineering | bop | ❌ | ✅ | In ECM under domain(s): engineering |
|  | product_engineering | drawing | ❌ | ✅ | In ECM under domain(s): engineering |
|  | product_engineering | ecn | ❌ | ✅ | In ECM under domain(s): engineering |
|  | product_engineering | engineering_bom | ❌ | ✅ | In ECM under domain(s): engineering |
|  | product_engineering | material_specification | ❌ | ✅ | In ECM under domain(s): engineering |
|  | product_engineering | product_specification | ❌ | ✅ | In ECM under domain(s): engineering |
|  | product_engineering | product_variant | ❌ | ✅ | In ECM under domain(s): engineering |
|  | product_engineering | tooling_equipment | ❌ | ✅ | In ECM under domain(s): engineering |
| **technology** | infrastructure_assets | data_integration | ✅ | ❌ | Domain not in MVM |
|  | infrastructure_assets | network_device | ✅ | ❌ | Domain not in MVM |
|  | infrastructure_assets | software_license | ✅ | ❌ | Domain not in MVM |
|  | infrastructure_assets | standard | ✅ | ❌ | Domain not in MVM |
|  | portfolio_management | digital_initiative | ✅ | ❌ | Domain not in MVM |
|  | portfolio_management | iiot_platform | ✅ | ❌ | Domain not in MVM |
|  | portfolio_management | it_project | ✅ | ❌ | Domain not in MVM |
|  | portfolio_management | it_project_milestone | ✅ | ❌ | Domain not in MVM |
|  | security_compliance | it_risk | ✅ | ❌ | Domain not in MVM |
|  | security_compliance | patch_record | ✅ | ❌ | Domain not in MVM |
|  | security_compliance | vulnerability | ✅ | ❌ | Domain not in MVM |
|  | service_operations | configuration_item | ✅ | ❌ | Domain not in MVM |
|  | service_operations | it_service | ✅ | ❌ | Domain not in MVM |
|  | service_operations | it_service_outage | ✅ | ❌ | Domain not in MVM |
|  | service_operations | service_ticket | ✅ | ❌ | Domain not in MVM |
|  | service_operations | sla_definition | ✅ | ❌ | Domain not in MVM |
|  | service_operations | sla_performance | ✅ | ❌ | Domain not in MVM |
|  | service_operations | technology_change_request | ✅ | ❌ | Domain not in MVM |
|  | service_operations | user_access_request | ✅ | ❌ | Domain not in MVM |
|  | vendor_relations | it_budget | ✅ | ❌ | Domain not in MVM |
|  | vendor_relations | it_contract | ✅ | ❌ | Domain not in MVM |
|  | vendor_relations | it_cost_allocation | ✅ | ❌ | Domain not in MVM |
|  | vendor_relations | it_vendor | ✅ | ❌ | Domain not in MVM |
| **workforce** | attendance_operations | absence_record | ✅ | ❌ | Domain not in MVM |
|  | attendance_operations | labor_cost_entry | ✅ | ❌ | Domain not in MVM |
|  | attendance_operations | labor_standard | ✅ | ❌ | Domain not in MVM |
|  | attendance_operations | overtime_request | ✅ | ❌ | Domain not in MVM |
|  | attendance_operations | pay_period | ✅ | ❌ | Domain not in MVM |
|  | attendance_operations | payroll_result | ✅ | ❌ | Domain not in MVM |
|  | attendance_operations | shift_definition | ✅ | ❌ | Domain not in MVM |
|  | attendance_operations | shift_schedule | ✅ | ❌ | Domain not in MVM |
|  | attendance_operations | time_entry | ✅ | ❌ | Domain not in MVM |
|  | attendance_operations | work_permit | ✅ | ❌ | Domain not in MVM |
|  | development_training | certification | ✅ | ❌ | Domain not in MVM |
|  | development_training | employee_certification | ✅ | ❌ | Domain not in MVM |
|  | development_training | employee_skill | ✅ | ❌ | Domain not in MVM |
|  | development_training | performance_goal | ✅ | ❌ | Domain not in MVM |
|  | development_training | performance_review | ✅ | ❌ | Domain not in MVM |
|  | development_training | skill | ✅ | ❌ | Domain not in MVM |
|  | development_training | training_completion | ✅ | ❌ | Domain not in MVM |
|  | development_training | training_course | ✅ | ❌ | Domain not in MVM |
|  | development_training | training_record | ✅ | ❌ | Domain not in MVM |
|  | personnel_management | disciplinary_action | ✅ | ❌ | Domain not in MVM |
|  | personnel_management | employee | ✅ | ❌ | Domain not in MVM |
|  | personnel_management | employee_transfer | ✅ | ❌ | Domain not in MVM |
|  | personnel_management | grievance | ✅ | ❌ | Domain not in MVM |
|  | personnel_management | headcount_plan | ✅ | ❌ | Domain not in MVM |
|  | personnel_management | job_position | ✅ | ❌ | Domain not in MVM |
|  | personnel_management | labor_classification | ✅ | ❌ | Domain not in MVM |
|  | personnel_management | org_unit | ✅ | ❌ | Domain not in MVM |
|  | personnel_management | position_assignment | ✅ | ❌ | Domain not in MVM |
|  | personnel_management | union_agreement | ✅ | ❌ | Domain not in MVM |
|  | regulatory_compliance | capa_record | ✅ | ❌ | Domain not in MVM |
|  | regulatory_compliance | compliance_reach_substance_declaration | ✅ | ❌ | Domain not in MVM |
|  | regulatory_compliance | compliance_record | ✅ | ❌ | Domain not in MVM |
|  | regulatory_compliance | export_classification | ✅ | ❌ | Domain not in MVM |
|  | regulatory_compliance | product_certification | ✅ | ❌ | Domain not in MVM |
|  | regulatory_compliance | regulatory_requirement | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | account | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | application | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | asset_register | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | billing_invoice | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | business_unit | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | catalog_item | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | channel_partner | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | component | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | contract | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | cost_center | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | delivery_order | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | equipment | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | field_service_order | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | functional_location | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | gl_account | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | internal_order | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | inventory_sku | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | it_asset | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | legal_entity | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | line | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | ncr | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | order | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | ot_system | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | procurement_purchase_order | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | procurement_supplier | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | product_sku | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | production_plant | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | profit_center | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | project_assignment | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | rd_project | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | sales_opportunity | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | sales_order | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | shipment | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | spare_part | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | warehouse | ✅ | ❌ | Domain not in MVM |
|  | resource_allocation | work_order | ✅ | ❌ | Domain not in MVM |