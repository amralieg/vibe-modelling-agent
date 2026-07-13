-- Schema for Domain: compliance | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:49

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`compliance` COMMENT 'Regulatory compliance and homologation management across all global markets. Owns CAFE (Corporate Average Fuel Economy) reporting, EPA/CARB emissions certifications, NHTSA FMVSS homologation records, WLTP/Euro NCAP test submissions, UNECE type approvals, and recall regulatory filings. Manages compliance testing, certification documentation, regulatory submissions, and audit trails. Ensures adherence to environmental, safety, and trade regulations across jurisdictions.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` (
    `homologation_record_id` BIGINT COMMENT 'Unique surrogate key for the homologation record.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Homologation records certify a specific vehicle model for market approval; FK to model ties approvals to the correct model definition.',
    `approval_name` STRING COMMENT 'Human‑readable name of the homologation approval.',
    `approval_number` STRING COMMENT 'Official approval number or certificate identifier issued by the regulatory authority.',
    `approval_status_date` DATE COMMENT 'Date when the current status was assigned to the approval.',
    `approval_type` STRING COMMENT 'Category of the approval (e.g., type approval, certification, test, homologation).. Valid values are `type_approval|type_certification|type_test|type_homologation`',
    `body_style` STRING COMMENT 'Exterior body configuration.. Valid values are `sedan|hatchback|coupe|convertible|wagon|utility`',
    `certification_document_url` STRING COMMENT 'Link to the electronic copy of the certification document.',
    `co2_emissions_g_per_km` DECIMAL(18,2) COMMENT 'Measured CO2 emissions in grams per kilometer.',
    `compliance_notes` STRING COMMENT 'Free‑form notes regarding special conditions, exemptions, or observations.',
    `document_version` STRING COMMENT 'Version identifier of the certification document.',
    `drivetrain` STRING COMMENT 'Drive configuration of the vehicle.. Valid values are `fwd|rwd|awd|4wd`',
    `effective_date` DATE COMMENT 'Date from which the approval is effective for sales.',
    `engine_code` STRING COMMENT 'Manufacturers internal engine identifier.',
    `expiration_date` DATE COMMENT 'Date on which the approval expires or must be renewed.',
    `fuel_consumption_l_per_100km` DECIMAL(18,2) COMMENT 'Measured fuel consumption in liters per 100 kilometers.',
    `fuel_type` STRING COMMENT 'Primary fuel used by the powertrain.. Valid values are `gasoline|diesel|electric|hybrid|plug_in_hybrid`',
    `homologation_record_status` STRING COMMENT 'Current lifecycle status of the homologation record.. Valid values are `pending|approved|rejected|revoked|expired`',
    `market_jurisdiction` STRING COMMENT 'Three‑letter ISO country code of the market where the approval applies.',
    `market_region` STRING COMMENT 'Geographic region grouping of markets.. Valid values are `NA|EU|APAC|LATAM|MEA`',
    `model_year` STRING COMMENT 'Calendar year in which the vehicle model was first produced.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the homologation record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the homologation record.',
    `regulatory_body` STRING COMMENT 'Authority that issued the approval.. Valid values are `NHTSA|EPA|EURO_NCAP|UNECE|CARB|DOT`',
    `regulatory_reference` STRING COMMENT 'Reference number of the regulatory filing or decision.',
    `test_cycle` STRING COMMENT 'Regulatory test cycle used for emissions and fuel consumption testing.. Valid values are `WLTP|NEDC|EPA|ECE|Euro_5|Euro_6`',
    `test_date` DATE COMMENT 'Date on which the regulatory test was performed.',
    `test_lab` STRING COMMENT 'Name of the accredited laboratory that performed the test.',
    `transmission_type` STRING COMMENT 'Type of transmission fitted to the vehicle.. Valid values are `automatic|manual|cvt|dual_clutch`',
    `updated_by` STRING COMMENT 'Identifier of the user who last modified the record.',
    `vehicle_model` STRING COMMENT 'Manufacturer‑defined model designation (e.g., Camry, F‑150).',
    `vehicle_type` STRING COMMENT 'Broad classification of the vehicle.. Valid values are `passenger|commercial|truck|suv|motorcycle|utility`',
    `created_by` STRING COMMENT 'Identifier of the user who created the record.',
    CONSTRAINT pk_homologation_record PRIMARY KEY(`homologation_record_id`)
) COMMENT 'Master record for vehicle type approval and homologation certifications across global markets. Captures UNECE type approval numbers, FMVSS homologation status, Euro NCAP ratings, WLTP certification references, and jurisdiction-specific approval details for each vehicle model and variant. Serves as the authoritative SSOT for all regulatory type approvals required before a vehicle can be sold in a given market.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` (
    `compliance_emissions_certification_id` BIGINT COMMENT 'Unique identifier for the compliance_emissions_certification data product (auto-inserted pre-linking).',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Connect emissions certifications to their governing compliance document.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Emissions certification traceability: each certification is performed on specific test equipment; linking enables audit of equipment used.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Add jurisdiction reference to emissions certifications for regional compliance tracking.',
    `powertrain_variant_id` BIGINT COMMENT 'Foreign key linking to vehicle.powertrain_variant. Business justification: Required for emissions certification reports that certify each specific powertrain variant, enabling traceability of emissions limits per variant.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Link emissions certifications to the regulatory requirement they satisfy.',
    CONSTRAINT pk_compliance_emissions_certification PRIMARY KEY(`compliance_emissions_certification_id`)
) COMMENT 'Master record for EPA, CARB, and Euro 6/7 emissions certifications issued for specific vehicle configurations and powertrain variants. Tracks certification number, applicable standard (EPA Tier 3, CARB LEV III, Euro 6d), test cycle (WLTP, FTP-75, US06), certification date, expiry, and compliance status. Covers ICE, HEV, PHEV, and EV powertrain types. Links to the specific engine family and vehicle model year program.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` (
    `cafe_compliance_record_id` BIGINT COMMENT 'System-generated unique identifier for the CAFE compliance record.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Replace free‑text region with FK to jurisdiction for standardized regional reporting.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: CAFE credit calculations are performed per vehicle model; linking to model allows accurate credit tracking and reporting per model.',
    `actual_cafe_mpg` DECIMAL(18,2) COMMENT 'Achieved Corporate Average Fuel Economy for the fleet, expressed in miles per gallon.',
    `approval_date` DATE COMMENT 'Date the regulator approved the submitted CAFE record.',
    `compliance_gap_mpg` DECIMAL(18,2) COMMENT 'Difference between actual and required CAFE; positive indicates surplus, negative indicates shortfall.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the compliance record was first created in the system.',
    `credit_balance` DECIMAL(18,2) COMMENT 'Monetary value of CAFE credits carried forward or generated in the reporting period.',
    `credit_expiration_date` DATE COMMENT 'Date on which any banked CAFE credits expire if not used.',
    `credit_type` STRING COMMENT 'Category of CAFE credit (generated, banked for future use, already used, or expired).. Valid values are `generation|banked|used|expired`',
    `fine_liability_usd` DECIMAL(18,2) COMMENT 'Potential monetary penalty if the compliance gap is negative and insufficient credits exist.',
    `fleet_mix_description` STRING COMMENT 'Narrative description of the vehicle mix (e.g., percentages of cars, trucks, hybrids).',
    `fleet_type` STRING COMMENT 'Classification of the vehicle fleet (e.g., domestic car, import car, light truck).. Valid values are `domestic_car|import_car|light_truck|medium_truck|heavy_truck`',
    `is_active` BOOLEAN COMMENT 'Indicates whether the record is currently active for reporting purposes.',
    `model_year` STRING COMMENT 'Model year of the vehicle fleet covered by the compliance record.',
    `notes` STRING COMMENT 'Free‑form comments or observations related to the compliance record.',
    `record_label` STRING COMMENT 'Human‑readable label identifying the compliance record, typically combining model year and fleet type.',
    `record_number` STRING COMMENT 'External reference number used in regulatory filings and internal reporting.',
    `regulatory_body` STRING COMMENT 'Governing authority to which the CAFE data is reported.. Valid values are `NHTSA|EPA|CARB|EU|UN`',
    `reporting_status` STRING COMMENT 'Current status of the regulatory filing process.. Valid values are `pending|submitted|approved|rejected`',
    `reporting_year` STRING COMMENT 'Fiscal year in which the CAFE data is reported to regulators.',
    `required_cafe_mpg` DECIMAL(18,2) COMMENT 'Regulatory minimum CAFE value that must be met for the given model year and fleet type.',
    `submission_date` DATE COMMENT 'Date the compliance record was submitted to the regulator.',
    `total_vehicles` STRING COMMENT 'Number of vehicles included in the fleet mix for this CAFE calculation.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the compliance record.',
    `version_number` STRING COMMENT 'Incremental version of the compliance record for audit tracking.',
    CONSTRAINT pk_cafe_compliance_record PRIMARY KEY(`cafe_compliance_record_id`)
) COMMENT 'Annual CAFE (Corporate Average Fuel Economy) compliance record tracking fleet-wide fuel economy performance against NHTSA-mandated standards. Captures model year, fleet type (domestic car, import car, light truck), actual achieved CAFE value (mpg), required standard, compliance gap or surplus, credit balance, and fine liability. Supports NHTSA annual CAFE reporting obligations and internal fleet mix planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` (
    `regulatory_submission_id` BIGINT COMMENT 'System-generated unique identifier for each regulatory submission record.',
    `aftersales_model_year_program_id` BIGINT COMMENT 'Foreign key linking to product.model_year_program. Business justification: REQUIRED: Each regulatory submission is filed for a specific vehicle program; linking enables submission status dashboards.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Regulatory submissions are filed per vehicle; FK to connected_vehicle provides traceability for audit and recall.',
    `employee_id` BIGINT COMMENT 'Identifier of the internal compliance officer responsible for the submission.',
    `regulatory_compliance_officer_employee_id` BIGINT COMMENT 'Identifier of the internal compliance officer responsible for the submission.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Associate each regulatory submission with the specific regulatory requirement it satisfies.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Regulatory submissions often reference a specific vehicle VIN; linking to vin_registry enables validation of VIN status and history for compliance reporting.',
    `approval_date` DATE COMMENT 'Date the regulatory body approved the submission.',
    `cafe_value` DECIMAL(18,2) COMMENT 'Reported CAFE metric associated with the submission, expressed in mpg.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the submission record was first created in the system.',
    `document_path` STRING COMMENT 'File system or storage URI where the submission package is stored.',
    `document_version` STRING COMMENT 'Version identifier of the submitted document (e.g., v1.0).',
    `effective_from` DATE COMMENT 'Date from which the submitted certification or approval becomes effective.',
    `effective_until` DATE COMMENT 'Expiration date of the certification or approval, if applicable.',
    `emission_standard` STRING COMMENT 'Applicable emissions regulation (e.g., EPA Tier 3, Euro 6).',
    `fee_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for the fee.. Valid values are `^[A-Z]{3}$`',
    `fee_gross_amount` DECIMAL(18,2) COMMENT 'Total fee charged before taxes or adjustments.',
    `fee_net_amount` DECIMAL(18,2) COMMENT 'Net fee after tax and any discounts.',
    `fee_tax_amount` DECIMAL(18,2) COMMENT 'Tax component of the submission fee.',
    `fuel_type` STRING COMMENT 'Primary propulsion technology of the vehicle(s) covered.. Valid values are `gasoline|diesel|hybrid|electric|hydrogen`',
    `is_critical` BOOLEAN COMMENT 'Flag indicating whether the submission is critical for regulatory compliance.',
    `is_urgent` BOOLEAN COMMENT 'Flag indicating whether the submission requires expedited handling.',
    `jurisdiction` STRING COMMENT 'Three‑letter ISO country code of the market or region for which the submission is made.. Valid values are `^[A-Z]{3}$`',
    `regulatory_body_code` STRING COMMENT 'Code of the governing body receiving the submission.. Valid values are `NHTSA|EPA|CARB|UNECE|Euro_NCAP|DOT`',
    `regulatory_body_name` STRING COMMENT 'Full name of the regulatory authority (e.g., National Highway Traffic Safety Administration).',
    `regulatory_submission_status` STRING COMMENT 'Current lifecycle status of the submission.. Valid values are `submitted|acknowledged|approved|rejected|under_review`',
    `rejection_reason` STRING COMMENT 'Textual explanation provided by the regulator when a submission is rejected.',
    `related_part_number` STRING COMMENT 'Part number(s) from the Bill of Materials relevant to the submission (e.g., emissions control component).',
    `reviewer_comments` STRING COMMENT 'Internal comments from the compliance reviewer regarding the submission.',
    `status_change_date` DATE COMMENT 'Date when the status last transitioned.',
    `submission_category` STRING COMMENT 'Indicates whether the submission is for domestic market, export market, or both.. Valid values are `domestic|export|both`',
    `submission_date` DATE COMMENT 'Date the submission was formally sent to the regulatory authority.',
    `submission_reference_number` STRING COMMENT 'External reference number assigned by the regulatory body or internal tracking system.',
    `submission_type` STRING COMMENT 'Category of the regulatory filing (e.g., type approval, recall notice).. Valid values are `type_approval|certificate_of_conformity|recall_notice|cafe_report|safety_compliance_report`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the submission record.',
    `vehicle_model_year` STRING COMMENT 'Model year of the vehicle(s) covered by the submission.',
    `vehicle_type` STRING COMMENT 'Classification of the vehicle (e.g., passenger, truck, SUV).. Valid values are `passenger|truck|suv|commercial|motorcycle`',
    CONSTRAINT pk_regulatory_submission PRIMARY KEY(`regulatory_submission_id`)
) COMMENT 'Transactional record for each formal regulatory submission made to a governing body (NHTSA, EPA, CARB, UNECE, Euro NCAP, DOT). Captures submission type (type approval application, certificate of conformity, recall notice, CAFE report, safety standard compliance report), submission date, regulatory body, submission reference number, status (submitted, acknowledged, approved, rejected, under review), and responsible compliance officer. Central audit trail for all outbound regulatory filings.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`recall_campaign` (
    `recall_campaign_id` BIGINT COMMENT 'Unique identifier for the compliance_recall_campaign data product (auto-inserted pre-linking).',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Attach the primary compliance document to the recall campaign for audit traceability.',
    `aftersales_nameplate_id` BIGINT COMMENT '',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Link recall campaign to the regulatory requirement that triggered the recall.',
    `vehicle_program_id` BIGINT COMMENT 'add column vehicle_program_id (BIGINT) with FK to engineering.vehicle_program.vehicle_program_id - recalls are issued against vehicle programs',
    CONSTRAINT pk_recall_campaign PRIMARY KEY(`recall_campaign_id`)
) COMMENT 'Master record for NHTSA safety recall campaigns and OEM-initiated service campaigns. Captures NHTSA recall number, campaign type (safety recall, emissions recall, OEM voluntary service campaign), defect description, affected population (VIN range, model year, nameplate), remedy description, campaign open date, remedy availability date, and campaign closure status. Serves as the compliance SSOT for recall management, distinct from aftersales.recall_completion which tracks dealer-level execution.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`test_event` (
    `test_event_id` BIGINT COMMENT 'System-generated unique identifier for the compliance test event record.',
    `compliance_document_id` BIGINT COMMENT 'Reference to the digital test report document.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Vehicle test events are performed on specific connected vehicles; linking enables compliance test tracking per vehicle.',
    `homologation_id` BIGINT COMMENT 'Identifier of the homologation record associated with this test.',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_obligation. Business justification: Identify the obligation that the test event is validating.',
    `employee_id` BIGINT COMMENT 'Identifier of the technician who performed the test.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the primary test equipment used.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Connect test events to the regulatory requirement they are designed to meet.',
    `ambient_humidity_percent` DECIMAL(18,2) COMMENT 'Relative humidity percentage at the test site.',
    `ambient_pressure_kpa` DECIMAL(18,2) COMMENT 'Barometric pressure at the test site in kilopascals.',
    `ambient_temperature_c` DECIMAL(18,2) COMMENT 'Ambient air temperature measured at the test site in degrees Celsius.',
    `certification_body` STRING COMMENT 'Regulatory authority or organization issuing the certification.',
    `certification_number` STRING COMMENT 'Official certification number assigned after successful test.',
    `certification_status` STRING COMMENT 'Current status of the regulatory certification linked to this test.. Valid values are `pending|issued|rejected|withdrawn`',
    `created_by_user` STRING COMMENT 'User identifier who initially created the record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the test event record was first created in the system.',
    `data_source_system` STRING COMMENT 'Originating operational system of record (e.g., SAP QM, Apriso MES).',
    `is_retest` BOOLEAN COMMENT 'True if the test is a repeat of a prior failed or conditional test.',
    `measured_unit` STRING COMMENT 'Unit of the measured value (e.g., g/km, km/h, dB).',
    `measured_value` DECIMAL(18,2) COMMENT 'Primary quantitative measurement recorded (e.g., CO2 g/km, g-force).',
    `notes` STRING COMMENT 'Free-text field for additional observations or comments.',
    `pass_fail_flag` BOOLEAN COMMENT 'Boolean indicator where true = pass, false = fail.',
    `powertrain_type` STRING COMMENT 'Classification of the vehicles powertrain (e.g., ICE, EV).. Valid values are `ICE|HEV|PHEV|EV|FCEV`',
    `regulatory_jurisdiction` STRING COMMENT 'Geographic or market jurisdiction governing the test (e.g., US, EU).',
    `result` STRING COMMENT 'Overall outcome of the test (pass, fail, or conditional).. Valid values are `pass|fail|conditional`',
    `retest_reason` STRING COMMENT 'Explanation why a retest was required.',
    `test_batch_number` STRING COMMENT 'Identifier for the group of tests executed together.',
    `test_category` STRING COMMENT 'Broad classification of the test (emissions, crash safety, noise, etc.).. Valid values are `emissions|crash|noise|fuel_economy|range|charging`',
    `test_condition` STRING COMMENT 'Operational condition under which the test was performed (e.g., cold start, hot start).',
    `test_equipment_name` STRING COMMENT 'Descriptive name of the test equipment.',
    `test_event_number` STRING COMMENT 'External reference number assigned to the test event by the testing facility.',
    `test_event_status` STRING COMMENT 'Current lifecycle status of the test event.. Valid values are `planned|in_progress|completed|passed|failed|cancelled`',
    `test_facility` STRING COMMENT 'Name of the laboratory or proving ground where the test was conducted.',
    `test_location` STRING COMMENT 'Geographic location (city, state, country) of the test facility.',
    `test_operator_name` STRING COMMENT 'Full name of the test operator.',
    `test_program` STRING COMMENT 'Name of the specific testing program or campaign (e.g., EPA Tier 3, Euro NCAP).',
    `test_sequence_number` STRING COMMENT 'Ordinal number of the test within a batch or campaign.',
    `test_timestamp` TIMESTAMP COMMENT 'Date and time when the physical compliance test was performed.',
    `test_type` STRING COMMENT 'Standardized test program or protocol applied (e.g., WLTP, NCAP).. Valid values are `WLTP|FTP-75|NEDC|RDE|NCAP|FMVSS`',
    `updated_by_user` STRING COMMENT 'User identifier who last modified the record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the test event record.',
    `vehicle_model_code` STRING COMMENT 'Internal code representing the vehicle model.',
    `vehicle_model_year` STRING COMMENT 'Model year of the vehicle under test.',
    `vehicle_variant` STRING COMMENT 'Specific trim or configuration variant of the vehicle.',
    CONSTRAINT pk_test_event PRIMARY KEY(`test_event_id`)
) COMMENT 'Transactional record capturing each physical compliance test event conducted for regulatory certification purposes. Covers emissions testing (WLTP, FTP-75, NEDC, RDE), crash safety testing (NCAP, FMVSS), noise testing (NVH/ECE R51), and fuel economy testing. Captures test date, test facility, test type, vehicle configuration tested, test result (pass/fail/conditional), measured values, and the certifying laboratory. Links to the homologation record or emissions certification being pursued.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` (
    `compliance_test_result_id` BIGINT COMMENT 'Unique identifier for the compliance test result record.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or instrument used for the measurement.',
    `engineering_test_result_id` BIGINT COMMENT 'SSOT reference to engineering.engineering_test_result (resolves cross-domain duplicate of test_result).',
    `primary_equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or instrument used for the measurement.',
    `test_event_id` BIGINT COMMENT 'Identifier of the parent compliance test event to which this result belongs.',
    `calibration_status` STRING COMMENT 'Indicates whether the test equipment was calibrated at the time of measurement.. Valid values are `calibrated|uncalibrated|pending`',
    `comments` STRING COMMENT 'Free‑text notes or observations related to the measurement.',
    `compliance_regulation_code` STRING COMMENT 'Code identifying the specific regulation or standard applied (e.g., EPA_2023_CO2).',
    `data_source_system` STRING COMMENT 'System of record that supplied the measurement data.. Valid values are `SAP_QM|MES|PLM|Custom`',
    `is_outlier` BOOLEAN COMMENT 'True if the measurement is flagged as a statistical outlier.',
    `jurisdiction` STRING COMMENT 'ISO 3166‑1 alpha‑3 country code of the regulatory jurisdiction.',
    `lab_location_code` STRING COMMENT 'Code representing the facility where the test was performed.',
    `limit_unit` STRING COMMENT 'Unit of the regulatory limit; typically matches the measurement unit.. Valid values are `g/km|mg/km|dB|mm|kg|%`',
    `measured_value` DECIMAL(18,2) COMMENT 'Numeric result of the measurement for the parameter.',
    `measurement_method` STRING COMMENT 'Technique used to obtain the measurement.. Valid values are `lab|in_vehicle|simulation`',
    `measurement_pressure_kpa` DECIMAL(18,2) COMMENT 'Ambient or chamber pressure during the measurement, expressed in kilopascals.',
    `measurement_temperature_c` DECIMAL(18,2) COMMENT 'Ambient or chamber temperature during the measurement, expressed in degrees Celsius.',
    `measurement_uncertainty` DECIMAL(18,2) COMMENT 'Estimated uncertainty associated with the measured value.',
    `parameter_code` STRING COMMENT 'Standardized code or identifier for the measured parameter.',
    `parameter_name` STRING COMMENT 'Descriptive name of the measured parameter (e.g., CO2, NOx, crash deformation zone).',
    `pass_fail_status` STRING COMMENT 'Indicates whether the measured value meets the regulatory limit.. Valid values are `pass|fail|conditional`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the result record was initially created in the system.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the result record.',
    `regulatory_limit` DECIMAL(18,2) COMMENT 'Maximum allowable value for the parameter as defined by the applicable regulation.',
    `test_batch_number` STRING COMMENT 'Identifier for the batch of specimens or vehicles tested together.',
    `test_phase` STRING COMMENT 'Specific phase of the compliance test (e.g., cold start, WLTP low speed).. Valid values are `cold_start|hot_start|wl_tp_low|wl_tp_medium|wl_tp_high|wl_tp_extra_high`',
    `test_result_status` STRING COMMENT 'Current lifecycle status of the result record.. Valid values are `recorded|reviewed|approved`',
    `test_timestamp` TIMESTAMP COMMENT 'Date and time when the measurement was taken.',
    `uncertainty_unit` STRING COMMENT 'Unit of the measurement uncertainty, matching the measurement unit.. Valid values are `g/km|mg/km|dB|mm|kg|%`',
    `unit_of_measure` STRING COMMENT 'Unit in which the measured value is expressed.. Valid values are `g/km|mg/km|dB|mm|kg|%`',
    CONSTRAINT pk_compliance_test_result PRIMARY KEY(`compliance_test_result_id`)
) COMMENT 'Detailed test result record for each measured parameter within a compliance test event. Captures parameter name (CO2 g/km, NOx mg/km, crash deformation zone, noise dB), measured value, regulatory limit, pass/fail status, test phase (cold start, hot start, WLTP low/medium/high/extra-high), and measurement uncertainty. Enables granular traceability of test outcomes against specific regulatory thresholds for each parameter tested.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` (
    `regulatory_requirement_id` BIGINT COMMENT 'System-generated unique identifier for each regulatory requirement record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Link regulatory requirement to its governing compliance document.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Specify the jurisdiction for each regulatory requirement.',
    `compliance_deadline` DATE COMMENT 'Latest date by which Automotive must achieve compliance.',
    `compliance_requirement_summary` STRING COMMENT 'Brief summary of the key compliance obligations imposed by the regulation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the regulatory requirement record was first created in the system.',
    `effective_date` DATE COMMENT 'Date on which the regulation becomes effective.',
    `expiry_date` DATE COMMENT 'Date on which the regulation is no longer applicable (if applicable).',
    `is_global` BOOLEAN COMMENT 'True if the regulation applies across all markets; false if market‑specific.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether compliance with the regulation is mandatory (true) or optional (false).',
    `issuing_body` STRING COMMENT 'Organization that issued the regulation (e.g., NHTSA, EPA, UNECE, IATF).',
    `last_review_date` DATE COMMENT 'Date when the regulation was last reviewed for updates or changes.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this record.',
    `market` STRING COMMENT 'Geographic market or jurisdiction to which the regulation applies.. Valid values are `US|EU|CA|JP|CN|KR`',
    `regulatory_requirement_name` STRING COMMENT 'Human‑readable name or title of the regulation (e.g., "Federal Motor Vehicle Safety Standard 208").',
    `notes` STRING COMMENT 'Free‑form field for any supplemental information or comments.',
    `powertrain_type` STRING COMMENT 'Powertrain technologies to which the regulation applies.. Valid values are `ICE|EV|HEV|PHEV|FCEV`',
    `reference_document_number` STRING COMMENT 'Official document number or docket identifier used by the issuing body.',
    `regulation_code` STRING COMMENT 'Official code or identifier assigned by the issuing body (e.g., "FMVSS 208", "ECE R94").',
    `regulation_type` STRING COMMENT 'High‑level classification of the regulation purpose.. Valid values are `safety|emissions|fuel_economy|equipment|environment|homologation`',
    `regulatory_requirement_status` STRING COMMENT 'Current lifecycle state of the regulation.. Valid values are `active|superseded|proposed|withdrawn`',
    `scope_description` STRING COMMENT 'Narrative description of the regulations applicability and scope.',
    `source_document_url` STRING COMMENT 'Link to the official regulation document or web page.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the regulatory requirement record.',
    `vehicle_category` STRING COMMENT 'Vehicle segment covered by the regulation. [ENUM-REF-CANDIDATE: passenger|light_truck|heavy_truck|commercial|motorcycle|electric|hybrid — 7 candidates stripped; promote to reference product]',
    `version` STRING COMMENT 'Version or revision identifier of the regulation (e.g., "v2.1").',
    CONSTRAINT pk_regulatory_requirement PRIMARY KEY(`regulatory_requirement_id`)
) COMMENT 'Reference master defining all applicable regulatory requirements and standards that Automotive must comply with across jurisdictions. Captures regulation name, issuing body (NHTSA, EPA, CARB, UNECE, IATF, ISO), regulation code (e.g., FMVSS 208, ECE R94, Euro 6d), effective date, applicability scope (market, vehicle category, powertrain type), compliance deadline, and current status (active, superseded, proposed). Serves as the regulatory obligation register.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` (
    `jurisdiction_id` BIGINT COMMENT 'System-generated unique identifier for the jurisdiction record.',
    `parent_jurisdiction_id` BIGINT COMMENT 'Identifier of the parent jurisdiction for hierarchical grouping (e.g., state belongs to a country).',
    `regulatory_body_id` BIGINT COMMENT 'FK to compliance.regulatory_body',
    `cafe_target_gpm` DECIMAL(18,2) COMMENT 'Corporate Average Fuel Economy target for the jurisdiction expressed in grams per mile.',
    `compliance_documentation_url` STRING COMMENT 'Link to the repository of official compliance documents for the jurisdiction.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the jurisdiction record was first created in the system.',
    `currency_code` STRING COMMENT 'Default currency used for financial reporting in this jurisdiction.. Valid values are `^[A-Z]{3}$`',
    `jurisdiction_description` STRING COMMENT 'Free‑form text providing additional context or notes about the jurisdiction.',
    `effective_date` DATE COMMENT 'Date when the jurisdiction became active for Automotives compliance tracking.',
    `emissions_standard_tier` STRING COMMENT 'Applicable emissions certification tier (e.g., EPA Tier 2, Euro 6, WLTP) for vehicles sold in this jurisdiction.',
    `epa_emission_limit_g_per_km` DECIMAL(18,2) COMMENT 'Maximum permissible emissions level for vehicles under EPA standards in this jurisdiction.',
    `esg_reporting_required_flag` BOOLEAN COMMENT 'ESG/energy tracking linkage marker.',
    `expiry_date` DATE COMMENT 'Date when the jurisdiction record is retired or no longer applicable (nullable).',
    `homologation_process_time_days` STRING COMMENT 'Typical number of calendar days required to complete homologation.',
    `is_eu_member` BOOLEAN COMMENT 'Indicates whether the jurisdiction is a member of the European Union.',
    `iso_country_code` STRING COMMENT 'Three‑letter ISO country code representing the jurisdictions primary country.. Valid values are `^[A-Z]{3}$`',
    `jurisdiction_status` STRING COMMENT 'Current lifecycle status of the jurisdiction record.. Valid values are `active|inactive|pending|retired|suspended`',
    `jurisdiction_type` STRING COMMENT 'Classification of the jurisdiction based on its governmental level.. Valid values are `federal|state|national|supranational|regional|local`',
    `market_entry_requirements` STRING COMMENT 'Key regulatory and administrative conditions required for market entry (e.g., certification documents, testing procedures).',
    `jurisdiction_name` STRING COMMENT 'Official name of the regulatory jurisdiction (e.g., United States, European Union).',
    `ncap_rating_required` STRING COMMENT 'Minimum NCAP safety rating required for vehicles sold in the jurisdiction.',
    `recall_reporting_requirement` STRING COMMENT 'Regulatory requirement for vehicle recall reporting in the jurisdiction.',
    `region_code` STRING COMMENT 'Code used to group jurisdictions into broader regions (e.g., NA for North America, EU for Europe).',
    `regulatory_body_website` STRING COMMENT 'Web address of the primary regulatory authority.',
    `safety_standard_framework` STRING COMMENT 'Safety regulation framework governing vehicle homologation (e.g., FMVSS, UNECE, NCAP).',
    `tax_rate_percent` DECIMAL(18,2) COMMENT 'Typical statutory tax rate applied to vehicle sales in the jurisdiction.',
    `unece_type_approval_code` STRING COMMENT 'Code representing UNECE type approval classification for the jurisdiction.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the jurisdiction record.',
    `wltp_test_cycle` STRING COMMENT 'Specific WLTP test cycle applicable (e.g., WLTP 2020).',
    CONSTRAINT pk_jurisdiction PRIMARY KEY(`jurisdiction_id`)
) COMMENT 'Reference master for regulatory jurisdictions in which Automotive operates and sells vehicles. Captures jurisdiction name, jurisdiction type (federal, state, national, supranational), country or region code, primary regulatory body, applicable emissions standard tier, applicable safety standard framework, and market entry requirements. Used to map vehicles and certifications to the correct regulatory regime for each sales market.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`obligation` (
    `obligation_id` BIGINT COMMENT 'System-generated unique identifier for the compliance obligation record.',
    `compliance_document_id` BIGINT COMMENT 'Reference to the stored certification document.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Add jurisdiction reference to obligations for regional compliance tracking.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the internal engineering team accountable for the obligation.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Connect obligations to the specific regulatory requirement they fulfill.',
    `vehicle_program_id` BIGINT COMMENT 'Identifier of the vehicle program or model line to which the obligation applies.',
    `actual_certification_date` DATE COMMENT 'Date on which certification was actually obtained.',
    `audit_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the compliance obligation record was first created in the system.',
    `audit_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the compliance obligation record.',
    `certification_body` STRING COMMENT 'External agency or authority that issues the certification (e.g., EPA, NHTSA).',
    `compliance_score` DECIMAL(18,2) COMMENT 'Numeric score (0‑100) reflecting overall compliance health for the obligation.',
    `corrective_action_due_date` DATE COMMENT 'Deadline for completing corrective actions.',
    `corrective_action_plan` STRING COMMENT 'Planned actions to remediate non‑compliance.',
    `effective_from` DATE COMMENT 'Date when the compliance obligation becomes effective.',
    `effective_until` DATE COMMENT 'Date when the compliance obligation expires or is no longer applicable.',
    `emission_value` DECIMAL(18,2) COMMENT 'Measured emission metric (e.g., g/km CO₂) associated with the obligation.',
    `evidence_document_path` STRING COMMENT 'File system or URL path to supporting evidence files.',
    `fuel_economy_value` DECIMAL(18,2) COMMENT 'Measured fuel economy (e.g., mpg or L/100km) relevant to the obligation.',
    `is_critical` BOOLEAN COMMENT 'Flag indicating whether the obligation is deemed critical for vehicle launch.',
    `is_regulatory` BOOLEAN COMMENT 'True if the obligation is mandated by external regulation; false if internal policy.',
    `last_review_date` DATE COMMENT 'Date when the obligation was last reviewed for status or changes.',
    `model_year` STRING COMMENT 'Model year of the vehicle program for which the regulatory requirement is scoped.',
    `next_review_date` DATE COMMENT 'Planned date for the next compliance review.',
    `non_compliance_reason` STRING COMMENT 'Root cause description for a non‑compliant status.',
    `notes` STRING COMMENT 'Free‑form comments or additional information about the obligation.',
    `obligation_number` STRING COMMENT 'Business identifier assigned to the regulatory obligation, often used in internal tracking and external filings.',
    `obligation_status` STRING COMMENT 'Current lifecycle status of the compliance obligation.. Valid values are `pending|in_progress|certified|waived|non_compliant`',
    `priority` STRING COMMENT 'Business priority assigned to the obligation.. Valid values are `low|medium|high`',
    `regulation_code` STRING COMMENT 'Standardized code or identifier for the regulation as defined by the governing body.',
    `regulation_name` STRING COMMENT 'Full official name of the regulation (e.g., "EPA Tier 3 Emissions Standard").',
    `regulation_type` STRING COMMENT 'Category of the regulation (e.g., emissions, safety, fuel economy, noise, or other).. Valid values are `emissions|safety|fuel_economy|noise|other`',
    `responsible_engineering_group` STRING COMMENT 'Human‑readable name of the engineering group leading the compliance effort.',
    `risk_level` STRING COMMENT 'Assessed risk associated with non‑compliance for this obligation.. Valid values are `low|medium|high|critical`',
    `target_certification_date` DATE COMMENT 'Planned date by which certification is expected to be achieved.',
    `test_date` DATE COMMENT 'Date on which the regulatory test was performed.',
    `test_facility` STRING COMMENT 'Name of the laboratory or site where testing occurred.',
    `test_method` STRING COMMENT 'Standardized method or protocol used for the test (e.g., WLTP, SAE J1979).',
    `test_result` STRING COMMENT 'Outcome of the regulatory test associated with the obligation.. Valid values are `pass|fail|pending`',
    `waiver_reason` STRING COMMENT 'Explanation why the obligation was waived, if applicable.',
    CONSTRAINT pk_obligation PRIMARY KEY(`obligation_id`)
) COMMENT 'Operational record linking a specific vehicle program or model year to its applicable regulatory requirements by jurisdiction. Captures the obligation status (pending, in-progress, certified, waived, non-compliant), target certification date, responsible engineering team, and associated homologation record or emissions certification. Enables compliance program managers to track which regulatory obligations are open, in-flight, or closed for each vehicle program.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` (
    `ncap_submission_id` BIGINT COMMENT 'System-generated unique identifier for each NCAP test submission record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Attach the NCAP submission to its supporting compliance document.',
    `adas_features_evaluated` STRING COMMENT 'Comma‑separated list of Advanced Driver Assistance Systems assessed during the test.',
    `adult_occupant_rating` DECIMAL(18,2) COMMENT 'Star rating for adult occupant protection category.',
    `child_occupant_rating` DECIMAL(18,2) COMMENT 'Star rating for child occupant protection category.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the NCAP submission record was first created in the system.',
    `market_region` STRING COMMENT 'Geographic market region for which the NCAP submission is intended.. Valid values are `EU|US|CN|JP|KR|AU`',
    `model_year` STRING COMMENT 'Model year of the vehicle under test.',
    `ncap_submission_status` STRING COMMENT 'Current lifecycle state of the NCAP submission.. Valid values are `draft|submitted|approved|rejected|published|archived`',
    `notes` STRING COMMENT 'Free‑form comments or observations related to the NCAP submission.',
    `overall_star_rating` DECIMAL(18,2) COMMENT 'Aggregated overall star rating awarded by the NCAP programme (e.g., 4.5).',
    `publication_date` DATE COMMENT 'Date when the NCAP rating results were publicly released.',
    `rating_agency` STRING COMMENT 'NCAP programme that issued the rating.. Valid values are `Euro NCAP|NHTSA|ANCAP|JNCAP`',
    `safety_assist_rating` DECIMAL(18,2) COMMENT 'Star rating for safety assist technologies (e.g., ADAS) evaluated in the NCAP test.',
    `submission_reference` STRING COMMENT 'External reference code assigned by the manufacturer for the NCAP submission.',
    `submission_timestamp` TIMESTAMP COMMENT 'Date and time when the NCAP submission was officially filed.',
    `test_date` DATE COMMENT 'Date on which the NCAP crash test was performed.',
    `test_programme_version` STRING COMMENT 'Version identifier of the NCAP test programme used for the submission (e.g., "Euro NCAP 2023").',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the NCAP submission record.',
    `vehicle_variant` STRING COMMENT 'Specific model variant of the vehicle that was tested (e.g., "Model X Sport").',
    `version_number` STRING COMMENT 'Incremental version number for the submission record to support auditability.',
    `vin` STRING COMMENT 'Unique 17‑character identifier of the tested vehicle.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `vulnerable_road_user_rating` DECIMAL(18,2) COMMENT 'Star rating for vulnerable road user protection (pedestrians, cyclists).',
    CONSTRAINT pk_ncap_submission PRIMARY KEY(`ncap_submission_id`)
) COMMENT 'Master record for New Car Assessment Programme (NCAP) test submissions including Euro NCAP, NHTSA NCAP, ANCAP, and JNCAP. Captures submission date, test programme version, vehicle variant tested, star rating achieved (overall and by category: adult occupant, child occupant, vulnerable road users, safety assist), ADAS features evaluated, and publication date. Distinct from general compliance_test_event due to the structured star-rating outcome and public disclosure requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` (
    `ota_compliance_approval_id` BIGINT COMMENT 'System-generated unique identifier for the OTA compliance approval record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Link OTA compliance approval to the approval document for auditability.',
    `approval_date` DATE COMMENT 'Date the regulatory body granted the OTA approval.',
    `approval_document_url` STRING COMMENT 'Link to the official approval documentation stored in the compliance repository.',
    `approval_number` STRING COMMENT 'External reference number assigned by the regulatory authority for this OTA approval.',
    `approval_type` STRING COMMENT 'Category of the OTA approval, e.g., software update, security patch, feature enablement.',
    `compliance_category` STRING COMMENT 'Regulatory compliance framework, e.g., UNECE R155, R156.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the OTA compliance approval record was first created in the lakehouse.',
    `cybersecurity_assessment_reference` STRING COMMENT 'Identifier of the cybersecurity assessment that validated the OTA update.',
    `effective_from` DATE COMMENT 'Date from which the OTA approval becomes valid for deployment.',
    `effective_until` DATE COMMENT 'Date after which the OTA approval expires or must be renewed.',
    `jurisdiction` STRING COMMENT 'ISO 3166‑1 alpha‑3 country code of the market where the approval applies.',
    `model_year` STRING COMMENT 'Model year of the vehicle platform for which the OTA approval is applicable.',
    `notes` STRING COMMENT 'Free‑form comments or observations related to the OTA approval.',
    `ota_compliance_approval_status` STRING COMMENT 'Current lifecycle status of the OTA approval.. Valid values are `active|inactive|pending|revoked|expired`',
    `regulatory_body` STRING COMMENT 'Regulatory authority that issued the OTA approval.. Valid values are `UNECE|EPA|NHTSA|CARB|EU|Other`',
    `risk_assessment_score` DECIMAL(18,2) COMMENT 'Quantitative risk score assigned during the OTA security evaluation.',
    `software_module_identifier` STRING COMMENT 'Unique identifier of the ECU or software module targeted by the OTA update.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the OTA compliance approval record.',
    `vehicle_type` STRING COMMENT 'Classification of vehicle models covered by the OTA approval.. Valid values are `passenger|commercial|electric|hybrid|truck|suv`',
    `version_number` STRING COMMENT 'Version of the OTA approval record, incremented on each change.',
    CONSTRAINT pk_ota_compliance_approval PRIMARY KEY(`ota_compliance_approval_id`)
) COMMENT 'Master record for regulatory approvals governing Over-the-Air (OTA) software updates to vehicle ECUs and ADAS systems. Captures OTA campaign reference, affected ECU or software module, regulatory body approval (UNECE R156 Software Update Management System), approval date, jurisdiction applicability, cybersecurity assessment reference, and rollout authorization status. Ensures OTA deployments comply with UNECE R155/R156 and applicable national regulations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` (
    `fmvss_certification_id` BIGINT COMMENT 'Unique surrogate key for FMVSS certification record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Associate FMVSS certification with its certification document.',
    `compliance_emissions_certification_id` BIGINT COMMENT 'SSOT reference to owning compliance.compliance_emissions_certification (resolves cross-domain duplicate of certification).',
    `employee_id` BIGINT COMMENT 'Employee identifier of the certifying engineer.',
    `primary_employee_id` BIGINT COMMENT 'Employee identifier of the certifying engineer.',
    `test_facility_id` BIGINT COMMENT 'Identifier of the test facility where testing was performed.',
    `audit_trail_reference` STRING COMMENT 'Identifier linking to audit trail logs for this certification.',
    `certification_basis` STRING COMMENT 'Basis of certification.. Valid values are `self|third_party|manufacturer`',
    `certification_date` DATE COMMENT 'Date when certification was issued.',
    `certification_number` STRING COMMENT 'Unique certification number assigned by Automotive for tracking.',
    `certification_status` STRING COMMENT 'Current status of the certification.. Valid values are `pending|approved|revoked|expired|withdrawn`',
    `certifying_engineer_name` STRING COMMENT 'Full name of the engineer who signed off the certification.',
    `compliance_result` STRING COMMENT 'Result of compliance testing.. Valid values are `pass|fail|conditional`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the record was first created.',
    `document_hash` STRING COMMENT 'Hash of the certification document for integrity verification.',
    `effective_from` DATE COMMENT 'Date from which the certification is effective.',
    `effective_until` DATE COMMENT 'Date until which the certification remains effective (nullable).',
    `emission_class` STRING COMMENT 'Emission class applicable to the vehicle.. Valid values are `Euro6|Euro5|EPA_Tier2|EPA_Tier3|None`',
    `expiration_date` DATE COMMENT 'Date when the certification expires, if applicable.',
    `is_active` BOOLEAN COMMENT 'Indicates if the certification record is currently active.',
    `market` STRING COMMENT 'Market name (e.g., US, EU, China).',
    `model_year` STRING COMMENT 'Model year of the vehicle (e.g., 2023).',
    `notes` STRING COMMENT 'Free-text notes regarding the certification.',
    `powertrain_type` STRING COMMENT 'Powertrain technology of the vehicle.. Valid values are `ICE|EV|HEV|PHEV|FCEV`',
    `recall_implication_flag` BOOLEAN COMMENT 'Indicates whether this certification is linked to a recall implication.',
    `region_code` STRING COMMENT 'Geographic region code where certification applies. [ENUM-REF-CANDIDATE: USA|CAN|MEX|EU|CHN|JPN|KOR — 7 candidates stripped; promote to reference product]',
    `regulatory_body` STRING COMMENT 'Regulatory authority overseeing the certification.. Valid values are `NHTSA|EPA|CARB|Euro_NCAP|UNECE`',
    `safety_feature_codes` STRING COMMENT 'Comma-separated list of safety feature codes (e.g., ADAS, ESC).',
    `standard_number` STRING COMMENT 'FMVSS standard number (e.g., 208, 126, 138).',
    `standard_title` STRING COMMENT 'Title of the FMVSS standard (e.g., Occupant Crash Protection).',
    `submission_reference` STRING COMMENT 'Reference to the regulatory submission package.',
    `test_date` DATE COMMENT 'Date when the compliance test was performed.',
    `test_evidence_reference` STRING COMMENT 'Reference identifier to test evidence documents stored in DMS.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `vehicle_model` STRING COMMENT 'Model name/identifier of the vehicle covered.',
    `vehicle_type` STRING COMMENT 'Category of vehicle.. Valid values are `passenger|truck|suv|commercial|motorcycle`',
    `vehicle_vin` STRING COMMENT 'Unique 17-character VIN of the vehicle.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `version_number` STRING COMMENT 'Version of the certification record (incremented on changes).',
    CONSTRAINT pk_fmvss_certification PRIMARY KEY(`fmvss_certification_id`)
) COMMENT 'Master record for Federal Motor Vehicle Safety Standard (FMVSS) self-certification records maintained by Automotive as required by NHTSA. Captures FMVSS standard number (e.g., FMVSS 208 Occupant Crash Protection, FMVSS 126 ESC, FMVSS 138 TPMS), vehicle model and model year, certification basis (self-certification), test evidence reference, certification date, and responsible certifying engineer. Supports NHTSA audit readiness and recall root-cause traceability.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` (
    `compliance_document_id` BIGINT COMMENT 'Surrogate primary key uniquely identifying the compliance document record.',
    `jurisdiction_id` BIGINT COMMENT 'add column jurisdiction_id (BIGINT) with FK to compliance.jurisdiction.jurisdiction_id - compliance documents are jurisdiction-specific',
    `approval_authorizer` STRING COMMENT 'Name of the individual who authorized the document.',
    `approval_date` DATE COMMENT 'Date the document received formal approval.',
    `authority_region` STRING COMMENT 'Geographic region or country where the issuing authority operates.',
    `checksum` STRING COMMENT 'SHA-256 hash of the document file for integrity verification.',
    `compliance_document_status` STRING COMMENT 'Current lifecycle status of the compliance document.. Valid values are `draft|submitted|approved|rejected|revoked|expired`',
    `confidentiality_level` STRING COMMENT 'Classification indicating the sensitivity of the document content.. Valid values are `public|internal|confidential|restricted`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the document record was created in the system.',
    `compliance_document_description` STRING COMMENT 'Brief narrative describing the purpose and content of the compliance document.',
    `digital_signature_present` BOOLEAN COMMENT 'Indicates whether the document includes a verified digital signature.',
    `document_number` STRING COMMENT 'Official reference number assigned to the compliance document by the issuing authority or internal system.',
    `document_type` STRING COMMENT 'Category of the compliance document indicating its nature.. Valid values are `certificate|test_report|audit_report|approval|submission`',
    `effective_date` DATE COMMENT 'Date the documents provisions become effective.',
    `expiry_date` DATE COMMENT 'Date after which the document is no longer valid.',
    `file_format` STRING COMMENT 'File format of the stored digital document.. Valid values are `pdf|docx|xml|xlsx`',
    `file_size_bytes` BIGINT COMMENT 'Size of the digital document file in bytes.',
    `issue_date` DATE COMMENT 'Date the document was officially issued.',
    `issuing_authority` STRING COMMENT 'Organization or agency that issued the compliance document (e.g., EPA, NHTSA).',
    `jurisdiction` STRING COMMENT 'Three-letter country code representing the jurisdiction of the regulation.',
    `language` STRING COMMENT 'Language code (ISO 639-1) of the document content.',
    `market` STRING COMMENT 'Target market or region for which the compliance document applies.. Valid values are `US|EU|CN|JP|CA|AU`',
    `notes` STRING COMMENT 'Free-text field for additional remarks or comments about the document.',
    `regulation_type` STRING COMMENT 'Type of regulation the document satisfies.. Valid values are `emissions|safety|homologation|environment|fuel_economy`',
    `regulatory_body` STRING COMMENT 'Regulatory organization associated with the compliance requirement (e.g., EPA, NHTSA, CARB).',
    `related_model_year` STRING COMMENT 'Model year of the vehicle(s) to which the document applies.',
    `related_vehicle_vin` STRING COMMENT 'Vehicle Identification Number of a vehicle associated with the document, if applicable.',
    `retention_policy` STRING COMMENT 'Policy governing how long the document must be retained.',
    `storage_uri` STRING COMMENT 'Uniform Resource Identifier pointing to the document location in the document management system.',
    `submission_date` DATE COMMENT 'Date the document was submitted to the regulatory body.',
    `title` STRING COMMENT 'Descriptive title of the compliance document.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the document record.',
    `version_label` STRING COMMENT 'Human-readable version label (e.g., v1.2, Rev A).',
    `version_number` STRING COMMENT 'Sequential version identifier of the document.',
    CONSTRAINT pk_compliance_document PRIMARY KEY(`compliance_document_id`)
) COMMENT 'Master record for compliance documentation artifacts associated with regulatory submissions, certifications, and homologation records. Captures document type (Certificate of Conformity, Type Approval Certificate, Test Report, PPAP compliance evidence, IATF audit report, FMEA summary), document reference number, issuing authority, issue date, expiry date, storage location (document management system URI), and document status. Provides the document register for the compliance domain.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`compliance_audit_finding` (
    `compliance_audit_finding_id` BIGINT COMMENT 'Unique identifier for the compliance_audit_finding data product (auto-inserted pre-linking).',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_obligation. Business justification: Link audit findings to the specific compliance obligation they relate to.',
    CONSTRAINT pk_compliance_audit_finding PRIMARY KEY(`compliance_audit_finding_id`)
) COMMENT 'Transactional record for findings raised during regulatory audits, IATF 16949 surveillance audits, ISO 14001 environmental audits, and internal compliance audits. Captures audit type, auditing body, finding category (major non-conformance, minor non-conformance, observation, opportunity for improvement), finding description, affected process or product, corrective action required, due date, and closure status. Supports IATF 16949 and ISO 9001 corrective action management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`compliance_corrective_action` (
    `compliance_corrective_action_id` BIGINT COMMENT 'Primary key for local compliance_corrective_action reference',
    `quality_corrective_action_id` BIGINT COMMENT 'FK reference to SSOT quality.quality_corrective_action',
    CONSTRAINT pk_compliance_corrective_action PRIMARY KEY(`compliance_corrective_action_id`)
) COMMENT 'Reference to SSOT owner quality.quality_corrective_action. Transactional record tracking corrective and preventive actions (CAPA) initiated in response to audit findings, regulatory non-conformances, or compliance violations. Captures root cause analysis method (5-Why, Ishikawa), root cause description, corrective action plan, responsible owner, implementation date, verification method, effectiveness review date, and closure status. Supports IATF 16949 clause 10.2 and regulatory corrective action commitments to NHTSA, EPA, or CARB.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` (
    `trade_compliance_record_id` BIGINT COMMENT 'System-generated unique identifier for the trade compliance record.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Add jurisdiction reference to trade compliance records for import/export regulation mapping.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier providing the kit, part, or vehicle.',
    `audit_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the compliance record was first created in the system.',
    `audit_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the compliance record.',
    `compliance_officer` STRING COMMENT 'Name of the internal officer responsible for this compliance record.',
    `compliance_status` STRING COMMENT 'Current compliance state of the record.. Valid values are `COMPLIANT|NON_COMPLIANT|PENDING|EXEMPT|REVOKED`',
    `country_of_origin` STRING COMMENT 'Three‑letter ISO code of the country where the kit or part was manufactured.',
    `customs_duty_rate` DECIMAL(18,2) COMMENT 'Applicable duty percentage for the HS code and country of origin.',
    `destination_country` STRING COMMENT 'Three‑letter ISO code of the country where the goods are destined.',
    `effective_date` DATE COMMENT 'Date when the compliance record became effective.',
    `expiration_date` DATE COMMENT 'Date when the compliance record expires, if applicable.',
    `export_control_classification` STRING COMMENT 'Classification indicating whether the item is subject to EAR or ITAR export controls.. Valid values are `EAR|ITAR|NONE`',
    `free_trade_agreement` STRING COMMENT 'Identifies the FTA that may reduce or eliminate duties for this shipment.. Valid values are `USMCA|EU-Japan_EPA|NAFTA|EU|NONE`',
    `hs_tariff_code` STRING COMMENT 'Six‑to‑ten digit code used to classify goods for customs duties.. Valid values are `^[0-9]{6,10}$`',
    `import_license_reference` STRING COMMENT 'Identifier of the import license authorizing entry of the kit or part.',
    `last_review_date` DATE COMMENT 'Date when the compliance record was last reviewed for accuracy.',
    `notes` STRING COMMENT 'Additional comments, observations, or special handling instructions.',
    `origin_port` STRING COMMENT 'UN/LOCODE of the port where the shipment originated.. Valid values are `^[A-Z]{5}$`',
    `part_number` STRING COMMENT 'Manufacturer part number when the record relates to an individual component.',
    `product_type` STRING COMMENT 'Indicates whether the record pertains to a completely knocked down kit, semi‑knocked down kit, finished vehicle, or individual part.. Valid values are `CKD|SKD|FINISHED_VEHICLE|PART`',
    `record_number` STRING COMMENT 'External reference number assigned by the compliance system for tracking.',
    `trade_regulation_code` STRING COMMENT 'Code of the specific regulation governing the trade (e.g., EPA emissions, NHTSA FMVSS).. Valid values are `EPA|CARB|NHTSA|EURO_NCAP|UNECE|IATF`',
    `vehicle_model` STRING COMMENT 'Name/identifier of the vehicle model (e.g., Corolla, F‑150).',
    `vehicle_model_year` STRING COMMENT 'Model year of the vehicle associated with the compliance record, if applicable.',
    CONSTRAINT pk_trade_compliance_record PRIMARY KEY(`trade_compliance_record_id`)
) COMMENT 'Master record for import/export trade compliance covering CKD (Completely Knocked Down) and SKD (Semi Knocked Down) vehicle kits, parts, and finished vehicles. Captures HS tariff code, country of origin, export control classification (EAR/ITAR), free trade agreement applicability (USMCA, EU-Japan EPA), customs duty rate, import license reference, and compliance status. Supports trade compliance obligations across Automotives global manufacturing and distribution footprint.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` (
    `environmental_permit_id` BIGINT COMMENT 'System-generated unique identifier for the environmental permit record.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant or facility associated with the permit.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Connect environmental permits to the jurisdiction that issued them.',
    `primary_environmental_plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant or facility associated with the permit.',
    `compliance_monitoring_frequency` STRING COMMENT 'How often compliance monitoring is performed for this permit.. Valid values are `monthly|quarterly|annually|biannually|on_demand`',
    `compliance_status` STRING COMMENT 'Overall compliance status based on monitoring results.. Valid values are `compliant|non_compliant|conditionally_compliant|under_review`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the permit record was created in the system.',
    `emission_report_submission_date` DATE COMMENT 'Date when the latest emission report was submitted to the authority.',
    `environmental_permit_status` STRING COMMENT 'Current operational status of the permit.. Valid values are `active|inactive|suspended|expired|revoked`',
    `expiry_date` DATE COMMENT 'Date when the permit expires unless renewed.',
    `is_exempt` BOOLEAN COMMENT 'Indicates whether the facility is exempt from certain permit requirements.',
    `issue_date` DATE COMMENT 'Date when the permit was officially issued.',
    `issuing_authority` STRING COMMENT 'Regulatory body that issued the permit.. Valid values are `EPA|State Environmental Agency|Local Authority|CARB|EU Commission`',
    `last_inspection_date` DATE COMMENT 'Date of the most recent compliance inspection for the permit.',
    `monitoring_method` STRING COMMENT 'Method used to monitor emissions for the permit.. Valid values are `continuous|periodic|spot|modeling`',
    `next_inspection_due` DATE COMMENT 'Scheduled date for the next required inspection.',
    `notes` STRING COMMENT 'Free-text field for additional remarks or observations about the permit.',
    `permit_category` STRING COMMENT 'Level of government that issued the permit.. Valid values are `federal|state|local`',
    `permit_number` STRING COMMENT 'Unique identifier assigned by the issuing authority to the environmental permit.',
    `permit_type` STRING COMMENT 'Category of environmental permit indicating the regulated activity.. Valid values are `air_emissions|wastewater|hazardous_waste|stormwater|solid_waste`',
    `pollutant_code` STRING COMMENT 'Standard code for the pollutant covered by the permit limit.. Valid values are `CO2|NOx|SO2|PM2.5|VOC|Lead`',
    `pollutant_limit_unit` STRING COMMENT 'Unit of measurement for the pollutant limit.. Valid values are `kg|ton|lb|g`',
    `pollutant_limit_value` DECIMAL(18,2) COMMENT 'Maximum allowable emission amount for the pollutant per reporting period.',
    `regulatory_body` STRING COMMENT 'Name of the regulatory organization overseeing the permit.',
    `renewal_status` STRING COMMENT 'Current status of the permit renewal process.. Valid values are `pending|approved|rejected|not_required`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the permit record.',
    `version_number` STRING COMMENT 'Incremental version of the permit record for audit purposes.',
    CONSTRAINT pk_environmental_permit PRIMARY KEY(`environmental_permit_id`)
) COMMENT 'Master record for environmental operating permits held by Automotive manufacturing plants and facilities. Captures permit type (air emissions permit, wastewater discharge permit, hazardous waste permit), issuing regulatory authority (EPA, state environmental agency), permit number, facility reference, permitted emission limits by pollutant, permit issue date, expiry date, renewal status, and compliance monitoring frequency. Supports ISO 14001 environmental management and EPA reporting obligations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` (
    `emissions_monitoring_reading_id` BIGINT COMMENT 'System-generated unique identifier for each emissions monitoring reading record.',
    `emissions_monitoring_point_id` BIGINT COMMENT 'Unique identifier of the physical monitoring location (e.g., stack, wastewater discharge point, ambient station).',
    `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: Associate emissions monitoring readings with the specific environmental permit they satisfy.',
    `calibration_date` DATE COMMENT 'Date when the monitoring equipment was last calibrated.',
    `compliance_status` STRING COMMENT 'Current compliance determination for this reading against the permitted limit.. Valid values are `compliant|non_compliant|pending|exempt`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the reading record was first created in the data lake.',
    `data_quality_flag` BOOLEAN COMMENT 'Indicator of the overall quality assessment of the reading.',
    `exceedance_flag` BOOLEAN COMMENT 'Indicates whether the measured value exceeds the permitted limit (true = exceedance).',
    `jurisdiction` STRING COMMENT 'ISO‑3 country code representing the geographic jurisdiction of the permit.. Valid values are `^[A-Z]{3}$`',
    `measured_value` DECIMAL(18,2) COMMENT 'Numeric value of the pollutant concentration or emission rate recorded.',
    `measurement_technique` STRING COMMENT 'Specific technique or location category used for the measurement.. Valid values are `stack|ambient|process`',
    `monitoring_method` STRING COMMENT 'Technique used to obtain the reading, e.g., Continuous Emissions Monitoring System (CEMS) or manual sampling.. Valid values are `CEMS|manual_sampling|continuous_sampler`',
    `notes` STRING COMMENT 'Free‑form comments or observations related to the reading.',
    `permitted_limit` DECIMAL(18,2) COMMENT 'Regulatory or permit‑based maximum allowable value for the pollutant.',
    `pollutant_type` STRING COMMENT 'Type of pollutant measured, aligned with regulatory reporting categories.. Valid values are `NOx|SOx|VOC|CO2|PM`',
    `reading_timestamp` TIMESTAMP COMMENT 'Date and time when the emissions measurement was recorded at the monitoring point.',
    `record_status` STRING COMMENT 'Lifecycle status of the record within the data system.. Valid values are `active|inactive|archived`',
    `regulatory_body` STRING COMMENT 'Government agency or standards organization governing the emission limit.. Valid values are `EPA|CARB|NHTSA|EU|UNECE|Other`',
    `sample_duration_minutes` STRING COMMENT 'Length of time over which the sample was collected, expressed in minutes.',
    `sensor_code` BIGINT COMMENT 'Unique identifier of the sensor or instrument that captured the reading.',
    `unit_of_measure` STRING COMMENT 'Unit in which the measured value is expressed.. Valid values are `ppm|ppb|mg/m3|µg/m3|g/kWh`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the reading record.',
    CONSTRAINT pk_emissions_monitoring_reading PRIMARY KEY(`emissions_monitoring_reading_id`)
) COMMENT 'Transactional record capturing periodic emissions monitoring readings from manufacturing plant stacks, wastewater discharge points, and facility-level environmental monitoring stations. Captures reading timestamp, monitoring point identifier, pollutant type (NOx, SOx, VOC, CO2, particulate matter), measured value, unit of measure, permitted limit, exceedance flag, and monitoring method (CEMS, manual sampling). Supports EPA Continuous Emissions Monitoring System (CEMS) reporting and permit compliance verification.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` (
    `recall_defect_report_id` BIGINT COMMENT 'Unique surrogate key for the recall defect report record.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Recall defect reports are issued per vehicle model; FK to model provides quick aggregation of recall statistics by model for safety compliance.',
    `party_id` BIGINT COMMENT 'Identifier of the vehicle manufacturer associated with the defect report.',
    `recall_campaign_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_recall_campaign. Business justification: Link defect reports to the recall campaign they belong to for root‑cause tracking.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: REQUIRED: Recall reports must reference the exact SKU to ensure precise part‑level remediation and dealer notifications.',
    `affected_nameplates` STRING COMMENT 'List of vehicle nameplates (e.g., Corolla, Camry) impacted by the defect.',
    `defect_category` STRING COMMENT 'High-level classification of the defect (safety, emissions, structural, other).. Valid values are `safety|emissions|structural|other`',
    `defect_description` STRING COMMENT 'Narrative description of the defect and its technical details.',
    `fatality_count` STRING COMMENT 'Number of reported fatalities associated with the defect.',
    `incident_count` STRING COMMENT 'Total number of defect incidents reported in this submission.',
    `injury_count` STRING COMMENT 'Number of reported injuries associated with the defect.',
    `investigation_status` STRING COMMENT 'Current status of the NHTSA investigation related to this defect.. Valid values are `open|closed|under_review|pending`',
    `model_year` STRING COMMENT 'Model year of the affected vehicle.',
    `nhtsa_investigation_number` STRING COMMENT 'Unique identifier for the NHTSA investigation, if opened.',
    `notes` STRING COMMENT 'Additional free-text comments or observations related to the report.',
    `recall_defect_report_status` STRING COMMENT 'Current lifecycle status of the report record.. Valid values are `draft|submitted|approved|rejected`',
    `recall_number` STRING COMMENT 'Identifier of the associated recall campaign, if any.',
    `regulation_code` STRING COMMENT 'Code of the specific regulation or standard referenced (e.g., FMVSS 111).',
    `regulatory_agency` STRING COMMENT 'Regulatory body overseeing the report or investigation.. Valid values are `NHTSA|EPA|CARB|EU_NCAP|UNECE`',
    `remedy_description` STRING COMMENT 'Description of the corrective action or remedy proposed for the defect.',
    `report_creation_timestamp` TIMESTAMP COMMENT 'Date and time when the recall defect report record was created in the system.',
    `report_last_updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the report record.',
    `report_number` STRING COMMENT 'External identifier assigned to the recall defect report by the reporting entity.',
    `report_submission_timestamp` TIMESTAMP COMMENT 'Date and time when the report was submitted to the regulatory agency.',
    `report_type` STRING COMMENT 'Category of the report submitted (e.g., Early Warning Reporting quarterly, Part 579 defect, consumer complaint aggregate, field report).. Valid values are `ewr_quarterly|part_579|consumer_complaint|field_report`',
    `reporting_period` STRING COMMENT 'The calendar period (e.g., 2023-Q1) that the report covers.',
    `vehicle_model` STRING COMMENT 'Model name or code of the vehicle affected by the defect.',
    `version_number` STRING COMMENT 'Version of the report record for audit purposes.',
    `vin_range_end` STRING COMMENT 'Ending VIN in the range of vehicles affected.',
    `vin_range_start` STRING COMMENT 'Starting VIN in the range of vehicles affected.',
    CONSTRAINT pk_recall_defect_report PRIMARY KEY(`recall_defect_report_id`)
) COMMENT 'Transactional record for Early Warning Reporting (EWR) and defect investigation reports submitted to or received from NHTSA. Captures report type (EWR quarterly report, Part 579 defect report, consumer complaint aggregate, field report), reporting period, defect category (safety, emissions, structural), number of incidents reported, injury/fatality count, investigation status, and NHTSA investigation number if opened. Supports 49 CFR Part 579 Early Warning Reporting obligations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`waiver` (
    `waiver_id` BIGINT COMMENT 'System-generated unique identifier for the compliance waiver record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Link waivers to their supporting compliance document.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Add jurisdiction reference to waivers for regional applicability.',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_obligation. Business justification: Tie waivers to the specific compliance obligation they modify.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Associate waivers with the regulatory requirement they exempt.',
    `amount` DECIMAL(18,2) COMMENT 'Monetary value associated with the waiver, if any.',
    `applicable_market` STRING COMMENT 'Geographic market or region where the waiver is valid.',
    `applicable_model_year_end` STRING COMMENT 'Last model year for which the waiver is applicable.',
    `applicable_model_year_start` STRING COMMENT 'First model year for which the waiver is applicable.',
    `applicable_vehicle_model` STRING COMMENT 'Vehicle model(s) to which the waiver applies.',
    `conditions_attached` STRING COMMENT 'Specific conditions or obligations that must be met while the waiver is in effect.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the waiver record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 currency code for the waiver amount.',
    `waiver_description` STRING COMMENT 'Brief textual description of the waiver purpose and scope.',
    `effective_from` DATE COMMENT 'Date when the waiver becomes effective for compliance purposes.',
    `effective_until` DATE COMMENT 'Date when the waiver expires or ceases to be effective.',
    `granted_date` DATE COMMENT 'Date on which the waiver was officially granted.',
    `granting_authority` STRING COMMENT 'Organization or agency that granted the waiver.',
    `justification` STRING COMMENT 'Business rationale and supporting arguments for obtaining the waiver.',
    `monitoring_frequency` STRING COMMENT 'How often compliance monitoring must be performed.. Valid values are `monthly|quarterly|annually|on_demand`',
    `monitoring_method` STRING COMMENT 'Method used for monitoring (e.g., reporting, audit, sensor data).',
    `monitoring_requirements` STRING COMMENT 'Requirements for compliance monitoring during the waiver period.',
    `notes` STRING COMMENT 'Free‑form notes or comments related to the waiver.',
    `reference_number` STRING COMMENT 'Reference number used by the authority for tracking the waiver.',
    `regulation_code` STRING COMMENT 'Official code or identifier of the regulation to which the waiver applies.',
    `regulatory_body` STRING COMMENT 'Regulatory body responsible for the underlying regulation (e.g., EPA, CARB, NHTSA).',
    `updated_by` STRING COMMENT 'User or system identifier that last updated the waiver record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the waiver record.',
    `version_number` STRING COMMENT 'Version number for the waiver record to support change tracking.',
    `waiver_number` STRING COMMENT 'External reference number assigned by the granting authority to the waiver.',
    `waiver_status` STRING COMMENT 'Current lifecycle status of the waiver.. Valid values are `pending|active|suspended|revoked|expired`',
    `waiver_type` STRING COMMENT 'Category of the waiver, such as CAFE exemption, CARB ZEV credit waiver, FMVSS temporary exemption, or other.. Valid values are `cafe_exemption|carb_zev|fmvss_temp|other`',
    `created_by` STRING COMMENT 'User or system identifier that created the waiver record.',
    CONSTRAINT pk_waiver PRIMARY KEY(`waiver_id`)
) COMMENT 'Master record for regulatory waivers, exemptions, and derogations granted to Automotive by regulatory bodies. Captures waiver type (CAFE small manufacturer exemption, CARB ZEV credit waiver, FMVSS temporary exemption), granting authority, waiver reference number, applicable regulation, justification basis, granted date, expiry date, conditions attached, and compliance monitoring requirements during the waiver period.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` (
    `zev_credit_id` BIGINT COMMENT 'System-generated unique identifier for each ZEV credit record.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Link ZEV credit transactions to jurisdiction for regional credit accounting.',
    `party_id` BIGINT COMMENT 'Identifier of the external party involved in a credit transfer or retirement.',
    `compliance_program` STRING COMMENT 'Regulatory compliance program under which the credit is tracked.. Valid values are `ZEV|GHG`',
    `counterparty_role` STRING COMMENT 'Role of the counterparty in the credit transaction.. Valid values are `buyer|seller|regulator|none`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the credit record was first created in the lakehouse.',
    `credit_basis` STRING COMMENT 'Basis on which the credit was earned, such as vehicle sales volume, powertrain type, or fleet volume.. Valid values are `vehicle_sales|powertrain_type|fleet_volume`',
    `credit_price_usd` DECIMAL(18,2) COMMENT 'Monetary valuation of a single credit in U.S. dollars, if applicable for trading.',
    `credit_quantity` DECIMAL(18,2) COMMENT 'Number of credits (can be fractional) associated with the transaction.',
    `credit_status` STRING COMMENT 'Current lifecycle status of the credit record.. Valid values are `earned|banked|transferred|retired|pending|cancelled`',
    `credit_transaction_number` STRING COMMENT 'External business identifier for the credit transaction, used in regulatory filings and audits.',
    `credit_type` STRING COMMENT 'Category of credit earned or managed, indicating zero‑emission vehicle (ZEV) or greenhouse‑gas (GHG) credit.. Valid values are `ZEV|TZEV|AT_PZEV|GHG`',
    `credit_vintage_year` STRING COMMENT 'Calendar year in which the credit was originally earned.',
    `effective_date` DATE COMMENT 'Date the credit becomes effective for compliance accounting.',
    `expiration_date` DATE COMMENT 'Date the credit expires if not used or retired.',
    `model_year` STRING COMMENT 'Model year of the vehicle or powertrain that generated the credit.',
    `notes` STRING COMMENT 'Free‑form comments or audit notes related to the credit transaction.',
    `powertrain_type` STRING COMMENT 'Technology classification of the powertrain associated with the credit.. Valid values are `BEV|PHEV|HEV|ICE`',
    `region` STRING COMMENT 'Geographic region or jurisdiction code where the credit is reported.',
    `regulatory_body` STRING COMMENT 'Regulatory authority governing the credit (e.g., CARB, EPA).. Valid values are `CARB|EPA|NHTSA|EU|UN|OTHER`',
    `retirement_reason` STRING COMMENT 'Reason why a credit was retired (e.g., compliance fulfillment, voluntary surrender).',
    `source_record_reference` STRING COMMENT 'Identifier of the source record in the originating system.',
    `transaction_date` DATE COMMENT 'Date the credit event (earn, transfer, retirement) occurred.',
    `transaction_reference_number` STRING COMMENT 'External reference number for the credit transfer or retirement filing.',
    `transaction_type` STRING COMMENT 'High‑level classification of the credit event: earn, transfer, or retire.. Valid values are `earn|transfer|retire`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the credit record.',
    `version_number` STRING COMMENT 'Optimistic concurrency control version for the credit record.',
    CONSTRAINT pk_zev_credit PRIMARY KEY(`zev_credit_id`)
) COMMENT 'Master record for Zero Emission Vehicle (ZEV) and greenhouse gas (GHG) compliance credits earned, purchased, transferred, or retired under CARB ZEV mandate and EPA GHG credit programs. Captures credit type (ZEV, TZEV, AT PZEV, GHG), model year, credit quantity, credit vintage, earning basis (vehicle sales volume, powertrain type), credit status (earned, banked, transferred, retired), and counterparty for credit transfers. Supports CARB ZEV mandate compliance and EPA GHG credit banking strategy.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` (
    `homologation_market_approval_id` BIGINT COMMENT 'System-generated unique identifier for the homologation market approval record.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: Link homologation_market_approval to its parent homologation_record to capture market‑specific approval status.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Link homologation_market_approval to jurisdiction for market context.',
    `additional_requirements` STRING COMMENT 'Extra documentation, testing, or reporting obligations attached to the approval.',
    `approval_authority` STRING COMMENT 'Name of the governmental or standards body that granted the market approval (e.g., NHTSA, EPA, CARB, Euro NCAP).',
    `approval_date` DATE COMMENT 'Date the approval authority formally granted the approval.',
    `approval_number` STRING COMMENT 'Unique identifier assigned by the approval authority to this specific market approval.',
    `approval_status_date` DATE COMMENT 'Date when the approval status last changed (e.g., from pending to approved).',
    `approval_type` STRING COMMENT 'Category of the approval (initial, supplemental, or renewal).. Valid values are `initial|supplemental|renewal`',
    `body_style` STRING COMMENT 'Physical configuration of the vehicle (e.g., sedan, SUV).. Valid values are `sedan|SUV|truck|van|coupe|convertible`',
    `compliance_document_url` STRING COMMENT 'Link to the electronic copy of the approval certificate or supporting documentation.',
    `conditions_of_approval` STRING COMMENT 'Specific conditions, limitations, or compliance actions required by the authority.',
    `derogations` STRING COMMENT 'Any market‑specific exemptions or deviations granted from standard requirements.',
    `effective_date` DATE COMMENT 'Date from which the approval becomes legally effective for sales.',
    `emission_standard` STRING COMMENT 'Regulatory emissions regime applicable (e.g., EPA Tier 3, Euro 6, WLTP).',
    `expiration_date` DATE COMMENT 'Date on which the approval ceases to be valid unless renewed.',
    `fuel_type` STRING COMMENT 'Primary energy source of the vehicle powertrain.. Valid values are `gasoline|diesel|electric|hybrid|plug_in_hybrid`',
    `homologation_market_approval_status` STRING COMMENT 'Current lifecycle status of the market approval.. Valid values are `approved|pending|rejected|withdrawn|suspended`',
    `market_jurisdiction` STRING COMMENT 'Three‑letter country code representing the market or jurisdiction where the vehicle variant is approved.. Valid values are `^[A-Z]{3}$`',
    `market_region` STRING COMMENT 'Geographic region grouping of markets (e.g., North America, Europe, Asia‑Pacific).',
    `model_year` STRING COMMENT 'Calendar year for which the vehicle model is marketed.',
    `notes` STRING COMMENT 'Free‑form comments or observations related to the approval.',
    `powertrain_type` STRING COMMENT 'Classification of the vehicles powertrain technology.. Valid values are `ICE|EV|HEV|PHEV`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the approval record was first created in the data lake.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the approval record.',
    `test_cycle` STRING COMMENT 'Laboratory test cycle used for emissions or fuel‑consumption testing.',
    `test_date` DATE COMMENT 'Date the certification test was performed.',
    `test_lab` STRING COMMENT 'Name of the accredited laboratory that conducted the test.',
    `vehicle_model` STRING COMMENT 'Manufacturer‑defined model name or code of the vehicle variant covered by the approval.',
    `version_number` STRING COMMENT 'Version identifier for the approval record, incremented on each amendment.',
    CONSTRAINT pk_homologation_market_approval PRIMARY KEY(`homologation_market_approval_id`)
) COMMENT 'Association record linking a homologation record to a specific market/jurisdiction approval status. Captures market, approval authority, approval date, approval number, validity period, conditions of approval, and any market-specific derogations or additional requirements. Enables tracking of which vehicle variants are approved for sale in which markets, supporting global market launch planning and compliance status dashboards.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` (
    `regulatory_change_notice_id` BIGINT COMMENT 'System-generated unique identifier for the regulatory change notice record.',
    `employee_id` BIGINT COMMENT 'Internal employee or team responsible for managing compliance to this notice.',
    `regulatory_body_id` BIGINT COMMENT 'Internal identifier of the regulatory agency responsible for the notice.',
    `regulatory_compliance_owner_employee_id` BIGINT COMMENT 'Internal employee or team responsible for managing compliance to this notice.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Tie change notices to the regulatory requirement they amend.',
    `affected_vehicle_programs` STRING COMMENT 'Comma‑separated list of vehicle programs (model lines) potentially impacted by the regulatory change.',
    `comment_period_end_date` DATE COMMENT 'Final date by which stakeholders may submit comments on the proposed regulation.',
    `comment_period_extended` BOOLEAN COMMENT 'Indicates whether the original comment period has been extended.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the notice record was first created in the data lake.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the estimated impact cost.. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'Date the regulation or rule becomes legally effective.',
    `estimated_impact_cost` DECIMAL(18,2) COMMENT 'Projected financial impact (cost) to the organization resulting from the regulatory change.',
    `extended_comment_deadline` DATE COMMENT 'New deadline date if the comment period was extended.',
    `impact_assessment_status` STRING COMMENT 'Progress status of the internal impact assessment for this notice.. Valid values are `not_started|in_progress|completed`',
    `impact_description` STRING COMMENT 'Narrative description of the anticipated operational or financial impact.',
    `jurisdiction` STRING COMMENT 'Three‑letter country or region code where the regulation applies.. Valid values are `^[A-Z]{3}$`',
    `notes` STRING COMMENT 'Free‑form notes or comments about the regulatory change notice.',
    `notice_number` STRING COMMENT 'External reference number assigned by the publishing body to the regulatory change notice.',
    `notice_type` STRING COMMENT 'Category of the notice indicating its stage in the rulemaking process.. Valid values are `NPRM|Final Rule|Guidance Document|Technical Circular`',
    `publication_date` DATE COMMENT 'Date the regulatory notice was officially published.',
    `publishing_body` STRING COMMENT 'Organization or agency that issued the regulatory change notice.. Valid values are `EPA|NHTSA|EU|CARB|IATF|SAE`',
    `regulation_reference` STRING COMMENT 'Official code or identifier of the underlying regulation (e.g., EPA‑40CFR106.10).',
    `regulatory_change_notice_status` STRING COMMENT 'Current lifecycle state of the regulatory change notice.. Valid values are `draft|published|under_review|closed|expired`',
    `related_documents` STRING COMMENT 'Comma‑separated list of URLs or internal IDs for supporting documentation.',
    `source_system_record_reference` STRING COMMENT 'Unique identifier of the notice in the source system.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the notice record.',
    CONSTRAINT pk_regulatory_change_notice PRIMARY KEY(`regulatory_change_notice_id`)
) COMMENT 'Transactional record tracking incoming regulatory changes, proposed rules, and final rules published by governing bodies that may impact Automotives products or operations. Captures regulation reference, publishing body, notice type (NPRM, Final Rule, Guidance Document, Technical Circular), publication date, comment period deadline, effective date, impact assessment status, affected vehicle programs, and assigned compliance owner. Supports proactive regulatory horizon scanning and impact assessment.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` (
    `emissions_monitoring_point_id` BIGINT COMMENT 'Primary key for emissions_monitoring_point',
    `parent_emissions_monitoring_point_id` BIGINT COMMENT 'Self-referencing FK on emissions_monitoring_point (parent_emissions_monitoring_point_id)',
    `alert_status` STRING COMMENT 'Current alert condition based on the latest reading.',
    `calibration_date` DATE COMMENT 'Most recent date the sensor was calibrated.',
    `calibration_status` STRING COMMENT 'Current calibration status of the sensor.',
    `country_code` STRING COMMENT 'Three‑letter ISO country code where the point resides.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the monitoring point record was created in the system.',
    `data_capture_frequency_seconds` STRING COMMENT 'Interval in seconds between consecutive emissions readings.',
    `data_quality_flag` BOOLEAN COMMENT 'Indicator of the reliability of the latest reading.',
    `decommission_date` DATE COMMENT 'Date the sensor was removed or retired (null if still active).',
    `emissions_monitoring_point_description` STRING COMMENT 'Free‑form description of the monitoring point location, purpose, or special notes.',
    `emission_standard` STRING COMMENT 'Applicable emissions standard or test protocol for the point.',
    `facility_code` STRING COMMENT 'Identifier of the plant or facility where the point is installed.',
    `installation_date` DATE COMMENT 'Date the sensor was installed at the monitoring point.',
    `jurisdiction` STRING COMMENT 'Regulatory authority governing the emissions data for this point.',
    `last_read_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent emissions measurement.',
    `last_read_value` DECIMAL(18,2) COMMENT 'Most recent emissions measurement value.',
    `location_latitude` DOUBLE COMMENT 'Geographic latitude of the monitoring point (decimal degrees).',
    `location_longitude` DOUBLE COMMENT 'Geographic longitude of the monitoring point (decimal degrees).',
    `measurement_range_max` DECIMAL(18,2) COMMENT 'Highest measurable emission value for the sensor.',
    `measurement_range_min` DECIMAL(18,2) COMMENT 'Lowest measurable emission value for the sensor.',
    `measurement_unit` STRING COMMENT 'Unit of measurement for emissions values recorded at this point.',
    `next_calibration_due` DATE COMMENT 'Scheduled date for the next required calibration.',
    `notes` STRING COMMENT 'Supplemental information or comments entered by engineers or compliance staff.',
    `point_code` STRING COMMENT 'External code or tag used to reference the monitoring point in regulatory filings.',
    `point_name` STRING COMMENT 'Human‑readable name of the emissions monitoring point.',
    `point_type` STRING COMMENT 'Category of emissions measured at the point (e.g., exhaust, evaporative).',
    `sensor_model` STRING COMMENT 'Manufacturer model number of the emissions sensor.',
    `sensor_serial_number` STRING COMMENT 'Unique serial number of the emissions sensor (device identifier).',
    `emissions_monitoring_point_status` STRING COMMENT 'Current operational status of the monitoring point.',
    `threshold_value` DECIMAL(18,2) COMMENT 'Emissions value that triggers an alert; expressed in the measurement unit.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the monitoring point record.',
    CONSTRAINT pk_emissions_monitoring_point PRIMARY KEY(`emissions_monitoring_point_id`)
) COMMENT 'Master reference table for emissions_monitoring_point. Referenced by monitoring_point_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`test_facility` (
    `test_facility_id` BIGINT COMMENT 'Primary key for test_facility',
    `parent_test_facility_id` BIGINT COMMENT 'Self-referencing FK on test_facility (parent_test_facility_id)',
    `audit_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the facility record was first created in the data lake.',
    `audit_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the facility record.',
    `capacity_per_day` STRING COMMENT 'Maximum number of vehicles that can be tested in a full day.',
    `certification_status` STRING COMMENT 'Current status of the facilitys certification.',
    `certification_type` STRING COMMENT 'Regulatory program under which the facility is certified.',
    `city` STRING COMMENT 'City where the facility is located.',
    `contact_email` STRING COMMENT 'Email address of the facilitys primary contact.',
    `contact_name` STRING COMMENT 'Name of the primary contact person for the facility.',
    `contact_phone` STRING COMMENT 'Phone number of the facilitys primary contact.',
    `country` STRING COMMENT 'Three‑letter ISO country code of the facility.',
    `emission_test_type` STRING COMMENT 'Primary emission measurement performed at the facility.',
    `energy_source` STRING COMMENT 'Dominant energy source used to power test equipment.',
    `established_date` DATE COMMENT 'Date the facility was originally opened.',
    `facility_code` STRING COMMENT 'External code used to reference the facility in regulatory filings and internal systems.',
    `facility_type` STRING COMMENT 'Category of testing services provided by the facility.',
    `is_24x7` BOOLEAN COMMENT 'Indicates whether the facility operates continuously (true) or not (false).',
    `last_inspection_date` DATE COMMENT 'Most recent date a regulatory or internal inspection was performed.',
    `latitude` DOUBLE COMMENT 'Latitude coordinate of the facility.',
    `location_address` STRING COMMENT 'Street address of the test facility.',
    `longitude` DOUBLE COMMENT 'Longitude coordinate of the facility.',
    `max_speed_kph` STRING COMMENT 'Highest vehicle speed (km/h) that can be safely tested at the facility.',
    `test_facility_name` STRING COMMENT 'Human‑readable name of the test facility.',
    `next_certification_due` DATE COMMENT 'Scheduled date for the next required certification renewal.',
    `notes` STRING COMMENT 'Free‑form field for any supplemental information about the facility.',
    `operating_hours_per_day` STRING COMMENT 'Number of hours the facility operates each day.',
    `safety_test_type` STRING COMMENT 'Primary safety test category conducted at the facility.',
    `state` STRING COMMENT 'State or province of the facility location.',
    `test_facility_status` STRING COMMENT 'Current operational status of the facility.',
    `test_capability_description` STRING COMMENT 'Free‑text description of the testing capabilities offered.',
    CONSTRAINT pk_test_facility PRIMARY KEY(`test_facility_id`)
) COMMENT 'Master reference table for test_facility. Referenced by test_facility_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` (
    `regulatory_body_id` BIGINT COMMENT 'Primary key for regulatory_body',
    `parent_regulatory_body_id` BIGINT COMMENT 'Self-referencing FK on regulatory_body (parent_regulatory_body_id)',
    `abbreviation` STRING COMMENT 'Common short name or acronym of the regulatory body.',
    `address` STRING COMMENT 'Physical mailing address of the regulatory body headquarters.',
    `contact_email` STRING COMMENT 'Primary contact email address for the regulatory body.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the regulatory body record was initially created.',
    `data_privacy_level` STRING COMMENT 'Data privacy classification level for information received from this body.',
    `regulatory_body_description` STRING COMMENT 'Additional free-text description or notes about the regulatory body.',
    `effective_date` DATE COMMENT 'Date when the regulatory body entry became effective in the system.',
    `expiry_date` DATE COMMENT 'Date when the regulatory body entry is no longer valid (if applicable).',
    `iso_iec_codes` STRING COMMENT 'List of ISO or IEC codes associated with the regulatory body (e.g., ISO 26262).',
    `jurisdiction` STRING COMMENT 'ISO 3166-1 alpha-3 country code where the regulatory body has authority.',
    `last_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the regulatory body record.',
    `regulatory_body_name` STRING COMMENT 'Official full name of the regulatory authority.',
    `phone_number` STRING COMMENT 'Main telephone number for the regulatory body.',
    `region` STRING COMMENT 'Geographic region classification (e.g., North America, Europe).',
    `regulatory_type` STRING COMMENT 'Category of regulatory authority (e.g., environmental, safety, trade).',
    `reporting_frequency` STRING COMMENT 'Typical reporting frequency required by the body (e.g., annual, quarterly).',
    `regulatory_body_status` STRING COMMENT 'Current operational status of the regulatory body in the system.',
    `website_url` STRING COMMENT 'Official website URL of the regulatory body.',
    CONSTRAINT pk_regulatory_body PRIMARY KEY(`regulatory_body_id`)
) COMMENT 'Master reference table for regulatory_body. Referenced by regulatory_body_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` (
    `homologation_variant_id` BIGINT COMMENT 'Unique identifier for the homologation variant record. Primary key.',
    `aftersales_trim_level_id` BIGINT COMMENT 'Reference to the specific trim level or configuration within the nameplate that this homologation variant applies to. Nullable if variant applies to all trims.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Reference to the vehicle nameplate (model line) that this homologation variant applies to. Links to the nameplate master data.',
    `sku_id` BIGINT COMMENT 'Reference to the base commercial SKU that this homologation variant is derived from. Links to the product catalog SKU master.',
    `adas_level` STRING COMMENT 'SAE automation level for the ADAS (Advanced Driver Assistance Systems) features included in this homologation variant, ranging from Level 0 (no automation) to Level 5 (full automation).. Valid values are `Level 0|Level 1|Level 2|Level 3|Level 4|Level 5`',
    `approval_authority` STRING COMMENT 'Name of the government agency, regulatory body, or authorized technical service that issued the homologation approval. Examples include NHTSA, EPA, CARB, TÜV, or national transport ministries.',
    `approval_date` DATE COMMENT 'Date on which the regulatory authority officially granted homologation approval for this variant. Format: yyyy-MM-dd.',
    `approval_number` STRING COMMENT 'Official approval or certification number issued by the regulatory authority upon successful homologation. This number is typically required for vehicle registration and sales in the target market.',
    `bom_impact_flag` BOOLEAN COMMENT 'Indicates whether this homologation variant requires changes to the base SKU Bill of Materials. True if BOM modifications are needed, False if only calibration or documentation changes are required.',
    `cafe_compliance_flag` BOOLEAN COMMENT 'Indicates whether this homologation variant is certified for CAFE (Corporate Average Fuel Economy) compliance in the United States market. Applicable to US market variants only.',
    `compliance_notes` STRING COMMENT 'Additional notes, comments, or special instructions related to regulatory compliance, testing requirements, or market-specific considerations for this homologation variant.',
    `cost_delta_amount` DECIMAL(18,2) COMMENT 'Incremental cost associated with implementing this homologation variant compared to the base SKU, including parts, labor, testing, and certification fees. Expressed in the currency specified in cost_delta_currency.',
    `cost_delta_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the cost_delta_amount field.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this homologation variant record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `effective_start_date` DATE COMMENT 'Date from which this homologation variant becomes valid and vehicles can be legally sold or registered in the target market. Format: yyyy-MM-dd.',
    `emissions_standard_target` STRING COMMENT 'Specific emissions standard or tier that this homologation variant is designed to meet, such as Euro 6d, EPA Tier 3, CARB LEV III, or China 6b.',
    `expiry_date` DATE COMMENT 'Date on which this homologation approval expires or becomes invalid, requiring renewal or re-certification. Nullable for approvals without expiration. Format: yyyy-MM-dd.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this homologation variant record was last updated or modified. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `lead_time_days` STRING COMMENT 'Typical lead time in days required to obtain homologation approval for this variant from the date of submission to the regulatory authority.',
    `model_year` STRING COMMENT 'Model year designation for which this homologation variant is applicable. Aligns with the automotive industry model year convention.',
    `modification_description` STRING COMMENT 'Detailed description of the technical modifications, component changes, or configuration adjustments required to meet the target market regulatory requirements. May reference specific parts, calibrations, or design changes.',
    `modification_type` STRING COMMENT 'High-level classification of the type of modification required for homologation compliance, such as hardware changes, software updates, calibration adjustments, documentation updates, labeling changes, or additional testing.. Valid values are `Hardware|Software|Calibration|Documentation|Labeling|Testing`',
    `ncap_rating` STRING COMMENT 'Safety rating achieved by this homologation variant under the applicable NCAP (New Car Assessment Programme) testing protocol, such as Euro NCAP, US NCAP, or ANCAP. Typically expressed as a star rating or score.',
    `ota_capable_flag` BOOLEAN COMMENT 'Indicates whether this homologation variant includes OTA (Over-the-Air) update capability for software and firmware updates. Relevant for regulatory compliance with evolving software update requirements.',
    `powertrain_type` STRING COMMENT 'Type of powertrain for which this homologation variant is certified. ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle).. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `regulatory_category` STRING COMMENT 'Classification of the primary regulatory domain this variant addresses, such as safety standards, emissions controls, environmental compliance, or fuel economy requirements. [ENUM-REF-CANDIDATE: Safety|Emissions|Environmental|Fuel Economy|Crash Test|Lighting|Braking|Occupant Protection — 8 candidates stripped; promote to reference product]',
    `regulatory_standard` STRING COMMENT 'Primary regulatory standard or framework that this homologation variant must comply with. Examples include UNECE (United Nations Economic Commission for Europe), FMVSS (Federal Motor Vehicle Safety Standards), ADR (Australian Design Rules), CARB (California Air Resources Board). [ENUM-REF-CANDIDATE: UNECE|FMVSS|ADR|CARB|EPA|Euro NCAP|IATF 16949|ISO 14001 — 8 candidates stripped; promote to reference product]',
    `renewal_required_flag` BOOLEAN COMMENT 'Indicates whether this homologation approval requires periodic renewal or re-certification. True if renewal is mandated by the regulatory authority, False if approval is perpetual or tied to model year.',
    `responsible_engineer` STRING COMMENT 'Name of the engineer or technical specialist responsible for managing the homologation process and regulatory compliance for this variant.',
    `submission_date` DATE COMMENT 'Date on which the homologation application and supporting documentation were submitted to the regulatory authority for review. Format: yyyy-MM-dd.',
    `target_market_code` STRING COMMENT 'ISO 3166-1 alpha-2 or alpha-3 country code representing the target market or jurisdiction for which this homologation variant is certified.. Valid values are `^[A-Z]{2,3}$`',
    `target_region` STRING COMMENT 'Broader geographic region classification for the target market, used for regional compliance grouping and reporting.. Valid values are `North America|Europe|Asia Pacific|Latin America|Middle East|Africa`',
    `test_report_reference` STRING COMMENT 'Reference number or identifier for the official test report(s) submitted as part of the homologation application. Links to laboratory test results, crash test data, emissions testing, or other certification evidence.',
    `testing_laboratory` STRING COMMENT 'Name of the accredited testing laboratory or technical service that conducted the homologation testing and issued the test reports.',
    `variant_code` STRING COMMENT 'Unique alphanumeric code identifying this specific homologation variant within the product catalog. Used for internal tracking and cross-referencing with regulatory submissions.. Valid values are `^[A-Z0-9]{4,20}$`',
    `variant_name` STRING COMMENT 'Human-readable name or designation for this homologation variant, typically including market and regulatory standard identifiers.',
    `variant_status` STRING COMMENT 'Current lifecycle status of the homologation variant in the approval and production process. Tracks progression from initial submission through approval, active use, and eventual expiration or withdrawal. [ENUM-REF-CANDIDATE: Draft|Submitted|Under Review|Approved|Active|Suspended|Expired|Withdrawn|Rejected — 9 candidates stripped; promote to reference product]',
    `wltp_certified_flag` BOOLEAN COMMENT 'Indicates whether this homologation variant has been tested and certified under the WLTP (Worldwide Harmonised Light Vehicles Test Procedure) standard for fuel consumption and emissions.',
    CONSTRAINT pk_homologation_variant PRIMARY KEY(`homologation_variant_id`)
) COMMENT 'Defines market-specific homologation variants of a base SKU required to meet local regulatory standards (UNECE, FMVSS, ADR, etc.). Captures homologation variant code, base SKU reference, target market/country, regulatory standard (UNECE/FMVSS/ADR/CARB), required modification description, homologation approval number, approval authority, approval date, expiry date, and variant status. Bridges the commercial product catalog to the compliance domains regulatory approval records.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`esg_report` (
    `esg_report_id` BIGINT COMMENT '',
    `jurisdiction_id` BIGINT COMMENT '',
    `regulatory_body_id` BIGINT COMMENT '',
    `assurance_provider` STRING COMMENT 'External assurance provider.',
    `created_timestamp` TIMESTAMP COMMENT '',
    `framework` STRING COMMENT '',
    `framework_standard` STRING COMMENT 'Reporting framework.',
    `published_date` DATE COMMENT '',
    `report_code` STRING COMMENT '',
    `report_name` STRING COMMENT 'Report name.',
    `report_status` STRING COMMENT '',
    `report_type` STRING COMMENT 'CSRD, EU Taxonomy, GRI, etc.',
    `reporting_framework` STRING COMMENT '',
    `reporting_period_end` DATE COMMENT '',
    `reporting_period_start` DATE COMMENT '',
    `submission_date` DATE COMMENT 'Submission date.',
    `total_energy_kwh` DECIMAL(18,2) COMMENT '',
    `total_scope1_co2_kg` DECIMAL(18,2) COMMENT 'Aggregate Scope 1 CO2.',
    `total_scope1_co2_tonnes` DECIMAL(18,2) COMMENT '',
    `total_scope2_co2_kg` DECIMAL(18,2) COMMENT 'Aggregate Scope 2 CO2.',
    `total_scope2_co2_tonnes` DECIMAL(18,2) COMMENT '',
    `total_scope3_co2_kg` DECIMAL(18,2) COMMENT 'Aggregate Scope 3 CO2.',
    `total_scope3_co2_tonnes` DECIMAL(18,2) COMMENT '',
    `total_water_liters` DECIMAL(18,2) COMMENT '',
    CONSTRAINT pk_esg_report PRIMARY KEY(`esg_report_id`)
) COMMENT 'ESG reporting structures aligned to CSRD and EU Taxonomy disclosure requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`social_compliance_audit` (
    `social_compliance_audit_id` BIGINT COMMENT '',
    `esg_report_id` BIGINT COMMENT '',
    `jurisdiction_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `audit_code` STRING COMMENT '',
    `audit_date` DATE COMMENT '',
    `audit_result` STRING COMMENT '',
    `audit_scope` STRING COMMENT 'Scope of the audit.',
    `audit_standard` STRING COMMENT '',
    `audit_type` STRING COMMENT '',
    `audited_entity_name` STRING COMMENT 'Audited supplier or site.',
    `auditor_name` STRING COMMENT '',
    `auditor_organization` STRING COMMENT 'Auditing body.',
    `corrective_action_due_date` DATE COMMENT 'Corrective action deadline.',
    `corrective_action_required_flag` BOOLEAN COMMENT '',
    `corrective_actions_required` BOOLEAN COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `finding_count` STRING COMMENT '',
    `findings_count` STRING COMMENT '',
    `nonconformance_count` STRING COMMENT 'Number of nonconformances.',
    CONSTRAINT pk_social_compliance_audit PRIMARY KEY(`social_compliance_audit_id`)
) COMMENT 'Social compliance audits covering labor, human rights, and supply-chain due diligence.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`compliance`.`sustainability_metric` (
    `sustainability_metric_id` BIGINT COMMENT '',
    `esg_report_id` BIGINT COMMENT '',
    `jurisdiction_id` BIGINT COMMENT '',
    `baseline_value` DECIMAL(18,2) COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `data_source` STRING COMMENT 'Source system.',
    `measurement_period` STRING COMMENT 'Reporting period.',
    `metric_category` STRING COMMENT '',
    `metric_code` STRING COMMENT '',
    `metric_name` STRING COMMENT '',
    `metric_unit` STRING COMMENT '',
    `metric_value` DECIMAL(18,2) COMMENT '',
    `period_date` DATE COMMENT 'Measurement date.',
    `reporting_period` STRING COMMENT '',
    `reporting_period_end` DATE COMMENT '',
    `reporting_period_start` DATE COMMENT '',
    `target_value` DECIMAL(18,2) COMMENT 'Target value.',
    `unit_of_measure` STRING COMMENT '',
    CONSTRAINT pk_sustainability_metric PRIMARY KEY(`sustainability_metric_id`)
) COMMENT 'Sustainability metrics tracked for ESG reporting and EU Taxonomy alignment.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` ADD CONSTRAINT `fk_compliance_compliance_emissions_certification_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` ADD CONSTRAINT `fk_compliance_compliance_emissions_certification_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` ADD CONSTRAINT `fk_compliance_compliance_emissions_certification_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ADD CONSTRAINT `fk_compliance_cafe_compliance_record_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ADD CONSTRAINT `fk_compliance_regulatory_submission_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_campaign` ADD CONSTRAINT `fk_compliance_recall_campaign_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_campaign` ADD CONSTRAINT `fk_compliance_recall_campaign_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ADD CONSTRAINT `fk_compliance_test_event_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ADD CONSTRAINT `fk_compliance_test_event_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ADD CONSTRAINT `fk_compliance_test_event_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ADD CONSTRAINT `fk_compliance_compliance_test_result_test_event_id` FOREIGN KEY (`test_event_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`test_event`(`test_event_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ADD CONSTRAINT `fk_compliance_regulatory_requirement_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ADD CONSTRAINT `fk_compliance_regulatory_requirement_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ADD CONSTRAINT `fk_compliance_jurisdiction_parent_jurisdiction_id` FOREIGN KEY (`parent_jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ADD CONSTRAINT `fk_compliance_jurisdiction_regulatory_body_id` FOREIGN KEY (`regulatory_body_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_body`(`regulatory_body_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ADD CONSTRAINT `fk_compliance_ncap_submission_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ADD CONSTRAINT `fk_compliance_ota_compliance_approval_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ADD CONSTRAINT `fk_compliance_fmvss_certification_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ADD CONSTRAINT `fk_compliance_fmvss_certification_compliance_emissions_certification_id` FOREIGN KEY (`compliance_emissions_certification_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification`(`compliance_emissions_certification_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ADD CONSTRAINT `fk_compliance_fmvss_certification_test_facility_id` FOREIGN KEY (`test_facility_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`test_facility`(`test_facility_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ADD CONSTRAINT `fk_compliance_compliance_document_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_audit_finding` ADD CONSTRAINT `fk_compliance_compliance_audit_finding_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ADD CONSTRAINT `fk_compliance_trade_compliance_record_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ADD CONSTRAINT `fk_compliance_environmental_permit_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ADD CONSTRAINT `fk_compliance_emissions_monitoring_reading_emissions_monitoring_point_id` FOREIGN KEY (`emissions_monitoring_point_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point`(`emissions_monitoring_point_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ADD CONSTRAINT `fk_compliance_emissions_monitoring_reading_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`environmental_permit`(`environmental_permit_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ADD CONSTRAINT `fk_compliance_recall_defect_report_recall_campaign_id` FOREIGN KEY (`recall_campaign_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`recall_campaign`(`recall_campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ADD CONSTRAINT `fk_compliance_waiver_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ADD CONSTRAINT `fk_compliance_waiver_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ADD CONSTRAINT `fk_compliance_waiver_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ADD CONSTRAINT `fk_compliance_waiver_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ADD CONSTRAINT `fk_compliance_zev_credit_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ADD CONSTRAINT `fk_compliance_homologation_market_approval_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ADD CONSTRAINT `fk_compliance_homologation_market_approval_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ADD CONSTRAINT `fk_compliance_regulatory_change_notice_regulatory_body_id` FOREIGN KEY (`regulatory_body_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_body`(`regulatory_body_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ADD CONSTRAINT `fk_compliance_regulatory_change_notice_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ADD CONSTRAINT `fk_compliance_emissions_monitoring_point_parent_emissions_monitoring_point_id` FOREIGN KEY (`parent_emissions_monitoring_point_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point`(`emissions_monitoring_point_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ADD CONSTRAINT `fk_compliance_test_facility_parent_test_facility_id` FOREIGN KEY (`parent_test_facility_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`test_facility`(`test_facility_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ADD CONSTRAINT `fk_compliance_regulatory_body_parent_regulatory_body_id` FOREIGN KEY (`parent_regulatory_body_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_body`(`regulatory_body_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`esg_report` ADD CONSTRAINT `fk_compliance_esg_report_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`esg_report` ADD CONSTRAINT `fk_compliance_esg_report_regulatory_body_id` FOREIGN KEY (`regulatory_body_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_body`(`regulatory_body_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`social_compliance_audit` ADD CONSTRAINT `fk_compliance_social_compliance_audit_esg_report_id` FOREIGN KEY (`esg_report_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`esg_report`(`esg_report_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`social_compliance_audit` ADD CONSTRAINT `fk_compliance_social_compliance_audit_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`sustainability_metric` ADD CONSTRAINT `fk_compliance_sustainability_metric_esg_report_id` FOREIGN KEY (`esg_report_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`esg_report`(`esg_report_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`sustainability_metric` ADD CONSTRAINT `fk_compliance_sustainability_metric_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`compliance` SET TAGS ('dbx_pii_division' = 'corporate');
ALTER SCHEMA `vibe_automotive_v1`.`compliance` SET TAGS ('dbx_pii_domain' = 'compliance');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Identifier (HRI)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `model_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `approval_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Approval Name (HAN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `approval_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Approval Number (HAN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `approval_status_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status Date (ASD)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `approval_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Approval Type (HAT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `approval_type` SET TAGS ('dbx_pii_value_regex' = 'type_approval|type_certification|type_test|type_homologation');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `body_style` SET TAGS ('dbx_pii_business_glossary_term' = 'Body Style (BS)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `body_style` SET TAGS ('dbx_pii_value_regex' = 'sedan|hatchback|coupe|convertible|wagon|utility');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `certification_document_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Document URL (CD_URL)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `co2_emissions_g_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'CO2 Emissions (grams per kilometer) (CO2_g/km)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `compliance_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Notes (CN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `document_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Version (DOC_VER)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `drivetrain` SET TAGS ('dbx_pii_business_glossary_term' = 'Drivetrain Configuration (DC)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `drivetrain` SET TAGS ('dbx_pii_value_regex' = 'fwd|rwd|awd|4wd');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date (ED)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `engine_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Engine Code (EC)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date (EXP_D)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `fuel_consumption_l_per_100km` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Consumption (liters per 100 km) (FC_L/100km)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Type (FT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_value_regex' = 'gasoline|diesel|electric|hybrid|plug_in_hybrid');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `homologation_record_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Status (HRS)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `homologation_record_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected|revoked|expired');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `market_jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Jurisdiction Code (MJC)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `market_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Region (MR)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `market_region` SET TAGS ('dbx_pii_value_regex' = 'NA|EU|APAC|LATAM|MEA');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body (RB)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_value_regex' = 'NHTSA|EPA|EURO_NCAP|UNECE|CARB|DOT');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Reference Number (RRN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `test_cycle` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Cycle Standard (TCS)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `test_cycle` SET TAGS ('dbx_pii_value_regex' = 'WLTP|NEDC|EPA|ECE|Euro_5|Euro_6');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `test_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Date (TD)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `test_lab` SET TAGS ('dbx_pii_business_glossary_term' = 'Testing Laboratory Name (TLN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `transmission_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Transmission Type (TT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `transmission_type` SET TAGS ('dbx_pii_value_regex' = 'automatic|manual|cvt|dual_clutch');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User Identifier (UBU)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `vehicle_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model (VM)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Type (VT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_pii_value_regex' = 'passenger|commercial|truck|suv|motorcycle|utility');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User Identifier (CBU)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` ALTER COLUMN `compliance_emissions_certification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for compliance_emissions_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` ALTER COLUMN `powertrain_variant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Variant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `cafe_compliance_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'CAFE Compliance Record ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `model_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `actual_cafe_mpg` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual CAFE (MPG)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `compliance_gap_mpg` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Gap (MPG)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `credit_balance` SET TAGS ('dbx_pii_business_glossary_term' = 'CAFE Credit Balance (USD)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `credit_expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `credit_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `credit_type` SET TAGS ('dbx_pii_value_regex' = 'generation|banked|used|expired');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `fine_liability_usd` SET TAGS ('dbx_pii_business_glossary_term' = 'Fine Liability (USD)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `fleet_mix_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet Mix Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `fleet_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `fleet_type` SET TAGS ('dbx_pii_value_regex' = 'domestic_car|import_car|light_truck|medium_truck|heavy_truck');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `is_active` SET TAGS ('dbx_pii_business_glossary_term' = 'Active Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `record_label` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Label (CAFE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `record_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Number (CAFE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_value_regex' = 'NHTSA|EPA|CARB|EU|UN');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `reporting_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `reporting_status` SET TAGS ('dbx_pii_value_regex' = 'pending|submitted|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `reporting_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `required_cafe_mpg` SET TAGS ('dbx_pii_business_glossary_term' = 'Required CAFE (MPG)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `submission_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `total_vehicles` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Vehicles');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `regulatory_submission_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Submission ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `aftersales_model_year_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Officer ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `regulatory_compliance_officer_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Officer ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `regulatory_compliance_officer_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `regulatory_compliance_officer_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `cafe_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Corporate Average Fuel Economy (CAFE) Value');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `document_path` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Document Path');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `document_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Version');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `emission_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Standard');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `fee_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Fee Currency');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `fee_currency` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `fee_gross_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Fee Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `fee_net_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Fee Net Amount');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `fee_tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Fee Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_value_regex' = 'gasoline|diesel|hybrid|electric|hydrogen');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Critical Submission');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `is_urgent` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Urgent Submission');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction (ISO 3166‑3)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `regulatory_body_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `regulatory_body_code` SET TAGS ('dbx_pii_value_regex' = 'NHTSA|EPA|CARB|UNECE|Euro_NCAP|DOT');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `regulatory_body_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `regulatory_submission_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `regulatory_submission_status` SET TAGS ('dbx_pii_value_regex' = 'submitted|acknowledged|approved|rejected|under_review');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `related_part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Part Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `reviewer_comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Reviewer Comments');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `status_change_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Status Change Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `submission_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Category');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `submission_category` SET TAGS ('dbx_pii_value_regex' = 'domestic|export|both');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `submission_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `submission_reference_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Reference Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `submission_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `submission_type` SET TAGS ('dbx_pii_value_regex' = 'type_approval|certificate_of_conformity|recall_notice|cafe_report|safety_compliance_report');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `vehicle_model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Year');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_pii_value_regex' = 'passenger|truck|suv|commercial|motorcycle');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_campaign` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_campaign` SET TAGS ('dbx_pii_subdomain' = 'safety_enforcement');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_campaign` ALTER COLUMN `recall_campaign_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for compliance_recall_campaign');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_campaign` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_campaign` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_event_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Test Event ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Report Document ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `homologation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `obligation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Obligation Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Operator ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `ambient_humidity_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Ambient Humidity (%)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `ambient_pressure_kpa` SET TAGS ('dbx_pii_business_glossary_term' = 'Ambient Pressure (kPa)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `ambient_temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Ambient Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `certification_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Body');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `certification_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `certification_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `certification_status` SET TAGS ('dbx_pii_value_regex' = 'pending|issued|rejected|withdrawn');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `created_by_user` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `data_source_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `is_retest` SET TAGS ('dbx_pii_business_glossary_term' = 'Retest Indicator');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `measured_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured Unit');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `measured_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured Test Value');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Event Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `pass_fail_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Pass/Fail Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|EV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `regulatory_jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Jurisdiction');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `result` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Result');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `result` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|conditional');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `retest_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Retest Reason');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Batch Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Test Category');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_category` SET TAGS ('dbx_pii_value_regex' = 'emissions|crash|noise|fuel_economy|range|charging');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_condition` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Condition Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_equipment_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Equipment Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_event_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Event Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_event_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Event Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_event_status` SET TAGS ('dbx_pii_value_regex' = 'planned|in_progress|completed|passed|failed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_facility` SET TAGS ('dbx_pii_business_glossary_term' = 'Testing Facility Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Testing Facility Location');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_operator_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Operator Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_operator_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_operator_name` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_operator_name` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_program` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Program Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_sequence_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Test Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `test_type` SET TAGS ('dbx_pii_value_regex' = 'WLTP|FTP-75|NEDC|RDE|NCAP|FMVSS');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `vehicle_model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Year');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ALTER COLUMN `vehicle_variant` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Variant');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `compliance_test_result_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Test Result ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `primary_equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `test_event_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Test Event ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `calibration_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `calibration_status` SET TAGS ('dbx_pii_value_regex' = 'calibrated|uncalibrated|pending');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Result Comments');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `compliance_regulation_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Regulation Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `data_source_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Source System');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `data_source_system` SET TAGS ('dbx_pii_value_regex' = 'SAP_QM|MES|PLM|Custom');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `is_outlier` SET TAGS ('dbx_pii_business_glossary_term' = 'Outlier Indicator');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `lab_location_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Laboratory Location Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `limit_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Limit Unit');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `limit_unit` SET TAGS ('dbx_pii_value_regex' = 'g/km|mg/km|dB|mm|kg|%');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `measured_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured Value');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `measurement_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Method');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `measurement_method` SET TAGS ('dbx_pii_value_regex' = 'lab|in_vehicle|simulation');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `measurement_pressure_kpa` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Pressure (kPa)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `measurement_temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `measurement_uncertainty` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Uncertainty');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `parameter_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Parameter Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `parameter_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Parameter Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `pass_fail_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Pass/Fail Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `pass_fail_status` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|conditional');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `regulatory_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Limit');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `test_batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Batch Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `test_phase` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Phase');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `test_phase` SET TAGS ('dbx_pii_value_regex' = 'cold_start|hot_start|wl_tp_low|wl_tp_medium|wl_tp_high|wl_tp_extra_high');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `test_result_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Result Record Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `test_result_status` SET TAGS ('dbx_pii_value_regex' = 'recorded|reviewed|approved');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `test_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `uncertainty_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Uncertainty Unit');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `uncertainty_unit` SET TAGS ('dbx_pii_value_regex' = 'g/km|mg/km|dB|mm|kg|%');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'g/km|mg/km|dB|mm|kg|%');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` SET TAGS ('dbx_pii_subdomain' = 'governance_framework');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `compliance_deadline` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Deadline');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `compliance_requirement_summary` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Requirement Summary');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `is_global` SET TAGS ('dbx_pii_business_glossary_term' = 'Global Applicability Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_pii_business_glossary_term' = 'Mandatory Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `issuing_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Issuing Body');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `market` SET TAGS ('dbx_pii_business_glossary_term' = 'Market');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `market` SET TAGS ('dbx_pii_value_regex' = 'US|EU|CA|JP|CN|KR');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `regulatory_requirement_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|EV|HEV|PHEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `regulation_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `regulation_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `regulation_type` SET TAGS ('dbx_pii_value_regex' = 'safety|emissions|fuel_economy|equipment|environment|homologation');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `regulatory_requirement_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `regulatory_requirement_status` SET TAGS ('dbx_pii_value_regex' = 'active|superseded|proposed|withdrawn');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `scope_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Scope Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `source_document_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Document URL');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `vehicle_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Category');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_requirement` ALTER COLUMN `version` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Version');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` SET TAGS ('dbx_pii_subdomain' = 'governance_framework');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `parent_jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Jurisdiction Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `regulatory_body_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body Id');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `regulatory_body_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `cafe_target_gpm` SET TAGS ('dbx_pii_business_glossary_term' = 'CAFE Target (g/mi)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `compliance_documentation_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Documentation URL');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `jurisdiction_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `emissions_standard_tier` SET TAGS ('dbx_pii_business_glossary_term' = 'Emissions Standard Tier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `epa_emission_limit_g_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'EPA Emission Limit (g/km)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `homologation_process_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Process Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `is_eu_member` SET TAGS ('dbx_pii_business_glossary_term' = 'EU Membership Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `iso_country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'ISO Country Code (ISO 3166-1 Alpha-3)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `iso_country_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `jurisdiction_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `jurisdiction_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|pending|retired|suspended');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `jurisdiction_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `jurisdiction_type` SET TAGS ('dbx_pii_value_regex' = 'federal|state|national|supranational|regional|local');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `market_entry_requirements` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Entry Requirements');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `jurisdiction_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `ncap_rating_required` SET TAGS ('dbx_pii_business_glossary_term' = 'NCAP Rating Requirement');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `recall_reporting_requirement` SET TAGS ('dbx_pii_business_glossary_term' = 'Recall Reporting Requirement');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `regulatory_body_website` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body Website URL');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `safety_standard_framework` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Standard Framework');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `tax_rate_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Tax Rate (Percent)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `unece_type_approval_code` SET TAGS ('dbx_pii_business_glossary_term' = 'UNECE Type Approval Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`jurisdiction` ALTER COLUMN `wltp_test_cycle` SET TAGS ('dbx_pii_business_glossary_term' = 'WLTP Test Cycle');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` SET TAGS ('dbx_pii_subdomain' = 'governance_framework');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `obligation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Obligation ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Document ID (CERTIFICATION_DOCUMENT_ID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Team ID (RESPONSIBLE_TEAM_ID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program ID (VEHICLE_PROGRAM_ID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `actual_certification_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Certification Date (ACTUAL_CERTIFICATION_DATE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `audit_created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Created Timestamp (AUDIT_CREATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `audit_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Updated Timestamp (AUDIT_UPDATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `certification_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Body (CERTIFICATION_BODY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `compliance_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Score (COMPLIANCE_SCORE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Due Date (CORRECTIVE_ACTION_DUE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `corrective_action_plan` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Plan (CORRECTIVE_ACTION_PLAN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From (EFFECTIVE_FROM)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until (EFFECTIVE_UNTIL)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `emission_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Value (EMISSION_VALUE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `evidence_document_path` SET TAGS ('dbx_pii_business_glossary_term' = 'Evidence Document Path (EVIDENCE_DOCUMENT_PATH)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `fuel_economy_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Economy Value (FUEL_ECONOMY_VALUE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Critical (IS_CRITICAL)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `is_regulatory` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Regulatory (IS_REGULATORY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date (LAST_REVIEW_DATE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MODEL_YEAR)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `next_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Review Date (NEXT_REVIEW_DATE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `non_compliance_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Non‑Compliance Reason (NON_COMPLIANCE_REASON)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `obligation_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Obligation Number (OBLIGATION_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `obligation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Obligation Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `obligation_status` SET TAGS ('dbx_pii_value_regex' = 'pending|in_progress|certified|waived|non_compliant');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Priority (PRIORITY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `regulation_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Code (REGULATION_CODE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `regulation_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Name (REGULATION_NAME)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `regulation_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Type (REGULATION_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `regulation_type` SET TAGS ('dbx_pii_value_regex' = 'emissions|safety|fuel_economy|noise|other');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `responsible_engineering_group` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Engineering Group (RESPONSIBLE_ENGINEERING_GROUP)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Level (RISK_LEVEL)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `target_certification_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Certification Date (TARGET_CERTIFICATION_DATE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `test_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Date (TEST_DATE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `test_facility` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Facility (TEST_FACILITY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `test_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Method (TEST_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `test_result` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Result (TEST_RESULT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `test_result` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|pending');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ALTER COLUMN `waiver_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Waiver Reason (WAIVER_REASON)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `ncap_submission_id` SET TAGS ('dbx_pii_business_glossary_term' = 'NCAP Submission Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `adas_features_evaluated` SET TAGS ('dbx_pii_business_glossary_term' = 'ADAS Features Evaluated');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `adult_occupant_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Adult Occupant Star Rating (AOR)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `child_occupant_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Child Occupant Star Rating (COR)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `market_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Region');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `market_region` SET TAGS ('dbx_pii_value_regex' = 'EU|US|CN|JP|KR|AU');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `ncap_submission_status` SET TAGS ('dbx_pii_business_glossary_term' = 'NCAP Submission Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `ncap_submission_status` SET TAGS ('dbx_pii_value_regex' = 'draft|submitted|approved|rejected|published|archived');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `overall_star_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Overall Star Rating (STAR)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `publication_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Publication Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `rating_agency` SET TAGS ('dbx_pii_business_glossary_term' = 'Rating Agency');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `rating_agency` SET TAGS ('dbx_pii_value_regex' = 'Euro NCAP|NHTSA|ANCAP|JNCAP');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `safety_assist_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Assist Star Rating (SAR)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `submission_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'NCAP Submission Reference');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `test_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `test_programme_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Programme Version');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `vehicle_variant` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Variant');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Version Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ncap_submission` ALTER COLUMN `vulnerable_road_user_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Vulnerable Road User Star Rating (VRU)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `ota_compliance_approval_id` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Compliance Approval ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date (APPROVAL_DATE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `approval_document_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Document URL (APPROVAL_DOCUMENT_URL)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `approval_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Number (APPROVAL_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `approval_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Type (APPROVAL_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `compliance_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Category (COMPLIANCE_CATEGORY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp (CREATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `cybersecurity_assessment_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Cybersecurity Assessment Reference (CYBERSECURITY_ASSESSMENT_REF)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date (EFFECTIVE_FROM)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date (EFFECTIVE_UNTIL)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction (JURISDICTION)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MODEL_YEAR)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `ota_compliance_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `ota_compliance_approval_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|pending|revoked|expired');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body (REGULATORY_BODY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_value_regex' = 'UNECE|EPA|NHTSA|CARB|EU|Other');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `risk_assessment_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Assessment Score (RISK_ASSESSMENT_SCORE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `software_module_identifier` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Module Identifier (SOFTWARE_MODULE_ID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp (UPDATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Type (VEHICLE_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_pii_value_regex' = 'passenger|commercial|electric|hybrid|truck|suv');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`ota_compliance_approval` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number (VERSION_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `fmvss_certification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'FMVSS Certification ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Certifying Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Certifying Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `test_facility_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Facility ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `audit_trail_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Trail ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `certification_basis` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Basis');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `certification_basis` SET TAGS ('dbx_pii_value_regex' = 'self|third_party|manufacturer');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `certification_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `certification_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `certification_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `certification_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|revoked|expired|withdrawn');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `certifying_engineer_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Certifying Engineer Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `certifying_engineer_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `certifying_engineer_name` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `compliance_result` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Result');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `compliance_result` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|conditional');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `document_hash` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Hash');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `emission_class` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Class');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `emission_class` SET TAGS ('dbx_pii_value_regex' = 'Euro6|Euro5|EPA_Tier2|EPA_Tier3|None');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `is_active` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Active');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `market` SET TAGS ('dbx_pii_business_glossary_term' = 'Market');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|EV|HEV|PHEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `recall_implication_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Recall Implication Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_value_regex' = 'NHTSA|EPA|CARB|Euro_NCAP|UNECE');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `safety_feature_codes` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Feature Codes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `standard_number` SET TAGS ('dbx_pii_business_glossary_term' = 'FMVSS Standard Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `standard_title` SET TAGS ('dbx_pii_business_glossary_term' = 'FMVSS Standard Title');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `submission_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Reference');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `test_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `test_evidence_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Evidence Reference');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `vehicle_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_pii_value_regex' = 'passenger|truck|suv|commercial|motorcycle');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Document ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `approval_authorizer` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Authorizer');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `authority_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Authority Region');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `checksum` SET TAGS ('dbx_pii_business_glossary_term' = 'Checksum (SHA256)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `compliance_document_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `compliance_document_status` SET TAGS ('dbx_pii_value_regex' = 'draft|submitted|approved|rejected|revoked|expired');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Confidentiality Level');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_pii_value_regex' = 'public|internal|confidential|restricted');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `compliance_document_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `digital_signature_present` SET TAGS ('dbx_pii_business_glossary_term' = 'Digital Signature Present');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `digital_signature_present` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `document_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `document_type` SET TAGS ('dbx_pii_value_regex' = 'certificate|test_report|audit_report|approval|submission');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `file_format` SET TAGS ('dbx_pii_business_glossary_term' = 'File Format');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `file_format` SET TAGS ('dbx_pii_value_regex' = 'pdf|docx|xml|xlsx');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `file_size_bytes` SET TAGS ('dbx_pii_business_glossary_term' = 'File Size (Bytes)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `issue_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_pii_business_glossary_term' = 'Issuing Authority');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction (ISO 3166-1 Alpha-3)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `language` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Language');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `market` SET TAGS ('dbx_pii_business_glossary_term' = 'Market');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `market` SET TAGS ('dbx_pii_value_regex' = 'US|EU|CN|JP|CA|AU');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `regulation_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `regulation_type` SET TAGS ('dbx_pii_value_regex' = 'emissions|safety|homologation|environment|fuel_economy');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `related_model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Model Year');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `related_vehicle_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Vehicle VIN');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `retention_policy` SET TAGS ('dbx_pii_business_glossary_term' = 'Retention Policy');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `storage_uri` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage URI');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `submission_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `title` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Title');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `version_label` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Version Label');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_document` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_audit_finding` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_audit_finding` SET TAGS ('dbx_pii_subdomain' = 'audit_management');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_audit_finding` ALTER COLUMN `compliance_audit_finding_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for compliance_audit_finding');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_audit_finding` ALTER COLUMN `obligation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Obligation Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_corrective_action` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_corrective_action` SET TAGS ('dbx_pii_subdomain' = 'audit_management');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_corrective_action` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `trade_compliance_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Trade Compliance Record ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `audit_created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `audit_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `compliance_officer` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Officer Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'COMPLIANT|NON_COMPLIANT|PENDING|EXEMPT|REVOKED');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_pii_business_glossary_term' = 'Country of Origin');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `customs_duty_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Customs Duty Rate (PERCENT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `destination_country` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Country');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Export Control Classification (ECCN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_pii_value_regex' = 'EAR|ITAR|NONE');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `free_trade_agreement` SET TAGS ('dbx_pii_business_glossary_term' = 'Free Trade Agreement (FTA) Applicability');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `free_trade_agreement` SET TAGS ('dbx_pii_value_regex' = 'USMCA|EU-Japan_EPA|NAFTA|EU|NONE');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `hs_tariff_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Harmonized System (HS) Tariff Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `hs_tariff_code` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `import_license_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Import License Reference');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Record Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `origin_port` SET TAGS ('dbx_pii_business_glossary_term' = 'Origin Port Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `origin_port` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Number (PN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `product_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Product Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `product_type` SET TAGS ('dbx_pii_value_regex' = 'CKD|SKD|FINISHED_VEHICLE|PART');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `record_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Trade Compliance Record Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `trade_regulation_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Trade Regulation Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `trade_regulation_code` SET TAGS ('dbx_pii_value_regex' = 'EPA|CARB|NHTSA|EURO_NCAP|UNECE|IATF');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `vehicle_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ALTER COLUMN `vehicle_model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` SET TAGS ('dbx_pii_subdomain' = 'environmental_monitoring');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Environmental Permit ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Facility ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `primary_environmental_plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Facility ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `compliance_monitoring_frequency` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Monitoring Frequency (CMF)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `compliance_monitoring_frequency` SET TAGS ('dbx_pii_value_regex' = 'monthly|quarterly|annually|biannually|on_demand');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status (CS)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|conditionally_compliant|under_review');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp (CT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `emission_report_submission_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Report Submission Date (ERSD)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `environmental_permit_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Permit Status (PS)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `environmental_permit_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|suspended|expired|revoked');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Date (ED)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `is_exempt` SET TAGS ('dbx_pii_business_glossary_term' = 'Exempt Flag (EF)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `issue_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Issue Date (ID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_pii_business_glossary_term' = 'Issuing Authority (IA)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_pii_value_regex' = 'EPA|State Environmental Agency|Local Authority|CARB|EU Commission');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Inspection Date (LID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `monitoring_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Monitoring Method (MM)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `monitoring_method` SET TAGS ('dbx_pii_value_regex' = 'continuous|periodic|spot|modeling');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `next_inspection_due` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Inspection Due Date (NID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes (N)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `permit_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Permit Category (PCAT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `permit_category` SET TAGS ('dbx_pii_value_regex' = 'federal|state|local');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `permit_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Permit Number (PN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `permit_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Permit Type (PT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `permit_type` SET TAGS ('dbx_pii_value_regex' = 'air_emissions|wastewater|hazardous_waste|stormwater|solid_waste');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `pollutant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Pollutant Code (PC)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `pollutant_code` SET TAGS ('dbx_pii_value_regex' = 'CO2|NOx|SO2|PM2.5|VOC|Lead');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `pollutant_limit_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Pollutant Limit Unit (PLU)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `pollutant_limit_unit` SET TAGS ('dbx_pii_value_regex' = 'kg|ton|lb|g');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `pollutant_limit_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Pollutant Limit Value (PLV)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body (RB)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `renewal_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Renewal Status (RS)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `renewal_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected|not_required');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp (UT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number (VN)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` SET TAGS ('dbx_pii_subdomain' = 'environmental_monitoring');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `emissions_monitoring_reading_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Emissions Monitoring Reading ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `emissions_monitoring_point_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Monitoring Point ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Environmental Permit Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `calibration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|pending|exempt');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `data_quality_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Quality Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `exceedance_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Exceedance Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `measured_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured Value');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `measurement_technique` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Technique');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `measurement_technique` SET TAGS ('dbx_pii_value_regex' = 'stack|ambient|process');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `monitoring_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Monitoring Method');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `monitoring_method` SET TAGS ('dbx_pii_value_regex' = 'CEMS|manual_sampling|continuous_sampler');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `permitted_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Permitted Limit');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `pollutant_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Pollutant Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `pollutant_type` SET TAGS ('dbx_pii_value_regex' = 'NOx|SOx|VOC|CO2|PM');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `reading_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Reading Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `record_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `record_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|archived');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_value_regex' = 'EPA|CARB|NHTSA|EU|UNECE|Other');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `sample_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Sample Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `sensor_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Sensor ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'ppm|ppb|mg/m3|µg/m3|g/kWh');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_reading` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` SET TAGS ('dbx_pii_subdomain' = 'safety_enforcement');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `recall_defect_report_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Recall Defect Report ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `model_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `recall_campaign_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Recall Campaign Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `sku_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `affected_nameplates` SET TAGS ('dbx_pii_business_glossary_term' = 'Affected Nameplates');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `defect_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Category');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `defect_category` SET TAGS ('dbx_pii_value_regex' = 'safety|emissions|structural|other');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `defect_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `fatality_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Fatality Count');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `incident_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Incident Count');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `injury_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Injury Count');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `investigation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Investigation Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `investigation_status` SET TAGS ('dbx_pii_value_regex' = 'open|closed|under_review|pending');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `nhtsa_investigation_number` SET TAGS ('dbx_pii_business_glossary_term' = 'NHTSA Investigation Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `recall_defect_report_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Report Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `recall_defect_report_status` SET TAGS ('dbx_pii_value_regex' = 'draft|submitted|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `recall_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Recall Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `regulation_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `regulatory_agency` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Agency');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `regulatory_agency` SET TAGS ('dbx_pii_value_regex' = 'NHTSA|EPA|CARB|EU_NCAP|UNECE');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `remedy_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Remedy Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `report_creation_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Report Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `report_last_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Report Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `report_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Report Number (Report ID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `report_submission_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Report Submission Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `report_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Report Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `report_type` SET TAGS ('dbx_pii_value_regex' = 'ewr_quarterly|part_579|consumer_complaint|field_report');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `reporting_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Period');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `vehicle_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `vin_range_end` SET TAGS ('dbx_pii_business_glossary_term' = 'VIN Range End');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `vin_range_end` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `vin_range_end` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `vin_range_start` SET TAGS ('dbx_pii_business_glossary_term' = 'VIN Range Start');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `vin_range_start` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ALTER COLUMN `vin_range_start` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` SET TAGS ('dbx_pii_subdomain' = 'governance_framework');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `waiver_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Waiver Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `obligation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Obligation Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Waiver Amount (WAIVER_AMT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `applicable_market` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Market (MARKET)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `applicable_model_year_end` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Model Year End (MODEL_YEAR_END)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `applicable_model_year_start` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Model Year Start (MODEL_YEAR_START)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `applicable_vehicle_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Vehicle Model (VEH_MODEL)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `conditions_attached` SET TAGS ('dbx_pii_business_glossary_term' = 'Waiver Conditions (WAIVER_COND)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (CURR_CODE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `waiver_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Waiver Description (WAIVER_DESC)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date (EFF_FROM_DT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date (EFF_UNTIL_DT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `granted_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Granted Date (GRANTED_DT)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `granting_authority` SET TAGS ('dbx_pii_business_glossary_term' = 'Granting Authority (GRANTING_AUTH)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `justification` SET TAGS ('dbx_pii_business_glossary_term' = 'Waiver Justification (WAIVER_JUST)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `monitoring_frequency` SET TAGS ('dbx_pii_business_glossary_term' = 'Monitoring Frequency (MON_FREQ)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `monitoring_frequency` SET TAGS ('dbx_pii_value_regex' = 'monthly|quarterly|annually|on_demand');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `monitoring_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Monitoring Method (MON_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `monitoring_requirements` SET TAGS ('dbx_pii_business_glossary_term' = 'Monitoring Requirements (MON_REQ)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `reference_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Waiver Reference Number (WAIVER_REF_NO)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `regulation_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Code (REG_CODE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body (REG_BODY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By (UPDATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number (VERSION_NO)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `waiver_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Waiver Number (WAIVER_NO)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `waiver_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Waiver Status (WAIVER_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `waiver_status` SET TAGS ('dbx_pii_value_regex' = 'pending|active|suspended|revoked|expired');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `waiver_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Waiver Type (WAIVER_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `waiver_type` SET TAGS ('dbx_pii_value_regex' = 'cafe_exemption|carb_zev|fmvss_temp|other');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By (CREATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`waiver` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` SET TAGS ('dbx_pii_subdomain' = 'governance_framework');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `zev_credit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Zero Emission Vehicle Credit ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Counterparty ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `compliance_program` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Program');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `compliance_program` SET TAGS ('dbx_pii_value_regex' = 'ZEV|GHG');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `counterparty_role` SET TAGS ('dbx_pii_business_glossary_term' = 'Counterparty Role');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `counterparty_role` SET TAGS ('dbx_pii_value_regex' = 'buyer|seller|regulator|none');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `credit_basis` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Basis');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `credit_basis` SET TAGS ('dbx_pii_value_regex' = 'vehicle_sales|powertrain_type|fleet_volume');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `credit_price_usd` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Price (USD)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `credit_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Quantity');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `credit_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `credit_status` SET TAGS ('dbx_pii_value_regex' = 'earned|banked|transferred|retired|pending|cancelled');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `credit_transaction_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Transaction Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `credit_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Type (ZEV, TZEV, AT PZEV, GHG)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `credit_type` SET TAGS ('dbx_pii_value_regex' = 'ZEV|TZEV|AT_PZEV|GHG');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `credit_vintage_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Vintage Year');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'BEV|PHEV|HEV|ICE');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `region` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_value_regex' = 'CARB|EPA|NHTSA|EU|UN|OTHER');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `retirement_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Retirement Reason');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `source_record_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Record ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `transaction_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `transaction_reference_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Reference Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `transaction_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `transaction_type` SET TAGS ('dbx_pii_value_regex' = 'earn|transfer|retire');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `homologation_market_approval_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Market Approval ID');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `additional_requirements` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Requirements');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `approval_authority` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Authority');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `approval_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `approval_status_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status Change Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `approval_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `approval_type` SET TAGS ('dbx_pii_value_regex' = 'initial|supplemental|renewal');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `body_style` SET TAGS ('dbx_pii_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `body_style` SET TAGS ('dbx_pii_value_regex' = 'sedan|SUV|truck|van|coupe|convertible');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `compliance_document_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Document URL');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `conditions_of_approval` SET TAGS ('dbx_pii_business_glossary_term' = 'Conditions of Approval');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `derogations` SET TAGS ('dbx_pii_business_glossary_term' = 'Derogations');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `emission_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Standard');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_value_regex' = 'gasoline|diesel|electric|hybrid|plug_in_hybrid');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `homologation_market_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `homologation_market_approval_status` SET TAGS ('dbx_pii_value_regex' = 'approved|pending|rejected|withdrawn|suspended');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `market_jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Jurisdiction (ISO 3166-1 Alpha-3 Country Code)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `market_jurisdiction` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `market_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Region');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type (ICE/EV/HEV/PHEV)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|EV|HEV|PHEV');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `test_cycle` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Cycle');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `test_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `test_lab` SET TAGS ('dbx_pii_business_glossary_term' = 'Testing Laboratory');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `vehicle_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_market_approval` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` SET TAGS ('dbx_pii_subdomain' = 'governance_framework');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `regulatory_change_notice_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Change Notice Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `regulatory_body_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `regulatory_compliance_owner_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `regulatory_compliance_owner_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `regulatory_compliance_owner_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `affected_vehicle_programs` SET TAGS ('dbx_pii_business_glossary_term' = 'Affected Vehicle Programs');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `comment_period_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Comment Period End Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `comment_period_extended` SET TAGS ('dbx_pii_business_glossary_term' = 'Comment Period Extended Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `estimated_impact_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Impact Cost');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `extended_comment_deadline` SET TAGS ('dbx_pii_business_glossary_term' = 'Extended Comment Deadline');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `impact_assessment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Impact Assessment Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `impact_assessment_status` SET TAGS ('dbx_pii_value_regex' = 'not_started|in_progress|completed');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `impact_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Impact Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction (ISO 3166‑3)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'General Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `notice_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Notice Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `notice_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Notice Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `notice_type` SET TAGS ('dbx_pii_value_regex' = 'NPRM|Final Rule|Guidance Document|Technical Circular');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `publication_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Publication Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `publishing_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Publishing Body');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `publishing_body` SET TAGS ('dbx_pii_value_regex' = 'EPA|NHTSA|EU|CARB|IATF|SAE');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `regulation_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulation Reference Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `regulatory_change_notice_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Notice Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `regulatory_change_notice_status` SET TAGS ('dbx_pii_value_regex' = 'draft|published|under_review|closed|expired');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `related_documents` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Documents');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `source_system_record_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` SET TAGS ('dbx_pii_subdomain' = 'environmental_monitoring');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `emissions_monitoring_point_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Emissions Monitoring Point Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `parent_emissions_monitoring_point_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Emissions Monitoring Point Id');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `parent_emissions_monitoring_point_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `alert_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Alert Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `calibration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `calibration_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `data_capture_frequency_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Capture Frequency Seconds');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `data_quality_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Quality Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `decommission_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Decommission Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `emissions_monitoring_point_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `emission_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Standard');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `facility_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Facility Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `installation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Installation Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `last_read_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Read Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `last_read_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Read Value');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Latitude');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_latitude` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_latitude` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_latitude` SET TAGS ('dbx_pii_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_latitude` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_latitude` SET TAGS ('dbx_pii_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Longitude');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_longitude` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_longitude` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_longitude` SET TAGS ('dbx_pii_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_longitude` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_longitude` SET TAGS ('dbx_pii_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `location_longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `measurement_range_max` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Range Max');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `measurement_range_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Range Min');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `next_calibration_due` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Calibration Due');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `point_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Point Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `point_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Point Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `point_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Point Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `sensor_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Sensor Model');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `sensor_serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Sensor Serial Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `sensor_serial_number` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `sensor_serial_number` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `emissions_monitoring_point_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `threshold_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Threshold Value');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`emissions_monitoring_point` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` SET TAGS ('dbx_pii_subdomain' = 'environmental_monitoring');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `test_facility_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Facility Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `parent_test_facility_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Test Facility Id');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `parent_test_facility_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `audit_created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `audit_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `capacity_per_day` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Per Day');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `certification_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `certification_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Certification Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_business_glossary_term' = 'Contact Email');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Contact Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_name` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_name` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_business_glossary_term' = 'Contact Phone');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `country` SET TAGS ('dbx_pii_business_glossary_term' = 'Country');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `country` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `emission_test_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Test Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `energy_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Energy Source');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `established_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Established Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `facility_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Facility Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `facility_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Facility Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `is_24x7` SET TAGS ('dbx_pii_business_glossary_term' = 'Is 24x7');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `location_address` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Address');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `location_address` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `location_address` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `max_speed_kph` SET TAGS ('dbx_pii_business_glossary_term' = 'Max Speed Kph');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `test_facility_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `next_certification_due` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Certification Due');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `operating_hours_per_day` SET TAGS ('dbx_pii_business_glossary_term' = 'Operating Hours Per Day');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `safety_test_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Test Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `state` SET TAGS ('dbx_pii_business_glossary_term' = 'State');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `state` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `test_facility_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_facility` ALTER COLUMN `test_capability_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Capability Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` SET TAGS ('dbx_pii_subdomain' = 'governance_framework');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `regulatory_body_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body Identifier');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `parent_regulatory_body_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Regulatory Body Id');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `parent_regulatory_body_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `abbreviation` SET TAGS ('dbx_pii_business_glossary_term' = 'Abbreviation');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `address` SET TAGS ('dbx_pii_business_glossary_term' = 'Address');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `address` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `address` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_business_glossary_term' = 'Contact Email');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `data_privacy_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Privacy Level');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `regulatory_body_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `iso_iec_codes` SET TAGS ('dbx_pii_business_glossary_term' = 'Iso Iec Codes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `last_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Updated');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `regulatory_body_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Phone Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `region` SET TAGS ('dbx_pii_business_glossary_term' = 'Region');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `regulatory_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `reporting_frequency` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Frequency');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `regulatory_body_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_body` ALTER COLUMN `website_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Website Url');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` SET TAGS ('dbx_pii_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `homologation_variant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Variant Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `aftersales_trim_level_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Level Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `sku_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Keeping Unit (SKU) Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Automation Level');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_value_regex' = 'Level 0|Level 1|Level 2|Level 3|Level 4|Level 5');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `approval_authority` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Authority');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Approval Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `approval_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Approval Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `bom_impact_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Impact Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `cafe_compliance_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Corporate Average Fuel Economy (CAFE) Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `compliance_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `cost_delta_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Cost Delta Amount');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `cost_delta_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `cost_delta_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Delta Currency Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `cost_delta_currency` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `emissions_standard_target` SET TAGS ('dbx_pii_business_glossary_term' = 'Emissions Standard Target');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Lead Time in Days');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `modification_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Required Modification Description');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `modification_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Modification Type Classification');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `modification_type` SET TAGS ('dbx_pii_value_regex' = 'Hardware|Software|Calibration|Documentation|Labeling|Testing');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `ncap_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'New Car Assessment Programme (NCAP) Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `ota_capable_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Over-the-Air (OTA) Update Capable Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `regulatory_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance Category');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `regulatory_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Standard Framework');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `renewal_required_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Renewal Required Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `responsible_engineer` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Homologation Engineer Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `submission_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Submission Date');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `target_market_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Market Country Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `target_market_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `target_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Geographic Region');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `target_region` SET TAGS ('dbx_pii_value_regex' = 'North America|Europe|Asia Pacific|Latin America|Middle East|Africa');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `test_report_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Report Reference Number');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `testing_laboratory` SET TAGS ('dbx_pii_business_glossary_term' = 'Testing Laboratory Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `variant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Variant Code');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `variant_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4,20}$');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `variant_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Variant Name');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `variant_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Variant Status');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ALTER COLUMN `wltp_certified_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Worldwide Harmonised Light Vehicles Test Procedure (WLTP) Certified Flag');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`esg_report` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`esg_report` SET TAGS ('dbx_pii_subdomain' = 'environmental_monitoring');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`esg_report` SET TAGS ('dbx_pii_domain' = 'compliance');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`esg_report` SET TAGS ('dbx_pii_subdomain' = 'esg_reporting');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`social_compliance_audit` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`social_compliance_audit` SET TAGS ('dbx_pii_subdomain' = 'environmental_monitoring');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`social_compliance_audit` SET TAGS ('dbx_pii_domain' = 'compliance');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`social_compliance_audit` SET TAGS ('dbx_pii_subdomain' = 'esg_reporting');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`sustainability_metric` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`sustainability_metric` SET TAGS ('dbx_pii_subdomain' = 'environmental_monitoring');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`sustainability_metric` SET TAGS ('dbx_pii_domain' = 'compliance');
ALTER TABLE `vibe_automotive_v1`.`compliance`.`sustainability_metric` SET TAGS ('dbx_pii_subdomain' = 'esg_reporting');
