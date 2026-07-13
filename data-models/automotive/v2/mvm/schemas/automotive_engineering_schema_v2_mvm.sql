-- Schema for Domain: engineering | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-13 17:05:57

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`engineering` COMMENT 'Manages the full product design and development lifecycle including CAD (Computer-Aided Design), CAE (Computer-Aided Engineering), PLM (Product Lifecycle Management), and digital twin modeling. Owns engineering BOM, design specifications, CFD (Computational Fluid Dynamics), FEA (Finite Element Analysis), NVH (Noise Vibration Harshness) testing, prototype validation, and engineering change orders (ECO/ECN). Integrates with Siemens Teamcenter, CATIA, and ENOVIA for collaborative engineering.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` (
    `vehicle_program_id` BIGINT COMMENT 'Primary key for vehicle_program',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Program budgeting uses a Cost Center; finance cost center reports expenses per vehicle program.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Vehicle programs have budget_allocation that must be posted to specific GL accounts for R&D capitalization under IFRS/GAAP. Automotive OEMs assign programs to GL accounts to track capitalized developm',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Vehicle Program Management Report requires linking each engineering program to its product nameplate for schedule, cost, and compliance tracking.',
    `bom_version` STRING COMMENT 'Version identifier of the engineering Bill of Materials.',
    `budget_allocation` DECIMAL(18,2) COMMENT 'Total budget allocated to the program (currency defined by currency_code).',
    `cad_release_version` STRING COMMENT 'Version of the CAD data set released for the program.',
    `cae_release_version` STRING COMMENT 'Version of the CAE simulation package released for the program.',
    `vehicle_program_code` STRING COMMENT 'Business identifier used across systems to reference the program (e.g., "P1234").',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the vehicle program record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three‑letter currency code for monetary values.. Valid values are `^[A-Z]{3}$`',
    `vehicle_program_description` STRING COMMENT 'Free‑form textual description of the program objectives and scope.',
    `digital_twin_enabled` BOOLEAN COMMENT 'Indicates whether a digital twin is maintained for the vehicle program.',
    `drivetrain` STRING COMMENT 'Drive configuration of the vehicle.. Valid values are `FWD|RWD|AWD|4WD`',
    `emission_standard` STRING COMMENT 'Regulatory emissions standard the vehicle must meet.. Valid values are `EPA|Euro6|Euro5|CARB|UN/ECE`',
    `end_date` DATE COMMENT 'Target date for End of Production (EOP) of the program.',
    `engineering_change_order_count` STRING COMMENT 'Total number of ECOs/ECNs issued for the program.',
    `field_quality_investigation_count` STRING COMMENT 'Count of active field quality investigations for this vehicle program.',
    `launch_date` DATE COMMENT 'Planned calendar date for market launch of the vehicle.',
    `model_year_end` STRING COMMENT 'Last model year covered by the program.',
    `model_year_start` STRING COMMENT 'First model year covered by the program.',
    `vehicle_program_name` STRING COMMENT 'Human‑readable name of the vehicle program (e.g., "All‑New X5").',
    `notes` STRING COMMENT 'Additional remarks, observations, or comments captured by engineering.',
    `ota_update_capability` BOOLEAN COMMENT 'Indicates whether the vehicle will support Over‑The‑Air software updates.',
    `platform_architecture` STRING COMMENT 'Technical platform on which the vehicle is built (e.g., "Modular Electric Architecture").',
    `powertrain_type` STRING COMMENT 'Primary propulsion technology of the vehicle.. Valid values are `ICE|EV|HEV|PHEV|FCEV`',
    `regulatory_approval_status` STRING COMMENT 'Current status of regulatory approvals for the program.. Valid values are `pending|approved|rejected|under_review`',
    `segment` STRING COMMENT 'Market segment the vehicle belongs to (e.g., SUV, sedan).. Valid values are `sedan|suv|truck|crossover|van|coupe`',
    `start_date` DATE COMMENT 'Target date for Start of Production (SOP) of the program.',
    `target_cost_per_vehicle` DECIMAL(18,2) COMMENT 'Target average manufacturing cost per vehicle (currency defined by currency_code).',
    `target_emissions_g_per_km` DECIMAL(18,2) COMMENT 'Target CO₂ emissions in grams per kilometer.',
    `target_fuel_efficiency_mpg` DECIMAL(18,2) COMMENT 'Target fuel economy in miles per gallon for ICE/HEV variants.',
    `target_market` STRING COMMENT 'Primary geographic market(s) for the vehicle (e.g., "North America").',
    `target_production_volume` STRING COMMENT 'Planned total number of vehicles to be produced for the program.',
    `target_range_km` STRING COMMENT 'Target all‑electric driving range in kilometers for EV variants.',
    `target_weight_kg` DECIMAL(18,2) COMMENT 'Target curb weight of the vehicle in kilograms.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the vehicle program record.',
    `vehicle_class` STRING COMMENT 'Regulatory vehicle class (e.g., "Passenger", "Light Commercial").',
    `vehicle_program_status` STRING COMMENT 'Current lifecycle status of the program.. Valid values are `concept|development|validation|launch|completed|cancelled`',
    `vehicle_program_type` STRING COMMENT 'Classification of the program as a nameplate, platform, or concept.. Valid values are `nameplate|platform|concept`',
    CONSTRAINT pk_vehicle_program PRIMARY KEY(`vehicle_program_id`)
) COMMENT 'Master record for a vehicle development program (nameplate/platform program), capturing program code, program name, vehicle segment, platform architecture, SOP (Start of Production) target date, EOP (End of Production) date, MY (Model Year) scope, program phase (concept, development, validation, launch), program director, budget allocation, and program status. Serves as the top-level anchor for all engineering activities within a development cycle. Owned by Siemens Teamcenter PLM. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`bom` (
    `bom_id` BIGINT COMMENT 'Unique surrogate key for the engineering bill of materials record.',
    `change_id` BIGINT COMMENT 'Identifier of the engineering change order linked to this BOM revision.',
    `bom_engineering_change_order_change_id` BIGINT COMMENT 'Identifier of the engineering change order linked to this BOM revision.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: BOM cost allocation is performed via a Cost Center; replace plain cost_center attribute with FK for accurate finance reporting.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Needed for BOM‑to‑inventory allocation process, enabling the production scheduling system to reserve SKUs for each BOM.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: A BOM is always created for a specific vehicle development program. The bom table has a denormalized STRING column program_name that should be replaced by a proper FK to vehicle_program. One vehicle',
    `approval_date` DATE COMMENT 'Date on which the BOM revision was approved.',
    `approved_by` STRING COMMENT 'Name of the person who approved the BOM revision.',
    `bom_type` STRING COMMENT 'Classification of the BOM: engineering (eBOM), manufacturing (mBOM), or service (sBOM).. Valid values are `eBOM|mBOM|sBOM`',
    `change_reason` STRING COMMENT 'Reason documented for the latest BOM revision.',
    `bom_code` STRING COMMENT 'Business identifier that uniquely identifies the BOM within a program.',
    `compliance_standard` STRING COMMENT 'Regulatory or industry standard to which the BOM complies.. Valid values are `ISO26262|IATF16949|SAEJ3061`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the BOM record was first created.',
    `bom_description` STRING COMMENT 'Free‑text description of the BOM purpose and scope.',
    `effective_end_date` DATE COMMENT 'Date when the BOM expires or is superseded (nullable).',
    `effective_start_date` DATE COMMENT 'Date when the BOM becomes effective for production.',
    `is_locked` BOOLEAN COMMENT 'Indicates whether the BOM is locked for further changes.',
    `last_review_date` DATE COMMENT 'Date of the most recent engineering review of the BOM.',
    `lifecycle_status` STRING COMMENT 'Overall lifecycle status of the BOM record.. Valid values are `active|inactive|pending|retired`',
    `model_year` STRING COMMENT 'Model year of the vehicle for which the BOM is defined.',
    `bom_name` STRING COMMENT 'Human‑readable name of the engineering BOM.',
    `owner_department` STRING COMMENT 'Engineering department responsible for the BOM.',
    `plant_location` STRING COMMENT 'Identifier of the manufacturing plant where the BOM will be used.',
    `release_status` STRING COMMENT 'Current release state of the BOM.. Valid values are `draft|released|archived|obsolete`',
    `revision_number` STRING COMMENT 'Revision identifier of the BOM (e.g., A, B, C).',
    `total_parts_count` STRING COMMENT 'Number of distinct part numbers referenced in the BOM.',
    `total_quantity` STRING COMMENT 'Sum of all component quantities across the BOM.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the BOM record.',
    `vehicle_variant` STRING COMMENT 'Identifier for the specific vehicle variant (e.g., Sport, Luxury).',
    `version_number` STRING COMMENT 'Internal version counter for the BOM record.',
    CONSTRAINT pk_bom PRIMARY KEY(`bom_id`)
) COMMENT 'Engineering Bill of Materials (eBOM) header record representing the complete structured parts list for a vehicle program or variant at a specific revision level. Captures BOM type (eBOM, mBOM, sBOM), program reference, model year, configuration context, effectivity dates, release status, BOM owner, and PLM system source. The eBOM is the authoritative design-intent parts structure managed in Siemens Teamcenter and ENOVIA before handoff to manufacturing BOM.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`bom_line` (
    `bom_line_id` BIGINT COMMENT 'Unique identifier for the engineering_bom_line data product (auto-inserted pre-linking).',
    `bom_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_bom. Business justification: A line item belongs to a single engineering BOM; adding engineering_bom_id creates the required parent link.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: BOM line execution tracks which equipment assembles the part; needed for production scheduling and OEE reporting.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Parent assembly reference is a part_master; replace with descriptive FK to part_master.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Each BOM line maps to a stockable SKU for MRP explosion, production kitting, and procurement planning. Automotive ERP (SAP PP/MM) requires this link to translate engineering BOM lines into inventory r',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: BOM line sourcing assignment; procurement uses this FK to generate purchase orders for each part line.',
    CONSTRAINT pk_bom_line PRIMARY KEY(`bom_line_id`)
) COMMENT 'Individual line item within an engineering BOM, representing a single part-to-parent relationship in the BOM hierarchy. Captures parent assembly reference, child part number, find number, quantity, unit of measure, effectivity start/end dates, variant applicability, substitution flags, BOM level, and engineering change reference. Supports multi-level BOM explosion and where-used analysis. Sourced from Siemens Teamcenter BOM Management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`part_master` (
    `part_master_id` BIGINT COMMENT 'Primary key for part_master',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Part cost accounting charges material cost to a Cost Center; finance tracks part expenses per cost center.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: In automotive ERP (SAP), each part/material master is assigned a GL account via valuation class for inventory valuation (raw material, WIP, finished goods). This is a standard, mandatory configuration',
    `plant_id` BIGINT COMMENT 'Identifier of the engineer responsible for the part definition.',
    `cad_model_reference` STRING COMMENT 'Path or identifier of the CAD 3D model stored in the PLM system.',
    `cost_usd` DECIMAL(18,2) COMMENT 'Standard cost of the part in US dollars as defined in the ERP system.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the part master record was first created in the system.',
    `criticality` STRING COMMENT 'Criticality of the part to vehicle safety or performance.. Valid values are `low|medium|high|critical`',
    `drawing_number` STRING COMMENT 'Reference to the engineering drawing document for the part.',
    `effective_date` DATE COMMENT 'Date when the current part version became effective.',
    `eol_reason` STRING COMMENT 'Reason for part end‑of‑life (e.g., technology superseded, supplier discontinued).',
    `expiration_date` DATE COMMENT 'Date when the part is scheduled to be retired or become obsolete, if applicable.',
    `height_mm` DECIMAL(18,2) COMMENT 'Physical height of the part in millimetres.',
    `inspection_status` STRING COMMENT 'Result of the latest inspection.. Valid values are `passed|failed|rework|pending`',
    `is_active` BOOLEAN COMMENT 'Indicates whether the part is currently active for use in new designs.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent quality inspection of the part.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the part master record.',
    `lead_time_days` STRING COMMENT 'Average supplier lead time in days for this part.',
    `length_mm` DECIMAL(18,2) COMMENT 'Physical length of the part in millimetres.',
    `lifecycle_status` STRING COMMENT 'Current lifecycle state of the part within PLM.. Valid values are `in_work|released|obsoleted|pending_release|discontinued`',
    `material` STRING COMMENT 'Primary material composition of the part (e.g., steel, aluminum, plastic).',
    `obsolescence_notice` BOOLEAN COMMENT 'True if an official obsolescence notice has been issued for the part.',
    `part_classification` STRING COMMENT 'High‑level functional classification of the part.. Valid values are `mechanical|electrical|hydraulic|software|electronic|structural`',
    `part_description` STRING COMMENT 'Detailed description of the parts function, features, and application.',
    `part_family` STRING COMMENT 'Logical grouping of related parts sharing common characteristics.',
    `part_number` STRING COMMENT 'Unique part number assigned by the organization, used to identify the part across systems.',
    `part_type` STRING COMMENT 'Classification of the part by its role in the product structure.. Valid values are `raw|processed|assembly|subassembly|component`',
    `quality_rating` STRING COMMENT 'Quality rating based on internal quality metrics (e.g., PPAP status).. Valid values are `A|B|C|D|E|F`',
    `reach_compliance` BOOLEAN COMMENT 'Indicates whether the part complies with REACH chemical regulations (True=Compliant).',
    `revision_level` STRING COMMENT 'Current revision identifier of the part. [ENUM-REF-CANDIDATE: A|B|C|D|E|F|G|H|I|J — 10 candidates stripped; promote to reference product]',
    `rohs_compliance` BOOLEAN COMMENT 'Indicates whether the part complies with RoHS restrictions (True=Compliant).',
    `supplier_part_number` STRING COMMENT 'Part number used by the supplier for this component.',
    `version_number` STRING COMMENT 'Numeric version of the part master record for internal version control.',
    `volume_cm3` DECIMAL(18,2) COMMENT 'Calculated volume of the part in cubic centimetres.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Net weight of the part in kilograms.',
    `width_mm` DECIMAL(18,2) COMMENT 'Physical width of the part in millimetres.',
    CONSTRAINT pk_part_master PRIMARY KEY(`part_master_id`)
) COMMENT 'Engineering part master record representing a unique part or component managed within the PLM system. Captures part number, part name, part classification, material type, weight, dimensions, drawing number, CAD model reference, lifecycle state (in-work, released, obsolete), revision level, owning engineer, supplier part number, REACH/RoHS compliance flag, and part family. Authoritative source for engineering part identity in Siemens Teamcenter / PTC Windchill. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`design_specification` (
    `design_specification_id` BIGINT COMMENT 'System-generated unique identifier for the design specification record.',
    `change_id` BIGINT COMMENT 'Foreign key linking to engineering.change. Business justification: A design specification is frequently updated or created as a result of an Engineering Change Order (ECO/ECN). The design_specification table has denormalized columns change_order_number (STRING) and',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Design specifications carry cost_estimate_usd and are owned by engineering departments. In automotive R&D, each design spec is budgeted against a cost center for program cost allocation, R&D capitaliz',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: A design specification is typically written for a specific part or component managed in the PLM system. Linking design_specification to part_master establishes the authoritative traceability between t',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: A design specification is authored within the context of a vehicle development program. The design_specification table has a denormalized STRING column program that should be replaced by a proper FK',
    `approval_date` DATE COMMENT 'Date the specification was approved.',
    `approval_status` STRING COMMENT 'Current approval state of the specification.. Valid values are `approved|rejected|pending`',
    `approver` STRING COMMENT 'Name of the person who approved the specification.',
    `author` STRING COMMENT 'Name of the engineer or team that authored the specification.',
    `compliance_status` STRING COMMENT 'Regulatory compliance state of the specification.. Valid values are `compliant|non_compliant|pending`',
    `component_name` STRING COMMENT 'Specific component the specification describes.',
    `confidentiality_level` STRING COMMENT 'Internal classification indicating data sensitivity.. Valid values are `internal|confidential|restricted`',
    `cost_estimate_usd` DECIMAL(18,2) COMMENT 'Estimated cost to implement the specification, in US dollars.',
    `design_specification_description` STRING COMMENT 'Detailed narrative describing the design intent and scope.',
    `design_phase` STRING COMMENT 'Current phase of the design lifecycle.. Valid values are `concept|development|validation|production`',
    `dimensions_mm` STRING COMMENT 'Physical dimensions expressed as LxWxH in millimetres.',
    `document_status` STRING COMMENT 'Current lifecycle state of the specification document.. Valid values are `draft|in_review|approved|released|archived`',
    `effective_date` DATE COMMENT 'Date the specification becomes effective for design work.',
    `engineering_department` STRING COMMENT 'Department responsible for the specification (e.g., Powertrain, Chassis).',
    `expiration_date` DATE COMMENT 'Date after which the specification is no longer valid.',
    `interface_name` STRING COMMENT 'Interface name when the spec defines an interaction point between components.',
    `is_active` BOOLEAN COMMENT 'Indicates whether the specification is currently active.',
    `lifecycle_stage` STRING COMMENT 'Stage of the product lifecycle where the spec is applied.. Valid values are `prototype|pre_production|production|post_production`',
    `material_specification` STRING COMMENT 'Material(s) and grades specified for the component.',
    `obsolescence_date` DATE COMMENT 'Planned date when the specification will be retired.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `regulatory_reference` STRING COMMENT 'Regulatory standards referenced (e.g., FMVSS 123, UNECE R123).',
    `release_date` DATE COMMENT 'Date the specification was released for use.',
    `revision_date` DATE COMMENT 'Date the current revision was released.',
    `revision_number` STRING COMMENT 'Alphanumeric revision identifier (e.g., A, B, C).',
    `spec_number` STRING COMMENT 'Business identifier assigned to the specification, e.g., DS-2023-001.',
    `spec_type` STRING COMMENT 'Classification of the specification scope.. Valid values are `system|subsystem|component|interface`',
    `subsystem_name` STRING COMMENT 'Name of the subsystem within the system, if applicable.',
    `system_name` STRING COMMENT 'Name of the vehicle system covered (e.g., Powertrain, Chassis).',
    `target_performance_units` STRING COMMENT 'Units for the target performance value (e.g., Nm, kW).',
    `target_performance_value` DECIMAL(18,2) COMMENT 'Numeric target performance metric (e.g., torque, efficiency).',
    `test_method` STRING COMMENT 'Primary analysis or test method used to validate the spec.. Valid values are `CFD|FEA|NVH|Simulation|Physical_Test`',
    `test_result_summary` STRING COMMENT 'High‑level summary of test outcomes.',
    `title` STRING COMMENT 'Human‑readable title describing the purpose of the specification.',
    `updated_by` STRING COMMENT 'User identifier who last updated the record.',
    `version_number` STRING COMMENT 'Version string for the specification (e.g., 1.0, 2.1).',
    `weight_kg` DECIMAL(18,2) COMMENT 'Target weight of the component or system in kilograms.',
    `created_by` STRING COMMENT 'User identifier who created the record.',
    CONSTRAINT pk_design_specification PRIMARY KEY(`design_specification_id`)
) COMMENT 'Engineering design specification document record capturing the technical requirements and design intent for a vehicle system, subsystem, or component. Includes specification number, title, specification type (system, subsystem, component, interface), applicable program, revision history, author, approval status, linked requirements, target performance values, and regulatory references (FMVSS, UNECE, NCAP). Managed in Teamcenter or ENOVIA document management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`change` (
    `change_id` BIGINT COMMENT 'System-generated unique identifier for the engineering change record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: ECO process requires identifying which production equipment must be reconfigured; linking change to equipment enables change impact analysis report.',
    `plant_id` BIGINT COMMENT 'Identifier of the person or group that approved the change.',
    `affected_programs` STRING COMMENT 'Comma‑separated list of vehicle programs impacted by the change.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the change was formally approved.',
    `change_status` STRING COMMENT 'Current lifecycle status of the engineering change.. Valid values are `draft|under_review|approved|implemented|rejected`',
    `change_type` STRING COMMENT 'Classification of the change request: Engineering Change Request (ECR), Engineering Change Order (ECO), or Engineering Change Notice (ECN).. Valid values are `ECR|ECO|ECN`',
    `closure_date` DATE COMMENT 'Date when the change record was closed after implementation verification.',
    `compliance_flag` BOOLEAN COMMENT 'Indicates whether the change is driven by regulatory or standards compliance.',
    `cost_adjustments` DECIMAL(18,2) COMMENT 'Estimated cost adjustments (e.g., tooling, re‑work) associated with the change.',
    `cost_estimate_gross` DECIMAL(18,2) COMMENT 'Initial estimated total cost of the change before any adjustments.',
    `cost_net` DECIMAL(18,2) COMMENT 'Final net cost after applying adjustments.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the engineering change record was created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the cost estimates.. Valid values are `USD|EUR|JPY|GBP|CAD|AUD`',
    `change_description` STRING COMMENT 'Detailed narrative explaining the purpose and scope of the change.',
    `effective_date` DATE COMMENT 'Date on which the change becomes effective in production or documentation.',
    `impact_analysis` STRING COMMENT 'Summary of technical and cost impact analysis performed for the change.',
    `implementation_date` DATE COMMENT 'Target calendar date for implementing the approved change on the product.',
    `number` STRING COMMENT 'Business identifier assigned to the change request (e.g., EC2023001234).',
    `origin` STRING COMMENT 'Source of the change request: internal, supplier, or customer.. Valid values are `internal|supplier|customer`',
    `priority` STRING COMMENT 'Business priority assigned to the change (high, medium, low).. Valid values are `high|medium|low`',
    `reason_category` STRING COMMENT 'High‑level category describing why the change is initiated.. Valid values are `cost_reduction|quality|regulatory|customer_request|other`',
    `reason_detail` STRING COMMENT 'Free‑form text providing additional context for the change reason.',
    `request_timestamp` TIMESTAMP COMMENT 'Date and time when the change request was initially submitted.',
    `revision_number` STRING COMMENT 'Revision identifier for the engineering change document.',
    `risk_assessment` STRING COMMENT 'Detailed risk assessment narrative for the change.',
    `risk_level` STRING COMMENT 'Assessed risk level of the change to product quality, schedule, or cost.. Valid values are `low|medium|high|critical`',
    `scope` STRING COMMENT 'Scope of the change affecting a part, assembly, specification, or process.. Valid values are `part|assembly|specification|process`',
    `title` STRING COMMENT 'Short descriptive title of the engineering change.',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to the engineering change record.',
    `version` STRING COMMENT 'Version number of the change record, incremented on each revision.',
    CONSTRAINT pk_change PRIMARY KEY(`change_id`)
) COMMENT 'Engineering Change Order/Notice (ECO/ECN) record capturing a formal request to modify a part, assembly, design specification, or BOM. Includes change number, change type (ECR/ECO/ECN), title, reason for change (cost reduction, quality, regulatory, customer request), affected parts list, affected programs, initiator, approver chain, priority, implementation date, cost impact estimate, and change status (draft, under review, approved, implemented, rejected). Managed in Siemens Teamcenter Change Management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`validation_test` (
    `validation_test_id` BIGINT COMMENT 'Unique identifier for the validation test record.',
    `change_id` BIGINT COMMENT 'Foreign key linking to engineering.change. Business justification: Validation tests are frequently triggered by Engineering Change Orders — when a part is modified via an ECO, re-validation tests must be run to confirm the change does not introduce regressions. Linki',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Validation tests consume significant budget (facility, equipment, engineer time). Automotive R&D accounting tracks test program spend against cost centers for R&D expense vs. capitalization decisions ',
    `design_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.design_specification. Business justification: A validation test is executed to verify that a part or assembly meets its design specification. Linking validation_test to design_specification establishes the critical traceability chain: spec → test',
    `part_master_id` BIGINT COMMENT 'add column part_master_id (BIGINT) with FK to engineering.part_master.part_master_id - validation tests verify specific parts meet requirements',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Engineering validation tests (NVH, crash, emissions, durability) are physically conducted at specific plant facilities. This FK enables plant capability reporting, test scheduling against plant calend',
    `vehicle_program_id` BIGINT COMMENT 'add column vehicle_program_id (BIGINT) with FK to engineering.vehicle_program.vehicle_program_id - validation tests are conducted for specific vehicle programs',
    `approval_date` DATE COMMENT 'Date when the test was formally approved.',
    `approval_status` STRING COMMENT 'Approval state after review of test results.. Valid values are `approved|rejected|pending`',
    `approved_by` STRING COMMENT 'Name of the individual who approved the test.',
    `batch_number` STRING COMMENT 'Batch identifier linking the test to a production or prototype batch.',
    `validation_test_category` STRING COMMENT 'High‑level engineering domain of the test.. Valid values are `structural|powertrain|electronics|software`',
    `comments` STRING COMMENT 'Free‑form comments or observations recorded by the test engineer.',
    `compliance_standard` STRING COMMENT 'Specific regulatory standard evaluated by the test.. Valid values are `FMVSS|EPA|NCAP|WLTP`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the test record was created in the system.',
    `data_source_system` STRING COMMENT 'Originating system that captured the test data (e.g., Teamcenter, MES).',
    `disposition` STRING COMMENT 'Disposition decision based on test result.. Valid values are `accept|rework|reject`',
    `document_reference` STRING COMMENT 'Reference to supporting documentation (e.g., test plan PDF).',
    `duration_minutes` STRING COMMENT 'Total elapsed time of the test execution in minutes.',
    `emission_co2_g_per_km` DECIMAL(18,2) COMMENT 'Measured carbon dioxide emission per kilometer.',
    `engineer` STRING COMMENT 'Name of the engineer responsible for conducting the test.',
    `equipment_used` STRING COMMENT 'List of major equipment or rigs employed during the test.',
    `is_critical` BOOLEAN COMMENT 'Indicates whether the test is classified as critical for safety or compliance.',
    `validation_test_name` STRING COMMENT 'Descriptive name of the validation test.',
    `noise_db` DECIMAL(18,2) COMMENT 'Measured acoustic noise level in decibels.',
    `phase` STRING COMMENT 'Development phase during which the test was performed.. Valid values are `prototype|pre_production|production`',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Overall compliance status of the test against applicable regulations.',
    `report_url` STRING COMMENT 'Web address or path to the stored test report.',
    `result` STRING COMMENT 'Outcome of the test execution.. Valid values are `pass|fail|conditional`',
    `result_timestamp` TIMESTAMP COMMENT 'Timestamp when the test result was entered into the system.',
    `revision_number` STRING COMMENT 'Revision number of the test procedure or setup.',
    `standard_reference` STRING COMMENT 'Reference code or document identifier for the standard governing the test.',
    `target_emission_co2` DECIMAL(18,2) COMMENT 'Regulatory or design target for CO2 emission.',
    `target_noise_db` DECIMAL(18,2) COMMENT 'Target acoustic noise level for compliance.',
    `target_torque_nm` DECIMAL(18,2) COMMENT 'Target torque specification for the test.',
    `timestamp` TIMESTAMP COMMENT 'Date and time when the test was executed.',
    `torque_nm` DECIMAL(18,2) COMMENT 'Measured torque value in newton‑meters.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the test record.',
    `validation_test_status` STRING COMMENT 'Current lifecycle status of the test.. Valid values are `planned|in_progress|completed|cancelled`',
    `validation_test_type` STRING COMMENT 'Category of the validation test according to engineering verification plans.. Valid values are `DVP|PVP|PPAP|Durability|Emissions|NCAP`',
    `variance_percent` DECIMAL(18,2) COMMENT 'Percentage variance between measured and target values.',
    `version` STRING COMMENT 'Version identifier for the test procedure.',
    CONSTRAINT pk_validation_test PRIMARY KEY(`validation_test_id`)
) COMMENT 'Engineering validation test record capturing a physical or virtual test event performed on a prototype or production-intent part/vehicle. Includes test ID, test type (DVP — Design Verification Plan, PVP — Process Validation Plan, PPAP, durability, emissions, NCAP/WLTP, FMVSS), test name, test standard reference, test facility, test date, test engineer, test result (pass/fail/conditional), measured values vs. targets, and disposition. Supports DVP&R (Design Verification Plan and Report) tracking. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` (
    `homologation_requirement_id` BIGINT COMMENT 'Unique surrogate key for the homologation requirement record.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Homologation requirement must reference the homologation record that documents market approval for that requirement.',
    `vehicle_program_id` BIGINT COMMENT 'Identifier of the vehicle program to which this requirement belongs.',
    `homologation_requirement_code` STRING COMMENT 'Business identifier assigned to the requirement by the engineering organization.',
    `compliance_method` STRING COMMENT 'How compliance is demonstrated: test, calculation, or declaration.. Valid values are `test|calculation|declaration`',
    `compliance_status` STRING COMMENT 'Current status of the requirements compliance lifecycle.. Valid values are `pending|in_progress|compliant|non_compliant|exempt`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the homologation requirement record was first created in the system.',
    `homologation_requirement_description` STRING COMMENT 'Full textual description of what the regulation mandates.',
    `effective_date` DATE COMMENT 'Date when the requirement becomes legally effective.',
    `expiration_date` DATE COMMENT 'Date when the requirement is no longer applicable, if applicable.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether the requirement is mandatory (true) or optional (false).',
    `last_review_date` DATE COMMENT 'Date when the requirement was last reviewed for relevance or changes.',
    `market_region` STRING COMMENT 'Three‑letter ISO country/region code where the requirement applies. [ENUM-REF-CANDIDATE: USA|CAN|MEX|DEU|JPN|CHN|AUS|GBR — 8 candidates stripped; promote to reference product]',
    `notes` STRING COMMENT 'Free‑form comments or observations about the requirement.',
    `priority_level` STRING COMMENT 'Business priority assigned to the requirement for planning purposes.. Valid values are `high|medium|low`',
    `regulation_name` STRING COMMENT 'Name of the regulatory standard governing the requirement, e.g., FMVSS, ECE_R, CARB.. Valid values are `FMVSS|ECE_R|CARB|Euro_NCAP|WLTP|EPA`',
    `regulation_number` STRING COMMENT 'Official number or identifier of the regulation (e.g., FMVSS 123).',
    `submission_deadline` DATE COMMENT 'Latest date by which evidence of compliance must be submitted.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the requirement record.',
    `vehicle_model_year` STRING COMMENT 'Model year of the vehicle to which the requirement is tied.',
    `vehicle_variant` STRING COMMENT 'Specific variant or trim level of the vehicle (e.g., sport, hybrid).',
    CONSTRAINT pk_homologation_requirement PRIMARY KEY(`homologation_requirement_id`)
) COMMENT 'Homologation and regulatory requirement record capturing the specific regulatory standards and type-approval requirements that a vehicle or component must satisfy for a target market. Includes requirement ID, regulation name (FMVSS, ECE-R, CARB, Euro NCAP, WLTP, EPA), regulation number, market/region applicability, requirement description, compliance method (test, calculation, declaration), linked validation tests, compliance status, and submission deadline. Supports regulatory compliance and homologation engineering activities.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` (
    `ecu_specification_id` BIGINT COMMENT 'Primary key for ecu_specification',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: An ECU specification describes both the software and hardware definition of an Electronic Control Unit, which is a physical part managed in the PLM part master. The ecu_specification table has a denor',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: An ECU specification is developed for a specific vehicle program or platform. The ecu_specification table has a denormalized STRING column vehicle_platform that should be replaced by a proper FK to ',
    `applicable_model_years` STRING COMMENT 'Model year range for which the ECU specification is valid (e.g., 2023‑2025).',
    `applicable_vehicle_variants` STRING COMMENT 'Vehicle variants or trims that use this ECU.',
    `asw_release_date` DATE COMMENT 'Date of the ASW release.',
    `asw_release_number` STRING COMMENT 'Identifier for the automotive software (ASW) release.',
    `calibration_dataset_reference` STRING COMMENT 'Reference identifier for the calibration data set used by the ECU.',
    `communication_protocol` STRING COMMENT 'Primary vehicle network protocol used by the ECU.. Valid values are `CAN|LIN|Ethernet|FlexRay|MOST|CANFD`',
    `compliance_standard` STRING COMMENT 'Regulatory or quality standard applicable to the ECU.. Valid values are `ISO_26262|IATF_16949|ISO_9001`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the ECU specification record was created.',
    `ecu_specification_description` STRING COMMENT 'Free‑form description of the ECU functionality and purpose.',
    `diagnostic_trouble_code_support` STRING COMMENT 'List or description of DTCs supported by the ECU.',
    `dimensions_mm` STRING COMMENT 'Physical dimensions (L×W×H) in millimetres.',
    `ecu_family` STRING COMMENT 'Higher‑level family grouping for related ECUs.',
    `ecu_specification_status` STRING COMMENT 'Current lifecycle state of the ECU specification.. Valid values are `active|inactive|deprecated|retired|development|released`',
    `ecu_type` STRING COMMENT 'Classification of the ECU function (e.g., engine control, ADAS).. Valid values are `engine_control|transmission|adas|body_control|battery_management|infotainment`',
    `effective_end_date` DATE COMMENT 'Date when the ECU specification is retired or superseded.',
    `effective_start_date` DATE COMMENT 'Date when the ECU specification becomes effective.',
    `eol_date` DATE COMMENT 'Planned date when the ECU will be discontinued.',
    `functional_safety_asil` STRING COMMENT 'Automotive Safety Integrity Level per ISO 26262.. Valid values are `ASIL_A|ASIL_B|ASIL_C|ASIL_D`',
    `hardware_revision` STRING COMMENT 'Revision identifier for the ECU hardware.',
    `hardware_version` STRING COMMENT 'Version identifier of the ECU hardware revision.',
    `is_critical` BOOLEAN COMMENT 'Indicates whether the ECU is safety‑critical.',
    `max_operating_temperature_c` STRING COMMENT 'Maximum ambient temperature at which the ECU can operate safely.',
    `memory_size_mb` STRING COMMENT 'On‑board memory capacity in megabytes.',
    `min_operating_temperature_c` STRING COMMENT 'Minimum ambient temperature at which the ECU can operate safely.',
    `ecu_specification_name` STRING COMMENT 'Human‑readable name of the electronic control unit.',
    `power_consumption_w` DECIMAL(18,2) COMMENT 'Typical power consumption in watts.',
    `processing_speed_mhz` STRING COMMENT 'CPU processing speed in megahertz.',
    `regulatory_approval_status` STRING COMMENT 'Status of regulatory approval for the ECU (e.g., NHTSA, EPA).. Valid values are `approved|pending|rejected`',
    `release_status` STRING COMMENT 'Current release state of the ECU specification.. Valid values are `draft|released|archived|obsolete`',
    `software_release_notes` STRING COMMENT 'Free‑form notes describing changes in the software release.',
    `software_version` STRING COMMENT 'Version identifier of the ECU software (e.g., v1.2.3).',
    `supported_features` STRING COMMENT 'Comma‑separated list of functional features provided by the ECU.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the ECU specification.',
    `voltage_range_v` STRING COMMENT 'Operating voltage range expressed as min‑max volts.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Physical weight of the ECU unit.',
    CONSTRAINT pk_ecu_specification PRIMARY KEY(`ecu_specification_id`)
) COMMENT 'ECU (Electronic Control Unit) software and hardware specification record capturing the technical definition of an automotive electronic control module. Includes ECU ID, ECU name, ECU type (engine control, transmission, ADAS, body control, battery management), hardware part number, software version, calibration dataset reference, communication protocol (CAN, LIN, Ethernet, FlexRay), functional safety level (ASIL rating per ISO 26262), supplier reference, and release status. Critical for EV, HEV, and ADAS program engineering.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` (
    `powertrain_spec_id` BIGINT COMMENT 'Unique surrogate identifier for the powertrain specification record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Powertrain specs carry cost_estimate_usd and cost_currency, indicating budgeted R&D items. Automotive powertrain programs are tracked against dedicated cost centers for program financial control and R',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Powertrain specifications are defined per vehicle program; linking enables program-level aggregation and reporting.',
    `approval_date` DATE COMMENT 'Date when the specification received formal approval.',
    `approved_by` STRING COMMENT 'Name of the authority who approved the specification.',
    `architecture_type` STRING COMMENT 'Physical layout of the engine (inline, V, boxer, etc.).',
    `aspiration_type` STRING COMMENT 'Method of air induction for the engine.. Valid values are `naturally_aspirated|turbocharged|supercharged`',
    `battery_capacity_kwh` DECIMAL(18,2) COMMENT 'Energy storage capacity for electrified powertrains; null for ICE/HEV.',
    `powertrain_spec_code` STRING COMMENT 'Business identifier code used to reference the specification across systems.',
    `compliance_status` STRING COMMENT 'Overall regulatory compliance state of the specification.. Valid values are `compliant|non_compliant|pending`',
    `cost_estimate_usd` DECIMAL(18,2) COMMENT 'Estimated manufacturing cost for the powertrain.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the specification record was created.',
    `cylinder_count` STRING COMMENT 'Number of cylinders for internal combustion engines.',
    `dimensions_mm` STRING COMMENT 'Physical envelope of the powertrain expressed as LxWxH in millimetres.',
    `displacement_cc` STRING COMMENT 'Engine cylinder displacement for internal combustion variants.',
    `effective_end_date` DATE COMMENT 'Date after which the specification is no longer effective.',
    `effective_start_date` DATE COMMENT 'Date from which the specification is considered effective.',
    `emission_control_technology` STRING COMMENT 'Technology used to reduce exhaust emissions (e.g., catalytic converter, DPF, SCR).',
    `emissions_standard` STRING COMMENT 'Regulatory emissions standard the powertrain meets.. Valid values are `Euro6|EPA_Tier3|CARB_LEVIII|WLTP`',
    `end_of_production_date` DATE COMMENT 'Date when the powertrain ceased production.',
    `epa_range_miles` STRING COMMENT 'Estimated driving range under EPA test cycle.',
    `fuel_type` STRING COMMENT 'Primary fuel or energy source for the powertrain.. Valid values are `gasoline|diesel|electric|hydrogen|hybrid`',
    `is_locked` BOOLEAN COMMENT 'Indicates whether the specification is locked from further edits.',
    `last_review_date` DATE COMMENT 'Date of the most recent engineering review.',
    `model_year` STRING COMMENT 'Model year the specification applies to.',
    `powertrain_spec_name` STRING COMMENT 'Human‑readable name of the powertrain specification.',
    `notes` STRING COMMENT 'Free‑form comments or engineering notes.',
    `power_output_kw` DECIMAL(18,2) COMMENT 'Peak power rating of the powertrain.',
    `powertrain_spec_status` STRING COMMENT 'Current lifecycle status of the specification.. Valid values are `draft|active|retired|obsolete`',
    `powertrain_type` STRING COMMENT 'Classification of the powertrain technology.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `start_of_production_date` DATE COMMENT 'Date when the powertrain entered series production.',
    `target_program_code` STRING COMMENT 'Program identifier for which this specification is intended.',
    `thermal_management` STRING COMMENT 'Cooling/heating strategy used for the powertrain.. Valid values are `air|liquid|phase_change|heat_pump`',
    `torque_nm` DECIMAL(18,2) COMMENT 'Peak torque rating of the powertrain.',
    `transmission_type` STRING COMMENT 'Transmission architecture used with the powertrain.. Valid values are `manual|automatic|dual_clutch|CVT|e-gear`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the specification.',
    `vehicle_variant` STRING COMMENT 'Specific vehicle variant (e.g., trim level) the spec supports.',
    `version_number` STRING COMMENT 'Version identifier for the specification revision.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Mass of the powertrain assembly.',
    `wltp_range_km` STRING COMMENT 'Estimated driving range under WLTP test cycle.',
    CONSTRAINT pk_powertrain_spec PRIMARY KEY(`powertrain_spec_id`)
) COMMENT 'Powertrain engineering specification record capturing the technical definition of an ICE, HEV, PHEV, or EV powertrain system. Includes spec ID, powertrain type (ICE, HEV, PHEV, BEV, FCEV), engine or motor displacement/power rating, torque output, transmission type, battery capacity (kWh) for electrified variants, fuel type, emissions standard compliance (Euro 6, EPA Tier 3, CARB LEV III), WLTP/EPA range rating, thermal management approach, and target program applicability. Supports R&D and powertrain engineering teams. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`change_impact` (
    `change_impact_id` BIGINT COMMENT 'Primary key for the change impact association record',
    `change_id` BIGINT COMMENT 'Foreign key linking to the engineering change order that affects this part',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to the specific part affected by this change',
    `affected_parts` STRING COMMENT 'Comma‑separated list of part numbers (e.g., VIN, SKU) impacted by the change. [Moved from change: This STRING column containing comma-separated part numbers is a classic denormalization anti-pattern. It represents the many-to-many relationship that should be properly modeled in the change_impact association table. Each part reference should be a separate change_impact record with its own impact_analysis, effective_date, scope, and implementation_date.]',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this part was added to the changes affected parts list.',
    `effective_date` DATE COMMENT 'Date when the change becomes effective for this specific part. May differ across parts within the same change due to phased implementation or inventory depletion schedules.',
    `impact_analysis` STRING COMMENT 'Detailed technical and cost impact analysis for this specific part within the change. Describes how the change affects this parts design, manufacturing, or supply chain.',
    `implementation_date` DATE COMMENT 'Target date for implementing the change for this specific part in production or documentation. May vary by part based on tooling readiness, inventory levels, or supplier coordination.',
    `implementation_status` STRING COMMENT 'Current implementation status for this specific part within the change (planned, in_progress, completed, deferred, cancelled).',
    `last_updated_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to this change impact record.',
    `part_revision_after` STRING COMMENT 'Part revision level after the change is applied. Documents the resulting configuration.',
    `part_revision_before` STRING COMMENT 'Part revision level before the change is applied. Captures the baseline configuration.',
    `scope` STRING COMMENT 'Scope of the change as it applies to this specific part (e.g., design modification, material substitution, supplier change, dimensional tolerance update).',
    CONSTRAINT pk_change_impact PRIMARY KEY(`change_impact_id`)
) COMMENT 'This association product represents the impact relationship between an engineering change order and the specific parts it affects. It captures the detailed scope, timing, and analysis of how each change affects each individual part. Each record links one change to one affected part with attributes that describe the nature and implementation details of that specific impact.. Existence Justification: In automotive PLM, engineering changes routinely affect multiple parts (a single ECO may update dozens of parts in an assembly), and parts are subject to multiple changes over their lifecycle (design improvements, cost reductions, regulatory updates). The business actively manages the change impact or affected part list as a core PLM workflow, tracking which parts are affected by each change with part-specific implementation dates, impact analysis, and scope. This is a recognized operational entity in Teamcenter Change Management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` (
    `compliance_evidence_id` BIGINT COMMENT 'Unique surrogate key for the compliance evidence record.',
    `homologation_requirement_id` BIGINT COMMENT 'Foreign key linking to the homologation requirement being satisfied by the test.',
    `validation_test_id` BIGINT COMMENT 'Foreign key linking to the validation test that provides evidence of compliance.',
    `approval_date` DATE COMMENT 'Date when the compliance evidence was formally approved by the regulatory compliance team for this requirement.',
    `compliance_status` STRING COMMENT 'Status of compliance for this specific test-requirement pairing, indicating whether the test result satisfies the requirement.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the compliance evidence record was created.',
    `evidence_submission_date` DATE COMMENT 'Date when this compliance evidence was submitted to the regulatory authority.',
    `notes` STRING COMMENT 'Free-form comments about the applicability of this test to this requirement, including any conditional acceptance criteria or deviations.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Boolean indicator of whether this test-requirement pairing meets regulatory compliance standards.',
    `result` STRING COMMENT 'The test result outcome as it applies to this specific requirement (pass/fail/conditional).',
    `reviewer_name` STRING COMMENT 'Name of the homologation engineer or compliance specialist who reviewed and approved this evidence mapping.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the compliance evidence record.',
    CONSTRAINT pk_compliance_evidence PRIMARY KEY(`compliance_evidence_id`)
) COMMENT 'This association product represents the compliance evidence linking validation tests to homologation requirements in the type-approval process. Each record captures the formal mapping between a specific validation test execution and a regulatory requirement it satisfies, including compliance status, test result applicability, and approval tracking. This is a core operational entity in homologation engineering, actively managed by regulatory compliance engineers to demonstrate type-approval readiness.. Existence Justification: In automotive homologation and type-approval processes, validation tests and regulatory requirements have a genuine many-to-many operational relationship. A single validation test (e.g., WLTP emissions test) satisfies multiple regulatory requirements across different markets (EPA, CARB, Euro 6d), and a single requirement (e.g., FMVSS 208 frontal impact) is proven by multiple tests (crash test, sled test, simulation validation). Homologation engineers actively manage compliance evidence mappings as a core business process, tracking which tests satisfy which requirements with approval status, submission dates, and reviewer sign-offs.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ADD CONSTRAINT `fk_engineering_bom_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ADD CONSTRAINT `fk_engineering_bom_bom_engineering_change_order_change_id` FOREIGN KEY (`bom_engineering_change_order_change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ADD CONSTRAINT `fk_engineering_bom_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` ADD CONSTRAINT `fk_engineering_bom_line_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`bom`(`bom_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` ADD CONSTRAINT `fk_engineering_bom_line_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ADD CONSTRAINT `fk_engineering_design_specification_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ADD CONSTRAINT `fk_engineering_design_specification_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ADD CONSTRAINT `fk_engineering_design_specification_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ADD CONSTRAINT `fk_engineering_validation_test_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ADD CONSTRAINT `fk_engineering_validation_test_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ADD CONSTRAINT `fk_engineering_validation_test_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ADD CONSTRAINT `fk_engineering_validation_test_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ADD CONSTRAINT `fk_engineering_homologation_requirement_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ADD CONSTRAINT `fk_engineering_ecu_specification_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ADD CONSTRAINT `fk_engineering_ecu_specification_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ADD CONSTRAINT `fk_engineering_powertrain_spec_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ADD CONSTRAINT `fk_engineering_change_impact_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ADD CONSTRAINT `fk_engineering_change_impact_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ADD CONSTRAINT `fk_engineering_compliance_evidence_homologation_requirement_id` FOREIGN KEY (`homologation_requirement_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`homologation_requirement`(`homologation_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ADD CONSTRAINT `fk_engineering_compliance_evidence_validation_test_id` FOREIGN KEY (`validation_test_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`validation_test`(`validation_test_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`engineering` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`engineering` SET TAGS ('dbx_domain' = 'engineering');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` SET TAGS ('dbx_subdomain' = 'product_development');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `bom_version` SET TAGS ('dbx_business_glossary_term' = 'BOM Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `budget_allocation` SET TAGS ('dbx_business_glossary_term' = 'Program Budget Allocation');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `budget_allocation` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `cad_release_version` SET TAGS ('dbx_business_glossary_term' = 'CAD Release Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `cae_release_version` SET TAGS ('dbx_business_glossary_term' = 'CAE Release Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_description` SET TAGS ('dbx_business_glossary_term' = 'Program Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `digital_twin_enabled` SET TAGS ('dbx_business_glossary_term' = 'Digital Twin Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `drivetrain` SET TAGS ('dbx_business_glossary_term' = 'Drivetrain Configuration');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `drivetrain` SET TAGS ('dbx_value_regex' = 'FWD|RWD|AWD|4WD');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `emission_standard` SET TAGS ('dbx_business_glossary_term' = 'Emission Standard');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `emission_standard` SET TAGS ('dbx_value_regex' = 'EPA|Euro6|Euro5|CARB|UN/ECE');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'End of Production Target Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `engineering_change_order_count` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Order Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `launch_date` SET TAGS ('dbx_business_glossary_term' = 'Program Launch Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `model_year_end` SET TAGS ('dbx_business_glossary_term' = 'Model Year End');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `model_year_start` SET TAGS ('dbx_business_glossary_term' = 'Model Year Start');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_name` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Program Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `ota_update_capability` SET TAGS ('dbx_business_glossary_term' = 'OTA Update Capability Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `platform_architecture` SET TAGS ('dbx_business_glossary_term' = 'Platform Architecture');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|EV|HEV|PHEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|under_review');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `segment` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Segment');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `segment` SET TAGS ('dbx_value_regex' = 'sedan|suv|truck|crossover|van|coupe');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Start of Production Target Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_cost_per_vehicle` SET TAGS ('dbx_business_glossary_term' = 'Target Cost Per Vehicle');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_cost_per_vehicle` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_emissions_g_per_km` SET TAGS ('dbx_business_glossary_term' = 'Target Emissions (g/km)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_fuel_efficiency_mpg` SET TAGS ('dbx_business_glossary_term' = 'Target Fuel Efficiency (MPG)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_market` SET TAGS ('dbx_business_glossary_term' = 'Target Market Region');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_production_volume` SET TAGS ('dbx_business_glossary_term' = 'Target Production Volume');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_range_km` SET TAGS ('dbx_business_glossary_term' = 'Target Electric Range (km)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Target Vehicle Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_class` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Class');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_status` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_status` SET TAGS ('dbx_value_regex' = 'concept|development|validation|launch|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_type` SET TAGS ('dbx_value_regex' = 'nameplate|platform|concept');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` SET TAGS ('dbx_subdomain' = 'product_development');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering BOM ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `change_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Order ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_engineering_change_order_change_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Order ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_type` SET TAGS ('dbx_business_glossary_term' = 'BOM Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_type` SET TAGS ('dbx_value_regex' = 'eBOM|mBOM|sBOM');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Change Reason');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_code` SET TAGS ('dbx_business_glossary_term' = 'Engineering BOM Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_value_regex' = 'ISO26262|IATF16949|SAEJ3061');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_description` SET TAGS ('dbx_business_glossary_term' = 'BOM Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `is_locked` SET TAGS ('dbx_business_glossary_term' = 'Is Locked');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|retired');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_name` SET TAGS ('dbx_business_glossary_term' = 'Engineering BOM Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `owner_department` SET TAGS ('dbx_business_glossary_term' = 'Owner Department');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `plant_location` SET TAGS ('dbx_business_glossary_term' = 'Plant Location');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `release_status` SET TAGS ('dbx_business_glossary_term' = 'Release Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `release_status` SET TAGS ('dbx_value_regex' = 'draft|released|archived|obsolete');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `total_parts_count` SET TAGS ('dbx_business_glossary_term' = 'Total Parts Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `total_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Quantity');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `vehicle_variant` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Variant Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` SET TAGS ('dbx_subdomain' = 'product_development');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` ALTER COLUMN `bom_line_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for engineering_bom_line');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` ALTER COLUMN `bom_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Bom Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Assembly Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` SET TAGS ('dbx_subdomain' = 'product_development');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Owning Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `cad_model_reference` SET TAGS ('dbx_business_glossary_term' = 'CAD Model Reference');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Standard Cost (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `cost_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `criticality` SET TAGS ('dbx_business_glossary_term' = 'Criticality Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `criticality` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `drawing_number` SET TAGS ('dbx_business_glossary_term' = 'Drawing Number (DRW)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `eol_reason` SET TAGS ('dbx_business_glossary_term' = 'End‑of‑Life Reason');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `height_mm` SET TAGS ('dbx_business_glossary_term' = 'Height (mm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Inspection Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `inspection_status` SET TAGS ('dbx_value_regex' = 'passed|failed|rework|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Active Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `length_mm` SET TAGS ('dbx_business_glossary_term' = 'Length (mm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status (LCS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'in_work|released|obsoleted|pending_release|discontinued');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `material` SET TAGS ('dbx_business_glossary_term' = 'Material (MAT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `obsolescence_notice` SET TAGS ('dbx_business_glossary_term' = 'Obsolescence Notice Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_classification` SET TAGS ('dbx_business_glossary_term' = 'Part Classification');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_classification` SET TAGS ('dbx_value_regex' = 'mechanical|electrical|hydraulic|software|electronic|structural');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_description` SET TAGS ('dbx_business_glossary_term' = 'Part Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_family` SET TAGS ('dbx_business_glossary_term' = 'Part Family');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number (PN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_type` SET TAGS ('dbx_business_glossary_term' = 'Part Type (PT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_type` SET TAGS ('dbx_value_regex' = 'raw|processed|assembly|subassembly|component');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `quality_rating` SET TAGS ('dbx_business_glossary_term' = 'Quality Rating');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `quality_rating` SET TAGS ('dbx_value_regex' = 'A|B|C|D|E|F');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `reach_compliance` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `revision_level` SET TAGS ('dbx_business_glossary_term' = 'Revision Level (REV)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `rohs_compliance` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `supplier_part_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Part Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `volume_cm3` SET TAGS ('dbx_business_glossary_term' = 'Volume (cm³)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `width_mm` SET TAGS ('dbx_business_glossary_term' = 'Width (mm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` SET TAGS ('dbx_subdomain' = 'product_development');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Design Specification Identifier (DSID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `change_id` SET TAGS ('dbx_business_glossary_term' = 'Change Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date (Approval Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status (Approval Status)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'approved|rejected|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `approver` SET TAGS ('dbx_business_glossary_term' = 'Approver Name (Approver)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `author` SET TAGS ('dbx_business_glossary_term' = 'Author Name (Author)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status (Compliance)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `component_name` SET TAGS ('dbx_business_glossary_term' = 'Component Name (Component)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Level (Conf Level)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_value_regex' = 'internal|confidential|restricted');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `cost_estimate_usd` SET TAGS ('dbx_business_glossary_term' = 'Cost Estimate (USD) (Cost Est)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `design_specification_description` SET TAGS ('dbx_business_glossary_term' = 'Specification Description (Description)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `design_phase` SET TAGS ('dbx_business_glossary_term' = 'Design Phase (Phase)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `design_phase` SET TAGS ('dbx_value_regex' = 'concept|development|validation|production');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `dimensions_mm` SET TAGS ('dbx_business_glossary_term' = 'Dimensions (mm) (Dimensions)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `document_status` SET TAGS ('dbx_business_glossary_term' = 'Document Lifecycle Status (Doc Status)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `document_status` SET TAGS ('dbx_value_regex' = 'draft|in_review|approved|released|archived');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date (Effective Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `engineering_department` SET TAGS ('dbx_business_glossary_term' = 'Engineering Department (Dept)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date (Expiration Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `interface_name` SET TAGS ('dbx_business_glossary_term' = 'Interface Name (Interface)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag (Active)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Stage (Lifecycle)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_value_regex' = 'prototype|pre_production|production|post_production');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `material_specification` SET TAGS ('dbx_business_glossary_term' = 'Material Specification Details (Material Spec)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `obsolescence_date` SET TAGS ('dbx_business_glossary_term' = 'Obsolescence Date (Obsolescence Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (Created At)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (Updated At)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference Codes (Reg Ref)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `release_date` SET TAGS ('dbx_business_glossary_term' = 'Release Date (Release Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `revision_date` SET TAGS ('dbx_business_glossary_term' = 'Revision Date (Rev Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number (Rev No.)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `spec_number` SET TAGS ('dbx_business_glossary_term' = 'Design Specification Number (DSN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `spec_type` SET TAGS ('dbx_business_glossary_term' = 'Specification Type (Spec Type)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `spec_type` SET TAGS ('dbx_value_regex' = 'system|subsystem|component|interface');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `subsystem_name` SET TAGS ('dbx_business_glossary_term' = 'Subsystem Name (Subsystem)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `system_name` SET TAGS ('dbx_business_glossary_term' = 'System Name (System)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `target_performance_units` SET TAGS ('dbx_business_glossary_term' = 'Target Performance Units (Units)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `target_performance_value` SET TAGS ('dbx_business_glossary_term' = 'Target Performance Value (Target Perf)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `test_method` SET TAGS ('dbx_business_glossary_term' = 'Test Method (Test Method)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `test_method` SET TAGS ('dbx_value_regex' = 'CFD|FEA|NVH|Simulation|Physical_Test');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `test_result_summary` SET TAGS ('dbx_business_glossary_term' = 'Test Result Summary (Test Summary)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Specification Title (Title)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By (Updated By)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number (Version)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight (kg) (Weight)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By (Created By)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` SET TAGS ('dbx_subdomain' = 'change_management');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `affected_programs` SET TAGS ('dbx_business_glossary_term' = 'Affected Programs');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_status` SET TAGS ('dbx_business_glossary_term' = 'Change Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_status` SET TAGS ('dbx_value_regex' = 'draft|under_review|approved|implemented|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_type` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_type` SET TAGS ('dbx_value_regex' = 'ECR|ECO|ECN');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Change Closure Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_adjustments` SET TAGS ('dbx_business_glossary_term' = 'Cost Adjustments');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_adjustments` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_adjustments` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_estimate_gross` SET TAGS ('dbx_business_glossary_term' = 'Gross Cost Estimate');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_estimate_gross` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_estimate_gross` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_net` SET TAGS ('dbx_business_glossary_term' = 'Net Cost Estimate');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_net` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_net` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CAD|AUD');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_description` SET TAGS ('dbx_business_glossary_term' = 'Change Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `impact_analysis` SET TAGS ('dbx_business_glossary_term' = 'Impact Analysis');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `implementation_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Implementation Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `origin` SET TAGS ('dbx_business_glossary_term' = 'Change Origin');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `origin` SET TAGS ('dbx_value_regex' = 'internal|supplier|customer');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Change Priority');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `reason_category` SET TAGS ('dbx_business_glossary_term' = 'Change Reason Category');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `reason_category` SET TAGS ('dbx_value_regex' = 'cost_reduction|quality|regulatory|customer_request|other');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `reason_detail` SET TAGS ('dbx_business_glossary_term' = 'Change Reason Detail');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `request_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Change Request Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Change Revision Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `risk_assessment` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `scope` SET TAGS ('dbx_business_glossary_term' = 'Change Scope');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `scope` SET TAGS ('dbx_value_regex' = 'part|assembly|specification|process');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Change Title');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Change Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` SET TAGS ('dbx_subdomain' = 'regulatory_compliance');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_id` SET TAGS ('dbx_business_glossary_term' = 'Validation Test ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `change_id` SET TAGS ('dbx_business_glossary_term' = 'Change Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Design Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date (AD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Test Approval Status (TAS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'approved|rejected|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By (AB)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approved_by` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Test Batch Number (TBN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_category` SET TAGS ('dbx_business_glossary_term' = 'Test Category (TCAT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_category` SET TAGS ('dbx_value_regex' = 'structural|powertrain|electronics|software');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Test Comments (TC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard (CS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_value_regex' = 'FMVSS|EPA|NCAP|WLTP');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System for Test Data (SS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `disposition` SET TAGS ('dbx_business_glossary_term' = 'Test Disposition (TD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `disposition` SET TAGS ('dbx_value_regex' = 'accept|rework|reject');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Test Document Reference (TDR)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Test Duration (Minutes) (TDUR)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `emission_co2_g_per_km` SET TAGS ('dbx_business_glossary_term' = 'Measured CO2 Emission (g/km) (MCO2)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `engineer` SET TAGS ('dbx_business_glossary_term' = 'Test Engineer (TE)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `engineer` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `engineer` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `equipment_used` SET TAGS ('dbx_business_glossary_term' = 'Equipment Used (EU)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Test Flag (CTF)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_name` SET TAGS ('dbx_business_glossary_term' = 'Validation Test Name (VTN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `noise_db` SET TAGS ('dbx_business_glossary_term' = 'Measured Noise Level (dB) (MNL)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `phase` SET TAGS ('dbx_business_glossary_term' = 'Test Phase (TPH)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `phase` SET TAGS ('dbx_value_regex' = 'prototype|pre_production|production');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag (RCF)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `report_url` SET TAGS ('dbx_business_glossary_term' = 'Test Report URL (TRURL)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `result` SET TAGS ('dbx_business_glossary_term' = 'Test Result (TR)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `result` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `result_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Result Recording Timestamp (RRT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Test Revision Number (TRN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `standard_reference` SET TAGS ('dbx_business_glossary_term' = 'Test Standard Reference (TSR)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `target_emission_co2` SET TAGS ('dbx_business_glossary_term' = 'Target CO2 Emission (g/km) (TCO2)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `target_noise_db` SET TAGS ('dbx_business_glossary_term' = 'Target Noise Level (dB) (TNL)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `target_torque_nm` SET TAGS ('dbx_business_glossary_term' = 'Target Torque (Nm) (TTQ)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `timestamp` SET TAGS ('dbx_business_glossary_term' = 'Test Execution Timestamp (TET)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `torque_nm` SET TAGS ('dbx_business_glossary_term' = 'Measured Torque (Nm) (MTQ)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_status` SET TAGS ('dbx_business_glossary_term' = 'Test Status (TS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_type` SET TAGS ('dbx_business_glossary_term' = 'Validation Test Type (VTT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_type` SET TAGS ('dbx_value_regex' = 'DVP|PVP|PPAP|Durability|Emissions|NCAP');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `variance_percent` SET TAGS ('dbx_business_glossary_term' = 'Result Variance Percentage (RV%) (VVAR)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Test Version (TV)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` SET TAGS ('dbx_subdomain' = 'regulatory_compliance');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `homologation_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Homologation Requirement ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Associated Vehicle Program ID (Vehicle_Program_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `homologation_requirement_code` SET TAGS ('dbx_business_glossary_term' = 'Homologation Requirement Code (HRC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `compliance_method` SET TAGS ('dbx_business_glossary_term' = 'Compliance Method (Method)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `compliance_method` SET TAGS ('dbx_value_regex' = 'test|calculation|declaration');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status (Status)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|compliant|non_compliant|exempt');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (Created_Timestamp)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `homologation_requirement_description` SET TAGS ('dbx_business_glossary_term' = 'Requirement Description (Desc)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date (Effective_Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date (Expiration_Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory Flag (Mandatory_Flag)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date (Last_Review_Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `market_region` SET TAGS ('dbx_business_glossary_term' = 'Market Region Code (Region)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes (Notes)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level (Priority)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `regulation_name` SET TAGS ('dbx_business_glossary_term' = 'Regulation Name (Regulation)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `regulation_name` SET TAGS ('dbx_value_regex' = 'FMVSS|ECE_R|CARB|Euro_NCAP|WLTP|EPA');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `regulation_number` SET TAGS ('dbx_business_glossary_term' = 'Regulation Number (Regulation_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `submission_deadline` SET TAGS ('dbx_business_glossary_term' = 'Submission Deadline (Deadline)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp (Updated_Timestamp)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `vehicle_model_year` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `vehicle_variant` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Variant Identifier (Variant)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` SET TAGS ('dbx_subdomain' = 'product_development');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Ecu Specification Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `applicable_model_years` SET TAGS ('dbx_business_glossary_term' = 'Applicable Model Years');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `applicable_vehicle_variants` SET TAGS ('dbx_business_glossary_term' = 'Applicable Vehicle Variants');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `asw_release_date` SET TAGS ('dbx_business_glossary_term' = 'ASW Release Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `asw_release_number` SET TAGS ('dbx_business_glossary_term' = 'ASW Release Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `calibration_dataset_reference` SET TAGS ('dbx_business_glossary_term' = 'Calibration Dataset Reference');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `communication_protocol` SET TAGS ('dbx_business_glossary_term' = 'Communication Protocol');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `communication_protocol` SET TAGS ('dbx_value_regex' = 'CAN|LIN|Ethernet|FlexRay|MOST|CANFD');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_value_regex' = 'ISO_26262|IATF_16949|ISO_9001');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_specification_description` SET TAGS ('dbx_business_glossary_term' = 'ECU Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `diagnostic_trouble_code_support` SET TAGS ('dbx_business_glossary_term' = 'Diagnostic Trouble Code Support');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `dimensions_mm` SET TAGS ('dbx_business_glossary_term' = 'ECU Dimensions (mm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_family` SET TAGS ('dbx_business_glossary_term' = 'ECU Family');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_specification_status` SET TAGS ('dbx_business_glossary_term' = 'ECU Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_specification_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|retired|development|released');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_type` SET TAGS ('dbx_business_glossary_term' = 'ECU Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_type` SET TAGS ('dbx_value_regex' = 'engine_control|transmission|adas|body_control|battery_management|infotainment');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `eol_date` SET TAGS ('dbx_business_glossary_term' = 'End‑of‑Life Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `functional_safety_asil` SET TAGS ('dbx_business_glossary_term' = 'Functional Safety ASIL Rating');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `functional_safety_asil` SET TAGS ('dbx_value_regex' = 'ASIL_A|ASIL_B|ASIL_C|ASIL_D');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `hardware_revision` SET TAGS ('dbx_business_glossary_term' = 'Hardware Revision');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `hardware_version` SET TAGS ('dbx_business_glossary_term' = 'Hardware Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical ECU Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `max_operating_temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Maximum Operating Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `memory_size_mb` SET TAGS ('dbx_business_glossary_term' = 'Memory Size (MB)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `min_operating_temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Minimum Operating Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_specification_name` SET TAGS ('dbx_business_glossary_term' = 'ECU Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `power_consumption_w` SET TAGS ('dbx_business_glossary_term' = 'Power Consumption (W)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `processing_speed_mhz` SET TAGS ('dbx_business_glossary_term' = 'Processing Speed (MHz)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_value_regex' = 'approved|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `release_status` SET TAGS ('dbx_business_glossary_term' = 'Release Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `release_status` SET TAGS ('dbx_value_regex' = 'draft|released|archived|obsolete');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `software_release_notes` SET TAGS ('dbx_business_glossary_term' = 'Software Release Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `software_version` SET TAGS ('dbx_business_glossary_term' = 'Software Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `supported_features` SET TAGS ('dbx_business_glossary_term' = 'Supported Features');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `voltage_range_v` SET TAGS ('dbx_business_glossary_term' = 'Voltage Range (V)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'ECU Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` SET TAGS ('dbx_subdomain' = 'product_development');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_spec_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Specification ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `architecture_type` SET TAGS ('dbx_business_glossary_term' = 'Engine Architecture Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `aspiration_type` SET TAGS ('dbx_business_glossary_term' = 'Aspiration Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `aspiration_type` SET TAGS ('dbx_value_regex' = 'naturally_aspirated|turbocharged|supercharged');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_business_glossary_term' = 'Battery Capacity (kWh)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_spec_code` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Specification Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `cost_estimate_usd` SET TAGS ('dbx_business_glossary_term' = 'Cost Estimate (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `cylinder_count` SET TAGS ('dbx_business_glossary_term' = 'Cylinder Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `dimensions_mm` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Dimensions (mm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `displacement_cc` SET TAGS ('dbx_business_glossary_term' = 'Engine Displacement (cubic centimeters)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `emission_control_technology` SET TAGS ('dbx_business_glossary_term' = 'Emission Control Technology');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_business_glossary_term' = 'Emissions Standard Compliance');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_value_regex' = 'Euro6|EPA_Tier3|CARB_LEVIII|WLTP');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `end_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'End of Production Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `epa_range_miles` SET TAGS ('dbx_business_glossary_term' = 'EPA Range (miles)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `fuel_type` SET TAGS ('dbx_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `fuel_type` SET TAGS ('dbx_value_regex' = 'gasoline|diesel|electric|hydrogen|hybrid');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `is_locked` SET TAGS ('dbx_business_glossary_term' = 'Specification Lock Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_spec_name` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Specification Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Specification Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `power_output_kw` SET TAGS ('dbx_business_glossary_term' = 'Maximum Power Output (kW)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_spec_status` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Specification Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_spec_status` SET TAGS ('dbx_value_regex' = 'draft|active|retired|obsolete');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type (ICE|HEV|PHEV|BEV|FCEV)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `start_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'Start of Production Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `target_program_code` SET TAGS ('dbx_business_glossary_term' = 'Target Vehicle Program Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `thermal_management` SET TAGS ('dbx_business_glossary_term' = 'Thermal Management Approach');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `thermal_management` SET TAGS ('dbx_value_regex' = 'air|liquid|phase_change|heat_pump');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `torque_nm` SET TAGS ('dbx_business_glossary_term' = 'Maximum Torque (Nm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'manual|automatic|dual_clutch|CVT|e-gear');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `vehicle_variant` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Variant');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Specification Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `wltp_range_km` SET TAGS ('dbx_business_glossary_term' = 'WLTP Range (km)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` SET TAGS ('dbx_subdomain' = 'change_management');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` SET TAGS ('dbx_association_edges' = 'engineering.change,engineering.part_master');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `change_impact_id` SET TAGS ('dbx_business_glossary_term' = 'Change Impact Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `change_id` SET TAGS ('dbx_business_glossary_term' = 'Change Impact - Change Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Change Impact - Part Master Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `affected_parts` SET TAGS ('dbx_business_glossary_term' = 'Affected Parts');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Impact Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Part Effective Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `impact_analysis` SET TAGS ('dbx_business_glossary_term' = 'Part-Specific Impact Analysis');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `implementation_date` SET TAGS ('dbx_business_glossary_term' = 'Part Implementation Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `implementation_status` SET TAGS ('dbx_business_glossary_term' = 'Part Implementation Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Impact Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `part_revision_after` SET TAGS ('dbx_business_glossary_term' = 'Part Revision After Change');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `part_revision_before` SET TAGS ('dbx_business_glossary_term' = 'Part Revision Before Change');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change_impact` ALTER COLUMN `scope` SET TAGS ('dbx_business_glossary_term' = 'Part Change Scope');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` SET TAGS ('dbx_subdomain' = 'regulatory_compliance');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` SET TAGS ('dbx_association_edges' = 'engineering.validation_test,engineering.homologation_requirement');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `compliance_evidence_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evidence Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `homologation_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evidence - Homologation Requirement Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `validation_test_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evidence - Validation Test Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `evidence_submission_date` SET TAGS ('dbx_business_glossary_term' = 'Evidence Submission Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Evidence Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `result` SET TAGS ('dbx_business_glossary_term' = 'Test Result');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `reviewer_name` SET TAGS ('dbx_business_glossary_term' = 'Reviewer Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`compliance_evidence` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
