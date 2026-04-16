-- Schema for Domain: asset | Business:  | Version: v1_mvm
-- Generated on: 2026-04-16 09:51:29

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`asset` COMMENT 'Manages the full lifecycle of manufacturing equipment, plant assets, and capital infrastructure using EAM/CMMS. Covers preventive and predictive maintenance (TPM), work order management, MTBF/MTTR tracking, condition monitoring via IIoT/MindSphere, PLCs, CNC machines, SCADA systems, and CAPEX/OPEX asset accounting.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`class` (
    `class_id` BIGINT COMMENT 'Unique system-generated identifier for each asset classification record within the enterprise asset taxonomy.',
    `classification_id` BIGINT COMMENT 'Foreign key linking to product.classification. Business justification: Asset classes are aligned to product classification schemes (e.g., equipment taxonomy). Asset management and product engineering teams share classification structures to ensure consistent categorizati',
    `applicable_standard` STRING COMMENT 'Primary industry or regulatory standard governing the design, operation, or maintenance of assets in this class (e.g., ISO 9001, IEC 61131, ANSI/NFPA 70, CE Marking, UL 508A).',
    `asset_type` STRING COMMENT 'Indicates whether the asset class represents a fixed asset, movable asset, leased asset, or tooling, driving accounting treatment and depreciation rules under IFRS/GAAP.. Valid values are `fixed_asset|movable_asset|leased_asset|rented_asset|tooling|spare_part_assembly`',
    `capitalization_threshold_amount` DECIMAL(18,2) COMMENT 'Minimum acquisition cost (in base currency) above which an asset of this class must be capitalized as a fixed asset rather than expensed as OPEX, per company CAPEX policy and GAAP/IFRS guidelines.',
    `capitalization_threshold_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the capitalization threshold amount, supporting multi-currency operations across global manufacturing sites.. Valid values are `^[A-Z]{3}$`',
    `category` STRING COMMENT 'High-level grouping of the asset class into a major category (e.g., production equipment, facility infrastructure, IT/OT systems) for portfolio-level reporting and CAPEX/OPEX planning.. Valid values are `production_equipment|material_handling|facility_infrastructure|it_ot_systems|safety_systems|utilities|tooling_fixtures|vehicles|measurement_instruments|other`',
    `ce_marking_required` BOOLEAN COMMENT 'Indicates whether assets of this class require CE Marking for operation within the European Union, ensuring conformity with applicable EU directives (Machinery Directive, Low Voltage Directive, EMC Directive).. Valid values are `true|false`',
    `code` STRING COMMENT 'Short alphanumeric code uniquely identifying the asset class, used for cross-system referencing between Maximo EAM and SAP S/4HANA PM module.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `cost_center_code` STRING COMMENT 'Default SAP cost center code for assets of this class, used for OPEX maintenance cost allocation and management accounting reporting in SAP S/4HANA CO module.. Valid values are `^[A-Z0-9]{4,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this asset class record was first created in the system, supporting audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `criticality_rating` STRING COMMENT 'Standardized criticality rating for assets of this class based on impact to production throughput, safety, and quality. Drives maintenance prioritization, spare parts stocking strategy, and OEE reporting.. Valid values are `critical|high|medium|low`',
    `depreciation_method` STRING COMMENT 'Accounting depreciation method applied to assets of this class, governing how asset value is expensed over its useful life in compliance with IFRS/GAAP financial reporting standards.. Valid values are `straight_line|declining_balance|double_declining_balance|units_of_production|sum_of_years_digits|not_applicable`',
    `description` STRING COMMENT 'Detailed narrative description of the asset class, including its typical function, application context, and distinguishing characteristics within the manufacturing environment.',
    `effective_date` DATE COMMENT 'Date from which this asset class definition becomes active and valid for use in asset creation and classification across EAM and ERP systems.. Valid values are `^d{4}-d{2}-d{2}$`',
    `energy_class` STRING COMMENT 'Energy efficiency classification for assets of this class, supporting ISO 50001 energy management compliance and OPEX energy cost reporting across manufacturing facilities.. Valid values are `A+++|A++|A+|A|B|C|D|E|F|G|not_rated`',
    `environmental_risk_class` STRING COMMENT 'Environmental risk classification for assets of this class, indicating potential environmental impact (e.g., refrigerant leaks, chemical containment, emissions) for compliance with ISO 14001 and EPA regulations.. Valid values are `low|medium|high|critical|not_applicable`',
    `expiry_date` DATE COMMENT 'Date after which this asset class definition is no longer valid for new asset creation, supporting controlled deprecation of obsolete classifications in the enterprise taxonomy.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gl_account_code` STRING COMMENT 'SAP General Ledger account code associated with this asset class for CAPEX capitalization and OPEX expense posting, ensuring correct financial accounting treatment in SAP S/4HANA FI/CO.. Valid values are `^[A-Z0-9]{4,10}$`',
    `hierarchy_level` STRING COMMENT 'Numeric depth of this asset class within the classification hierarchy tree, where level 1 represents the root category and higher numbers represent more granular sub-classifications.. Valid values are `^[1-9][0-9]*$`',
    `iiot_monitoring_enabled` BOOLEAN COMMENT 'Indicates whether assets of this class are configured for real-time condition monitoring via the Siemens MindSphere IIoT platform, enabling predictive maintenance and digital performance analytics.. Valid values are `true|false`',
    `inspection_authority` STRING COMMENT 'Name of the regulatory or certification body responsible for mandating or conducting inspections for assets of this class (e.g., OSHA, TÜV, UL, CE Notified Body, local fire authority).',
    `inspection_frequency_days` STRING COMMENT 'Mandatory interval in calendar days between regulatory compliance inspections for assets of this class, as prescribed by applicable governing bodies (OSHA, CE, UL, local regulations).. Valid values are `^[1-9][0-9]*$`',
    `inspection_required` BOOLEAN COMMENT 'Indicates whether assets of this class are subject to mandatory regulatory inspections (e.g., pressure vessels, lifting equipment, electrical installations) as required by OSHA, CE Marking, or UL certification standards.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this asset class record, used for change tracking, data synchronization between Maximo EAM and SAP S/4HANA, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `maintenance_frequency_days` STRING COMMENT 'Standard interval in calendar days between scheduled preventive maintenance activities for assets of this class, used to auto-generate work orders in Maximo EAM.. Valid values are `^[1-9][0-9]*$`',
    `maintenance_strategy` STRING COMMENT 'Default maintenance strategy class assigned to assets of this type, aligning with Total Productive Maintenance (TPM) and Reliability-Centered Maintenance (RCM) frameworks configured in Maximo EAM.. Valid values are `preventive|predictive|corrective|condition_based|run_to_failure|total_productive_maintenance|reliability_centered`',
    `mean_time_between_failures_hours` DECIMAL(18,2) COMMENT 'Industry-standard or OEM-specified Mean Time Between Failures (MTBF) in hours for assets of this class, used as a benchmark for reliability analysis, maintenance planning, and OEE calculations.',
    `mean_time_to_repair_hours` DECIMAL(18,2) COMMENT 'Industry-standard or OEM-specified Mean Time To Repair (MTTR) in hours for assets of this class, used to estimate downtime impact, plan maintenance labor resources, and set SLA targets for work orders.',
    `name` STRING COMMENT 'Full descriptive name of the asset class (e.g., CNC Machining Center, Industrial Robot, PLC Controller, HVAC System, Power Transformer).',
    `reach_rohs_applicable` BOOLEAN COMMENT 'Indicates whether assets of this class contain substances subject to REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) or RoHS (Restriction of Hazardous Substances) compliance requirements.. Valid values are `true|false`',
    `residual_value_percent` DECIMAL(18,2) COMMENT 'Estimated residual (salvage) value of assets in this class expressed as a percentage of original acquisition cost, used in depreciation base calculations per IFRS IAS 16.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `safety_critical` BOOLEAN COMMENT 'Indicates whether assets of this class are designated as safety-critical, requiring enhanced maintenance protocols, mandatory inspection records, and compliance with ISO 45001 occupational health and safety standards.. Valid values are `true|false`',
    `sap_asset_class_code` STRING COMMENT 'Corresponding asset class code in SAP S/4HANA FI-AA module, used for financial accounting, depreciation area assignment, and CAPEX tracking. Ensures EAM-ERP synchronization.. Valid values are `^[A-Z0-9]{4,8}$`',
    `scada_integrated` BOOLEAN COMMENT 'Indicates whether assets of this class are integrated with SCADA systems for supervisory control and real-time operational data acquisition, relevant for OT/IT convergence and cybersecurity compliance.. Valid values are `true|false`',
    `spare_parts_strategy` STRING COMMENT 'Default spare parts inventory strategy for assets of this class, used to configure MRO (Maintenance, Repair and Operations) inventory levels in SAP MM and Infor WMS.. Valid values are `critical_stock|min_max|on_demand|vendor_managed|no_stock_required`',
    `status` STRING COMMENT 'Current lifecycle status of the asset class record, controlling whether new assets can be created under this classification in EAM and ERP systems.. Valid values are `active|inactive|under_review|deprecated|pending_approval`',
    `subcategory` STRING COMMENT 'Secondary classification level within the asset category, providing finer granularity (e.g., CNC Machining, Robotic Welding, SCADA Systems, HVAC Chillers) for maintenance strategy alignment.',
    `ul_certification_required` BOOLEAN COMMENT 'Indicates whether assets of this class require UL (Underwriters Laboratories) product safety certification for operation in North American markets.. Valid values are `true|false`',
    `useful_life_years` DECIMAL(18,2) COMMENT 'Standard expected useful life in years for assets belonging to this class, used to calculate depreciation schedules and plan asset replacement cycles under IFRS IAS 16.. Valid values are `^d{1,3}(.d{1,2})?$`',
    `warranty_duration_months` STRING COMMENT 'Standard manufacturer warranty duration in months applicable to assets of this class, used to configure warranty tracking and claim management in Maximo EAM and Salesforce Service Cloud.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_class PRIMARY KEY(`class_id`)
) COMMENT 'Reference classification taxonomy for manufacturing assets defining asset categories (e.g., CNC Machining Center, Industrial Robot, PLC Controller, HVAC System, Power Transformer), depreciation class, maintenance strategy class, and regulatory inspection requirements. Used for standardized asset categorization across EAM and ERP systems.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` (
    `maintenance_plan_id` BIGINT COMMENT 'Unique system-generated identifier for the maintenance plan record within the enterprise asset management system.',
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: Maintenance plans are created for a customers equipment portfolio under a service contract. Service planners assign maintenance plans to the customer account to schedule preventive maintenance visits',
    `class_id` BIGINT COMMENT 'Foreign key linking to asset.asset_class. Business justification: Maintenance plans may be templated by asset class for standardized preventive maintenance across similar equipment types. This enables asset class-level maintenance strategy management.',
    `cost_allocation_id` BIGINT COMMENT 'Foreign key linking to finance.cost_allocation. Business justification: Preventive maintenance plans carry annual budgeted costs assigned to a cost center. Plant controllers use this link to compare planned vs. actual maintenance spend per cost center during budget review',
    `entitlement_id` BIGINT COMMENT 'Foreign key linking to service.entitlement. Business justification: Maintenance plans are scoped by what the customer is entitled to receive under their service agreement. Asset managers validate entitlement before scheduling planned maintenance to ensure the work is ',
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.location. Business justification: Maintenance plans specify which stocking location supplies the required spare parts. Planners reference this logistics location when generating planned orders to ensure parts are sourced from the corr',
    `product_configuration_id` BIGINT COMMENT 'Foreign key linking to product.product_configuration. Business justification: Maintenance plans are designed for specific product configurations. A motor with a specific voltage/power configuration requires a different maintenance schedule than another variant. Maintenance engi',
    `tooling_equipment_id` BIGINT COMMENT 'Foreign key linking to engineering.tooling_equipment. Business justification: Maintenance plans specify which engineering-defined tooling and equipment is required to perform maintenance activities. Maintenance planners reference engineering tooling records to ensure correct to',
    `approved_by` STRING COMMENT 'Name or employee identifier of the maintenance manager or engineering authority who approved the maintenance plan for active use. Required for regulatory compliance and quality management system documentation.',
    `approved_date` DATE COMMENT 'Date on which the maintenance plan was formally approved by the responsible authority. Required for quality management system (QMS) compliance and regulatory audit documentation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `call_horizon_percentage` DECIMAL(18,2) COMMENT 'SAP PM call horizon parameter expressed as a percentage of the maintenance cycle. Defines how early within the scheduling horizon a maintenance call is created (e.g., 100% means calls are created at the full horizon distance).',
    `completion_requirement` STRING COMMENT 'Indicates whether completion of maintenance activities under this plan is mandatory (regulatory or safety-critical), recommended (best practice), or optional (condition-dependent). Drives escalation and overdue handling logic.. Valid values are `mandatory|recommended|optional`',
    `cost_center` STRING COMMENT 'SAP CO cost center code to which maintenance costs generated by this plan are allocated. Enables OPEX tracking, departmental cost reporting, and budget variance analysis.',
    `counter_reading_at_last_service` DECIMAL(18,2) COMMENT 'Meter or counter value (e.g., operating hours, production cycles, kilometers) recorded at the time of the last completed maintenance activity. Used as the baseline for counter-based scheduling.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when the maintenance plan record was first created in the source system (SAP PM or Maximo EAM). Used for data lineage, audit trails, and Silver layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated and actual cost values on this maintenance plan (e.g., USD, EUR, GBP). Supports multinational cost consolidation and reporting.. Valid values are `^[A-Z]{3}$`',
    `cycle_unit` STRING COMMENT 'Unit of measure for the maintenance cycle value. Supports both time-based units (days, weeks, months) and counter-based units (operating hours, production cycles, kilometers) per SAP PM counter configuration.. Valid values are `days|weeks|months|years|hours|cycles|kilometers|strokes|units_produced`',
    `cycle_value` DECIMAL(18,2) COMMENT 'Numeric value defining the maintenance cycle interval. For time-based plans this is the duration (e.g., 90 days), for counter-based plans this is the usage count (e.g., 500 operating hours or 10,000 production cycles).',
    `description` STRING COMMENT 'Detailed narrative describing the scope, objectives, and coverage of the maintenance plan including equipment types, maintenance activities, and regulatory drivers.',
    `end_date` DATE COMMENT 'Calendar date on which the maintenance plan expires and ceases to generate new maintenance calls. Null indicates an open-ended plan with no defined expiry.. Valid values are `^d{4}-d{2}-d{2}$`',
    `equipment_category` STRING COMMENT 'Classification of the equipment type covered by this maintenance plan. Aligns with SAP PM equipment categories and supports filtering for CNC machines, PLC systems, SCADA infrastructure, and other asset classes.. Valid values are `production_machinery|cnc_machine|plc_system|scada_system|conveyor|hvac|electrical|instrumentation|pressure_vessel|rotating_equipment|vehicle|facility`',
    `estimated_cost` DECIMAL(18,2) COMMENT 'Planned cost in the plan currency for one execution cycle of the maintenance activities, including labor, materials, and external services. Used for OPEX budgeting and CAPEX vs OPEX classification.',
    `estimated_duration_hours` DECIMAL(18,2) COMMENT 'Planned duration in hours required to complete one execution of the maintenance activities defined in this plan. Used for resource capacity planning, downtime scheduling, and OEE impact assessment.',
    `external_plan_reference` STRING COMMENT 'Cross-system reference identifier for this maintenance plan in the alternate source system (e.g., Maximo PM Program ID when the master record is in SAP PM, or vice versa). Enables reconciliation between SAP PM and Maximo EAM.',
    `last_completion_date` DATE COMMENT 'Date on which the most recently executed maintenance activity under this plan was completed and confirmed. Used as the baseline for calculating the next due date in time-based plans.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to the maintenance plan record in the source system. Used for incremental data loading, change detection, and audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_scheduled_date` DATE COMMENT 'Date on which the most recent maintenance call was scheduled under this plan. Used to calculate the next due date and track scheduling cadence compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `lead_time_days` STRING COMMENT 'Number of calendar days before the scheduled maintenance due date that a work order should be generated, allowing time for spare parts procurement, resource scheduling, and production planning coordination.',
    `maintenance_plant` STRING COMMENT 'The plant responsible for executing the maintenance activities, which may differ from the plant where the asset is located in multi-site or centralized maintenance organizations.',
    `maintenance_type` STRING COMMENT 'Operational classification of the maintenance execution type, distinguishing planned scheduled activities from emergency or shutdown-based maintenance windows.. Valid values are `planned|unplanned|emergency|shutdown|turnaround`',
    `name` STRING COMMENT 'Descriptive name of the maintenance plan, typically reflecting the asset type, maintenance strategy, and frequency (e.g., Annual Turbine Overhaul Plan).',
    `next_due_date` DATE COMMENT 'Calculated date on which the next maintenance activity is due based on the cycle parameters, last completion date, and scheduling rules. Critical for maintenance scheduling dashboards and overdue tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `notification_type` STRING COMMENT 'Type of maintenance notification generated when the plan triggers a maintenance call. SAP PM notification types (M1 activity report, M2 malfunction report, M3 maintenance request) or digital alert channels.. Valid values are `M1|M2|M3|email|sms|system_alert`',
    `order_type` STRING COMMENT 'SAP PM order type or Maximo work order type that will be generated when this maintenance plan triggers a maintenance call. Determines the workflow, settlement rules, and cost accounting treatment.. Valid values are `PM01|PM02|PM03|PM04|PM05|corrective|preventive|inspection|refurbishment`',
    `plan_category` STRING COMMENT 'Business category of the maintenance plan aligned with Total Productive Maintenance (TPM) disciplines: preventive, predictive, lubrication, calibration, regulatory inspection, or major overhaul.. Valid values are `preventive|predictive|corrective|inspection|lubrication|calibration|regulatory|overhaul`',
    `plan_number` STRING COMMENT 'Business-facing alphanumeric identifier for the maintenance plan, used for cross-system referencing between SAP PM and Maximo EAM.. Valid values are `^MP-[A-Z0-9]{4,20}$`',
    `planner_group` STRING COMMENT 'SAP PM planner group code identifying the maintenance planning team responsible for managing and scheduling this maintenance plan. Used for workload distribution and planning accountability.',
    `plant_code` STRING COMMENT 'SAP plant or Maximo site code identifying the manufacturing facility or operational site where the assets covered by this maintenance plan are located.',
    `priority` STRING COMMENT 'Business priority level assigned to the maintenance plan, used for resource allocation and scheduling conflict resolution when multiple maintenance activities compete for the same assets or technicians.. Valid values are `very_high|high|medium|low`',
    `regulatory_reference` STRING COMMENT 'Specific regulatory standard, clause, or legal requirement that mandates this maintenance plan (e.g., OSHA 29 CFR 1910.217, ISO 45001 Clause 8.1, EPA 40 CFR Part 63). Required for compliance audit trails.',
    `regulatory_requirement` BOOLEAN COMMENT 'Indicates whether this maintenance plan is mandated by a regulatory body (e.g., OSHA, EPA, CE Marking, ISO 45001, pressure vessel inspection regulations). Regulatory plans receive elevated priority and compliance tracking.. Valid values are `true|false`',
    `revision_number` STRING COMMENT 'Version or revision identifier for the maintenance plan, incremented when significant changes are made to cycle parameters, scope, or strategy. Supports change management and audit trail requirements.',
    `safety_critical` BOOLEAN COMMENT 'Indicates whether the maintenance plan covers safety-critical equipment or activities where failure could result in personnel injury, environmental incident, or production safety hazard. Triggers mandatory completion tracking under ISO 45001.. Valid values are `true|false`',
    `scheduling_horizon_days` STRING COMMENT 'Forward-looking planning window in days within which the maintenance plan will generate scheduled work orders. Defines how far ahead the system creates maintenance calls for resource and capacity planning.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this maintenance plan record originated: SAP S/4HANA PM module, Maximo EAM, or manually entered. Supports data lineage and reconciliation between systems.. Valid values are `SAP_PM|MAXIMO_EAM|MANUAL`',
    `start_date` DATE COMMENT 'Calendar date on which the maintenance plan becomes active and begins generating scheduled maintenance calls or work orders.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the maintenance plan indicating whether it is being drafted, actively scheduling work orders, suspended, or retired.. Valid values are `draft|active|inactive|suspended|completed|archived`',
    `strategy_type` STRING COMMENT 'Classification of the maintenance strategy governing this plan. Time-based triggers on calendar intervals, counter-based on usage meters (hours, cycles), condition-based on sensor thresholds, and predictive leverages IIoT/MindSphere analytics.. Valid values are `time_based|counter_based|condition_based|predictive|regulatory|combination`',
    `tolerance_percentage` DECIMAL(18,2) COMMENT 'Allowable deviation percentage from the scheduled maintenance due date or counter threshold before the maintenance is considered overdue. Used to accommodate production scheduling flexibility without triggering compliance violations.',
    `work_center` STRING COMMENT 'SAP PM or Maximo work center code identifying the maintenance team, crew, or organizational unit responsible for executing the maintenance activities defined in this plan.',
    CONSTRAINT pk_maintenance_plan PRIMARY KEY(`maintenance_plan_id`)
) COMMENT 'Defines preventive and time-based maintenance strategies for equipment assets including TPM schedules, inspection intervals, lubrication cycles, calibration frequencies, and regulatory inspection plans. Captures maintenance strategy type (time-based, counter-based, condition-based), cycle parameters, lead times, and scheduling horizon. Sourced from SAP PM Maintenance Plans and Maximo EAM PM Programs.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`maintenance_item` (
    `maintenance_item_id` BIGINT COMMENT 'Unique system-generated identifier for each individual maintenance task item within a maintenance plan. Serves as the primary key for the maintenance_item entity in the asset domain.',
    `maintenance_plan_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_plan. Business justification: Maintenance items are individual tasks within a maintenance plan. Adding maintenance_plan_id FK establishes the parent-child relationship and allows removal of the denormalized plan_number string.',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Maintenance items (spare parts, consumables) are procured via purchase orders. Maintenance planners reference the PO that sourced the part used in a maintenance activity — a daily operational link in ',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Each maintenance item (spare part or consumable) is sourced from a specific supplier. Procurement and maintenance teams track which supplier provides each item for reordering and warranty claims.',
    `task_list_id` BIGINT COMMENT 'Foreign key linking to asset.task_list. Business justification: maintenance_item currently stores task_list_number (STRING) and task_list_type (STRING) as denormalized references to the task_list product. task_list has a `number` and `type` attribute that are the ',
    `activity_type` STRING COMMENT 'Cost accounting activity type used to allocate internal labor costs for this maintenance task to the appropriate cost center. Links maintenance execution to financial controlling (CO) in SAP.',
    `calibration_standard` STRING COMMENT 'Reference to the applicable calibration standard or specification that governs this calibration task item (e.g., ISO 9001 Clause 7.1.5, NIST Traceable, IEC 61315). Applicable only when task_type is calibration. Supports quality management system compliance.',
    `control_key` STRING COMMENT 'SAP PM control key that determines how the maintenance operation is processed, including whether it is internally performed, externally serviced, or a milestone operation. Controls costing, confirmation, and scheduling behavior.. Valid values are `PM01|PM02|PM03|PM04|PM05`',
    `cost_center` STRING COMMENT 'Financial cost center code to which the costs of this maintenance task are allocated. Enables maintenance cost tracking by organizational unit, department, or production area for management accounting purposes.',
    `cost_classification` STRING COMMENT 'Financial classification of the maintenance task cost as either Capital Expenditure (CAPEX) — improving or extending asset life — or Operational Expenditure (OPEX) — routine maintenance to sustain current performance. Critical for financial reporting and asset accounting.. Valid values are `capex|opex`',
    `cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated and actual cost values associated with this maintenance item (e.g., USD, EUR, GBP). Supports multi-currency operations in a multinational enterprise.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this maintenance item record was created in the system. Used for audit trail, data lineage, and compliance with ISO 9001 document control requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `estimated_cost` DECIMAL(18,2) COMMENT 'Planned total cost estimate for executing this maintenance task item, including labor, materials, and external services. Used for maintenance budget planning, CAPEX/OPEX classification, and cost variance analysis.. Valid values are `^[0-9]{1,15}(.[0-9]{1,2})?$`',
    `estimated_duration_hours` DECIMAL(18,2) COMMENT 'Planned time in hours required to complete this maintenance task item. Used for work order scheduling, capacity planning, and labor cost estimation. Basis for Mean Time To Repair (MTTR) benchmarking.. Valid values are `^[0-9]{1,6}(.[0-9]{1,2})?$`',
    `expected_measurement_value` DECIMAL(18,2) COMMENT 'Target or nominal measurement value expected at the measurement point during inspection or calibration. Used to assess whether the equipment is operating within acceptable parameters and to trigger corrective actions when deviations occur.',
    `hazardous_material_indicator` BOOLEAN COMMENT 'Flag indicating whether this maintenance task involves handling, disposal, or exposure to hazardous materials (chemicals, lubricants, refrigerants, etc.). Triggers REACH/RoHS compliance checks and hazardous waste disposal procedures.. Valid values are `true|false`',
    `interval_unit` STRING COMMENT 'Unit of measure for the maintenance interval, defining whether the interval is time-based (days, weeks, months), usage-based (operating hours, cycles, kilometers), or event-based. Determines the scheduling trigger type.. Valid values are `days|weeks|months|years|operating_hours|cycles|kilometers|starts`',
    `interval_value` DECIMAL(18,2) COMMENT 'Numeric value of the maintenance interval at which this task should be performed (e.g., 90 for every 90 days, 500 for every 500 operating hours). Combined with interval_unit to define the full maintenance cycle.. Valid values are `^[0-9]{1,8}(.[0-9]{1,2})?$`',
    `item_number` STRING COMMENT 'Sequential counter number identifying the position of this task item within its parent maintenance plan or task list. Used for ordering and referencing individual steps (e.g., 0010, 0020, 0030 in SAP PM convention).. Valid values are `^[0-9]{1,4}$`',
    `item_text` STRING COMMENT 'Short descriptive text summarizing the specific maintenance task to be performed, such as Inspect hydraulic seals, Lubricate conveyor bearings, or Calibrate pressure sensor. Used for display and search.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this maintenance item record was last updated. Supports change tracking, audit compliance, and data freshness monitoring in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_time_days` STRING COMMENT 'Number of days in advance that preparation activities (material procurement, permit acquisition, resource booking) must begin before the scheduled execution date of this maintenance task. Supports proactive maintenance scheduling.. Valid values are `^[0-9]+$`',
    `lockout_tagout_required` BOOLEAN COMMENT 'Indicates whether Lockout/Tagout (LOTO) energy isolation procedures must be applied before performing this maintenance task. Mandatory for tasks involving electrical, hydraulic, pneumatic, or thermal energy sources to prevent accidental energization.. Valid values are `true|false`',
    `long_text` STRING COMMENT 'Detailed narrative description of the maintenance task including step-by-step instructions, technical specifications, acceptance criteria, and any special notes for the technician. Supports Standard Operating Procedure (SOP) documentation.',
    `maintenance_category` STRING COMMENT 'Broad category of maintenance strategy this item belongs to, distinguishing between preventive (scheduled), predictive (condition-triggered), corrective (reactive), statutory (regulatory-mandated), and other maintenance types. Supports TPM and reliability-centered maintenance (RCM) analysis.. Valid values are `preventive|predictive|corrective|condition_based|time_based|usage_based|statutory|lubrication|calibration`',
    `material_list_indicator` BOOLEAN COMMENT 'Flag indicating whether this maintenance task item has an associated list of required spare parts, consumables, or materials (Bill of Materials for maintenance). When true, material components are defined in the task list component assignment.. Valid values are `true|false`',
    `measurement_point` STRING COMMENT 'Identifier or description of the specific measurement point on the equipment where readings are to be taken during inspection or condition monitoring tasks (e.g., Bearing Temperature - Drive End, Vibration - Motor NDE). Supports IIoT and condition-based maintenance.',
    `measurement_unit` STRING COMMENT 'Unit of measure for the expected and actual measurement values recorded during this maintenance task (e.g., °C, bar, mm/s, kPa, RPM, mA). Ensures consistent data capture and comparison against specifications.',
    `number_of_technicians` STRING COMMENT 'Number of maintenance technicians or workers required to perform this task item simultaneously. Used for crew sizing, capacity planning, and safety compliance (e.g., confined space entry requiring minimum two persons).. Valid values are `^[1-9][0-9]*$`',
    `permit_required` BOOLEAN COMMENT 'Indicates whether a formal Permit to Work (PTW) is required before executing this maintenance task. Applies to high-risk activities such as hot work, confined space entry, electrical isolation, or working at height. Mandatory for safety compliance.. Valid values are `true|false`',
    `permit_type` STRING COMMENT 'Type of work permit required for this maintenance task when permit_required is true. Determines the safety authorization workflow, hazard controls, and regulatory compliance requirements that must be satisfied before work begins.. Valid values are `hot_work|cold_work|confined_space|electrical_isolation|working_at_height|radiation|excavation|none`',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant or facility where this maintenance item is applicable. Supports multi-plant operations and plant-level maintenance reporting in a multinational enterprise.. Valid values are `^[A-Z0-9]{2,6}$`',
    `ppe_requirements` STRING COMMENT 'Description of the Personal Protective Equipment (PPE) required for safe execution of this maintenance task (e.g., Safety glasses, chemical-resistant gloves, steel-toed boots, hearing protection). Supports safety compliance and technician briefing.',
    `qualification_requirement` STRING COMMENT 'Required skill, trade certification, or qualification level that the assigned technician must possess to perform this maintenance task (e.g., Certified Electrician, Hydraulics Level 2, Confined Space Entry Certified). Supports workforce compliance.',
    `revision_number` STRING COMMENT 'Version or revision identifier of this maintenance item definition, tracking changes made to task instructions, intervals, or requirements over time. Supports document control and change management in compliance with ISO 9001.. Valid values are `^[A-Z0-9]{1,10}$`',
    `sop_reference` STRING COMMENT 'Document number or identifier of the Standard Operating Procedure (SOP) that governs the execution of this maintenance task. Ensures technicians follow approved procedures and supports ISO 9001 document control requirements.',
    `status` STRING COMMENT 'Current lifecycle status of the maintenance item within the maintenance plan. Controls whether the item is actively scheduled and executed. Inactive or obsolete items are retained for audit history.. Valid values are `active|inactive|draft|pending_approval|approved|obsolete|suspended`',
    `task_type` STRING COMMENT 'Classification of the specific maintenance activity to be performed. Drives material requirements, skill requirements, and safety protocols. Supports Total Productive Maintenance (TPM) task decomposition and reporting.. Valid values are `inspection|lubrication|replacement|calibration|cleaning|adjustment|testing|overhaul|repair|measurement|documentation|safety_check`',
    `tolerance_lower_limit` DECIMAL(18,2) COMMENT 'Minimum acceptable measurement value for this maintenance task. Readings below this threshold indicate a non-conformance condition requiring corrective action or Corrective and Preventive Action (CAPA) initiation.',
    `tolerance_upper_limit` DECIMAL(18,2) COMMENT 'Maximum acceptable measurement value for this maintenance task. Readings above this threshold indicate a non-conformance condition requiring corrective action or Corrective and Preventive Action (CAPA) initiation.',
    `valid_from_date` DATE COMMENT 'Date from which this maintenance item definition becomes effective and applicable for scheduling and execution. Supports time-bound validity of maintenance task definitions and change management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Date until which this maintenance item definition remains effective. After this date, the item is no longer scheduled or executed. Supports lifecycle management and planned obsolescence of maintenance tasks.. Valid values are `^d{4}-d{2}-d{2}$`',
    `work_center` STRING COMMENT 'Identifier of the maintenance work center (crew, team, or workshop) responsible for executing this task item. Used for capacity planning, scheduling, and labor cost allocation in SAP PM and Maximo.',
    CONSTRAINT pk_maintenance_item PRIMARY KEY(`maintenance_item_id`)
) COMMENT 'Individual maintenance task items within a maintenance plan, defining the specific inspection, lubrication, replacement, or calibration activity to be performed on a piece of equipment at a defined interval. Captures task list reference, work center assignment, estimated duration, required materials, and safety instructions. Supports TPM task decomposition.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`asset_notification` (
    `asset_notification_id` BIGINT COMMENT 'Unique surrogate identifier for the maintenance notification record in the lakehouse silver layer. Serves as the primary key for this entity.',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Asset notifications (breakdowns, alerts) are raised by or reported to a specific customer contact. Maintenance coordinators use this link to communicate fault status, schedule access, and obtain sign-',
    `installed_base_id` BIGINT COMMENT 'Foreign key linking to customer.installed_base. Business justification: Every asset notification references the specific installed asset at the customer site. Dispatchers and planners use this link to identify which customer-owned equipment is affected and route the notif',
    `assembly` STRING COMMENT 'Identifier of the specific assembly, sub-component, or part of the equipment where the fault or damage was observed. Supports root cause analysis and spare parts planning.',
    `breakdown_indicator` BOOLEAN COMMENT 'Flag indicating whether the notification represents a complete equipment breakdown (unplanned stoppage) as opposed to a degraded performance or minor fault condition. Drives breakdown-specific KPI reporting and emergency response protocols.. Valid values are `true|false`',
    `category` STRING COMMENT 'Operational category classifying the maintenance trigger strategy: PREVENTIVE (scheduled TPM), CORRECTIVE (reactive repair), PREDICTIVE (IIoT/MindSphere condition-based alert), CONDITION_BASED (sensor threshold breach), EMERGENCY (immediate safety/production risk). Supports TPM and maintenance strategy analytics.. Valid values are `PREVENTIVE|CORRECTIVE|PREDICTIVE|CONDITION_BASED|EMERGENCY`',
    `cause_code` STRING COMMENT 'Standardized code from the cause catalog identifying the root cause of the equipment failure or malfunction (e.g., operator error, material fatigue, lubrication failure). Supports CAPA processes and reliability engineering.',
    `cause_description` STRING COMMENT 'Textual description of the identified root cause corresponding to the cause code. Provides narrative context for CAPA documentation and reliability improvement initiatives.',
    `closed_timestamp` TIMESTAMP COMMENT 'Timestamp when the notification was formally closed after business completion confirmation, distinguishing technical completion from administrative closure. Used for lifecycle duration analytics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `completed_timestamp` TIMESTAMP COMMENT 'Timestamp when the notification was marked as technically completed in the source system, indicating all associated maintenance tasks have been executed and documented.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility where the notified asset is located. Supports multinational regulatory compliance reporting and regional maintenance performance benchmarking.. Valid values are `^[A-Z]{3}$`',
    `damage_code` STRING COMMENT 'Standardized code from the damage catalog identifying the type of physical damage or defect observed on the equipment (e.g., wear, corrosion, fracture, leakage). Supports failure pattern analysis and FMEA validation.',
    `damage_description` STRING COMMENT 'Textual description of the observed damage or defect corresponding to the damage code. Provides human-readable context for maintenance planners and engineers performing root cause analysis.',
    `description` STRING COMMENT 'Short text description of the malfunction, damage, or maintenance activity as entered by the reporter. Provides the primary narrative of the issue for maintenance planners and technicians.',
    `effect_code` STRING COMMENT 'Standardized code describing the operational effect or consequence of the malfunction on production (e.g., production stoppage, reduced output, quality defect). Used in FMEA severity assessment and impact analysis.',
    `environment_relevant` BOOLEAN COMMENT 'Flag indicating whether the notified fault has potential environmental impact (e.g., chemical leak, emissions exceedance). Triggers environmental incident reporting per ISO 14001 and EPA regulatory requirements.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the notification record in the source system. Used for incremental data extraction, change tracking, and audit trail maintenance in the lakehouse silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `long_text` STRING COMMENT 'Extended free-text narrative providing detailed description of the fault, observed symptoms, environmental conditions, and any immediate actions taken by the operator at the time of reporting.',
    `main_work_center` STRING COMMENT 'Identifier of the primary maintenance work center (crew or team) responsible for executing the maintenance activities triggered by this notification. Used for capacity planning and workload balancing.',
    `malfunction_end_date` DATE COMMENT 'Date when the equipment malfunction or breakdown was resolved and the asset was returned to operational status. Used for downtime duration calculation and MTTR analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `malfunction_end_time` TIMESTAMP COMMENT 'Precise timestamp when the equipment malfunction was resolved and normal operations resumed. Combined with malfunction start timestamp to compute actual downtime for MTTR and OEE calculations.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `malfunction_start_date` DATE COMMENT 'Date when the equipment malfunction or breakdown actually began, as reported by the operator. May differ from the reported date if the fault was observed after the fact. Used for downtime duration calculation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `malfunction_start_time` TIMESTAMP COMMENT 'Precise timestamp when the equipment malfunction or breakdown commenced. Used in conjunction with malfunction end timestamp to calculate actual downtime duration for OEE and MTBF/MTTR reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `number` STRING COMMENT 'Business-facing alphanumeric identifier for the maintenance notification as assigned by the source system (SAP PM or Maximo EAM). Used for cross-system traceability and shop floor reference.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `object_part_code` STRING COMMENT 'Code identifying the specific part or component of the equipment object where the damage or fault was detected. Enables component-level failure frequency analysis and targeted preventive maintenance planning.',
    `planner_group` STRING COMMENT 'Code identifying the maintenance planning group responsible for processing this notification and creating the associated work order. Determines routing of the notification to the correct maintenance team.',
    `planning_plant` STRING COMMENT 'Plant code of the maintenance planning plant responsible for processing and planning the work associated with this notification. May differ from the plant where the asset is located in centralized maintenance organizations.. Valid values are `^[A-Z0-9]{1,10}$`',
    `plant_code` STRING COMMENT 'SAP plant code or Maximo site identifier representing the manufacturing facility where the notified asset is located. Enables plant-level maintenance performance benchmarking across the multinational enterprise.. Valid values are `^[A-Z0-9]{1,10}$`',
    `priority` STRING COMMENT 'Priority level assigned to the notification indicating urgency of response: 1 (Very High/Emergency), 2 (High), 3 (Medium), 4 (Low). Influences work order scheduling and resource allocation.. Valid values are `1|2|3|4`',
    `reported_by` STRING COMMENT 'User ID or personnel number of the individual who created and submitted the maintenance notification, typically a machine operator, technician, or shift supervisor on the shop floor.',
    `reported_date` DATE COMMENT 'Calendar date on which the maintenance notification was formally reported and entered into the system. Used for aging analysis and SLA compliance measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reported_timestamp` TIMESTAMP COMMENT 'Precise date and time when the notification was created in the source system, including timezone offset. Critical for calculating response time SLAs and shift-based analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `required_end_date` DATE COMMENT 'Date by which the maintenance work associated with this notification must be completed. Defines the deadline for work order execution and is used for SLA breach detection and escalation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `required_start_date` DATE COMMENT 'Date by which maintenance work associated with this notification must commence, as specified by the requester or maintenance planner. Used for scheduling and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `safety_relevant` BOOLEAN COMMENT 'Flag indicating whether the notified malfunction or damage has safety implications for personnel, equipment, or the environment. Triggers mandatory escalation to HSE teams and may invoke OSHA/ISO 45001 incident reporting protocols.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this notification record was sourced (e.g., SAP PM, Maximo EAM). Supports data lineage tracking and multi-system reconciliation in the lakehouse.. Valid values are `SAP_PM|MAXIMO_EAM|SIEMENS_OPCENTER|MINDSPHERE|MANUAL`',
    `source_system_code` STRING COMMENT 'Native primary key or record identifier of the notification in the originating source system (e.g., SAP QMNUM or Maximo SR number). Enables reverse lookup and reconciliation with the system of record.',
    `status` STRING COMMENT 'Current processing status of the notification using SAP PM system status codes: OSNO (Outstanding, Not in Process), NOPR (Notification in Process), ORAS (Order Assigned), NOCO (Notification Completed), CLSD (Closed), CANC (Cancelled). Drives workflow routing and reporting.. Valid values are `OSNO|NOPR|ORAS|NOCO|CLSD|CANC`',
    `type` STRING COMMENT 'Classification of the maintenance notification per SAP PM standard types: M1 (Malfunction Report), M2 (Activity Request), M3 (Inspection Request), M4 (General Maintenance Request). Drives downstream work order creation logic and prioritization.. Valid values are `M1|M2|M3|M4`',
    `work_order_number` STRING COMMENT 'Reference number of the maintenance work order created from this notification. Captures the downstream linkage between the notification trigger and the execution order for traceability and audit purposes.',
    CONSTRAINT pk_asset_notification PRIMARY KEY(`asset_notification_id`)
) COMMENT 'Maintenance notification records capturing equipment malfunction reports, damage notifications, activity requests, and operator-initiated fault reports from the shop floor. Serves as the upstream trigger for work order creation. Captures notification type (M1-malfunction, M2-activity, M3-inspection), reported damage, cause codes, and breakdown indicators. Sourced from SAP PM Notifications (QMEL) and Maximo EAM Service Requests.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`measurement_point` (
    `measurement_point_id` BIGINT COMMENT 'Unique system-generated identifier for a measurement point or counter position defined on a piece of equipment or technical object. Serves as the primary key for the measurement point entity.',
    `maintenance_plan_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_plan. Business justification: measurement_point has a maintenance_strategy_code STRING attribute indicating its association with a maintenance strategy. In EAM counter-based maintenance, measurement points (counters) are directly ',
    `product_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.product_specification. Business justification: Measurement points on assets are defined against product specifications from engineering, which set the nominal values and tolerance limits. Condition monitoring teams use this link to evaluate whethe',
    `alert_enabled` BOOLEAN COMMENT 'Indicates whether automated alerts or notifications are configured for this measurement point when readings breach the defined upper or lower limit thresholds. Drives real-time alarm management in SCADA and MindSphere.. Valid values are `true|false`',
    `calibration_interval_days` STRING COMMENT 'Number of days between required calibration events for the sensor or instrument at this measurement point. Used to schedule preventive calibration work orders and ensure measurement traceability.. Valid values are `^[0-9]+$`',
    `calibration_required` BOOLEAN COMMENT 'Indicates whether the sensor or instrument associated with this measurement point requires periodic calibration to maintain measurement accuracy. Drives calibration work order generation and compliance with metrology standards.. Valid values are `true|false`',
    `category` STRING COMMENT 'Classifies the measurement point as either a counter (accumulating numeric value such as operating hours or cycle count used for counter-based maintenance triggering) or a characteristic (instantaneous measurement such as temperature, pressure, or vibration used for condition monitoring).. Valid values are `counter|characteristic`',
    `characteristic_code` STRING COMMENT 'Reference code linking this measurement point to a classification characteristic in the EAM/PLM system (e.g., SAP classification characteristic or Teamcenter attribute). Enables structured querying and grouping of measurement points by engineering characteristic.. Valid values are `^[A-Z0-9_]{1,30}$`',
    `condition_monitoring_enabled` BOOLEAN COMMENT 'Indicates whether this measurement point is actively used for condition-based maintenance (CBM) monitoring. When true, readings are evaluated against thresholds to trigger predictive maintenance work orders via MindSphere or SAP PM.. Valid values are `true|false`',
    `counter_overflow_value` DECIMAL(18,2) COMMENT 'Maximum value a counter-type measurement point can reach before rolling over to zero. Critical for correctly computing cumulative counter readings across overflow events (e.g., an odometer rolling over at 999,999 km). Applicable only to category=counter.',
    `counter_reading_direction` STRING COMMENT 'Indicates whether the counter increments upward (ascending, e.g., operating hours accumulating) or decrements downward (descending, e.g., remaining service life countdown). Applicable only to category=counter.. Valid values are `ascending|descending`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this measurement point record was first created in the source system. Supports audit trail, data lineage, and lifecycle tracking for the measurement point.',
    `decimal_places` STRING COMMENT 'Number of decimal places to which measurement readings are recorded and displayed for this measurement point. Controls precision of data capture and reporting.. Valid values are `^[0-9]$`',
    `last_calibration_date` DATE COMMENT 'Date on which the most recent calibration of the sensor or instrument at this measurement point was performed. Used to calculate next calibration due date and assess current measurement validity.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this measurement point record was most recently updated in the source system. Used for change detection, incremental data loading in the lakehouse Silver layer, and audit compliance.',
    `last_reading_by` STRING COMMENT 'User ID or system identifier of the person or automated process that recorded the most recent measurement reading. Supports audit trail and data quality validation for manual readings.',
    `last_reading_timestamp` TIMESTAMP COMMENT 'Date and time when the most recent measurement reading was recorded at this point. Used to assess data freshness, identify stale sensors, and support maintenance scheduling based on elapsed time since last reading.',
    `last_reading_value` DECIMAL(18,2) COMMENT 'Most recent measurement reading recorded at this measurement point. Provides the current state of the monitored parameter for real-time dashboards, maintenance scheduling, and condition assessment without querying the full reading history.',
    `lower_limit` DECIMAL(18,2) COMMENT 'Minimum acceptable value for readings at this measurement point. Readings below this threshold trigger alerts, condition-based maintenance work orders, or SCADA alarms. Used in Statistical Process Control (SPC) and predictive maintenance analytics.',
    `maintenance_strategy_code` STRING COMMENT 'Code of the maintenance strategy (e.g., time-based, counter-based, condition-based) associated with this measurement point. Determines how maintenance plans and task lists are triggered based on readings from this point.. Valid values are `^[A-Z0-9_-]{1,20}$`',
    `mindsphere_aspect_name` STRING COMMENT 'Name of the MindSphere aspect (logical grouping of related time-series variables) to which this measurement points sensor variable belongs. Aspects organize sensor data streams for analytics and Digital Twin modeling in MindSphere.',
    `mindsphere_asset_reference` STRING COMMENT 'Identifier of the digital asset in Siemens MindSphere IIoT Platform to which this measurement point is bound. Enables real-time sensor data ingestion, edge computing, and predictive analytics via MindSphere.',
    `mindsphere_variable_name` STRING COMMENT 'Specific time-series variable name within the MindSphere aspect that maps to this measurement point. Provides the exact binding between the physical sensor signal and the MindSphere data model for real-time streaming and predictive analytics.',
    `name` STRING COMMENT 'Descriptive name of the measurement point that identifies its physical or logical location and purpose on the equipment (e.g., Spindle Vibration Sensor, Operating Hours Counter, Coolant Temperature).',
    `plant_code` STRING COMMENT 'Code of the manufacturing plant or facility where the equipment bearing this measurement point is located. Supports multi-site reporting and plant-level condition monitoring dashboards.. Valid values are `^[A-Z0-9]{1,10}$`',
    `plc_address` STRING COMMENT 'Memory address or register reference in the PLC that provides the raw signal for this measurement point. Used for IT/OT convergence data pipelines to pull readings directly from PLC registers into the lakehouse.',
    `point_number` STRING COMMENT 'Business-facing alphanumeric identifier for the measurement point as defined in the source EAM/CMMS system (e.g., SAP PM measurement point number). Used for cross-system referencing and shop-floor identification.. Valid values are `^[A-Z0-9_-]{1,30}$`',
    `point_type` STRING COMMENT 'Physical or engineering type of the measurement being captured at this point. Drives sensor configuration, alarm thresholds, and analytics models in Siemens MindSphere and SAP PM.. Valid values are `vibration|temperature|pressure|flow|current|voltage|speed|torque|humidity|operating_hours|cycle_count|distance|weight|other`',
    `reading_method` STRING COMMENT 'Indicates how measurement readings are captured: automatic (via IIoT sensor/SCADA integration), manual (technician enters reading during inspection or maintenance), or semi_automatic (sensor-assisted but requires manual confirmation).. Valid values are `automatic|manual|semi_automatic`',
    `sampling_interval_seconds` STRING COMMENT 'Frequency in seconds at which sensor readings are captured and transmitted for this measurement point. Drives data volume planning, edge computing configuration, and real-time alerting latency in MindSphere and SCADA systems.. Valid values are `^[0-9]+$`',
    `scada_tag_name` STRING COMMENT 'Tag name or address in the SCADA or DCS system that corresponds to this measurement point. Enables mapping between the EAM measurement point and the operational technology (OT) data source for automated reading ingestion.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this measurement point record originates (e.g., SAP PM, Maximo EAM, Siemens MindSphere). Supports data lineage tracking and multi-system reconciliation in the Silver layer.. Valid values are `SAP_PM|MAXIMO|MINDSPHERE|OPCENTER|SCADA|MANUAL`',
    `source_system_key` STRING COMMENT 'Natural key or primary identifier of this measurement point record in the originating source system (e.g., SAP PM measurement point number, Maximo meter ID). Enables reverse lookup and reconciliation with the system of record.',
    `status` STRING COMMENT 'Current operational status of the measurement point. active indicates readings are being collected; inactive means temporarily disabled; decommissioned means permanently retired; under_calibration means the point is offline for calibration; suspended means paused due to equipment downtime.. Valid values are `active|inactive|decommissioned|under_calibration|suspended`',
    `target_value` DECIMAL(18,2) COMMENT 'Optimal or nominal expected value for readings at this measurement point under normal operating conditions. Used as the baseline for deviation analysis, OEE calculations, and predictive maintenance models.',
    `unit_of_measure` STRING COMMENT 'Engineering unit in which measurement readings are recorded at this point (e.g., h for hours, rpm for revolutions per minute, °C for Celsius, bar for pressure, mm/s for vibration velocity). Aligns with SAP PM unit of measure configuration.. Valid values are `^[A-Za-z0-9°/%µ]{1,20}$`',
    `upper_limit` DECIMAL(18,2) COMMENT 'Maximum acceptable value for readings at this measurement point. Readings exceeding this threshold trigger alerts, condition-based maintenance work orders, or SCADA alarms. Used in SPC and predictive maintenance analytics.',
    `work_center_code` STRING COMMENT 'Code of the work center or production cell associated with the equipment on which this measurement point resides. Enables OEE and condition monitoring analysis at the work center level.. Valid values are `^[A-Z0-9_-]{1,20}$`',
    `valid_from` DATE COMMENT 'Date from which this measurement point definition is effective and readings should be collected. Supports temporal validity management for measurement point configurations that change over the asset lifecycle.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to` DATE COMMENT 'Date until which this measurement point definition is effective. After this date, the measurement point is considered expired or superseded. Used for lifecycle management and historical data segmentation.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_measurement_point PRIMARY KEY(`measurement_point_id`)
) COMMENT 'Defines measurement points and counter positions on equipment for condition monitoring, counter-based maintenance triggering, and IIoT sensor data integration. Captures measurement point category (counter, characteristic), unit of measure, upper/lower limits, and MindSphere sensor binding. Enables condition-based maintenance and predictive analytics via Siemens MindSphere.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`measurement_reading` (
    `measurement_reading_id` BIGINT COMMENT 'Unique surrogate identifier for each measurement reading record in the asset domain. Serves as the primary key for the measurement_reading data product in the Databricks Silver Layer.',
    `measurement_point_id` BIGINT COMMENT 'Foreign key linking to asset.measurement_point. Business justification: Readings are captured at measurement points. Adding measurement_point_id FK establishes the parent-child relationship and allows removal of denormalized point number and name which can be retrieved vi',
    `sensor_measurement_point_id` BIGINT COMMENT 'Unique identifier of the IIoT sensor, transducer, or instrumentation device that captured the reading. Relevant for automated readings from Siemens MindSphere, SCADA, or PLC/DCS integrations. Supports sensor-level diagnostics and calibration tracking.',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: Measurement readings (e.g., vibration, temperature, pressure) must reference a standard unit of measure. Using the shared product UOM catalog ensures readings are comparable against product design spe',
    `breach_severity` STRING COMMENT 'Severity classification of the threshold breach for this reading: none (within limits), warning (advisory), alarm (action required), or critical (immediate shutdown/intervention required). Drives maintenance priority and escalation workflows.. Valid values are `none|warning|alarm|critical`',
    `calibration_due_date` DATE COMMENT 'Date by which the sensor or measurement instrument used for this reading is due for recalibration. Supports instrument calibration compliance tracking per ISO 9001 and ISO/IEC 17025 requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `characteristic_value` STRING COMMENT 'Qualitative or coded value for characteristic-type readings where the result is non-numeric (e.g., OK, NOK, Leaking, Corroded). Used for inspection-type measurement points that capture condition descriptions rather than numeric values.',
    `counter_overflow_indicator` BOOLEAN COMMENT 'Flag indicating whether a counter-type reading has overflowed (i.e., reset to zero after reaching its maximum value). Critical for accurate MTBF and operating hour calculations on assets with cyclical counters.. Valid values are `true|false`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility where the measurement was taken. Supports multinational regulatory compliance reporting (e.g., OSHA, EPA, EU directives) and regional analytics.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the measurement reading record was created in the system. Supports data lineage, audit trail, and Silver Layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `delta_value` DECIMAL(18,2) COMMENT 'Difference between the current counter reading and the previous counter reading for counter-type measurement points. Represents the incremental consumption or usage since the last reading (e.g., hours run, cycles completed). Used for usage-based maintenance scheduling.',
    `functional_location` STRING COMMENT 'Hierarchical plant structure identifier representing the physical location of the asset (e.g., plant, production line, work center). Aligns with SAP PM Functional Location (IL01) and Maximo Location hierarchy for spatial analytics.',
    `is_estimated` BOOLEAN COMMENT 'Indicates whether the reading value was estimated (e.g., interpolated due to sensor gap, manually estimated by technician) rather than directly measured. Estimated readings are flagged for analytics quality control and excluded from certain SPC calculations.. Valid values are `true|false`',
    `last_calibration_date` DATE COMMENT 'Date on which the sensor or measurement instrument was last calibrated. Used to assess the validity and reliability of the reading value and to support ISO 9001 measurement system compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the measurement reading record was last updated or corrected. Supports change tracking, data quality audits, and Silver Layer incremental processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lower_alarm_limit` DECIMAL(18,2) COMMENT 'Lower critical alarm threshold for the measurement point. A reading below this value indicates a critical condition requiring immediate maintenance intervention or asset shutdown to prevent failure.',
    `lower_warning_limit` DECIMAL(18,2) COMMENT 'Lower warning threshold value for the measurement point. A reading below this value triggers a warning alert for condition-based maintenance review, without necessarily requiring immediate action.',
    `maintenance_plan_number` STRING COMMENT 'Reference to the preventive maintenance plan or inspection plan that scheduled this reading, if applicable. Supports TPM (Total Productive Maintenance) compliance tracking and planned vs. actual reading analysis.',
    `plant_code` STRING COMMENT 'SAP plant code or facility identifier representing the manufacturing site where the asset and measurement point are located. Supports multi-site, multinational reporting and plant-level OEE and maintenance analytics.',
    `reading_date` DATE COMMENT 'Calendar date on which the measurement reading was recorded. Used for day-level aggregation, maintenance scheduling, and compliance reporting distinct from the precise timestamp.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reading_number` STRING COMMENT 'Business-facing alphanumeric identifier for the measurement reading, as assigned by the source system (e.g., Maximo EAM or SAP PM). Used for cross-system traceability and audit referencing.',
    `reading_quality` STRING COMMENT 'Data quality indicator for the reading value, aligned with OPC-UA quality codes. Indicates whether the reading is reliable (good), potentially unreliable (uncertain), or invalid (bad, sensor fault, out of range). Critical for IIoT and SCADA data quality management.. Valid values are `good|uncertain|bad|not_connected|out_of_range|sensor_fault`',
    `reading_source` STRING COMMENT 'Origin of the measurement reading indicating how it was captured: manual inspection by a technician, automated IIoT sensor via Siemens MindSphere, SCADA system integration, MES shop floor data, PLC/DCS direct feed, or API integration.. Valid values are `manual|iiot_sensor|scada|mes|plc|dcs|iot_gateway|api`',
    `reading_status` STRING COMMENT 'Lifecycle status of the measurement reading record. Active readings are valid for condition monitoring; cancelled readings have been voided; superseded readings have been replaced by corrected values; pending_review readings await technician validation.. Valid values are `active|cancelled|superseded|pending_review|approved`',
    `reading_taken_by` STRING COMMENT 'Identifier or name of the technician, operator, or automated system that captured the reading. For manual readings, this is the personnel ID or name. For automated readings, this is the system or sensor identifier. Supports accountability and audit trails.',
    `reading_timestamp` TIMESTAMP COMMENT 'Exact date and time when the measurement or counter reading was captured at the measurement point. Critical for time-series analysis, condition-based maintenance triggering, and IIoT/SCADA data correlation via Siemens MindSphere.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `reading_type` STRING COMMENT 'Classification of the reading as a continuous measurement (e.g., temperature, pressure), a counter (e.g., operating hours, cycle count), or a characteristic (e.g., qualitative inspection result). Drives downstream processing logic for condition-based maintenance.. Valid values are `measurement|counter|characteristic`',
    `reading_value` DECIMAL(18,2) COMMENT 'Actual numeric value of the measurement captured at the measurement point (e.g., temperature in Celsius, vibration in mm/s, pressure in bar, counter in hours or cycles). Core data element for condition monitoring and predictive maintenance analytics.',
    `remarks` STRING COMMENT 'Free-text field for technician or system notes associated with the reading (e.g., observed abnormal noise, sensor replaced prior to reading, reading taken under non-standard operating conditions). Supports qualitative context for maintenance decision-making.',
    `sensor_tag` STRING COMMENT 'Engineering tag name of the sensor or instrument as defined in the plant instrumentation and control system (e.g., P&ID tag number, SCADA tag). Used by maintenance engineers and process engineers for cross-referencing with plant documentation.',
    `source_system` STRING COMMENT 'Operational system of record from which the measurement reading originated (e.g., Maximo EAM, SAP PM, Siemens MindSphere, Opcenter MES, SCADA). Supports data lineage, reconciliation, and cross-system audit trails.. Valid values are `maximo|sap_pm|mindsphere|opcenter_mes|scada|manual|plc|dcs|other`',
    `source_system_reading_reference` STRING COMMENT 'Native identifier of the measurement reading record in the originating source system (e.g., Maximo measurement document number, SAP PM measurement document number). Enables traceability back to the system of record.',
    `threshold_breach_indicator` BOOLEAN COMMENT 'Flag indicating whether the reading value has breached any defined threshold (warning or alarm limit). When True, the reading triggers downstream condition-based maintenance workflows or work order creation.. Valid values are `true|false`',
    `unit_of_measure` STRING COMMENT 'Engineering unit in which the reading value is expressed (e.g., °C, bar, mm/s, kPa, RPM, kWh, hours, cycles). Aligned with ISO 80000 international system of units for standardized measurement reporting.',
    `upper_alarm_limit` DECIMAL(18,2) COMMENT 'Upper critical alarm threshold for the measurement point. A reading above this value indicates a critical condition requiring immediate maintenance intervention or asset shutdown to prevent failure.',
    `upper_warning_limit` DECIMAL(18,2) COMMENT 'Upper warning threshold value for the measurement point. A reading above this value triggers a warning alert for condition-based maintenance review, without necessarily requiring immediate action.',
    CONSTRAINT pk_measurement_reading PRIMARY KEY(`measurement_reading_id`)
) COMMENT 'Time-series transactional records of actual measurement readings and counter readings captured at defined measurement points on manufacturing equipment. Includes readings from manual inspections, automated IIoT sensors via MindSphere, and SCADA system integrations. Captures reading value, unit, reading timestamp, source system, and threshold breach indicators for condition-based maintenance triggering.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`calibration_record` (
    `calibration_record_id` BIGINT COMMENT 'Unique system-generated identifier for each calibration record within the enterprise asset management system.',
    `cost_allocation_id` BIGINT COMMENT 'Foreign key linking to finance.cost_allocation. Business justification: Calibration services for precision manufacturing equipment carry direct costs (external lab fees, technician time) that must be allocated to the owning cost center. Quality and finance teams track cal',
    `installed_base_id` BIGINT COMMENT 'Foreign key linking to customer.installed_base. Business justification: Calibration records are performed on specific instruments in the customers installed base. Quality and compliance teams use this link to produce calibration certificates tied to the customers asset ',
    `material_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.material_specification. Business justification: Calibration of measurement instruments must reference the engineering material specification that defines acceptable tolerance and measurement standards. Quality and metrology teams use this link to v',
    `measurement_point_id` BIGINT COMMENT 'Foreign key linking to asset.measurement_point. Business justification: Calibration is specific to measurement points on equipment. Adding measurement_point_id FK enables point-level calibration tracking and history.',
    `product_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.product_specification. Business justification: Calibration must verify equipment meets engineering specifications. Quality and metrology teams reference product specs to determine calibration acceptance criteria and measurement uncertainty require',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Calibration services are performed by certified external suppliers. Procurement manages these service suppliers; linking calibration records to the supplier enables spend tracking, re-qualification sc',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: Calibration records capture measured values in specific units of measure. Referencing the shared UOM catalog ensures consistency between product specifications and calibration tolerances used by quali',
    `work_order_operation_id` BIGINT COMMENT 'Foreign key linking to asset.work_order_operation. Business justification: Calibration activities in manufacturing are executed as work order operations within the EAM/CMMS system. Linking calibration_record.work_order_operation_id → work_order_operation.work_order_operation',
    `adjustment_made_flag` BOOLEAN COMMENT 'Indicates whether a physical adjustment or repair was made to the instrument during the calibration event. When true, as-found and as-left values will differ, and impact assessment on prior measurements may be required.. Valid values are `true|false`',
    `approval_date` DATE COMMENT 'Date on which the calibration record was formally reviewed and approved by the authorized quality reviewer. Required for QMS document control and audit readiness.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Employee ID of the quality engineer or metrology supervisor who reviewed and approved the calibration record. Supports four-eyes principle and QMS document control requirements.',
    `as_found_value` DECIMAL(18,2) COMMENT 'Measured value of the instrument before any calibration adjustment is made. Represents the instruments condition at the time of calibration arrival. Critical for drift analysis and out-of-tolerance impact assessment.',
    `as_left_value` DECIMAL(18,2) COMMENT 'Measured value of the instrument after calibration adjustment or verification. Confirms the instrument meets required accuracy specifications before being returned to service.',
    `calibration_date` DATE COMMENT 'Date on which the calibration was performed. Core traceability field required by ISO 9001 QMS calibration control. Used to calculate calibration intervals and overdue status.. Valid values are `^d{4}-d{2}-d{2}$`',
    `calibration_interval_days` STRING COMMENT 'Defined calibration frequency in calendar days between successive calibrations. Determined by instrument criticality, manufacturer recommendation, and historical drift analysis. Used to compute next_due_date.. Valid values are `^[1-9][0-9]*$`',
    `calibration_method` STRING COMMENT 'Reference to the calibration procedure or method used (e.g., SOP number, standard method reference such as ASTM E74, ISO 376). Ensures repeatability and traceability of the calibration process.',
    `calibration_number` STRING COMMENT 'Human-readable business identifier for the calibration event, typically generated by the QMS or EAM system (e.g., SAP QM or Maximo). Used for cross-referencing with calibration certificates and work orders.. Valid values are `^CAL-[A-Z0-9]{4,10}-[0-9]{6}$`',
    `calibration_standard_reference` STRING COMMENT 'Identifier or description of the reference standard used to perform the calibration (e.g., NIST-traceable dead weight tester, certified reference gauge). Establishes metrological traceability chain.',
    `calibration_type` STRING COMMENT 'Classification of the calibration event indicating the reason or trigger for calibration. Supports analysis of calibration frequency drivers and QMS audit trails.. Valid values are `initial|periodic|after_repair|after_adjustment|unscheduled|pre_use|post_use`',
    `capa_reference_number` STRING COMMENT 'Reference number of the CAPA initiated as a result of an out-of-tolerance finding. Links the calibration record to the quality management corrective action workflow in the QMS.',
    `certificate_issue_date` DATE COMMENT 'Date on which the calibration certificate was formally issued by the performing laboratory or technician. May differ from calibration_date if certificate issuance is delayed.. Valid values are `^d{4}-d{2}-d{2}$`',
    `certificate_number` STRING COMMENT 'Unique identifier of the calibration certificate issued upon completion of the calibration. Required for QMS documentation control and regulatory audit traceability.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the calibration record was first created in the system. Provides audit trail for QMS document control and data lineage in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `environmental_humidity_percent` DECIMAL(18,2) COMMENT 'Relative humidity percentage at the calibration location at the time of calibration. Required environmental condition documentation per ISO/IEC 17025 for precision metrology.. Valid values are `^(100(.0+)?|[0-9]{1,2}(.[0-9]+)?)$`',
    `environmental_temperature_c` DECIMAL(18,2) COMMENT 'Ambient temperature in degrees Celsius at the time and location of calibration. Environmental conditions can affect measurement accuracy and are required to be documented per ISO/IEC 17025.',
    `functional_location` STRING COMMENT 'Functional location code from the EAM hierarchy (SAP PM or Maximo) indicating where the instrument is installed (e.g., production line, test bench, quality lab). Supports location-based calibration scheduling.',
    `instrument_description` STRING COMMENT 'Descriptive name and specification of the measurement instrument or test equipment being calibrated (e.g., Digital Torque Wrench 0-200 Nm, Pressure Transmitter 0-10 bar).',
    `instrument_tag` STRING COMMENT 'Plant-specific tag or loop number assigned to the measurement instrument or gauge on the shop floor (e.g., TI-101, FT-205). Used in P&ID documentation and SCADA/DCS systems for field identification.',
    `laboratory_accreditation_number` STRING COMMENT 'Accreditation body registration number of the calibration laboratory (e.g., A2LA, UKAS, DAkkS accreditation number). Confirms the laboratorys competence per ISO/IEC 17025 and supports regulatory compliance.',
    `laboratory_name` STRING COMMENT 'Name of the laboratory or service provider that performed the calibration. May be an internal metrology lab or an external accredited calibration laboratory.',
    `laboratory_type` STRING COMMENT 'Classification of the calibration laboratory indicating whether calibration was performed internally or by an external accredited/non-accredited provider. Affects traceability requirements and QMS documentation.. Valid values are `internal|external_accredited|external_non_accredited|oem_service_center`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the calibration record. Supports change tracking, audit trail requirements, and incremental data loading in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `manufacturer` STRING COMMENT 'Name of the manufacturer of the measurement instrument or test equipment being calibrated. Used for warranty tracking, spare parts sourcing, and manufacturer-specific calibration procedures.',
    `measurement_uncertainty` DECIMAL(18,2) COMMENT 'Expanded measurement uncertainty (typically at 95% confidence level, k=2) associated with the calibration result, expressed in the same unit as the measurement. Required by ISO/IEC 17025 accredited laboratories.',
    `measurement_unit` STRING COMMENT 'Unit of measure for the as-found and as-left calibration values (e.g., bar, psi, °C, Nm, mm, V, A). Required for correct interpretation of calibration readings.',
    `model_number` STRING COMMENT 'Manufacturer model number of the measurement instrument. Used to identify the correct calibration procedure and reference standard requirements.',
    `next_due_date` DATE COMMENT 'Date by which the next calibration must be completed to maintain measurement traceability and QMS compliance. Drives calibration scheduling in the EAM/CMMS system.. Valid values are `^d{4}-d{2}-d{2}$`',
    `out_of_tolerance_impact` STRING COMMENT 'Assessment of the potential impact on product quality when an instrument is found out of tolerance. Supports CAPA initiation and product disposition decisions per ISO 9001 requirements.. Valid values are `no_impact|impact_assessment_required|product_recall_initiated|product_quarantined|no_product_affected`',
    `performed_by` STRING COMMENT 'Employee ID or technician identifier of the person who performed the calibration. Supports competency verification and audit trail requirements. Not a personal name to avoid PII concerns.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility where the instrument is installed and calibrated. Supports multi-site calibration program management.',
    `remarks` STRING COMMENT 'Free-text field for additional observations, anomalies, or notes recorded by the calibration technician during the calibration event. Supports root cause analysis and audit documentation.',
    `result` STRING COMMENT 'Overall outcome of the calibration event indicating whether the instrument met the required accuracy specifications. Drives disposition decisions and QMS non-conformance workflows.. Valid values are `pass|fail|conditional_pass|adjusted_pass|out_of_tolerance|void`',
    `serial_number` STRING COMMENT 'Manufacturer serial number of the measurement instrument. Provides unique physical traceability for the instrument across its calibration history.',
    `standard_certificate_number` STRING COMMENT 'Certificate number of the reference standard used during calibration, confirming its own traceability to national or international measurement standards (e.g., NIST, PTB, NPL).',
    `status` STRING COMMENT 'Current lifecycle status of the calibration record within the QMS workflow. Controls visibility and usability of the record for compliance reporting and audit purposes.. Valid values are `draft|pending_review|approved|cancelled|superseded|void`',
    `tolerance_lower_limit` DECIMAL(18,2) COMMENT 'Minimum acceptable deviation from the nominal value for the instrument to be considered within calibration tolerance. Used in conjunction with tolerance_upper_limit to determine pass/fail result.',
    `tolerance_upper_limit` DECIMAL(18,2) COMMENT 'Maximum acceptable deviation from the nominal value for the instrument to be considered within calibration tolerance. Used to determine pass/fail result.',
    CONSTRAINT pk_calibration_record PRIMARY KEY(`calibration_record_id`)
) COMMENT 'Calibration and metrology records for precision manufacturing equipment, measurement instruments, gauges, and test equipment. Captures calibration date, calibration standard used, as-found and as-left values, calibration result (pass/fail), next due date, calibration certificate reference, and accredited laboratory details. Supports ISO 9001 QMS calibration control requirements and regulatory compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`asset_valuation` (
    `asset_valuation_id` BIGINT COMMENT 'Unique surrogate identifier for each asset valuation record in the SAP FI-AA fixed asset accounting module. Serves as the primary key for the asset_valuation data product in the Databricks Silver layer.',
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.location. Business justification: Asset valuation must reflect the physical location of the asset for depreciation, insurance, and tax purposes. Finance and fixed-asset teams link valuations to logistics locations to correctly allocat',
    `asset_transaction_id` BIGINT COMMENT 'Foreign key linking to finance.asset_transaction. Business justification: Asset valuations are directly posted as financial asset transactions (acquisitions, depreciation, write-offs). Fixed asset accounting teams link every valuation movement to its corresponding financial',
    `chart_of_accounts_id` BIGINT COMMENT 'Foreign key linking to finance.chart_of_accounts. Business justification: Each asset valuation must post to a specific GL account (asset account, accumulated depreciation account). Finance controllers require this link to ensure valuations hit the correct balance sheet acco',
    `class_id` BIGINT COMMENT 'Foreign key linking to asset.class. Business justification: asset_valuation stores asset_class_code as a STRING reference to the asset classification taxonomy. The class product is the authoritative source for asset classification with depreciation_method, use',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Asset depreciation and revaluation runs are executed period-by-period. Finance teams close asset books per fiscal period — this link drives period-end depreciation runs and ensures valuations align wi',
    `installed_base_id` BIGINT COMMENT 'Foreign key linking to customer.installed_base. Business justification: Asset valuations are performed on specific customer-installed equipment for insurance, depreciation, or lease purposes. Finance and asset management teams link valuations to the installed base to main',
    `sales_price_list_id` BIGINT COMMENT 'Foreign key linking to sales.sales_price_list. Business justification: Asset valuations in industrial manufacturing reference the current sales price list to establish replacement cost or fair market value — used by finance and insurance teams during asset lifecycle revi',
    `accumulated_depreciation` DECIMAL(18,2) COMMENT 'Total depreciation charged against the asset from the capitalization date to the current valuation date. Represents the cumulative reduction in asset value due to wear, obsolescence, and usage over its useful life.',
    `accumulated_depreciation_gl_account` STRING COMMENT 'The SAP General Ledger contra-asset account code used to record accumulated depreciation for this asset. Supports balance sheet presentation of gross asset value less accumulated depreciation.',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'The original historical cost of acquiring the asset, including purchase price, import duties, installation costs, and any directly attributable costs to bring the asset to its intended use. Recorded in the transaction currency per IAS 16.',
    `acquisition_cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the acquisition cost transaction currency (e.g., USD, EUR, CNY). Supports multi-currency asset accounting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `acquisition_cost_group_currency` DECIMAL(18,2) COMMENT 'The acquisition cost translated into the group reporting currency (e.g., USD for a US-headquartered multinational). Used for consolidated financial reporting and CAPEX tracking at the enterprise level.',
    `acquisition_date` DATE COMMENT 'The date on which the asset was acquired or purchased. May differ from the capitalization date if the asset was under construction or in transit before being placed in service.. Valid values are `^d{4}-d{2}-d{2}$`',
    `asset_sub_number` STRING COMMENT 'SAP FI-AA sub-asset number used to track individual components or additions to a main asset (e.g., a capital improvement added to an existing machine). Enables component-level depreciation tracking.',
    `asset_under_construction_flag` BOOLEAN COMMENT 'Indicates whether the asset is currently classified as an Asset Under Construction (AUC) in SAP FI-AA. AUC assets are not yet depreciated and are transferred to a final asset class upon completion and capitalization.. Valid values are `true|false`',
    `capex_project_number` STRING COMMENT 'The SAP Project System (PS) or internal project number associated with the capital expenditure that funded this asset acquisition. Links the asset to the originating CAPEX budget and project for investment tracking and ROI analysis.',
    `capitalization_date` DATE COMMENT 'The date on which the asset was capitalized and placed into service for depreciation purposes in SAP FI-AA. This is the start date for depreciation calculation and is critical for CAPEX accounting under IAS 16 and GAAP ASC 360.. Valid values are `^d{4}-d{2}-d{2}$`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity or subsidiary that owns the asset for financial accounting purposes. Supports multi-entity IFRS/GAAP reporting across the multinational enterprise.',
    `controlling_area_code` STRING COMMENT 'SAP Controlling (CO) area code that groups company codes for internal cost accounting and CAPEX/OPEX reporting. Enables cross-company cost center analysis and asset cost allocation.',
    `cost_center_code` STRING COMMENT 'The SAP Controlling cost center to which depreciation and asset-related costs are allocated. Enables OPEX cost allocation to manufacturing departments, plants, or business units for internal reporting.',
    `current_period_depreciation` DECIMAL(18,2) COMMENT 'The depreciation expense charged for the current fiscal period (month or year) as calculated by the SAP FI-AA depreciation run. Used for P&L reporting and OPEX cost allocation to cost centers.',
    `date` DATE COMMENT 'The date as of which the asset valuation figures (net book value, accumulated depreciation) are reported. Typically corresponds to the fiscal period-end or year-end closing date for balance sheet reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `depreciation_key` STRING COMMENT 'The SAP FI-AA depreciation key code that defines the specific depreciation calculation method, period control, and base value for the asset (e.g., LINR for straight-line, DGRW for declining balance). Drives automated depreciation posting.',
    `depreciation_method` STRING COMMENT 'The accounting method used to allocate the depreciable cost of the asset over its useful life (e.g., straight-line, declining balance, units of production). Determined by asset class and must comply with IFRS/GAAP policies.. Valid values are `straight_line|declining_balance|double_declining_balance|units_of_production|sum_of_years_digits|MACRS|other`',
    `disposal_date` DATE COMMENT 'The date on which the asset was retired, sold, scrapped, or otherwise disposed of. Triggers derecognition of the asset from the balance sheet and recognition of any gain or loss on disposal per IAS 16.. Valid values are `^d{4}-d{2}-d{2}$`',
    `disposal_proceeds` DECIMAL(18,2) COMMENT 'The net proceeds received from the sale or disposal of the asset. Used to calculate the gain or loss on disposal (disposal proceeds minus net book value at disposal date) for P&L reporting.',
    `fiscal_period` STRING COMMENT 'The fiscal period (posting period) within the fiscal year to which this valuation record applies (e.g., 01 through 12 for monthly periods, or 13-16 for special closing periods in SAP). Enables period-level depreciation reporting.. Valid values are `^(0[1-9]|1[0-6])$`',
    `group_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the group/consolidated reporting currency used for enterprise-level CAPEX and asset valuation reporting (e.g., USD, EUR).. Valid values are `^[A-Z]{3}$`',
    `impairment_date` DATE COMMENT 'The date on which an impairment loss was recognized for the asset. Required for IAS 36 impairment assessment documentation and audit trail purposes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `impairment_loss` DECIMAL(18,2) COMMENT 'The amount by which the carrying amount of the asset exceeds its recoverable amount, recognized as an impairment loss in the income statement. Recorded when an assets value has declined beyond normal depreciation per IAS 36.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent update to the asset valuation record in the source SAP FI-AA system. Used for incremental data loading, audit trail, and change tracking in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `model` STRING COMMENT 'The accounting policy model applied to the asset class for subsequent measurement: cost_model (cost less accumulated depreciation and impairment) or revaluation_model (fair value less subsequent depreciation and impairment) per IAS 16.. Valid values are `cost_model|revaluation_model`',
    `net_book_value` DECIMAL(18,2) COMMENT 'The current carrying amount of the asset on the balance sheet, calculated as acquisition cost minus accumulated depreciation and any accumulated impairment losses. Key metric for IFRS/GAAP fixed asset reporting and balance sheet valuation.',
    `plant_code` STRING COMMENT 'The SAP plant code identifying the manufacturing facility or site where the asset is physically located. Supports plant-level CAPEX tracking and asset register reporting.',
    `residual_value` DECIMAL(18,2) COMMENT 'The estimated amount the organization expects to recover from the asset at the end of its useful life, net of disposal costs. The depreciable amount is acquisition cost minus residual value. Reviewed at each reporting date per IAS 16.',
    `residual_value_percent` DECIMAL(18,2) COMMENT 'The residual (salvage) value expressed as a percentage of the original acquisition cost. Used in SAP FI-AA to automatically calculate the residual value amount when the acquisition cost changes.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `revaluation_amount` DECIMAL(18,2) COMMENT 'The amount by which the assets carrying value was adjusted upward or downward under the revaluation model permitted by IAS 16. Positive values indicate upward revaluation; negative values indicate downward revaluation to revaluation reserve.',
    `revaluation_date` DATE COMMENT 'The date on which the asset was formally revalued to fair value under the IAS 16 revaluation model. Revaluations must be performed with sufficient regularity to ensure the carrying amount does not differ materially from fair value.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the asset valuation record. Drives financial reporting inclusion/exclusion and depreciation run eligibility. fully_depreciated indicates net book value has reached residual value.. Valid values are `active|disposed|retired|under_construction|impaired|transferred|fully_depreciated`',
    `useful_life_months` STRING COMMENT 'The estimated useful life of the asset expressed in months, providing finer granularity for depreciation calculation in SAP FI-AA. Used when the useful life does not align to whole years.. Valid values are `^[0-9]+$`',
    `useful_life_years` STRING COMMENT 'The estimated number of years the asset is expected to be economically useful to the organization. Used to calculate the annual depreciation charge under straight-line and other time-based methods. Reviewed periodically per IAS 16.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_asset_valuation PRIMARY KEY(`asset_valuation_id`)
) COMMENT 'Financial valuation records for capital assets capturing acquisition cost, current book value, accumulated depreciation, depreciation method, useful life, residual value, and asset capitalization date. Supports CAPEX/OPEX tracking, IFRS/GAAP fixed asset accounting, and asset impairment assessments. Sourced from SAP FI-AA (Fixed Asset Accounting) module and linked to the finance domain general ledger.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`warranty` (
    `warranty_id` BIGINT COMMENT 'Unique surrogate identifier for each asset warranty record in the lakehouse silver layer.',
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: Warranties are registered to the purchasing customer account. After-sales and warranty claims teams must identify the owning account to validate coverage, process replacements, and track warranty liab',
    `approved_manufacturer_id` BIGINT COMMENT 'Foreign key linking to engineering.approved_manufacturer. Business justification: Equipment warranties are tied to approved manufacturers from engineering. Procurement and maintenance teams verify warranty claims against engineerings approved manufacturer list for OEM parts and se',
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ar_invoice. Business justification: When warranty claims are billed back to OEM suppliers or customers, an AR invoice is raised. Finance teams link warranty records to AR invoices to track warranty cost recovery — common in industrial e',
    `installed_base_id` BIGINT COMMENT 'Foreign key linking to customer.installed_base. Business justification: A warranty is tied to a specific installed asset at a customer site. Service teams look up the installed base record to confirm the asset is under warranty before dispatching technicians or approving ',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Warranty validity is tied to the original purchase order for the asset. Procurement teams reference the PO to validate warranty start dates, coverage scope, and supplier obligations during claims proc',
    `sales_price_list_id` BIGINT COMMENT 'Foreign key linking to sales.sales_price_list. Business justification: Extended warranty offerings are sold at prices governed by the active sales price list. Sales and after-market teams use this link to validate warranty pricing at point of sale and renewal.',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Warranties are issued by the assets supplier or manufacturer. When a warranty claim is raised, procurement and asset teams must identify the responsible supplier — a standard post-procurement operati',
    `warranty_policy_id` BIGINT COMMENT 'Foreign key linking to product.warranty_policy. Business justification: Asset warranties follow product warranty policies defined by manufacturers. Service teams validate warranty coverage and terms when processing claims or scheduling covered maintenance.',
    `category` STRING COMMENT 'Categorizes the warranty by the nature of the covered asset — whether it applies to a complete equipment unit, a specific component, a sub-assembly, embedded software, or structural elements.. Valid values are `equipment|component|assembly|software|consumable|structural`',
    `claim_procedure` STRING COMMENT 'Description of the required process for submitting a warranty claim, including required documentation, notification channels, and escalation contacts as specified by the OEM.',
    `claim_submission_deadline_days` STRING COMMENT 'Maximum number of days after a failure event within which a warranty claim must be submitted to the OEM or supplier. Prevents forfeiture of warranty rights due to late filing.',
    `contract_reference_number` STRING COMMENT 'Reference number of the formal warranty or service contract document. Used for legal and commercial traceability, especially for extended service agreements.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or site where the warranted asset is located. Supports jurisdiction-specific warranty regulations and multi-national reporting.. Valid values are `^[A-Z]{3}$`',
    `coverage_basis` STRING COMMENT 'Defines whether the warranty is triggered by elapsed time, equipment usage (e.g., operating hours, cycles), a combination of both, or a specific event such as first failure.. Valid values are `time_based|usage_based|time_and_usage|event_based`',
    `covered_components` STRING COMMENT 'Free-text description of the specific components, assemblies, or systems covered under this warranty (e.g., Spindle motor and drive unit, Hydraulic pump and seals). Supports claim eligibility assessment.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the warranty record was first created in the system. Supports audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary values in this warranty record (e.g., USD, EUR, GBP). Supports multi-currency operations across global manufacturing sites.. Valid values are `^[A-Z]{3}$`',
    `document_reference` STRING COMMENT 'Reference to the physical or digital warranty certificate, OEM warranty booklet, or document management system (DMS) record. Enables retrieval of original warranty terms for claim disputes.',
    `exclusions` STRING COMMENT 'Description of items, failure modes, or conditions explicitly excluded from warranty coverage (e.g., Consumable wear parts, Damage due to operator misuse, Corrosion from chemical exposure).',
    `expiry_date` DATE COMMENT 'Date on which the warranty coverage expires. Critical for maintenance decision support — determines whether a repair should be claimed under warranty or charged to OPEX/CAPEX.. Valid values are `^d{4}-d{2}-d{2}$`',
    `labor_covered_flag` BOOLEAN COMMENT 'Indicates whether labor costs for warranty repairs are covered by the OEM or supplier. Drives cost recovery calculations and maintenance work order cost allocation.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the warranty record. Used for change tracking, data freshness monitoring, and incremental lakehouse processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `model_number` STRING COMMENT 'Manufacturer model number of the covered equipment or component. Used to verify warranty applicability and identify covered parts.',
    `name` STRING COMMENT 'Descriptive name or title of the warranty agreement (e.g., OEM Standard 2-Year Parts and Labor, Extended Service Agreement - CNC Spindle).',
    `notification_lead_days` STRING COMMENT 'Number of days before warranty expiry that automated notifications should be triggered to maintenance planners and procurement teams. Supports proactive warranty management.',
    `number` STRING COMMENT 'Business-facing warranty reference number as assigned by the OEM, supplier, or internal warranty management system. Used for cross-referencing warranty claims and correspondence.',
    `open_claim_count` STRING COMMENT 'Number of warranty claims currently open or in-progress against this warranty record. Supports workload management and supplier escalation decisions.',
    `parts_covered_flag` BOOLEAN COMMENT 'Indicates whether replacement parts and materials are covered under this warranty. Determines whether spare parts costs should be claimed from the supplier.. Valid values are `true|false`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or site where the warranted asset is installed. Supports multi-site warranty management and regional reporting.',
    `purchase_order_number` STRING COMMENT 'Reference to the Purchase Order (PO) under which the equipment or extended warranty was procured. Enables traceability from warranty to procurement records in SAP Ariba and SAP S/4HANA MM.',
    `renewal_deadline_date` DATE COMMENT 'Last date by which the warranty renewal or extension must be initiated to avoid a coverage gap. Triggers proactive notifications to maintenance planners.. Valid values are `^d{4}-d{2}-d{2}$`',
    `renewal_option_flag` BOOLEAN COMMENT 'Indicates whether this warranty is eligible for renewal or extension upon expiry. Supports proactive warranty renewal planning before coverage lapses.. Valid values are `true|false`',
    `response_time_hours` DECIMAL(18,2) COMMENT 'Maximum response time in hours committed by the OEM or service provider under the warranty or service level agreement. Used for SLA compliance monitoring.',
    `start_date` DATE COMMENT 'Date on which the warranty coverage becomes effective. Typically aligned with equipment commissioning date, delivery date, or purchase date depending on OEM terms.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the warranty record. Drives maintenance decision support (warranty vs. repair) and claim eligibility checks.. Valid values are `active|expired|pending_activation|suspended|cancelled|claimed|under_review`',
    `supplier_code` STRING COMMENT 'Internal supplier or vendor code from SAP Ariba or ERP identifying the warranty provider. Enables linkage to supplier performance and procurement records.',
    `total_claim_count` STRING COMMENT 'Total number of warranty claims ever submitted against this warranty record. Used for supplier warranty performance tracking and reliability analysis.',
    `total_claim_limit_amount` DECIMAL(18,2) COMMENT 'Maximum cumulative monetary value of claims that can be made under this warranty agreement. Supports warranty cost recovery planning and financial exposure assessment.',
    `total_claimed_amount` DECIMAL(18,2) COMMENT 'Cumulative monetary value of all warranty claims submitted against this warranty record to date. Used for warranty cost recovery tracking and supplier performance analysis.',
    `travel_covered_flag` BOOLEAN COMMENT 'Indicates whether travel and field service expenses for on-site warranty repairs are covered by the OEM or supplier. Relevant for remote plant locations.. Valid values are `true|false`',
    `type` STRING COMMENT 'Classification of the warranty by coverage type. OEM standard warranties are provided by the original equipment manufacturer; extended service agreements are purchased add-ons; supplier warranties cover procured components.. Valid values are `oem_standard|extended_service_agreement|supplier_warranty|parts_only|labor_only|comprehensive|limited|performance_guarantee`',
    `usage_limit_unit` STRING COMMENT 'Unit of measure for the usage limit value (e.g., operating hours for CNC machines, cycles for presses, kilometers for transport equipment).. Valid values are `hours|cycles|kilometers|miles|starts|strokes`',
    `usage_limit_value` DECIMAL(18,2) COMMENT 'Maximum usage threshold (e.g., operating hours, cycles, kilometers) beyond which the warranty is void. Applicable when coverage_basis is usage_based or time_and_usage.',
    CONSTRAINT pk_warranty PRIMARY KEY(`warranty_id`)
) COMMENT 'Warranty coverage records for manufacturing equipment and components capturing OEM warranty terms, warranty start and expiration dates, covered components, warranty claim procedures, and warranty claim history. Tracks both original equipment warranties and extended service agreements. Enables warranty cost recovery, maintenance decision support (warranty vs. repair), and supplier warranty performance tracking.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`service_contract` (
    `service_contract_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a vendor-side maintenance service contract for manufacturing equipment assets.',
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: Service contracts are negotiated and owned by a customer account. Contract management teams link every service contract to the responsible customer account daily for billing, renewal, and escalation w',
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: Service contracts with external maintenance vendors generate periodic AP invoices. Accounts payable teams match vendor invoices to service contracts for three-way matching and payment processing — a d',
    `contract_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_contract. Business justification: Service contracts for asset maintenance originate from procurement contracts. Links commercial terms negotiated by procurement to operational service delivery tracked by asset management.',
    `discount_structure_id` BIGINT COMMENT 'Foreign key linking to sales.discount_structure. Business justification: Long-term service contracts in industrial manufacturing routinely apply negotiated discount structures. Finance and sales ops teams link the applicable discount tier to the contract to ensure consiste',
    `freight_contract_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_contract. Business justification: Service contracts for field-maintained assets often include agreed logistics terms for parts shipment (e.g., next-day delivery SLAs). Linking to a freight contract lets contract managers enforce and a',
    `pricing_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.pricing_agreement. Business justification: Service contract billing rates are governed by the customers negotiated pricing agreement. Finance and sales operations use this link to apply correct labor, parts, and service rates when invoicing c',
    `product_price_list_id` BIGINT COMMENT 'Foreign key linking to product.product_price_list. Business justification: Service contracts reference a product price list to determine labor and parts pricing for covered services. Contract managers and sales teams use this link to ensure contractual pricing aligns with cu',
    `sla_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.sla_agreement. Business justification: A service contract enforces a specific SLA agreement negotiated with the customer. Field service and support teams reference this link to determine response time commitments and penalty clauses on eve',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Service contracts for asset maintenance are awarded to external suppliers. Procurement manages supplier relationships; linking service contracts to the supplier record enables spend tracking and suppl',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: Service contracts are subject to applicable tax codes (VAT, GST, withholding tax) depending on vendor jurisdiction. Tax and AP teams require this link to correctly calculate and report taxes on servic',
    `annual_value` DECIMAL(18,2) COMMENT 'Annualized monetary value of the service contract, used for year-over-year spend comparison, OPEX budgeting, and financial planning.',
    `approved_by` STRING COMMENT 'Name or employee ID of the authorized signatory or approving manager who formally approved the service contract, supporting audit trail and procurement governance.',
    `approved_date` DATE COMMENT 'Date on which the service contract received formal internal approval, completing the procurement authorization process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the contract is configured to automatically renew upon expiry without requiring a new negotiation cycle. Critical for CAPEX/OPEX planning and procurement governance.. Valid values are `true|false`',
    `contract_category` STRING COMMENT 'Categorizes the service contract by the nature of the service provider: OEM (Original Equipment Manufacturer) direct service, third-party independent service provider, in-house maintenance team formalization, or consortium arrangement.. Valid values are `oem|third_party|in_house|consortium`',
    `contract_title` STRING COMMENT 'Descriptive title of the maintenance service contract, summarizing the scope and covered equipment or service type (e.g., Annual Preventive Maintenance - CNC Machining Line 3).',
    `contract_type` STRING COMMENT 'Classification of the maintenance service contract by commercial and operational structure, distinguishing between full-service agreements, preventive maintenance (PM) contracts, time-and-materials arrangements, OEM service agreements, and emergency response contracts.. Valid values are `full_service|preventive_maintenance|time_and_materials|fixed_price|emergency_response|spare_parts_supply|condition_based|extended_warranty|oem_service`',
    `cost_center` STRING COMMENT 'SAP controlling cost center code to which the service contract costs are allocated for internal financial reporting and OPEX tracking.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary location where the service contract is executed, supporting multi-country regulatory compliance and reporting.. Valid values are `^[A-Z]{3}$`',
    `covered_asset_scope` STRING COMMENT 'Defines the breadth of equipment coverage under this contract: a single asset, a defined group of assets (e.g., all CNC machines in a cell), an entire plant, or enterprise-wide coverage across all facilities.. Valid values are `single_asset|asset_group|plant_wide|enterprise_wide`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the service contract record was first created in the system, supporting audit trail, data lineage, and Silver layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the contract value and billing amounts are denominated (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `emergency_response_included` BOOLEAN COMMENT 'Indicates whether 24/7 emergency breakdown response and corrective maintenance are included within the contract scope, or require separate call-out billing.. Valid values are `true|false`',
    `end_date` DATE COMMENT 'The date on which the service contract expires and vendor obligations cease, unless renewed or extended.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gl_account_code` STRING COMMENT 'SAP General Ledger account code for posting service contract costs, enabling accurate financial reporting and OPEX/CAPEX classification in the chart of accounts.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the service contract record, used for change tracking, incremental data loads, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `notice_period_days` STRING COMMENT 'Number of calendar days advance notice required by either party to terminate or not renew the contract. Supports procurement planning and avoidance of unintended auto-renewals.. Valid values are `^[0-9]+$`',
    `payment_terms` STRING COMMENT 'Contractual payment terms specifying the due date for invoices (e.g., Net 30, Net 60, 2/10 Net 30). Aligns with SAP vendor payment terms configuration.',
    `penalty_clause_flag` BOOLEAN COMMENT 'Indicates whether the contract includes financial penalty clauses for SLA breaches (e.g., downtime exceeding guaranteed uptime, response time violations). Supports vendor performance management.. Valid values are `true|false`',
    `penalty_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of the contract value or invoice amount deducted as a financial penalty for each SLA breach event, as defined in the contract penalty clause.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the primary manufacturing facility or site where the contracted maintenance services are to be performed.',
    `pm_visits_per_year` STRING COMMENT 'Number of scheduled preventive maintenance visits per year included in the contract scope. Used for maintenance planning, scheduling, and compliance tracking against TPM programs.. Valid values are `^[0-9]+$`',
    `preventive_maintenance_included` BOOLEAN COMMENT 'Indicates whether scheduled preventive maintenance (PM) visits and tasks are included within the scope of this service contract, as opposed to being billed separately.. Valid values are `true|false`',
    `remote_monitoring_included` BOOLEAN COMMENT 'Indicates whether the vendor provides remote condition monitoring and diagnostics services (e.g., via IIoT/MindSphere integration) as part of the contract scope.. Valid values are `true|false`',
    `renewal_date` DATE COMMENT 'The date on which the contract was most recently renewed, if applicable. Used to track renewal history and calculate contract age.. Valid values are `^d{4}-d{2}-d{2}$`',
    `signed_date` DATE COMMENT 'The date on which the service contract was formally executed and signed by authorized representatives of both parties.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sla_resolution_time_hours` DECIMAL(18,2) COMMENT 'Contractually guaranteed maximum time in hours from fault notification to full equipment restoration and return to service, as defined in the SLA terms.',
    `sla_response_time_hours` DECIMAL(18,2) COMMENT 'Contractually guaranteed maximum time in hours from fault notification to vendor on-site or remote response, as defined in the SLA terms. Critical for equipment criticality-based maintenance planning.',
    `spare_parts_included` BOOLEAN COMMENT 'Indicates whether the cost of spare parts and consumables used during maintenance activities is covered within the contract value, or billed as additional MRO costs.. Valid values are `true|false`',
    `start_date` DATE COMMENT 'The date on which the service contract becomes effective and the vendors service obligations commence.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the service contract, tracking progression from drafting through approval, active execution, suspension, expiry, or termination.. Valid values are `draft|pending_approval|active|suspended|expired|terminated|renewed|cancelled`',
    `termination_reason` STRING COMMENT 'Reason code explaining why the service contract was terminated or cancelled before or at its natural expiry. Supports vendor performance analysis and procurement lessons-learned.. Valid values are `expired|vendor_default|mutual_agreement|budget_reduction|asset_decommission|scope_change|performance_failure|other`',
    `uptime_guarantee_percent` DECIMAL(18,2) COMMENT 'Contractually guaranteed minimum equipment availability or uptime percentage over a defined measurement period, as specified in the SLA. Directly linked to OEE targets and production planning.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `vendor_code` STRING COMMENT 'Internal vendor master code assigned in SAP/ERP to uniquely identify the service vendor, enabling cross-system linkage to procurement and accounts payable records.',
    `wbs_element` STRING COMMENT 'SAP Project System WBS element code used to allocate contract costs to a specific capital project or maintenance program, supporting CAPEX vs. OPEX classification.',
    CONSTRAINT pk_service_contract PRIMARY KEY(`service_contract_id`)
) COMMENT 'OEM and third-party maintenance service contract records covering manufacturing equipment. Captures contract scope, covered assets, SLA terms (response time, uptime guarantees), contract value, billing frequency, included services (preventive maintenance, emergency response, spare parts), and contract performance metrics. Distinct from customer-facing service contracts managed in the service domain — this covers vendor-side maintenance contracts for owned assets.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`task_list` (
    `task_list_id` BIGINT COMMENT 'Unique surrogate identifier for the maintenance task list record in the lakehouse silver layer.',
    `class_id` BIGINT COMMENT 'Foreign key linking to asset.asset_class. Business justification: Task lists are templated by asset class for standardized maintenance procedures. Adding asset_class_id FK enables asset class-level task management and allows removal of denormalized asset_class_code ',
    `knowledge_article_id` BIGINT COMMENT 'Foreign key linking to service.knowledge_article. Business justification: Task lists reference knowledge articles for standardized work instructions and safety procedures. Technicians executing maintenance tasks follow the linked knowledge article to ensure consistent, comp',
    `product_configuration_id` BIGINT COMMENT 'Foreign key linking to product.product_configuration. Business justification: Task lists (standard maintenance procedures) are authored for specific product configurations. Maintenance engineers reference the product configuration to ensure the correct task sequence and tooling',
    `approved_by` STRING COMMENT 'Name or user ID of the maintenance engineer or supervisor who approved the current revision of the task list for operational use.',
    `approved_date` DATE COMMENT 'Date on which the current revision of the task list was formally approved for use in maintenance planning and work order generation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `change_notice_number` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that triggered the latest revision of this task list. Provides audit trail for change management.',
    `cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated material and labor cost values (e.g., USD, EUR, GBP). Supports multi-currency operations in multinational environments.. Valid values are `^[A-Z]{3}$`',
    `craft_type` STRING COMMENT 'Required trade or craft skill for executing the task list (e.g., electrician, millwright, instrumentation technician, welder). Drives labor assignment and qualification checks.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the task list record was first created in the source system. Used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Detailed description of the maintenance task list, including its purpose, scope, and the type of maintenance activity it supports (e.g., annual lubrication, quarterly inspection).',
    `equipment_category` STRING COMMENT 'Category of equipment this task list is designed for (e.g., CNC machine, conveyor, compressor, PLC panel). Enables reuse across equipment of the same category.',
    `estimated_duration_hours` DECIMAL(18,2) COMMENT 'Total estimated time in hours to complete all operations in the task list. Used for work order scheduling, capacity planning, and downtime estimation.. Valid values are `^d{1,7}(.d{1,2})?$`',
    `estimated_labor_cost` DECIMAL(18,2) COMMENT 'Estimated labor cost for executing the task list based on technician hours and applicable labor rates. Used for maintenance budget planning and OPEX forecasting.. Valid values are `^d{1,15}(.d{1,2})?$`',
    `estimated_material_cost` DECIMAL(18,2) COMMENT 'Estimated cost of materials and spare parts required to execute the task list, expressed in the cost currency. Used for maintenance budget planning and OPEX forecasting.. Valid values are `^d{1,15}(.d{1,2})?$`',
    `group_counter` STRING COMMENT 'Counter within the task list group distinguishing individual variants (e.g., different equipment configurations or revision levels) within the same group.',
    `group_number` STRING COMMENT 'SAP PM task list group number that logically groups related task list variants (counters) under a single maintenance activity family.',
    `hazardous_material_indicator` BOOLEAN COMMENT 'Flag indicating whether the task list involves handling hazardous materials (e.g., lubricants, solvents, refrigerants). Triggers REACH/RoHS compliance checks and HSE documentation requirements.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the task list record in the source system. Used for change detection, incremental loading, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lockout_tagout_required` BOOLEAN COMMENT 'Flag indicating whether Lockout/Tagout (LOTO) energy isolation procedures are required before executing this task list. Critical for electrical and mechanical safety compliance.. Valid values are `true|false`',
    `maintenance_type` STRING COMMENT 'Category of maintenance activity the task list supports, aligned with Total Productive Maintenance (TPM) strategy. Drives scheduling logic and cost classification in the EAM system.. Valid values are `preventive|predictive|corrective|condition_based|inspection|lubrication|calibration|overhaul|statutory`',
    `material_list_indicator` BOOLEAN COMMENT 'Flag indicating whether this task list includes a predefined list of spare parts and materials required for execution. Enables automatic material reservation upon work order creation.. Valid values are `true|false`',
    `name` STRING COMMENT 'Short descriptive name of the maintenance task list template, used for display and search in work order generation and maintenance planning.',
    `number` STRING COMMENT 'Business key identifying the task list template in the source EAM/CMMS system (e.g., SAP PM task list number or Maximo Job Plan ID). Used for cross-system traceability.',
    `number_of_technicians` STRING COMMENT 'Number of maintenance technicians required to execute the task list. Used for crew sizing, labor capacity planning, and work order resource allocation.. Valid values are `^[1-9][0-9]*$`',
    `operation_count` STRING COMMENT 'Total number of individual maintenance operations (steps) defined within this task list. Provides a quick indicator of task complexity for planning and scheduling.. Valid values are `^[0-9]+$`',
    `permit_to_work_required` BOOLEAN COMMENT 'Flag indicating whether a formal Permit to Work (PTW) must be issued before executing this task list (e.g., hot work, confined space, electrical isolation permits).. Valid values are `true|false`',
    `permit_type` STRING COMMENT 'Type of Permit to Work required for this task list when permit_to_work_required is true. Drives the correct permit form and approval workflow.. Valid values are `hot_work|confined_space|electrical_isolation|working_at_height|cold_work|radiation|general`',
    `planner_group` STRING COMMENT 'Maintenance planner group responsible for creating, maintaining, and approving this task list template. Used for organizational filtering and workload distribution.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility where this task list is applicable. Supports multi-plant operations and plant-level maintenance planning.',
    `ppe_requirements` STRING COMMENT 'Description of mandatory Personal Protective Equipment (PPE) required when executing this task list (e.g., safety glasses, hard hat, arc flash suit, chemical gloves). Supports ISO 45001 hazard control.',
    `qualification_requirement` STRING COMMENT 'Specific certification, license, or competency required to perform the task list (e.g., electrical safety certification, confined space entry, forklift license). Supports ISO 45001 competence management.',
    `regulatory_reference` STRING COMMENT 'Specific regulatory standard, directive, or legal requirement that mandates this task list (e.g., OSHA 29 CFR 1910.147, ISO 45001 Clause 8.1, PED 2014/68/EU). Populated when regulatory_requirement is true.',
    `regulatory_requirement` BOOLEAN COMMENT 'Flag indicating whether this task list is mandated by a regulatory or statutory requirement (e.g., pressure vessel inspection, electrical safety testing, environmental compliance check).. Valid values are `true|false`',
    `revision_number` STRING COMMENT 'Current revision or version number of the task list template. Incremented upon approved changes to ensure traceability and document control compliance.. Valid values are `^[A-Z0-9]+(.[0-9]+)*$`',
    `sop_reference` STRING COMMENT 'Reference number or document identifier of the Standard Operating Procedure (SOP) associated with this task list. Links to the controlled document management system for procedure retrieval.',
    `source_system` STRING COMMENT 'Operational system of record from which this task list record was sourced (e.g., SAP PM, Maximo EAM). Supports data lineage and reconciliation in the lakehouse.. Valid values are `SAP_PM|MAXIMO|TEAMCENTER|OPCENTER|MANUAL`',
    `source_system_key` STRING COMMENT 'Natural key or composite key from the originating source system (e.g., SAP task list group + counter, Maximo Job Plan ID). Enables traceability back to the system of record.',
    `status` STRING COMMENT 'Current lifecycle status of the task list template. Only active task lists can be assigned to maintenance plans or used for work order generation.. Valid values are `active|inactive|in_review|obsolete|draft`',
    `tpm_pillar` STRING COMMENT 'TPM pillar this task list supports, enabling alignment of maintenance activities with the TPM program structure and OEE improvement initiatives.. Valid values are `autonomous_maintenance|planned_maintenance|quality_maintenance|focused_improvement|early_equipment_management|education_and_training|safety_health_environment|office_tpm`',
    `type` STRING COMMENT 'Classification of the task list template scope: general (reusable across equipment classes), equipment_specific (tied to a specific equipment master), or functional_location_specific (tied to a functional location). Corresponds to SAP PM task list categories IA01/IA05/IA11.. Valid values are `general|equipment_specific|functional_location_specific`',
    `usage_count` STRING COMMENT 'Number of times this task list has been referenced in maintenance plans or used to generate work orders. Indicates template adoption and supports rationalization of the task list library.. Valid values are `^[0-9]+$`',
    `valid_from_date` DATE COMMENT 'Date from which this task list revision is effective and can be used for maintenance plan assignment and work order generation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Date after which this task list revision expires and should no longer be used for new work order generation. Supports lifecycle management and scheduled obsolescence.. Valid values are `^d{4}-d{2}-d{2}$`',
    `work_center_code` STRING COMMENT 'Code of the maintenance work center responsible for executing the tasks defined in this task list. Used for capacity planning and labor scheduling.',
    CONSTRAINT pk_task_list PRIMARY KEY(`task_list_id`)
) COMMENT 'Standardized maintenance task list templates (general, equipment-specific, and functional location-specific) defining the sequence of operations, required materials, tools, safety instructions, and estimated durations for recurring maintenance activities. Serves as the reusable template library for work order generation and maintenance plan assignment. Supports SOP standardization and TPM task standardization across plants.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`contract_coverage` (
    `contract_coverage_id` BIGINT COMMENT 'Primary key for the contract_coverage association',
    `maintenance_plan_id` BIGINT COMMENT 'Foreign key linking to the preventive maintenance plan that is covered under this service contract.',
    `service_contract_id` BIGINT COMMENT 'Foreign key linking to the vendor-side maintenance service contract that provides coverage for this maintenance plan.',
    `coverage_scope` STRING COMMENT 'Defines which specific activities, tasks, or components within the maintenance plan are covered under this contract pairing. Sourced directly from detection phase relationship data.',
    `covered_visit_count` BIGINT COMMENT 'The number of preventive maintenance visits allocated to this specific maintenance plan under this contract. Enables tracking of visit budget consumption per plan-contract pairing. Sourced directly from detection phase relationship data.',
    `end_date` DATE COMMENT 'The date on which this service contract ceases to cover this specific maintenance plan. May differ from the overall contract end date if coverage is phased out by plan. Sourced from detection phase as contract_end_date.',
    `priority_level` STRING COMMENT 'The priority assigned to this maintenance plan within the contracts service scope, used by the vendor to sequence response and scheduling when multiple plans are covered. Sourced directly from detection phase relationship data.',
    `start_date` DATE COMMENT 'The date on which this service contract begins covering this specific maintenance plan. May differ from the overall contract start date if coverage is phased in by plan. Sourced from detection phase as contract_start_date.',
    CONSTRAINT pk_contract_coverage PRIMARY KEY(`contract_coverage_id`)
) COMMENT 'This association product represents the Contract (coverage assignment) between service_contract and maintenance_plan. It captures the formal scope definition of which maintenance plans are covered under a given vendor service contract, including the specific terms, visit allocations, and priority levels that apply to each plan-contract pairing. Each record links one service_contract to one maintenance_plan with attributes that exist only in the context of this coverage relationship — such as how many PM visits are allocated to that plan under that contract, and the effective coverage dates for that specific pairing.. Existence Justification: In industrial manufacturing EAM, a single service contract (e.g., a vendor OEM agreement) explicitly covers multiple maintenance plans — for example, Contract SC-2024-001 covers PM Plan MP-CNC-001, MP-CNC-002, and MP-HVAC-003 at Plant A. Conversely, a single maintenance plan (e.g., a quarterly lubrication cycle for a CNC machine) can be covered by multiple service contracts over its lifetime, or simultaneously by overlapping contracts (e.g., an OEM contract for parts and a third-party contract for labor). The business actively manages this coverage scope as a formal assignment — procurement and maintenance teams create, update, and terminate these coverage records as contracts are negotiated and plans are revised.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ADD CONSTRAINT `fk_asset_maintenance_item_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ADD CONSTRAINT `fk_asset_maintenance_item_task_list_id` FOREIGN KEY (`task_list_id`) REFERENCES `manufacturing_ecm`.`asset`.`task_list`(`task_list_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ADD CONSTRAINT `fk_asset_measurement_point_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ADD CONSTRAINT `fk_asset_measurement_reading_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ADD CONSTRAINT `fk_asset_measurement_reading_sensor_measurement_point_id` FOREIGN KEY (`sensor_measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ADD CONSTRAINT `fk_asset_task_list_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` ADD CONSTRAINT `fk_asset_contract_coverage_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` ADD CONSTRAINT `fk_asset_contract_coverage_service_contract_id` FOREIGN KEY (`service_contract_id`) REFERENCES `manufacturing_ecm`.`asset`.`service_contract`(`service_contract_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`asset` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `manufacturing_ecm`.`asset` SET TAGS ('dbx_domain' = 'asset');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` SET TAGS ('dbx_subdomain' = 'asset_registry');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `class_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Class ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `classification_id` SET TAGS ('dbx_business_glossary_term' = 'Classification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `applicable_standard` SET TAGS ('dbx_business_glossary_term' = 'Applicable Industry Standard');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `asset_type` SET TAGS ('dbx_business_glossary_term' = 'Asset Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `asset_type` SET TAGS ('dbx_value_regex' = 'fixed_asset|movable_asset|leased_asset|rented_asset|tooling|spare_part_assembly');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `capitalization_threshold_amount` SET TAGS ('dbx_business_glossary_term' = 'Capitalization Threshold Amount');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `capitalization_threshold_currency` SET TAGS ('dbx_business_glossary_term' = 'Capitalization Threshold Currency');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `capitalization_threshold_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Asset Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'production_equipment|material_handling|facility_infrastructure|it_ot_systems|safety_systems|utilities|tooling_fixtures|vehicles|measurement_instruments|other');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `ce_marking_required` SET TAGS ('dbx_business_glossary_term' = 'CE Marking Required Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `ce_marking_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Default Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `criticality_rating` SET TAGS ('dbx_business_glossary_term' = 'Asset Criticality Rating');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `criticality_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|double_declining_balance|units_of_production|sum_of_years_digits|not_applicable');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `energy_class` SET TAGS ('dbx_business_glossary_term' = 'Energy Efficiency Class');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `energy_class` SET TAGS ('dbx_value_regex' = 'A+++|A++|A+|A|B|C|D|E|F|G|not_rated');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `environmental_risk_class` SET TAGS ('dbx_business_glossary_term' = 'Environmental Risk Class');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `environmental_risk_class` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical|not_applicable');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Hierarchy Level');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `iiot_monitoring_enabled` SET TAGS ('dbx_business_glossary_term' = 'Industrial Internet of Things (IIoT) Monitoring Enabled Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `iiot_monitoring_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `inspection_authority` SET TAGS ('dbx_business_glossary_term' = 'Inspection Authority');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `inspection_frequency_days` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Inspection Frequency (Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `inspection_frequency_days` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Inspection Required');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `inspection_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `maintenance_frequency_days` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Frequency (Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `maintenance_frequency_days` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Strategy');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_value_regex' = 'preventive|predictive|corrective|condition_based|run_to_failure|total_productive_maintenance|reliability_centered');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `mean_time_between_failures_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (MTBF) Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `mean_time_to_repair_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (MTTR) Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `reach_rohs_applicable` SET TAGS ('dbx_business_glossary_term' = 'REACH/RoHS Applicability Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `reach_rohs_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `residual_value_percent` SET TAGS ('dbx_business_glossary_term' = 'Residual Value Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `residual_value_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `safety_critical` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Asset Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `safety_critical` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `sap_asset_class_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Asset Class Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `sap_asset_class_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,8}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `scada_integrated` SET TAGS ('dbx_business_glossary_term' = 'Supervisory Control and Data Acquisition (SCADA) Integration Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `scada_integrated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `spare_parts_strategy` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Stocking Strategy');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `spare_parts_strategy` SET TAGS ('dbx_value_regex' = 'critical_stock|min_max|on_demand|vendor_managed|no_stock_required');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_review|deprecated|pending_approval');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `subcategory` SET TAGS ('dbx_business_glossary_term' = 'Asset Subcategory');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `ul_certification_required` SET TAGS ('dbx_business_glossary_term' = 'Underwriters Laboratories (UL) Certification Required Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `ul_certification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life (Years)');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_value_regex' = '^d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `warranty_duration_months` SET TAGS ('dbx_business_glossary_term' = 'Standard Warranty Duration (Months)');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `warranty_duration_months` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `class_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `entitlement_id` SET TAGS ('dbx_business_glossary_term' = 'Entitlement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Parts Origin Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `product_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Product Configuration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `tooling_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Tooling Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `call_horizon_percentage` SET TAGS ('dbx_business_glossary_term' = 'Call Horizon Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `completion_requirement` SET TAGS ('dbx_business_glossary_term' = 'Completion Requirement');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `completion_requirement` SET TAGS ('dbx_value_regex' = 'mandatory|recommended|optional');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `counter_reading_at_last_service` SET TAGS ('dbx_business_glossary_term' = 'Counter Reading at Last Service');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `cycle_unit` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Cycle Unit');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `cycle_unit` SET TAGS ('dbx_value_regex' = 'days|weeks|months|years|hours|cycles|kilometers|strokes|units_produced');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `cycle_value` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Cycle Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `equipment_category` SET TAGS ('dbx_business_glossary_term' = 'Equipment Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `equipment_category` SET TAGS ('dbx_value_regex' = 'production_machinery|cnc_machine|plc_system|scada_system|conveyor|hvac|electrical|instrumentation|pressure_vessel|rotating_equipment|vehicle|facility');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Maintenance Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `estimated_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Maintenance Duration (Hours)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `external_plan_reference` SET TAGS ('dbx_business_glossary_term' = 'External Plan Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `last_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Completion Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `last_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `last_scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Last Scheduled Maintenance Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `last_scheduled_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_plant` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plant');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_value_regex' = 'planned|unplanned|emergency|shutdown|turnaround');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `next_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Due Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `next_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `notification_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Notification Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `notification_type` SET TAGS ('dbx_value_regex' = 'M1|M2|M3|email|sms|system_alert');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'PM01|PM02|PM03|PM04|PM05|corrective|preventive|inspection|refurbishment');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `plan_category` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `plan_category` SET TAGS ('dbx_value_regex' = 'preventive|predictive|corrective|inspection|lubrication|calibration|regulatory|overhaul');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^MP-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `planner_group` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Planner Group');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Priority');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'very_high|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `regulatory_requirement` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `regulatory_requirement` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Revision Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `safety_critical` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `safety_critical` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `scheduling_horizon_days` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Horizon (Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_PM|MAXIMO_EAM|MANUAL');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|inactive|suspended|completed|archived');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `strategy_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Strategy Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `strategy_type` SET TAGS ('dbx_value_regex' = 'time_based|counter_based|condition_based|predictive|regulatory|combination');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `tolerance_percentage` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `work_center` SET TAGS ('dbx_business_glossary_term' = 'Responsible Work Center');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `maintenance_item_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Item ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `task_list_id` SET TAGS ('dbx_business_glossary_term' = 'Task List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `activity_type` SET TAGS ('dbx_business_glossary_term' = 'Activity Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `calibration_standard` SET TAGS ('dbx_business_glossary_term' = 'Calibration Standard Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `control_key` SET TAGS ('dbx_business_glossary_term' = 'Control Key');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `control_key` SET TAGS ('dbx_value_regex' = 'PM01|PM02|PM03|PM04|PM05');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `cost_classification` SET TAGS ('dbx_business_glossary_term' = 'Cost Classification (CAPEX/OPEX)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `cost_classification` SET TAGS ('dbx_value_regex' = 'capex|opex');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Maintenance Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_value_regex' = '^[0-9]{1,15}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `estimated_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration (Hours)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `estimated_duration_hours` SET TAGS ('dbx_value_regex' = '^[0-9]{1,6}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `expected_measurement_value` SET TAGS ('dbx_business_glossary_term' = 'Expected Measurement Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `hazardous_material_indicator` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `hazardous_material_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `interval_unit` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Interval Unit');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `interval_unit` SET TAGS ('dbx_value_regex' = 'days|weeks|months|years|operating_hours|cycles|kilometers|starts');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `interval_value` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Interval Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `interval_value` SET TAGS ('dbx_value_regex' = '^[0-9]{1,8}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `item_number` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Item Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `item_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `item_text` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Item Short Text');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `lockout_tagout_required` SET TAGS ('dbx_business_glossary_term' = 'Lockout/Tagout (LOTO) Required');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `lockout_tagout_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `long_text` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Item Long Text');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `maintenance_category` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `maintenance_category` SET TAGS ('dbx_value_regex' = 'preventive|predictive|corrective|condition_based|time_based|usage_based|statutory|lubrication|calibration');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `material_list_indicator` SET TAGS ('dbx_business_glossary_term' = 'Material List Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `material_list_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `measurement_point` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `number_of_technicians` SET TAGS ('dbx_business_glossary_term' = 'Number of Technicians Required');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `number_of_technicians` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `permit_required` SET TAGS ('dbx_business_glossary_term' = 'Permit to Work Required');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `permit_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `permit_type` SET TAGS ('dbx_business_glossary_term' = 'Permit to Work Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `permit_type` SET TAGS ('dbx_value_regex' = 'hot_work|cold_work|confined_space|electrical_isolation|working_at_height|radiation|excavation|none');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `ppe_requirements` SET TAGS ('dbx_business_glossary_term' = 'Personal Protective Equipment (PPE) Requirements');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `qualification_requirement` SET TAGS ('dbx_business_glossary_term' = 'Qualification Requirement');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `revision_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `sop_reference` SET TAGS ('dbx_business_glossary_term' = 'Standard Operating Procedure (SOP) Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Item Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|pending_approval|approved|obsolete|suspended');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `task_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Task Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `task_type` SET TAGS ('dbx_value_regex' = 'inspection|lubrication|replacement|calibration|cleaning|adjustment|testing|overhaul|repair|measurement|documentation|safety_check');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `tolerance_lower_limit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Tolerance Lower Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `tolerance_upper_limit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Tolerance Upper Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `work_center` SET TAGS ('dbx_business_glossary_term' = 'Work Center');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` SET TAGS ('dbx_original_name' = 'asset_notification');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `asset_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Notification ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `installed_base_id` SET TAGS ('dbx_business_glossary_term' = 'Installed Base Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `assembly` SET TAGS ('dbx_business_glossary_term' = 'Assembly / Sub-Component');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `breakdown_indicator` SET TAGS ('dbx_business_glossary_term' = 'Breakdown Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `breakdown_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Notification Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'PREVENTIVE|CORRECTIVE|PREDICTIVE|CONDITION_BASED|EMERGENCY');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `cause_code` SET TAGS ('dbx_business_glossary_term' = 'Cause Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `cause_description` SET TAGS ('dbx_business_glossary_term' = 'Cause Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Notification Closed Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Notification Completed Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `completed_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `damage_code` SET TAGS ('dbx_business_glossary_term' = 'Damage Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Notification Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `effect_code` SET TAGS ('dbx_business_glossary_term' = 'Effect Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `environment_relevant` SET TAGS ('dbx_business_glossary_term' = 'Environment Relevant Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `environment_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `long_text` SET TAGS ('dbx_business_glossary_term' = 'Notification Long Text');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `main_work_center` SET TAGS ('dbx_business_glossary_term' = 'Main Work Center');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `malfunction_end_date` SET TAGS ('dbx_business_glossary_term' = 'Malfunction End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `malfunction_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `malfunction_end_time` SET TAGS ('dbx_business_glossary_term' = 'Malfunction End Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `malfunction_end_time` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `malfunction_start_date` SET TAGS ('dbx_business_glossary_term' = 'Malfunction Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `malfunction_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `malfunction_start_time` SET TAGS ('dbx_business_glossary_term' = 'Malfunction Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `malfunction_start_time` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Notification Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `object_part_code` SET TAGS ('dbx_business_glossary_term' = 'Object Part Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `planner_group` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Planner Group');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `planning_plant` SET TAGS ('dbx_business_glossary_term' = 'Planning Plant');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `planning_plant` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Notification Priority');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = '1|2|3|4');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `reported_by` SET TAGS ('dbx_business_glossary_term' = 'Reported By (Reporter ID)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `reported_by` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `reported_date` SET TAGS ('dbx_business_glossary_term' = 'Reported Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `reported_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `reported_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Reported Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `reported_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `required_end_date` SET TAGS ('dbx_business_glossary_term' = 'Required End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `required_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `required_start_date` SET TAGS ('dbx_business_glossary_term' = 'Required Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `required_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `safety_relevant` SET TAGS ('dbx_business_glossary_term' = 'Safety Relevant Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `safety_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_PM|MAXIMO_EAM|SIEMENS_OPCENTER|MINDSPHERE|MANUAL');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Notification Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'OSNO|NOPR|ORAS|NOCO|CLSD|CANC');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Notification Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'M1|M2|M3|M4');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `work_order_number` SET TAGS ('dbx_business_glossary_term' = 'Work Order Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` SET TAGS ('dbx_subdomain' = 'asset_registry');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `product_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Specification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `alert_enabled` SET TAGS ('dbx_business_glossary_term' = 'Alert Enabled Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `alert_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Calibration Interval (Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `calibration_required` SET TAGS ('dbx_business_glossary_term' = 'Calibration Required Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `calibration_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'counter|characteristic');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `characteristic_code` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `characteristic_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `condition_monitoring_enabled` SET TAGS ('dbx_business_glossary_term' = 'Condition Monitoring Enabled Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `condition_monitoring_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `counter_overflow_value` SET TAGS ('dbx_business_glossary_term' = 'Counter Overflow Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `counter_reading_direction` SET TAGS ('dbx_business_glossary_term' = 'Counter Reading Direction');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `counter_reading_direction` SET TAGS ('dbx_value_regex' = 'ascending|descending');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `decimal_places` SET TAGS ('dbx_business_glossary_term' = 'Decimal Places');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `decimal_places` SET TAGS ('dbx_value_regex' = '^[0-9]$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_business_glossary_term' = 'Last Calibration Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `last_reading_by` SET TAGS ('dbx_business_glossary_term' = 'Last Reading Recorded By');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `last_reading_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Reading Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `last_reading_value` SET TAGS ('dbx_business_glossary_term' = 'Last Reading Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `lower_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Limit Threshold');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `maintenance_strategy_code` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Strategy Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `maintenance_strategy_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `mindsphere_aspect_name` SET TAGS ('dbx_business_glossary_term' = 'MindSphere Aspect Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `mindsphere_asset_reference` SET TAGS ('dbx_business_glossary_term' = 'MindSphere Asset ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `mindsphere_variable_name` SET TAGS ('dbx_business_glossary_term' = 'MindSphere Variable Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `plc_address` SET TAGS ('dbx_business_glossary_term' = 'PLC (Programmable Logic Controller) Address');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `plc_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `plc_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `point_number` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `point_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `point_type` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `point_type` SET TAGS ('dbx_value_regex' = 'vibration|temperature|pressure|flow|current|voltage|speed|torque|humidity|operating_hours|cycle_count|distance|weight|other');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `reading_method` SET TAGS ('dbx_business_glossary_term' = 'Reading Method');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `reading_method` SET TAGS ('dbx_value_regex' = 'automatic|manual|semi_automatic');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `sampling_interval_seconds` SET TAGS ('dbx_business_glossary_term' = 'Sampling Interval (Seconds)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `sampling_interval_seconds` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `scada_tag_name` SET TAGS ('dbx_business_glossary_term' = 'SCADA (Supervisory Control and Data Acquisition) Tag Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_PM|MAXIMO|MINDSPHERE|OPCENTER|SCADA|MANUAL');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|decommissioned|under_calibration|suspended');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'Target Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Za-z0-9°/%µ]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `upper_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Limit Threshold');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `work_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `valid_from` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `valid_from` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `valid_to` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `valid_to` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `measurement_reading_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Reading ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `sensor_measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Sensor ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `breach_severity` SET TAGS ('dbx_business_glossary_term' = 'Breach Severity');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `breach_severity` SET TAGS ('dbx_value_regex' = 'none|warning|alarm|critical');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `calibration_due_date` SET TAGS ('dbx_business_glossary_term' = 'Calibration Due Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `calibration_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `characteristic_value` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `counter_overflow_indicator` SET TAGS ('dbx_business_glossary_term' = 'Counter Overflow Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `counter_overflow_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `delta_value` SET TAGS ('dbx_business_glossary_term' = 'Delta Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `functional_location` SET TAGS ('dbx_business_glossary_term' = 'Functional Location');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `is_estimated` SET TAGS ('dbx_business_glossary_term' = 'Is Estimated Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `is_estimated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_business_glossary_term' = 'Last Calibration Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `lower_alarm_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Alarm Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `lower_warning_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Warning Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `maintenance_plan_number` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_date` SET TAGS ('dbx_business_glossary_term' = 'Reading Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_number` SET TAGS ('dbx_business_glossary_term' = 'Reading Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_quality` SET TAGS ('dbx_business_glossary_term' = 'Reading Quality');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_quality` SET TAGS ('dbx_value_regex' = 'good|uncertain|bad|not_connected|out_of_range|sensor_fault');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_source` SET TAGS ('dbx_business_glossary_term' = 'Reading Source');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_source` SET TAGS ('dbx_value_regex' = 'manual|iiot_sensor|scada|mes|plc|dcs|iot_gateway|api');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_status` SET TAGS ('dbx_business_glossary_term' = 'Reading Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_status` SET TAGS ('dbx_value_regex' = 'active|cancelled|superseded|pending_review|approved');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_taken_by` SET TAGS ('dbx_business_glossary_term' = 'Reading Taken By');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Reading Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_type` SET TAGS ('dbx_business_glossary_term' = 'Reading Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_type` SET TAGS ('dbx_value_regex' = 'measurement|counter|characteristic');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `reading_value` SET TAGS ('dbx_business_glossary_term' = 'Reading Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Reading Remarks');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `sensor_tag` SET TAGS ('dbx_business_glossary_term' = 'Sensor Tag');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'maximo|sap_pm|mindsphere|opcenter_mes|scada|manual|plc|dcs|other');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `source_system_reading_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System Reading ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `threshold_breach_indicator` SET TAGS ('dbx_business_glossary_term' = 'Threshold Breach Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `threshold_breach_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `upper_alarm_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Alarm Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `upper_warning_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Warning Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_record_id` SET TAGS ('dbx_business_glossary_term' = 'Calibration Record ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `installed_base_id` SET TAGS ('dbx_business_glossary_term' = 'Installed Base Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `material_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Material Specification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `product_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Specification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `work_order_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Operation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `adjustment_made_flag` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Made Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `adjustment_made_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By (Reviewer ID)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `as_found_value` SET TAGS ('dbx_business_glossary_term' = 'As-Found Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `as_left_value` SET TAGS ('dbx_business_glossary_term' = 'As-Left Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_date` SET TAGS ('dbx_business_glossary_term' = 'Calibration Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Calibration Interval (Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_method` SET TAGS ('dbx_business_glossary_term' = 'Calibration Method');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_number` SET TAGS ('dbx_business_glossary_term' = 'Calibration Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_number` SET TAGS ('dbx_value_regex' = '^CAL-[A-Z0-9]{4,10}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_standard_reference` SET TAGS ('dbx_business_glossary_term' = 'Calibration Standard Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_type` SET TAGS ('dbx_business_glossary_term' = 'Calibration Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_type` SET TAGS ('dbx_value_regex' = 'initial|periodic|after_repair|after_adjustment|unscheduled|pre_use|post_use');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `capa_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `certificate_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Calibration Certificate Issue Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `certificate_issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Calibration Certificate Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `environmental_humidity_percent` SET TAGS ('dbx_business_glossary_term' = 'Environmental Relative Humidity (%)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `environmental_humidity_percent` SET TAGS ('dbx_value_regex' = '^(100(.0+)?|[0-9]{1,2}(.[0-9]+)?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `environmental_temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Environmental Temperature (°C)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `functional_location` SET TAGS ('dbx_business_glossary_term' = 'Functional Location');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `instrument_description` SET TAGS ('dbx_business_glossary_term' = 'Instrument Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `instrument_tag` SET TAGS ('dbx_business_glossary_term' = 'Instrument Tag');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `laboratory_accreditation_number` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Accreditation Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `laboratory_name` SET TAGS ('dbx_business_glossary_term' = 'Calibration Laboratory Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `laboratory_type` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `laboratory_type` SET TAGS ('dbx_value_regex' = 'internal|external_accredited|external_non_accredited|oem_service_center');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Instrument Manufacturer');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `measurement_uncertainty` SET TAGS ('dbx_business_glossary_term' = 'Measurement Uncertainty');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'Instrument Model Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `next_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Calibration Due Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `next_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `out_of_tolerance_impact` SET TAGS ('dbx_business_glossary_term' = 'Out-of-Tolerance Impact Assessment');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `out_of_tolerance_impact` SET TAGS ('dbx_value_regex' = 'no_impact|impact_assessment_required|product_recall_initiated|product_quarantined|no_product_affected');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `performed_by` SET TAGS ('dbx_business_glossary_term' = 'Performed By (Technician ID)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Calibration Remarks');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `result` SET TAGS ('dbx_business_glossary_term' = 'Calibration Result');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `result` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional_pass|adjusted_pass|out_of_tolerance|void');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Instrument Serial Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `standard_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Standard Certificate Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Calibration Record Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_review|approved|cancelled|superseded|void');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `tolerance_lower_limit` SET TAGS ('dbx_business_glossary_term' = 'Tolerance Lower Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `tolerance_upper_limit` SET TAGS ('dbx_business_glossary_term' = 'Tolerance Upper Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` SET TAGS ('dbx_subdomain' = 'asset_registry');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` SET TAGS ('dbx_original_name' = 'asset_valuation');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `asset_valuation_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Valuation ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `asset_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Transaction Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `chart_of_accounts_id` SET TAGS ('dbx_business_glossary_term' = 'Chart Of Accounts Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `class_id` SET TAGS ('dbx_business_glossary_term' = 'Class Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `installed_base_id` SET TAGS ('dbx_business_glossary_term' = 'Installed Base Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `sales_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Price List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `accumulated_depreciation` SET TAGS ('dbx_business_glossary_term' = 'Accumulated Depreciation');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `accumulated_depreciation` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `accumulated_depreciation_gl_account` SET TAGS ('dbx_business_glossary_term' = 'Accumulated Depreciation GL Account Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Asset Acquisition Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `acquisition_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost Currency');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `acquisition_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `acquisition_cost_group_currency` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost in Group Currency');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `acquisition_cost_group_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_business_glossary_term' = 'Asset Acquisition Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `asset_sub_number` SET TAGS ('dbx_business_glossary_term' = 'Asset Sub-Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `asset_under_construction_flag` SET TAGS ('dbx_business_glossary_term' = 'Asset Under Construction (AUC) Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `asset_under_construction_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `capex_project_number` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) Project Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `capitalization_date` SET TAGS ('dbx_business_glossary_term' = 'Asset Capitalization Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `capitalization_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `controlling_area_code` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `current_period_depreciation` SET TAGS ('dbx_business_glossary_term' = 'Current Period Depreciation');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `current_period_depreciation` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `date` SET TAGS ('dbx_business_glossary_term' = 'Asset Valuation Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `depreciation_key` SET TAGS ('dbx_business_glossary_term' = 'SAP Depreciation Key');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|double_declining_balance|units_of_production|sum_of_years_digits|MACRS|other');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `disposal_date` SET TAGS ('dbx_business_glossary_term' = 'Asset Disposal Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `disposal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `disposal_proceeds` SET TAGS ('dbx_business_glossary_term' = 'Asset Disposal Proceeds');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `disposal_proceeds` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Group Reporting Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `impairment_date` SET TAGS ('dbx_business_glossary_term' = 'Impairment Recognition Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `impairment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `impairment_loss` SET TAGS ('dbx_business_glossary_term' = 'Impairment Loss');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `impairment_loss` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `model` SET TAGS ('dbx_business_glossary_term' = 'Asset Valuation Model');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `model` SET TAGS ('dbx_value_regex' = 'cost_model|revaluation_model');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `net_book_value` SET TAGS ('dbx_business_glossary_term' = 'Net Book Value (NBV)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `net_book_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `residual_value` SET TAGS ('dbx_business_glossary_term' = 'Residual Value (Salvage Value)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `residual_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `residual_value_percent` SET TAGS ('dbx_business_glossary_term' = 'Residual Value Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `residual_value_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `revaluation_amount` SET TAGS ('dbx_business_glossary_term' = 'Asset Revaluation Amount');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `revaluation_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `revaluation_date` SET TAGS ('dbx_business_glossary_term' = 'Asset Revaluation Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `revaluation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Asset Valuation Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|disposed|retired|under_construction|impaired|transferred|fully_depreciated');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `useful_life_months` SET TAGS ('dbx_business_glossary_term' = 'Useful Life (Months)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `useful_life_months` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life (Years)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` SET TAGS ('dbx_subdomain' = 'asset_registry');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `warranty_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Warranty ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `approved_manufacturer_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Manufacturer Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ar Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `installed_base_id` SET TAGS ('dbx_business_glossary_term' = 'Installed Base Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `sales_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Price List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `warranty_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Warranty Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'equipment|component|assembly|software|consumable|structural');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `claim_procedure` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Procedure');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `claim_submission_deadline_days` SET TAGS ('dbx_business_glossary_term' = 'Claim Submission Deadline (Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `contract_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Warranty Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `coverage_basis` SET TAGS ('dbx_business_glossary_term' = 'Warranty Coverage Basis');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `coverage_basis` SET TAGS ('dbx_value_regex' = 'time_based|usage_based|time_and_usage|event_based');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `covered_components` SET TAGS ('dbx_business_glossary_term' = 'Covered Components Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Warranty Document Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `exclusions` SET TAGS ('dbx_business_glossary_term' = 'Warranty Exclusions');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiry Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `labor_covered_flag` SET TAGS ('dbx_business_glossary_term' = 'Labor Covered Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `labor_covered_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'Model Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Warranty Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `notification_lead_days` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiry Notification Lead Days');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Warranty Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `open_claim_count` SET TAGS ('dbx_business_glossary_term' = 'Open Warranty Claim Count');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `parts_covered_flag` SET TAGS ('dbx_business_glossary_term' = 'Parts Covered Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `parts_covered_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `renewal_deadline_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Renewal Deadline Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `renewal_deadline_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `renewal_option_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Renewal Option Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `renewal_option_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `response_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Warranty Response Time (Hours)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Warranty Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|expired|pending_activation|suspended|cancelled|claimed|under_review');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `total_claim_count` SET TAGS ('dbx_business_glossary_term' = 'Total Warranty Claim Count');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `total_claim_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Warranty Claim Limit Amount');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `total_claim_limit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `total_claimed_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Claimed Amount');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `total_claimed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `travel_covered_flag` SET TAGS ('dbx_business_glossary_term' = 'Travel Covered Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `travel_covered_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Warranty Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'oem_standard|extended_service_agreement|supplier_warranty|parts_only|labor_only|comprehensive|limited|performance_guarantee');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `usage_limit_unit` SET TAGS ('dbx_business_glossary_term' = 'Warranty Usage Limit Unit');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `usage_limit_unit` SET TAGS ('dbx_value_regex' = 'hours|cycles|kilometers|miles|starts|strokes');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `usage_limit_value` SET TAGS ('dbx_business_glossary_term' = 'Warranty Usage Limit Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` SET TAGS ('dbx_subdomain' = 'service_coverage');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ap Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `discount_structure_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Structure Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `freight_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `pricing_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Pricing Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `product_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Product Price List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `sla_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `annual_value` SET TAGS ('dbx_business_glossary_term' = 'Annual Contract Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `annual_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Contract Approved By');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Approved Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `contract_category` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `contract_category` SET TAGS ('dbx_value_regex' = 'oem|third_party|in_house|consortium');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `contract_title` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Title');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'full_service|preventive_maintenance|time_and_materials|fixed_price|emergency_response|spare_parts_supply|condition_based|extended_warranty|oem_service');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `covered_asset_scope` SET TAGS ('dbx_business_glossary_term' = 'Covered Asset Scope');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `covered_asset_scope` SET TAGS ('dbx_value_regex' = 'single_asset|asset_group|plant_wide|enterprise_wide');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Contract Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `emergency_response_included` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Included Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `emergency_response_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Contract Notice Period (Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `penalty_clause_flag` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `penalty_clause_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `penalty_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'SLA Penalty Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `penalty_rate_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `pm_visits_per_year` SET TAGS ('dbx_business_glossary_term' = 'Preventive Maintenance (PM) Visits Per Year');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `pm_visits_per_year` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `preventive_maintenance_included` SET TAGS ('dbx_business_glossary_term' = 'Preventive Maintenance (PM) Included Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `preventive_maintenance_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `remote_monitoring_included` SET TAGS ('dbx_business_glossary_term' = 'Remote Monitoring Included Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `remote_monitoring_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Renewal Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `renewal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `signed_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Signed Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `signed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `sla_resolution_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Resolution Time (Hours)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `sla_response_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Response Time (Hours)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `spare_parts_included` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Included Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `spare_parts_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|suspended|expired|terminated|renewed|cancelled');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Contract Termination Reason');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `termination_reason` SET TAGS ('dbx_value_regex' = 'expired|vendor_default|mutual_agreement|budget_reduction|asset_decommission|scope_change|performance_failure|other');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `uptime_guarantee_percent` SET TAGS ('dbx_business_glossary_term' = 'Uptime Guarantee Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `uptime_guarantee_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `vendor_code` SET TAGS ('dbx_business_glossary_term' = 'Service Vendor Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `task_list_id` SET TAGS ('dbx_business_glossary_term' = 'Task List ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `class_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `knowledge_article_id` SET TAGS ('dbx_business_glossary_term' = 'Knowledge Article Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `product_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Product Configuration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approved Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `change_notice_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `craft_type` SET TAGS ('dbx_business_glossary_term' = 'Craft Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Task List Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `equipment_category` SET TAGS ('dbx_business_glossary_term' = 'Equipment Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `estimated_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration (Hours)');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `estimated_duration_hours` SET TAGS ('dbx_value_regex' = '^d{1,7}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `estimated_labor_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Labor Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `estimated_labor_cost` SET TAGS ('dbx_value_regex' = '^d{1,15}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `estimated_material_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Material Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `estimated_material_cost` SET TAGS ('dbx_value_regex' = '^d{1,15}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `group_counter` SET TAGS ('dbx_business_glossary_term' = 'Task List Group Counter');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `group_number` SET TAGS ('dbx_business_glossary_term' = 'Task List Group Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `hazardous_material_indicator` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `hazardous_material_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `lockout_tagout_required` SET TAGS ('dbx_business_glossary_term' = 'Lockout/Tagout (LOTO) Required');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `lockout_tagout_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_value_regex' = 'preventive|predictive|corrective|condition_based|inspection|lubrication|calibration|overhaul|statutory');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `material_list_indicator` SET TAGS ('dbx_business_glossary_term' = 'Material List Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `material_list_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Task List Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Task List Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `number_of_technicians` SET TAGS ('dbx_business_glossary_term' = 'Number of Technicians Required');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `number_of_technicians` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `operation_count` SET TAGS ('dbx_business_glossary_term' = 'Operation Count');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `operation_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `permit_to_work_required` SET TAGS ('dbx_business_glossary_term' = 'Permit to Work Required');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `permit_to_work_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `permit_type` SET TAGS ('dbx_business_glossary_term' = 'Permit to Work Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `permit_type` SET TAGS ('dbx_value_regex' = 'hot_work|confined_space|electrical_isolation|working_at_height|cold_work|radiation|general');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `planner_group` SET TAGS ('dbx_business_glossary_term' = 'Planner Group');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `ppe_requirements` SET TAGS ('dbx_business_glossary_term' = 'Personal Protective Equipment (PPE) Requirements');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `qualification_requirement` SET TAGS ('dbx_business_glossary_term' = 'Qualification Requirement');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `regulatory_requirement` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `regulatory_requirement` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `revision_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]+(.[0-9]+)*$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `sop_reference` SET TAGS ('dbx_business_glossary_term' = 'Standard Operating Procedure (SOP) Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_PM|MAXIMO|TEAMCENTER|OPCENTER|MANUAL');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Task List Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|in_review|obsolete|draft');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `tpm_pillar` SET TAGS ('dbx_business_glossary_term' = 'Total Productive Maintenance (TPM) Pillar');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `tpm_pillar` SET TAGS ('dbx_value_regex' = 'autonomous_maintenance|planned_maintenance|quality_maintenance|focused_improvement|early_equipment_management|education_and_training|safety_health_environment|office_tpm');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Task List Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'general|equipment_specific|functional_location_specific');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `usage_count` SET TAGS ('dbx_business_glossary_term' = 'Usage Count');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `usage_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` SET TAGS ('dbx_subdomain' = 'service_coverage');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` SET TAGS ('dbx_association_edges' = 'asset.service_contract,asset.maintenance_plan');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` ALTER COLUMN `contract_coverage_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Coverage - Contract Coverage Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Coverage - Maintenance Plan Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` ALTER COLUMN `service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Coverage - Service Contract Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` ALTER COLUMN `coverage_scope` SET TAGS ('dbx_business_glossary_term' = 'Coverage Scope');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` ALTER COLUMN `covered_visit_count` SET TAGS ('dbx_business_glossary_term' = 'Covered Visit Count');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Coverage Priority Level');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_coverage` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage Start Date');
