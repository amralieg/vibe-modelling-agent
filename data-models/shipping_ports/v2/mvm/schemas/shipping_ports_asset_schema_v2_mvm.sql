-- Schema for Domain: asset | Business: Shipping_Ports | Version: v2_mvm
-- Generated on: 2026-07-13 10:24:14

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`asset` COMMENT 'Manages asset registry, equipment inventory, asset lifecycle, depreciation, SWL ratings, preventive and corrective maintenance schedules, work orders, spare parts inventory, equipment downtime, and asset reliability. Covers cranes (STS, QC), RTG, ASC, AGV, MHC, forklifts, and port vehicles. Integrates with Maximo Asset Management and SAP PM. SSOT for asset ownership, valuation, maintenance, and lifecycle management.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` (
    `port_asset_id` BIGINT COMMENT 'Unique identifier for the port asset. Primary key for the asset registry.',
    `equipment_class_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_class. Business justification: port_asset currently has asset_class as STRING. equipment_class is the SSOT for equipment classification hierarchy. Normalizing this relationship: port_asset should FK to equipment_class.equipment_cla',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Port assets (cranes, tugs, forklifts) are often operated by specific terminal operators or stevedoring companies who are registered port community participants. Essential for: asset responsibility tra',
    `parent_asset_port_asset_id` BIGINT COMMENT 'Reference to the parent asset in a hierarchical asset structure. Used for sub-assemblies and component tracking. Null for top-level assets.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Every fixed port asset (crane, bollard, fender, gate, building) has a permanent or assigned location within port geography (berth, yard block, terminal zone) - fundamental for asset tracking, maintena',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Port-owned mobile harbor assets (tugs, pilot boats, survey vessels, floating cranes) are vessels requiring IMO registration, classification society certification, flag state compliance, and insurance ',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'Original purchase or construction cost of the asset in the ports functional currency. Basis for depreciation calculations.',
    `asset_category` STRING COMMENT 'Detailed sub-classification within the asset class. Examples: STS (Ship-to-Shore crane), QC (Quay Crane), RTG (Rubber Tyred Gantry), ASC (Automated Stacking Crane), AGV (Automated Guided Vehicle), MHC (Mobile Harbour Crane).',
    `asset_description` STRING COMMENT 'Detailed textual description of the asset including make, model, and distinguishing characteristics.',
    `asset_number` STRING COMMENT 'Externally-known unique business identifier for the asset. Used across operational systems and maintenance records. Sourced from Maximo Asset Management or SAP PM.. Valid values are `^[A-Z0-9]{6,20}$`',
    `asset_status` STRING COMMENT 'Current operational status of the asset. Indicates availability for operations and maintenance state.. Valid values are `active|inactive|under_maintenance|decommissioned|reserved|out_of_service`',
    `capex_classification` STRING COMMENT 'Classification of the capital expenditure type that funded the asset acquisition or major enhancement.. Valid values are `new_acquisition|replacement|expansion|upgrade|refurbishment`',
    `commissioning_date` DATE COMMENT 'Date when the asset was placed into active service at the port. Marks the start of the assets operational lifecycle.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this asset record was first created in the system. Audit trail for data governance.',
    `criticality_rating` STRING COMMENT 'Business criticality classification indicating the impact of asset failure on port operations. Used for prioritizing maintenance and spare parts inventory.. Valid values are `critical|high|medium|low`',
    `current_book_value` DECIMAL(18,2) COMMENT 'Current net book value of the asset after accumulated depreciation. Updated periodically based on depreciation schedule.',
    `data_source_system` STRING COMMENT 'Operational system of record from which this asset data was sourced. Primary sources are Maximo Asset Management and SAP PM.. Valid values are `maximo|sap_pm|navis_n4|manual_entry|other`',
    `decommissioning_date` DATE COMMENT 'Date when the asset was permanently removed from service. Null for assets still in service.',
    `depreciation_method` STRING COMMENT 'Accounting method used to calculate depreciation expense for this asset over its useful life.. Valid values are `straight_line|declining_balance|units_of_production|sum_of_years_digits`',
    `environmental_compliance_flag` BOOLEAN COMMENT 'Indicates whether the asset meets current environmental regulations and emissions standards. True if compliant, False if non-compliant or exempted.',
    `grt` DECIMAL(18,2) COMMENT 'Gross Registered Tonnage for marine assets where applicable. Measure of overall internal volume.',
    `imo_number` STRING COMMENT 'IMO identification number for marine assets where applicable. Permanent reference number assigned by the International Maritime Organization.. Valid values are `^IMO[0-9]{7}$`',
    `insurance_policy_number` STRING COMMENT 'Reference number of the insurance policy covering this asset. Used for claims and risk management.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent safety or compliance inspection performed on the asset.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this asset record was last updated. Audit trail for data governance and change tracking.',
    `maintenance_strategy` STRING COMMENT 'Primary maintenance approach applied to this asset. Determines scheduling and resource allocation for maintenance activities.. Valid values are `preventive|predictive|corrective|condition_based|run_to_failure`',
    `manufacturer` STRING COMMENT 'Name of the original equipment manufacturer (OEM) who produced the asset.',
    `mean_time_between_failures` DECIMAL(18,2) COMMENT 'Average time in hours between asset failures. Key performance indicator for asset reliability and maintenance effectiveness.',
    `mean_time_to_repair` DECIMAL(18,2) COMMENT 'Average time in hours required to restore the asset to operational status after a failure. Indicator of maintenance efficiency.',
    `model` STRING COMMENT 'Manufacturers model number or designation for the asset.',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next mandatory safety or compliance inspection. Critical for regulatory compliance.',
    `nrt` DECIMAL(18,2) COMMENT 'Net Registered Tonnage for marine assets where applicable. Measure of revenue-earning capacity.',
    `operating_hours` DECIMAL(18,2) COMMENT 'Cumulative operating hours logged by the asset since commissioning. Used for usage-based maintenance scheduling and lifecycle analysis.',
    `residual_value` DECIMAL(18,2) COMMENT 'Estimated salvage or scrap value of the asset at the end of its useful life. Used in depreciation calculations.',
    `rfid_tag_code` STRING COMMENT 'RFID tag identifier attached to the asset for automated tracking and location monitoring within the port facility.',
    `serial_number` STRING COMMENT 'Manufacturers unique serial number assigned to this specific asset unit. Used for warranty claims and parts ordering.',
    `swl_rating` DECIMAL(18,2) COMMENT 'Maximum load capacity in metric tonnes that the asset is certified to handle safely. Critical for cranes, RTGs, ASCs, and lifting equipment. Compliance with SOLAS and port safety regulations.',
    `useful_life_years` STRING COMMENT 'Expected operational lifespan of the asset in years. Used for depreciation and lifecycle planning.',
    `warranty_expiry_date` DATE COMMENT 'Date when the manufacturers warranty coverage expires. Null if no warranty or warranty has already expired.',
    `year_of_manufacture` STRING COMMENT 'Calendar year in which the asset was manufactured by the OEM.',
    CONSTRAINT pk_port_asset PRIMARY KEY(`port_asset_id`)
) COMMENT 'SSOT for all physical assets owned or operated by the port. Master registry covering cranes (STS, QC, MHC), RTGs, ASCs, AGVs, forklifts, port vehicles, and infrastructure equipment. Captures asset number, description, asset class, asset category, manufacturer, model, serial number, year of manufacture, commissioning date, decommissioning date, location (berth/yard/terminal zone), SWL (Safe Working Load) rating, GRT/NRT where applicable, acquisition cost, current book value, depreciation method, useful life, residual value, asset status (active/inactive/under_maintenance/decommissioned), CAPEX classification, owning cost centre, and parent asset reference for sub-assembly hierarchy. Sourced from Maximo Asset Management and SAP PM.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` (
    `equipment_class_id` BIGINT COMMENT 'Unique identifier for the equipment class. Primary key for the equipment classification hierarchy.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Equipment classes (STS cranes, fenders, mooring hooks) are designed and certified for specific vessel types. Port procurement, berth planning, and equipment assignment decisions require knowing which ',
    `acquisition_cost_range_usd` STRING COMMENT 'Typical acquisition cost range for new equipment in this class, expressed in USD. Used for budgeting, procurement planning, and asset valuation. Business-confidential.',
    `annual_operating_cost_usd` DECIMAL(18,2) COMMENT 'Estimated annual operating cost (OPEX) for equipment in this class, including fuel, maintenance, labor, and consumables. Used for total cost of ownership analysis. Business-confidential.',
    `automation_level` STRING COMMENT 'Degree of automation for equipment in this class. Impacts operator requirements, productivity metrics, and technology integration.. Valid values are `manual|semi_automated|fully_automated|remote_controlled`',
    `capacity_teu` STRING COMMENT 'Operational capacity of the equipment class expressed in TEU. Applicable to container handling equipment (cranes, stackers, carriers). Null for non-container equipment.',
    `certification_requirements` STRING COMMENT 'Mandatory certifications, inspections, or regulatory approvals required for equipment in this class (e.g., annual SWL certification, ISPS compliance, pressure vessel inspection).',
    `class_code` STRING COMMENT 'Standardized alphanumeric code uniquely identifying the equipment class across the terminal. Used for reporting, spare parts mapping, and maintenance planning.. Valid values are `^[A-Z0-9]{4,12}$`',
    `class_description` STRING COMMENT 'Detailed description of the equipment class, including typical use cases, operational characteristics, and distinguishing features.',
    `class_name` STRING COMMENT 'Full descriptive name of the equipment class (e.g., Ship-to-Shore Crane, Rubber Tyred Gantry Crane, Automated Guided Vehicle).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this equipment class record was first created in the system.',
    `depreciation_method` STRING COMMENT 'Standard depreciation method applied to assets in this equipment class for financial accounting purposes.. Valid values are `straight_line|declining_balance|units_of_production|sum_of_years_digits`',
    `effective_from_date` DATE COMMENT 'Date from which this equipment class definition became effective in the terminal classification hierarchy.',
    `effective_to_date` DATE COMMENT 'Date until which this equipment class definition remains effective. Null for currently active classes.',
    `emissions_standard` STRING COMMENT 'Applicable emissions standard or tier for this equipment class (e.g., EPA Tier 4, Euro Stage V). Required for environmental compliance and GHG reporting.',
    `environmental_impact_category` STRING COMMENT 'Classification of environmental impact for equipment in this class based on emissions, noise, and resource consumption. Used for EMS reporting and sustainability planning.. Valid values are `minimal|moderate|significant|high`',
    `equipment_category` STRING COMMENT 'High-level categorization of equipment class by operational function within the terminal.. Valid values are `cargo_handling|horizontal_transport|yard_equipment|marine_equipment|utility_equipment|support_vehicle`',
    `fuel_consumption_rate` DECIMAL(18,2) COMMENT 'Typical fuel or energy consumption rate for this equipment class (e.g., liters per hour, kWh per move). Used for OPEX planning and environmental impact assessment.',
    `imdg_compliance_required` BOOLEAN COMMENT 'Indicates whether equipment in this class must comply with IMDG Code requirements for handling dangerous goods. Critical for cargo operations and regulatory compliance.',
    `inspection_frequency_days` STRING COMMENT 'Standard inspection interval for equipment in this class, measured in days. Drives preventive maintenance scheduling in Maximo and SAP PM.',
    `interoperability_standard` STRING COMMENT 'Communication or integration standards supported by equipment in this class (e.g., ISO 18186 RFID, EDI BAPLIE, TOS API). Enables system integration and data exchange.',
    `isps_security_level` STRING COMMENT 'ISPS security level classification for equipment in this class. Determines access control, monitoring, and security protocol requirements.. Valid values are `level_1|level_2|level_3|not_applicable`',
    `kpi_benchmark_moves_per_hour` DECIMAL(18,2) COMMENT 'Industry benchmark productivity rate for equipment in this class, measured in moves per hour. Used for performance target setting and operational efficiency analysis.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this equipment class record was last updated.',
    `lifecycle_status` STRING COMMENT 'Current lifecycle status of the equipment class in the classification hierarchy. Deprecated or obsolete classes are retained for historical asset tracking but not used for new acquisitions.. Valid values are `active|deprecated|obsolete|under_review`',
    `maintenance_complexity` STRING COMMENT 'Relative complexity of maintenance operations for this equipment class. Influences spare parts inventory levels, technician skill requirements, and maintenance cost forecasting.. Valid values are `low|medium|high|critical`',
    `manufacturer_standard` STRING COMMENT 'Typical or recommended manufacturers for this equipment class (e.g., Liebherr, Konecranes, Kalmar, ZPMC). Used for procurement and spare parts compatibility.',
    `mean_time_between_failures_hours` DECIMAL(18,2) COMMENT 'Industry benchmark or historical average MTBF for equipment in this class, measured in operational hours. Used for reliability planning and spare parts optimization.',
    `mean_time_to_repair_hours` DECIMAL(18,2) COMMENT 'Industry benchmark or historical average MTTR for equipment in this class, measured in hours. Critical for downtime forecasting and service level planning.',
    `mobility_type` STRING COMMENT 'Mobility characteristic of equipment in this class. Influences yard planning, operational flexibility, and infrastructure requirements.. Valid values are `fixed|rail_mounted|rubber_tyred|tracked|self_propelled|towed`',
    `noise_level_db` STRING COMMENT 'Typical operational noise level for equipment in this class, measured in decibels. Required for occupational health compliance and environmental monitoring.',
    `operational_speed_range` STRING COMMENT 'Typical operational speed range for this equipment class (e.g., 20-30 moves/hour for STS cranes, 15-25 km/h for AGVs). Used for performance benchmarking and KPI target setting.',
    `operator_certification_required` BOOLEAN COMMENT 'Indicates whether specialized operator certification or licensing is required to operate equipment in this class. Drives workforce training and competency management.',
    `operator_skill_level` STRING COMMENT 'Minimum operator skill level required for safe and efficient operation of equipment in this class. Used for workforce planning and training program design.. Valid values are `basic|intermediate|advanced|expert`',
    `power_source` STRING COMMENT 'Primary power source for equipment in this class. Critical for environmental reporting, energy management, and emissions tracking.. Valid values are `diesel|electric|hybrid|battery|manual`',
    `residual_value_percentage` DECIMAL(18,2) COMMENT 'Expected residual or salvage value at end of useful life, expressed as a percentage of original acquisition cost. Used in depreciation calculations.',
    `safety_risk_rating` STRING COMMENT 'Inherent safety risk level associated with operation of equipment in this class. Influences safety protocols, training requirements, and incident response planning.. Valid values are `low|medium|high|critical`',
    `spare_parts_category` STRING COMMENT 'Standardized spare parts category or family associated with this equipment class. Enables cross-equipment spare parts compatibility mapping and inventory optimization.',
    `swl_rating_max_tonnes` DECIMAL(18,2) COMMENT 'Maximum Safe Working Load rating for equipment in this class, measured in metric tonnes. Defines upper operational capacity boundary.',
    `swl_rating_min_tonnes` DECIMAL(18,2) COMMENT 'Minimum Safe Working Load rating for equipment in this class, measured in metric tonnes. Critical for operational safety and compliance.',
    `useful_life_years` STRING COMMENT 'Expected useful life of equipment in this class, measured in years. Used for depreciation calculation, lifecycle planning, and CAPEX forecasting.',
    CONSTRAINT pk_equipment_class PRIMARY KEY(`equipment_class_id`)
) COMMENT 'SSOT for the reference classification hierarchy of port equipment types. Defines standardised equipment categories (STS Crane, QC Crane, RTG, ASC, AGV, MHC, Forklift, Port Tractor, Reach Stacker, Empty Handler, Port Vehicle, Mooring Equipment, Utility Equipment) with associated SWL bands, operational capacity parameters, certification requirements, and applicable regulatory standards (SOLAS, IMDG, ISPS). Enables consistent equipment reporting, maintenance planning, spare parts compatibility mapping, and KPI benchmarking across the terminal.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` (
    `maintenance_plan_id` BIGINT COMMENT 'Unique identifier for the preventive maintenance plan. Primary key. Inferred role: MASTER_RESOURCE (defines a maintenance plan as a managed resource/configuration).',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Berths require dedicated maintenance plans for fender system replacement cycles, bollard inspection schedules, and dredging programs. Berth-linked maintenance plans support next_maintenance_date sched',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Navigation channels require formal dredging maintenance plans governed by dredging authority mandates and survey_frequency_months requirements. Channel maintenance plans support next_due_date scheduli',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Maintenance plans are frequently executed by external contractors (OEM service providers, specialized marine engineers) who must be registered port community participants for port access and complianc',
    `equipment_class_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_class. Business justification: The maintenance_plan table contains an asset_class STRING column that stores a free-text classification of the equipment type the plan applies to. This is a denormalization of the equipment_class refe',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Maintenance activities on ISPS-regulated port assets must be coordinated with the Facility Security Plan (PFSP). Port Facility Security Officers must approve maintenance affecting security systems. Li',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Maintenance plans for customer-owned or leased equipment must reference the governing service agreement to ensure SLA compliance, determine cost recovery responsibility, and track contractual maintena',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Maintenance plans executed by contracted service providers are governed by participant service agreements that define negotiated rates, scope, and terms. Linking enables contract compliance validation',
    `port_asset_id` BIGINT COMMENT 'Reference to the specific asset (STS crane, RTG, ASC, AGV, MHC, forklift, port vehicle) to which this maintenance plan applies. Links to the asset registry.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Maintenance budgets and actual costs are controlled by cost centre for operational expense management. Essential for budget vs actual variance reporting and cost centre accountability.',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Quay walls require long-term maintenance plans for cathodic protection, structural repairs, and fender replacement. Quay wall maintenance plans support next_inspection_due_date scheduling, replacement',
    `rail_wagon_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_wagon. Business justification: Rail wagons operating at port terminals require scheduled maintenance plans governing brake inspections, axle servicing, and certification renewals. maintenance_plan already governs port_assets; addin',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Preventive maintenance plans for critical port equipment (cranes, RTGs, mooring systems) must reference risk assessments per ISO 45001. Ensures maintenance procedures address identified hazards. Requi',
    `approval_date` DATE COMMENT 'The date when the current revision of the maintenance plan was formally approved. Part of the plan lifecycle audit trail.',
    `auto_generate_work_order` BOOLEAN COMMENT 'Indicates whether work orders should be automatically generated when the maintenance due date or meter reading is reached. True for routine preventive maintenance, false for plans requiring manual review.',
    `compliance_certificate_required` BOOLEAN COMMENT 'Indicates whether a compliance certificate or inspection report must be issued upon completion of maintenance under this plan. True for statutory and regulatory maintenance activities.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this maintenance plan record was first created in the system. Part of the audit trail.',
    `effective_from_date` DATE COMMENT 'The date from which this maintenance plan becomes active and begins generating work orders. Supports phased rollout of new maintenance strategies.',
    `effective_to_date` DATE COMMENT 'The date on which this maintenance plan expires or is superseded. Nullable for open-ended plans. Used for plan lifecycle management and historical tracking.',
    `estimated_cost` DECIMAL(18,2) COMMENT 'Estimated total cost of executing maintenance under this plan, including labor, spare parts, consumables, and contractor services. Used for budgeting and CAPEX/OPEX planning.',
    `estimated_downtime_hours` DECIMAL(18,2) COMMENT 'Estimated duration (in hours) that the asset will be out of service during maintenance execution. Critical for operational planning and berth/yard scheduling.',
    `estimated_labor_hours` DECIMAL(18,2) COMMENT 'Estimated total labor hours required to complete the maintenance tasks. Used for resource planning, scheduling, and cost estimation.',
    `last_completed_date` DATE COMMENT 'The date when maintenance under this plan was last successfully completed. Used to calculate the next due date and track maintenance history.',
    `lead_time_days` STRING COMMENT 'Number of days in advance of the due date that the work order should be generated. Allows time for planning, resource allocation, and spare parts procurement.',
    `maintenance_frequency_unit` STRING COMMENT 'Unit of measure for the maintenance frequency interval. Time-based plans use calendar units (days, weeks, months, years), meter-based plans use operational units (operating hours, cycles, TEU handled, lifts, kilometers). [ENUM-REF-CANDIDATE: days|weeks|months|years|operating_hours|cycles|teu_handled|lifts|kilometers — 9 candidates stripped; promote to reference product]',
    `maintenance_frequency_value` STRING COMMENT 'Numeric value representing the interval between maintenance activities. Interpreted in conjunction with frequency_unit (e.g., 30 days, 500 operating hours, 1000 TEU handled).',
    `meter_reading_at_last_completion` DECIMAL(18,2) COMMENT 'The asset meter reading (operating hours, cycles, TEU handled, etc.) at the time of last maintenance completion. Used for meter-based maintenance scheduling.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this maintenance plan record was last modified. Updated whenever any field in the plan is changed. Part of the audit trail.',
    `next_due_date` DATE COMMENT 'The next scheduled date when maintenance under this plan is due. Calculated based on the last completion date and the maintenance frequency. Used for work order generation and scheduling.',
    `next_due_meter_reading` DECIMAL(18,2) COMMENT 'The asset meter reading at which the next maintenance is due. Applicable for meter-based maintenance plans. Triggers work order generation when the asset meter reaches this value.',
    `notes` STRING COMMENT 'Free-text field for additional notes, comments, or special instructions related to the maintenance plan. May include historical context, lessons learned, or operational considerations.',
    `oem_reference` STRING COMMENT 'Reference to the OEM maintenance manual, technical bulletin, or service recommendation that defines this maintenance plan. Ensures alignment with manufacturer specifications and warranty requirements.',
    `plan_name` STRING COMMENT 'Human-readable name or title of the maintenance plan, describing the maintenance activity or scope.',
    `plan_number` STRING COMMENT 'Externally-known unique identifier for the maintenance plan, typically assigned by Maximo Asset Management. Used for cross-system reference and reporting.',
    `plan_status` STRING COMMENT 'Current lifecycle status of the maintenance plan. Active plans generate work orders, inactive plans are disabled, draft plans are under development, suspended plans are temporarily paused, and archived plans are retained for historical reference.. Valid values are `active|inactive|draft|suspended|archived`',
    `plan_type` STRING COMMENT 'Classification of the maintenance plan strategy. Time-based plans trigger on calendar intervals, meter-based on usage counters (e.g., operating hours), condition-based on asset condition monitoring, predictive on analytics, corrective on failure, and statutory on regulatory compliance requirements.. Valid values are `time_based|meter_based|condition_based|predictive|corrective|statutory`',
    `priority` STRING COMMENT 'Priority level of the maintenance plan, reflecting the criticality of the asset and the impact of maintenance deferral on operations, safety, and compliance. Critical plans cannot be deferred.. Valid values are `critical|high|medium|low`',
    `regulatory_requirement` STRING COMMENT 'Reference to applicable regulatory or statutory requirements that mandate this maintenance plan (e.g., IMO regulations, PSC requirements, national maritime safety authority directives, environmental compliance).',
    `required_trade_skills` STRING COMMENT 'Comma-separated list of trade skills or certifications required to perform the maintenance tasks (e.g., electrician, hydraulic technician, crane operator, certified welder). Used for workforce planning and assignment.',
    `responsible_department` STRING COMMENT 'Department or organizational unit responsible for planning, scheduling, and executing maintenance under this plan (e.g., Engineering, Maintenance, Operations).',
    `revision_date` DATE COMMENT 'The date when the current revision of the maintenance plan was approved and became effective. Tracks plan change history.',
    `revision_number` STRING COMMENT 'Version or revision number of the maintenance plan. Incremented when the plan is updated or modified. Supports change control and audit trail.',
    `safety_procedures` STRING COMMENT 'Applicable safety procedures, permits, and precautions required during maintenance execution. Includes lockout/tagout (LOTO), confined space entry, hot work permits, and personal protective equipment (PPE) requirements.',
    `seasonal_adjustment` STRING COMMENT 'Seasonal adjustment factor for maintenance scheduling. Some maintenance activities are preferentially scheduled during specific seasons or operational periods (e.g., off-peak season, favorable weather conditions).. Valid values are `none|summer|winter|monsoon|peak_season|off_peak`',
    `sla_requirement` STRING COMMENT 'Service Level Agreement requirements or performance targets associated with this maintenance plan (e.g., maximum response time, uptime targets, availability guarantees). Aligns maintenance planning with operational commitments.',
    `task_checklist` STRING COMMENT 'Structured checklist or step-by-step instructions for executing the maintenance tasks. Ensures consistency and completeness of maintenance activities.',
    `task_description` STRING COMMENT 'Detailed description of the maintenance tasks and procedures to be performed under this plan. May reference OEM (Original Equipment Manufacturer) maintenance manuals, safety procedures, and technical specifications.',
    CONSTRAINT pk_maintenance_plan PRIMARY KEY(`maintenance_plan_id`)
) COMMENT 'Defines preventive maintenance (PM) plans and schedules for port assets as configured in Maximo Asset Management. Captures plan type (time-based, meter-based, condition-based), maintenance frequency, maintenance task descriptions, required trade skills, estimated labour hours, required spare parts, applicable safety procedures, and next due date. Covers all asset classes including STS cranes, RTGs, ASCs, AGVs, MHC, and port vehicles. Aligns with OEM maintenance manuals and port SLA requirements. SSOT for planned maintenance scheduling.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` (
    `work_order_id` BIGINT COMMENT 'Unique identifier for the work order. Primary key for the work order entity.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Work orders are raised directly against berths for fender replacement, bollard repair, dredging, and shore power maintenance. Berth-linked work orders support berth downtime tracking, operational_stat',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Dredging and navigational aid maintenance work orders are raised against specific channels. Channel-linked work orders support dredging cost tracking, last_dredging_date updates, operational_status ma',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Work orders often involve external contractors for specialized repairs, equipment servicing, or emergency maintenance. Contractors must be registered port community participants for security clearance',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal_equipment. Business justification: Maintenance work orders need operational equipment identifier for dispatch coordination, real-time equipment status updates, shift handover, and operational downtime tracking. While work_order.asset_i',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: ISO 55001 asset management audits and ISPS facility audits review maintenance work orders as evidence of preventive maintenance compliance. Auditors trace specific work orders during certification aud',
    `marpol_record_id` BIGINT COMMENT 'Foreign key linking to compliance.marpol_record. Business justification: Work orders on MARPOL-relevant equipment (oily water separators, incinerators, bilge systems) generate or are associated with MARPOL compliance records. Linking work_order to marpol_record enables tra',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Work orders for contracted maintenance are billed under specific participant service agreements governing rates and payment terms. Linking enables direct rate lookup for cost estimation, invoice gener',
    `port_asset_id` BIGINT COMMENT 'Reference to the port asset (crane, RTG, ASC, AGV, MHC, forklift, vehicle, or infrastructure) against which this work order is raised. Links to the asset registry for equipment details, location, and specifications.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Work order costs must be allocated to cost centres for expense tracking and financial reporting. Critical for maintenance cost control and cost centre P&L in port operations.',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Work orders for port services (crane hire, berth maintenance, equipment servicing) are billed against the governing port tariff schedule. Port billing teams require this link to apply correct charge r',
    `rail_wagon_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_wagon. Business justification: Rail wagons at port terminals require maintenance work orders for brake repairs, coupling replacements, and certification-driven inspections. work_order already covers terminal_equipment and tugs; ext',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.sla_profile. Business justification: Work orders for asset maintenance must be tracked against applicable customer SLA profiles to monitor response/resolution time compliance. Port operators report SLA breach metrics per work order for c',
    `tug_id` BIGINT COMMENT 'Foreign key linking to marine.tug. Business justification: Maintenance work orders on tugs require operational context (bollard pull rating, FIFI class, escort capability, engine power) for work planning, parts specification, and service provider selection. L',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: High-risk maintenance (hot work, confined space, lifting operations) requires permits to work before execution. Port operations mandate permit tracking on work orders for regulatory compliance (ISPS, ',
    `actual_contractor_cost` DECIMAL(18,2) COMMENT 'Actual cost for external contractor or vendor services consumed during work order execution, captured from vendor invoices. Expressed in the ports functional currency. Used for cost accounting and vendor performance evaluation.',
    `actual_end_datetime` TIMESTAMP COMMENT 'Actual date and time when maintenance work was completed. Captured when work order status changes to completed. Used for schedule adherence analysis, downtime calculation, and Mean Time To Repair (MTTR) metrics.',
    `actual_labour_hours` DECIMAL(18,2) COMMENT 'Actual total labour hours consumed to complete the work order, captured from time attendance records. Used for cost accounting, productivity analysis, and future estimation accuracy improvement.',
    `actual_material_cost` DECIMAL(18,2) COMMENT 'Actual total cost of spare parts, consumables, and materials consumed during work order execution, captured from inventory transactions and purchase orders. Expressed in the ports functional currency. Used for cost accounting and budget variance analysis.',
    `actual_start_datetime` TIMESTAMP COMMENT 'Actual date and time when maintenance work commenced. Captured when work order status changes to in_progress. Used for schedule adherence analysis and downtime tracking.',
    `cancellation_reason` STRING COMMENT 'Explanation for why the work order was cancelled. Populated only if work_order_status is cancelled. Used for process improvement and understanding maintenance planning effectiveness.',
    `completion_datetime` TIMESTAMP COMMENT 'Date and time when the work order was officially closed and marked as completed in the system. Distinct from actual_end_datetime which captures when physical work finished. Used for work order lifecycle tracking and performance reporting.',
    `created_datetime` TIMESTAMP COMMENT 'Date and time when the work order record was first created in the system. Used for audit trail and work order aging analysis.',
    `downtime_hours` DECIMAL(18,2) COMMENT 'Total hours the asset was unavailable for operations due to this maintenance work. Calculated as difference between actual_start_datetime and actual_end_datetime, adjusted for any concurrent operational use. Used for availability metrics and operational impact analysis.',
    `equipment_shutdown_required_flag` BOOLEAN COMMENT 'Indicates whether the asset must be completely shut down and de-energized for this maintenance work. True = shutdown required; False = work can be performed while asset is operational or in standby. Used for operational planning and safety risk assessment.',
    `estimated_contractor_cost` DECIMAL(18,2) COMMENT 'Planned cost for external contractor or vendor services required for the work order, estimated during planning. Expressed in the ports functional currency. Null if work is performed entirely by internal crews.',
    `estimated_labour_hours` DECIMAL(18,2) COMMENT 'Planned total labour hours required to complete the work order, estimated during work order planning. Used for crew scheduling and cost estimation.',
    `estimated_material_cost` DECIMAL(18,2) COMMENT 'Planned total cost of spare parts, consumables, and materials required for the work order, estimated during planning. Expressed in the ports functional currency.',
    `external_work_order_reference` STRING COMMENT 'Reference number or identifier from the source system (Maximo, SAP PM) for cross-system reconciliation and traceability. Used for data integration and audit purposes.',
    `failure_code` STRING COMMENT 'Standardized code identifying the type of failure or maintenance need. Follows ISO 14224 taxonomy for equipment failure modes. Examples: ME-1001 (mechanical failure), EL-2003 (electrical fault), HY-3005 (hydraulic leak). Used for reliability analysis and failure trend reporting.. Valid values are `^[A-Z]{2}-[0-9]{4}$`',
    `last_modified_datetime` TIMESTAMP COMMENT 'Date and time when the work order record was last updated. Used for audit trail and change tracking.',
    `parts_availability_status` STRING COMMENT 'Status of spare parts and materials required for the work order. Available = all parts in stock; On Order = parts ordered but not yet received; Backordered = parts delayed by supplier; Not Required = no parts needed. Used for work order scheduling and inventory planning.. Valid values are `available|on_order|backordered|not_required`',
    `planned_end_datetime` TIMESTAMP COMMENT 'Scheduled date and time when maintenance work is planned to be completed. Used for asset availability forecasting and operational planning.',
    `planned_start_datetime` TIMESTAMP COMMENT 'Scheduled date and time when maintenance work is planned to begin. Used for crew scheduling, asset downtime planning, and operational coordination.',
    `priority_level` STRING COMMENT 'Urgency classification for work order execution. Critical = immediate safety or operational impact; High = significant operational impact; Medium = moderate impact; Low = minimal impact. Drives scheduling and resource allocation decisions.. Valid values are `critical|high|medium|low`',
    `resolution_description` STRING COMMENT 'Detailed description of the work performed, findings, corrective actions taken, and final resolution. Captured upon work order completion. Used for maintenance history, knowledge management, and future troubleshooting.',
    `root_cause_code` STRING COMMENT 'Standardized code identifying the underlying cause of the failure or maintenance need, determined after work completion. Follows ISO 14224 root cause taxonomy. Examples: RC-1001 (wear and tear), RC-2003 (operator error), RC-3005 (design deficiency). Used for root cause analysis and continuous improvement.. Valid values are `^[A-Z]{2}-[0-9]{4}$`',
    `safety_permit_required_flag` BOOLEAN COMMENT 'Indicates whether a safety work permit (hot work, confined space, work at height, etc.) is required for this work order per ISO 45001 and port safety regulations. True = permit required; False = no permit required.',
    `total_work_order_cost` DECIMAL(18,2) COMMENT 'Total actual cost of the work order, including labour, materials, and contractor costs. Calculated as sum of actual_labour_hours * labour_rate + actual_material_cost + actual_contractor_cost. Expressed in the ports functional currency. Used for asset lifecycle costing and maintenance budget management.',
    `warranty_claim_flag` BOOLEAN COMMENT 'Indicates whether this work order is eligible for warranty claim against the equipment manufacturer or vendor. True = warranty claim submitted or eligible; False = no warranty claim. Used for cost recovery and vendor accountability.',
    `warranty_claim_reference` STRING COMMENT 'External reference number or identifier for the warranty claim submitted to the manufacturer or vendor. Populated only if warranty_claim_flag is true. Used for tracking warranty claim status and cost recovery.',
    `work_description` STRING COMMENT 'Detailed description of the maintenance work to be performed, including scope, procedures, and safety requirements. Provides instructions to maintenance crews and context for work order execution.',
    `work_order_number` STRING COMMENT 'Externally-known unique business identifier for the work order, typically formatted as WO-YYYYMMDD or similar pattern. Used for communication with maintenance crews, vendors, and reporting.. Valid values are `^WO-[0-9]{8}$`',
    `work_order_status` STRING COMMENT 'Current lifecycle state of the work order. Draft = created but not approved; Approved = authorized for execution; Scheduled = assigned to crew with planned date; In Progress = work underway; On Hold = temporarily suspended; Completed = work finished and closed; Cancelled = work order voided. [ENUM-REF-CANDIDATE: draft|approved|scheduled|in_progress|on_hold|completed|cancelled — 7 candidates stripped; promote to reference product]',
    `work_order_type` STRING COMMENT 'Classification of the work order based on maintenance strategy. Preventive = scheduled maintenance per maintenance plan; Corrective = repair in response to failure; Emergency = urgent unplanned repair; Inspection = condition assessment; Overhaul = major refurbishment; Calibration = precision adjustment of equipment.. Valid values are `preventive|corrective|emergency|inspection|overhaul|calibration`',
    CONSTRAINT pk_work_order PRIMARY KEY(`work_order_id`)
) COMMENT 'SSOT for all maintenance execution records (preventive, corrective, emergency, inspection, and overhaul) raised against port assets. Captures work order number, work order type, asset reference, failure code, priority level, work order status (draft/approved/in_progress/completed/cancelled), assigned maintenance crew, planned and actual start/end datetime, estimated vs actual labour hours, estimated vs actual material cost, total work order cost, root cause code, and resolution description. Sourced from Maximo Asset Management and SAP PM. Links to maintenance_plan for preventive triggers and failure_report for corrective triggers.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` (
    `work_order_task_id` BIGINT COMMENT 'Unique identifier for the work order task. Primary key.',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: A work_order_task may target a specific sub-asset or component within the broader work order scope. The work_order already links to the primary port_asset, but individual tasks within a complex work o',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Port maintenance tasks are executed by specific registered subcontractors/vendors (port_community_participants). The existing plain-text `vendor_service_provider` column is a denormalization of port_c',
    `work_order_id` BIGINT COMMENT 'Reference to the parent maintenance work order under which this task is performed. Links task to the overall maintenance activity.',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when this task was completed. Used for performance tracking and schedule variance analysis.',
    `actual_labour_hours` DECIMAL(18,2) COMMENT 'Actual number of labour hours expended to complete this task. Used for performance analysis and cost tracking.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when work on this task commenced. Used for performance tracking and schedule variance analysis.',
    `asset_component` STRING COMMENT 'Specific component or sub-assembly of the asset being maintained in this task, such as hoist motor, boom structure, or hydraulic cylinder on an STS crane.',
    `certification_reference` STRING COMMENT 'Reference number of the certification or inspection report issued upon completion of this task. Links to regulatory compliance documentation.',
    `certification_required` BOOLEAN COMMENT 'Indicates whether this task requires formal certification or sign-off by a qualified inspector or regulatory authority, such as Safe Working Load (SWL) certification for lifting equipment.',
    `completion_notes` STRING COMMENT 'Detailed notes recorded by the technician upon task completion, including observations, issues encountered, corrective actions taken, and recommendations for future maintenance.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this task record was first created in the system. Used for audit trail and data lineage.',
    `environmental_impact_notes` STRING COMMENT 'Notes on environmental considerations or impacts related to this task, such as hazardous material handling, waste disposal, or emissions. Supports ISO 14001 compliance.',
    `equipment_downtime_required` BOOLEAN COMMENT 'Indicates whether the equipment must be taken out of service to perform this task. Critical for operational planning and berth allocation.',
    `failure_code` STRING COMMENT 'Standardized code identifying the type of failure or defect addressed by this task. Used for failure mode analysis and reliability engineering.',
    `inspection_result` STRING COMMENT 'Outcome of inspection tasks. Indicates whether the inspected component meets operational and safety standards.. Valid values are `pass|fail|conditional|not_applicable`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this task record was last updated. Used for audit trail and change tracking.',
    `measurement_reading` STRING COMMENT 'Quantitative measurement or reading taken during the task, such as vibration levels, temperature, pressure, or electrical resistance. Stored as string to accommodate various units and formats.',
    `modified_by_user` STRING COMMENT 'Username or identifier of the system user who last modified this task record. Used for audit trail and accountability.',
    `planned_end_timestamp` TIMESTAMP COMMENT 'Scheduled date and time when this task is planned to be completed. Used for maintenance scheduling and downtime planning.',
    `planned_labour_hours` DECIMAL(18,2) COMMENT 'Estimated number of labour hours required to complete this task. Used for resource planning and scheduling.',
    `planned_start_timestamp` TIMESTAMP COMMENT 'Scheduled date and time when this task is planned to begin. Used for maintenance scheduling and resource allocation.',
    `safety_permit_reference` STRING COMMENT 'Reference number of the safety permit or work authorization required for this task, such as lock-out/tag-out (LOTO), hot work permit, confined space entry, or height work permit.',
    `task_description` STRING COMMENT 'Detailed description of the specific maintenance task to be performed, including procedures, safety requirements, and expected outcomes.',
    `task_priority` STRING COMMENT 'Priority level assigned to this task within the work order. Determines execution sequence when multiple tasks compete for resources.. Valid values are `critical|high|medium|low`',
    `task_sequence_number` STRING COMMENT 'Sequential ordering of this task within the parent work order. Defines the execution order of multi-step maintenance operations.',
    `task_status` STRING COMMENT 'Current lifecycle status of the maintenance task. Tracks progression from assignment through completion.. Valid values are `pending|in_progress|completed|cancelled|on_hold|failed`',
    `task_type` STRING COMMENT 'Classification of the maintenance task activity. Categorizes the nature of work to be performed. [ENUM-REF-CANDIDATE: inspection|repair|replacement|lubrication|calibration|testing|cleaning|adjustment — 8 candidates stripped; promote to reference product]',
    `total_labour_cost` DECIMAL(18,2) COMMENT 'Total labour cost for this task, calculated from actual labour hours and technician hourly rates. Used for maintenance cost allocation and budgeting.',
    `total_task_cost` DECIMAL(18,2) COMMENT 'Total cost of this task including labour, parts, and any additional charges. Rolls up to the overall work order cost.',
    `trade_skill_required` STRING COMMENT 'Specialized trade or skill set required to perform this task, such as electrical, mechanical, hydraulic, or structural engineering expertise.',
    `warranty_claim_flag` BOOLEAN COMMENT 'Indicates whether this task is associated with a warranty claim for parts or labour. Used for cost recovery and vendor management.',
    CONSTRAINT pk_work_order_task PRIMARY KEY(`work_order_task_id`)
) COMMENT 'SSOT for individual task lines and material consumption within a maintenance work order. Represents the granular steps required to complete a maintenance activity, including spare parts issued and returned. Records task sequence number, task description, trade skill required, planned and actual labour hours, task status, assigned technician, start/end timestamps, safety permit reference (e.g., lock-out/tag-out), completion notes, spare parts consumed (part reference, quantity issued/returned, unit cost), and material cost per task. Enables detailed tracking of multi-step maintenance operations, parts consumption, and cost allocation on complex equipment such as STS cranes, ASCs, and AGVs. Sourced from Maximo Work Order Tasks and Inventory Transactions.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` (
    `failure_report_id` BIGINT COMMENT 'Unique identifier for the equipment failure report record. Primary key.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Berth infrastructure failures (fender collapse, bollard failure, shore power outage) generate failure reports that must be linked to the berth for root cause analysis, berth_delay_minutes attribution,',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal_equipment. Business justification: Equipment failure reports require operational equipment context for reliability analysis, operational impact assessment (TEU throughput loss, vessel delays), and maintenance planning. While failure_re',
    `inspection_record_id` BIGINT COMMENT 'Foreign key linking to asset.inspection_record. Business justification: A formal inspection (inspection_record) frequently discovers defects or non-conformances that trigger the creation of a failure_report. Linking failure_report.inspection_record_id → inspection_record.',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Equipment failures impacting contracted services must reference the affected agreement for SLA breach assessment, penalty calculation, and root cause accountability determination. Critical for termina',
    `port_asset_id` BIGINT COMMENT 'Reference to the port asset or equipment that experienced the failure. Links to the asset registry for cranes (STS, QC), RTG, ASC, AGV, MHC, forklifts, and port vehicles.',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: Asset failures (crane breakdown, fender damage) occurring during a specific vessel call must be attributed to that call for demurrage claims, liability determination, and insurance reporting. Linking ',
    `port_location_id` BIGINT COMMENT 'Reference to the employee (operator, supervisor, or maintenance technician) who first reported the failure event.',
    `previous_failure_report_id` BIGINT COMMENT 'Reference to the previous failure report for the same asset or component if this is a recurrence. Enables failure pattern analysis and chronic issue tracking.',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Quay wall structural failures (cracking, settlement, overloading) require failure reports linked to the specific wall for structural_condition_rating updates, insurance claims, regulatory notification',
    `rail_wagon_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_wagon. Business justification: Rail wagon failures (derailments, brake failures, structural damage) at port terminals generate formal failure reports for root cause analysis, insurance claims, and regulatory notification. failure_r',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: When asset failures involve third-party operated equipment or contractor-maintained assets, the responsible port community participant must be formally tracked for liability determination, warranty cl',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Terminal zone infrastructure failures (pavement collapse, reefer plug bank failure, fire suppression system failure) generate failure reports linked to the zone for operational impact assessment, zone',
    `tug_id` BIGINT COMMENT 'Foreign key linking to marine.tug. Business justification: Tug failure reports require operational context (bollard pull applied at failure, tow line configuration, engagement duration, sea state) for root cause analysis and corrective action design. Links as',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel that was being serviced when the failure occurred, if applicable. Links failure events to specific vessel operations for impact tracking.',
    `work_order_id` BIGINT COMMENT 'Reference to the corrective maintenance work order generated as a result of this failure event. Links to Maximo work order system.',
    `affected_component` STRING COMMENT 'The specific component or part that failed (e.g., motor bearing, hydraulic pump, wire rope, brake pad, PLC module, sensor). Supports root cause analysis and spare parts inventory optimization.',
    `affected_system` STRING COMMENT 'The major system or subsystem of the asset that was affected by the failure (e.g., hoist system, trolley drive, spreader mechanism, boom structure, control system).',
    `ambient_temperature_c` DECIMAL(18,2) COMMENT 'Ambient temperature in degrees Celsius at the time of failure. Relevant for temperature-sensitive equipment and thermal stress analysis.',
    `berth_delay_minutes` STRING COMMENT 'Total delay in minutes caused to vessel berthing or departure operations as a result of the equipment failure. Impacts SLA (Service Level Agreement) compliance and customer satisfaction.',
    `corrective_action_recommendation` STRING COMMENT 'Recommended corrective actions to prevent recurrence, such as design modifications, maintenance procedure changes, operator training, or spare parts stocking adjustments.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the failure report record was first created in the asset management system. Used for audit trail and data lineage.',
    `cycles_at_failure` BIGINT COMMENT 'Total cumulative operational cycles (e.g., crane lifts, RTG moves) of the asset at the time of failure. Used for cycle-based reliability and fatigue analysis.',
    `days_since_last_pm` STRING COMMENT 'Number of days elapsed between the last preventive maintenance service and the failure event. Key metric for maintenance interval optimization.',
    `detection_datetime` TIMESTAMP COMMENT 'The date and time when the failure was first detected or reported, which may differ from the actual failure occurrence time.',
    `downtime_hours` DECIMAL(18,2) COMMENT 'Total equipment downtime in hours from failure occurrence to return to service. Critical KPI for MTTR (Mean Time To Repair) and availability calculations.',
    `environmental_impact_flag` BOOLEAN COMMENT 'Boolean indicator of whether the equipment failure resulted in environmental impact such as fluid spills, emissions, or other environmental incidents requiring reporting under MARPOL or ISO 14001.',
    `estimated_repair_cost` DECIMAL(18,2) COMMENT 'Estimated cost of repair in local currency based on initial assessment. Used for budgeting, financial impact analysis, and CAPEX/OPEX planning.',
    `failure_class` STRING COMMENT 'Primary classification of the failure type: mechanical, electrical, hydraulic, structural, software, or pneumatic. Enables targeted maintenance strategy and spare parts planning.. Valid values are `mechanical|electrical|hydraulic|structural|software|pneumatic`',
    `failure_datetime` TIMESTAMP COMMENT 'The exact date and time when the equipment failure occurred. Critical for MTBF (Mean Time Between Failures) calculation and downtime analysis.',
    `failure_description` STRING COMMENT 'Detailed narrative description of the failure event, including symptoms observed, conditions at time of failure, and any unusual circumstances. Critical for root cause analysis and knowledge management.',
    `failure_mode` STRING COMMENT 'Classification of how the equipment failed: complete breakdown, degraded performance, intermittent fault, safety shutdown, overload trip, or component wear. Used for failure mode and effects analysis (FMEA).. Valid values are `complete_breakdown|degraded_performance|intermittent_fault|safety_shutdown|overload_trip|component_wear`',
    `failure_recurrence_flag` BOOLEAN COMMENT 'Boolean indicator of whether this failure is a recurrence of a previously reported failure on the same asset or component. Used to identify chronic reliability issues.',
    `failure_report_number` STRING COMMENT 'Business-facing unique identifier for the failure report, typically formatted as FR-YYYYMMDD or similar pattern for external reference and tracking.. Valid values are `^FR-[0-9]{8}$`',
    `failure_severity` STRING COMMENT 'Severity classification of the failure impact: critical (complete operational stoppage), major (significant capacity reduction), moderate (partial degradation), or minor (minimal impact).. Valid values are `critical|major|moderate|minor`',
    `immediate_action_taken` STRING COMMENT 'Description of immediate corrective or containment actions taken at the time of failure to mitigate safety risks, prevent further damage, or restore partial operations.',
    `investigation_assigned_to` BIGINT COMMENT 'Reference to the maintenance engineer or reliability analyst assigned to investigate the root cause of the failure and complete the failure analysis.',
    `investigation_completed_date` DATE COMMENT 'Date when the failure investigation and root cause analysis were completed. Used to track investigation cycle time and closure performance.',
    `last_pm_date` DATE COMMENT 'Date of the last completed preventive maintenance service prior to the failure. Used to analyze correlation between maintenance intervals and failure occurrence.',
    `load_at_failure_tonnes` DECIMAL(18,2) COMMENT 'The load being handled by the equipment in tonnes at the time of failure. Critical for overload analysis and SWL (Safe Working Load) compliance verification.',
    `maintenance_status_at_failure` STRING COMMENT 'The preventive maintenance status of the asset at the time of failure: current (up to date), overdue, recently completed, in warranty, or out of warranty. Used to correlate failures with maintenance compliance.. Valid values are `current|overdue|recently_completed|in_warranty|out_of_warranty`',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the failure report record was last modified. Tracks updates during investigation and analysis phases.',
    `operating_hours_at_failure` DECIMAL(18,2) COMMENT 'Total cumulative operating hours of the asset at the time of failure. Critical for age-based reliability analysis and MTBF calculation.',
    `operational_impact_description` STRING COMMENT 'Narrative description of the operational impact caused by the failure, including effects on vessel operations, cargo handling, berth availability, and terminal throughput.',
    `priority` STRING COMMENT 'Priority classification for the corrective maintenance work: emergency (immediate safety risk), urgent (critical operations impact), high, medium, or low. Drives work order scheduling and resource allocation.. Valid values are `emergency|urgent|high|medium|low`',
    `report_status` STRING COMMENT 'Current lifecycle status of the failure report: draft, submitted, under investigation, analysis complete, or closed. Tracks the failure investigation and resolution workflow.. Valid values are `draft|submitted|under_investigation|analysis_complete|closed`',
    `reported_by_role` STRING COMMENT 'The role or position of the person who reported the failure: operator, supervisor, maintenance technician, safety officer, or shift manager.. Valid values are `operator|supervisor|maintenance_technician|safety_officer|shift_manager`',
    `root_cause` STRING COMMENT 'Identified root cause of the failure after investigation, such as component fatigue, inadequate lubrication, operator error, design flaw, or environmental factors. May be populated after initial report during failure analysis.',
    `safety_incident_flag` BOOLEAN COMMENT 'Boolean indicator of whether the equipment failure resulted in or was associated with a safety incident requiring OHS (Occupational Health and Safety) investigation or reporting.',
    `swl_exceeded_flag` BOOLEAN COMMENT 'Boolean indicator of whether the Safe Working Load rating of the equipment was exceeded at the time of failure. Critical for safety compliance and liability assessment.',
    `teu_throughput_loss` STRING COMMENT 'Estimated loss in container handling capacity measured in TEU due to the equipment failure. Used for productivity impact analysis and financial loss calculation.',
    `warranty_claim_eligible_flag` BOOLEAN COMMENT 'Boolean indicator of whether the failure is eligible for warranty claim from the equipment manufacturer or supplier based on warranty terms and failure analysis.',
    `weather_conditions` STRING COMMENT 'Description of weather conditions at the time of failure (e.g., heavy rain, high wind, extreme temperature) that may have contributed to or influenced the failure event.',
    CONSTRAINT pk_failure_report PRIMARY KEY(`failure_report_id`)
) COMMENT 'Records equipment failure events and corrective maintenance triggers for port assets. Captures failure datetime, failure mode, failure class (mechanical/electrical/hydraulic/structural/software), affected system or component, reported by (operator/supervisor), failure description, operational impact (crane downtime, TEU throughput loss, berth delay), immediate action taken, and link to the resulting corrective work order. Supports reliability analysis, MTBF (Mean Time Between Failures) tracking, and OHS incident correlation. Sourced from Maximo and NAVIS N4 equipment downtime logs.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` (
    `inspection_record_id` BIGINT COMMENT 'Unique identifier for the inspection record. Primary key for the inspection_record data product.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Berths require mandatory structural inspections (fender condition, bollard SWL, quay face integrity) per port authority and flag state regulations. Inspection records must be directly linked to berths',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Navigation channels require hydrographic surveys and depth inspections mandated by dredging authorities and SOLAS. Survey/inspection records linked to channels support maintained depth compliance repo',
    `equipment_class_id` BIGINT COMMENT 'Reference to the standardized inspection checklist or template used during the inspection. Ensures consistency and completeness of inspection procedures.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal_equipment. Business justification: Equipment inspections (SWL certification, regulatory compliance) require operational equipment identifier for inspection scheduling, operational compliance tracking, and equipment certification status',
    `facility_id` BIGINT COMMENT 'Foreign key linking to infrastructure.facility. Business justification: Port facilities (container terminals, bulk terminals) require regulatory inspections for dangerous goods certification, ISPS compliance, and environmental certification. Inspection records linked to f',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: External inspectors (classification societies like Lloyds, DNV; regulatory surveyors; certification bodies) must be registered port community participants for facility access and accreditation verifi',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Port facility audits (ISO 9001, ISPS, OHSAS 18001) require inspection records as objective evidence. Auditors verify that statutory inspections (SWL tests, crane certifications) were completed per sch',
    `marpol_record_id` BIGINT COMMENT 'Foreign key linking to compliance.marpol_record. Business justification: PSC and port authority inspections of waste-handling and pollution-prevention equipment directly reference MARPOL records. When an inspection identifies MARPOL deficiencies (e.g., oily water separator',
    `port_asset_id` BIGINT COMMENT 'Foreign key reference to the asset that was inspected. Links to the asset registry for equipment such as Ship-to-Shore (STS) cranes, Rubber Tyred Gantry (RTG) cranes, Automated Stacking Cranes (ASC), Automated Guided Vehicles (AGV), Mobile Harbour Cranes (MHC), forklifts, and port vehicles.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Internal port asset inspections assign employees as inspectors. Tracks inspector assignment for compliance audits, workload planning, and certification verification. Inspector_name is denormalized emp',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Port authority inspection fees (statutory crane inspections, berth certifications, equipment load tests) are governed by published port tariff schedules. Compliance officers and billing teams require ',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Quay walls require periodic structural condition inspections (load capacity, seismic rating, fender system) mandated by port authorities and insurers. Inspection records linked directly to quay walls ',
    `rail_wagon_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_wagon. Business justification: Rail wagons entering port terminals are subject to mandatory safety inspections (brake tests, structural integrity, hazmat certification). inspection_record already covers terminal_equipment and tugs;',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Terminal zones require safety and pavement condition inspections (pavement_condition_rating, fire suppression, CCTV). Inspection records linked to terminal zones support next_inspection_due_date sched',
    `tug_id` BIGINT COMMENT 'Foreign key linking to marine.tug. Business justification: Statutory inspections of tugs (class surveys, FIFI certification, escort capability verification, bollard pull testing) require linking asset register to operational vessel data for compliance trackin',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Asset inspections requiring hot work (NDT, welding inspection), confined space entry (tank inspections), or working at height require permits. Maritime regulations mandate permit tracking for inspecti',
    `work_order_id` BIGINT COMMENT 'Foreign key reference to the work order generated to address inspection findings. Links inspection results to corrective maintenance activities.',
    `asset_operational_status_at_inspection` STRING COMMENT 'The operational status of the asset at the time of inspection. Indicates whether the asset was in active use, idle, undergoing maintenance, or out of service during the inspection.. Valid values are `operational|idle|under_maintenance|out_of_service`',
    `certificate_expiry_date` DATE COMMENT 'The date on which the inspection certificate expires. After this date, the asset may not be legally operated until re-inspected and re-certified.',
    `compliance_status` STRING COMMENT 'Indicates whether the asset meets all applicable regulatory and safety standards based on the inspection findings. Used for regulatory reporting and risk management.. Valid values are `compliant|non_compliant|partially_compliant`',
    `corrective_action_deadline` DATE COMMENT 'The date by which corrective actions must be completed. Driven by regulatory requirements, safety considerations, or operational impact.',
    `corrective_actions_required` STRING COMMENT 'Detailed description of the corrective actions, repairs, or remediation work required to address the inspection findings. Provides guidance for maintenance planning and work order generation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this inspection record was first created in the system. Used for audit trail and data lineage tracking.',
    `critical_defects_count` STRING COMMENT 'Number of critical severity defects identified. Critical defects pose immediate safety risks or operational hazards requiring urgent corrective action.',
    `defect_severity_highest` STRING COMMENT 'The highest severity level among all defects identified during the inspection. Used for prioritization and escalation decisions.. Valid values are `critical|major|minor|none`',
    `defects_identified_count` STRING COMMENT 'Total number of defects, non-conformances, or issues identified during the inspection. Used for trend analysis and asset reliability metrics.',
    `findings_summary` STRING COMMENT 'High-level summary of the inspection findings. Provides an overview of the asset condition, compliance status, and key observations made during the inspection.',
    `inspection_cost` DECIMAL(18,2) COMMENT 'Total cost incurred for conducting the inspection, including inspector fees, equipment rental, and administrative expenses. Used for maintenance budget tracking and cost analysis.',
    `inspection_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the inspection cost. Enables multi-currency financial reporting and analysis.. Valid values are `^[A-Z]{3}$`',
    `inspection_date` DATE COMMENT 'The date on which the inspection was conducted. Principal business event timestamp for the inspection activity.',
    `inspection_end_time` TIMESTAMP COMMENT 'Timestamp when the inspection activity was completed. Used to calculate inspection duration and resource utilization.',
    `inspection_frequency_days` STRING COMMENT 'The required interval in days between inspections for this asset type and inspection category. Driven by regulatory requirements, manufacturer recommendations, or internal policies.',
    `inspection_number` STRING COMMENT 'Business identifier for the inspection record. Externally-known unique reference number assigned to this inspection event for tracking and audit purposes.',
    `inspection_outcome` STRING COMMENT 'Overall pass/fail result of the inspection. Indicates whether the asset meets the required standards and is fit for continued operation. Conditional pass indicates minor issues that must be addressed within a specified timeframe.. Valid values are `pass|fail|conditional_pass|deferred`',
    `inspection_report_url` STRING COMMENT 'Link or file path to the detailed inspection report document. Provides access to supporting documentation, photographs, and detailed findings.',
    `inspection_scope` STRING COMMENT 'Detailed description of the areas, systems, and components covered by the inspection. Defines the boundaries and extent of the inspection activity.',
    `inspection_start_time` TIMESTAMP COMMENT 'Timestamp when the inspection activity commenced. Captures the precise start time for duration tracking and scheduling purposes.',
    `inspection_status` STRING COMMENT 'Current lifecycle status of the inspection record. Tracks whether the inspection is scheduled, in progress, completed, cancelled, or overdue.. Valid values are `scheduled|in_progress|completed|cancelled|overdue`',
    `inspection_type` STRING COMMENT 'Classification of the inspection. Indicates the nature and purpose of the inspection: statutory (mandated by law), periodic safety (scheduled safety checks), pre-operational (before equipment use), condition assessment (asset health evaluation), Port State Control (PSC), International Ship and Port Facility Security (ISPS), load test, or Safe Working Load (SWL) verification. [ENUM-REF-CANDIDATE: statutory|periodic_safety|pre_operational|condition_assessment|psc|isps|load_test|swl_verification — 8 candidates stripped; promote to reference product]',
    `inspector_authority` STRING COMMENT 'The organization or regulatory body that the inspector represents. Examples include national maritime authority, Port State Control (PSC), International Maritime Organization (IMO), classification society, or internal maintenance department.',
    `inspector_certification_number` STRING COMMENT 'Professional certification or license number of the inspector. Validates the inspectors qualifications and authority to conduct the inspection.',
    `load_test_performed` BOOLEAN COMMENT 'Indicates whether a physical load test was performed during the inspection. Load tests are required for cranes and lifting equipment to verify structural integrity and capacity.',
    `load_test_weight` DECIMAL(18,2) COMMENT 'The weight in metric tonnes used during the load test. Typically set at a percentage above the Safe Working Load (SWL) to verify safety margins.',
    `major_defects_count` STRING COMMENT 'Number of major severity defects identified. Major defects significantly impact asset performance or compliance but do not pose immediate danger.',
    `minor_defects_count` STRING COMMENT 'Number of minor severity defects identified. Minor defects have limited impact on operations and can be addressed during routine maintenance.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this inspection record was last modified. Tracks the most recent update to the record for audit and version control purposes.',
    `next_inspection_due_date` DATE COMMENT 'The date by which the next inspection of this asset must be conducted. Calculated based on inspection frequency requirements, regulatory mandates, and asset condition.',
    `regulatory_reference` STRING COMMENT 'Citation of the specific regulation, standard, or code that mandates or governs this inspection. Examples include SOLAS Chapter V, ISPS Code Part A, national maritime safety regulations, or ISO standards.',
    `remarks` STRING COMMENT 'Additional comments, observations, or notes recorded by the inspector. Captures contextual information not covered by structured fields.',
    `swl_rating_verified` DECIMAL(18,2) COMMENT 'The Safe Working Load (SWL) rating verified during the inspection, measured in metric tonnes. Critical for crane and lifting equipment inspections to ensure safe operational limits.',
    `weather_conditions` STRING COMMENT 'Description of weather conditions during the inspection. Relevant for outdoor equipment inspections where weather may impact findings or inspection feasibility.',
    CONSTRAINT pk_inspection_record PRIMARY KEY(`inspection_record_id`)
) COMMENT 'Records all formal asset inspections conducted on port equipment, including statutory inspections (PSC, ISPS, national maritime authority), periodic safety inspections, pre-operational checks, and condition assessments. Captures inspection type, inspection date, inspector name and authority, inspection scope, findings summary, defects identified, defect severity (critical/major/minor), corrective actions required, pass/fail outcome, next inspection due date, and regulatory reference. Covers STS cranes, RTGs, ASCs, AGVs, MHC, forklifts, and port vehicles. Sourced from Maximo Inspection Records.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` (
    `spare_part_id` BIGINT COMMENT 'Unique identifier for the spare part record. Primary key for the spare part master catalogue.',
    `equipment_class_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_class. Business justification: spare_part currently has equipment_class as STRING. This should be normalized to FK to equipment_class.equipment_class_id. Enables proper parts cataloging by equipment class, supports parts compatibil',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Controlled spare parts (dual-use components, radioactive sources for scanners, certain chemicals) require import/export permits under national trade control regulations. Linking spare_part to import_e',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Spare parts for security equipment stored in restricted security zones require zone-based access control and inventory tracking. Operational necessity for MARSEC-level compliance and audit trails.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Spare parts suppliers must be registered port community participants for just-in-time delivery to port facilities, customs clearance of imported parts, ISPS security screening, and direct-to-maintenan',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Spare parts are physically stored in port warehouses. The existing warehouse_code plain attribute is a denormalized reference to the warehouse entity. A proper FK to warehouse supports inventory locat',
    `abc_classification` STRING COMMENT 'ABC inventory classification based on value and usage frequency. A-items are high-value/high-usage, C-items are low-value/low-usage. Used for inventory control strategy.. Valid values are `A|B|C`',
    `annual_usage_quantity` DECIMAL(18,2) COMMENT 'Total quantity consumed in the past 12 months. Used for demand forecasting, reorder point calculations, and ABC classification.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the spare part master record was first created in the system. Audit trail for data governance and compliance.',
    `criticality_classification` STRING COMMENT 'Business criticality rating of the spare part based on impact to port operations if unavailable. Critical parts support STS, QC, and other mission-critical equipment. Used for inventory prioritization and stocking decisions.. Valid values are `critical|essential|standard`',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the unit cost (e.g., USD, EUR, GBP). Supports multi-currency procurement and valuation.. Valid values are `^[A-Z]{3}$`',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the spare part is classified as hazardous material requiring special handling, storage, and disposal procedures per IMDG Code and MARPOL regulations.',
    `imdg_class` STRING COMMENT 'IMDG classification code for hazardous materials (e.g., Class 3 - Flammable Liquids, Class 8 - Corrosives). Required for compliance with maritime safety regulations.',
    `interchangeable_part_number` STRING COMMENT 'Alternative or substitute part number that can be used in place of this spare part. Supports supply chain flexibility and obsolescence management.',
    `last_issue_date` DATE COMMENT 'Date when this spare part was last issued from inventory for a work order or maintenance activity. Used for usage pattern analysis and demand forecasting.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the spare part master record. Used for change tracking and data quality monitoring.',
    `last_purchase_date` DATE COMMENT 'Date of the most recent purchase order for this spare part. Used for procurement pattern analysis and supplier performance tracking.',
    `lead_time_days` STRING COMMENT 'Average procurement lead time in days from purchase order placement to receipt at the warehouse. Used for inventory planning and reorder point calculations.',
    `minimum_stock_level` DECIMAL(18,2) COMMENT 'Minimum inventory quantity threshold below which replenishment should be triggered. Safety stock level to prevent stockouts for critical operations.',
    `obsolescence_status` STRING COMMENT 'Lifecycle status indicating whether the part is actively supported by the manufacturer or approaching end-of-life. Critical for long-term asset maintenance planning.. Valid values are `active|obsolete|phase_out|discontinued`',
    `part_category` STRING COMMENT 'High-level classification of the spare part by functional category. Used for inventory organization and procurement planning.. Valid values are `mechanical|electrical|hydraulic|structural|consumable|safety_equipment`',
    `part_description` STRING COMMENT 'Detailed textual description of the spare part including technical specifications, dimensions, and functional characteristics. Used for identification and procurement purposes.',
    `part_number` STRING COMMENT 'Internal part number assigned by the port authority for inventory management and procurement. Unique identifier used across Maximo Asset Management and SAP MM Materials Management systems.',
    `quantity_on_hand` DECIMAL(18,2) COMMENT 'Current physical inventory quantity available in stock across all storage locations. Real-time balance maintained by Maximo Spare Parts Inventory and SAP MM.',
    `quantity_on_order` DECIMAL(18,2) COMMENT 'Quantity currently on purchase orders awaiting delivery from suppliers. Used for inventory planning and replenishment forecasting.',
    `quantity_reserved` DECIMAL(18,2) COMMENT 'Quantity currently reserved for planned work orders or maintenance activities but not yet issued. Used for available-to-promise calculations.',
    `reorder_point` DECIMAL(18,2) COMMENT 'Inventory level at which a purchase requisition should be automatically generated. Calculated based on lead time demand and safety stock requirements.',
    `reorder_quantity` DECIMAL(18,2) COMMENT 'Standard quantity to order when replenishment is triggered. Economic order quantity (EOQ) or fixed lot size based on procurement strategy.',
    `shelf_life_days` STRING COMMENT 'Maximum storage duration in days before the spare part expires or degrades. Applicable to consumables, lubricants, seals, and time-sensitive components.',
    `spare_part_status` STRING COMMENT 'Current lifecycle status of the spare part master record. Active parts are available for procurement and issue; inactive parts are blocked from transactions.. Valid values are `active|inactive|discontinued|pending_approval`',
    `storage_location` STRING COMMENT 'Physical warehouse location identifier including warehouse code, aisle, rack, bin, and shelf position. Supports efficient picking and putaway operations.',
    `total_stock_value` DECIMAL(18,2) COMMENT 'Total inventory value calculated as quantity on hand multiplied by unit cost. Used for financial reporting and asset valuation per IAS 2 Inventories.',
    `un_number` STRING COMMENT 'Four-digit UN identification number for hazardous materials (e.g., UN1203 for gasoline). Required for transport documentation and safety data sheets.. Valid values are `^UN[0-9]{4}$`',
    `unit_cost` DECIMAL(18,2) COMMENT 'Standard unit cost of the spare part in the ports base currency. Used for inventory valuation and budgeting. Sourced from SAP MM Materials Management.',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure for inventory counting and procurement (e.g., each, meter, kilogram, liter, box, set). Aligns with SAP MM Materials Management UOM standards.. Valid values are `each|meter|kilogram|liter|box|set`',
    `warranty_period_months` STRING COMMENT 'Manufacturer warranty period in months from date of purchase. Used for warranty claim tracking and supplier performance evaluation.',
    CONSTRAINT pk_spare_part PRIMARY KEY(`spare_part_id`)
) COMMENT 'Master catalogue and inventory register of spare parts and consumables held for port asset maintenance. SSOT for spare parts master data within the asset domain. Captures part number, part description, OEM part reference, equipment class compatibility, unit of measure, minimum stock level, reorder point, lead time in days, storage location (warehouse bin), unit cost, total stock value, criticality classification (critical/essential/standard), and hazardous material flag. Integrates with Maximo Spare Parts Inventory and SAP MM Materials Management.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_parent_asset_port_asset_id` FOREIGN KEY (`parent_asset_port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ADD CONSTRAINT `fk_asset_work_order_task_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ADD CONSTRAINT `fk_asset_work_order_task_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_inspection_record_id` FOREIGN KEY (`inspection_record_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`inspection_record`(`inspection_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_previous_failure_report_id` FOREIGN KEY (`previous_failure_report_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`failure_report`(`failure_report_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ADD CONSTRAINT `fk_asset_spare_part_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`asset` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`asset` SET TAGS ('dbx_domain' = 'asset');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `equipment_class_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `parent_asset_port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Asset Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `asset_category` SET TAGS ('dbx_business_glossary_term' = 'Asset Category');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `asset_description` SET TAGS ('dbx_business_glossary_term' = 'Asset Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `asset_number` SET TAGS ('dbx_business_glossary_term' = 'Asset Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `asset_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `asset_status` SET TAGS ('dbx_business_glossary_term' = 'Asset Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `asset_status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_maintenance|decommissioned|reserved|out_of_service');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `capex_classification` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `capex_classification` SET TAGS ('dbx_value_regex' = 'new_acquisition|replacement|expansion|upgrade|refurbishment');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `criticality_rating` SET TAGS ('dbx_business_glossary_term' = 'Criticality Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `criticality_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `current_book_value` SET TAGS ('dbx_business_glossary_term' = 'Current Book Value');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `current_book_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Data Source System');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `data_source_system` SET TAGS ('dbx_value_regex' = 'maximo|sap_pm|navis_n4|manual_entry|other');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `decommissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Decommissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|units_of_production|sum_of_years_digits');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `environmental_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `grt` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `imo_number` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `imo_number` SET TAGS ('dbx_value_regex' = '^IMO[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Strategy');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `maintenance_strategy` SET TAGS ('dbx_value_regex' = 'preventive|predictive|corrective|condition_based|run_to_failure');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `mean_time_between_failures` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (MTBF)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `mean_time_to_repair` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (MTTR)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `model` SET TAGS ('dbx_business_glossary_term' = 'Model Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `nrt` SET TAGS ('dbx_business_glossary_term' = 'Net Registered Tonnage (NRT)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `residual_value` SET TAGS ('dbx_business_glossary_term' = 'Residual Value');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `rfid_tag_code` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Tag Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `serial_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `swl_rating` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life in Years');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `year_of_manufacture` SET TAGS ('dbx_business_glossary_term' = 'Year of Manufacture');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `equipment_class_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Class Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `acquisition_cost_range_usd` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost Range in United States Dollars (USD)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `acquisition_cost_range_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `annual_operating_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Annual Operating Cost in United States Dollars (USD)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `annual_operating_cost_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `automation_level` SET TAGS ('dbx_business_glossary_term' = 'Automation Level');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `automation_level` SET TAGS ('dbx_value_regex' = 'manual|semi_automated|fully_automated|remote_controlled');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Capacity in Twenty-foot Equivalent Units (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `certification_requirements` SET TAGS ('dbx_business_glossary_term' = 'Certification Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `class_code` SET TAGS ('dbx_business_glossary_term' = 'Equipment Class Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `class_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `class_description` SET TAGS ('dbx_business_glossary_term' = 'Equipment Class Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `class_name` SET TAGS ('dbx_business_glossary_term' = 'Equipment Class Name');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|units_of_production|sum_of_years_digits');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_business_glossary_term' = 'Emissions Standard');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `environmental_impact_category` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Category');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `environmental_impact_category` SET TAGS ('dbx_value_regex' = 'minimal|moderate|significant|high');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `equipment_category` SET TAGS ('dbx_business_glossary_term' = 'Equipment Category');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `equipment_category` SET TAGS ('dbx_value_regex' = 'cargo_handling|horizontal_transport|yard_equipment|marine_equipment|utility_equipment|support_vehicle');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `fuel_consumption_rate` SET TAGS ('dbx_business_glossary_term' = 'Fuel Consumption Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `imdg_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Compliance Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `inspection_frequency_days` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `interoperability_standard` SET TAGS ('dbx_business_glossary_term' = 'Interoperability Standard');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `kpi_benchmark_moves_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Benchmark Moves Per Hour');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'active|deprecated|obsolete|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `maintenance_complexity` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Complexity');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `maintenance_complexity` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `manufacturer_standard` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Standard');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `mean_time_between_failures_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (MTBF) in Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `mean_time_to_repair_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time To Repair (MTTR) in Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `mobility_type` SET TAGS ('dbx_business_glossary_term' = 'Mobility Type');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `mobility_type` SET TAGS ('dbx_value_regex' = 'fixed|rail_mounted|rubber_tyred|tracked|self_propelled|towed');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `noise_level_db` SET TAGS ('dbx_business_glossary_term' = 'Noise Level in Decibels (dB)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `operational_speed_range` SET TAGS ('dbx_business_glossary_term' = 'Operational Speed Range');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `operator_certification_required` SET TAGS ('dbx_business_glossary_term' = 'Operator Certification Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `operator_skill_level` SET TAGS ('dbx_business_glossary_term' = 'Operator Skill Level');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `operator_skill_level` SET TAGS ('dbx_value_regex' = 'basic|intermediate|advanced|expert');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `power_source` SET TAGS ('dbx_business_glossary_term' = 'Power Source');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `power_source` SET TAGS ('dbx_value_regex' = 'diesel|electric|hybrid|battery|manual');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `residual_value_percentage` SET TAGS ('dbx_business_glossary_term' = 'Residual Value Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `safety_risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Safety Risk Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `safety_risk_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `spare_parts_category` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Category');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `swl_rating_max_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) Rating Maximum in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `swl_rating_min_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) Rating Minimum in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life in Years');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `equipment_class_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `rail_wagon_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Wagon Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `auto_generate_work_order` SET TAGS ('dbx_business_glossary_term' = 'Auto Generate Work Order');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `compliance_certificate_required` SET TAGS ('dbx_business_glossary_term' = 'Compliance Certificate Required');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Maintenance Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `estimated_downtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Downtime Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `estimated_labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Labor Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `last_completed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Completed Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Days');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_frequency_unit` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Frequency Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_frequency_value` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Frequency Value');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `meter_reading_at_last_completion` SET TAGS ('dbx_business_glossary_term' = 'Meter Reading at Last Completion');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `next_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `next_due_meter_reading` SET TAGS ('dbx_business_glossary_term' = 'Next Due Meter Reading');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `oem_reference` SET TAGS ('dbx_business_glossary_term' = 'Original Equipment Manufacturer (OEM) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Name');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|suspended|archived');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Type');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'time_based|meter_based|condition_based|predictive|corrective|statutory');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `regulatory_requirement` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `required_trade_skills` SET TAGS ('dbx_business_glossary_term' = 'Required Trade Skills');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `revision_date` SET TAGS ('dbx_business_glossary_term' = 'Revision Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `safety_procedures` SET TAGS ('dbx_business_glossary_term' = 'Safety Procedures');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `seasonal_adjustment` SET TAGS ('dbx_business_glossary_term' = 'Seasonal Adjustment');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `seasonal_adjustment` SET TAGS ('dbx_value_regex' = 'none|summer|winter|monsoon|peak_season|off_peak');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `sla_requirement` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Requirement');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `task_checklist` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Task Checklist');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `task_description` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Task Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Equipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `marpol_record_id` SET TAGS ('dbx_business_glossary_term' = 'Marpol Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `rail_wagon_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Wagon Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Profile Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `tug_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `actual_contractor_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Contractor Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `actual_end_datetime` SET TAGS ('dbx_business_glossary_term' = 'Actual End Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `actual_labour_hours` SET TAGS ('dbx_business_glossary_term' = 'Actual Labour Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `actual_material_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Material Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `actual_start_datetime` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `completion_datetime` SET TAGS ('dbx_business_glossary_term' = 'Completion Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `created_datetime` SET TAGS ('dbx_business_glossary_term' = 'Created Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `downtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Downtime Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `equipment_shutdown_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Equipment Shutdown Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `estimated_contractor_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Contractor Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `estimated_labour_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Labour Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `estimated_material_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Material Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `external_work_order_reference` SET TAGS ('dbx_business_glossary_term' = 'External Work Order Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `failure_code` SET TAGS ('dbx_business_glossary_term' = 'Failure Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `failure_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}-[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `last_modified_datetime` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `parts_availability_status` SET TAGS ('dbx_business_glossary_term' = 'Parts Availability Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `parts_availability_status` SET TAGS ('dbx_value_regex' = 'available|on_order|backordered|not_required');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `planned_end_datetime` SET TAGS ('dbx_business_glossary_term' = 'Planned End Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `planned_start_datetime` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `resolution_description` SET TAGS ('dbx_business_glossary_term' = 'Resolution Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}-[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `safety_permit_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Permit Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `total_work_order_cost` SET TAGS ('dbx_business_glossary_term' = 'Total Work Order Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `warranty_claim_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `warranty_claim_reference` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `work_description` SET TAGS ('dbx_business_glossary_term' = 'Work Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `work_order_number` SET TAGS ('dbx_business_glossary_term' = 'Work Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `work_order_number` SET TAGS ('dbx_value_regex' = '^WO-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `work_order_status` SET TAGS ('dbx_business_glossary_term' = 'Work Order Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `work_order_type` SET TAGS ('dbx_business_glossary_term' = 'Work Order Type');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `work_order_type` SET TAGS ('dbx_value_regex' = 'preventive|corrective|emergency|inspection|overhaul|calibration');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `work_order_task_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Task ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `actual_labour_hours` SET TAGS ('dbx_business_glossary_term' = 'Actual Labour Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `asset_component` SET TAGS ('dbx_business_glossary_term' = 'Asset Component');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `certification_reference` SET TAGS ('dbx_business_glossary_term' = 'Certification Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `certification_required` SET TAGS ('dbx_business_glossary_term' = 'Certification Required');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `completion_notes` SET TAGS ('dbx_business_glossary_term' = 'Completion Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `environmental_impact_notes` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `equipment_downtime_required` SET TAGS ('dbx_business_glossary_term' = 'Equipment Downtime Required');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `failure_code` SET TAGS ('dbx_business_glossary_term' = 'Failure Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `inspection_result` SET TAGS ('dbx_business_glossary_term' = 'Inspection Result');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `inspection_result` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `measurement_reading` SET TAGS ('dbx_business_glossary_term' = 'Measurement Reading');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `planned_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `planned_labour_hours` SET TAGS ('dbx_business_glossary_term' = 'Planned Labour Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `planned_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `safety_permit_reference` SET TAGS ('dbx_business_glossary_term' = 'Safety Permit Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `task_description` SET TAGS ('dbx_business_glossary_term' = 'Task Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `task_priority` SET TAGS ('dbx_business_glossary_term' = 'Task Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `task_priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `task_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Task Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `task_status` SET TAGS ('dbx_business_glossary_term' = 'Task Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `task_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|cancelled|on_hold|failed');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `task_type` SET TAGS ('dbx_business_glossary_term' = 'Task Type');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `total_labour_cost` SET TAGS ('dbx_business_glossary_term' = 'Total Labour Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `total_task_cost` SET TAGS ('dbx_business_glossary_term' = 'Total Task Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `trade_skill_required` SET TAGS ('dbx_business_glossary_term' = 'Trade Skill Required');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `warranty_claim_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_report_id` SET TAGS ('dbx_business_glossary_term' = 'Failure Report ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Equipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `inspection_record_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Reported By Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `previous_failure_report_id` SET TAGS ('dbx_business_glossary_term' = 'Previous Failure Report ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `rail_wagon_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Wagon Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `tug_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `affected_component` SET TAGS ('dbx_business_glossary_term' = 'Affected Component');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `affected_system` SET TAGS ('dbx_business_glossary_term' = 'Affected System');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `ambient_temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Ambient Temperature (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `berth_delay_minutes` SET TAGS ('dbx_business_glossary_term' = 'Berth Delay Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `corrective_action_recommendation` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Recommendation');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `cycles_at_failure` SET TAGS ('dbx_business_glossary_term' = 'Cycles at Failure');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `days_since_last_pm` SET TAGS ('dbx_business_glossary_term' = 'Days Since Last Preventive Maintenance (PM)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `detection_datetime` SET TAGS ('dbx_business_glossary_term' = 'Detection Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `downtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Downtime Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `environmental_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `estimated_repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Repair Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `estimated_repair_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_class` SET TAGS ('dbx_business_glossary_term' = 'Failure Class');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_class` SET TAGS ('dbx_value_regex' = 'mechanical|electrical|hydraulic|structural|software|pneumatic');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_datetime` SET TAGS ('dbx_business_glossary_term' = 'Failure Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_description` SET TAGS ('dbx_business_glossary_term' = 'Failure Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_mode` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_mode` SET TAGS ('dbx_value_regex' = 'complete_breakdown|degraded_performance|intermittent_fault|safety_shutdown|overload_trip|component_wear');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_recurrence_flag` SET TAGS ('dbx_business_glossary_term' = 'Failure Recurrence Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_report_number` SET TAGS ('dbx_business_glossary_term' = 'Failure Report Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_report_number` SET TAGS ('dbx_value_regex' = '^FR-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_severity` SET TAGS ('dbx_business_glossary_term' = 'Failure Severity');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_severity` SET TAGS ('dbx_value_regex' = 'critical|major|moderate|minor');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `immediate_action_taken` SET TAGS ('dbx_business_glossary_term' = 'Immediate Action Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `investigation_assigned_to` SET TAGS ('dbx_business_glossary_term' = 'Investigation Assigned To');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `investigation_completed_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Completed Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `last_pm_date` SET TAGS ('dbx_business_glossary_term' = 'Last Preventive Maintenance (PM) Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `load_at_failure_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Load at Failure (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `maintenance_status_at_failure` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Status at Failure');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `maintenance_status_at_failure` SET TAGS ('dbx_value_regex' = 'current|overdue|recently_completed|in_warranty|out_of_warranty');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `operating_hours_at_failure` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours at Failure');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `operational_impact_description` SET TAGS ('dbx_business_glossary_term' = 'Operational Impact Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Repair Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'emergency|urgent|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `report_status` SET TAGS ('dbx_business_glossary_term' = 'Report Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `report_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_investigation|analysis_complete|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `reported_by_role` SET TAGS ('dbx_business_glossary_term' = 'Reported By Role');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `reported_by_role` SET TAGS ('dbx_value_regex' = 'operator|supervisor|maintenance_technician|safety_officer|shift_manager');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `root_cause` SET TAGS ('dbx_business_glossary_term' = 'Root Cause');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `safety_incident_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Incident Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `swl_exceeded_flag` SET TAGS ('dbx_business_glossary_term' = 'SWL (Safe Working Load) Exceeded Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `teu_throughput_loss` SET TAGS ('dbx_business_glossary_term' = 'TEU (Twenty-foot Equivalent Unit) Throughput Loss');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `warranty_claim_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Eligible Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `weather_conditions` SET TAGS ('dbx_business_glossary_term' = 'Weather Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_record_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Record Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `equipment_class_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Checklist Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Equipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `marpol_record_id` SET TAGS ('dbx_business_glossary_term' = 'Marpol Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `rail_wagon_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Wagon Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `tug_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `asset_operational_status_at_inspection` SET TAGS ('dbx_business_glossary_term' = 'Asset Operational Status at Inspection');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `asset_operational_status_at_inspection` SET TAGS ('dbx_value_regex' = 'operational|idle|under_maintenance|out_of_service');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `certificate_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|partially_compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `corrective_action_deadline` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Deadline');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `corrective_actions_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Actions Required');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `critical_defects_count` SET TAGS ('dbx_business_glossary_term' = 'Critical Defects Count');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `defect_severity_highest` SET TAGS ('dbx_business_glossary_term' = 'Highest Defect Severity');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `defect_severity_highest` SET TAGS ('dbx_value_regex' = 'critical|major|minor|none');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `defects_identified_count` SET TAGS ('dbx_business_glossary_term' = 'Defects Identified Count');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `findings_summary` SET TAGS ('dbx_business_glossary_term' = 'Findings Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_cost` SET TAGS ('dbx_business_glossary_term' = 'Inspection Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Inspection Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_end_time` SET TAGS ('dbx_business_glossary_term' = 'Inspection End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_frequency_days` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_outcome` SET TAGS ('dbx_business_glossary_term' = 'Inspection Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_outcome` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional_pass|deferred');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_report_url` SET TAGS ('dbx_business_glossary_term' = 'Inspection Report Uniform Resource Locator (URL)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_scope` SET TAGS ('dbx_business_glossary_term' = 'Inspection Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_start_time` SET TAGS ('dbx_business_glossary_term' = 'Inspection Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Inspection Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|overdue');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Type');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspector_authority` SET TAGS ('dbx_business_glossary_term' = 'Inspector Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspector_certification_number` SET TAGS ('dbx_business_glossary_term' = 'Inspector Certification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `load_test_performed` SET TAGS ('dbx_business_glossary_term' = 'Load Test Performed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `load_test_weight` SET TAGS ('dbx_business_glossary_term' = 'Load Test Weight');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `major_defects_count` SET TAGS ('dbx_business_glossary_term' = 'Major Defects Count');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `minor_defects_count` SET TAGS ('dbx_business_glossary_term' = 'Minor Defects Count');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Inspection Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `swl_rating_verified` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) Rating Verified');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `weather_conditions` SET TAGS ('dbx_business_glossary_term' = 'Weather Conditions During Inspection');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `equipment_class_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `abc_classification` SET TAGS ('dbx_business_glossary_term' = 'ABC Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `abc_classification` SET TAGS ('dbx_value_regex' = 'A|B|C');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `annual_usage_quantity` SET TAGS ('dbx_business_glossary_term' = 'Annual Usage Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `criticality_classification` SET TAGS ('dbx_business_glossary_term' = 'Criticality Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `criticality_classification` SET TAGS ('dbx_value_regex' = 'critical|essential|standard');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `interchangeable_part_number` SET TAGS ('dbx_business_glossary_term' = 'Interchangeable Part Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `last_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Last Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `last_purchase_date` SET TAGS ('dbx_business_glossary_term' = 'Last Purchase Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `minimum_stock_level` SET TAGS ('dbx_business_glossary_term' = 'Minimum Stock Level');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `obsolescence_status` SET TAGS ('dbx_business_glossary_term' = 'Obsolescence Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `obsolescence_status` SET TAGS ('dbx_value_regex' = 'active|obsolete|phase_out|discontinued');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `part_category` SET TAGS ('dbx_business_glossary_term' = 'Part Category');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `part_category` SET TAGS ('dbx_value_regex' = 'mechanical|electrical|hydraulic|structural|consumable|safety_equipment');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `part_description` SET TAGS ('dbx_business_glossary_term' = 'Part Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `quantity_on_hand` SET TAGS ('dbx_business_glossary_term' = 'Quantity on Hand');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `quantity_on_order` SET TAGS ('dbx_business_glossary_term' = 'Quantity on Order');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `quantity_reserved` SET TAGS ('dbx_business_glossary_term' = 'Quantity Reserved');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `reorder_quantity` SET TAGS ('dbx_business_glossary_term' = 'Reorder Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `shelf_life_days` SET TAGS ('dbx_business_glossary_term' = 'Shelf Life in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `spare_part_status` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `spare_part_status` SET TAGS ('dbx_value_regex' = 'active|inactive|discontinued|pending_approval');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `total_stock_value` SET TAGS ('dbx_business_glossary_term' = 'Total Stock Value');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `total_stock_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `unit_cost` SET TAGS ('dbx_business_glossary_term' = 'Unit Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `unit_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'each|meter|kilogram|liter|box|set');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period in Months');
