-- Schema for Domain: asset | Business:  | Version: v2_ecm
-- Generated on: 2026-07-14 02:32:19

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`asset` COMMENT 'Manufacturing asset and equipment management including production machinery, tooling, dies, fixtures, and plant infrastructure. Manages asset registry, preventive and predictive maintenance schedules, equipment downtime tracking, and calibration management. Tracks asset utilization, MTBF (Mean Time Between Failures), MTTR (Mean Time To Repair), and maintenance costs. Includes spare parts inventory for maintenance and CMMS integration. Supports SAP PM module for enterprise asset management.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` (
    `equipment_registry_id` BIGINT COMMENT 'System-generated unique identifier for each equipment record.',
    `asset_class_id` BIGINT COMMENT 'Foreign key linking to asset.asset_class. Business justification: Classify each equipment record by linking to asset_class.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Needed for Cost Allocation Report linking each equipment to its cost center for depreciation and expense tracking, a standard automotive finance requirement.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Equipment belongs to a functional location; linking equipment_registry to functional_location eliminates duplicated location strings and enables hierarchy navigation.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Asset management records equipment supplier to manage warranty contracts, service agreements, and depreciation schedules.',
    `asset_condition` STRING COMMENT 'Current physical condition of the equipment as assessed during inspection.. Valid values are `new|good|fair|poor|critical`',
    `asset_tag` STRING COMMENT 'Company‑assigned tag or barcode used to uniquely identify the equipment on the shop floor.',
    `calibration_last_date` DATE COMMENT 'Date when the equipment was last calibrated.',
    `calibration_next_due` DATE COMMENT 'Scheduled date for the next required calibration.',
    `calibration_required_flag` BOOLEAN COMMENT 'Indicates whether the equipment requires periodic calibration.',
    `capital_expenditure_amount` DECIMAL(18,2) COMMENT 'Initial capital cost incurred to acquire the equipment.',
    `commissioning_date` DATE COMMENT 'Date the equipment became operational and entered service.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the equipment record was first created in the system.',
    `decommission_date` DATE COMMENT 'Date the equipment was retired or removed from service (nullable if still active).',
    `depreciation_end_date` DATE COMMENT 'Date depreciation calculations end (typically end of useful life).',
    `depreciation_method` STRING COMMENT 'Accounting method used to depreciate the equipment.. Valid values are `straight_line|declining_balance|units_of_production`',
    `depreciation_start_date` DATE COMMENT 'Date depreciation calculations begin for the equipment.',
    `equipment_registry_description` STRING COMMENT 'Detailed textual description of the equipments purpose and characteristics.',
    `energy_consumption_kwh` DECIMAL(18,2) COMMENT 'Average energy consumption of the equipment per operating hour.',
    `equipment_category` STRING COMMENT 'Operational category indicating the primary production area the equipment supports.. Valid values are `production|assembly|painting|testing|logistics|utility`',
    `equipment_registry_status` STRING COMMENT 'Current operational status of the equipment.. Valid values are `in_service|out_of_service|maintenance|retired|scrapped`',
    `equipment_type` STRING COMMENT 'Broad classification of equipment based on function or technology. [ENUM-REF-CANDIDATE: machinery|robot|agv|plc|scada|press|welding_station|paint_booth — 8 candidates stripped; promote to reference product]',
    `installation_date` DATE COMMENT 'Date the equipment was physically installed at the plant.',
    `last_maintenance_date` DATE COMMENT 'Date the most recent maintenance work was completed.',
    `lifecycle_phase` STRING COMMENT 'Stage of the equipments lifecycle within the enterprise.. Valid values are `design|manufacturing|operational|decommissioned`',
    `maintenance_interval_days` STRING COMMENT 'Planned number of days between routine maintenance activities.',
    `maintenance_strategy` STRING COMMENT 'Chosen maintenance approach for the equipment.. Valid values are `preventive|predictive|reactive`',
    `manufacturer` STRING COMMENT 'Name of the company that produced the equipment.',
    `model_number` STRING COMMENT 'Model identifier assigned by the equipment manufacturer.',
    `mtbf_hours` DECIMAL(18,2) COMMENT 'Average operating time between equipment failures.',
    `mttr_hours` DECIMAL(18,2) COMMENT 'Average time required to repair the equipment after a failure.',
    `equipment_registry_name` STRING COMMENT 'Human‑readable name of the equipment or asset.',
    `next_maintenance_date` DATE COMMENT 'Scheduled date for the upcoming maintenance activity.',
    `operating_cost_per_hour` DECIMAL(18,2) COMMENT 'Estimated cost to operate the equipment per hour, including energy and labor.',
    `power_rating_kw` DECIMAL(18,2) COMMENT 'Maximum electrical power rating of the equipment.',
    `regulatory_compliance_expiry` DATE COMMENT 'Date when the equipments current regulatory compliance certification expires.',
    `regulatory_compliance_status` STRING COMMENT 'Indicates whether the equipment meets applicable regulatory requirements.. Valid values are `compliant|non_compliant|pending`',
    `safety_certification_expiry` DATE COMMENT 'Expiration date of the equipments safety certification.',
    `safety_certification_status` STRING COMMENT 'Current status of safety certifications applicable to the equipment.. Valid values are `certified|expired|not_applicable`',
    `serial_number` STRING COMMENT 'Manufacturer‑provided serial number for the equipment.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the equipment record.',
    `warranty_end_date` DATE COMMENT 'Date when the equipment warranty period expires.',
    `warranty_start_date` DATE COMMENT 'Date when the equipment warranty period begins.',
    `warranty_status` STRING COMMENT 'Current state of the equipment warranty.. Valid values are `active|expired|pending`',
    `weight_kg` DECIMAL(18,2) COMMENT 'Physical weight of the equipment in kilograms.',
    CONSTRAINT pk_equipment_registry PRIMARY KEY(`equipment_registry_id`)
) COMMENT 'Master registry of all manufacturing assets and equipment across all plants, including production machinery, robots, AGVs, PLCs, SCADA systems, presses, welding stations, paint booths, and assembly line equipment. Serves as the SSOT for equipment identity, classification, location, and lifecycle status. Aligned with SAP PM Equipment Master (EQUI) and supports IATF 16949 asset traceability requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`functional_location` (
    `functional_location_id` BIGINT COMMENT 'Unique system-generated identifier for the functional location.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Supports Facility Cost Center reporting, enabling allocation of location‑based overhead and depreciation in financial statements.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Each functional location falls under a specific jurisdiction; linking supports location‑based regulatory reporting.',
    `parent_location_functional_location_id` BIGINT COMMENT 'Identifier of the immediate parent location in the hierarchy.',
    `address_line1` STRING COMMENT 'Primary street address of the functional location.',
    `address_line2` STRING COMMENT 'Secondary address information (suite, building, etc.).',
    `area_sqm` DOUBLE COMMENT 'Physical floor area occupied by the functional location.',
    `calibration_due_date` DATE COMMENT 'Date by which equipment calibration must be performed.',
    `capacity_units_per_hour` DOUBLE COMMENT 'Maximum production output capacity of the location, measured in units per hour.',
    `capital_cost` DECIMAL(18,2) COMMENT 'Initial capital expenditure required to acquire and install the location.',
    `city` STRING COMMENT 'City where the functional location is situated.',
    `functional_location_code` STRING COMMENT 'Business code used to identify the functional location in external systems.',
    `commissioning_date` DATE COMMENT 'Date the functional location became operational after installation.',
    `compliance_iso9001` BOOLEAN COMMENT 'Indicates whether the location complies with ISO 9001 quality standards.',
    `country_code` STRING COMMENT 'Three‑letter ISO country code where the location resides.',
    `decommission_date` DATE COMMENT 'Date the functional location was retired or taken out of service.',
    `depreciation_amount` DECIMAL(18,2) COMMENT 'Total amount allocated for depreciation over the assets useful life.',
    `depreciation_end_date` DATE COMMENT 'Date when the location is fully depreciated.',
    `depreciation_start_date` DATE COMMENT 'Date when depreciation of the locations capital cost begins.',
    `functional_location_description` STRING COMMENT 'Detailed textual description of the functional locations purpose and characteristics.',
    `functional_location_status` STRING COMMENT 'Current lifecycle status of the functional location.. Valid values are `active|inactive|maintenance|decommissioned|planned`',
    `functional_location_type` STRING COMMENT 'Category of the functional location within the plant hierarchy.. Valid values are `plant|shop|line|station|position|utility`',
    `hierarchy_level` STRING COMMENT 'Numeric depth of the location within the plant hierarchy (e.g., 1=Plant, 2=Shop).',
    `installation_date` DATE COMMENT 'Date the functional location was physically installed.',
    `is_critical` BOOLEAN COMMENT 'True if the location is deemed critical to production continuity.',
    `is_operational` BOOLEAN COMMENT 'True if the location is currently operational.',
    `last_maintenance_date` DATE COMMENT 'Most recent date on which maintenance was performed.',
    `latitude` DOUBLE COMMENT 'Geographic latitude of the functional location.',
    `longitude` DOUBLE COMMENT 'Geographic longitude of the functional location.',
    `maintenance_cost_yearly` DECIMAL(18,2) COMMENT 'Estimated yearly cost for maintaining the location.',
    `maintenance_interval_days` STRING COMMENT 'Standard interval between scheduled maintenance activities, expressed in days.',
    `maintenance_strategy` STRING COMMENT 'Approach used for maintaining the functional location.. Valid values are `preventive|predictive|run-to-failure`',
    `manufacturer` STRING COMMENT 'Name of the company that manufactured the equipment installed at the location.',
    `model_number` STRING COMMENT 'Model identifier assigned by the manufacturer.',
    `mtbf_days` DOUBLE COMMENT 'Average number of days between successive failures of equipment at this location.',
    `mttr_hours` DOUBLE COMMENT 'Average time required to repair equipment after a failure, expressed in hours.',
    `functional_location_name` STRING COMMENT 'Human‑readable name of the functional location.',
    `next_maintenance_date` DATE COMMENT 'Planned date for the next preventive or predictive maintenance activity.',
    `oee_overall_pct` DOUBLE COMMENT 'Combined availability, performance, and quality metric expressed as a percentage.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the functional location.',
    `responsible_department` STRING COMMENT 'Department that owns operational responsibility for the location.',
    `safety_certification_status` STRING COMMENT 'Current status of safety certifications for the location.. Valid values are `certified|pending|expired`',
    `serial_number` STRING COMMENT 'Unique serial number stamped on the equipment.',
    `state` STRING COMMENT 'State or province of the functional location.',
    CONSTRAINT pk_functional_location PRIMARY KEY(`functional_location_id`)
) COMMENT 'Hierarchical plant topology model representing the physical and functional structure of manufacturing facilities — plant, shop, line, station, and position levels. Each functional location is a named node in the plant hierarchy where equipment is installed and maintained. Directly maps to SAP PM Functional Location (IFLOT) and supports spatial asset management, maintenance planning, and OEE reporting by location.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` (
    `tooling_registry_id` BIGINT COMMENT 'System-generated unique identifier for each tooling record.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Foreign key linking to aftersales.aftersales_nameplate. Business justification: Links tooling to the specific vehicle program it supports; replaces the denormalized vehicle_program string for 3NF compliance.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Tooling procurement process requires linking each tooling asset to its supplier for warranty, cost, and compliance reporting.',
    `asset_tag` STRING COMMENT 'Internal asset tag used for inventory and tracking within the plant.',
    `calibration_date` DATE COMMENT 'Date the tool was last calibrated or verified for accuracy.',
    `calibration_due_date` DATE COMMENT 'Planned date for the next calibration activity.',
    `calibration_status` STRING COMMENT 'Current status of the tools calibration lifecycle.. Valid values are `calibrated|due|overdue`',
    `cost_usd` DECIMAL(18,2) COMMENT 'Capital cost of the tool in US dollars.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the tooling record was first created in the system.',
    `custodian_plant` STRING COMMENT 'Plant responsible for the tools custody and maintenance.',
    `tooling_registry_description` STRING COMMENT 'Detailed free‑text description of the tool, including purpose and key characteristics.',
    `dimensions_mm` STRING COMMENT 'Physical dimensions of the tool expressed as L×W×H in millimetres.',
    `last_maintenance_date` DATE COMMENT 'Date when the tool last underwent preventive or corrective maintenance.',
    `maintenance_schedule` STRING COMMENT 'Planned maintenance frequency for the tool.. Valid values are `daily|weekly|monthly|quarterly|annual|none`',
    `material` STRING COMMENT 'Primary material composition of the tool (e.g., H13 steel, aluminum).',
    `mtbf_hours` DECIMAL(18,2) COMMENT 'Average operational hours between tool failures, calculated from historical data.',
    `mttr_hours` DECIMAL(18,2) COMMENT 'Average time required to repair the tool after a failure.',
    `next_maintenance_date` DATE COMMENT 'Planned date for the next scheduled maintenance activity.',
    `plant_location` STRING COMMENT 'Identifier of the plant or facility where the tool is physically located.',
    `purchase_date` DATE COMMENT 'Date the tool was acquired by the organization.',
    `remaining_shots` STRING COMMENT 'Estimated remaining shots before tool replacement or refurbishment is required.',
    `serial_number` STRING COMMENT 'Manufacturer‑assigned serial number of the tool.',
    `shots_used` STRING COMMENT 'Cumulative number of shots the tool has performed to date.',
    `tool_code` STRING COMMENT 'Business identifier assigned to the tool, often used in shop‑floor systems and engineering drawings.',
    `tool_life_shots` STRING COMMENT 'Maximum number of shots/strokes the tool is engineered to perform.',
    `tool_name` STRING COMMENT 'Human‑readable name of the tooling item (e.g., "Engine Block Stamping Die").',
    `tool_type` STRING COMMENT 'Classification of the tooling item indicating its functional category.. Valid values are `stamping_die|injection_mold|welding_fixture|cmm_fixture|gauge|jig`',
    `tooling_registry_status` STRING COMMENT 'Current lifecycle status of the tool within the manufacturing environment.. Valid values are `active|inactive|retired|maintenance|decommissioned`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the tooling record.',
    `vehicle_model` STRING COMMENT 'Specific vehicle model or variant associated with the tooling.',
    `vendor_contract_number` STRING COMMENT 'Reference number of the contract under which the tool was purchased.',
    `vendor_name` STRING COMMENT 'Name of the external supplier that provided the tool.',
    `warranty_expiration_date` DATE COMMENT 'Date when the tools manufacturer warranty ends.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Weight of the tool in kilograms.',
    CONSTRAINT pk_tooling_registry PRIMARY KEY(`tooling_registry_id`)
) COMMENT 'Master registry of all production tooling, dies, molds, fixtures, gauges, and jigs used in manufacturing and assembly operations. Tracks tool identity, classification (stamping die, injection mold, welding fixture, CMM fixture), associated vehicle programs, tool life (shots/strokes remaining), and current custodian plant. Supports PPAP tooling documentation and die maintenance scheduling.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` (
    `maintenance_plan_id` BIGINT COMMENT 'Unique system-generated identifier for the maintenance plan.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: A maintenance plan is defined for specific equipment; adding equipment_registry_id to maintenance_plan creates the parent‑child link needed for plan assignment.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee or contractor responsible for the plan.',
    `maintenance_responsible_person_employee_id` BIGINT COMMENT 'Identifier of the employee or contractor responsible for the plan.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Plant‑level maintenance plans are created per manufacturing plant; required for the Plant Maintenance Planning KPI.',
    `maintenance_plan_category` STRING COMMENT 'High‑level classification of the plan (e.g., routine, major overhaul).. Valid values are `routine|major|overhaul|inspection`',
    `compliance_standard` STRING COMMENT 'Regulatory or quality standard that the maintenance plan must satisfy.. Valid values are `IATF16949|ISO9001|ISO14001|EPA|NHTSA`',
    `cost_estimate_amount` DECIMAL(18,2) COMMENT 'Monetary estimate of the total cost to execute the maintenance plan.',
    `cost_estimate_currency` STRING COMMENT 'Currency of the cost estimate for the maintenance plan.. Valid values are `USD|EUR|JPY|CNY|GBP|CAD`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the maintenance plan record was created.',
    `maintenance_plan_description` STRING COMMENT 'Detailed description of the maintenance plan purpose and scope.',
    `downtime_estimate_hours` DECIMAL(18,2) COMMENT 'Estimated duration of equipment downtime for the maintenance activity.',
    `effective_from` DATE COMMENT 'Official start date of the agreement portion of the maintenance plan.',
    `effective_until` DATE COMMENT 'Official end date of the agreement portion of the maintenance plan (nullable).',
    `end_date` DATE COMMENT 'Date when the maintenance plan expires or is retired (nullable).',
    `interval_unit` STRING COMMENT 'Unit of measure for the maintenance interval.. Valid values are `day|week|month|hour|kilometer|mile`',
    `interval_value` STRING COMMENT 'Numeric value of the maintenance interval.',
    `last_maintenance_date` DATE COMMENT 'Date when the most recent maintenance was performed under this plan.',
    `lead_time_days` STRING COMMENT 'Number of days required to prepare before the maintenance window.',
    `lifecycle_status` STRING COMMENT 'Lifecycle stage of the maintenance plan within the organization.. Valid values are `planned|in_service|retired|decommissioned`',
    `maintenance_plan_status` STRING COMMENT 'Current operational status of the maintenance plan.. Valid values are `active|inactive|suspended|draft|retired|pending`',
    `maintenance_type` STRING COMMENT 'Category of maintenance performed under the plan.. Valid values are `preventive|predictive|corrective`',
    `maintenance_window` STRING COMMENT 'Preferred time window for performing the maintenance.. Valid values are `night_shift|weekend|anytime`',
    `next_maintenance_date` DATE COMMENT 'Scheduled date for the next maintenance activity.',
    `notes` STRING COMMENT 'Free‑form notes or comments about the maintenance plan.',
    `parts_list_reference` STRING COMMENT 'Reference code or identifier for the parts list associated with the maintenance plan.',
    `parts_required_flag` BOOLEAN COMMENT 'Indicates whether spare parts are required for the maintenance task.',
    `plan_code` STRING COMMENT 'Business code used to reference the maintenance plan in SAP PM and other systems.. Valid values are `^MP-[A-Z0-9]{6}$`',
    `plan_name` STRING COMMENT 'Descriptive name of the maintenance plan.',
    `priority` STRING COMMENT 'Priority level assigned to the maintenance plan.. Valid values are `low|medium|high|critical`',
    `responsible_department` STRING COMMENT 'Department accountable for executing the maintenance plan.',
    `safety_risk_level` STRING COMMENT 'Risk classification for safety hazards associated with the maintenance activity.. Valid values are `low|moderate|high|critical`',
    `schedule_type` STRING COMMENT 'Method used to trigger maintenance (time, usage counter, or condition).. Valid values are `time_based|counter_based|condition_based`',
    `start_date` DATE COMMENT 'Date when the maintenance plan becomes effective.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the maintenance plan record.',
    CONSTRAINT pk_maintenance_plan PRIMARY KEY(`maintenance_plan_id`)
) COMMENT 'Preventive and predictive maintenance plan defining scheduled maintenance strategies for equipment and functional locations. Captures maintenance cycle (time-based, counter-based, condition-based), task list references, maintenance intervals, lead times, and scheduling parameters. Aligned with SAP PM Maintenance Plan (MPLAN) and supports IATF 16949 preventive maintenance program requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` (
    `maintenance_order_id` BIGINT COMMENT 'System-generated unique identifier for the maintenance order.',
    `employee_id` BIGINT COMMENT 'Identifier of the person who approved the maintenance order.',
    `approver_id` BIGINT COMMENT 'Identifier of the person who approved the maintenance order.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Maintenance orders often require regulatory approvals; attaching the relevant compliance document ensures traceability.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Allows linking maintenance orders to cost centers for accurate labor/material expense posting in the Maintenance Cost Ledger.',
    `functional_location_id` BIGINT COMMENT 'Identifier of the functional location where maintenance is performed.',
    `maintenance_employee_id` BIGINT COMMENT 'Identifier of the person or department that requested the maintenance work.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or asset being maintained.',
    `maintenance_equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or asset being maintained.',
    `maintenance_work_center_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_work_center. Business justification: Replace free‑text work_center with FK to maintenance_work_center for proper relational integrity.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Foreign key linking to aftersales.aftersales_nameplate. Business justification: Required for Maintenance Cost Allocation Report linking downtime costs to specific vehicle programs, a standard process in automotive manufacturing.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Service orders for customer‑owned vehicles require the owning party for billing, warranty tracking, and service history.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant where the maintenance is performed.',
    `primary_maintenance_employee_id` BIGINT COMMENT 'Identifier of the person or department that requested the maintenance work.',
    `actual_finish_timestamp` TIMESTAMP COMMENT 'Actual date and time when maintenance work was completed.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when maintenance work began.',
    `compliance_status` STRING COMMENT 'Regulatory compliance status of the maintenance activity.. Valid values are `compliant|non_compliant|exempt`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the maintenance order record was created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for monetary amounts.. Valid values are `^[A-Z]{3}$`',
    `maintenance_order_description` STRING COMMENT 'Detailed description of the maintenance task and scope.',
    `downtime_minutes` STRING COMMENT 'Total minutes the equipment was unavailable due to maintenance.',
    `external_service_provider` STRING COMMENT 'Name of third‑party service provider if external resources were used.',
    `is_emergency` BOOLEAN COMMENT 'True if the order was created as an emergency response.',
    `labor_cost_actual` DECIMAL(18,2) COMMENT 'Actual labor cost incurred.',
    `labor_cost_estimated` DECIMAL(18,2) COMMENT 'Planned labor cost based on estimated hours and rates.',
    `labor_hours_actual` DECIMAL(18,2) COMMENT 'Actual labor hours spent on the maintenance work.',
    `labor_hours_estimated` DECIMAL(18,2) COMMENT 'Planned labor hours required to complete the maintenance work.',
    `maintenance_order_status` STRING COMMENT 'Current lifecycle status of the maintenance order.. Valid values are `planned|released|in_progress|completed|closed|cancelled`',
    `maintenance_strategy` STRING COMMENT 'Strategy governing the maintenance order: run-based, time-based, or condition-based.. Valid values are `run_based|time_based|condition_based`',
    `material_cost_actual` DECIMAL(18,2) COMMENT 'Actual cost of materials consumed during maintenance.',
    `material_cost_estimated` DECIMAL(18,2) COMMENT 'Planned cost of materials required for the maintenance order.',
    `mttr_minutes` DECIMAL(18,2) COMMENT 'Average time taken to repair equipment, calculated from this order.',
    `notes` STRING COMMENT 'Free‑form notes entered by technicians.',
    `oem_part_number` STRING COMMENT 'Original Equipment Manufacturer part number for parts used.',
    `order_number` STRING COMMENT 'External business identifier assigned to the maintenance order.',
    `order_type` STRING COMMENT 'Classification of the maintenance work: corrective, preventive, or predictive.. Valid values are `corrective|preventive|predictive`',
    `parts_used` STRING COMMENT 'List of part numbers and quantities used, stored as free text or JSON string.',
    `planned_finish_date` DATE COMMENT 'Scheduled date for completion of maintenance work.',
    `planned_start_date` DATE COMMENT 'Scheduled date for the start of maintenance work.',
    `priority` STRING COMMENT 'Priority level indicating urgency of the maintenance work.. Valid values are `low|medium|high|critical`',
    `safety_flag` BOOLEAN COMMENT 'Indicates whether safety procedures were required for the maintenance work.',
    `total_cost` DECIMAL(18,2) COMMENT 'Sum of labor and material costs for the order.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the maintenance order record.',
    `warranty_claim_flag` BOOLEAN COMMENT 'Indicates whether the maintenance work is covered under warranty.',
    CONSTRAINT pk_maintenance_order PRIMARY KEY(`maintenance_order_id`)
) COMMENT 'Work order issued for corrective, preventive, or predictive maintenance activities on equipment or functional locations. Captures order type (PM01 corrective, PM02 preventive, PM03 predictive), priority, planned/actual start and finish times, assigned work center, estimated and actual labor hours, material costs, and completion status. Core transactional entity in SAP PM module. Drives MTTR calculation and maintenance cost tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` (
    `maintenance_notification_id` BIGINT COMMENT 'System-generated unique identifier for the maintenance notification record.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or asset to which the notification relates.',
    `employee_id` BIGINT COMMENT 'Identifier of the operator, technician, or system that raised the notification.',
    `maintenance_plan_id` BIGINT COMMENT 'Identifier of the maintenance plan governing this notification.',
    `maintenance_reported_by_employee_id` BIGINT COMMENT 'Identifier of the operator, technician, or system that raised the notification.',
    `activity_code` STRING COMMENT 'Code representing the maintenance activity to be performed.',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Real completion time when work finished.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Real start time when work began on the notification.',
    `asset_tag` STRING COMMENT 'Human‑readable tag or serial number of the asset.',
    `breakdown_indicator` BOOLEAN COMMENT 'True if the notification represents a complete equipment breakdown.',
    `cause_code` STRING COMMENT 'Standardized code describing the root cause of the malfunction.',
    `compliance_flag` BOOLEAN COMMENT 'True if the issue triggers regulatory or internal compliance actions.',
    `corrective_action` STRING COMMENT 'Planned or executed action to resolve the issue.',
    `cost_estimate` DECIMAL(18,2) COMMENT 'Projected monetary cost of the maintenance activity.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the notification record was first persisted in the lakehouse.',
    `currency_code` STRING COMMENT 'ISO 4217 currency code for the cost estimate.',
    `downtime_reason_code` STRING COMMENT 'Standard code explaining why production was halted.',
    `estimated_downtime_minutes` STRING COMMENT 'Projected duration of production loss in minutes.',
    `last_maintenance_date` DATE COMMENT 'Date of the most recent maintenance activity performed on the asset.',
    `location` STRING COMMENT 'Plant, line, or area where the asset is located.',
    `maintenance_category` STRING COMMENT 'Broad classification such as preventive, corrective, predictive.',
    `maintenance_group` STRING COMMENT 'Organizational group responsible for the maintenance activity.',
    `maintenance_notification_status` STRING COMMENT 'Current lifecycle state of the notification.. Valid values are `new|in_progress|resolved|closed|cancelled`',
    `mtbf_hours` DECIMAL(18,2) COMMENT 'Historical average time between failures for the asset.',
    `mttr_hours` DECIMAL(18,2) COMMENT 'Average time required to repair the asset after a failure.',
    `next_scheduled_maintenance_date` DATE COMMENT 'Planned date for the next preventive maintenance.',
    `notes` STRING COMMENT 'Free‑form field for any extra information relevant to the notification.',
    `notification_number` STRING COMMENT 'Human‑readable identifier assigned to the notification (e.g., NM123456).',
    `notification_timestamp` TIMESTAMP COMMENT 'Date and time when the notification was originally created in the source system.',
    `notification_type` STRING COMMENT 'Classifies the notification as a malfunction report, activity report, or maintenance request.. Valid values are `malfunction|activity|maintenance_request`',
    `oem_notification_flag` BOOLEAN COMMENT 'True if the original equipment manufacturer must be notified.',
    `parts_list` STRING COMMENT 'Comma‑separated list of part numbers required.',
    `parts_required_flag` BOOLEAN COMMENT 'True if spare parts are needed to complete the maintenance.',
    `planned_end_timestamp` TIMESTAMP COMMENT 'Scheduled completion time for the maintenance activity.',
    `planned_start_timestamp` TIMESTAMP COMMENT 'Scheduled start time for the maintenance activity.',
    `priority` STRING COMMENT 'Business‑defined urgency level for handling the notification.. Valid values are `low|medium|high|critical`',
    `regulatory_report_required` BOOLEAN COMMENT 'Indicates whether the notification must be reported to a governing body (e.g., NHTSA).',
    `reported_by_name` STRING COMMENT 'Display name of the person or system that reported the issue.',
    `root_cause_analysis` STRING COMMENT 'Narrative description of the underlying cause identified after investigation.',
    `safety_risk_flag` BOOLEAN COMMENT 'Indicates whether the issue poses a safety hazard.',
    `severity` STRING COMMENT 'Impact level of the reported issue on production.. Valid values are `minor|major|critical`',
    `shift` STRING COMMENT 'Production shift during which the issue was observed.. Valid values are `day|swing|night`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the notification record.',
    `work_center` STRING COMMENT 'Specific work center or production cell responsible for the asset.',
    CONSTRAINT pk_maintenance_notification PRIMARY KEY(`maintenance_notification_id`)
) COMMENT 'Maintenance notification (malfunction report, activity report, or maintenance request) raised by operators, technicians, or automated condition monitoring systems to report equipment faults, defects, or required maintenance activities. Captures notification type, reported damage/cause/activity codes, breakdown indicator, and priority. Maps to SAP PM Notification (QMEL) and is the trigger for maintenance order creation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` (
    `equipment_downtime_id` BIGINT COMMENT 'System‑generated unique identifier for each equipment downtime event.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Enables downtime cost attribution to the responsible cost center for OEE and financial impact analysis.',
    `employee_id` BIGINT COMMENT 'Identifier of the operator or technician who reported or handled the downtime.',
    `equipment_operator_employee_id` BIGINT COMMENT 'Identifier of the operator or technician who reported or handled the downtime.',
    `maintenance_order_id` BIGINT COMMENT 'Identifier of the maintenance work order linked to the downtime event.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Foreign key linking to aftersales.aftersales_nameplate. Business justification: Supports Downtime Impact Analysis per vehicle program, a regulatory and internal KPI report.',
    `equipment_registry_id` BIGINT COMMENT 'Unique identifier of the equipment or machine that experienced downtime.',
    `production_line_id` BIGINT COMMENT 'Identifier of the production line or cell affected by the downtime.',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: Downtime tracking must attribute loss to the work center where the equipment resides for OEE and cost analysis.',
    `cause_severity` STRING COMMENT 'Severity rating of the root cause, used for prioritization of corrective actions.. Valid values are `low|medium|high`',
    `comments` STRING COMMENT 'Additional free‑form notes captured by the operator or maintenance team.',
    `cost_of_downtime` DECIMAL(18,2) COMMENT 'Estimated financial impact of the downtime event.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for the cost of downtime.',
    `downtime_category` STRING COMMENT 'High‑level classification of why the equipment was down.. Valid values are `mechanical_failure|electrical_fault|tooling_change|planned_maintenance|material_shortage|other`',
    `downtime_event_number` STRING COMMENT 'Business‑visible identifier or ticket number assigned to the downtime event.',
    `downtime_percentage` DECIMAL(18,2) COMMENT 'Proportion of scheduled production time lost, expressed as a percentage.',
    `downtime_reason_group` STRING COMMENT 'Higher‑level grouping of root cause categories for reporting.',
    `downtime_reported_by` STRING COMMENT 'Name of the person who initially reported the downtime.',
    `downtime_reported_timestamp` TIMESTAMP COMMENT 'Timestamp when the downtime was first reported in the system.',
    `downtime_source_system` STRING COMMENT 'Name of the source system that recorded the downtime (e.g., MES, SAP PM).',
    `duration_minutes` STRING COMMENT 'Total length of the downtime event expressed in whole minutes.',
    `end_timestamp` TIMESTAMP COMMENT 'Exact date‑time when the equipment resumed operation.',
    `equipment_downtime_status` STRING COMMENT 'Current lifecycle status of the downtime record.. Valid values are `open|closed|cancelled`',
    `is_critical` BOOLEAN COMMENT 'True if the downtime event had a critical impact on production or safety.',
    `lost_units` STRING COMMENT 'Number of production units that could not be produced because of the downtime.',
    `maintenance_type` STRING COMMENT 'Indicates whether the downtime was scheduled (planned) or unexpected (unplanned).. Valid values are `planned|unplanned`',
    `oee_impact_percentage` DECIMAL(18,2) COMMENT 'Estimated impact of the downtime on Overall Equipment Effectiveness, expressed as a percentage.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the downtime record was first created in the system.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the downtime record.',
    `repair_action_taken` STRING COMMENT 'Description of the corrective action performed to restore equipment.',
    `root_cause_code` STRING COMMENT 'Standardized code representing the detailed root cause of the downtime.',
    `root_cause_description` STRING COMMENT 'Free‑text description of the underlying cause of the downtime.',
    `scheduled_maintenance_flag` BOOLEAN COMMENT 'True if the downtime was part of a pre‑planned maintenance window.',
    `shift` STRING COMMENT 'Shift during which the downtime occurred.. Valid values are `day|night|swing`',
    `spare_part_quantity` STRING COMMENT 'Quantity of the spare part consumed in the repair.',
    `spare_part_used` STRING COMMENT 'Part number of any spare component used during repair.',
    `start_timestamp` TIMESTAMP COMMENT 'Exact date‑time when the equipment stopped operating.',
    CONSTRAINT pk_equipment_downtime PRIMARY KEY(`equipment_downtime_id`)
) COMMENT 'Operational record of unplanned and planned equipment downtime events on the shop floor. Captures downtime start and end timestamps, duration (minutes), downtime category (mechanical failure, electrical fault, tooling change, planned maintenance, material shortage), affected production line, lost production units, and root cause classification. Primary source for MTBF, MTTR, and OEE availability calculations. Integrates with MES (Apriso/Dassault) downtime tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`calibration_record` (
    `calibration_record_id` BIGINT COMMENT 'System-generated unique identifier for the calibration record.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the asset or measurement equipment that was calibrated.',
    `maintenance_order_id` BIGINT COMMENT 'Identifier of the maintenance work order that triggered or recorded the calibration.',
    `calibration_cost` DECIMAL(18,2) COMMENT 'Monetary cost incurred for the calibration activity.',
    `calibration_date` DATE COMMENT 'Date on which the calibration activity was performed.',
    `calibration_interval_days` STRING COMMENT 'Number of days between successive calibrations as defined by the calibration plan.',
    `calibration_label` STRING COMMENT 'Human‑readable label or title for the calibration event.',
    `calibration_method` STRING COMMENT 'Method used for calibration: performed in‑house or by an external provider.. Valid values are `in_house|external`',
    `calibration_number` STRING COMMENT 'Business‑assigned identifier or code for the calibration record, used in reports and work orders.',
    `calibration_record_status` STRING COMMENT 'Current lifecycle status of the calibration record.. Valid values are `scheduled|in_progress|completed|failed|cancelled`',
    `calibration_report_url` STRING COMMENT 'Link to the digital calibration report or certificate.',
    `calibration_standard` STRING COMMENT 'Reference to the calibration standard or traceability document used for the calibration.',
    `calibration_type` STRING COMMENT 'Category of calibration performed, e.g., dimensional, electrical, functional, temperature, or pressure.. Valid values are `dimensional|electrical|functional|temperature|pressure`',
    `comments` STRING COMMENT 'Free‑form notes or observations recorded by the calibrator.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the calibration record was initially created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for calibration_cost.. Valid values are `USD|EUR|JPY|CNY|GBP|CAD`',
    `due_date` DATE COMMENT 'Scheduled date when the next calibration is required.',
    `lab_certificate_number` STRING COMMENT 'Certificate or accreditation number issued to the laboratory for this calibration.',
    `laboratory_name` STRING COMMENT 'Name of the accredited laboratory or internal facility that performed the calibration.',
    `measurement_uncertainty` DECIMAL(18,2) COMMENT 'Quantified uncertainty of the measurement after calibration, expressed in the unit defined by uncertainty_unit.',
    `result` STRING COMMENT 'Outcome of the calibration: pass, fail, or conditional.. Valid values are `pass|fail|conditional`',
    `uncertainty_unit` STRING COMMENT 'Unit of measure for measurement_uncertainty, e.g., micrometers, millimeters, nanometers, or percent.. Valid values are `µm|mm|nm|%`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the calibration record.',
    CONSTRAINT pk_calibration_record PRIMARY KEY(`calibration_record_id`)
) COMMENT 'Calibration and measurement system analysis (MSA) record for gauges, measurement instruments, test equipment, and CMM (Coordinate Measuring Machine) assets. Tracks calibration date, due date, calibration standard used, calibration result (pass/fail/conditional), measurement uncertainty, calibration interval, and accredited laboratory reference. Mandatory for IATF 16949 clause 7.1.5 measurement equipment management and PPAP dimensional reporting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` (
    `equipment_counter_id` BIGINT COMMENT 'Unique surrogate key for each equipment counter reading record.',
    `measurement_point_id` BIGINT COMMENT 'Identifier of the specific measurement point on the equipment (e.g., sensor or counter location).',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment (machine, tool, or asset) to which the counter reading belongs.',
    `batch_number` STRING COMMENT 'Batch or lot number associated with the production run (if applicable).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the reading record was created in the data lake.',
    `cumulative_counter` DECIMAL(18,2) COMMENT 'Cumulative total of the counter up to this reading (if applicable).',
    `delta_counter` DECIMAL(18,2) COMMENT 'Difference between this reading and the previous reading.',
    `equipment_counter_status` STRING COMMENT 'Current status of the reading record.. Valid values are `active|archived|invalid`',
    `event_timestamp` TIMESTAMP COMMENT 'Date and time when the counter reading was captured.',
    `maintenance_action` STRING COMMENT 'Recommended maintenance action associated with this reading.. Valid values are `inspection|repair|replace|none`',
    `maintenance_due_date` DATE COMMENT 'Date by which the recommended maintenance action should be completed.',
    `maintenance_trigger_flag` BOOLEAN COMMENT 'Indicates whether this reading triggers a maintenance action based on predefined thresholds.',
    `plant_location` STRING COMMENT 'Plant or facility where the equipment is located.',
    `reading_quality` STRING COMMENT 'Quality status of the reading as assessed by the system or operator.. Valid values are `good|questionable|invalid`',
    `reading_type` STRING COMMENT 'Category of the counter measurement.. Valid values are `operating_hours|production_cycles|stroke_count|mileage|temperature|pressure`',
    `reading_value` DECIMAL(18,2) COMMENT 'Numeric value of the counter reading (e.g., operating hours, cycles).',
    `recorded_by` STRING COMMENT 'User or system identifier that recorded the reading.',
    `recorded_by_role` STRING COMMENT 'Role of the recorder (human operator or automated system).. Valid values are `operator|system|automated`',
    `remarks` STRING COMMENT 'Free-text comments or notes about the reading.',
    `sensor_calibration_date` DATE COMMENT 'Date when the sensor was last calibrated.',
    `sensor_calibration_due_date` DATE COMMENT 'Next scheduled calibration date for the sensor.',
    `sensor_serial_number` STRING COMMENT 'Serial number of the sensor providing the reading.',
    `shift` STRING COMMENT 'Production shift during which the reading was taken.. Valid values are `day|swing|night`',
    `unit_of_measure` STRING COMMENT 'Unit in which the reading value is expressed.. Valid values are `hours|cycles|km|strokes|temperature|pressure`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the reading record.',
    `work_center` STRING COMMENT 'Work center responsible for the equipment.',
    CONSTRAINT pk_equipment_counter PRIMARY KEY(`equipment_counter_id`)
) COMMENT 'Counter and measurement point readings for equipment — tracks operating hours, production cycles, stroke counts, mileage, and other counter-based metrics used to trigger condition-based maintenance. Each reading is time-stamped and associated with a specific measurement point on the equipment. Maps to SAP PM Measurement Document (IK11) and supports predictive maintenance trigger logic.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` (
    `spare_parts_catalog_id` BIGINT COMMENT 'Unique surrogate key for each spare parts catalog record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Links spare part inventory valuation to cost centers for inventory costing and budgeting in automotive plants.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Spare parts inventory tracks which supplier provides each part to enable procurement planning, cost analysis, and recall traceability.',
    `cad_file_reference` STRING COMMENT 'Path or identifier for the CAD file stored in the PLM system.',
    `compliance_certifications` STRING COMMENT 'List of regulatory or quality certifications applicable to the part.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the catalog record was created.',
    `currency_code` STRING COMMENT 'ISO 4217 currency code for the listed price.. Valid values are `USD|EUR|JPY|GBP|CAD|AUD`',
    `dimensions_mm` STRING COMMENT 'Physical dimensions expressed as LxWxH in millimetres.',
    `drawing_number` STRING COMMENT 'Reference to the CAD drawing that defines the part geometry.',
    `effective_from` DATE COMMENT 'Date from which the part information is valid.',
    `effective_until` DATE COMMENT 'Date until which the part information remains valid; null for indefinite.',
    `eol_date` DATE COMMENT 'Planned date when the part will no longer be manufactured or supported.',
    `expiration_date` DATE COMMENT 'Date after which the part must not be used.',
    `is_critical` BOOLEAN COMMENT 'True if the part is critical to equipment operation and requires special handling.',
    `is_obsolete` BOOLEAN COMMENT 'Indicates whether the part is obsolete and should not be used for new maintenance.',
    `lead_time_days` STRING COMMENT 'Average number of days from order to receipt of the part.',
    `list_price_usd` DECIMAL(18,2) COMMENT 'Standard catalog price in US dollars.',
    `location_code` STRING COMMENT 'Warehouse or bin identifier where the part is stored.',
    `lot_number` STRING COMMENT 'Batch or lot identifier for traceability.',
    `maintenance_interval_hours` STRING COMMENT 'Recommended operating hours between preventive maintenance actions.',
    `maintenance_strategy` STRING COMMENT 'Preferred maintenance approach for the part.. Valid values are `preventive|predictive|reactive`',
    `manufacturer_name` STRING COMMENT 'Name of the company that manufactures the part.',
    `manufacturer_part_number` STRING COMMENT 'Part number assigned by the original equipment manufacturer.',
    `max_order_quantity` STRING COMMENT 'Largest quantity that can be ordered in a single purchase.',
    `mean_time_between_failures_hours` DECIMAL(18,2) COMMENT 'Average operating time between part failures.',
    `min_order_quantity` STRING COMMENT 'Smallest quantity that can be ordered from the supplier.',
    `part_category` STRING COMMENT 'High‑level grouping of parts (e.g., hydraulics, electronics).',
    `part_description` STRING COMMENT 'Detailed description of the spare part, including function and key characteristics.',
    `part_family` STRING COMMENT 'Family of parts sharing a common design platform.',
    `part_group` STRING COMMENT 'Logical group of parts that are interchangeable or used together.',
    `part_name` STRING COMMENT 'Human‑readable name or title of the spare part.',
    `part_number` STRING COMMENT 'Manufacturer or OEM assigned part number used to uniquely identify the spare part.',
    `part_revision` STRING COMMENT 'Revision identifier for engineering changes to the part.',
    `part_subcategory` STRING COMMENT 'More specific classification within the part category.',
    `part_type` STRING COMMENT 'Classification of the part by functional domain.. Valid values are `mechanical|electrical|hydraulic|software|consumable`',
    `regulatory_approval_code` STRING COMMENT 'Code indicating compliance with applicable safety or emissions regulations.',
    `reorder_point_quantity` STRING COMMENT 'Inventory level that triggers a replenishment order.',
    `safety_rating` STRING COMMENT 'Safety classification based on internal or external assessment.. Valid values are `A|B|C|D|E`',
    `safety_stock_quantity` STRING COMMENT 'Minimum inventory level to protect against stockouts.',
    `spare_parts_catalog_status` STRING COMMENT 'Current lifecycle status of the part in the catalog.. Valid values are `active|inactive|discontinued|pending`',
    `stock_quantity` STRING COMMENT 'Quantity of the part currently on hand.',
    `supplier_code` STRING COMMENT 'Identifier of the preferred supplier for this part.',
    `uom` STRING COMMENT 'Standard unit of measure for inventory and ordering.. Valid values are `EA|SET|KG|L`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the record.',
    `warranty_period_months` STRING COMMENT 'Manufacturer warranty duration expressed in months.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Net weight of the part in kilograms.',
    CONSTRAINT pk_spare_parts_catalog PRIMARY KEY(`spare_parts_catalog_id`)
) COMMENT 'Catalog of spare parts and MRO (Maintenance, Repair, and Operations) materials associated with specific equipment and functional locations. Defines the bill of materials for maintenance — critical spare parts, recommended stock quantities, lead times, and supplier references. Links equipment to the materials required for its maintenance. Supports SAP PM Equipment BOM (CS15) and MRP planning for maintenance materials.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` (
    `maintenance_task_list_id` BIGINT COMMENT 'Unique identifier for the maintenance task list.',
    `maintenance_plan_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_plan. Business justification: Tie maintenance task lists to their parent maintenance plan.',
    `applicable_asset_type` STRING COMMENT 'Type of asset (e.g., CNC machine, robot, conveyor) the task applies to.',
    `author` STRING COMMENT 'Name of the person who authored the task list.',
    `compliance_standard` STRING COMMENT 'Regulatory or industry standard governing the task.. Valid values are `ISO 14224|IATF 16949|ISO 9001|ISO 14001`',
    `cost_estimate_amount` DECIMAL(18,2) COMMENT 'Estimated cost to perform the task.',
    `cost_estimate_currency` STRING COMMENT 'Currency of the cost estimate.. Valid values are `USD|EUR|JPY|GBP|CNY|CAD`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the task list record was created.',
    `criticality` STRING COMMENT 'Impact level of task failure on operations.. Valid values are `low|medium|high|critical`',
    `maintenance_task_list_description` STRING COMMENT 'Detailed description of the work to be performed.',
    `effective_end_date` DATE COMMENT 'Date after which the task list is no longer valid (null if indefinite).',
    `effective_start_date` DATE COMMENT 'Date from which the task list is valid.',
    `environmental_impact_flag` BOOLEAN COMMENT 'Indicates whether the task has environmental impact considerations.',
    `equipment_category` STRING COMMENT 'Broad category of equipment (e.g., mechanical, electrical, hydraulic).',
    `estimated_duration_minutes` STRING COMMENT 'Planned duration to complete the task, in minutes.',
    `estimated_labor_hours` DECIMAL(18,2) COMMENT 'Estimated labor effort in hours.',
    `frequency_interval_days` STRING COMMENT 'Number of days between recurring executions of the task.',
    `frequency_interval_months` STRING COMMENT 'Number of months between recurring executions of the task.',
    `is_deprecated` BOOLEAN COMMENT 'Indicates if the task list is deprecated and should not be used for new work orders.',
    `last_modified_by` STRING COMMENT 'Name of the person who last modified the task list.',
    `maintenance_task_list_status` STRING COMMENT 'Current lifecycle status of the task list.. Valid values are `active|inactive|deprecated`',
    `maintenance_type` STRING COMMENT 'Category of maintenance strategy the task belongs to.. Valid values are `preventive|predictive|corrective|inspection|calibration`',
    `overtime_allowed` BOOLEAN COMMENT 'Whether overtime work is permitted for this task.',
    `priority` STRING COMMENT 'Priority level indicating urgency.. Valid values are `low|medium|high|critical`',
    `regulatory_reference` STRING COMMENT 'Specific regulation or guideline reference (e.g., NHTSA §123).',
    `required_materials` STRING COMMENT 'Materials or consumables needed for the task.',
    `required_skill_level` STRING COMMENT 'Skill level required for personnel performing the task.. Valid values are `basic|intermediate|advanced|expert`',
    `required_tools` STRING COMMENT 'List of tools or equipment needed to execute the task.',
    `requires_approval` BOOLEAN COMMENT 'Indicates if task execution requires managerial approval.',
    `revision_date` DATE COMMENT 'Date of the latest revision of the task list.',
    `safety_instructions` STRING COMMENT 'Safety precautions and personal protective equipment required.',
    `safety_rating` STRING COMMENT 'Overall safety risk rating for the task.. Valid values are `low|moderate|high|extreme`',
    `task_code` STRING COMMENT 'Unique code identifying the task within the maintenance catalog.',
    `task_name` STRING COMMENT 'Descriptive name of the maintenance task.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the task list.',
    `version_number` STRING COMMENT 'Version of the task list definition.',
    `work_order_template_code` BIGINT COMMENT 'Reference to the work order template that uses this task list.',
    CONSTRAINT pk_maintenance_task_list PRIMARY KEY(`maintenance_task_list_id`)
) COMMENT 'Standardized task list (operation list) defining the sequence of maintenance activities, required labor skills, estimated durations, safety instructions, and material requirements for a specific maintenance strategy. Reusable template referenced by maintenance plans and orders. Maps to SAP PM Task List (PLMK) and supports standardization of preventive maintenance procedures across plants.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`acquisition` (
    `acquisition_id` BIGINT COMMENT 'System-generated unique identifier for the asset acquisition record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Critical for capital expenditure allocation to the proper cost center during asset acquisition accounting.',
    `functional_location_id` BIGINT COMMENT 'Identifier of the plant or facility where the asset is installed.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: When equipment is sold to external customers, acquisition records must capture the buyer party for revenue recognition and contract compliance.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier providing the asset.',
    `vendor_id` BIGINT COMMENT 'Unique identifier of the supplier providing the asset.',
    `acquisition_number` STRING COMMENT 'External business identifier or reference number for the acquisition transaction.',
    `acquisition_status` STRING COMMENT 'Current lifecycle status of the acquisition process.. Valid values are `planned|ordered|received|installed|active|retired`',
    `acquisition_timestamp` TIMESTAMP COMMENT 'Date and time when the acquisition event was recorded (e.g., purchase order issuance).',
    `approval_date` DATE COMMENT 'Date when the acquisition was approved.',
    `approval_status` STRING COMMENT 'Current approval state of the acquisition request.. Valid values are `pending|approved|rejected`',
    `asset_category` STRING COMMENT 'Business category grouping for the asset (e.g., production, auxiliary).',
    `asset_condition` STRING COMMENT 'Physical condition of the asset at the time of acquisition.. Valid values are `new|used|refurbished`',
    `asset_subcategory` STRING COMMENT 'More detailed classification within the asset category.',
    `asset_tag` STRING COMMENT 'Human‑readable label or tag assigned to the asset for identification on the shop floor.',
    `asset_type` STRING COMMENT 'High‑level classification of the acquired asset.. Valid values are `machinery|tooling|fixture|infrastructure|robot|conveyor`',
    `budget_line_item` STRING COMMENT 'Budget line item code used for the acquisition funding.',
    `capex_project_code` STRING COMMENT 'Capital expenditure project identifier linked to the acquisition.',
    `commissioning_date` DATE COMMENT 'Date when the asset was officially commissioned and ready for production.',
    `cost` DECIMAL(18,2) COMMENT 'Base purchase price of the asset before taxes, fees, and installation.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for monetary values.',
    `depreciation_method` STRING COMMENT 'Accounting method used to depreciate the asset over its useful life.. Valid values are `straight_line|double_declining|units_of_production`',
    `depreciation_period_years` STRING COMMENT 'Number of years over which the asset is depreciated.',
    `expected_mtbf_hours` DOUBLE COMMENT 'Planned Mean Time Between Failures for the asset, expressed in operating hours.',
    `expected_mttr_hours` DOUBLE COMMENT 'Planned Mean Time To Repair for the asset, expressed in hours.',
    `finance_account_code` STRING COMMENT 'General ledger account code to which the acquisition cost is posted.',
    `installation_cost` DECIMAL(18,2) COMMENT 'Cost incurred to install and commission the asset at the plant.',
    `maintenance_contract_flag` BOOLEAN COMMENT 'Indicates whether a separate maintenance contract exists for the asset.',
    `manufacturer` STRING COMMENT 'Company that produced the asset.',
    `model_number` STRING COMMENT 'Model designation of the asset as defined by the manufacturer.',
    `purchase_order_number` STRING COMMENT 'Reference number of the purchase order associated with the acquisition.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the acquisition record was first created in the system.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the acquisition record.',
    `serial_number` STRING COMMENT 'Manufacturer‑assigned serial number of the asset.',
    `sop_readiness_date` DATE COMMENT 'Target date when the asset is expected to be ready for Start of Production.',
    `tax_code` STRING COMMENT 'Tax classification code applied to the acquisition.',
    `total_gross_amount` DECIMAL(18,2) COMMENT 'Gross monetary amount of the acquisition (cost + installation + taxes).',
    `total_net_amount` DECIMAL(18,2) COMMENT 'Net amount payable after taxes and any discounts.',
    `total_tax_amount` DECIMAL(18,2) COMMENT 'Aggregate tax amount applied to the acquisition.',
    `useful_life_years` STRING COMMENT 'Estimated operational lifespan of the asset for planning purposes.',
    `warranty_end_date` DATE COMMENT 'Date when the vendor warranty period expires.',
    `warranty_start_date` DATE COMMENT 'Date when the vendor warranty period begins.',
    CONSTRAINT pk_acquisition PRIMARY KEY(`acquisition_id`)
) COMMENT 'Capital asset acquisition record capturing the procurement and commissioning of new manufacturing equipment, tooling, and plant infrastructure. Tracks CapEx authorization reference, purchase order reference, vendor, acquisition cost, installation cost, commissioning date, SOP (Start of Production) readiness date, and depreciation method. Links to finance domain for fixed asset accounting and supports CapEx project tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` (
    `asset_valuation_id` BIGINT COMMENT 'System-generated unique identifier for each asset valuation record.',
    `equipment_registry_id` BIGINT COMMENT 'Unique identifier of the manufacturing asset being valued.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Tracks which employee performed the valuation; required for financial audit and change‑control documentation.',
    `primary_asset_equipment_registry_id` BIGINT COMMENT 'Unique identifier of the manufacturing asset being valued.',
    `accumulated_depreciation` DECIMAL(18,2) COMMENT 'Total depreciation expense recorded to date for the asset.',
    `amount` DECIMAL(18,2) COMMENT 'Monetary amount representing the current book value of the asset.',
    `asset_valuation_status` STRING COMMENT 'Current lifecycle status of the valuation record.. Valid values are `active|inactive|superseded|archived`',
    `book_value_after_valuation` DECIMAL(18,2) COMMENT 'Asset book value after applying the current valuation adjustments.',
    `book_value_before_valuation` DECIMAL(18,2) COMMENT 'Asset book value prior to the current valuation.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the valuation record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code of the valuation amount.. Valid values are `^[A-Z]{3}$`',
    `depreciation_end_date` DATE COMMENT 'Projected or actual date when the asset will be fully depreciated.',
    `depreciation_expense_current_year` DECIMAL(18,2) COMMENT 'Depreciation expense recognized for the asset in the current fiscal year.',
    `depreciation_method` STRING COMMENT 'Method used to calculate depreciation for the asset.. Valid values are `straight_line|declining_balance|units_of_production`',
    `depreciation_rate_percent` DECIMAL(18,2) COMMENT 'Annual depreciation rate expressed as a percentage.',
    `depreciation_start_date` DATE COMMENT 'Date when depreciation of the asset began.',
    `impairment_amount` DECIMAL(18,2) COMMENT 'Monetary amount of impairment applied to the asset value, if any.',
    `impairment_indicator` BOOLEAN COMMENT 'Flag indicating whether the valuation includes an impairment adjustment.',
    `net_book_value` DECIMAL(18,2) COMMENT 'Asset book value after subtracting accumulated depreciation.',
    `notes` STRING COMMENT 'Free‑form comments or observations related to the valuation.',
    `reason` STRING COMMENT 'Business reason for performing the valuation (e.g., annual review, sale, impairment).',
    `residual_value` DECIMAL(18,2) COMMENT 'Estimated salvage value of the asset at the end of its useful life.',
    `revaluation_amount` DECIMAL(18,2) COMMENT 'Monetary increase or decrease applied during a revaluation.',
    `revaluation_flag` BOOLEAN COMMENT 'Indicates whether the valuation represents a revaluation (as opposed to routine depreciation).',
    `updated_by` STRING COMMENT 'User or process identifier that last modified the valuation record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent update to the valuation record.',
    `useful_life_years` STRING COMMENT 'Estimated useful life of the asset in years for depreciation purposes.',
    `valuation_date` DATE COMMENT 'Date on which the asset valuation was performed.',
    `valuation_name` STRING COMMENT 'Human‑readable name or title for the valuation record.',
    `valuation_number` STRING COMMENT 'Business reference number assigned to the valuation event.',
    `valuation_type` STRING COMMENT 'Category of valuation: initial, periodic, impairment, or revaluation.. Valid values are `initial|periodic|impairment|revaluation`',
    `created_by` STRING COMMENT 'User or process identifier that created the valuation record.',
    CONSTRAINT pk_asset_valuation PRIMARY KEY(`asset_valuation_id`)
) COMMENT 'Financial valuation record for manufacturing assets tracking book value, net book value, accumulated depreciation, depreciation method (straight-line, declining balance), useful life, residual value, and revaluation history. Supports SAP FI-AA (Asset Accounting) integration and provides the financial dimension of asset management for CapEx reporting, impairment testing, and insurance valuation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` (
    `maintenance_cost_id` BIGINT COMMENT 'System-generated unique identifier for each maintenance cost record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Ensures each maintenance cost line is charged to the correct cost center for financial consolidation.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or functional location incurring the cost.',
    `maintenance_equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or functional location incurring the cost.',
    `maintenance_order_id` BIGINT COMMENT 'Identifier of the maintenance order to which this cost line belongs.',
    `spare_parts_catalog_id` BIGINT COMMENT 'Foreign key linking to asset.spare_parts_catalog. Business justification: Link maintenance cost lines to the specific spare part used.',
    `consumables_cost` DECIMAL(18,2) COMMENT 'Cost of consumable items (e.g., lubricants, cleaning supplies).',
    `cost_category` STRING COMMENT 'Classification of the cost element (e.g., labor, material, external service).. Valid values are `labor|material|external_service|spare_parts|consumables`',
    `cost_object_reference` STRING COMMENT 'Identifier of the SAP CO cost object (e.g., order, WBS element) for settlement.',
    `cost_type` STRING COMMENT 'Indicates whether the cost is planned (budget) or actual incurred.. Valid values are `planned|actual`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the maintenance cost record was created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for monetary amounts.. Valid values are `USD|EUR|JPY|GBP|CNY|CAD`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Any discount applied to the cost line.',
    `downtime_duration_minutes` STRING COMMENT 'Total production downtime caused by the maintenance, measured in minutes.',
    `external_service_cost` DECIMAL(18,2) COMMENT 'Cost of third‑party services or contractors.',
    `functional_location` STRING COMMENT 'Plant or line location code where the equipment resides.',
    `invoice_date` DATE COMMENT 'Date the external invoice was issued.',
    `invoice_number` STRING COMMENT 'External invoice identifier for third‑party services or parts.',
    `labor_cost` DECIMAL(18,2) COMMENT 'Monetary amount for labor (labor_hours * labor_rate).',
    `labor_hours` DECIMAL(18,2) COMMENT 'Total labor hours spent on the maintenance activity.',
    `labor_rate` DECIMAL(18,2) COMMENT 'Hourly rate applied to labor hours, expressed in the transaction currency.',
    `line_quantity` STRING COMMENT 'Number of units represented by this cost line (e.g., number of labor entries).',
    `line_sequence` STRING COMMENT 'Sequential number of the cost line within the maintenance order.',
    `maintenance_end_timestamp` TIMESTAMP COMMENT 'Exact end time of the maintenance activity.',
    `maintenance_start_timestamp` TIMESTAMP COMMENT 'Exact start time of the maintenance activity.',
    `maintenance_status` STRING COMMENT 'Current lifecycle state of the maintenance work.. Valid values are `scheduled|in_progress|completed|canceled`',
    `maintenance_type` STRING COMMENT 'Category of maintenance activity performed.. Valid values are `preventive|corrective|predictive|inspection`',
    `material_cost` DECIMAL(18,2) COMMENT 'Monetary cost of materials used.',
    `material_quantity` DECIMAL(18,2) COMMENT 'Quantity of material consumed for the maintenance task.',
    `material_uom` STRING COMMENT 'Unit of measure for the material quantity.. Valid values are `pcs|kg|l|m|m2|m3`',
    `mtbf_hours` DECIMAL(18,2) COMMENT 'Average operating hours between successive failures for the equipment.',
    `mttr_hours` DECIMAL(18,2) COMMENT 'Average time required to repair the equipment after a failure.',
    `posting_date` DATE COMMENT 'Date on which the cost is posted to financial ledgers.',
    `settlement_status` STRING COMMENT 'Current status of cost settlement against the cost object.. Valid values are `pending|settled|rejected`',
    `spare_parts_cost` DECIMAL(18,2) COMMENT 'Cost of spare parts consumed during maintenance.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component applied to the total cost.',
    `total_cost` DECIMAL(18,2) COMMENT 'Aggregated total cost for the line (sum of all cost components).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the maintenance cost record.',
    `vendor_name` STRING COMMENT 'Name of the external vendor or service provider.',
    `warranty_expiration_date` DATE COMMENT 'Date when the equipment warranty expires.',
    `warranty_flag` BOOLEAN COMMENT 'Indicates whether the maintenance is covered under warranty (true) or not (false).',
    `work_center` STRING COMMENT 'Work center responsible for performing the maintenance activity.',
    CONSTRAINT pk_maintenance_cost PRIMARY KEY(`maintenance_cost_id`)
) COMMENT 'Maintenance cost record aggregating actual labor, material, and external service costs incurred per maintenance order and per equipment/functional location. Captures cost element breakdown (internal labor, external contractor, spare parts, consumables), cost center allocation, and settlement to production cost objects. Supports SAP CO cost object controlling and maintenance budget vs. actual variance analysis.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` (
    `equipment_reliability_id` BIGINT COMMENT 'System‑generated unique identifier for each equipment reliability record.',
    `equipment_registry_id` BIGINT COMMENT 'Unique identifier of the equipment (machine, tool, or fixture) to which the reliability metrics apply.',
    `availability_percentage` DECIMAL(18,2) COMMENT 'Percentage of scheduled production time that the equipment was available for operation (Uptime / (Uptime + Downtime)).',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the reliability record was first created in the system.',
    `data_quality_score` DECIMAL(18,2) COMMENT 'Score (0‑1) indicating the completeness and accuracy of the source data used to compute the reliability metrics.',
    `failure_rate_per_hour` DECIMAL(18,2) COMMENT 'Number of equipment failures occurring per operating hour during the reporting period.',
    `maintenance_cost_amount` DECIMAL(18,2) COMMENT 'Total monetary cost incurred for all maintenance activities on the equipment in the reporting period.',
    `maintenance_cost_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for the maintenance cost amount.. Valid values are `USD|EUR|JPY|GBP|CNY|CAD`',
    `mean_time_between_failures_hours` DECIMAL(18,2) COMMENT 'Average elapsed operating time between successive failures of the equipment, expressed in hours.',
    `mean_time_to_repair_hours` DECIMAL(18,2) COMMENT 'Average time required to restore equipment to operational condition after a failure, expressed in hours.',
    `notes` STRING COMMENT 'Optional free‑text field for additional observations or remarks about the reliability record.',
    `number_of_failures` STRING COMMENT 'Count of distinct failure events recorded for the equipment during the reporting period.',
    `oee_availability_percentage` DECIMAL(18,2) COMMENT 'Availability portion of OEE, reflecting planned production time versus actual uptime.',
    `oee_performance_percentage` DECIMAL(18,2) COMMENT 'Performance portion of OEE, measuring actual production speed against ideal speed.',
    `oee_quality_percentage` DECIMAL(18,2) COMMENT 'Quality portion of OEE, representing good units produced versus total units processed.',
    `overall_oee_percentage` DECIMAL(18,2) COMMENT 'Composite metric combining availability, performance, and quality percentages for the equipment.',
    `plant_location` STRING COMMENT 'Identifier of the manufacturing plant or site where the equipment is installed.',
    `record_name` STRING COMMENT 'Human‑readable name for the reliability record, typically combining plant, equipment, and period (e.g., "PlantA_Stamping_2023Q1").',
    `reliability_category` STRING COMMENT 'Type of maintenance or failure mode that the reliability record reflects.. Valid values are `preventive|corrective|predictive|unscheduled`',
    `reliability_code` STRING COMMENT 'Business code used by external systems or reports to reference this reliability record.',
    `reliability_status` STRING COMMENT 'Current health classification of the equipment based on its reliability metrics.. Valid values are `good|degraded|poor|critical`',
    `reporting_period_end` DATE COMMENT 'Last calendar day of the period for which reliability metrics are calculated.',
    `reporting_period_start` DATE COMMENT 'First calendar day of the period for which reliability metrics are calculated.',
    `total_downtime_minutes` BIGINT COMMENT 'Cumulative minutes the equipment was non‑operational due to failures or planned maintenance within the reporting period.',
    `total_uptime_minutes` BIGINT COMMENT 'Cumulative minutes the equipment was operational and producing within the reporting period.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the reliability record.',
    CONSTRAINT pk_equipment_reliability PRIMARY KEY(`equipment_reliability_id`)
) COMMENT 'Reliability performance record for equipment tracking MTBF (Mean Time Between Failures), MTTR (Mean Time To Repair), availability percentage, failure rate, and OEE (Overall Equipment Effectiveness) components (availability, performance, quality) over defined reporting periods. Computed from downtime and maintenance order actuals. Supports reliability-centered maintenance (RCM) programs and IATF 16949 equipment effectiveness monitoring.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` (
    `condition_monitoring_id` BIGINT COMMENT 'System-generated unique identifier for each condition monitoring measurement event.',
    `equipment_registry_id` BIGINT COMMENT 'Unique identifier of the manufacturing asset or equipment to which the sensor is attached.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who validated or acknowledged the measurement.',
    `condition_equipment_registry_id` BIGINT COMMENT 'Unique identifier of the manufacturing asset or equipment to which the sensor is attached.',
    `condition_operator_employee_id` BIGINT COMMENT 'Identifier of the employee who validated or acknowledged the measurement.',
    `maintenance_plan_id` BIGINT COMMENT 'Link to the maintenance plan applicable to the asset at the time of measurement.',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: Condition‑monitoring sensor data is tied to the work center where the equipment operates, needed for predictive maintenance dashboards.',
    `anomaly_detected` BOOLEAN COMMENT 'True when the anomaly_score exceeds the configured alert threshold.',
    `anomaly_score` DOUBLE COMMENT 'Numeric score from the anomaly detection model indicating deviation from normal behavior.',
    `battery_level_percent` STRING COMMENT 'Remaining battery charge of the sensor expressed as a percent.',
    `calibration_status` STRING COMMENT 'Current calibration state of the sensor.. Valid values are `calibrated|due|overdue`',
    `comment` STRING COMMENT 'Free‑text field for additional observations or operator notes.',
    `condition_monitoring_status` STRING COMMENT 'Overall health status derived from the measurement and thresholds.. Valid values are `normal|warning|critical|offline`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the measurement record was first persisted in the lakehouse.',
    `data_quality_flag` BOOLEAN COMMENT 'Quality assessment of the measurement record.',
    `equipment_status` STRING COMMENT 'Current operational state of the asset at the time of measurement.. Valid values are `operational|maintenance|failed|idle`',
    `event_timestamp` TIMESTAMP COMMENT 'Date and time when the sensor measurement was captured on the shop floor.',
    `firmware_version` STRING COMMENT 'Version identifier of the sensor firmware at event time.',
    `location` STRING COMMENT 'Physical location code or description where the sensor is installed.',
    `maintenance_action_required` BOOLEAN COMMENT 'Indicates whether the measurement triggers a maintenance work order.',
    `measurement_type` STRING COMMENT 'Category of the measured parameter (e.g., vibration, temperature, oil analysis).. Valid values are `vibration|temperature|oil_analysis|acoustic|current|pressure`',
    `measurement_value` DOUBLE COMMENT 'Numeric value recorded for the measurement_type at event_timestamp.',
    `plant` STRING COMMENT 'Identifier of the manufacturing plant or facility.',
    `predicted_time_to_failure_hours` DOUBLE COMMENT 'Estimated remaining operating time before failure, as predicted by the model.',
    `recorded_by_system` STRING COMMENT 'Source system that transmitted the measurement to the data lake.. Valid values are `bosch_iot|geotab|custom`',
    `reliability_score` DOUBLE COMMENT 'Composite score representing the overall reliability of the asset based on recent measurements.',
    `sensor_code` BIGINT COMMENT 'Unique identifier of the IoT sensor that generated the measurement.',
    `signal_strength_dbm` DOUBLE COMMENT 'Radio signal strength of the sensor transmission.',
    `threshold_breach_flag` BOOLEAN COMMENT 'True when measurement_value exceeds threshold_value.',
    `threshold_value` DOUBLE COMMENT 'Configured limit for the measurement; breach indicates abnormal condition.',
    `unit_of_measure` STRING COMMENT 'Engineering unit associated with measurement_value.. Valid values are `mm_per_s|celsius|ppm|db|ampere|bar`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the measurement record.',
    CONSTRAINT pk_condition_monitoring PRIMARY KEY(`condition_monitoring_id`)
) COMMENT 'Condition monitoring and predictive maintenance sensor data record capturing real-time and periodic equipment health parameters — vibration levels, temperature, oil analysis results, acoustic emission, current draw, and pressure readings from IoT sensors (Bosch IoT / Geotab). Each record represents a measurement event with timestamp, sensor ID, measured value, engineering unit, and threshold breach indicator. Feeds predictive maintenance algorithms.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`asset_tooling_usage` (
    `asset_tooling_usage_id` BIGINT COMMENT 'Unique identifier for the asset_tooling_usage data product (auto-inserted pre-linking).',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Link asset_tooling_usage to equipment_registry to associate usage records with the specific equipment.',
    `tooling_registry_id` BIGINT COMMENT 'Foreign key linking to asset.tooling_registry. Business justification: Link asset_tooling_usage to tooling_registry to capture which tooling is used for each asset usage record.',
    CONSTRAINT pk_asset_tooling_usage PRIMARY KEY(`asset_tooling_usage_id`)
) COMMENT 'Operational usage record for production tooling and dies tracking actual strokes, shots, cycles, or impressions consumed per production run. Captures tool life consumed vs. total rated life, wear indicators, last refurbishment date, and remaining life percentage. Drives tool change scheduling, die maintenance triggers, and PPAP tool life validation. Integrates with MES press and stamping line data.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` (
    `equipment_transfer_id` BIGINT COMMENT 'System-generated unique identifier for each equipment transfer record.',
    `employee_id` BIGINT COMMENT 'Identifier of the engineer accountable for the transfer execution.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Add equipment_registry reference to equipment_transfer to know which asset is moved.',
    `equipment_responsible_engineer_employee_id` BIGINT COMMENT 'Identifier of the engineer accountable for the transfer execution.',
    `compliance_standard` STRING COMMENT 'Applicable regulatory or quality standard governing the transfer (e.g., ISO 9001, IATF 16949).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the transfer record was first created in the system.',
    `depreciation_amount_after` DECIMAL(18,2) COMMENT 'Accumulated depreciation value of the equipment after the transfer.',
    `depreciation_amount_before` DECIMAL(18,2) COMMENT 'Accumulated depreciation value of the equipment before the transfer.',
    `destination_functional_location` STRING COMMENT 'Identifier of the functional location or plant where the equipment is being transferred to.',
    `equipment_condition_after` STRING COMMENT 'Recorded condition of the equipment at the destination after move.. Valid values are `good|fair|poor|damaged`',
    `equipment_condition_before` STRING COMMENT 'Recorded condition of the equipment at the source location prior to move.. Valid values are `good|fair|poor|damaged`',
    `equipment_transfer_status` STRING COMMENT 'Current processing state of the transfer (e.g., pending, in progress, completed, cancelled).. Valid values are `pending|in_progress|completed|cancelled`',
    `installation_status` STRING COMMENT 'Indicates whether the equipment was installed after arrival.. Valid values are `installed|not_installed|pending`',
    `mtbf_hours_after` DECIMAL(18,2) COMMENT 'Mean time between failures for the equipment measured after the transfer.',
    `mtbf_hours_before` DECIMAL(18,2) COMMENT 'Mean time between failures for the equipment measured before the transfer.',
    `notes` STRING COMMENT 'Free‑form comments or observations related to the transfer.',
    `reason_code` STRING COMMENT 'Business reason for the equipment transfer.. Valid values are `line_rebalancing|plant_consolidation|program_changeover|maintenance|other`',
    `source_functional_location` STRING COMMENT 'Identifier of the functional location or plant where the equipment originated.',
    `transfer_cost_amount` DECIMAL(18,2) COMMENT 'Monetary cost incurred for moving the equipment.',
    `transfer_cost_currency` STRING COMMENT 'ISO 4217 currency code for the transfer cost (e.g., USD, EUR).',
    `transfer_date` TIMESTAMP COMMENT 'Exact date and time when the equipment was moved from source to destination.',
    `transfer_number` STRING COMMENT 'Human‑readable reference number assigned to the equipment transfer event.',
    `transfer_order_reference` STRING COMMENT 'Reference to an external work order or purchase order linked to the transfer.',
    `transport_method` STRING COMMENT 'Mode of transportation used for the equipment move.. Valid values are `truck|rail|ship|air|internal`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the transfer record.',
    `warranty_status_after` STRING COMMENT 'Warranty state of the equipment at the destination location.. Valid values are `valid|expired|not_applicable`',
    `warranty_status_before` STRING COMMENT 'Warranty state of the equipment at the source location.. Valid values are `valid|expired|not_applicable`',
    CONSTRAINT pk_equipment_transfer PRIMARY KEY(`equipment_transfer_id`)
) COMMENT 'Record of equipment relocation and transfer events between plants, production lines, or functional locations. Captures source and destination functional locations, transfer date, reason code (line rebalancing, plant consolidation, program changeover), transport method, installation status at destination, and responsible engineer. Supports asset location history and plant capacity planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` (
    `maintenance_work_center_id` BIGINT COMMENT 'Unique surrogate key for each maintenance work center.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Allows work‑center overhead allocation to finance cost centers for accurate cost accounting.',
    `employee_id` BIGINT COMMENT 'Identifier of the person responsible for the work center.',
    `maintenance_responsible_person_employee_id` BIGINT COMMENT 'Identifier of the person responsible for the work center.',
    `capacity_per_shift` DECIMAL(18,2) COMMENT 'Maximum production capacity of the work center per shift (units per hour).',
    `certification_required_flag` BOOLEAN COMMENT 'Indicates whether specific certifications are mandatory for staff.',
    `compliance_iso9001` BOOLEAN COMMENT 'True if the work center complies with ISO 9001 quality management standards.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the work center record was created.',
    `maintenance_work_center_description` STRING COMMENT 'Detailed free‑text description of the work centers responsibilities.',
    `downtime_estimate_hours` DECIMAL(18,2) COMMENT 'Typical downtime expected for scheduled maintenance.',
    `effective_from` DATE COMMENT 'Date when the work center becomes effective.',
    `effective_until` DATE COMMENT 'Date when the work center ceases to be effective (null if open‑ended).',
    `equipment_category` STRING COMMENT 'Category of equipment primarily used in the work center.',
    `functional_area` STRING COMMENT 'Higher‑level functional area (e.g., Assembly, Paint, Body Shop) the work center belongs to.',
    `headcount` STRING COMMENT 'Number of personnel assigned to the work center.',
    `hourly_rate` DECIMAL(18,2) COMMENT 'Standard hourly labor cost for the work center (currency defined by hourly_rate_currency).',
    `hourly_rate_currency` STRING COMMENT 'Currency of the hourly labor rate.. Valid values are `USD|EUR|JPY|GBP|CNY`',
    `is_critical` BOOLEAN COMMENT 'True if the work center is deemed critical to production continuity.',
    `is_operational` BOOLEAN COMMENT 'True if the work center is currently operational.',
    `labor_cost_rate_amount` DECIMAL(18,2) COMMENT 'Standard labor cost per hour for the work center.',
    `labor_cost_rate_currency` STRING COMMENT 'Currency for the labor cost rate.. Valid values are `USD|EUR|JPY|GBP|CNY`',
    `last_maintenance_date` DATE COMMENT 'Date of the most recent maintenance activity.',
    `maintenance_interval_days` STRING COMMENT 'Planned number of days between routine maintenance activities.',
    `maintenance_strategy` STRING COMMENT 'Strategic approach for maintaining the work center.. Valid values are `preventive|predictive|reactive`',
    `maintenance_window` STRING COMMENT 'Preferred time window for performing maintenance.. Valid values are `night|weekend|any`',
    `maintenance_work_center_status` STRING COMMENT 'Current lifecycle status of the work center.. Valid values are `active|inactive|planned|closed`',
    `mean_time_between_failures_hours` DECIMAL(18,2) COMMENT 'Average operating hours between failures for the work center.',
    `mean_time_to_repair_hours` DECIMAL(18,2) COMMENT 'Average time required to restore the work center after a failure.',
    `next_maintenance_date` DATE COMMENT 'Planned date for the next maintenance activity.',
    `oee_target_pct` DECIMAL(18,2) COMMENT 'Target OEE percentage for the work center.',
    `parts_list_reference` STRING COMMENT 'Reference code to the parts list associated with the work center.',
    `parts_required_flag` BOOLEAN COMMENT 'Indicates whether spare parts are required for scheduled work.',
    `plant_location_code` STRING COMMENT 'Code of the plant or functional location where the work center is assigned.',
    `priority` STRING COMMENT 'Priority level for scheduling work center capacity.. Valid values are `low|medium|high|critical`',
    `responsible_department` STRING COMMENT 'Department accountable for the work centers performance.',
    `safety_certification_status` STRING COMMENT 'Current status of safety certifications for the work center.. Valid values are `valid|expired|pending`',
    `safety_risk_level` STRING COMMENT 'Assessed safety risk associated with the work center.. Valid values are `low|medium|high`',
    `shift_pattern` STRING COMMENT 'Shift arrangement for the work center staff.. Valid values are `single|double|triple`',
    `skill_level_required` STRING COMMENT 'Minimum skill level required for personnel assigned to the work center.. Valid values are `basic|intermediate|advanced|expert`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the work center record.',
    `work_center_code` STRING COMMENT 'Business identifier code used in SAP and other systems.',
    `work_center_group` STRING COMMENT 'Logical grouping of work centers for planning purposes.',
    `work_center_name` STRING COMMENT 'Human‑readable name of the work center (e.g., Electrical Assembly Team).',
    `work_center_type` STRING COMMENT 'Classification of the work center by craft or functional area.. Valid values are `electrical|mechanical|hydraulics|robotics|tooling|facility`',
    CONSTRAINT pk_maintenance_work_center PRIMARY KEY(`maintenance_work_center_id`)
) COMMENT 'Master data for maintenance work centers (craft groups) — electrical, mechanical, hydraulics, robotics, tooling, and facilities maintenance teams. Defines available capacity (headcount, shift patterns), skill requirements, cost rates, and plant assignment. Maps to SAP PM Work Center (CR01) and is used for maintenance order scheduling, capacity leveling, and labor cost calculation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`inspection` (
    `inspection_id` BIGINT COMMENT 'Unique identifier for the asset inspection record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Inspection reports are stored as compliance documents for regulatory audit; linking provides direct access to the document.',
    `functional_location_id` BIGINT COMMENT 'Identifier of the plant or facility where the inspection took place.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the asset/equipment inspected.',
    `inspection_checklist_id` BIGINT COMMENT 'Identifier of the inspection checklist used.',
    `employee_id` BIGINT COMMENT 'Identifier of the inspector who performed the inspection.',
    `inspection_equipment_registry_id` BIGINT COMMENT 'Identifier of the asset/equipment inspected.',
    `inspector_employee_id` BIGINT COMMENT 'Identifier of the inspector who performed the inspection.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Foreign key linking to aftersales.aftersales_nameplate. Business justification: Allows inspection results to be traced to the vehicle program, required for quality audit and compliance reporting.',
    `plant_id` BIGINT COMMENT 'Identifier of the plant or facility where the inspection took place.',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: Inspections are performed at a work center; linking enables Inspection‑by‑Work‑Center compliance reports.',
    `asset_tag` STRING COMMENT 'Asset tag or barcode associated with the inspected equipment.',
    `attached_documents` STRING COMMENT 'Comma-separated list of document identifiers attached to the inspection record.',
    `calibration_required` BOOLEAN COMMENT 'Flag indicating whether calibration is required following inspection.',
    `checklist_version` STRING COMMENT 'Version of the checklist applied during inspection.',
    `comments` STRING COMMENT 'Additional comments or observations recorded by the inspector.',
    `compliance_standard` STRING COMMENT 'Regulatory or standards framework applicable to the inspection.. Valid values are `OSHA|ISO9001|IATF16949|EPA|NHTSA`',
    `corrective_action_reference` STRING COMMENT 'Reference identifier for corrective actions linked to this inspection.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the inspection record was first created in the system.',
    `downtime_impact_flag` BOOLEAN COMMENT 'Indicates whether the inspection caused production downtime.',
    `downtime_minutes` STRING COMMENT 'Total production downtime minutes attributable to the inspection.',
    `duration_minutes` STRING COMMENT 'Total time spent performing the inspection, in minutes.',
    `findings_summary` STRING COMMENT 'Brief summary of findings from the inspection.',
    `inspection_number` STRING COMMENT 'External reference number for the inspection as used in operational systems.',
    `inspection_status` STRING COMMENT 'Current lifecycle status of the inspection.. Valid values are `planned|in_progress|completed|closed|rejected`',
    `inspection_timestamp` TIMESTAMP COMMENT 'Date and time when the inspection was performed.',
    `inspection_type` STRING COMMENT 'Category of inspection performed.. Valid values are `safety|quality|regulatory|pre_production|calibration`',
    `inspector_name` STRING COMMENT 'Full name of the inspector.',
    `maintenance_order_reference` STRING COMMENT 'Identifier of maintenance order generated from inspection findings.',
    `non_conformance_count` STRING COMMENT 'Number of non-conformances identified during the inspection.',
    `non_conformance_flag` BOOLEAN COMMENT 'Indicates whether the inspection resulted in any non-conformances.',
    `risk_level` STRING COMMENT 'Risk severity assigned based on inspection findings.. Valid values are `low|medium|high|critical`',
    `safety_certification_status` STRING COMMENT 'Result of safety certification checks during inspection.. Valid values are `compliant|non_compliant|not_applicable`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the inspection record.',
    CONSTRAINT pk_inspection PRIMARY KEY(`inspection_id`)
) COMMENT 'Formal inspection record for equipment, tooling, and plant infrastructure covering safety inspections, regulatory compliance inspections (OSHA, pressure vessel, crane), quality system audits (IATF 16949), and pre-production readiness checks. Captures inspection type, inspector, inspection date, checklist results, findings, non-conformances raised, and corrective action references. Distinct from calibration (which is measurement-specific) and maintenance orders (which are repair-focused).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` (
    `warranty_claim_equipment_id` BIGINT COMMENT 'System generated unique identifier for each equipment warranty claim record.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the OEM or supplier that provided the equipment under warranty.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or tooling item for which the warranty claim is filed.',
    `warranty_equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or tooling item for which the warranty claim is filed.',
    `claim_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the claim record was first created in the system.',
    `claim_number` STRING COMMENT 'Business visible claim reference number assigned by the warranty claim system.',
    `claim_resolution_timestamp` TIMESTAMP COMMENT 'Timestamp when the claim was resolved (approved, rejected, or settled).',
    `claim_status` STRING COMMENT 'Current lifecycle status of the warranty claim.. Valid values are `submitted|under_review|approved|rejected|settled|closed`',
    `claim_submission_timestamp` TIMESTAMP COMMENT 'Date and time when the warranty claim was submitted by the maintenance organization.',
    `claim_type` STRING COMMENT 'Nature of the claim outcome requested (repair, replacement, or credit).. Valid values are `repair|replacement|credit`',
    `claim_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the claim record.',
    `created_by_user` STRING COMMENT 'User identifier of the employee who created the claim.',
    `credit_amount` DECIMAL(18,2) COMMENT 'Monetary credit awarded to the plant for the claim (if applicable).',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for monetary fields.. Valid values are `USD|EUR|JPY|GBP|CAD|AUD`',
    `defect_category` STRING COMMENT 'High‑level category of the reported defect.. Valid values are `mechanical|electrical|software|calibration|other`',
    `defect_description` STRING COMMENT 'Narrative description of the equipment defect or failure reported.',
    `downtime_hours` DECIMAL(18,2) COMMENT 'Total equipment downtime (in hours) attributable to the defect.',
    `equipment_serial_number` STRING COMMENT 'Manufacturer supplied serial number of the equipment.',
    `equipment_tag` STRING COMMENT 'Plant asset tag or barcode assigned to the equipment.',
    `is_critical` BOOLEAN COMMENT 'Indicates whether the equipment failure is classified as critical to production.',
    `mttr_hours` DECIMAL(18,2) COMMENT 'Average time required to repair the equipment for this claim.',
    `notes` STRING COMMENT 'Additional free‑form comments or observations related to the claim.',
    `parts_used` STRING COMMENT 'Comma‑separated list of part numbers or SKUs used during repair.',
    `priority_level` STRING COMMENT 'Business priority assigned to the claim for handling.. Valid values are `low|medium|high|critical`',
    `repair_action_description` STRING COMMENT 'Detailed description of the repair or replacement work performed.',
    `repair_decision` STRING COMMENT 'Decision taken by the supplier on how to resolve the claim.. Valid values are `repair|replace|credit|none`',
    `root_cause_code` STRING COMMENT 'Standardized code representing the root cause of the equipment failure.',
    `root_cause_description` STRING COMMENT 'Narrative description of the identified root cause.',
    `settlement_date` DATE COMMENT 'Date on which the settlement amount was paid to the plant.',
    `settlement_status` STRING COMMENT 'Current status of the claim settlement payment.. Valid values are `pending|paid|reversed|void`',
    `total_repair_cost` DECIMAL(18,2) COMMENT 'Total cost incurred for repairing the equipment (excluding warranty credit).',
    `updated_by_user` STRING COMMENT 'User identifier of the employee who last modified the claim.',
    `warranty_claim_reference` STRING COMMENT 'Reference number provided by the supplier or OEM for tracking the claim.',
    `warranty_coverage_end_date` DATE COMMENT 'Date when the equipment warranty coverage expires.',
    `warranty_coverage_start_date` DATE COMMENT 'Date when the equipment warranty coverage began.',
    CONSTRAINT pk_warranty_claim_equipment PRIMARY KEY(`warranty_claim_equipment_id`)
) COMMENT 'Warranty claim record for manufacturing equipment and tooling under OEM or supplier warranty. Tracks claim submission date, equipment defect description, warranty coverage period, supplier/OEM claim reference, repair or replacement decision, credit amount received, and claim settlement status. Distinct from vehicle warranty (owned by aftersales domain) — this covers plant equipment warranties managed by the maintenance organization.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` (
    `shutdown_plan_id` BIGINT COMMENT 'Unique system-generated identifier for the shutdown plan record.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Associate shutdown plans with the functional location they affect.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee responsible for managing the shutdown project.',
    `shutdown_project_manager_employee_id` BIGINT COMMENT 'Identifier of the employee responsible for managing the shutdown project.',
    `affected_line_codes` STRING COMMENT 'Comma‑separated list of production line identifiers impacted by the shutdown.',
    `approval_status` STRING COMMENT 'Current approval state of the shutdown plan.. Valid values are `pending|approved|rejected`',
    `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the shutdown plan was approved or rejected.',
    `cost_estimate_amount` DECIMAL(18,2) COMMENT 'Estimated monetary cost of the shutdown plan.',
    `cost_estimate_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for the cost estimate.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the shutdown plan record was first created in the system.',
    `downtime_estimate_hours` DECIMAL(18,2) COMMENT 'Projected total downtime in hours for the shutdown.',
    `estimated_production_loss_units` BIGINT COMMENT 'Projected number of vehicle units not produced due to the shutdown.',
    `notes` STRING COMMENT 'Free‑form comments or additional information about the shutdown plan.',
    `plan_number` STRING COMMENT 'Human‑readable business number or code assigned to the shutdown plan.',
    `planned_end_timestamp` TIMESTAMP COMMENT 'Scheduled end date and time for the shutdown event.',
    `planned_start_timestamp` TIMESTAMP COMMENT 'Scheduled start date and time for the shutdown event.',
    `risk_level` STRING COMMENT 'Risk classification for the shutdown plan.. Valid values are `low|medium|high`',
    `scope_of_work` STRING COMMENT 'Brief description of the work to be performed during the shutdown.',
    `shutdown_plan_status` STRING COMMENT 'Current lifecycle state of the shutdown plan.. Valid values are `planned|approved|in_progress|completed|cancelled`',
    `shutdown_type` STRING COMMENT 'Category of shutdown event, e.g., annual maintenance, SOP retool, emergency, or capital installation.. Valid values are `annual_maintenance|sop_retool|emergency|capital_installation`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the shutdown plan record.',
    CONSTRAINT pk_shutdown_plan PRIMARY KEY(`shutdown_plan_id`)
) COMMENT 'Planned plant or line shutdown event record for major maintenance turnarounds, model year changeovers, retooling, and capital installation projects. Captures shutdown type (annual maintenance shutdown, SOP retool, emergency shutdown), planned start/end dates, affected production lines, estimated production loss (units), scope of work summary, and responsible project manager. Supports production planning and CapEx project coordination.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` (
    `lubrication_schedule_id` BIGINT COMMENT 'System-generated unique identifier for the lubrication schedule record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Links lubrication activities to cost centers for budgeting of preventive maintenance expenses.',
    `employee_id` BIGINT COMMENT 'Identifier of the person (e.g., maintenance planner) responsible for the schedule.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or machine to which this lubrication schedule applies.',
    `lubrication_equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or machine to which this lubrication schedule applies.',
    `lubrication_responsible_person_employee_id` BIGINT COMMENT 'Identifier of the person (e.g., maintenance planner) responsible for the schedule.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Lubrication scheduling must reference the lubricant supplier to ensure specification compliance and track supplier performance.',
    `application_method` STRING COMMENT 'Method by which the lubricant is applied to the equipment.. Valid values are `manual|automatic|robotic`',
    `compliance_status` STRING COMMENT 'Indicates whether the schedule is being followed as required.. Valid values are `compliant|non_compliant|overdue`',
    `frequency_unit` STRING COMMENT 'Time unit for the lubrication interval.. Valid values are `hour|day|shift|week|month`',
    `frequency_value` STRING COMMENT 'Numeric part of the lubrication interval (e.g., 8).',
    `is_critical` BOOLEAN COMMENT 'True if the lubrication point is critical to equipment safety or performance.',
    `last_lubrication_timestamp` TIMESTAMP COMMENT 'Date and time when the equipment was last lubricated.',
    `lubricant_spec` STRING COMMENT 'Manufacturer‑specified grade or standard for the lubricant (e.g., ISO VG 46).',
    `lubrication_point_description` STRING COMMENT 'Textual description of the specific point or component to be lubricated.',
    `lubrication_schedule_status` STRING COMMENT 'Current lifecycle status of the schedule.. Valid values are `active|inactive|retired|draft`',
    `lubrication_type` STRING COMMENT 'Category of lubricant used (e.g., grease, oil, synthetic).. Valid values are `grease|oil|synthetic|semi_synthetic|dry|solid`',
    `maintenance_group` STRING COMMENT 'Logical grouping of lubrication schedules for planning (e.g., primary, secondary).',
    `next_due_timestamp` TIMESTAMP COMMENT 'Planned date and time for the next lubrication activity.',
    `notes` STRING COMMENT 'Free‑form comments or special instructions for the schedule.',
    `quantity_amount` DECIMAL(18,2) COMMENT 'Amount of lubricant applied each interval.',
    `quantity_unit` STRING COMMENT 'Unit of measure for the lubricant quantity.. Valid values are `ml|g|kg|l`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the schedule record was first created in the system.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the schedule record.',
    `responsible_department` STRING COMMENT 'Organizational department accountable for executing the schedule.',
    `safety_risk_level` STRING COMMENT 'Risk classification associated with the lubrication activity.. Valid values are `low|medium|high`',
    `schedule_code` STRING COMMENT 'Business code used to reference the lubrication schedule in maintenance planning.',
    `schedule_name` STRING COMMENT 'Human‑readable name describing the lubrication schedule.',
    CONSTRAINT pk_lubrication_schedule PRIMARY KEY(`lubrication_schedule_id`)
) COMMENT 'Lubrication management schedule defining lubrication points on equipment, lubricant type (grease, oil, specification grade), application method, frequency, and quantity. Tracks last lubrication date, next due date, and compliance status. Supports autonomous maintenance programs (TPM — Total Productive Maintenance) and prevents equipment failures attributable to inadequate lubrication. Managed as a distinct schedule from general PM plans due to high frequency and operator-executed nature.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` (
    `equipment_service_subscription_id` BIGINT COMMENT 'Primary key for the equipment_service_subscription association',
    `equipment_registry_id` BIGINT COMMENT 'FK to the equipment registry record',
    `mobility_service_id` BIGINT COMMENT 'FK to the mobility service record',
    `billing_amount` DECIMAL(18,2) COMMENT 'Monetary amount billed for the subscription period',
    `currency_code` STRING COMMENT 'ISO 4217 currency code for the billing amount',
    `end_date` DATE COMMENT 'Date the subscription ends or is terminated',
    `equipment_service_subscription_status` STRING COMMENT 'Current lifecycle status of the subscription (active, suspended, cancelled)',
    `start_date` DATE COMMENT 'Date the subscription becomes effective',
    `subscription_number` STRING COMMENT 'Business identifier for the subscription',
    CONSTRAINT pk_equipment_service_subscription PRIMARY KEY(`equipment_service_subscription_id`)
) COMMENT 'Represents the contractual subscription of a manufacturing equipment asset to a mobility service offering. Each record links one equipment_registry to one mobility_service and stores subscription-specific data such as dates, status, and billing.. Existence Justification: Each manufacturing equipment asset can be subscribed to multiple mobility services, and each mobility service can be subscribed to by many equipment assets. The subscription is an operational record that humans create, update, and delete, capturing start/end dates, status, and billing details.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` (
    `compliance_assessment_id` BIGINT COMMENT 'Primary key for the ComplianceAssessment association',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to the equipment registry',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to the regulatory requirement',
    `assessment_date` DATE COMMENT 'Date when the compliance assessment was performed',
    `compliance_status` STRING COMMENT 'Current compliance state of the equipment for this requirement',
    `notes` STRING COMMENT 'Free‑form comments about the assessment',
    CONSTRAINT pk_compliance_assessment PRIMARY KEY(`compliance_assessment_id`)
) COMMENT 'Represents the assessment of a specific equipment asset against a particular regulatory requirement, recording the compliance status, assessment date, and any notes. Each record links one equipment_registry to one regulatory_requirement.. Existence Justification: Each piece of manufacturing equipment must be evaluated against multiple regulatory requirements, and each regulatory requirement applies to many pieces of equipment. The compliance team actively creates, updates, and deletes records linking equipment to regulations, capturing status, assessment dates, and notes for each pairing.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` (
    `inspection_checklist_id` BIGINT COMMENT 'Primary key for inspection_checklist',
    `parent_inspection_checklist_id` BIGINT COMMENT 'Self-referencing FK on inspection_checklist (parent_inspection_checklist_id)',
    `approval_status` STRING COMMENT 'Current approval state of the checklist.',
    `approved_by` STRING COMMENT 'Name of the person or role that approved the checklist.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the checklist was approved.',
    `associated_asset_type` STRING COMMENT 'Type of asset (e.g., robot, press, conveyor) the checklist applies to.',
    `author` STRING COMMENT 'Name of the person or role that authored the checklist.',
    `change_reason` STRING COMMENT 'Reason for the most recent change to the checklist.',
    `checklist_code` STRING COMMENT 'External business code used to reference the checklist in SAP PM and other systems.',
    `checklist_name` STRING COMMENT 'Human‑readable name of the inspection checklist.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the checklist record was first created.',
    `department` STRING COMMENT 'Organizational department responsible for the checklist.',
    `inspection_checklist_description` STRING COMMENT 'Detailed free‑text description of the checklist purpose and scope.',
    `effective_from` DATE COMMENT 'Date from which the checklist becomes valid for use.',
    `effective_until` DATE COMMENT 'Date after which the checklist is no longer valid (null if open‑ended).',
    `estimated_duration_minutes` STRING COMMENT 'Typical time in minutes required to complete the checklist.',
    `frequency` STRING COMMENT 'How often the checklist is scheduled to be performed.',
    `inspection_type` STRING COMMENT 'Category of inspection the checklist supports.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether the checklist must be performed for the asset.',
    `last_reviewed_timestamp` TIMESTAMP COMMENT 'Date and time when the checklist was last reviewed for relevance.',
    `regulatory_standard` STRING COMMENT 'External regulation or standard the checklist satisfies (e.g., ISO 26262).',
    `required_certification` STRING COMMENT 'Specific certification or training required to execute the checklist.',
    `review_cycle_days` STRING COMMENT 'Number of days between mandatory reviews of the checklist.',
    `safety_rating` STRING COMMENT 'Safety risk rating associated with the checklist.',
    `inspection_checklist_status` STRING COMMENT 'Current lifecycle status of the checklist.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the checklist.',
    `version` STRING COMMENT 'Version identifier of the checklist (e.g., v1.2).',
    CONSTRAINT pk_inspection_checklist PRIMARY KEY(`inspection_checklist_id`)
) COMMENT 'Master reference table for inspection_checklist. Referenced by checklist_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`measurement_point` (
    `measurement_point_id` BIGINT COMMENT 'Primary key for measurement_point',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the asset (machine, line, or equipment) to which the measurement point belongs.',
    `parent_measurement_point_id` BIGINT COMMENT 'Self-referencing FK on measurement_point (parent_measurement_point_id)',
    `calibration_due_timestamp` TIMESTAMP COMMENT 'Scheduled date and time for the next required calibration.',
    `calibration_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent calibration of the measurement point.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the measurement point record was first created in the system.',
    `measurement_point_description` STRING COMMENT 'Free‑text description of the measurement point purpose and characteristics.',
    `installation_timestamp` TIMESTAMP COMMENT 'Date and time when the measurement point was installed on the asset.',
    `location` STRING COMMENT 'Plant, line, or station where the measurement point is physically installed.',
    `max_value` DOUBLE COMMENT 'Upper bound of acceptable measurement values for this point.',
    `measurement_category` STRING COMMENT 'Indicates whether the measurement is captured automatically by a sensor, entered manually, or derived from other data.',
    `min_value` DOUBLE COMMENT 'Lower bound of acceptable measurement values for this point.',
    `point_code` STRING COMMENT 'Business code used to reference the measurement point in external systems.',
    `point_name` STRING COMMENT 'Human‑readable name of the measurement point.',
    `point_type` STRING COMMENT 'Category that defines what physical quantity the point measures.',
    `reading_frequency_hz` STRING COMMENT 'How often the measurement point records data, expressed in hertz.',
    `sensor_code` BIGINT COMMENT 'Identifier of the sensor device that provides data for this measurement point.',
    `measurement_point_status` STRING COMMENT 'Current operational status of the measurement point.',
    `tolerance` DOUBLE COMMENT 'Allowed deviation from the nominal value before flagging an alert.',
    `unit_of_measure` STRING COMMENT 'Unit in which the measurement is recorded (e.g., °C, bar, mm/s², L/min).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the measurement point record.',
    CONSTRAINT pk_measurement_point PRIMARY KEY(`measurement_point_id`)
) COMMENT 'Master reference table for measurement_point. Referenced by measurement_point_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`asset`.`asset_class` (
    `asset_class_id` BIGINT COMMENT 'Unique surrogate key for each asset class record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Asset class defines a default compliance standard document; linking provides quick reference for class‑level compliance.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Provides default cost center for new assets of this class, supporting automated cost allocation in ERP.',
    `asset_category` STRING COMMENT 'High‑level category grouping for the asset class.. Valid values are `production_machinery|robot|conveyor|tooling|building|utility`',
    `calibration_interval_days` STRING COMMENT 'Number of days between required calibrations.',
    `calibration_required_flag` BOOLEAN COMMENT 'Indicates whether assets of this class must be calibrated periodically.',
    `class_code` STRING COMMENT 'Business code used to reference the asset class in ERP and PLM systems.',
    `class_description` STRING COMMENT 'Detailed textual description of the asset class purpose and scope.',
    `class_name` STRING COMMENT 'Human‑readable name of the asset class (e.g., "Robotic Arm").',
    `class_status` STRING COMMENT 'Current lifecycle state of the asset class.. Valid values are `active|inactive|retired|planned|decommissioned`',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the asset class record was first created.',
    `default_capacity_units_per_hour` DECIMAL(18,2) COMMENT 'Typical production capacity associated with the asset class.',
    `default_cost_amount` DECIMAL(18,2) COMMENT 'Standard cost amount associated with the asset class (e.g., average purchase price).',
    `default_cost_currency` STRING COMMENT 'Currency used for default cost amounts.. Valid values are `USD|EUR|JPY`',
    `default_energy_consumption_kwh_per_hour` DECIMAL(18,2) COMMENT 'Typical energy usage for assets of this class, used for cost and sustainability calculations.',
    `default_environmental_compliance` STRING COMMENT 'Standard environmental regulation applicable to the asset class.. Valid values are `ISO14001|EPA|CARB`',
    `default_lifecycle_phase` STRING COMMENT 'Typical lifecycle phase where assets of this class reside.. Valid values are `design|manufacturing|operation|maintenance|retirement`',
    `default_location_type` STRING COMMENT 'Common location type for assets of this class.. Valid values are `plant|warehouse|field|office`',
    `default_maintenance_cost_per_hour` DECIMAL(18,2) COMMENT 'Standard labor cost applied to maintenance activities for this class.',
    `default_maintenance_interval_days` STRING COMMENT 'Standard interval between scheduled maintenance events.',
    `default_mtbf_hours` DECIMAL(18,2) COMMENT 'Typical MTBF used for planning and reliability analysis.',
    `default_mttr_hours` DECIMAL(18,2) COMMENT 'Typical MTTR used for downtime estimation.',
    `default_power_rating_kw` DECIMAL(18,2) COMMENT 'Standard power rating for the asset class.',
    `default_responsible_department` STRING COMMENT 'Organizational department that typically owns assets of this class.',
    `default_safety_certification_required` BOOLEAN COMMENT 'Indicates whether assets of this class must hold a safety certification.',
    `default_spare_part_policy` STRING COMMENT 'Policy governing spare part inventory for this asset class.. Valid values are `stocked|just_in_time|none`',
    `default_supplier` STRING COMMENT 'Preferred supplier for procurement of assets in this class.',
    `default_warranty_years` STRING COMMENT 'Standard warranty duration offered for assets of this class.',
    `depreciation_end_date` DATE COMMENT 'Date when depreciation ends (end of useful life).',
    `depreciation_method` STRING COMMENT 'Accounting method used to depreciate assets of this class.. Valid values are `straight_line|declining_balance|units_of_production`',
    `depreciation_rate_percent` DECIMAL(18,2) COMMENT 'Annual depreciation rate expressed as a percentage.',
    `depreciation_start_date` DATE COMMENT 'Date when depreciation begins for newly created assets of this class.',
    `effective_from` DATE COMMENT 'Date from which the asset class definition is valid.',
    `effective_until` DATE COMMENT 'Date after which the asset class definition is no longer valid (nullable).',
    `is_depreciable` BOOLEAN COMMENT 'Indicates whether assets of this class are subject to depreciation.',
    `is_maintainable` BOOLEAN COMMENT 'Indicates whether assets of this class require maintenance planning.',
    `maintenance_strategy_default` STRING COMMENT 'Standard maintenance approach applied to assets of this class.. Valid values are `preventive|predictive|reactive`',
    `sap_asset_class_code` STRING COMMENT 'Corresponding SAP S/4HANA PM asset class code for integration.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent update to the asset class record.',
    `useful_life_years` STRING COMMENT 'Expected economic life of assets in this class, in years.',
    CONSTRAINT pk_asset_class PRIMARY KEY(`asset_class_id`)
) COMMENT 'Reference classification taxonomy for manufacturing assets defining asset classes (production machinery, robots, conveyors, tooling, gauges, vehicles, buildings, utilities) with associated depreciation parameters, maintenance strategy defaults, calibration requirements, and SAP asset class codes. Provides standardized classification used across equipment registry, asset valuation, and maintenance planning. Passes First-Class Entity Test with 8+ unique business attributes beyond id/name/code.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ADD CONSTRAINT `fk_asset_equipment_registry_asset_class_id` FOREIGN KEY (`asset_class_id`) REFERENCES `vibe_automotive_v1`.`asset`.`asset_class`(`asset_class_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ADD CONSTRAINT `fk_asset_equipment_registry_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ADD CONSTRAINT `fk_asset_functional_location_parent_location_functional_location_id` FOREIGN KEY (`parent_location_functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_maintenance_equipment_registry_id` FOREIGN KEY (`maintenance_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_maintenance_work_center_id` FOREIGN KEY (`maintenance_work_center_id`) REFERENCES `vibe_automotive_v1`.`asset`.`maintenance_work_center`(`maintenance_work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ADD CONSTRAINT `fk_asset_maintenance_notification_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ADD CONSTRAINT `fk_asset_maintenance_notification_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `vibe_automotive_v1`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ADD CONSTRAINT `fk_asset_equipment_downtime_maintenance_order_id` FOREIGN KEY (`maintenance_order_id`) REFERENCES `vibe_automotive_v1`.`asset`.`maintenance_order`(`maintenance_order_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ADD CONSTRAINT `fk_asset_equipment_downtime_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_maintenance_order_id` FOREIGN KEY (`maintenance_order_id`) REFERENCES `vibe_automotive_v1`.`asset`.`maintenance_order`(`maintenance_order_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ADD CONSTRAINT `fk_asset_equipment_counter_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `vibe_automotive_v1`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ADD CONSTRAINT `fk_asset_equipment_counter_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ADD CONSTRAINT `fk_asset_maintenance_task_list_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `vibe_automotive_v1`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ADD CONSTRAINT `fk_asset_acquisition_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_primary_asset_equipment_registry_id` FOREIGN KEY (`primary_asset_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ADD CONSTRAINT `fk_asset_maintenance_cost_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ADD CONSTRAINT `fk_asset_maintenance_cost_maintenance_equipment_registry_id` FOREIGN KEY (`maintenance_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ADD CONSTRAINT `fk_asset_maintenance_cost_maintenance_order_id` FOREIGN KEY (`maintenance_order_id`) REFERENCES `vibe_automotive_v1`.`asset`.`maintenance_order`(`maintenance_order_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ADD CONSTRAINT `fk_asset_maintenance_cost_spare_parts_catalog_id` FOREIGN KEY (`spare_parts_catalog_id`) REFERENCES `vibe_automotive_v1`.`asset`.`spare_parts_catalog`(`spare_parts_catalog_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ADD CONSTRAINT `fk_asset_equipment_reliability_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ADD CONSTRAINT `fk_asset_condition_monitoring_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ADD CONSTRAINT `fk_asset_condition_monitoring_condition_equipment_registry_id` FOREIGN KEY (`condition_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ADD CONSTRAINT `fk_asset_condition_monitoring_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `vibe_automotive_v1`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_tooling_usage` ADD CONSTRAINT `fk_asset_asset_tooling_usage_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_tooling_usage` ADD CONSTRAINT `fk_asset_asset_tooling_usage_tooling_registry_id` FOREIGN KEY (`tooling_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`tooling_registry`(`tooling_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ADD CONSTRAINT `fk_asset_equipment_transfer_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_inspection_checklist_id` FOREIGN KEY (`inspection_checklist_id`) REFERENCES `vibe_automotive_v1`.`asset`.`inspection_checklist`(`inspection_checklist_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_inspection_equipment_registry_id` FOREIGN KEY (`inspection_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ADD CONSTRAINT `fk_asset_warranty_claim_equipment_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ADD CONSTRAINT `fk_asset_warranty_claim_equipment_warranty_equipment_registry_id` FOREIGN KEY (`warranty_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ADD CONSTRAINT `fk_asset_shutdown_plan_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ADD CONSTRAINT `fk_asset_lubrication_schedule_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ADD CONSTRAINT `fk_asset_lubrication_schedule_lubrication_equipment_registry_id` FOREIGN KEY (`lubrication_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` ADD CONSTRAINT `fk_asset_equipment_service_subscription_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` ADD CONSTRAINT `fk_asset_compliance_assessment_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ADD CONSTRAINT `fk_asset_inspection_checklist_parent_inspection_checklist_id` FOREIGN KEY (`parent_inspection_checklist_id`) REFERENCES `vibe_automotive_v1`.`asset`.`inspection_checklist`(`inspection_checklist_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ADD CONSTRAINT `fk_asset_measurement_point_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ADD CONSTRAINT `fk_asset_measurement_point_parent_measurement_point_id` FOREIGN KEY (`parent_measurement_point_id`) REFERENCES `vibe_automotive_v1`.`asset`.`measurement_point`(`measurement_point_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`asset` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`asset` SET TAGS ('dbx_domain' = 'asset');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` SET TAGS ('dbx_subdomain' = 'equipment_management');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `asset_class_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `asset_condition` SET TAGS ('dbx_business_glossary_term' = 'Asset Condition');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `asset_condition` SET TAGS ('dbx_value_regex' = 'new|good|fair|poor|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `asset_tag` SET TAGS ('dbx_business_glossary_term' = 'Asset Tag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `calibration_last_date` SET TAGS ('dbx_business_glossary_term' = 'Last Calibration Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `calibration_next_due` SET TAGS ('dbx_business_glossary_term' = 'Next Calibration Due Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `calibration_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Calibration Required Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `capital_expenditure_amount` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `decommission_date` SET TAGS ('dbx_business_glossary_term' = 'Decommission Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `depreciation_end_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation End Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|units_of_production');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `depreciation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Start Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `equipment_registry_description` SET TAGS ('dbx_business_glossary_term' = 'Equipment Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `energy_consumption_kwh` SET TAGS ('dbx_business_glossary_term' = 'Energy Consumption (kWh)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `equipment_category` SET TAGS ('dbx_business_glossary_term' = 'Equipment Category');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `equipment_category` SET TAGS ('dbx_value_regex' = 'production|assembly|painting|testing|logistics|utility');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `equipment_registry_status` SET TAGS ('dbx_business_glossary_term' = 'Equipment Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `equipment_registry_status` SET TAGS ('dbx_value_regex' = 'in_service|out_of_service|maintenance|retired|scrapped');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `installation_date` SET TAGS ('dbx_business_glossary_term' = 'Installation Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `lifecycle_phase` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Phase');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `lifecycle_phase` SET TAGS ('dbx_value_regex' = 'design|manufacturing|operational|decommissioned');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `maintenance_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Interval (Days)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Strategy');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_value_regex' = 'preventive|predictive|reactive');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'Model Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `mtbf_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `mttr_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `equipment_registry_name` SET TAGS ('dbx_business_glossary_term' = 'Equipment Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `next_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `operating_cost_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Operating Cost per Hour');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `power_rating_kw` SET TAGS ('dbx_business_glossary_term' = 'Power Rating (kW)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `regulatory_compliance_expiry` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `safety_certification_expiry` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_value_regex' = 'certified|expired|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `warranty_status` SET TAGS ('dbx_business_glossary_term' = 'Warranty Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `warranty_status` SET TAGS ('dbx_value_regex' = 'active|expired|pending');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` SET TAGS ('dbx_subdomain' = 'equipment_management');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Identifier (FL_ID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `parent_location_functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Functional Location Identifier (Parent FL ID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1 (ADDR_LINE1)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2 (ADDR_LINE2)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Area (Square Meters) (AREA_SQM)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `calibration_due_date` SET TAGS ('dbx_business_glossary_term' = 'Calibration Due Date (CAL_DUE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `capacity_units_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Production Capacity (Units per Hour) (CAPACITY_UPH)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `capacity_units_per_hour` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `capital_cost` SET TAGS ('dbx_business_glossary_term' = 'Capital Cost (CAPITAL_COST)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City (CITY)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `functional_location_code` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Code (FLC)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date (COMMISSION_DATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `compliance_iso9001` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Compliance Flag (ISO9001_COMPL)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code (ISO 3166-1 Alpha-3) (COUNTRY_CODE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `decommission_date` SET TAGS ('dbx_business_glossary_term' = 'Decommission Date (DECOM_DATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `depreciation_amount` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Amount (DEPR_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `depreciation_end_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation End Date (DEPR_END_DATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `depreciation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Start Date (DEPR_START_DATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `functional_location_description` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Description (FLD)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `functional_location_status` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Status (FLS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `functional_location_status` SET TAGS ('dbx_value_regex' = 'active|inactive|maintenance|decommissioned|planned');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `functional_location_type` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Type (FLT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `functional_location_type` SET TAGS ('dbx_value_regex' = 'plant|shop|line|station|position|utility');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Level (HL)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `installation_date` SET TAGS ('dbx_business_glossary_term' = 'Installation Date (INST_DATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Asset Flag (IS_CRITICAL)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `is_operational` SET TAGS ('dbx_business_glossary_term' = 'Operational Flag (IS_OPERATIONAL)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date (LAST_MAINT_DATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude (LATITUDE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude (LONGITUDE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `maintenance_cost_yearly` SET TAGS ('dbx_business_glossary_term' = 'Annual Maintenance Cost (MAINT_COST_YEARLY)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `maintenance_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Interval (Days) (MAINT_INTERVAL_DAYS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Strategy (MAINT_STRATEGY)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_value_regex' = 'preventive|predictive|run-to-failure');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Name (MANUFACTURER)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'Model Number (MODEL_NO)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `mtbf_days` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (Days) (MTBF_DAYS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `mttr_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (Hours) (MTTR_HOURS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `functional_location_name` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Name (FLN)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `next_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Maintenance Date (NEXT_MAINT_DATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `oee_overall_pct` SET TAGS ('dbx_business_glossary_term' = 'Overall Equipment Effectiveness (Percentage) (OEE_PCT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code (POSTAL_CODE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department (RESP_DEPT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Status (SAFETY_CERT_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_value_regex' = 'certified|pending|expired');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number (SERIAL_NO)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `state` SET TAGS ('dbx_business_glossary_term' = 'State/Province (STATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `state` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ALTER COLUMN `state` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` SET TAGS ('dbx_subdomain' = 'equipment_management');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `tooling_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Tooling Registry Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `asset_tag` SET TAGS ('dbx_business_glossary_term' = 'Asset Tag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `calibration_date` SET TAGS ('dbx_business_glossary_term' = 'Last Calibration Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `calibration_due_date` SET TAGS ('dbx_business_glossary_term' = 'Calibration Due Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `calibration_status` SET TAGS ('dbx_business_glossary_term' = 'Calibration Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `calibration_status` SET TAGS ('dbx_value_regex' = 'calibrated|due|overdue');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Tool Cost (USD)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `custodian_plant` SET TAGS ('dbx_business_glossary_term' = 'Custodian Plant');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `tooling_registry_description` SET TAGS ('dbx_business_glossary_term' = 'Tool Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `dimensions_mm` SET TAGS ('dbx_business_glossary_term' = 'Dimensions (mm)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `maintenance_schedule` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Schedule');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `maintenance_schedule` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|annual|none');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `material` SET TAGS ('dbx_business_glossary_term' = 'Material');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `mtbf_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `mttr_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `next_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `plant_location` SET TAGS ('dbx_business_glossary_term' = 'Plant Location Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `purchase_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `remaining_shots` SET TAGS ('dbx_business_glossary_term' = 'Remaining Shots');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `shots_used` SET TAGS ('dbx_business_glossary_term' = 'Shots Used');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `tool_code` SET TAGS ('dbx_business_glossary_term' = 'Tool Code (Unique Identifier)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `tool_life_shots` SET TAGS ('dbx_business_glossary_term' = 'Tool Design Life (Shots)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `tool_name` SET TAGS ('dbx_business_glossary_term' = 'Tool Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `tool_type` SET TAGS ('dbx_business_glossary_term' = 'Tool Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `tool_type` SET TAGS ('dbx_value_regex' = 'stamping_die|injection_mold|welding_fixture|cmm_fixture|gauge|jig');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `tooling_registry_status` SET TAGS ('dbx_business_glossary_term' = 'Tool Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `tooling_registry_status` SET TAGS ('dbx_value_regex' = 'active|inactive|retired|maintenance|decommissioned');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `vehicle_model` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `vendor_contract_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `warranty_expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_responsible_person_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_responsible_person_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_responsible_person_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_plan_category` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Category');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_plan_category` SET TAGS ('dbx_value_regex' = 'routine|major|overhaul|inspection');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_value_regex' = 'IATF16949|ISO9001|ISO14001|EPA|NHTSA');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `cost_estimate_amount` SET TAGS ('dbx_business_glossary_term' = 'Cost Estimate Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `cost_estimate_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Estimate Currency');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `cost_estimate_currency` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP|CAD');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_plan_description` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `downtime_estimate_hours` SET TAGS ('dbx_business_glossary_term' = 'Downtime Estimate (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Plan End Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `interval_unit` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Interval Unit');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `interval_unit` SET TAGS ('dbx_value_regex' = 'day|week|month|hour|kilometer|mile');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `interval_value` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Interval Value');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'planned|in_service|retired|decommissioned');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_plan_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|draft|retired|pending');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Type (Preventive, Predictive, Corrective)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_value_regex' = 'preventive|predictive|corrective');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_window` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Window');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_window` SET TAGS ('dbx_value_regex' = 'night_shift|weekend|anytime');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `next_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Notes');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `parts_list_reference` SET TAGS ('dbx_business_glossary_term' = 'Parts List Reference');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `parts_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Parts Required Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_value_regex' = '^MP-[A-Z0-9]{6}$');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Priority');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `safety_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Safety Risk Level');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `safety_risk_level` SET TAGS ('dbx_value_regex' = 'low|moderate|high|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `schedule_type` SET TAGS ('dbx_business_glossary_term' = 'Schedule Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `schedule_type` SET TAGS ('dbx_value_regex' = 'time_based|counter_based|condition_based');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Plan Start Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `maintenance_order_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID (APPRID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `approver_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID (APPRID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location ID (FLID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `maintenance_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requester ID (REQID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `maintenance_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `maintenance_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID (EQID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `maintenance_equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID (EQID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `maintenance_work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant ID (PID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `primary_maintenance_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requester ID (REQID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `primary_maintenance_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `primary_maintenance_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `actual_finish_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Finish Timestamp (AFT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp (AST)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status (CS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|exempt');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CCY)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `maintenance_order_description` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order Description (MOD)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `downtime_minutes` SET TAGS ('dbx_business_glossary_term' = 'Downtime Minutes (DTM)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `external_service_provider` SET TAGS ('dbx_business_glossary_term' = 'External Service Provider (ESP)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `is_emergency` SET TAGS ('dbx_business_glossary_term' = 'Emergency Maintenance Flag (EMF)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `labor_cost_actual` SET TAGS ('dbx_business_glossary_term' = 'Actual Labor Cost (ALC)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `labor_cost_estimated` SET TAGS ('dbx_business_glossary_term' = 'Estimated Labor Cost (ELC)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `labor_hours_actual` SET TAGS ('dbx_business_glossary_term' = 'Actual Labor Hours (ALH)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `labor_hours_estimated` SET TAGS ('dbx_business_glossary_term' = 'Estimated Labor Hours (ELH)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `maintenance_order_status` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order Status (MOS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `maintenance_order_status` SET TAGS ('dbx_value_regex' = 'planned|released|in_progress|completed|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Strategy (MS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_value_regex' = 'run_based|time_based|condition_based');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `material_cost_actual` SET TAGS ('dbx_business_glossary_term' = 'Actual Material Cost (AMC)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `material_cost_estimated` SET TAGS ('dbx_business_glossary_term' = 'Estimated Material Cost (EMC)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `mttr_minutes` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (MTTR) Minutes (MTTRM)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes (AN)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `oem_part_number` SET TAGS ('dbx_business_glossary_term' = 'OEM Part Number (OEMPN)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order Number (MOTN)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order Type (MOT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'corrective|preventive|predictive');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `parts_used` SET TAGS ('dbx_business_glossary_term' = 'Parts Used (PU)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `planned_finish_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Finish Date (PFD)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date (PSD)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order Priority (MOP)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `safety_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Flag (SF)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `total_cost` SET TAGS ('dbx_business_glossary_term' = 'Total Maintenance Cost (TMC)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ALTER COLUMN `warranty_claim_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Flag (WCF)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `maintenance_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Notification ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reported By ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `maintenance_reported_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reported By ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `maintenance_reported_by_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `maintenance_reported_by_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `activity_code` SET TAGS ('dbx_business_glossary_term' = 'Activity Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `asset_tag` SET TAGS ('dbx_business_glossary_term' = 'Asset Tag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `breakdown_indicator` SET TAGS ('dbx_business_glossary_term' = 'Breakdown Indicator');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `cause_code` SET TAGS ('dbx_business_glossary_term' = 'Cause Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `corrective_action` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `cost_estimate` SET TAGS ('dbx_business_glossary_term' = 'Cost Estimate');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `downtime_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Downtime Reason Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `estimated_downtime_minutes` SET TAGS ('dbx_business_glossary_term' = 'Estimated Downtime (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `location` SET TAGS ('dbx_business_glossary_term' = 'Location');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `maintenance_category` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Category');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `maintenance_group` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Group');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `maintenance_notification_status` SET TAGS ('dbx_business_glossary_term' = 'Notification Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `maintenance_notification_status` SET TAGS ('dbx_value_regex' = 'new|in_progress|resolved|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `mtbf_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `mttr_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `next_scheduled_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `notification_number` SET TAGS ('dbx_business_glossary_term' = 'Notification Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Notification Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `notification_type` SET TAGS ('dbx_business_glossary_term' = 'Notification Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `notification_type` SET TAGS ('dbx_value_regex' = 'malfunction|activity|maintenance_request');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `oem_notification_flag` SET TAGS ('dbx_business_glossary_term' = 'OEM Notification Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `parts_list` SET TAGS ('dbx_business_glossary_term' = 'Parts List');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `parts_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Parts Required Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `planned_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `planned_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Notification Priority');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `regulatory_report_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Report Required');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `reported_by_name` SET TAGS ('dbx_business_glossary_term' = 'Reported By Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `root_cause_analysis` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `safety_risk_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Risk Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Notification Severity');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'minor|major|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `shift` SET TAGS ('dbx_business_glossary_term' = 'Shift');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `shift` SET TAGS ('dbx_value_regex' = 'day|swing|night');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ALTER COLUMN `work_center` SET TAGS ('dbx_business_glossary_term' = 'Work Center');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` SET TAGS ('dbx_subdomain' = 'equipment_management');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `equipment_downtime_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Downtime Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `equipment_operator_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `equipment_operator_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `equipment_operator_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `maintenance_order_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `cause_severity` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Severity');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `cause_severity` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Downtime Comments');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `cost_of_downtime` SET TAGS ('dbx_business_glossary_term' = 'Cost of Downtime');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `downtime_category` SET TAGS ('dbx_business_glossary_term' = 'Downtime Category');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `downtime_category` SET TAGS ('dbx_value_regex' = 'mechanical_failure|electrical_fault|tooling_change|planned_maintenance|material_shortage|other');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `downtime_event_number` SET TAGS ('dbx_business_glossary_term' = 'Downtime Event Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `downtime_percentage` SET TAGS ('dbx_business_glossary_term' = 'Downtime Percentage of Scheduled Time');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `downtime_reason_group` SET TAGS ('dbx_business_glossary_term' = 'Downtime Reason Group');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `downtime_reported_by` SET TAGS ('dbx_business_glossary_term' = 'Downtime Reported By');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `downtime_reported_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Downtime Reported Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `downtime_source_system` SET TAGS ('dbx_business_glossary_term' = 'Downtime Source System');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Downtime Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Downtime End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `equipment_downtime_status` SET TAGS ('dbx_business_glossary_term' = 'Downtime Event Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `equipment_downtime_status` SET TAGS ('dbx_value_regex' = 'open|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Downtime Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `lost_units` SET TAGS ('dbx_business_glossary_term' = 'Lost Production Units');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_value_regex' = 'planned|unplanned');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `oee_impact_percentage` SET TAGS ('dbx_business_glossary_term' = 'OEE Impact Percentage');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `repair_action_taken` SET TAGS ('dbx_business_glossary_term' = 'Repair Action Taken');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `scheduled_maintenance_flag` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Maintenance Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `shift` SET TAGS ('dbx_business_glossary_term' = 'Work Shift');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `shift` SET TAGS ('dbx_value_regex' = 'day|night|swing');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `spare_part_quantity` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Quantity');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `spare_part_used` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Used');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Downtime Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` SET TAGS ('dbx_subdomain' = 'quality_assurance');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_record_id` SET TAGS ('dbx_business_glossary_term' = 'Calibration Record ID (CAL_REC_ID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Identifier (Asset ID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `maintenance_order_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order Identifier (MO_ID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_cost` SET TAGS ('dbx_business_glossary_term' = 'Calibration Cost (CAL_COST)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_date` SET TAGS ('dbx_business_glossary_term' = 'Calibration Date (CAL_DATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Calibration Interval (Days) (CAL_INT_DAYS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_label` SET TAGS ('dbx_business_glossary_term' = 'Calibration Record Label (CAL_LABEL)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_method` SET TAGS ('dbx_business_glossary_term' = 'Calibration Method (CAL_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_method` SET TAGS ('dbx_value_regex' = 'in_house|external');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_number` SET TAGS ('dbx_business_glossary_term' = 'Calibration Record Number (CAL_NUM)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_record_status` SET TAGS ('dbx_business_glossary_term' = 'Calibration Status (CAL_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_record_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|failed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_report_url` SET TAGS ('dbx_business_glossary_term' = 'Calibration Report URL (CAL_REPORT_URL)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_standard` SET TAGS ('dbx_business_glossary_term' = 'Calibration Standard Reference (CAL_STD)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_type` SET TAGS ('dbx_business_glossary_term' = 'Calibration Type (CAL_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `calibration_type` SET TAGS ('dbx_value_regex' = 'dimensional|electrical|functional|temperature|pressure');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Calibration Comments (CAL_COMMENTS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CURR_CODE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP|CAD');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Calibration Due Date (CAL_DUE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `lab_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Certificate Number (LAB_CERT_NO)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `laboratory_name` SET TAGS ('dbx_business_glossary_term' = 'Accredited Laboratory Name (LAB_NAME)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `measurement_uncertainty` SET TAGS ('dbx_business_glossary_term' = 'Measurement Uncertainty (UNCERTAINTY)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `result` SET TAGS ('dbx_business_glossary_term' = 'Calibration Result (CAL_RESULT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `result` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `uncertainty_unit` SET TAGS ('dbx_business_glossary_term' = 'Uncertainty Unit of Measure (UNCERTAINTY_UOM)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `uncertainty_unit` SET TAGS ('dbx_value_regex' = 'µm|mm|nm|%');
ALTER TABLE `vibe_automotive_v1`.`asset`.`calibration_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` SET TAGS ('dbx_subdomain' = 'equipment_management');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `equipment_counter_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Counter ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `cumulative_counter` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Counter');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `delta_counter` SET TAGS ('dbx_business_glossary_term' = 'Delta Counter');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `equipment_counter_status` SET TAGS ('dbx_business_glossary_term' = 'Record Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `equipment_counter_status` SET TAGS ('dbx_value_regex' = 'active|archived|invalid');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `maintenance_action` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Action');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `maintenance_action` SET TAGS ('dbx_value_regex' = 'inspection|repair|replace|none');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `maintenance_due_date` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Due Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `maintenance_trigger_flag` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Trigger Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `plant_location` SET TAGS ('dbx_business_glossary_term' = 'Plant Location');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `reading_quality` SET TAGS ('dbx_business_glossary_term' = 'Reading Quality');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `reading_quality` SET TAGS ('dbx_value_regex' = 'good|questionable|invalid');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `reading_type` SET TAGS ('dbx_business_glossary_term' = 'Reading Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `reading_type` SET TAGS ('dbx_value_regex' = 'operating_hours|production_cycles|stroke_count|mileage|temperature|pressure');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `reading_value` SET TAGS ('dbx_business_glossary_term' = 'Counter Reading Value');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `recorded_by` SET TAGS ('dbx_business_glossary_term' = 'Recorded By');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `recorded_by_role` SET TAGS ('dbx_business_glossary_term' = 'Recorder Role');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `recorded_by_role` SET TAGS ('dbx_value_regex' = 'operator|system|automated');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `sensor_calibration_date` SET TAGS ('dbx_business_glossary_term' = 'Sensor Calibration Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `sensor_calibration_due_date` SET TAGS ('dbx_business_glossary_term' = 'Sensor Calibration Due Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `sensor_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Sensor Serial Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `shift` SET TAGS ('dbx_business_glossary_term' = 'Production Shift');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `shift` SET TAGS ('dbx_value_regex' = 'day|swing|night');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'hours|cycles|km|strokes|temperature|pressure');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_counter` ALTER COLUMN `work_center` SET TAGS ('dbx_business_glossary_term' = 'Work Center');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` SET TAGS ('dbx_subdomain' = 'tooling_resources');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `spare_parts_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Catalog ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `cad_file_reference` SET TAGS ('dbx_business_glossary_term' = 'CAD File Reference (CAD_REF)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `compliance_certifications` SET TAGS ('dbx_business_glossary_term' = 'Compliance Certifications (COMPLIANCE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CURR)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CAD|AUD');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `dimensions_mm` SET TAGS ('dbx_business_glossary_term' = 'Dimensions (mm)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `drawing_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Drawing Number (DRW_NO)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `eol_date` SET TAGS ('dbx_business_glossary_term' = 'End of Life Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date (EXP_DATE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Part Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `is_obsolete` SET TAGS ('dbx_business_glossary_term' = 'Obsolete Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `list_price_usd` SET TAGS ('dbx_business_glossary_term' = 'List Price (USD)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code (LOC_CODE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Lot Number (LOT_NO)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `maintenance_interval_hours` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Interval (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Strategy (MSTRATEGY)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_value_regex' = 'preventive|predictive|reactive');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `manufacturer_name` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Name (MFG_NAME)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `manufacturer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Part Number (MPN)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `max_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Quantity (MAX_QTY)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `mean_time_between_failures_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `min_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `part_category` SET TAGS ('dbx_business_glossary_term' = 'Part Category (PCAT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `part_description` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Description (PDESC)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `part_family` SET TAGS ('dbx_business_glossary_term' = 'Part Family (PFAMILY)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `part_group` SET TAGS ('dbx_business_glossary_term' = 'Part Group (PGROUP)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `part_name` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Name (PNAME)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Number (PN)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision (PREV)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `part_subcategory` SET TAGS ('dbx_business_glossary_term' = 'Part Subcategory (PSUBCAT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `part_type` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Type (PTYPE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `part_type` SET TAGS ('dbx_value_regex' = 'mechanical|electrical|hydraulic|software|consumable');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `regulatory_approval_code` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Code (REG_CODE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `reorder_point_quantity` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point Quantity (ROP_QTY)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `safety_rating` SET TAGS ('dbx_business_glossary_term' = 'Safety Rating (SRATING)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `safety_rating` SET TAGS ('dbx_value_regex' = 'A|B|C|D|E');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity (SS_QTY)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `spare_parts_catalog_status` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Lifecycle Status (PSTATUS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `spare_parts_catalog_status` SET TAGS ('dbx_value_regex' = 'active|inactive|discontinued|pending');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Current Stock Quantity (STOCK_QTY)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code (SUPP_CODE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `uom` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `uom` SET TAGS ('dbx_value_regex' = 'EA|SET|KG|L');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period (Months)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `maintenance_task_list_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Task List ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `applicable_asset_type` SET TAGS ('dbx_business_glossary_term' = 'Applicable Asset Type (AAT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `author` SET TAGS ('dbx_business_glossary_term' = 'Author (AU)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `author` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `author` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard (CS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_value_regex' = 'ISO 14224|IATF 16949|ISO 9001|ISO 14001');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `cost_estimate_amount` SET TAGS ('dbx_business_glossary_term' = 'Cost Estimate Amount (CEA)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `cost_estimate_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Estimate Currency (CEC)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `cost_estimate_currency` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CNY|CAD');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `criticality` SET TAGS ('dbx_business_glossary_term' = 'Task Criticality (TC)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `criticality` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `maintenance_task_list_description` SET TAGS ('dbx_business_glossary_term' = 'Task Description (TD)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date (EED)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date (ESD)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `environmental_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Flag (EIF)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `equipment_category` SET TAGS ('dbx_business_glossary_term' = 'Equipment Category (EC)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `estimated_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration (Minutes) (ED)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `estimated_labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Labor Hours (ELH)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `frequency_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Frequency Interval Days (FID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `frequency_interval_months` SET TAGS ('dbx_business_glossary_term' = 'Frequency Interval Months (FIM)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `is_deprecated` SET TAGS ('dbx_business_glossary_term' = 'Is Deprecated Flag (IDF)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By (LMB)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `maintenance_task_list_status` SET TAGS ('dbx_business_glossary_term' = 'Task List Status (TLS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `maintenance_task_list_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Type (MT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_value_regex' = 'preventive|predictive|corrective|inspection|calibration');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `overtime_allowed` SET TAGS ('dbx_business_glossary_term' = 'Overtime Allowed Flag (OAF)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Task Priority (TP)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference (RR)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `required_materials` SET TAGS ('dbx_business_glossary_term' = 'Required Materials (RM)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `required_skill_level` SET TAGS ('dbx_business_glossary_term' = 'Required Skill Level (RSL)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `required_skill_level` SET TAGS ('dbx_value_regex' = 'basic|intermediate|advanced|expert');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `required_tools` SET TAGS ('dbx_business_glossary_term' = 'Required Tools (RT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `requires_approval` SET TAGS ('dbx_business_glossary_term' = 'Requires Approval Flag (RAF)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `revision_date` SET TAGS ('dbx_business_glossary_term' = 'Revision Date (RD)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `safety_instructions` SET TAGS ('dbx_business_glossary_term' = 'Safety Instructions (SI)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `safety_rating` SET TAGS ('dbx_business_glossary_term' = 'Safety Rating (SR)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `safety_rating` SET TAGS ('dbx_value_regex' = 'low|moderate|high|extreme');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `task_code` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Task Code (MTC)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `task_name` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Task Name (MTN)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number (VN)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_task_list` ALTER COLUMN `work_order_template_code` SET TAGS ('dbx_business_glossary_term' = 'Work Order Template ID (WOTID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` SET TAGS ('dbx_subdomain' = 'financial_tracking');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `acquisition_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Acquisition ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Location ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `acquisition_number` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `acquisition_status` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `acquisition_status` SET TAGS ('dbx_value_regex' = 'planned|ordered|received|installed|active|retired');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `acquisition_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `asset_category` SET TAGS ('dbx_business_glossary_term' = 'Asset Category');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `asset_condition` SET TAGS ('dbx_business_glossary_term' = 'Asset Condition');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `asset_condition` SET TAGS ('dbx_value_regex' = 'new|used|refurbished');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `asset_subcategory` SET TAGS ('dbx_business_glossary_term' = 'Asset Subcategory');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `asset_tag` SET TAGS ('dbx_business_glossary_term' = 'Asset Tag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `asset_type` SET TAGS ('dbx_business_glossary_term' = 'Asset Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `asset_type` SET TAGS ('dbx_value_regex' = 'machinery|tooling|fixture|infrastructure|robot|conveyor');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `budget_line_item` SET TAGS ('dbx_business_glossary_term' = 'Budget Line Item');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `capex_project_code` SET TAGS ('dbx_business_glossary_term' = 'CapEx Project Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|double_declining|units_of_production');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `depreciation_period_years` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Period (Years)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `expected_mtbf_hours` SET TAGS ('dbx_business_glossary_term' = 'Expected MTBF (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `expected_mttr_hours` SET TAGS ('dbx_business_glossary_term' = 'Expected MTTR (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `finance_account_code` SET TAGS ('dbx_business_glossary_term' = 'Finance Account Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `installation_cost` SET TAGS ('dbx_business_glossary_term' = 'Installation Cost');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `maintenance_contract_flag` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Contract Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'Model Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `sop_readiness_date` SET TAGS ('dbx_business_glossary_term' = 'SOP Readiness Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `total_gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `total_net_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Net Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `total_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life (Years)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` SET TAGS ('dbx_subdomain' = 'financial_tracking');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `asset_valuation_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Valuation ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `primary_asset_equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `accumulated_depreciation` SET TAGS ('dbx_business_glossary_term' = 'Accumulated Depreciation');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `amount` SET TAGS ('dbx_business_glossary_term' = 'Valuation Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `asset_valuation_status` SET TAGS ('dbx_business_glossary_term' = 'Valuation Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `asset_valuation_status` SET TAGS ('dbx_value_regex' = 'active|inactive|superseded|archived');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `book_value_after_valuation` SET TAGS ('dbx_business_glossary_term' = 'Book Value After Valuation');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `book_value_before_valuation` SET TAGS ('dbx_business_glossary_term' = 'Book Value Before Valuation');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `depreciation_end_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation End Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `depreciation_expense_current_year` SET TAGS ('dbx_business_glossary_term' = 'Current Year Depreciation Expense');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|units_of_production');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `depreciation_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Rate (%)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `depreciation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Start Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `impairment_amount` SET TAGS ('dbx_business_glossary_term' = 'Impairment Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `impairment_indicator` SET TAGS ('dbx_business_glossary_term' = 'Impairment Indicator');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `net_book_value` SET TAGS ('dbx_business_glossary_term' = 'Net Book Value');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Valuation Notes');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `reason` SET TAGS ('dbx_business_glossary_term' = 'Valuation Reason');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `residual_value` SET TAGS ('dbx_business_glossary_term' = 'Residual Value');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `revaluation_amount` SET TAGS ('dbx_business_glossary_term' = 'Revaluation Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `revaluation_flag` SET TAGS ('dbx_business_glossary_term' = 'Revaluation Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life (Years)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `valuation_date` SET TAGS ('dbx_business_glossary_term' = 'Valuation Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `valuation_name` SET TAGS ('dbx_business_glossary_term' = 'Valuation Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `valuation_number` SET TAGS ('dbx_business_glossary_term' = 'Valuation Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `valuation_type` SET TAGS ('dbx_business_glossary_term' = 'Valuation Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `valuation_type` SET TAGS ('dbx_value_regex' = 'initial|periodic|impairment|revaluation');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `maintenance_cost_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Cost ID (MCID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID (EQID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `maintenance_equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID (EQID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `maintenance_order_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order ID (MOID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `spare_parts_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Catalog Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `consumables_cost` SET TAGS ('dbx_business_glossary_term' = 'Consumables Cost');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `cost_category` SET TAGS ('dbx_business_glossary_term' = 'Cost Category');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `cost_category` SET TAGS ('dbx_value_regex' = 'labor|material|external_service|spare_parts|consumables');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `cost_object_reference` SET TAGS ('dbx_business_glossary_term' = 'Cost Object ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `cost_type` SET TAGS ('dbx_business_glossary_term' = 'Cost Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `cost_type` SET TAGS ('dbx_value_regex' = 'planned|actual');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CNY|CAD');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `downtime_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Downtime Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `external_service_cost` SET TAGS ('dbx_business_glossary_term' = 'External Service Cost');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `functional_location` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `labor_cost` SET TAGS ('dbx_business_glossary_term' = 'Labor Cost');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Labor Hours');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `labor_rate` SET TAGS ('dbx_business_glossary_term' = 'Labor Rate (Currency per Hour)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `line_quantity` SET TAGS ('dbx_business_glossary_term' = 'Line Quantity');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `line_sequence` SET TAGS ('dbx_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `maintenance_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Maintenance End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `maintenance_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `maintenance_status` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `maintenance_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|canceled');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_value_regex' = 'preventive|corrective|predictive|inspection');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `material_cost` SET TAGS ('dbx_business_glossary_term' = 'Material Cost');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `material_quantity` SET TAGS ('dbx_business_glossary_term' = 'Material Quantity');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `material_uom` SET TAGS ('dbx_business_glossary_term' = 'Material Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `material_uom` SET TAGS ('dbx_value_regex' = 'pcs|kg|l|m|m2|m3');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `mtbf_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (MTBF) Hours');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `mttr_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (MTTR) Hours');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `settlement_status` SET TAGS ('dbx_business_glossary_term' = 'Settlement Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `settlement_status` SET TAGS ('dbx_value_regex' = 'pending|settled|rejected');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `spare_parts_cost` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Cost');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `total_cost` SET TAGS ('dbx_business_glossary_term' = 'Total Maintenance Cost');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `warranty_expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `warranty_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ALTER COLUMN `work_center` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` SET TAGS ('dbx_subdomain' = 'equipment_management');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `equipment_reliability_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Reliability Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `availability_percentage` SET TAGS ('dbx_business_glossary_term' = 'Equipment Availability (%)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `data_quality_score` SET TAGS ('dbx_business_glossary_term' = 'Data Quality Score');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `failure_rate_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Failure Rate (Failures per Hour)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `maintenance_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `maintenance_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Cost Currency');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `maintenance_cost_currency` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CNY|CAD');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `mean_time_between_failures_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `mean_time_to_repair_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `number_of_failures` SET TAGS ('dbx_business_glossary_term' = 'Number of Failures');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `oee_availability_percentage` SET TAGS ('dbx_business_glossary_term' = 'OEE Availability Component (%)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `oee_performance_percentage` SET TAGS ('dbx_business_glossary_term' = 'OEE Performance Component (%)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `oee_quality_percentage` SET TAGS ('dbx_business_glossary_term' = 'OEE Quality Component (%)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `overall_oee_percentage` SET TAGS ('dbx_business_glossary_term' = 'Overall Equipment Effectiveness (%)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `plant_location` SET TAGS ('dbx_business_glossary_term' = 'Plant Location');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `record_name` SET TAGS ('dbx_business_glossary_term' = 'Reliability Record Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `reliability_category` SET TAGS ('dbx_business_glossary_term' = 'Reliability Category');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `reliability_category` SET TAGS ('dbx_value_regex' = 'preventive|corrective|predictive|unscheduled');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `reliability_code` SET TAGS ('dbx_business_glossary_term' = 'Reliability Record Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `reliability_status` SET TAGS ('dbx_business_glossary_term' = 'Reliability Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `reliability_status` SET TAGS ('dbx_value_regex' = 'good|degraded|poor|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `reporting_period_end` SET TAGS ('dbx_business_glossary_term' = 'Reporting Period End Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `reporting_period_start` SET TAGS ('dbx_business_glossary_term' = 'Reporting Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `total_downtime_minutes` SET TAGS ('dbx_business_glossary_term' = 'Total Downtime (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `total_uptime_minutes` SET TAGS ('dbx_business_glossary_term' = 'Total Uptime (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_reliability` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `condition_monitoring_id` SET TAGS ('dbx_business_glossary_term' = 'Condition Monitoring Record ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `condition_equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `condition_operator_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `condition_operator_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `condition_operator_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `anomaly_detected` SET TAGS ('dbx_business_glossary_term' = 'Anomaly Detected Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `anomaly_score` SET TAGS ('dbx_business_glossary_term' = 'Anomaly Score');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `battery_level_percent` SET TAGS ('dbx_business_glossary_term' = 'Battery Level Percentage');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `calibration_status` SET TAGS ('dbx_business_glossary_term' = 'Calibration Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `calibration_status` SET TAGS ('dbx_value_regex' = 'calibrated|due|overdue');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `comment` SET TAGS ('dbx_business_glossary_term' = 'Comment');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `condition_monitoring_status` SET TAGS ('dbx_business_glossary_term' = 'Condition Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `condition_monitoring_status` SET TAGS ('dbx_value_regex' = 'normal|warning|critical|offline');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `data_quality_flag` SET TAGS ('dbx_business_glossary_term' = 'Data Quality Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `equipment_status` SET TAGS ('dbx_business_glossary_term' = 'Equipment Operational Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `equipment_status` SET TAGS ('dbx_value_regex' = 'operational|maintenance|failed|idle');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `firmware_version` SET TAGS ('dbx_business_glossary_term' = 'Firmware Version');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `location` SET TAGS ('dbx_business_glossary_term' = 'Sensor Location');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `maintenance_action_required` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Action Required');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `measurement_type` SET TAGS ('dbx_business_glossary_term' = 'Measurement Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `measurement_type` SET TAGS ('dbx_value_regex' = 'vibration|temperature|oil_analysis|acoustic|current|pressure');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `measurement_value` SET TAGS ('dbx_business_glossary_term' = 'Measurement Value');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `plant` SET TAGS ('dbx_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `predicted_time_to_failure_hours` SET TAGS ('dbx_business_glossary_term' = 'Predicted Time To Failure (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `recorded_by_system` SET TAGS ('dbx_business_glossary_term' = 'Recording System');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `recorded_by_system` SET TAGS ('dbx_value_regex' = 'bosch_iot|geotab|custom');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `reliability_score` SET TAGS ('dbx_business_glossary_term' = 'Reliability Score');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `sensor_code` SET TAGS ('dbx_business_glossary_term' = 'Sensor Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `signal_strength_dbm` SET TAGS ('dbx_business_glossary_term' = 'Signal Strength (dBm)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `threshold_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Threshold Breach Indicator');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `threshold_value` SET TAGS ('dbx_business_glossary_term' = 'Threshold Value');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'mm_per_s|celsius|ppm|db|ampere|bar');
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_tooling_usage` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_tooling_usage` SET TAGS ('dbx_subdomain' = 'tooling_resources');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_tooling_usage` ALTER COLUMN `asset_tooling_usage_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for asset_tooling_usage');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_tooling_usage` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_tooling_usage` ALTER COLUMN `tooling_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Tooling Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` SET TAGS ('dbx_subdomain' = 'equipment_management');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `equipment_transfer_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Transfer ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `equipment_responsible_engineer_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `equipment_responsible_engineer_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `equipment_responsible_engineer_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `depreciation_amount_after` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Amount (After) USD');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `depreciation_amount_before` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Amount (Before) USD');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `destination_functional_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Functional Location');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `equipment_condition_after` SET TAGS ('dbx_business_glossary_term' = 'Equipment Condition After Transfer');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `equipment_condition_after` SET TAGS ('dbx_value_regex' = 'good|fair|poor|damaged');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `equipment_condition_before` SET TAGS ('dbx_business_glossary_term' = 'Equipment Condition Before Transfer');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `equipment_condition_before` SET TAGS ('dbx_value_regex' = 'good|fair|poor|damaged');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `equipment_transfer_status` SET TAGS ('dbx_business_glossary_term' = 'Transfer Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `equipment_transfer_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `installation_status` SET TAGS ('dbx_business_glossary_term' = 'Installation Status at Destination');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `installation_status` SET TAGS ('dbx_value_regex' = 'installed|not_installed|pending');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `mtbf_hours_after` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (After) Hours');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `mtbf_hours_before` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (Before) Hours');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Transfer Notes');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Transfer Reason Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `reason_code` SET TAGS ('dbx_value_regex' = 'line_rebalancing|plant_consolidation|program_changeover|maintenance|other');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `source_functional_location` SET TAGS ('dbx_business_glossary_term' = 'Source Functional Location');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `transfer_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Transfer Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `transfer_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Transfer Cost Currency');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `transfer_date` SET TAGS ('dbx_business_glossary_term' = 'Transfer Date and Time');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `transfer_number` SET TAGS ('dbx_business_glossary_term' = 'Transfer Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `transfer_order_reference` SET TAGS ('dbx_business_glossary_term' = 'External Transfer Order Reference');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `transport_method` SET TAGS ('dbx_business_glossary_term' = 'Transport Method');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `transport_method` SET TAGS ('dbx_value_regex' = 'truck|rail|ship|air|internal');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `warranty_status_after` SET TAGS ('dbx_business_glossary_term' = 'Warranty Status After Transfer');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `warranty_status_after` SET TAGS ('dbx_value_regex' = 'valid|expired|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `warranty_status_before` SET TAGS ('dbx_business_glossary_term' = 'Warranty Status Before Transfer');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ALTER COLUMN `warranty_status_before` SET TAGS ('dbx_value_regex' = 'valid|expired|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Work Center Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_responsible_person_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_responsible_person_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_responsible_person_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `capacity_per_shift` SET TAGS ('dbx_business_glossary_term' = 'Capacity Per Shift');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `capacity_per_shift` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `certification_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Certification Required Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `compliance_iso9001` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_work_center_description` SET TAGS ('dbx_business_glossary_term' = 'Work Center Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `downtime_estimate_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Downtime (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `equipment_category` SET TAGS ('dbx_business_glossary_term' = 'Equipment Category');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `functional_area` SET TAGS ('dbx_business_glossary_term' = 'Functional Area');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `headcount` SET TAGS ('dbx_business_glossary_term' = 'Headcount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `hourly_rate` SET TAGS ('dbx_business_glossary_term' = 'Hourly Labor Rate');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `hourly_rate_currency` SET TAGS ('dbx_business_glossary_term' = 'Hourly Rate Currency');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `hourly_rate_currency` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CNY');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Work Center Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `is_operational` SET TAGS ('dbx_business_glossary_term' = 'Operational Work Center Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `labor_cost_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Labor Cost Rate Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `labor_cost_rate_currency` SET TAGS ('dbx_business_glossary_term' = 'Labor Cost Rate Currency');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `labor_cost_rate_currency` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CNY');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Interval (Days)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Strategy');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_value_regex' = 'preventive|predictive|reactive');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_window` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Window');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_window` SET TAGS ('dbx_value_regex' = 'night|weekend|any');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_work_center_status` SET TAGS ('dbx_business_glossary_term' = 'Work Center Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `maintenance_work_center_status` SET TAGS ('dbx_value_regex' = 'active|inactive|planned|closed');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `mean_time_between_failures_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `mean_time_to_repair_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `next_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `oee_target_pct` SET TAGS ('dbx_business_glossary_term' = 'Overall Equipment Effectiveness Target (%)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `parts_list_reference` SET TAGS ('dbx_business_glossary_term' = 'Parts List Reference');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `parts_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Parts Required Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `plant_location_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Location Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Work Center Priority');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_value_regex' = 'valid|expired|pending');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `safety_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Safety Risk Level');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `safety_risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_value_regex' = 'single|double|triple');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `skill_level_required` SET TAGS ('dbx_business_glossary_term' = 'Skill Level Required');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `skill_level_required` SET TAGS ('dbx_value_regex' = 'basic|intermediate|advanced|expert');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `work_center_group` SET TAGS ('dbx_business_glossary_term' = 'Work Center Group');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `work_center_name` SET TAGS ('dbx_business_glossary_term' = 'Work Center Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `work_center_type` SET TAGS ('dbx_business_glossary_term' = 'Work Center Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ALTER COLUMN `work_center_type` SET TAGS ('dbx_value_regex' = 'electrical|mechanical|hydraulics|robotics|tooling|facility');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` SET TAGS ('dbx_subdomain' = 'quality_assurance');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Inspection ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Location ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspection_checklist_id` SET TAGS ('dbx_business_glossary_term' = 'Checklist ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspection_equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspector_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspector_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspector_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Location ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `asset_tag` SET TAGS ('dbx_business_glossary_term' = 'Asset Tag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `attached_documents` SET TAGS ('dbx_business_glossary_term' = 'Attached Documents');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `calibration_required` SET TAGS ('dbx_business_glossary_term' = 'Calibration Required');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `checklist_version` SET TAGS ('dbx_business_glossary_term' = 'Checklist Version');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Inspector Comments');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_value_regex' = 'OSHA|ISO9001|IATF16949|EPA|NHTSA');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `corrective_action_reference` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Reference');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `downtime_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Downtime Impact Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `downtime_minutes` SET TAGS ('dbx_business_glossary_term' = 'Downtime Minutes');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Inspection Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `findings_summary` SET TAGS ('dbx_business_glossary_term' = 'Findings Summary');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspection_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Number (INSPECT_NO)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Inspection Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspection_status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|closed|rejected');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspection_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspection_type` SET TAGS ('dbx_value_regex' = 'safety|quality|regulatory|pre_production|calibration');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspector_name` SET TAGS ('dbx_business_glossary_term' = 'Inspector Name (INSPECTOR_NAME)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspector_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `inspector_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `maintenance_order_reference` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order Reference');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `non_conformance_count` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Count');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `non_conformance_flag` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` SET TAGS ('dbx_subdomain' = 'financial_tracking');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `warranty_claim_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `warranty_equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `claim_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Claim Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `claim_number` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `claim_resolution_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Claim Resolution Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `claim_status` SET TAGS ('dbx_business_glossary_term' = 'Claim Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `claim_status` SET TAGS ('dbx_value_regex' = 'submitted|under_review|approved|rejected|settled|closed');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `claim_submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Claim Submission Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `claim_type` SET TAGS ('dbx_business_glossary_term' = 'Claim Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `claim_type` SET TAGS ('dbx_value_regex' = 'repair|replacement|credit');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `claim_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Claim Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `credit_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CAD|AUD');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `defect_category` SET TAGS ('dbx_business_glossary_term' = 'Defect Category');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `defect_category` SET TAGS ('dbx_value_regex' = 'mechanical|electrical|software|calibration|other');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `defect_description` SET TAGS ('dbx_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `downtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Downtime Hours');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `equipment_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `equipment_tag` SET TAGS ('dbx_business_glossary_term' = 'Equipment Asset Tag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Is Critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `mttr_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Claim Notes');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `parts_used` SET TAGS ('dbx_business_glossary_term' = 'Parts Used');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `repair_action_description` SET TAGS ('dbx_business_glossary_term' = 'Repair Action Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `repair_decision` SET TAGS ('dbx_business_glossary_term' = 'Repair Decision');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `repair_decision` SET TAGS ('dbx_value_regex' = 'repair|replace|credit|none');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Settlement Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `settlement_status` SET TAGS ('dbx_business_glossary_term' = 'Settlement Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `settlement_status` SET TAGS ('dbx_value_regex' = 'pending|paid|reversed|void');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `total_repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Total Repair Cost');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `warranty_claim_reference` SET TAGS ('dbx_business_glossary_term' = 'External Warranty Claim Reference');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `warranty_coverage_end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Coverage End Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ALTER COLUMN `warranty_coverage_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Coverage Start Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` SET TAGS ('dbx_subdomain' = 'financial_tracking');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Project Manager Identifier (PM_ID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_project_manager_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Project Manager Identifier (PM_ID)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_project_manager_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_project_manager_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `affected_line_codes` SET TAGS ('dbx_business_glossary_term' = 'Affected Production Line Codes (LINE_CODES)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status (APPROVAL_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp (APPROVAL_TS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `cost_estimate_amount` SET TAGS ('dbx_business_glossary_term' = 'Estimated Cost Amount (COST_AMT)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `cost_estimate_currency` SET TAGS ('dbx_business_glossary_term' = 'Estimated Cost Currency (COST_CURR)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `downtime_estimate_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Downtime Hours (DOWNTIME_HRS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `estimated_production_loss_units` SET TAGS ('dbx_business_glossary_term' = 'Estimated Production Loss Units (LOSS_UNITS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Plan Number (PLAN_NO)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `planned_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Shutdown End Timestamp (END_TS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `planned_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Shutdown Start Timestamp (START_TS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level (RISK)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `scope_of_work` SET TAGS ('dbx_business_glossary_term' = 'Scope of Work Summary (SCOPE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Plan Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_plan_status` SET TAGS ('dbx_value_regex' = 'planned|approved|in_progress|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_type` SET TAGS ('dbx_business_glossary_term' = 'Shutdown Type (TYPE)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `shutdown_type` SET TAGS ('dbx_value_regex' = 'annual_maintenance|sop_retool|emergency|capital_installation');
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `lubrication_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Lubrication Schedule Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `lubrication_equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `lubrication_responsible_person_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `lubrication_responsible_person_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `lubrication_responsible_person_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `application_method` SET TAGS ('dbx_business_glossary_term' = 'Lubrication Application Method');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `application_method` SET TAGS ('dbx_value_regex' = 'manual|automatic|robotic');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Lubrication Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|overdue');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `frequency_unit` SET TAGS ('dbx_business_glossary_term' = 'Lubrication Frequency Unit');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `frequency_unit` SET TAGS ('dbx_value_regex' = 'hour|day|shift|week|month');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `frequency_value` SET TAGS ('dbx_business_glossary_term' = 'Lubrication Frequency Value');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Lubrication Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `last_lubrication_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Lubrication Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `lubricant_spec` SET TAGS ('dbx_business_glossary_term' = 'Lubricant Specification');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `lubrication_point_description` SET TAGS ('dbx_business_glossary_term' = 'Lubrication Point Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `lubrication_schedule_status` SET TAGS ('dbx_business_glossary_term' = 'Lubrication Schedule Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `lubrication_schedule_status` SET TAGS ('dbx_value_regex' = 'active|inactive|retired|draft');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `lubrication_type` SET TAGS ('dbx_business_glossary_term' = 'Lubrication Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `lubrication_type` SET TAGS ('dbx_value_regex' = 'grease|oil|synthetic|semi_synthetic|dry|solid');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `maintenance_group` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Group');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `next_due_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Next Lubrication Due Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Lubrication Schedule Notes');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `quantity_amount` SET TAGS ('dbx_business_glossary_term' = 'Lubricant Quantity Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Lubricant Quantity Unit');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_value_regex' = 'ml|g|kg|l');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `safety_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Safety Risk Level');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `safety_risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_business_glossary_term' = 'Lubrication Schedule Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ALTER COLUMN `schedule_name` SET TAGS ('dbx_business_glossary_term' = 'Lubrication Schedule Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` SET TAGS ('dbx_subdomain' = 'equipment_management');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` SET TAGS ('dbx_association_edges' = 'asset.equipment_registry,mobility.mobility_service');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` ALTER COLUMN `equipment_service_subscription_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Service Subscription - Subscription Id');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Service Subscription - Equipment Registry Id');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` ALTER COLUMN `mobility_service_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Service Subscription - Mobility Service Id');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` ALTER COLUMN `billing_amount` SET TAGS ('dbx_business_glossary_term' = 'Subscription Billing Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Subscription End Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` ALTER COLUMN `equipment_service_subscription_status` SET TAGS ('dbx_business_glossary_term' = 'Subscription Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Subscription Start Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` ALTER COLUMN `subscription_number` SET TAGS ('dbx_business_glossary_term' = 'Subscription Number');
ALTER TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` SET TAGS ('dbx_subdomain' = 'quality_assurance');
ALTER TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` SET TAGS ('dbx_association_edges' = 'asset.equipment_registry,compliance.regulatory_requirement');
ALTER TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` ALTER COLUMN `compliance_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Complianceassessment - Compliance Assessment Id');
ALTER TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Complianceassessment - Equipment Registry Id');
ALTER TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Complianceassessment - Regulatory Requirement Id');
ALTER TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Assessment Notes');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` SET TAGS ('dbx_subdomain' = 'quality_assurance');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `inspection_checklist_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Checklist Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `parent_inspection_checklist_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Inspection Checklist Id');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `parent_inspection_checklist_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `associated_asset_type` SET TAGS ('dbx_business_glossary_term' = 'Associated Asset Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `author` SET TAGS ('dbx_business_glossary_term' = 'Author');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Change Reason');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `checklist_code` SET TAGS ('dbx_business_glossary_term' = 'Checklist Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `checklist_name` SET TAGS ('dbx_business_glossary_term' = 'Checklist Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `department` SET TAGS ('dbx_business_glossary_term' = 'Department');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `inspection_checklist_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `estimated_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration Minutes');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `frequency` SET TAGS ('dbx_business_glossary_term' = 'Frequency');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `inspection_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `last_reviewed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Reviewed Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `regulatory_standard` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Standard');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `required_certification` SET TAGS ('dbx_business_glossary_term' = 'Required Certification');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `review_cycle_days` SET TAGS ('dbx_business_glossary_term' = 'Review Cycle Days');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `safety_rating` SET TAGS ('dbx_business_glossary_term' = 'Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `inspection_checklist_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection_checklist` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Version');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` SET TAGS ('dbx_subdomain' = 'equipment_management');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `parent_measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Measurement Point Id');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `parent_measurement_point_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `calibration_due_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Calibration Due Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `calibration_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Calibration Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `measurement_point_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `installation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Installation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `location` SET TAGS ('dbx_business_glossary_term' = 'Location');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `max_value` SET TAGS ('dbx_business_glossary_term' = 'Max Value');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `measurement_category` SET TAGS ('dbx_business_glossary_term' = 'Measurement Category');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `min_value` SET TAGS ('dbx_business_glossary_term' = 'Min Value');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `point_code` SET TAGS ('dbx_business_glossary_term' = 'Point Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `point_name` SET TAGS ('dbx_business_glossary_term' = 'Point Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `point_type` SET TAGS ('dbx_business_glossary_term' = 'Point Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `reading_frequency_hz` SET TAGS ('dbx_business_glossary_term' = 'Reading Frequency Hz');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `sensor_code` SET TAGS ('dbx_business_glossary_term' = 'Sensor Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `measurement_point_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `tolerance` SET TAGS ('dbx_business_glossary_term' = 'Tolerance');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit Of Measure');
ALTER TABLE `vibe_automotive_v1`.`asset`.`measurement_point` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` SET TAGS ('dbx_subdomain' = 'equipment_management');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `asset_class_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Identifier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Default Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Default Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `asset_category` SET TAGS ('dbx_business_glossary_term' = 'Asset Category');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `asset_category` SET TAGS ('dbx_value_regex' = 'production_machinery|robot|conveyor|tooling|building|utility');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Calibration Interval (Days)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `calibration_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Calibration Required Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `class_code` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `class_description` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Description');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `class_name` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Name');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `class_status` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `class_status` SET TAGS ('dbx_value_regex' = 'active|inactive|retired|planned|decommissioned');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_capacity_units_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Default Capacity (Units/Hour)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_capacity_units_per_hour` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Default Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Default Cost Currency');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_cost_currency` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_energy_consumption_kwh_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Default Energy Consumption (kWh/Hour)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_environmental_compliance` SET TAGS ('dbx_business_glossary_term' = 'Default Environmental Compliance');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_environmental_compliance` SET TAGS ('dbx_value_regex' = 'ISO14001|EPA|CARB');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_lifecycle_phase` SET TAGS ('dbx_business_glossary_term' = 'Default Lifecycle Phase');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_lifecycle_phase` SET TAGS ('dbx_value_regex' = 'design|manufacturing|operation|maintenance|retirement');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_location_type` SET TAGS ('dbx_business_glossary_term' = 'Default Location Type');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_location_type` SET TAGS ('dbx_value_regex' = 'plant|warehouse|field|office');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_maintenance_cost_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Default Maintenance Cost per Hour');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_maintenance_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Default Maintenance Interval (Days)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_mtbf_hours` SET TAGS ('dbx_business_glossary_term' = 'Default Mean Time Between Failures (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_mttr_hours` SET TAGS ('dbx_business_glossary_term' = 'Default Mean Time To Repair (Hours)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_power_rating_kw` SET TAGS ('dbx_business_glossary_term' = 'Default Power Rating (kW)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Default Responsible Department');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_safety_certification_required` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Required Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_spare_part_policy` SET TAGS ('dbx_business_glossary_term' = 'Default Spare Part Policy');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_spare_part_policy` SET TAGS ('dbx_value_regex' = 'stocked|just_in_time|none');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_supplier` SET TAGS ('dbx_business_glossary_term' = 'Default Supplier');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `default_warranty_years` SET TAGS ('dbx_business_glossary_term' = 'Default Warranty Period (Years)');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `depreciation_end_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation End Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|units_of_production');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `depreciation_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Rate Percent');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `depreciation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Start Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `is_depreciable` SET TAGS ('dbx_business_glossary_term' = 'Is Depreciable Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `is_maintainable` SET TAGS ('dbx_business_glossary_term' = 'Is Maintainable Flag');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `maintenance_strategy_default` SET TAGS ('dbx_business_glossary_term' = 'Default Maintenance Strategy');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `maintenance_strategy_default` SET TAGS ('dbx_value_regex' = 'preventive|predictive|reactive');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `sap_asset_class_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Asset Class Code');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life (Years)');
