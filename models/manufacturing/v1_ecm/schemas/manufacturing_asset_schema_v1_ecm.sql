-- Schema for Domain: asset | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:32

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`asset` COMMENT 'Manages the full lifecycle of manufacturing equipment, plant assets, and capital infrastructure using EAM/CMMS. Covers preventive and predictive maintenance (TPM), work order management, MTBF/MTTR tracking, condition monitoring via IIoT/MindSphere, PLCs, CNC machines, SCADA systems, and CAPEX/OPEX asset accounting.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`class` (
    `class_id` BIGINT COMMENT 'Unique system-generated identifier for each asset classification record within the enterprise asset taxonomy.',
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
    `parent_class_code` STRING COMMENT 'Code of the parent asset class in the classification hierarchy, enabling multi-level taxonomy structures (e.g., Machining Center → CNC Machining Center → 5-Axis CNC Machining Center).. Valid values are `^[A-Z0-9_-]{2,20}$`',
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
    `class_id` BIGINT COMMENT 'Foreign key linking to asset.asset_class. Business justification: Maintenance plans may be templated by asset class for standardized preventive maintenance across similar equipment types. This enables asset class-level maintenance strategy management.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Maintenance plans define default cost centers for generated work orders, enabling automated cost allocation for preventive maintenance programs and budget forecasting.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Maintenance plans are defined for specific equipment assets in equipment-specific preventive maintenance strategies. The plan currently has functional_location and equipment_category strings but no di',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Maintenance plans can be location-based for area maintenance strategies. Adding functional_location_id FK enables proper location-based planning and allows removal of the denormalized location code st',
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
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Maintenance items (consumables, parts) reference catalog for procurement. Maintenance planners specify which catalog items are needed for preventive/corrective maintenance tasks.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Maintenance items can be equipment-specific tasks. Adding equipment_id FK enables equipment-level task tracking and allows removal of the denormalized equipment_number string.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Maintenance items can be location-specific tasks. Adding functional_location_id FK enables location-based task management and allows removal of the denormalized location code string.',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Maintenance items define spare parts required for maintenance plans. Planners link maintenance items to inventory SKUs to enable automatic reservation, availability checking, and procurement of requir',
    `maintenance_plan_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_plan. Business justification: Maintenance items are individual tasks within a maintenance plan. Adding maintenance_plan_id FK establishes the parent-child relationship and allows removal of the denormalized plan_number string.',
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
    `task_list_number` STRING COMMENT 'Reference to the task list (general, equipment, or functional location task list) that defines the standard set of operations for this maintenance item. In SAP PM, this corresponds to the task list group and counter.',
    `task_list_type` STRING COMMENT 'Type of task list referenced by this maintenance item, indicating whether it is a general task list, equipment-specific task list, or functional location task list. Determines the scope and applicability of the task.. Valid values are `general|equipment|functional_location|assembly`',
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
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Maintenance notifications can be reported by customers about their equipment. Customer service and maintenance planning need to track which customer reported the issue.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Notifications report malfunctions and issues on specific equipment. Adding equipment_id FK enables proper asset tracking and allows removal of the denormalized equipment_number string.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Notifications can be location-specific when the issue is not tied to a specific equipment but to a functional area. Adding functional_location_id FK enables spatial analysis and allows removal of the ',
    `predictive_alert_id` BIGINT COMMENT 'Reference identifier of the Industrial Internet of Things (IIoT) sensor alert or MindSphere condition monitoring event that automatically triggered this notification. Enables traceability from predictive analytics to maintenance action.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Maintenance notifications are reported by operators/employees who observe equipment issues. Essential for tracking who identified problems and for follow-up communication.',
    `request_id` BIGINT COMMENT 'Foreign key linking to service.service_request. Business justification: Asset notifications (breakdowns, alarms) can originate from customer service requests. Links customer-reported issues to internal maintenance notifications for tracking and resolution.',
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
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Measurement points are installed on equipment for condition monitoring. Adding equipment_id FK establishes the asset relationship and allows removal of the denormalized equipment_number string.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Measurement points can be location-based for area monitoring. Adding functional_location_id FK enables location-based monitoring and allows removal of the denormalized location code string.',
    `ot_system_id` BIGINT COMMENT 'Foreign key linking to technology.ot_system. Business justification: Measurement points (temperature, pressure, vibration sensors) are connected to OT systems that collect the data. Instrumentation engineers need this link for calibration and data validation activities',
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
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Readings are associated with equipment for asset-level condition tracking. Adding equipment_id FK enables direct equipment relationship and allows removal of denormalized asset number and description.',
    `measurement_point_id` BIGINT COMMENT 'Foreign key linking to asset.measurement_point. Business justification: Readings are captured at measurement points. Adding measurement_point_id FK establishes the parent-child relationship and allows removal of denormalized point number and name which can be retrieved vi',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Manual measurement readings must identify which technician recorded the data for quality control, audit compliance, and accountability in regulated manufacturing environments.',
    `sensor_measurement_point_id` BIGINT COMMENT 'Unique identifier of the IIoT sensor, transducer, or instrumentation device that captured the reading. Relevant for automated readings from Siemens MindSphere, SCADA, or PLC/DCS integrations. Supports sensor-level diagnostics and calibration tracking.',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Readings may be taken during work order execution as part of maintenance activities. Adding work_order_id FK links readings to maintenance context and allows removal of denormalized work order number ',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`failure_record` (
    `failure_record_id` BIGINT COMMENT 'Unique system-generated identifier for each equipment failure or fault event record within the asset management system.',
    `asset_notification_id` BIGINT COMMENT 'Foreign key linking to asset.notification. Business justification: Failures are reported via notifications. Adding notification_id FK captures the reporting mechanism and allows removal of denormalized notification number string.',
    `capa_record_id` BIGINT COMMENT 'Foreign key linking to compliance.capa_record. Business justification: Critical equipment failures trigger CAPA processes in regulated industries (pharma, medical devices). Quality teams link failures to CAPA records for regulatory compliance and continuous improvement t',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Failures occur on equipment. Adding equipment_id FK establishes the asset relationship and allows removal of denormalized asset number and description which can be retrieved via JOIN.',
    `ncr_id` BIGINT COMMENT 'Foreign key linking to quality.ncr. Business justification: Equipment failures that produce defective parts trigger NCRs. Maintenance teams link failure records to NCRs to coordinate equipment repair with quality disposition of affected material.',
    `pfmea_id` BIGINT COMMENT 'Foreign key linking to engineering.pfmea. Business justification: Failure records validate Process FMEA predictions. Reliability engineers link actual failures to PFMEA failure modes to update risk priority numbers, improve preventive maintenance strategies, and dri',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Equipment failures must document which employee reported the incident for root cause analysis, reliability engineering, and safety investigation processes.',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Failures are addressed by corrective work orders. Adding work_order_id FK links failure events to repair activities and allows removal of denormalized work order number string.',
    `actual_repair_cost` DECIMAL(18,2) COMMENT 'The actual total cost incurred to repair the failure, captured from work order actuals in the ERP/EAM system, used for OPEX tracking, maintenance cost benchmarking, and ROI analysis.',
    `affected_production_quantity` DECIMAL(18,2) COMMENT 'The quantity of production units (parts, assemblies, or batches) that were impacted, scrapped, or placed on hold as a direct result of this failure event.',
    `capa_reference_number` STRING COMMENT 'The reference number of the associated CAPA record in the Quality Management System (QMS), linking the failure event to its formal corrective action for traceability and audit purposes.',
    `capa_required_flag` BOOLEAN COMMENT 'Indicates whether a formal Corrective and Preventive Action (CAPA) process must be initiated as a result of this failure event, based on severity, recurrence, or regulatory requirements.. Valid values are `true|false`',
    `closed_timestamp` TIMESTAMP COMMENT 'The date and time when the failure record was formally closed in the EAM/CMMS system following completion of all corrective actions and verification of asset restoration.',
    `cost_center` STRING COMMENT 'The financial cost center responsible for the asset and associated maintenance costs, enabling OPEX allocation and maintenance budget variance reporting.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the repair cost amounts recorded in this failure record, supporting multi-currency reporting in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `damage_code` STRING COMMENT 'Standardized code identifying the type of physical damage observed on the failed component or asset (e.g., cracking, erosion, deformation, contamination), used for spare parts planning and FMEA analysis.',
    `detection_method` STRING COMMENT 'The method by which the failure was first detected, distinguishing between operator-observed, sensor-triggered (IIoT/SCADA), alarm-based, or inspection-based detection. Supports FMEA detectability scoring and predictive maintenance program evaluation.. Valid values are `operator_observation|condition_monitoring|predictive_alert|preventive_inspection|alarm_system|iiot_sensor|scada_alert|customer_report|automated_test|unknown`',
    `downtime_duration_minutes` DECIMAL(18,2) COMMENT 'Total duration in minutes that the asset was non-operational due to this failure event. Used for OEE downtime categorization, TPM loss analysis, and MTTR calculation inputs.',
    `environmental_incident_flag` BOOLEAN COMMENT 'Indicates whether this failure event caused or contributed to an environmental incident (e.g., spill, emission exceedance), triggering reporting obligations under ISO 14001 and EPA regulations.. Valid values are `true|false`',
    `estimated_repair_cost` DECIMAL(18,2) COMMENT 'The estimated total cost to repair the failure, including labor, materials, and contractor costs, used for maintenance budget planning and CAPEX vs. OPEX decision support.',
    `failed_component` STRING COMMENT 'Name or description of the specific sub-component, part, or assembly within the asset that failed, enabling component-level reliability analysis and spare parts demand forecasting.',
    `failed_component_part_number` STRING COMMENT 'The material or part number of the failed component as registered in the ERP/PLM system, enabling linkage to BOM, spare parts inventory, and procurement records.',
    `failure_cause_code` STRING COMMENT 'Standardized code identifying the root cause of the failure (e.g., wear, fatigue, corrosion, misalignment, overload), used for CAPA initiation and reliability improvement programs.',
    `failure_cause_description` STRING COMMENT 'Detailed narrative description of the root cause of the failure, providing context beyond the standardized cause code for engineering analysis and FMEA documentation.',
    `failure_class` STRING COMMENT 'High-level classification of the failure type based on the physical or functional domain of the fault, used for trend analysis and FMEA categorization.. Valid values are `electrical|mechanical|hydraulic|pneumatic|instrumentation|structural|software|process|environmental|operator_error|unknown`',
    `failure_code` STRING COMMENT 'Standardized alphanumeric code identifying the specific type of failure as defined in the enterprise failure code catalog, aligned with ISO 14224 taxonomy for reliability data collection.',
    `failure_effect_code` STRING COMMENT 'Standardized code describing the consequence or effect of the failure on the asset, process, or production output (e.g., complete shutdown, degraded performance, safety hazard), used in FMEA severity assessment.',
    `failure_effect_description` STRING COMMENT 'Narrative description of the observed impact of the failure on equipment operation, production continuity, product quality, or safety, supporting FMEA severity scoring and CAPA documentation.',
    `failure_end_timestamp` TIMESTAMP COMMENT 'The exact date and time when the equipment was restored to operational status following the failure, used to calculate downtime duration and Mean Time To Repair (MTTR).',
    `failure_mode` STRING COMMENT 'Description of the observable manner in which the equipment failed (e.g., vibration, overheating, leakage, fracture, corrosion), as used in FMEA and reliability engineering analysis.',
    `failure_number` STRING COMMENT 'Human-readable business reference number for the failure event, used for cross-referencing in work orders, NCRs, and maintenance reports. Follows the format FR-YYYY-NNNNNN.. Valid values are `^FR-[0-9]{4}-[0-9]{6}$`',
    `failure_start_timestamp` TIMESTAMP COMMENT 'The exact date and time when the equipment failure or fault event began, used as the baseline for calculating downtime duration and Mean Time Between Failures (MTBF).',
    `failure_status` STRING COMMENT 'Current lifecycle status of the failure record, tracking progression from initial reporting through investigation, repair, and formal closure in the EAM/CMMS system.. Valid values are `open|in_progress|resolved|closed|deferred|cancelled`',
    `functional_location` STRING COMMENT 'The hierarchical functional location code (e.g., plant-area-line-station) identifying where in the facility the failed asset is installed, used for location-based failure trend analysis.',
    `maintenance_type` STRING COMMENT 'Classification of the maintenance response triggered by this failure, distinguishing between corrective, emergency, predictive, or condition-based maintenance actions for TPM and OPEX analysis.. Valid values are `corrective|emergency|predictive|condition_based|deferred_corrective`',
    `oee_loss_category` STRING COMMENT 'Classification of the failure event within the OEE loss framework, categorizing the downtime as availability loss, performance loss, or quality loss for TPM and Six Sigma reporting.. Valid values are `unplanned_downtime|planned_downtime|speed_loss|quality_loss|minor_stoppage|startup_loss`',
    `plant_code` STRING COMMENT 'The SAP plant or facility code where the failed asset is located, enabling geographic and organizational segmentation of failure data for multi-site reliability benchmarking.',
    `production_impact` STRING COMMENT 'Assessment of the failures impact on production operations, indicating whether the failure caused a complete line stoppage, partial capacity reduction, or had no direct production impact.. Valid values are `full_production_stop|partial_production_stop|degraded_performance|no_production_impact|quality_impact_only`',
    `recurrence_flag` BOOLEAN COMMENT 'Indicates whether this failure is a recurrence of a previously recorded failure on the same asset with the same failure mode, used to identify chronic failure patterns and evaluate CAPA effectiveness.. Valid values are `true|false`',
    `repair_type` STRING COMMENT 'Classification of the corrective action taken to resolve the failure, used for maintenance cost analysis, spare parts consumption tracking, and CAPA effectiveness evaluation.. Valid values are `replacement|repair_in_place|adjustment|cleaning|lubrication|calibration|software_reset|no_action_required|deferred`',
    `reported_by` STRING COMMENT 'The employee ID or username of the person who reported or logged the failure event into the CMMS/EAM system, used for accountability and audit trail purposes.',
    `reported_timestamp` TIMESTAMP COMMENT 'The date and time when the failure event was formally reported or logged into the CMMS/EAM system, which may differ from the actual failure start time due to detection lag.',
    `safety_incident_flag` BOOLEAN COMMENT 'Indicates whether this failure event resulted in or contributed to a safety incident, near-miss, or hazardous condition, triggering mandatory reporting under OSHA and ISO 45001 requirements.. Valid values are `true|false`',
    `severity_level` STRING COMMENT 'Classification of the failure impact severity on production, safety, quality, or asset integrity. Used for prioritizing corrective actions, FMEA severity ranking, and OEE loss categorization.. Valid values are `critical|major|moderate|minor|negligible`',
    CONSTRAINT pk_failure_record PRIMARY KEY(`failure_record_id`)
) COMMENT 'Structured records of equipment failures, breakdowns, and fault events capturing failure mode, failure cause, failure effect, damage code, and MTBF/MTTR data points. Supports FMEA analysis, reliability engineering, and TPM loss tracking. Links to work orders and notifications to form a complete failure history for each asset. Enables OEE downtime categorization and Six Sigma reliability improvement programs.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`reliability_record` (
    `reliability_record_id` BIGINT COMMENT 'Unique surrogate identifier for each aggregated reliability performance record in the Silver layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `equipment_id` BIGINT COMMENT 'Reference to the manufacturing equipment or capital infrastructure asset for which this reliability record is computed. Aligns with the asset register in Maximo EAM and SAP PM.',
    `asset_age_years` DECIMAL(18,2) COMMENT 'Age of the asset in years calculated from its commissioning date to the period end date. Used in reliability trend analysis, end-of-life assessment, and CAPEX replacement planning.. Valid values are `^d+(.d{1,2})?$`',
    `asset_category` STRING COMMENT 'High-level classification of the asset type used to segment reliability KPIs by equipment class. Supports TPM program analysis and CAPEX planning by asset category.. Valid values are `production_equipment|utility_system|material_handling|inspection_equipment|facility_infrastructure|it_ot_system|tooling|other`',
    `asset_criticality` STRING COMMENT 'Criticality classification of the asset based on its impact on production throughput, safety, and quality. Drives maintenance prioritization, spare parts stocking strategy, and CAPEX justification thresholds.. Valid values are `critical|major|general|minor`',
    `asset_name` STRING COMMENT 'Descriptive name of the manufacturing equipment or plant asset (e.g., CNC Machining Center Line 3, Hydraulic Press Unit 7). Supports human-readable reporting and dashboard labeling.',
    `asset_number` STRING COMMENT 'Human-readable asset tag or equipment number as registered in the EAM/CMMS system (e.g., Maximo asset number or SAP PM equipment number). Used for cross-system reconciliation and shop floor identification.. Valid values are `^[A-Z0-9-]{3,30}$`',
    `availability_percentage` DECIMAL(18,2) COMMENT 'Percentage of scheduled operating time during which the asset was available and operational (not in unplanned downtime). Calculated as (Uptime / (Uptime + Unplanned Downtime)) × 100. Fundamental input to OEE calculation and SLA compliance reporting.. Valid values are `^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$`',
    `availability_target_percentage` DECIMAL(18,2) COMMENT 'Target availability percentage defined for the asset in the TPM program, production SLA, or OEM contract. Compared against actual availability_percentage to determine performance gap and trigger corrective actions.. Valid values are `^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$`',
    `computed_timestamp` TIMESTAMP COMMENT 'Timestamp when this reliability record was computed and loaded into the Silver layer lakehouse. Used for data freshness monitoring, pipeline audit trails, and identifying stale records in downstream reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `condition_monitoring_status` STRING COMMENT 'Current health status of the asset as determined by IIoT/MindSphere condition monitoring sensors (vibration, temperature, oil analysis, etc.) at the time of record computation. Supports predictive maintenance decision-making.. Valid values are `normal|advisory|warning|critical|sensor_fault|not_monitored`',
    `corrective_work_order_count` STRING COMMENT 'Total number of corrective (reactive) maintenance work orders raised against the asset during the reporting period. High counts relative to preventive work orders indicate reactive maintenance posture and reliability risk.. Valid values are `^d+$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility where the asset is installed. Enables multi-country reliability benchmarking and compliance with regional regulatory reporting requirements.. Valid values are `^[A-Z]{3}$`',
    `data_source_system` STRING COMMENT 'Identifies the operational system of record from which failure events and work order actuals were sourced for this reliability record computation (e.g., Maximo EAM, SAP S/4HANA PM, Siemens Opcenter MES). Supports data lineage and audit traceability.. Valid values are `maximo_eam|sap_pm|opcenter_mes|mindsphere_iiot|manual|other`',
    `failure_count` STRING COMMENT 'Total number of unplanned failure events recorded for the asset during the reporting period. Used to compute MTBF, assess failure frequency trends, and trigger FMEA reviews or CAPA actions.. Valid values are `^d+$`',
    `failure_mode_primary` STRING COMMENT 'Dominant failure mode category observed across failure events for this asset during the reporting period. Derived from work order failure codes and used to drive FMEA/PFMEA reviews, CAPA actions, and spare parts strategy.. Valid values are `mechanical|electrical|hydraulic|pneumatic|software|instrumentation|structural|wear|corrosion|contamination|operator_error|unknown|other`',
    `last_failure_date` DATE COMMENT 'Date of the most recent unplanned failure event recorded for the asset within or prior to the reporting period. Used to compute time-since-last-failure metrics and assess recurrence risk.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_preventive_maintenance_date` DATE COMMENT 'Date on which the most recent preventive maintenance activity was completed for the asset. Used to assess PM schedule adherence and predict next maintenance due date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `maintenance_cost_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the maintenance cost amount (e.g., USD, EUR, CNY). Supports multi-currency consolidation for global asset portfolio reporting.. Valid values are `^[A-Z]{3}$`',
    `maintenance_cost_local_currency` DECIMAL(18,2) COMMENT 'Total actual maintenance expenditure (labor, materials, and contractor costs) incurred for the asset during the reporting period, expressed in the plants local currency. Used for OPEX tracking, CAPEX justification, and cost-of-reliability analysis.. Valid values are `^d+(.d{1,4})?$`',
    `mean_time_between_failures_hours` DECIMAL(18,2) COMMENT 'Average operating time (in hours) between consecutive unplanned failures for the asset over the reporting period. Core reliability KPI used for TPM effectiveness measurement, spare parts planning, and CAPEX justification. Computed from failure records and work order actuals.. Valid values are `^d+(.d{1,4})?$`',
    `mean_time_to_repair_hours` DECIMAL(18,2) COMMENT 'Average time (in hours) required to restore the asset to operational status following an unplanned failure, measured from failure detection to return-to-service. Key maintainability KPI used to evaluate maintenance crew efficiency and spare parts availability.. Valid values are `^d+(.d{1,4})?$`',
    `next_preventive_maintenance_date` DATE COMMENT 'Scheduled date for the next preventive maintenance activity for the asset, as determined by the maintenance plan in Maximo EAM or SAP PM. Used for production scheduling conflict analysis and resource planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `oee_contribution_percentage` DECIMAL(18,2) COMMENT 'The assets OEE availability component contribution expressed as a percentage. Represents the availability dimension of OEE (Availability × Performance × Quality) attributable to this assets reliability record. Used in TPM program effectiveness dashboards.. Valid values are `^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$`',
    `period_end_date` DATE COMMENT 'End date of the reliability measurement window for this record. Defines the upper boundary of the aggregation interval used for all KPI computations in this record.. Valid values are `^d{4}-d{2}-d{2}$`',
    `period_start_date` DATE COMMENT 'Start date of the reliability measurement window for this record. Combined with period_end_date to define the exact aggregation interval for MTBF, MTTR, and availability calculations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_downtime_hours` DECIMAL(18,2) COMMENT 'Total hours of scheduled downtime for preventive maintenance, calibration, changeover, or planned shutdowns during the reporting period. Distinguishes planned from unplanned downtime for accurate availability and OEE computation.. Valid values are `^d+(.d{1,4})?$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility where the asset is installed. Enables multi-site reliability benchmarking and regional performance aggregation.. Valid values are `^[A-Z0-9]{2,10}$`',
    `predictive_maintenance_flag` BOOLEAN COMMENT 'Indicates whether the asset is enrolled in a predictive maintenance (PdM) program using IIoT sensor data and analytics (e.g., Siemens MindSphere). Assets under PdM programs typically show improved MTBF trends over time.. Valid values are `true|false`',
    `preventive_maintenance_compliance_percentage` DECIMAL(18,2) COMMENT 'Percentage of scheduled preventive maintenance work orders completed on time during the reporting period. Measures TPM program adherence and is a leading indicator of future reliability performance.. Valid values are `^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$`',
    `preventive_work_order_count` STRING COMMENT 'Total number of preventive maintenance work orders executed against the asset during the reporting period. Used to compute PM compliance ratio and assess TPM program maturity.. Valid values are `^d+$`',
    `record_status` STRING COMMENT 'Lifecycle status of this reliability record. Active indicates the current authoritative record; superseded indicates it has been replaced by a recalculated record; under_review indicates pending validation; invalidated indicates data quality issues were found.. Valid values are `active|superseded|under_review|invalidated`',
    `reliability_target_mtbf_hours` DECIMAL(18,2) COMMENT 'Contractual or internally defined MTBF target (in hours) for this asset class, as established in the TPM program or OEM SLA. Used to assess actual MTBF performance against target and trigger escalation or CAPEX review.. Valid values are `^d+(.d{1,4})?$`',
    `remaining_useful_life_years` DECIMAL(18,2) COMMENT 'Estimated remaining useful life of the asset in years, derived from reliability trends, condition monitoring data, and OEM design life specifications. Critical input for CAPEX planning, asset replacement decisions, and depreciation schedule reviews.. Valid values are `^d+(.d{1,2})?$`',
    `reporting_period_type` STRING COMMENT 'Defines the rolling or fixed time window over which reliability KPIs (MTBF, MTTR, availability) are aggregated. Supports trend analysis across different time horizons for TPM and lifecycle decisions.. Valid values are `rolling_30_day|rolling_90_day|rolling_180_day|rolling_365_day|monthly|quarterly|annual|custom`',
    `scheduled_operating_hours` DECIMAL(18,2) COMMENT 'Total hours the asset was scheduled to operate during the reporting period based on the production calendar. Used as the denominator for availability percentage and OEE calculations.. Valid values are `^d+(.d{1,4})?$`',
    `total_operating_hours` DECIMAL(18,2) COMMENT 'Total hours the asset was in active production operation during the reporting period, excluding all downtime. Denominator basis for MTBF calculation and OEE performance rate computation.. Valid values are `^d+(.d{1,4})?$`',
    `tpm_program_code` STRING COMMENT 'Code identifying the TPM program or maintenance strategy (e.g., RCM, CBM, time-based PM) under which this asset is managed. Used to segment reliability performance by maintenance strategy and evaluate TPM program ROI.. Valid values are `^[A-Z0-9-]{2,20}$`',
    `unplanned_downtime_hours` DECIMAL(18,2) COMMENT 'Total hours of unplanned equipment downtime due to failures, breakdowns, or emergency stoppages during the reporting period. Primary driver of MTBF and availability degradation; used in OEE loss analysis.. Valid values are `^d+(.d{1,4})?$`',
    `work_center_code` STRING COMMENT 'Production work center or cost center code to which the asset belongs. Used for OEE contribution analysis and production scheduling impact assessment.. Valid values are `^[A-Z0-9-]{2,20}$`',
    CONSTRAINT pk_reliability_record PRIMARY KEY(`reliability_record_id`)
) COMMENT 'Aggregated reliability performance records per equipment asset tracking MTBF (Mean Time Between Failures), MTTR (Mean Time To Repair), availability percentage, failure frequency, and OEE contribution. Computed from failure records and work order actuals over defined rolling periods. Serves as the authoritative reliability KPI record for asset lifecycle decisions, CAPEX justification, and TPM program effectiveness measurement.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`asset_bom` (
    `asset_bom_id` BIGINT COMMENT 'Unique surrogate identifier for each asset Bill of Materials (BOM) line record in the equipment component hierarchy. Serves as the primary key for the asset_bom entity in the Databricks Silver layer.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Asset bill-of-materials lists product catalog items as components. Engineering uses this for maintenance planning, component replacement, and understanding equipment composition.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: The equipment Bill of Materials defines the spare parts and sub-component structure of a specific equipment asset. No direct equipment FK column exists in asset_bom; adding equipment_id establishes th',
    `alternative_part_number` STRING COMMENT 'Approved alternative or interchangeable part number that can substitute for the primary component when the original is unavailable. Supports MRO procurement flexibility and reduces equipment downtime during spare parts shortages.',
    `change_notice_number` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that introduced or modified this BOM line. Provides full traceability of component changes back to the formal change management process in Siemens Teamcenter PLM.',
    `child_component_number` STRING COMMENT 'Part number or item number of the child component, spare part, or sub-assembly at this BOM line. Corresponds to the material or spare part number in SAP MM or Maximo Item Master used for MRO procurement and inventory management.',
    `component_type` STRING COMMENT 'Functional classification of the component indicating its role in the equipment assembly. Drives MRO stocking strategies, maintenance task material requirements, and spare parts categorization for procurement planning.. Valid values are `spare_part|sub_assembly|consumable|lubricant|tool|fastener|seal|bearing|electrical|pneumatic|hydraulic|software|documentation`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility where this asset BOM is applicable. Supports multinational regulatory compliance (e.g., CE Marking in EU, UL in USA) and country-specific spare parts sourcing strategies.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this asset BOM line record was first created in the source system (Maximo EAM or SAP PM). Used for data lineage, audit trail, and change history tracking in compliance with ISO 9001 quality management documentation requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `criticality_rating` STRING COMMENT 'Criticality classification of the component based on its impact on equipment availability, safety, and production continuity. Critical components trigger mandatory stocking policies and expedited procurement. Supports FMEA-driven maintenance strategies and TPM programs.. Valid values are `critical|high|medium|low`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated unit cost (e.g., USD, EUR, GBP). Supports multi-currency operations in a multinational manufacturing enterprise and enables currency conversion for consolidated financial reporting.. Valid values are `^[A-Z]{3}$`',
    `drawing_number` STRING COMMENT 'Reference to the engineering drawing or technical document number associated with this component, managed in Siemens Teamcenter PLM or the document management system. Enables maintenance technicians to access assembly diagrams and installation specifications.',
    `effective_from_date` DATE COMMENT 'Date from which this BOM line item becomes valid and effective for use in maintenance planning and MRO procurement. Supports date-effective BOM management to handle engineering changes (ECN/ECO) and component supersessions over the asset lifecycle.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_to_date` DATE COMMENT 'Date after which this BOM line item is no longer valid. Used to manage component supersessions, phase-outs, and engineering change orders (ECO). Null value indicates the line is currently valid with no planned expiry.. Valid values are `^d{4}-d{2}-d{2}$`',
    `estimated_unit_cost` DECIMAL(18,2) COMMENT 'Estimated procurement cost per unit of this component in the transaction currency. Used for MRO budget planning, CAPEX/OPEX spare parts inventory valuation, and maintenance cost estimation. Sourced from SAP MM moving average price or standard cost.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `hierarchy_level` STRING COMMENT 'Numeric depth level of this component within the BOM tree structure, starting at 1 for the top-level assembly. Enables traversal and explosion of multi-level equipment BOMs for maintenance planning and spare parts analysis.. Valid values are `^[0-9]{1,3}$`',
    `installation_position` STRING COMMENT 'Physical location or mounting position identifier where the component is installed within the parent assembly (e.g., Bearing Housing A, Inlet Valve Position 3). Critical for maintenance technicians to locate and replace components during work order execution.',
    `internal_part_number` STRING COMMENT 'Company-internal material or part number assigned to the component in the ERP/EAM system (SAP MM material number or Maximo item number). Used for internal procurement, inventory management, and work order material reservations.',
    `is_regulatory_controlled` BOOLEAN COMMENT 'Indicates whether this component is subject to regulatory control, certification requirements, or compliance obligations (e.g., CE Marking, UL certification, REACH/RoHS compliance, pressure vessel regulations). Triggers mandatory documentation and traceability requirements.. Valid values are `true|false`',
    `is_safety_critical` BOOLEAN COMMENT 'Indicates whether this component is classified as safety-critical, meaning its failure could result in personnel injury, environmental incident, or regulatory non-compliance. Safety-critical components require mandatory inspection intervals and controlled replacement procedures per OSHA and ISO 45001.. Valid values are `true|false`',
    `item_category` STRING COMMENT 'Classification of the BOM line item indicating how the component is managed and procured. Stock items are warehouse-managed spare parts; non-stock items are direct-procured; document items reference technical drawings; text items are descriptive notes.. Valid values are `stock_item|non_stock_item|document|text|class_item|configurable_item`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this asset BOM line record in the source system. Supports incremental data loading in the Databricks Silver layer, change detection, and audit trail requirements for configuration management.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_time_days` STRING COMMENT 'Standard procurement lead time in calendar days for this component from the preferred supplier. Used in MRO spare parts planning to determine minimum stock levels, reorder points, and emergency procurement timelines to minimize equipment downtime.. Valid values are `^[0-9]{1,4}$`',
    `manufacturer_name` STRING COMMENT 'Name of the original equipment manufacturer (OEM) or component manufacturer. Used for approved vendor list management, warranty validation, and ensuring OEM-specified spare parts are used in maintenance activities to preserve equipment warranties.',
    `manufacturer_part_number` STRING COMMENT 'Original manufacturers part number for the component, distinct from the internal material number. Essential for cross-referencing with supplier catalogs, sourcing equivalent parts, and validating OEM compliance during MRO procurement via SAP Ariba.',
    `number` STRING COMMENT 'Business-facing identifier for the equipment BOM structure, typically sourced from Maximo EAM or SAP PM. Groups all component lines belonging to the same asset BOM revision together. Distinct from the engineering product BOM managed in Siemens Teamcenter PLM.. Valid values are `^[A-Z0-9-]{3,30}$`',
    `parent_component_number` STRING COMMENT 'Part number or item number of the parent assembly or sub-assembly in the BOM hierarchy. Defines the immediate parent node in the parent-child component relationship tree. Used to reconstruct the full hierarchical structure of the equipment.',
    `plant_code` STRING COMMENT 'SAP plant code or facility identifier where this asset BOM is applicable. Supports multi-plant operations in a multinational manufacturing enterprise, enabling plant-specific BOM variants and localized spare parts stocking strategies.. Valid values are `^[A-Z0-9]{2,6}$`',
    `position_number` STRING COMMENT 'Sequential numeric position identifier for the component within the BOM structure, following SAP BOM item numbering conventions (e.g., 0010, 0020). Used for ordering and referencing BOM line items in maintenance documentation and work orders.. Valid values are `^[0-9]{4}$`',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity of the child component required per one unit of the parent assembly. Used in MRO spare parts planning, maintenance work order material requirements, and inventory replenishment calculations.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether this component complies with the EU REACH Regulation (EC 1907/2006) for chemical substance registration and restriction. Critical for environmental compliance reporting and supply chain chemical substance management.. Valid values are `true|false`',
    `recommended_stock_quantity` DECIMAL(18,2) COMMENT 'Recommended minimum on-hand stock quantity for this spare part based on criticality, lead time, and maintenance frequency. Drives MRO inventory stocking policies and reorder point calculations in the Warehouse Management System (WMS).. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `replacement_interval_days` STRING COMMENT 'Recommended or OEM-specified replacement interval for this component expressed in calendar days. Complements the operating-hours-based interval for time-based preventive maintenance scheduling, particularly for components subject to age-related degradation regardless of usage.. Valid values are `^[0-9]{1,5}$`',
    `replacement_interval_hours` DECIMAL(18,2) COMMENT 'Recommended or OEM-specified replacement interval for this component expressed in equipment operating hours. Used to generate preventive maintenance (PM) work orders and schedule planned replacements as part of the TPM program in Maximo EAM.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `revision` STRING COMMENT 'Revision or version identifier of the asset BOM, incremented when engineering changes (ECN/ECO) are applied to the component structure. Enables tracking of configuration changes over the asset lifecycle.. Valid values are `^[A-Z0-9.]{1,10}$`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether this component complies with the EU RoHS Directive (2011/65/EU) restricting the use of hazardous substances such as lead, mercury, cadmium, and hexavalent chromium. Required for CE Marking compliance and environmental regulatory reporting.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this asset BOM line was sourced (e.g., Maximo EAM, SAP S/4HANA PM, Siemens Teamcenter PLM). Supports data lineage tracking and conflict resolution when multiple systems contribute BOM data to the Silver layer.. Valid values are `MAXIMO|SAP_PM|TEAMCENTER|OPCENTER|MANUAL`',
    `spare_part_class` STRING COMMENT 'MRO spare parts classification indicating the stocking and management strategy for this component. Insurance spares are held for catastrophic failures; running spares are regularly consumed; rotables are repaired and returned to stock. Drives inventory investment decisions and CAPEX/OPEX classification.. Valid values are `insurance_spare|running_spare|consumable|capital_spare|rotable`',
    `status` STRING COMMENT 'Current lifecycle status of this BOM line item. Active lines are valid for use in maintenance planning; obsolete lines have been superseded by newer components; draft lines are pending engineering approval. Drives filtering in maintenance planning and MRO procurement workflows.. Valid values are `active|inactive|obsolete|superseded|under_review|draft`',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure for the component quantity at this BOM line (e.g., EA for each, KG for kilogram, L for litre). Aligns with the base unit of measure defined in the material master for accurate MRO procurement and inventory management.. Valid values are `EA|KG|L|M|M2|M3|SET|PAIR|BOX|ROLL|FT|IN|LB|GAL`',
    `usage` STRING COMMENT 'Defines the intended usage context of this BOM, distinguishing maintenance BOMs (for MRO spare parts and work order planning) from production BOMs (for manufacturing) and engineering BOMs (for design). Ensures the correct BOM is consumed by the appropriate business process.. Valid values are `maintenance|production|engineering|universal`',
    `weight_kg` DECIMAL(18,2) COMMENT 'Physical weight of the component in kilograms. Used for logistics planning, shipping cost estimation, equipment load calculations, and ergonomic risk assessments for maintenance activities per ISO 45001 occupational health requirements.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    CONSTRAINT pk_asset_bom PRIMARY KEY(`asset_bom_id`)
) COMMENT 'Equipment Bill of Materials defining the hierarchical spare parts and sub-component structure of manufacturing assets. Captures parent-child component relationships, part numbers, quantities, installation positions, and criticality ratings. Enables MRO spare parts planning, maintenance task material requirements, and equipment configuration management. Distinct from the engineering product BOM managed in Teamcenter PLM.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`work_order_operation` (
    `work_order_operation_id` BIGINT COMMENT 'Unique surrogate identifier for each individual operation step within a maintenance work order. Serves as the primary key for the work_order_operation entity in the Databricks Silver Layer.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Operations may be equipment-specific within a multi-asset work order. Adding equipment_id FK enables operation-level asset tracking for complex maintenance activities.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Each maintenance operation must record which technician performed the work for labor tracking, quality accountability, and compliance documentation required in manufacturing.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Work order operations specify which warehouse to pull spare parts from. Maintenance planners assign the source warehouse for parts retrieval to optimize logistics and ensure parts availability for sch',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Operations are individual steps within a work order defining the maintenance task sequence. Adding work_order_id FK establishes the parent-child relationship and allows removal of denormalized work or',
    `activity_type` STRING COMMENT 'Cost accounting activity type code used to classify the labor cost of this operation for internal order settlement and cost center allocation (e.g., MAINT_LABOR, INSP_LABOR, OVHL_LABOR).',
    `actual_cost` DECIMAL(18,2) COMMENT 'Actual cost incurred for this operation step upon confirmation, including posted labor hours valued at activity rates. Used for cost variance analysis and maintenance budget reporting.',
    `actual_duration_hours` DECIMAL(18,2) COMMENT 'Actual elapsed time recorded for completing this operation. Used for Mean Time To Repair (MTTR) analysis, scheduling accuracy assessment, and maintenance performance benchmarking.',
    `actual_finish_timestamp` TIMESTAMP COMMENT 'Date and time when this operation was confirmed as completed by the executing technician or supervisor. Triggers downstream processes such as cost settlement and equipment return to service.',
    `actual_labor_hours` DECIMAL(18,2) COMMENT 'Actual number of labor hours recorded upon confirmation of this operation step. Compared against estimated hours for variance analysis, MTTR tracking, and future planning calibration.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Date and time when execution of this operation actually commenced, as recorded by the technician or MES system. Used for schedule adherence analysis and MTTR calculation.',
    `completion_confirmation_text` STRING COMMENT 'Free-text remarks entered by the technician or supervisor at the time of operation confirmation, describing findings, deviations from plan, or conditions observed during execution.',
    `confirmation_number` STRING COMMENT 'Reference number of the time confirmation document recorded against this operation in the EAM/CMMS system. Links the operation to labor time postings and cost accounting entries.',
    `control_key` STRING COMMENT 'SAP PM control key that governs how the operation is processed — whether it is internally performed, externally procured, or a milestone operation. Determines scheduling, costing, and confirmation behavior.',
    `cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which the estimated and actual operation costs are expressed. Supports multi-currency financial reporting in multinational manufacturing environments.. Valid values are `^[A-Z]{3}$`',
    `cost_element` STRING COMMENT 'General ledger cost element code to which the labor and resource costs of this operation are posted. Enables OPEX tracking and maintenance cost analysis by operation type.',
    `craft_type` STRING COMMENT 'Trade or skill discipline required to perform this operation (e.g., Mechanical, Electrical, Instrumentation). Enables multi-craft coordination and ensures qualified technicians are assigned.. Valid values are `mechanical|electrical|instrumentation|civil|welding|hvac|it_ot|general|contractor`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this work order operation record was created in the source EAM/CMMS system. Used for audit trail, data lineage, and SLA compliance tracking.',
    `estimated_cost` DECIMAL(18,2) COMMENT 'Planned cost for executing this operation step, including labor and any directly assigned resources. Used for work order budget control and CAPEX/OPEX planning.',
    `estimated_duration_hours` DECIMAL(18,2) COMMENT 'Planned elapsed time (wall-clock duration) to complete this operation, distinct from labor hours when multiple technicians work in parallel. Used for scheduling and equipment downtime planning.',
    `estimated_labor_hours` DECIMAL(18,2) COMMENT 'Planned number of labor hours required to complete this operation step, as defined during work order planning. Used for capacity planning, scheduling, and cost estimation.',
    `external_service_order_number` STRING COMMENT 'Purchase order or service order number raised for externally performed operations where a third-party contractor or service provider executes the maintenance task. Links to procurement records.',
    `is_milestone` BOOLEAN COMMENT 'Indicates whether this operation is a milestone step whose completion triggers automatic progression of the work order status or downstream workflow actions (e.g., safety permit release, quality inspection gate).. Valid values are `true|false`',
    `is_safety_critical` BOOLEAN COMMENT 'Indicates whether this operation involves safety-critical activities requiring special permits, lockout/tagout (LOTO) procedures, confined space entry, or other regulatory safety controls.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to this work order operation record in the source system. Used for incremental data loading, change detection, and audit compliance.',
    `number_of_technicians` STRING COMMENT 'Number of technicians or workers required to simultaneously execute this operation. Used for crew sizing, shift planning, and labor cost estimation.',
    `operation_long_text` STRING COMMENT 'Detailed narrative instructions for the maintenance technician performing this operation, including safety precautions, Standard Operating Procedure (SOP) references, and step-by-step guidance.',
    `operation_number` STRING COMMENT 'Sequential step number identifying the position of this operation within the work order (e.g., 0010, 0020, 0030). Determines execution sequence and is used for multi-craft coordination and scheduling.. Valid values are `^[0-9]{4}$`',
    `operation_short_text` STRING COMMENT 'Brief description of the maintenance task to be performed in this operation step (e.g., Inspect bearing assembly, Replace hydraulic seal). Used in work order printouts and shop floor instructions.',
    `operation_type` STRING COMMENT 'Classification of the maintenance operation type indicating the nature of work to be performed. Drives resource planning, cost allocation, and compliance reporting.. Valid values are `internal|external|inspection|calibration|lubrication|replacement|overhaul|cleaning|testing|adjustment`',
    `permit_to_work_number` STRING COMMENT 'Reference number of the Permit to Work (PTW) document issued for this operation. Provides audit trail for safety compliance and regulatory inspections.',
    `permit_to_work_required` BOOLEAN COMMENT 'Indicates whether a formal Permit to Work (PTW) must be issued and approved before this operation can commence. Enforces safety compliance for high-risk maintenance activities.. Valid values are `true|false`',
    `plant_code` STRING COMMENT 'Manufacturing plant or facility code where this operation is to be executed. Supports multi-plant maintenance operations and regional reporting in multinational environments.',
    `qualification_code` STRING COMMENT 'Specific skill or certification code required to perform this operation (e.g., high-voltage certification, confined space entry, forklift license). Ensures regulatory compliance and worker safety.',
    `remaining_labor_hours` DECIMAL(18,2) COMMENT 'Forecasted remaining labor hours needed to complete this operation, updated during partial confirmations. Supports real-time work order progress tracking and resource reallocation decisions.',
    `scheduled_finish_timestamp` TIMESTAMP COMMENT 'Planned date and time when this operation is scheduled to be completed. Used for maintenance window management, production impact assessment, and SLA compliance tracking.',
    `scheduled_start_timestamp` TIMESTAMP COMMENT 'Planned date and time when this operation is scheduled to begin. Used for maintenance scheduling, shift planning, and equipment downtime window coordination.',
    `standard_text_key` STRING COMMENT 'Reference key to a pre-defined standard text or Standard Operating Procedure (SOP) template that provides the detailed work instructions for this operation type. Promotes consistency and reduces planning effort.',
    `status` STRING COMMENT 'Current lifecycle status of the work order operation step. Tracks progression from creation through execution to completion, enabling operation-level progress monitoring and KPI reporting.. Valid values are `created|released|in_progress|partially_confirmed|confirmed|technically_completed|closed|cancelled`',
    `sub_operation_number` STRING COMMENT 'Optional sub-step identifier used when an operation is further decomposed into parallel or sequential sub-tasks. Supports detailed multi-craft breakdown within a single operation step.',
    `system_status` STRING COMMENT 'System-generated status code from the source EAM/CMMS system (e.g., CRTD, REL, CNF, TECO) reflecting the technical processing state of the operation. Complements the business-facing status field.',
    `user_status` STRING COMMENT 'User-defined status code applied by maintenance planners or supervisors to reflect business-specific workflow states beyond the system status (e.g., AWMAT - Awaiting Materials, AWPMT - Awaiting Permit).',
    `work_center_code` STRING COMMENT 'Identifier of the work center (maintenance crew, craft group, or production cell) responsible for executing this operation. Used for capacity planning, labor scheduling, and cost center assignment.',
    CONSTRAINT pk_work_order_operation PRIMARY KEY(`work_order_operation_id`)
) COMMENT 'Individual operation steps within a maintenance work order defining the sequence of maintenance tasks, craft/skill requirements, estimated and actual labor hours, work center assignments, and operation-level completion status. Enables detailed labor planning, multi-craft coordination, and operation-level progress tracking within complex maintenance work orders.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`permit_to_work` (
    `permit_to_work_id` BIGINT COMMENT 'Unique system-generated identifier for each permit to work record within the manufacturing enterprise.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Safety permits authorize maintenance and operational activities on specific equipment. Adding equipment_id FK establishes the asset relationship and allows removal of denormalized equipment_number str',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Permits are location-specific for area-based work authorization. Adding functional_location_id FK enables location-based permit management and allows removal of denormalized location_code string.',
    `incident_id` BIGINT COMMENT 'Foreign key linking to hse.incident. Business justification: When incidents occur during permitted work, the permit must reference the incident for investigation, permit system review, and contractor safety performance tracking.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Safety permits must identify the specific employee authorized to perform hazardous work. Critical for safety compliance and legal liability in manufacturing operations.',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_obligation. Business justification: Permits to work must satisfy specific compliance obligations (OSHA, ATEX, confined space regulations). Safety officers verify obligation fulfillment before authorizing high-risk maintenance work.',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Permits are issued for work orders requiring safety authorization. Adding work_order_id FK links permits to maintenance activities and allows removal of denormalized work order number string.',
    `approved_timestamp` TIMESTAMP COMMENT 'The exact date and time when the issuing authority formally approved the permit to work. Provides a precise audit trail event for regulatory compliance and incident investigation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `closed_by` STRING COMMENT 'Name or employee ID of the authorized person who formally closed the permit to work, confirming that all safety precautions have been removed, equipment has been re-energized safely, and the work area has been restored.',
    `closed_timestamp` TIMESTAMP COMMENT 'The date and time when the permit was formally closed upon completion or cancellation of the work. Closure confirms that all isolation points have been reinstated, the work area is safe, and all personnel have been accounted for.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `closure_confirmation` BOOLEAN COMMENT 'Boolean flag confirming that the permit has been formally closed with all required sign-offs completed, isolation points reinstated, tools and materials removed, and the work area restored to a safe operational state.. Valid values are `true|false`',
    `confined_space_class` STRING COMMENT 'Classification of the confined space involved in the permitted work, per OSHA 29 CFR 1910.146. Permit-required confined spaces have serious safety hazards and require additional controls beyond standard confined space entry procedures.. Valid values are `permit_required|non_permit_required|not_applicable`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the permitted work is being performed. Enables multi-country regulatory compliance tracking, as permit requirements vary by jurisdiction (OSHA, EU Directives, local HSE regulations).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the permit to work record was first created in the system. Provides the starting point of the permit lifecycle audit trail.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Detailed narrative description of the work scope, tasks to be performed, equipment involved, and specific hazards identified. Provides full context for safety officers and executing personnel.',
    `electrical_voltage_level` STRING COMMENT 'Classification of the electrical voltage level involved in the permitted electrical isolation or electrical work activity. Determines the arc flash boundary, required PPE, and qualified electrician requirements.. Valid values are `low_voltage|medium_voltage|high_voltage|extra_high_voltage|not_applicable`',
    `fire_watch_required` BOOLEAN COMMENT 'Indicates whether a dedicated fire watch attendant is required during and after the permitted work activity. Mandatory for hot work permits involving welding, cutting, or grinding near combustible materials.. Valid values are `true|false`',
    `gas_test_required` BOOLEAN COMMENT 'Indicates whether atmospheric gas testing is required before and/or during the permitted work. Mandatory for confined space entry, hot work near flammable materials, and chemical handling permits.. Valid values are `true|false`',
    `gas_test_result` STRING COMMENT 'Result of the atmospheric gas test conducted prior to permit activation. A pass result confirms safe atmospheric conditions for the work to proceed. Failure requires remediation before work can commence.. Valid values are `pass|fail|not_required|pending`',
    `hot_work_type` STRING COMMENT 'Specific type of hot work activity being performed under the permit, if applicable. Used to determine fire prevention requirements, fire watch duration, and post-work inspection periods.. Valid values are `welding|cutting|grinding|brazing|soldering|open_flame|not_applicable`',
    `incident_occurred` BOOLEAN COMMENT 'Indicates whether a safety incident, near-miss, or injury occurred during the execution of the permitted work. When true, triggers mandatory incident reporting and CAPA (Corrective and Preventive Action) processes.. Valid values are `true|false`',
    `incident_report_number` STRING COMMENT 'Reference number of the safety incident report or non-conformance report (NCR) raised as a result of an incident occurring during the permitted work. Enables traceability between permits and incident management records.',
    `isolation_points` STRING COMMENT 'Textual description or list of all energy isolation points (electrical breakers, valves, pneumatic lines, hydraulic lines) that must be isolated before work commences. Critical for LOTO compliance and safe execution.',
    `issuing_authority` STRING COMMENT 'Name or employee ID of the authorized person (typically a safety officer, area manager, or permit issuer) who reviewed and approved the permit to work. This individual bears legal and regulatory accountability for the permit.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when the permit to work record was most recently updated. Supports change tracking, audit compliance, and data freshness monitoring in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `loto_procedure_number` STRING COMMENT 'Reference number of the specific LOTO procedure document that must be followed for energy isolation. Links to the documented LOTO procedure in the safety management system or document control system.',
    `loto_required` BOOLEAN COMMENT 'Indicates whether Lockout/Tagout (LOTO) procedures are mandatory for this permit. When true, all energy isolation points must be locked and tagged before work commences, per OSHA 29 CFR 1910.147.. Valid values are `true|false`',
    `number_of_workers` STRING COMMENT 'Total number of workers authorized to perform work under this permit. Used for personnel accountability, emergency mustering, and ensuring the work area is not overcrowded beyond safe limits.. Valid values are `^[1-9][0-9]*$`',
    `performing_contractor` STRING COMMENT 'Name of the internal work crew, department, or external contractor company responsible for executing the permitted work. Supports contractor management and safety compliance tracking.',
    `permit_number` STRING COMMENT 'Human-readable business reference number for the permit, typically formatted with plant code, year, and sequence. Used for cross-referencing in work orders, audits, and regulatory inspections.. Valid values are `^PTW-[A-Z]{2,6}-[0-9]{4}-[0-9]{6}$`',
    `permit_type` STRING COMMENT 'Classification of the permit based on the nature of the hazardous work being authorized. Determines the specific safety precautions, isolation requirements, and regulatory compliance obligations applicable to the work activity.. Valid values are `hot_work|cold_work|confined_space_entry|electrical_isolation|lockout_tagout|working_at_height|excavation|radiation|chemical_handling|general`',
    `plant_code` STRING COMMENT 'SAP S/4HANA plant code identifying the manufacturing facility where the permitted work is to be performed. Enables plant-level safety compliance reporting and regulatory submissions.',
    `ppe_requirements` STRING COMMENT 'Description of the mandatory Personal Protective Equipment (PPE) that must be worn by all personnel performing the permitted work, e.g., arc flash suit, SCBA, chemical-resistant gloves, fall harness.',
    `regulatory_standard` STRING COMMENT 'Primary regulatory standard or legal requirement governing this permit to work, e.g., OSHA 29 CFR 1910.147, ISO 45001, EU Directive 1999/92/EC (ATEX), or local national HSE regulation. Supports multi-jurisdictional compliance reporting.',
    `renewal_count` STRING COMMENT 'Number of times this permit has been renewed or extended beyond its original validity window. Repeated renewals may indicate work scope creep or scheduling issues and are tracked for safety audit purposes.. Valid values are `^[0-9]+$`',
    `requested_by` STRING COMMENT 'Name or employee ID of the person (typically the maintenance technician, contractor supervisor, or work requester) who initiated the permit to work application. Required for accountability and audit trail.',
    `risk_assessment_number` STRING COMMENT 'Reference number of the formal risk assessment or job hazard analysis (JHA) document that underpins the safety controls specified in this permit. Provides traceability to the documented risk management process.',
    `risk_level` STRING COMMENT 'Overall risk classification assigned to the permitted work activity based on the hazard identification and risk assessment. Determines the level of authorization required and the intensity of safety controls to be applied.. Valid values are `low|medium|high|critical`',
    `safety_precautions` STRING COMMENT 'Detailed list of safety precautions, control measures, and risk mitigation steps that must be implemented before and during the permitted work. Derived from the job hazard analysis or risk assessment for the activity.',
    `status` STRING COMMENT 'Current lifecycle status of the permit to work. Tracks the permit from initial drafting through approval, active execution, and final closure or cancellation. Critical for real-time safety control on the shop floor.. Valid values are `draft|pending_approval|approved|active|suspended|cancelled|closed|expired`',
    `suspension_reason` STRING COMMENT 'Reason for suspending an active permit to work, e.g., change in atmospheric conditions, discovery of additional hazards, emergency evacuation, or shift change. Mandatory when status transitions to suspended.',
    `title` STRING COMMENT 'Short descriptive title summarizing the work activity being authorized by the permit, e.g., Electrical Panel Maintenance - Line 3 Switchgear.',
    `valid_from` TIMESTAMP COMMENT 'The date and time from which the permit to work is authorized and active. Work must not commence before this timestamp. Enforces the authorized time window for hazardous work execution.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `valid_to` TIMESTAMP COMMENT 'The date and time at which the permit to work expires. Work must cease and the permit must be formally closed or renewed before this timestamp. Prevents unauthorized continuation of hazardous work beyond the approved window.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    CONSTRAINT pk_permit_to_work PRIMARY KEY(`permit_to_work_id`)
) COMMENT 'Safety permit records authorizing maintenance and operational activities on hazardous equipment including lockout/tagout (LOTO) permits, hot work permits, confined space entry permits, and electrical isolation permits. Captures permit type, issuing authority, valid time window, safety precautions, isolation points, and permit closure confirmation. Mandatory for OSHA and ISO 45001 compliance in manufacturing environments.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`calibration_record` (
    `calibration_record_id` BIGINT COMMENT 'Unique system-generated identifier for each calibration record within the enterprise asset management system.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Calibration records must identify certified technicians who performed the work for ISO compliance, quality audits, and traceability in regulated manufacturing.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Calibration records reference the catalog item being calibrated for traceability to manufacturer specifications. Quality teams use this for compliance and calibration procedure selection.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Calibration is performed on precision equipment and measurement instruments. Adding equipment_id FK establishes the asset relationship and allows removal of denormalized asset_number string.',
    `measurement_point_id` BIGINT COMMENT 'Foreign key linking to asset.measurement_point. Business justification: Calibration is specific to measurement points on equipment. Adding measurement_point_id FK enables point-level calibration tracking and history.',
    `product_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.product_specification. Business justification: Calibration must verify equipment meets engineering specifications. Quality and metrology teams reference product specs to determine calibration acceptance criteria and measurement uncertainty require',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Calibration activities must comply with specific regulatory requirements (ISO 17025, FDA 21 CFR Part 11). Quality teams link calibrations to regulations for audit trails and compliance reporting.',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Calibration activities are executed via work orders. Adding work_order_id FK links calibration to maintenance execution and allows removal of denormalized work order number string.',
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
    `asset_register_id` BIGINT COMMENT 'Foreign key linking to finance.asset_register. Business justification: Asset valuations (impairments, revaluations, fair value assessments) must link to the financial asset register for GAAP/IFRS compliance and balance sheet accuracy.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Financial valuations are for capital equipment assets tracking acquisition cost, depreciation, and book value. Adding equipment_id FK links financial records to physical assets.',
    `accumulated_depreciation` DECIMAL(18,2) COMMENT 'Total depreciation charged against the asset from the capitalization date to the current valuation date. Represents the cumulative reduction in asset value due to wear, obsolescence, and usage over its useful life.',
    `accumulated_depreciation_gl_account` STRING COMMENT 'The SAP General Ledger contra-asset account code used to record accumulated depreciation for this asset. Supports balance sheet presentation of gross asset value less accumulated depreciation.',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'The original historical cost of acquiring the asset, including purchase price, import duties, installation costs, and any directly attributable costs to bring the asset to its intended use. Recorded in the transaction currency per IAS 16.',
    `acquisition_cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the acquisition cost transaction currency (e.g., USD, EUR, CNY). Supports multi-currency asset accounting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `acquisition_cost_group_currency` DECIMAL(18,2) COMMENT 'The acquisition cost translated into the group reporting currency (e.g., USD for a US-headquartered multinational). Used for consolidated financial reporting and CAPEX tracking at the enterprise level.',
    `acquisition_date` DATE COMMENT 'The date on which the asset was acquired or purchased. May differ from the capitalization date if the asset was under construction or in transit before being placed in service.. Valid values are `^d{4}-d{2}-d{2}$`',
    `asset_class_code` STRING COMMENT 'SAP FI-AA asset class code that categorizes the fixed asset (e.g., machinery, buildings, vehicles, IT equipment). Drives default depreciation parameters, GL account determination, and capitalization rules.',
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
    `fiscal_year` STRING COMMENT 'The fiscal year to which this asset valuation record belongs (e.g., 2024). Used for annual CAPEX reporting, fixed asset schedules, and year-end financial close in SAP FI-AA.. Valid values are `^d{4}$`',
    `gl_account_code` STRING COMMENT 'The SAP General Ledger account code to which the asset acquisition cost and depreciation are posted. Links the asset valuation to the finance domain general ledger for balance sheet and P&L reporting.',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`capex_request` (
    `capex_request_id` BIGINT COMMENT 'Unique system-generated identifier for each capital expenditure request record in the Databricks Silver Layer. Serves as the primary key for all downstream joins and lineage tracking.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Capital expenditure requests for new equipment or major upgrades are tied to customer accounts for project tracking, budgeting, and approval workflows.',
    `budget_id` BIGINT COMMENT 'Foreign key linking to finance.budget. Business justification: Capital expenditure requests must reference approved capital budgets for authorization and tracking. Finance validates capex requests against budget availability before approval.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Capital expenditure requests specify which catalog items to purchase. Finance and operations use this for budgeting, approval workflows, and procurement of new equipment.',
    `class_id` BIGINT COMMENT 'Foreign key linking to asset.asset_class. Business justification: CAPEX requests reference asset classes for new acquisitions and capacity expansion. Adding asset_class_id FK enables asset class-level investment tracking and allows removal of denormalized asset_cate',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Capex requests originate from specific cost centers (departments) for budget ownership and post-acquisition depreciation allocation. Used for capital planning and accountability.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: CAPEX requests may be for specific equipment replacement, upgrade, or major overhaul. Adding equipment_id FK links capital investment requests to existing assets being replaced or upgraded.',
    `order_quotation_id` BIGINT COMMENT 'Foreign key linking to order.quotation. Business justification: Capital expenditure requests for new equipment reference supplier quotations for budget approval. Finance teams validate capex spending against approved quotes before issuing purchase orders.',
    `procurement_purchase_requisition_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_requisition. Business justification: Capital equipment purchases require formal procurement requisitions. Finance and procurement teams track capex requests through the PR-to-PO workflow for budget control and approval.',
    `project_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_project. Business justification: Capital expenditure requests for new equipment originate from engineering projects. Finance and asset management track CAPEX against engineering project budgets for new production lines, automation up',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: Capital equipment requests often originate from R&D projects requiring new manufacturing capabilities. Finance tracks which R&D initiatives drive equipment investments for ROI analysis and project cos',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Capital expenditure requests must track which employee/manager initiated the request for approval workflows, budget accountability, and investment decision tracking.',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Capital expenditure requests for new equipment/upgrades link to sales opportunities that generated the purchase. Finance uses this for budget approval and ROI tracking against sales projections.',
    `actual_completion_date` DATE COMMENT 'Actual date on which the capital project was completed and the asset was commissioned or placed in service. Triggers asset capitalization in SAP FI-AA and depreciation commencement under IFRS IAS 16.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `amount_in_group_currency` DECIMAL(18,2) COMMENT 'Requested CAPEX amount converted to the corporate group reporting currency (e.g., USD or EUR) for consolidated investment portfolio reporting and cross-entity budget comparison.',
    `approval_date` DATE COMMENT 'Date on which the capital expenditure request received final formal approval from the authorized approving body. Used to calculate approval cycle time and trigger SAP PS project activation.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `approved_amount` DECIMAL(18,2) COMMENT 'Capital expenditure amount formally approved by the investment committee or authorized approver. May differ from requested amount due to scope adjustments, budget constraints, or phased approval decisions.',
    `approved_by` STRING COMMENT 'Employee ID or user ID of the final approving authority (e.g., CFO, Investment Committee Chair) who granted formal approval for the capital expenditure request. Required for audit and SOX compliance.',
    `budget_cycle` STRING COMMENT 'Budget planning cycle in which the CAPEX request was submitted. Distinguishes between annual plan submissions, mid-year reviews, supplemental requests, rolling forecasts, and emergency approvals.. Valid values are `annual_plan|mid_year_review|supplemental|rolling_forecast|emergency`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity responsible for the capital expenditure. Determines the financial reporting entity, currency, and chart of accounts for asset capitalization under IFRS or GAAP.. Valid values are `^[A-Z0-9]{4}$`',
    `cost_center_code` STRING COMMENT 'SAP cost center code to which the capital expenditure will be allocated for internal cost accounting and controlling purposes. Used for OPEX/CAPEX split analysis and departmental budget tracking.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the capital asset will be installed or the project will be executed. Supports multi-country CAPEX reporting, regulatory compliance tracking, and tax treatment determination.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the CAPEX request record was first created in the source system (SAP PS or CAPEX management tool). Used for audit trail, data lineage, and SLA compliance tracking in the Databricks Silver Layer.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the requested and approved CAPEX amounts (e.g., USD, EUR, CNY). Supports multi-currency CAPEX planning in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `current_approval_level` STRING COMMENT 'Current stage in the multi-tier approval workflow for the CAPEX request. Reflects the authorization level required based on investment amount thresholds defined in the corporate CAPEX approval authority matrix.. Valid values are `department_manager|plant_manager|regional_director|vp_operations|cfo|investment_committee|board`',
    `description` STRING COMMENT 'Detailed narrative describing the scope, objectives, and business rationale of the capital expenditure request. Captures project justification, technical specifications, and strategic alignment for investment committee review.',
    `estimated_roi_percent` DECIMAL(18,2) COMMENT 'Projected return on investment percentage for the capital expenditure, calculated as net benefit divided by total investment cost. Key financial metric used by investment committees to rank and prioritize CAPEX requests.',
    `group_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the corporate group reporting currency used in consolidated CAPEX portfolio reporting (e.g., USD for a US-headquartered multinational).. Valid values are `^[A-Z]{3}$`',
    `internal_rate_of_return_percent` DECIMAL(18,2) COMMENT 'Internal rate of return percentage for the capital investment, representing the discount rate at which NPV equals zero. Used alongside ROI and payback period for comprehensive investment committee financial analysis.',
    `investment_program_position` STRING COMMENT 'SAP PS investment program position code that classifies the CAPEX request within the corporate investment portfolio hierarchy. Enables top-down budget planning and bottom-up CAPEX aggregation across business units.',
    `justification_category` STRING COMMENT 'Strategic justification category for the capital investment, used to align CAPEX requests with corporate strategic pillars and investment portfolio analysis. Mandatory field for investment committee scoring.. Valid values are `cost_reduction|revenue_growth|capacity_increase|regulatory_mandatory|safety_mandatory|quality_improvement|maintenance_reliability|sustainability|digital_transformation|risk_mitigation`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the CAPEX request record in the source system. Used for incremental data loading, change detection, and audit trail maintenance in the Databricks Silver Layer.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `net_present_value` DECIMAL(18,2) COMMENT 'Net present value of the capital investment, calculated as the present value of expected future cash flows minus the initial investment cost. Expressed in transaction currency. Core financial metric for investment committee evaluation.',
    `payback_period_months` STRING COMMENT 'Estimated number of months required to recover the capital investment from net cash flows or cost savings generated by the asset. Standard financial metric in CAPEX justification and investment committee scoring.',
    `planned_completion_date` DATE COMMENT 'Planned date for completion of the capital project and asset commissioning. Used for project milestone tracking, capitalization date estimation, and depreciation start planning.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `planned_start_date` DATE COMMENT 'Planned date for commencement of the capital project execution (e.g., procurement initiation, construction start, or equipment delivery). Used for project scheduling and cash flow forecasting.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or operational site where the capital asset will be installed or the project will be executed. Used for plant-level CAPEX budget allocation and reporting.. Valid values are `^[A-Z0-9]{4}$`',
    `priority` STRING COMMENT 'Business priority rating assigned to the capital expenditure request, reflecting urgency, strategic importance, and risk of deferral. Used by investment committees to rank competing requests within budget cycles.. Valid values are `critical|high|medium|low`',
    `regulatory_compliance_required` BOOLEAN COMMENT 'Indicates whether the capital expenditure is mandated by regulatory, safety, or environmental compliance requirements (e.g., OSHA, EPA, CE Marking, RoHS/REACH). Mandatory compliance CAPEX requests receive expedited approval.. Valid values are `true|false`',
    `rejection_reason` STRING COMMENT 'Narrative explanation provided by the approving authority when a capital expenditure request is rejected or placed on hold. Captures the business rationale for non-approval to support resubmission and audit trail requirements.',
    `request_number` STRING COMMENT 'Human-readable business reference number for the CAPEX request, formatted as CAPEX-{YEAR}-{SEQUENCE}. Used in investment committee communications, approval workflows, and SAP PS project references.. Valid values are `^CAPEX-[0-9]{4}-[0-9]{6}$`',
    `request_type` STRING COMMENT 'Classification of the capital expenditure request by investment purpose. Determines applicable approval thresholds, depreciation treatment, and budget pool allocation. Aligns with SAP asset class and investment program categorization.. Valid values are `new_asset_acquisition|major_overhaul|capacity_expansion|replacement|technology_upgrade|regulatory_compliance|safety|environmental|research_and_development|infrastructure`',
    `requested_amount` DECIMAL(18,2) COMMENT 'Total capital expenditure amount requested by the business unit, expressed in the transaction currency. Represents the full estimated investment including equipment, installation, commissioning, and contingency.',
    `requested_by` STRING COMMENT 'Employee ID or user ID of the individual who submitted the capital expenditure request. Used for accountability tracking, approval routing, and audit trail in the CAPEX workflow.',
    `requesting_department` STRING COMMENT 'Name of the business department or organizational unit that initiated the capital expenditure request (e.g., Production Engineering, Maintenance, Facilities). Used for departmental CAPEX spend analysis.',
    `sap_project_number` STRING COMMENT 'SAP PS project definition number linked to this CAPEX request after approval. Enables integration between the CAPEX approval record and the capital project execution, cost tracking, and asset settlement in SAP.',
    `status` STRING COMMENT 'Current lifecycle status of the capital expenditure request, tracking progression from initial draft through approval workflow to execution and closure. Drives investment committee routing and SAP PS project activation.. Valid values are `draft|submitted|under_review|approved|conditionally_approved|rejected|on_hold|cancelled|in_execution|closed`',
    `submission_date` DATE COMMENT 'Date on which the capital expenditure request was formally submitted for review and approval. Marks the start of the approval workflow and is used for cycle time analysis and budget cycle deadline tracking.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `title` STRING COMMENT 'Short descriptive title of the capital expenditure request, summarizing the investment initiative (e.g., CNC Machine Line Expansion – Plant DE-01). Used in dashboards, approval emails, and investment committee agendas.',
    `wbs_element` STRING COMMENT 'SAP PS Work Breakdown Structure element code linked to the capital project for budget tracking, cost collection, and asset under construction (AuC) settlement. Enables granular project cost monitoring.',
    CONSTRAINT pk_capex_request PRIMARY KEY(`capex_request_id`)
) COMMENT 'Capital expenditure request records for new asset acquisitions, major overhauls, and capacity expansion projects. Captures project justification, estimated investment amount, expected ROI, payback period, asset category, approval workflow status, and budget allocation. Supports CAPEX planning cycles, investment committee approvals, and SAP PS (Project System) integration for capital project tracking.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` (
    `lifecycle_event_id` BIGINT COMMENT 'Unique surrogate identifier for each asset lifecycle event record in the Enterprise Asset Management (EAM) system. Serves as the primary key for the asset_lifecycle_event data product.',
    `asset_notification_id` BIGINT COMMENT 'Foreign key linking to asset.notification. Business justification: Lifecycle events may be initiated by notifications such as damage reports or change requests. Adding notification_id FK captures the initiating event and allows removal of denormalized notification nu',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Lifecycle events track equipment history including commissioning, transfers, and decommissioning. Adding equipment_id FK establishes the asset relationship and allows removal of denormalized asset_num',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Lifecycle events may involve location changes and transfers. Adding functional_location_id FK enables location tracking and allows removal of denormalized location code string.',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Lifecycle events may be triggered by work orders such as installation or decommissioning activities. Adding work_order_id FK links events to maintenance context and allows removal of denormalized work',
    `approved_by` STRING COMMENT 'Name or employee identifier of the person who formally approved the lifecycle event, particularly for decommissioning, disposal, major overhaul, and capitalization events requiring management authorization.',
    `approved_date` DATE COMMENT 'The date on which the lifecycle event was formally approved by the authorized approver. Required for financial events (capitalization, write-off) and regulatory compliance events.. Valid values are `^d{4}-d{2}-d{2}$`',
    `asset_configuration_change` STRING COMMENT 'Description of any technical or physical configuration change to the asset resulting from this lifecycle event (e.g., component replacement, software upgrade, capacity modification). Supports asset configuration management and PLM integration.',
    `asset_status_after` STRING COMMENT 'The operational status of the asset immediately following this lifecycle event. Together with asset_status_before, provides the complete status transition record required for EAM and regulatory audits.. Valid values are `active|inactive|under_maintenance|decommissioned|disposed|standby|in_transit|under_installation|scrapped`',
    `asset_status_before` STRING COMMENT 'The operational status of the asset immediately prior to this lifecycle event. Enables before/after status tracking for audit trails and asset history reconstruction.. Valid values are `active|inactive|under_maintenance|decommissioned|disposed|standby|in_transit|under_installation|scrapped`',
    `cost_center` STRING COMMENT 'The financial cost center to which the lifecycle event costs are allocated. Used for management accounting, budget control, and cost reporting in SAP CO.',
    `cost_classification` STRING COMMENT 'Financial classification of the lifecycle event cost as Capital Expenditure (CAPEX) or Operational Expenditure (OPEX). Critical for financial reporting, asset capitalization, and tax treatment under GAAP and IFRS.. Valid values are `capex|opex`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the location where the lifecycle event occurred. Supports multi-country regulatory compliance, reporting, and asset tracking for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the lifecycle event record was first created in the source system or data platform. Used for data lineage, audit trail, and Silver layer processing tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the event cost amount (e.g., USD, EUR, GBP). Supports multi-currency financial reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Free-text narrative description of the lifecycle event, capturing the specific actions taken, reasons for the event, and any relevant technical or operational context not captured in structured fields.',
    `disposal_method` STRING COMMENT 'Method used to dispose of the asset at end-of-life. Populated only for disposal and decommissioning events. Required for financial write-off processing, environmental compliance, and asset register closure.. Valid values are `sold|scrapped|recycled|donated|returned_to_vendor|transferred|written_off`',
    `disposal_value` DECIMAL(18,2) COMMENT 'Proceeds or residual value realized from the disposal of the asset (e.g., sale proceeds, scrap value). Used for gain/loss on disposal calculations in financial reporting under GAAP and IFRS.',
    `downtime_duration_minutes` STRING COMMENT 'Duration of asset downtime associated with this lifecycle event, measured in minutes. Used for Overall Equipment Effectiveness (OEE) calculations, Mean Time To Repair (MTTR) tracking, and production impact analysis.. Valid values are `^[0-9]+$`',
    `ecn_number` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) associated with this lifecycle event, particularly for modification and upgrade events. Links to Siemens Teamcenter PLM change management.',
    `environmental_impact_flag` BOOLEAN COMMENT 'Indicates whether this lifecycle event (particularly disposal or decommissioning) has environmental impact considerations requiring compliance with ISO 14001, EPA regulations, or RoHS/REACH directives for hazardous materials handling.. Valid values are `true|false`',
    `event_category` STRING COMMENT 'High-level grouping of the lifecycle event for reporting and analytics. Physical changes include installation and relocation; financial changes include capitalization and write-off; compliance events include certification renewals and regulatory inspections.. Valid values are `physical_change|financial_change|administrative_change|compliance_event|maintenance_event|safety_event`',
    `event_cost` DECIMAL(18,2) COMMENT 'Total cost incurred for executing the lifecycle event, including labor, materials, and external services. Used for CAPEX/OPEX classification, asset cost tracking, and financial reporting.',
    `event_date` DATE COMMENT 'The calendar date on which the lifecycle event occurred or was formally executed. Used for asset history chronology, regulatory audit trails, and depreciation calculations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `event_number` STRING COMMENT 'Business-facing unique identifier for the lifecycle event, used in EAM/CMMS systems and audit trails. Follows the enterprise event numbering convention (e.g., ALE-2024-000123).. Valid values are `^ALE-[0-9]{4}-[0-9]{6}$`',
    `event_status` STRING COMMENT 'Current processing status of the lifecycle event record. Indicates whether the event has been planned, is actively in progress, has been completed, or has been cancelled or rejected through the approval workflow.. Valid values are `planned|in_progress|completed|cancelled|pending_approval|rejected`',
    `event_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) when the lifecycle event was recorded or executed. Supports time-ordered event sequencing, IIoT integration, and regulatory audit log requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `event_type` STRING COMMENT 'Classification of the lifecycle event that occurred for the asset. Defines the nature of the change — e.g., commissioning marks the asset as operational, decommissioning removes it from service, relocation records a physical move, and major overhaul captures significant refurbishment activities.. Valid values are `commissioning|installation|relocation|modification|major_overhaul|decommissioning|disposal|reactivation|transfer|upgrade|inspection|certification_renewal|warranty_claim|capitalization|write_off`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the lifecycle event record. Used for incremental data loading, change data capture, and audit trail maintenance in the Databricks Lakehouse Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `planner_group` STRING COMMENT 'The maintenance planning group responsible for scheduling and coordinating the lifecycle event. Aligns with SAP PM planner group configuration for maintenance planning and scheduling.',
    `plant_code` STRING COMMENT 'SAP plant code or facility identifier where the asset is located at the time of the lifecycle event. Supports multi-site asset tracking and plant-level reporting.',
    `previous_functional_location_code` STRING COMMENT 'The functional location of the asset prior to a relocation or transfer event. Populated only for relocation, transfer, and installation events to provide a complete movement audit trail.',
    `production_impact` STRING COMMENT 'Assessment of the impact this lifecycle event has on production operations. Used for prioritization, OEE loss categorization, and production planning adjustments during asset downtime.. Valid values are `no_impact|minor|moderate|significant|critical`',
    `project_number` STRING COMMENT 'Reference to the capital project or engineering project associated with this lifecycle event, particularly for commissioning, major overhaul, or upgrade events. Links to SAP PS (Project System) or equivalent project management system.',
    `reason_code` STRING COMMENT 'Standardized code indicating the business or technical reason for the lifecycle event (e.g., end-of-life, regulatory requirement, capacity upgrade, damage, strategic relocation). Supports root cause analysis and asset lifecycle analytics.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this lifecycle event is driven by or subject to regulatory compliance requirements (e.g., mandatory inspection, certification renewal, environmental compliance). Triggers enhanced documentation and approval workflows.. Valid values are `true|false`',
    `regulatory_reference` STRING COMMENT 'Specific regulatory standard, directive, or requirement that mandates or governs this lifecycle event (e.g., ISO 9001 clause, OSHA standard number, EPA regulation, CE Marking directive). Required for compliance audit documentation.',
    `responsible_person` STRING COMMENT 'Name or employee identifier of the person responsible for executing or authorizing the lifecycle event (e.g., maintenance engineer, plant manager, reliability engineer). Supports accountability tracking and audit requirements.',
    `responsible_work_center` STRING COMMENT 'The maintenance work center or organizational unit responsible for executing the lifecycle event. Used for capacity planning, labor cost allocation, and maintenance performance reporting.',
    `safety_critical_flag` BOOLEAN COMMENT 'Indicates whether this lifecycle event involves a safety-critical asset or has safety implications requiring special handling, regulatory notification, or enhanced documentation under OSHA or ISO 45001.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'The operational system of record from which this lifecycle event record originated (e.g., SAP S/4HANA PM, Maximo EAM, Siemens MindSphere). Supports data lineage tracking and Silver layer reconciliation in the Databricks Lakehouse.. Valid values are `SAP_PM|Maximo_EAM|MindSphere|Opcenter_MES|Manual|Teamcenter_PLM`',
    CONSTRAINT pk_lifecycle_event PRIMARY KEY(`lifecycle_event_id`)
) COMMENT 'Chronological log of significant lifecycle events for manufacturing assets including commissioning, installation, relocation, modification, major overhaul, decommissioning, and disposal events. Each record captures event type, event date, responsible party, associated work order or project reference, and the resulting change in asset status or configuration. Provides the complete asset history trail required for EAM and regulatory audits.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`condition_assessment` (
    `condition_assessment_id` BIGINT COMMENT 'Unique system-generated identifier for each formal condition assessment record within the asset management domain.',
    `assessed_by_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Asset condition assessments must document which reliability engineer or inspector performed the evaluation for professional accountability and audit trails.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the qualified inspector who conducted the condition assessment, used for credential verification and accountability tracking.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Condition assessments evaluate equipment health and remaining useful life. Adding equipment_id FK establishes the asset relationship and allows removal of denormalized asset_number string.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Condition assessments can be location-based for area-level condition monitoring. Adding functional_location_id FK enables location-based assessment tracking and allows removal of denormalized location',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Condition assessments may be performed during work order execution as part of inspection activities. Adding work_order_id FK links assessments to maintenance context and allows removal of denormalized',
    `action_due_date` DATE COMMENT 'Target date by which the recommended maintenance action or intervention should be completed to prevent further asset degradation or failure.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Name or employee ID of the maintenance engineer or reliability manager who reviewed and approved the condition assessment findings and recommendations.',
    `approved_date` DATE COMMENT 'Date on which the condition assessment was formally reviewed and approved by the responsible maintenance engineer or reliability manager.. Valid values are `^d{4}-d{2}-d{2}$`',
    `assessment_category` STRING COMMENT 'Business category driving the assessment, distinguishing between routine preventive, predictive maintenance (PdM), regulatory compliance, insurance, capital investment planning, or RCM-driven assessments.. Valid values are `preventive|predictive|corrective|regulatory|insurance|capital_planning|rcm|baseline`',
    `assessment_date` DATE COMMENT 'Calendar date on which the formal condition assessment inspection was conducted on the asset.. Valid values are `^d{4}-d{2}-d{2}$`',
    `assessment_findings` STRING COMMENT 'Detailed narrative of all observations, defects, anomalies, and condition findings identified during the inspection, forming the evidentiary basis for the condition rating and recommendations.',
    `assessment_number` STRING COMMENT 'Human-readable business reference number for the condition assessment, used for cross-system referencing and communication with maintenance planners and engineers.. Valid values are `^CA-[0-9]{4}-[0-9]{6}$`',
    `assessment_type` STRING COMMENT 'Classification of the inspection methodology used to evaluate the asset condition, such as visual inspection, non-destructive testing (NDT), vibration analysis, thermographic imaging, or Reliability Centered Maintenance (RCM) survey.. Valid values are `visual_inspection|non_destructive_testing|vibration_analysis|thermographic|ultrasonic|oil_analysis|rcm_survey|predictive_maintenance_evaluation|first_article_inspection|regulatory_inspection|insurance_inspection`',
    `capex_flag` BOOLEAN COMMENT 'Indicates whether the recommended action requires capital expenditure (CAPEX) authorization, as opposed to operational expenditure (OPEX), for asset replacement or major refurbishment.. Valid values are `true|false`',
    `condition_score` DECIMAL(18,2) COMMENT 'Numeric condition score on a 0–100 scale representing the overall health of the asset, where 100 is as-new and 0 represents complete failure. Enables quantitative comparison and trending across assets.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility where the assessed asset is located, supporting multi-country regulatory compliance and reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the condition assessment record was first created in the system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated repair cost, supporting multi-currency reporting in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `electrical_condition_score` DECIMAL(18,2) COMMENT 'Numeric score (0–100) evaluating the condition of electrical components including wiring, insulation, contactors, drives, and control panels.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `end_of_life_date` DATE COMMENT 'Projected calendar date by which the asset is expected to reach end of serviceable life based on current condition, degradation rate, and remaining useful life estimate.. Valid values are `^d{4}-d{2}-d{2}$`',
    `environmental_risk_flag` BOOLEAN COMMENT 'Indicates whether the asset condition poses an environmental risk such as fluid leaks, emissions, or hazardous material exposure, requiring escalation per ISO 14001 and EPA regulations.. Valid values are `true|false`',
    `estimated_repair_cost` DECIMAL(18,2) COMMENT 'Estimated cost of the recommended maintenance action or repair in the local currency, used for CAPEX/OPEX budgeting and maintenance cost planning.',
    `failure_risk_level` STRING COMMENT 'Risk level of asset failure based on the combination of probability of failure and consequence of failure, used for risk-based maintenance (RBM) prioritization.. Valid values are `very_high|high|medium|low|negligible`',
    `iiot_data_used_flag` BOOLEAN COMMENT 'Indicates whether sensor data from the IIoT platform (Siemens MindSphere) was incorporated into the assessment, such as vibration trends, temperature profiles, or operating hour counters.. Valid values are `true|false`',
    `inspection_methodology` STRING COMMENT 'Detailed description of the specific inspection techniques, tools, and standards applied during the assessment, such as vibration spectrum analysis, dye penetrant testing, or infrared thermography.',
    `inspector_certification` STRING COMMENT 'Professional certification or qualification held by the inspector relevant to the assessment type, such as ISO Category II Vibration Analyst, Level II NDT Technician, or Certified Maintenance and Reliability Professional (CMRP).',
    `inspector_name` STRING COMMENT 'Full name of the inspector who performed the condition assessment. Retained for audit trail and regulatory compliance purposes.',
    `instrumentation_condition_score` DECIMAL(18,2) COMMENT 'Numeric score (0–100) evaluating the condition of instrumentation, sensors, PLCs, HMIs, and control systems associated with the asset.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the condition assessment record, supporting change tracking and data quality monitoring in the Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `maintenance_plan_number` STRING COMMENT 'Reference to the preventive maintenance plan that triggered this scheduled condition assessment, linking the assessment to the assets maintenance strategy.',
    `mechanical_condition_score` DECIMAL(18,2) COMMENT 'Numeric score (0–100) evaluating the condition of mechanical components such as bearings, gears, shafts, seals, and rotating parts.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `mindsphere_asset_reference` STRING COMMENT 'Identifier of the asset in the Siemens MindSphere IIoT platform whose sensor data and predictive analytics were referenced during this condition assessment.',
    `next_assessment_date` DATE COMMENT 'Recommended date for the next condition assessment based on current asset condition, risk level, and maintenance strategy interval.. Valid values are `^d{4}-d{2}-d{2}$`',
    `overall_condition_rating` STRING COMMENT 'Holistic condition rating assigned to the asset based on the assessment findings, used for risk-based maintenance prioritization and asset investment planning.. Valid values are `excellent|good|fair|poor|critical|failed`',
    `plant_code` STRING COMMENT 'Manufacturing plant or facility code where the asset under assessment is located, used for organizational reporting and maintenance planning.',
    `priority` STRING COMMENT 'Priority level assigned to the recommended action, used to sequence maintenance interventions and allocate resources in the maintenance planning process.. Valid values are `critical|high|medium|low`',
    `production_impact` STRING COMMENT 'Assessment of the current or potential impact of the asset condition on production output, throughput, and Overall Equipment Effectiveness (OEE).. Valid values are `no_impact|minor_degradation|significant_degradation|production_stoppage_risk|production_stopped`',
    `recommended_action` STRING COMMENT 'Primary maintenance or investment action recommended by the inspector based on assessment findings, used to drive work order creation, CAPEX requests, or decommissioning decisions.. Valid values are `continue_monitoring|schedule_maintenance|immediate_repair|component_replacement|asset_refurbishment|asset_replacement|decommission|further_investigation|no_action_required`',
    `recommended_action_detail` STRING COMMENT 'Free-text narrative providing detailed description of the recommended corrective or preventive action, including specific components, repair scope, or replacement specifications.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this assessment was conducted to satisfy a specific regulatory, statutory, or insurance inspection requirement, such as pressure vessel certification or CE marking compliance.. Valid values are `true|false`',
    `regulatory_reference` STRING COMMENT 'Specific regulatory standard, statutory requirement, or certification reference that mandated this inspection, such as OSHA 1910.217, PED 2014/68/EU, or ISO 45001 Clause 9.1.',
    `remaining_useful_life_years` DECIMAL(18,2) COMMENT 'Estimated remaining useful life of the asset in years as determined by the inspector or predictive model at the time of assessment. Critical input for capital expenditure (CAPEX) planning and asset replacement scheduling.. Valid values are `^d{1,4}(.d{1,2})?$`',
    `safety_risk_flag` BOOLEAN COMMENT 'Indicates whether the assessed asset condition presents a safety risk to personnel or the facility, triggering mandatory escalation per OSHA and ISO 45001 requirements.. Valid values are `true|false`',
    `status` STRING COMMENT 'Current workflow status of the condition assessment record, tracking its lifecycle from initial data capture through review, approval, and closure.. Valid values are `draft|in_progress|pending_review|approved|closed|cancelled`',
    `structural_condition_score` DECIMAL(18,2) COMMENT 'Numeric score (0–100) evaluating the structural integrity of the asset, including frame, housing, welds, and load-bearing components.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    CONSTRAINT pk_condition_assessment PRIMARY KEY(`condition_assessment_id`)
) COMMENT 'Structured condition assessment records resulting from formal asset inspections, RCM (Reliability Centered Maintenance) surveys, and predictive maintenance evaluations. Captures overall condition rating, individual component condition scores, remaining useful life estimate, recommended actions, inspection methodology, and inspector credentials. Supports asset investment planning and risk-based maintenance prioritization.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` (
    `iiot_asset_telemetry_id` BIGINT COMMENT 'Unique surrogate identifier for each IIoT asset telemetry record in the silver layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: IIoT telemetry streams from connected equipment via SCADA/MindSphere. Adding equipment_id FK establishes the asset relationship and allows removal of denormalized asset_number string.',
    `iiot_platform_id` BIGINT COMMENT 'Foreign key linking to technology.iiot_platform. Business justification: Asset telemetry data is collected and transmitted through specific IIoT platforms. Operations teams need to track which platform manages each telemetry stream for data quality and connectivity issues.',
    `measurement_point_id` BIGINT COMMENT 'Foreign key linking to asset.measurement_point. Business justification: Telemetry may be associated with specific measurement points on equipment. Adding measurement_point_id FK enables point-level telemetry tracking. The sensor_tag can be retrieved from measurement_point',
    `ot_system_id` BIGINT COMMENT 'Identifier of the SCADA or DCS system that is the originating source of this telemetry reading. Supports multi-SCADA environments and data lineage tracing back to the operational technology layer.',
    `sensor_measurement_point_id` BIGINT COMMENT 'Unique identifier of the physical or virtual sensor on the asset that generated this telemetry reading. Maps to the sensor registry in MindSphere or SCADA/DCS configuration.',
    `anomaly_detection_flag` BOOLEAN COMMENT 'Indicates whether the MindSphere predictive analytics engine or silver layer validation rules have flagged this telemetry reading as a statistical anomaly. True triggers investigation workflows and feeds predictive maintenance models.. Valid values are `true|false`',
    `anomaly_score` DECIMAL(18,2) COMMENT 'A normalized score between 0.0 and 1.0 representing the degree of anomaly detected in this telemetry reading by the predictive analytics model. Higher scores indicate greater deviation from normal operating patterns and higher maintenance urgency.. Valid values are `^(0(.d{1,4})?|1(.0{1,4})?)$`',
    `asset_operational_state` STRING COMMENT 'The operational state of the asset at the time of the telemetry reading as reported by the MES or SCADA system. Critical input for OEE availability calculation and production loss analysis.. Valid values are `running|idle|setup|maintenance|fault|shutdown|standby`',
    `breach_severity` STRING COMMENT 'Severity classification of the threshold breach for this telemetry reading. Drives prioritization of maintenance work orders and escalation routing in the CMMS/EAM system.. Valid values are `none|warning|alarm|critical`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility where the asset generating this telemetry is located. Supports multi-national regulatory compliance reporting and regional OEE benchmarking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp at which this telemetry record was created in the silver layer lakehouse table. Used for audit trail, data lineage, and incremental processing watermark management.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `cycle_count` BIGINT COMMENT 'The cumulative number of machine cycles completed by the asset as reported at the time of the telemetry reading. Used for condition-based maintenance triggering, OEE performance rate calculation, and remaining useful life estimation.',
    `edge_device_code` STRING COMMENT 'Identifier of the MindSphere edge computing device or gateway that collected and pre-processed this telemetry reading before transmission to the cloud platform. Used for edge device health monitoring and data provenance.',
    `event_timestamp` TIMESTAMP COMMENT 'The precise UTC timestamp at which the sensor reading was captured at the edge device or PLC. This is the source-of-truth event time used for time-series analysis, OEE calculation, and predictive maintenance models.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `functional_location_code` STRING COMMENT 'The SAP PM functional location code identifying the physical installation point of the asset within the plant hierarchy (e.g., line, cell, area). Used for spatial aggregation of telemetry in OEE and reliability dashboards.',
    `ingestion_timestamp` TIMESTAMP COMMENT 'The timestamp at which the telemetry record was received and ingested into the lakehouse silver layer from the MindSphere edge computing pipeline. Used to measure streaming latency and data freshness.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lower_alarm_limit` DECIMAL(18,2) COMMENT 'The critical lower threshold at which an alarm is triggered, indicating the asset has entered a fault or unsafe operating condition. Used to initiate automatic shutdown sequences or maintenance notifications.',
    `lower_warning_limit` DECIMAL(18,2) COMMENT 'The lower boundary threshold at which a warning alert is triggered for this sensor measurement. Crossing this limit indicates the asset is approaching an abnormal operating condition requiring attention.',
    `measurement_type` STRING COMMENT 'The physical or electrical quantity being measured by the sensor. Classifies the telemetry reading into a standard engineering measurement category for analytics routing and threshold evaluation.. Valid values are `vibration|temperature|pressure|current|voltage|speed|cycle_count|flow_rate|torque|humidity|power|displacement|acoustic_emission|oil_level|coolant_level`',
    `mindsphere_aspect_name` STRING COMMENT 'The MindSphere aspect (logical grouping of related sensor variables) to which this telemetry reading belongs. Aspects organize sensor data by functional domain (e.g., Vibration, Thermal, Electrical) for digital twin synchronization.',
    `mindsphere_asset_reference` STRING COMMENT 'The unique asset identifier assigned within the Siemens MindSphere IIoT platform, used to correlate telemetry streams with the digital asset registry and edge computing configuration.',
    `mindsphere_variable_name` STRING COMMENT 'The specific variable name within the MindSphere aspect that this telemetry reading represents. Provides the exact mapping between the raw sensor stream and the MindSphere digital twin data model.',
    `oee_loss_category` STRING COMMENT 'Classification of the OEE loss type associated with the asset state at the time of this telemetry reading. Enables automated OEE decomposition into availability, performance, and quality loss buckets per ISO 22400.. Valid values are `availability_loss|performance_loss|quality_loss|no_loss|unclassified`',
    `operating_hours_cumulative` DECIMAL(18,2) COMMENT 'The total cumulative operating hours logged by the asset from its commissioning date up to the event timestamp. Used as the primary counter for time-based preventive maintenance scheduling and MTBF calculation.',
    `plant_code` STRING COMMENT 'The SAP plant code identifying the manufacturing facility where the asset is installed. Supports multi-plant OEE benchmarking and regional compliance reporting.',
    `production_order_number` STRING COMMENT 'The SAP production order number active on the asset at the time of the telemetry reading. Enables correlation of equipment performance data with specific production runs for quality and yield analysis.',
    `reading_quality` STRING COMMENT 'OPC-UA quality code indicating the reliability of the sensor reading. Good indicates a valid measurement; uncertain or bad flags data quality issues for exclusion from predictive models and OEE calculations.. Valid values are `good|uncertain|bad|substituted|not_connected`',
    `reading_status` STRING COMMENT 'Processing status of the telemetry record within the silver layer pipeline. Indicates whether the reading has passed validation rules, been flagged as an anomaly, or been imputed due to sensor dropout.. Valid values are `raw|validated|anomaly_flagged|imputed|rejected`',
    `reading_value` DECIMAL(18,2) COMMENT 'The numeric value of the sensor measurement captured at the event timestamp. Precision of 6 decimal places supports high-resolution sensors such as vibration accelerometers and precision pressure transducers.',
    `sampling_interval_seconds` STRING COMMENT 'The configured sampling frequency in seconds at which this sensor was polled to generate the telemetry reading. Supports data density analysis and distinguishes high-frequency vibration data from low-frequency temperature readings.',
    `shift_identifier` STRING COMMENT 'The production shift identifier (e.g., Shift A, Shift B, Night Shift) during which the telemetry reading was captured. Enables shift-level OEE benchmarking and labor-correlated performance analysis.',
    `source_record_reference` STRING COMMENT 'The native record or message identifier from the originating source system (e.g., MindSphere time-series record ID, SCADA historian tag timestamp key). Enables deduplication and idempotent reprocessing in the lakehouse pipeline.',
    `source_system` STRING COMMENT 'The originating operational technology or IT system from which this telemetry record was sourced. Supports data lineage, audit trails, and multi-source reconciliation in the lakehouse silver layer.. Valid values are `mindsphere|scada|dcs|plc|opcenter_mes|manual`',
    `threshold_breach_flag` BOOLEAN COMMENT 'Indicates whether the reading value has breached any configured warning or alarm threshold at the time of capture. True triggers downstream alerting workflows and predictive maintenance scoring.. Valid values are `true|false`',
    `transmission_latency_ms` STRING COMMENT 'The elapsed time in milliseconds between the sensor event timestamp and the ingestion timestamp in the lakehouse. Used to monitor edge-to-cloud pipeline performance and identify data delivery SLA breaches.',
    `unit_of_measure` STRING COMMENT 'The engineering unit of the sensor reading value (e.g., °C, bar, A, RPM, mm/s², kW, Hz). Follows SI unit conventions to ensure interoperability across analytics and digital twin systems.',
    `upper_alarm_limit` DECIMAL(18,2) COMMENT 'The critical upper threshold at which an alarm is triggered, indicating the asset has entered a fault or unsafe operating condition. Used to initiate automatic shutdown sequences or maintenance notifications.',
    `upper_warning_limit` DECIMAL(18,2) COMMENT 'The upper boundary threshold at which a warning alert is triggered for this sensor measurement. Crossing this limit indicates the asset is approaching an abnormal operating condition requiring attention.',
    CONSTRAINT pk_iiot_asset_telemetry PRIMARY KEY(`iiot_asset_telemetry_id`)
) COMMENT 'High-frequency operational telemetry data streamed from IIoT-connected manufacturing equipment via Siemens MindSphere edge computing and SCADA/DCS systems. Captures real-time sensor readings including vibration, temperature, pressure, current draw, speed, and cycle counts per asset. Serves as the operational data foundation for predictive maintenance models, OEE calculation, and digital twin synchronization.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`predictive_alert` (
    `predictive_alert_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each predictive maintenance alert record in the silver layer lakehouse.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Predictive maintenance alerts require acknowledgment by maintenance personnel to track response times and ensure critical alerts are not ignored.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: Predictive maintenance alerts are generated by specific analytics applications (e.g., predictive maintenance software). Reliability engineers need to know which application generated each alert for va',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Predictive alerts are generated for equipment based on condition monitoring and predictive models. Adding equipment_id FK establishes the asset relationship and allows removal of denormalized asset_nu',
    `line_id` BIGINT COMMENT 'Foreign key linking to production.production_line. Business justification: Predictive maintenance alerts for line-level issues (not single equipment) enable production schedulers to proactively adjust schedules before failures occur, minimizing unplanned downtime impact on p',
    `measurement_point_id` BIGINT COMMENT 'Foreign key linking to asset.measurement_point. Business justification: Alerts are based on measurement point data and thresholds. Adding measurement_point_id FK links alerts to monitoring points and allows removal of denormalized point number string.',
    `request_id` BIGINT COMMENT 'Foreign key linking to service.service_request. Business justification: Predictive maintenance alerts can automatically generate service requests for customers with service contracts. Proactive service model where IoT alerts trigger customer notifications and service sche',
    `acknowledged_by` STRING COMMENT 'User ID or name of the maintenance planner, reliability engineer, or technician who acknowledged the alert in the EAM/CMMS system.',
    `acknowledged_timestamp` TIMESTAMP COMMENT 'Date and time when a maintenance planner or technician formally acknowledged the alert in the EAM/CMMS system, marking the start of the response workflow.',
    `action_priority` STRING COMMENT 'Operational priority classification for the recommended maintenance action, guiding maintenance planners on response urgency: immediate (stop and fix), urgent (within 24 hours), scheduled (next maintenance window), or monitor (watch and trend).. Valid values are `immediate|urgent|scheduled|monitor`',
    `actual_value` DECIMAL(18,2) COMMENT 'The actual sensor or measurement reading value at the time the alert was triggered, representing the observed condition of the asset parameter.',
    `alert_category` STRING COMMENT 'Physical or process domain category of the condition being monitored that produced the alert, enabling classification by failure mode domain for FMEA and reliability analysis.. Valid values are `vibration|temperature|pressure|current|voltage|flow|speed|lubrication|corrosion|wear|leakage|electrical|structural|process`',
    `alert_generated_timestamp` TIMESTAMP COMMENT 'Date and time when the predictive alert was first generated by the condition monitoring system or predictive model, in ISO 8601 format with timezone offset.',
    `alert_number` STRING COMMENT 'Human-readable business identifier for the predictive alert, used for cross-system referencing and communication with maintenance teams. Typically sourced from Siemens MindSphere or Maximo EAM.. Valid values are `^PA-[0-9]{4}-[0-9]{6}$`',
    `alert_type` STRING COMMENT 'Classification of the mechanism that generated the alert — whether triggered by a static threshold breach, statistical anomaly detection model, trend deviation analysis, pattern recognition algorithm, or predictive ML model output.. Valid values are `threshold_breach|anomaly_detection|trend_deviation|pattern_recognition|model_prediction|rule_based`',
    `confidence_score` DECIMAL(18,2) COMMENT 'Confidence percentage (0–100) assigned by the predictive model or anomaly detection algorithm indicating the reliability of the alert prediction. Higher scores indicate greater model certainty.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility where the alert-generating asset is located, supporting multinational regulatory compliance reporting and regional maintenance analytics.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the predictive alert record was created in the lakehouse silver layer, used for data lineage, audit trail, and SLA compliance tracking.',
    `deviation_percent` DECIMAL(18,2) COMMENT 'Percentage by which the actual measured value deviates from the configured threshold or baseline value, used to quantify the magnitude of the anomaly for prioritization.',
    `environmental_risk_flag` BOOLEAN COMMENT 'Indicates whether the predicted failure condition could result in an environmental incident (e.g., fluid leak, emissions exceedance), triggering EPA/ISO 14001 environmental management protocols.. Valid values are `true|false`',
    `false_positive_flag` BOOLEAN COMMENT 'Indicates whether the alert was determined to be a false positive after investigation, used for model performance feedback, retraining data labeling, and alert quality KPI reporting.. Valid values are `true|false`',
    `functional_location` STRING COMMENT 'Hierarchical plant structure code identifying the physical location of the asset that generated the alert, as defined in SAP S/4HANA PM functional location master.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the predictive alert record in the lakehouse silver layer, supporting change tracking and incremental data processing.',
    `model_name` STRING COMMENT 'Name or identifier of the predictive maintenance model, anomaly detection algorithm, or condition monitoring rule that generated the alert (e.g., bearing_vibration_lstm_v2, motor_current_threshold_rule).',
    `model_version` STRING COMMENT 'Version identifier of the predictive model or rule set that generated the alert, enabling traceability of alert quality to specific model iterations for model governance and retraining decisions.',
    `plant_code` STRING COMMENT 'SAP plant code or facility identifier where the asset generating the alert is physically located, supporting plant-level maintenance performance reporting and OEE impact analysis.',
    `predicted_failure_mode` STRING COMMENT 'The anticipated failure mode identified by the predictive model or condition monitoring rule, aligned with FMEA failure mode taxonomy (e.g., bearing fatigue, insulation breakdown, seal leakage).',
    `production_impact` STRING COMMENT 'Assessment of the potential production impact if the predicted failure occurs without intervention, used to prioritize alerts by business consequence and support OEE loss categorization.. Valid values are `none|minor|moderate|significant|critical`',
    `recommended_action` STRING COMMENT 'Prescribed maintenance or operational action recommended by the predictive model or condition monitoring rule to address the detected anomaly (e.g., lubricate bearing, inspect coupling, reduce load, schedule replacement).',
    `recurrence_count` STRING COMMENT 'Number of times this same alert condition (same asset, same parameter, same failure mode) has recurred within the current monitoring period, supporting chronic failure identification and CAPA escalation decisions.',
    `remaining_useful_life_days` STRING COMMENT 'Estimated number of days before the asset or component is predicted to reach a failure state, as computed by the prognostic model. Supports proactive maintenance scheduling and spare parts planning.',
    `resolved_timestamp` TIMESTAMP COMMENT 'Date and time when the alert condition was confirmed as resolved, either through completion of the recommended maintenance action or through validated return to normal operating parameters.',
    `safety_risk_flag` BOOLEAN COMMENT 'Indicates whether the predicted failure condition poses a potential occupational health and safety risk to personnel, triggering mandatory safety review and OSHA/ISO 45001 compliance protocols.. Valid values are `true|false`',
    `severity` STRING COMMENT 'Risk-based severity classification of the alert indicating urgency of response required. Critical indicates imminent failure risk; high requires same-day action; medium requires scheduled attention; low is advisory.. Valid values are `critical|high|medium|low|informational`',
    `source_system` STRING COMMENT 'Originating operational system that generated or published the predictive alert (e.g., Siemens MindSphere IIoT Platform, Maximo EAM, SAP PM, Opcenter MES, SCADA, PLC/DCS edge system).. Valid values are `MindSphere|Maximo|SAP_PM|Opcenter|SCADA|PLC|DCS|Manual`',
    `source_system_alert_reference` STRING COMMENT 'Native alert or event identifier from the originating source system (e.g., MindSphere event ID, SCADA alarm ID), enabling bidirectional traceability between the lakehouse silver layer and the operational system.',
    `status` STRING COMMENT 'Current disposition status of the predictive alert in its lifecycle workflow, from initial generation through acknowledgement, work order creation, resolution, and closure.. Valid values are `open|acknowledged|in_progress|work_order_created|resolved|closed|suppressed|false_positive`',
    `suppression_reason` STRING COMMENT 'Reason code explaining why an alert was suppressed or muted, such as during planned maintenance windows, known transient conditions, sensor calibration periods, or duplicate alert deduplication.. Valid values are `planned_maintenance|known_condition|sensor_fault|calibration|duplicate|operator_override|other`',
    `threshold_value` DECIMAL(18,2) COMMENT 'The configured threshold or limit value that was breached or approached by the actual measurement, as defined in the condition monitoring rule or predictive model configuration.',
    `triggering_parameter` STRING COMMENT 'Name or tag of the specific physical or process parameter (e.g., bearing temperature, vibration RMS, motor current) whose measured value caused the alert to be generated.',
    `unit_of_measure` STRING COMMENT 'Engineering unit of the triggering parameter measurement (e.g., °C, mm/s, bar, A, V, RPM), required for correct interpretation of actual and threshold values.',
    CONSTRAINT pk_predictive_alert PRIMARY KEY(`predictive_alert_id`)
) COMMENT 'Operational alert records generated by predictive maintenance models and condition monitoring rules when equipment telemetry or measurement readings breach defined thresholds or anomaly detection rules. Captures alert type, severity, triggering parameter, threshold value, actual value, recommended action, and alert disposition status. Bridges IIoT condition monitoring to the work order creation workflow.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`warranty` (
    `warranty_id` BIGINT COMMENT 'Unique surrogate identifier for each asset warranty record in the lakehouse silver layer.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Warranties are registered to customer accounts who purchased the equipment. Service and claims processing require knowing which customer holds the warranty.',
    `approved_manufacturer_id` BIGINT COMMENT 'Foreign key linking to engineering.approved_manufacturer. Business justification: Equipment warranties are tied to approved manufacturers from engineering. Procurement and maintenance teams verify warranty claims against engineerings approved manufacturer list for OEM parts and se',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Warranties cover specific equipment assets. Adding equipment_id FK establishes the asset relationship and allows removal of denormalized asset_number string.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Equipment warranties are provided by suppliers/OEMs. Asset teams track warranty coverage while procurement manages supplier relationships and warranty claim processes.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Warranty records must link to the original sales order for warranty start date, coverage terms, and customer entitlements. Service teams validate warranty claims against order history.',
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
    `serial_number` STRING COMMENT 'Manufacturer serial number of the equipment or component covered by this warranty. Required for OEM warranty validation and claim submission.',
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
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Service contracts are agreements with specific customer accounts for equipment maintenance. Billing, service scheduling, and contract management require this link daily.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Service contract costs (maintenance agreements, support contracts) are charged to specific cost centers for budget tracking and accrual management. Used for monthly expense allocation.',
    `it_vendor_id` BIGINT COMMENT 'Foreign key linking to technology.it_vendor. Business justification: Asset service contracts are often with IT/OT vendors who provide maintenance software, remote monitoring, or control system support. Procurement teams need this for vendor management and contract rene',
    `plan_id` BIGINT COMMENT 'Foreign key linking to billing.billing_plan. Business justification: Service contracts define billing schedules (monthly, quarterly, annual). The billing plan specifies when and how much to invoice customers for ongoing maintenance services throughout the contract peri',
    `procurement_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_contract. Business justification: Service contracts for asset maintenance originate from procurement contracts. Links commercial terms negotiated by procurement to operational service delivery tracked by asset management.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Maintenance service contracts are established with external suppliers/vendors. Procurement manages vendor relationships while asset teams execute service agreements for equipment maintenance.',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Service contracts for maintenance/support originate from won sales opportunities. Links contract to original equipment sale for revenue recognition, upsell tracking, and customer lifecycle management.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Service contracts are often sold with equipment orders. Service teams need to trace contracts back to original equipment sales for warranty validation and contract scope verification.',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` (
    `shutdown_plan_id` BIGINT COMMENT 'Unique system-generated identifier for the shutdown plan record in the enterprise asset management system.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Planned shutdowns affect functional locations and production areas. Adding functional_location_id FK enables location-based shutdown planning and coordination.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Plant shutdowns are major events requiring dedicated internal orders to collect all related costs (labor, contractors, materials) for total cost visibility and post-shutdown analysis.',
    `line_id` BIGINT COMMENT 'Foreign key linking to production.production_line. Business justification: Planned shutdowns for major maintenance must coordinate with production lines to schedule downtime. Production planning uses this to reschedule orders and manage customer commitments during maintenanc',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Plant shutdown plans must identify the maintenance planner responsible for coordination to ensure accountability for complex, high-stakes maintenance events.',
    `actual_cost` DECIMAL(18,2) COMMENT 'Total actual cost incurred during the shutdown event, used for budget variance analysis, CAPEX/OPEX reporting, and future shutdown cost estimation.',
    `actual_end_date` DATE COMMENT 'Actual calendar date on which the shutdown concluded and production was restored, used for duration variance analysis and SMED improvement tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_start_date` DATE COMMENT 'Actual calendar date on which the shutdown commenced, enabling variance analysis against the planned start date for schedule performance measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Name or employee ID of the authorized approver who formally approved the shutdown plan for execution, supporting audit trail and governance requirements.',
    `approved_date` DATE COMMENT 'Calendar date on which the shutdown plan received formal management approval, used for governance tracking and lead time analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `budget_code` STRING COMMENT 'Financial budget code or internal order number linking the shutdown plan to the approved annual maintenance or capital expenditure budget.',
    `capex_opex_classification` STRING COMMENT 'Financial classification of the shutdown spend as Capital Expenditure (CAPEX), Operational Expenditure (OPEX), or a mixed combination, required for correct accounting treatment under IFRS/GAAP.. Valid values are `capex|opex|mixed`',
    `contractor_required_flag` BOOLEAN COMMENT 'Indicates whether external contractor resources are required to execute the shutdown plan, triggering procurement and contractor management workflows.. Valid values are `true|false`',
    `cost_center` STRING COMMENT 'SAP cost center code to which the shutdown costs are allocated for management accounting and OPEX/CAPEX reporting purposes.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code identifying the country where the plant subject to the shutdown is located, supporting multinational regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `craft_types_required` STRING COMMENT 'Comma-separated list of maintenance craft types or trade disciplines required for the shutdown (e.g., mechanical, electrical, instrumentation, civil, scaffolding), supporting multi-craft coordination.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp recording when the shutdown plan record was first created in the system, used for audit trail and data governance compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `critical_path_description` STRING COMMENT 'Narrative description of the critical path activities and milestones that determine the minimum shutdown duration, used for schedule optimization and resource prioritization.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary values in this shutdown plan record, supporting multi-currency financial reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed narrative describing the scope, objectives, and rationale for the planned shutdown or turnaround event.',
    `estimated_cost` DECIMAL(18,2) COMMENT 'Total estimated cost of the shutdown event including labor, materials, contractor services, and overhead, used for CAPEX/OPEX budgeting and financial planning.',
    `estimated_labor_hours` DECIMAL(18,2) COMMENT 'Total estimated labor hours required across all crafts and trades to execute the shutdown plan, used for workforce scheduling and contractor resource planning.',
    `estimated_production_loss_hours` DECIMAL(18,2) COMMENT 'Estimated total production hours lost due to the planned shutdown, used for OEE (Overall Equipment Effectiveness) impact assessment and production scheduling adjustments.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp recording the most recent update to the shutdown plan record, supporting change tracking, audit compliance, and incremental data loading in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `name` STRING COMMENT 'Descriptive name of the shutdown plan event (e.g., Annual Turnaround 2025 - Plant A, Major Overhaul Q2 2025 - Line 3).',
    `permit_to_work_required_flag` BOOLEAN COMMENT 'Indicates whether a formal Permit to Work (PTW) system is required for activities within this shutdown plan, enforcing safety compliance for hazardous work.. Valid values are `true|false`',
    `plan_number` STRING COMMENT 'Business-facing alphanumeric identifier for the shutdown plan, used for cross-system referencing and communication with maintenance crews, planners, and management.. Valid values are `^SDP-[A-Z0-9]{4,20}$`',
    `planned_duration_days` DECIMAL(18,2) COMMENT 'Total planned duration of the shutdown event expressed in calendar days, used for production loss estimation, resource planning, and SMED (Single-Minute Exchange of Dies) optimization benchmarking.',
    `planned_end_date` DATE COMMENT 'Scheduled calendar date on which the shutdown is planned to conclude and production is expected to resume, used for production loss estimation and customer commitment planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_start_date` DATE COMMENT 'Scheduled calendar date on which the shutdown is planned to commence, used for production planning, resource scheduling, and supply chain coordination.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planner_group` STRING COMMENT 'SAP maintenance planner group code responsible for planning and coordinating the shutdown activities, used for workload distribution and accountability tracking.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or production site where the shutdown will be executed.',
    `priority` STRING COMMENT 'Business priority level assigned to the shutdown plan, used for resource allocation and scheduling conflict resolution across multiple concurrent shutdown events.. Valid values are `critical|high|medium|low`',
    `regulatory_authority` STRING COMMENT 'Name of the regulatory authority or certification body whose inspection or compliance requirement is driving or included in the shutdown (e.g., OSHA, EPA, TÜV, Lloyds Register).',
    `regulatory_inspection_flag` BOOLEAN COMMENT 'Indicates whether the shutdown includes mandatory regulatory inspection activities required by governing bodies such as OSHA, EPA, or certification authorities (UL, CE Marking).. Valid values are `true|false`',
    `revision_number` STRING COMMENT 'Version or revision number of the shutdown plan document, tracking changes to scope, schedule, or resources through the planning lifecycle.',
    `safety_isolation_plan_reference` STRING COMMENT 'Reference number or document identifier for the Lockout/Tagout (LOTO) and energy isolation plan associated with this shutdown, ensuring compliance with occupational safety requirements.',
    `scope_of_work` STRING COMMENT 'Detailed description of all maintenance, inspection, overhaul, and modification activities included in the shutdown plan scope, serving as the master reference for work order generation and contractor briefings.',
    `shutdown_coordinator` STRING COMMENT 'Name or employee ID of the designated shutdown coordinator or turnaround manager responsible for overall execution of the shutdown plan.',
    `shutdown_type` STRING COMMENT 'Classification of the shutdown event by its primary purpose: annual turnaround, major overhaul, regulatory inspection outage, planned preventive maintenance window, emergency shutdown, seasonal shutdown, or capital project tie-in.. Valid values are `annual_turnaround|major_overhaul|regulatory_inspection|planned_maintenance|emergency_shutdown|seasonal_shutdown|capital_project`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this shutdown plan record originated (e.g., SAP S/4HANA PM, Maximo EAM), supporting data lineage and integration traceability.. Valid values are `SAP_PM|Maximo|Opcenter|MindSphere|Manual`',
    `status` STRING COMMENT 'Current lifecycle status of the shutdown plan, tracking progression from initial drafting through approval, execution, and completion or cancellation.. Valid values are `draft|submitted|approved|in_progress|completed|cancelled|on_hold`',
    `total_work_orders` STRING COMMENT 'Total count of maintenance work orders planned and associated with this shutdown event, used for resource loading and execution progress tracking.',
    `wbs_element` STRING COMMENT 'SAP Work Breakdown Structure element code used to track and allocate shutdown costs within the project accounting framework, particularly for CAPEX-classified shutdown activities.',
    `work_center_codes` STRING COMMENT 'Comma-separated list of work center codes representing the production areas, lines, or departments included in the scope of the shutdown plan.',
    CONSTRAINT pk_shutdown_plan PRIMARY KEY(`shutdown_plan_id`)
) COMMENT 'Planned plant shutdown and turnaround event records capturing scheduled maintenance windows, scope of work, participating work centers, resource requirements, critical path milestones, and safety isolation plans. Covers annual shutdowns, major overhauls, and regulatory inspection outages. Enables coordinated multi-craft maintenance execution, minimizing unplanned production downtime and optimizing SMED changeover strategies.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`task_list` (
    `task_list_id` BIGINT COMMENT 'Unique surrogate identifier for the maintenance task list record in the lakehouse silver layer.',
    `class_id` BIGINT COMMENT 'Foreign key linking to asset.asset_class. Business justification: Task lists are templated by asset class for standardized maintenance procedures. Adding asset_class_id FK enables asset class-level task management and allows removal of denormalized asset_class_code ',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Task lists can be equipment-specific for unique or critical assets. Adding equipment_id FK enables equipment-level task customization beyond asset class templates.',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`asset_document` (
    `asset_document_id` BIGINT COMMENT 'Unique surrogate identifier for each asset document record in the EAM document repository. Serves as the primary key for the asset_document data product.',
    `cad_model_id` BIGINT COMMENT 'Foreign key linking to engineering.cad_model. Business justification: Asset documentation includes CAD models for equipment layout, piping diagrams, and facility modifications. Maintenance and engineering teams use 3D models for planning work, clearance verification, an',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Technical documents are linked to equipment including OEM manuals, P&IDs, and drawings. Adding equipment_id FK establishes the asset relationship and allows removal of denormalized asset_number string',
    `evidence_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_evidence. Business justification: Asset documents (test reports, certificates, inspection records) serve as compliance evidence for audits. Document controllers link asset documentation to compliance evidence repositories for regulato',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Documents can be location-specific such as area layouts and safety procedures. Adding functional_location_id FK enables location-based document management and allows removal of denormalized location s',
    `approved_by` STRING COMMENT 'Name or user ID of the authorized person who approved the document for release. Required by ISO 9001 document control requirements to ensure only reviewed and authorized documents are used in operations.',
    `approved_date` DATE COMMENT 'Date on which the document was formally approved by the authorized approver. Establishes the official approval timestamp for audit and compliance purposes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `author` STRING COMMENT 'Name or user ID of the person who originally authored or created the document. Provides accountability and is required for document control traceability under ISO 9001 documented information requirements.',
    `category` STRING COMMENT 'High-level grouping of the document for portfolio management and reporting. Distinguishes between technical engineering documents, regulatory compliance records, quality documents, safety documents, and maintenance procedures.. Valid values are `technical|regulatory_compliance|quality|safety|maintenance|engineering|commercial|environmental`',
    `certificate_number` STRING COMMENT 'Official certificate or approval number assigned by the issuing certification body or regulatory authority (e.g., UL file number, CE notified body certificate number, calibration certificate ID). Used for regulatory audit verification and traceability.',
    `certification_body` STRING COMMENT 'Name of the external certification authority, notified body, or inspection agency that issued or validated the document (e.g., UL, TÜV Rheinland, Bureau Veritas, SGS, DNV). Applicable for certificates, inspection reports, and regulatory approvals.',
    `change_notice_number` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that triggered the creation or revision of this document. Links document revisions to the formal engineering change management process in Teamcenter PLM.',
    `classification` STRING COMMENT 'Information security classification of the document content, governing access control and distribution. Aligns with the enterprise data classification framework. Restricted documents (e.g., proprietary schematics) require stricter access controls than internal procedures.. Valid values are `public|internal|confidential|restricted`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country for which this document is applicable or where the regulatory requirement originates. Supports multi-country compliance management (e.g., CE for EU, UL for USA).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the asset document record was first created in the lakehouse Silver layer. Supports data lineage, audit trail, and change tracking requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Free-text description providing additional context about the document content, scope, or applicability. Supplements the document title with details such as applicable equipment models, revision summary, or regulatory scope.',
    `drawing_number` STRING COMMENT 'Formal engineering drawing number assigned to technical drawings (P&ID, electrical schematics, assembly drawings, wiring diagrams). Follows the plant or enterprise drawing numbering standard and is used for cross-referencing in maintenance and engineering workflows.',
    `file_format` STRING COMMENT 'Electronic file format of the document (e.g., PDF for certificates and manuals, DWG/DXF for CAD drawings, TIFF for scanned documents). Determines rendering and archival requirements.. Valid values are `pdf|dwg|dxf|tiff|docx|xlsx|xml|step|iges|edrw|other`',
    `file_size_kb` STRING COMMENT 'Size of the document file in kilobytes. Used for storage management, archival planning, and document repository capacity monitoring.. Valid values are `^[0-9]+$`',
    `is_controlled` BOOLEAN COMMENT 'Indicates whether the document is subject to formal document control procedures (revision management, approval workflow, distribution control). Controlled documents require strict change management per ISO 9001 Section 7.5.. Valid values are `true|false`',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether this document is mandatory for the asset to be legally operated, commissioned, or maintained (e.g., CE declaration of conformity, pressure vessel inspection certificate). Mandatory documents trigger compliance alerts when expired or missing.. Valid values are `true|false`',
    `issue_date` DATE COMMENT 'Date on which the current revision of the document was officially issued or released for use. Used to determine document currency and to trigger review cycles.. Valid values are `^d{4}-d{2}-d{2}$`',
    `language_code` STRING COMMENT 'ISO 639-1 language code indicating the primary language of the document content (e.g., en, de, fr, zh). Essential for multinational operations where documents must be available in local languages for regulatory compliance and operator use.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the asset document record in the lakehouse Silver layer. Used for incremental data processing, change detection, and audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `linked_work_order_number` STRING COMMENT 'Reference to a maintenance work order number associated with this document (e.g., an inspection certificate generated as output of a work order, or a procedure attached to a specific work order). Supports traceability between maintenance execution and documentation.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of the document to ensure continued accuracy, relevance, and compliance. Supports document control workflows and prevents use of outdated procedures or specifications.. Valid values are `^d{4}-d{2}-d{2}$`',
    `number` STRING COMMENT 'Business-assigned unique document identifier used across EAM, PLM, and document management systems. Typically follows a structured numbering convention (e.g., DOC-PLANT-YYYY-NNNN) and is the primary cross-system reference key.. Valid values are `^[A-Z0-9-.]{3,50}$`',
    `oem_vendor_name` STRING COMMENT 'Name of the Original Equipment Manufacturer (OEM) or external vendor who supplied the document (e.g., equipment manual from Siemens, Fanuc, ABB). Relevant for OEM manuals, spare parts catalogs, and vendor-supplied technical documentation.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or site where the asset and its associated document are applicable. Supports multi-site document management and plant-level compliance reporting.. Valid values are `^[A-Z0-9]{2,10}$`',
    `regulatory_standard` STRING COMMENT 'Specific regulatory standard, directive, or norm that this document satisfies or references (e.g., ISO 9001:2015, IEC 62443-2-1, CE Directive 2006/42/EC, OSHA 29 CFR 1910, RoHS Directive 2011/65/EU, REACH Regulation EC 1907/2006). Critical for compliance audit trails.',
    `retention_period_years` STRING COMMENT 'Mandatory retention period in years for which the document must be preserved, as defined by regulatory requirements, legal obligations, or internal policy. Drives automated archival and deletion workflows. Regulatory documents (e.g., CE declarations) may require retention for the assets operational life plus additional years.. Valid values are `^[0-9]{1,3}$`',
    `revision_number` STRING COMMENT 'Current revision or version identifier of the document (e.g., A, B, Rev 3, 1.2). Critical for ensuring the correct version of technical drawings, procedures, and certificates is in use. Aligns with Engineering Change Notice (ECN) and Engineering Change Order (ECO) processes.. Valid values are `^[A-Z0-9.]{1,10}$`',
    `source_system` STRING COMMENT 'Identifies the originating system from which the document record was sourced. Enables traceability back to the authoritative system of record (e.g., Siemens Teamcenter PLM for engineering drawings, SharePoint for procedures, SAP PM for maintenance records).. Valid values are `teamcenter_plm|sharepoint|sap_pm|maximo_eam|opcenter_mes|mindsphere|external_vendor|paper_scan|other`',
    `source_system_document_reference` STRING COMMENT 'Native document identifier as assigned by the originating source system (e.g., Teamcenter PLM item ID, SharePoint document ID, SAP DMS document number). Enables bidirectional traceability and reconciliation between the lakehouse and the system of record.',
    `status` STRING COMMENT 'Current lifecycle status of the document within the document control workflow. Determines whether the document is active and usable (released/approved), under revision (draft/under_review), or no longer valid (superseded/obsolete/archived).. Valid values are `draft|under_review|approved|released|superseded|obsolete|archived|cancelled`',
    `storage_path` STRING COMMENT 'Logical or physical storage path or URL reference to the document file in the document management system or content repository (e.g., SharePoint URL, Teamcenter vault path, Azure Blob Storage URI). Enables direct document retrieval from the EAM interface.',
    `title` STRING COMMENT 'Full descriptive title of the document as it appears in the source system (e.g., Hydraulic Press P&ID Drawing Rev C, CE Declaration of Conformity - Conveyor Line 3). Used for search, display, and reporting.',
    `type` STRING COMMENT 'Classification of the document by its functional purpose within the asset lifecycle. Drives document handling rules, retention policies, and compliance workflows. Examples include OEM manuals, P&ID drawings, electrical schematics, CE declarations, and UL certificates.. Valid values are `oem_manual|pid_drawing|electrical_schematic|inspection_certificate|ce_declaration|ul_certificate|maintenance_procedure|calibration_certificate|safety_data_sheet|test_report|warranty_certificate|regulatory_approval|wiring_diagram|assembly_drawing|spare_parts_catalog|sop|ncr|fai_report|ppap_document|reach_rohs_declaration|other`',
    `valid_from_date` DATE COMMENT 'Start date from which the document is considered valid and applicable for operational use. Particularly important for regulatory certificates, calibration records, and compliance declarations that have defined validity windows.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Expiry or end date after which the document is no longer valid for operational use. Critical for time-bound documents such as inspection certificates, CE declarations, UL certifications, calibration certificates, and insurance documents. Drives automated renewal alerts.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_asset_document PRIMARY KEY(`asset_document_id`)
) COMMENT 'Technical document repository linking for manufacturing assets including OEM manuals, P&ID drawings, electrical schematics, inspection certificates, CE/UL certification documents, and regulatory compliance records. Captures document type, revision number, document source system reference (Teamcenter PLM or SharePoint), validity dates, and document classification. Provides the document management layer for the EAM asset master.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` (
    `equipment_contract_coverage_id` BIGINT COMMENT 'Unique surrogate identifier for each equipment-contract coverage record',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to the specific manufacturing equipment asset covered under this service contract',
    `service_contract_id` BIGINT COMMENT 'Foreign key linking to the vendor maintenance service contract providing coverage for this equipment',
    `contract_line_value` DECIMAL(18,2) COMMENT 'The allocated annual contract value attributable to this specific equipments coverage. Used for cost allocation and chargeback to cost centers. Sum of all equipment line values should reconcile to the contracts annual_value.',
    `coverage_end_date` DATE COMMENT 'The date on which coverage for this specific equipment under this contract expires or was terminated. May differ from the overall contract end_date if equipment was removed mid-contract.',
    `coverage_start_date` DATE COMMENT 'The date on which this specific equipment asset became covered under this service contract. May differ from the overall contract start_date if equipment was added mid-contract.',
    `covered_components_scope` STRING COMMENT 'Defines which components or subsystems of this equipment are covered under this contract (e.g., Full System, Electrical Only, Mechanical Excluding Wear Parts, Control System Only). Scope can vary by equipment even within the same contract.',
    `priority_response_flag` BOOLEAN COMMENT 'Indicates whether this equipment has been designated for priority or expedited response under this contract, typically for business-critical assets. Overrides standard SLA response times with faster guaranteed response.',
    `sla_tier` STRING COMMENT 'The service level agreement tier assigned to this specific equipment under this contract (e.g., Critical, Standard, Basic). Different equipment under the same contract may have different SLA tiers based on criticality and negotiated terms.',
    CONSTRAINT pk_equipment_contract_coverage PRIMARY KEY(`equipment_contract_coverage_id`)
) COMMENT 'This association product represents the contract coverage relationship between manufacturing equipment and vendor maintenance service contracts. It captures which specific equipment assets are covered under which service contracts, along with coverage-specific terms, SLA tiers, and scope definitions that exist only in the context of this equipment-contract pairing. Each record links one equipment asset to one service contract with attributes defining the specific coverage terms for that asset under that contract.. Existence Justification: In industrial manufacturing operations, vendor maintenance service contracts are typically negotiated to cover fleets or groups of equipment assets, not individual pieces of equipment. A single service contract commonly covers multiple equipment assets (e.g., All Siemens PLCs in Plant A, All CNC machines from Manufacturer X), and conversely, a single critical equipment asset may be covered by multiple overlapping service contracts (e.g., OEM warranty, extended maintenance contract, emergency response contract, remote monitoring service). The business actively manages equipment-contract coverage as a distinct operational entity, tracking which assets are covered under which contracts with specific coverage terms, SLA tiers, and scope definitions that vary by equipment even within the same contract.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` (
    `equipment_service_contract_id` BIGINT COMMENT 'Unique surrogate identifier for each equipment-supplier service contract relationship',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to the specific manufacturing equipment or plant asset covered by this service contract',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the service supplier or vendor providing maintenance, repair, or technical support services',
    `annual_contract_value` DECIMAL(18,2) COMMENT 'Annual financial value of the service contract for this supplier-equipment relationship, as identified in the detection phase relationship data',
    `contract_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the annual contract value',
    `contract_end_date` DATE COMMENT 'Expiration or termination date of the service contract between this supplier and this equipment, as identified in the detection phase relationship data',
    `contract_start_date` DATE COMMENT 'Effective start date of the service contract between this supplier and this equipment, as identified in the detection phase relationship data',
    `contract_status` STRING COMMENT 'Current lifecycle status of this service contract relationship',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this service contract relationship record was created',
    `is_primary_service_provider` BOOLEAN COMMENT 'Indicates whether this supplier is the primary or preferred service provider for this equipment among potentially multiple service suppliers',
    `response_time_hours` DECIMAL(18,2) COMMENT 'Contractually committed maximum response time in hours for this supplier to respond to service requests for this equipment, as identified in the detection phase relationship data',
    `service_level_agreement` STRING COMMENT 'Contractual SLA tier or service level commitment governing this suppliers service delivery for this equipment, as identified in the detection phase relationship data',
    `service_type` STRING COMMENT 'Classification of the type of service provided by this supplier for this equipment, as identified in the detection phase relationship data',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this service contract relationship record was last modified',
    CONSTRAINT pk_equipment_service_contract PRIMARY KEY(`equipment_service_contract_id`)
) COMMENT 'This association product represents the service contract relationship between manufacturing equipment and service suppliers. It captures the formal service agreements, maintenance contracts, and support arrangements that govern how suppliers provide maintenance, repair, calibration, and technical support services to specific equipment assets. Each record links one equipment asset to one service supplier with contract terms, SLA parameters, response commitments, and financial arrangements that exist only in the context of this specific service relationship.. Existence Justification: In industrial manufacturing operations, equipment assets routinely have multiple concurrent service suppliers serving different specialized roles (OEM for warranty service, third-party for preventive maintenance, calibration labs for metrology equipment, spare parts suppliers). Simultaneously, service suppliers maintain service contracts with many different equipment assets across the plant. This is an operational reality actively managed by maintenance planners and reliability engineers who track which suppliers service which equipment with specific SLA terms, response times, and contract periods.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` (
    `asset_supply_agreement_id` BIGINT COMMENT 'Primary key for asset_supply_agreement',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier providing the spare part under this supply agreement',
    `spare_part_id` BIGINT COMMENT 'Foreign key linking to the spare part being sourced under this supply agreement',
    `procurement_supply_agreement_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a specific supply agreement between a spare part and supplier',
    `agreement_end_date` DATE COMMENT 'Expiration or renewal date of the supply agreement. Null if open-ended. Used to trigger contract renegotiation workflows.',
    `agreement_start_date` DATE COMMENT 'Effective start date of the supply agreement or contract terms for this part-supplier combination',
    `last_purchase_date` DATE COMMENT 'Date of the most recent purchase order issued to this supplier for this spare part. Used to track active sourcing relationships and identify dormant supply agreements.',
    `lead_time_days` STRING COMMENT 'Number of calendar days from purchase order placement to goods receipt for this part from this supplier. Supplier-specific and critical for MRP planning and safety stock calculations.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum order quantity (MOQ) required by this supplier for this spare part. Drives procurement batch sizing and inventory planning.',
    `preferred_supplier_flag` BOOLEAN COMMENT 'Indicates whether this supplier is the preferred source for this spare part based on price, quality, delivery performance, and strategic relationship. Used to prioritize sourcing decisions in MRP and procurement workflows.',
    `preferred_vendor_number` STRING COMMENT 'SAP vendor account number of the preferred supplier for this spare part. Used to default sourcing in purchase requisitions and MRP-driven procurement. [Moved from spare_part: This attribute in spare_part currently stores a single preferred supplier, which contradicts the business reality that parts can be sourced from multiple suppliers with different preference levels. The preferred_supplier_flag in the supply_agreement association properly models that preference is a property of each part-supplier relationship, not a single global attribute of the part.]. Valid values are `^[A-Z0-9]{1,20}$`',
    `price_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the unit price (e.g., USD, EUR, CNY)',
    `quality_rating` DECIMAL(18,2) COMMENT 'Supplier quality performance rating for this specific spare part, typically on a scale of 0.00 to 5.00 or 0.00 to 100.00. Based on defect rates, returns, and quality audit results for deliveries of this part.',
    `status` STRING COMMENT 'Current lifecycle status of the supply agreement. Active agreements are available for procurement; Inactive/Expired agreements are historical.',
    `unit_price` DECIMAL(18,2) COMMENT 'Negotiated price per unit of measure for this spare part from this specific supplier. Varies by supplier for the same part based on volume commitments, contract terms, and supplier capabilities.',
    CONSTRAINT pk_asset_supply_agreement PRIMARY KEY(`asset_supply_agreement_id`)
) COMMENT 'This association product represents the contractual sourcing relationship between a spare part and a supplier. It captures supplier-specific pricing, lead times, order constraints, and quality metrics that exist only in the context of this specific part-supplier combination. Each record links one spare part to one supplier with commercial terms negotiated for that pairing.. Existence Justification: In industrial manufacturing MRO operations, spare parts are routinely sourced from multiple suppliers to ensure supply chain resilience, competitive pricing, and risk mitigation. Each part-supplier combination has distinct commercial terms including negotiated unit prices, supplier-specific lead times, minimum order quantities, and quality performance ratings. Procurement teams actively manage these supply agreements as operational entities, selecting suppliers based on urgency, cost, and availability for each replenishment order.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` (
    `equipment_allocation_id` BIGINT COMMENT 'Unique surrogate identifier for each equipment-to-project allocation record',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to the manufacturing equipment or plant asset being allocated to the R&D project',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to the R&D project receiving the equipment allocation',
    `allocated_by` STRING COMMENT 'Name or employee identifier of the resource manager or project manager who authorized this equipment allocation to the R&D project.',
    `allocation_date` DATE COMMENT 'Date on which this equipment allocation was formally recorded in the system. Used for audit trail and allocation history tracking.',
    `allocation_percentage` DECIMAL(18,2) COMMENT 'Percentage of equipment capacity or cost allocated to this specific R&D project. Used for proportional cost distribution when equipment is shared across multiple projects simultaneously.',
    `allocation_status` STRING COMMENT 'Current lifecycle status of the equipment allocation. Drives whether costs are actively being charged to the project.',
    `cost_allocation_rate` DECIMAL(18,2) COMMENT 'Hourly or periodic rate at which equipment costs (depreciation, maintenance, utilities) are charged to the R&D project. Used for accurate project costing and financial tracking.',
    `project_priority` STRING COMMENT 'Priority level of this specific equipment allocation within the context of the R&D project. Used for resource contention resolution when multiple projects compete for the same equipment.',
    `usage_end_date` DATE COMMENT 'Date on which the R&D project stopped using or released this equipment allocation. Defines the end of the cost allocation period. Null indicates ongoing allocation.',
    `usage_start_date` DATE COMMENT 'Date on which the R&D project began using or was allocated this equipment. Defines the start of the cost allocation period.',
    CONSTRAINT pk_equipment_allocation PRIMARY KEY(`equipment_allocation_id`)
) COMMENT 'This association product represents the allocation of manufacturing equipment to R&D projects. It captures the financial and operational assignment of shared equipment resources across the innovation portfolio. Each record links one equipment asset to one R&D project with allocation percentages, usage periods, and cost distribution rates that exist only in the context of this resource-sharing relationship.. Existence Justification: In industrial manufacturing R&D operations, equipment allocation is a formal business process where shared manufacturing equipment (test rigs, prototyping machines, lab equipment) is allocated across multiple concurrent R&D projects. Finance and resource managers actively track which equipment is used by which projects, with specific allocation percentages, time periods, and cost rates. This is an operational resource management and project costing activity, not an analytical correlation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` (
    `equipment_compliance_id` BIGINT COMMENT 'Unique surrogate identifier for each equipment-regulatory requirement compliance record',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to the manufacturing equipment or plant asset subject to regulatory compliance',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to the regulatory requirement, standard, or legal obligation that applies to this equipment',
    `assessment_method` STRING COMMENT 'Method used to assess compliance of this equipment with this requirement, reflecting the rigor and independence of the assessment process.',
    `compliance_status` STRING COMMENT 'Current compliance state of this equipment against this specific regulatory requirement. Drives compliance reporting, audit readiness, and remediation workflows.',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this equipment-requirement compliance record was first created in the system.',
    `evidence_reference` STRING COMMENT 'Reference to the compliance evidence, documentation, or audit report that substantiates the compliance status (e.g., document ID, file path, certificate number).',
    `exemption_expiry_date` DATE COMMENT 'Date on which the exemption expires and the equipment must either achieve compliance or obtain exemption renewal. Null if exemption is permanent or not applicable.',
    `exemption_flag` BOOLEAN COMMENT 'Indicates whether this equipment has been granted a formal exemption from this regulatory requirement due to technical, operational, or jurisdictional reasons. Exemptions must be documented and approved.',
    `exemption_reason` STRING COMMENT 'Free-text explanation of why this equipment is exempted from this regulatory requirement, including reference to approval authority and supporting documentation.',
    `last_assessment_date` DATE COMMENT 'Date of the most recent compliance assessment or audit performed for this equipment-requirement pair. Used to track assessment currency and trigger reassessments.',
    `last_updated_date` TIMESTAMP COMMENT 'Timestamp of the most recent update to this compliance record, reflecting changes in status, assessments, or responsible parties.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next compliance review or reassessment of this equipment against this requirement. Drives compliance calendar and proactive audit scheduling.',
    `non_compliance_severity` STRING COMMENT 'Severity level of non-compliance if status is NON_COMPLIANT, reflecting the risk exposure and urgency of remediation required.',
    `remediation_due_date` DATE COMMENT 'Target date by which non-compliance must be remediated to avoid regulatory penalties or operational restrictions. Null if compliant or not applicable.',
    `responsible_person` STRING COMMENT 'Name or identifier of the individual accountable for ensuring and demonstrating compliance of this equipment with this regulatory requirement. Typically a compliance officer, plant manager, or EHS coordinator.',
    CONSTRAINT pk_equipment_compliance PRIMARY KEY(`equipment_compliance_id`)
) COMMENT 'This association product represents the compliance relationship between manufacturing equipment and regulatory requirements. It captures the compliance status, assessment history, and accountability for each equipment-requirement pair. Each record links one equipment asset to one regulatory requirement with attributes that track compliance state, assessment dates, responsible parties, and exemption status.. Existence Justification: In industrial manufacturing operations, each piece of equipment must comply with multiple regulatory requirements (ISO 9001, ISO 14001, ISO 45001, OSHA, EPA, IEC 62443, etc.), and each regulatory requirement applies to multiple equipment assets across the plant. Compliance teams actively manage this many-to-many relationship by tracking compliance status, scheduling assessments, assigning responsible parties, and managing exemptions for each equipment-requirement pair. This is an operational compliance management process, not an analytical correlation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`control_implementation` (
    `control_implementation_id` BIGINT COMMENT 'Unique surrogate identifier for each equipment-control implementation record',
    `cybersecurity_control_id` BIGINT COMMENT 'Foreign key linking to the cybersecurity control being implemented on the equipment',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to the manufacturing equipment or OT asset on which the cybersecurity control is implemented',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this control implementation record was created',
    `effectiveness_rating` STRING COMMENT 'Assessment of how effectively the control is functioning on this specific equipment asset (effective, partially_effective, ineffective, not_tested). Explicitly identified in detection reasoning as control_effectiveness_rating.',
    `implementation_date` DATE COMMENT 'Date on which the cybersecurity control was deployed and activated on this equipment. Explicitly identified in detection reasoning.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this control implementation record was last updated',
    `next_verification_due_date` DATE COMMENT 'Scheduled date by which the next verification or assessment of this control implementation must be completed for this equipment',
    `remediation_notes` STRING COMMENT 'Free-text notes documenting remediation actions, exceptions, or technical details specific to this equipment-control implementation',
    `responsible_engineer` STRING COMMENT 'Name or identifier of the engineer or technician responsible for implementing and maintaining this control on this equipment. Explicitly identified in detection reasoning.',
    `status` STRING COMMENT 'Current lifecycle status of the control implementation on this specific equipment asset (planned, in_progress, implemented, verified, failed, deferred, not_applicable). Explicitly identified in detection reasoning as control_implementation_status.',
    `verification_date` DATE COMMENT 'Date on which the control implementation was formally verified or audited for this equipment. Explicitly identified in detection reasoning.',
    CONSTRAINT pk_control_implementation PRIMARY KEY(`control_implementation_id`)
) COMMENT 'This association product represents the implementation of cybersecurity controls on specific manufacturing equipment assets. It captures the operational deployment, verification, and effectiveness tracking of IEC 62443 and NIST CSF controls across PLCs, SCADA systems, DCS controllers, HMIs, and IIoT devices. Each record links one equipment asset to one cybersecurity control with implementation-specific attributes including deployment status, verification dates, effectiveness ratings, and responsible engineering ownership.. Existence Justification: In industrial manufacturing OT environments, a single piece of equipment (PLC, SCADA system, HMI) requires multiple cybersecurity controls to be implemented simultaneously (network segmentation, access control, patch management, encryption, incident response). Conversely, a single cybersecurity control (e.g., IEC 62443 network segmentation) must be implemented across hundreds or thousands of equipment assets across multiple plants. OT security teams actively manage the implementation lifecycle for each equipment-control combination, tracking deployment status, verification dates, effectiveness ratings, and responsible engineers.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`equipment_certification` (
    `equipment_certification_id` BIGINT COMMENT 'Primary key for the equipment_certification association',
    `engineering_regulatory_certification_id` BIGINT COMMENT 'Foreign key linking to the regulatory certification record (CE, UL, RoHS, REACH, etc.)',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to the manufacturing equipment or plant asset',
    `certificate_number` STRING COMMENT 'Specific certificate number applicable to this equipment-certification combination. May be a variant or addendum to the master certificate.',
    `certification_date` DATE COMMENT 'Date when this specific equipment received or was covered by this certification. May differ from the certificate issue_date if equipment was added to an existing certificate scope.',
    `certifying_body` STRING COMMENT 'Name of the accredited organization that certified this specific equipment under this certification standard.',
    `compliance_status` STRING COMMENT 'Current compliance status of this equipment for this specific certification. Drives operational decisions about equipment use in regulated markets.',
    `documentation_reference` STRING COMMENT 'Document management reference or storage path to the certification documentation specific to this equipment (test reports, declarations, technical files).',
    `expiry_date` DATE COMMENT 'Date when this certification expires for this specific equipment, driving recertification workflows and export compliance checks.',
    `last_audit_date` DATE COMMENT 'Date of the most recent compliance audit or inspection for this equipment under this certification.',
    `next_audit_date` DATE COMMENT 'Scheduled date for the next compliance audit or surveillance review for this equipment-certification combination.',
    `notes` STRING COMMENT 'Free-text notes about special conditions, limitations, or exceptions for this equipment-certification relationship.',
    `responsible_engineer` STRING COMMENT 'Name or employee ID of the engineer responsible for maintaining this certification for this specific equipment.',
    CONSTRAINT pk_equipment_certification PRIMARY KEY(`equipment_certification_id`)
) COMMENT 'This association product represents the certification compliance relationship between regulatory certifications and manufacturing equipment. It captures the specific certification status, validity dates, and compliance documentation for each equipment-certification combination. Each record links one regulatory certification to one equipment asset with attributes that exist only in the context of this compliance relationship, supporting regulatory audits and export documentation.. Existence Justification: In industrial manufacturing, equipment requires multiple regulatory certifications (CE Marking, UL, ATEX, RoHS, REACH, IEC) to operate in different markets and jurisdictions, and each certification standard applies to multiple equipment types across the plant. The business actively manages equipment-certification relationships as operational compliance records, tracking certification dates, expiry dates, compliance status, and audit schedules for each equipment-certification combination to support regulatory audits, export control, and market access decisions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` (
    `contract_risk_assessment_id` BIGINT COMMENT 'Unique system-generated identifier for each contract-risk assessment record',
    `service_contract_id` BIGINT COMMENT 'Foreign key linking to the vendor-side maintenance service contract being assessed for compliance risks',
    `third_party_risk_id` BIGINT COMMENT 'Foreign key linking to the specific third-party risk category being assessed in the context of this service contract',
    `assessment_status` STRING COMMENT 'Current status of the risk assessment workflow for this contract-risk combination (Pending, In Progress, Completed, Overdue, Closed)',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this contract-risk assessment record was initially created in the system',
    `last_updated_date` TIMESTAMP COMMENT 'Timestamp of the most recent update to this contract-risk assessment record',
    `mitigation_measures` STRING COMMENT 'Description of specific risk mitigation controls, contractual clauses, or operational measures implemented to address this risk for this contract. Explicitly identified in detection phase relationship data.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next review of this contract-risk assessment based on the review frequency',
    `review_frequency` STRING COMMENT 'Frequency at which this specific contract-risk assessment is reviewed and updated (Continuous, Monthly, Quarterly, Semi-Annual, Annual, Ad-Hoc). Explicitly identified in detection phase relationship data.',
    `risk_assessment_date` DATE COMMENT 'Date on which the compliance risk assessment was performed for this specific contract-risk combination. Explicitly identified in detection phase relationship data.',
    `risk_level` STRING COMMENT 'Assessed risk level for this specific third-party risk in the context of this service contract (Critical, High, Medium, Low, Negligible). Explicitly identified in detection phase relationship data.',
    `risk_owner` STRING COMMENT 'Name or identifier of the individual or team responsible for managing and monitoring this specific risk in the context of this service contract. Explicitly identified in detection phase relationship data.',
    CONSTRAINT pk_contract_risk_assessment PRIMARY KEY(`contract_risk_assessment_id`)
) COMMENT 'This association product represents the compliance risk assessment relationship between service contracts and identified third-party risks. It captures the ongoing risk evaluation, mitigation planning, and monitoring activities performed by compliance teams for each contract-risk combination. Each record links one service contract to one specific third-party risk exposure with assessment dates, risk levels, mitigation measures, review frequency, and ownership that exist only in the context of this specific contract-risk relationship.. Existence Justification: In industrial manufacturing operations, a single service contract with a third-party vendor (e.g., OEM maintenance provider) can expose the organization to multiple distinct compliance risk categories simultaneously (cybersecurity per IEC 62443, data privacy per GDPR Article 28, environmental compliance, labor standards, sanctions screening). Conversely, a single third-party risk category (e.g., cybersecurity risk) applies to multiple service contracts across different vendors and equipment types. Compliance teams actively manage these contract-risk assessments as distinct work products, tracking assessment dates, risk levels, mitigation measures, review schedules, and ownership for each contract-risk combination.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ADD CONSTRAINT `fk_asset_maintenance_item_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ADD CONSTRAINT `fk_asset_asset_notification_predictive_alert_id` FOREIGN KEY (`predictive_alert_id`) REFERENCES `manufacturing_ecm`.`asset`.`predictive_alert`(`predictive_alert_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ADD CONSTRAINT `fk_asset_measurement_reading_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ADD CONSTRAINT `fk_asset_measurement_reading_sensor_measurement_point_id` FOREIGN KEY (`sensor_measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ADD CONSTRAINT `fk_asset_failure_record_asset_notification_id` FOREIGN KEY (`asset_notification_id`) REFERENCES `manufacturing_ecm`.`asset`.`asset_notification`(`asset_notification_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ADD CONSTRAINT `fk_asset_lifecycle_event_asset_notification_id` FOREIGN KEY (`asset_notification_id`) REFERENCES `manufacturing_ecm`.`asset`.`asset_notification`(`asset_notification_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ADD CONSTRAINT `fk_asset_iiot_asset_telemetry_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ADD CONSTRAINT `fk_asset_iiot_asset_telemetry_sensor_measurement_point_id` FOREIGN KEY (`sensor_measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ADD CONSTRAINT `fk_asset_predictive_alert_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ADD CONSTRAINT `fk_asset_task_list_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` ADD CONSTRAINT `fk_asset_equipment_contract_coverage_service_contract_id` FOREIGN KEY (`service_contract_id`) REFERENCES `manufacturing_ecm`.`asset`.`service_contract`(`service_contract_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ADD CONSTRAINT `fk_asset_contract_risk_assessment_service_contract_id` FOREIGN KEY (`service_contract_id`) REFERENCES `manufacturing_ecm`.`asset`.`service_contract`(`service_contract_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`asset` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `manufacturing_ecm`.`asset` SET TAGS ('dbx_domain' = 'asset');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` SET TAGS ('dbx_original_name' = 'asset_class');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `class_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Class ID');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `parent_class_code` SET TAGS ('dbx_business_glossary_term' = 'Parent Asset Class Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ALTER COLUMN `parent_class_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `class_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `task_list_number` SET TAGS ('dbx_business_glossary_term' = 'Task List Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `task_list_type` SET TAGS ('dbx_business_glossary_term' = 'Task List Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ALTER COLUMN `task_list_type` SET TAGS ('dbx_value_regex' = 'general|equipment|functional_location|assembly');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `asset_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Notification ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `predictive_alert_id` SET TAGS ('dbx_business_glossary_term' = 'IIoT Alert ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reported By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ALTER COLUMN `request_id` SET TAGS ('dbx_business_glossary_term' = 'Service Request Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` SET TAGS ('dbx_subdomain' = 'performance_monitoring');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Ot System Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` SET TAGS ('dbx_subdomain' = 'performance_monitoring');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `measurement_reading_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Reading ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Recorded By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `sensor_measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Sensor ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` SET TAGS ('dbx_subdomain' = 'performance_monitoring');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_record_id` SET TAGS ('dbx_business_glossary_term' = 'Failure Record ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `asset_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Notification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `capa_record_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `ncr_id` SET TAGS ('dbx_business_glossary_term' = 'Ncr Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `pfmea_id` SET TAGS ('dbx_business_glossary_term' = 'Pfmea Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reported By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `actual_repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Repair Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `actual_repair_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `affected_production_quantity` SET TAGS ('dbx_business_glossary_term' = 'Affected Production Quantity');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `capa_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `capa_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Required Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `capa_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Failure Record Closed Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `damage_code` SET TAGS ('dbx_business_glossary_term' = 'Damage Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `detection_method` SET TAGS ('dbx_business_glossary_term' = 'Failure Detection Method');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `detection_method` SET TAGS ('dbx_value_regex' = 'operator_observation|condition_monitoring|predictive_alert|preventive_inspection|alarm_system|iiot_sensor|scada_alert|customer_report|automated_test|unknown');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `downtime_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Downtime Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `environmental_incident_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Incident Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `environmental_incident_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `estimated_repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Repair Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `estimated_repair_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failed_component` SET TAGS ('dbx_business_glossary_term' = 'Failed Component');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failed_component_part_number` SET TAGS ('dbx_business_glossary_term' = 'Failed Component Part Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_cause_code` SET TAGS ('dbx_business_glossary_term' = 'Failure Cause Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Failure Cause Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_class` SET TAGS ('dbx_business_glossary_term' = 'Failure Class');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_class` SET TAGS ('dbx_value_regex' = 'electrical|mechanical|hydraulic|pneumatic|instrumentation|structural|software|process|environmental|operator_error|unknown');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_code` SET TAGS ('dbx_business_glossary_term' = 'Failure Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_effect_code` SET TAGS ('dbx_business_glossary_term' = 'Failure Effect Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_effect_description` SET TAGS ('dbx_business_glossary_term' = 'Failure Effect Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Failure End Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_mode` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_number` SET TAGS ('dbx_business_glossary_term' = 'Failure Record Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_number` SET TAGS ('dbx_value_regex' = '^FR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Failure Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_status` SET TAGS ('dbx_business_glossary_term' = 'Failure Record Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `failure_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|resolved|closed|deferred|cancelled');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `functional_location` SET TAGS ('dbx_business_glossary_term' = 'Functional Location');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_value_regex' = 'corrective|emergency|predictive|condition_based|deferred_corrective');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `oee_loss_category` SET TAGS ('dbx_business_glossary_term' = 'Overall Equipment Effectiveness (OEE) Loss Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `oee_loss_category` SET TAGS ('dbx_value_regex' = 'unplanned_downtime|planned_downtime|speed_loss|quality_loss|minor_stoppage|startup_loss');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `production_impact` SET TAGS ('dbx_business_glossary_term' = 'Production Impact');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `production_impact` SET TAGS ('dbx_value_regex' = 'full_production_stop|partial_production_stop|degraded_performance|no_production_impact|quality_impact_only');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `recurrence_flag` SET TAGS ('dbx_business_glossary_term' = 'Failure Recurrence Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `recurrence_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `repair_type` SET TAGS ('dbx_business_glossary_term' = 'Repair Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `repair_type` SET TAGS ('dbx_value_regex' = 'replacement|repair_in_place|adjustment|cleaning|lubrication|calibration|software_reset|no_action_required|deferred');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `reported_by` SET TAGS ('dbx_business_glossary_term' = 'Reported By');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `reported_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Failure Reported Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `safety_incident_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Incident Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `safety_incident_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `severity_level` SET TAGS ('dbx_business_glossary_term' = 'Failure Severity Level');
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'critical|major|moderate|minor|negligible');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` SET TAGS ('dbx_subdomain' = 'performance_monitoring');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `reliability_record_id` SET TAGS ('dbx_business_glossary_term' = 'Reliability Record ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `asset_age_years` SET TAGS ('dbx_business_glossary_term' = 'Asset Age in Years');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `asset_age_years` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `asset_category` SET TAGS ('dbx_business_glossary_term' = 'Asset Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `asset_category` SET TAGS ('dbx_value_regex' = 'production_equipment|utility_system|material_handling|inspection_equipment|facility_infrastructure|it_ot_system|tooling|other');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `asset_criticality` SET TAGS ('dbx_business_glossary_term' = 'Asset Criticality Rating');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `asset_criticality` SET TAGS ('dbx_value_regex' = 'critical|major|general|minor');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `asset_name` SET TAGS ('dbx_business_glossary_term' = 'Asset Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `asset_number` SET TAGS ('dbx_business_glossary_term' = 'Asset Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `asset_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `availability_percentage` SET TAGS ('dbx_business_glossary_term' = 'Asset Availability Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `availability_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `availability_target_percentage` SET TAGS ('dbx_business_glossary_term' = 'Availability Target Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `availability_target_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `computed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Computed Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `computed_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `condition_monitoring_status` SET TAGS ('dbx_business_glossary_term' = 'Condition Monitoring Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `condition_monitoring_status` SET TAGS ('dbx_value_regex' = 'normal|advisory|warning|critical|sensor_fault|not_monitored');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `corrective_work_order_count` SET TAGS ('dbx_business_glossary_term' = 'Corrective Work Order Count');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `corrective_work_order_count` SET TAGS ('dbx_value_regex' = '^d+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Data Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `data_source_system` SET TAGS ('dbx_value_regex' = 'maximo_eam|sap_pm|opcenter_mes|mindsphere_iiot|manual|other');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `failure_count` SET TAGS ('dbx_business_glossary_term' = 'Failure Count');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `failure_count` SET TAGS ('dbx_value_regex' = '^d+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `failure_mode_primary` SET TAGS ('dbx_business_glossary_term' = 'Primary Failure Mode');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `failure_mode_primary` SET TAGS ('dbx_value_regex' = 'mechanical|electrical|hydraulic|pneumatic|software|instrumentation|structural|wear|corrosion|contamination|operator_error|unknown|other');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `last_failure_date` SET TAGS ('dbx_business_glossary_term' = 'Last Failure Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `last_failure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `last_preventive_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Preventive Maintenance Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `last_preventive_maintenance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `maintenance_cost_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Cost Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `maintenance_cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `maintenance_cost_local_currency` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Cost in Local Currency');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `maintenance_cost_local_currency` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `maintenance_cost_local_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `mean_time_between_failures_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (MTBF) in Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `mean_time_between_failures_hours` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `mean_time_to_repair_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (MTTR) in Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `mean_time_to_repair_hours` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `next_preventive_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Preventive Maintenance Due Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `next_preventive_maintenance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `oee_contribution_percentage` SET TAGS ('dbx_business_glossary_term' = 'Overall Equipment Effectiveness (OEE) Contribution Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `oee_contribution_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Period End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Period Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `planned_downtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Planned Downtime Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `planned_downtime_hours` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `predictive_maintenance_flag` SET TAGS ('dbx_business_glossary_term' = 'Predictive Maintenance Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `predictive_maintenance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `preventive_maintenance_compliance_percentage` SET TAGS ('dbx_business_glossary_term' = 'Preventive Maintenance (PM) Compliance Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `preventive_maintenance_compliance_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `preventive_work_order_count` SET TAGS ('dbx_business_glossary_term' = 'Preventive Work Order Count');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `preventive_work_order_count` SET TAGS ('dbx_value_regex' = '^d+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `record_status` SET TAGS ('dbx_business_glossary_term' = 'Reliability Record Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `record_status` SET TAGS ('dbx_value_regex' = 'active|superseded|under_review|invalidated');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `reliability_target_mtbf_hours` SET TAGS ('dbx_business_glossary_term' = 'Reliability Target Mean Time Between Failures (MTBF) in Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `reliability_target_mtbf_hours` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `remaining_useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Remaining Useful Life (RUL) in Years');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `remaining_useful_life_years` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `reporting_period_type` SET TAGS ('dbx_business_glossary_term' = 'Reporting Period Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `reporting_period_type` SET TAGS ('dbx_value_regex' = 'rolling_30_day|rolling_90_day|rolling_180_day|rolling_365_day|monthly|quarterly|annual|custom');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `scheduled_operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Operating Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `scheduled_operating_hours` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `total_operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Total Operating Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `total_operating_hours` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `tpm_program_code` SET TAGS ('dbx_business_glossary_term' = 'Total Productive Maintenance (TPM) Program Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `tpm_program_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `unplanned_downtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Unplanned Downtime Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `unplanned_downtime_hours` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ALTER COLUMN `work_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` SET TAGS ('dbx_original_name' = 'asset_bom');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `asset_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Bill of Materials (BOM) ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `alternative_part_number` SET TAGS ('dbx_business_glossary_term' = 'Alternative Part Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `change_notice_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `child_component_number` SET TAGS ('dbx_business_glossary_term' = 'Child Component Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `component_type` SET TAGS ('dbx_business_glossary_term' = 'Component Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `component_type` SET TAGS ('dbx_value_regex' = 'spare_part|sub_assembly|consumable|lubricant|tool|fastener|seal|bearing|electrical|pneumatic|hydraulic|software|documentation');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `criticality_rating` SET TAGS ('dbx_business_glossary_term' = 'Component Criticality Rating');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `criticality_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `drawing_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Drawing Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'BOM Line Effective From Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'BOM Line Effective To Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `estimated_unit_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Unit Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `estimated_unit_cost` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `estimated_unit_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'BOM Hierarchy Level');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `installation_position` SET TAGS ('dbx_business_glossary_term' = 'Installation Position');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `internal_part_number` SET TAGS ('dbx_business_glossary_term' = 'Internal Part Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `is_regulatory_controlled` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Controlled Component Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `is_regulatory_controlled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `is_safety_critical` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Component Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `is_safety_critical` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'BOM Item Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `item_category` SET TAGS ('dbx_value_regex' = 'stock_item|non_stock_item|document|text|class_item|configurable_item');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Component Procurement Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `manufacturer_name` SET TAGS ('dbx_business_glossary_term' = 'Component Manufacturer Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `manufacturer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Part Number (MPN)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `parent_component_number` SET TAGS ('dbx_business_glossary_term' = 'Parent Component Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `position_number` SET TAGS ('dbx_business_glossary_term' = 'BOM Position Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `position_number` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Component Quantity');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliant Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `recommended_stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Recommended Stock Quantity');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `recommended_stock_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `replacement_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Replacement Interval (Calendar Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `replacement_interval_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `replacement_interval_hours` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Replacement Interval (Operating Hours)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `replacement_interval_hours` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `revision` SET TAGS ('dbx_business_glossary_term' = 'BOM Revision');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `revision` SET TAGS ('dbx_value_regex' = '^[A-Z0-9.]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant Indicator');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'MAXIMO|SAP_PM|TEAMCENTER|OPCENTER|MANUAL');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `spare_part_class` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Classification');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `spare_part_class` SET TAGS ('dbx_value_regex' = 'insurance_spare|running_spare|consumable|capital_spare|rotable');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'BOM Line Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|obsolete|superseded|under_review|draft');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|M2|M3|SET|PAIR|BOX|ROLL|FT|IN|LB|GAL');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `usage` SET TAGS ('dbx_business_glossary_term' = 'BOM Usage');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `usage` SET TAGS ('dbx_value_regex' = 'maintenance|production|engineering|universal');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Component Weight (Kilograms)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ALTER COLUMN `weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `work_order_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Operation ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Performed By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `activity_type` SET TAGS ('dbx_business_glossary_term' = 'Activity Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `actual_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Operation Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `actual_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Actual Duration Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `actual_finish_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Finish Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `actual_labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Actual Labor Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `completion_confirmation_text` SET TAGS ('dbx_business_glossary_term' = 'Completion Confirmation Text');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `confirmation_number` SET TAGS ('dbx_business_glossary_term' = 'Confirmation Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `control_key` SET TAGS ('dbx_business_glossary_term' = 'Control Key');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `cost_element` SET TAGS ('dbx_business_glossary_term' = 'Cost Element');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `craft_type` SET TAGS ('dbx_business_glossary_term' = 'Craft Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `craft_type` SET TAGS ('dbx_value_regex' = 'mechanical|electrical|instrumentation|civil|welding|hvac|it_ot|general|contractor');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Operation Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `estimated_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `estimated_labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Labor Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `external_service_order_number` SET TAGS ('dbx_business_glossary_term' = 'External Service Order Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `is_milestone` SET TAGS ('dbx_business_glossary_term' = 'Milestone Operation Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `is_milestone` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `is_safety_critical` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Operation Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `is_safety_critical` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `number_of_technicians` SET TAGS ('dbx_business_glossary_term' = 'Number of Technicians');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `operation_long_text` SET TAGS ('dbx_business_glossary_term' = 'Operation Long Text');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `operation_number` SET TAGS ('dbx_business_glossary_term' = 'Operation Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `operation_number` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `operation_short_text` SET TAGS ('dbx_business_glossary_term' = 'Operation Short Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `operation_type` SET TAGS ('dbx_business_glossary_term' = 'Operation Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `operation_type` SET TAGS ('dbx_value_regex' = 'internal|external|inspection|calibration|lubrication|replacement|overhaul|cleaning|testing|adjustment');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `permit_to_work_number` SET TAGS ('dbx_business_glossary_term' = 'Permit to Work Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `permit_to_work_required` SET TAGS ('dbx_business_glossary_term' = 'Permit to Work Required Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `permit_to_work_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `qualification_code` SET TAGS ('dbx_business_glossary_term' = 'Qualification Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `remaining_labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Remaining Labor Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `scheduled_finish_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Finish Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `scheduled_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `standard_text_key` SET TAGS ('dbx_business_glossary_term' = 'Standard Text Key');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Operation Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'created|released|in_progress|partially_confirmed|confirmed|technically_completed|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `sub_operation_number` SET TAGS ('dbx_business_glossary_term' = 'Sub-Operation Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `system_status` SET TAGS ('dbx_business_glossary_term' = 'System Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `user_status` SET TAGS ('dbx_business_glossary_term' = 'User Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit to Work (PTW) ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `incident_id` SET TAGS ('dbx_business_glossary_term' = 'Incident Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Issued To Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Obligation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Permit Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `closed_by` SET TAGS ('dbx_business_glossary_term' = 'Permit Closed By');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `closed_by` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Permit Closed Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `closure_confirmation` SET TAGS ('dbx_business_glossary_term' = 'Permit Closure Confirmation Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `closure_confirmation` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `confined_space_class` SET TAGS ('dbx_business_glossary_term' = 'Confined Space Classification');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `confined_space_class` SET TAGS ('dbx_value_regex' = 'permit_required|non_permit_required|not_applicable');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Permit Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `electrical_voltage_level` SET TAGS ('dbx_business_glossary_term' = 'Electrical Voltage Level');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `electrical_voltage_level` SET TAGS ('dbx_value_regex' = 'low_voltage|medium_voltage|high_voltage|extra_high_voltage|not_applicable');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `fire_watch_required` SET TAGS ('dbx_business_glossary_term' = 'Fire Watch Required Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `fire_watch_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `gas_test_required` SET TAGS ('dbx_business_glossary_term' = 'Gas Test Required Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `gas_test_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `gas_test_result` SET TAGS ('dbx_business_glossary_term' = 'Gas Test Result');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `gas_test_result` SET TAGS ('dbx_value_regex' = 'pass|fail|not_required|pending');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `hot_work_type` SET TAGS ('dbx_business_glossary_term' = 'Hot Work Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `hot_work_type` SET TAGS ('dbx_value_regex' = 'welding|cutting|grinding|brazing|soldering|open_flame|not_applicable');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `incident_occurred` SET TAGS ('dbx_business_glossary_term' = 'Incident Occurred Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `incident_occurred` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `incident_report_number` SET TAGS ('dbx_business_glossary_term' = 'Incident Report Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `isolation_points` SET TAGS ('dbx_business_glossary_term' = 'Isolation Points Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `loto_procedure_number` SET TAGS ('dbx_business_glossary_term' = 'Lockout/Tagout (LOTO) Procedure Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `loto_required` SET TAGS ('dbx_business_glossary_term' = 'Lockout/Tagout (LOTO) Required Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `loto_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `number_of_workers` SET TAGS ('dbx_business_glossary_term' = 'Number of Workers Authorized');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `number_of_workers` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `performing_contractor` SET TAGS ('dbx_business_glossary_term' = 'Performing Contractor / Crew');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `permit_number` SET TAGS ('dbx_business_glossary_term' = 'Permit to Work (PTW) Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `permit_number` SET TAGS ('dbx_value_regex' = '^PTW-[A-Z]{2,6}-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `permit_type` SET TAGS ('dbx_business_glossary_term' = 'Permit Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `permit_type` SET TAGS ('dbx_value_regex' = 'hot_work|cold_work|confined_space_entry|electrical_isolation|lockout_tagout|working_at_height|excavation|radiation|chemical_handling|general');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `ppe_requirements` SET TAGS ('dbx_business_glossary_term' = 'Personal Protective Equipment (PPE) Requirements');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `regulatory_standard` SET TAGS ('dbx_business_glossary_term' = 'Applicable Regulatory Standard');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `renewal_count` SET TAGS ('dbx_business_glossary_term' = 'Permit Renewal Count');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `renewal_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `requested_by` SET TAGS ('dbx_business_glossary_term' = 'Requested By (Applicant)');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `requested_by` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `risk_assessment_number` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Reference Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `safety_precautions` SET TAGS ('dbx_business_glossary_term' = 'Safety Precautions');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Permit Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|active|suspended|cancelled|closed|expired');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'Permit Suspension Reason');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Permit Title');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `valid_from` SET TAGS ('dbx_business_glossary_term' = 'Permit Valid From (Start Date/Time)');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `valid_from` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `valid_to` SET TAGS ('dbx_business_glossary_term' = 'Permit Valid To (Expiry Date/Time)');
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ALTER COLUMN `valid_to` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` SET TAGS ('dbx_subdomain' = 'performance_monitoring');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `calibration_record_id` SET TAGS ('dbx_business_glossary_term' = 'Calibration Record ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Calibrated By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `product_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Specification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` SET TAGS ('dbx_subdomain' = 'financial_planning');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` SET TAGS ('dbx_original_name' = 'asset_valuation');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `asset_valuation_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Valuation ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `asset_register_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Register Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `asset_class_code` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Code');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` SET TAGS ('dbx_subdomain' = 'financial_planning');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `capex_request_id` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) Request ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `budget_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `class_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `order_quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `procurement_purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requested By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Project Completion Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `amount_in_group_currency` SET TAGS ('dbx_business_glossary_term' = 'CAPEX Amount in Group Currency');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `amount_in_group_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'CAPEX Approval Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `approved_amount` SET TAGS ('dbx_business_glossary_term' = 'Approved CAPEX Amount');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `approved_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By (Employee ID)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `budget_cycle` SET TAGS ('dbx_business_glossary_term' = 'CAPEX Budget Cycle');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `budget_cycle` SET TAGS ('dbx_value_regex' = 'annual_plan|mid_year_review|supplemental|rolling_forecast|emergency');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `current_approval_level` SET TAGS ('dbx_business_glossary_term' = 'Current Approval Level');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `current_approval_level` SET TAGS ('dbx_value_regex' = 'department_manager|plant_manager|regional_director|vp_operations|cfo|investment_committee|board');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'CAPEX Request Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `estimated_roi_percent` SET TAGS ('dbx_business_glossary_term' = 'Estimated Return on Investment (ROI) Percent');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `estimated_roi_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Group Reporting Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `internal_rate_of_return_percent` SET TAGS ('dbx_business_glossary_term' = 'Internal Rate of Return (IRR) Percent');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `internal_rate_of_return_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `investment_program_position` SET TAGS ('dbx_business_glossary_term' = 'Investment Program Position');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `justification_category` SET TAGS ('dbx_business_glossary_term' = 'Investment Justification Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `justification_category` SET TAGS ('dbx_value_regex' = 'cost_reduction|revenue_growth|capacity_increase|regulatory_mandatory|safety_mandatory|quality_improvement|maintenance_reliability|sustainability|digital_transformation|risk_mitigation');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `net_present_value` SET TAGS ('dbx_business_glossary_term' = 'Net Present Value (NPV)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `net_present_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `payback_period_months` SET TAGS ('dbx_business_glossary_term' = 'Payback Period (Months)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `planned_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Project Completion Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `planned_completion_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Project Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'CAPEX Request Priority');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `regulatory_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Required Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `regulatory_compliance_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'CAPEX Request Rejection Reason');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `request_number` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) Request Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `request_number` SET TAGS ('dbx_value_regex' = '^CAPEX-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `request_type` SET TAGS ('dbx_business_glossary_term' = 'CAPEX Request Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `request_type` SET TAGS ('dbx_value_regex' = 'new_asset_acquisition|major_overhaul|capacity_expansion|replacement|technology_upgrade|regulatory_compliance|safety|environmental|research_and_development|infrastructure');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `requested_amount` SET TAGS ('dbx_business_glossary_term' = 'Requested CAPEX Amount');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `requested_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `requested_by` SET TAGS ('dbx_business_glossary_term' = 'Requested By (Employee ID)');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `requesting_department` SET TAGS ('dbx_business_glossary_term' = 'Requesting Department');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `sap_project_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Project System (PS) Project Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'CAPEX Request Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|approved|conditionally_approved|rejected|on_hold|cancelled|in_execution|closed');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'CAPEX Request Submission Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `submission_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'CAPEX Request Title');
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` SET TAGS ('dbx_original_name' = 'asset_lifecycle_event');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `lifecycle_event_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Lifecycle Event ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `asset_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Notification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `asset_configuration_change` SET TAGS ('dbx_business_glossary_term' = 'Asset Configuration Change Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `asset_status_after` SET TAGS ('dbx_business_glossary_term' = 'Asset Status After Event');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `asset_status_after` SET TAGS ('dbx_value_regex' = 'active|inactive|under_maintenance|decommissioned|disposed|standby|in_transit|under_installation|scrapped');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `asset_status_before` SET TAGS ('dbx_business_glossary_term' = 'Asset Status Before Event');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `asset_status_before` SET TAGS ('dbx_value_regex' = 'active|inactive|under_maintenance|decommissioned|disposed|standby|in_transit|under_installation|scrapped');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `cost_classification` SET TAGS ('dbx_business_glossary_term' = 'Cost Classification (CAPEX/OPEX)');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `cost_classification` SET TAGS ('dbx_value_regex' = 'capex|opex');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Asset Lifecycle Event Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `disposal_method` SET TAGS ('dbx_business_glossary_term' = 'Asset Disposal Method');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `disposal_method` SET TAGS ('dbx_value_regex' = 'sold|scrapped|recycled|donated|returned_to_vendor|transferred|written_off');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `disposal_value` SET TAGS ('dbx_business_glossary_term' = 'Asset Disposal Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `disposal_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `downtime_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Asset Downtime Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `downtime_duration_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `ecn_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `environmental_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `environmental_impact_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_category` SET TAGS ('dbx_business_glossary_term' = 'Asset Lifecycle Event Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_category` SET TAGS ('dbx_value_regex' = 'physical_change|financial_change|administrative_change|compliance_event|maintenance_event|safety_event');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_cost` SET TAGS ('dbx_business_glossary_term' = 'Asset Lifecycle Event Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_date` SET TAGS ('dbx_business_glossary_term' = 'Asset Lifecycle Event Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_number` SET TAGS ('dbx_business_glossary_term' = 'Asset Lifecycle Event Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_number` SET TAGS ('dbx_value_regex' = '^ALE-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_status` SET TAGS ('dbx_business_glossary_term' = 'Asset Lifecycle Event Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|cancelled|pending_approval|rejected');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Asset Lifecycle Event Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Asset Lifecycle Event Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `event_type` SET TAGS ('dbx_value_regex' = 'commissioning|installation|relocation|modification|major_overhaul|decommissioning|disposal|reactivation|transfer|upgrade|inspection|certification_renewal|warranty_claim|capitalization|write_off');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `planner_group` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Planner Group');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `previous_functional_location_code` SET TAGS ('dbx_business_glossary_term' = 'Previous Functional Location Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `production_impact` SET TAGS ('dbx_business_glossary_term' = 'Production Impact Level');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `production_impact` SET TAGS ('dbx_value_regex' = 'no_impact|minor|moderate|significant|critical');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `project_number` SET TAGS ('dbx_business_glossary_term' = 'Project Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Asset Lifecycle Event Reason Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Event Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `responsible_person` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `responsible_work_center` SET TAGS ('dbx_business_glossary_term' = 'Responsible Work Center');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `safety_critical_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Event Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `safety_critical_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_PM|Maximo_EAM|MindSphere|Opcenter_MES|Manual|Teamcenter_PLM');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` SET TAGS ('dbx_subdomain' = 'performance_monitoring');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `condition_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Condition Assessment ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `assessed_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assessed By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Employee ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Recommended Action Due Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `action_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `assessment_category` SET TAGS ('dbx_business_glossary_term' = 'Assessment Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `assessment_category` SET TAGS ('dbx_value_regex' = 'preventive|predictive|corrective|regulatory|insurance|capital_planning|rcm|baseline');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `assessment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `assessment_findings` SET TAGS ('dbx_business_glossary_term' = 'Assessment Findings');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `assessment_number` SET TAGS ('dbx_business_glossary_term' = 'Condition Assessment Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `assessment_number` SET TAGS ('dbx_value_regex' = '^CA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `assessment_type` SET TAGS ('dbx_business_glossary_term' = 'Assessment Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `assessment_type` SET TAGS ('dbx_value_regex' = 'visual_inspection|non_destructive_testing|vibration_analysis|thermographic|ultrasonic|oil_analysis|rcm_survey|predictive_maintenance_evaluation|first_article_inspection|regulatory_inspection|insurance_inspection');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `capex_flag` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `capex_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `condition_score` SET TAGS ('dbx_business_glossary_term' = 'Condition Score');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `condition_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `electrical_condition_score` SET TAGS ('dbx_business_glossary_term' = 'Electrical Condition Score');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `electrical_condition_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `end_of_life_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated End of Life Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `end_of_life_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `environmental_risk_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Risk Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `environmental_risk_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `estimated_repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Repair Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `failure_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Failure Risk Level');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `failure_risk_level` SET TAGS ('dbx_value_regex' = 'very_high|high|medium|low|negligible');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `iiot_data_used_flag` SET TAGS ('dbx_business_glossary_term' = 'Industrial Internet of Things (IIoT) Data Used Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `iiot_data_used_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `inspection_methodology` SET TAGS ('dbx_business_glossary_term' = 'Inspection Methodology');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `inspector_certification` SET TAGS ('dbx_business_glossary_term' = 'Inspector Certification');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `inspector_name` SET TAGS ('dbx_business_glossary_term' = 'Inspector Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `inspector_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `instrumentation_condition_score` SET TAGS ('dbx_business_glossary_term' = 'Instrumentation and Controls Condition Score');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `instrumentation_condition_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `maintenance_plan_number` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `mechanical_condition_score` SET TAGS ('dbx_business_glossary_term' = 'Mechanical Condition Score');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `mechanical_condition_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `mindsphere_asset_reference` SET TAGS ('dbx_business_glossary_term' = 'MindSphere Asset ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `next_assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Assessment Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `next_assessment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `overall_condition_rating` SET TAGS ('dbx_business_glossary_term' = 'Overall Condition Rating');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `overall_condition_rating` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor|critical|failed');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Action Priority');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `production_impact` SET TAGS ('dbx_business_glossary_term' = 'Production Impact');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `production_impact` SET TAGS ('dbx_value_regex' = 'no_impact|minor_degradation|significant_degradation|production_stoppage_risk|production_stopped');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `recommended_action` SET TAGS ('dbx_business_glossary_term' = 'Recommended Action');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `recommended_action` SET TAGS ('dbx_value_regex' = 'continue_monitoring|schedule_maintenance|immediate_repair|component_replacement|asset_refurbishment|asset_replacement|decommission|further_investigation|no_action_required');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `recommended_action_detail` SET TAGS ('dbx_business_glossary_term' = 'Recommended Action Detail');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `remaining_useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Remaining Useful Life (RUL) in Years');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `remaining_useful_life_years` SET TAGS ('dbx_value_regex' = '^d{1,4}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `safety_risk_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Risk Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `safety_risk_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Assessment Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|in_progress|pending_review|approved|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `structural_condition_score` SET TAGS ('dbx_business_glossary_term' = 'Structural Condition Score');
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ALTER COLUMN `structural_condition_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` SET TAGS ('dbx_subdomain' = 'performance_monitoring');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `iiot_asset_telemetry_id` SET TAGS ('dbx_business_glossary_term' = 'Industrial Internet of Things (IIoT) Asset Telemetry ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `iiot_platform_id` SET TAGS ('dbx_business_glossary_term' = 'Iiot Platform Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Supervisory Control and Data Acquisition (SCADA) System ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `sensor_measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Sensor ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `anomaly_detection_flag` SET TAGS ('dbx_business_glossary_term' = 'Anomaly Detection Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `anomaly_detection_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `anomaly_score` SET TAGS ('dbx_business_glossary_term' = 'Anomaly Score');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `anomaly_score` SET TAGS ('dbx_value_regex' = '^(0(.d{1,4})?|1(.0{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `asset_operational_state` SET TAGS ('dbx_business_glossary_term' = 'Asset Operational State');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `asset_operational_state` SET TAGS ('dbx_value_regex' = 'running|idle|setup|maintenance|fault|shutdown|standby');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `breach_severity` SET TAGS ('dbx_business_glossary_term' = 'Threshold Breach Severity');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `breach_severity` SET TAGS ('dbx_value_regex' = 'none|warning|alarm|critical');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `cycle_count` SET TAGS ('dbx_business_glossary_term' = 'Machine Cycle Count');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `edge_device_code` SET TAGS ('dbx_business_glossary_term' = 'Edge Device ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Telemetry Event Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `functional_location_code` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `ingestion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Telemetry Ingestion Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `ingestion_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `lower_alarm_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Alarm Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `lower_warning_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Warning Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `measurement_type` SET TAGS ('dbx_business_glossary_term' = 'Measurement Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `measurement_type` SET TAGS ('dbx_value_regex' = 'vibration|temperature|pressure|current|voltage|speed|cycle_count|flow_rate|torque|humidity|power|displacement|acoustic_emission|oil_level|coolant_level');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `mindsphere_aspect_name` SET TAGS ('dbx_business_glossary_term' = 'MindSphere Aspect Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `mindsphere_asset_reference` SET TAGS ('dbx_business_glossary_term' = 'Siemens MindSphere Asset ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `mindsphere_variable_name` SET TAGS ('dbx_business_glossary_term' = 'MindSphere Variable Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `oee_loss_category` SET TAGS ('dbx_business_glossary_term' = 'Overall Equipment Effectiveness (OEE) Loss Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `oee_loss_category` SET TAGS ('dbx_value_regex' = 'availability_loss|performance_loss|quality_loss|no_loss|unclassified');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `operating_hours_cumulative` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Operating Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `production_order_number` SET TAGS ('dbx_business_glossary_term' = 'Production Order Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `reading_quality` SET TAGS ('dbx_business_glossary_term' = 'Reading Quality Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `reading_quality` SET TAGS ('dbx_value_regex' = 'good|uncertain|bad|substituted|not_connected');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `reading_status` SET TAGS ('dbx_business_glossary_term' = 'Reading Processing Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `reading_status` SET TAGS ('dbx_value_regex' = 'raw|validated|anomaly_flagged|imputed|rejected');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `reading_value` SET TAGS ('dbx_business_glossary_term' = 'Sensor Reading Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `sampling_interval_seconds` SET TAGS ('dbx_business_glossary_term' = 'Sampling Interval (Seconds)');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `shift_identifier` SET TAGS ('dbx_business_glossary_term' = 'Shift Identifier');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `source_record_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'mindsphere|scada|dcs|plc|opcenter_mes|manual');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `threshold_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Threshold Breach Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `threshold_breach_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `transmission_latency_ms` SET TAGS ('dbx_business_glossary_term' = 'Transmission Latency (Milliseconds)');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `upper_alarm_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Alarm Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ALTER COLUMN `upper_warning_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Warning Limit');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` SET TAGS ('dbx_subdomain' = 'performance_monitoring');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `predictive_alert_id` SET TAGS ('dbx_business_glossary_term' = 'Predictive Alert ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Acknowledged By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `request_id` SET TAGS ('dbx_business_glossary_term' = 'Service Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `acknowledged_by` SET TAGS ('dbx_business_glossary_term' = 'Acknowledged By');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `acknowledged_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Alert Acknowledged Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `action_priority` SET TAGS ('dbx_business_glossary_term' = 'Action Priority');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `action_priority` SET TAGS ('dbx_value_regex' = 'immediate|urgent|scheduled|monitor');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `actual_value` SET TAGS ('dbx_business_glossary_term' = 'Actual Measured Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `alert_category` SET TAGS ('dbx_business_glossary_term' = 'Alert Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `alert_category` SET TAGS ('dbx_value_regex' = 'vibration|temperature|pressure|current|voltage|flow|speed|lubrication|corrosion|wear|leakage|electrical|structural|process');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `alert_generated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Alert Generated Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `alert_number` SET TAGS ('dbx_business_glossary_term' = 'Alert Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `alert_number` SET TAGS ('dbx_value_regex' = '^PA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `alert_type` SET TAGS ('dbx_business_glossary_term' = 'Alert Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `alert_type` SET TAGS ('dbx_value_regex' = 'threshold_breach|anomaly_detection|trend_deviation|pattern_recognition|model_prediction|rule_based');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `confidence_score` SET TAGS ('dbx_business_glossary_term' = 'Model Confidence Score');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `confidence_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `deviation_percent` SET TAGS ('dbx_business_glossary_term' = 'Deviation Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `environmental_risk_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Risk Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `environmental_risk_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `false_positive_flag` SET TAGS ('dbx_business_glossary_term' = 'False Positive Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `false_positive_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `functional_location` SET TAGS ('dbx_business_glossary_term' = 'Functional Location');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `model_name` SET TAGS ('dbx_business_glossary_term' = 'Predictive Model Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `model_version` SET TAGS ('dbx_business_glossary_term' = 'Predictive Model Version');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `predicted_failure_mode` SET TAGS ('dbx_business_glossary_term' = 'Predicted Failure Mode');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `production_impact` SET TAGS ('dbx_business_glossary_term' = 'Production Impact');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `production_impact` SET TAGS ('dbx_value_regex' = 'none|minor|moderate|significant|critical');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `recommended_action` SET TAGS ('dbx_business_glossary_term' = 'Recommended Action');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `recurrence_count` SET TAGS ('dbx_business_glossary_term' = 'Alert Recurrence Count');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `remaining_useful_life_days` SET TAGS ('dbx_business_glossary_term' = 'Remaining Useful Life (RUL) Days');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `resolved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Alert Resolved Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `safety_risk_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Risk Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `safety_risk_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Alert Severity');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|informational');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'MindSphere|Maximo|SAP_PM|Opcenter|SCADA|PLC|DCS|Manual');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `source_system_alert_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System Alert ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Alert Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|acknowledged|in_progress|work_order_created|resolved|closed|suppressed|false_positive');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `suppression_reason` SET TAGS ('dbx_business_glossary_term' = 'Alert Suppression Reason');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `suppression_reason` SET TAGS ('dbx_value_regex' = 'planned_maintenance|known_condition|sensor_fault|calibration|duplicate|operator_override|other');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `threshold_value` SET TAGS ('dbx_business_glossary_term' = 'Threshold Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `triggering_parameter` SET TAGS ('dbx_business_glossary_term' = 'Triggering Parameter');
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` SET TAGS ('dbx_original_name' = 'asset_warranty');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `warranty_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Warranty ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `approved_manufacturer_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Manufacturer Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `it_vendor_id` SET TAGS ('dbx_business_glossary_term' = 'It Vendor Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `plan_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `procurement_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Plan ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Planned By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `actual_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Shutdown Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `actual_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_business_glossary_term' = 'Actual End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approved Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `budget_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `capex_opex_classification` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure / Operational Expenditure (CAPEX/OPEX) Classification');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `capex_opex_classification` SET TAGS ('dbx_value_regex' = 'capex|opex|mixed');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `contractor_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Contractor Required Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `contractor_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `craft_types_required` SET TAGS ('dbx_business_glossary_term' = 'Craft Types Required');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `critical_path_description` SET TAGS ('dbx_business_glossary_term' = 'Critical Path Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Plan Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Shutdown Cost');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `estimated_labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Labor Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `estimated_production_loss_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Production Loss (Hours)');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Plan Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `permit_to_work_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Permit to Work Required Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `permit_to_work_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Plan Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^SDP-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `planned_duration_days` SET TAGS ('dbx_business_glossary_term' = 'Planned Duration (Days)');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `planned_end_date` SET TAGS ('dbx_business_glossary_term' = 'Planned End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `planned_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `planner_group` SET TAGS ('dbx_business_glossary_term' = 'Planner Group');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Priority');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `regulatory_authority` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `regulatory_inspection_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Inspection Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `regulatory_inspection_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `safety_isolation_plan_reference` SET TAGS ('dbx_business_glossary_term' = 'Safety Isolation Plan Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `scope_of_work` SET TAGS ('dbx_business_glossary_term' = 'Scope of Work');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_coordinator` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Coordinator');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_type` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_type` SET TAGS ('dbx_value_regex' = 'annual_turnaround|major_overhaul|regulatory_inspection|planned_maintenance|emergency_shutdown|seasonal_shutdown|capital_project');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_PM|Maximo|Opcenter|MindSphere|Manual');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Plan Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|in_progress|completed|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `total_work_orders` SET TAGS ('dbx_business_glossary_term' = 'Total Work Orders');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ALTER COLUMN `work_center_codes` SET TAGS ('dbx_business_glossary_term' = 'Participating Work Center Codes');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `task_list_id` SET TAGS ('dbx_business_glossary_term' = 'Task List ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `class_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` SET TAGS ('dbx_original_name' = 'asset_document');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `asset_document_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Document ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `cad_model_id` SET TAGS ('dbx_business_glossary_term' = 'Cad Model Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `evidence_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evidence Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `author` SET TAGS ('dbx_business_glossary_term' = 'Document Author');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Document Category');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'technical|regulatory_compliance|quality|safety|maintenance|engineering|commercial|environmental');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `certification_body` SET TAGS ('dbx_business_glossary_term' = 'Certification Body');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `change_notice_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `classification` SET TAGS ('dbx_business_glossary_term' = 'Document Classification');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `classification` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|restricted');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Document Description');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `drawing_number` SET TAGS ('dbx_business_glossary_term' = 'Drawing Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `file_format` SET TAGS ('dbx_business_glossary_term' = 'File Format');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `file_format` SET TAGS ('dbx_value_regex' = 'pdf|dwg|dxf|tiff|docx|xlsx|xml|step|iges|edrw|other');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `file_size_kb` SET TAGS ('dbx_business_glossary_term' = 'File Size (Kilobytes)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `file_size_kb` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `is_controlled` SET TAGS ('dbx_business_glossary_term' = 'Controlled Document Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `is_controlled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Document Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Document Issue Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Document Language Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `linked_work_order_number` SET TAGS ('dbx_business_glossary_term' = 'Linked Work Order Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Document Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{3,50}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `oem_vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Original Equipment Manufacturer (OEM) Vendor Name');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `regulatory_standard` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Standard Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `retention_period_years` SET TAGS ('dbx_business_glossary_term' = 'Document Retention Period (Years)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `retention_period_years` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `revision_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9.]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'teamcenter_plm|sharepoint|sap_pm|maximo_eam|opcenter_mes|mindsphere|external_vendor|paper_scan|other');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `source_system_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System Document ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Document Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|approved|released|superseded|obsolete|archived|cancelled');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `storage_path` SET TAGS ('dbx_business_glossary_term' = 'Document Storage Path');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Document Title');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Document Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'oem_manual|pid_drawing|electrical_schematic|inspection_certificate|ce_declaration|ul_certificate|maintenance_procedure|calibration_certificate|safety_data_sheet|test_report|warranty_certificate|regulatory_approval|wiring_diagram|assembly_drawing|s...');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Document Valid From Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Document Valid To Date (Expiry Date)');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` SET TAGS ('dbx_association_edges' = 'asset.equipment,asset.service_contract');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` ALTER COLUMN `equipment_contract_coverage_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Contract Coverage ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Contract Coverage - Equipment Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` ALTER COLUMN `service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Contract Coverage - Service Contract Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` ALTER COLUMN `contract_line_value` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` ALTER COLUMN `coverage_end_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` ALTER COLUMN `coverage_start_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` ALTER COLUMN `covered_components_scope` SET TAGS ('dbx_business_glossary_term' = 'Covered Components Scope');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` ALTER COLUMN `priority_response_flag` SET TAGS ('dbx_business_glossary_term' = 'Priority Response Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'SLA Tier');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` SET TAGS ('dbx_association_edges' = 'asset.equipment,procurement.supplier');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `equipment_service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Service Contract ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Service Contract - Equipment Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Service Contract - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `annual_contract_value` SET TAGS ('dbx_business_glossary_term' = 'Annual Contract Value');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `contract_currency` SET TAGS ('dbx_business_glossary_term' = 'Contract Currency');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `contract_status` SET TAGS ('dbx_business_glossary_term' = 'Contract Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `is_primary_service_provider` SET TAGS ('dbx_business_glossary_term' = 'Is Primary Service Provider');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `response_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Response Time Hours');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `service_level_agreement` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` SET TAGS ('dbx_association_edges' = 'asset.spare_part,procurement.supplier');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `asset_supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'asset_supply_agreement Identifier');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement - Spare Part Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `procurement_supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `agreement_end_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `agreement_start_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `last_purchase_date` SET TAGS ('dbx_business_glossary_term' = 'Last Purchase Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Days');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `preferred_supplier_flag` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `preferred_vendor_number` SET TAGS ('dbx_business_glossary_term' = 'Preferred Vendor Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `preferred_vendor_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `price_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Price Currency Code');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `quality_rating` SET TAGS ('dbx_business_glossary_term' = 'Quality Rating');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ALTER COLUMN `unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` SET TAGS ('dbx_association_edges' = 'asset.equipment,research.rd_project');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ALTER COLUMN `equipment_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Allocation ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Allocation - Equipment Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Allocation - Rd Project Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ALTER COLUMN `allocated_by` SET TAGS ('dbx_business_glossary_term' = 'Allocated By');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ALTER COLUMN `allocation_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ALTER COLUMN `allocation_percentage` SET TAGS ('dbx_business_glossary_term' = 'Allocation Percentage');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ALTER COLUMN `cost_allocation_rate` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Rate');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ALTER COLUMN `project_priority` SET TAGS ('dbx_business_glossary_term' = 'Project Priority');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ALTER COLUMN `usage_end_date` SET TAGS ('dbx_business_glossary_term' = 'Usage End Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ALTER COLUMN `usage_start_date` SET TAGS ('dbx_business_glossary_term' = 'Usage Start Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` SET TAGS ('dbx_association_edges' = 'asset.equipment,compliance.regulatory_requirement');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `equipment_compliance_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Compliance Identifier');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Compliance - Equipment Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Compliance - Regulatory Requirement Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `assessment_method` SET TAGS ('dbx_business_glossary_term' = 'Assessment Method');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Created Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `evidence_reference` SET TAGS ('dbx_business_glossary_term' = 'Evidence Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `exemption_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Exemption Expiry Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `exemption_flag` SET TAGS ('dbx_business_glossary_term' = 'Exemption Flag');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `exemption_reason` SET TAGS ('dbx_business_glossary_term' = 'Exemption Reason');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `last_assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Assessment Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `last_updated_date` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `non_compliance_severity` SET TAGS ('dbx_business_glossary_term' = 'Non-Compliance Severity');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `remediation_due_date` SET TAGS ('dbx_business_glossary_term' = 'Remediation Due Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ALTER COLUMN `responsible_person` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` SET TAGS ('dbx_association_edges' = 'asset.equipment,compliance.cybersecurity_control');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `control_implementation_id` SET TAGS ('dbx_business_glossary_term' = 'Control Implementation ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `cybersecurity_control_id` SET TAGS ('dbx_business_glossary_term' = 'Control Implementation - Cybersecurity Control Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Control Implementation - Equipment Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `effectiveness_rating` SET TAGS ('dbx_business_glossary_term' = 'Control Effectiveness Rating');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `implementation_date` SET TAGS ('dbx_business_glossary_term' = 'Implementation Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `next_verification_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Verification Due Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `remediation_notes` SET TAGS ('dbx_business_glossary_term' = 'Remediation Notes');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `responsible_engineer` SET TAGS ('dbx_business_glossary_term' = 'Responsible Engineer');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Control Implementation Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Verification Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` SET TAGS ('dbx_association_edges' = 'engineering.regulatory_certification,asset.equipment');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `equipment_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Certification - Equipment Certification Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `engineering_regulatory_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Certification - Regulatory Certification Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Certification - Equipment Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Number');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `certification_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `certifying_body` SET TAGS ('dbx_business_glossary_term' = 'Certifying Body');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `documentation_reference` SET TAGS ('dbx_business_glossary_term' = 'Documentation Reference');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `next_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Next Audit Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Certification Notes');
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ALTER COLUMN `responsible_engineer` SET TAGS ('dbx_business_glossary_term' = 'Responsible Engineer');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` SET TAGS ('dbx_association_edges' = 'asset.service_contract,compliance.third_party_risk');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `contract_risk_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Risk Assessment ID');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Risk Assessment - Service Contract Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `third_party_risk_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Risk Assessment - Third Party Risk Id');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `assessment_status` SET TAGS ('dbx_business_glossary_term' = 'Assessment Status');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Created Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `last_updated_date` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `mitigation_measures` SET TAGS ('dbx_business_glossary_term' = 'Mitigation Measures');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `review_frequency` SET TAGS ('dbx_business_glossary_term' = 'Review Frequency');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `risk_assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Date');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level');
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ALTER COLUMN `risk_owner` SET TAGS ('dbx_business_glossary_term' = 'Risk Owner');
