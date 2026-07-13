-- Schema for Domain: engineering | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:51

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`engineering` COMMENT 'Manages the full product design and development lifecycle including CAD (Computer-Aided Design), CAE (Computer-Aided Engineering), PLM (Product Lifecycle Management), and digital twin modeling. Owns engineering BOM, design specifications, CFD (Computational Fluid Dynamics), FEA (Finite Element Analysis), NVH (Noise Vibration Harshness) testing, prototype validation, and engineering change orders (ECO/ECN). Integrates with Siemens Teamcenter, CATIA, and ENOVIA for collaborative engineering.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` (
    `vehicle_program_id` BIGINT COMMENT 'Primary key for vehicle_program',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Program budgeting uses a Cost Center; finance cost center reports expenses per vehicle program.',
    `employee_id` BIGINT COMMENT 'Surrogate key of the manager overseeing day‑to‑day execution.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Foreign key linking to product.nameplate. Business justification: Vehicle Program Management Report requires linking each engineering program to its product nameplate for schedule, cost, and compliance tracking.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Program profitability analysis assigns each vehicle program to a Profit Center for revenue and margin reporting.',
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
    `vehicle_program_status` STRING COMMENT 'Current lifecycle status of the program.. Valid values are `concept|development|validation|launch|completed|cancelled`',
    `target_cost_per_vehicle` DECIMAL(18,2) COMMENT 'Target average manufacturing cost per vehicle (currency defined by currency_code).',
    `target_emissions_g_per_km` DECIMAL(18,2) COMMENT 'Target CO₂ emissions in grams per kilometer.',
    `target_fuel_efficiency_mpg` DECIMAL(18,2) COMMENT 'Target fuel economy in miles per gallon for ICE/HEV variants.',
    `target_market` STRING COMMENT 'Primary geographic market(s) for the vehicle (e.g., "North America").',
    `target_production_volume` STRING COMMENT 'Planned total number of vehicles to be produced for the program.',
    `target_range_km` STRING COMMENT 'Target all‑electric driving range in kilometers for EV variants.',
    `target_weight_kg` DECIMAL(18,2) COMMENT 'Target curb weight of the vehicle in kilograms.',
    `vehicle_program_type` STRING COMMENT 'Classification of the program as a nameplate, platform, or concept.. Valid values are `nameplate|platform|concept`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the vehicle program record.',
    `vehicle_class` STRING COMMENT 'Regulatory vehicle class (e.g., "Passenger", "Light Commercial").',
    CONSTRAINT pk_vehicle_program PRIMARY KEY(`vehicle_program_id`)
) COMMENT 'Master record for a vehicle development program (nameplate/platform program), capturing program code, program name, vehicle segment, platform architecture, SOP (Start of Production) target date, EOP (End of Production) date, MY (Model Year) scope, program phase (concept, development, validation, launch), program director, budget allocation, and program status. Serves as the top-level anchor for all engineering activities within a development cycle. Owned by Siemens Teamcenter PLM. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`bom` (
    `bom_id` BIGINT COMMENT 'Unique surrogate key for the engineering bill of materials record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: BOM approval requires tracking approving employee for audit compliance.',
    `change_id` BIGINT COMMENT 'Identifier of the engineering change order linked to this BOM revision.',
    `bom_engineering_change_order_change_id` BIGINT COMMENT 'Identifier of the engineering change order linked to this BOM revision.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: BOM cost allocation is performed via a Cost Center; replace plain cost_center attribute with FK for accurate finance reporting.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Needed for BOM‑to‑inventory allocation process, enabling the production scheduling system to reserve SKUs for each BOM.',
    `approval_date` DATE COMMENT 'Date on which the BOM revision was approved.',
    `approved_by` STRING COMMENT 'Name of the person who approved the BOM revision.',
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
    `program_name` STRING COMMENT 'Name of the vehicle program (e.g., Model X) to which the BOM belongs.',
    `release_status` STRING COMMENT 'Current release state of the BOM.. Valid values are `draft|released|archived|obsolete`',
    `revision_number` STRING COMMENT 'Revision identifier of the BOM (e.g., A, B, C).',
    `total_parts_count` STRING COMMENT 'Number of distinct part numbers referenced in the BOM.',
    `total_quantity` STRING COMMENT 'Sum of all component quantities across the BOM.',
    `bom_type` STRING COMMENT 'Classification of the BOM: engineering (eBOM), manufacturing (mBOM), or service (sBOM).. Valid values are `eBOM|mBOM|sBOM`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the BOM record.',
    `vehicle_variant` STRING COMMENT 'Identifier for the specific vehicle variant (e.g., Sport, Luxury).',
    `version_number` STRING COMMENT 'Internal version counter for the BOM record.',
    CONSTRAINT pk_bom PRIMARY KEY(`bom_id`)
) COMMENT 'Engineering Bill of Materials (eBOM) header record representing the complete structured parts list for a vehicle program or variant at a specific revision level. Captures BOM type (eBOM, mBOM, sBOM), program reference, model year, configuration context, effectivity dates, release status, BOM owner, and PLM system source. The eBOM is the authoritative design-intent parts structure managed in Siemens Teamcenter and ENOVIA before handoff to manufacturing BOM.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` (
    `engineering_bom_line_id` BIGINT COMMENT 'Unique identifier for the engineering_bom_line data product (auto-inserted pre-linking).',
    `bom_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_bom. Business justification: A line item belongs to a single engineering BOM; adding engineering_bom_id creates the required parent link.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: BOM line execution tracks which equipment assembles the part; needed for production scheduling and OEE reporting.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Parent assembly reference is a part_master; replace with descriptive FK to part_master.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: BOM line sourcing assignment; procurement uses this FK to generate purchase orders for each part line.',
    `product_bom_line_id` BIGINT COMMENT 'SSOT reference to product.product_bom_line (resolves cross-domain duplicate of bom_line).',
    CONSTRAINT pk_engineering_bom_line PRIMARY KEY(`engineering_bom_line_id`)
) COMMENT 'Individual line item within an engineering BOM, representing a single part-to-parent relationship in the BOM hierarchy. Captures parent assembly reference, child part number, find number, quantity, unit of measure, effectivity start/end dates, variant applicability, substitution flags, BOM level, and engineering change reference. Supports multi-level BOM explosion and where-used analysis. Sourced from Siemens Teamcenter BOM Management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`part_master` (
    `part_master_id` BIGINT COMMENT 'Primary key for part_master',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Part cost accounting charges material cost to a Cost Center; finance tracks part expenses per cost center.',
    `employee_id` BIGINT COMMENT 'Identifier of the engineer responsible for the part definition.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the engineer responsible for the part definition.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Parts must be linked to applicable regulatory requirements for compliance tracking during part engineering.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Supplier Management Process: engineering part master must be linked to the external supplier record for PPAP, cost, and lead‑time tracking.',
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
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Specification author must be recorded for traceability and regulatory audits.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Regulatory Requirement Mapping required for design approval; each design spec must reference the regulatory requirement it satisfies.',
    `approval_date` DATE COMMENT 'Date the specification was approved.',
    `approval_status` STRING COMMENT 'Current approval state of the specification.. Valid values are `approved|rejected|pending`',
    `approver` STRING COMMENT 'Name of the person who approved the specification.',
    `author` STRING COMMENT 'Name of the engineer or team that authored the specification.',
    `change_order_date` DATE COMMENT 'Date the change order was issued.',
    `change_order_number` STRING COMMENT 'Identifier of the engineering change order associated with this spec.',
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
    `linked_requirements` STRING COMMENT 'Comma‑separated list of requirement IDs that this specification satisfies.',
    `material_specification` STRING COMMENT 'Material(s) and grades specified for the component.',
    `obsolescence_date` DATE COMMENT 'Planned date when the specification will be retired.',
    `program` STRING COMMENT 'Name of the vehicle program (e.g., Model X, MY2024) to which the specification belongs.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `regulatory_reference` STRING COMMENT 'Regulatory standards referenced (e.g., FMVSS 123, UNECE R123).',
    `related_documents` STRING COMMENT 'Comma‑separated list of other design specification IDs related to this one.',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`cad_model` (
    `cad_model_id` BIGINT COMMENT 'Unique surrogate key for each CAD model record.',
    `part_master_id` BIGINT COMMENT 'add column part_master_id (BIGINT) with FK to engineering.part_master.part_master_id - CAD models represent the 3D geometry of specific parts',
    `employee_id` BIGINT COMMENT 'Surrogate key of the engineer responsible for the model.',
    `primary_employee_id` BIGINT COMMENT 'Surrogate key of the engineer responsible for the model.',
    `vehicle_program_id` BIGINT COMMENT 'add column vehicle_program_id (BIGINT) with FK to engineering.vehicle_program.vehicle_program_id - CAD models are developed within vehicle programs',
    `assembly_name` STRING COMMENT 'Name of the parent assembly if the model is a sub‑component.',
    `compliance_iso26262_level` STRING COMMENT 'Functional safety classification of the component according to ISO 26262.. Valid values are `ASIL_A|ASIL_B|ASIL_C|ASIL_D|none`',
    `configuration_context` STRING COMMENT 'Contextual configuration (e.g., default, sport, luxury) for which the model variant is defined.',
    `coordinate_system` STRING COMMENT 'Reference coordinate system (e.g., right‑hand, left‑hand) applied to the model.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the CAD model record was first created in the system.',
    `design_approval_status` STRING COMMENT 'Current approval state of the design.. Valid values are `pending|approved|rejected`',
    `design_change_date` DATE COMMENT 'Date when the most recent engineering change was applied.',
    `design_change_number` STRING COMMENT 'Identifier of the engineering change order (ECO/ECN) that last modified the model.',
    `design_release_date` DATE COMMENT 'Official date when the design was released for manufacturing.',
    `digital_twin_ready` BOOLEAN COMMENT 'True if the model meets criteria for inclusion in a digital twin.',
    `file_name` STRING COMMENT 'File name of the CAD geometry (including extension).',
    `file_path` STRING COMMENT 'Repository location or network path where the CAD file is stored.',
    `file_size_bytes` BIGINT COMMENT 'Size of the CAD file in bytes; used for storage planning and transfer cost estimation.',
    `geometry_units` STRING COMMENT 'Unit of measure used for the models geometry coordinates.. Valid values are `mm|cm|m|in|ft`',
    `is_digital_mockup_included` BOOLEAN COMMENT 'True if the model is part of a Digital Mock‑Up (DMU) package.',
    `last_published_date` DATE COMMENT 'Date when the model was last released to downstream teams or systems.',
    `lifecycle_status` STRING COMMENT 'Detailed stage of the model from creation to retirement.. Valid values are `in_design|in_review|approved|released|retired`',
    `maturity_level` STRING COMMENT 'Indicates how mature the model is within the product development lifecycle.. Valid values are `concept|detailed_design|validation|production`',
    `cad_model_name` STRING COMMENT 'Human‑readable name of the CAD model as shown in the engineering portal.',
    `notes` STRING COMMENT 'Free‑form comments or remarks entered by the designer.',
    `number` STRING COMMENT 'Business identifier assigned to the CAD model; often mirrors the part number used in downstream processes.',
    `part_number` STRING COMMENT 'OEM part number that the CAD model represents; links the digital geometry to the physical component.',
    `regulatory_approval_status` STRING COMMENT 'Status of regulatory sign‑off (e.g., NHTSA, EPA) for the model.. Valid values are `pending|approved|rejected`',
    `related_vehicle_variant` STRING COMMENT 'Specific vehicle variant (e.g., sport, hybrid) that the model supports.',
    `revision` STRING COMMENT 'Revision identifier (e.g., A, B, C) used for minor changes within a version.',
    `simulation_ready` BOOLEAN COMMENT 'True if the model is prepared for CAE simulations (e.g., meshed, cleaned).',
    `cad_model_status` STRING COMMENT 'Current lifecycle status of the model within the PLM system.. Valid values are `draft|released|archived|obsolete`',
    `tool_version` STRING COMMENT 'Version of the CAD application (e.g., CATIA V5R30) used to author the model.',
    `cad_model_type` STRING COMMENT 'Classification of the CAD geometry type.. Valid values are `part|assembly|surface|solid|wireframe`',
    `updated_by` STRING COMMENT 'Full name of the engineer who performed the latest edit.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the CAD model record.',
    `vehicle_model_year` STRING COMMENT 'Model year of the vehicle platform that uses this CAD model.',
    `vehicle_platform` STRING COMMENT 'Platform identifier (e.g., MQB, CMF) associated with the model.',
    `version` STRING COMMENT 'Version label of the CAD model (e.g., V1.0, V2.1).',
    `created_by` STRING COMMENT 'Full name of the engineer who initially created the CAD model.',
    CONSTRAINT pk_cad_model PRIMARY KEY(`cad_model_id`)
) COMMENT 'CAD (Computer-Aided Design) model record representing a 3D digital geometry asset created in CATIA or equivalent tool. Captures model file reference, part or assembly association, CAD tool version, coordinate system, model maturity level, digital mock-up (DMU) inclusion flag, last published date, file size, configuration context, and owning designer. Supports digital twin construction and downstream CAE simulation setup. Sourced from Dassault Systèmes CATIA and ENOVIA.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`change` (
    `change_id` BIGINT COMMENT 'System-generated unique identifier for the engineering change record.',
    `employee_id` BIGINT COMMENT 'Identifier of the person or group that approved the change.',
    `approver_id` BIGINT COMMENT 'Identifier of the person or group that approved the change.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: ECO process requires identifying which production equipment must be reconfigured; linking change to equipment enables change impact analysis report.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the person or group that originated the change request.',
    `tooling_registry_id` BIGINT COMMENT 'Foreign key linking to asset.tooling_registry. Business justification: Tooling impact of an engineering change must be tracked for re‑tooling schedules and cost estimation.',
    `affected_parts` STRING COMMENT 'Comma‑separated list of part numbers (e.g., VIN, SKU) impacted by the change.',
    `affected_programs` STRING COMMENT 'Comma‑separated list of vehicle programs impacted by the change.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the change was formally approved.',
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
    `change_status` STRING COMMENT 'Current lifecycle status of the engineering change.. Valid values are `draft|under_review|approved|implemented|rejected`',
    `title` STRING COMMENT 'Short descriptive title of the engineering change.',
    `change_type` STRING COMMENT 'Classification of the change request: Engineering Change Request (ECR), Engineering Change Order (ECO), or Engineering Change Notice (ECN).. Valid values are `ECR|ECO|ECN`',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to the engineering change record.',
    `version` STRING COMMENT 'Version number of the change record, incremented on each revision.',
    CONSTRAINT pk_change PRIMARY KEY(`change_id`)
) COMMENT 'Engineering Change Order/Notice (ECO/ECN) record capturing a formal request to modify a part, assembly, design specification, or BOM. Includes change number, change type (ECR/ECO/ECN), title, reason for change (cost reduction, quality, regulatory, customer request), affected parts list, affected programs, initiator, approver chain, priority, implementation date, cost impact estimate, and change status (draft, under review, approved, implemented, rejected). Managed in Siemens Teamcenter Change Management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` (
    `cae_simulation_id` BIGINT COMMENT 'Unique surrogate key for the CAE simulation record.',
    `employee_id` BIGINT COMMENT 'Identifier of the engineering analyst who initiated or owned the simulation.',
    `part_master_id` BIGINT COMMENT 'Identifier of the part or assembly that the simulation analyzes.',
    `cae_part_part_master_id` BIGINT COMMENT 'Identifier of the part or assembly that the simulation analyzes.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the engineering analyst who initiated or owned the simulation.',
    `analyst_name` STRING COMMENT 'Full name of the analyst responsible for the simulation.',
    `boundary_conditions` STRING COMMENT 'Structured description of boundary conditions (e.g., constraints, supports) used in the simulation.',
    `convergence_criteria` STRING COMMENT 'Criteria used to determine simulation convergence (e.g., residual threshold).',
    `cpu_time_seconds` DECIMAL(18,2) COMMENT 'Total CPU processing time consumed by the simulation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the simulation record was first created in the system.',
    `load_case` STRING COMMENT 'Description of the load case applied in the simulation.',
    `memory_usage_mb` DECIMAL(18,2) COMMENT 'Peak memory usage of the simulation process in megabytes.',
    `mesh_element_count` BIGINT COMMENT 'Total number of finite elements in the simulation mesh.',
    `mesh_quality_score` DECIMAL(18,2) COMMENT 'Quality rating of the mesh (higher is better).',
    `notes` STRING COMMENT 'Free‑form comments or observations recorded by the analyst.',
    `number` STRING COMMENT 'External identifier assigned to the simulation run, used for tracking across systems.',
    `part_name` STRING COMMENT 'Descriptive name of the part or assembly.',
    `part_number` STRING COMMENT 'Catalog or engineering part number of the simulated component.',
    `result_metric_name` STRING COMMENT 'Name of the primary result metric produced by the simulation (e.g., Max Stress).',
    `result_metric_unit` STRING COMMENT 'Unit of measure for the primary result metric.. Valid values are `MPa|Pa|N|kg|m/s^2|Hz`',
    `result_metric_value` DECIMAL(18,2) COMMENT 'Numeric value of the primary result metric.',
    `result_outcome` STRING COMMENT 'Pass/fail determination of the simulation against target criteria.. Valid values are `pass|fail`',
    `run_duration_seconds` DECIMAL(18,2) COMMENT 'Total wall‑clock time of the simulation run in seconds.',
    `run_timestamp` TIMESTAMP COMMENT 'Date and time when the simulation execution started.',
    `solver_name` STRING COMMENT 'Name of the computational solver used for the simulation.',
    `cae_simulation_status` STRING COMMENT 'Current lifecycle status of the simulation.. Valid values are `draft|queued|running|completed|failed|cancelled`',
    `target_metric_name` STRING COMMENT 'Name of the target metric the simulation is evaluated against.',
    `target_metric_unit` STRING COMMENT 'Unit of measure for the target metric.. Valid values are `MPa|Pa|N|kg|m/s^2|Hz`',
    `target_metric_value` DECIMAL(18,2) COMMENT 'Numeric target value for the primary metric.',
    `cae_simulation_type` STRING COMMENT 'Category of analysis performed (e.g., Finite Element Analysis, Computational Fluid Dynamics).. Valid values are `FEA|CFD|NVH|Crash|Thermal|Fatigue`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the simulation record.',
    `version` STRING COMMENT 'Version identifier of the simulation setup (e.g., v1.2).',
    CONSTRAINT pk_cae_simulation PRIMARY KEY(`cae_simulation_id`)
) COMMENT 'CAE (Computer-Aided Engineering) simulation record capturing a virtual analysis run performed on a vehicle component or system. Includes simulation ID, simulation type (FEA — Finite Element Analysis, CFD — Computational Fluid Dynamics, NVH — Noise Vibration Harshness, crash, thermal, fatigue), associated part or assembly, solver used, load cases, boundary conditions, mesh parameters, run date, analyst, result summary (pass/fail against targets), and linked design specification. Supports virtual validation before physical prototype build.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` (
    `prototype_build_id` BIGINT COMMENT 'Unique identifier for the prototype build record.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Prototype builds are scheduled at specific plant locations; linking enables location‑based resource planning and cost allocation.',
    `employee_id` BIGINT COMMENT 'Identifier of the engineer accountable for the build.',
    `prototype_responsible_engineer_employee_id` BIGINT COMMENT 'Identifier of the engineer accountable for the build.',
    `vehicle_program_id` BIGINT COMMENT 'add column vehicle_program_id (BIGINT) with FK to engineering.vehicle_program.vehicle_program_id - prototype builds are conducted within vehicle programs',
    `compliance_status` STRING COMMENT 'Regulatory and quality compliance status of the prototype build.. Valid values are `compliant|non_compliant|pending`',
    `configuration_description` STRING COMMENT 'Textual description of the prototypes configuration and options.',
    `cost` DECIMAL(18,2) COMMENT 'Total cost incurred to produce the prototype build.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the build record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the build cost.. Valid values are `USD|EUR|JPY|CAD|GBP|CNY`',
    `data_source_system` STRING COMMENT 'Originating system that supplied the build data.. Valid values are `Teamcenter|CATIA|ENOVIA|SAP|MES`',
    `prototype_build_date` DATE COMMENT 'Calendar date when the prototype was physically built.',
    `duration_hours` DECIMAL(18,2) COMMENT 'Total elapsed time of the build process expressed in hours.',
    `emission_rating` STRING COMMENT 'Emission classification assigned to the prototype based on testing.. Valid values are `tier1|tier2|tier3|tier4`',
    `location` STRING COMMENT 'Plant or facility where the prototype build took place.',
    `notes` STRING COMMENT 'Free‑form notes or comments captured by engineering staff.',
    `number` STRING COMMENT 'Internal sequential number assigned to each prototype build.',
    `phase` STRING COMMENT 'Stage of the prototype build lifecycle.. Valid values are `mule|alpha|beta|pre_production|production`',
    `program_code` STRING COMMENT 'Code identifying the vehicle program or project associated with the prototype.',
    `prototype_number` STRING COMMENT 'Internal identifier for the prototype unit or component.',
    `purpose` STRING COMMENT 'Primary testing or validation purpose of the prototype build.. Valid values are `durability|crash|nvh|emissions|homologation|validation`',
    `safety_rating` STRING COMMENT 'Safety assessment rating for the prototype.. Valid values are `ncap|euro_ncap|none`',
    `prototype_build_status` STRING COMMENT 'Current lifecycle status of the prototype build.. Valid values are `planned|in_progress|completed|failed|cancelled`',
    `test_results_summary` STRING COMMENT 'High‑level summary of test outcomes associated with the prototype build.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the build record.',
    `vin` STRING COMMENT 'Globally unique identifier assigned to the prototype vehicle.',
    CONSTRAINT pk_prototype_build PRIMARY KEY(`prototype_build_id`)
) COMMENT 'Prototype vehicle or component build record capturing the physical build event for validation purposes. Includes build number, build phase (mule, alpha, beta, pre-production), program reference, build date, build location, VIN or prototype identifier, configuration description, build purpose (durability, crash, NVH, emissions, homologation), responsible engineer, and build status. Tracks the physical instantiation of engineering designs for testing and validation activities. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`validation_test` (
    `validation_test_id` BIGINT COMMENT 'Unique identifier for the validation test record.',
    `part_master_id` BIGINT COMMENT 'add column part_master_id (BIGINT) with FK to engineering.part_master.part_master_id - validation tests verify specific parts meet requirements',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Test engineer must be linked to validation test for traceability and regulatory reporting.',
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
    `engineering_test_result_id` BIGINT COMMENT 'Identifier linking to the detailed test report document.',
    `equipment_used` STRING COMMENT 'List of major equipment or rigs employed during the test.',
    `facility` STRING COMMENT 'Name of the facility or lab where the test was performed.',
    `is_critical` BOOLEAN COMMENT 'Indicates whether the test is classified as critical for safety or compliance.',
    `location` STRING COMMENT 'Code identifying the physical location or plant where the test took place.',
    `validation_test_name` STRING COMMENT 'Descriptive name of the validation test.',
    `noise_db` DECIMAL(18,2) COMMENT 'Measured acoustic noise level in decibels.',
    `phase` STRING COMMENT 'Development phase during which the test was performed.. Valid values are `prototype|pre_production|production`',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Overall compliance status of the test against applicable regulations.',
    `report_url` STRING COMMENT 'Web address or path to the stored test report.',
    `result` STRING COMMENT 'Outcome of the test execution.. Valid values are `pass|fail|conditional`',
    `result_timestamp` TIMESTAMP COMMENT 'Timestamp when the test result was entered into the system.',
    `revision_number` STRING COMMENT 'Revision number of the test procedure or setup.',
    `standard_reference` STRING COMMENT 'Reference code or document identifier for the standard governing the test.',
    `validation_test_status` STRING COMMENT 'Current lifecycle status of the test.. Valid values are `planned|in_progress|completed|cancelled`',
    `target_emission_co2` DECIMAL(18,2) COMMENT 'Regulatory or design target for CO2 emission.',
    `target_noise_db` DECIMAL(18,2) COMMENT 'Target acoustic noise level for compliance.',
    `target_torque_nm` DECIMAL(18,2) COMMENT 'Target torque specification for the test.',
    `timestamp` TIMESTAMP COMMENT 'Date and time when the test was executed.',
    `torque_nm` DECIMAL(18,2) COMMENT 'Measured torque value in newton‑meters.',
    `validation_test_type` STRING COMMENT 'Category of the validation test according to engineering verification plans.. Valid values are `DVP|PVP|PPAP|Durability|Emissions|NCAP`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the test record.',
    `variance_percent` DECIMAL(18,2) COMMENT 'Percentage variance between measured and target values.',
    `version` STRING COMMENT 'Version identifier for the test procedure.',
    CONSTRAINT pk_validation_test PRIMARY KEY(`validation_test_id`)
) COMMENT 'Engineering validation test record capturing a physical or virtual test event performed on a prototype or production-intent part/vehicle. Includes test ID, test type (DVP — Design Verification Plan, PVP — Process Validation Plan, PPAP, durability, emissions, NCAP/WLTP, FMVSS), test name, test standard reference, test facility, test date, test engineer, test result (pass/fail/conditional), measured values vs. targets, and disposition. Supports DVP&R (Design Verification Plan and Report) tracking. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`engineering_test_result` (
    `engineering_test_result_id` BIGINT COMMENT 'Unique identifier for the engineering_test_result data product (auto-inserted pre-linking).',
    `validation_test_id` BIGINT COMMENT 'Foreign key linking to engineering.validation_test. Business justification: Test results belong to a validation test; linking enables traceability.',
    CONSTRAINT pk_engineering_test_result PRIMARY KEY(`engineering_test_result_id`)
) COMMENT 'Detailed test result record capturing individual measurement data points from a validation test event. Includes result ID, parent test reference, measurement parameter name, unit of measure, measured value, target value, tolerance band (min/max), pass/fail status, test condition description, channel or sensor ID, timestamp of measurement, and data file reference. Enables granular traceability of test outcomes against engineering targets and regulatory thresholds.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` (
    `digital_twin_id` BIGINT COMMENT 'Primary key for digital_twin',
    `connected_vehicle_id` BIGINT COMMENT 'Unique system-generated identifier for the digital twin record.',
    `part_master_id` BIGINT COMMENT 'Unique identifier of the physical part associated with the twin.',
    `prototype_build_id` BIGINT COMMENT 'Identifier of the prototype unit used for validation of the twin.',
    `digital_prototype_prototype_build_id` BIGINT COMMENT 'Identifier of the prototype unit used for validation of the twin.',
    `engineering_team_id` BIGINT COMMENT 'Unique identifier of the engineering team.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Digital twin of a component is tied to the physical plant location for synchronization and maintenance planning.',
    `primary_digital_part_master_id` BIGINT COMMENT 'Unique identifier of the physical part associated with the twin.',
    `vehicle_program_id` BIGINT COMMENT 'Identifier of the engineering program linked to the digital twin.',
    `asset_vin` STRING COMMENT 'VIN of the physical vehicle linked to the digital twin, if applicable.',
    `digital_twin_code` STRING COMMENT 'Business identifier code assigned to the digital twin within engineering systems.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the digital twin record was first created.',
    `data_quality_score` DECIMAL(18,2) COMMENT 'Overall quality rating of the twins data (0‑100).',
    `fidelity_level` STRING COMMENT 'Granularity of the digital twin model (e.g., high‑fidelity CFD vs. low‑fidelity schematic).. Valid values are `high|medium|low`',
    `last_sync_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent successful sync operation.',
    `model_description` STRING COMMENT 'Free‑text description of the digital twins purpose and scope.',
    `model_file_path` STRING COMMENT 'File system or object storage path to the model artifact.',
    `model_storage_location` STRING COMMENT 'Logical storage location descriptor (e.g., Data Lake, Git repo).',
    `digital_twin_name` STRING COMMENT 'Human‑readable name of the digital twin.',
    `performance_metric` DECIMAL(18,2) COMMENT 'Key performance indicator derived from simulation (e.g., drag coefficient).',
    `regulatory_compliance_status` STRING COMMENT 'Compliance state with relevant automotive regulations (e.g., NHTSA, EPA).. Valid values are `compliant|non_compliant|pending`',
    `simulation_model_version` STRING COMMENT 'Version string of the simulation model used for the digital twin.',
    `simulation_tool` STRING COMMENT 'Software tool used to generate the simulation model.. Valid values are `ANSYS|Siemens|Altair|Dassault`',
    `digital_twin_status` STRING COMMENT 'Current lifecycle state of the digital twin.. Valid values are `active|inactive|retired|archived`',
    `sync_status` STRING COMMENT 'Current synchronization state between the virtual model and physical asset data.. Valid values are `in_sync|out_of_sync|pending`',
    `digital_twin_type` STRING COMMENT 'Category of the digital twin indicating the physical scope it represents.. Valid values are `vehicle|powertrain|chassis|body|component`',
    `updated_by` STRING COMMENT 'User name or identifier that performed the last update.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the digital twin record.',
    `validation_status` STRING COMMENT 'Result of the latest validation run against physical test data.. Valid values are `validated|pending|rejected`',
    `created_by` STRING COMMENT 'User name or identifier that created the record.',
    CONSTRAINT pk_digital_twin PRIMARY KEY(`digital_twin_id`)
) COMMENT 'Digital twin model record representing the virtual counterpart of a physical vehicle, system, or component. Captures twin ID, twin type (vehicle-level, powertrain, chassis, body), associated program and part references, simulation model version, real-world asset linkage (VIN or prototype ID), synchronization status, last updated timestamp, fidelity level, and owning engineering team. Enables continuous correlation between virtual models and physical test/field data for predictive engineering.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`milestone` (
    `milestone_id` BIGINT COMMENT 'Unique identifier for the engineering milestone record.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Milestones (e.g., design freeze) occur at a plant location; linking supports location‑based milestone dashboards.',
    `employee_id` BIGINT COMMENT 'FK to workforce.employee',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the person responsible for delivering the milestone.',
    `primary_milestone_employee_id` BIGINT COMMENT 'Identifier of the person responsible for delivering the milestone.',
    `tertiary_milestone_sign_off_authority_employee_id` BIGINT COMMENT 'Identifier of the authority who signed off the milestone.',
    `vehicle_program_id` BIGINT COMMENT 'Identifier of the engineering program to which this milestone belongs.',
    `actual_date` DATE COMMENT 'Actual calendar date when the milestone was achieved.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the milestone was approved during gate review.',
    `change_reason` STRING COMMENT 'Reason provided for any change to milestone dates or status.',
    `milestone_code` STRING COMMENT 'Short code representing the milestone phase.. Valid values are `P0|P1|P2|P3|SOP`',
    `compliance_standard` STRING COMMENT 'Applicable compliance standard(s) for the milestone (e.g., ISO 26262, IATF 16949).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the milestone record was created.',
    `milestone_description` STRING COMMENT 'Detailed description of the milestone purpose, scope, and deliverables.',
    `gate_review_outcome` STRING COMMENT 'Result of the gate review for the milestone.. Valid values are `approved|conditional|deferred|rejected`',
    `is_critical` BOOLEAN COMMENT 'Indicates whether the milestone is deemed critical for program success.',
    `milestone_name` STRING COMMENT 'Descriptive name of the milestone (e.g., P0 Concept Freeze, P1 Design Freeze).',
    `open_action_items_count` STRING COMMENT 'Number of unresolved action items after the gate review.',
    `planned_date` DATE COMMENT 'Planned calendar date for milestone completion.',
    `plant_location` STRING COMMENT 'Manufacturing plant or site associated with the milestone.',
    `risk_level` STRING COMMENT 'Risk classification assigned to the milestone.. Valid values are `low|medium|high|critical`',
    `milestone_status` STRING COMMENT 'Current lifecycle status of the milestone.. Valid values are `planned|in_progress|completed|closed|cancelled`',
    `milestone_type` STRING COMMENT 'Category of the milestone within the product development process.. Valid values are `gate|review|release|prototype|pilot`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the milestone record.',
    `version_number` STRING COMMENT 'Version number of the milestone record for change tracking.',
    CONSTRAINT pk_milestone PRIMARY KEY(`milestone_id`)
) COMMENT 'Engineering program milestone record capturing key gate reviews and decision points in the vehicle development process. Includes milestone ID, milestone name (P0 concept freeze, P1 design freeze, P2 prototype release, P3 pilot build, SOP), program reference, planned date, actual date, milestone owner, gate review outcome (approved, conditional, deferred), open action items count, and sign-off authority. Supports APQP (Advanced Product Quality Planning) phase gate management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` (
    `fmea_record_id` BIGINT COMMENT 'System-generated unique identifier for the FMEA record.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: FMEA analysis often references the equipment where failure mode is observed; linking enables root‑cause tracking and preventive maintenance.',
    `employee_id` BIGINT COMMENT 'Identifier of the engineer or manager who approved the FMEA analysis.',
    `part_master_id` BIGINT COMMENT 'Reference to the part (or component) that the FMEA analyzes.',
    `fmea_part_part_master_id` BIGINT COMMENT 'Reference to the part (or component) that the FMEA analyzes.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the engineer or responsible person assigned to implement the recommended action.',
    `primary_fmea_employee_id` BIGINT COMMENT 'Identifier of the engineer or responsible person assigned to implement the recommended action.',
    `actual_completion_date` DATE COMMENT 'Date when the recommended action was actually completed.',
    `analysis_team` STRING COMMENT 'Name or identifier of the cross‑functional team that performed the FMEA.',
    `approval_date` DATE COMMENT 'Date when the FMEA record received formal approval.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the FMEA record was first created in the system.',
    `current_controls` STRING COMMENT 'Existing controls or safeguards that address the failure mode.',
    `detection_rating` STRING COMMENT 'Detection score (1‑10) representing the ability of current controls to detect the failure before it reaches the customer.',
    `document_url` STRING COMMENT 'Link to the detailed FMEA PDF or digital twin document stored in the repository.',
    `effective_end_date` DATE COMMENT 'Date when the FMEA analysis is retired or superseded (nullable).',
    `effective_start_date` DATE COMMENT 'Date from which the FMEA analysis is considered active.',
    `failure_effect` STRING COMMENT 'Potential effect on the vehicle or process if the failure mode occurs.',
    `failure_mode` STRING COMMENT 'Textual description of the way the part or process could fail.',
    `fmea_number` STRING COMMENT 'Business identifier assigned to the FMEA record, often used in reports and traceability.',
    `fmea_type` STRING COMMENT 'Indicates whether the analysis is a Design FMEA (DFMEA) or Process FMEA (PFMEA).. Valid values are `DFMEA|PFMEA`',
    `notes` STRING COMMENT 'Free‑form comments or observations related to the FMEA.',
    `occurrence_rating` STRING COMMENT 'Occurrence score (1‑10) indicating how likely the failure mode is to happen.',
    `process_code` BIGINT COMMENT 'Reference to the manufacturing process step when the FMEA is a PFMEA.',
    `recommended_action` STRING COMMENT 'Proposed corrective or preventive action to reduce risk.',
    `revision_number` STRING COMMENT 'Sequential revision number of the FMEA record.',
    `risk_category` STRING COMMENT 'High‑level risk classification derived from the RPN.. Valid values are `high|medium|low`',
    `rpn` STRING COMMENT 'Calculated risk priority number (S × O × D) used to prioritize mitigation actions.',
    `severity_rating` STRING COMMENT 'Severity score (1‑10) reflecting the seriousness of the failure effect.',
    `fmea_record_status` STRING COMMENT 'Current lifecycle status of the FMEA record.. Valid values are `open|in_progress|closed|rejected`',
    `target_completion_date` DATE COMMENT 'Planned date by which the recommended action should be completed.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the FMEA record.',
    `version` STRING COMMENT 'Alphanumeric version label (e.g., v1.0, v2.1) for the FMEA record.',
    CONSTRAINT pk_fmea_record PRIMARY KEY(`fmea_record_id`)
) COMMENT 'FMEA (Failure Mode and Effects Analysis) record capturing the systematic risk analysis of a design or process. Includes FMEA ID, FMEA type (DFMEA — Design FMEA, PFMEA — Process FMEA), associated part or process, failure mode description, potential effect of failure, severity rating, potential cause, occurrence rating, current controls, detection rating, RPN (Risk Priority Number), recommended actions, responsible engineer, and completion date. Managed per IATF 16949 and AIAG-VDA FMEA methodology.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` (
    `dvp_plan_id` BIGINT COMMENT 'System-generated unique identifier for the Design Verification Plan.',
    `change_id` BIGINT COMMENT 'Identifier of the engineering change order that triggered the plan.',
    `employee_id` BIGINT COMMENT 'Identifier of the user who created the plan record.',
    `part_master_id` BIGINT COMMENT 'Identifier of the part or component covered by the DVP.',
    `dvp_part_part_master_id` BIGINT COMMENT 'Identifier of the part or component covered by the DVP.',
    `design_specification_id` BIGINT COMMENT 'Identifier of the engineering specification linked to the plan.',
    `dvp_related_specification_design_specification_id` BIGINT COMMENT 'Identifier of the engineering specification linked to the plan.',
    `dvp_updated_by_employee_id` BIGINT COMMENT 'Identifier of the user who performed the latest update.',
    `primary_dvp_employee_id` BIGINT COMMENT 'Identifier of the engineer accountable for the plan execution.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the engineer accountable for the plan execution.',
    `tertiary_dvp_updated_by_employee_id` BIGINT COMMENT 'Identifier of the user who performed the latest update.',
    `vehicle_program_id` BIGINT COMMENT 'Identifier of the vehicle program to which the plan belongs.',
    `actual_completion_date` DATE COMMENT 'Date when the last test in the plan was completed.',
    `approval_date` DATE COMMENT 'Date on which the plan received final approval.',
    `approval_status` STRING COMMENT 'Current approval state of the verification plan.. Valid values are `draft|pending|approved|rejected|withdrawn`',
    `dvp_plan_code` STRING COMMENT 'Business-visible alphanumeric code used to reference the DVP plan.',
    `completed_test_count` STRING COMMENT 'Number of test cases that have been completed.',
    `completion_percentage` DECIMAL(18,2) COMMENT 'Percentage of tests completed (0‑100).',
    `cost_estimate_usd` DECIMAL(18,2) COMMENT 'Estimated cost to execute the verification plan, expressed in US dollars.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the plan record was created.',
    `dvp_plan_description` STRING COMMENT 'Detailed narrative describing the scope and objectives of the plan.',
    `document_url` STRING COMMENT 'Web link or repository path to the full DVP document.',
    `effective_end_date` DATE COMMENT 'Date when the plan is retired or superseded (nullable).',
    `effective_start_date` DATE COMMENT 'Date when the plan becomes active for execution.',
    `is_automated` BOOLEAN COMMENT 'Indicates whether the test procedures are automated.',
    `is_locked` BOOLEAN COMMENT 'Indicates whether the plan is locked from further edits.',
    `last_review_date` DATE COMMENT 'Date of the most recent formal review of the plan.',
    `last_status_change_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent change to the plan status.',
    `model_year` STRING COMMENT 'Model year of the vehicle variant the plan applies to.',
    `notes` STRING COMMENT 'Additional remarks or comments about the verification plan.',
    `planned_completion_date` DATE COMMENT 'Target date for completing all tests in the plan.',
    `priority` STRING COMMENT 'Business priority assigned to the plan.. Valid values are `low|medium|high|critical`',
    `regulatory_approval_required` BOOLEAN COMMENT 'Indicates whether regulatory sign‑off is required for the plan.',
    `regulatory_approval_status` STRING COMMENT 'Current status of regulatory approval for the plan.. Valid values are `not_required|pending|approved|rejected`',
    `risk_level` STRING COMMENT 'Overall risk rating assigned to the verification plan.. Valid values are `low|medium|high|critical`',
    `dvp_plan_status` STRING COMMENT 'Current operational status of the verification plan.. Valid values are `active|inactive|archived|cancelled`',
    `system_code` BIGINT COMMENT 'Identifier of the vehicle system (e.g., powertrain, ADAS) the plan validates.',
    `test_environment` STRING COMMENT 'Physical or virtual environment where testing occurs.. Valid values are `lab|test_track|simulation|field`',
    `test_phase` STRING COMMENT 'Lifecycle phase during which the tests are performed.. Valid values are `development|prototype|pre-production|production|post-production`',
    `test_type` STRING COMMENT 'Primary classification of the tests in the plan.. Valid values are `functional|performance|durability|safety|regulatory|environmental`',
    `title` STRING COMMENT 'Descriptive title of the verification plan.',
    `total_test_count` STRING COMMENT 'Total number of test cases defined in the plan.',
    `dvp_plan_type` STRING COMMENT 'Category of the plan indicating the level of the product it validates.. Valid values are `system|component|subsystem|vehicle|process`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the plan record.',
    `vehicle_variant` STRING COMMENT 'Specific vehicle variant or trim level associated with the plan.',
    `version_number` STRING COMMENT 'Semantic version identifier for the plan (e.g., 1.0, 2.1).',
    CONSTRAINT pk_dvp_plan PRIMARY KEY(`dvp_plan_id`)
) COMMENT 'Design Verification Plan (DVP) record defining the complete test plan for validating a vehicle system or component against its design specifications. Captures DVP ID, plan title, associated part or system, program reference, total test count, completion percentage, responsible engineer, approval status, linked specification, and planned vs. actual completion dates. Acts as the master test planning document that governs all validation_test records for a given scope.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` (
    `homologation_requirement_id` BIGINT COMMENT 'Unique surrogate key for the homologation requirement record.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: Homologation requirement must reference the homologation record that documents market approval for that requirement.',
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
    `linked_validation_test_ids` STRING COMMENT 'Comma‑separated list of validation test identifiers that satisfy this requirement.',
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
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: ECU sourcing workflow requires each ECU spec to reference the approved supplier for compliance and warranty management.',
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
    `ecu_type` STRING COMMENT 'Classification of the ECU function (e.g., engine control, ADAS).. Valid values are `engine_control|transmission|adas|body_control|battery_management|infotainment`',
    `effective_end_date` DATE COMMENT 'Date when the ECU specification is retired or superseded.',
    `effective_start_date` DATE COMMENT 'Date when the ECU specification becomes effective.',
    `eol_date` DATE COMMENT 'Planned date when the ECU will be discontinued.',
    `functional_safety_asil` STRING COMMENT 'Automotive Safety Integrity Level per ISO 26262.. Valid values are `ASIL_A|ASIL_B|ASIL_C|ASIL_D`',
    `hardware_part_number` STRING COMMENT 'Manufacturer part number for the ECU hardware.',
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
    `ecu_specification_status` STRING COMMENT 'Current lifecycle state of the ECU specification.. Valid values are `active|inactive|deprecated|retired|development|released`',
    `supported_features` STRING COMMENT 'Comma‑separated list of functional features provided by the ECU.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the ECU specification.',
    `vehicle_platform` STRING COMMENT 'Vehicle platform or architecture that the ECU supports (e.g., MQB, e‑CM).',
    `voltage_range_v` STRING COMMENT 'Operating voltage range expressed as min‑max volts.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Physical weight of the ECU unit.',
    CONSTRAINT pk_ecu_specification PRIMARY KEY(`ecu_specification_id`)
) COMMENT 'ECU (Electronic Control Unit) software and hardware specification record capturing the technical definition of an automotive electronic control module. Includes ECU ID, ECU name, ECU type (engine control, transmission, ADAS, body control, battery management), hardware part number, software version, calibration dataset reference, communication protocol (CAN, LIN, Ethernet, FlexRay), functional safety level (ASIL rating per ISO 26262), supplier reference, and release status. Critical for EV, HEV, and ADAS program engineering.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` (
    `powertrain_spec_id` BIGINT COMMENT 'Unique surrogate identifier for the powertrain specification record.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Powertrain specifications are defined per vehicle program; linking enables program-level aggregation and reporting.',
    `approval_date` DATE COMMENT 'Date when the specification received formal approval.',
    `approved_by` STRING COMMENT 'Name of the authority who approved the specification.',
    `architecture_type` STRING COMMENT 'Physical layout of the engine (inline, V, boxer, etc.).',
    `aspiration_type` STRING COMMENT 'Method of air induction for the engine.. Valid values are `naturally_aspirated|turbocharged|supercharged`',
    `battery_capacity_kwh` DECIMAL(18,2) COMMENT 'Energy storage capacity for electrified powertrains; null for ICE/HEV.',
    `powertrain_spec_code` STRING COMMENT 'Business identifier code used to reference the specification across systems.',
    `compliance_status` STRING COMMENT 'Overall regulatory compliance state of the specification.. Valid values are `compliant|non_compliant|pending`',
    `cost_currency` STRING COMMENT 'Currency code for the cost estimate.',
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
    `powertrain_type` STRING COMMENT 'Classification of the powertrain technology.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `start_of_production_date` DATE COMMENT 'Date when the powertrain entered series production.',
    `powertrain_spec_status` STRING COMMENT 'Current lifecycle status of the specification.. Valid values are `draft|active|retired|obsolete`',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`weight_report` (
    `weight_report_id` BIGINT COMMENT 'Unique identifier for the weight report record.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Weight reports are generated by weighing equipment; linking allows equipment calibration tracking and compliance audit.',
    `employee_id` BIGINT COMMENT 'Identifier of the engineer accountable for the weight report.',
    `primary_weight_employee_id` BIGINT COMMENT 'Identifier of the engineer accountable for the weight report.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Weight reports are generated for a specific vehicle program; linking provides program aggregation.',
    `actual_weight_kg` DECIMAL(18,2) COMMENT 'Physical measurement of the component weight obtained during testing, in kilograms.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the report was approved, if applicable.',
    `comments` STRING COMMENT 'Free‑form notes or observations related to the weight report.',
    `compliance_flag` BOOLEAN COMMENT 'Regulatory or standards compliance indicator relevant to the weight data.',
    `component_scope` STRING COMMENT 'Specific component or assembly within the system that the weight pertains to.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the weight report record was first created.',
    `estimated_weight_kg` DECIMAL(18,2) COMMENT 'Current engineering estimate of the component weight, in kilograms.',
    `is_locked` BOOLEAN COMMENT 'Indicates whether the report is locked from further edits.',
    `weight_report_name` STRING COMMENT 'Human‑readable name or title of the weight report.',
    `number` STRING COMMENT 'Business identifier assigned to the weight report for external reference.',
    `reduction_action` STRING COMMENT 'Planned or executed engineering action intended to reduce the component weight.',
    `regulatory_approval_status` STRING COMMENT 'Status of regulatory approval for the weight report.. Valid values are `pending|approved|rejected|not_required`',
    `reporting_date` DATE COMMENT 'Date on which the weight data was reported.',
    `weight_report_status` STRING COMMENT 'Current lifecycle status of the weight report.. Valid values are `draft|in_review|approved|rejected|archived`',
    `system_scope` STRING COMMENT 'Engineering system or vehicle subsystem the weight measurement applies to (e.g., chassis, powertrain).',
    `target_weight_kg` DECIMAL(18,2) COMMENT 'Target mass budget allocation for the component, expressed in kilograms.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the weight report.',
    `version_number` STRING COMMENT 'Sequential version of the report for change tracking.',
    `weight_delta_kg` DECIMAL(18,2) COMMENT 'Difference between actual weight and target weight (actual – target), expressed in kilograms.',
    `weight_delta_percent` DECIMAL(18,2) COMMENT 'Weight delta expressed as a percentage of the target weight.',
    `weight_source` STRING COMMENT 'Origin of the weight data, such as simulation, prototype measurement, or supplier data.',
    `weight_target_category` STRING COMMENT 'Category of the weight target (e.g., mass budget, component limit).',
    CONSTRAINT pk_weight_report PRIMARY KEY(`weight_report_id`)
) COMMENT 'Vehicle or component weight tracking record capturing mass budget allocations and actual measured weights throughout the development program. Includes report ID, program reference, reporting date, system or component scope, target weight (kg), current estimated weight, actual measured weight, weight delta vs. target, weight reduction actions, responsible engineer, and report status. Supports mass management — a critical engineering discipline for fuel economy (CAFE), EV range, and performance targets. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`design_review` (
    `design_review_id` BIGINT COMMENT 'Unique identifier for the design review event.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Design review chair employee needed for meeting minutes, decisions, and audit logs.',
    `vehicle_program_id` BIGINT COMMENT 'Identifier of the vehicle program associated with this design review.',
    `attendees_count` STRING COMMENT 'Number of participants who attended the design review.',
    `chair_name` STRING COMMENT 'Full name of the chairperson leading the design review.',
    `compliance_flag` BOOLEAN COMMENT 'Indicates whether the reviewed design meets required compliance standards (true = compliant).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the design review record was first created in the system.',
    `design_review_date` TIMESTAMP COMMENT 'Date and time when the design review took place.',
    `duration_minutes` STRING COMMENT 'Total duration of the design review in minutes.',
    `findings_count` STRING COMMENT 'Total number of findings identified during the review.',
    `identifier` STRING COMMENT 'Business identifier or code assigned to the design review (e.g., DR-2024-001).',
    `location` STRING COMMENT 'Physical or virtual location where the design review was conducted.',
    `minutes_document_ref` STRING COMMENT 'Reference (e.g., file path or URL) to the detailed minutes of the review.',
    `notes` STRING COMMENT 'Additional free‑form notes captured during the design review.',
    `open_actions_count` STRING COMMENT 'Number of action items that remain open after the review.',
    `outcome` STRING COMMENT 'Result of the design review: approved, conditional, or rejected.. Valid values are `approved|conditional|rejected`',
    `risk_level` STRING COMMENT 'Risk assessment level assigned to the review outcomes.. Valid values are `low|medium|high`',
    `design_review_status` STRING COMMENT 'Current lifecycle status of the design review record.. Valid values are `scheduled|in_progress|completed|cancelled`',
    `system_or_component` STRING COMMENT 'Name or identifier of the system or component that was reviewed.',
    `total_action_items` STRING COMMENT 'Total number of action items generated by the review (including open and closed).',
    `design_review_type` STRING COMMENT 'Type of design review (Preliminary Design Review, Critical Design Review, System Design Review, Supplier Design Review).. Valid values are `PDR|CDR|System|Supplier`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the design review record.',
    `version_number` STRING COMMENT 'Version number of the design review record for audit tracking.',
    CONSTRAINT pk_design_review PRIMARY KEY(`design_review_id`)
) COMMENT 'Formal design review event record capturing structured peer reviews of engineering designs at key program stages. Includes review ID, review type (PDR — Preliminary Design Review, CDR — Critical Design Review, system design review, supplier design review), program reference, review date, reviewed system or component, review chair, attendees count, findings count, open actions count, review outcome (approved, conditional, rejected), and minutes document reference. Supports APQP and PLM governance processes.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`material_specification` (
    `material_specification_id` BIGINT COMMENT 'Unique surrogate key for the material specification record.',
    `material_id` BIGINT COMMENT 'Foreign key linking to engineering.material. Business justification: Material specifications describe a concrete material entity; linking removes redundancy and centralizes material attributes.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Material specifications describe a part; linking to part_master removes redundant part identifiers.',
    `applicable_standard` STRING COMMENT 'Reference to external standards governing the material (e.g., SAE, ASTM, DIN).',
    `application_restriction` STRING COMMENT 'Business rules limiting where the material may be used (e.g., high‑temperature zones).',
    `approved_supplier` STRING COMMENT 'Comma‑separated list of suppliers approved to provide this material.',
    `compliance_reach` STRING COMMENT 'Regulatory status of the material under EU REACH.. Valid values are `compliant|non_compliant|pending`',
    `compliance_rohs` STRING COMMENT 'Regulatory status of the material under RoHS directives.. Valid values are `compliant|non_compliant|pending`',
    `cost_per_kg_usd` DECIMAL(18,2) COMMENT 'Current purchase cost of the material per kilogram in US dollars.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the specification record was first created.',
    `density_kg_per_m3` DECIMAL(18,2) COMMENT 'Mass per unit volume of the material.',
    `effective_end_date` DATE COMMENT 'Date after which the specification is no longer valid (null if open‑ended).',
    `effective_start_date` DATE COMMENT 'Date from which the specification is valid.',
    `elongation_percent` DECIMAL(18,2) COMMENT 'Percent increase in length at fracture, indicating ductility.',
    `environmental_impact_score` DECIMAL(18,2) COMMENT 'Numeric score representing the materials environmental footprint.',
    `grade_or_alloy` STRING COMMENT 'Specific grade or alloy designation (e.g., 6061‑T6, 304L).',
    `is_critical` BOOLEAN COMMENT 'Indicates whether the material is critical for safety or performance.',
    `last_review_date` DATE COMMENT 'Date when the specification was last reviewed for relevance or compliance.',
    `lead_time_days` STRING COMMENT 'Typical supplier lead time for the material, in calendar days.',
    `lifecycle_status` STRING COMMENT 'Lifecycle phase of the material specification.. Valid values are `in_design|approved|in_use|retired|archived`',
    `material_class` STRING COMMENT 'High‑level classification of the material type.. Valid values are `steel|aluminum|polymer|composite|glass`',
    `material_specification_name` STRING COMMENT 'Human‑readable name of the material specification.',
    `notes` STRING COMMENT 'Free‑form comments or observations about the material specification.',
    `safety_rating` STRING COMMENT 'Safety classification of the material according to internal or regulatory criteria.. Valid values are `A|B|C|D|E`',
    `specific_heat_j_per_kgk` DECIMAL(18,2) COMMENT 'Energy required to raise the temperature of 1 kg of material by 1 K.',
    `material_specification_status` STRING COMMENT 'Current operational status of the specification.. Valid values are `active|inactive|deprecated|pending`',
    `surface_treatment` STRING COMMENT 'Required surface finishing process for the material.. Valid values are `none|coating|plating|anodizing|galvanizing`',
    `tensile_strength_mpa` DECIMAL(18,2) COMMENT 'Maximum stress the material can withstand while being stretched before breaking.',
    `thermal_conductivity_w_per_mk` DECIMAL(18,2) COMMENT 'Rate at which heat passes through the material.',
    `material_specification_type` STRING COMMENT 'Primary functional category of the material.. Valid values are `structural|electrical|thermal|decorative`',
    `updated_by` STRING COMMENT 'User identifier of the person who last modified the record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the specification.',
    `version_number` STRING COMMENT 'Incremental version of the specification for change tracking.',
    `warranty_period_months` STRING COMMENT 'Manufacturer warranty period applicable to the material.',
    `yield_strength_mpa` DECIMAL(18,2) COMMENT 'Stress at which material begins to deform plastically.',
    `created_by` STRING COMMENT 'User identifier of the person who created the record.',
    CONSTRAINT pk_material_specification PRIMARY KEY(`material_specification_id`)
) COMMENT 'Engineering material specification record defining the approved materials for use in vehicle components. Captures spec ID, material name, material class (steel, aluminum, polymer, composite, glass), grade or alloy designation, mechanical properties (tensile strength, yield strength, elongation), thermal properties, density, surface treatment requirements, applicable standards (SAE, ASTM, DIN), REACH/RoHS compliance status, approved supplier list, and application restrictions. Supports part design and supplier qualification.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` (
    `configuration_rule_id` BIGINT COMMENT 'System-generated unique identifier for the vehicle configuration rule.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Rule creator employee tracked for change management and compliance documentation.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Configuration rules are defined per vehicle program; adding program FK groups rules correctly.',
    `approval_status` STRING COMMENT 'Current approval state of the rule within engineering governance.. Valid values are `approved|pending|rejected`',
    `approved_by` STRING COMMENT 'Identifier of the authority who approved the rule.',
    `change_reason` STRING COMMENT 'Reason why the rule was created or modified (e.g., new regulation, market demand).',
    `configuration_rule_code` STRING COMMENT 'Business code used to reference the rule in engineering and ordering systems.',
    `compliance_standard` STRING COMMENT 'Reference to the regulatory or internal standard the rule satisfies (e.g., ISO 26262, FMVSS).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the rule record was first created in the system.',
    `configuration_rule_description` STRING COMMENT 'Detailed textual description of the rule logic and intent.',
    `effective_date` DATE COMMENT 'Date on which the rule becomes active.',
    `expiration_date` DATE COMMENT 'Date on which the rule is no longer valid (null if indefinite).',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether the rule must be enforced for all builds (True) or is advisory (False).',
    `last_review_date` DATE COMMENT 'Date when the rule was last reviewed for relevance or compliance.',
    `market` STRING COMMENT 'Geographic market(s) where the rule is applicable (e.g., US, EU, CN).',
    `model_year` STRING COMMENT 'Model year for which the rule is valid.',
    `configuration_rule_name` STRING COMMENT 'Human‑readable name describing the purpose of the rule.',
    `notes` STRING COMMENT 'Free‑form comments or observations about the rule.',
    `option_category` STRING COMMENT 'High‑level category of the options involved (e.g., powertrain, interior, safety).',
    `option_code_a` STRING COMMENT 'Identifier of the first option involved in the rule (e.g., engine, trim).',
    `option_code_b` STRING COMMENT 'Identifier of the second option involved in the rule.',
    `priority` STRING COMMENT 'Numeric priority used when multiple rules conflict; lower numbers indicate higher priority.',
    `program_name` STRING COMMENT 'Name of the vehicle program (e.g., SUV‑X, EV‑Y) to which the rule applies.',
    `source` STRING COMMENT 'Origin of the rule: commercial policy, engineering requirement, or regulatory mandate.. Valid values are `commercial|engineering|regulatory`',
    `configuration_rule_status` STRING COMMENT 'Current lifecycle status of the rule.. Valid values are `active|inactive|retired|draft`',
    `configuration_rule_type` STRING COMMENT 'Classification of the rule logic: include, exclude, requires, or incompatible.. Valid values are `include|exclude|requires|incompatible`',
    `updated_by` STRING COMMENT 'User identifier of the person who last modified the rule.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the rule record.',
    `vehicle_platform` STRING COMMENT 'Platform architecture (e.g., MQB, CMF) to which the rule applies.',
    `version_number` STRING COMMENT 'Incremental version of the rule for change tracking.',
    `created_by` STRING COMMENT 'User identifier of the person who created the rule.',
    CONSTRAINT pk_configuration_rule PRIMARY KEY(`configuration_rule_id`)
) COMMENT 'Vehicle configuration rule record defining the valid combinations of options, packages, and features for a vehicle program. Captures rule ID, rule type (include, exclude, requires, incompatible), applicable program and model year, option code A, option code B, rule description, market applicability, effective date, and rule source (commercial, engineering, regulatory). Managed in ENOVIA Configuration Management and supports order-to-build feasibility validation and BOM variant management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`ota_release` (
    `ota_release_id` BIGINT COMMENT 'System-generated unique identifier for the OTA software release record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: OTA release approval must be signed off by an employee for regulatory compliance.',
    `engineering_team_id` BIGINT COMMENT 'Identifier of the engineering team responsible for creating the OTA package.',
    `ota_compliance_approval_id` BIGINT COMMENT 'Foreign key linking to compliance.ota_compliance_approval. Business justification: Each OTA release needs a compliance approval record linking the software update to its regulatory approval.',
    `ecu_specification_id` BIGINT COMMENT 'Identifier of the electronic control unit that the OTA package targets.',
    `target_ecu_ecu_specification_id` BIGINT COMMENT 'Identifier of the electronic control unit that the OTA package targets.',
    `validation_test_id` BIGINT COMMENT 'Reference to the validation test suite that approved the OTA release.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: OTA releases are scoped to a vehicle program; linking provides program ownership and traceability.',
    `approval_date` TIMESTAMP COMMENT 'Date and time when the OTA release was formally approved.',
    `approval_timestamp` TIMESTAMP COMMENT 'Exact time when the approval action was recorded.',
    `approved_by` STRING COMMENT 'Name or identifier of the authority that approved the OTA release.',
    `build_number` STRING COMMENT 'Technical build identifier generated by the build system.',
    `compatible_vin_range` STRING COMMENT 'VIN prefix range (e.g., 1HGCM*) that identifies vehicles eligible for the update.',
    `compliance_standard` STRING COMMENT 'Name of the regulatory or industry standard satisfied (e.g., ISO 26262).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the OTA release record was first created in the system.',
    `cybersecurity_assessment_status` STRING COMMENT 'Result of the security assessment for the OTA package.. Valid values are `passed|failed|not_tested`',
    `cybersecurity_score` DECIMAL(18,2) COMMENT 'Numerical score reflecting the security posture of the OTA package.',
    `distribution_method` STRING COMMENT 'Channel through which the OTA update is delivered to vehicles.. Valid values are `ota|dealer|service_center`',
    `effective_date` DATE COMMENT 'Date when the OTA release becomes available for deployment.',
    `estimated_download_size_mb` DECIMAL(18,2) COMMENT 'Projected size of the OTA package for vehicle download, in megabytes.',
    `estimated_install_time_minutes` STRING COMMENT 'Projected time required for the vehicle to install the OTA update.',
    `expiry_date` DATE COMMENT 'Date after which the OTA release should no longer be offered.',
    `hash` STRING COMMENT 'Cryptographic hash of the OTA package for integrity verification.',
    `is_critical` BOOLEAN COMMENT 'Flag indicating the update addresses critical safety or security issues.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether the OTA update is required for compliance or safety.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether the OTA release meets applicable regulatory requirements.',
    `rollback_supported` BOOLEAN COMMENT 'Indicates whether the vehicle can revert to a prior software version if needed.',
    `rollback_window_days` STRING COMMENT 'Number of days after deployment during which a rollback is permitted.',
    `rollout_strategy` STRING COMMENT 'Planned deployment approach (e.g., staged, immediate, region‑based).',
    `signature` STRING COMMENT 'Digital signature used to authenticate the OTA package.',
    `software_delta_description` STRING COMMENT 'Narrative of code changes, new features, or bug fixes included in the OTA package.',
    `source` STRING COMMENT 'Origin of the OTA package content.. Valid values are `internal|supplier|partner`',
    `ota_release_status` STRING COMMENT 'Current lifecycle status of the OTA release.. Valid values are `draft|pending|approved|deployed|retracted`',
    `target_market` STRING COMMENT 'Market segment (e.g., North America, EU) for which the OTA release is applicable.',
    `target_model_year_end` STRING COMMENT 'Last model year (inclusive) for which the OTA release is valid.',
    `target_model_year_start` STRING COMMENT 'First model year (inclusive) for which the OTA release is valid.',
    `target_region` STRING COMMENT 'Geographic region(s) where the OTA release is intended to be deployed.',
    `target_vehicle_model` STRING COMMENT 'Vehicle model name or code that the OTA release applies to.',
    `test_result_summary` STRING COMMENT 'Concise summary of key test outcomes supporting the release.',
    `ota_release_type` STRING COMMENT 'Category of the OTA update indicating its purpose.. Valid values are `feature|security|calibration|regulatory`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the OTA release record.',
    `validation_status` STRING COMMENT 'Overall result of all validation activities for the OTA release.. Valid values are `passed|failed|not_tested`',
    `version` STRING COMMENT 'Human‑readable version string of the OTA package (e.g., 2024.03.01).',
    CONSTRAINT pk_ota_release PRIMARY KEY(`ota_release_id`)
) COMMENT 'OTA (Over-the-Air) software release engineering record capturing the definition and approval of a software update package for connected vehicle ECUs. Includes release ID, release version, target ECU or system, software delta description, release type (feature, security patch, calibration, regulatory), compatible vehicle configurations (VIN range or model/MY), validation test references, cybersecurity assessment status, rollout strategy, and release approval date. Bridges engineering and connected mobility domains for software-defined vehicle programs. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`engineering_document` (
    `engineering_document_id` BIGINT COMMENT 'Primary key for local engineering_document reference',
    `compliance_document_id` BIGINT COMMENT 'FK reference to SSOT compliance.compliance_document',
    CONSTRAINT pk_engineering_document PRIMARY KEY(`engineering_document_id`)
) COMMENT 'Reference to SSOT owner compliance.compliance_document. Engineering document record serving as the metadata catalog for all controlled engineering documents managed in the PLM system. Includes document ID, document number, title, document type (drawing, specification, test report, analysis report, FMEA, DVP, meeting minutes), revision level, author, approval status, release date, associated program and part references, document format, storage location reference, and retention policy. Supports document control per IATF 16949 and ISO 9001 requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`engineering_adas_feature` (
    `engineering_adas_feature_id` BIGINT COMMENT 'Unique identifier for the engineering_adas_feature data product (auto-inserted pre-linking).',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: ADAS feature definitions are scoped to a vehicle program; linking enables program‑level reporting.',
    CONSTRAINT pk_engineering_adas_feature PRIMARY KEY(`engineering_adas_feature_id`)
) COMMENT 'ADAS (Advanced Driver Assistance Systems) feature engineering record capturing the definition, requirements, and validation status of an autonomous or assisted driving feature. Includes feature ID, feature name, SAE automation level (L1–L5), feature category (ACC, AEB, LKA, parking assist, highway pilot), applicable program, sensor suite requirements (camera, radar, lidar, ultrasonic), ODD (Operational Design Domain) definition, functional safety ASIL rating, regulatory approval status, and SOP readiness. Supports autonomous driving R&D programs.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`cost_target` (
    `cost_target_id` BIGINT COMMENT 'Unique identifier for the cost target record.',
    `employee_id` BIGINT COMMENT 'Identifier of the engineer responsible for the cost target.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the engineer responsible for the cost target.',
    `vehicle_program_id` BIGINT COMMENT 'Identifier of the vehicle program to which the cost target belongs.',
    `approval_date` DATE COMMENT 'Date when the cost target was approved.',
    `approval_status` STRING COMMENT 'Current approval status of the cost target.. Valid values are `pending|approved|rejected|under_review`',
    `cost_target_code` STRING COMMENT 'Business identifier code for the cost target.',
    `component_code` STRING COMMENT 'Standard code for the component (e.g., BOM part number).',
    `cost_basis` STRING COMMENT 'Basis for the cost target calculation.. Valid values are `baseline|benchmark|historical|target`',
    `cost_gap_percentage` DECIMAL(18,2) COMMENT 'Percentage gap between target and current total cost.',
    `cost_gap_total` DECIMAL(18,2) COMMENT 'Difference between target total cost and current estimated total cost.',
    `cost_manufacturing` DECIMAL(18,2) COMMENT 'Target manufacturing cost amount.',
    `cost_material` DECIMAL(18,2) COMMENT 'Target material cost amount.',
    `cost_methodology` STRING COMMENT 'Methodology used to define the cost target.. Valid values are `DTC|Value Engineering|Target Costing|Other`',
    `cost_reduction_ideas_count` STRING COMMENT 'Number of cost reduction ideas recorded for this target.',
    `cost_total` DECIMAL(18,2) COMMENT 'Overall target cost amount.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the cost target record was created.',
    `currency` STRING COMMENT 'Three-letter ISO currency code for cost values.',
    `current_estimated_cost_manufacturing` DECIMAL(18,2) COMMENT 'Current estimated manufacturing cost.',
    `current_estimated_cost_material` DECIMAL(18,2) COMMENT 'Current estimated material cost.',
    `current_estimated_cost_total` DECIMAL(18,2) COMMENT 'Current total estimated cost.',
    `effective_end_date` DATE COMMENT 'Date when the cost target expires or is superseded.',
    `effective_start_date` DATE COMMENT 'Date when the cost target becomes effective.',
    `freeze_date` DATE COMMENT 'Date when the cost target is frozen and no longer editable.',
    `is_locked` BOOLEAN COMMENT 'Indicates whether the cost target is locked from further changes.',
    `cost_target_name` STRING COMMENT 'Descriptive name of the cost target, e.g., Powertrain System Cost Target.',
    `notes` STRING COMMENT 'Free-text notes or comments regarding the cost target.',
    `cost_target_status` STRING COMMENT 'Lifecycle status of the cost target record.. Valid values are `active|inactive|archived|draft`',
    `system_or_component` STRING COMMENT 'Name of the vehicle system or component the cost target applies to.',
    `cost_target_type` STRING COMMENT 'Classification of the cost target (design, manufacturing, total, etc.).. Valid values are `design|manufacturing|total|material|labor`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the cost target record.',
    `version_number` STRING COMMENT 'Version of the cost target record.',
    CONSTRAINT pk_cost_target PRIMARY KEY(`cost_target_id`)
) COMMENT 'Engineering cost target record capturing the design-to-cost objectives assigned to vehicle systems, subsystems, or components during the development program. Includes target ID, program reference, system or component scope, target cost (material cost, manufacturing cost, total cost), current estimated cost, cost gap vs. target, cost reduction ideas count, responsible engineer, target freeze date, and approval status. Supports design-to-cost (DTC) and value engineering disciplines critical to program profitability.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` (
    `engineering_bom_component_id` BIGINT COMMENT 'Primary key for the bom_component association',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to the part master record',
    `production_bom_id` BIGINT COMMENT 'Foreign key linking to the production BOM record',
    `installation_sequence` STRING COMMENT 'Order in which the part is installed during assembly',
    `quantity_per_vehicle` DECIMAL(18,2) COMMENT 'Number of units of the part required for one vehicle',
    `engineering_bom_component_type` STRING COMMENT 'Classification of the part within the BOM (e.g., standard, optional, service)',
    `unit_of_measure` STRING COMMENT 'Unit in which the quantity is expressed',
    CONSTRAINT pk_engineering_bom_component PRIMARY KEY(`engineering_bom_component_id`)
) COMMENT 'This association product represents the BOM Component relationship between part_master and production_bom. It captures the quantity of the part per vehicle, the unit of measure, the type of component, and the installation sequence within the manufacturing BOM.. Existence Justification: A part_master can be used in many production_bom records (different vehicle models, configurations) and each production_bom contains many part_master entries. The link is managed as BOM component lines that capture quantity, unit of measure, component type, and installation sequence. This relationship is actively created, updated, and deleted by engineering/manufacturing teams as part of the BOM management process.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` (
    `dealer_part_inventory_id` BIGINT COMMENT 'Primary key for the dealer_part_inventory association',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to the dealership',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to the engineering part master',
    `dealer_cost_price` DECIMAL(18,2) COMMENT 'Cost price of the part for the dealership',
    `lead_time_days` STRING COMMENT 'Expected lead time in days for the part to be delivered to the dealership',
    `list_price` DECIMAL(18,2) COMMENT 'Manufacturer list price for the part',
    `quantity_on_hand` BIGINT COMMENT 'Current stock quantity of the part at the dealership',
    `reorder_point` BIGINT COMMENT 'Inventory level that triggers a reorder for the part at the dealership',
    `reorder_quantity` BIGINT COMMENT 'Standard quantity to reorder when the reorder point is reached',
    `retail_price` DECIMAL(18,2) COMMENT 'Retail price offered to end customers by the dealership',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the part quantity (e.g., pieces, sets)',
    CONSTRAINT pk_dealer_part_inventory PRIMARY KEY(`dealer_part_inventory_id`)
) COMMENT 'This association product represents the stocking relationship between engineering part_master records and dealer locations. It captures per‑dealer part quantities, pricing, reorder thresholds, and lead‑time information that are specific to each part‑dealership pairing.. Existence Justification: Dealerships maintain inventory of engineering parts; a single part can be stocked at many dealership locations and each dealership stocks many different parts. The stocking relationship is actively managed through inventory records that capture quantities, pricing, and lead‑time per dealer‑part combination.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` (
    `engineering_team_id` BIGINT COMMENT 'Primary key for engineering_team',
    `employee_id` BIGINT COMMENT 'FK to workforce.employee',
    `parent_engineering_team_id` BIGINT COMMENT 'Self-referencing FK on engineering_team (parent_engineering_team_id)',
    `primary_employee_id` BIGINT COMMENT 'Unique identifier of the employee who manages the team.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Engineering teams are organized around vehicle programs; linking enables program‑level resource planning.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Annual budget allocated to the engineering team (currency assumed corporate default).',
    `engineering_team_code` STRING COMMENT 'Unique alphanumeric code used to reference the team across systems.',
    `compliance_status` STRING COMMENT 'Current compliance standing of the team with internal and external regulations.',
    `contact_email` STRING COMMENT 'Primary email address for team communications.',
    `contact_phone` STRING COMMENT 'Primary telephone number for the team.',
    `cost_center_code` STRING COMMENT 'Financial cost‑center identifier to which the teams expenses are charged.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the team record was first created in the system.',
    `data_classification` STRING COMMENT 'Classification level applied to data owned by the team.',
    `engineering_team_description` STRING COMMENT 'Free‑form description of the teams purpose, scope, and responsibilities.',
    `digital_twin_enabled` BOOLEAN COMMENT 'True if the team actively creates and maintains digital twin models.',
    `domain` STRING COMMENT 'Functional domain the team primarily supports.',
    `effective_from` DATE COMMENT 'Date when the team became operational or was officially established.',
    `effective_until` DATE COMMENT 'Date when the team was dissolved or ceased operations (null if still active).',
    `engineering_toolset` STRING COMMENT 'Primary CAD/CAE software suite used by the team.',
    `is_virtual` BOOLEAN COMMENT 'True if the team operates primarily in a virtual/remote mode.',
    `last_review_date` DATE COMMENT 'Date of the most recent governance or performance review of the team.',
    `last_reviewed_by` STRING COMMENT 'Name of the person who performed the last review.',
    `engineering_team_level` STRING COMMENT 'Scope level of the team within the organization.',
    `location` STRING COMMENT 'Primary physical site or plant where the team is based (e.g., plant code).',
    `engineering_team_name` STRING COMMENT 'Human‑readable name of the engineering team.',
    `notes` STRING COMMENT 'Additional free‑form remarks or observations about the team.',
    `number_of_members` STRING COMMENT 'Current headcount of engineers and staff assigned to the team.',
    `primary_skill` STRING COMMENT 'Dominant engineering discipline of the team.',
    `safety_certification_level` STRING COMMENT 'Functional safety classification of the teams deliverables per ISO 26262.',
    `engineering_team_status` STRING COMMENT 'Current lifecycle status of the team.',
    `engineering_team_type` STRING COMMENT 'Category of engineering work performed by the team.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the team record.',
    CONSTRAINT pk_engineering_team PRIMARY KEY(`engineering_team_id`)
) COMMENT 'Master reference table for engineering_team. Referenced by team_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`material` (
    `material_id` BIGINT COMMENT 'Primary key for material',
    `parent_material_id` BIGINT COMMENT 'Self-referencing FK on material (parent_material_id)',
    `supply_supplier_id` BIGINT COMMENT 'add column supplier_id (BIGINT) with FK to supply.supply_supplier.supply_supplier_id - materials are sourced from specific suppliers',
    `application` STRING COMMENT 'Typical engineering subsystem where the material is used.',
    `boiling_point_c` DECIMAL(18,2) COMMENT 'Temperature at which the material transitions from liquid to gas.',
    `certification` STRING COMMENT 'Quality or compliance certifications associated with the material.',
    `material_code` STRING COMMENT 'External catalog or part number assigned to the material by the organization.',
    `color` STRING COMMENT 'Standard color designation of the material (e.g., black, silver).',
    `corrosion_resistance` STRING COMMENT 'Qualitative rating of the materials resistance to corrosion in typical automotive environments.',
    `cost_per_kg_usd` DECIMAL(18,2) COMMENT 'Current purchase cost of the material per kilogram in US dollars.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the material record was first created in the system.',
    `customs_tariff_code` STRING COMMENT 'Eight‑digit HS code used for import/export classification.',
    `density_kg_per_m3` DECIMAL(18,2) COMMENT 'Mass per unit volume of the material.',
    `effective_from` DATE COMMENT 'Date when the material becomes valid for use in engineering projects.',
    `effective_until` DATE COMMENT 'Date when the material is retired or no longer approved for new designs (nullable).',
    `electrical_resistivity_ohm_m` DECIMAL(18,2) COMMENT 'Resistance to electrical current flow.',
    `elongation_percent` DECIMAL(18,2) COMMENT 'Percentage increase in length at fracture, indicating ductility.',
    `environmental_impact_score` DECIMAL(18,2) COMMENT 'Numerical score representing the materials overall environmental footprint.',
    `family` STRING COMMENT 'Secondary classification grouping materials by typical engineering use.',
    `grade` STRING COMMENT 'Specific grade or standard within the material type (e.g., 6061‑T6 for aluminum).',
    `group` STRING COMMENT 'Higher‑level grouping used for cost and inventory planning.',
    `hardness_hb` DECIMAL(18,2) COMMENT 'Hardness measurement using the Brinell scale.',
    `hazardous` BOOLEAN COMMENT 'Indicates whether the material is classified as hazardous under safety regulations.',
    `hazardous_class` STRING COMMENT 'Regulatory classification of the hazardous material.',
    `melting_point_c` DECIMAL(18,2) COMMENT 'Temperature at which the material transitions from solid to liquid.',
    `msds_url` STRING COMMENT 'Link to the online Material Safety Data Sheet for the material.',
    `material_name` STRING COMMENT 'Human‑readable name of the material as used in engineering documentation.',
    `notes` STRING COMMENT 'Free‑form field for additional remarks or engineering comments.',
    `origin_country` STRING COMMENT 'ISO 3166‑1 alpha‑3 code of the country where the material is sourced.',
    `reach_compliant` BOOLEAN COMMENT 'True if the material complies with EU REACH chemical safety requirements.',
    `recyclable` BOOLEAN COMMENT 'Indicates whether the material can be recycled at end‑of‑life.',
    `recycle_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of the material that can be recovered and reused.',
    `revision_number` STRING COMMENT 'Minor revision identifier for changes to the material record.',
    `rohs_compliant` BOOLEAN COMMENT 'True if the material meets RoHS restrictions on hazardous substances.',
    `source` STRING COMMENT 'Indicates whether the material is produced in‑house or procured from external suppliers.',
    `specification` STRING COMMENT 'Detailed technical specification document reference for the material.',
    `material_status` STRING COMMENT 'Current lifecycle status of the material in the engineering catalog.',
    `surface_finish` STRING COMMENT 'Description of the materials surface treatment (e.g., polished, anodized).',
    `tensile_strength_mpa` DECIMAL(18,2) COMMENT 'Maximum stress the material can withstand while being stretched before failure.',
    `thermal_conductivity_w_per_mk` DECIMAL(18,2) COMMENT 'Rate at which heat passes through the material.',
    `material_type` STRING COMMENT 'Broad classification of the material based on its composition.',
    `unit_of_measure` STRING COMMENT 'Standard unit used for material quantity calculations.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the material record.',
    `version_number` STRING COMMENT 'Major version of the material definition.',
    `yield_strength_mpa` DECIMAL(18,2) COMMENT 'Stress at which material begins to deform plastically.',
    CONSTRAINT pk_material PRIMARY KEY(`material_id`)
) COMMENT 'Master reference table for material. Referenced by material_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` (
    `engineering_change_action_id` BIGINT COMMENT 'System-generated unique identifier for the engineering action record.',
    `employee_id` BIGINT COMMENT 'Identifier of the engineer responsible for executing the action.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the engineer responsible for executing the action.',
    `actual_effort_hours` DECIMAL(18,2) COMMENT 'Recorded labor effort spent on the action.',
    `attachment_count` STRING COMMENT 'Number of supporting documents or files attached to the action.',
    `closure_timestamp` TIMESTAMP COMMENT 'Timestamp when the action was officially closed in the system.',
    `engineering_change_action_code` STRING COMMENT 'Business identifier code for the action, used for tracking and reference across systems.',
    `comments` STRING COMMENT 'Free-text field for additional remarks or notes.',
    `completion_date` DATE COMMENT 'Actual date when the action was marked completed.',
    `compliance_flag` BOOLEAN COMMENT 'True if the action is required to meet regulatory or internal compliance standards.',
    `cost_estimate` DECIMAL(18,2) COMMENT 'Estimated monetary cost to implement the action.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the engineering action record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for the cost estimate.. Valid values are `^[A-Z]{3}$`',
    `engineering_change_action_description` STRING COMMENT 'Detailed description of the issue, corrective measure, or improvement required.',
    `due_date` DATE COMMENT 'Planned date by which the action should be completed.',
    `estimated_effort_hours` DECIMAL(18,2) COMMENT 'Projected labor effort required to complete the action.',
    `is_critical` BOOLEAN COMMENT 'Indicates whether the action is deemed critical to program success.',
    `priority` STRING COMMENT 'Business priority assigned to the action to indicate urgency.. Valid values are `low|medium|high|critical`',
    `resolution_description` STRING COMMENT 'Narrative of how the action was resolved or closed.',
    `risk_level` STRING COMMENT 'Assessed risk associated with the actions impact on the program.. Valid values are `low|medium|high|critical`',
    `source_event` STRING COMMENT 'Originating event that triggered the creation of the engineering action.. Valid values are `test_failure|fmea_finding|gate_review|audit|customer_feedback|regulatory_issue`',
    `engineering_change_action_status` STRING COMMENT 'Current lifecycle status of the engineering action.. Valid values are `open|in_progress|completed|closed|cancelled`',
    `target_milestone` STRING COMMENT 'Program milestone or gate that the action is associated with.',
    `timestamp` TIMESTAMP COMMENT 'Timestamp of the real-world event that initiated the action.',
    `title` STRING COMMENT 'Short descriptive title summarizing the engineering action.',
    `engineering_change_action_type` STRING COMMENT 'Category of the engineering action indicating the nature of work required.. Valid values are `design_change|test_rerun|analysis|supplier_engagement|process_improvement|documentation_update`',
    `updated_by` STRING COMMENT 'User identifier of the person who last modified the action record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the engineering action record.',
    `created_by` STRING COMMENT 'User identifier of the person who created the action record.',
    CONSTRAINT pk_engineering_change_action PRIMARY KEY(`engineering_change_action_id`)
) COMMENT 'Engineering action item record capturing a specific task or corrective action arising from a design review, test failure, FMEA finding, or milestone gate review. Includes action ID, action title, action type (design change, test rerun, analysis, supplier engagement), source event (test failure, FMEA, gate review), assigned engineer, due date, priority, completion status, resolution description, and linked parent record (validation test, FMEA, milestone). Enables systematic tracking of open engineering issues to closure.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` (
    `engineering_project_id` BIGINT COMMENT 'Primary key for project',
    `employee_id` BIGINT COMMENT 'Identifier of the sponsoring organization or business unit.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the person managing the project.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Projects are typically executed within the context of a vehicle program; linking provides program‑level project tracking.',
    `actual_cost` DECIMAL(18,2) COMMENT 'Cumulative cost incurred to date.',
    `approved_by` BIGINT COMMENT 'Identifier of the person who approved the project.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the project received formal approval.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Approved budget for the project in the functional currency.',
    `change_order_count` STRING COMMENT 'Number of engineering change orders issued for the project.',
    `engineering_project_code` STRING COMMENT 'Unique business code assigned to the project.',
    `compliance_regulation` STRING COMMENT 'Primary regulatory compliance framework applicable to the project.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the project record was created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for budget and cost.',
    `data_classification` STRING COMMENT 'Classification level for the project data as per corporate policy.',
    `department` STRING COMMENT 'Business department responsible for the project.',
    `engineering_project_description` STRING COMMENT 'Detailed description of the projects scope and objectives.',
    `digital_twin_enabled` BOOLEAN COMMENT 'Flag indicating if a digital twin model is created for the project.',
    `end_date` DATE COMMENT 'Actual end date when work was completed.',
    `engineering_phase` STRING COMMENT 'Current engineering phase of the project.',
    `expected_mtbf_hours` DECIMAL(18,2) COMMENT 'Estimated mean time between failures for components developed in the project, expressed in hours.',
    `external_partner` STRING COMMENT 'Name of any external partner organization collaborating on the project.',
    `is_archived` BOOLEAN COMMENT 'Indicates whether the project record is archived and no longer active.',
    `is_global` BOOLEAN COMMENT 'Indicates whether the project spans multiple geographic regions.',
    `last_review_date` DATE COMMENT 'Date of the most recent project health review.',
    `milestone_count` STRING COMMENT 'Total number of milestones defined for the project.',
    `milestone_status` STRING COMMENT 'Overall status of project milestones.',
    `engineering_project_name` STRING COMMENT 'Human readable name of the engineering project.',
    `notes` STRING COMMENT 'Free-form notes captured by project team.',
    `planned_end_date` DATE COMMENT 'Scheduled end date as per project plan.',
    `planned_start_date` DATE COMMENT 'Scheduled start date as per project plan.',
    `plant_location` STRING COMMENT 'Identifier of the manufacturing plant or site where the project is executed.',
    `priority` STRING COMMENT 'Business priority assigned to the project.',
    `review_outcome` STRING COMMENT 'Result of the latest project health review.',
    `risk_level` STRING COMMENT 'Overall risk assessment for the project.',
    `start_date` DATE COMMENT 'Actual start date when work commenced.',
    `engineering_project_status` STRING COMMENT 'Current lifecycle status of the project.',
    `sustainability_score` STRING COMMENT 'Internal score (0-100) assessing the projects environmental impact.',
    `engineering_project_type` STRING COMMENT 'Category of engineering work the project represents.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the project record.',
    `vehicle_platform` STRING COMMENT 'Vehicle platform or model family associated with the project.',
    `version_number` STRING COMMENT 'Version identifier for the projects documentation set.',
    CONSTRAINT pk_engineering_project PRIMARY KEY(`engineering_project_id`)
) COMMENT 'Master reference table for project. Referenced by project_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`cfd_simulation_result` (
    `cfd_simulation_result_id` BIGINT COMMENT 'Primary key for cfd_simulation_result',
    `vehicle_program_id` BIGINT COMMENT 'FK to vehicle program',
    CONSTRAINT pk_cfd_simulation_result PRIMARY KEY(`cfd_simulation_result_id`)
) COMMENT 'Engineering R&D product: cfd simulation result';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`fea_simulation_result` (
    `fea_simulation_result_id` BIGINT COMMENT 'Primary key for fea_simulation_result',
    `vehicle_program_id` BIGINT COMMENT 'FK to vehicle program',
    CONSTRAINT pk_fea_simulation_result PRIMARY KEY(`fea_simulation_result_id`)
) COMMENT 'Engineering R&D product: fea simulation result';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`nvh_test_result` (
    `nvh_test_result_id` BIGINT COMMENT 'Primary key for nvh_test_result',
    `vehicle_program_id` BIGINT COMMENT 'FK to vehicle program',
    CONSTRAINT pk_nvh_test_result PRIMARY KEY(`nvh_test_result_id`)
) COMMENT 'Engineering R&D product: nvh test result';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`test_bench_run` (
    `test_bench_run_id` BIGINT COMMENT 'Primary key for test_bench_run',
    `vehicle_program_id` BIGINT COMMENT 'FK to vehicle program',
    CONSTRAINT pk_test_bench_run PRIMARY KEY(`test_bench_run_id`)
) COMMENT 'Engineering R&D product: test bench run';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`sensor_dataset` (
    `sensor_dataset_id` BIGINT COMMENT 'Primary key for sensor_dataset',
    `vehicle_program_id` BIGINT COMMENT 'FK to vehicle program',
    CONSTRAINT pk_sensor_dataset PRIMARY KEY(`sensor_dataset_id`)
) COMMENT 'Engineering R&D product: sensor dataset';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`driving_scenario_library` (
    `driving_scenario_library_id` BIGINT COMMENT 'Primary key for driving_scenario_library',
    `vehicle_program_id` BIGINT COMMENT 'FK to vehicle program',
    CONSTRAINT pk_driving_scenario_library PRIMARY KEY(`driving_scenario_library_id`)
) COMMENT 'Engineering R&D product: driving scenario library';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`requirements_traceability` (
    `requirements_traceability_id` BIGINT COMMENT 'Primary key for requirements_traceability',
    `vehicle_program_id` BIGINT COMMENT 'FK to vehicle program',
    CONSTRAINT pk_requirements_traceability PRIMARY KEY(`requirements_traceability_id`)
) COMMENT 'Engineering R&D product: requirements traceability';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`engineering`.`packaging_specification` (
    `packaging_specification_id` BIGINT COMMENT 'Primary key',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp',
    `packaging_specification_status` STRING COMMENT 'Current status',
    CONSTRAINT pk_packaging_specification PRIMARY KEY(`packaging_specification_id`)
) COMMENT 'Engineering product: packaging specification';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ADD CONSTRAINT `fk_engineering_bom_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ADD CONSTRAINT `fk_engineering_bom_bom_engineering_change_order_change_id` FOREIGN KEY (`bom_engineering_change_order_change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` ADD CONSTRAINT `fk_engineering_engineering_bom_line_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`bom`(`bom_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` ADD CONSTRAINT `fk_engineering_engineering_bom_line_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ADD CONSTRAINT `fk_engineering_cad_model_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ADD CONSTRAINT `fk_engineering_cad_model_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ADD CONSTRAINT `fk_engineering_cae_simulation_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ADD CONSTRAINT `fk_engineering_cae_simulation_cae_part_part_master_id` FOREIGN KEY (`cae_part_part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ADD CONSTRAINT `fk_engineering_prototype_build_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ADD CONSTRAINT `fk_engineering_validation_test_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ADD CONSTRAINT `fk_engineering_validation_test_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_test_result` ADD CONSTRAINT `fk_engineering_engineering_test_result_validation_test_id` FOREIGN KEY (`validation_test_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`validation_test`(`validation_test_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ADD CONSTRAINT `fk_engineering_digital_twin_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ADD CONSTRAINT `fk_engineering_digital_twin_prototype_build_id` FOREIGN KEY (`prototype_build_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`prototype_build`(`prototype_build_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ADD CONSTRAINT `fk_engineering_digital_twin_digital_prototype_prototype_build_id` FOREIGN KEY (`digital_prototype_prototype_build_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`prototype_build`(`prototype_build_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ADD CONSTRAINT `fk_engineering_digital_twin_engineering_team_id` FOREIGN KEY (`engineering_team_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_team`(`engineering_team_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ADD CONSTRAINT `fk_engineering_digital_twin_primary_digital_part_master_id` FOREIGN KEY (`primary_digital_part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ADD CONSTRAINT `fk_engineering_digital_twin_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ADD CONSTRAINT `fk_engineering_milestone_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ADD CONSTRAINT `fk_engineering_fmea_record_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ADD CONSTRAINT `fk_engineering_fmea_record_fmea_part_part_master_id` FOREIGN KEY (`fmea_part_part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ADD CONSTRAINT `fk_engineering_dvp_plan_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ADD CONSTRAINT `fk_engineering_dvp_plan_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ADD CONSTRAINT `fk_engineering_dvp_plan_dvp_part_part_master_id` FOREIGN KEY (`dvp_part_part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ADD CONSTRAINT `fk_engineering_dvp_plan_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ADD CONSTRAINT `fk_engineering_dvp_plan_dvp_related_specification_design_specification_id` FOREIGN KEY (`dvp_related_specification_design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ADD CONSTRAINT `fk_engineering_dvp_plan_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ADD CONSTRAINT `fk_engineering_homologation_requirement_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ADD CONSTRAINT `fk_engineering_powertrain_spec_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ADD CONSTRAINT `fk_engineering_weight_report_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ADD CONSTRAINT `fk_engineering_design_review_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ADD CONSTRAINT `fk_engineering_material_specification_material_id` FOREIGN KEY (`material_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`material`(`material_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ADD CONSTRAINT `fk_engineering_material_specification_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ADD CONSTRAINT `fk_engineering_configuration_rule_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ADD CONSTRAINT `fk_engineering_ota_release_engineering_team_id` FOREIGN KEY (`engineering_team_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_team`(`engineering_team_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ADD CONSTRAINT `fk_engineering_ota_release_ecu_specification_id` FOREIGN KEY (`ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ADD CONSTRAINT `fk_engineering_ota_release_target_ecu_ecu_specification_id` FOREIGN KEY (`target_ecu_ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ADD CONSTRAINT `fk_engineering_ota_release_validation_test_id` FOREIGN KEY (`validation_test_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`validation_test`(`validation_test_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ADD CONSTRAINT `fk_engineering_ota_release_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_adas_feature` ADD CONSTRAINT `fk_engineering_engineering_adas_feature_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ADD CONSTRAINT `fk_engineering_cost_target_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` ADD CONSTRAINT `fk_engineering_engineering_bom_component_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ADD CONSTRAINT `fk_engineering_dealer_part_inventory_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ADD CONSTRAINT `fk_engineering_engineering_team_parent_engineering_team_id` FOREIGN KEY (`parent_engineering_team_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_team`(`engineering_team_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ADD CONSTRAINT `fk_engineering_engineering_team_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ADD CONSTRAINT `fk_engineering_material_parent_material_id` FOREIGN KEY (`parent_material_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`material`(`material_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ADD CONSTRAINT `fk_engineering_engineering_project_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cfd_simulation_result` ADD CONSTRAINT `fk_engineering_cfd_simulation_result_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fea_simulation_result` ADD CONSTRAINT `fk_engineering_fea_simulation_result_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`nvh_test_result` ADD CONSTRAINT `fk_engineering_nvh_test_result_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`test_bench_run` ADD CONSTRAINT `fk_engineering_test_bench_run_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`sensor_dataset` ADD CONSTRAINT `fk_engineering_sensor_dataset_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`driving_scenario_library` ADD CONSTRAINT `fk_engineering_driving_scenario_library_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`requirements_traceability` ADD CONSTRAINT `fk_engineering_requirements_traceability_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`engineering` SET TAGS ('dbx_pii_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`engineering` SET TAGS ('dbx_pii_domain' = 'engineering');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` SET TAGS ('dbx_pii_subdomain' = 'program_management');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Manager Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `bom_version` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `budget_allocation` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Budget Allocation');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `budget_allocation` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `cad_release_version` SET TAGS ('dbx_pii_business_glossary_term' = 'CAD Release Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `cae_release_version` SET TAGS ('dbx_pii_business_glossary_term' = 'CAE Release Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `digital_twin_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Twin Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `drivetrain` SET TAGS ('dbx_pii_business_glossary_term' = 'Drivetrain Configuration');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `drivetrain` SET TAGS ('dbx_pii_value_regex' = 'FWD|RWD|AWD|4WD');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `emission_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Standard');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `emission_standard` SET TAGS ('dbx_pii_value_regex' = 'EPA|Euro6|Euro5|CARB|UN/ECE');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production Target Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `engineering_change_order_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change Order Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `launch_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Launch Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `model_year_end` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year End');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `model_year_start` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year Start');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `ota_update_capability` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Update Capability Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `platform_architecture` SET TAGS ('dbx_pii_business_glossary_term' = 'Platform Architecture');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|EV|HEV|PHEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected|under_review');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Segment');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `segment` SET TAGS ('dbx_pii_value_regex' = 'sedan|suv|truck|crossover|van|coupe');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production Target Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_status` SET TAGS ('dbx_pii_value_regex' = 'concept|development|validation|launch|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_cost_per_vehicle` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Cost Per Vehicle');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_cost_per_vehicle` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_emissions_g_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Emissions (g/km)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_fuel_efficiency_mpg` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Fuel Efficiency (MPG)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_market` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Market Region');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_production_volume` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Production Volume');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_range_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Electric Range (km)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `target_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Vehicle Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_program_type` SET TAGS ('dbx_pii_value_regex' = 'nameplate|platform|concept');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ALTER COLUMN `vehicle_class` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Class');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering BOM ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `change_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change Order ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_engineering_change_order_change_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change Order ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `change_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Reason');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering BOM Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_value_regex' = 'ISO26262|IATF16949|SAEJ3061');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_description` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `is_locked` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Locked');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|pending|retired');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering BOM Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `owner_department` SET TAGS ('dbx_pii_business_glossary_term' = 'Owner Department');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `plant_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Location');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `program_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `release_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `release_status` SET TAGS ('dbx_pii_value_regex' = 'draft|released|archived|obsolete');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `total_parts_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Parts Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `total_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Quantity');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_type` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `bom_type` SET TAGS ('dbx_pii_value_regex' = 'eBOM|mBOM|sBOM');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `vehicle_variant` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Variant Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` ALTER COLUMN `engineering_bom_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for engineering_bom_line');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` ALTER COLUMN `bom_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Bom Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Assembly Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Master Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Owning Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Owning Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `cad_model_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'CAD Model Reference');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `cost_usd` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Cost (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `cost_usd` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `criticality` SET TAGS ('dbx_pii_business_glossary_term' = 'Criticality Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `criticality` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `drawing_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Drawing Number (DRW)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `eol_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'End‑of‑Life Reason');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `height_mm` SET TAGS ('dbx_pii_business_glossary_term' = 'Height (mm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `inspection_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `inspection_status` SET TAGS ('dbx_pii_value_regex' = 'passed|failed|rework|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `is_active` SET TAGS ('dbx_pii_business_glossary_term' = 'Active Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `length_mm` SET TAGS ('dbx_pii_business_glossary_term' = 'Length (mm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifecycle Status (LCS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'in_work|released|obsoleted|pending_release|discontinued');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `material` SET TAGS ('dbx_pii_business_glossary_term' = 'Material (MAT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `obsolescence_notice` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolescence Notice Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Classification');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_classification` SET TAGS ('dbx_pii_value_regex' = 'mechanical|electrical|hydraulic|software|electronic|structural');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_family` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Family');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Number (PN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Type (PT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `part_type` SET TAGS ('dbx_pii_value_regex' = 'raw|processed|assembly|subassembly|component');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `quality_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Rating');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `quality_rating` SET TAGS ('dbx_pii_value_regex' = 'A|B|C|D|E|F');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `reach_compliance` SET TAGS ('dbx_pii_business_glossary_term' = 'REACH Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `revision_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Level (REV)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `rohs_compliance` SET TAGS ('dbx_pii_business_glossary_term' = 'RoHS Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `supplier_part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Part Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `volume_cm3` SET TAGS ('dbx_pii_business_glossary_term' = 'Volume (cm³)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ALTER COLUMN `width_mm` SET TAGS ('dbx_pii_business_glossary_term' = 'Width (mm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Specification Identifier (DSID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Author Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date (Approval Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status (Approval Status)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'approved|rejected|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `approver` SET TAGS ('dbx_pii_business_glossary_term' = 'Approver Name (Approver)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `author` SET TAGS ('dbx_pii_business_glossary_term' = 'Author Name (Author)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `change_order_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Order Date (CO Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `change_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Order Number (CO Number)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status (Compliance)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `component_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Component Name (Component)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Confidentiality Level (Conf Level)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_pii_value_regex' = 'internal|confidential|restricted');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `cost_estimate_usd` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Estimate (USD) (Cost Est)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `design_specification_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Specification Description (Description)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `design_phase` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Phase (Phase)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `design_phase` SET TAGS ('dbx_pii_value_regex' = 'concept|development|validation|production');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `dimensions_mm` SET TAGS ('dbx_pii_business_glossary_term' = 'Dimensions (mm) (Dimensions)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `document_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Lifecycle Status (Doc Status)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `document_status` SET TAGS ('dbx_pii_value_regex' = 'draft|in_review|approved|released|archived');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date (Effective Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `engineering_department` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Department (Dept)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date (Expiration Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `interface_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Interface Name (Interface)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `is_active` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Active Flag (Active)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifecycle Stage (Lifecycle)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_pii_value_regex' = 'prototype|pre_production|production|post_production');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `linked_requirements` SET TAGS ('dbx_pii_business_glossary_term' = 'Linked Requirement Identifiers (Req IDs)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `material_specification` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Specification Details (Material Spec)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `obsolescence_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolescence Date (Obsolescence Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `program` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Name (Program)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (Created At)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp (Updated At)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Reference Codes (Reg Ref)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `related_documents` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Document Identifiers (Related Docs)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `release_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Date (Release Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `revision_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Date (Rev Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Number (Rev No.)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `spec_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Specification Number (DSN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `spec_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Specification Type (Spec Type)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `spec_type` SET TAGS ('dbx_pii_value_regex' = 'system|subsystem|component|interface');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `subsystem_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Subsystem Name (Subsystem)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `system_name` SET TAGS ('dbx_pii_business_glossary_term' = 'System Name (System)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `target_performance_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Performance Units (Units)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `target_performance_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Performance Value (Target Perf)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `test_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Method (Test Method)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `test_method` SET TAGS ('dbx_pii_value_regex' = 'CFD|FEA|NVH|Simulation|Physical_Test');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `test_result_summary` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Result Summary (Test Summary)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `title` SET TAGS ('dbx_pii_business_glossary_term' = 'Specification Title (Title)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated By (Updated By)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number (Version)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight (kg) (Weight)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created By (Created By)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `cad_model_id` SET TAGS ('dbx_pii_business_glossary_term' = 'CAD Model Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Owning Designer Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Owning Designer Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `assembly_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `compliance_iso26262_level` SET TAGS ('dbx_pii_business_glossary_term' = 'ISO 26262 Safety Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `compliance_iso26262_level` SET TAGS ('dbx_pii_value_regex' = 'ASIL_A|ASIL_B|ASIL_C|ASIL_D|none');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `configuration_context` SET TAGS ('dbx_pii_business_glossary_term' = 'Configuration Context');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `coordinate_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Coordinate System');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `design_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Approval Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `design_approval_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `design_change_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Change Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `design_change_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Change Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `design_release_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Release Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `digital_twin_ready` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Twin Ready Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `file_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Model File Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `file_path` SET TAGS ('dbx_pii_business_glossary_term' = 'Model File Path');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `file_size_bytes` SET TAGS ('dbx_pii_business_glossary_term' = 'Model File Size (Bytes)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `geometry_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Geometry Units');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `geometry_units` SET TAGS ('dbx_pii_value_regex' = 'mm|cm|m|in|ft');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `is_digital_mockup_included` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Mock‑Up Inclusion Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `last_published_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Published Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'CAD Model Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'in_design|in_review|approved|released|retired');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `maturity_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Maturity Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `maturity_level` SET TAGS ('dbx_pii_value_regex' = 'concept|detailed_design|validation|production');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `cad_model_name` SET TAGS ('dbx_pii_business_glossary_term' = 'CAD Model Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'CAD Model Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `related_vehicle_variant` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Vehicle Variant');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `revision` SET TAGS ('dbx_pii_business_glossary_term' = 'CAD Model Revision');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `simulation_ready` SET TAGS ('dbx_pii_business_glossary_term' = 'Simulation Ready Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `cad_model_status` SET TAGS ('dbx_pii_business_glossary_term' = 'CAD Model Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `cad_model_status` SET TAGS ('dbx_pii_value_regex' = 'draft|released|archived|obsolete');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `tool_version` SET TAGS ('dbx_pii_business_glossary_term' = 'CAD Tool Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `cad_model_type` SET TAGS ('dbx_pii_business_glossary_term' = 'CAD Model Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `cad_model_type` SET TAGS ('dbx_pii_value_regex' = 'part|assembly|surface|solid|wireframe');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By (Designer)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `vehicle_model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Year');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `vehicle_platform` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Platform');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `version` SET TAGS ('dbx_pii_business_glossary_term' = 'CAD Model Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By (Designer)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` SET TAGS ('dbx_pii_subdomain' = 'change_control');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `approver_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Initiator ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `tooling_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Tooling Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `affected_parts` SET TAGS ('dbx_pii_business_glossary_term' = 'Affected Parts');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `affected_programs` SET TAGS ('dbx_pii_business_glossary_term' = 'Affected Programs');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `closure_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Closure Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_adjustments` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Adjustments');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_adjustments` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_adjustments` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_estimate_gross` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Cost Estimate');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_estimate_gross` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_estimate_gross` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_net` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Cost Estimate');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_net` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `cost_net` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|GBP|CAD|AUD');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `impact_analysis` SET TAGS ('dbx_pii_business_glossary_term' = 'Impact Analysis');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `implementation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Implementation Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `origin` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Origin');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `origin` SET TAGS ('dbx_pii_value_regex' = 'internal|supplier|customer');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Priority');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `reason_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Reason Category');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `reason_category` SET TAGS ('dbx_pii_value_regex' = 'cost_reduction|quality|regulatory|customer_request|other');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `reason_detail` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Reason Detail');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `request_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Request Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Revision Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `risk_assessment` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Assessment');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `scope` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Scope');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `scope` SET TAGS ('dbx_pii_value_regex' = 'part|assembly|specification|process');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_status` SET TAGS ('dbx_pii_value_regex' = 'draft|under_review|approved|implemented|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `title` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Title');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `change_type` SET TAGS ('dbx_pii_value_regex' = 'ECR|ECO|ECN');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ALTER COLUMN `version` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` SET TAGS ('dbx_pii_subdomain' = 'validation_testing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `cae_simulation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'CAE Simulation ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Analyst ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `cae_part_part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Analyst ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `analyst_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Analyst Name (ANALYST_NAME)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `boundary_conditions` SET TAGS ('dbx_pii_business_glossary_term' = 'Boundary Conditions (BC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `convergence_criteria` SET TAGS ('dbx_pii_business_glossary_term' = 'Convergence Criteria (CONV_CRIT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `cpu_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'CPU Time (CPU_TIME_S)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `load_case` SET TAGS ('dbx_pii_business_glossary_term' = 'Load Case Description (LOAD_CASE)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `memory_usage_mb` SET TAGS ('dbx_pii_business_glossary_term' = 'Memory Usage (MEMORY_MB)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `mesh_element_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Mesh Element Count (MESH_ELEM_COUNT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `mesh_quality_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Mesh Quality Score (MESH_QUALITY)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Simulation Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Simulation Number (SIM_NO)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `part_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Name (PART_NAME)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Number (PART_NO)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `result_metric_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Result Metric Name (RESULT_METRIC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `result_metric_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Result Metric Unit (RESULT_UNIT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `result_metric_unit` SET TAGS ('dbx_pii_value_regex' = 'MPa|Pa|N|kg|m/s^2|Hz');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `result_metric_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Result Metric Value (RESULT_VALUE)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `result_outcome` SET TAGS ('dbx_pii_business_glossary_term' = 'Result Outcome (OUTCOME)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `result_outcome` SET TAGS ('dbx_pii_value_regex' = 'pass|fail');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `run_duration_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Run Duration (RUN_DURATION_S)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `run_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Run Timestamp (RUN_TS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `solver_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Solver Name (SOLVER)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `cae_simulation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Simulation Status (SIM_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `cae_simulation_status` SET TAGS ('dbx_pii_value_regex' = 'draft|queued|running|completed|failed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `target_metric_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Metric Name (TARGET_METRIC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `target_metric_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Metric Unit (TARGET_UNIT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `target_metric_unit` SET TAGS ('dbx_pii_value_regex' = 'MPa|Pa|N|kg|m/s^2|Hz');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `target_metric_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Metric Value (TARGET_VALUE)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `cae_simulation_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Simulation Type (SIM_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `cae_simulation_type` SET TAGS ('dbx_pii_value_regex' = 'FEA|CFD|NVH|Crash|Thermal|Fatigue');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ALTER COLUMN `version` SET TAGS ('dbx_pii_business_glossary_term' = 'Simulation Version (VERSION)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` SET TAGS ('dbx_pii_subdomain' = 'validation_testing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `prototype_build_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Prototype Build ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `prototype_responsible_engineer_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `prototype_responsible_engineer_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `prototype_responsible_engineer_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `configuration_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Configuration Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Cost');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `cost` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|CAD|GBP|CNY');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `data_source_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System of Record');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `data_source_system` SET TAGS ('dbx_pii_value_regex' = 'Teamcenter|CATIA|ENOVIA|SAP|MES');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `prototype_build_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `duration_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Duration Hours');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `emission_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Rating');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `emission_rating` SET TAGS ('dbx_pii_value_regex' = 'tier1|tier2|tier3|tier4');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `location` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Location');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `phase` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Phase');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `phase` SET TAGS ('dbx_pii_value_regex' = 'mule|alpha|beta|pre_production|production');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `program_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `prototype_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Prototype Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `purpose` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Purpose');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `purpose` SET TAGS ('dbx_pii_value_regex' = 'durability|crash|nvh|emissions|homologation|validation');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `safety_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `safety_rating` SET TAGS ('dbx_pii_value_regex' = 'ncap|euro_ncap|none');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `prototype_build_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `prototype_build_status` SET TAGS ('dbx_pii_value_regex' = 'planned|in_progress|completed|failed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `test_results_summary` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Results Summary');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `vin` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ALTER COLUMN `vin` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` SET TAGS ('dbx_pii_subdomain' = 'validation_testing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Validation Test ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Engineer Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date (AD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Approval Status (TAS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'approved|rejected|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By (AB)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Batch Number (TBN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Category (TCAT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_category` SET TAGS ('dbx_pii_value_regex' = 'structural|powertrain|electronics|software');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Comments (TC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Standard (CS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_value_regex' = 'FMVSS|EPA|NCAP|WLTP');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `data_source_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System for Test Data (SS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `disposition` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Disposition (TD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `disposition` SET TAGS ('dbx_pii_value_regex' = 'accept|rework|reject');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `document_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Document Reference (TDR)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Duration (Minutes) (TDUR)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `emission_co2_g_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured CO2 Emission (g/km) (MCO2)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `engineer` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Engineer (TE)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `engineer` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `engineer` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `engineering_test_result_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Report Identifier (TRID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `equipment_used` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Used (EU)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `facility` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Facility (TF)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Test Flag (CTF)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `location` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Location Code (TLC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Validation Test Name (VTN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `noise_db` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured Noise Level (dB) (MNL)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `phase` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Phase (TPH)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `phase` SET TAGS ('dbx_pii_value_regex' = 'prototype|pre_production|production');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance Flag (RCF)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `report_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Report URL (TRURL)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `result` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Result (TR)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `result` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|conditional');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `result_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Result Recording Timestamp (RRT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Revision Number (TRN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `standard_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Standard Reference (TSR)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Status (TS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_status` SET TAGS ('dbx_pii_value_regex' = 'planned|in_progress|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `target_emission_co2` SET TAGS ('dbx_pii_business_glossary_term' = 'Target CO2 Emission (g/km) (TCO2)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `target_noise_db` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Noise Level (dB) (TNL)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `target_torque_nm` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Torque (Nm) (TTQ)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Execution Timestamp (TET)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `torque_nm` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured Torque (Nm) (MTQ)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Validation Test Type (VTT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `validation_test_type` SET TAGS ('dbx_pii_value_regex' = 'DVP|PVP|PPAP|Durability|Emissions|NCAP');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `variance_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Result Variance Percentage (RV%) (VVAR)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ALTER COLUMN `version` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Version (TV)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_test_result` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_test_result` SET TAGS ('dbx_pii_subdomain' = 'validation_testing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_test_result` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_test_result` ALTER COLUMN `engineering_test_result_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for engineering_test_result');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_test_result` ALTER COLUMN `validation_test_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Validation Test Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `digital_twin_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Twin Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Twin Identifier (DT_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Identifier (PART_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `prototype_build_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Prototype Identifier (PROTO_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `digital_prototype_prototype_build_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Prototype Identifier (PROTO_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `engineering_team_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Team Identifier (ENG_TEAM_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `primary_digital_part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Identifier (PART_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Program Identifier (ENG_PRG_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `asset_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `digital_twin_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Twin Code (DTC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `data_quality_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Quality Score (DQ_SCORE)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `fidelity_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Fidelity Level (FID_LVL)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `fidelity_level` SET TAGS ('dbx_pii_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `last_sync_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Synchronization Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `model_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Description (MODEL_DESC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `model_file_path` SET TAGS ('dbx_pii_business_glossary_term' = 'Model File Path (MODEL_PATH)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `model_storage_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Storage Location (MODEL_LOC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `digital_twin_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Twin Name (DTN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `performance_metric` SET TAGS ('dbx_pii_business_glossary_term' = 'Performance Metric Score (PERF_METRIC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance Status (REG_COMP_STS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `simulation_model_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Simulation Model Version (SMV)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `simulation_tool` SET TAGS ('dbx_pii_business_glossary_term' = 'Simulation Tool (SIM_TOOL)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `simulation_tool` SET TAGS ('dbx_pii_value_regex' = 'ANSYS|Siemens|Altair|Dassault');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `digital_twin_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Twin Lifecycle Status (DTLS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `digital_twin_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|retired|archived');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `sync_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Synchronization Status (SYNC_STS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `sync_status` SET TAGS ('dbx_pii_value_regex' = 'in_sync|out_of_sync|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `digital_twin_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Twin Type (DTT)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `digital_twin_type` SET TAGS ('dbx_pii_value_regex' = 'vehicle|powertrain|chassis|body|component');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated By User (UPDATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `validation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Validation Status (VAL_STS)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `validation_status` SET TAGS ('dbx_pii_value_regex' = 'validated|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created By User (CREATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` SET TAGS ('dbx_pii_subdomain' = 'program_management');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `milestone_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Milestone ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Owner Employee Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Owner ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `primary_milestone_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Owner ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `primary_milestone_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `primary_milestone_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `tertiary_milestone_sign_off_authority_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sign‑off Authority ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `tertiary_milestone_sign_off_authority_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `tertiary_milestone_sign_off_authority_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Program ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `actual_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `change_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Reason');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `milestone_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `milestone_code` SET TAGS ('dbx_pii_value_regex' = 'P0|P1|P2|P3|SOP');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `milestone_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `gate_review_outcome` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Review Outcome');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `gate_review_outcome` SET TAGS ('dbx_pii_value_regex' = 'approved|conditional|deferred|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Milestone Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `milestone_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `open_action_items_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Open Action Items Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `planned_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `plant_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Location');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Risk Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `milestone_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `milestone_status` SET TAGS ('dbx_pii_value_regex' = 'planned|in_progress|completed|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `milestone_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `milestone_type` SET TAGS ('dbx_pii_value_regex' = 'gate|review|release|prototype|pilot');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` SET TAGS ('dbx_pii_subdomain' = 'risk_analysis');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `fmea_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'FMEA Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Identifier (Part_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `fmea_part_part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Identifier (Part_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Action Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `primary_fmea_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Action Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `primary_fmea_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `primary_fmea_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Completion Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `analysis_team` SET TAGS ('dbx_pii_business_glossary_term' = 'Analysis Team');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `current_controls` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Controls Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `detection_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Detection Rating (D)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `document_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Document URL');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `failure_effect` SET TAGS ('dbx_pii_business_glossary_term' = 'Failure Effect Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `failure_mode` SET TAGS ('dbx_pii_business_glossary_term' = 'Failure Mode Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `fmea_number` SET TAGS ('dbx_pii_business_glossary_term' = 'FMEA Number (FMEA_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `fmea_type` SET TAGS ('dbx_pii_business_glossary_term' = 'FMEA Type (Design or Process)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `fmea_type` SET TAGS ('dbx_pii_value_regex' = 'DFMEA|PFMEA');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `occurrence_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Occurrence Rating (O)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `process_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Identifier (Process_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `recommended_action` SET TAGS ('dbx_pii_business_glossary_term' = 'Recommended Action');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `risk_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Category');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `risk_category` SET TAGS ('dbx_pii_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `rpn` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Priority Number (RPN)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `severity_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Severity Rating (S)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `fmea_record_status` SET TAGS ('dbx_pii_business_glossary_term' = 'FMEA Record Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `fmea_record_status` SET TAGS ('dbx_pii_value_regex' = 'open|in_progress|closed|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `target_completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Completion Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ALTER COLUMN `version` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` SET TAGS ('dbx_pii_subdomain' = 'validation_testing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Verification Plan ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `change_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change Order ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_part_part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Specification ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_related_specification_design_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Specification ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_updated_by_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_updated_by_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_updated_by_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `primary_dvp_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `primary_dvp_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `primary_dvp_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `tertiary_dvp_updated_by_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `tertiary_dvp_updated_by_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `tertiary_dvp_updated_by_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Completion Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'draft|pending|approved|rejected|withdrawn');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_plan_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Verification Plan Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `completed_test_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Completed Test Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `completion_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Completion Percentage');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `cost_estimate_usd` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Estimate (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_plan_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Verification Plan Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `document_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Document URL');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `is_automated` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Automated');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `is_locked` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Locked');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `last_status_change_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Status Change Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `planned_completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Completion Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Plan Priority');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `regulatory_approval_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Required');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_value_regex' = 'not_required|pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_plan_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Plan Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_plan_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|archived|cancelled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `system_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle System ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `test_environment` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Environment');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `test_environment` SET TAGS ('dbx_pii_value_regex' = 'lab|test_track|simulation|field');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `test_phase` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Phase');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `test_phase` SET TAGS ('dbx_pii_value_regex' = 'development|prototype|pre-production|production|post-production');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `test_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `test_type` SET TAGS ('dbx_pii_value_regex' = 'functional|performance|durability|safety|regulatory|environmental');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `title` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Verification Plan Title');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `total_test_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Test Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_plan_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Verification Plan Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `dvp_plan_type` SET TAGS ('dbx_pii_value_regex' = 'system|component|subsystem|vehicle|process');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `vehicle_variant` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Variant');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` SET TAGS ('dbx_pii_subdomain' = 'risk_analysis');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `homologation_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Requirement ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated Vehicle Program ID (Vehicle_Program_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `homologation_requirement_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Requirement Code (HRC)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `compliance_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Method (Method)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `compliance_method` SET TAGS ('dbx_pii_value_regex' = 'test|calculation|declaration');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status (Status)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'pending|in_progress|compliant|non_compliant|exempt');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (Created_Timestamp)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `homologation_requirement_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Requirement Description (Desc)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date (Effective_Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date (Expiration_Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Mandatory Flag (Mandatory_Flag)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date (Last_Review_Date)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `linked_validation_test_ids` SET TAGS ('dbx_pii_business_glossary_term' = 'Linked Validation Test IDs (Test_IDs)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `market_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Region Code (Region)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes (Notes)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Priority Level (Priority)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `regulation_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Name (Regulation)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `regulation_name` SET TAGS ('dbx_pii_value_regex' = 'FMVSS|ECE_R|CARB|Euro_NCAP|WLTP|EPA');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `regulation_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Number (Regulation_ID)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `submission_deadline` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Deadline (Deadline)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp (Updated_Timestamp)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `vehicle_model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ALTER COLUMN `vehicle_variant` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Variant Identifier (Variant)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Ecu Specification Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `applicable_model_years` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Model Years');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `applicable_vehicle_variants` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Vehicle Variants');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `asw_release_date` SET TAGS ('dbx_pii_business_glossary_term' = 'ASW Release Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `asw_release_number` SET TAGS ('dbx_pii_business_glossary_term' = 'ASW Release Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `calibration_dataset_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Dataset Reference');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `communication_protocol` SET TAGS ('dbx_pii_business_glossary_term' = 'Communication Protocol');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `communication_protocol` SET TAGS ('dbx_pii_value_regex' = 'CAN|LIN|Ethernet|FlexRay|MOST|CANFD');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_value_regex' = 'ISO_26262|IATF_16949|ISO_9001');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_specification_description` SET TAGS ('dbx_pii_business_glossary_term' = 'ECU Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `diagnostic_trouble_code_support` SET TAGS ('dbx_pii_business_glossary_term' = 'Diagnostic Trouble Code Support');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `dimensions_mm` SET TAGS ('dbx_pii_business_glossary_term' = 'ECU Dimensions (mm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_family` SET TAGS ('dbx_pii_business_glossary_term' = 'ECU Family');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_type` SET TAGS ('dbx_pii_business_glossary_term' = 'ECU Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_type` SET TAGS ('dbx_pii_value_regex' = 'engine_control|transmission|adas|body_control|battery_management|infotainment');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `eol_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End‑of‑Life Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `functional_safety_asil` SET TAGS ('dbx_pii_business_glossary_term' = 'Functional Safety ASIL Rating');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `functional_safety_asil` SET TAGS ('dbx_pii_value_regex' = 'ASIL_A|ASIL_B|ASIL_C|ASIL_D');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `hardware_part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Hardware Part Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `hardware_revision` SET TAGS ('dbx_pii_business_glossary_term' = 'Hardware Revision');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `hardware_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Hardware Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical ECU Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `max_operating_temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Operating Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `memory_size_mb` SET TAGS ('dbx_pii_business_glossary_term' = 'Memory Size (MB)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `min_operating_temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Minimum Operating Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_specification_name` SET TAGS ('dbx_pii_business_glossary_term' = 'ECU Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `power_consumption_w` SET TAGS ('dbx_pii_business_glossary_term' = 'Power Consumption (W)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `processing_speed_mhz` SET TAGS ('dbx_pii_business_glossary_term' = 'Processing Speed (MHz)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_value_regex' = 'approved|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `release_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `release_status` SET TAGS ('dbx_pii_value_regex' = 'draft|released|archived|obsolete');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `software_release_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Release Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `software_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_specification_status` SET TAGS ('dbx_pii_business_glossary_term' = 'ECU Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `ecu_specification_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|deprecated|retired|development|released');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `supported_features` SET TAGS ('dbx_pii_business_glossary_term' = 'Supported Features');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `vehicle_platform` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Platform');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `voltage_range_v` SET TAGS ('dbx_pii_business_glossary_term' = 'Voltage Range (V)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ALTER COLUMN `weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'ECU Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_spec_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Specification ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `architecture_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Engine Architecture Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `aspiration_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Aspiration Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `aspiration_type` SET TAGS ('dbx_pii_value_regex' = 'naturally_aspirated|turbocharged|supercharged');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery Capacity (kWh)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_spec_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Specification Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `cost_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Currency (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `cost_estimate_usd` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Estimate (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `cylinder_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Cylinder Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `dimensions_mm` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Dimensions (mm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `displacement_cc` SET TAGS ('dbx_pii_business_glossary_term' = 'Engine Displacement (cubic centimeters)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `emission_control_technology` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Control Technology');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Emissions Standard Compliance');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_pii_value_regex' = 'Euro6|EPA_Tier3|CARB_LEVIII|WLTP');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `end_of_production_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `epa_range_miles` SET TAGS ('dbx_pii_business_glossary_term' = 'EPA Range (miles)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_value_regex' = 'gasoline|diesel|electric|hydrogen|hybrid');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `is_locked` SET TAGS ('dbx_pii_business_glossary_term' = 'Specification Lock Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_spec_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Specification Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Specification Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `power_output_kw` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Power Output (kW)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type (ICE|HEV|PHEV|BEV|FCEV)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `start_of_production_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_spec_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Specification Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `powertrain_spec_status` SET TAGS ('dbx_pii_value_regex' = 'draft|active|retired|obsolete');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `target_program_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Vehicle Program Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `thermal_management` SET TAGS ('dbx_pii_business_glossary_term' = 'Thermal Management Approach');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `thermal_management` SET TAGS ('dbx_pii_value_regex' = 'air|liquid|phase_change|heat_pump');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `torque_nm` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Torque (Nm)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `transmission_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `transmission_type` SET TAGS ('dbx_pii_value_regex' = 'manual|automatic|dual_clutch|CVT|e-gear');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `vehicle_variant` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Variant');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Specification Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ALTER COLUMN `wltp_range_km` SET TAGS ('dbx_pii_business_glossary_term' = 'WLTP Range (km)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` SET TAGS ('dbx_pii_subdomain' = 'program_management');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `weight_report_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight Report ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `primary_weight_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `primary_weight_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `primary_weight_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `actual_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Measured Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `component_scope` SET TAGS ('dbx_pii_business_glossary_term' = 'Component Scope');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `estimated_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `is_locked` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Locked');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `weight_report_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Report Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Report Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `reduction_action` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight Reduction Action');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected|not_required');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `reporting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `weight_report_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Report Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `weight_report_status` SET TAGS ('dbx_pii_value_regex' = 'draft|in_review|approved|rejected|archived');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `system_scope` SET TAGS ('dbx_pii_business_glossary_term' = 'System Scope');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `target_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `weight_delta_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight Delta (kg)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `weight_delta_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight Delta Percentage');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `weight_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight Source');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ALTER COLUMN `weight_target_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight Target Category');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` SET TAGS ('dbx_pii_subdomain' = 'change_control');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `design_review_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Review ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Chair Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `attendees_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Attendees Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `chair_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Chair Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `design_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Review Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `findings_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Findings Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `identifier` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Review Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `location` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Location');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `minutes_document_ref` SET TAGS ('dbx_pii_business_glossary_term' = 'Minutes Document Reference');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `open_actions_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Open Actions Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `outcome` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Outcome');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `outcome` SET TAGS ('dbx_pii_value_regex' = 'approved|conditional|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Risk Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `design_review_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `design_review_status` SET TAGS ('dbx_pii_value_regex' = 'scheduled|in_progress|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `system_or_component` SET TAGS ('dbx_pii_business_glossary_term' = 'Reviewed System or Component');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `total_action_items` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Action Items');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `design_review_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Review Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `design_review_type` SET TAGS ('dbx_pii_value_regex' = 'PDR|CDR|System|Supplier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `material_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Specification ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `material_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `applicable_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Standard');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `application_restriction` SET TAGS ('dbx_pii_business_glossary_term' = 'Application Restriction');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `approved_supplier` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved Supplier(s)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `compliance_reach` SET TAGS ('dbx_pii_business_glossary_term' = 'REACH Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `compliance_reach` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `compliance_rohs` SET TAGS ('dbx_pii_business_glossary_term' = 'RoHS Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `compliance_rohs` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `cost_per_kg_usd` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost per Kilogram (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `density_kg_per_m3` SET TAGS ('dbx_pii_business_glossary_term' = 'Density (kg/m³)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `elongation_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Elongation Percentage');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `environmental_impact_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Environmental Impact Score');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `grade_or_alloy` SET TAGS ('dbx_pii_business_glossary_term' = 'Grade or Alloy Designation');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Material Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'in_design|approved|in_use|retired|archived');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `material_class` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Class');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `material_class` SET TAGS ('dbx_pii_value_regex' = 'steel|aluminum|polymer|composite|glass');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `material_specification_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Specification Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `safety_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `safety_rating` SET TAGS ('dbx_pii_value_regex' = 'A|B|C|D|E');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `specific_heat_j_per_kgk` SET TAGS ('dbx_pii_business_glossary_term' = 'Specific Heat Capacity (J/kg·K)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `material_specification_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Specification Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `material_specification_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|deprecated|pending');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `surface_treatment` SET TAGS ('dbx_pii_business_glossary_term' = 'Surface Treatment');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `surface_treatment` SET TAGS ('dbx_pii_value_regex' = 'none|coating|plating|anodizing|galvanizing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `tensile_strength_mpa` SET TAGS ('dbx_pii_business_glossary_term' = 'Tensile Strength (MPa)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `thermal_conductivity_w_per_mk` SET TAGS ('dbx_pii_business_glossary_term' = 'Thermal Conductivity (W/m·K)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `material_specification_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Specification Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `material_specification_type` SET TAGS ('dbx_pii_value_regex' = 'structural|electrical|thermal|decorative');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Period (Months)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `yield_strength_mpa` SET TAGS ('dbx_pii_business_glossary_term' = 'Yield Strength (MPa)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material_specification` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `configuration_rule_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Configuration Rule Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'approved|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `change_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Reason');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `configuration_rule_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Configuration Rule Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `configuration_rule_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Rule Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_pii_business_glossary_term' = 'Mandatory Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `market` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Applicability');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `configuration_rule_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Configuration Rule Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `option_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Option Category');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `option_code_a` SET TAGS ('dbx_pii_business_glossary_term' = 'Option Code A');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `option_code_b` SET TAGS ('dbx_pii_business_glossary_term' = 'Option Code B');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Rule Priority');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `program_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `source` SET TAGS ('dbx_pii_business_glossary_term' = 'Rule Source');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `source` SET TAGS ('dbx_pii_value_regex' = 'commercial|engineering|regulatory');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `configuration_rule_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Rule Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `configuration_rule_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|retired|draft');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `configuration_rule_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Configuration Rule Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `configuration_rule_type` SET TAGS ('dbx_pii_value_regex' = 'include|exclude|requires|incompatible');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `vehicle_platform` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Platform');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` SET TAGS ('dbx_pii_subdomain' = 'change_control');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `ota_release_id` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Release Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `engineering_team_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Team Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `ota_compliance_approval_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Ota Compliance Approval Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `ecu_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Target ECU Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `target_ecu_ecu_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Target ECU Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `validation_test_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Validation Test Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `build_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Build Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `compatible_vin_range` SET TAGS ('dbx_pii_business_glossary_term' = 'Compatible VIN Range');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `cybersecurity_assessment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Cybersecurity Assessment Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `cybersecurity_assessment_status` SET TAGS ('dbx_pii_value_regex' = 'passed|failed|not_tested');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `cybersecurity_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Cybersecurity Score');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `distribution_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Distribution Method');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `distribution_method` SET TAGS ('dbx_pii_value_regex' = 'ota|dealer|service_center');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `estimated_download_size_mb` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Download Size (MB)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `estimated_install_time_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Install Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `hash` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Hash');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Critical');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Mandatory');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `rollback_supported` SET TAGS ('dbx_pii_business_glossary_term' = 'Rollback Supported');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `rollback_window_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Rollback Window (Days)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `rollout_strategy` SET TAGS ('dbx_pii_business_glossary_term' = 'Rollout Strategy');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `signature` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Signature');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `signature` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `software_delta_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Delta Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `source` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Source');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `source` SET TAGS ('dbx_pii_value_regex' = 'internal|supplier|partner');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `ota_release_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `ota_release_status` SET TAGS ('dbx_pii_value_regex' = 'draft|pending|approved|deployed|retracted');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `target_market` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Market');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `target_model_year_end` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Model Year End');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `target_model_year_start` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Model Year Start');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `target_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Region');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `target_vehicle_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Vehicle Model');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `test_result_summary` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Result Summary');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `ota_release_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `ota_release_type` SET TAGS ('dbx_pii_value_regex' = 'feature|security|calibration|regulatory');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `validation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Validation Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `validation_status` SET TAGS ('dbx_pii_value_regex' = 'passed|failed|not_tested');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ALTER COLUMN `version` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Version');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_document` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_document` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_document` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_document` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_adas_feature` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_adas_feature` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_adas_feature` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_adas_feature` ALTER COLUMN `engineering_adas_feature_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for engineering_adas_feature');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_adas_feature` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` SET TAGS ('dbx_pii_subdomain' = 'program_management');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_target_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Target ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program ID');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected|under_review');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_target_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Target Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `component_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Component Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_basis` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Basis');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_basis` SET TAGS ('dbx_pii_value_regex' = 'baseline|benchmark|historical|target');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_gap_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Gap Percentage');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_gap_total` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Gap Total (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_manufacturing` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Cost Manufacturing (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_material` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Cost Material (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_methodology` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Methodology');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_methodology` SET TAGS ('dbx_pii_value_regex' = 'DTC|Value Engineering|Target Costing|Other');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_reduction_ideas_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Reduction Ideas Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_total` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Cost Total (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Currency');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `current_estimated_cost_manufacturing` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Estimated Cost Manufacturing (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `current_estimated_cost_material` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Estimated Cost Material (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `current_estimated_cost_total` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Estimated Cost Total (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `freeze_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Freeze Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `is_locked` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Locked');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_target_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Target Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_target_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_target_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|archived|draft');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `system_or_component` SET TAGS ('dbx_pii_business_glossary_term' = 'System or Component');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_target_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Target Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `cost_target_type` SET TAGS ('dbx_pii_value_regex' = 'design|manufacturing|total|material|labor');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` SET TAGS ('dbx_pii_association_edges' = 'engineering.part_master,manufacturing.production_bom');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` ALTER COLUMN `engineering_bom_component_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Bom Component - Bom Component Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Bom Component - Part Master Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` ALTER COLUMN `production_bom_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Bom Component - Production Bom Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` ALTER COLUMN `installation_sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Installation Sequence');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` ALTER COLUMN `quantity_per_vehicle` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity per Vehicle');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` ALTER COLUMN `engineering_bom_component_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Component Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` SET TAGS ('dbx_pii_association_edges' = 'engineering.part_master,dealer.dealership');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ALTER COLUMN `dealer_part_inventory_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Part Inventory - Dealer Part Inventory Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Part Inventory - Dealership Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Part Inventory - Part Master Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ALTER COLUMN `dealer_cost_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Part Inventory - Dealer Cost Price');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Part Inventory - Lead Time Days');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ALTER COLUMN `list_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Part Inventory - List Price');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ALTER COLUMN `quantity_on_hand` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Part Inventory - Quantity On Hand');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ALTER COLUMN `reorder_point` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Part Inventory - Reorder Point');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ALTER COLUMN `reorder_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Part Inventory - Reorder Quantity');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ALTER COLUMN `retail_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Part Inventory - Retail Price');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Part Inventory - Unit Of Measure');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` SET TAGS ('dbx_pii_subdomain' = 'program_management');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `engineering_team_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Team Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manager Employee Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `parent_engineering_team_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Engineering Team Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `parent_engineering_team_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Employee Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `engineering_team_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_business_glossary_term' = 'Contact Email');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_business_glossary_term' = 'Contact Phone');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `data_classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Classification');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `engineering_team_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `digital_twin_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Twin Enabled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `domain` SET TAGS ('dbx_pii_business_glossary_term' = 'Domain');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `engineering_toolset` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Toolset');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `is_virtual` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Virtual');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `last_reviewed_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Reviewed By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `engineering_team_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Team Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `location` SET TAGS ('dbx_pii_business_glossary_term' = 'Location');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `engineering_team_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `number_of_members` SET TAGS ('dbx_pii_business_glossary_term' = 'Number Of Members');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `primary_skill` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Skill');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `safety_certification_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Certification Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `engineering_team_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `engineering_team_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Team Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `material_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `parent_material_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Material Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `parent_material_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `application` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Application');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `boiling_point_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Boiling Point C');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `certification` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `material_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `color` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Color');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `corrosion_resistance` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrosion Resistance');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `cost_per_kg_usd` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Per Kg Usd');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `customs_tariff_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Customs Tariff Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `density_kg_per_m3` SET TAGS ('dbx_pii_business_glossary_term' = 'Density Kg Per M3');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `electrical_resistivity_ohm_m` SET TAGS ('dbx_pii_business_glossary_term' = 'Electrical Resistivity Ohm M');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `elongation_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Elongation Percent');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `environmental_impact_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Environmental Impact Score');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `family` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Family');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `grade` SET TAGS ('dbx_pii_business_glossary_term' = 'Grade');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `group` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Group');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `hardness_hb` SET TAGS ('dbx_pii_business_glossary_term' = 'Hardness Hb');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `hazardous` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `hazardous_class` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Class');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `melting_point_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Melting Point C');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `msds_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Msds Url');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `material_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `origin_country` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Origin Country');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_pii_business_glossary_term' = 'Reach Compliant');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `recyclable` SET TAGS ('dbx_pii_business_glossary_term' = 'Recyclable');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `recycle_rate_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Recycle Rate Percent');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_pii_business_glossary_term' = 'Rohs Compliant');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `source` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Source');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `specification` SET TAGS ('dbx_pii_business_glossary_term' = 'Specification');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `material_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `surface_finish` SET TAGS ('dbx_pii_business_glossary_term' = 'Surface Finish');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `tensile_strength_mpa` SET TAGS ('dbx_pii_business_glossary_term' = 'Tensile Strength Mpa');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `thermal_conductivity_w_per_mk` SET TAGS ('dbx_pii_business_glossary_term' = 'Thermal Conductivity W Per Mk');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `material_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit Of Measure');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ALTER COLUMN `yield_strength_mpa` SET TAGS ('dbx_pii_business_glossary_term' = 'Yield Strength Mpa');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` SET TAGS ('dbx_pii_subdomain' = 'change_control');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `engineering_change_action_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Action Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Assigned Engineer Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Assigned Engineer Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `actual_effort_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Effort (Hours)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `attachment_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Attachment Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `closure_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Closure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `engineering_change_action_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Action Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Completion Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Requirement Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `cost_estimate` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Estimate (USD)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `engineering_change_action_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Action Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Due Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `estimated_effort_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Effort (Hours)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Flag');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Action Priority');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `resolution_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Resolution Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `source_event` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Event');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `source_event` SET TAGS ('dbx_pii_value_regex' = 'test_failure|fmea_finding|gate_review|audit|customer_feedback|regulatory_issue');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `engineering_change_action_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Action Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `engineering_change_action_status` SET TAGS ('dbx_pii_value_regex' = 'open|in_progress|completed|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `target_milestone` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Milestone');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Action Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `title` SET TAGS ('dbx_pii_business_glossary_term' = 'Action Title');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `engineering_change_action_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Action Type (Design Change, Test Rerun, etc.)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `engineering_change_action_type` SET TAGS ('dbx_pii_value_regex' = 'design_change|test_rerun|analysis|supplier_engagement|process_improvement|documentation_update');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` SET TAGS ('dbx_pii_subdomain' = 'program_management');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `engineering_project_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Project Identifier');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sponsor Employee Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Employee Id');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `actual_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Cost');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `change_order_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Order Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `engineering_project_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `compliance_regulation` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Regulation');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `data_classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Classification');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `department` SET TAGS ('dbx_pii_business_glossary_term' = 'Department');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `engineering_project_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `digital_twin_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Twin Enabled');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `engineering_phase` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Phase');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `expected_mtbf_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Expected Mtbf Hours');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `external_partner` SET TAGS ('dbx_pii_business_glossary_term' = 'External Partner');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `is_archived` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Archived');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `is_global` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Global');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `milestone_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Count');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `milestone_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `engineering_project_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `planned_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned End Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `plant_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Location');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Priority');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `review_outcome` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Outcome');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start Date');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `engineering_project_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `sustainability_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Sustainability Score');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `engineering_project_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Type');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `vehicle_platform` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Platform');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cfd_simulation_result` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cfd_simulation_result` SET TAGS ('dbx_pii_subdomain' = 'validation_testing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cfd_simulation_result` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fea_simulation_result` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fea_simulation_result` SET TAGS ('dbx_pii_subdomain' = 'validation_testing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fea_simulation_result` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`nvh_test_result` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`nvh_test_result` SET TAGS ('dbx_pii_subdomain' = 'validation_testing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`nvh_test_result` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`test_bench_run` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`test_bench_run` SET TAGS ('dbx_pii_subdomain' = 'validation_testing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`test_bench_run` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`sensor_dataset` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`sensor_dataset` SET TAGS ('dbx_pii_subdomain' = 'validation_testing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`sensor_dataset` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`driving_scenario_library` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`driving_scenario_library` SET TAGS ('dbx_pii_subdomain' = 'validation_testing');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`driving_scenario_library` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`requirements_traceability` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`requirements_traceability` SET TAGS ('dbx_pii_subdomain' = 'risk_analysis');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`requirements_traceability` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`packaging_specification` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`packaging_specification` SET TAGS ('dbx_pii_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`packaging_specification` SET TAGS ('dbx_pii_domain' = 'engineering');
ALTER TABLE `vibe_automotive_v1`.`engineering`.`packaging_specification` SET TAGS ('dbx_pii_governance_verified' = 'true');
