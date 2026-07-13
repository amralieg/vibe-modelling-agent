-- Schema for Domain: manufacturing | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:53

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`manufacturing` COMMENT 'Core production and assembly operations across all manufacturing plants. Manages shop floor execution via MES (Manufacturing Execution System), work order scheduling, production line sequencing (JIS - Just-in-Sequence), WIP (Work in Progress) tracking, and build traceability. Includes stamping, body shop, paint, and final assembly processes. Integrates with AGV (Automated Guided Vehicle), PLC (Programmable Logic Controller), and SCADA systems for real-time production control.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`plant` (
    `plant_id` BIGINT COMMENT 'Unique surrogate identifier for each manufacturing plant or assembly facility. Primary key for the plant master record, referenced across MES, SAP PP, and logistics domains.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Plant regulatory reporting requires knowing the jurisdiction (country/region) governing emissions and safety permits.',
    `address_line1` STRING COMMENT 'Primary street address of the plant facility. Used for logistics, regulatory filings, and official correspondence. Classified as confidential organizational contact data.',
    `address_line2` STRING COMMENT 'Secondary address line for the plant facility (e.g., building number, gate, or suite). Supplements address_line1 for complete facility location identification.',
    `agv_enabled` BOOLEAN COMMENT 'Indicates whether the plant is equipped with Automated Guided Vehicle (AGV) systems for material transport on the shop floor. Used for automation capability classification and MES integration configuration.',
    `annual_capacity_units` STRING COMMENT 'Maximum number of vehicles or assemblies the plant is designed to produce per year under normal two-shift operations. Used for capacity planning, CapEx justification, and production scheduling in SAP PP.',
    `city` STRING COMMENT 'City or municipality where the plant is physically located. Used for logistics planning, workforce commute analysis, and regulatory jurisdiction determination.',
    `plant_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying the plant within SAP S/4HANA and MES systems (e.g., DETF01, USNA02). Used as the business key across ERP, MES, and logistics integrations. Maps to SAP Organizational Unit - Plant Code.. Valid values are `^[A-Z0-9]{2,10}$`',
    `commissioning_date` DATE COMMENT 'The date on which the plant was officially commissioned and handed over for production operations. Distinct from SOP date; represents the physical readiness milestone. Used for asset lifecycle management and depreciation calculations in SAP AM.',
    `company_code` STRING COMMENT 'SAP S/4HANA company code to which this plant is assigned for financial accounting and controlling purposes. Links plant operations to the FI/CO module for cost center allocation and EBITDA reporting.. Valid values are `^[A-Z0-9]{2,6}$`',
    `cost_center_code` STRING COMMENT 'SAP Controlling (CO) cost center code assigned to the plant for financial cost allocation, CapEx tracking, and R&D expenditure reporting. Used in management accounting and EBITDA analysis.. Valid values are `^[A-Z0-9]{4,10}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code indicating the country where the plant is physically located (e.g., USA, DEU, CHN). Used for regulatory compliance, CAFE reporting, and logistics routing.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the plant master record was first created in the system. Used for data lineage, audit trail, and record lifecycle management in the Databricks Silver Layer.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the local currency used in plant-level financial reporting and cost accounting (e.g., USD, EUR, CNY). Used in SAP FI/CO for cost center reporting and CapEx tracking.. Valid values are `^[A-Z]{3}$`',
    `daily_capacity_units` STRING COMMENT 'Maximum number of vehicles or assemblies the plant can produce per day (Jobs Per Day - JPD). Derived from takt time and shift configuration. Used for daily production scheduling and MES throughput planning.',
    `dummy_flag` BOOLEAN COMMENT 'Placeholder attribute to satisfy target entity touch',
    `eop_date` DATE COMMENT 'The official End of Production (EOP) date when the plant is scheduled to cease production of the current model or permanently close. Used for capacity planning, workforce transition, and asset disposal planning.',
    `epa_facility_code` STRING COMMENT 'EPA-assigned facility identifier for emissions and environmental compliance reporting. Required for CAFE (Corporate Average Fuel Economy) reporting and Clean Air Act compliance.. Valid values are `^[A-Z0-9]{1,20}$`',
    `esg_tracking_enabled_flag` BOOLEAN COMMENT 'ESG/energy tracking linkage marker.',
    `floor_area_sqm` DECIMAL(18,2) COMMENT 'Total manufacturing floor area of the plant in square meters. Used for facility planning, CapEx allocation, insurance valuation, and ISO 14001 environmental footprint reporting.',
    `iatf_16949_certified` BOOLEAN COMMENT 'Indicates whether the plant holds a current IATF 16949 automotive quality management system certification. Mandatory for OEM supplier qualification and customer-specific requirements compliance.',
    `iso_14001_certified` BOOLEAN COMMENT 'Indicates whether the plant holds a current ISO 14001 Environmental Management System certification. Required for EPA compliance reporting and sustainability disclosures.',
    `iso_9001_certified` BOOLEAN COMMENT 'Indicates whether the plant holds a current ISO 9001 Quality Management System certification. Required for supplier qualification and regulatory compliance reporting.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the plant in decimal degrees (WGS 84). Used for geospatial analytics, logistics network optimization, and supply chain mapping.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the plant in decimal degrees (WGS 84). Used for geospatial analytics, logistics network optimization, and supply chain mapping.',
    `manager` STRING COMMENT 'Full name of the plant manager or general manager responsible for overall plant operations. Used for escalation routing, regulatory correspondence, and organizational reporting. Not classified as PII as this is a business role reference.',
    `mes_plant_code` STRING COMMENT 'The plant identifier as registered in the Apriso/Dassault MES system. Used for cross-system reconciliation between SAP PP production orders and MES shop floor execution records. Enables traceability from ERP to shop floor.. Valid values are `^[A-Za-z0-9_-]{1,50}$`',
    `model_year_current` STRING COMMENT 'The current Model Year (MY) of vehicles being produced at the plant (e.g., 2025). Used for production scheduling, regulatory compliance submissions, and CAFE reporting alignment.. Valid values are `^[0-9]{4}$`',
    `plant_name` STRING COMMENT 'Official full name of the manufacturing plant or assembly facility (e.g., Detroit Final Assembly Plant No. 1). Used in reporting, regulatory submissions, and communications.',
    `nhtsa_facility_code` STRING COMMENT 'NHTSA-assigned facility identifier for the plant. Required for vehicle recall management, safety defect reporting, and Federal Motor Vehicle Safety Standards (FMVSS) compliance submissions.. Valid values are `^[A-Z0-9]{1,20}$`',
    `number_of_assembly_lines` BOOLEAN COMMENT 'Total count of active production or assembly lines within the plant. Used for capacity planning, MES line configuration, and production scheduling.',
    `number_of_shifts` BOOLEAN COMMENT 'Number of production shifts operated per day at the plant (typically 1, 2, or 3). Drives capacity calculations, workforce planning in SuccessFactors, and MES scheduling.',
    `operational_status` STRING COMMENT 'Current lifecycle state of the plant. active indicates full production; idle indicates temporary suspension; ramp_up indicates pre-SOP commissioning phase; ramp_down indicates post-EOP wind-down; shutdown indicates planned or unplanned stoppage; decommissioned indicates permanently closed.. Valid values are `active|idle|ramp_up|ramp_down|shutdown|decommissioned`',
    `ota_capable` BOOLEAN COMMENT 'Indicates whether the plant has the infrastructure to perform OTA (Over-the-Air) software updates on vehicles during the final assembly or PDI (Pre-Delivery Inspection) process. Relevant for connected vehicle production.',
    `phone_number` STRING COMMENT 'Primary telephone number for the plant facility. Used for operational communications, emergency contact, and supplier/logistics coordination. Classified as confidential organizational contact data.',
    `plant_type` STRING COMMENT 'Categorical classification of the plants primary manufacturing function. Values include stamping (metal forming), body_shop (body-in-white welding), paint (paint application), final_assembly (vehicle assembly), ckd (Completely Knocked Down assembly), skd (Semi Knocked Down assembly), powertrain (engine/transmission), logistics (parts distribution). [ENUM-REF-CANDIDATE: stamping|body_shop|paint|final_assembly|ckd|skd|powertrain|logistics — promote to reference product]',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the plant location. Used for logistics routing, tax jurisdiction assignment, and regulatory reporting.',
    `powertrain_types_produced` STRING COMMENT 'Classification of powertrain technologies assembled or manufactured at this plant. ICE (Internal Combustion Engine), EV (Electric Vehicle), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), FCEV (Fuel Cell Electric Vehicle), or mixed. Used for EPA emissions compliance, CAFE reporting, and R&D investment tracking.. Valid values are `ice|ev|hev|phev|fcev|mixed`',
    `primary_vehicle_segment` STRING COMMENT 'The primary vehicle segment produced at this plant. Values: car (passenger cars), truck (light/heavy trucks), suv (Sport Utility Vehicles), commercial_vehicle (vans/buses/heavy commercial), ev (Battery Electric Vehicle), hev (Hybrid Electric Vehicle - HEV), phev (Plug-in Hybrid Electric Vehicle - PHEV), mixed (multiple segments). Drives model year planning and regulatory compliance requirements. [ENUM-REF-CANDIDATE: car|truck|suv|commercial_vehicle|ev|hev|phev|mixed — 8 candidates stripped; promote to reference product]',
    `region` STRING COMMENT 'Geographic or operational region in which the plant is located (e.g., North America, Europe, Asia Pacific). Used for regional production planning, capacity allocation, and management reporting.',
    `scada_enabled` BOOLEAN COMMENT 'Indicates whether the plant operates a SCADA (Supervisory Control and Data Acquisition) system for real-time monitoring and control of manufacturing processes, utilities, and equipment.',
    `short_name` STRING COMMENT 'Abbreviated or commonly used name for the plant used in dashboards, shop floor displays, and internal communications (e.g., Detroit FA1).. Valid values are `^[A-Za-z0-9 ]{1,30}$`',
    `sop_date` DATE COMMENT 'The official Start of Production (SOP) date when the plant commenced or is scheduled to commence volume production. Critical milestone for capital planning, workforce ramp-up, and supplier readiness. Aligns with APQP phase-gate milestones.',
    `ssot_governance_note` STRING COMMENT 'SSOT owner for plant entity. Other domains reference this via FK.',
    `state_province` STRING COMMENT 'State, province, or administrative subdivision where the plant is located (e.g., Michigan, Bavaria, Ontario). Used for local regulatory compliance, tax jurisdiction, and workforce reporting.',
    `takt_time_seconds` STRING COMMENT 'The rate at which vehicles must be produced to meet customer demand, expressed in seconds per unit. Calculated as available production time divided by customer demand rate. Fundamental to JIS (Just-in-Sequence) scheduling and line balancing in MES.',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the plant location (e.g., America/Detroit, Europe/Berlin). Used for MES shift scheduling, production timestamp normalization, and cross-plant reporting in the Databricks lakehouse.',
    `union_represented` BOOLEAN COMMENT 'Indicates whether the plant workforce is represented by a labor union. Impacts workforce planning, shift scheduling, overtime policies, and collective bargaining agreement compliance in SuccessFactors.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the plant master record was last modified. Used for change tracking, data synchronization between SAP S/4HANA and the Databricks lakehouse, and audit compliance.',
    `workforce_headcount` STRING COMMENT 'Total number of employees (direct and indirect labor) currently employed at the plant. Used for workforce planning, capacity analysis, and regulatory headcount reporting in SuccessFactors.',
    CONSTRAINT pk_plant PRIMARY KEY(`plant_id`)
) COMMENT 'Master record for each manufacturing plant or assembly facility operated by Automotive. Captures plant identity, location, type (stamping, body shop, paint, final assembly, CKD/SKD), production capacity, SOP/EOP dates, plant code, and operational status. SSOT for plant-level identity referenced across MES, SAP PP, and logistics domains. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` (
    `production_line_id` BIGINT COMMENT 'Unique surrogate identifier for each production line record within the manufacturing data platform. Serves as the primary key for the production_line entity. Role: MASTER_RESOURCE.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Line‑level cost allocation report requires linking each production line to its finance cost center; experts expect a cost_center_id instead of the denormalized code.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the production line manager or area manager responsible for this lines operations, quality, and safety performance. References the SuccessFactors HR system employee record. Used for accountability assignment, escalation routing, and workforce reporting.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where this production line is physically located. Links to the plant master record for capacity planning, OEE reporting, and regulatory compliance reporting by facility.',
    `work_center_id` BIGINT COMMENT 'The SAP S/4HANA PP (Production Planning) work center identifier corresponding to this production line. Enables direct linkage between the lakehouse production_line master and SAP production orders, capacity planning, and cost center assignments in SAP CO (Controlling).',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Line scheduling and line‑to‑program assignment use vehicle_program_id to match line capabilities with program requirements.',
    `agv_integration_enabled` BOOLEAN COMMENT 'Indicates whether this production line is integrated with an AGV (Automated Guided Vehicle) system for automated material delivery, WIP (Work in Progress) transport, or carrier movement. True = AGV-integrated; False = manual or conventional conveyor-based material handling. Used for automation investment tracking and MES configuration.',
    `automation_level` STRING COMMENT 'Classification of the overall automation level of the production line: manual (predominantly human-operated), semi_automated (mix of manual and robotic operations), highly_automated (majority robotic with human oversight), or fully_automated (lights-out or near-lights-out operation). Used for workforce planning, CapEx investment analysis, and Industry 4.0 maturity assessments.. Valid values are `manual|semi_automated|highly_automated|fully_automated`',
    `ckd_skd_capable` STRING COMMENT 'Indicates the assembly kit type this line is configured to process: CKD (Completely Knocked Down — full kit assembly from parts), SKD (Semi Knocked Down — partial pre-assembly), CBU (Completely Built Up — no kit assembly, line-off only), or multi (capable of multiple kit types). Relevant for export assembly plants and regulatory homologation.. Valid values are `CKD|SKD|CBU|multi`',
    `conveyor_type` STRING COMMENT 'Type of conveyor or carrier system used to move vehicles or assemblies along this production line: overhead_conveyor (hanging carrier), floor_conveyor (ground-level chain/belt), skillet (moving platform for final assembly), agv_carrier (autonomous guided vehicle carrier), stationary (fixed-position assembly), or mixed (combination of types).. Valid values are `overhead_conveyor|floor_conveyor|skillet|agv_carrier|stationary|mixed`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this production line master record was first created in the data platform (yyyy-MM-ddTHH:mm:ss.SSSXXX). Provides audit trail for data governance, lineage tracking, and IATF 16949 record retention compliance. Maps to RECORD_AUDIT_CREATED category for MASTER_RESOURCE role.',
    `current_jph` DECIMAL(18,2) COMMENT 'The current actual or most recently measured throughput rate of the production line in Jobs Per Hour (JPH), reflecting real-world performance after accounting for constraints, model mix, and current configuration. Used to compare against designed_jph for capacity gap analysis and production scheduling.',
    `designed_jph` DECIMAL(18,2) COMMENT 'The engineered design throughput capacity of the production line expressed in Jobs Per Hour (JPH) — the number of vehicle units or assemblies the line is designed to produce per hour under optimal conditions. This is the nameplate capacity used for capacity planning, takt time calculation, and OEE baseline. Maps to MEASUREMENT_OR_VALUE category for MASTER_RESOURCE role.',
    `energy_consumption_kwh_per_unit` DECIMAL(18,2) COMMENT 'Average energy consumption of this production line in kilowatt-hours (kWh) per vehicle unit produced. Used for ISO 14001 environmental management reporting, carbon footprint calculation, energy efficiency benchmarking, and EPA/CARB manufacturing emissions compliance.',
    `energy_metering_enabled_flag` BOOLEAN COMMENT 'ESG/energy tracking linkage marker.',
    `eop_date` DATE COMMENT 'The planned or actual End of Production (EOP) date for this production line — the date on which series production of the current vehicle program is scheduled to cease. Used for capacity reallocation planning, tooling disposition, and supply chain wind-down management. Nullable for lines with no defined EOP.',
    `floor_space_sqm` DECIMAL(18,2) COMMENT 'Total floor space occupied by this production line in square meters, including the line footprint, buffer zones, and material staging areas. Used for facility capacity planning, real estate cost allocation, and plant layout optimization.',
    `iatf_audit_status` STRING COMMENT 'Current IATF 16949 (International Automotive Task Force) quality management system audit status for this production line: compliant (no non-conformances), minor_nc (minor non-conformance identified), major_nc (major non-conformance — corrective action required), suspended (production suspended pending corrective action), or not_audited (not yet subject to IATF audit).. Valid values are `compliant|minor_nc|major_nc|suspended|not_audited`',
    `jis_enabled` BOOLEAN COMMENT 'Indicates whether this production line operates under JIS (Just-in-Sequence) material delivery sequencing, where parts are delivered to the line in the exact sequence of vehicle build order. True = JIS-enabled; False = standard JIT or batch delivery. Critical for supply chain integration and sequencing system configuration.',
    `last_iatf_audit_date` DATE COMMENT 'Date of the most recent IATF 16949 quality management system audit conducted on this production line. Used for audit cycle management, corrective action tracking, and regulatory compliance reporting to OEM customers and certification bodies.',
    `last_maintenance_date` DATE COMMENT 'Date of the most recent planned preventive maintenance activity performed on this production line. Used for maintenance scheduling in SAP PM (Plant Maintenance), OEE (Overall Equipment Effectiveness) calculation, and IATF 16949 preventive maintenance compliance.',
    `line_code` STRING COMMENT 'Externally-known alphanumeric code that uniquely identifies the production line within the plant and across the enterprise (e.g., FA-01, BS-03, PT-02). Used as the business key in MES, SAP PP, and Apriso/Dassault shop-floor execution systems. Maps to BUSINESS_IDENTIFIER category for MASTER_RESOURCE role.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `line_length_meters` DECIMAL(18,2) COMMENT 'Physical length of the production line in meters, measured from the first to the last station. Used for facility layout planning, AGV (Automated Guided Vehicle) path configuration, and ergonomic compliance assessments per plant engineering standards.',
    `line_name` STRING COMMENT 'Human-readable descriptive name of the production line (e.g., Final Assembly Line 1 – Truck Platform, Body Shop Framing Line – SUV). Used in reporting dashboards, capacity planning, and operator interfaces. Maps to IDENTITY_LABEL category for MASTER_RESOURCE role.',
    `line_status` STRING COMMENT 'Current operational lifecycle status of the production line: active (running production), idle (scheduled downtime or no orders), maintenance (planned or unplanned maintenance), ramp_up (pre-SOP commissioning), ramp_down (approaching EOP), or decommissioned (permanently retired). Maps to LIFECYCLE_STATUS category for MASTER_RESOURCE role.. Valid values are `active|idle|maintenance|ramp_up|ramp_down|decommissioned`',
    `line_type` STRING COMMENT 'Categorical classification of the production line by manufacturing process area: stamping (metal forming), body_shop (welding/framing), paint (surface treatment), final_assembly (vehicle build), powertrain (engine/transmission), chassis (underbody), or trim (interior/exterior finishing). Maps to CLASSIFICATION_OR_TYPE category for MASTER_RESOURCE role. [ENUM-REF-CANDIDATE: stamping|body_shop|paint|final_assembly|powertrain|chassis|trim|subassembly|battery_pack|quality_gate — promote to reference product]',
    `max_vehicle_weight_kg` DECIMAL(18,2) COMMENT 'Maximum gross vehicle weight in kilograms that this production lines conveyor, tooling, and fixtures are rated to handle. Constrains which vehicle programs can be assigned to this line and is critical for structural safety compliance and tooling certification.',
    `mes_line_code` STRING COMMENT 'The line identifier as registered in the Apriso/Dassault MES (Manufacturing Execution System) for shop floor execution, work order dispatch, and build traceability. Used for cross-system reconciliation between the lakehouse silver layer and the operational MES source system.',
    `mixed_model_capable` BOOLEAN COMMENT 'Indicates whether this production line is capable of producing multiple vehicle models or variants in a mixed sequence on the same line (mixed-model assembly). True = mixed-model capable; False = dedicated single-model line. Drives production scheduling complexity and sequencing logic in MES.',
    `model_year_capability` STRING COMMENT 'The model year (MY) or range of model years that this production line is currently tooled and certified to produce (e.g., 2024 or 2024-2026). Drives SOP (Start of Production) and EOP (End of Production) planning, tooling investment decisions, and homologation scheduling.. Valid values are `^[0-9]{4}(-[0-9]{4})?$`',
    `next_maintenance_date` DATE COMMENT 'Date of the next planned preventive maintenance activity scheduled for this production line. Drives maintenance work order creation in SAP PM, production scheduling adjustments, and downtime planning to minimize impact on JPH targets.',
    `number_of_stations` STRING COMMENT 'Total count of individual work stations or assembly stations on this production line. Used for line balancing analysis, ergonomic assessments, and determining the number of operators required per shift. Key input for APQP (Advanced Product Quality Planning) and control plan development.',
    `paint_booth_type` STRING COMMENT 'Type of paint application system used on this line (applicable to paint shop lines): waterborne (water-based paint — lower VOC emissions), solventborne (solvent-based paint), powder_coat (electrostatic powder coating), or none (non-paint line). Drives EPA/CARB VOC (Volatile Organic Compound) emissions compliance reporting and environmental permit management.. Valid values are `waterborne|solventborne|powder_coat|none`',
    `plc_system_reference` STRING COMMENT 'Identifier or name of the PLC (Programmable Logic Controller) system or network controlling this production lines automated equipment (e.g., Siemens S7-1500 Network A, Allen-Bradley ControlLogix Zone 3). Used for maintenance management in SAP PM, SCADA integration, and cybersecurity asset inventory.',
    `powertrain_type_capability` STRING COMMENT 'The powertrain technology types this production line is capable of assembling: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle), or multi (flexible line supporting multiple powertrain types). Critical for EV transition capacity planning and regulatory compliance with EPA/CARB emissions standards.. Valid values are `ICE|HEV|PHEV|BEV|FCEV|multi`',
    `quality_gate_count` STRING COMMENT 'Number of quality inspection gates or checkpoints integrated into this production line (e.g., in-process inspection stations, end-of-line audit points). Used for quality planning per APQP (Advanced Product Quality Planning), control plan documentation, and IATF 16949 compliance audits.',
    `robot_count` STRING COMMENT 'Total number of industrial robots (welding, painting, assembly, material handling) deployed on this production line. Used for maintenance planning in SAP PM, automation investment tracking, and Industry 4.0 KPI reporting.',
    `safety_certification_expiry_date` DATE COMMENT 'Expiry date of the production lines current safety certification. Used to trigger renewal workflows, prevent operation of uncertified lines, and support regulatory audit readiness for OSHA, DOT, and IATF 16949 compliance.',
    `safety_certification_status` STRING COMMENT 'Current status of the production lines safety certification and compliance with applicable occupational safety standards (e.g., OSHA, CE Machinery Directive, ISO 13849): certified (valid and current), expired (certification lapsed), pending_renewal (renewal in progress), or not_required (exempt from certification requirement).. Valid values are `certified|expired|pending_renewal|not_required`',
    `scada_system_reference` STRING COMMENT 'Identifier or name of the SCADA (Supervisory Control and Data Acquisition) system monitoring and controlling this production line (e.g., Ignition SCADA Plant2-Zone1, Wonderware InTouch Line FA-01). Used for real-time production monitoring, alarm management, and integration with MES and ERP systems.',
    `shift_configuration` STRING COMMENT 'Current shift schedule configuration for the production line, indicating the number of operating shifts per day: 1_shift (single day shift), 2_shift (day and afternoon), 3_shift (continuous 24-hour), or 4_shift_rotating (rotating continental schedule). Drives capacity planning, workforce scheduling in SuccessFactors, and MRP calculations in SAP PP.. Valid values are `1_shift|2_shift|3_shift|4_shift_rotating`',
    `sop_date` DATE COMMENT 'The official Start of Production (SOP) date for this production line — the date on which the line commenced or is scheduled to commence series production of the current vehicle program. Used for program milestone tracking, APQP phase gate management, and regulatory homologation scheduling.',
    `takt_time_seconds` DECIMAL(18,2) COMMENT 'The calculated takt time for this production line in seconds — the maximum allowable time to produce one unit to meet customer demand. Derived from available production time divided by customer demand rate. Stored as a master configuration value for scheduling and line balancing in JIS (Just-in-Sequence) operations.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this production line master record in the data platform (yyyy-MM-ddTHH:mm:ss.SSSXXX). Used for change tracking, data freshness monitoring, and incremental ETL processing in the Databricks Lakehouse silver layer.',
    `vehicle_platform_code` STRING COMMENT 'The vehicle platform or architecture code that this production line is primarily configured to build (e.g., F-150 Gen14, GMT800, MEB). A single line may support multiple model variants on the same platform. Used for PLM integration with Siemens Teamcenter and production scheduling.',
    `weld_gun_count` STRING COMMENT 'Total number of resistance spot weld guns (robotic and manual) deployed on this production line. Applicable primarily to body shop lines. Used for weld quality management per IATF 16949, preventive maintenance scheduling in SAP PM, and SPC (Statistical Process Control) monitoring of weld quality.',
    CONSTRAINT pk_production_line PRIMARY KEY(`production_line_id`)
) COMMENT 'Master record for each production line within a plant, including stamping lines, body shop lines, paint booths, and final assembly lines. Tracks line code, line type, designed throughput (JPH - Jobs Per Hour), current shift configuration, AGV integration flags, PLC/SCADA system references, and operational status. Owned by manufacturing as the SSOT for line-level capacity and configuration. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` (
    `work_center_id` BIGINT COMMENT 'Unique surrogate identifier for the work center (station) record within the manufacturing data platform. Primary key for the work_center master entity.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Work‑center cost tracking for OEE and labor cost reporting uses a finance cost center; replacing cost_center_code with cost_center_id is standard practice.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Required for Work Center Maintenance Planning reports linking each work center to its functional location in the plant hierarchy.',
    `employee_id` BIGINT COMMENT 'Identifier of the production supervisor or team leader responsible for this work center. Used for accountability tracking, escalation routing, and workforce management integration with SuccessFactors.',
    `work_responsible_supervisor_employee_id` BIGINT COMMENT 'Identifier of the production supervisor or team leader responsible for this work center. Used for accountability tracking, escalation routing, and workforce management integration with SuccessFactors.',
    `agv_integration_enabled` BOOLEAN COMMENT 'Indicates whether this work center is integrated with AGV (Automated Guided Vehicle) systems for automated material delivery and WIP transport. Drives AGV routing configuration in the MES.',
    `automation_level` STRING COMMENT 'Degree of automation at this work center: fully_automated (no human intervention), highly_automated (minimal human oversight), semi_automated (human-assisted), manual (entirely human-operated), or collaborative (human-robot collaboration). Informs CapEx planning and Industry 4.0 transformation roadmap.. Valid values are `fully_automated|highly_automated|semi_automated|manual|collaborative`',
    `available_capacity_hours_per_day` DECIMAL(18,2) COMMENT 'Total available production hours per day for this work center, accounting for planned shift schedules and scheduled breaks. Used in SAP PP capacity requirements planning (CRP) and MES scheduling.',
    `capacity_category` STRING COMMENT 'Capacity classification of the work center: bottleneck (constraining throughput of the line), standard (normal capacity), buffer (excess capacity used to absorb variation), or flexible (can be redeployed across lines). Critical for Theory of Constraints analysis and production scheduling.. Valid values are `bottleneck|standard|buffer|flexible`',
    `work_center_category` STRING COMMENT 'SAP PP work center category classifying the primary resource type: machine (machine-driven capacity), labor (labor-driven capacity), machine_labor (both machine and labor capacity), or external (subcontracted operation). Determines how capacity and costing are calculated in SAP.. Valid values are `machine|labor|machine_labor|external`',
    `work_center_code` STRING COMMENT 'Externally-known alphanumeric code that uniquely identifies the work center across MES, SAP PP, and SCADA systems. Used as the business key in cross-system integration (e.g., Apriso/Dassault MES work center identifier).. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `commissioning_date` DATE COMMENT 'Date on which this work center was officially commissioned and made available for production use. Used for asset age tracking, depreciation calculation, and maintenance lifecycle management.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this work center master record was first created in the data platform. Used for data lineage, audit trail, and record lifecycle management.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the cost rates (machine_rate_per_hour, labor_rate_per_hour) associated with this work center (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `cycle_time_seconds` DECIMAL(18,2) COMMENT 'Standard cycle time in seconds for this work center to complete one unit of work. Used in production scheduling, capacity calculation, and bottleneck analysis. Represents the designed throughput rate per station.',
    `decommissioning_date` DATE COMMENT 'Date on which this work center was or is planned to be permanently decommissioned and removed from production service. Nullable for active stations. Used for asset lifecycle planning and capacity forecasting.',
    `work_center_description` STRING COMMENT 'Detailed textual description of the work centers function, scope of operations, and any special capabilities or constraints relevant to production planning and scheduling.',
    `energy_consumption_kw` DECIMAL(18,2) COMMENT 'Rated energy consumption of this work center in kilowatts (kW) under standard operating conditions. Used for energy management, sustainability reporting, and ISO 14001 environmental compliance tracking.',
    `floor_area_sqm` DECIMAL(18,2) COMMENT 'Physical floor area occupied by this work center in square meters. Used for facility layout planning, ergonomic assessments, and plant capacity management.',
    `is_bottleneck` BOOLEAN COMMENT 'Indicates whether this work center has been identified as a production bottleneck constraining overall line throughput. Bottleneck stations receive priority in capacity planning, maintenance scheduling, and continuous improvement initiatives.',
    `is_jis_enabled` BOOLEAN COMMENT 'Indicates whether this work center participates in JIS (Just-in-Sequence) production sequencing. When true, the MES enforces strict vehicle sequence delivery to this station to support mixed-model assembly.',
    `is_quality_gate` BOOLEAN COMMENT 'Indicates whether this work center serves as a quality gate (inspection checkpoint) in the production flow. Quality gate stations require SPC (Statistical Process Control) data capture and may hold WIP pending quality approval.',
    `labor_rate_per_hour` DECIMAL(18,2) COMMENT 'Standard direct labor cost rate per hour (in local currency) for this work center. Used in production order costing, standard cost roll-up, and labor efficiency variance reporting.',
    `last_calibration_date` DATE COMMENT 'Date of the most recent calibration or measurement system verification performed on this work centers tooling and gauges. Required for IATF 16949 Clause 7.1.5 measurement system compliance.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this work center master record. Used for change tracking, data freshness monitoring, and incremental ETL processing in the Databricks lakehouse.',
    `location_description` STRING COMMENT 'Textual description of the physical location of the work center within the plant (e.g., Building A, Bay 3, Row 5). Supports maintenance routing, safety inspections, and shop floor navigation.',
    `machine_rate_per_hour` DECIMAL(18,2) COMMENT 'Standard machine cost rate per hour (in local currency) for this work center, used in production order costing, standard cost calculation, and variance analysis in SAP CO.',
    `maintenance_strategy_code` STRING COMMENT 'Maintenance strategy applied to this work center: preventive (scheduled interval-based), predictive (condition-monitoring-based), corrective (repair after failure), or condition_based (triggered by sensor thresholds). Drives SAP PM maintenance planning.. Valid values are `preventive|predictive|corrective|condition_based`',
    `mean_time_between_failures_hours` DECIMAL(18,2) COMMENT 'Standard mean time between failures (MTBF) in hours for this work center, representing the expected average operational time between unplanned breakdowns. Used in reliability analysis, maintenance planning, and OEE (Overall Equipment Effectiveness) benchmarking.',
    `mean_time_to_repair_hours` DECIMAL(18,2) COMMENT 'Standard mean time to repair (MTTR) in hours for this work center, representing the average time required to restore the station to operational status after a failure. Used in maintenance planning and availability calculations.',
    `mes_work_center_code` STRING COMMENT 'Native work center identifier in the Apriso/Dassault MES system. Used for cross-system traceability between the lakehouse silver layer and the operational MES for shop floor execution and WIP (Work in Progress) tracking.',
    `work_center_name` STRING COMMENT 'Human-readable name of the work center station (e.g., Body Framing Station 04, Final Torque Assembly Line 2). Used in shop floor displays, MES dashboards, and production reporting.',
    `next_calibration_due_date` DATE COMMENT 'Scheduled date for the next calibration or measurement system verification at this work center. Triggers maintenance work orders in SAP PM and quality alerts in the MES when approaching or overdue.',
    `number_of_shifts` STRING COMMENT 'Number of production shifts per day this work center operates (typically 1, 2, or 3). Used in daily capacity calculation and workforce planning.',
    `number_of_workers` STRING COMMENT 'Standard number of direct labor workers assigned to this work center per shift. Used for workforce planning, labor cost allocation, and ergonomic assessment.',
    `overhead_rate_percent` DECIMAL(18,2) COMMENT 'Manufacturing overhead absorption rate as a percentage applied to this work centers direct costs for product costing and standard cost calculation in SAP CO.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility where this work center is physically located. Aligns with SAP S/4HANA organizational structure for production planning.. Valid values are `^[A-Z0-9]{2,10}$`',
    `plc_node_code` STRING COMMENT 'Identifier of the PLC (Programmable Logic Controller) node associated with this work center in the shop floor control network. Used for real-time production control integration and SCADA data correlation.',
    `process_category` STRING COMMENT 'Manufacturing process category to which this work center belongs, reflecting the major shop segment (e.g., stamping, body shop, paint, final assembly, powertrain). Used for shop floor segmentation, capacity analysis, and APQP (Advanced Product Quality Planning) alignment. [ENUM-REF-CANDIDATE: stamping|body_shop|paint|final_assembly|powertrain|chassis|trim|quality_inspection|logistics — promote to reference product]',
    `production_line_code` STRING COMMENT 'Code identifying the production line (e.g., stamping, body shop, paint, final assembly) to which this work center belongs. Supports JIS (Just-in-Sequence) scheduling and MES line-level reporting.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `sap_work_center_code` STRING COMMENT 'Native work center identifier in SAP S/4HANA PP module. Used for cross-system reconciliation between the lakehouse and SAP for production order routing, capacity planning, and cost center allocation.',
    `scada_node_code` STRING COMMENT 'Identifier of the SCADA (Supervisory Control and Data Acquisition) node associated with this work center. Enables real-time monitoring, alarm management, and production data acquisition from the shop floor.',
    `setup_time_minutes` DECIMAL(18,2) COMMENT 'Standard setup/changeover time in minutes required to prepare this work center for a new production run or model variant. Used in SAP PP capacity planning and MES work order scheduling.',
    `shift_model_code` STRING COMMENT 'Code referencing the shift schedule model assigned to this work center (e.g., 1-shift, 2-shift, 3-shift, weekend shift). Determines available production windows for capacity planning and MES scheduling.. Valid values are `^[A-Z0-9_-]{1,10}$`',
    `standard_value_key` STRING COMMENT 'SAP PP standard value key (e.g., SAP1, SAP2) defining which standard values (setup, machine, labor, teardown times) are relevant for this work center in routing operations. Governs how production order times are calculated.. Valid values are `^[A-Z0-9]{1,6}$`',
    `takt_time_seconds` DECIMAL(18,2) COMMENT 'Takt time in seconds representing the rate at which vehicles must be produced to meet customer demand. Calculated as available production time divided by customer demand rate. Used for JIS (Just-in-Sequence) line balancing and MES pacing.',
    `teardown_time_minutes` DECIMAL(18,2) COMMENT 'Standard teardown/cleanup time in minutes required after completing a production run at this work center. Included in total station time calculations for capacity planning.',
    `work_center_status` STRING COMMENT 'Current lifecycle status of the work center: active (in production use), inactive (temporarily not in use), under_maintenance (scheduled or unscheduled maintenance), decommissioned (permanently retired), or planned (not yet commissioned). Drives MES scheduling eligibility and capacity planning.. Valid values are `active|inactive|under_maintenance|decommissioned|planned`',
    `work_center_type` STRING COMMENT 'Classification of the work center by its operational mode: manual (human-operated), automated (machine-driven without robotics), robotic (robot arm/AGV-integrated), semi_automated (human-assisted automation), inspection (quality gate), or rework (defect correction station). Drives capacity planning and labor allocation.. Valid values are `manual|automated|robotic|semi_automated|inspection|rework`',
    CONSTRAINT pk_work_center PRIMARY KEY(`work_center_id`)
) COMMENT 'Master record for individual work centers (stations) within a production line. Captures work center code, name, type (manual, automated, robotic), cycle time standard, takt time, capacity category, shift availability, and associated PLC/SCADA node identifiers. Supports JIS sequencing and MES shop floor execution at the station level. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` (
    `production_order_id` BIGINT COMMENT 'Primary key for production_order',
    `configuration_id` BIGINT COMMENT 'Reference to the vehicle configuration or variant being built under this production order. Links to the vehicle configuration master (model, trim, powertrain, options) managed in Siemens Teamcenter PLM or SAP Variant Configuration.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Order cost tracking and variance analysis require linking each production order to its finance cost center, replacing the denormalized code.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: REQUIRED: Order creation audit requires tracking planner employee; essential for traceability and compliance.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Order‑to‑customer linkage required for order fulfillment, warranty, and recall reports; manufacturers need to know which party placed each production order.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Production order cost posting uses a specific GL account; the order‑to‑GL link is required for the Production Order Cost Ledger report.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: Production Order release process checks Homologation_Record to ensure model/year has regulatory approval before manufacturing starts.',
    `opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Supports Opportunity‑to‑Production conversion analysis; ties each production order back to the sales opportunity that generated it.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where this production order is executed. Corresponds to the SAP Plant (WERKS) organizational unit. Links to the plant master data product.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Enables Production Order Supplier Impact Analysis, identifying the primary supplier for critical components.',
    `production_bom_id` BIGINT COMMENT 'Reference to the Bill of Materials (BOM) version used for this production order. The BOM defines all components and sub-assemblies required to build the target material. Managed in SAP PP and Siemens Teamcenter PLM.',
    `production_line_id` BIGINT COMMENT 'Reference to the specific production line (e.g., stamping, body shop, paint, final assembly) assigned to execute this order. Maps to SAP Work Center (ARBPL) or MES line definition.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Order‑level profitability analysis (Order Profitability Statement) needs a profit_center FK to allocate revenue and cost.',
    `quote_id` BIGINT COMMENT 'Foreign key linking to sales.quote. Business justification: Provides Quote‑to‑Production traceability for financial and compliance reporting; links the quote that was accepted to the resulting production order.',
    `routing_id` BIGINT COMMENT 'Reference to the production routing (task list / operation sequence) assigned to this order. The routing defines the sequence of manufacturing operations, work centers, and standard times. Maps to SAP PP Routing (PLNNR).',
    `shift_id` BIGINT COMMENT 'Reference to the production shift (e.g., Day, Afternoon, Night) assigned to execute this order. Used for capacity planning, labor allocation, and shift-level production reporting.',
    `sku_master_id` BIGINT COMMENT 'Reference to the SAP Material Master (MATNR) representing the finished vehicle, sub-assembly, or component being produced. The primary product/material being manufactured under this order.',
    `supply_purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.supply_purchase_order. Business justification: Production scheduling aligns each production order with its originating purchase order to ensure material availability and OTD compliance.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Each production order is created for a specific vehicle program; order tracking dashboards filter by vehicle_program_id.',
    `actual_cost` DECIMAL(18,2) COMMENT 'The total actual cost incurred to execute this production order, including material consumption, labor, machine, and overhead costs as settled in SAP CO. Expressed in the plants local currency. Used for cost variance analysis, profitability reporting, and CapEx/OpEx tracking.',
    `actual_finish_timestamp` TIMESTAMP COMMENT 'The precise date and time when all production activities for this order were completed and the final goods receipt was posted, as recorded by MES or SAP PP. Used for cycle time calculation, OTD (On-Time Delivery) measurement, and throughput analysis.',
    `actual_labor_hours` DECIMAL(18,2) COMMENT 'The total actual direct labor hours consumed during execution of this production order, as confirmed through SAP PP operation confirmations or MES time tracking. Used for labor efficiency analysis, variance reporting, and cost actuals in SAP CO.',
    `actual_machine_hours` DECIMAL(18,2) COMMENT 'The total actual machine/equipment hours consumed during execution of this production order, as recorded by SCADA (Supervisory Control and Data Acquisition) systems or MES. Used for OEE analysis, machine utilization reporting, and cost variance calculation.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'The precise date and time when production activities for this order actually commenced on the shop floor, as recorded by the MES or confirmed by the first operation confirmation in SAP PP. Used for cycle time analysis and schedule adherence measurement.',
    `assembly_sequence_number` STRING COMMENT 'The Just-in-Sequence (JIS) sequence number assigned to this production order, defining its position in the assembly line build sequence. Critical for JIS supply chain synchronization — ensures parts arrive at the line in the exact order vehicles are built. Managed by MES and communicated to tier-1 suppliers.',
    `confirmed_quantity` DECIMAL(18,2) COMMENT 'The quantity of vehicles or sub-assemblies that have been confirmed as successfully produced and goods-receipted against this order. Maps to SAP PP confirmed yield quantity (WEMNG). Used for production performance and yield tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this production order record was first created in the source system (SAP PP). Used for audit trail, data lineage, and record lifecycle management. Maps to SAP order creation timestamp (ERDAT + ERZET).',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the standard_cost and actual_cost amounts on this production order (e.g., USD, EUR, JPY, MXN). Determined by the plants controlling area currency in SAP CO.. Valid values are `^[A-Z]{3}$`',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether this production order involves the use or production of hazardous materials (e.g., battery electrolytes for EV/HEV powertrains, paint solvents, chemical treatments). True = hazardous materials involved, requiring compliance with EPA, CARB, and ISO 14001 environmental management protocols.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this production order record was most recently modified in the source system. Used for change tracking, delta load processing in the lakehouse pipeline, and audit compliance under IATF 16949.',
    `mes_order_reference` STRING COMMENT 'Cross-reference identifier assigned by the Apriso/Dassault MES system for this production order. Used to correlate SAP PP orders with shop floor execution records in the MES for traceability and real-time production control.',
    `model_year` STRING COMMENT 'The vehicle model year (MY) associated with the units being produced under this order. Critical for regulatory compliance (CAFE, EPA, NCAP), warranty tracking, and production program management. Typically a 4-digit year (e.g., 2025).. Valid values are `^[0-9]{4}$`',
    `order_date` DATE COMMENT 'The business date on which the production order was created and issued in SAP PP. This is the principal business event date representing when the manufacturing work order was formally raised. Maps to SAP order creation date (ERDAT).',
    `order_description` STRING COMMENT 'Free-text description of the production order providing additional context about the manufacturing scope, special instructions, or engineering change notes. Used by shop floor supervisors and production planners for operational clarity.',
    `order_number` STRING COMMENT 'Externally-known alphanumeric identifier for the production order as assigned by SAP PP (Production Planning) or Apriso MES. This is the business-facing reference used on the shop floor, in MES screens, and in cross-system communication. Maps to SAP PP order number (AUFNR).. Valid values are `^[A-Z0-9-]{6,20}$`',
    `order_status` STRING COMMENT 'Current lifecycle state of the production order within the SAP PP and MES workflow. created = order created but not yet released to shop floor; released = released for execution; in_progress = active manufacturing underway; partially_confirmed = some operations confirmed; confirmed = all operations confirmed; technically_completed = TECO status in SAP — production complete, pending settlement; closed = fully settled and archived; cancelled = order voided. [ENUM-REF-CANDIDATE: created|released|in_progress|partially_confirmed|confirmed|technically_completed|closed|cancelled — promote to reference product]',
    `order_type` STRING COMMENT 'Classification of the production order indicating its manufacturing purpose. vehicle_build represents a full vehicle assembly order; sub_assembly covers component or module builds (e.g., powertrain, axle); rework covers defect correction orders; repair covers warranty or field return repairs; prototype covers R&D and pre-SOP (Start of Production) builds. Maps to SAP PP order type (AUART).. Valid values are `vehicle_build|sub_assembly|rework|repair|prototype`',
    `planned_finish_date` DATE COMMENT 'The scheduled date on which all production activities for this order are planned to be completed. Used for delivery commitment, JIT (Just-in-Time) scheduling, and OTD (On-Time Delivery) performance tracking. Maps to SAP PP planned finish date (GLTRS).',
    `planned_labor_hours` DECIMAL(18,2) COMMENT 'The total planned direct labor hours required to execute this production order, derived from the routing standard times and target quantity. Used for capacity planning, workforce scheduling via SuccessFactors, and standard cost calculation in SAP CO.',
    `planned_machine_hours` DECIMAL(18,2) COMMENT 'The total planned machine/equipment hours required to execute this production order, derived from routing standard machine times. Used for equipment capacity planning, OEE (Overall Equipment Effectiveness) baseline, and standard cost calculation.',
    `planned_start_date` DATE COMMENT 'The scheduled date on which production activities for this order are planned to begin, as determined by MRP (Material Requirements Planning) or production scheduling. Maps to SAP PP planned start date (GSTRS).',
    `ppap_required` BOOLEAN COMMENT 'Indicates whether PPAP (Production Part Approval Process) approval is required before this production order can be released for full-volume production. Typically True for new part introductions, engineering changes, or supplier changes. Governed by IATF 16949 and AIAG PPAP standards.',
    `priority` STRING COMMENT 'Numeric priority level assigned to this production order for shop floor scheduling and sequencing. Lower values indicate higher priority. Used by MES and JIS (Just-in-Sequence) systems to determine execution order when multiple orders compete for the same resources.',
    `production_stage` STRING COMMENT 'The manufacturing stage or shop area where this production order is executed. Reflects the physical production process: stamping = metal forming; body_shop = body-in-white welding; paint = surface coating; final_assembly = vehicle assembly; powertrain = engine/transmission build; trim_chassis = trim, chassis, and final fit.. Valid values are `stamping|body_shop|paint|final_assembly|powertrain|trim_chassis`',
    `quality_inspection_lot` STRING COMMENT 'The SAP QM (Quality Management) inspection lot number created for quality inspection activities associated with this production order. Links production execution to quality results, usage decisions, and non-conformance records. Maps to SAP QM inspection lot (QMNUM).',
    `release_timestamp` TIMESTAMP COMMENT 'The date and time when the production order was formally released to the shop floor for execution. Release triggers material staging, capacity reservation, and MES order activation. Maps to SAP PP order release date/time.',
    `rework_quantity` DECIMAL(18,2) COMMENT 'The quantity of units that required rework (non-conforming units corrected and returned to production flow) during execution of this order. Distinct from scrap — reworked units are salvaged. Used for quality cost analysis and APQP (Advanced Product Quality Planning) reporting.',
    `scrap_quantity` DECIMAL(18,2) COMMENT 'The quantity of units scrapped or rejected during production of this order due to quality defects or process failures. Used for PPM (Parts Per Million) defect rate calculation, scrap cost analysis, and FMEA (Failure Mode and Effects Analysis) reporting.',
    `sop_indicator` BOOLEAN COMMENT 'Indicates whether this production order is part of the SOP (Start of Production) launch phase for a new vehicle program. True = SOP launch order subject to enhanced quality monitoring and APQP controls; False = regular series production order.',
    `standard_cost` DECIMAL(18,2) COMMENT 'The planned standard cost to produce the target quantity under this order, calculated from the BOM (Bill of Materials) component costs and routing activity rates in SAP CO (Controlling). Expressed in the plants local currency. Used for cost variance analysis and EBITDA reporting.',
    `target_quantity` DECIMAL(18,2) COMMENT 'The planned quantity of vehicles or sub-assemblies to be produced under this order, expressed in the base unit of measure (typically EA for each). Maps to SAP PP planned order quantity (GAMNG). Used for capacity planning and production scheduling.',
    `technical_completion_timestamp` TIMESTAMP COMMENT 'The date and time when the production order was set to Technically Completed (TECO) status in SAP PP, indicating all manufacturing operations are finished and the order is pending cost settlement. Distinct from actual_finish_timestamp which records the last physical operation.',
    `unit_of_measure` STRING COMMENT 'The base unit of measure for the target and confirmed quantities on this production order (e.g., EA = Each for vehicles, PC = Piece for components, SET for kits, KG for bulk materials). Maps to SAP base unit of measure (MEINS).. Valid values are `EA|PC|SET|KG|L`',
    `vin_range_end` STRING COMMENT 'The last VIN (Vehicle Identification Number) in the sequential range assigned to units produced under this order. Together with vin_range_start, defines the complete set of vehicles traceable to this production order for recall, warranty, and homologation purposes.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `vin_range_start` STRING COMMENT 'The first VIN (Vehicle Identification Number) in the sequential range assigned to units produced under this order. VINs are 17-character alphanumeric identifiers conforming to ISO 3779. Used for build traceability, recall management, and regulatory reporting to NHTSA.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `wip_posting_flag` BOOLEAN COMMENT 'Indicates whether WIP (Work in Progress) costs have been calculated and posted to the financial ledger for this production order in the current period. True = WIP posted; False = WIP not yet posted. Used for period-end financial closing in SAP CO.',
    CONSTRAINT pk_production_order PRIMARY KEY(`production_order_id`)
) COMMENT 'Core transactional record representing a manufacturing work order issued to produce a specific vehicle or sub-assembly. Captures order number, order type (vehicle build, sub-assembly, rework), planned and actual start/finish dates, target quantity, produced quantity, order status, priority, shift assignment, and MES order reference. Links to plant, production line, and vehicle configuration. SSOT for shop floor execution tracking in SAP PP and Apriso MES. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` (
    `build_sequence_id` BIGINT COMMENT 'Unique surrogate identifier for the Just-in-Sequence (JIS) build sequence record in the Databricks Silver Layer. Primary key generated by the Apriso/Dassault MES sequencing module upon sequence creation.',
    `configuration_id` BIGINT COMMENT 'Reference to the vehicle configuration record defining the model, trim, powertrain, and option codes for the vehicle to be assembled at this sequence position.',
    `build_vehicle_config_configuration_id` BIGINT COMMENT 'Reference to the vehicle configuration record defining the model, trim, powertrain, and option codes for the vehicle to be assembled at this sequence position.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where this build sequence is executed. Links to the plant master record in the enterprise data model.',
    `production_line_id` BIGINT COMMENT 'Reference to the specific assembly or production line to which this build sequence is assigned. Drives AGV routing and JIS supplier call-off logic.',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: Rename work_order_id to production_order_id to follow FK naming convention and link each build sequence to its parent production order.',
    `shift_id` BIGINT COMMENT 'Reference to the production shift during which this build sequence is scheduled to execute. Determines labor allocation and JIS call-off windows.',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time at which assembly of the vehicle at this sequence position was completed on the production line, as recorded by the MES. Null until assembly is complete.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time at which assembly of the vehicle at this sequence position commenced on the production line, as recorded by the MES. Null until assembly begins.',
    `assembly_stage` STRING COMMENT 'Current or target assembly stage for this sequence position: stamping = metal forming; body_shop = body-in-white welding; paint = paint application; final_assembly = trim and chassis assembly; PDI = Pre-Delivery Inspection. Drives shop floor routing in the MES.. Valid values are `stamping|body_shop|paint|final_assembly|PDI`',
    `body_style_code` STRING COMMENT 'Code identifying the body style of the vehicle (e.g., sedan, SUV, truck, coupe, van). Influences stamping and body shop routing within the production sequence.',
    `build_type` STRING COMMENT 'Classification of the vehicle build purpose: retail = customer-ordered retail unit; fleet = fleet customer order; stock = dealer stock build; pilot = pre-production pilot build; homologation = regulatory homologation unit; press = media/press fleet unit.. Valid values are `retail|fleet|stock|pilot|homologation|press`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time at which this build sequence record was first created in the MES sequencing module and ingested into the Databricks Silver Layer. Supports audit trail and data lineage.',
    `customer_order_number` STRING COMMENT 'Sales order number from SAP SD or Salesforce Automotive Cloud associated with this build sequence position, if the vehicle is built to a specific customer or dealer order. Null for stock builds.',
    `dealer_code` STRING COMMENT 'Unique identifier of the dealer for whom this vehicle is being built, if applicable. Sourced from the dealer master in CDK Global DMS or Salesforce Automotive Cloud. Null for unallocated stock builds.',
    `destination_market_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code indicating the intended destination market for the vehicle. Determines homologation variant, regulatory compliance requirements (NHTSA, UNECE, CARB), and market-specific option content.. Valid values are `^[A-Z]{3}$`',
    `drive_configuration` STRING COMMENT 'Drivetrain configuration of the vehicle: FWD (Front-Wheel Drive), RWD (Rear-Wheel Drive), AWD (All-Wheel Drive), or 4WD (Four-Wheel Drive). Determines axle and driveshaft JIS call-off and assembly routing.. Valid values are `FWD|RWD|AWD|4WD`',
    `exterior_color_code` STRING COMMENT 'Paint color code for the vehicle exterior as specified in the build sequence. Drives paint shop scheduling, batch sequencing for color changeover optimization, and JIS paint material call-off.',
    `freeze_timestamp` TIMESTAMP COMMENT 'Date and time at which the build sequence was frozen and locked for JIS supplier call-off. After this timestamp, sequence changes are restricted and require formal change control. Critical for JIS supplier synchronization.',
    `interior_color_code` STRING COMMENT 'Interior trim and upholstery color code for the vehicle. Used for JIS seat and interior component call-off to tier-1 suppliers.',
    `is_frozen` BOOLEAN COMMENT 'Indicates whether the build sequence record has been frozen for JIS supplier call-off. When True, sequence changes are restricted and require formal change control approval. Directly linked to freeze_timestamp.',
    `is_priority_build` BOOLEAN COMMENT 'Indicates whether this vehicle has been flagged as a priority build (e.g., executive order, critical dealer allocation, regulatory compliance unit). Priority builds may override standard JIS sequencing rules.',
    `jis_call_off_timestamp` TIMESTAMP COMMENT 'Date and time at which the JIS supplier call-off message was transmitted for this sequence position. Triggers sequenced part delivery from tier-1 JIS suppliers. Critical for supply chain synchronization and OTD measurement.',
    `mes_sequence_reference` STRING COMMENT 'Native sequence record identifier from the Apriso/Dassault MES sequencing module. Serves as the source system key for lineage and reconciliation between the Silver Layer and the operational MES.',
    `model_year` STRING COMMENT 'Four-digit model year (MY) of the vehicle to be assembled at this sequence position. Determines applicable BOM revision, regulatory homologation requirements, and CAFE/EPA compliance targets.. Valid values are `^[0-9]{4}$`',
    `option_package_code` STRING COMMENT 'Code representing the bundled option package (e.g., technology package, towing package, safety package) selected for the vehicle. Determines additional BOM components and JIS call-off requirements.',
    `planned_build_date` DATE COMMENT 'Calendar date on which the vehicle at this sequence position is planned to be assembled. Used for JIS supplier call-off scheduling and production planning in SAP PP.',
    `planned_end_timestamp` TIMESTAMP COMMENT 'Precise date and time at which assembly of the vehicle at this sequence position is planned to complete. Used for takt time validation and shift throughput planning.',
    `planned_start_timestamp` TIMESTAMP COMMENT 'Precise date and time at which assembly of the vehicle at this sequence position is planned to begin on the production line. Drives JIS call-off timing and AGV dispatch scheduling.',
    `powertrain_type` STRING COMMENT 'Classification of the vehicle powertrain to be assembled: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), or FCEV (Fuel Cell Electric Vehicle). Drives line routing, tooling selection, and regulatory compliance checks.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `quality_hold_flag` BOOLEAN COMMENT 'Indicates whether this build sequence position has been placed on a quality hold, preventing progression to the next assembly stage. Triggered by MES quality gate failures or FMEA-driven stop conditions.',
    `regulatory_variant_code` STRING COMMENT 'Code identifying the regulatory homologation variant of the vehicle (e.g., US-NHTSA, EU-UNECE, CARB-ZEV). Ensures correct BOM variant selection for emissions, safety, and market-specific compliance requirements.',
    `sequence_change_reason` STRING COMMENT 'Free-text or coded reason for the most recent modification to this build sequence record (e.g., material shortage, quality hold, customer order change, line disruption). Required for change control audit trail under IATF 16949.',
    `sequence_number` STRING COMMENT 'Ordered position number of this vehicle within the production run for the assigned line and shift. Drives JIS supplier call-off sequencing and AGV routing. Must be unique within a plant, line, shift, and planned build date combination.',
    `sequence_revision_number` STRING COMMENT 'Incremental revision counter tracking how many times this build sequence record has been modified since initial creation. Supports audit trail and change control compliance under IATF 16949.',
    `sequence_set_number` STRING COMMENT 'Externally-known identifier for the production sequence set or run to which this record belongs, as generated by the MES sequencing module. Used for JIS call-off batch identification and supplier communication.',
    `sequence_status` STRING COMMENT 'Current lifecycle state of the build sequence record within the MES workflow. planned = sequence created but not yet released to shop floor; released = released for production; in_progress = vehicle currently being assembled; completed = assembly finished; cancelled = sequence removed from run; on_hold = temporarily suspended pending resolution.. Valid values are `planned|released|in_progress|completed|cancelled|on_hold`',
    `sequence_type` STRING COMMENT 'Classification of the build sequence record indicating whether it is the original planned sequence, a revised sequence after change control, an emergency insertion, or a resequenced position due to line disruption.. Valid values are `initial|revised|emergency|resequenced`',
    `takt_time_seconds` STRING COMMENT 'Planned takt time in seconds allocated for assembly of the vehicle at this sequence position. Derived from the line rate and used for production pacing, WIP tracking, and OTD performance measurement.',
    `transmission_type` STRING COMMENT 'Type of transmission to be installed in the vehicle at this sequence position. Drives drivetrain component JIS call-off and assembly station routing.. Valid values are `automatic|manual|CVT|DCT|single_speed`',
    `trim_level_code` STRING COMMENT 'Code identifying the trim or grade level of the vehicle (e.g., base, mid, premium, sport). Determines option content, BOM variant, and JIS part call-off requirements.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to this build sequence record, as recorded in the MES or Silver Layer. Used for incremental data loading, change detection, and audit compliance.',
    `vehicle_model_code` STRING COMMENT 'Alphanumeric code identifying the vehicle model (e.g., platform or nameplate code) to be assembled at this sequence position. Sourced from Teamcenter PLM product structure.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number (VIN) assigned to the vehicle at this sequence position, conforming to ISO 3779 and NHTSA standards. May be pre-assigned at sequence creation or stamped during body shop operations. Critical for build traceability and regulatory compliance.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_build_sequence PRIMARY KEY(`build_sequence_id`)
) COMMENT 'JIS (Just-in-Sequence) build sequence record defining the ordered sequence of vehicles to be assembled on a production line for a given shift or production run. Captures sequence number, planned build date, shift, line assignment, vehicle configuration reference (model, trim, powertrain, color), sequence status, and freeze timestamp. Critical for JIS supplier call-offs and AGV routing. Sourced from Apriso MES sequencing module. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` (
    `vehicle_build_id` BIGINT COMMENT 'Primary key for vehicle_build',
    `build_stage_id` BIGINT COMMENT 'Foreign key linking to manufacturing.build_stage. Business justification: Vehicle build references its current build stage; replace string column with FK to build_stage for normalization.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Required for OTA update management: associate each built vehicle with its connected vehicle record for remote diagnostics, firmware deployment, and compliance reporting.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: Each built vehicle must be tied to its Homologation_Record for VIN‑level compliance verification and reporting.',
    `operator_team_id` BIGINT COMMENT 'Reference to the operator team or crew responsible for executing this vehicle build. Used for workforce productivity and quality traceability.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where this vehicle was assembled. Enables plant-level production reporting and capacity analysis.',
    `production_order_id` BIGINT COMMENT 'Reference to the SAP PP production order that authorized and scheduled this vehicle build. Links the build event to the manufacturing planning hierarchy.',
    `shift_id` BIGINT COMMENT 'Reference to the production shift during which this vehicle build was executed. Supports shift-level throughput and quality analysis.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Enables Build ↔ Delivery scheduling; associates each built vehicle with the sales order it fulfills for handover and logistics planning.',
    `vehicle_ownership_id` BIGINT COMMENT 'Foreign key linking to customer.vehicle_ownership. Business justification: Recall and ownership analytics require tying the build record to the ownership record that stores acquisition date, purchase price, and ownership number.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: VIN Registration Integration needed for warranty, recall, and regulatory reporting linking build record to VIN registry.',
    `assembly_line_code` STRING COMMENT 'Identifier for the specific production/assembly line within the plant on which this vehicle was built (e.g., LINE-A1, TRIM-LINE-3). Used for line-level throughput analysis, bottleneck identification, and SCADA/PLC integration.',
    `battery_serial_number` STRING COMMENT 'The unique serial number of the high-voltage traction battery pack installed in this vehicle (applicable to HEV, PHEV, BEV). Null for ICE vehicles. Critical for EV battery genealogy, warranty, and end-of-life regulatory compliance.',
    `body_shop_end_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the body shop stage was completed and the body-in-white was released to the paint shop. Null if stage not yet completed.',
    `body_shop_start_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the vehicle body-in-white (BIW) entered the body shop for welding and assembly. Key milestone for build genealogy and stage cycle time tracking.',
    `body_style` STRING COMMENT 'The body style classification of the vehicle being built. Used for production line routing, tooling selection, and regulatory homologation grouping.. Valid values are `sedan|suv|truck|van|coupe|convertible`',
    `bom_version` STRING COMMENT 'The specific BOM (Bill of Materials) version or engineering change level used to build this vehicle. Captured at build time for genealogy and recall traceability. Links to Siemens Teamcenter PLM BOM management.',
    `build_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when the vehicle build was completed at the final assembly stage and signed off for PDI (Pre-Delivery Inspection). Null if the build is still in progress. Used for cycle time, throughput, and SOP/EOP milestone tracking.',
    `build_sequence_number` STRING COMMENT 'The Just-in-Sequence (JIS) production sequence number assigned to this vehicle on the assembly line. Determines the order in which vehicles are built and parts are delivered to the line. Critical for JIS/JIT supply chain synchronization.',
    `build_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the vehicle build process commenced at the first production stage (typically body-in-white or stamping entry). Principal business event timestamp for the build lifecycle. Used for cycle time calculation and OTD (On-Time Delivery) analysis.',
    `build_status` STRING COMMENT 'Current lifecycle status of the vehicle build record. Drives shop floor workflow, MES gating, and production reporting. on_hold indicates a quality or material hold; rework indicates a defect requiring corrective action before completion.. Valid values are `in_progress|completed|on_hold|rework|scrapped|cancelled`',
    `build_type` STRING COMMENT 'Classification of the vehicle build type: standard (full local assembly), CKD (Completely Knocked Down – assembled from imported kits), SKD (Semi Knocked Down), pilot (pre-SOP trial build), or prototype (engineering validation). Affects BOM, duty classification, and regulatory reporting.. Valid values are `standard|ckd|skd|pilot|prototype`',
    `chassis_end_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the chassis assembly stage was completed. Null if stage not yet completed.',
    `chassis_start_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the vehicle entered the chassis assembly stage for powertrain marriage, suspension, and drivetrain installation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vehicle build record was first created in the MES/data platform. Represents the audit trail creation event, distinct from the build_start_timestamp which is the actual shop floor event time.',
    `end_of_line_test_result` STRING COMMENT 'Result of the automated end-of-line (EOL) functional test performed on the completed vehicle, covering powertrain, brakes, ADAS, and electrical systems. Distinct from quality_gate_status which covers visual/dimensional inspection.. Valid values are `pass|fail|retest_required`',
    `engine_serial_number` STRING COMMENT 'The unique serial number of the engine unit installed in this vehicle during chassis assembly. Critical for powertrain genealogy, warranty traceability, and recall management.',
    `final_assembly_end_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the final assembly stage was completed and the vehicle was released for PDI (Pre-Delivery Inspection). Null if stage not yet completed.',
    `final_assembly_start_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the vehicle entered the final assembly stage for fluids, wheels, glass, and end-of-line checks.',
    `hold_flag` BOOLEAN COMMENT 'Indicates whether this vehicle build is currently under a production hold (True = on hold). A hold may be triggered by a quality non-conformance, missing parts, engineering change, or safety concern. Drives MES gating to prevent further assembly until resolved.',
    `hold_reason_code` STRING COMMENT 'Coded reason for the production hold applied to this vehicle build (e.g., QUALITY_DEFECT, MISSING_PART, ECN_CHANGE, SAFETY_CONCERN). Null if hold_flag is False. [ENUM-REF-CANDIDATE: QUALITY_DEFECT|MISSING_PART|ECN_CHANGE|SAFETY_CONCERN|SUPPLIER_DEVIATION|TOOLING_FAILURE|OTHER — promote to reference product]',
    `homologation_market` STRING COMMENT 'The target regulatory market for which this vehicle is homologated and built (e.g., USA, DEU, GBR, CHN, AUS). Determines applicable safety, emissions, and labeling standards. Uses ISO 3166-1 alpha-3 country codes.',
    `model_year` STRING COMMENT 'The automotive model year (MY) designation for the vehicle being built (e.g., 2025). Determines applicable regulatory standards, BOM revision, and homologation requirements. Distinct from the calendar year of production.. Valid values are `^[0-9]{4}$`',
    `paint_color_code` STRING COMMENT 'The manufacturers paint color code applied to this vehicle during the paint stage (e.g., G1W – Super White, 040 – Classic White). Used for paint shop scheduling, color sequencing optimization, and customer order matching.',
    `paint_end_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the paint stage was completed and the vehicle body was released to the trim/general assembly line. Null if stage not yet completed.',
    `paint_start_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the vehicle body entered the paint shop for priming, painting, and clear-coat application.',
    `powertrain_type` STRING COMMENT 'Classification of the vehicle powertrain technology being assembled: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), or FCEV (Fuel Cell Electric Vehicle). Drives assembly line routing, tooling, and EPA/CARB emissions compliance tracking.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `quality_gate_status` STRING COMMENT 'Result of the end-of-line quality gate inspection for this vehicle build. conditional_pass indicates the vehicle passed with minor deviations requiring dealer rectification. Drives release-to-shipping authorization.. Valid values are `pass|fail|conditional_pass|pending`',
    `rework_count` STRING COMMENT 'Number of rework operations performed on this vehicle build. A count greater than zero indicates quality issues encountered during assembly. Used for PPM (Parts Per Million) defect rate calculation and FMEA analysis.',
    `rework_flag` BOOLEAN COMMENT 'Indicates whether this vehicle build has been flagged for rework due to a detected defect or non-conformance (True = rework required). Distinct from hold_flag; a vehicle can be in rework while not on hold.',
    `scheduled_build_date` DATE COMMENT 'The planned calendar date on which this vehicle was scheduled to be built per the production plan (MRP/MES schedule). Used to measure schedule adherence and production plan vs. actual variance.',
    `sop_flag` BOOLEAN COMMENT 'Indicates whether this vehicle build is part of the official Start of Production (SOP) launch batch (True = SOP vehicle). SOP vehicles are subject to enhanced quality scrutiny and PPAP sign-off requirements.',
    `stamping_end_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the stamping stage was completed and the body panels were released to the body shop. Null if stage not yet completed.',
    `stamping_start_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the vehicle body panels entered the stamping stage. Used for stage-level cycle time analysis and production flow monitoring.',
    `transmission_serial_number` STRING COMMENT 'The unique serial number of the transmission unit installed in this vehicle. Used for drivetrain genealogy, warranty claims, and component-level recall traceability.',
    `trim_end_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the trim assembly stage was completed. Null if stage not yet completed.',
    `trim_start_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the vehicle entered the trim assembly stage for interior fitting, electrical harness installation, and dashboard assembly.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this vehicle build record. Used for incremental data pipeline processing, audit trails, and detecting stale records in the Silver layer.',
    `vehicle_model_code` STRING COMMENT 'Internal product/model code identifying the vehicle nameplate and variant being built (e.g., F150-XLT-4WD). Maps to the PLM product structure in Siemens Teamcenter. Used for BOM resolution and build sequence planning.',
    `vin` STRING COMMENT 'The globally unique 17-character Vehicle Identification Number (VIN) assigned to this vehicle unit at body-in-white or VIN stamping stage. Conforms to ISO 3779 / NHTSA VIN standard. SSOT for vehicle-level traceability across manufacturing, sales, and after-sales domains.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_vehicle_build PRIMARY KEY(`vehicle_build_id`)
) COMMENT 'Transactional record capturing the actual build event for a single vehicle unit on the shop floor, from body-in-white through final assembly. Tracks VIN assignment, production order reference, actual start and completion timestamps per build stage (stamping, body shop, paint, trim, chassis, final), build status, shift, operator team, and any hold or rework flags. SSOT for vehicle-level build traceability and genealogy in the manufacturing domain. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` (
    `build_stage_id` BIGINT COMMENT 'Unique surrogate identifier for each build stage record in the vehicle manufacturing process. Primary key for the build_stage reference master. [REFERENCE_LOOKUP role — canonical_skip_reason: This entity is a reference master defining standard build stages; per-role minimums for REFERENCE_LOOKUP are exempt, but all meaningful business attributes are still included for completeness.]',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Stage‑level cost capture for capacity planning and cost of quality uses a finance cost center; the FK replaces the string code.',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Build stages are defined per production line; adding production_line_id FK groups stages under their line.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: REQUIRED: Each build stage is overseen by a supervisor employee; needed for accountability and shift handover reports.',
    `agv_enabled` BOOLEAN COMMENT 'Indicates whether AGV (Automated Guided Vehicle) systems are deployed at this build stage for material transport, vehicle body movement, or component sequencing. Drives AGV routing configuration and integration with SCADA and MES systems.',
    `applicable_vehicle_types` STRING COMMENT 'Comma-separated list of vehicle body types or powertrain categories for which this build stage applies (e.g., Sedan, SUV, Truck, EV, HEV, PHEV, ICE, Commercial). Enables stage filtering in mixed-model assembly lines and supports model-specific production routing. [ENUM-REF-CANDIDATE: Sedan|SUV|Truck|EV|HEV|PHEV|ICE|Commercial|CKD|SKD — promote to reference product]',
    `automation_level` STRING COMMENT 'Classification of the degree of automation at this build stage: manual (operator-driven), semi-automated (operator-assisted machinery), fully-automated (machine-driven with minimal operator oversight), or robotic (AGV/robot-cell driven). Informs CapEx planning, maintenance scheduling, and OEE benchmarking.. Valid values are `manual|semi-automated|fully-automated|robotic`',
    `buffer_capacity_units` STRING COMMENT 'Maximum number of vehicle units that can be held in the buffer/queue between this build stage and the next stage. Defines the WIP (Work in Progress) inventory limit for line balancing and is used in production simulation and bottleneck analysis.',
    `co2_emission_kg` DECIMAL(18,2) COMMENT 'Standard CO2-equivalent emissions in kilograms per vehicle unit processed at this build stage. Supports EPA and CARB (California Air Resources Board) environmental compliance reporting, sustainability KPIs, and manufacturing carbon footprint tracking.',
    `control_plan_code` STRING COMMENT 'Reference code of the APQP (Advanced Product Quality Planning) control plan document governing quality control activities at this build stage. Specifies product/process characteristics, control methods, and reaction plans for out-of-control conditions per IATF 16949.. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this build stage record was first created in the system. Provides audit trail for master data governance and change history tracking per IATF 16949 documented information control requirements.',
    `effective_from` DATE COMMENT 'The date from which this build stage definition record is valid and applicable for production use. Supports temporal versioning of the build stage master, enabling historical traceability of process changes and engineering change management.',
    `effective_until` DATE COMMENT 'The date until which this build stage definition record is valid. Null indicates the record is currently active with no planned expiry. Used for managing engineering changes, process revisions, and model-year transitions in the build stage master.',
    `energy_consumption_kwh` DECIMAL(18,2) COMMENT 'Standard energy consumption in kilowatt-hours (kWh) per vehicle unit processed through this build stage. Used for manufacturing sustainability reporting, carbon footprint calculation, and ISO 14001 environmental management compliance. Particularly significant for paint ovens and E-Coat tanks.',
    `eop_date` DATE COMMENT 'The EOP (End of Production) date on which this build stage is scheduled to be or was decommissioned. Null if the stage is currently active with no planned end date. Used for production planning horizon management and asset retirement scheduling.',
    `fmea_reference_code` STRING COMMENT 'Reference identifier linking this build stage to its corresponding FMEA (Failure Mode and Effects Analysis) document. Ensures traceability between the process stage definition and its risk assessment per IATF 16949 and APQP (Advanced Product Quality Planning) requirements.. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `hazmat_classification` STRING COMMENT 'Classification of hazardous materials present or used at this build stage per DOT and EPA regulations (e.g., paint solvents, E-Coat chemicals, welding fumes). Drives EHS (Environmental Health and Safety) compliance, PPE requirements, and ISO 14001 environmental management reporting.. Valid values are `none|flammable|corrosive|toxic|oxidizer|environmental-hazard`',
    `iatf_process_category` STRING COMMENT 'IATF 16949 process category designation for this build stage: special-characteristic (processes producing special product/process characteristics requiring enhanced control), standard-process, critical-process (safety-critical per FMVSS), or monitoring-only (observation without active control). Drives audit scope and PPAP (Production Part Approval Process) requirements.. Valid values are `special-characteristic|standard-process|critical-process|monitoring-only`',
    `is_quality_gate` BOOLEAN COMMENT 'Indicates whether this build stage is designated as a quality gate checkpoint where vehicles must pass defined quality criteria before advancing to the next stage. Quality gates are mandatory hold points per IATF 16949 and APQP (Advanced Product Quality Planning) requirements.',
    `is_rework_eligible` BOOLEAN COMMENT 'Indicates whether vehicles failing quality checks at this build stage are eligible for rework and re-entry into the production flow, as opposed to being routed to scrap or offline repair. Drives rework routing logic in MES and quality management workflows.',
    `labor_headcount_standard` STRING COMMENT 'The standard number of direct labor operators assigned to this build stage per shift under normal production conditions. Used for workforce planning, capacity balancing, and labor cost standard costing in SAP S/4HANA CO.',
    `max_temperature_c` DECIMAL(18,2) COMMENT 'Maximum allowable ambient or process temperature in degrees Celsius for this build stage. Exceeding this threshold triggers a quality hold and SCADA alarm. Particularly relevant for paint curing ovens, E-Coat baths, and weld quality control.',
    `mes_stage_code` STRING COMMENT 'The native stage identifier as defined in the Apriso/Dassault MES system. Used for cross-system reconciliation between the lakehouse silver layer and the operational MES, ensuring traceability of production events back to the source system of record.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `min_temperature_c` DECIMAL(18,2) COMMENT 'Minimum allowable ambient or process temperature in degrees Celsius for this build stage to operate within specification. Critical for paint shop, E-Coat, and adhesive curing stages where temperature directly affects product quality. Used in SPC (Statistical Process Control) monitoring.',
    `model_year_applicability` STRING COMMENT 'Comma-separated list of MY (Model Year) designations for which this build stage definition is applicable (e.g., MY2024,MY2025) or ALL if applicable across all model years. Supports model-year-specific production routing and engineering change management.. Valid values are `^(MYd{4}(,MYd{4})*|ALL)$`',
    `plant_area_code` STRING COMMENT 'Alphanumeric code identifying the specific plant area or shop within the manufacturing facility where this build stage is physically located (e.g., SH01 for Stamping Hall 1, BS02 for Body Shop 2). Aligns with SAP S/4HANA work center and plant layout master data.. Valid values are `^[A-Z0-9_]{2,15}$`',
    `plc_program_code` STRING COMMENT 'Identifier of the PLC (Programmable Logic Controller) program controlling the automated equipment at this build stage. Used for change management, version control of control programs, and traceability of equipment configuration changes per IATF 16949 requirements.. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `ppm_target` DECIMAL(18,2) COMMENT 'Target defect rate for this build stage expressed in PPM (Parts Per Million). Defines the quality performance benchmark used in IATF 16949 supplier and process quality reporting, SPC control limit setting, and continuous improvement initiatives.',
    `preceding_stage_code` STRING COMMENT 'Stage code of the immediately preceding build stage in the standard production sequence. Defines the upstream dependency for production flow control, WIP (Work in Progress) tracking, and JIS (Just-in-Sequence) scheduling. Null for the first stage in the sequence.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `process_area` STRING COMMENT 'The physical or functional manufacturing area where this build stage is executed (e.g., Stamping Plant, Body Shop, Paint Shop, General Assembly, Chassis Line, PDI Bay). Maps to plant layout zones and is used for capacity planning and SCADA (Supervisory Control and Data Acquisition) integration. [ENUM-REF-CANDIDATE: Stamping|Body Shop|Paint Shop|E-Coat|General Assembly|Chassis Line|Trim Line|PDI Bay|Quality Gate|Logistics — promote to reference product]',
    `quality_inspection_plan_code` STRING COMMENT 'Reference code of the SAP QM (Quality Management) inspection plan associated with this build stage. Defines the inspection characteristics, sampling procedures, and acceptance criteria applied during quality gate checks. Linked to FMEA (Failure Mode and Effects Analysis) and APQP documentation.. Valid values are `^[A-Z0-9_-]{3,25}$`',
    `safety_classification` STRING COMMENT 'Safety risk classification of this build stage per DOT and OSHA standards: standard (routine operations), elevated-risk (requires additional PPE or safety protocols), critical-safety (safety-critical operations with mandatory sign-off), or restricted-access (limited to certified personnel only).. Valid values are `standard|elevated-risk|critical-safety|restricted-access`',
    `sap_operation_code` STRING COMMENT 'The SAP S/4HANA PP routing operation code corresponding to this build stage. Enables direct linkage between the build stage reference master and SAP production order routing operations for cost allocation, scheduling, and confirmation.. Valid values are `^[A-Z0-9]{4,10}$`',
    `sequence_order` STRING COMMENT 'Integer defining the sequential position of this build stage within the overall vehicle assembly process flow. Used to enforce JIS (Just-in-Sequence) ordering, production line scheduling, and WIP (Work in Progress) traceability. Lower values indicate earlier stages.',
    `shift_pattern` STRING COMMENT 'Standard shift pattern under which this build stage operates: single (one shift per day), double (two shifts), triple (three shifts), or continuous (24/7 operation). Used for capacity planning, labor scheduling in SuccessFactors, and production throughput calculations.. Valid values are `single|double|triple|continuous`',
    `sop_date` DATE COMMENT 'The SOP (Start of Production) date on which this build stage was first commissioned and became operational for regular production. Used for asset lifecycle tracking, warranty baseline calculations, and production history reporting.',
    `spc_enabled` BOOLEAN COMMENT 'Indicates whether SPC (Statistical Process Control) monitoring is active for this build stage. When true, process parameters are continuously monitored against control limits and deviations trigger automated alerts in the MES and SAP QM systems per IATF 16949 requirements.',
    `stage_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the build stage within the manufacturing process (e.g., STAMP, BODY, ECOAT, PAINT, TRIM1, CHAS, TRIM2, FINAL, PDI). Used as the business key in MES (Manufacturing Execution System) integrations and production reporting.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `stage_description` STRING COMMENT 'Detailed narrative description of the manufacturing activities, operations, and objectives performed at this build stage. Provides context for production engineers, quality auditors, and training documentation. Sourced from PLM and MES configuration documentation.',
    `stage_name` STRING COMMENT 'Full descriptive name of the build stage as used in production planning and reporting (e.g., Stamping, Body Shop, E-Coat, Paint, Trim-1, Chassis, Trim-2, Final Assembly, PDI — Pre-Delivery Inspection). Displayed in MES dashboards and production schedules.',
    `stage_status` STRING COMMENT 'Current lifecycle status of the build stage definition: active (in production use), inactive (temporarily not in use), pilot (under validation/trial), suspended (halted due to quality or safety issue), or decommissioned (permanently retired from the process). Controls whether the stage is available for new production orders.. Valid values are `active|inactive|pilot|suspended|decommissioned`',
    `stage_type` STRING COMMENT 'Categorical classification of the build stage by its primary manufacturing function: assembly (joining components), fabrication (forming/stamping metal), coating (E-Coat/paint application), inspection (quality gate checks), testing (functional/NVH testing), or logistics (material staging/sequencing).. Valid values are `assembly|fabrication|coating|inspection|testing|logistics`',
    `standard_cycle_time_sec` DECIMAL(18,2) COMMENT 'The engineered standard cycle time for this build stage measured in seconds. Represents the designed takt-aligned duration for one vehicle unit to complete the stage under normal operating conditions. Used for production scheduling, OEE (Overall Equipment Effectiveness) calculation, and bottleneck analysis.',
    `succeeding_stage_code` STRING COMMENT 'Stage code of the immediately succeeding build stage in the standard production sequence. Defines the downstream handoff point for production flow control and vehicle build traceability. Null for the final stage (PDI) in the sequence.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `takt_time_sec` DECIMAL(18,2) COMMENT 'The customer-demand-driven takt time for this build stage in seconds, calculated as available production time divided by required production volume. Defines the rhythm of production and is used to balance line capacity and identify over/under-capacity stages.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this build stage record. Used for change detection in ETL pipelines, audit trail maintenance, and engineering change management workflows per IATF 16949 documented information control.',
    `work_center_code` STRING COMMENT 'SAP S/4HANA work center identifier associated with this build stage. Links the build stage to capacity planning, cost center allocation, and production order routing in the ERP system. Enables integration between MES stage execution and SAP PP/CO modules.. Valid values are `^[A-Z0-9_]{2,20}$`',
    CONSTRAINT pk_build_stage PRIMARY KEY(`build_stage_id`)
) COMMENT 'Reference master defining the standard build stages in the vehicle manufacturing process (e.g., Stamping, Body Shop, E-Coat, Paint, Trim-1, Chassis, Trim-2, Final, PDI). Captures stage code, stage name, sequence order, process area, standard cycle time, and applicable vehicle types. Used to structure vehicle_build traceability and production reporting. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` (
    `shop_floor_event_id` BIGINT COMMENT 'Unique surrogate identifier for each shop floor event record generated by MES, PLC, or SCADA systems during production operations.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where the event occurred. Supports multi-plant OEE (Overall Equipment Effectiveness) analysis and regulatory reporting.',
    `employee_id` BIGINT COMMENT 'Reference to the shop floor operator or technician who performed or acknowledged the event. Sourced from SuccessFactors workforce records.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the specific machine, robot, or automated equipment (e.g., welding robot, torque tool, paint gun, AGV unit) that generated or is associated with this event. Sourced from SAP PM equipment master.',
    `production_order_id` BIGINT COMMENT 'Reference to the SAP PP production order under which this shop floor event was generated. Links the event to the scheduled manufacturing work order.',
    `shift_id` BIGINT COMMENT 'Reference to the production shift during which this event was recorded. Enables shift-level OEE and throughput analysis.',
    `shop_equipment_registry_id` BIGINT COMMENT 'Identifier of the specific machine, robot, or automated equipment (e.g., welding robot, torque tool, paint gun, AGV unit) that generated or is associated with this event. Sourced from SAP PM equipment master.',
    `shop_operator_employee_id` BIGINT COMMENT 'Reference to the shop floor operator or technician who performed or acknowledged the event. Sourced from SuccessFactors workforce records.',
    `tooling_registry_id` BIGINT COMMENT 'Identifier of the specific hand tool or automated tool (e.g., torque wrench, weld gun tip, drill bit) used during this event. Enables tool traceability for PPAP (Production Part Approval Process) and tool wear monitoring.',
    `shop_tooling_registry_id` BIGINT COMMENT 'Identifier of the specific hand tool or automated tool (e.g., torque wrench, weld gun tip, drill bit) used during this event. Enables tool traceability for PPAP (Production Part Approval Process) and tool wear monitoring.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the vehicle unit being processed at the time of this event. Enables full build traceability from stamping through final assembly per NHTSA VIN requirements.',
    `work_center_id` BIGINT COMMENT 'Reference to the SAP PP/MES work center (station, cell, or line segment) where this event occurred. Identifies the physical production resource.',
    `agv_unit_code` STRING COMMENT 'Identifier of the AGV (Automated Guided Vehicle) unit involved in this event. Populated only for AGV arrival, departure, or fault events. Enables AGV fleet utilization and route efficiency analysis.. Valid values are `^AGV-[A-Z0-9]{2,15}$`',
    `assembly_area` STRING COMMENT 'Major manufacturing area where the event occurred. Supports area-level OEE reporting and quality gate management across stamping, body shop, paint, and final assembly. [ENUM-REF-CANDIDATE: stamping|body_shop|paint_shop|final_assembly|powertrain|chassis|trim — 7 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this shop floor event record was first ingested into the Databricks Silver layer. Distinct from event_timestamp (real-world event time). Used for data pipeline latency monitoring and audit trail.',
    `event_category` STRING COMMENT 'High-level grouping of the event type for reporting and analytics. Enables aggregated OEE loss categorization (availability, performance, quality) and safety incident tracking.. Valid values are `production|quality|material|equipment|safety|logistics`',
    `event_duration_seconds` DECIMAL(18,2) COMMENT 'Duration of the shop floor event in seconds (e.g., station cycle time, weld duration, paint cure time). Principal quantitative measurement for cycle time analysis and OEE performance rate calculation.',
    `event_payload` STRING COMMENT 'Structured JSON string containing the full event-specific payload from the MES, PLC, or SCADA system. Stores additional context-specific parameters not captured in dedicated columns (e.g., weld schedule parameters, paint recipe ID, torque angle). Stored as STRING to comply with Silver layer no-complex-type constraint.',
    `event_source_system` STRING COMMENT 'Identifies the originating control system that generated this event (MES, PLC, SCADA, AGV controller, or manual entry). Critical for data lineage and root-cause analysis. [ENUM-REF-CANDIDATE: MES|PLC|SCADA|AGV|TPMS|OBD|MANUAL — 7 candidates stripped; promote to reference product]',
    `event_status` STRING COMMENT 'Current lifecycle state of the shop floor event record. Indicates whether the event has been acknowledged, confirmed by the operator, placed on hold, or escalated for quality review.. Valid values are `open|confirmed|cancelled|on_hold|escalated`',
    `event_timestamp` TIMESTAMP COMMENT 'Precise date and time (ISO 8601 with timezone offset) when the shop floor event occurred as recorded by the MES, PLC, or SCADA system. This is the principal real-world event time used for OEE calculation and production sequencing.',
    `event_type` STRING COMMENT 'Discriminator classifying the kind of shop floor event. Drives downstream routing, OEE calculation, and quality gate logic. [ENUM-REF-CANDIDATE: station_entry|station_exit|torque_confirmation|weld_completion|paint_cure|agv_arrival|hold_trigger|alarm|inspection_pass|inspection_fail|rework_start|rework_complete — promote to reference product]',
    `fault_code` STRING COMMENT 'Machine or process fault code generated by the PLC or SCADA system when an alarm or hold event occurs. Used for root-cause analysis, FMEA (Failure Mode and Effects Analysis) updates, and maintenance work order creation.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `fault_description` STRING COMMENT 'Human-readable description of the fault or alarm condition associated with this event. Populated from the PLC/SCADA alarm dictionary. Null for non-alarm events.',
    `hold_reason_code` STRING COMMENT 'Coded reason for a production hold triggered by this event (e.g., QUAL-FAIL, TORQUE-OOC, WELD-MISS, PART-MISSING). Populated only for hold_trigger event types. Drives quality containment and corrective action workflows.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `is_rework` BOOLEAN COMMENT 'Indicates whether this event is associated with a rework operation (True) rather than a first-pass production operation (False). Used to calculate first-time quality (FTQ) and rework cost metrics.',
    `is_within_spec` BOOLEAN COMMENT 'Indicates whether the measured value falls within the defined process control limits (True) or represents an out-of-specification condition (False). Drives automatic quality hold triggers and PPM (Parts Per Million) defect rate calculation.',
    `lower_control_limit` DECIMAL(18,2) COMMENT 'Lower statistical process control limit for the measured value at this station. Used in SPC (Statistical Process Control) to detect process drift and trigger quality holds.',
    `measured_value` DECIMAL(18,2) COMMENT 'Principal numeric measurement captured during the event (e.g., torque value in Nm, weld current in A, paint film thickness in µm, temperature in °C, pressure in bar). Null when the event type does not produce a measurement.',
    `measured_value_unit` STRING COMMENT 'Engineering unit of measure for the measured_value field (e.g., Nm for torque, A for weld current, µm for paint film thickness). Ensures dimensional correctness in SPC and quality analysis. [ENUM-REF-CANDIDATE: Nm|A|V|bar|°C|µm|mm|kg|kN|rpm|% — 11 candidates stripped; promote to reference product]',
    `mes_event_number` STRING COMMENT 'Externally-known unique event reference number assigned by the Apriso/Dassault MES system. Used for cross-system traceability and audit correlation.. Valid values are `^MES-[A-Z0-9]{4,20}$`',
    `model_year` STRING COMMENT 'Four-digit model year (MY) of the vehicle being produced at the time of this event. Supports model-year-level production analytics and regulatory compliance reporting.',
    `oee_loss_category` STRING COMMENT 'Classifies this events contribution to OEE (Overall Equipment Effectiveness) loss: availability loss (unplanned downtime), performance loss (speed reduction), quality loss (defects/rework), or no_loss (normal production). Enables direct OEE waterfall analysis per ISO 22400.. Valid values are `availability|performance|quality|no_loss`',
    `planned_cycle_time_seconds` DECIMAL(18,2) COMMENT 'Standard planned cycle time in seconds for this process step as defined in the SAP PP routing. Compared against event_duration_seconds to calculate performance rate for OEE.',
    `powertrain_type` STRING COMMENT 'Powertrain technology type of the vehicle being produced (ICE – Internal Combustion Engine, HEV – Hybrid Electric Vehicle, PHEV – Plug-in Hybrid Electric Vehicle, BEV – Battery Electric Vehicle, FCEV – Fuel Cell Electric Vehicle). Drives process routing differences and regulatory compliance checks.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `process_step_code` STRING COMMENT 'Code identifying the specific manufacturing process step (e.g., STAMP-001, BODY-WELD-045, PAINT-CURE-010, ASSY-TORQUE-120) within the routing. Aligns with SAP PP routing operations.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `production_line_code` STRING COMMENT 'Alphanumeric code identifying the specific production line (e.g., BODY-LINE-1, PAINT-LINE-A, FINAL-ASSY-2) where the event occurred. Supports line-level throughput and OEE analysis.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `program_number` STRING COMMENT 'Version-controlled program number loaded on the PLC or robot controller at the time of this event. Critical for traceability of process parameter changes and engineering change management.. Valid values are `^[A-Z0-9_.-]{2,40}$`',
    `quality_result` STRING COMMENT 'Outcome of the quality check associated with this event. Determines whether the vehicle unit proceeds to the next station, requires rework, or is scrapped. Feeds into IATF 16949 quality records and PPM reporting.. Valid values are `pass|fail|rework|scrap|conditional_pass`',
    `rework_attempt_number` STRING COMMENT 'Sequential count of rework attempts for this vehicle unit at this station. A value greater than 1 indicates repeated failures and triggers escalation per IATF 16949 nonconforming product procedures.',
    `scrap_code` STRING COMMENT 'Coded reason for scrapping a component or vehicle unit at this event. Populated only when quality_result is scrap. Feeds into SAP CO scrap cost reporting and IATF 16949 quality records.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `sequence_number` STRING COMMENT 'Production sequence number assigned to the vehicle unit in the JIS (Just-in-Sequence) build schedule. Used to validate correct part delivery sequencing and detect sequence deviations.',
    `station_code` STRING COMMENT 'Unique code of the specific work station or assembly point within the production line where the event was triggered. Enables station-level cycle time and downtime analysis.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `station_name` STRING COMMENT 'Human-readable descriptive name of the work station (e.g., Underbody Weld Station 3, E-Coat Oven Exit, Engine Dress Final). Used in operator dashboards and quality reports.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this shop floor event record in the Silver layer (e.g., when quality result or hold status was updated post-event). Supports change data capture and audit compliance.',
    `upper_control_limit` DECIMAL(18,2) COMMENT 'Upper statistical process control limit for the measured value at this station. Used in SPC (Statistical Process Control) to detect process drift and trigger quality holds.',
    `vehicle_model_code` STRING COMMENT 'Internal code identifying the vehicle model or platform being assembled (e.g., F-150, RAV4, Model-3-LR). Enables model-mix production analysis and JIS (Just-in-Sequence) validation.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `vin_number` STRING COMMENT '17-character Vehicle Identification Number of the vehicle unit being processed. Denormalized here for direct event-level traceability without requiring a join. Conforms to ISO 3779 and NHTSA 49 CFR Part 565.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_shop_floor_event PRIMARY KEY(`shop_floor_event_id`)
) COMMENT 'Granular transactional record capturing real-time shop floor events generated by MES, PLC, and SCADA systems during production. Includes event type (station entry, station exit, torque confirmation, weld completion, paint cure, AGV arrival, hold trigger, alarm), event timestamp, work center, production order reference, VIN reference, operator ID, and event payload. Enables real-time production monitoring and OEE (Overall Equipment Effectiveness) calculation. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` (
    `wip_inventory_id` BIGINT COMMENT 'Unique surrogate identifier for each WIP inventory snapshot or movement record on the shop floor. Primary key for this entity.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: WIP valuation and inventory accounting require a direct FK to the finance cost center for accurate period‑end reporting.',
    `inbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_shipment. Business justification: WIP traceability requires linking inventory records to the inbound shipment that delivered the parts, supporting recall and quality investigations.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: WIP inventory must reference the authoritative part master for quality, cost, and compliance checks.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where this WIP item resides. Aligns with SAP organizational unit (Werk) for plant-level WIP visibility.',
    `employee_id` BIGINT COMMENT 'Employee ID of the shop floor operator who last performed or confirmed an operation on this WIP item. Sourced from MES operator login. Supports operator-level quality traceability per IATF 16949.',
    `production_line_id` BIGINT COMMENT 'FK to manufacturing.production_line',
    `production_order_id` BIGINT COMMENT 'Reference to the SAP PP production order (Fertigungsauftrag) that authorized the manufacturing activity generating this WIP item. Links WIP to the planned production schedule.',
    `inspection_id` BIGINT COMMENT 'Reference to the quality inspection lot or inspection record associated with this WIP item when wip_status = awaiting_inspection or after inspection completion. Links to SAP QM inspection lot.',
    `routing_id` BIGINT COMMENT 'Reference to the production routing (Arbeitsplan) that defines the sequence of operations for manufacturing this WIP item. Sourced from SAP PP routing master data.',
    `shift_id` BIGINT COMMENT 'FK to manufacturing.shift',
    `sku_master_id` BIGINT COMMENT 'Reference to the SAP material master record (Materialstamm) representing the sub-assembly, component, or vehicle body in this WIP record.',
    `storage_location_id` BIGINT COMMENT 'FK to inventory.storage_location',
    `wip_operator_employee_id` BIGINT COMMENT 'Employee ID of the shop floor operator who last performed or confirmed an operation on this WIP item. Sourced from MES operator login. Supports operator-level quality traceability per IATF 16949.',
    `work_center_id` BIGINT COMMENT 'Reference to the specific work center (Arbeitsplatz) on the shop floor where the WIP item is currently being processed or staged. Supports JIS sequencing and real-time WIP location tracking.',
    `actual_cycle_time_sec` DECIMAL(18,2) COMMENT 'Actual time in seconds taken to complete the current operation on this WIP item, calculated from operation_start_timestamp to operation_end_timestamp. Compared against standard_cycle_time_sec for efficiency analysis.',
    `assembly_stage` STRING COMMENT 'Manufacturing stage or shop area where the WIP item currently resides. Reflects the major production zones: stamping, body shop, paint, final assembly, powertrain, chassis, trim, and inspection. Supports stage-level WIP throughput analysis. [ENUM-REF-CANDIDATE: stamping|body_shop|paint|final_assembly|powertrain|chassis|trim|inspection — 8 candidates stripped; promote to reference product]',
    `bom_version` STRING COMMENT 'Version identifier of the Bill of Materials (BOM) applicable to this WIP item at the time of production. Ensures traceability to the exact engineering configuration used during manufacturing.',
    `buffer_zone_code` STRING COMMENT 'Code identifying the buffer or staging zone where the WIP item is temporarily held between work centers (e.g., pre-paint buffer, body shop exit buffer, final assembly feeder lane). Supports JIT/JIS material flow management.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the wip_valuation_amount (e.g., USD, EUR, MXN). Supports multi-currency WIP valuation for global manufacturing plants.. Valid values are `^[A-Z]{3}$`',
    `engineering_change_number` STRING COMMENT 'Engineering Change Number (ECN) applicable to this WIP item if it is being built to a revised engineering specification. Sourced from Siemens Teamcenter PLM. Ensures traceability of mid-production design changes.',
    `hold_reason_code` STRING COMMENT 'Code indicating the reason a WIP item has been placed on hold (e.g., quality defect, missing component, engineering change, supplier deviation). Populated only when wip_status = on_hold. [ENUM-REF-CANDIDATE: quality_defect|missing_component|engineering_change|supplier_deviation|tooling_failure|safety_concern|awaiting_approval — promote to reference product]',
    `inspection_result` STRING COMMENT 'Outcome of the most recent quality inspection gate for this WIP item: pass = conforms to specification; fail = non-conforming; conditional_pass = accepted with deviation; pending = inspection not yet completed.. Valid values are `pass|fail|conditional_pass|pending`',
    `is_rework_item` BOOLEAN COMMENT 'Indicates whether this WIP item has been routed to a rework station for corrective operations (True) or is following the standard production flow (False). Used to track rework rates and associated costs.',
    `location_entry_timestamp` TIMESTAMP COMMENT 'Date and time when the WIP item entered the current work center, buffer zone, or AGV carrier position. Used to calculate dwell time and identify bottlenecks in the production flow.',
    `location_exit_timestamp` TIMESTAMP COMMENT 'Date and time when the WIP item exited the current work center, buffer zone, or AGV carrier position. Null if the item has not yet departed. Used with location_entry_timestamp to compute cycle time per station.',
    `mes_transaction_code` STRING COMMENT 'Unique transaction identifier assigned by the Apriso/Dassault MES system for this WIP movement or status change event. Used for source system reconciliation and audit trail in the Silver Layer.',
    `model_year` STRING COMMENT 'Four-digit model year (MY) of the vehicle being manufactured. Used to segregate WIP by model year for production planning, regulatory compliance (CAFE, EPA), and inventory valuation.. Valid values are `^[0-9]{4}$`',
    `operation_end_timestamp` TIMESTAMP COMMENT 'Date and time when the manufacturing operation on this WIP item was completed or closed. Used to calculate actual operation duration and compare against standard cycle time.',
    `operation_number` STRING COMMENT 'SAP PP routing operation number (Vorgangs-Nr.) identifying the specific manufacturing step being performed on this WIP item. Aligns with the production order routing sequence.. Valid values are `^[0-9]{4}$`',
    `operation_start_timestamp` TIMESTAMP COMMENT 'Date and time when the manufacturing operation on this WIP item was started by the operator or automated system. Represents the principal business event time for this WIP transaction.',
    `powertrain_type` STRING COMMENT 'Powertrain technology type of the vehicle being assembled: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), EV (Electric Vehicle), or FCEV (Fuel Cell Electric Vehicle). Drives assembly process routing and regulatory reporting.. Valid values are `ICE|HEV|PHEV|EV|FCEV`',
    `priority_code` STRING COMMENT 'Production priority assigned to this WIP item. EXPEDITE indicates a rush order requiring immediate processing to meet customer or dealer commitment. Used by shop floor supervisors to manage queue sequencing.. Valid values are `NORMAL|HIGH|URGENT|EXPEDITE`',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity of units represented by this WIP inventory record. Typically 1 for discrete vehicle assemblies; may be greater than 1 for batch sub-assembly components (e.g., fasteners, brackets).',
    `record_created_timestamp` TIMESTAMP COMMENT 'Date and time when this WIP inventory record was first created in the source MES system. Audit trail field for data lineage and IATF 16949 traceability compliance.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this WIP inventory record was last modified in the source MES system. Used for change detection and incremental Silver Layer ingestion.',
    `sap_order_number` STRING COMMENT 'SAP PP production order number (Auftragsnummer) from SAP S/4HANA that corresponds to the production_order_id. Retained as a business-visible identifier for cross-system reconciliation between MES and ERP.. Valid values are `^[0-9]{8,12}$`',
    `scheduled_completion_date` DATE COMMENT 'Planned date by which this WIP item is expected to complete the current operation or exit the current stage, as defined in the production order schedule. Used for OTD (On-Time Delivery) tracking.',
    `scrap_reason_code` STRING COMMENT 'Code identifying the reason a WIP item was scrapped (e.g., dimensional non-conformance, weld failure, paint defect, crash damage). Populated only when wip_status = scrapped. Feeds PPM (Parts Per Million) defect rate reporting. [ENUM-REF-CANDIDATE: dimensional_nonconformance|weld_failure|paint_defect|crash_damage|material_defect|process_error — promote to reference product]',
    `sequence_number` STRING COMMENT 'Just-in-Sequence (JIS) position number assigned to this WIP item within the production line sequence. Critical for sequenced delivery of components (e.g., seats, instrument panels) and for maintaining build order integrity.',
    `snapshot_timestamp` TIMESTAMP COMMENT 'Date and time when this WIP inventory snapshot record was captured. Supports point-in-time WIP visibility and Silver Layer delta processing in the Databricks Lakehouse.',
    `standard_cycle_time_sec` DECIMAL(18,2) COMMENT 'Planned standard cycle time in seconds for the current operation on this WIP item, as defined in the SAP PP routing. Used to calculate actual vs. standard cycle time variance and identify takt time deviations.',
    `sub_assembly_number` STRING COMMENT 'Unique identifier for a sub-assembly unit (e.g., powertrain module, instrument panel, axle assembly) when the WIP item is not yet associated with a full VIN. Assigned by the MES during component-level traceability.',
    `supplier_deviation_number` STRING COMMENT 'Reference number for an approved supplier deviation or concession allowing a non-standard component to be used in this WIP item. Issued via PPAP (Production Part Approval Process) deviation process.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the WIP quantity (e.g., EA = each for discrete assemblies, KG for weight-based materials). Aligns with SAP base unit of measure (Basismengeneinheit). [ENUM-REF-CANDIDATE: EA|KG|L|M|M2|M3|PC|SET — 8 candidates stripped; promote to reference product]',
    `vehicle_model_code` STRING COMMENT 'Internal code identifying the vehicle model or nameplate being assembled (e.g., F-150, Silverado, Model 3 equivalent). Supports model-mix analysis and JIS sequencing.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number assigned to the vehicle body or chassis associated with this WIP item. Populated once the VIN is stamped during body shop operations; null for sub-assembly WIP prior to VIN assignment.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `wip_record_number` STRING COMMENT 'Human-readable, externally visible business identifier for this WIP inventory record, generated by the MES (Manufacturing Execution System). Used on shop floor traveler documents and in MES dashboards.. Valid values are `^WIP-[A-Z0-9]{3,6}-[0-9]{8}-[0-9]{6}$`',
    `wip_status` STRING COMMENT 'Current lifecycle status of the WIP item on the shop floor. in_process = actively being worked on; on_hold = paused pending resolution; awaiting_inspection = queued for quality gate; scrapped = condemned and removed from flow; completed = operation finished; rework = returned for corrective operations.. Valid values are `in_process|on_hold|awaiting_inspection|scrapped|completed|rework`',
    `wip_valuation_amount` DECIMAL(18,2) COMMENT 'Standard cost valuation of this WIP item in the plant currency, calculated based on the accumulated material and activity costs up to the current production stage. Used for WIP inventory valuation in SAP CO (Controlling) and financial reporting.',
    CONSTRAINT pk_wip_inventory PRIMARY KEY(`wip_inventory_id`)
) COMMENT 'Snapshot and movement record for Work-in-Progress (WIP) inventory on the shop floor. Tracks WIP item identity, associated VIN or sub-assembly ID, current location (work center, buffer zone, AGV carrier), quantity, WIP status (in-process, on-hold, awaiting inspection, scrapped), entry and exit timestamps per location, and production order reference. Supports real-time WIP visibility and JIT material flow management. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` (
    `production_schedule_id` BIGINT COMMENT 'Unique surrogate identifier for the master production schedule (MPS) record in the Databricks Silver Layer. Primary key for this entity.',
    `billing_run_id` BIGINT COMMENT 'Reference to the SAP MRP (Material Requirements Planning) run that generated or last updated this production schedule. Enables traceability of schedule origin and supports re-planning analysis.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Foreign key linking to product.nameplate. Business justification: REQUIRED: Production schedules are often filtered by nameplate; nameplate‑level planning dashboards need this FK.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where the scheduled production will occur. Corresponds to the SAP Plant organizational unit.',
    `production_line_id` BIGINT COMMENT 'Reference to the specific production line (e.g., final assembly, body shop, paint shop, stamping) within the plant where the scheduled build will take place.',
    `model_id` BIGINT COMMENT 'Reference to the vehicle model (e.g., sedan, SUV, truck, EV) being scheduled for production. Links to the vehicle master product record.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Production schedules are generated per vehicle program; schedule analytics filter by vehicle_program_id.',
    `actual_quantity` STRING COMMENT 'Actual number of vehicles produced and confirmed as good units by the MES (Manufacturing Execution System) during the schedule period. Populated upon schedule completion from Apriso/Dassault MES.',
    `approved_by` STRING COMMENT 'Name or employee identifier of the production planning manager who formally approved this schedule version for release to the shop floor. Required for IATF 16949 document control and audit trail.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the production schedule was formally approved for release. Marks the transition from draft to released status and triggers supplier call-off generation.',
    `assembly_process_stage` STRING COMMENT 'Manufacturing process stage covered by this schedule record. Reflects the major shop areas in automotive assembly: stamping (metal forming), body shop (welding/joining), paint (surface treatment), final assembly (powertrain/trim installation), or trim-chassis-final (TCF integrated line).. Valid values are `stamping|body_shop|paint|final_assembly|trim_chassis_final`',
    `available_capacity_hours` DECIMAL(18,2) COMMENT 'Total available production capacity in hours for this schedule period on the assigned production line, accounting for planned downtime, maintenance windows, and shift patterns.',
    `body_style` STRING COMMENT 'Body style classification of the vehicles scheduled for production. Used for production line configuration, tooling setup, and capacity planning by body type.. Valid values are `sedan|suv|truck|van|coupe|convertible`',
    `build_sequence_end` STRING COMMENT 'Ending sequence number for the JIS (Just-in-Sequence) build order within this schedule period. Together with build_sequence_start defines the range of vehicle sequence numbers assigned to this schedule.',
    `build_sequence_start` STRING COMMENT 'Starting sequence number for the JIS (Just-in-Sequence) build order within this schedule period. Used by MES and AGV systems to sequence vehicle bodies through the production line in the correct order.',
    `build_type` STRING COMMENT 'Classification of the production build type. standard = full series production; ckd = Completely Knocked Down (CKD) kit assembly; skd = Semi Knocked Down (SKD) assembly; pilot = pre-production pilot build; pre_series = pre-series validation build.. Valid values are `standard|ckd|skd|pilot|pre_series`',
    `calloff_transmission_time` TIMESTAMP COMMENT 'Timestamp when supplier delivery call-offs were transmitted to the supply base for this production schedule. Used for OTD (On-Time Delivery) tracking and supplier performance measurement.',
    `capacity_utilization_pct` DECIMAL(18,2) COMMENT 'Planned capacity utilization percentage for this schedule period, calculated as (confirmed_quantity × takt_time) / available_capacity_hours × 100. Stored as a planning input from SAP PP capacity leveling, not a derived KPI.',
    `confirmed_quantity` STRING COMMENT 'Number of vehicles confirmed for production after capacity leveling, constraint resolution, and production planning approval. May differ from planned_quantity due to capacity constraints or material availability.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this production schedule record was first created in the system, either by an MRP run or manual entry. Audit trail field for data lineage and compliance.',
    `eop_date` DATE COMMENT 'Official End of Production (EOP) date for the vehicle model/model year. Schedules beyond this date are invalid. Used for phase-out planning, last-time-buy procurement, and regulatory deregistration.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month number 1-12 or 1-16 for special periods) within the fiscal year. Enables alignment of production volumes with financial reporting periods for management accounting and EBITDA analysis.',
    `fiscal_year` STRING COMMENT 'Fiscal year (FY) to which this production schedule belongs. Used for financial planning, CapEx allocation, and EBITDA reporting alignment between production volumes and financial periods.',
    `freeze_horizon_date` DATE COMMENT 'Date up to which the production schedule is frozen and cannot be changed without formal change control. Protects supplier call-offs and JIT/JIS delivery commitments within the frozen window.',
    `is_frozen` BOOLEAN COMMENT 'Boolean flag indicating whether this schedule record is currently within the freeze horizon and locked against changes. True = frozen (no modifications allowed without change control); False = open for revision.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this production schedule record. Updated on every revision, status change, or quantity adjustment. Essential for incremental data loading in the Databricks Silver Layer.',
    `model_year` STRING COMMENT 'The automotive model year (MY) designation for the vehicles being scheduled. Used for regulatory compliance (CAFE, EPA), BOM versioning, and sales planning. Typically one year ahead of the calendar year for SOP planning.',
    `planned_quantity` STRING COMMENT 'Total number of vehicles planned for production in this schedule period as determined by the MRP run. Represents the gross requirement before capacity and constraint adjustments.',
    `powertrain_type` STRING COMMENT 'Powertrain technology classification for the vehicles in this schedule. ICE = Internal Combustion Engine; HEV = Hybrid Electric Vehicle; PHEV = Plug-in Hybrid Electric Vehicle; EV = Battery Electric Vehicle; FCEV = Fuel Cell Electric Vehicle. Drives regulatory reporting (CAFE, EPA, CARB) and BOM variant selection.. Valid values are `ICE|HEV|PHEV|EV|FCEV`',
    `regulatory_market` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the primary regulatory market for which these vehicles are being produced. Determines applicable homologation standards (NHTSA/FMVSS for USA, UNECE for Europe, etc.), emissions certification (EPA, CARB, Euro 6), and CAFE compliance tracking. [ENUM-REF-CANDIDATE: USA|CAN|MEX|DEU|GBR|CHN|JPN|KOR|AUS|BRA — 10 candidates stripped; promote to reference product]',
    `schedule_change_reason` STRING COMMENT 'Business reason code or description for the most recent schedule revision. Examples: material shortage, capacity constraint, demand change, quality hold, tooling failure, model mix adjustment. Required for change control audit trail per IATF 16949.',
    `schedule_date` DATE COMMENT 'The principal planned production date (or start date of the weekly/monthly bucket) for this schedule record. Represents the real-world business event date when production is planned to occur.',
    `schedule_end_date` DATE COMMENT 'End date of the production schedule period. For daily schedules this equals schedule_date; for weekly/monthly buckets this marks the last day of the planning period.',
    `schedule_notes` STRING COMMENT 'Free-text field for production planners to record contextual notes, exceptions, or special instructions associated with this schedule record. Examples: tooling changeover notes, quality hold references, special customer order constraints.',
    `schedule_number` STRING COMMENT 'Externally-known alphanumeric identifier for the production schedule record, sourced from SAP PP (Production Planning). Used for cross-system reference and communication with supply chain and manufacturing teams.. Valid values are `^MPS-[A-Z0-9]{3,10}-[0-9]{4}-[0-9]{6}$`',
    `schedule_status` STRING COMMENT 'Current lifecycle state of the production schedule record. draft = initial planning; released = approved for execution; frozen = within freeze horizon, no changes allowed; in_execution = active shop floor production; completed = all planned units built; cancelled = schedule voided.. Valid values are `draft|released|frozen|in_execution|completed|cancelled`',
    `schedule_type` STRING COMMENT 'Time granularity of the production schedule record. daily = day-level MPS; weekly = weekly bucket plan; monthly = monthly capacity plan. Determines the planning horizon and supplier call-off frequency.. Valid values are `daily|weekly|monthly`',
    `schedule_version` STRING COMMENT 'Incremental version number of the production schedule. Each MRP (Material Requirements Planning) run or manual revision increments this counter, enabling version comparison and rollback analysis.',
    `scheduled_end_time` TIMESTAMP COMMENT 'Precise timestamp when production is scheduled to complete for this schedule record. Used for shift planning, takt time validation, and downstream logistics coordination.',
    `scheduled_start_time` TIMESTAMP COMMENT 'Precise timestamp when production is scheduled to begin on the line for this schedule record. Used for JIS (Just-in-Sequence) sequencing, AGV routing, and supplier call-off timing.',
    `shift_pattern` STRING COMMENT 'Shift configuration planned for this production schedule period. Determines available production hours and workforce requirements. Single = 1 shift/day; Double = 2 shifts/day; Triple = 3 shifts/day; Weekend = weekend-only production.. Valid values are `single|double|triple|weekend`',
    `sop_date` DATE COMMENT 'Official Start of Production (SOP) date for the vehicle model/model year being scheduled. Marks the formal launch of series production. Used to validate that schedule dates fall within the active production window.',
    `supplier_calloff_generated` BOOLEAN COMMENT 'Boolean flag indicating whether supplier delivery call-offs (JIT/JIS delivery schedules) have been generated and transmitted to suppliers based on this production schedule. True = call-offs sent; False = pending call-off generation.',
    `takt_time_seconds` STRING COMMENT 'Planned takt time in seconds per vehicle unit for this production schedule. Takt time = available production time divided by customer demand rate. Drives line balancing, AGV pacing, and JIS sequencing intervals.',
    CONSTRAINT pk_production_schedule PRIMARY KEY(`production_schedule_id`)
) COMMENT 'Master production schedule (MPS) record defining planned vehicle production volumes by plant, production line, model, MY (Model Year), and time period (daily, weekly, monthly). Captures scheduled quantity, confirmed quantity, schedule version, freeze horizon, schedule status, and MRP run reference. Integrates with SAP PP MRP and supports capacity planning and supplier call-off generation. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`shift` (
    `shift_id` BIGINT COMMENT 'Unique surrogate identifier for each shift definition record in the manufacturing plant reference master.',
    `factory_calendar_id` BIGINT COMMENT 'SAP factory calendar identifier governing public holidays and non-working days applicable to this shift definition (e.g., US01, DE01). Ensures production scheduling excludes statutory holidays.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant at which this shift definition applies. Used to scope shift schedules to specific production facilities.',
    `production_line_id` BIGINT COMMENT 'Reference to the specific production line (e.g., stamping, body shop, paint, final assembly) to which this shift definition is assigned. Enables line-level OEE and scheduling.',
    `agv_active` BOOLEAN COMMENT 'Indicates whether Automated Guided Vehicle (AGV) operations are active during this shift. Used for shop floor automation scheduling and safety protocol management in MES and SCADA integrations.',
    `break_duration_minutes` STRING COMMENT 'Total scheduled break time in minutes for the shift (e.g., 30 minutes for a single meal break, 50 minutes for two breaks). Used to reconcile gross shift hours against planned production hours.',
    `break_schedule` STRING COMMENT 'Textual description of the break schedule for the shift, including break times and durations (e.g., 10:00–10:15 AM rest break; 12:30–13:00 PM meal break). Supports workforce planning and ergonomic compliance documentation.',
    `shift_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying the shift definition within the plant (e.g., DAY1, AFT2, NGT3, WKD1). Used as the business key in SAP PP and MES integrations.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this shift definition record was first created in the system. Used for audit trail, data lineage, and IATF 16949 document control compliance.',
    `day_of_week_mask` STRING COMMENT 'Seven-character binary string (Mon–Sun) indicating which days of the week this shift runs (e.g., 1111100 = Monday to Friday, 0000011 = Saturday and Sunday). Used by MES and SAP PP for automated shift calendar generation.. Valid values are `^[01]{7}$`',
    `shift_description` STRING COMMENT 'Free-text description providing additional context about the shift definition, including special operating conditions, seasonal variations, or programme-specific notes (e.g., Reduced capacity shift during model year changeover).',
    `effective_date` DATE COMMENT 'Calendar date from which this shift definition becomes valid and available for production scheduling. Supports versioned shift master management and seasonal schedule changes.',
    `energy_consumption_target_kwh` DECIMAL(18,2) COMMENT 'Planned energy consumption target in kilowatt-hours for the shift. Used for energy efficiency monitoring, ISO 14001 environmental reporting, and CAFE/EPA compliance cost tracking.',
    `eop_date` DATE COMMENT 'End of Production (EOP) date associated with this shift definition, indicating when the shift schedule is retired for a vehicle programme. Null if no planned end. Used for production wind-down planning.',
    `expiry_date` DATE COMMENT 'Calendar date after which this shift definition is no longer valid for production scheduling. Null indicates an open-ended shift definition with no planned end. Supports model year changeovers and SOP/EOP transitions.',
    `gross_shift_hours` DECIMAL(18,2) COMMENT 'Total clock hours from shift start to shift end including all breaks and non-production time (e.g., 8.0 hours). Used to distinguish gross capacity from net available production time.',
    `handover_duration_minutes` STRING COMMENT 'Planned duration in minutes allocated for shift handover activities between outgoing and incoming crews (e.g., 15 minutes). Included in shift scheduling to ensure continuity of production and quality checks.',
    `is_template` BOOLEAN COMMENT 'Indicates whether this shift record is a reusable template definition (True) rather than a plant/line-specific instantiation (False). Templates are used to standardise shift configurations across multiple plants and lines.',
    `mes_shift_code` STRING COMMENT 'Native shift identifier in the Apriso/Dassault MES system used for shop floor execution and traceability. Enables cross-system reconciliation between the lakehouse silver layer and the MES source of record.. Valid values are `^[A-Z0-9_-]{1,50}$`',
    `model_year` STRING COMMENT 'Automotive model year (MY) for which this shift definition is applicable (e.g., 2025). Aligns shift scheduling with SOP (Start of Production) and EOP (End of Production) milestones for specific vehicle programmes.. Valid values are `^[0-9]{4}$`',
    `shift_name` STRING COMMENT 'Human-readable name of the shift (e.g., Day Shift, Afternoon Shift, Night Shift, Weekend Shift). Used in production scheduling dashboards, workforce planning reports, and OEE calculations.',
    `number_of_breaks` STRING COMMENT 'Count of distinct scheduled break periods within the shift (e.g., 2 for a morning rest break and a meal break). Used in ergonomic compliance reporting and workforce scheduling.',
    `oee_target_percent` DECIMAL(18,2) COMMENT 'Target OEE percentage for this shift, representing the combined availability, performance, and quality targets (e.g., 85.00%). Used as the benchmark for shift-level OEE reporting and continuous improvement initiatives.',
    `overtime_eligible` BOOLEAN COMMENT 'Indicates whether this shift definition is classified as an overtime shift, triggering premium pay calculations and overtime reporting in SAP HR and SuccessFactors payroll.',
    `pattern_code` STRING COMMENT 'Code referencing the rotating shift pattern or schedule template to which this shift belongs (e.g., 3SHIFT_ROTATING, 2SHIFT_FIXED, CONTINENTAL). Used for workforce rostering and long-term capacity planning.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `planned_end_time` TIMESTAMP COMMENT 'Planned clock time at which the shift ends production activities. Combined with planned_start_time to derive gross shift duration for capacity and OEE calculations.',
    `planned_production_hours` DECIMAL(18,2) COMMENT 'Net planned production hours for the shift after deducting all scheduled breaks and non-production time (e.g., 7.5 hours for an 8-hour shift with 30-minute break). Core input for OEE denominator and capacity planning in SAP PP.',
    `planned_start_time` TIMESTAMP COMMENT 'Planned clock time at which the shift begins production activities (e.g., 2024-01-15T06:00:00.000+00:00). Used for production order scheduling, JIS sequencing, and workforce rostering.',
    `premium_pay_rate` DECIMAL(18,2) COMMENT 'Pay rate multiplier applied to base wages for this shift (e.g., 1.5000 for time-and-a-half overtime, 1.2500 for night shift differential). Used in payroll cost calculations and labour cost reporting. Classified confidential as it contains compensation data.',
    `production_model` STRING COMMENT 'Shift operating model classification indicating the overall production schedule structure at the plant (e.g., single_shift, two_shift, three_shift, four_shift_continental). Drives capacity planning and workforce rostering strategy.. Valid values are `single_shift|two_shift|three_shift|four_shift_continental`',
    `quality_inspection_required` BOOLEAN COMMENT 'Indicates whether a mandatory quality inspection (e.g., PDI, SPC check, FMEA-driven inspection point) is required at the start or end of this shift. Drives SAP QM inspection lot creation and MES quality gate activation.',
    `sap_shift_code` STRING COMMENT 'Shift identifier as defined in SAP S/4HANA PP module (Schicht). Used for production order scheduling, capacity planning, and cross-system reconciliation with the ERP source of record.. Valid values are `^[A-Z0-9_]{1,20}$`',
    `scada_zone_code` STRING COMMENT 'Code identifying the SCADA monitoring zone associated with this shift definition. Used to correlate shift-level production data with real-time SCADA telemetry for process control and quality monitoring.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `sequence_number` STRING COMMENT 'Ordinal position of the shift within a 24-hour production cycle at the plant/line (e.g., 1 = first shift, 2 = second shift, 3 = third shift). Used for JIS sequencing and handover management.',
    `shift_status` STRING COMMENT 'Current lifecycle status of the shift definition. Active shifts are available for production order scheduling; inactive or suspended shifts are excluded from planning runs.. Valid values are `active|inactive|suspended|draft`',
    `shift_type` STRING COMMENT 'Classification of the shift by its operational period. Drives workforce planning, premium pay calculations, and production capacity modelling. [ENUM-REF-CANDIDATE: day|afternoon|night|weekend|overtime|shutdown — promote to reference product if additional types are required]. Valid values are `day|afternoon|night|weekend|overtime|shutdown`',
    `sop_date` DATE COMMENT 'Start of Production (SOP) date associated with this shift definition, indicating when the shift schedule becomes operational for a new vehicle programme or model year. Used for production ramp-up planning.',
    `supervisor_role_code` STRING COMMENT 'Code identifying the required supervisor role classification for this shift (e.g., PROD_SUPV, AREA_LEAD). Used for workforce planning and shift handover accountability. References the HR role catalogue in SuccessFactors.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `target_takt_time_seconds` DECIMAL(18,2) COMMENT 'Planned takt time in seconds per unit for this shift, calculated as net available production time divided by customer demand rate. Fundamental metric for line balancing and JIS sequencing in automotive assembly.',
    `target_units_per_shift` STRING COMMENT 'Planned number of vehicle units (or assemblies) to be produced during this shift. Used as the production target for OEE performance ratio calculation and daily production reporting.',
    `timezone_code` STRING COMMENT 'IANA timezone identifier for the plant location where this shift operates (e.g., America/Detroit, Europe/Berlin). Ensures accurate timestamp interpretation for global multi-plant production scheduling and reporting.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this shift definition record was last modified. Used for change tracking, data lineage, and incremental ETL processing in the Databricks Lakehouse silver layer.',
    `workforce_headcount_target` STRING COMMENT 'Planned number of direct production workers required for this shift. Used for workforce planning, labour cost budgeting, and integration with SuccessFactors workforce scheduling.',
    CONSTRAINT pk_shift PRIMARY KEY(`shift_id`)
) COMMENT 'Reference master for production shift definitions at each plant and production line. Captures shift code, shift name (Day, Afternoon, Night, Weekend), planned start and end times, break schedule, planned production hours, and applicable plant and line assignments. Used for production order scheduling, OEE calculation, and workforce planning integration. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` (
    `downtime_event_id` BIGINT COMMENT 'Unique surrogate identifier for each downtime event record in the manufacturing execution system. Primary key for the downtime_event data product.',
    `equipment_registry_id` BIGINT COMMENT 'Reference to the specific machine, robot, AGV (Automated Guided Vehicle), or equipment asset that experienced the downtime. Maps to SAP PM Equipment master record.',
    `org_unit_id` BIGINT COMMENT 'Reference to the maintenance, production, or quality team responsible for resolving the downtime event. Used for accountability tracking and response time analysis.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where the downtime event occurred. Corresponds to the SAP Plant (Werk) organizational unit.',
    `primary_equipment_registry_id` BIGINT COMMENT 'Reference to the specific machine, robot, AGV (Automated Guided Vehicle), or equipment asset that experienced the downtime. Maps to SAP PM Equipment master record.',
    `production_line_id` BIGINT COMMENT 'Reference to the production line (e.g., stamping line, body shop line, paint line, final assembly line) affected by the downtime event. Enables line-level OEE and throughput impact analysis.',
    `production_order_id` BIGINT COMMENT 'Reference to the SAP PP Production Order (Fertigungsauftrag) that was active or impacted at the time of the downtime event. Used to quantify production order impact and schedule deviation.',
    `employee_id` BIGINT COMMENT 'Reference to the employee (operator, technician, or supervisor) who initially reported or logged the downtime event in the MES or SAP system.',
    `work_center_id` BIGINT COMMENT 'Reference to the specific work center or production cell where the downtime event was recorded. Maps to SAP PP Work Center (Arbeitsplatz) or MES work station definition. Critical for OEE (Overall Equipment Effectiveness) analysis at the work center level.',
    `affected_process_area` STRING COMMENT 'The manufacturing process area impacted by the downtime event. Reflects the major shop segments in automotive assembly: stamping (press shop), body shop (BIW - Body in White), paint shop, final assembly, powertrain assembly, chassis, trim, or general assembly. Used for plant-level downtime distribution analysis. [ENUM-REF-CANDIDATE: stamping|body_shop|paint|final_assembly|powertrain|chassis|trim|general_assembly — promote to reference product]',
    `corrective_action_code` STRING COMMENT 'Standardized code from the SAP PM activity type catalog describing the corrective action taken to resolve the downtime event (e.g., part replacement, lubrication, calibration, software reset, tooling adjustment). Supports FMEA corrective action tracking and spare parts consumption analysis.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the downtime event record was first created in the source system (MES, SAP PM, or SCADA). Represents the audit creation time, distinct from start_timestamp which is the actual business event time. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the maintenance_cost_local field (e.g., USD, EUR, MXN, CNY). Required for multi-plant, multi-currency cost consolidation in global automotive manufacturing operations.. Valid values are `^[A-Z]{3}$`',
    `downtime_category` STRING COMMENT 'Primary classification of the downtime event type. mechanical_failure covers equipment breakdowns; tooling_change covers die/tool swap activities; material_shortage covers JIT/JIS supply disruptions; quality_hold covers production stops due to quality issues; scheduled_maintenance covers planned PM activities; changeover covers model or variant changeover activities. Drives OEE availability loss categorization.. Valid values are `mechanical_failure|tooling_change|material_shortage|quality_hold|scheduled_maintenance|changeover`',
    `downtime_type` STRING COMMENT 'Indicates whether the downtime event was planned (scheduled maintenance, changeover, tooling change per production schedule) or unplanned (unexpected breakdown, quality hold, material shortage). Critical for separating planned vs. unplanned OEE availability losses.. Valid values are `planned|unplanned`',
    `duration_minutes` DECIMAL(18,2) COMMENT 'Total elapsed duration of the downtime event in minutes, calculated as the difference between end_timestamp and start_timestamp. Stored as a business field for direct use in OEE (Overall Equipment Effectiveness) availability calculations and SCADA-integrated downtime reporting. Null if the event has not yet ended.',
    `end_timestamp` TIMESTAMP COMMENT 'The exact date and time when the downtime event ended and production resumed, as recorded by the MES or SCADA system. Null if the event is still active. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `escalation_level` STRING COMMENT 'Indicates the management escalation level reached during the downtime event based on duration thresholds or safety/quality triggers. none = resolved at operator level; supervisor = shift supervisor notified; manager = production manager engaged; plant_director = plant director escalation triggered. Supports escalation SLA compliance reporting.. Valid values are `none|supervisor|manager|plant_director`',
    `event_date` DATE COMMENT 'The calendar date on which the downtime event started. Derived from start_timestamp for day-level partitioning, reporting, and trend analysis. Stored as a separate DATE field to support efficient date-range queries and daily OEE dashboard aggregations. Format: yyyy-MM-dd.',
    `event_description` STRING COMMENT 'Free-text narrative description of the downtime event as entered by the operator, technician, or supervisor in the MES or SAP PM notification. Captures contextual details not covered by structured codes, such as observed symptoms, environmental conditions, or operator observations at the time of failure.',
    `event_number` STRING COMMENT 'Externally-known, human-readable business identifier for the downtime event, typically generated by the MES (Manufacturing Execution System) or SAP PM (Plant Maintenance) module. Format: DT-{YYYY}-{NNNNNN}. Used for cross-system referencing and shop floor communication.. Valid values are `^DT-[0-9]{4}-[0-9]{6}$`',
    `event_status` STRING COMMENT 'Current lifecycle status of the downtime event record. open indicates the event is active and unresolved; in_progress indicates a repair or corrective action is underway; resolved indicates the root cause has been addressed; closed indicates the event is fully documented and closed; cancelled indicates the event was logged in error.. Valid values are `open|in_progress|resolved|closed|cancelled`',
    `failure_mode_code` STRING COMMENT 'Standardized code identifying the specific failure mode that caused the downtime event, aligned with the FMEA (Failure Mode and Effects Analysis) failure mode library. Examples: electrical fault, hydraulic leak, sensor failure, conveyor jam. Enables FMEA-driven root cause trending and PPAP (Production Part Approval Process) corrective action tracking.',
    `fault_location_code` STRING COMMENT 'SAP PM object part / location code identifying the specific component or sub-assembly on the equipment where the fault occurred (e.g., spindle, conveyor belt, welding gun tip, paint nozzle). Enables component-level failure frequency analysis and spare parts demand forecasting.',
    `is_quality_hold_triggered` BOOLEAN COMMENT 'Indicates whether the downtime event triggered a quality hold on WIP (Work in Progress) or finished vehicle inventory. True = quality hold was activated; False = no quality hold. Links to SAP QM quality notification and SPC (Statistical Process Control) out-of-control action plans.',
    `is_repeat_failure` BOOLEAN COMMENT 'Indicates whether this downtime event is a recurrence of a previously recorded failure on the same equipment or work center within a defined lookback period (typically 30 days). True = repeat failure; False = first occurrence. Used to identify chronic equipment issues requiring escalated corrective action under IATF 16949 Section 10.2.',
    `is_safety_related` BOOLEAN COMMENT 'Indicates whether the downtime event involved a safety incident, near-miss, or safety-critical equipment failure (e.g., AGV collision, robot safety stop, lockout/tagout activation). True = safety-related; False = non-safety. Triggers mandatory safety reporting and OSHA/DOT compliance escalation workflows.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when the downtime event record was most recently modified in the source system, such as when resolution notes were added, status was updated, or cost data was posted. Used for incremental data pipeline processing and audit trail in the Silver layer. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `maintenance_cost_local` DECIMAL(18,2) COMMENT 'Total direct maintenance cost incurred to resolve the downtime event, including labor, spare parts, and external service costs, expressed in the plants local currency. Sourced from SAP PM actual cost settlement. Used for cost-of-downtime analysis and CapEx vs. OpEx maintenance budget reporting.',
    `model_year` STRING COMMENT 'The vehicle model year (MY) of the production program running on the affected line at the time of the downtime event. Used to correlate downtime patterns with specific model year launches, SOP (Start of Production) ramp-up periods, and EOP (End of Production) transitions.. Valid values are `^[0-9]{4}$`',
    `notification_number` STRING COMMENT 'The SAP Plant Maintenance (PM) notification number (Meldungsnummer) created in SAP S/4HANA to formally record the maintenance request or breakdown notification associated with this downtime event. Enables traceability between the MES downtime record and the SAP PM work order lifecycle.',
    `oee_availability_loss_pct` DECIMAL(18,2) COMMENT 'The percentage of scheduled production time lost due to this downtime event, calculated as (duration_minutes / scheduled_production_time_minutes) × 100. Represents the availability loss component of the OEE (Overall Equipment Effectiveness) metric for the affected work center during the event period. Stored as a business field for direct use in OEE dashboards.',
    `powertrain_type` STRING COMMENT 'The powertrain type of the vehicle being produced at the time of the downtime event. ICE = Internal Combustion Engine, HEV = Hybrid Electric Vehicle, PHEV = Plug-in Hybrid Electric Vehicle, EV = Electric Vehicle, FCEV = Fuel Cell Electric Vehicle. Used to analyze downtime patterns by powertrain technology, particularly relevant for EV/PHEV line ramp-up monitoring.. Valid values are `ICE|HEV|PHEV|EV|FCEV`',
    `production_loss_units` STRING COMMENT 'Number of vehicle units or production units lost due to the downtime event, based on the planned production rate for the affected work center. Used to quantify the production order impact and schedule recovery requirements.',
    `resolution_notes` STRING COMMENT 'Free-text field capturing the maintenance technicians description of the actions taken to resolve the downtime event and restore production. Complements corrective_action_code with detailed narrative. Stored in the Silver layer for use in AI/ML-based predictive maintenance model training.',
    `root_cause_code` STRING COMMENT 'Standardized code identifying the confirmed root cause of the downtime event after investigation, aligned with the SAP PM cause code catalog. Distinct from failure_mode_code which captures the symptom; root_cause_code captures the underlying reason (e.g., inadequate lubrication, worn tooling, incorrect setup, supplier part defect).',
    `scada_alarm_code` STRING COMMENT 'The alarm or fault code generated by the SCADA (Supervisory Control and Data Acquisition) or PLC (Programmable Logic Controller) system at the time the downtime event was triggered. Provides the raw machine-level signal that initiated the downtime record. Used for SCADA-integrated downtime reporting and automated event correlation.',
    `shift_code` STRING COMMENT 'The production shift during which the downtime event occurred (e.g., shift_1 = day shift, shift_2 = afternoon shift, shift_3 = night shift, weekend = weekend shift). Used for shift-level OEE analysis and workforce accountability reporting.. Valid values are `shift_1|shift_2|shift_3|weekend`',
    `spare_parts_consumed` BOOLEAN COMMENT 'Indicates whether spare parts or materials were consumed from inventory to resolve the downtime event. True = spare parts were issued via SAP MM goods issue; False = no parts consumed (e.g., adjustment or reset only). Drives spare parts demand planning and MRP (Material Requirements Planning) replenishment.',
    `start_timestamp` TIMESTAMP COMMENT 'The exact date and time when the downtime event began, as recorded by the MES or SCADA system. This is the principal real-world event time used for duration calculation and shift-level reporting. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `time_to_repair_minutes` DECIMAL(18,2) COMMENT 'Elapsed time in minutes from when the maintenance team began active repair work to when the equipment was restored to operational status. Distinct from duration_minutes (total downtime) and time_to_respond_minutes (response lag). Core component of MTTR (Mean Time to Repair) KPI calculation.',
    `time_to_respond_minutes` DECIMAL(18,2) COMMENT 'Elapsed time in minutes between the downtime event start_timestamp and the time the responsible maintenance or production team acknowledged and began responding to the event. Key metric for maintenance response SLA (Service Level Agreement) compliance and MTTR (Mean Time to Repair) component analysis.',
    `vehicle_model_code` STRING COMMENT 'The internal vehicle model or platform code (e.g., F-150, Silverado, Model 3 equivalent) being produced on the affected line at the time of the downtime event. Enables model-specific downtime analysis and supports PLM (Product Lifecycle Management) integration.',
    `work_order_number` STRING COMMENT 'The SAP PM maintenance work order number (Auftragsnummer) issued to address the downtime event. Distinct from the production order; this is the corrective or preventive maintenance order raised by the maintenance team in SAP PM.',
    CONSTRAINT pk_downtime_event PRIMARY KEY(`downtime_event_id`)
) COMMENT 'Transactional record capturing unplanned and planned production downtime events at the work center or line level. Tracks downtime start and end timestamps, duration (minutes), downtime category (mechanical failure, tooling change, material shortage, quality hold, scheduled maintenance, changeover), affected work center, production order impact, and responsible team. Critical for OEE analysis and SCADA-integrated downtime reporting. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` (
    `production_bom_id` BIGINT COMMENT 'Unique surrogate identifier for the manufacturing Bill of Materials (mBOM) record in the Databricks Silver Layer. Serves as the primary key for this entity.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: BOM Management Report requires each BOM to be tied to a vehicle model to ensure correct component list per model.',
    `bom_id` BIGINT COMMENT 'Reference identifier linking this manufacturing BOM (mBOM) to the originating engineering BOM (eBOM) in Siemens Teamcenter PLM or PTC Windchill. Enables traceability from shop floor execution back to the engineering design intent. The eBOM-to-mBOM transformation is managed via the PLM-SAP integration.',
    `production_ebom_reference_bom_id` BIGINT COMMENT 'Reference identifier linking this manufacturing BOM (mBOM) to the originating engineering BOM (eBOM) in Siemens Teamcenter PLM or PTC Windchill. Enables traceability from shop floor execution back to the engineering design intent. The eBOM-to-mBOM transformation is managed via the PLM-SAP integration.',
    `approval_date` DATE COMMENT 'The date on which this manufacturing BOM received formal approval from the designated authority. Precedes the release_date in the BOM lifecycle workflow. Required for IATF 16949 documented information control.',
    `approved_by` STRING COMMENT 'User ID or employee identifier of the approving authority (e.g., Chief Engineer, Manufacturing Manager) who approved this BOM for production release. Distinct from released_by — approval may be a separate workflow step in Teamcenter PLM or SAP workflow.',
    `apqp_phase` STRING COMMENT 'Current APQP phase associated with this BOMs program lifecycle. Phase 1=Plan and Define, Phase 2=Product Design and Development, Phase 3=Process Design and Development, Phase 4=Product and Process Validation, Phase 5=Launch/Feedback. Tracks BOM maturity relative to the program development gate.. Valid values are `phase_1|phase_2|phase_3|phase_4|phase_5`',
    `assembly_type` STRING COMMENT 'Indicates whether the vehicle is assembled as a Completely Built Unit (CBU), Completely Knocked Down (CKD) kit for overseas assembly, or Semi Knocked Down (SKD) kit. Determines the BOM structure, component packaging, and applicable customs/import regulations for the target market.. Valid values are `CBU|CKD|SKD`',
    `base_quantity` DECIMAL(18,2) COMMENT 'The base quantity of the header material for which the BOM component quantities are defined (e.g., 1 vehicle). All component quantities in the BOM are expressed relative to this base quantity. Corresponds to the SAP BOM header base quantity field.',
    `base_unit_of_measure` STRING COMMENT 'The unit of measure for the BOM base quantity (e.g., EA for each/vehicle, PC for piece, SET for set). Corresponds to the SAP material master base unit of measure. Ensures consistent quantity calculations during MRP explosion and production order processing. [ENUM-REF-CANDIDATE: EA|PC|KG|L|M|M2|M3|SET — 8 candidates stripped; promote to reference product]',
    `bom_alternative` STRING COMMENT 'SAP BOM alternative identifier (e.g., 01, 02) distinguishing multiple valid BOM configurations for the same material and plant. Supports variant BOMs for different production lines or regional configurations (e.g., LHD vs RHD, CKD vs SKD).',
    `bom_description` STRING COMMENT 'Human-readable description of the manufacturing BOM, typically including the vehicle model, model year, plant, and key configuration attributes (e.g., 2025 F-150 XLT 3.5L EcoBoost AWD – Detroit Assembly Plant – MY2025 Production BOM). Used for display in SAP, Teamcenter PLM, and reporting tools.',
    `bom_level` STRING COMMENT 'The maximum depth/level of the BOM hierarchy for this manufacturing BOM (e.g., 1 = single-level, 5 = five levels deep). Used to understand BOM complexity and to control multi-level BOM explosion in MRP and production scheduling.',
    `bom_status` STRING COMMENT 'Current lifecycle state of the manufacturing BOM. draft indicates the BOM is under engineering review. released means it has been authorized for production use. frozen indicates no further changes are permitted (e.g., during active production run). superseded means a newer BOM version has replaced it. obsolete means the BOM is no longer valid.. Valid values are `draft|released|frozen|superseded|obsolete`',
    `bom_type` STRING COMMENT 'Classification of the BOM by its intended use in the manufacturing process. production is the standard mBOM used on the shop floor. phantom represents sub-assemblies that are not stocked. sales is used for variant configuration. spare_parts is for after-sales service. co_product is for by-products in manufacturing.. Valid values are `production|phantom|sales|spare_parts|co_product`',
    `bom_usage` STRING COMMENT 'SAP BOM usage indicator defining the organizational context in which the BOM is applied. production (SAP usage 1) is the standard for shop floor manufacturing. engineering (SAP usage 2) is for design/development. universal (SAP usage 3) applies across all usages. Determines which BOM is selected during MRP and production order processing.. Valid values are `production|engineering|universal|plant_maintenance|sales`',
    `bom_version` STRING COMMENT 'Version identifier of the manufacturing BOM (e.g., v1.0, v2.3). Incremented each time the BOM is revised through an approved Engineering Change Order. Enables version history tracking and rollback capability for quality investigations.',
    `change_reason` STRING COMMENT 'Free-text description of the business reason for creating or modifying this BOM version (e.g., Cost reduction – substitute supplier for part X, Regulatory compliance – CARB Tier 3 emission update, Quality improvement – NVH fix per TSB-2024-001). Required for IATF 16949 change control documentation.',
    `component_count` STRING COMMENT 'Total number of distinct component line items (BOM positions) in this manufacturing BOM. Provides a quick indicator of BOM complexity and is used for completeness validation during BOM release. Does not include phantom sub-assembly components.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this manufacturing BOM record was first created in the source system (SAP PP or Teamcenter PLM). Represents the business event of BOM creation, not the ETL load time. Formatted as yyyy-MM-ddTHH:mm:ss.SSSXXX per enterprise data standards.',
    `eco_number` STRING COMMENT 'The Engineering Change Order (ECO) number that authorized the creation or last modification of this manufacturing BOM. Provides full traceability from the shop floor BOM back to the formal engineering change management process in Teamcenter PLM. Required for IATF 16949 change control compliance.',
    `effectivity_end_date` DATE COMMENT 'The date after which this manufacturing BOM version is no longer valid for production use. Corresponds to the SAP BOM Valid To date. Null indicates the BOM is open-ended with no planned expiry. Used to manage BOM transitions during model year changeovers and End of Production (EOP).',
    `effectivity_start_date` DATE COMMENT 'The date from which this manufacturing BOM version becomes effective and valid for production use. Corresponds to the SAP BOM Valid From date. Used for date-effective BOM explosion in MRP and production order creation. Aligns with Start of Production (SOP) planning.',
    `eop_date` DATE COMMENT 'The planned or actual End of Production (EOP) date for the vehicle program associated with this BOM. Marks the milestone when serial production of this vehicle configuration ceases. Used for last-time-buy planning, spare parts provisioning, and regulatory compliance archiving.',
    `homologation_status` STRING COMMENT 'Status of the regulatory homologation (type approval) for the vehicle configuration defined by this BOM in the target regulatory market. approved is required before vehicles built to this BOM can be legally sold in the target market. Managed through the Regulatory Compliance and Homologation process.. Valid values are `pending|in_progress|approved|rejected|expired`',
    `is_configurable` BOOLEAN COMMENT 'Indicates whether this BOM uses SAP Variant Configuration (VC) to support multiple vehicle variants from a single configurable BOM structure. True = configurable BOM with characteristic-based component selection. False = fixed BOM for a single specific vehicle configuration.',
    `is_phantom_assembly` BOOLEAN COMMENT 'Indicates whether the header material of this BOM is a phantom assembly — a logical grouping of components that is not physically stocked or produced as a discrete unit. Phantom assemblies are exploded through during MRP and production order processing. Common for sub-assemblies in JIS manufacturing.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this manufacturing BOM record in the source system. Used to detect changes during incremental data loads into the Databricks Silver Layer and to support BOM change history auditing required by IATF 16949.',
    `material_number` STRING COMMENT 'SAP material number of the header material (finished vehicle or major assembly) for which this BOM is defined. This is the top-level material in the BOM hierarchy, corresponding to the vehicle configuration or assembly unit.',
    `model_year` STRING COMMENT 'The four-digit automotive Model Year (MY) for which this manufacturing BOM is valid (e.g., 2025). Determines the applicable regulatory standards, feature content, and homologation requirements. Aligns with NHTSA and EPA model year definitions.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the specific manufacturing facility where this mBOM is used for production (e.g., P001 for Detroit Assembly, P002 for Osaka Plant). Determines plant-specific routing, work centers, and local regulatory compliance requirements.',
    `powertrain_type` STRING COMMENT 'Classification of the vehicle powertrain technology for which this BOM is defined. ICE = Internal Combustion Engine, HEV = Hybrid Electric Vehicle, PHEV = Plug-in Hybrid Electric Vehicle, BEV = Battery Electric Vehicle, FCEV = Fuel Cell Electric Vehicle. Determines applicable emissions regulations (EPA, CARB, WLTP) and BOM component sets.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `ppap_status` STRING COMMENT 'Status of the Production Part Approval Process (PPAP) for the components in this BOM. PPAP is the AIAG/IATF 16949 process that verifies supplier components meet design and specification requirements before production launch. approved is required before the BOM can be released to production.. Valid values are `not_required|pending|submitted|approved|rejected`',
    `predecessor_bom_number` STRING COMMENT 'BOM number of the previous manufacturing BOM version that this BOM supersedes. Enables backward navigation in the BOM version chain for change impact analysis and quality investigations. Null for the initial BOM version.',
    `production_line_code` STRING COMMENT 'Code identifying the specific production line or assembly line within the plant for which this BOM is configured (e.g., LINE-A, TRIM-CHASSIS-1). Used in Apriso/Dassault MES for shop floor routing and JIS (Just-in-Sequence) scheduling.',
    `regulatory_market_code` STRING COMMENT 'Code identifying the target regulatory market for which this BOM is homologated (e.g., US-FEDERAL, US-CARB, EU-EURO6, JP-JC08, CN-CHINA6). Determines applicable emissions standards (EPA, CARB, Euro 6, WLTP), safety regulations (NHTSA FMVSS, UNECE), and CAFE compliance requirements.',
    `release_date` DATE COMMENT 'The date on which this manufacturing BOM was formally released to production (status changed to released). Marks the point at which the BOM is authorized for use in production orders and MRP planning. Corresponds to the SAP BOM release date.',
    `released_by` STRING COMMENT 'User ID or employee identifier of the manufacturing engineer or release authority who formally released this BOM to production in SAP PP or Teamcenter PLM. Required for audit trail and change control compliance under IATF 16949.',
    `revision_level` STRING COMMENT 'Alphanumeric revision level of the BOM (e.g., A, B, C or 01, 02). Used in conjunction with bom_version to track incremental changes within a version. Aligns with SAP BOM revision level and Teamcenter PLM revision management.',
    `routing_number` STRING COMMENT 'SAP routing number linking this manufacturing BOM to the associated production routing (sequence of operations, work centers, and standard times). The BOM and routing together define the complete manufacturing recipe for the vehicle. Corresponds to SAP PP routing header (CA01).',
    `sop_date` DATE COMMENT 'The planned or actual Start of Production (SOP) date for the vehicle program associated with this BOM. Marks the milestone when serial production begins using this BOM configuration. Critical for program management, supplier readiness, and PPAP completion tracking.',
    `superseded_by_bom_number` STRING COMMENT 'BOM number of the newer manufacturing BOM that has replaced this one (populated when bom_status = superseded). Enables forward navigation in the BOM version chain for traceability and historical analysis. Null when this is the current active BOM.',
    `vehicle_configuration_code` STRING COMMENT 'Code identifying the specific vehicle configuration (variant) for which this BOM is defined, including body style, drivetrain, trim level, and market variant (e.g., SUV-AWD-PREMIUM-NA). Used in SAP Variant Configuration (VC) to select the correct BOM components for a specific vehicle order.',
    `vehicle_model_code` STRING COMMENT 'Internal OEM code identifying the vehicle model (nameplate) for which this mBOM is defined (e.g., F150, RAV4, MODEL3). Used to associate the BOM with the correct vehicle program in PLM and SAP.',
    CONSTRAINT pk_production_bom PRIMARY KEY(`production_bom_id`)
) COMMENT 'Manufacturing Bill of Materials (BOM) record representing the production-level BOM used on the shop floor for a specific vehicle configuration and model year. Distinct from the engineering BOM (eBOM) in the engineering domain — this is the manufacturing BOM (mBOM) as released to production. Captures BOM header (vehicle model, MY, plant, effectivity dates), BOM status, and reference to the engineering change order that authorized it. Managed via SAP PP and Teamcenter PLM BOM transfer. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_bom_component` (
    `manufacturing_bom_component_id` BIGINT COMMENT 'Primary key for local manufacturing_bom_component reference',
    `engineering_bom_component_id` BIGINT COMMENT 'FK reference to SSOT engineering.engineering_bom_component',
    CONSTRAINT pk_manufacturing_bom_component PRIMARY KEY(`manufacturing_bom_component_id`)
) COMMENT 'Reference to SSOT owner engineering.engineering_bom_component. Line-item record within a manufacturing BOM representing a single component or sub-assembly required to build a vehicle. Captures component part number, description, quantity per vehicle, unit of measure, installation work center, installation sequence, alternative part references, effectivity start/end dates, and scrap factor. Supports JIT/JIS material call-offs and shop floor assembly instructions. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` (
    `material_consumption_id` BIGINT COMMENT 'Unique surrogate identifier for each material consumption (goods issue) transaction record on the shop floor. Primary key of this table.',
    `employee_id` BIGINT COMMENT 'Employee ID of the shop floor operator or MES user who confirmed or posted the material consumption. Used for accountability, audit trail, and operator-level quality traceability per IATF 16949.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: Material consumption reports must reference the specific inbound part receipt to calculate usage rates and supplier performance metrics.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where the material consumption occurred. Aligns with SAP organizational unit for plant.',
    `production_order_id` BIGINT COMMENT 'Reference to the production order against which this material was consumed. Links consumption to the manufacturing work order in SAP PP.',
    `sku_master_id` BIGINT COMMENT 'Reference to the material master record for the consumed part or component. Corresponds to the SAP Material Master (MM) object.',
    `storage_location_id` BIGINT COMMENT 'Reference to the storage location (bin, supermarket, line-side buffer) from which the material was issued for consumption.',
    `work_center_id` BIGINT COMMENT 'Reference to the work center (assembly station, stamping cell, paint booth, etc.) on the shop floor where the material was consumed.',
    `assembly_station_code` STRING COMMENT 'Code identifying the specific assembly station or line position (JIS – Just-in-Sequence station) where the material was consumed. More granular than work center; used for shop floor traceability.',
    `batch_number` STRING COMMENT 'Supplier or internal batch/lot number of the consumed material. Critical for traceability, recall management, and IATF 16949 batch traceability requirements. Nullable for non-batch-managed materials.',
    `bom_item_number` STRING COMMENT 'The BOM line item number identifying the specific component position within the production BOM. Links the consumption record back to the engineering BOM structure in Siemens Teamcenter PLM.',
    `bom_version` STRING COMMENT 'Version or revision of the BOM used at the time of consumption. Supports engineering change management and ensures consumption is reconciled against the correct BOM revision.',
    `consumption_status` STRING COMMENT 'Current lifecycle status of the material consumption record. posted = goods issue confirmed in SAP; reversed = goods issue reversed (movement type 262); blocked = held for quality review; pending = awaiting MES confirmation.. Valid values are `posted|reversed|blocked|pending`',
    `consumption_timestamp` TIMESTAMP COMMENT 'The precise date and time when the material was physically issued from stock and consumed at the work center on the shop floor. This is the principal business event timestamp for this transaction.',
    `cost_variance_amount` DECIMAL(18,2) COMMENT 'Monetary value of the consumption variance (actual cost minus planned cost) in plant currency. Positive = cost overrun; negative = cost saving. Key metric for production cost variance reporting in SAP CO.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this material consumption record was first created in the source system (SAP MM or MES). Audit trail field for data lineage and Silver layer ingestion tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the material cost amount (e.g., USD, EUR, JPY). Supports multi-currency manufacturing operations across global plants.. Valid values are `^[A-Z]{3}$`',
    `goods_movement_number` STRING COMMENT 'Externally visible SAP material document number generated when the goods issue (movement type 261) is posted. Serves as the business-facing transaction identifier traceable in SAP MM.',
    `goods_movement_type` STRING COMMENT 'SAP movement type code indicating the nature of the goods movement (e.g., 261 = goods issue to production order, 262 = reversal, 291 = goods issue to cost center). Drives inventory and cost accounting postings.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this material consumption record in the source system. Used for incremental data load detection and audit trail in the Databricks Silver layer.',
    `material_cost_amount` DECIMAL(18,2) COMMENT 'Standard cost value of the consumed material quantity at the time of goods issue, expressed in the plant currency. Calculated as quantity consumed × standard price from SAP Material Master. Feeds production cost accounting and variance reporting.',
    `mes_transaction_code` STRING COMMENT 'Unique transaction identifier from the Apriso/Dassault MES system that triggered or confirmed this material consumption event. Enables cross-system reconciliation between MES shop floor execution and SAP MM goods movements.',
    `model_year` STRING COMMENT 'The model year (MY) of the vehicle being assembled (e.g., 2025). Used for model-year-level consumption analysis, BOM alignment, and regulatory compliance reporting.. Valid values are `^[0-9]{4}$`',
    `operation_number` STRING COMMENT 'The routing operation number within the production order at which the material was consumed (e.g., operation 0010 = body shop, 0020 = paint, 0030 = final assembly). Enables process-step-level consumption analysis.',
    `original_goods_movement_number` STRING COMMENT 'Reference to the original SAP material document number that this record reverses. Populated only when reversal_indicator is True. Enables audit trail for reversed consumption transactions.',
    `planned_quantity` DECIMAL(18,2) COMMENT 'The planned quantity of this material as specified in the Bill of Materials (BOM) for the production order. Used to calculate consumption variance against actual quantity consumed.',
    `posting_date` DATE COMMENT 'The accounting posting date for the goods issue in SAP, which may differ from the physical consumption timestamp. Used for period-end cost accounting and production variance reporting.',
    `powertrain_type` STRING COMMENT 'Powertrain type of the vehicle being assembled: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), EV (Electric Vehicle), FCEV (Fuel Cell Electric Vehicle). Drives BOM variant selection and consumption expectations.. Valid values are `ICE|HEV|PHEV|EV|FCEV`',
    `production_line_code` STRING COMMENT 'Code identifying the production line (e.g., LINE-A, TRIM-2, PAINT-EAST) where the material was consumed. Used for line-level consumption analysis and capacity planning.',
    `quality_inspection_lot` STRING COMMENT 'SAP QM inspection lot number associated with the consumed material batch, if the material is subject to incoming or in-process quality inspection. Links consumption to quality results for IATF 16949 traceability.',
    `quantity_consumed` DECIMAL(18,2) COMMENT 'Actual quantity of the material consumed (goods issued) against the production order. Expressed in the base unit of measure of the material. Core quantitative fact for this transaction.',
    `quantity_variance` DECIMAL(18,2) COMMENT 'Difference between actual quantity consumed and planned BOM quantity (actual minus planned). Positive value indicates over-consumption; negative indicates under-consumption. Key input for production variance reporting and cost accounting.',
    `reversal_indicator` BOOLEAN COMMENT 'Flag indicating whether this consumption record is a reversal (cancellation) of a previously posted goods issue. True = this is a reversal document; False = original consumption posting.',
    `scrap_indicator` BOOLEAN COMMENT 'Flag indicating whether the consumed material was scrapped (True) rather than incorporated into the vehicle assembly. Scrap consumption is tracked separately for waste reporting, IATF 16949 scrap analysis, and environmental compliance.',
    `scrap_reason_code` STRING COMMENT 'Coded reason for material scrap when scrap_indicator is True (e.g., DAMAGE, DEFECT, WRONG_PART, PROCESS_LOSS). Used for scrap root cause analysis and PPM defect rate reporting. [ENUM-REF-CANDIDATE: DAMAGE|DEFECT|WRONG_PART|PROCESS_LOSS|HANDLING_ERROR|SUPPLIER_DEFECT|OTHER — promote to reference product]',
    `serial_number` STRING COMMENT 'Individual serial number of the consumed component where serial number management is active (e.g., ECU, battery module, transmission). Enables unit-level traceability for safety-critical parts. Nullable for non-serialized materials.',
    `shift_code` STRING COMMENT 'Production shift during which the material was consumed (DAY, AFTERNOON, NIGHT). Used for shift-level consumption analysis, variance trending, and workforce productivity reporting.. Valid values are `DAY|AFTERNOON|NIGHT`',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this consumption record originated (SAP_MM = SAP S/4HANA MM goods movement, MES_APRISO = Apriso/Dassault MES, SAP_PP = SAP Production Planning, MANUAL = manual entry). Supports data lineage in the lakehouse.. Valid values are `SAP_MM|MES_APRISO|SAP_PP|MANUAL`',
    `supplier_number` STRING COMMENT 'SAP vendor/supplier number of the supplier who provided the consumed material. Used for supplier-level consumption analysis, PPAP traceability, and supply chain variance reporting.',
    `unit_of_measure` STRING COMMENT 'Base unit of measure for the consumed quantity (e.g., EA = each, KG = kilogram, L = litre, M = metre, PC = piece). Aligns with SAP base UoM from Material Master. [ENUM-REF-CANDIDATE: EA|KG|L|M|M2|M3|PC|SET|ROL|BOX — 10 candidates stripped; promote to reference product]',
    `variance_percentage` DECIMAL(18,2) COMMENT 'Quantity variance expressed as a percentage of the planned BOM quantity ((actual - planned) / planned × 100). Used for threshold-based alerting and PPM (Parts Per Million) defect rate analysis.',
    `vehicle_model_code` STRING COMMENT 'Internal OEM code identifying the vehicle model or platform being assembled (e.g., F150, CAMRY-HEV, SILVERADO-EV). Used for model-level consumption aggregation and BOM variance analysis.',
    `vehicle_vin` STRING COMMENT 'The 17-character Vehicle Identification Number (VIN) of the vehicle being assembled when the material was consumed. Enables vehicle-level build traceability and recall management. Nullable for non-vehicle-specific consumption (e.g., consumables).. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `wip_order_sequence` STRING COMMENT 'Sequential position of this consumption event within the production orders WIP (Work in Progress) processing sequence. Used for JIS (Just-in-Sequence) ordering analysis and shop floor flow traceability.',
    CONSTRAINT pk_material_consumption PRIMARY KEY(`material_consumption_id`)
) COMMENT 'Transactional record capturing actual material consumption (goods issue) against a production order on the shop floor. Tracks consumed part number, quantity consumed, unit of measure, consumption timestamp, work center, production order reference, storage location, batch number, and variance from planned BOM quantity. Feeds SAP MM goods movement and cost accounting for production variance reporting. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` (
    `rework_order_id` BIGINT COMMENT 'Unique surrogate identifier for the rework order record in the Databricks Silver Layer. Primary key for this entity.',
    `defect_record_id` BIGINT COMMENT 'Reference to the quality defect record in the quality domain that triggered this rework order. Links rework traceability to the originating inspection finding or defect notification.',
    `employee_id` BIGINT COMMENT 'Reference to the workforce employee or technician assigned to perform the rework operation. Links to the workforce domain for skill and certification validation.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where the rework operation is being executed. Aligns with SAP Plant (Werk) organizational unit.',
    `production_order_id` BIGINT COMMENT 'Reference to the originating production order from which this rework order was raised. Links the rework event back to the scheduled manufacturing work order in SAP PP or MES.',
    `work_center_id` BIGINT COMMENT 'Reference to the work center or repair station assigned to execute the rework operation. Corresponds to SAP PP Work Center or MES work station definition.',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when the rework operation was completed and the unit was released for re-inspection or returned to the production line. Recorded by MES upon order closure.',
    `actual_rework_hours` DECIMAL(18,2) COMMENT 'Actual labor hours consumed to complete the rework operation, recorded upon order completion in MES or SAP PM. Compared against planned hours for efficiency analysis and cost variance reporting.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the rework technician began executing the rework operation, as recorded by MES shop floor data collection or operator confirmation.',
    `assembly_stage_code` STRING COMMENT 'Code representing the specific assembly stage or station within the production line where the nonconformance was detected (e.g., body framing, paint primer, trim line, chassis marriage). Supports JIS (Just-in-Sequence) traceability.',
    `bom_component_number` STRING COMMENT 'The BOM (Bill of Materials) component or part number of the specific sub-assembly or component requiring rework. References the engineering BOM managed in Siemens Teamcenter or SAP MM.',
    `corrective_action_reference` STRING COMMENT 'Reference number or identifier of the corrective action (CAR) or 8D problem-solving report raised in response to this rework event. Links the rework order to the formal quality improvement process.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the rework order record was first created in the source system (MES or SAP QM). Audit trail field for data lineage and compliance purposes.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary cost fields on this rework order (rework_labor_cost, rework_material_cost). Typically the plants local operating currency (e.g., USD, EUR, MXN).. Valid values are `^[A-Z]{3}$`',
    `defect_code` STRING COMMENT 'Standardized defect classification code identifying the type of nonconformance that triggered the rework order. Aligns with the plant defect code catalogue maintained in SAP QM or MES quality module.. Valid values are `^[A-Z0-9]{2,10}$`',
    `defect_description` STRING COMMENT 'Free-text narrative description of the defect or nonconformance identified during in-process quality inspection that initiated this rework order. Captured by the quality inspector or MES operator.',
    `defect_location_code` STRING COMMENT 'Standardized code identifying the physical location or zone on the vehicle or sub-assembly where the defect was found (e.g., body zone, paint zone, chassis area). Used for spatial defect analysis and NVH (Noise Vibration Harshness) correlation.',
    `detection_method_code` STRING COMMENT 'Code indicating the method by which the defect was detected prior to rework order creation (e.g., visual inspection, automated gauge check, functional test, quality audit, customer feedback). Supports FMEA (Failure Mode and Effects Analysis) detection ranking analysis.. Valid values are `visual_inspection|automated_gauge|functional_test|audit_check|customer_feedback`',
    `detection_timestamp` TIMESTAMP COMMENT 'Date and time when the nonconformance was originally detected during in-process quality inspection, triggering the creation of this rework order. The principal business event timestamp for this transaction.',
    `disposition_code` STRING COMMENT 'Final disposition decision for the nonconforming unit after rework evaluation. Repaired indicates successful correction; scrapped indicates the unit is unrecoverable; concession (use-as-is) indicates acceptance of the nonconformance with documented deviation; return to supplier applies to purchased components.. Valid values are `repaired|scrapped|concession|use_as_is|return_to_supplier`',
    `inspection_point_code` STRING COMMENT 'Code identifying the specific quality inspection checkpoint or gate (e.g., body-in-white audit, paint final audit, end-of-line check) at which the defect was detected and the rework order was initiated.',
    `is_regulatory_hold` BOOLEAN COMMENT 'Indicates whether the vehicle or sub-assembly is placed on a regulatory hold pending rework completion and re-inspection. A regulatory hold prevents the unit from advancing to the next production stage or shipping.',
    `is_safety_related` BOOLEAN COMMENT 'Indicates whether the defect triggering this rework order is classified as safety-critical, requiring escalation per NHTSA, DOT, or internal safety reporting protocols. Safety-related rework orders may trigger FMEA review and potential field action assessment.',
    `line_stoppage_flag` BOOLEAN COMMENT 'Indicates whether this rework event caused a production line stoppage (Andon pull or line stop). Used for OEE (Overall Equipment Effectiveness) impact analysis and production downtime reporting.',
    `model_year` STRING COMMENT 'The vehicle model year (MY) of the unit undergoing rework. Used for regulatory compliance reporting, warranty analysis, and production quality trending by model year.',
    `planned_end_timestamp` TIMESTAMP COMMENT 'Scheduled date and time when the rework operation is planned to be completed. Used to calculate planned rework cycle time and assess impact on downstream production sequencing.',
    `planned_rework_hours` DECIMAL(18,2) COMMENT 'Estimated labor hours planned to complete the rework operation, as defined in the rework routing or standard repair time (SRT) catalogue. Used for capacity planning and cost estimation.',
    `planned_start_timestamp` TIMESTAMP COMMENT 'Scheduled date and time when the rework operation is planned to begin, as determined by the MES scheduler or production planner. Used for shop floor capacity planning and JIS (Just-in-Sequence) scheduling.',
    `priority_level` STRING COMMENT 'Business priority assigned to the rework order to drive scheduling and resource allocation on the shop floor. Critical priority typically indicates a safety-related or regulatory nonconformance requiring immediate resolution.. Valid values are `critical|high|medium|low`',
    `production_line_code` STRING COMMENT 'Code identifying the specific production line (e.g., stamping, body shop, paint, final assembly) where the defect was originally detected and the rework order was raised.',
    `re_inspection_required` BOOLEAN COMMENT 'Indicates whether a formal re-inspection is required after rework completion before the unit can be released to the next production stage or shipped. Mandatory for safety-related or regulatory nonconformances.',
    `re_inspection_result` STRING COMMENT 'Outcome of the quality re-inspection performed after rework completion. Pass indicates the unit meets specification; fail triggers a secondary rework or scrap decision; conditional pass indicates acceptance with documented deviation.. Valid values are `pass|fail|conditional_pass|pending`',
    `rework_attempt_count` STRING COMMENT 'Number of rework attempts made on this unit or component for the same defect. Multiple rework attempts on the same unit indicate a chronic quality issue and may trigger escalation or scrap decision per quality policy.',
    `rework_instruction_reference` STRING COMMENT 'Document number or reference to the approved rework instruction, repair standard, or Technical Service Bulletin (TSB) that governs the rework procedure. Ensures traceability to authorized repair methods.',
    `rework_labor_cost` DECIMAL(18,2) COMMENT 'Total internal labor cost incurred for the rework operation, calculated from actual rework hours and the applicable labor rate. Expressed in the plants operating currency. Used for quality cost (Cost of Poor Quality - COPQ) reporting.',
    `rework_material_cost` DECIMAL(18,2) COMMENT 'Cost of replacement parts and materials consumed during the rework operation. Sourced from SAP MM goods issue postings against the rework order. Contributes to total Cost of Poor Quality (COPQ) calculation.',
    `rework_order_number` STRING COMMENT 'Externally-known, human-readable business identifier for the rework order, typically generated by the MES (Manufacturing Execution System) or SAP QM module. Format: RWK-{PlantCode}-{Year}-{Sequence}.. Valid values are `^RWK-[A-Z]{3}-[0-9]{4}-[0-9]{6}$`',
    `rework_order_status` STRING COMMENT 'Current lifecycle status of the rework order within the shop floor execution workflow. Tracks progression from creation through completion or cancellation as managed in MES or SAP QM.. Valid values are `open|in_progress|on_hold|completed|cancelled`',
    `rework_type` STRING COMMENT 'Classification of the rework operation method. Inline repair is performed on the moving assembly line; offline rework removes the unit from the line; teardown involves partial or full disassembly; subassembly rework targets a component before vehicle integration; cosmetic repair addresses surface or finish defects. [ENUM-REF-CANDIDATE: inline_repair|offline_rework|teardown|subassembly_rework|cosmetic_repair|field_return_rework — promote to reference product]. Valid values are `inline_repair|offline_rework|teardown|subassembly_rework|cosmetic_repair`',
    `root_cause_code` STRING COMMENT 'Standardized code classifying the root cause of the defect as determined through root cause analysis (e.g., 5-Why, Ishikawa). Populated upon rework completion. Supports FMEA (Failure Mode and Effects Analysis) and SPC (Statistical Process Control) improvement actions.',
    `scrap_quantity` STRING COMMENT 'Number of components or sub-assemblies scrapped as a result of this rework order where repair was not feasible. Used for PPM (Parts Per Million) defect rate calculation and scrap cost reporting.',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this rework order record was sourced (e.g., SAP QM, Apriso/Dassault MES, or manual entry). Supports data lineage and Silver Layer ingestion traceability.. Valid values are `SAP_QM|MES_APRISO|MES_DASSAULT|MANUAL`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when the rework order record was last modified in the source system. Supports incremental data loading in the Databricks Silver Layer and audit trail requirements.',
    `vehicle_model_code` STRING COMMENT 'Internal product/model code identifying the vehicle nameplate or platform (e.g., truck, SUV, EV, HEV) associated with the rework order. Aligns with PLM product structure in Siemens Teamcenter.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number (VIN) of the vehicle or vehicle body on which rework is being performed. Nullable for sub-assembly rework not yet associated with a VIN. Conforms to ISO 3779 standard.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_rework_order PRIMARY KEY(`rework_order_id`)
) COMMENT 'Transactional record for rework or repair operations initiated on a vehicle or sub-assembly that failed an in-process quality check. Captures rework order number, originating production order, VIN reference, defect description, rework type (in-line repair, offline rework, teardown), assigned work center, planned and actual rework hours, rework status, and disposition (repaired, scrapped, concession). Integrates with quality domain defect records. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` (
    `production_confirmation_id` BIGINT COMMENT 'Unique surrogate identifier for the production confirmation record in the Databricks Silver Layer. Primary key for this entity. Entity Role: TRANSACTION_HEADER — represents a discrete business event (completion of a production order or partial operation) with a clear lifecycle.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where this production confirmation was posted. Enables plant-level production output reporting, capacity utilization analysis, and multi-plant benchmarking.',
    `employee_id` BIGINT COMMENT 'Reference to the production operator (employee/personnel number) who posted or was responsible for this confirmation. Used for traceability, quality accountability, and workforce productivity analysis. Maps to SAP HR personnel number (PERNR) or MES operator badge ID.',
    `production_operator_employee_id` BIGINT COMMENT 'Reference to the production operator (employee/personnel number) who posted or was responsible for this confirmation. Used for traceability, quality accountability, and workforce productivity analysis. Maps to SAP HR personnel number (PERNR) or MES operator badge ID.',
    `reversed_confirmation_production_confirmation_id` BIGINT COMMENT 'Reference to the original production confirmation record that this entry reverses. Populated only when reversal_indicator is True. Enables audit trail reconstruction and net quantity calculation when reversals are present. Self-referencing within the production_confirmation product.',
    `shift_id` BIGINT COMMENT 'Reference to the production shift during which this confirmation was recorded. Enables shift-level production output analysis, yield comparison across shifts, and workforce productivity reporting.',
    `work_center_id` BIGINT COMMENT 'Reference to the work center (SAP ARBPL) where the confirmed operation was executed. Work centers represent physical production resources such as stamping presses, welding stations, paint booths, or assembly lines. Used for capacity reporting and OEE (Overall Equipment Effectiveness) analysis.',
    `activity_type_code` STRING COMMENT 'SAP CO activity type (LSTAR) used to record the confirmed actual activities (setup, machine, labor) against the production order. Drives cost settlement rates and actual cost calculation in SAP CO-PC (Product Costing). Required for standard vs. actual cost variance analysis.. Valid values are `^[A-Z0-9]{4,6}$`',
    `assembly_stage` STRING COMMENT 'The manufacturing assembly stage at which this confirmation was recorded. Reflects the major production process area within the vehicle manufacturing flow. Used for stage-level throughput analysis, WIP (Work in Progress) tracking, and process bottleneck identification. [ENUM-REF-CANDIDATE: stamping|body_shop|paint|final_assembly|powertrain|chassis|trim — promote to reference product]',
    `base_unit_of_measure` STRING COMMENT 'The unit of measure in which yield, scrap, and rework quantities are expressed. Typically EA (Each) for vehicles and assemblies, PC (Piece) for components, KG for weight-based materials. Maps to SAP MM/PP base unit of measure (MEINS). Required for correct inventory posting and quantity reconciliation. [ENUM-REF-CANDIDATE: EA|PC|KG|L|M|SET|VH — 7 candidates stripped; promote to reference product]',
    `batch_number` STRING COMMENT 'SAP batch number (CHARG) assigned to the confirmed production output. Used for batch-managed materials to enable full forward and backward traceability of components and finished vehicles. Critical for recall management, warranty analysis, and regulatory compliance with NHTSA traceability requirements.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `confirmation_entry_mode` STRING COMMENT 'Method by which this production confirmation was entered into SAP PP. manual = entered by operator via CO11N; automatic = system-generated via PP-PI or SCADA integration; mes_interface = posted via Apriso/Dassault MES interface; backflush = automatic backflush confirmation triggered by goods issue. Used for data quality auditing and process automation tracking.. Valid values are `manual|automatic|mes_interface|backflush`',
    `confirmation_number` STRING COMMENT 'Externally-known alphanumeric confirmation number assigned by SAP PP (CO11N) at the time of posting. This is the business-facing identifier used in shop floor reporting, MES integration, and order settlement reconciliation. Maps to SAP field RUECK (Confirmation Number).. Valid values are `^[A-Z0-9]{10,20}$`',
    `confirmation_status` STRING COMMENT 'Current lifecycle status of the production confirmation record. created = confirmation entered but not yet posted; posted = successfully posted to SAP PP and inventory updated; reversed = confirmation reversed via CO13; cancelled = voided before posting; partial = partial quantity confirmed, order still open; final = final confirmation closing the production order.. Valid values are `created|posted|reversed|cancelled|partial|final`',
    `confirmation_timestamp` TIMESTAMP COMMENT 'The principal real-world event timestamp recording when the production operation or order was confirmed as complete on the shop floor. This is the business event time (not the system posting time) and represents the actual completion moment. Maps to SAP PP fields BUDAT (posting date) + ISDD/ISDZ (actual execution date/time). Used for takt time analysis, shift output reporting, and production scheduling.',
    `confirmation_type` STRING COMMENT 'Classification of the confirmation indicating whether it is a partial confirmation (interim progress), final confirmation (order completion), automatic system-generated confirmation, milestone-based confirmation, or a reversal entry. Determines downstream SAP PP processing logic including order closure and goods receipt.. Valid values are `partial|final|automatic|milestone|reversal`',
    `cost_center_code` STRING COMMENT 'SAP CO cost center (KOSTL) associated with the work center where this confirmation was posted. Used for actual cost allocation, activity-based costing, and manufacturing cost variance reporting. Enables EBITDA (Earnings Before Interest, Taxes, Depreciation, and Amortization) analysis at the plant and cost center level.. Valid values are `^[A-Z0-9]{4,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this production confirmation record was first created in the source system (SAP PP or MES). Represents the system audit creation time, distinct from the confirmation_timestamp (business event time). Used for data lineage, audit trail, and SLA monitoring of confirmation posting latency.',
    `downtime_duration_min` DECIMAL(18,2) COMMENT 'Total unplanned downtime duration recorded during this production confirmation period, in minutes. Captured from SCADA/PLC systems or MES downtime tracking. Used for OEE (Overall Equipment Effectiveness) availability calculation, maintenance planning, and production loss analysis.',
    `downtime_reason_code` STRING COMMENT 'Coded reason for any downtime recorded during this confirmation period. Maps to the plants downtime reason catalog (e.g., MECH = Mechanical Failure, MATL = Material Shortage, QUAL = Quality Hold, CHNG = Changeover). Used for root cause analysis, maintenance prioritization, and production loss reporting.. Valid values are `^[A-Z0-9]{2,10}$`',
    `final_confirmation_flag` BOOLEAN COMMENT 'Indicates whether this confirmation is the final confirmation for the production order (SAP PP IEDD — Final Confirmation Indicator). When True, SAP PP automatically closes the production order, triggers goods receipt for the finished product, and initiates order settlement to CO (Controlling). Critical for order lifecycle management and inventory accuracy.',
    `goods_receipt_posted_flag` BOOLEAN COMMENT 'Indicates whether the automatic goods receipt (GR) to inventory has been successfully posted as a result of this production confirmation. True = inventory has been updated with the confirmed yield quantity. Used for inventory reconciliation and to identify confirmations where GR posting failed or is pending.',
    `labor_time_actual_min` DECIMAL(18,2) COMMENT 'Actual direct labor time consumed for this production operation, recorded in minutes. Maps to SAP PP activity type for labor (ISRLA — Actual Labor Time). Used for labor cost settlement to the production order, workforce productivity analysis, and standard vs. actual cost variance reporting.',
    `labor_time_planned_min` DECIMAL(18,2) COMMENT 'Planned direct labor time for this operation as defined in the SAP PP routing, recorded in minutes. Baseline for labor efficiency variance analysis and standard cost calculation.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this production confirmation record was last modified in the source system. Tracks reversals, corrections, and status updates. Used for incremental data loading in the Databricks Silver Layer pipeline and change data capture (CDC) processing.',
    `machine_time_actual_min` DECIMAL(18,2) COMMENT 'Actual machine runtime consumed for this production operation, recorded in minutes. Maps to SAP PP activity type for machine time (ISRÜT — Actual Machine Time). Core input for OEE calculation, takt time variance analysis, and capacity utilization reporting. Compared against planned machine time from the routing to identify bottlenecks.',
    `machine_time_planned_min` DECIMAL(18,2) COMMENT 'Planned machine time for this operation as defined in the SAP PP routing, recorded in minutes. Baseline for actual vs. planned machine time variance analysis and takt time adherence reporting.',
    `material_number` STRING COMMENT 'SAP material number (MATNR) of the finished or semi-finished product being confirmed. Identifies the vehicle model, sub-assembly, or component produced in this confirmation. Essential for inventory goods receipt posting and BOM (Bill of Materials) reconciliation.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `mes_confirmation_reference` STRING COMMENT 'The confirmation or transaction reference number from the Apriso/Dassault MES system that corresponds to this SAP PP production confirmation. Enables cross-system traceability between the MES shop floor execution record and the SAP ERP confirmation posting. Critical for audit trails and discrepancy resolution.. Valid values are `^[A-Z0-9-]{1,50}$`',
    `model_year` STRING COMMENT 'The vehicle model year (MY) of the product being confirmed. Used for production output reporting by model year, regulatory compliance tracking (CAFE, EPA emissions), and alignment with SOP (Start of Production) and EOP (End of Production) milestones. Retained as a denormalized attribute for direct reporting without joining to vehicle configuration.. Valid values are `^[0-9]{4}$`',
    `operation_number` STRING COMMENT 'Routing operation number (VORNR) within the production order being confirmed. Identifies the specific manufacturing step (e.g., 0010 = Stamping, 0020 = Body Weld, 0030 = Paint, 0040 = Final Assembly) for partial confirmation scenarios. Maps to SAP PP routing operation.. Valid values are `^[0-9]{4}$`',
    `order_settlement_status` STRING COMMENT 'Status of the SAP CO production order settlement triggered by this final confirmation. pending = settlement not yet executed; settled = actual costs fully settled to cost objects; partially_settled = partial settlement completed; not_required = non-final confirmation, settlement not applicable. Used for period-end closing and financial reporting.. Valid values are `pending|settled|partially_settled|not_required`',
    `posting_date` DATE COMMENT 'The accounting/inventory posting date (SAP BUDAT) on which the production confirmation is financially posted. May differ from the confirmation timestamp when confirmations are entered retroactively. Drives inventory valuation, cost object settlement, and financial period assignment.',
    `powertrain_type` STRING COMMENT 'The powertrain technology type of the vehicle or assembly being confirmed. ICE = Internal Combustion Engine, HEV = Hybrid Electric Vehicle, PHEV = Plug-in Hybrid Electric Vehicle, BEV = Battery Electric Vehicle, FCEV = Fuel Cell Electric Vehicle. Used for regulatory reporting (CAFE, EPA, CARB), EV production mix analysis, and R&D investment tracking.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `production_order_number` STRING COMMENT 'SAP PP production order number (AUFNR) to which this confirmation is posted. Links the confirmation to the originating manufacturing order for order settlement, cost collection, and goods receipt triggering. Retained as a business attribute for direct shop floor reporting without requiring a join.. Valid values are `^[0-9]{8,12}$`',
    `quality_inspection_lot` STRING COMMENT 'SAP QM inspection lot number (PRUEFLOS) created automatically upon goods receipt posting from this confirmation. Links the production output to the quality inspection record for in-process and final inspection results. Used for quality traceability and IATF 16949 inspection record management.. Valid values are `^[0-9]{12}$`',
    `reversal_indicator` BOOLEAN COMMENT 'Flag indicating whether this confirmation record is a reversal entry (CO13 reversal in SAP PP). True = this record reverses a previously posted confirmation. Used to identify correction entries in production output reporting and to exclude reversed confirmations from yield and time aggregations.',
    `rework_quantity` DECIMAL(18,2) COMMENT 'The quantity of units requiring rework (reprocessing to meet specification) identified during this confirmation. Distinct from scrap (which is permanently rejected). Used for quality cost analysis, rework labor tracking, and process capability assessment per APQP (Advanced Product Quality Planning) requirements.',
    `scrap_quantity` DECIMAL(18,2) COMMENT 'The quantity of units scrapped (rejected as non-conforming) during this production operation. Maps to SAP PP field XMNGA (Scrap Quantity). Used for PPM (Parts Per Million) defect rate calculation, scrap cost reporting, and FMEA (Failure Mode and Effects Analysis) input. Triggers quality notification creation when thresholds are exceeded.',
    `scrap_reason_code` STRING COMMENT 'Coded reason for scrap recorded against this confirmation. Maps to SAP QM defect codes or MES scrap reason catalog (e.g., DIM = Dimensional Non-conformance, WLD = Weld Defect, PNT = Paint Defect, ASY = Assembly Error). Required for PPM (Parts Per Million) defect analysis, FMEA updates, and quality improvement initiatives per IATF 16949.. Valid values are `^[A-Z0-9]{2,10}$`',
    `setup_time_actual_min` DECIMAL(18,2) COMMENT 'Actual machine/workstation setup time consumed for this operation, recorded in minutes. Maps to SAP PP activity type for setup (ISRST — Actual Setup Time). Used for capacity planning, OEE (Overall Equipment Effectiveness) calculation, and comparison against planned setup time from the routing.',
    `setup_time_planned_min` DECIMAL(18,2) COMMENT 'Planned setup time for this operation as defined in the SAP PP routing, recorded in minutes. Provides the baseline for actual vs. planned setup time variance analysis. Sourced from the routing master data at the time of production order creation.',
    `storage_location_code` STRING COMMENT 'SAP storage location (LGORT) to which the confirmed yield quantity is posted as a goods receipt. Identifies the physical inventory location within the plant (e.g., finished goods area, WIP buffer, sequencing area). Required for inventory management and JIS (Just-in-Sequence) delivery coordination.. Valid values are `^[A-Z0-9]{4}$`',
    `takt_time_actual_sec` DECIMAL(18,2) COMMENT 'Actual takt time achieved for this production confirmation, expressed in seconds per unit. Calculated as total operation time divided by yield quantity. Used for production line balancing, bottleneck identification, and comparison against the planned takt time to assess line efficiency. Key metric in JIS (Just-in-Sequence) production management.',
    `teardown_time_actual_min` DECIMAL(18,2) COMMENT 'Actual teardown/cleanup time consumed after the production operation, recorded in minutes. Maps to SAP PP activity type for teardown. Included in total operation time for accurate takt time and capacity utilization calculations. Relevant for paint booth cleaning, tooling changeover, and AGV (Automated Guided Vehicle) repositioning cycles.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number assigned to the vehicle unit confirmed in this production record. Populated for final assembly confirmations where a specific vehicle unit is produced. Null for sub-assembly or component-level confirmations. Enables full build traceability from production confirmation to vehicle delivery.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `yield_quantity` DECIMAL(18,2) COMMENT 'The confirmed good quantity (yield) produced in this confirmation, expressed in the base unit of measure of the material. Represents the number of units that passed quality inspection and are accepted into inventory. Maps to SAP PP field LMNGA (Yield Quantity). Core metric for production output reporting and OTD (On-Time Delivery) tracking.',
    CONSTRAINT pk_production_confirmation PRIMARY KEY(`production_confirmation_id`)
) COMMENT 'Transactional record confirming the completion of a production order or a partial operation within a production order. Captures confirmation number, production order reference, confirmed quantity (yield and scrap), actual activity times (setup, machine, labor), confirmation timestamp, shift, work center, and operator. Triggers SAP PP order settlement and inventory goods receipt. SSOT for actual production output reporting. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage` (
    `manufacturing_tooling_usage_id` BIGINT COMMENT 'Unique identifier for the manufacturing_tooling_usage data product (auto-inserted pre-linking).',
    `production_order_id` BIGINT COMMENT 'add column production_order_id (BIGINT) with FK to manufacturing.production_order.production_order_id - tooling usage occurs during specific production orders',
    `tooling_registry_id` BIGINT COMMENT 'add column tooling_registry_id (BIGINT) with FK to asset.tooling_registry.tooling_registry_id - manufacturing tooling usage must reference the specific tool from the asset registry',
    `work_center_id` BIGINT COMMENT 'FK to manufacturing.work_center',
    CONSTRAINT pk_manufacturing_tooling_usage PRIMARY KEY(`manufacturing_tooling_usage_id`)
) COMMENT 'Transactional record tracking the usage of production tooling (dies, fixtures, jigs, welding guns, torque tools) against specific production orders and work centers. Captures tool ID, tool type, usage start and end timestamps, production order reference, work center, stroke count or cycle count, cumulative usage against tool life limit, and tool condition at usage. Supports predictive tooling maintenance and PPAP tooling traceability. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` (
    `process_parameter_id` BIGINT COMMENT 'Unique surrogate identifier for each process parameter reading record captured from PLC/SCADA systems during manufacturing operations.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where this process parameter reading was collected.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the operator or technician responsible for the work center at the time of this parameter reading. Used for operator-level quality analysis and IATF 16949 traceability requirements.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the specific machine, robot, or tooling equipment that performed the operation and generated this parameter reading (e.g., welding gun ID, torque wrench serial, press machine ID). Supports equipment-level SPC and predictive maintenance analysis.',
    `process_equipment_registry_id` BIGINT COMMENT 'Identifier of the specific machine, robot, or tooling equipment that performed the operation and generated this parameter reading (e.g., welding gun ID, torque wrench serial, press machine ID). Supports equipment-level SPC and predictive maintenance analysis.',
    `process_operator_employee_id` BIGINT COMMENT 'Employee identifier of the operator or technician responsible for the work center at the time of this parameter reading. Used for operator-level quality analysis and IATF 16949 traceability requirements.',
    `tooling_registry_id` BIGINT COMMENT 'Identifier of the specific tool or fixture used during the operation (e.g., torque bit ID, weld electrode ID, press die ID). Distinct from equipment_id; a single machine may use multiple interchangeable tools.',
    `process_tooling_registry_id` BIGINT COMMENT 'Identifier of the specific tool or fixture used during the operation (e.g., torque bit ID, weld electrode ID, press die ID). Distinct from equipment_id; a single machine may use multiple interchangeable tools.',
    `production_order_id` BIGINT COMMENT 'Reference to the production order (SAP PP work order) under which this process parameter reading was captured.',
    `vehicle_build_id` BIGINT COMMENT 'Reference to the vehicle build record associated with this process parameter reading, enabling full build traceability per VIN.',
    `work_center_id` BIGINT COMMENT 'Reference to the work center (SAP PP work center / Apriso MES station) where the process parameter was measured.',
    `assembly_stage` STRING COMMENT 'Manufacturing assembly stage during which this process parameter was captured. Aligns with the major shop areas: stamping, body shop, paint, trim, chassis, final assembly, or powertrain. [ENUM-REF-CANDIDATE: stamping|body_shop|paint|trim|chassis|final_assembly|powertrain — 7 candidates stripped; promote to reference product]',
    `control_plan_number` STRING COMMENT 'Reference number of the APQP Control Plan that defines the monitoring requirements, specification limits, and reaction plan for this process parameter. Links process execution to the approved quality plan.',
    `control_plan_revision` STRING COMMENT 'Revision level of the control plan in effect at the time of this parameter reading. Ensures traceability to the correct engineering specification version.',
    `data_collection_method` STRING COMMENT 'Method by which this process parameter reading was collected: automatic = fully automated PLC/SCADA capture with no operator intervention; semi_automatic = automated measurement with operator confirmation; manual = operator-entered value.. Valid values are `automatic|semi_automatic|manual`',
    `deviation_from_nominal` DECIMAL(18,2) COMMENT 'Calculated difference between the measured value and the nominal (target) value (measured_value minus nominal_value). Positive values indicate above-nominal readings; negative values indicate below-nominal. Stored as a raw field to support SPC trend analysis without requiring a join.',
    `gauge_calibration_due_date` DATE COMMENT 'Date by which the measurement instrument or gauge used for this reading is due for recalibration. Readings taken after the calibration due date may be flagged as suspect for quality audit purposes.',
    `is_out_of_control` BOOLEAN COMMENT 'Indicates whether this reading triggered an SPC out-of-control signal based on Western Electric or Nelson rules applied to the control chart. True = out-of-control signal detected; False = in statistical control. Distinct from pass_fail_status which checks specification limits.',
    `lower_control_limit` DECIMAL(18,2) COMMENT 'Statistical Lower Control Limit (LCL) for this process parameter as defined by SPC methodology. Readings below this value indicate the process is out of statistical control.',
    `lower_spec_limit` DECIMAL(18,2) COMMENT 'Engineering Lower Specification Limit (LSL) for this process parameter as defined in the control plan or engineering drawing. Readings below LSL result in a non-conformance. Distinct from LCL which is a statistical control boundary.',
    `measured_value` DECIMAL(18,2) COMMENT 'The actual numeric value of the process parameter as measured by the PLC/SCADA sensor at the time of the reading (e.g., 8500.0 amperes for weld current, 25.5 Nm for torque, 120.0 µm for paint film thickness).',
    `measurement_system_code` STRING COMMENT 'Identifier of the measurement system (gauge, sensor, or instrument) used to capture this reading. Supports Measurement System Analysis (MSA) / Gauge R&R traceability per AIAG MSA manual.',
    `mes_transaction_code` STRING COMMENT 'Unique transaction identifier assigned by the Apriso/Dassault MES system when this process parameter reading was recorded. Enables cross-system reconciliation between the lakehouse silver layer and the MES operational system.',
    `model_year` STRING COMMENT 'Model Year (MY) of the vehicle being built when this process parameter was captured (e.g., 2025). Supports model-year-level SPC trending and quality reporting.',
    `nominal_value` DECIMAL(18,2) COMMENT 'The engineering-specified nominal or target value for this process parameter as defined in the control plan. Used as the centre line for SPC charting and deviation calculation.',
    `non_conformance_number` STRING COMMENT 'Reference number of the Non-Conformance Report (NCR) raised in the quality management system (SAP QM) when this parameter reading resulted in a fail disposition. Null when pass_fail_status is pass.',
    `parameter_code` STRING COMMENT 'Unique alphanumeric code identifying the specific process parameter definition (e.g., WELD_CURR_01, TORQUE_BOLT_A, PAINT_FILM_T). Sourced from the PLC/SCADA parameter catalogue in Apriso MES.. Valid values are `^[A-Z0-9_]{3,30}$`',
    `parameter_name` STRING COMMENT 'Human-readable name of the process parameter being measured (e.g., Weld Current, Torque Value, Paint Film Thickness, Oven Temperature, Press Force, Adhesive Bead Width).',
    `parameter_type` STRING COMMENT 'Classification of the process parameter by its physical or process nature. Drives SPC charting rules and control limit interpretation. [ENUM-REF-CANDIDATE: weld_current|weld_time|torque|paint_film_thickness|oven_temperature|press_force|adhesive_bead_width|coolant_pressure|cure_time|voltage|current|speed|flow_rate|humidity — promote to reference product]',
    `pass_fail_status` STRING COMMENT 'Result of the automated conformance check comparing the measured value against the specification limits. pass = within LSL/USL; fail = outside LSL/USL; warning = within spec but outside UCL/LCL (statistically out of control); rework_required = fail with rework disposition; inconclusive = sensor error or missing reference limits.. Valid values are `pass|fail|warning|rework_required|inconclusive`',
    `plc_tag_code` STRING COMMENT 'Unique tag identifier from the Programmable Logic Controller (PLC) or SCADA system that is the source of this parameter reading. Enables traceability back to the originating control system data point.',
    `powertrain_type` STRING COMMENT 'Powertrain type of the vehicle being built: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), or FCEV (Fuel Cell Electric Vehicle). Certain process parameters (e.g., battery cell compression) are powertrain-specific.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `reaction_plan_triggered` BOOLEAN COMMENT 'Indicates whether the control plan reaction plan was triggered as a result of this parameter reading (True = reaction plan activated due to out-of-spec or out-of-control condition). Supports IATF 16949 audit evidence.',
    `reading_timestamp` TIMESTAMP COMMENT 'Exact date and time when the process parameter value was measured by the PLC/SCADA system. This is the principal business event timestamp for this record, representing the real-world moment of measurement.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this process parameter record was first ingested into the data platform (silver layer). Distinct from reading_timestamp which represents the actual measurement event time.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this process parameter record in the data platform. Used for incremental load tracking and audit trail purposes.',
    `sample_number` STRING COMMENT 'Sequential sample number within the SPC subgroup or sampling plan for this parameter at this work center. Used to construct X-bar/R charts and other SPC control charts.',
    `scada_system_code` STRING COMMENT 'Identifier of the SCADA system instance that collected and transmitted this process parameter reading to the MES/data platform.',
    `shift_code` STRING COMMENT 'Code identifying the production shift during which this parameter reading was captured (e.g., SHIFT_A, SHIFT_B, SHIFT_C). Supports shift-level SPC analysis and quality reporting.. Valid values are `^[A-Z0-9]{1,10}$`',
    `spc_rule_violated` STRING COMMENT 'Identifies the specific SPC detection rule that was violated when is_out_of_control is True (e.g., RULE_1_BEYOND_3SIGMA, RULE_2_NINE_CONSECUTIVE, RULE_3_SIX_TRENDING). Null when no rule is violated.',
    `subgroup_number` STRING COMMENT 'Identifier of the SPC rational subgroup to which this reading belongs. Subgroups are used to calculate control limits and assess process variation in X-bar/R or X-bar/S charts.',
    `unit_of_measure` STRING COMMENT 'Engineering unit of measure for the measured value (e.g., A for amperes, Nm for Newton-metres, µm for micrometres, °C for Celsius, kN for kilonewtons, mm for millimetres, ms for milliseconds). Follows SI unit conventions.',
    `upper_control_limit` DECIMAL(18,2) COMMENT 'Statistical Upper Control Limit (UCL) for this process parameter as defined by SPC methodology. Readings above this value indicate the process is out of statistical control.',
    `upper_spec_limit` DECIMAL(18,2) COMMENT 'Engineering Upper Specification Limit (USL) for this process parameter as defined in the control plan or engineering drawing. Readings above USL result in a non-conformance. Distinct from UCL which is a statistical control boundary.',
    `vehicle_model_code` STRING COMMENT 'Internal vehicle model or platform code for the vehicle being built (e.g., F150, RAV4, MODEL_3). Supports model-level process capability analysis and SPC stratification.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number (VIN) of the vehicle being processed at the time of this parameter reading. Enables full build traceability from process parameter to finished vehicle per NHTSA requirements.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_process_parameter PRIMARY KEY(`process_parameter_id`)
) COMMENT 'Transactional record capturing actual process parameter readings collected from PLC/SCADA systems during manufacturing operations. Includes parameter type (weld current, weld time, torque value, paint film thickness, oven temperature, press force, adhesive bead width), measured value, upper and lower control limits (UCL/LCL), pass/fail status, timestamp, work center, production order, and VIN reference. Supports SPC (Statistical Process Control) and IATF 16949 process monitoring requirements. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` (
    `agv_movement_id` BIGINT COMMENT 'Unique surrogate identifier for each AGV movement event record on the shop floor. Primary key for the agv_movement data product.',
    `employee_id` BIGINT COMMENT 'The identifier of the shop floor operator or MES user who manually initiated, overrode, or acknowledged this AGV movement task. Null for fully automated movements with no human intervention. Supports operator accountability and manual override tracking.',
    `agv_route_id` BIGINT COMMENT 'The predefined route identifier assigned to this movement by the AGV fleet management system. Routes define the physical path the AGV follows on the shop floor. Used for route utilization analysis, congestion detection, and route optimization.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where this AGV movement occurred. Links to the plant master for facility-level reporting and fleet utilization analysis.',
    `primary_employee_id` BIGINT COMMENT 'The identifier of the shop floor operator or MES user who manually initiated, overrode, or acknowledged this AGV movement task. Null for fully automated movements with no human intervention. Supports operator accountability and manual override tracking.',
    `shift_id` BIGINT COMMENT 'Reference to the production shift during which this AGV movement occurred. Enables shift-level fleet utilization reporting, throughput analysis, and comparison of AGV performance across shifts.',
    `work_center_id` BIGINT COMMENT 'Reference to the work center or production zone where the AGV movement was initiated or completed. Supports work center-level material flow analysis.',
    `agv_controller_code` STRING COMMENT 'Identifier of the AGV fleet management controller or traffic management system (e.g., a specific SCADA or AGV supervisor node) that dispatched and managed this movement. Supports multi-controller fleet architectures and fault isolation.',
    `agv_unit_code` STRING COMMENT 'The unique physical identifier assigned to the AGV unit performing the movement. Used for fleet management, maintenance scheduling, and utilization tracking per individual vehicle.. Valid values are `^AGV-[A-Z0-9]{3,12}$`',
    `assembly_stage` STRING COMMENT 'The manufacturing assembly stage to which this AGV movement is associated (e.g., stamping, body shop, paint, trim, chassis, final assembly). Enables stage-level material flow analysis and supports multi-stage production traceability.. Valid values are `stamping|body_shop|paint|trim|chassis|final_assembly`',
    `average_speed_mps` DECIMAL(18,2) COMMENT 'The average travel speed of the AGV in metres per second during this movement. Used to identify speed anomalies, assess compliance with shop floor speed limits, and support throughput optimization.',
    `battery_level_end_pct` DECIMAL(18,2) COMMENT 'The AGV battery state of charge as a percentage at the time the movement task ended. Combined with battery_level_start_pct to calculate energy consumption per movement and model battery degradation over time.',
    `battery_level_start_pct` DECIMAL(18,2) COMMENT 'The AGV battery state of charge as a percentage at the time the movement task began. Used for fleet energy management, charge scheduling optimization, and identifying movements that may have been impacted by low battery conditions.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this AGV movement record was first created in the MES or data platform. Used for audit trail, data lineage, and Silver layer ingestion tracking.',
    `destination_location_code` STRING COMMENT 'The shop floor location code of the target delivery point for this AGV movement. Used to verify correct delivery to the intended assembly station or buffer zone and to support JIS (Just-in-Sequence) call-off validation.',
    `destination_location_name` STRING COMMENT 'Human-readable descriptive name of the destination location (e.g., Final Assembly Line 2 Station 14, Trim Shop Sequencing Buffer). Supports operational dashboards and exception reporting.',
    `distance_travelled_m` DECIMAL(18,2) COMMENT 'The total distance in metres travelled by the AGV during this movement event, as reported by the AGVs odometry or navigation system. Used for fleet utilization reporting, energy consumption modelling, and route efficiency analysis.',
    `fault_code` STRING COMMENT 'The fault or exception code reported by the AGV or fleet controller during this movement (e.g., obstacle detected, navigation error, battery low, load sensor failure). Null if no fault occurred. Used for predictive maintenance, FMEA (Failure Mode and Effects Analysis), and fleet reliability reporting.',
    `fault_description` STRING COMMENT 'Human-readable description of the fault or exception that occurred during this movement. Provides operational context for maintenance technicians and MES operators beyond the structured fault_code.',
    `fault_timestamp` TIMESTAMP COMMENT 'The precise date and time when the fault or exception was detected during this AGV movement. Null if no fault occurred. Used for mean time between failures (MTBF) calculation and maintenance response time analysis.',
    `is_manual_override` BOOLEAN COMMENT 'Indicates whether this AGV movement was manually overridden or initiated by a human operator rather than being fully automated by the MES or AGV fleet controller (True = manual override, False = fully automated). Used for automation rate reporting and exception analysis.',
    `jis_call_off_flag` BOOLEAN COMMENT 'Indicates whether this AGV movement was triggered by a JIS (Just-in-Sequence) call-off signal from the assembly line (True = JIS-triggered, False = standard replenishment or non-sequenced movement). Critical for sequencing compliance reporting and line-feed performance analysis.',
    `load_weight_kg` DECIMAL(18,2) COMMENT 'The weight in kilograms of the load carried by the AGV during this movement, as measured by the AGVs onboard load sensor. Used for payload compliance monitoring, energy consumption analysis, and overload fault detection.',
    `mes_task_code` STRING COMMENT 'The unique task or dispatch identifier assigned by the MES (Manufacturing Execution System) — specifically Apriso/Dassault — to this AGV movement instruction. Used for cross-system reconciliation between the AGV fleet controller and the MES shop floor execution layer.',
    `movement_end_timestamp` TIMESTAMP COMMENT 'The precise date and time (ISO 8601 with timezone offset) when the AGV completed or terminated the movement task. Null if the movement is still in progress. Used with movement_start_timestamp to derive actual cycle time.',
    `movement_start_timestamp` TIMESTAMP COMMENT 'The precise date and time (ISO 8601 with timezone offset) when the AGV began executing the movement task. Used for cycle time calculation, throughput analysis, and JIS (Just-in-Sequence) compliance verification.',
    `movement_status` STRING COMMENT 'Current lifecycle state of the AGV movement event. Tracks whether the movement is actively executing, successfully completed, aborted due to an obstacle, faulted due to a system error, or cancelled by the MES scheduler.. Valid values are `in_progress|completed|aborted|faulted|cancelled`',
    `movement_type` STRING COMMENT 'Categorical classification of the AGV movement event: load (picking up a carrier/part), transport (moving between locations), unload (depositing a carrier/part), charge (returning to charging station), idle (stationary with no task), fault (movement interrupted by exception).. Valid values are `load|transport|unload|charge|idle|fault`',
    `origin_location_code` STRING COMMENT 'The shop floor location code (e.g., storage lane, buffer zone, work station address) from which the AGV departed for this movement. Encoded per the plants internal location addressing scheme (e.g., aisle-bay-level). Used for material flow mapping and route optimization.',
    `origin_location_name` STRING COMMENT 'Human-readable descriptive name of the origin location (e.g., Body Shop Buffer Lane 3, Paint Shop Entry Conveyor, Stamping Parts Supermarket). Supports operational reporting and shop floor visualization dashboards.',
    `part_description` STRING COMMENT 'Human-readable description of the part or component being transported (e.g., Front Door Inner Panel LH, Battery Module Assembly EV). Supports operational reporting without requiring a join to the parts master.',
    `part_number` STRING COMMENT 'The OEM (Original Equipment Manufacturer) part number of the primary component or assembly being transported by the AGV. Supports Bill of Materials (BOM) traceability and JIS (Just-in-Sequence) delivery verification at the assembly line.',
    `planned_end_timestamp` TIMESTAMP COMMENT 'The MES-scheduled completion time for this AGV movement task. Compared against movement_end_timestamp to measure on-time delivery performance and identify bottlenecks in material flow.',
    `planned_start_timestamp` TIMESTAMP COMMENT 'The MES-scheduled start time for this AGV movement task. Compared against movement_start_timestamp to measure schedule adherence and identify JIS (Just-in-Sequence) delivery deviations.',
    `priority_level` STRING COMMENT 'The dispatch priority assigned to this AGV movement by the MES or AGV fleet controller. Critical and high priority movements are typically associated with JIS (Just-in-Sequence) call-offs or line-stop prevention. Used for queue management and SLA reporting.. Valid values are `critical|high|normal|low`',
    `quantity_transported` STRING COMMENT 'The number of parts, units, or assemblies carried by the AGV in this movement. Used for material flow volume reporting, inventory reconciliation, and JIT (Just-in-Time) delivery quantity verification.',
    `route_deviation_flag` BOOLEAN COMMENT 'Indicates whether the AGV deviated from its assigned route during this movement (True = deviation occurred, False = route followed as planned). Deviations may indicate obstacles, dynamic re-routing, or system faults requiring investigation.',
    `source_system_code` STRING COMMENT 'The identifier of the originating operational system that generated this AGV movement record (e.g., Apriso MES instance ID, Bosch IoT AGV controller node). Supports data lineage, multi-system reconciliation, and Silver layer provenance tracking in the Databricks Lakehouse.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this AGV movement record was last modified, such as when a fault code was appended or movement status was updated to completed. Supports incremental data processing in the Databricks Silver layer.',
    `vin` STRING COMMENT 'The 17-character Vehicle Identification Number (VIN) of the vehicle being built when this AGV movement is directly associated with a specific vehicle build (e.g., transporting a body-in-white or sequenced component). Null for non-vehicle-specific movements such as bulk part replenishment. Enables build traceability per NHTSA requirements.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_agv_movement PRIMARY KEY(`agv_movement_id`)
) COMMENT 'Transactional record capturing Automated Guided Vehicle (AGV) movement events on the shop floor. Tracks AGV unit ID, movement type (load, transport, unload, charge, idle), origin location, destination location, carried load (part number, VIN, carrier ID), movement start and end timestamps, route taken, and any fault or exception codes. Supports real-time material flow visibility and AGV fleet utilization reporting. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` (
    `capacity_plan_id` BIGINT COMMENT 'Unique surrogate identifier for each capacity plan record in the manufacturing domain. Primary key for the capacity_plan data product.',
    `work_center_id` BIGINT COMMENT 'Reference to the work center identified as the capacity bottleneck constraining overall line throughput during this planning period. Used to prioritize capacity improvement investments and focus S&OP constraint management.',
    `employee_id` BIGINT COMMENT 'Reference to the manufacturing or industrial engineering employee responsible for maintaining and updating this capacity plan. Supports accountability tracking in S&OP governance.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant for which this capacity plan is defined. Links to the manufacturing.plant master record.',
    `primary_employee_id` BIGINT COMMENT 'Reference to the manufacturing or industrial engineering employee responsible for maintaining and updating this capacity plan. Supports accountability tracking in S&OP governance.',
    `production_line_id` BIGINT COMMENT 'Reference to the specific production line (e.g., final assembly line, body shop line, paint line) within the plant for which capacity is being planned. Links to the manufacturing.work_center or production line master.',
    `shift_id` BIGINT COMMENT 'Reference to the shift pattern (e.g., 1-shift, 2-shift, 3-shift) applied in this capacity plan. Shift pattern determines available production hours and directly impacts rated capacity calculation.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Capacity planning aligns plant capacity with each vehicle program; capacity_plan needs vehicle_program reference.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the capacity plan was formally approved by the designated authority. Marks the transition from submitted to approved status in the S&OP governance process.',
    `approved_by` STRING COMMENT 'Name or employee identifier of the S&OP or manufacturing leadership authority who approved this capacity plan. Required for audit trail and governance compliance under IATF 16949.',
    `available_hours` DECIMAL(18,2) COMMENT 'Total scheduled production hours available in the planning period after accounting for planned downtime, shift breaks, and scheduled maintenance. Used in conjunction with rated_capacity_jph to compute rated capacity in units.',
    `bottleneck_constraint_description` STRING COMMENT 'Narrative description of the primary capacity constraint at the bottleneck work center (e.g., Paint oven cycle time limits throughput to 58 JPH, Robotic welding cell maintenance window reduces available hours). Supports root cause analysis and CapEx justification.',
    `capacity_gap_units` STRING COMMENT 'Difference between planned_production_units and demonstrated_capacity_units, representing the capacity shortfall or surplus for the planning period. Positive value indicates a capacity gap requiring corrective action (overtime, additional shifts, CapEx); negative value indicates surplus capacity.',
    `capacity_plan_type` STRING COMMENT 'Classification of the capacity planning methodology used. rough_cut (RCCP — Rough Cut Capacity Planning) for high-level S&OP; detailed for work-center-level CRP (Capacity Requirements Planning); constraint_based for Theory of Constraints analysis; what_if for scenario planning and CapEx evaluation.. Valid values are `rough_cut|detailed|constraint_based|what_if`',
    `capacity_utilization_percent` DECIMAL(18,2) COMMENT 'Planned capacity utilization rate expressed as a percentage, calculated as (planned_production_units / rated_capacity_units) × 100. Drives S&OP decisions on overtime, additional shifts, and capital investment. Target thresholds are typically 85–95% for automotive assembly.',
    `capex_amount` DECIMAL(18,2) COMMENT 'Estimated capital expenditure amount required to address the capacity gap identified in this plan. Expressed in the plants operating currency. Used for CapEx budget submissions and investment approval processes.',
    `capex_required` BOOLEAN COMMENT 'Indicates whether this capacity plan identifies a requirement for capital investment (CapEx) to close a capacity gap (e.g., new tooling, additional robots, facility expansion). Triggers CapEx approval workflow in SAP FI/CO.',
    `changeover_hours` DECIMAL(18,2) COMMENT 'Hours allocated for model changeovers, tooling changes, and line reconfigurations during the planning period. Relevant for mixed-model assembly lines producing multiple vehicle variants (e.g., ICE and BEV on the same line).',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this capacity plan record was first created in the system. Provides the audit trail creation anchor for data lineage and compliance purposes.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary values in this capacity plan record (e.g., USD, EUR, MXN, CNY). Ensures consistent financial reporting across multi-plant, multi-currency manufacturing operations.. Valid values are `^[A-Z]{3}$`',
    `daily_production_target` STRING COMMENT 'Planned number of vehicles to be produced per working day during the planning period, derived from planned_production_units / working_days. Used for daily MES scheduling and shift-level production targets.',
    `demonstrated_capacity_units` STRING COMMENT 'Actual production output achieved in a comparable prior period, used as the realistic baseline for capacity planning. Reflects real-world constraints such as quality losses, minor stoppages, and changeovers. Key input to APQP (Advanced Product Quality Planning) capacity studies.',
    `eop_date` DATE COMMENT 'Planned End of Production (EOP) date for the vehicle model or program covered by this capacity plan. Marks the milestone when production of the model is scheduled to cease. Used for capacity wind-down planning and asset redeployment decisions.',
    `fiscal_year` STRING COMMENT 'Fiscal year (FY) to which this capacity plan belongs, used for CapEx (Capital Expenditure) alignment, budget planning, and financial reporting. Format: FY followed by 4-digit year (e.g., FY2025).. Valid values are `^FY[0-9]{4}$`',
    `headcount_required` STRING COMMENT 'Total direct labor headcount required to execute the planned production volume during the planning period. Used for workforce planning, hiring decisions, and labor cost budgeting in SuccessFactors and SAP CO.',
    `is_bottleneck_constrained` BOOLEAN COMMENT 'Indicates whether the capacity plan is constrained by a bottleneck work center that limits overall line throughput below the planned production target. When True, the bottleneck_work_center_id and bottleneck_constraint_description fields are populated.',
    `model_year` STRING COMMENT 'Automotive model year (MY) for which this capacity plan is prepared. Capacity plans are typically aligned to MY production programs, SOP (Start of Production), and EOP (End of Production) milestones.. Valid values are `^[0-9]{4}$`',
    `number_of_shifts` STRING COMMENT 'Number of production shifts planned per working day for this capacity plan (e.g., 1, 2, or 3 shifts). Directly determines available production hours and total capacity for the planning period.',
    `plan_end_date` DATE COMMENT 'Last calendar date of the planning period covered by this capacity plan record. Together with plan_start_date, defines the planning window for capacity supply and demand balancing.',
    `plan_number` STRING COMMENT 'Externally-known, human-readable business identifier for the capacity plan record, used in S&OP (Sales and Operations Planning) communications, SAP PP capacity planning transactions (CM01/CM21), and cross-functional reporting. Format: CP-{PLANT}-{YEAR}-{MONTH}-{SEQ}.. Valid values are `^CP-[A-Z0-9]{3,6}-[0-9]{4}-[0-9]{2}-[0-9]{3}$`',
    `plan_start_date` DATE COMMENT 'First calendar date of the planning period covered by this capacity plan record. Used to align capacity supply with demand signals from S&OP and MRP (Material Requirements Planning) runs.',
    `plan_status` STRING COMMENT 'Current lifecycle state of the capacity plan record. draft indicates work-in-progress; submitted indicates pending approval; approved indicates sign-off by S&OP leadership; active indicates the operative plan driving production scheduling; superseded indicates replaced by a newer version; archived indicates historical record.. Valid values are `draft|submitted|approved|active|superseded|archived`',
    `plan_version` STRING COMMENT 'Version identifier of the capacity plan, enabling management of multiple planning iterations (e.g., v1.0, v2.0) within the same planning period. Supports S&OP cycle versioning and plan-over-plan variance analysis.. Valid values are `^v[0-9]{1,3}.[0-9]{1,2}$`',
    `planned_downtime_hours` DECIMAL(18,2) COMMENT 'Total planned downtime hours for the production line during the planning period, including scheduled maintenance, tooling changeovers, model changeovers, and planned shutdowns. Reduces available production hours from the theoretical maximum.',
    `planned_maintenance_hours` DECIMAL(18,2) COMMENT 'Subset of planned downtime hours specifically allocated to preventive and predictive maintenance activities on production equipment. Tracked separately from changeover downtime for maintenance KPI reporting and SAP PM integration.',
    `planned_overtime_hours` DECIMAL(18,2) COMMENT 'Total overtime hours planned for the production line during the planning period to meet production targets beyond standard shift capacity. Feeds into workforce cost planning and labor budget in SAP CO.',
    `planned_production_units` STRING COMMENT 'Number of vehicles planned for production in the planning period as agreed in the S&OP process. Represents the demand signal that capacity must satisfy. Compared against rated and demonstrated capacity to identify gaps.',
    `planning_period_type` STRING COMMENT 'Granularity of the capacity planning horizon for this record. weekly supports short-term MES scheduling; monthly supports S&OP cycles; quarterly and annual support CapEx and strategic workforce planning.. Valid values are `weekly|monthly|quarterly|annual`',
    `planning_scenario` STRING COMMENT 'Demand scenario underpinning this capacity plan. base reflects the consensus S&OP forecast; optimistic reflects upside demand; pessimistic reflects downside risk; stretch reflects maximum achievable output. Enables scenario comparison for executive decision-making.. Valid values are `base|optimistic|pessimistic|stretch`',
    `powertrain_type` STRING COMMENT 'Powertrain technology type planned for production in this capacity plan. ICE = Internal Combustion Engine; HEV = Hybrid Electric Vehicle; PHEV = Plug-in Hybrid Electric Vehicle; BEV = Battery Electric Vehicle; FCEV = Fuel Cell Electric Vehicle. Impacts tooling, line configuration, and capacity requirements.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `rated_capacity_jph` DECIMAL(18,2) COMMENT 'Theoretical maximum production rate expressed in Jobs Per Hour (JPH) for the production line under ideal conditions. Derived from takt time and line design specifications. Used as the baseline for capacity utilization calculations in S&OP.',
    `rated_capacity_units` STRING COMMENT 'Theoretical maximum number of vehicles that can be produced in the planning period, calculated as rated_capacity_jph × available_hours. Represents the upper bound of production capacity for S&OP and CapEx planning.',
    `sap_capacity_plan_code` STRING COMMENT 'Source system identifier for this capacity plan record in SAP S/4HANA PP (Production Planning) module, used for data lineage traceability and reconciliation between the lakehouse Silver layer and the operational ERP system.',
    `sop_date` DATE COMMENT 'Planned Start of Production (SOP) date for the vehicle model or program covered by this capacity plan. Marks the milestone when full-rate production is scheduled to begin. Critical for capacity ramp-up planning and APQP milestone tracking.',
    `takt_time_seconds` STRING COMMENT 'Planned takt time in seconds for the production line during this planning period, representing the rate at which vehicles must be produced to meet customer demand. Takt time = available production time / planned production units. Core metric in JIS (Just-in-Sequence) and line balancing.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this capacity plan record was last modified. Tracks plan revisions through the S&OP cycle and supports change management auditing.',
    `vehicle_model_code` STRING COMMENT 'Internal OEM (Original Equipment Manufacturer) code identifying the vehicle model or program (e.g., platform code, nameplate code) for which this capacity plan is prepared. Enables capacity planning at the model/program level.',
    `working_days` STRING COMMENT 'Number of scheduled working days in the planning period after excluding weekends, public holidays, and planned plant shutdowns. Used to compute daily production targets and available hours.',
    CONSTRAINT pk_capacity_plan PRIMARY KEY(`capacity_plan_id`)
) COMMENT 'Master record for plant and line capacity planning, capturing planned production capacity by plant, production line, shift pattern, and planning period (weekly/monthly). Includes rated capacity (JPH × available hours), demonstrated capacity, capacity utilization percentage, bottleneck work center, planned overtime hours, and capacity plan version. Supports S&OP (Sales and Operations Planning) and capital investment decisions. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` (
    `changeover_id` BIGINT COMMENT 'Unique surrogate identifier for each production line changeover event record in the manufacturing execution system.',
    `employee_id` BIGINT COMMENT 'Reference to the production supervisor or line manager who authorized and oversaw the changeover event. Supports accountability tracking and sign-off compliance per IATF 16949.',
    `org_unit_id` BIGINT COMMENT 'Reference to the operator team or crew responsible for executing the changeover. Supports SMED (Single-Minute Exchange of Die) team performance analysis and workforce accountability.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where the changeover event occurred.',
    `primary_employee_id` BIGINT COMMENT 'Reference to the production supervisor or line manager who authorized and oversaw the changeover event. Supports accountability tracking and sign-off compliance per IATF 16949.',
    `production_line_id` BIGINT COMMENT 'Reference to the specific production or assembly line on which the changeover was performed.',
    `shift_id` BIGINT COMMENT 'Reference to the production shift during which the changeover event occurred. Used for shift-level performance reporting and labor attribution.',
    `actual_duration_minutes` STRING COMMENT 'Actual elapsed time in minutes from changeover start to completion. Core metric for SMED (Single-Minute Exchange of Die) analysis and OEE (Overall Equipment Effectiveness) calculations.',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when the changeover was completed and the production line resumed normal operation, as recorded by MES (Manufacturing Execution System).',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the changeover physically commenced on the production line, as recorded by MES (Manufacturing Execution System) or operator input.',
    `agv_intervention_required` BOOLEAN COMMENT 'Indicates whether AGV (Automated Guided Vehicle) systems were required to transport tooling, fixtures, or materials as part of the changeover process. Supports AGV utilization and changeover logistics analysis.',
    `assembly_stage` STRING COMMENT 'The specific manufacturing stage or shop where the changeover occurred (e.g., stamping, body shop, paint, trim, chassis, final assembly). Enables stage-level SMED (Single-Minute Exchange of Die) benchmarking.. Valid values are `stamping|body_shop|paint|trim|chassis|final_assembly`',
    `changeover_number` STRING COMMENT 'Externally-known business identifier for the changeover event, used in MES (Manufacturing Execution System) and shop floor documentation. Format: CO-{PLANT}-{YYYYMMDD}-{SEQ}.. Valid values are `^CO-[A-Z0-9]{3,6}-[0-9]{8}-[0-9]{4}$`',
    `changeover_status` STRING COMMENT 'Current lifecycle state of the changeover event as tracked in the MES (Manufacturing Execution System). Drives shop floor workflow and reporting.. Valid values are `scheduled|in_progress|completed|cancelled|aborted`',
    `changeover_type` STRING COMMENT 'Classification of the changeover event indicating the nature of the switch on the production line. [ENUM-REF-CANDIDATE: model_mix_change|color_change|tooling_swap|line_retooling|powertrain_variant|body_style_change — promote to reference product]. Valid values are `model_mix_change|color_change|tooling_swap|line_retooling|powertrain_variant|body_style_change`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the changeover record was first created in the MES (Manufacturing Execution System) or data platform. Supports audit trail and data lineage requirements.',
    `delay_reason_code` STRING COMMENT 'Standardized code capturing the primary reason for any variance between planned and actual changeover duration. Used for root cause analysis in SMED (Single-Minute Exchange of Die) and continuous improvement programs.',
    `external_elements_duration_minutes` STRING COMMENT 'Total time in minutes spent on external changeover activities that can be performed while the production line is still running (e.g., pre-staging tooling). Core SMED (Single-Minute Exchange of Die) metric for optimization.',
    `first_good_unit_timestamp` TIMESTAMP COMMENT 'Timestamp when the first conforming vehicle unit passed quality inspection after the changeover was completed. Marks the effective end of production loss and resumption of normal throughput.',
    `from_body_style_code` STRING COMMENT 'Body style classification of the vehicle being produced before the changeover (e.g., sedan, SUV, truck). Used to categorize body style changeover events.. Valid values are `sedan|suv|truck|coupe|hatchback|van`',
    `from_exterior_color_code` STRING COMMENT 'Paint color code of the vehicle being produced before the changeover. Relevant for color change changeover events in the paint shop.',
    `from_powertrain_type` STRING COMMENT 'Powertrain variant being produced before the changeover. ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle).. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `from_vehicle_model_code` STRING COMMENT 'Vehicle model code of the product being produced on the line immediately before the changeover. Identifies the outgoing model in a model mix change scenario.',
    `internal_elements_duration_minutes` STRING COMMENT 'Total time in minutes spent on internal changeover activities that require the production line to be stopped (e.g., die removal, fixture swap). Core SMED (Single-Minute Exchange of Die) metric for identifying conversion opportunities.',
    `is_planned` BOOLEAN COMMENT 'Indicates whether the changeover was a scheduled/planned event (True) or an unplanned/emergency changeover triggered by a quality issue, equipment failure, or urgent customer order change (False).',
    `is_smed_target` BOOLEAN COMMENT 'Flags whether this changeover event is designated as a target for SMED (Single-Minute Exchange of Die) improvement analysis. Enables filtering of changeover records for lean manufacturing improvement programs.',
    `line_verification_duration_minutes` STRING COMMENT 'Time in minutes spent on post-changeover line verification, first-off inspection, and quality gate checks before resuming full production. Supports APQP (Advanced Product Quality Planning) and PPAP (Production Part Approval Process) compliance.',
    `mes_changeover_reference` STRING COMMENT 'Native changeover event identifier from the Apriso/Dassault MES (Manufacturing Execution System). Enables traceability and reconciliation between the lakehouse silver layer and the operational MES source system.',
    `model_year` STRING COMMENT 'Model Year (MY) of the vehicle being introduced on the production line after the changeover. Used for production planning, regulatory compliance, and homologation tracking.. Valid values are `^[0-9]{4}$`',
    `planned_duration_minutes` STRING COMMENT 'Planned duration of the changeover in minutes as defined in the production schedule. Baseline for SMED (Single-Minute Exchange of Die) improvement tracking.',
    `planned_end_timestamp` TIMESTAMP COMMENT 'Scheduled date and time when the changeover was planned to be completed. Used to calculate planned changeover duration and production window impact.',
    `planned_start_timestamp` TIMESTAMP COMMENT 'Scheduled date and time when the changeover was planned to begin, as defined in the production schedule. Used for SMED (Single-Minute Exchange of Die) baseline comparison.',
    `production_loss_units` STRING COMMENT 'Number of vehicle units not produced due to the changeover downtime. Calculated as the difference between potential production capacity and actual output during the changeover window. Key metric for OEE (Overall Equipment Effectiveness) and capacity planning.',
    `quality_gate_passed` BOOLEAN COMMENT 'Indicates whether the post-changeover quality gate inspection was passed (True) before resuming full production. A False value indicates the line was held pending rework or re-inspection per IATF 16949 quality control requirements.',
    `reason_code` STRING COMMENT 'Standardized code indicating the business reason that triggered the changeover event (e.g., scheduled model mix, customer order sequence, engineering change, maintenance requirement). Used for root cause analysis and frequency reporting.',
    `reason_description` STRING COMMENT 'Free-text description providing additional context for the changeover reason, supplementing the reason code with operator or supervisor notes.',
    `sap_order_reference` STRING COMMENT 'Reference to the SAP S/4HANA production order number associated with the post-changeover production run. Enables cost allocation and production confirmation reconciliation in SAP PP (Production Planning).',
    `scrap_units_during_changeover` STRING COMMENT 'Number of vehicle units scrapped or rejected during the changeover transition period before the first good unit was produced. Contributes to quality loss calculation in OEE (Overall Equipment Effectiveness).',
    `takt_time_seconds` STRING COMMENT 'Takt time in seconds applicable to the production line at the time of changeover. Used to calculate production loss units and assess changeover impact on line throughput.',
    `to_body_style_code` STRING COMMENT 'Body style classification of the vehicle to be produced after the changeover (e.g., sedan, SUV, truck). Used to categorize body style changeover events.. Valid values are `sedan|suv|truck|coupe|hatchback|van`',
    `to_exterior_color_code` STRING COMMENT 'Paint color code of the vehicle to be produced after the changeover. Relevant for color change changeover events in the paint shop.',
    `to_powertrain_type` STRING COMMENT 'Powertrain variant to be produced after the changeover. ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle).. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `to_vehicle_model_code` STRING COMMENT 'Vehicle model code of the product to be produced on the line immediately after the changeover. Identifies the incoming model in a model mix change scenario.',
    `tooling_change_required` BOOLEAN COMMENT 'Indicates whether the changeover required a physical tooling swap or die change (True) or was a parameter/program-only changeover (False). Drives tooling logistics planning and SMED (Single-Minute Exchange of Die) categorization.',
    `tooling_setup_duration_minutes` STRING COMMENT 'Time in minutes required specifically for tooling installation, adjustment, and verification during the changeover. Subset of internal changeover elements used for tooling-specific SMED analysis.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the changeover record was last modified in the data platform. Supports audit trail, data lineage, and incremental load processing for the Databricks Lakehouse Silver Layer.',
    `variance_minutes` STRING COMMENT 'Difference in minutes between actual and planned changeover duration (actual_duration_minutes minus planned_duration_minutes). Positive value indicates overrun; negative indicates early completion. Key SMED (Single-Minute Exchange of Die) performance indicator.',
    CONSTRAINT pk_changeover PRIMARY KEY(`changeover_id`)
) COMMENT 'Transactional record for production line changeover events when switching between vehicle models, body styles, or powertrain variants on a shared production line. Captures changeover type (model mix change, color change, tooling swap, line retooling), planned and actual changeover start/end times, duration, affected production line, changeover team, and production loss (units not produced). Supports SMED (Single-Minute Exchange of Die) improvement programs. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` (
    `production_variant_id` BIGINT COMMENT 'Primary key for production_variant',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: Variant definitions are approved via homologation; linking ensures variant builds only when approved.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Variant Definition Process links each variant to its vehicle model for configuration management and regulatory compliance.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where this production variant is authorized to be built. Determines line compatibility, tooling availability, and regulatory homologation scope.',
    `production_bom_id` BIGINT COMMENT 'Reference to the manufacturing BOM (Bill of Materials) version applicable to this production variant. Links to the BOM master in Siemens Teamcenter PLM or SAP MM (Materials Management) to resolve component lists for production planning and MRP (Material Requirements Planning) execution.',
    `production_line_id` BIGINT COMMENT 'Reference to the specific production line within the plant on which this variant is authorized to be assembled. Drives JIS (Just-in-Sequence) feasibility validation and takt time allocation.',
    `routing_id` BIGINT COMMENT 'Reference to the manufacturing routing (operation sequence) applicable to this production variant in SAP PP (Production Planning). Defines the sequence of work centers, operations, and standard times required to build this variant from stamping through final assembly.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Variants are defined under a vehicle program; variant management reports require vehicle_program_id.',
    `adas_level` STRING COMMENT 'SAE J3016 automation level of the ADAS (Advanced Driver Assistance Systems) suite fitted to this production variant: L0 (no automation), L1 (driver assistance), L2 (partial automation), L2_PLUS (enhanced partial automation), L3 (conditional automation). Drives ECU (Electronic Control Unit) software configuration, OTA (Over-the-Air Update) eligibility, and UNECE UN R157 regulatory compliance.. Valid values are `L0|L1|L2|L2_PLUS|L3`',
    `assembly_complexity_score` STRING COMMENT 'Numeric score (1–10) representing the relative assembly complexity of this production variant compared to the base variant on the same production line. Higher scores indicate more assembly operations, longer cycle times, or specialized tooling requirements. Used for JIS (Just-in-Sequence) sequencing optimization to balance line loading and avoid consecutive high-complexity builds.',
    `battery_capacity_kwh` DECIMAL(18,2) COMMENT 'Usable battery pack capacity in kilowatt-hours (kWh) for BEV, PHEV, and HEV variants. Null for pure ICE variants. Drives assembly sequencing for battery marriage station, WLTP (Worldwide Harmonised Light Vehicles Test Procedure) range certification, and EPA electric range labelling.',
    `body_style_code` STRING COMMENT 'Standardized code identifying the vehicle body configuration for this production variant (e.g., SEDAN, SUV, TRUCK, COUPE, HATCHBACK, MINIVAN). Determines stamping die sets, body shop tooling, and paint booth configuration requirements. [ENUM-REF-CANDIDATE: SEDAN|SUV|TRUCK|COUPE|HATCHBACK|MINIVAN|CONVERTIBLE|WAGON|VAN|CROSSOVER — promote to reference product]. Valid values are `SEDAN|SUV|TRUCK|COUPE|HATCHBACK|MINIVAN`',
    `co2_emission_g_per_km` DECIMAL(18,2) COMMENT 'Certified CO2 tailpipe emission in grams per kilometre (g/km) under WLTP or NEDC test cycle for this production variant. Used for EU CO2 fleet average compliance (Regulation (EU) 2019/631), CAFE (Corporate Average Fuel Economy) calculations, and vehicle taxation band classification in destination markets.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this production variant record was first created in the manufacturing master data system. Provides audit trail for data governance and IATF 16949 documented information control requirements.',
    `destination_market_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code identifying the primary market for which this production variant is homologated and destined (e.g., USA, DEU, JPN). Governs regulatory compliance requirements (NHTSA FMVSS, Euro NCAP, UNECE), emission standards, and right-hand vs left-hand drive configuration.. Valid values are `^[A-Z]{3}$`',
    `drive_configuration` STRING COMMENT 'Drivetrain configuration specifying which axles receive motive power: FWD (Front-Wheel Drive), RWD (Rear-Wheel Drive), AWD (All-Wheel Drive), or 4WD (Four-Wheel Drive). Determines chassis assembly routing, driveshaft fitment, and NVH (Noise Vibration Harshness) validation requirements.. Valid values are `FWD|RWD|AWD|4WD`',
    `engine_displacement_cc` STRING COMMENT 'Total engine displacement in cubic centimetres (cc) for ICE (Internal Combustion Engine) and HEV/PHEV variants. Null for BEV and FCEV variants. Used for regulatory classification under EPA, CARB, and UNECE emissions standards, and for CAFE (Corporate Average Fuel Economy) fleet averaging calculations.',
    `engineering_change_level` STRING COMMENT 'Current engineering change revision level for this production variant as managed in Siemens Teamcenter PLM or PTC Windchill (e.g., A, B, C1, REV3). Tracks design maturity and ensures the correct BOM (Bill of Materials) version is applied during production. Incremented upon each approved engineering change notice (ECN).. Valid values are `^[A-Z0-9]{1,10}$`',
    `eop_date` DATE COMMENT 'Date on which this production variant is scheduled to cease production (EOP — End of Production). Drives last-order scheduling, tooling decommissioning planning, and spare parts provisioning for after-sales service obligations.',
    `fuel_economy_mpg` DECIMAL(18,2) COMMENT 'EPA-certified combined fuel economy in miles per gallon (MPG) for ICE, HEV, and PHEV variants in NAFTA markets. Null for BEV/FCEV variants. Used for CAFE (Corporate Average Fuel Economy) fleet compliance reporting to EPA and consumer window sticker labelling under 49 CFR Part 575.',
    `gross_vehicle_weight_kg` DECIMAL(18,2) COMMENT 'Gross Vehicle Weight Rating (GVWR) in kilograms for this production variant. Used for regulatory classification under DOT FMVSS, UNECE weight regulations, and CAFE (Corporate Average Fuel Economy) fleet averaging. Also drives chassis assembly torque specifications and suspension tuning parameters.',
    `hand_of_drive` STRING COMMENT 'Steering wheel position for this production variant: LHD (Left-Hand Drive) for markets such as USA, Germany; RHD (Right-Hand Drive) for markets such as UK, Japan, Australia. Determines instrument panel assembly variant, steering column routing, and body shop tooling configuration.. Valid values are `LHD|RHD`',
    `homologation_status` STRING COMMENT 'Regulatory type-approval and homologation status for this production variant in the target destination market: PENDING (application submitted), CERTIFIED (full approval granted), CONDITIONAL (provisional approval with conditions), EXPIRED (certification lapsed), NOT_REQUIRED. Governs whether the variant can be legally sold in the destination market.. Valid values are `PENDING|CERTIFIED|CONDITIONAL|EXPIRED|NOT_REQUIRED`',
    `is_ckd_eligible` BOOLEAN COMMENT 'Indicates whether this production variant can be produced as a CKD (Completely Knocked Down) kit for assembly at an overseas plant (True = CKD eligible). Drives export documentation, customs tariff classification, and overseas plant BOM (Bill of Materials) configuration in SAP MM.',
    `is_jis_eligible` BOOLEAN COMMENT 'Indicates whether this production variant is eligible for JIS (Just-in-Sequence) supplier call-off sequencing (True = JIS eligible). JIS-eligible variants require sequenced component delivery synchronized to the build sequence, impacting supplier logistics contracts and MES call-off trigger configuration.',
    `is_line_compatible` BOOLEAN COMMENT 'Indicates whether this production variant has been validated as feasible for assembly on the assigned production line (True = compatible, False = not compatible). Serves as the primary gate flag in MES (Manufacturing Execution System) build sequence feasibility validation and JIS (Just-in-Sequence) call-off authorization.',
    `is_ota_capable` BOOLEAN COMMENT 'Indicates whether this production variant supports OTA (Over-the-Air) software updates for ECU (Electronic Control Unit) and infotainment systems (True = OTA capable). Drives connected vehicle service provisioning in Geotab/Bosch IoT platform and UNECE UN R156 software update regulatory compliance.',
    `max_consecutive_builds` STRING COMMENT 'Maximum number of consecutive units of this production variant that can be scheduled back-to-back in the build sequence without violating line balancing or ergonomic constraints. Enforced by MES (Manufacturing Execution System) JIS (Just-in-Sequence) sequencing rules to prevent operator fatigue and tooling overload.',
    `mes_variant_reference` STRING COMMENT 'Cross-reference identifier for this production variant in the Apriso/Dassault MES (Manufacturing Execution System). Used for real-time build sequence call-off, WIP (Work in Progress) tracking, and quality gate routing on the shop floor.. Valid values are `^[A-Z0-9-]{3,30}$`',
    `model_year` STRING COMMENT 'Four-digit model year (MY) for which this production variant is defined and authorized. Governs BOM (Bill of Materials) version applicability, regulatory homologation, and CAFE (Corporate Average Fuel Economy) compliance grouping. Range: 2000–2040.',
    `ncap_safety_rating` STRING COMMENT 'Overall NCAP (New Car Assessment Programme) safety star rating achieved by this production variant (1 to 5 stars, or NOT_RATED if not yet assessed). Applicable to Euro NCAP, NHTSA NCAP, or ANCAP depending on destination market. Used for regulatory compliance reporting and marketing communications.. Valid values are `1_STAR|2_STAR|3_STAR|4_STAR|5_STAR|NOT_RATED`',
    `option_package_code` STRING COMMENT 'Code identifying the bundled option package associated with this production variant (e.g., TECH_PKG, SAFETY_PKG, LUXURY_PKG). Maps to a specific set of BOM (Bill of Materials) components and assembly operations in Siemens Teamcenter PLM and SAP PP configurable material management.. Valid values are `^[A-Z0-9]{2,15}$`',
    `paint_process_type` STRING COMMENT 'Classification of the paint application process required for this production variant: STANDARD (solid colour), METALLIC, PEARL, MATTE, or TWO_TONE. Determines paint booth routing, cure cycle parameters, and paint material BOM (Bill of Materials) components in the body shop and paint shop assembly stages.. Valid values are `STANDARD|METALLIC|PEARL|MATTE|TWO_TONE`',
    `powertrain_type` STRING COMMENT 'Classification of the vehicle powertrain technology for this variant: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), or FCEV (Fuel Cell Electric Vehicle). Drives assembly process routing, tooling requirements, and EPA/CARB emissions compliance classification.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `ppap_status` STRING COMMENT 'Current PPAP (Production Part Approval Process) approval status for this production variant. PPAP approval is a mandatory quality gate before SOP (Start of Production) under IATF 16949. Status values: NOT_REQUIRED, PENDING, SUBMITTED, APPROVED, REJECTED. Drives production release authorization in MES.. Valid values are `NOT_REQUIRED|PENDING|SUBMITTED|APPROVED|REJECTED`',
    `regulatory_region` STRING COMMENT 'Regulatory compliance region grouping for this production variant, used to apply the correct homologation ruleset: NAFTA (North America), EU (European Union), APAC (Asia-Pacific), LATAM (Latin America), MEA (Middle East & Africa), CHINA. Determines applicable NCAP (New Car Assessment Programme) standards, emissions regulations, and safety certification requirements.. Valid values are `NAFTA|EU|APAC|LATAM|MEA|CHINA`',
    `sap_material_number` STRING COMMENT 'SAP S/4HANA material master number (MM module) corresponding to this production variants configurable material (KMAT). Used for MRP (Material Requirements Planning), production order creation in SAP PP, and cost object controlling in SAP CO.. Valid values are `^[A-Z0-9]{8,18}$`',
    `sop_date` DATE COMMENT 'Date on which this production variant is authorized to enter volume production (SOP — Start of Production). Used for production planning gate reviews, PPAP (Production Part Approval Process) milestone tracking, and supplier readiness confirmation.',
    `standard_build_hours` DECIMAL(18,2) COMMENT 'Standard labor hours required to complete the full assembly of this production variant from stamping through final assembly and PDI (Pre-Delivery Inspection). Used for production cost standard setting, workforce planning, and SAP CO (Controlling) cost object calculation.',
    `takt_time_seconds` STRING COMMENT 'Allocated takt time in seconds for building this production variant on the assigned production line. Represents the available production time divided by customer demand rate. Used for JIS (Just-in-Sequence) scheduling, capacity planning, and bottleneck identification in MES (Manufacturing Execution System).',
    `teamcenter_variant_code` STRING COMMENT 'Cross-reference identifier for this production variant in Siemens Teamcenter PLM (Product Lifecycle Management) variant configuration module. Enables traceability between the manufacturing master data record and the engineering variant definition in the PLM system of record.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `transmission_type` STRING COMMENT 'Type of transmission fitted in this production variant: AUTOMATIC (conventional automatic), MANUAL (manual gearbox), CVT (Continuously Variable Transmission), DCT (Dual-Clutch Transmission), or SINGLE_SPEED (for BEV/FCEV). Drives assembly routing to the correct powertrain marriage station and torque tooling specification.. Valid values are `AUTOMATIC|MANUAL|CVT|DCT|SINGLE_SPEED`',
    `trim_level_code` STRING COMMENT 'Alphanumeric code identifying the equipment and feature trim level for this variant (e.g., BASE, XLE, PLATINUM, SPORT). Determines option package applicability, BOM (Bill of Materials) component selection, and MSRP (Manufacturer Suggested Retail Price) tier in the commercial catalog.. Valid values are `^[A-Z0-9]{1,10}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this production variant record was most recently modified. Used for change data capture (CDC) in the Databricks Silver Layer pipeline and for engineering change audit trail compliance under IATF 16949 documented information control.',
    `v2x_capable` BOOLEAN COMMENT 'Indicates whether this production variant is equipped with V2X (Vehicle-to-Everything) communication hardware (True = V2X capable). Drives telematics module assembly sequencing, spectrum licensing compliance, and connected mobility service activation in Geotab/Bosch IoT platform.',
    `variant_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying this production variant within the manufacturing system. Used as the primary business key in MES (Manufacturing Execution System), PLM (Product Lifecycle Management), and SAP PP (Production Planning) for variant identification and cross-system referencing. Sourced from Siemens Teamcenter PLM variant configuration.. Valid values are `^[A-Z0-9]{4,20}$`',
    `variant_name` STRING COMMENT 'Human-readable descriptive name of the production variant (e.g., F-Series SuperCrew 4x4 BEV Long Range). Used in build sequence planning, shop floor documentation, and JIS (Just-in-Sequence) scheduling displays.',
    `variant_status` STRING COMMENT 'Current lifecycle status of the production variant within the manufacturing master data: ACTIVE (currently buildable), PLANNED (approved for future SOP), INACTIVE (not currently scheduled), DISCONTINUED (past EOP), ON_HOLD (temporarily suspended pending engineering change or regulatory review). Drives MES build feasibility checks.. Valid values are `ACTIVE|INACTIVE|PLANNED|DISCONTINUED|ON_HOLD`',
    `vehicle_model_code` STRING COMMENT 'OEM (Original Equipment Manufacturer) internal model code identifying the vehicle platform or nameplate (e.g., F150, RAV4, MODEL3). Links the production variant to the vehicle program in PLM (Product Lifecycle Management) and SAP MM (Materials Management).. Valid values are `^[A-Z0-9]{2,10}$`',
    `wltp_range_km` DECIMAL(18,2) COMMENT 'Official WLTP (Worldwide Harmonised Light Vehicles Test Procedure) certified driving range in kilometres for BEV and PHEV variants. Null for ICE and HEV variants. Used for EU regulatory labelling, EPA range certification cross-reference, and consumer-facing range claims.',
    CONSTRAINT pk_production_variant PRIMARY KEY(`production_variant_id`)
) COMMENT 'Reference master defining the valid production variants (option combinations) that can be built on a specific production line for a given model year. Captures variant code, model, MY, powertrain type (ICE, HEV, PHEV, BEV), body style, trim level, market destination, and line compatibility flags. Supports build sequence feasibility validation and JIS sequencing rules. Distinct from the commercial product catalog — this is the manufacturing-feasible variant definition. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` (
    `scrap_record_id` BIGINT COMMENT 'Unique surrogate identifier for each scrap record transaction in the manufacturing domain. Primary key for the scrap_record data product.',
    `employee_id` BIGINT COMMENT 'Reference to the supervisor or quality engineer who authorized the scrap disposition. Required for IATF 16949 nonconforming output control and SAP CO posting authorization.',
    `defect_record_id` BIGINT COMMENT 'Reference to the quality defect or nonconformance record in the SAP QM or MES quality module that triggered this scrap event. Links scrap to the broader quality management workflow.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant where the scrap event occurred. Used for plant-level PPM (Parts Per Million) defect rate reporting and cost center allocation.',
    `production_order_id` BIGINT COMMENT 'Reference to the production order under which the scrapped material or component was being processed. Links scrap to SAP PP production order for cost variance accounting.',
    `work_center_id` BIGINT COMMENT 'Reference to the work center or process station where the scrap event was detected and recorded. Enables work-center-level scrap analysis and bottleneck identification.',
    `assembly_stage_code` STRING COMMENT 'The manufacturing assembly stage at which the scrap was detected. STAMP = Stamping, BODY = Body Shop, PAINT = Paint Shop, TRIM = Trim Assembly, CHASSIS = Chassis Assembly, FINAL = Final Assembly, PDI = Pre-Delivery Inspection (PDI). Critical for stage-level scrap rate analysis. [ENUM-REF-CANDIDATE: STAMP|BODY|PAINT|TRIM|CHASSIS|FINAL|PDI — 7 candidates stripped; promote to reference product]',
    `bom_component_number` STRING COMMENT 'The BOM (Bill of Materials) component position number of the scrapped part within the vehicle BOM structure. Used for BOM-level scrap impact analysis and engineering change management in Siemens Teamcenter PLM.',
    `co2_impact_kg` DECIMAL(18,2) COMMENT 'Estimated CO2 equivalent emissions impact in kilograms associated with the scrapped material, based on the materials embodied carbon factor. Used for environmental sustainability reporting and EPA/ISO 14001 carbon footprint tracking.',
    `corrective_action_reference` STRING COMMENT 'Reference number to the corrective action report (CAR) or 8D problem-solving report initiated as a result of this scrap event. Links to the quality corrective action management system.',
    `cost_center_code` STRING COMMENT 'SAP CO cost center code to which the scrap cost variance is posted. Derived from the work centers cost center assignment. Enables departmental cost accountability for scrap losses.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this scrap record was first created in the source system (SAP or MES). Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the scrap_value and salvage_value amounts (e.g., USD, EUR, JPY, MXN). Aligns with the plants company code currency in SAP S/4HANA.. Valid values are `^[A-Z]{3}$`',
    `detection_method_code` STRING COMMENT 'Code indicating the inspection or detection method used to identify the defect leading to scrap. VISUAL = visual inspection; GAUGE = gauge measurement; CMM = Coordinate Measuring Machine; SPC = Statistical Process Control (SPC) chart alert; FUNCTIONAL = functional test failure; AUTOMATED = automated vision system; AUDIT = quality audit finding. [ENUM-REF-CANDIDATE: VISUAL|GAUGE|CMM|SPC|FUNCTIONAL|AUTOMATED|AUDIT — 7 candidates stripped; promote to reference product]',
    `disposal_method_code` STRING COMMENT 'Code indicating how the scrapped material is to be or was physically disposed of. RECYCLE = sent to recycling; LANDFILL = disposed to landfill; REWORK = redirected to rework process; RETURN_SUPPLIER = returned to supplier; INCINERATE = incinerated; RESALE = sold as scrap metal or secondary material.. Valid values are `RECYCLE|LANDFILL|REWORK|RETURN_SUPPLIER|INCINERATE|RESALE`',
    `disposal_reference` STRING COMMENT 'Reference number for the disposal authorization document, waste manifest, or environmental permit associated with the scrapped material disposal. Required for EPA and ISO 14001 environmental compliance documentation.',
    `inspection_point_code` STRING COMMENT 'Code identifying the specific quality gate or inspection point in the production routing where the defect was detected and the scrap decision was made. Aligns with the APQP (Advanced Product Quality Planning) control plan.',
    `is_hazardous_material` BOOLEAN COMMENT 'Indicates whether the scrapped material is classified as hazardous (e.g., battery electrolyte, paint solvents, hydraulic fluid). True = hazardous; requires special disposal handling per EPA and DOT regulations.',
    `is_safety_related` BOOLEAN COMMENT 'Indicates whether the scrapped component is a safety-critical part (e.g., airbag, brake component, steering system part). True = safety-related; triggers mandatory FMEA (Failure Mode and Effects Analysis) review and NHTSA notification assessment.',
    `is_warranty_relevant` BOOLEAN COMMENT 'Indicates whether the scrap event is relevant to warranty analysis, i.e., the defect type matches known warranty failure modes. True = relevant; used to correlate manufacturing scrap patterns with field warranty claims.',
    `mes_transaction_code` STRING COMMENT 'The unique transaction identifier assigned by the Apriso/Dassault MES system when the scrap event was recorded on the shop floor. Used for cross-system traceability between MES and SAP.',
    `model_year` STRING COMMENT 'The vehicle model year (MY) associated with the production order or vehicle unit being scrapped. Used for model-year-level scrap cost reporting and CAFE/regulatory compliance tracking.',
    `part_number` STRING COMMENT 'The SAP material number or BOM (Bill of Materials) component part number of the scrapped item. Null if the scrapped item is a complete vehicle unit (VIN-level scrap). Used for BOM-level scrap analysis and MRP (Material Requirements Planning) adjustments.',
    `ppm_contribution` DECIMAL(18,2) COMMENT 'The PPM (Parts Per Million) defect rate contribution of this individual scrap event, calculated as (scrap_quantity / total production quantity) × 1,000,000. Used as a raw input for PPM defect rate KPI reporting to management and customers.',
    `production_line_code` STRING COMMENT 'Code identifying the specific production line where the scrap event occurred. Used for line-level scrap rate trending and capacity impact analysis.',
    `root_cause_code` STRING COMMENT 'Standardized root cause classification code assigned after investigation, used for corrective action tracking and FMEA (Failure Mode and Effects Analysis) updates. Examples: TOOL_WEAR, PARAM_DRIFT, INCOMING_MATL, OPERATOR_SKILL, DESIGN_TOLERANCE. [ENUM-REF-CANDIDATE: TOOL_WEAR|PARAM_DRIFT|INCOMING_MATL|OPERATOR_SKILL|DESIGN_TOLERANCE|MAINT_FAILURE|PROCESS_CHANGE|ENVIRONMENT — promote to reference product]',
    `salvage_value` DECIMAL(18,2) COMMENT 'The recoverable monetary value from the scrapped material after disposal (e.g., scrap metal resale, recycled material value). Net scrap cost = scrap_value minus salvage_value. Used in SAP CO variance reporting.',
    `sap_movement_type` STRING COMMENT 'SAP MM goods movement type used to post the scrap transaction. 551 = Scrapping from unrestricted stock; 552 = Reversal of scrapping; 553 = Scrapping from quality inspection stock; 554 = Reversal of scrapping from QI stock. Critical for SAP CO variance posting reconciliation.. Valid values are `551|552|553|554`',
    `sap_posting_document_number` STRING COMMENT 'The SAP FI/CO accounting document number generated when the scrap value was posted to the production variance account. Null if not yet financially posted. Used for financial audit trail and period-end closing reconciliation.',
    `scrap_category` STRING COMMENT 'High-level classification of the scrap event origin for management reporting and corrective action routing. process = manufacturing process failure; material = incoming material defect; design = engineering design issue; tooling = tooling or fixture failure; supplier = supplier-caused defect; operator_error = human error.. Valid values are `process|material|design|tooling|supplier|operator_error`',
    `scrap_document_number` STRING COMMENT 'Externally visible, human-readable document number assigned to this scrap transaction, typically generated by SAP MM/PP goods movement (movement type 551/552). Used for audit trail and cross-system reconciliation.. Valid values are `^SCR-[0-9]{4}-[0-9]{8}$`',
    `scrap_quantity` DECIMAL(18,2) COMMENT 'The quantity of material or components scrapped in this transaction, expressed in the base unit of measure of the material (e.g., EA for each, KG for weight-based materials, M for length-based). Must be greater than zero.',
    `scrap_reason_code` STRING COMMENT 'Standardized reason code classifying the root cause of the scrap event, sourced from the SAP QM defect catalog or MES reason code library. Examples: DMGD (Damaged), WELD_FAIL (Weld Failure), PAINT_DEF (Paint Defect), DIM_OOT (Dimensional Out of Tolerance), MATL_DEF (Material Defect). [ENUM-REF-CANDIDATE: DMGD|WELD_FAIL|PAINT_DEF|DIM_OOT|MATL_DEF|OPER_ERR|TOOLING|SETUP_ERR|DESIGN_DEF|SUPPLIER_DEF — promote to reference product]',
    `scrap_reason_description` STRING COMMENT 'Free-text narrative description of the scrap reason, providing additional context beyond the reason code. Entered by the operator or quality technician at the time of scrap recording in MES.',
    `scrap_status` STRING COMMENT 'Current lifecycle status of the scrap record. pending = awaiting supervisor confirmation; confirmed = approved and posted to SAP CO; disposed = material physically removed; reversed = scrap posting reversed; under_review = flagged for quality investigation.. Valid values are `pending|confirmed|disposed|reversed|under_review`',
    `scrap_timestamp` TIMESTAMP COMMENT 'The precise date and time when the scrap event was recorded on the shop floor via MES (Manufacturing Execution System). This is the principal business event timestamp, distinct from record audit timestamps.',
    `scrap_value` DECIMAL(18,2) COMMENT 'The gross standard cost value of the scrapped material or component, calculated as scrap quantity multiplied by the SAP standard cost rate. Posted to SAP CO production variance account. Used for financial reporting of manufacturing losses.',
    `shift_code` STRING COMMENT 'Code identifying the production shift during which the scrap event occurred. D = Day, A = Afternoon, N = Night, E = Extended. Enables shift-level scrap pattern analysis for workforce and process improvement.. Valid values are `D|A|N|E`',
    `supplier_code` STRING COMMENT 'SAP vendor code of the external supplier who provided the scrapped material or component, if the scrap root cause is supplier-related. Used for supplier PPM (Parts Per Million) defect rate reporting and PPAP (Production Part Approval Process) review triggers.',
    `unit_of_measure` STRING COMMENT 'Base unit of measure for the scrap quantity, aligned with SAP material master UoM configuration. EA = Each, KG = Kilogram, M = Meter, L = Liter, M2 = Square Meter, M3 = Cubic Meter, PC = Piece. [ENUM-REF-CANDIDATE: EA|KG|M|L|M2|M3|PC — 7 candidates stripped; promote to reference product]',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this scrap record, such as status changes, quantity corrections, or authorization updates.',
    `vehicle_model_code` STRING COMMENT 'Internal vehicle model or platform code associated with the scrapped component or vehicle unit (e.g., F150, RAV4, Model3). Enables model-level scrap rate analysis and BOM (Bill of Materials) impact assessment.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number (VIN) of the vehicle unit being scrapped, if the scrap event applies to a complete or partially assembled vehicle. Null for component-level scrap. Conforms to ISO 3779 VIN standard.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `weight_kg` DECIMAL(18,2) COMMENT 'Physical weight of the scrapped material in kilograms. Used for environmental reporting (ISO 14001 waste generation metrics), recycling tracking, and logistics planning for scrap removal.',
    CONSTRAINT pk_scrap_record PRIMARY KEY(`scrap_record_id`)
) COMMENT 'Transactional record capturing scrapped materials, components, or vehicle units during the manufacturing process. Tracks scrap item (part number or VIN), scrap quantity, scrap reason code, scrap location (work center, process stage), production order reference, scrap value, disposal method, and authorization reference. Feeds SAP CO production variance accounting and quality PPM (Parts Per Million) defect rate reporting. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` (
    `manufacturing_supply_agreement_id` BIGINT COMMENT 'Primary key for the SupplyAgreement association',
    `manufacturing_packaging_specification_id` BIGINT COMMENT 'Reference to the packaging spec used for shipments to this plant',
    `plant_id` BIGINT COMMENT 'Foreign key linking to the plant',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier',
    `procurement_supply_agreement_id` BIGINT COMMENT 'SSOT reference to procurement.procurement_supply_agreement (resolves cross-domain duplicate of supply_agreement).',
    `approval_date` DATE COMMENT 'Date the agreement was approved',
    `approval_status` STRING COMMENT 'Current approval status of the agreement (e.g., Approved, Pending)',
    `effective_end_date` DATE COMMENT 'Date the agreement expires or is terminated',
    `effective_start_date` DATE COMMENT 'Date the agreement becomes effective',
    `freight_terms` STRING COMMENT 'Freight terms agreed (e.g., FOB, CIF)',
    `is_preferred_supplier` BOOLEAN COMMENT 'Flag indicating if this supplier is the preferred source for the plant',
    `lead_time_days` STRING COMMENT 'Number of days from order to delivery for this plant‑supplier pair',
    `manufacturing_supply_agreement_status` STRING COMMENT 'Current status of the agreement (Active, Inactive, Suspended)',
    `minimum_order_quantity` STRING COMMENT 'Minimum quantity the supplier will accept for this plant',
    `quality_rating` STRING COMMENT 'Quality rating assigned to the supplier for this plant',
    `shipping_method` STRING COMMENT 'Preferred shipping method for deliveries',
    CONSTRAINT pk_manufacturing_supply_agreement PRIMARY KEY(`manufacturing_supply_agreement_id`)
) COMMENT 'Represents the contractual agreement between a manufacturing plant and a supplier. Each record captures the specific terms that apply to that plant‑supplier pair, such as lead time, minimum order quantity, pricing, and quality requirements.. Existence Justification: Each manufacturing plant can source materials from multiple suppliers, and each supplier can serve multiple plants. The business manages these plant‑supplier links through contracts that capture lead times, minimum order quantities, pricing, and other terms. The relationship is actively created, updated, and tracked as a distinct agreement. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` (
    `vehicle_mobility_subscription_id` BIGINT COMMENT 'Primary key for the VehicleMobilitySubscription association',
    `mobility_service_id` BIGINT COMMENT 'Foreign key linking to the mobility service offering',
    `service_tier_id` BIGINT COMMENT 'Reference to the pricing tier applicable to this subscription',
    `vehicle_build_id` BIGINT COMMENT 'Foreign key linking to the vehicle build record',
    `billing_amount` DECIMAL(18,2) COMMENT 'Monetary amount billed for the subscription period',
    `subscription_end_date` DATE COMMENT 'Date when the vehicles subscription to the service ends or is scheduled to end',
    `subscription_start_date` DATE COMMENT 'Date when the vehicles subscription to the service begins',
    `vehicle_mobility_subscription_status` STRING COMMENT 'Current status of the subscription (e.g., active, suspended, cancelled)',
    CONSTRAINT pk_vehicle_mobility_subscription PRIMARY KEY(`vehicle_mobility_subscription_id`)
) COMMENT 'Represents the contractual relationship between a vehicle build and a mobility service. Each record captures the period of subscription, billing details, status, and the service tier applicable to that vehicle.. Existence Justification: Each vehicle build can be subscribed to multiple mobility services (e.g., remote diagnostics, OTA updates) and each mobility service can be subscribed by many vehicle builds across the fleet. The subscription is an operational contract that is created, updated, and terminated by business users, and it carries its own attributes such as start/end dates, billing amount, and status. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` (
    `compliance_certification_id` BIGINT COMMENT 'Primary key for the ComplianceCertification association',
    `compliance_emissions_certification_id` BIGINT COMMENT 'SSOT reference to compliance.compliance_emissions_certification (resolves cross-domain duplicate of certification).',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to the production order',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to the regulatory requirement',
    `certification_date` DATE COMMENT 'Date when the compliance was certified for this order‑requirement pair',
    `compliance_status` STRING COMMENT 'Current compliance status for this order‑requirement pair (e.g., Compliant, Non‑Compliant, Pending)',
    `evidence_document_path` STRING COMMENT 'File system or URL path to the evidence document supporting compliance',
    CONSTRAINT pk_compliance_certification PRIMARY KEY(`compliance_certification_id`)
) COMMENT 'This association product records the compliance certification of a production order against a specific regulatory requirement. It captures the compliance status, supporting evidence document path, and the date the certification was achieved for each order‑requirement pair.. Existence Justification: Each production order must be verified against multiple regulatory requirements, and each regulatory requirement applies to many production orders. The compliance status, supporting evidence, and certification date are recorded for every order‑requirement pair, and quality engineers actively create, update, and delete these records as part of the manufacturing compliance process. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` (
    `production_order_allocation_id` BIGINT COMMENT 'Primary key for the production_order_allocation association',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to the dealership',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to the production order',
    `allocation_date` DATE COMMENT 'Date when the allocation was created or scheduled',
    `allocation_number` STRING COMMENT 'Unique identifier for the allocation instance',
    `allocation_status` STRING COMMENT 'Current status of the allocation (e.g., pending, confirmed, shipped)',
    `allocation_type` STRING COMMENT 'Type of allocation (e.g., standard, expedited, special)',
    `priority_tier` STRING COMMENT 'Priority tier assigned to the allocation for fulfillment sequencing',
    CONSTRAINT pk_production_order_allocation PRIMARY KEY(`production_order_allocation_id`)
) COMMENT 'Represents the allocation of a manufacturing production order to a dealership. Each record links one production order to one dealership and captures allocation-specific details such as allocation number, status, date, priority tier, and type.. Existence Justification: Production orders are work orders that generate vehicles, and the allocation process assigns portions of these orders to multiple dealerships for distribution. A single production order can be split across several dealerships, and each dealership receives many production orders over time. The allocation itself carries attributes such as allocation number, status, date, priority tier, and type, which are managed as a distinct business entity. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` (
    `agv_route_id` BIGINT COMMENT 'Primary key for agv_route',
    `agv_start_location_id` BIGINT COMMENT 'Identifier of the location where the AGV begins the route.',
    `reverse_agv_route_id` BIGINT COMMENT 'Self-referencing FK on agv_route (reverse_agv_route_id)',
    `storage_location_id` BIGINT COMMENT 'Identifier of the location where the AGV ends the route.',
    `allowed_load_kg` DECIMAL(18,2) COMMENT 'Maximum load weight that can be safely transported on the route.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the route record was first created in the system.',
    `effective_from` DATE COMMENT 'Date when the route becomes operationally effective.',
    `effective_until` DATE COMMENT 'Date when the route is retired or superseded; null if open‑ended.',
    `energy_consumption_kwh_per_cycle` DECIMAL(18,2) COMMENT 'Average electrical energy consumed by an AGV to complete the route once.',
    `estimated_cycle_time_seconds` STRING COMMENT 'Typical time for an AGV to complete one full traversal of the route.',
    `is_bidirectional` BOOLEAN COMMENT 'Indicates whether the route can be traversed in both directions.',
    `is_dynamic_route` BOOLEAN COMMENT 'True if the route can be altered in real time based on production demands.',
    `last_inspection_timestamp` TIMESTAMP COMMENT 'Date and time when the route was last inspected for safety and compliance.',
    `maintenance_window` STRING COMMENT 'Scheduled time window during which the route may be taken offline for maintenance.',
    `max_speed_m_per_s` DECIMAL(18,2) COMMENT 'Maximum permissible speed for AGVs on this route.',
    `notes` STRING COMMENT 'Free‑form text for any supplemental information about the route.',
    `priority_level` STRING COMMENT 'Numeric priority (1 = highest) used by the scheduler to rank routes.',
    `route_category` STRING COMMENT 'Business priority category that influences scheduling and resource allocation.',
    `route_code` STRING COMMENT 'Unique alphanumeric code assigned to the route for lookup and integration with MES.',
    `route_length_meters` DECIMAL(18,2) COMMENT 'Total physical length of the route measured in meters.',
    `route_name` STRING COMMENT 'Human‑readable name of the AGV route used for display and reporting.',
    `route_type` STRING COMMENT 'Classification of the route purpose within the plant.',
    `route_version` STRING COMMENT 'Incremental version number tracking changes to the route definition.',
    `safety_rating` STRING COMMENT 'Safety classification based on risk assessment for the route.',
    `agv_route_status` STRING COMMENT 'Current lifecycle status of the route.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the route record.',
    `waypoint_count` STRING COMMENT 'Number of intermediate waypoints between start and end locations.',
    CONSTRAINT pk_agv_route PRIMARY KEY(`agv_route_id`)
) COMMENT 'Master reference table for agv_route. Referenced by route_id. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`routing` (
    `routing_id` BIGINT COMMENT 'Primary key for routing',
    `alternate_routing_id` BIGINT COMMENT 'Self-referencing FK on routing (alternate_routing_id)',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant to which the routing belongs.',
    `change_approved_by` STRING COMMENT 'User identifier who approved the routing change.',
    `change_approved_date` DATE COMMENT 'Date when the routing change was formally approved.',
    `change_reason` STRING COMMENT 'Business reason for the most recent change to the routing.',
    `routing_code` STRING COMMENT 'External code used in MES and shop‑floor systems to reference this routing.',
    `compliance_standard` STRING COMMENT 'Applicable industry or internal compliance standard (e.g., ISO/TS 16949).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the routing record was first created in the master system.',
    `routing_description` STRING COMMENT 'Free‑form description of the routing purpose, scope and special instructions.',
    `effective_end_date` DATE COMMENT 'Date when the routing is retired or superseded; null if open‑ended.',
    `effective_start_date` DATE COMMENT 'Date when the routing becomes valid for production planning.',
    `is_default` BOOLEAN COMMENT 'True if this routing is the default for its product family.',
    `last_review_date` DATE COMMENT 'Date when the routing was last reviewed for accuracy or compliance.',
    `material_type` STRING COMMENT 'Primary material category processed by the routing (e.g., steel, aluminum, composite).',
    `notes` STRING COMMENT 'Additional free‑form comments, special handling instructions, or exceptions.',
    `operation_count` STRING COMMENT 'Total count of discrete work‑center steps defined in the routing.',
    `product_family` STRING COMMENT 'High‑level product family (e.g., SUV, Truck, EV) that uses this routing.',
    `quality_check_required` BOOLEAN COMMENT 'True if the routing mandates a quality inspection step.',
    `reviewed_by` STRING COMMENT 'User identifier of the person who performed the last review.',
    `route_name` STRING COMMENT 'Human‑readable name of the routing used on shop floor displays and reports.',
    `routing_status` STRING COMMENT 'Current lifecycle state of the routing.',
    `routing_type` STRING COMMENT 'Category of the routing based on the manufacturing process it supports.',
    `safety_level` STRING COMMENT 'Safety classification of the routing based on hazard analysis.',
    `total_cycle_time_minutes` DECIMAL(18,2) COMMENT 'Planned total processing time for the routing, expressed in minutes.',
    `updated_by` STRING COMMENT 'User identifier who performed the latest update.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the routing record.',
    `version_number` STRING COMMENT 'Incremental version number for change management of the routing.',
    `work_center` STRING COMMENT 'Primary work‑center or cell where the routing is executed.',
    `created_by` STRING COMMENT 'User identifier who originally created the routing.',
    CONSTRAINT pk_routing PRIMARY KEY(`routing_id`)
) COMMENT 'Master reference table for routing. Referenced by routing_id. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` (
    `factory_calendar_id` BIGINT COMMENT 'Primary key for factory_calendar',
    `base_factory_calendar_id` BIGINT COMMENT 'Self-referencing FK on factory_calendar (base_factory_calendar_id)',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant to which the calendar applies.',
    `calendar_code` STRING COMMENT 'Business‑defined unique code used to reference the calendar in planning systems.',
    `calendar_name` STRING COMMENT 'Human‑readable name of the calendar (e.g., "2025 Production Schedule").',
    `calendar_type` STRING COMMENT 'Classification of the calendar purpose: production, maintenance, holiday, or plant shutdown.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the calendar record was first created in the system.',
    `day_of_year` STRING COMMENT 'Ordinal day of the year (1‑365/366) for quick lookup.',
    `factory_calendar_description` STRING COMMENT 'Free‑form description providing additional context about the calendar.',
    `end_date` DATE COMMENT 'Last calendar date on which the schedule is valid (nullable for open‑ended calendars).',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the calendar belongs, used for financial reporting.',
    `is_holiday` BOOLEAN COMMENT 'Flag indicating whether a given calendar day is a recognized holiday or plant shutdown.',
    `is_work_day` BOOLEAN COMMENT 'Flag indicating whether a given calendar day is a scheduled production work day.',
    `notes` STRING COMMENT 'Additional free‑form notes or comments from planners.',
    `plant_location` STRING COMMENT 'Standard three‑letter location code of the plant (e.g., "DET").',
    `shift_pattern` STRING COMMENT 'Standard shift pattern applied to the calendar (e.g., two 8‑hour shifts).',
    `start_date` DATE COMMENT 'First calendar date on which the schedule becomes effective.',
    `factory_calendar_status` STRING COMMENT 'Current lifecycle status of the calendar.',
    `timezone` STRING COMMENT 'IANA time‑zone identifier for the plant (e.g., "America/Detroit").',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent update to the calendar record.',
    `version_number` STRING COMMENT 'Incremental version of the calendar for change management.',
    `week_number` STRING COMMENT 'ISO week number within the calendar year.',
    CONSTRAINT pk_factory_calendar PRIMARY KEY(`factory_calendar_id`)
) COMMENT 'Master reference table for factory_calendar. Referenced by factory_calendar_id. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` (
    `operator_team_id` BIGINT COMMENT 'Primary key for operator_team',
    `employee_id` BIGINT COMMENT 'Employee ID of the team supervisor or lead.',
    `functional_location_id` BIGINT COMMENT 'Identifier of the manufacturing plant or facility where the team operates.',
    `parent_operator_team_id` BIGINT COMMENT 'Self-referencing FK on operator_team (parent_operator_team_id)',
    `production_line_id` BIGINT COMMENT 'Identifier of the production line that the team works on.',
    `average_cycle_time_seconds` DECIMAL(18,2) COMMENT 'Mean time taken to complete a single unit on the line.',
    `average_experience_years` DECIMAL(18,2) COMMENT 'Mean years of experience of team members.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the team record was first created in the system.',
    `operator_team_description` STRING COMMENT 'Additional notes or remarks about the team’s purpose, composition, or special considerations.',
    `downtime_minutes_last_month` STRING COMMENT 'Cumulative minutes of unplanned downtime for the team in the previous month.',
    `effective_end_date` DATE COMMENT 'Calendar date when the team is retired or disbanded (null if still active).',
    `effective_start_date` DATE COMMENT 'Calendar date when the team starts operating or is officially recognized.',
    `is_overtime_allowed` BOOLEAN COMMENT 'True if the team may work overtime shifts.',
    `last_safety_audit_date` DATE COMMENT 'Date when the team last underwent a safety audit.',
    `member_count` STRING COMMENT 'Total count of operators assigned to the team.',
    `operator_team_name` STRING COMMENT 'Descriptive name of the operator team (e.g., "Paint Line A Team").',
    `overtime_rate_multiplier` DECIMAL(18,2) COMMENT 'Factor applied to hourly wage when overtime is worked.',
    `quality_defect_rate_pct` DECIMAL(18,2) COMMENT 'Percentage of produced units that failed quality inspection.',
    `safety_training_completed` BOOLEAN COMMENT 'True if all team members have completed required safety training.',
    `shift` STRING COMMENT 'Standard shift the team works (day, night, or flexible).',
    `skill_level` STRING COMMENT 'Overall skill tier of the team based on competency assessments.',
    `operator_team_status` STRING COMMENT 'Current operational status of the team.',
    `team_code` STRING COMMENT 'Alphanumeric code that uniquely identifies the team in manufacturing execution systems.',
    `team_type` STRING COMMENT 'Functional classification of the team (e.g., assembly, paint, inspection).',
    `total_output_units_last_month` STRING COMMENT 'Number of finished units the team delivered in the prior month.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the team record.',
    `work_order_capacity_per_shift` STRING COMMENT 'Number of work orders the team can process in a standard shift.',
    CONSTRAINT pk_operator_team PRIMARY KEY(`operator_team_id`)
) COMMENT 'Master reference table for operator_team. Referenced by operator_team_id. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`energy_consumption_record` (
    `energy_consumption_record_id` BIGINT COMMENT '',
    `line_energy_meter_id` BIGINT COMMENT 'Source meter.',
    `plant_id` BIGINT COMMENT '',
    `production_line_id` BIGINT COMMENT '',
    `cost_amount` DECIMAL(18,2) COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `currency_code` STRING COMMENT '',
    `energy_consumed_kwh` DECIMAL(18,2) COMMENT '',
    `energy_kwh` DECIMAL(18,2) COMMENT '',
    `energy_source` STRING COMMENT '',
    `energy_source_type` STRING COMMENT 'Electricity, gas, steam, renewable, etc.',
    `measurement_date` DATE COMMENT '',
    `period_date` DATE COMMENT 'Aggregation date.',
    `reading_date` DATE COMMENT '',
    `reading_end_timestamp` TIMESTAMP COMMENT 'Reading window end.',
    `reading_start_timestamp` TIMESTAMP COMMENT 'Reading window start.',
    `renewable_flag` BOOLEAN COMMENT 'Whether from renewable source.',
    `renewable_share_pct` DECIMAL(18,2) COMMENT '',
    CONSTRAINT pk_energy_consumption_record PRIMARY KEY(`energy_consumption_record_id`)
) COMMENT 'Per-line and per-plant electrical energy consumption records for ESG and energy tracking. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`co2_emission_record` (
    `co2_emission_record_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `production_line_id` BIGINT COMMENT '',
    `calculation_method` STRING COMMENT 'Emission factor method.',
    `co2_equivalent_kg` DECIMAL(18,2) COMMENT '',
    `co2_kg` DECIMAL(18,2) COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `emission_factor` DECIMAL(18,2) COMMENT 'Applied emission factor.',
    `emission_scope` STRING COMMENT '',
    `emission_source` STRING COMMENT '',
    `measurement_date` DATE COMMENT '',
    `period_date` DATE COMMENT 'Aggregation date.',
    `reading_date` DATE COMMENT '',
    CONSTRAINT pk_co2_emission_record PRIMARY KEY(`co2_emission_record_id`)
) COMMENT 'Plant and line CO2 emission records for CSRD/EU Taxonomy ESG reporting. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`water_usage_record` (
    `water_usage_record_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `production_line_id` BIGINT COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `discharge_liters` DECIMAL(18,2) COMMENT 'Water discharged.',
    `measurement_date` DATE COMMENT '',
    `period_date` DATE COMMENT 'Aggregation date.',
    `reading_date` DATE COMMENT '',
    `recycled_flag` BOOLEAN COMMENT '',
    `recycled_water_liters` DECIMAL(18,2) COMMENT '',
    `water_consumed_liters` DECIMAL(18,2) COMMENT '',
    `water_liters` DECIMAL(18,2) COMMENT '',
    `water_source` STRING COMMENT '',
    `water_source_type` STRING COMMENT 'Municipal, well, recycled, etc.',
    CONSTRAINT pk_water_usage_record PRIMARY KEY(`water_usage_record_id`)
) COMMENT 'Plant and line water usage records for ESG water stewardship reporting. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`line_energy_meter` (
    `line_energy_meter_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `production_line_id` BIGINT COMMENT '',
    `calibration_date` DATE COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `install_date` DATE COMMENT '',
    `installation_date` DATE COMMENT 'Meter installation date.',
    `last_calibration_date` DATE COMMENT 'Last calibration date.',
    `measurement_unit` STRING COMMENT '',
    `meter_code` STRING COMMENT '',
    `meter_status` STRING COMMENT '',
    `meter_type` STRING COMMENT '',
    `scada_node_code` STRING COMMENT 'SCADA integration node.',
    `unit_of_measure` STRING COMMENT 'Measurement unit.',
    CONSTRAINT pk_line_energy_meter PRIMARY KEY(`line_energy_meter_id`)
) COMMENT 'Physical energy meters installed per production line for granular energy metering. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`oee_daily_snapshot` (
    `oee_daily_snapshot_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `production_line_id` BIGINT COMMENT '',
    `shift_id` BIGINT COMMENT 'Shift.',
    `availability_pct` DECIMAL(18,2) COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `downtime_minutes` DECIMAL(18,2) COMMENT '',
    `good_units` STRING COMMENT '',
    `good_units_produced` STRING COMMENT 'Good units from production_confirmation.',
    `oee_pct` DECIMAL(18,2) COMMENT '',
    `performance_pct` DECIMAL(18,2) COMMENT '',
    `planned_production_minutes` DECIMAL(18,2) COMMENT '',
    `planned_production_time_minutes` DECIMAL(18,2) COMMENT 'Planned time.',
    `quality_pct` DECIMAL(18,2) COMMENT '',
    `snapshot_date` DATE COMMENT '',
    `total_produced_units` STRING COMMENT '',
    `total_units_produced` STRING COMMENT 'Units confirmed.',
    `units_good` STRING COMMENT '',
    `units_produced` STRING COMMENT '',
    CONSTRAINT pk_oee_daily_snapshot PRIMARY KEY(`oee_daily_snapshot_id`)
) COMMENT 'Pre-aggregated daily OEE snapshot (availability x performance x quality) derived from downtime_event and production_confirmation. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`equipment_effectiveness_metric` (
    `equipment_effectiveness_metric_id` BIGINT COMMENT '',
    `oee_daily_snapshot_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `production_line_id` BIGINT COMMENT '',
    `work_center_id` BIGINT COMMENT '',
    `availability_pct` DECIMAL(18,2) COMMENT 'Availability.',
    `created_timestamp` TIMESTAMP COMMENT '',
    `metric_date` DATE COMMENT '',
    `metric_name` STRING COMMENT '',
    `metric_type` STRING COMMENT 'MTBF, MTTR, utilization, etc.',
    `metric_unit` STRING COMMENT '',
    `metric_value` DECIMAL(18,2) COMMENT '',
    `performance_pct` DECIMAL(18,2) COMMENT 'Performance.',
    `quality_pct` DECIMAL(18,2) COMMENT 'Quality.',
    `unit_of_measure` STRING COMMENT '',
    CONSTRAINT pk_equipment_effectiveness_metric PRIMARY KEY(`equipment_effectiveness_metric_id`)
) COMMENT 'Equipment-level effectiveness metrics for OEE analytics. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` (
    `manufacturing_packaging_specification_id` BIGINT COMMENT 'Primary key for packaging_specification',
    `packaging_specification_id` BIGINT COMMENT 'Self-referencing FK on packaging_specification (outer_packaging_specification_id)',
    `packaging_specification_ssot_id` BIGINT COMMENT 'FK to SSOT owner engineering.packaging_specification for packaging_specification (resolves cross-domain duplicate).',
    `vendor_id` BIGINT COMMENT 'FK to procurement.vendor',
    `packaging_vendor_id` BIGINT COMMENT 'Unique identifier of the packaging supplier.',
    `barcode_pattern` STRING COMMENT 'Pattern or format of the barcode (e.g., numeric length).',
    `barcode_type` STRING COMMENT 'Standard type of barcode used on the packaging.',
    `manufacturing_packaging_specification_code` STRING COMMENT 'External code used to reference the packaging specification in ERP/MES systems.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the specification record was first created in the system.',
    `default_package_weight_kg` DECIMAL(18,2) COMMENT 'Standard weight of the packaged unit in kilograms.',
    `manufacturing_packaging_specification_description` STRING COMMENT 'Detailed textual description of the packaging specification, including purpose and usage notes.',
    `disposal_method` STRING COMMENT 'Recommended disposal or end‑of‑life method for the packaging.',
    `effective_from` DATE COMMENT 'Date when the specification becomes effective for production.',
    `effective_until` DATE COMMENT 'Date when the specification is retired or superseded (null if open‑ended).',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the package contains hazardous materials.',
    `height_cm` DECIMAL(18,2) COMMENT 'External height of the package in centimeters.',
    `last_review_date` DATE COMMENT 'Date when the specification was last reviewed for accuracy or compliance.',
    `length_cm` DECIMAL(18,2) COMMENT 'External length of the package in centimeters.',
    `material_type` STRING COMMENT 'Primary material used for the packaging.',
    `max_load_kg` DECIMAL(18,2) COMMENT 'Maximum permissible load weight for the package.',
    `manufacturing_packaging_specification_name` STRING COMMENT 'Human‑readable name of the packaging specification.',
    `notes` STRING COMMENT 'Free‑form field for additional remarks, exceptions, or special handling instructions.',
    `packaging_color` STRING COMMENT 'Standard color or color code of the packaging.',
    `packaging_cost_usd` DECIMAL(18,2) COMMENT 'Standard cost of the packaging per unit in US dollars.',
    `packaging_shape` STRING COMMENT 'Geometric shape of the packaging.',
    `recyclable_flag` BOOLEAN COMMENT 'True if the packaging is recyclable according to company policy.',
    `regulatory_compliance_status` STRING COMMENT 'Current compliance status with relevant packaging regulations.',
    `manufacturing_packaging_specification_status` STRING COMMENT 'Current lifecycle state of the specification.',
    `temperature_range_c` STRING COMMENT 'Acceptable temperature range for the package, expressed as "min-max" in Celsius.',
    `manufacturing_packaging_specification_type` STRING COMMENT 'Category of the specification indicating its role (e.g., primary packaging, secondary packaging, custom).',
    `units_per_carton` STRING COMMENT 'Number of individual units contained in one carton.',
    `units_per_pallet` STRING COMMENT 'Number of cartons that can be stacked on a standard pallet.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the specification record.',
    `version_number` STRING COMMENT 'Version identifier for change management of the specification.',
    `volume_per_unit_cubic_m` DECIMAL(18,2) COMMENT 'Physical volume occupied by a single packaged unit.',
    `weight_per_unit_kg` DECIMAL(18,2) COMMENT 'Weight of a single packaged unit.',
    `width_cm` DECIMAL(18,2) COMMENT 'External width of the package in centimeters.',
    CONSTRAINT pk_manufacturing_packaging_specification PRIMARY KEY(`manufacturing_packaging_specification_id`)
) COMMENT 'Master reference table for packaging_specification. Referenced by packaging_specification_id. [preservation_guardrail: verified]';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ADD CONSTRAINT `fk_manufacturing_production_line_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ADD CONSTRAINT `fk_manufacturing_production_line_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_production_bom_id` FOREIGN KEY (`production_bom_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_bom`(`production_bom_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_routing_id` FOREIGN KEY (`routing_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`routing`(`routing_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`shift`(`shift_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ADD CONSTRAINT `fk_manufacturing_build_sequence_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ADD CONSTRAINT `fk_manufacturing_build_sequence_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ADD CONSTRAINT `fk_manufacturing_build_sequence_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ADD CONSTRAINT `fk_manufacturing_build_sequence_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`shift`(`shift_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_build_stage_id` FOREIGN KEY (`build_stage_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`build_stage`(`build_stage_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_operator_team_id` FOREIGN KEY (`operator_team_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`operator_team`(`operator_team_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`shift`(`shift_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ADD CONSTRAINT `fk_manufacturing_build_stage_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ADD CONSTRAINT `fk_manufacturing_shop_floor_event_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ADD CONSTRAINT `fk_manufacturing_shop_floor_event_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ADD CONSTRAINT `fk_manufacturing_shop_floor_event_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`shift`(`shift_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ADD CONSTRAINT `fk_manufacturing_shop_floor_event_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_routing_id` FOREIGN KEY (`routing_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`routing`(`routing_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`shift`(`shift_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ADD CONSTRAINT `fk_manufacturing_production_schedule_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ADD CONSTRAINT `fk_manufacturing_production_schedule_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ADD CONSTRAINT `fk_manufacturing_shift_factory_calendar_id` FOREIGN KEY (`factory_calendar_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`factory_calendar`(`factory_calendar_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ADD CONSTRAINT `fk_manufacturing_shift_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ADD CONSTRAINT `fk_manufacturing_shift_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ADD CONSTRAINT `fk_manufacturing_downtime_event_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ADD CONSTRAINT `fk_manufacturing_downtime_event_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ADD CONSTRAINT `fk_manufacturing_downtime_event_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ADD CONSTRAINT `fk_manufacturing_downtime_event_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ADD CONSTRAINT `fk_manufacturing_production_confirmation_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ADD CONSTRAINT `fk_manufacturing_production_confirmation_reversed_confirmation_production_confirmation_id` FOREIGN KEY (`reversed_confirmation_production_confirmation_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_confirmation`(`production_confirmation_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ADD CONSTRAINT `fk_manufacturing_production_confirmation_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`shift`(`shift_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ADD CONSTRAINT `fk_manufacturing_production_confirmation_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage` ADD CONSTRAINT `fk_manufacturing_manufacturing_tooling_usage_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage` ADD CONSTRAINT `fk_manufacturing_manufacturing_tooling_usage_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ADD CONSTRAINT `fk_manufacturing_process_parameter_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ADD CONSTRAINT `fk_manufacturing_process_parameter_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ADD CONSTRAINT `fk_manufacturing_process_parameter_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ADD CONSTRAINT `fk_manufacturing_process_parameter_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ADD CONSTRAINT `fk_manufacturing_agv_movement_agv_route_id` FOREIGN KEY (`agv_route_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`agv_route`(`agv_route_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ADD CONSTRAINT `fk_manufacturing_agv_movement_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ADD CONSTRAINT `fk_manufacturing_agv_movement_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`shift`(`shift_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ADD CONSTRAINT `fk_manufacturing_agv_movement_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ADD CONSTRAINT `fk_manufacturing_capacity_plan_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ADD CONSTRAINT `fk_manufacturing_capacity_plan_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ADD CONSTRAINT `fk_manufacturing_capacity_plan_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ADD CONSTRAINT `fk_manufacturing_capacity_plan_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`shift`(`shift_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ADD CONSTRAINT `fk_manufacturing_changeover_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ADD CONSTRAINT `fk_manufacturing_changeover_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ADD CONSTRAINT `fk_manufacturing_changeover_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`shift`(`shift_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ADD CONSTRAINT `fk_manufacturing_production_variant_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ADD CONSTRAINT `fk_manufacturing_production_variant_production_bom_id` FOREIGN KEY (`production_bom_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_bom`(`production_bom_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ADD CONSTRAINT `fk_manufacturing_production_variant_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ADD CONSTRAINT `fk_manufacturing_production_variant_routing_id` FOREIGN KEY (`routing_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`routing`(`routing_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ADD CONSTRAINT `fk_manufacturing_scrap_record_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ADD CONSTRAINT `fk_manufacturing_scrap_record_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ADD CONSTRAINT `fk_manufacturing_scrap_record_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ADD CONSTRAINT `fk_manufacturing_manufacturing_supply_agreement_manufacturing_packaging_specification_id` FOREIGN KEY (`manufacturing_packaging_specification_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification`(`manufacturing_packaging_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ADD CONSTRAINT `fk_manufacturing_manufacturing_supply_agreement_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` ADD CONSTRAINT `fk_manufacturing_vehicle_mobility_subscription_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` ADD CONSTRAINT `fk_manufacturing_compliance_certification_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` ADD CONSTRAINT `fk_manufacturing_production_order_allocation_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ADD CONSTRAINT `fk_manufacturing_agv_route_reverse_agv_route_id` FOREIGN KEY (`reverse_agv_route_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`agv_route`(`agv_route_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ADD CONSTRAINT `fk_manufacturing_routing_alternate_routing_id` FOREIGN KEY (`alternate_routing_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`routing`(`routing_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ADD CONSTRAINT `fk_manufacturing_routing_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ADD CONSTRAINT `fk_manufacturing_factory_calendar_base_factory_calendar_id` FOREIGN KEY (`base_factory_calendar_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`factory_calendar`(`factory_calendar_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ADD CONSTRAINT `fk_manufacturing_factory_calendar_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ADD CONSTRAINT `fk_manufacturing_operator_team_parent_operator_team_id` FOREIGN KEY (`parent_operator_team_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`operator_team`(`operator_team_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ADD CONSTRAINT `fk_manufacturing_operator_team_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`energy_consumption_record` ADD CONSTRAINT `fk_manufacturing_energy_consumption_record_line_energy_meter_id` FOREIGN KEY (`line_energy_meter_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`line_energy_meter`(`line_energy_meter_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`energy_consumption_record` ADD CONSTRAINT `fk_manufacturing_energy_consumption_record_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`energy_consumption_record` ADD CONSTRAINT `fk_manufacturing_energy_consumption_record_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`co2_emission_record` ADD CONSTRAINT `fk_manufacturing_co2_emission_record_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`co2_emission_record` ADD CONSTRAINT `fk_manufacturing_co2_emission_record_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`water_usage_record` ADD CONSTRAINT `fk_manufacturing_water_usage_record_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`water_usage_record` ADD CONSTRAINT `fk_manufacturing_water_usage_record_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`line_energy_meter` ADD CONSTRAINT `fk_manufacturing_line_energy_meter_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`line_energy_meter` ADD CONSTRAINT `fk_manufacturing_line_energy_meter_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`oee_daily_snapshot` ADD CONSTRAINT `fk_manufacturing_oee_daily_snapshot_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`oee_daily_snapshot` ADD CONSTRAINT `fk_manufacturing_oee_daily_snapshot_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`oee_daily_snapshot` ADD CONSTRAINT `fk_manufacturing_oee_daily_snapshot_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`shift`(`shift_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`equipment_effectiveness_metric` ADD CONSTRAINT `fk_manufacturing_equipment_effectiveness_metric_oee_daily_snapshot_id` FOREIGN KEY (`oee_daily_snapshot_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`oee_daily_snapshot`(`oee_daily_snapshot_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`equipment_effectiveness_metric` ADD CONSTRAINT `fk_manufacturing_equipment_effectiveness_metric_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`equipment_effectiveness_metric` ADD CONSTRAINT `fk_manufacturing_equipment_effectiveness_metric_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`equipment_effectiveness_metric` ADD CONSTRAINT `fk_manufacturing_equipment_effectiveness_metric_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`manufacturing` SET TAGS ('dbx_pii_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`manufacturing` SET TAGS ('dbx_pii_domain' = 'manufacturing');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `agv_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Automated Guided Vehicle (AGV) Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `annual_capacity_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Annual Production Capacity (Units)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant City');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Commissioning Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `company_code` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Company Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `company_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Currency Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `daily_capacity_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Daily Production Capacity (Units)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `epa_facility_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Environmental Protection Agency (EPA) Facility Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `epa_facility_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{1,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `floor_area_sqm` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Floor Area (Square Meters)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `iatf_16949_certified` SET TAGS ('dbx_pii_business_glossary_term' = 'IATF 16949 Automotive Quality Certification Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `iso_14001_certified` SET TAGS ('dbx_pii_business_glossary_term' = 'ISO 14001 Environmental Management Certification Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `iso_9001_certified` SET TAGS ('dbx_pii_business_glossary_term' = 'ISO 9001 Quality Management Certification Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Latitude');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Longitude');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `manager` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Manager Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `mes_plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `mes_plant_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Za-z0-9_-]{1,50}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `model_year_current` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `model_year_current` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `plant_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `nhtsa_facility_code` SET TAGS ('dbx_pii_business_glossary_term' = 'National Highway Traffic Safety Administration (NHTSA) Facility Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `nhtsa_facility_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{1,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `number_of_assembly_lines` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Assembly Lines');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `number_of_shifts` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Production Shifts');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `operational_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Operational Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `operational_status` SET TAGS ('dbx_pii_value_regex' = 'active|idle|ramp_up|ramp_down|shutdown|decommissioned');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `ota_capable` SET TAGS ('dbx_pii_business_glossary_term' = 'Over-the-Air (OTA) Update Capable Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Phone Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `plant_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Postal Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `powertrain_types_produced` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Types Produced');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `powertrain_types_produced` SET TAGS ('dbx_pii_value_regex' = 'ice|ev|hev|phev|fcev|mixed');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `primary_vehicle_segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Vehicle Segment');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `region` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Region');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `scada_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Supervisory Control and Data Acquisition (SCADA) Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `short_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Short Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `short_name` SET TAGS ('dbx_pii_value_regex' = '^[A-Za-z0-9 ]{1,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `takt_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Takt Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `time_zone` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Time Zone');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `union_represented` SET TAGS ('dbx_pii_business_glossary_term' = 'Union Representation Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ALTER COLUMN `workforce_headcount` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Workforce Headcount');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Manager Employee ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Work Center Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `agv_integration_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Automated Guided Vehicle (AGV) Integration Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `automation_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Automation Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `automation_level` SET TAGS ('dbx_pii_value_regex' = 'manual|semi_automated|highly_automated|fully_automated');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `ckd_skd_capable` SET TAGS ('dbx_pii_business_glossary_term' = 'CKD/SKD Assembly Capability');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `ckd_skd_capable` SET TAGS ('dbx_pii_value_regex' = 'CKD|SKD|CBU|multi');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `conveyor_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Conveyor System Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `conveyor_type` SET TAGS ('dbx_pii_value_regex' = 'overhead_conveyor|floor_conveyor|skillet|agv_carrier|stationary|mixed');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `current_jph` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Actual Jobs Per Hour (JPH) Rate');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `designed_jph` SET TAGS ('dbx_pii_business_glossary_term' = 'Designed Jobs Per Hour (JPH) Throughput Rate');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `energy_consumption_kwh_per_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Energy Consumption per Unit (kWh)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `floor_space_sqm` SET TAGS ('dbx_pii_business_glossary_term' = 'Floor Space Area (Square Meters)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `iatf_audit_status` SET TAGS ('dbx_pii_business_glossary_term' = 'IATF 16949 Audit Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `iatf_audit_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|minor_nc|major_nc|suspended|not_audited');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `jis_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Just-in-Sequence (JIS) Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `last_iatf_audit_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last IATF 16949 Audit Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Planned Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `line_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `line_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `line_length_meters` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Length (Meters)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `line_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `line_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Operational Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `line_status` SET TAGS ('dbx_pii_value_regex' = 'active|idle|maintenance|ramp_up|ramp_down|decommissioned');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `line_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `max_vehicle_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Vehicle Weight Capacity (kg)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `mes_line_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Line Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `mixed_model_capable` SET TAGS ('dbx_pii_business_glossary_term' = 'Mixed Model Production Capable Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `model_year_capability` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY) Capability Range');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `model_year_capability` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}(-[0-9]{4})?$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `next_maintenance_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Scheduled Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `number_of_stations` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Work Stations');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `paint_booth_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Paint Booth Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `paint_booth_type` SET TAGS ('dbx_pii_value_regex' = 'waterborne|solventborne|powder_coat|none');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `plc_system_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Programmable Logic Controller (PLC) System Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `powertrain_type_capability` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type Capability');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `powertrain_type_capability` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV|multi');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `quality_gate_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Count');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `robot_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Industrial Robot Count');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `safety_certification_expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Certification Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Certification Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_pii_value_regex' = 'certified|expired|pending_renewal|not_required');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `scada_system_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Supervisory Control and Data Acquisition (SCADA) System Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `shift_configuration` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Configuration');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `shift_configuration` SET TAGS ('dbx_pii_value_regex' = '1_shift|2_shift|3_shift|4_shift_rotating');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `takt_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Takt Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `vehicle_platform_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Platform Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ALTER COLUMN `weld_gun_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Weld Gun Count');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Supervisor ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_responsible_supervisor_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Supervisor ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_responsible_supervisor_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_responsible_supervisor_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `agv_integration_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Automated Guided Vehicle (AGV) Integration Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `automation_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Automation Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `automation_level` SET TAGS ('dbx_pii_value_regex' = 'fully_automated|highly_automated|semi_automated|manual|collaborative');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `available_capacity_hours_per_day` SET TAGS ('dbx_pii_business_glossary_term' = 'Available Capacity Hours Per Day');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `capacity_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Category');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `capacity_category` SET TAGS ('dbx_pii_value_regex' = 'bottleneck|standard|buffer|flexible');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_center_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center Category');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_center_category` SET TAGS ('dbx_pii_value_regex' = 'machine|labor|machine_labor|external');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_center_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `cycle_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Cycle Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `decommissioning_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Decommissioning Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_center_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `energy_consumption_kw` SET TAGS ('dbx_pii_business_glossary_term' = 'Energy Consumption (Kilowatts)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `floor_area_sqm` SET TAGS ('dbx_pii_business_glossary_term' = 'Floor Area (Square Meters)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `is_bottleneck` SET TAGS ('dbx_pii_business_glossary_term' = 'Bottleneck Station Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `is_jis_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Just-in-Sequence (JIS) Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `is_quality_gate` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `labor_rate_per_hour` SET TAGS ('dbx_pii_business_glossary_term' = 'Labor Rate Per Hour');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `labor_rate_per_hour` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Calibration Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `location_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `machine_rate_per_hour` SET TAGS ('dbx_pii_business_glossary_term' = 'Machine Rate Per Hour');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `machine_rate_per_hour` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `maintenance_strategy_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Maintenance Strategy Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `maintenance_strategy_code` SET TAGS ('dbx_pii_value_regex' = 'preventive|predictive|corrective|condition_based');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `mean_time_between_failures_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Mean Time Between Failures (MTBF) Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `mean_time_to_repair_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Mean Time to Repair (MTTR) Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `mes_work_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_center_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `next_calibration_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Calibration Due Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `number_of_shifts` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Shifts');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `number_of_workers` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Workers');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `overhead_rate_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Overhead Rate Percent');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `overhead_rate_percent` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `plc_node_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Programmable Logic Controller (PLC) Node ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `process_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Category');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `production_line_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `production_line_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `sap_work_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `scada_node_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Supervisory Control and Data Acquisition (SCADA) Node ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `setup_time_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Setup Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `shift_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `shift_model_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{1,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `standard_value_key` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Value Key');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `standard_value_key` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `takt_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Takt Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `teardown_time_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Teardown Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_center_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_center_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|under_maintenance|decommissioned|planned');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_center_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ALTER COLUMN `work_center_type` SET TAGS ('dbx_pii_value_regex' = 'manual|automated|robotic|semi_automated|inspection|rework');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `configuration_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Configuration ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `production_bom_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `quote_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quote Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `routing_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Routing ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `shift_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Material ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `supply_purchase_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `actual_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Production Cost');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `actual_cost` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `actual_finish_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Production Finish Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `actual_labor_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Labor Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `actual_machine_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Machine Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Production Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `assembly_sequence_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Sequence Number (JIS)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Confirmed Production Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `mes_order_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Order Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `order_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Creation Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `order_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `order_number` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9-]{6,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `order_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `order_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `order_type` SET TAGS ('dbx_pii_value_regex' = 'vehicle_build|sub_assembly|rework|repair|prototype');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `planned_finish_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Production Finish Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `planned_labor_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Labor Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `planned_machine_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Machine Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Production Start Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `ppap_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Part Approval Process (PPAP) Required Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Priority');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `production_stage` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Stage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `production_stage` SET TAGS ('dbx_pii_value_regex' = 'stamping|body_shop|paint|final_assembly|powertrain|trim_chassis');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `quality_inspection_lot` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Inspection Lot Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `release_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Release Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `rework_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `scrap_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `sop_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Indicator');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `standard_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Production Cost');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `standard_cost` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `target_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Production Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `technical_completion_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Technical Completion Timestamp (TECO)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'EA|PC|SET|KG|L');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `vin_range_end` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN) Range End');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `vin_range_end` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `vin_range_start` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN) Range Start');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `vin_range_start` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ALTER COLUMN `wip_posting_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Work in Progress (WIP) Posting Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `build_sequence_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Sequence ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `configuration_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Configuration ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `build_vehicle_config_configuration_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Configuration ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `shift_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Assembly End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Assembly Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `assembly_stage` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Stage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `assembly_stage` SET TAGS ('dbx_pii_value_regex' = 'stamping|body_shop|paint|final_assembly|PDI');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `body_style_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Body Style Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `build_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `build_type` SET TAGS ('dbx_pii_value_regex' = 'retail|fleet|stock|pilot|homologation|press');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `customer_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Order Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `dealer_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `destination_market_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Market Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `destination_market_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `drive_configuration` SET TAGS ('dbx_pii_business_glossary_term' = 'Drive Configuration');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `drive_configuration` SET TAGS ('dbx_pii_value_regex' = 'FWD|RWD|AWD|4WD');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `exterior_color_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Exterior Color Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `freeze_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Sequence Freeze Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Interior Color Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `is_frozen` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Sequence Frozen Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `is_priority_build` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Priority Build Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `jis_call_off_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Just-in-Sequence (JIS) Call-Off Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `mes_sequence_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'MES Sequence Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `option_package_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Option Package Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `planned_build_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Build Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `planned_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Assembly End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `planned_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Assembly Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `quality_hold_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Hold Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `regulatory_variant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Variant Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `sequence_change_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Sequence Change Reason');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `sequence_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Just-in-Sequence (JIS) Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `sequence_revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Sequence Revision Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `sequence_set_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Sequence Set Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `sequence_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Sequence Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `sequence_status` SET TAGS ('dbx_pii_value_regex' = 'planned|released|in_progress|completed|cancelled|on_hold');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `sequence_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Sequence Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `sequence_type` SET TAGS ('dbx_pii_value_regex' = 'initial|revised|emergency|resequenced');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `takt_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Takt Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `transmission_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `transmission_type` SET TAGS ('dbx_pii_value_regex' = 'automatic|manual|CVT|DCT|single_speed');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `trim_level_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Level Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `vehicle_build_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Build Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `build_stage_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Stage Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `operator_team_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator Team ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `shift_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Shift ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Ownership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `assembly_line_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Line Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `battery_serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'High-Voltage Battery Serial Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `body_shop_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Body Shop Stage End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `body_shop_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Body Shop Stage Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `body_style` SET TAGS ('dbx_pii_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `body_style` SET TAGS ('dbx_pii_value_regex' = 'sedan|suv|truck|van|coupe|convertible');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `bom_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Version');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `build_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Build End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `build_sequence_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Sequence Number (JIS)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `build_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `build_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Build Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `build_status` SET TAGS ('dbx_pii_value_regex' = 'in_progress|completed|on_hold|rework|scrapped|cancelled');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `build_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `build_type` SET TAGS ('dbx_pii_value_regex' = 'standard|ckd|skd|pilot|prototype');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `chassis_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Chassis Assembly Stage End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `chassis_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Chassis Assembly Stage Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `end_of_line_test_result` SET TAGS ('dbx_pii_business_glossary_term' = 'End-of-Line (EOL) Test Result');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `end_of_line_test_result` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|retest_required');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `engine_serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Engine Serial Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `final_assembly_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Final Assembly Stage End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `final_assembly_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Final Assembly Stage Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `hold_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Hold Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `hold_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Hold Reason Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `homologation_market` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Market');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `paint_color_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Paint Color Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `paint_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Paint Stage End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `paint_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Paint Stage Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `quality_gate_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `quality_gate_status` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|conditional_pass|pending');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `rework_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Count');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `rework_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Required Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `scheduled_build_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Scheduled Build Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `sop_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `stamping_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Stamping Stage End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `stamping_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Stamping Stage Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `transmission_serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Transmission Serial Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `trim_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Assembly Stage End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `trim_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Assembly Stage Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `build_stage_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Stage ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supervisor Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `agv_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV (Automated Guided Vehicle) Enabled Indicator');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `applicable_vehicle_types` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Vehicle Types');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `automation_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Automation Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `automation_level` SET TAGS ('dbx_pii_value_regex' = 'manual|semi-automated|fully-automated|robotic');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `buffer_capacity_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Buffer Capacity (Units)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `co2_emission_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard CO2 Emission (kg per Unit)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `control_plan_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Plan Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `control_plan_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `energy_consumption_kwh` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Energy Consumption (kWh per Unit)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'EOP (End of Production) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `fmea_reference_code` SET TAGS ('dbx_pii_business_glossary_term' = 'FMEA (Failure Mode and Effects Analysis) Reference Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `fmea_reference_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `hazmat_classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Materials (HazMat) Classification');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `hazmat_classification` SET TAGS ('dbx_pii_value_regex' = 'none|flammable|corrosive|toxic|oxidizer|environmental-hazard');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `iatf_process_category` SET TAGS ('dbx_pii_business_glossary_term' = 'IATF (International Automotive Task Force) Process Category');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `iatf_process_category` SET TAGS ('dbx_pii_value_regex' = 'special-characteristic|standard-process|critical-process|monitoring-only');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `is_quality_gate` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Indicator');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `is_rework_eligible` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Eligible Indicator');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `labor_headcount_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Labor Headcount');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `max_temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Process Temperature (Celsius)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `mes_stage_code` SET TAGS ('dbx_pii_business_glossary_term' = 'MES (Manufacturing Execution System) Stage ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `mes_stage_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `min_temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Minimum Process Temperature (Celsius)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `model_year_applicability` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY) Applicability');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `model_year_applicability` SET TAGS ('dbx_pii_value_regex' = '^(MYd{4}(,MYd{4})*|ALL)$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `plant_area_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Area Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `plant_area_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{2,15}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `plc_program_code` SET TAGS ('dbx_pii_business_glossary_term' = 'PLC (Programmable Logic Controller) Program ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `plc_program_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `ppm_target` SET TAGS ('dbx_pii_business_glossary_term' = 'PPM (Parts Per Million) Defect Rate Target');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `preceding_stage_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Preceding Stage Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `preceding_stage_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `process_area` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Area');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `quality_inspection_plan_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Inspection Plan Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `quality_inspection_plan_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{3,25}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `safety_classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Classification');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `safety_classification` SET TAGS ('dbx_pii_value_regex' = 'standard|elevated-risk|critical-safety|restricted-access');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `sap_operation_code` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Operation Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `sap_operation_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `sequence_order` SET TAGS ('dbx_pii_business_glossary_term' = 'Stage Sequence Order');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Pattern');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_pii_value_regex' = 'single|double|triple|continuous');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'SOP (Start of Production) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `spc_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'SPC (Statistical Process Control) Enabled Indicator');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `stage_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Stage Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `stage_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `stage_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Stage Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `stage_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Stage Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `stage_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Stage Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `stage_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|pilot|suspended|decommissioned');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `stage_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Stage Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `stage_type` SET TAGS ('dbx_pii_value_regex' = 'assembly|fabrication|coating|inspection|testing|logistics');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `standard_cycle_time_sec` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Cycle Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `succeeding_stage_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Succeeding Stage Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `succeeding_stage_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `takt_time_sec` SET TAGS ('dbx_pii_business_glossary_term' = 'Takt Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `work_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ALTER COLUMN `work_center_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `shop_floor_event_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shop Floor Event ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment / Machine ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `shift_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Shift ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `shop_equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment / Machine ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `shop_operator_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `shop_operator_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `shop_operator_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `tooling_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Tool ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `shop_tooling_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Tool ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN) ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `agv_unit_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Automated Guided Vehicle (AGV) Unit ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `agv_unit_code` SET TAGS ('dbx_pii_value_regex' = '^AGV-[A-Z0-9]{2,15}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `assembly_area` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Area');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `event_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Shop Floor Event Category');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `event_category` SET TAGS ('dbx_pii_value_regex' = 'production|quality|material|equipment|safety|logistics');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `event_duration_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Event Duration (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `event_payload` SET TAGS ('dbx_pii_business_glossary_term' = 'Event Payload (JSON)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `event_source_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Event Source System');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `event_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Shop Floor Event Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `event_status` SET TAGS ('dbx_pii_value_regex' = 'open|confirmed|cancelled|on_hold|escalated');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Shop Floor Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `event_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Shop Floor Event Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `fault_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Fault / Alarm Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `fault_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `fault_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Fault / Alarm Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `hold_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Hold Reason Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `hold_reason_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `is_rework` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Indicator');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `is_within_spec` SET TAGS ('dbx_pii_business_glossary_term' = 'Within Specification Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `lower_control_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Lower Control Limit (LCL)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `measured_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured Process Value');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `measured_value_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured Value Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `mes_event_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Event Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `mes_event_number` SET TAGS ('dbx_pii_value_regex' = '^MES-[A-Z0-9]{4,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `oee_loss_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Overall Equipment Effectiveness (OEE) Loss Category');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `oee_loss_category` SET TAGS ('dbx_pii_value_regex' = 'availability|performance|quality|no_loss');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `planned_cycle_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Cycle Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `process_step_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Process Step Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `process_step_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `production_line_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `production_line_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `program_number` SET TAGS ('dbx_pii_business_glossary_term' = 'PLC / Robot Program Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `program_number` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_.-]{2,40}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `quality_result` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Result');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `quality_result` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|rework|scrap|conditional_pass');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `rework_attempt_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Attempt Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `scrap_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Reason Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `scrap_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `sequence_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Just-in-Sequence (JIS) Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `station_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Station Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `station_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `station_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Station Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `upper_control_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Upper Control Limit (UCL)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `vin_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ALTER COLUMN `vin_number` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `wip_inventory_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work-in-Progress (WIP) Inventory ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inbound Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator Employee ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `inspection_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Inspection ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `routing_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Routing ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `shift_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `shift_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Material ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `wip_operator_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator Employee ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `wip_operator_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `wip_operator_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `actual_cycle_time_sec` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Cycle Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `assembly_stage` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Stage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `bom_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Version');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `buffer_zone_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Buffer Zone Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `engineering_change_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change Number (ECN)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `hold_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Hold Reason Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `inspection_result` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Result');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `inspection_result` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|conditional_pass|pending');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `is_rework_item` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Rework Item Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `location_entry_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Entry Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `location_exit_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Exit Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `mes_transaction_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Transaction ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `operation_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Operation End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `operation_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Operation Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `operation_number` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `operation_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Operation Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|EV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `priority_code` SET TAGS ('dbx_pii_business_glossary_term' = 'WIP Priority Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `priority_code` SET TAGS ('dbx_pii_value_regex' = 'NORMAL|HIGH|URGENT|EXPEDITE');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'WIP Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `sap_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Production Order Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `sap_order_number` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{8,12}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `scheduled_completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Scheduled Completion Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `scrap_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Reason Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `sequence_number` SET TAGS ('dbx_pii_business_glossary_term' = 'JIS Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `snapshot_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'WIP Snapshot Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `standard_cycle_time_sec` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Cycle Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `sub_assembly_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Sub-Assembly ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `supplier_deviation_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Deviation Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `wip_record_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Work-in-Progress (WIP) Record Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `wip_record_number` SET TAGS ('dbx_pii_value_regex' = '^WIP-[A-Z0-9]{3,6}-[0-9]{8}-[0-9]{6}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `wip_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Work-in-Progress (WIP) Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `wip_status` SET TAGS ('dbx_pii_value_regex' = 'in_process|on_hold|awaiting_inspection|scrapped|completed|rework');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `wip_valuation_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'WIP Valuation Amount');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ALTER COLUMN `wip_valuation_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` SET TAGS ('dbx_pii_coverage_preserved' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `production_schedule_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Schedule ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `billing_run_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Requirements Planning (MRP) Run ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `model_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `actual_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Production Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Schedule Approved By');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Schedule Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `assembly_process_stage` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Process Stage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `assembly_process_stage` SET TAGS ('dbx_pii_value_regex' = 'stamping|body_shop|paint|final_assembly|trim_chassis_final');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `available_capacity_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Available Production Capacity (Hours)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `body_style` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Body Style');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `body_style` SET TAGS ('dbx_pii_value_regex' = 'sedan|suv|truck|van|coupe|convertible');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `build_sequence_end` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Sequence End Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `build_sequence_start` SET TAGS ('dbx_pii_business_glossary_term' = 'Build Sequence Start Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `build_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Build Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `build_type` SET TAGS ('dbx_pii_value_regex' = 'standard|ckd|skd|pilot|pre_series');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `calloff_transmission_time` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Call-Off Transmission Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `capacity_utilization_pct` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Utilization Percentage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Confirmed Production Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `freeze_horizon_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Schedule Freeze Horizon Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `is_frozen` SET TAGS ('dbx_pii_business_glossary_term' = 'Schedule Frozen Indicator');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `planned_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Production Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|EV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `regulatory_market` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Market / Destination Country');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `schedule_change_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Schedule Change Reason');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `schedule_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Schedule Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `schedule_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Schedule End Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `schedule_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Schedule Notes');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `schedule_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Master Production Schedule (MPS) Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `schedule_number` SET TAGS ('dbx_pii_value_regex' = '^MPS-[A-Z0-9]{3,10}-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `schedule_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Schedule Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `schedule_status` SET TAGS ('dbx_pii_value_regex' = 'draft|released|frozen|in_execution|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `schedule_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Schedule Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `schedule_type` SET TAGS ('dbx_pii_value_regex' = 'daily|weekly|monthly');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `schedule_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Schedule Version Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `scheduled_end_time` SET TAGS ('dbx_pii_business_glossary_term' = 'Scheduled Production End Time');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `scheduled_start_time` SET TAGS ('dbx_pii_business_glossary_term' = 'Scheduled Production Start Time');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Shift Pattern');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_pii_value_regex' = 'single|double|triple|weekend');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `supplier_calloff_generated` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Call-Off Generated Indicator');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ALTER COLUMN `takt_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Takt Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `shift_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `factory_calendar_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Factory Calendar ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `agv_active` SET TAGS ('dbx_pii_business_glossary_term' = 'Automated Guided Vehicle (AGV) Active Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `break_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Break Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `break_schedule` SET TAGS ('dbx_pii_business_glossary_term' = 'Break Schedule Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `shift_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `shift_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `day_of_week_mask` SET TAGS ('dbx_pii_business_glossary_term' = 'Day of Week Mask');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `day_of_week_mask` SET TAGS ('dbx_pii_value_regex' = '^[01]{7}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `shift_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Effective Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `energy_consumption_target_kwh` SET TAGS ('dbx_pii_business_glossary_term' = 'Energy Consumption Target (kWh)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `gross_shift_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Shift Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `handover_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Handover Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `is_template` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Template Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `mes_shift_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Shift ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `mes_shift_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{1,50}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `shift_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `number_of_breaks` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Scheduled Breaks');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `oee_target_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Overall Equipment Effectiveness (OEE) Target Percentage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `overtime_eligible` SET TAGS ('dbx_pii_business_glossary_term' = 'Overtime Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `pattern_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Pattern Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `pattern_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `planned_end_time` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Shift End Time');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `planned_production_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Production Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `planned_start_time` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Shift Start Time');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `premium_pay_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Premium Pay Rate Multiplier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `premium_pay_rate` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `production_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Shift Model');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `production_model` SET TAGS ('dbx_pii_value_regex' = 'single_shift|two_shift|three_shift|four_shift_continental');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `sap_shift_code` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Shift Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `sap_shift_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{1,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `scada_zone_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Supervisory Control and Data Acquisition (SCADA) Zone Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `scada_zone_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `sequence_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `shift_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `shift_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|suspended|draft');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `shift_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `shift_type` SET TAGS ('dbx_pii_value_regex' = 'day|afternoon|night|weekend|overtime|shutdown');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `supervisor_role_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Supervisor Role Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `supervisor_role_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `target_takt_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Takt Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `target_units_per_shift` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Units Per Shift');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `timezone_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Timezone Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shift` ALTER COLUMN `workforce_headcount_target` SET TAGS ('dbx_pii_business_glossary_term' = 'Workforce Headcount Target');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `downtime_event_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Event ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Team ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `primary_equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Reported By Employee ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `affected_process_area` SET TAGS ('dbx_pii_business_glossary_term' = 'Affected Process Area');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `corrective_action_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `downtime_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Category');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `downtime_category` SET TAGS ('dbx_pii_value_regex' = 'mechanical_failure|tooling_change|material_shortage|quality_hold|scheduled_maintenance|changeover');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `downtime_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `downtime_type` SET TAGS ('dbx_pii_value_regex' = 'planned|unplanned');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `escalation_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Escalation Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `escalation_level` SET TAGS ('dbx_pii_value_regex' = 'none|supervisor|manager|plant_director');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `event_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Event Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `event_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Event Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `event_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Event Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `event_number` SET TAGS ('dbx_pii_value_regex' = '^DT-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `event_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Event Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `event_status` SET TAGS ('dbx_pii_value_regex' = 'open|in_progress|resolved|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `failure_mode_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Failure Mode Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `fault_location_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Fault Location Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `is_quality_hold_triggered` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Quality Hold Triggered Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `is_repeat_failure` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Repeat Failure Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `is_safety_related` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Safety Related Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `maintenance_cost_local` SET TAGS ('dbx_pii_business_glossary_term' = 'Maintenance Cost (Local Currency)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `maintenance_cost_local` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `notification_number` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP PM Notification Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `oee_availability_loss_pct` SET TAGS ('dbx_pii_business_glossary_term' = 'OEE Availability Loss Percentage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|EV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `production_loss_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Loss Units');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `resolution_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Resolution Notes');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Root Cause Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `scada_alarm_code` SET TAGS ('dbx_pii_business_glossary_term' = 'SCADA Alarm Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `shift_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Shift Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `shift_code` SET TAGS ('dbx_pii_value_regex' = 'shift_1|shift_2|shift_3|weekend');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `spare_parts_consumed` SET TAGS ('dbx_pii_business_glossary_term' = 'Spare Parts Consumed Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `time_to_repair_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Time to Repair (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `time_to_respond_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Time to Respond (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ALTER COLUMN `work_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Maintenance Work Order Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` SET TAGS ('dbx_pii_subdomain' = 'material_planning');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `production_bom_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Bill of Materials (BOM) ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `model_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `bom_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Bill of Materials (eBOM) Reference ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `production_ebom_reference_bom_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Bill of Materials (eBOM) Reference ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Approval Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Approved By (User ID)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_pii_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_pii_value_regex' = 'phase_1|phase_2|phase_3|phase_4|phase_5');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `assembly_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `assembly_type` SET TAGS ('dbx_pii_value_regex' = 'CBU|CKD|SKD');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `base_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Base Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `base_unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Base Unit of Measure (UoM)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `bom_alternative` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Alternative Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `bom_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `bom_level` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Level (Depth)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `bom_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `bom_status` SET TAGS ('dbx_pii_value_regex' = 'draft|released|frozen|superseded|obsolete');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `bom_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `bom_type` SET TAGS ('dbx_pii_value_regex' = 'production|phantom|sales|spare_parts|co_product');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `bom_usage` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Usage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `bom_usage` SET TAGS ('dbx_pii_value_regex' = 'production|engineering|universal|plant_maintenance|sales');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `bom_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Version');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `change_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Change Reason');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `component_count` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Component Count');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `eco_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change Order (ECO) Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `effectivity_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Effectivity End Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `effectivity_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Effectivity Start Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `homologation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `homologation_status` SET TAGS ('dbx_pii_value_regex' = 'pending|in_progress|approved|rejected|expired');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `is_configurable` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Configurable BOM Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `is_phantom_assembly` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Phantom Assembly Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `material_number` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Material Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `ppap_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Part Approval Process (PPAP) Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `ppap_status` SET TAGS ('dbx_pii_value_regex' = 'not_required|pending|submitted|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `predecessor_bom_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Predecessor BOM Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `production_line_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `regulatory_market_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Market Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `release_date` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Release Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `released_by` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Released By (User ID)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `revision_level` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Revision Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `routing_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Routing Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `routing_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `routing_number` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `superseded_by_bom_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Superseded By BOM Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `vehicle_configuration_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Configuration Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_bom_component` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_bom_component` SET TAGS ('dbx_pii_subdomain' = 'material_planning');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_bom_component` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_bom_component` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_bom_component` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` SET TAGS ('dbx_pii_subdomain' = 'material_planning');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `material_consumption_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Consumption ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Confirmed By Employee ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Material ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `assembly_station_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Station Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `bom_item_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Item Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `bom_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Version');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `consumption_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Consumption Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `consumption_status` SET TAGS ('dbx_pii_value_regex' = 'posted|reversed|blocked|pending');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `consumption_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Consumption Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `cost_variance_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Variance Amount');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `cost_variance_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `goods_movement_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Goods Movement Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `goods_movement_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Goods Movement Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `material_cost_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `material_cost_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `mes_transaction_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Transaction ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `operation_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Operation Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `original_goods_movement_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Original Goods Movement Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `planned_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Quantity (BOM)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|EV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `production_line_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `quality_inspection_lot` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Inspection Lot');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `quantity_consumed` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Consumed');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `quantity_variance` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Variance');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `scrap_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Indicator');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `scrap_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Reason Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `shift_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `shift_code` SET TAGS ('dbx_pii_value_regex' = 'DAY|AFTERNOON|NIGHT');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `source_system_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `source_system_code` SET TAGS ('dbx_pii_value_regex' = 'SAP_MM|MES_APRISO|SAP_PP|MANUAL');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `supplier_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `variance_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Variance Percentage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ALTER COLUMN `wip_order_sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Work in Progress (WIP) Order Sequence');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` SET TAGS ('dbx_pii_subdomain' = 'material_planning');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Order ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `defect_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Defect ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Assigned Technician ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Rework End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `actual_rework_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Rework Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Rework Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `assembly_stage_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Stage Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `bom_component_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Component Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `corrective_action_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `defect_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `defect_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `defect_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `defect_location_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Location Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `detection_method_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Detection Method Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `detection_method_code` SET TAGS ('dbx_pii_value_regex' = 'visual_inspection|automated_gauge|functional_test|audit_check|customer_feedback');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `detection_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Detection Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `disposition_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Disposition Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `disposition_code` SET TAGS ('dbx_pii_value_regex' = 'repaired|scrapped|concession|use_as_is|return_to_supplier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `inspection_point_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Point Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `is_regulatory_hold` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Hold Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `is_safety_related` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety-Related Defect Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `line_stoppage_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Stoppage Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `planned_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Rework End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `planned_rework_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Rework Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `planned_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Rework Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Priority Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `production_line_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `re_inspection_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Re-Inspection Required Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `re_inspection_result` SET TAGS ('dbx_pii_business_glossary_term' = 'Re-Inspection Result');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `re_inspection_result` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|conditional_pass|pending');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_attempt_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Attempt Count');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_instruction_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Instruction Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_labor_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Labor Cost');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_labor_cost` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_material_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Material Cost');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_material_cost` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Order Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_order_number` SET TAGS ('dbx_pii_value_regex' = '^RWK-[A-Z]{3}-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_order_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Order Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_order_status` SET TAGS ('dbx_pii_value_regex' = 'open|in_progress|on_hold|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `rework_type` SET TAGS ('dbx_pii_value_regex' = 'inline_repair|offline_rework|teardown|subassembly_rework|cosmetic_repair');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Root Cause Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `scrap_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `source_system_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `source_system_code` SET TAGS ('dbx_pii_value_regex' = 'SAP_QM|MES_APRISO|MES_DASSAULT|MANUAL');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `production_confirmation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Confirmation ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `production_operator_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `production_operator_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `production_operator_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `reversed_confirmation_production_confirmation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Reversed Confirmation ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `shift_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `activity_type_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Activity Type Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `activity_type_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4,6}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `assembly_stage` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Stage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `base_unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Base Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `confirmation_entry_mode` SET TAGS ('dbx_pii_business_glossary_term' = 'Confirmation Entry Mode');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `confirmation_entry_mode` SET TAGS ('dbx_pii_value_regex' = 'manual|automatic|mes_interface|backflush');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `confirmation_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Confirmation Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `confirmation_number` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{10,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `confirmation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Confirmation Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `confirmation_status` SET TAGS ('dbx_pii_value_regex' = 'created|posted|reversed|cancelled|partial|final');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `confirmation_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Confirmation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `confirmation_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Confirmation Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `confirmation_type` SET TAGS ('dbx_pii_value_regex' = 'partial|final|automatic|milestone|reversal');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `downtime_duration_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `downtime_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Reason Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `downtime_reason_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `final_confirmation_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Final Confirmation Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `goods_receipt_posted_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Goods Receipt Posted Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `labor_time_actual_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Labor Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `labor_time_planned_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Labor Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `machine_time_actual_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Machine Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `machine_time_planned_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Machine Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `material_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `material_number` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `mes_confirmation_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Confirmation Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `mes_confirmation_reference` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9-]{1,50}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `operation_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Operation Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `operation_number` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `order_settlement_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Settlement Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `order_settlement_status` SET TAGS ('dbx_pii_value_regex' = 'pending|settled|partially_settled|not_required');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `production_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `production_order_number` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{8,12}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `quality_inspection_lot` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Inspection Lot Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `quality_inspection_lot` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{12}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `rework_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `scrap_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `scrap_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Reason Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `scrap_reason_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `setup_time_actual_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Setup Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `setup_time_planned_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Setup Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `takt_time_actual_sec` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Takt Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `teardown_time_actual_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Teardown Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ALTER COLUMN `yield_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Yield Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage` SET TAGS ('dbx_pii_subdomain' = 'material_planning');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage` ALTER COLUMN `manufacturing_tooling_usage_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for manufacturing_tooling_usage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `process_parameter_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Parameter ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator Employee ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment / Machine ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `process_equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment / Machine ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `process_operator_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator Employee ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `process_operator_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `process_operator_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `tooling_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Tool ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `process_tooling_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Tool ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `vehicle_build_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Build ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `assembly_stage` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Stage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `control_plan_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Plan Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `control_plan_revision` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Plan Revision Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `data_collection_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Collection Method');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `data_collection_method` SET TAGS ('dbx_pii_value_regex' = 'automatic|semi_automatic|manual');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `deviation_from_nominal` SET TAGS ('dbx_pii_business_glossary_term' = 'Deviation from Nominal Value');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `gauge_calibration_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Calibration Due Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `is_out_of_control` SET TAGS ('dbx_pii_business_glossary_term' = 'Statistical Process Control (SPC) Out-of-Control Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `lower_control_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Lower Control Limit (LCL)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `lower_spec_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Lower Specification Limit (LSL)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `measured_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured Process Parameter Value');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `measurement_system_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement System ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `mes_transaction_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Transaction ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `nominal_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Nominal (Target) Process Parameter Value');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `non_conformance_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Non-Conformance Report (NCR) Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `parameter_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Parameter Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `parameter_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{3,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `parameter_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Parameter Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `parameter_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Parameter Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `pass_fail_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Parameter Pass/Fail Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `pass_fail_status` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|warning|rework_required|inconclusive');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `plc_tag_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Programmable Logic Controller (PLC) Tag ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `reaction_plan_triggered` SET TAGS ('dbx_pii_business_glossary_term' = 'Reaction Plan Triggered Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `reading_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Parameter Reading Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `sample_number` SET TAGS ('dbx_pii_business_glossary_term' = 'SPC Sample Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `scada_system_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Supervisory Control and Data Acquisition (SCADA) System ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `shift_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Shift Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `shift_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `spc_rule_violated` SET TAGS ('dbx_pii_business_glossary_term' = 'Statistical Process Control (SPC) Rule Violated');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `subgroup_number` SET TAGS ('dbx_pii_business_glossary_term' = 'SPC Subgroup ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `upper_control_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Upper Control Limit (UCL)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Upper Specification Limit (USL)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `agv_movement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Automated Guided Vehicle (AGV) Movement ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `agv_route_id` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Route ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `shift_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `agv_controller_code` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Fleet Controller ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `agv_unit_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Automated Guided Vehicle (AGV) Unit ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `agv_unit_code` SET TAGS ('dbx_pii_value_regex' = '^AGV-[A-Z0-9]{3,12}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `assembly_stage` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Stage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `assembly_stage` SET TAGS ('dbx_pii_value_regex' = 'stamping|body_shop|paint|trim|chassis|final_assembly');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `average_speed_mps` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Average Speed (Metres per Second)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `battery_level_end_pct` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Battery Level at Movement End (Percentage)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `battery_level_start_pct` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Battery Level at Movement Start (Percentage)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Destination Location Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `destination_location_name` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Destination Location Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `distance_travelled_m` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Distance Travelled (Metres)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `fault_code` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Fault Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `fault_description` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Fault Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `fault_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Fault Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `is_manual_override` SET TAGS ('dbx_pii_business_glossary_term' = 'Manual Override Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `jis_call_off_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Just-in-Sequence (JIS) Call-Off Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `load_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Load Weight (Kilograms)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `mes_task_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Task ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `movement_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Movement End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `movement_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Movement Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `movement_status` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Movement Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `movement_status` SET TAGS ('dbx_pii_value_regex' = 'in_progress|completed|aborted|faulted|cancelled');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `movement_type` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Movement Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `movement_type` SET TAGS ('dbx_pii_value_regex' = 'load|transport|unload|charge|idle|fault');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Origin Location Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `origin_location_name` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Origin Location Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `part_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `planned_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Planned Movement End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `planned_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Planned Movement Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Movement Priority Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_value_regex' = 'critical|high|normal|low');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `quantity_transported` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Transported');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `route_deviation_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Route Deviation Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `source_system_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `capacity_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Plan ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Bottleneck Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plan Owner ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plan Owner ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `shift_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `available_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Available Production Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `bottleneck_constraint_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Bottleneck Constraint Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `capacity_gap_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Gap Units');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `capacity_plan_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Plan Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `capacity_plan_type` SET TAGS ('dbx_pii_value_regex' = 'rough_cut|detailed|constraint_based|what_if');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `capacity_utilization_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Utilization Percentage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `capex_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Capital Expenditure (CapEx) Amount');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `capex_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `capex_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Capital Expenditure (CapEx) Required Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `changeover_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Changeover Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `daily_production_target` SET TAGS ('dbx_pii_business_glossary_term' = 'Daily Production Target (Units)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `demonstrated_capacity_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Demonstrated Capacity Units');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_value_regex' = '^FY[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `headcount_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Headcount Required');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `is_bottleneck_constrained` SET TAGS ('dbx_pii_business_glossary_term' = 'Bottleneck Constrained Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `number_of_shifts` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Shifts');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `plan_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Plan End Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Plan Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_pii_value_regex' = '^CP-[A-Z0-9]{3,6}-[0-9]{4}-[0-9]{2}-[0-9]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `plan_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Plan Start Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Plan Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_pii_value_regex' = 'draft|submitted|approved|active|superseded|archived');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Plan Version');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_pii_value_regex' = '^v[0-9]{1,3}.[0-9]{1,2}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `planned_downtime_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Downtime Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `planned_maintenance_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Maintenance Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `planned_overtime_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Overtime Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `planned_production_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Production Units');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `planning_period_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Planning Period Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `planning_period_type` SET TAGS ('dbx_pii_value_regex' = 'weekly|monthly|quarterly|annual');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `planning_scenario` SET TAGS ('dbx_pii_business_glossary_term' = 'Planning Scenario');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `planning_scenario` SET TAGS ('dbx_pii_value_regex' = 'base|optimistic|pessimistic|stretch');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `rated_capacity_jph` SET TAGS ('dbx_pii_business_glossary_term' = 'Rated Capacity Jobs Per Hour (JPH)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `rated_capacity_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Rated Capacity Units');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `sap_capacity_plan_code` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Capacity Plan ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `takt_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Takt Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ALTER COLUMN `working_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Working Days');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `changeover_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Changeover ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supervisor ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Changeover Team ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supervisor ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `shift_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `actual_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Changeover Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Changeover End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Changeover Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `agv_intervention_required` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV (Automated Guided Vehicle) Intervention Required');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `assembly_stage` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Stage');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `assembly_stage` SET TAGS ('dbx_pii_value_regex' = 'stamping|body_shop|paint|trim|chassis|final_assembly');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `changeover_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Changeover Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `changeover_number` SET TAGS ('dbx_pii_value_regex' = '^CO-[A-Z0-9]{3,6}-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `changeover_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Changeover Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `changeover_status` SET TAGS ('dbx_pii_value_regex' = 'scheduled|in_progress|completed|cancelled|aborted');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `changeover_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Changeover Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `changeover_type` SET TAGS ('dbx_pii_value_regex' = 'model_mix_change|color_change|tooling_swap|line_retooling|powertrain_variant|body_style_change');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `delay_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Changeover Delay Reason Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `external_elements_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'External Changeover Elements Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `first_good_unit_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'First Good Unit Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `from_body_style_code` SET TAGS ('dbx_pii_business_glossary_term' = 'From Body Style Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `from_body_style_code` SET TAGS ('dbx_pii_value_regex' = 'sedan|suv|truck|coupe|hatchback|van');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `from_exterior_color_code` SET TAGS ('dbx_pii_business_glossary_term' = 'From Exterior Color Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `from_powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'From Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `from_powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `from_vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'From Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `internal_elements_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Internal Changeover Elements Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `is_planned` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Planned Changeover');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `is_smed_target` SET TAGS ('dbx_pii_business_glossary_term' = 'Is SMED (Single-Minute Exchange of Die) Target');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `line_verification_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Verification Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `mes_changeover_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'MES (Manufacturing Execution System) Changeover Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `planned_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Changeover Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `planned_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Changeover End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `planned_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Changeover Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `production_loss_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Loss Units');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `quality_gate_passed` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Passed');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Changeover Reason Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `reason_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Changeover Reason Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `sap_order_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Production Order Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `scrap_units_during_changeover` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Units During Changeover');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `takt_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Takt Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `to_body_style_code` SET TAGS ('dbx_pii_business_glossary_term' = 'To Body Style Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `to_body_style_code` SET TAGS ('dbx_pii_value_regex' = 'sedan|suv|truck|coupe|hatchback|van');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `to_exterior_color_code` SET TAGS ('dbx_pii_business_glossary_term' = 'To Exterior Color Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `to_powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'To Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `to_powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `to_vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'To Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `tooling_change_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Tooling Change Required');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `tooling_setup_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Tooling Setup Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ALTER COLUMN `variance_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Changeover Duration Variance (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` SET TAGS ('dbx_pii_subdomain' = 'material_planning');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `production_variant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Variant Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `model_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `production_bom_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `routing_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Routing ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Automation Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_value_regex' = 'L0|L1|L2|L2_PLUS|L3');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `assembly_complexity_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Complexity Score');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery Capacity (kWh)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `body_style_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Body Style Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `body_style_code` SET TAGS ('dbx_pii_value_regex' = 'SEDAN|SUV|TRUCK|COUPE|HATCHBACK|MINIVAN');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `co2_emission_g_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'CO2 Emission (g/km)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `destination_market_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Market Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `destination_market_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `drive_configuration` SET TAGS ('dbx_pii_business_glossary_term' = 'Drive Configuration');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `drive_configuration` SET TAGS ('dbx_pii_value_regex' = 'FWD|RWD|AWD|4WD');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `engine_displacement_cc` SET TAGS ('dbx_pii_business_glossary_term' = 'Engine Displacement (cc)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `engineering_change_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `engineering_change_level` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `fuel_economy_mpg` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Economy (MPG)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `gross_vehicle_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Vehicle Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `hand_of_drive` SET TAGS ('dbx_pii_business_glossary_term' = 'Hand of Drive');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `hand_of_drive` SET TAGS ('dbx_pii_value_regex' = 'LHD|RHD');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `homologation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `homologation_status` SET TAGS ('dbx_pii_value_regex' = 'PENDING|CERTIFIED|CONDITIONAL|EXPIRED|NOT_REQUIRED');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `is_ckd_eligible` SET TAGS ('dbx_pii_business_glossary_term' = 'Completely Knocked Down (CKD) Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `is_jis_eligible` SET TAGS ('dbx_pii_business_glossary_term' = 'Just-in-Sequence (JIS) Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `is_line_compatible` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Compatibility Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `is_ota_capable` SET TAGS ('dbx_pii_business_glossary_term' = 'Over-the-Air (OTA) Update Capable Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `max_consecutive_builds` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Consecutive Builds');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `mes_variant_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Variant Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `mes_variant_reference` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9-]{3,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `ncap_safety_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'New Car Assessment Programme (NCAP) Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `ncap_safety_rating` SET TAGS ('dbx_pii_value_regex' = '1_STAR|2_STAR|3_STAR|4_STAR|5_STAR|NOT_RATED');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `option_package_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Option Package Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `option_package_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,15}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `paint_process_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Paint Process Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `paint_process_type` SET TAGS ('dbx_pii_value_regex' = 'STANDARD|METALLIC|PEARL|MATTE|TWO_TONE');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `ppap_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Part Approval Process (PPAP) Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `ppap_status` SET TAGS ('dbx_pii_value_regex' = 'NOT_REQUIRED|PENDING|SUBMITTED|APPROVED|REJECTED');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `regulatory_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Region');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `regulatory_region` SET TAGS ('dbx_pii_value_regex' = 'NAFTA|EU|APAC|LATAM|MEA|CHINA');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `sap_material_number` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Material Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `sap_material_number` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{8,18}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `standard_build_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Build Hours');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `takt_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Takt Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `teamcenter_variant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Siemens Teamcenter PLM Variant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `teamcenter_variant_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `transmission_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `transmission_type` SET TAGS ('dbx_pii_value_regex' = 'AUTOMATIC|MANUAL|CVT|DCT|SINGLE_SPEED');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `trim_level_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Level Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `trim_level_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `v2x_capable` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle-to-Everything (V2X) Communication Capable Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `variant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Variant Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `variant_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4,20}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `variant_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Variant Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `variant_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Variant Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `variant_status` SET TAGS ('dbx_pii_value_regex' = 'ACTIVE|INACTIVE|PLANNED|DISCONTINUED|ON_HOLD');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ALTER COLUMN `wltp_range_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Worldwide Harmonised Light Vehicles Test Procedure (WLTP) Range (km)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Record ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Authorizing Employee ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `defect_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Defect ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `assembly_stage_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Stage Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `bom_component_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Component Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `co2_impact_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Carbon Dioxide (CO2) Impact (kg)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `corrective_action_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `detection_method_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Detection Method Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `disposal_method_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Disposal Method Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `disposal_method_code` SET TAGS ('dbx_pii_value_regex' = 'RECYCLE|LANDFILL|REWORK|RETURN_SUPPLIER|INCINERATE|RESALE');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `disposal_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Disposal Authorization Reference');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `inspection_point_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Point Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `is_hazardous_material` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `is_safety_related` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety-Related Component Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `is_warranty_relevant` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Relevance Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `mes_transaction_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Execution System (MES) Transaction ID');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `ppm_contribution` SET TAGS ('dbx_pii_business_glossary_term' = 'Parts Per Million (PPM) Defect Contribution');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `production_line_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Root Cause Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `salvage_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Salvage Value');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `salvage_value` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `sap_movement_type` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Goods Movement Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `sap_movement_type` SET TAGS ('dbx_pii_value_regex' = '551|552|553|554');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `sap_posting_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Financial Posting Document Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Category');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_category` SET TAGS ('dbx_pii_value_regex' = 'process|material|design|tooling|supplier|operator_error');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Document Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_document_number` SET TAGS ('dbx_pii_value_regex' = '^SCR-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Quantity');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Reason Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_reason_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Reason Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Record Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_status` SET TAGS ('dbx_pii_value_regex' = 'pending|confirmed|disposed|reversed|under_review');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Value');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `scrap_value` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `shift_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `shift_code` SET TAGS ('dbx_pii_value_regex' = 'D|A|N|E');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `supplier_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ALTER COLUMN `weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` SET TAGS ('dbx_pii_subdomain' = 'supplier_integration');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` SET TAGS ('dbx_pii_association_edges' = 'manufacturing.plant,procurement.supplier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `manufacturing_supply_agreement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplyagreement - Supply Agreement Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `manufacturing_packaging_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Packaging Spec');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplyagreement - Plant Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplyagreement - Supplier Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `freight_terms` SET TAGS ('dbx_pii_business_glossary_term' = 'Freight Terms');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `is_preferred_supplier` SET TAGS ('dbx_pii_business_glossary_term' = 'Preferred Supplier Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `manufacturing_supply_agreement_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Agreement Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Minimum Order Qty');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `quality_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Rating');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ALTER COLUMN `shipping_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Shipping Method');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` SET TAGS ('dbx_pii_subdomain' = 'supplier_integration');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` SET TAGS ('dbx_pii_association_edges' = 'manufacturing.vehicle_build,mobility.mobility_service');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` ALTER COLUMN `vehicle_mobility_subscription_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehiclemobilitysubscription - Vehicle Mobility Subscription Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` ALTER COLUMN `mobility_service_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehiclemobilitysubscription - Mobility Service Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` ALTER COLUMN `service_tier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Tier Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` ALTER COLUMN `vehicle_build_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehiclemobilitysubscription - Vehicle Build Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` ALTER COLUMN `billing_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Billing Amount');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` ALTER COLUMN `subscription_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription End Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` ALTER COLUMN `subscription_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Start Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` ALTER COLUMN `vehicle_mobility_subscription_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` SET TAGS ('dbx_pii_subdomain' = 'supplier_integration');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` SET TAGS ('dbx_pii_association_edges' = 'manufacturing.production_order,compliance.regulatory_requirement');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` ALTER COLUMN `compliance_certification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliancecertification - Compliance Certification Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliancecertification - Production Order Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliancecertification - Regulatory Requirement Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` ALTER COLUMN `certification_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` ALTER COLUMN `evidence_document_path` SET TAGS ('dbx_pii_business_glossary_term' = 'Evidence Document');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` SET TAGS ('dbx_pii_subdomain' = 'supplier_integration');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` SET TAGS ('dbx_pii_association_edges' = 'manufacturing.production_order,dealer.dealership');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` ALTER COLUMN `production_order_allocation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Allocation - Allocation Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Allocation - Dealership Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Allocation - Production Order Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` ALTER COLUMN `allocation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` ALTER COLUMN `priority_tier` SET TAGS ('dbx_pii_business_glossary_term' = 'Priority Tier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `agv_route_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Agv Route Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `agv_start_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Start Location Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `reverse_agv_route_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Reverse Agv Route Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `reverse_agv_route_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'End Location Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `allowed_load_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Allowed Load Kg');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `energy_consumption_kwh_per_cycle` SET TAGS ('dbx_pii_business_glossary_term' = 'Energy Consumption Kwh Per Cycle');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `estimated_cycle_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Cycle Time Seconds');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `is_bidirectional` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Bidirectional');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `is_dynamic_route` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Dynamic Route');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `last_inspection_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Inspection Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `maintenance_window` SET TAGS ('dbx_pii_business_glossary_term' = 'Maintenance Window');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `max_speed_m_per_s` SET TAGS ('dbx_pii_business_glossary_term' = 'Max Speed M Per S');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `route_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Route Category');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `route_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Route Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `route_length_meters` SET TAGS ('dbx_pii_business_glossary_term' = 'Route Length Meters');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `route_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Route Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `route_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Route Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `route_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Route Version');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `safety_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `agv_route_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ALTER COLUMN `waypoint_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Waypoint Count');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` SET TAGS ('dbx_pii_subdomain' = 'material_planning');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `routing_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Routing Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `alternate_routing_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Alternate Routing Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `alternate_routing_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `change_approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Approved By');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `change_approved_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Approved Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `change_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Reason');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `routing_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Routing Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `routing_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `is_default` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Default');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `material_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `operation_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Operation Count');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `product_family` SET TAGS ('dbx_pii_business_glossary_term' = 'Product Family');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `quality_check_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Check Required');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `reviewed_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Reviewed By');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `route_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Route Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `routing_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Routing Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `routing_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Routing Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `safety_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `total_cycle_time_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Cycle Time Minutes');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `work_center` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `factory_calendar_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Factory Calendar Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `base_factory_calendar_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Base Factory Calendar Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `base_factory_calendar_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `calendar_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Calendar Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `calendar_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Calendar Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `calendar_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Calendar Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `day_of_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Day Of Year');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `factory_calendar_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `is_holiday` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Holiday');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `is_work_day` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Work Day');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `plant_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Location');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift Pattern');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `factory_calendar_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `timezone` SET TAGS ('dbx_pii_business_glossary_term' = 'Timezone');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`factory_calendar` ALTER COLUMN `week_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Week Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `operator_team_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator Team Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Employee Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `parent_operator_team_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Operator Team Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `parent_operator_team_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `average_cycle_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Average Cycle Time Seconds');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `average_experience_years` SET TAGS ('dbx_pii_business_glossary_term' = 'Average Experience Years');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `operator_team_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `downtime_minutes_last_month` SET TAGS ('dbx_pii_business_glossary_term' = 'Downtime Minutes Last Month');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `is_overtime_allowed` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Overtime Allowed');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `last_safety_audit_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Safety Audit Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `member_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Member Count');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `operator_team_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `overtime_rate_multiplier` SET TAGS ('dbx_pii_business_glossary_term' = 'Overtime Rate Multiplier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `quality_defect_rate_pct` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Defect Rate Pct');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `safety_training_completed` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Training Completed');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `shift` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `skill_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Skill Level');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `operator_team_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `team_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Team Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `team_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Team Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `total_output_units_last_month` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Output Units Last Month');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ALTER COLUMN `work_order_capacity_per_shift` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Order Capacity Per Shift');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`energy_consumption_record` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`energy_consumption_record` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`energy_consumption_record` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`energy_consumption_record` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`co2_emission_record` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`co2_emission_record` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`co2_emission_record` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`co2_emission_record` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`water_usage_record` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`water_usage_record` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`water_usage_record` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`water_usage_record` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`line_energy_meter` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`line_energy_meter` SET TAGS ('dbx_pii_subdomain' = 'facility_management');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`line_energy_meter` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`line_energy_meter` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`oee_daily_snapshot` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`oee_daily_snapshot` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`oee_daily_snapshot` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`oee_daily_snapshot` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`equipment_effectiveness_metric` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`equipment_effectiveness_metric` SET TAGS ('dbx_pii_subdomain' = 'execution_control');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`equipment_effectiveness_metric` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`equipment_effectiveness_metric` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` SET TAGS ('dbx_pii_subdomain' = 'material_planning');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `manufacturing_packaging_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Packaging Specification Identifier');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `packaging_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Outer Packaging Specification Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `packaging_specification_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `vendor_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Vendor Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `vendor_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `packaging_vendor_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vendor Id');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `barcode_pattern` SET TAGS ('dbx_pii_business_glossary_term' = 'Barcode Pattern');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `barcode_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Barcode Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `manufacturing_packaging_specification_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `default_package_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Default Package Weight Kg');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `manufacturing_packaging_specification_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `disposal_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Disposal Method');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `height_cm` SET TAGS ('dbx_pii_business_glossary_term' = 'Height Cm');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `length_cm` SET TAGS ('dbx_pii_business_glossary_term' = 'Length Cm');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `material_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `max_load_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Max Load Kg');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `manufacturing_packaging_specification_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `packaging_color` SET TAGS ('dbx_pii_business_glossary_term' = 'Packaging Color');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `packaging_cost_usd` SET TAGS ('dbx_pii_business_glossary_term' = 'Packaging Cost Usd');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `packaging_shape` SET TAGS ('dbx_pii_business_glossary_term' = 'Packaging Shape');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `recyclable_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Recyclable Flag');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `manufacturing_packaging_specification_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `temperature_range_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Temperature Range C');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `manufacturing_packaging_specification_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Type');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `units_per_carton` SET TAGS ('dbx_pii_business_glossary_term' = 'Units Per Carton');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `units_per_pallet` SET TAGS ('dbx_pii_business_glossary_term' = 'Units Per Pallet');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `volume_per_unit_cubic_m` SET TAGS ('dbx_pii_business_glossary_term' = 'Volume Per Unit Cubic M');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `weight_per_unit_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight Per Unit Kg');
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ALTER COLUMN `width_cm` SET TAGS ('dbx_pii_business_glossary_term' = 'Width Cm');
