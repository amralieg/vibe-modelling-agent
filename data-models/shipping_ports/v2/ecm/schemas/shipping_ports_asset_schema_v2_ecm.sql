-- Schema for Domain: asset | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:23

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`asset` COMMENT 'Manages asset registry, equipment inventory, asset lifecycle, depreciation, SWL ratings, preventive and corrective maintenance schedules, work orders, spare parts inventory, equipment downtime, and asset reliability. Covers cranes (STS, QC), RTG, ASC, AGV, MHC, forklifts, and port vehicles. Integrates with Maximo Asset Management and SAP PM. SSOT for asset ownership, valuation, maintenance, and lifecycle management.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` (
    `port_asset_id` BIGINT COMMENT 'Unique identifier for the port asset. Primary key for the asset registry.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Port assets (cranes, RTGs, tugs) are often subject to concession agreements, lease contracts, or BOT arrangements. Business need: tracking which assets are governed by which commercial agreements for ',
    `equipment_class_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_class. Business justification: port_asset currently has asset_class as STRING. equipment_class is the SSOT for equipment classification hierarchy. Normalizing this relationship: port_asset should FK to equipment_class.equipment_cla',
    `facility_security_plan_id` BIGINT COMMENT 'Foreign key linking to security.facility_security_plan. Business justification: ISPS Code requires critical port assets (cranes, scanners, access gates) to be explicitly documented in Facility Security Plans. Regulatory compliance requirement for port facility security assessment',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Port assets (cranes, tugs, forklifts) are often operated by specific terminal operators or stevedoring companies who are registered port community participants. Essential for: asset responsibility tra',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Every port asset must be assigned to a cost centre for financial accountability, budget allocation, and management reporting. Essential for asset ownership tracking and cost allocation in port operati',
    `parent_asset_port_asset_id` BIGINT COMMENT 'Reference to the parent asset in a hierarchical asset structure. Used for sub-assemblies and component tracking. Null for top-level assets.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Every fixed port asset (crane, bollard, fender, gate, building) has a permanent or assigned location within port geography (berth, yard block, terminal zone) - fundamental for asset tracking, maintena',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Port-owned mobile harbor assets (tugs, pilot boats, survey vessels, floating cranes) are vessels requiring IMO registration, classification society certification, flag state compliance, and insurance ',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Every port asset is physically deployed within a security zone for ISPS compliance. Required for access control planning, patrol route assignment, MARSEC-level restrictions, and security audit trails.',
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
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Asset equipment classes reference standardized equipment type master data. Currently equipment_class has equipment_type as a string. Adding FK to masterdata.equipment_type enables standardized equipme',
    `material_group_id` BIGINT COMMENT 'Foreign key linking to procurement.material_group. Business justification: Equipment classes map to procurement material groups for CAPEX budgeting, sourcing strategy definition, and spend analysis. Ports use this link for category management (consolidating crane parts suppl',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` (
    `swl_certificate_id` BIGINT COMMENT 'Unique identifier for the SWL certificate record. Primary key.',
    `compliance_audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: SWL certificates for lifting equipment are mandatory audit evidence during port facility safety audits and ISPS compliance audits. Auditors verify certificate validity, test dates, and expiry for all ',
    `port_asset_id` BIGINT COMMENT 'Reference to the lifting equipment or crane asset (STS, QC, MHC, RTG, ASC, forklift, spreader) for which this SWL certificate is issued.',
    `applicable_standard` STRING COMMENT 'The regulatory or technical standard(s) under which the certificate was issued (e.g., SOLAS Chapter II-1, ISO 9927-1, AS 2550, national maritime safety regulations). May list multiple standards separated by semicolons.',
    `certificate_document_url` STRING COMMENT 'URL or file path to the digitally stored copy of the physical SWL certificate document (PDF, image, or other format).',
    `certificate_number` STRING COMMENT 'Unique certificate number assigned by the issuing authority or classification society. This is the externally-known identifier for the certificate.',
    `certificate_status` STRING COMMENT 'Current lifecycle status of the SWL certificate. Valid = in force, Expired = past expiry date, Suspended = temporarily invalid, Revoked = permanently cancelled, Pending Renewal = renewal in progress.. Valid values are `Valid|Expired|Suspended|Revoked|Pending Renewal`',
    `compliance_flag` BOOLEAN COMMENT 'Indicates whether the equipment is currently in compliance with SWL certification requirements. True = compliant (valid certificate), False = non-compliant (expired, suspended, or revoked certificate).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this SWL certificate record was first created in the system.',
    `equipment_serial_number` STRING COMMENT 'Manufacturer serial number or asset tag of the equipment being certified. Used for cross-reference and audit trail.',
    `equipment_type` STRING COMMENT 'Type of lifting equipment covered by this certificate. STS = Ship-to-Shore crane, QC = Quay Crane, MHC = Mobile Harbour Crane, RTG = Rubber Tyred Gantry, ASC = Automated Stacking Crane, AGV = Automated Guided Vehicle. [ENUM-REF-CANDIDATE: STS|QC|MHC|RTG|ASC|AGV|Forklift|Spreader|Mobile Crane|Gantry Crane|Other — 11 candidates stripped; promote to reference product]',
    `expiry_date` DATE COMMENT 'Date on which the SWL certificate expires and the equipment must be re-certified. Triggers maintenance or re-certification workflows.',
    `inspection_frequency_months` STRING COMMENT 'Required frequency of SWL inspections and re-certification in months (e.g., 12, 24, 60 months) as mandated by regulatory authority or classification society.',
    `issue_date` DATE COMMENT 'Date on which the SWL certificate was officially issued by the certifying authority. This is the effective start date of the certificate.',
    `issuing_authority` STRING COMMENT 'Name of the classification society, accredited surveyor, or regulatory body that issued the SWL certificate (e.g., Lloyds Register, DNV GL, Bureau Veritas, National Maritime Safety Authority).',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this SWL certificate record was last modified or updated in the system.',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next periodic inspection or re-certification of the equipment. Used to trigger preventive maintenance workflows.',
    `remarks` STRING COMMENT 'Additional notes, observations, or conditions recorded by the surveyor during the inspection and certification process. May include limitations, special operating conditions, or maintenance recommendations.',
    `renewal_notification_sent_date` DATE COMMENT 'Date on which the renewal notification was sent to the responsible maintenance team or asset manager, typically 30-90 days before expiry.',
    `surveyor_license_number` STRING COMMENT 'Professional license or accreditation number of the surveyor who conducted the inspection.',
    `surveyor_name` STRING COMMENT 'Full name of the certified surveyor or inspector who conducted the load test and issued the certificate.',
    `swl_rating_tonnes` DECIMAL(18,2) COMMENT 'The certified safe working load capacity of the equipment in metric tonnes. This is the maximum load the equipment is authorized to lift under normal operating conditions.',
    `test_date` DATE COMMENT 'Date on which the load test was conducted by the surveyor or classification society.',
    `test_load_tonnes` DECIMAL(18,2) COMMENT 'The actual test load applied during the load test, typically 125% of the SWL rating, as required by maritime safety regulations.',
    `test_location` STRING COMMENT 'Physical location where the load test was conducted (e.g., terminal name, berth number, workshop).',
    `test_method` STRING COMMENT 'Method used to conduct the load test and certification (e.g., static load test, dynamic load test, non-destructive testing, visual inspection).. Valid values are `Static Load Test|Dynamic Load Test|Non-Destructive Testing|Visual Inspection|Combined`',
    `test_result` STRING COMMENT 'Outcome of the load test. Pass = equipment meets SWL requirements, Fail = equipment does not meet requirements, Conditional Pass = meets requirements with noted conditions or limitations.. Valid values are `Pass|Fail|Conditional Pass`',
    CONSTRAINT pk_swl_certificate PRIMARY KEY(`swl_certificate_id`)
) COMMENT 'Manages Safe Working Load (SWL) certification records for all lifting equipment and cranes (STS, QC, MHC, RTG, ASC, forklifts, spreaders). Captures certificate number, issuing authority (classification society or accredited body), SWL rating in tonnes, test load applied, test date, certificate issue date, expiry date, certificate status (valid/expired/suspended), surveyor name, and applicable standards (SOLAS, national maritime safety regulations). Critical for regulatory compliance and operational safety. Triggers maintenance or re-certification workflows on expiry.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` (
    `depreciation_schedule_id` BIGINT COMMENT 'Unique identifier for the depreciation schedule record. Primary key for the depreciation schedule entity.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Depreciation expense must post to specific cost centres for management accounting and P&L reporting. Required for monthly financial close and cost centre performance analysis in port operations.',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Depreciation schedules must link to the financial fixed asset register for financial reporting and asset accounting. Required for balance sheet reporting and accumulated depreciation tracking.',
    `port_asset_id` BIGINT COMMENT 'Reference to the port asset (crane, RTG, ASC, AGV, MHC, forklift, vehicle, or infrastructure) for which this depreciation schedule applies.',
    `accumulated_depreciation` DECIMAL(18,2) COMMENT 'The cumulative total of all depreciation expense recognized to date since the asset was placed in service. This contra-asset account reduces the gross book value to arrive at net book value.',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'The original purchase price or capitalized cost of the asset, including all costs necessary to bring the asset to working condition (purchase price, freight, installation, commissioning). This is the depreciable base before residual value.',
    `annual_depreciation_amount` DECIMAL(18,2) COMMENT 'The calculated depreciation expense allocated to each fiscal year. For straight-line method, this is depreciable amount divided by useful life years. For other methods, this varies by year.',
    `appraiser_name` STRING COMMENT 'The name of the professional appraiser or valuation firm that performed the asset valuation, if applicable. Used for audit trail and valuation credibility.',
    `appraiser_reference` STRING COMMENT 'The reference number or document identifier for the appraisal report. Used to trace back to the source valuation documentation.',
    `asset_retirement_obligation` DECIMAL(18,2) COMMENT 'The present value of the estimated future cost to retire, dismantle, or remove the asset at the end of its useful life. Relevant for port infrastructure such as berths, wharves, and environmental remediation obligations.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this depreciation schedule record was first created in the lakehouse. Used for data lineage and audit trail.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which all monetary amounts in this depreciation schedule are denominated (e.g., USD, EUR, GBP, AUD).. Valid values are `^[A-Z]{3}$`',
    `depreciable_amount` DECIMAL(18,2) COMMENT 'The net amount subject to depreciation, calculated as acquisition cost minus residual value. This is the total amount that will be expensed over the assets useful life.',
    `depreciation_area` STRING COMMENT 'The accounting perspective or valuation area for which this depreciation schedule is maintained. Book depreciation follows local GAAP, tax follows tax authority rules, IFRS follows International Financial Reporting Standards, group is for consolidated reporting, cost accounting for internal management, and consolidated for group-level financial statements.. Valid values are `book|tax|ifrs|group|cost_accounting|consolidated`',
    `depreciation_end_date` DATE COMMENT 'The date on which depreciation calculation ends for this asset. This is the date when the asset is fully depreciated or retired from service.',
    `depreciation_method` STRING COMMENT 'The calculation method used to allocate the asset cost over its useful life. Straight-line allocates evenly, declining balance applies a fixed percentage to the remaining book value, units-of-production bases depreciation on actual usage (e.g., TEU handled, operating hours), sum-of-years-digits is an accelerated method, and accelerated encompasses other rapid depreciation approaches.. Valid values are `straight_line|declining_balance|double_declining_balance|units_of_production|sum_of_years_digits|accelerated`',
    `depreciation_percentage` DECIMAL(18,2) COMMENT 'The depreciation rate applied for declining balance or percentage-based methods. For example, 20% for a 5-year straight-line equivalent, or 40% for double-declining balance.',
    `depreciation_run_date` DATE COMMENT 'The date on which the depreciation calculation was executed in the source system (SAP FI-AA). Used for audit trail and reconciliation.',
    `depreciation_start_date` DATE COMMENT 'The date on which depreciation calculation begins for this asset. Typically the asset capitalization date or the date the asset is placed in service.',
    `depreciation_status` STRING COMMENT 'The current status of the depreciation schedule. Active indicates ongoing depreciation, suspended indicates temporary halt (e.g., asset under repair), completed indicates fully depreciated, reversed indicates a depreciation reversal, and adjusted indicates a schedule modification.. Valid values are `active|suspended|completed|reversed|adjusted`',
    `fiscal_period` STRING COMMENT 'The fiscal period (month or quarter) within the fiscal year to which this depreciation schedule record applies. Typically 1-12 for monthly periods or 1-4 for quarterly periods.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this depreciation schedule record applies. Used for year-over-year depreciation tracking and financial statement preparation.',
    `gl_account_code` STRING COMMENT 'The general ledger account code to which depreciation expense is posted. Typically an expense account in the chart of accounts.',
    `impairment_date` DATE COMMENT 'The date on which the impairment loss was recognized. Used for financial statement disclosure and audit trail.',
    `impairment_indicator` BOOLEAN COMMENT 'Flag indicating whether there are indicators that the asset may be impaired (carrying amount exceeds recoverable amount). Triggers impairment testing per IAS 36.',
    `impairment_loss` DECIMAL(18,2) COMMENT 'The amount by which the carrying amount of the asset exceeds its recoverable amount. Impairment loss is recognized as an expense and reduces the assets net book value.',
    `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this depreciation schedule record was last modified in the lakehouse. Used for change tracking and audit trail.',
    `net_book_value` DECIMAL(18,2) COMMENT 'The current carrying value of the asset on the balance sheet, calculated as acquisition cost minus accumulated depreciation. Also known as carrying amount or written-down value.',
    `notes` STRING COMMENT 'Free-text notes or comments regarding the depreciation schedule, such as reasons for adjustments, impairment justifications, or special depreciation considerations.',
    `period_depreciation_amount` DECIMAL(18,2) COMMENT 'The depreciation expense allocated to a specific accounting period (month or quarter). This is the periodic depreciation charge posted to the general ledger.',
    `residual_value` DECIMAL(18,2) COMMENT 'The estimated salvage or scrap value of the asset at the end of its useful life. This amount is not depreciated. For port equipment, residual value may reflect resale value or scrap metal value.',
    `revaluation_date` DATE COMMENT 'The date on which the asset was revalued to fair value under the revaluation model. Used for tracking revaluation frequency and compliance with IAS 16.',
    `revaluation_surplus` DECIMAL(18,2) COMMENT 'The amount by which the assets fair value exceeds its carrying amount under the revaluation model. Revaluation surplus is recognized in other comprehensive income and accumulated in equity.',
    `sap_asset_document_number` STRING COMMENT 'The SAP FI-AA document number that records the depreciation posting or asset transaction. Used for reconciliation between the lakehouse and SAP S/4HANA Asset Accounting.',
    `useful_life_units` BIGINT COMMENT 'The estimated total units of production or operating hours over the assets useful life, used when depreciation method is units-of-production. For example, total TEU capacity for a crane, or total operating hours for an AGV.',
    `useful_life_years` DECIMAL(18,2) COMMENT 'The estimated economic useful life of the asset in years, over which the asset will be depreciated. For port equipment such as STS cranes, RTG, and ASC, useful life typically ranges from 10 to 30 years depending on asset class and usage intensity.',
    `valuation_amount` DECIMAL(18,2) COMMENT 'The monetary value of the asset according to the specified valuation type. Used for insurance coverage determination, impairment testing, and financial reporting.',
    `valuation_date` DATE COMMENT 'The effective date of the asset valuation. For fair market value or appraisal value, this is the date the valuation was performed.',
    `valuation_type` STRING COMMENT 'The basis or method used for asset valuation. Book value is the accounting carrying amount, fair market value is the price in an orderly transaction, insurance replacement value is the cost to replace the asset, liquidation value is the forced-sale value, and appraisal value is a professional third-party valuation.. Valid values are `book_value|fair_market_value|insurance_replacement_value|liquidation_value|appraisal_value`',
    CONSTRAINT pk_depreciation_schedule PRIMARY KEY(`depreciation_schedule_id`)
) COMMENT 'SSOT for the financial valuation and depreciation lifecycle of each port asset. Defines and tracks both periodic depreciation calculations and point-in-time asset valuations. Captures depreciation method (straight-line, declining balance, units-of-production), useful life, depreciation start/end dates, annual depreciation amount, accumulated depreciation, net book value, residual value, depreciation area (book, tax, IFRS), fiscal year, valuation type (book value, fair market value, insurance replacement value), valuation amount, appraiser reference, and SAP asset accounting document reference. Supports CAPEX reporting, IFRS 16 compliance, asset impairment assessments, insurance valuations, and financial statement preparation. Sourced from SAP S/4HANA Asset Accounting (FI-AA).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` (
    `maintenance_plan_id` BIGINT COMMENT 'Unique identifier for the preventive maintenance plan. Primary key. Inferred role: MASTER_RESOURCE (defines a maintenance plan as a managed resource/configuration).',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Maintenance plans for customer-owned or leased equipment must reference the governing service agreement to ensure SLA compliance, determine cost recovery responsibility, and track contractual maintena',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Maintenance plans are frequently executed by external contractors (OEM service providers, specialized marine engineers) who must be registered port community participants for port access and complianc',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Maintenance budgets and actual costs are controlled by cost centre for operational expense management. Essential for budget vs actual variance reporting and cost centre accountability.',
    `work_order_id` BIGINT COMMENT 'Reference to the most recent work order that completed maintenance under this plan. Provides traceability to execution records.',
    `personnel_id` BIGINT COMMENT 'Foreign key linking to security.security_personnel. Business justification: Maintenance plans for security-critical assets (access gates, CCTV, barriers, scanners) require assignment to security-cleared personnel. Operational necessity for MARSEC-level compliance and restrict',
    `port_asset_id` BIGINT COMMENT 'Reference to the specific asset (STS crane, RTG, ASC, AGV, MHC, forklift, port vehicle) to which this maintenance plan applies. Links to the asset registry.',
    `employee_id` BIGINT COMMENT 'Reference to the employee responsible for planning and scheduling maintenance under this plan. Links to the workforce employee registry.',
    `risk_assessment_id` BIGINT COMMENT 'Foreign key linking to safety.risk_assessment. Business justification: Preventive maintenance plans for critical port equipment (cranes, RTGs, mooring systems) must reference risk assessments per ISO 45001. Ensures maintenance procedures address identified hazards. Requi',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Planned maintenance is often executed under service contracts (crane maintenance, dredging, quay wall inspections). Ports link PM plans to contracts for automatic cost allocation, SLA compliance track',
    `work_order_template_id` BIGINT COMMENT 'Reference to the work order template used for auto-generating work orders from this maintenance plan. Ensures consistency in work order structure and content.',
    `approval_date` DATE COMMENT 'The date when the current revision of the maintenance plan was formally approved. Part of the plan lifecycle audit trail.',
    `asset_class` STRING COMMENT 'Classification of the asset type covered by this plan. STS (Ship-to-Shore crane), RTG (Rubber Tyred Gantry), ASC (Automated Stacking Crane), AGV (Automated Guided Vehicle), MHC (Mobile Harbour Crane), QC (Quay Crane), and other port equipment categories. [ENUM-REF-CANDIDATE: sts_crane|rtg|asc|agv|mhc|qc|forklift|port_vehicle|reach_stacker|terminal_tractor|other — 11 candidates stripped; promote to reference product]',
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
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Work orders for contracted services (equipment maintenance under concession terms, customer-specific repairs) must track the governing agreement for accurate billing, cost allocation, and SLA complian',
    `compliance_audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: ISO 55001 asset management audits and ISPS facility audits review maintenance work orders as evidence of preventive maintenance compliance. Auditors trace specific work orders during certification aud',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Work orders often involve external contractors for specialized repairs, equipment servicing, or emergency maintenance. Contractors must be registered port community participants for security clearance',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Work order costs must be allocated to cost centres for expense tracking and financial reporting. Critical for maintenance cost control and cost centre P&L in port operations.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Major maintenance work orders often charge to internal orders for cost collection before settlement to assets or expense accounts. Common in port maintenance accounting for large repairs.',
    `procurement_plan_id` BIGINT COMMENT 'Reference to the preventive maintenance plan that triggered this work order. Populated for preventive work orders; null for corrective, emergency, or ad-hoc work orders.',
    `permit_to_work_id` BIGINT COMMENT 'Foreign key linking to safety.permit_to_work. Business justification: High-risk maintenance (hot work, confined space, lifting operations) requires permits to work before execution. Port operations mandate permit tracking on work orders for regulatory compliance (ISPS, ',
    `personnel_id` BIGINT COMMENT 'Foreign key linking to security.security_personnel. Business justification: Work orders in restricted security zones require security escort or supervision by certified security personnel. ISPS operational requirement for access control and audit trail of maintenance activiti',
    `port_asset_id` BIGINT COMMENT 'Reference to the port asset (crane, RTG, ASC, AGV, MHC, forklift, vehicle, or infrastructure) against which this work order is raised. Links to the asset registry for equipment details, location, and specifications.',
    `employee_id` BIGINT COMMENT 'Reference to the maintenance supervisor or foreman responsible for overseeing this work order execution. Links to employee entity for contact details and accountability.',
    `purchase_requisition_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_requisition. Business justification: Maintenance work orders trigger procurement requisitions for parts and services not in stock. This is core MRO workflow in ports—linking work orders to requisitions enables tracking of maintenance-dri',
    `terminal_equipment_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal_equipment. Business justification: Maintenance work orders need operational equipment identifier for dispatch coordination, real-time equipment status updates, shift handover, and operational downtime tracking. While work_order.asset_i',
    `tertiary_work_approved_by_employee_id` BIGINT COMMENT 'Reference to the maintenance manager or authorized approver who approved this work order for execution. Required for work orders above certain cost thresholds or priority levels.',
    `tug_id` BIGINT COMMENT 'Foreign key linking to marine.tug. Business justification: Maintenance work orders on tugs require operational context (bollard pull rating, FIFI class, escort capability, engine power) for work planning, parts specification, and service provider selection. L',
    `gang_id` BIGINT COMMENT 'Reference to the maintenance crew or work gang assigned to execute this work order. Links to workforce gang entity for crew composition, skills, and availability.',
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
    `employee_id` BIGINT COMMENT 'Reference to the maintenance technician or crew member assigned to execute this task. Links to workforce employee record.',
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
    `vendor_service_provider` STRING COMMENT 'Name of external vendor or contractor who performed this task, if not completed by internal workforce. Used for outsourced maintenance tracking.',
    `warranty_claim_flag` BOOLEAN COMMENT 'Indicates whether this task is associated with a warranty claim for parts or labour. Used for cost recovery and vendor management.',
    CONSTRAINT pk_work_order_task PRIMARY KEY(`work_order_task_id`)
) COMMENT 'SSOT for individual task lines and material consumption within a maintenance work order. Represents the granular steps required to complete a maintenance activity, including spare parts issued and returned. Records task sequence number, task description, trade skill required, planned and actual labour hours, task status, assigned technician, start/end timestamps, safety permit reference (e.g., lock-out/tag-out), completion notes, spare parts consumed (part reference, quantity issued/returned, unit cost), and material cost per task. Enables detailed tracking of multi-step maintenance operations, parts consumption, and cost allocation on complex equipment such as STS cranes, ASCs, and AGVs. Sourced from Maximo Work Order Tasks and Inventory Transactions.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` (
    `failure_report_id` BIGINT COMMENT 'Unique identifier for the equipment failure report record. Primary key.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Equipment failures impacting contracted services must reference the affected agreement for SLA breach assessment, penalty calculation, and root cause accountability determination. Critical for termina',
    `violation_id` BIGINT COMMENT 'Foreign key linking to compliance.violation. Business justification: Equipment failures causing oil spills, cargo damage, or safety incidents trigger regulatory violations. Port authorities must link failure reports to compliance violation records for incident investig',
    `ohs_incident_id` BIGINT COMMENT 'Reference to the associated OHS incident record if the failure resulted in injury, near-miss, or safety event requiring formal investigation and reporting.',
    `port_asset_id` BIGINT COMMENT 'Reference to the port asset or equipment that experienced the failure. Links to the asset registry for cranes (STS, QC), RTG, ASC, AGV, MHC, forklifts, and port vehicles.',
    `previous_failure_report_id` BIGINT COMMENT 'Reference to the previous failure report for the same asset or component if this is a recurrence. Enables failure pattern analysis and chronic issue tracking.',
    `employee_id` BIGINT COMMENT 'Reference to the employee (operator, supervisor, or maintenance technician) who first reported the failure event.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: When asset failures involve third-party operated equipment or contractor-maintained assets, the responsible port community participant must be formally tracked for liability determination, warranty cl',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Failures of security-critical assets (gate malfunctions, CCTV outages, scanner failures) automatically trigger security incident protocols under ISPS Code. Required for PFSO notification and regulator',
    `terminal_equipment_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal_equipment. Business justification: Equipment failure reports require operational equipment context for reliability analysis, operational impact assessment (TEU throughput loss, vessel delays), and maintenance planning. While failure_re',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` (
    `downtime_record_id` BIGINT COMMENT 'Unique identifier for the equipment downtime record. Primary key for the downtime tracking system.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Asset downtime affecting contracted throughput commitments must reference the agreement for SLA measurement, penalty assessment, and dispute resolution. Essential for terminal operators tracking equip',
    `failure_report_id` BIGINT COMMENT 'Reference to the failure or incident report documenting the root cause of unplanned downtime. Used for failure analysis and reliability improvement.',
    `port_asset_id` BIGINT COMMENT 'Identifier of the port asset or equipment that experienced downtime. Links to the asset registry covering cranes (STS, QC), RTG, ASC, AGV, MHC, forklifts, and port vehicles.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee or system user who reported or logged the downtime event. Links to workforce management system for accountability and audit trail.',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Downtime of security equipment (access barriers, screening devices, surveillance systems) must be logged as security incidents for ISPS audit trails and PFSO review. Regulatory compliance requirement.',
    `shift_pattern_id` BIGINT COMMENT 'Identifier of the operational shift during which the downtime occurred. Used for shift-based performance analysis and workforce planning. Links to workforce roster system.',
    `terminal_equipment_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal_equipment. Business justification: Downtime records track operational impact (TEU loss, vessel delays) requiring operational equipment identifier for shift reporting, dispatcher visibility, and real-time equipment availability. While d',
    `tertiary_downtime_approved_by_user_employee_id` BIGINT COMMENT 'Identifier of the maintenance manager or supervisor who approved and closed the downtime record. Used for audit trail and data quality assurance.',
    `tug_id` BIGINT COMMENT 'Foreign key linking to marine.tug. Business justification: Tug downtime impacts towage service delivery and port operational capacity. Linking downtime records to tug operational data enables MTBF/MTTR analysis by vessel class, bollard pull rating, and servic',
    `vessel_id` BIGINT COMMENT 'Identifier of the vessel being serviced at the time of downtime, if applicable. Used to assess impact on vessel turnaround time and potential demurrage claims. Links to vessel operations domain.',
    `work_order_id` BIGINT COMMENT 'Reference to the maintenance work order associated with this downtime event, if applicable. Links to Maximo work order system for planned or corrective maintenance activities.',
    `acknowledged_timestamp` TIMESTAMP COMMENT 'Date and time when the downtime event was acknowledged by maintenance management. Used to calculate response time and escalation metrics.',
    `affected_berth` STRING COMMENT 'Berth number or identifier where the equipment downtime occurred, if applicable. Relevant for ship-to-shore cranes and quay cranes. Used to assess impact on vessel operations and berth utilization.',
    `affected_terminal` STRING COMMENT 'Name or code of the marine terminal or container yard where the downtime occurred. Used for location-based downtime analysis and terminal performance benchmarking.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the downtime record was approved and closed by management. Used for audit trail and record lifecycle tracking.',
    `corrective_action_taken` STRING COMMENT 'Description of the corrective actions implemented to resolve the downtime and restore equipment to operational status. Includes repair procedures, parts replaced, adjustments made, or temporary workarounds applied.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this downtime record was first created in the lakehouse. System-generated audit field for data lineage and record lifecycle tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the maintenance cost amount. Typically the ports functional currency (e.g., USD, EUR, SGD).. Valid values are `^[A-Z]{3}$`',
    `downtime_category` STRING COMMENT 'Classification of the downtime event type. Planned maintenance includes scheduled preventive maintenance. Unplanned breakdown covers equipment failures. Operational standby represents idle time due to no cargo operations. Weather hold indicates suspension due to adverse weather conditions. Regulatory inspection covers mandatory safety or compliance inspections. Operator unavailable indicates downtime due to workforce constraints.. Valid values are `planned_maintenance|unplanned_breakdown|operational_standby|weather_hold|regulatory_inspection|operator_unavailable`',
    `downtime_duration_hours` DECIMAL(18,2) COMMENT 'Total duration of the downtime event measured in hours. Calculated as the difference between end and start timestamps. Critical for calculating equipment availability, MTTR (Mean Time To Repair), and OEE (Overall Equipment Effectiveness).',
    `downtime_end_timestamp` TIMESTAMP COMMENT 'Date and time when the equipment was restored to operational status and downtime ended. Null if downtime is ongoing. Used to calculate total downtime duration.',
    `downtime_reason_code` STRING COMMENT 'Standardized code representing the specific reason or root cause of the downtime event. Aligned with Maximo failure codes and maintenance taxonomy. Used for failure mode analysis and reliability improvement initiatives.',
    `downtime_reason_description` STRING COMMENT 'Detailed narrative description of the downtime cause, symptoms observed, and corrective actions taken. Provides context for root cause analysis and knowledge management.',
    `downtime_start_timestamp` TIMESTAMP COMMENT 'Date and time when the equipment downtime event began. Captured from TOS or asset monitoring systems. Used as the primary business event timestamp for calculating downtime duration and availability metrics.',
    `downtime_status` STRING COMMENT 'Current lifecycle status of the downtime record. Open indicates newly reported. In progress indicates active repair or investigation. Resolved indicates equipment restored but record under review. Closed indicates record finalized and approved. Cancelled indicates false alarm or duplicate entry.. Valid values are `open|in_progress|resolved|closed|cancelled`',
    `is_current_record` BOOLEAN COMMENT 'Flag indicating whether this is the current active version of the downtime record. True for the latest version. False for historical versions. Used for SCD Type 2 queries and current-state reporting.',
    `is_regulatory_reportable` BOOLEAN COMMENT 'Flag indicating whether the downtime event must be reported to regulatory authorities such as Port State Control (PSC) or maritime safety agencies. True if reportable under IMO, SOLAS, or national regulations.',
    `is_safety_related` BOOLEAN COMMENT 'Flag indicating whether the downtime event was caused by or resulted in a safety hazard or incident. True if safety-related. Used for OHS (Occupational Health and Safety) reporting and compliance with SOLAS and ISPS requirements.',
    `maintenance_cost_amount` DECIMAL(18,2) COMMENT 'Total cost incurred for resolving the downtime event, including labor, spare parts, and contractor fees. Expressed in the ports functional currency. Used for OPEX (Operational Expenditure) tracking and cost-benefit analysis of reliability improvements.',
    `mtbf_impact_flag` BOOLEAN COMMENT 'Flag indicating whether this downtime event should be included in MTBF (Mean Time Between Failures) calculations. True for unplanned breakdowns and failures. False for planned maintenance and operational standby. Used for reliability KPI derivation.',
    `mttr_impact_flag` BOOLEAN COMMENT 'Flag indicating whether this downtime event should be included in MTTR (Mean Time To Repair) calculations. True for events requiring corrective maintenance. False for planned maintenance and non-repair downtime. Used for maintenance efficiency KPI derivation.',
    `oee_impact_flag` BOOLEAN COMMENT 'Flag indicating whether this downtime event should be included in OEE (Overall Equipment Effectiveness) calculations. True for all downtime that reduces equipment availability. Used for productivity and efficiency benchmarking.',
    `operational_impact_teu` STRING COMMENT 'Estimated number of TEUs (Twenty-foot Equivalent Units) that could not be handled due to this downtime event. Used to quantify the cargo handling impact and calculate productivity loss.',
    `operational_impact_vessel_moves` STRING COMMENT 'Estimated number of vessel container moves lost due to this downtime event. Applicable primarily to ship-to-shore cranes and quay cranes. Used to assess impact on vessel turnaround time and berth productivity.',
    `preventive_action_recommended` STRING COMMENT 'Recommendations for preventive actions to avoid recurrence of similar downtime events. May include changes to maintenance schedules, operator training, design modifications, or spare parts stocking strategies.',
    `priority_level` STRING COMMENT 'Urgency classification of the downtime event based on operational impact and asset criticality. Critical indicates immediate vessel or terminal operations impact. High indicates significant productivity loss. Medium indicates moderate impact. Low indicates minimal operational disruption.. Valid values are `critical|high|medium|low`',
    `record_effective_date` DATE COMMENT 'Date from which this version of the downtime record is effective. Used for slowly changing dimension (SCD) Type 2 historization and temporal queries.',
    `record_expiry_date` DATE COMMENT 'Date until which this version of the downtime record is valid. Null for current active records. Used for slowly changing dimension (SCD) Type 2 historization and temporal queries.',
    `reported_timestamp` TIMESTAMP COMMENT 'Date and time when the downtime event was first reported or logged in the system. May differ from actual downtime start time. Used for response time analysis.',
    `resolution_timestamp` TIMESTAMP COMMENT 'Date and time when the root cause was identified and corrective action was completed. May differ from downtime end timestamp if testing or commissioning is required. Used for MTTR calculation.',
    `responsible_party` STRING COMMENT 'Entity or party responsible for the downtime event. Internal maintenance indicates port maintenance team responsibility. External contractor indicates third-party service provider. Equipment manufacturer indicates warranty or design defect issues. Operator error indicates human factor. Force majeure covers uncontrollable events like extreme weather. Third party damage indicates damage caused by external parties.. Valid values are `internal_maintenance|external_contractor|equipment_manufacturer|operator_error|force_majeure|third_party_damage`',
    `root_cause_category` STRING COMMENT 'High-level classification of the root cause of downtime based on failure mode analysis. Categories may include mechanical failure, electrical failure, hydraulic failure, structural damage, software malfunction, operator error, or external factors. Used for reliability improvement and preventive maintenance planning. [ENUM-REF-CANDIDATE: mechanical_failure|electrical_failure|hydraulic_failure|structural_damage|software_malfunction|operator_error|external_factors|design_defect|wear_and_tear — promote to reference product]',
    `sla_breach_flag` BOOLEAN COMMENT 'Flag indicating whether the downtime event caused a breach of service level agreements with shipping lines or terminal customers. True if SLA targets for vessel turnaround time or container handling were not met due to this downtime.',
    `source_record_reference` STRING COMMENT 'Unique identifier of the downtime record in the source operational system. Used for data lineage, reconciliation, and traceability back to the system of record.',
    `spare_parts_used` STRING COMMENT 'List or description of spare parts consumed during the repair or maintenance activity. Links to spare parts inventory in Maximo. Used for parts consumption analysis and inventory planning.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this downtime record was last modified in the lakehouse. System-generated audit field for change tracking and data quality monitoring.',
    `weather_condition` STRING COMMENT 'Description of weather conditions at the time of downtime, if weather was a contributing factor. Includes wind speed, visibility, precipitation, or sea state. Used for weather-related downtime analysis and force majeure claims.',
    CONSTRAINT pk_downtime_record PRIMARY KEY(`downtime_record_id`)
) COMMENT 'Tracks equipment downtime events for all port assets, capturing start and end timestamps, duration in hours, downtime category (planned maintenance, unplanned breakdown, operational standby, weather hold, regulatory inspection), affected asset, operational impact in TEUs or vessel moves lost, responsible party, and associated work order or failure report reference. Enables calculation of equipment availability, utilisation rates, MTBF (Mean Time Between Failures), MTTR (Mean Time To Repair), and OEE (Overall Equipment Effectiveness) for cranes, RTGs, ASCs, and AGVs. Primary source for reliability KPI derivation. Integrates with NAVIS N4 TOS and Maximo.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` (
    `inspection_record_id` BIGINT COMMENT 'Unique identifier for the inspection record. Primary key for the inspection_record data product.',
    `compliance_audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Port facility audits (ISO 9001, ISPS, OHSAS 18001) require inspection records as objective evidence. Auditors verify that statutory inspections (SWL tests, crane certifications) were completed per sch',
    `inspection_checklist_id` BIGINT COMMENT 'Reference to the standardized inspection checklist or template used during the inspection. Ensures consistency and completeness of inspection procedures.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Internal port asset inspections assign employees as inspectors. Tracks inspector assignment for compliance audits, workload planning, and certification verification. Inspector_name is denormalized emp',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: External inspectors (classification societies like Lloyds, DNV; regulatory surveyors; certification bodies) must be registered port community participants for facility access and accreditation verifi',
    `permit_to_work_id` BIGINT COMMENT 'Foreign key linking to safety.permit_to_work. Business justification: Asset inspections requiring hot work (NDT, welding inspection), confined space entry (tank inspections), or working at height require permits. Maritime regulations mandate permit tracking for inspecti',
    `personnel_id` BIGINT COMMENT 'Foreign key linking to security.security_personnel. Business justification: Inspections of security equipment (scanners, CCTV, access control systems) require certified security personnel with ISPS training. Regulatory requirement for security equipment certification and comp',
    `port_asset_id` BIGINT COMMENT 'Foreign key reference to the asset that was inspected. Links to the asset registry for equipment such as Ship-to-Shore (STS) cranes, Rubber Tyred Gantry (RTG) cranes, Automated Stacking Cranes (ASC), Automated Guided Vehicles (AGV), Mobile Harbour Cranes (MHC), forklifts, and port vehicles.',
    `service_entry_sheet_id` BIGINT COMMENT 'Foreign key linking to procurement.service_entry_sheet. Business justification: Third-party inspections (SWL certification, NDT testing, regulatory surveys) are procured services. Ports must link inspection completion to service entry sheets for payment release, three-way matchin',
    `swl_certificate_id` BIGINT COMMENT 'Foreign key linking to asset.swl_certificate. Business justification: Links SWL-specific inspection records to their corresponding SWL certificates. While inspection_record covers all inspection types (statutory, safety, operational, SWL), SWL inspections specifically v',
    `terminal_equipment_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal_equipment. Business justification: Equipment inspections (SWL certification, regulatory compliance) require operational equipment identifier for inspection scheduling, operational compliance tracking, and equipment certification status',
    `tug_id` BIGINT COMMENT 'Foreign key linking to marine.tug. Business justification: Statutory inspections of tugs (class surveys, FIFI certification, escort capability verification, bollard pull testing) require linking asset register to operational vessel data for compliance trackin',
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
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Spare parts are imported/exported goods requiring HS code classification for customs clearance, import duty calculation, trade compliance reporting, and controlled goods licensing (especially for dual',
    `equipment_class_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_class. Business justification: spare_part currently has equipment_class as STRING. This should be normalized to FK to equipment_class.equipment_class_id. Enables proper parts cataloging by equipment class, supports parts compatibil',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Spare parts inventory must map to GL accounts for balance sheet reporting and inventory valuation. Essential for financial statement preparation and inventory accounting in port operations.',
    `material_master_id` BIGINT COMMENT 'Foreign key linking to procurement.material_master. Business justification: Spare parts are materials in the procurement master data system. Ports need unified material master records for MRP runs, inventory valuation, procurement planning, and cross-system reconciliation bet',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Spare parts suppliers must be registered port community participants for just-in-time delivery to port facilities, customs clearance of imported parts, ISPS security screening, and direct-to-maintenan',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Spare parts for security equipment stored in restricted security zones require zone-based access control and inventory tracking. Operational necessity for MARSEC-level compliance and audit trails.',
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
    `warehouse_code` STRING COMMENT 'Identifier for the warehouse or storage facility where the spare part is stocked. Supports multi-warehouse inventory management across port terminals.',
    `warranty_period_months` STRING COMMENT 'Manufacturer warranty period in months from date of purchase. Used for warranty claim tracking and supplier performance evaluation.',
    CONSTRAINT pk_spare_part PRIMARY KEY(`spare_part_id`)
) COMMENT 'Master catalogue and inventory register of spare parts and consumables held for port asset maintenance. SSOT for spare parts master data within the asset domain. Captures part number, part description, OEM part reference, equipment class compatibility, unit of measure, minimum stock level, reorder point, lead time in days, storage location (warehouse bin), unit cost, total stock value, criticality classification (critical/essential/standard), and hazardous material flag. Integrates with Maximo Spare Parts Inventory and SAP MM Materials Management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`meter` (
    `meter_id` BIGINT COMMENT 'Unique identifier for the asset meter reading record. Primary key for the asset meter entity.',
    `employee_id` BIGINT COMMENT 'Identifier of the maintenance technician or operator who captured the manual meter reading. Null for automated readings.',
    `port_asset_id` BIGINT COMMENT 'Identifier of the port asset (STS crane, RTG, ASC, AGV, MHC, forklift, vehicle) to which this meter reading belongs.',
    `terminal_equipment_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal_equipment. Business justification: Meter readings (operating hours, crane cycles, fuel consumption) are captured from operational equipment for real-time telemetry, operational monitoring, and preventive maintenance triggering. While a',
    `tug_id` BIGINT COMMENT 'Foreign key linking to marine.tug. Business justification: Operating hours, fuel consumption, and bollard pull cycles on tugs are metered for condition-based maintenance triggers, performance monitoring, and utilization billing. Links asset meter readings to ',
    `work_order_id` BIGINT COMMENT 'Identifier of the maintenance work order during which this meter reading was captured. Links meter reading to preventive or corrective maintenance activity.',
    `alert_generated_flag` BOOLEAN COMMENT 'Indicates whether a maintenance alert has been generated based on this meter reading. True if alert was triggered, false otherwise.',
    `alert_threshold` DECIMAL(18,2) COMMENT 'Meter reading value at which an alert or notification should be generated to prompt maintenance planning. Typically set before the PM threshold to allow lead time.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this meter reading record was first created in the lakehouse. Used for data lineage and audit trail.',
    `cumulative_total` DECIMAL(18,2) COMMENT 'Lifetime cumulative total for the meter since asset commissioning. Accounts for rollovers and resets to provide true lifetime usage.',
    `current_reading` DECIMAL(18,2) COMMENT 'The current meter reading value captured at the reading date. Represents the cumulative total at the time of observation.',
    `data_quality_score` DECIMAL(18,2) COMMENT 'Calculated data quality score for this meter reading (0-100). Based on factors such as reading source reliability, variance from expected, and validation status.',
    `incremental_usage` DECIMAL(18,2) COMMENT 'Calculated incremental usage between current and previous reading. Used to trigger usage-based preventive maintenance (PM) schedules.',
    `meter_type` STRING COMMENT 'Type of meter or counter being tracked. Operating hours for RTGs and AGVs, lift cycles for STS cranes and QCs, distance travelled for AGVs, load cycles for handling equipment, fuel consumption for diesel-powered equipment, engine hours for vehicles.. Valid values are `operating_hours|lift_cycles|distance_travelled|load_cycles|fuel_consumption|engine_hours`',
    `next_pm_threshold` DECIMAL(18,2) COMMENT 'Meter reading value at which the next preventive maintenance activity is scheduled to be triggered. Used for condition-based and usage-based PM scheduling.',
    `pm_interval` DECIMAL(18,2) COMMENT 'Standard interval between preventive maintenance activities for this meter type. For example, 500 operating hours for RTG inspection, 10000 lift cycles for STS crane service.',
    `previous_reading` DECIMAL(18,2) COMMENT 'The previous meter reading value before the current reading. Used to calculate incremental usage since last reading.',
    `reading_accuracy` STRING COMMENT 'Assessed accuracy level of the meter reading. High for direct sensor readings, medium for manual observations, low for estimated or interpolated values.. Valid values are `high|medium|low`',
    `reading_date` TIMESTAMP COMMENT 'Date and time when the meter reading was captured. Primary business event timestamp for condition-based and usage-based maintenance scheduling.',
    `reading_method` STRING COMMENT 'Method used to obtain the meter reading. Direct observation by technician, remote telemetry from IoT device, system integration from TOS or SCADA, estimated based on usage patterns, or interpolated from adjacent readings.. Valid values are `direct_observation|remote_telemetry|system_integration|estimated|interpolated`',
    `reading_notes` STRING COMMENT 'Free-text notes or comments about the meter reading. May include technician observations, anomalies detected, or contextual information about operating conditions.',
    `reading_source` STRING COMMENT 'Source or method by which the meter reading was captured. Manual entry by technician, automated system reading, IoT sensor transmission, telematics device, or SCADA system integration.. Valid values are `manual|automated|iot_sensor|telematics|scada`',
    `reading_status` STRING COMMENT 'Status of the meter reading. Valid for confirmed accurate readings, invalid for erroneous data, estimated for interpolated values, adjusted for corrected readings, pending verification for unconfirmed readings.. Valid values are `valid|invalid|estimated|adjusted|pending_verification`',
    `rollover_count` STRING COMMENT 'Number of times the meter has rolled over since asset commissioning. Used to calculate true cumulative total.',
    `rollover_flag` BOOLEAN COMMENT 'Indicates whether the meter has rolled over (reset to zero after reaching maximum value). True if rollover occurred, false otherwise.',
    `sensor_code` STRING COMMENT 'Identifier of the IoT sensor or telematics device that transmitted the automated meter reading. Null for manual readings.',
    `source_record_reference` STRING COMMENT 'Unique identifier of the meter reading record in the source system. Used for data lineage and reconciliation with operational systems.',
    `unit` STRING COMMENT 'Unit of measure for the meter reading. Hours for operating time, cycles for lift/load operations, kilometers or meters for distance, liters or gallons for fuel consumption.. Valid values are `hours|cycles|kilometers|meters|liters|gallons`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this meter reading record was last updated in the lakehouse. Used for change tracking and data freshness monitoring.',
    `usage_rate_per_day` DECIMAL(18,2) COMMENT 'Calculated average daily usage rate for this meter. Used to forecast when PM thresholds will be reached and to schedule proactive maintenance.',
    `variance_from_expected` DECIMAL(18,2) COMMENT 'Percentage variance between the actual reading and the expected reading based on historical usage patterns. Used to identify anomalies or equipment issues.',
    CONSTRAINT pk_meter PRIMARY KEY(`meter_id`)
) COMMENT 'SSOT for meter and counter readings used to trigger condition-based and usage-based maintenance plans for port assets. Captures meter type (operating hours, lift cycles, distance travelled, load cycles, fuel consumption), meter unit, current reading, previous reading, reading date, reading source (manual/automated/IoT sensor), cumulative total, and rollover flag. Supports meter-based PM scheduling for STS cranes (lift cycles), RTGs (operating hours), AGVs (distance/cycles), and port vehicles (odometer). Sourced from Maximo Meter Readings and IoT sensor platforms.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` (
    `acquisition_id` BIGINT COMMENT 'Unique identifier for the asset acquisition record. Primary key for the asset acquisition lifecycle tracking from procurement through commissioning.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Asset acquisitions may be funded through internal orders for capex cost collection and settlement. Used when acquisitions are not part of formal projects but need cost tracking.',
    `port_asset_id` BIGINT COMMENT 'Reference to the asset that was acquired. Links to the master asset registry for the equipment unit (crane, RTG, ASC, AGV, MHC, forklift, or port vehicle) that was procured.',
    `employee_id` BIGINT COMMENT 'Reference to the employee designated as the asset manager responsible for the lifecycle management of this asset post-acquisition. Links to workforce employee master data.',
    `risk_assessment_id` BIGINT COMMENT 'Foreign key linking to safety.risk_assessment. Business justification: New asset commissioning requires pre-operational risk assessment per ISO 45001 and port safety management systems. Links acquisition to mandatory safety evaluation before equipment enters service. Cri',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier or manufacturer from whom the asset was procured. Links to the vendor master data in SAP MM.',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Capital asset acquisitions are tracked under WBS elements in project accounting for capex budget control and project cost tracking. Standard practice in port infrastructure investment management.',
    `acceptance_certificate_number` STRING COMMENT 'The unique reference number of the formal acceptance certificate issued upon successful handover of the asset from vendor to port authority.. Valid values are `^AC[0-9]{8,12}$`',
    `acquisition_date` DATE COMMENT 'The date on which the asset was legally acquired or ownership transferred to the port authority. This is the principal business event timestamp for the acquisition transaction.',
    `asset_class_code` STRING COMMENT 'The SAP FI-AA asset class code that categorizes the asset for accounting, depreciation, and reporting purposes (e.g., cranes, vehicles, IT equipment).. Valid values are `^[A-Z0-9]{4,10}$`',
    `asset_location_code` STRING COMMENT 'The code identifying the physical location or berth where the asset is deployed within the port facility (e.g., terminal yard, berth number, maintenance depot).. Valid values are `^[A-Z0-9]{4,12}$`',
    `capitalization_date` DATE COMMENT 'The date on which the asset was capitalized in the financial accounting system (SAP FI-AA), marking the start of depreciation.',
    `commissioning_date` DATE COMMENT 'The date on which the asset was commissioned and became operational for port activities. Marks the transition from capital project to operational asset.',
    `cost` DECIMAL(18,2) COMMENT 'The total cost paid for acquiring the asset, including purchase price, delivery, installation, and commissioning costs. Represents the capitalized value in SAP FI-AA.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this asset acquisition record was first created in the system. Audit trail for data governance and compliance.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which the acquisition cost was denominated (e.g., USD, EUR, GBP, SGD).. Valid values are `^[A-Z]{3}$`',
    `depreciation_method` STRING COMMENT 'The accounting method used to depreciate the asset over its useful life. Determines how the acquisition cost is expensed over time in SAP FI-AA.. Valid values are `straight_line|declining_balance|units_of_production|sum_of_years_digits`',
    `funding_source` STRING COMMENT 'The financial mechanism used to fund the asset acquisition. Indicates whether the asset was purchased using internal capital, external financing, or alternative funding arrangements.. Valid values are `own_funds|bank_loan|lease|public_private_partnership|government_grant|bond_issuance`',
    `handover_acceptance_date` DATE COMMENT 'The date on which the asset was formally accepted by the port authority from the vendor, signifying completion of all acceptance tests and readiness for operational deployment.',
    `handover_acceptance_status` STRING COMMENT 'The current status of the asset handover and acceptance process from the vendor to the port operations team. Tracks the final stage of the acquisition lifecycle before operational deployment.. Valid values are `pending_inspection|conditionally_accepted|fully_accepted|rejected|under_remediation`',
    `initial_swl_certification_date` DATE COMMENT 'The date on which the initial Safe Working Load certification was issued for the asset by a qualified marine surveyor or certification authority. Critical for cranes, lifting equipment, and cargo handling machinery.',
    `installation_completion_date` DATE COMMENT 'The date on which physical installation of the asset at the port site was completed, preceding commissioning and acceptance testing.',
    `installation_contractor_name` STRING COMMENT 'The name of the contractor responsible for installing and commissioning the asset at the port facility. May differ from the equipment vendor.',
    `insurance_coverage_amount` DECIMAL(18,2) COMMENT 'The total insured value or coverage amount for the asset under the insurance policy.',
    `insurance_policy_number` STRING COMMENT 'The insurance policy number covering the asset against damage, loss, or liability. Critical for high-value port equipment such as STS cranes and RTGs.. Valid values are `^[A-Z0-9]{8,20}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this asset acquisition record was last updated in the system. Audit trail for data governance and compliance.',
    `notes` STRING COMMENT 'Free-text field for additional notes, comments, or special conditions related to the asset acquisition, including any deviations from standard procurement processes or unique contractual terms.',
    `purchase_order_number` STRING COMMENT 'The purchase order number issued to the vendor for procurement of the asset. Integrates with SAP MM purchase order management system.. Valid values are `^PO[0-9]{8,12}$`',
    `residual_value` DECIMAL(18,2) COMMENT 'The estimated salvage or residual value of the asset at the end of its useful life, used in depreciation calculations.',
    `swl_rating_tonnes` DECIMAL(18,2) COMMENT 'The certified Safe Working Load capacity of the asset in metric tonnes. Applicable to cranes (STS, QC, MHC), RTG, ASC, and other lifting equipment. Defines the maximum load the equipment is certified to handle safely.',
    `useful_life_years` STRING COMMENT 'The estimated useful economic life of the asset in years, used for depreciation calculation and lifecycle planning.',
    `warranty_end_date` DATE COMMENT 'The date on which the manufacturer or vendor warranty coverage expires for the acquired asset.',
    `warranty_start_date` DATE COMMENT 'The date on which the manufacturer or vendor warranty coverage begins for the acquired asset.',
    `warranty_terms` STRING COMMENT 'Detailed description of the warranty coverage terms, including scope of coverage, exclusions, service level commitments, and claim procedures provided by the vendor.',
    CONSTRAINT pk_acquisition PRIMARY KEY(`acquisition_id`)
) COMMENT 'Records the procurement and commissioning lifecycle of new port assets from capital expenditure approval through to operational deployment. Captures CAPEX project reference, purchase order number, vendor/supplier name, acquisition date, acquisition cost, currency, funding source (own funds/loan/lease/PPP), commissioning date, warranty start and end dates, warranty terms, initial SWL certification date, and handover acceptance status. Integrates with SAP MM purchase orders and SAP FI-AA asset capitalisation. SSOT for asset acquisition history.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` (
    `disposal_id` BIGINT COMMENT 'Unique identifier for the asset disposal record. Primary key for the asset disposal entity.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Asset buyers (equipment brokers, scrap dealers, other port operators) must be registered port community participants for disposal authorization, asset removal from port facilities, environmental compl',
    `personnel_id` BIGINT COMMENT 'Foreign key linking to security.security_personnel. Business justification: Disposal of security equipment requires security officer authorization for chain of custody, data sanitization verification, and ISPS compliance. Operational requirement for decommissioning security-c',
    `port_asset_id` BIGINT COMMENT 'Reference to the port asset being disposed (crane, RTG, ASC, AGV, MHC, forklift, vehicle, or other equipment). Links to the asset registry master data.',
    `authorization_date` DATE COMMENT 'The date on which the disposal was formally authorized. Must precede or equal the disposal date.',
    `authorization_reference` STRING COMMENT 'Reference to the approval document, board resolution, or management authorization that approved the asset disposal. Required for governance and audit compliance.',
    `authorized_by` STRING COMMENT 'Name or identifier of the person or role who authorized the disposal (e.g., CFO, Asset Manager, Port Director). Part of the approval audit trail.',
    `contractor` STRING COMMENT 'Name of the third-party contractor or service provider who executed the physical disposal (scrap dealer, recycling company, transport company, or demolition contractor). Null if disposal handled internally.',
    `cost` DECIMAL(18,2) COMMENT 'The cost incurred to dispose of the asset, including dismantling, transport, environmental compliance, contractor fees, and disposal facility charges. Reduces net proceeds in financial analysis.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this disposal record was first created in the system. Part of the audit trail for data lineage and compliance.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the disposal proceeds and financial amounts (e.g., USD, EUR, GBP, AUD).. Valid values are `^[A-Z]{3}$`',
    `disposal_date` DATE COMMENT 'The date on which the asset was officially disposed, decommissioned, or transferred. Represents the principal business event timestamp for the disposal transaction.',
    `disposal_status` STRING COMMENT 'Current lifecycle status of the disposal transaction. Pending indicates awaiting approval; approved indicates authorized for disposal; in-progress indicates disposal activities underway; completed indicates disposal finalized; cancelled indicates disposal cancelled.. Valid values are `pending|approved|in-progress|completed|cancelled`',
    `environmental_compliance_flag` BOOLEAN COMMENT 'Indicates whether the disposal complied with environmental regulations including MARPOL (Marine Pollution Convention), hazardous waste disposal regulations, and local environmental laws. True indicates compliant disposal; false indicates non-compliance or pending investigation.',
    `environmental_disposal_certificate` STRING COMMENT 'Reference number or identifier of the environmental disposal certificate or hazardous waste manifest issued by regulatory authorities confirming compliant disposal of hazardous materials (e.g., oils, batteries, chemicals from port equipment).',
    `gain_loss` DECIMAL(18,2) COMMENT 'The financial gain (positive) or loss (negative) on disposal, calculated as disposal proceeds minus net book value. Impacts the income statement and is reported in financial accounting.',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the disposed asset contained hazardous materials requiring special handling and disposal procedures (e.g., hydraulic fluids, batteries, asbestos, refrigerants). True indicates hazardous materials present; false indicates non-hazardous.',
    `insurance_claim_reference` STRING COMMENT 'Reference number of the insurance claim if the disposal was due to insured damage or loss. Links disposal to Protection and Indemnity (P&I) or property insurance claims.',
    `last_modified_by` STRING COMMENT 'User identifier or name of the person who last modified the disposal record. Part of the audit trail for change tracking and accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this disposal record was last updated. Tracks changes to disposal status, financial amounts, or compliance documentation.',
    `location` STRING COMMENT 'The physical location where the asset was disposed (scrap yard, recycling facility, buyer location, or transfer destination). Includes facility name and address for audit trail.',
    `maximo_work_order_number` STRING COMMENT 'Reference to the Maximo Asset Management work order that executed the physical disposal activities (decommissioning, dismantling, removal, transport). Links disposal record to maintenance system of record.',
    `method` STRING COMMENT 'The method by which the asset was disposed. Scrap indicates physical destruction or recycling; sale indicates sold to third party; transfer indicates moved to another entity or division; donation indicates gifted; write-off indicates accounting removal without physical disposal; trade-in indicates exchanged as part of new asset acquisition.. Valid values are `scrap|sale|transfer|donation|write-off|trade-in`',
    `net_book_value` DECIMAL(18,2) COMMENT 'The carrying value of the asset on the balance sheet at the time of disposal, calculated as original cost less accumulated depreciation. Used to determine gain or loss on disposal.',
    `notes` STRING COMMENT 'Free-text field for additional comments, special circumstances, lessons learned, or operational notes related to the disposal. Used for knowledge management and continuous improvement.',
    `proceeds` DECIMAL(18,2) COMMENT 'The monetary amount received from the disposal of the asset (sale price, scrap value, or trade-in value). Zero for write-offs, donations, or transfers without consideration.',
    `reason` STRING COMMENT 'The business rationale for disposing the asset. End-of-life indicates asset reached end of useful life; obsolescence indicates technology or operational obsolescence; damage indicates irreparable damage; strategic-divestment indicates business strategy change; regulatory-compliance indicates disposal mandated by regulation; upgrade indicates replacement with newer equipment; redundancy indicates excess capacity. [ENUM-REF-CANDIDATE: end-of-life|obsolescence|damage|strategic-divestment|regulatory-compliance|upgrade|redundancy — 7 candidates stripped; promote to reference product]',
    `receiving_party_identifier` STRING COMMENT 'Business identifier for the receiving party (tax ID, company registration number, or internal customer/vendor code). Used for audit trail and compliance documentation.',
    `receiving_party_name` STRING COMMENT 'The name of the organization or individual who received the asset (buyer, transferee, or recipient). Applicable for sale, transfer, donation, or trade-in disposal methods. Null for scrap or write-off.',
    `reference_number` STRING COMMENT 'Business identifier for the disposal transaction, used for tracking and audit purposes. May align with SAP FI-AA retirement document number or Maximo work order reference.',
    `sap_fi_aa_document_number` STRING COMMENT 'The SAP FI-AA retirement document number that records the asset disposal transaction in the financial system. Links the physical disposal to the accounting system of record for asset retirement and financial reporting.',
    `created_by` STRING COMMENT 'User identifier or name of the person who created the disposal record. Part of the audit trail for accountability and data governance.',
    CONSTRAINT pk_disposal PRIMARY KEY(`disposal_id`)
) COMMENT 'Records the decommissioning, disposal, or transfer of port assets at end-of-life or upon strategic divestment. Captures disposal date, disposal method (scrap/sale/transfer/write-off), disposal proceeds, net book value at disposal, gain or loss on disposal, disposal authorisation reference, receiving party (if transferred or sold), environmental disposal compliance flag (MARPOL, hazardous waste regulations), and SAP FI-AA retirement document reference. Ensures complete asset lifecycle closure and regulatory compliance for equipment disposal.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` (
    `task_part_consumption_id` BIGINT COMMENT 'Unique identifier for this material consumption transaction. Primary key.',
    `employee_id` BIGINT COMMENT 'Reference to the warehouse or maintenance employee who issued the spare part. Provides accountability and audit trail for inventory transactions.',
    `spare_part_id` BIGINT COMMENT 'Foreign key linking to the spare part that was consumed in the maintenance task',
    `work_order_task_id` BIGINT COMMENT 'Foreign key linking to the maintenance task that consumed the spare part',
    `consumption_reason` STRING COMMENT 'Classification of why the spare part was consumed in this task. Supports maintenance analytics and parts usage pattern analysis.',
    `issue_timestamp` TIMESTAMP COMMENT 'Date and time when the spare part was issued from inventory for this maintenance task. Used for inventory transaction history and task timeline tracking.',
    `lot_number` STRING COMMENT 'Manufacturing lot or batch number of the consumed spare part. Required for traceability, quality control, and warranty claims.',
    `quantity_consumed` DECIMAL(18,2) COMMENT 'Quantity of the spare part consumed during this maintenance task. Used for inventory deduction and cost calculation.',
    `return_quantity` DECIMAL(18,2) COMMENT 'Quantity of the spare part returned to inventory if not fully consumed. Supports accurate inventory reconciliation and cost adjustment.',
    `return_timestamp` TIMESTAMP COMMENT 'Date and time when unused spare parts were returned to inventory. Used for inventory transaction completeness.',
    `serial_number` STRING COMMENT 'Serial number of the consumed spare part for serialized items. Enables individual part tracking for high-value or critical components.',
    `spare_parts_consumed` STRING COMMENT 'Comma-separated list of spare part references consumed during this task. Detailed part-level consumption is tracked in separate inventory transaction records. [Moved from work_order_task: This is a denormalized STRING field containing comma-separated part references. It should be replaced by the properly normalized task_part_consumption association table, which provides structured tracking of each part consumption with full transactional detail.]',
    `total_parts_cost` DECIMAL(18,2) COMMENT 'Total cost of all spare parts and materials consumed during this task. Aggregated from individual inventory transaction line items. [Moved from work_order_task: This aggregate cost should be calculated dynamically by summing (quantity_consumed * unit_cost_at_consumption) from the task_part_consumption association records, rather than stored redundantly on the work_order_task.]',
    `unit_cost_at_consumption` DECIMAL(18,2) COMMENT 'Unit cost of the spare part at the time of consumption. Captured for accurate cost accounting as part costs may fluctuate over time.',
    `warehouse_location_at_issue` STRING COMMENT 'Physical warehouse location (bin/rack/aisle) from which the part was issued. Supports inventory accuracy and picking efficiency analysis.',
    `warranty_claim_eligible` BOOLEAN COMMENT 'Indicates whether this part consumption is eligible for warranty claim or reimbursement. Used for warranty management and cost recovery.',
    CONSTRAINT pk_task_part_consumption PRIMARY KEY(`task_part_consumption_id`)
) COMMENT 'This association product represents the Material Consumption event between work_order_task and spare_part. It captures the issuance and consumption of spare parts during maintenance task execution for cost accounting, inventory management, warranty tracking, and regulatory compliance. Each record links one work_order_task to one spare_part with attributes that exist only in the context of this consumption transaction, including quantity consumed, unit cost at time of issue, lot/serial traceability, warehouse location, and issuing employee.. Existence Justification: In maritime port maintenance operations, a single maintenance task routinely consumes multiple spare parts (e.g., replacing hydraulic system components requires seals, hoses, fittings, and fluid), and a single spare part is consumed across many different maintenance tasks over time. The business actively manages each consumption transaction as a discrete inventory event with specific quantity, cost, lot/serial traceability, timestamp, and issuing employee for regulatory compliance, warranty claims, and cost accounting.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` (
    `plan_part_requirement_id` BIGINT COMMENT 'Unique identifier for this maintenance plan part requirement record. Primary key.',
    `maintenance_plan_id` BIGINT COMMENT 'Foreign key linking to the preventive maintenance plan that requires this spare part',
    `plan_spare_part_id` BIGINT COMMENT 'Foreign key linking to the spare part required by this maintenance plan',
    `spare_part_id` BIGINT COMMENT 'Reference to an alternative spare_part that can be used as a substitute if the primary part is unavailable. Supports flexible parts reservation. Identified in detection phase.',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this part requirement was added to the maintenance plan. Supports audit trail and BOM versioning.',
    `criticality_flag` BOOLEAN COMMENT 'Indicates whether this part is critical for the maintenance plan execution. Critical parts must be available before work order generation. Identified in detection phase.',
    `estimated_unit_cost` DECIMAL(18,2) COMMENT 'Estimated unit cost of this spare part at the time of maintenance plan creation. Used to calculate maintenance_plan.estimated_cost. May differ from current spare_part.unit_cost due to price changes. Identified in detection phase.',
    `last_updated_date` TIMESTAMP COMMENT 'Timestamp when this part requirement was last modified (quantity, criticality, or substitution changes). Supports change tracking.',
    `lead_time_days` STRING COMMENT 'Procurement lead time in days for this part in the context of this maintenance plan. May differ from spare_part.lead_time_days if expedited procurement is available for critical PM work. Identified in detection phase.',
    `notes` STRING COMMENT 'Free-text notes about this specific part requirement, such as special handling instructions, installation sequence, or OEM recommendations specific to this maintenance plan.',
    `required_quantity` DECIMAL(18,2) COMMENT 'Quantity of this spare part required to complete the maintenance plan. Used for parts reservation and inventory availability checking. Identified in detection phase.',
    `required_spare_parts` STRING COMMENT 'List of spare parts, consumables, and materials required for the maintenance tasks. May include part numbers, quantities, and specifications. Used for inventory planning and procurement. [Moved from maintenance_plan: This STRING field in maintenance_plan is a denormalized placeholder that lists spare parts in a comma-separated or text format. It should be replaced by the properly normalized plan_part_requirement association table, which provides structured, queryable, and relationship-specific data (quantities, criticality, costs) for each part requirement.]',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the required quantity (e.g., each, meter, liter). Must align with spare_part.unit_of_measure. Identified in detection phase.',
    CONSTRAINT pk_plan_part_requirement PRIMARY KEY(`plan_part_requirement_id`)
) COMMENT 'This association product represents the Bill of Materials (BOM) relationship between maintenance_plan and spare_part. It captures the specific parts required to execute a preventive maintenance plan, including quantities, criticality, and cost estimates. Each record links one maintenance_plan to one spare_part with attributes that exist only in the context of this planned maintenance requirement. Used for parts reservation, cost estimation, availability checking, and procurement planning.. Existence Justification: In maritime port operations, a preventive maintenance plan (e.g., quarterly STS crane inspection) requires multiple spare parts (hydraulic fluid, brake pads, filters, lubricants), and each spare part is used across multiple maintenance plans (brake pads are needed for STS crane PM, RTG PM, and MHC PM). The business actively manages this Bill of Materials relationship to auto-generate parts reservations when work orders are created, calculate plan costs, ensure parts availability before scheduling, and aggregate demand for procurement planning.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` (
    `inspection_checklist_id` BIGINT COMMENT 'Primary key for inspection_checklist',
    `equipment_class_id` BIGINT COMMENT 'add column equipment_class_id (BIGINT) with FK to asset.equipment_class.equipment_class_id - inspection checklists are designed for specific equipment classes and must reference them',
    `inspection_superseded_by_checklist_id` BIGINT COMMENT 'Reference to the newer inspection checklist version that replaces this one, enabling version lineage tracking and ensuring users are directed to current procedures.',
    `parent_inspection_checklist_id` BIGINT COMMENT 'Self-referencing FK on inspection_checklist (parent_inspection_checklist_id)',
    `applicable_regulation_code` STRING COMMENT 'Code or reference number of the regulatory standard, maritime convention, or port authority regulation that mandates or governs this inspection checklist (e.g., IMO SOLAS, OSHA 1910, local port authority codes).',
    `approved_by_name` STRING COMMENT 'Name of the authority (person, role, or department) who approved this inspection checklist for operational use, establishing accountability and governance.',
    `approved_date` DATE COMMENT 'Date on which this inspection checklist was formally approved for use, supporting audit trail and version control.',
    `asset_category` STRING COMMENT 'Category of port equipment or asset this checklist applies to: Ship-to-Shore (STS) crane, Quay Crane (QC), Rubber-Tired Gantry (RTG), Automated Stacking Crane (ASC), Automated Guided Vehicle (AGV), Mobile Harbor Crane (MHC), forklift, port vehicle, terminal equipment, or infrastructure.',
    `certification_required_flag` BOOLEAN COMMENT 'Indicates whether completion of this inspection checklist requires formal certification or sign-off by a qualified inspector, surveyor, or regulatory authority.',
    `checklist_code` STRING COMMENT 'Unique business identifier code for the inspection checklist, used for external reference and integration with maintenance management systems.',
    `checklist_description` STRING COMMENT 'Detailed description of the inspection checklist including its objectives, scope, and application context.',
    `checklist_name` STRING COMMENT 'Human-readable name of the inspection checklist describing its purpose and scope.',
    `checklist_type` STRING COMMENT 'Classification of the inspection checklist by maintenance strategy: preventive (scheduled), corrective (repair-driven), predictive (condition-based), statutory (regulatory compliance), safety (hazard assessment), or operational (pre-use verification).',
    `checklist_version` STRING COMMENT 'Version number of the inspection checklist following semantic versioning (major.minor), enabling version control and audit trail of checklist evolution.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this inspection checklist record was first created in the system, supporting audit trail and data lineage.',
    `digital_form_available_flag` BOOLEAN COMMENT 'Indicates whether a digital/mobile version of this inspection checklist is available for electronic data capture, enabling paperless inspections and real-time data integration.',
    `documentation_retention_years` STRING COMMENT 'Number of years that completed inspection records using this checklist must be retained for regulatory compliance, audit, and liability purposes.',
    `effective_from_date` DATE COMMENT 'Date from which this inspection checklist version becomes active and should be used for new inspections, supporting version control and regulatory compliance.',
    `effective_until_date` DATE COMMENT 'Date after which this inspection checklist version is no longer valid and should not be used for new inspections. Null indicates no expiration.',
    `equipment_class` STRING COMMENT 'Specific equipment class or model family this checklist is designed for, enabling targeted inspection procedures for equipment with similar characteristics.',
    `estimated_duration_minutes` STRING COMMENT 'Expected time in minutes required to complete the full inspection checklist, used for resource planning and scheduling.',
    `external_system_reference_code` STRING COMMENT 'Unique identifier of this checklist in the external maintenance management system, used for cross-system reconciliation and data lineage.',
    `inspection_frequency` STRING COMMENT 'Prescribed frequency at which this inspection checklist should be executed: daily, weekly, monthly, quarterly, semi-annual, annual, biennial, on-demand (event-triggered), or condition-based (sensor/threshold-driven).',
    `inspector_qualification_level` STRING COMMENT 'Minimum qualification or certification level required for personnel authorized to execute this inspection checklist: operator (basic trained), technician (skilled trades), certified inspector (formal certification), engineer (professional engineer), surveyor (third-party), or regulatory authority (government official).',
    `integration_system_code` STRING COMMENT 'Code identifying the external maintenance management system this checklist integrates with (e.g., Maximo, SAP PM), enabling bi-directional synchronization of inspection data.',
    `language_code` STRING COMMENT 'Three-letter ISO 639-2 language code indicating the language in which this checklist is written, supporting multilingual port operations and international workforce.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this inspection checklist record, enabling change tracking and version control.',
    `last_review_date` DATE COMMENT 'Date of the most recent review or assessment of this inspection checklist for continued relevance, accuracy, and regulatory alignment.',
    `mandatory_checkpoint_count` STRING COMMENT 'Number of checkpoints that must be completed for the inspection to be considered valid, distinguishing critical items from optional or conditional checks.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of this inspection checklist to ensure it remains current with equipment changes, regulatory updates, and operational best practices.',
    `pass_threshold_percentage` DECIMAL(18,2) COMMENT 'Minimum percentage of checkpoints that must pass for the overall inspection to be considered successful, expressed as a decimal (e.g., 95.00 for 95%).',
    `photo_evidence_required_flag` BOOLEAN COMMENT 'Indicates whether photographic evidence must be captured during inspection execution for documentation, compliance, or defect verification purposes.',
    `regulatory_requirement_flag` BOOLEAN COMMENT 'Indicates whether this inspection checklist is mandated by regulatory or statutory requirements (true) or is voluntary/internal best practice (false).',
    `safety_critical_flag` BOOLEAN COMMENT 'Indicates whether this checklist covers safety-critical systems or components where failure could result in injury, environmental harm, or catastrophic equipment damage.',
    `inspection_checklist_status` STRING COMMENT 'Current lifecycle status of the inspection checklist: draft (under development), active (approved for use), under review (being revised), superseded (replaced by newer version), or retired (no longer applicable).',
    `swl_verification_required_flag` BOOLEAN COMMENT 'Indicates whether this checklist includes verification of Safe Working Load (SWL) ratings for lifting equipment, a critical safety parameter for cranes and material handling equipment.',
    `total_checkpoint_count` STRING COMMENT 'Total number of individual inspection checkpoints or items included in this checklist, used for progress tracking and completeness validation.',
    CONSTRAINT pk_inspection_checklist PRIMARY KEY(`inspection_checklist_id`)
) COMMENT 'Master reference table for inspection_checklist. Referenced by inspection_checklist_id.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` (
    `work_order_template_id` BIGINT COMMENT 'Primary key for work_order_template',
    `equipment_type_id` BIGINT COMMENT 'Reference to the specific equipment type that this work order template is designed for.',
    `parent_work_order_template_id` BIGINT COMMENT 'Self-referencing FK on work_order_template (parent_work_order_template_id)',
    `approval_required` BOOLEAN COMMENT 'Indicates whether work orders generated from this template require management approval before execution.',
    `approved_by` STRING COMMENT 'Name or identifier of the authorized person who approved the work order template for operational use.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the work order template was approved for operational use.',
    `asset_class` STRING COMMENT 'Classification of port equipment and assets that this work order template applies to, including Ship-to-Shore (STS) cranes, Rubber Tyred Gantry (RTG), Automated Stacking Crane (ASC), Automated Guided Vehicle (AGV), Mobile Harbor Crane (MHC), and other terminal equipment.',
    `compliance_standard` STRING COMMENT 'Regulatory or industry standards that this work order template is designed to satisfy, such as ISO, OSHA, or port authority requirements.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the work order template record was first created in the system.',
    `downtime_required` BOOLEAN COMMENT 'Indicates whether the asset must be taken out of service to execute the work order.',
    `effective_date` DATE COMMENT 'Date from which this work order template version becomes active and available for generating work orders.',
    `estimated_cost` DECIMAL(18,2) COMMENT 'Standard estimated total cost for executing the work order including labor, materials, and overhead. Currency is USD as the business operates primarily in US dollar markets.',
    `estimated_duration_hours` DECIMAL(18,2) COMMENT 'Standard estimated time in hours required to complete the work order based on historical performance data.',
    `estimated_labor_hours` DECIMAL(18,2) COMMENT 'Total estimated labor hours required across all technicians and trades to complete the work order.',
    `expiration_date` DATE COMMENT 'Date after which this work order template version is no longer valid and should not be used for generating new work orders.',
    `frequency_interval` STRING COMMENT 'Numeric value representing the interval between scheduled occurrences of this work order template for preventive maintenance.',
    `frequency_unit` STRING COMMENT 'Unit of measure for the frequency interval, supporting time-based and usage-based maintenance scheduling.',
    `inspection_checklist` STRING COMMENT 'Structured checklist of inspection points, measurements, and acceptance criteria to be completed during work order execution.',
    `last_review_date` DATE COMMENT 'Date when the work order template was last reviewed and validated for accuracy and completeness.',
    `lockout_tagout_required` BOOLEAN COMMENT 'Indicates whether lockout/tagout procedures are required for safe execution of this work order template.',
    `maintenance_category` STRING COMMENT 'Technical discipline or trade category required to execute the work order template.',
    `modified_by` STRING COMMENT 'Name or identifier of the user or system that last modified the work order template.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the work order template record was last updated in the system.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review and update of the work order template.',
    `notes` STRING COMMENT 'Additional notes, comments, or special instructions related to the work order template that do not fit in other structured fields.',
    `permit_required` BOOLEAN COMMENT 'Indicates whether a work permit or hot work permit is required before executing work orders generated from this template.',
    `priority_level` STRING COMMENT 'Default priority level assigned to work orders generated from this template, indicating urgency and resource allocation requirements.',
    `required_crew_size` STRING COMMENT 'Number of technicians or crew members required to safely and efficiently execute the work order.',
    `required_skills` STRING COMMENT 'Comma-separated list of technical skills, certifications, or qualifications required for technicians executing this work order.',
    `required_tools` STRING COMMENT 'List of specialized tools, equipment, or test instruments required to execute the work order.',
    `responsible_department` STRING COMMENT 'Department or functional area responsible for executing work orders generated from this template.',
    `safety_critical_flag` BOOLEAN COMMENT 'Indicates whether this work order template addresses safety-critical systems or components that directly impact personnel safety or operational safety.',
    `spare_parts_list` STRING COMMENT 'List of spare parts, consumables, and materials typically required for this work order template.',
    `swl_verification_required` BOOLEAN COMMENT 'Indicates whether this work order template requires verification or recertification of Safe Working Load ratings for lifting equipment.',
    `task_list` STRING COMMENT 'Detailed step-by-step task instructions and procedures to be followed when executing work orders from this template.',
    `template_code` STRING COMMENT 'Unique business identifier code for the work order template used for external reference and system integration.',
    `template_description` STRING COMMENT 'Detailed description of the work order template including scope, objectives, and expected outcomes of the maintenance activity.',
    `template_name` STRING COMMENT 'Human-readable name of the work order template describing the maintenance or repair activity.',
    `template_status` STRING COMMENT 'Current lifecycle status of the work order template indicating whether it is available for use in generating work orders.',
    `version_number` STRING COMMENT 'Version number of the work order template to track revisions and updates to procedures and task lists.',
    `work_order_type` STRING COMMENT 'Classification of the work order template by maintenance strategy type.',
    `created_by` STRING COMMENT 'Name or identifier of the user or system that created the work order template.',
    CONSTRAINT pk_work_order_template PRIMARY KEY(`work_order_template_id`)
) COMMENT 'Master reference table for work_order_template. Referenced by work_order_template_id.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` (
    `asset_location_id` BIGINT COMMENT 'Unique identifier for each asset location assignment record. Primary key. Inferred role: TRANSACTION_HEADER (each location assignment is a discrete business event with lifecycle). This entity tracks location assignment events for port assets.',
    `port_asset_id` BIGINT COMMENT 'Reference to the port asset being located or transferred. Links to the asset registry for equipment such as Ship-to-Shore (STS) cranes, Rubber Tyred Gantry (RTG) cranes, Automated Stacking Cranes (ASC), Automated Guided Vehicles (AGV), Mobile Harbour Cranes (MHC), forklifts, and port vehicles.',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Asset location assignments must reference security zone for access control enforcement, patrol planning, and MARSEC-level restrictions. Operational requirement for security personnel dispatch and cred',
    `access_restriction_level` STRING COMMENT 'Level of access control required for personnel and equipment entering this location. Public for unrestricted areas; authorized for credentialed staff; escort required for visitor areas; permit only for special authorization zones; emergency only for restricted emergency access.. Valid values are `public|authorized|escort_required|permit_only|emergency_only`',
    `assignment_number` STRING COMMENT 'Externally-known business identifier for this location assignment event. Used for tracking and audit purposes across NAVIS N4 and TOPS Expert systems.. Valid values are `^[A-Z0-9]{8,20}$`',
    `assignment_priority` STRING COMMENT 'Business priority level for this location assignment. Critical for emergency response or safety-critical equipment; high for revenue-generating operations; medium for routine redeployment; low for optimization or non-urgent transfers.. Valid values are `critical|high|medium|low`',
    `assignment_status` STRING COMMENT 'Current lifecycle state of the location assignment. Active indicates the asset is currently deployed at this location; pending indicates scheduled future assignment; completed indicates historical assignment; cancelled indicates assignment was revoked; suspended indicates temporary hold.. Valid values are `active|pending|completed|cancelled|suspended`',
    `assignment_timestamp` TIMESTAMP COMMENT 'Precise date and time when the location assignment was executed or recorded in the Terminal Operating System (TOS). Principal business event timestamp for this location assignment transaction.',
    `authorizing_officer` STRING COMMENT 'Name or identifier of the port authority officer, terminal manager, or operations supervisor who approved the asset location assignment or transfer. Used for accountability and audit trail.',
    `berth_code` STRING COMMENT 'Identifier for the specific berth where the asset is assigned, if applicable. Relevant for quayside equipment such as Ship-to-Shore (STS) cranes and Quay Cranes (QC). Null for non-berth locations.. Valid values are `^[A-Z0-9]{2,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this asset location assignment record was first created in the system. Audit trail timestamp for record creation.',
    `destination_cost_centre` STRING COMMENT 'Financial cost centre code to which the asset is being assigned. Used for inter-departmental cost allocation and Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) tracking in SAP S/4HANA Controlling (CO) module.. Valid values are `^[A-Z0-9]{4,12}$`',
    `dispatch_order_number` STRING COMMENT 'Reference number of the equipment dispatch order that initiated this location assignment. Links to NAVIS N4 or TOPS Expert dispatch management for operational coordination.. Valid values are `^[A-Z0-9]{8,20}$`',
    `distance_from_previous_location_m` DECIMAL(18,2) COMMENT 'Physical distance in meters between the previous location and current location. Used for transfer cost estimation, fuel consumption tracking, and logistics planning.',
    `effective_from_date` DATE COMMENT 'Date when the asset location assignment becomes effective. Marks the start of the assets deployment at this location. Used for historical tracking and yard planning.',
    `effective_to_date` DATE COMMENT 'Date when the asset location assignment ends or is scheduled to end. Null for current active assignments. Used for transfer planning and historical analysis.',
    `environmental_zone` STRING COMMENT 'Environmental classification of the location area. Standard for normal operations; controlled emission for Greenhouse Gas (GHG) monitoring zones; noise restricted for residential proximity; hazmat for International Maritime Dangerous Goods (IMDG) handling; marine protected for environmentally sensitive areas per Marine Pollution Convention (MARPOL).. Valid values are `standard|controlled_emission|noise_restricted|hazmat|marine_protected`',
    `gps_latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the asset location in decimal degrees. Supports real-time equipment positioning and dispatch routing. Integrates with Vessel Traffic Management System (VTMS) and Terminal Operating System (TOS).',
    `gps_longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the asset location in decimal degrees. Supports real-time equipment positioning and dispatch routing. Integrates with Vessel Traffic Management System (VTMS) and Terminal Operating System (TOS).',
    `is_temporary_assignment` BOOLEAN COMMENT 'Flag indicating whether this location assignment is temporary (True) or permanent (False). Temporary assignments are typically for short-term operational needs, maintenance, or project work.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this asset location assignment record was most recently modified. Audit trail timestamp for record updates.',
    `load_bearing_capacity_tonnes` DECIMAL(18,2) COMMENT 'Maximum load bearing capacity of the location surface in metric tonnes. Critical for ensuring Safe Working Load (SWL) compliance when deploying heavy equipment such as Mobile Harbour Cranes (MHC), Rubber Tyred Gantry (RTG) cranes, or loaded vehicles.',
    `location_code` STRING COMMENT 'Standardized alphanumeric code identifying the specific physical location within the terminal footprint. May represent berth, quay zone, yard block, Container Yard (CY), maintenance bay, or equipment staging area.. Valid values are `^[A-Z0-9-]{4,15}$`',
    `location_name` STRING COMMENT 'Human-readable name or description of the physical location where the asset is deployed. Examples: Berth 5 North, Yard Block A3, Maintenance Bay 2, Quay Crane Rail 7.',
    `network_connectivity_available` BOOLEAN COMMENT 'Flag indicating whether data network connectivity (wired or wireless) is available at this location (True) or not (False). Required for Radio Frequency Identification (RFID) tracking, Terminal Operating System (TOS) integration, and real-time equipment monitoring.',
    `next_scheduled_location_code` STRING COMMENT 'Location code where the asset is scheduled to be transferred next. Null if no future transfer is planned. Supports forward planning and equipment dispatch optimization.. Valid values are `^[A-Z0-9-]{4,15}$`',
    `notes` STRING COMMENT 'Free-text field for additional comments, special instructions, operational notes, or contextual information related to this asset location assignment. Used for communication between operations, maintenance, and planning teams.',
    `operational_area` STRING COMMENT 'Functional designation of the operational area where the asset is deployed. Container terminal for Twenty-foot Equivalent Unit (TEU) / Forty-foot Equivalent Unit (FEU) handling; bulk cargo for dry/liquid bulk; Roll-on Roll-off (RoRo) for vehicle shipping; general cargo for break-bulk; intermodal for rail/road transfer; maintenance depot for repair facilities; administration for support functions. [ENUM-REF-CANDIDATE: container_terminal|bulk_cargo|roro|general_cargo|intermodal|maintenance_depot|administration — 7 candidates stripped; promote to reference product]',
    `originating_cost_centre` STRING COMMENT 'Financial cost centre code from which the asset is being transferred. Used for inter-departmental cost allocation and Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) tracking in SAP S/4HANA Controlling (CO) module.. Valid values are `^[A-Z0-9]{4,12}$`',
    `power_supply_available` BOOLEAN COMMENT 'Flag indicating whether electrical power supply infrastructure is available at this location (True) or not (False). Relevant for electrically-powered equipment such as Ship-to-Shore (STS) cranes, Automated Stacking Cranes (ASC), and charging stations for Automated Guided Vehicles (AGV).',
    `previous_location_code` STRING COMMENT 'Location code where the asset was deployed immediately prior to this assignment. Null for initial deployment. Supports transfer history tracking and equipment movement analysis.. Valid values are `^[A-Z0-9-]{4,15}$`',
    `safety_zone_classification` STRING COMMENT 'Safety and security classification of the location area. Unrestricted for general access; restricted for authorized personnel only; hazardous for dangerous goods areas; International Ship and Port Facility Security (ISPS) controlled for security zones; confined space for Occupational Health and Safety (OHS) regulated areas.. Valid values are `unrestricted|restricted|hazardous|isps_controlled|confined_space`',
    `surface_type` STRING COMMENT 'Physical surface type of the location area. Concrete for paved quay and yard; asphalt for roadways; gravel for unpaved areas; rail for rail-mounted equipment zones; water for floating equipment; mixed for composite surfaces. Relevant for equipment compatibility and Safe Working Load (SWL) considerations.. Valid values are `concrete|asphalt|gravel|rail|water|mixed`',
    `terminal_zone` STRING COMMENT 'High-level operational area designation within the port terminal. Quayside for berth and crane operations; yard for container stacking; gate for entry/exit; maintenance for repair facilities; intermodal for rail/road transfer; storage for warehousing; administration for office areas. [ENUM-REF-CANDIDATE: quayside|yard|gate|maintenance|intermodal|storage|administration — 7 candidates stripped; promote to reference product]',
    `transfer_description` STRING COMMENT 'Detailed narrative explanation of the location assignment or transfer, including context, operational requirements, and any special instructions for equipment dispatch or maintenance crew routing.',
    `transfer_duration_hours` DECIMAL(18,2) COMMENT 'Actual or estimated time in hours required to physically relocate the asset from the previous location to the current location. Includes mobilization, transit, and positioning time.',
    `transfer_reason` STRING COMMENT 'Business justification for the asset location assignment or transfer. Operational demand for workload balancing; maintenance for scheduled service; breakdown for repair; redeployment for strategic repositioning; seasonal for peak period adjustments; project for infrastructure work; emergency for incident response; optimization for efficiency improvement. [ENUM-REF-CANDIDATE: operational_demand|maintenance|breakdown|redeployment|seasonal|project|emergency|optimization — 8 candidates stripped; promote to reference product]',
    `work_order_number` STRING COMMENT 'Reference number of the maintenance work order associated with this location assignment, if the transfer is for maintenance purposes. Links to Maximo Asset Management or SAP PM work order system.. Valid values are `^[A-Z0-9]{8,20}$`',
    `yard_block` STRING COMMENT 'Identifier for the yard block or stacking area where the asset is deployed. Relevant for Rubber Tyred Gantry (RTG) cranes, Automated Stacking Cranes (ASC), and yard handling equipment. Null for non-yard locations.. Valid values are `^[A-Z0-9]{2,8}$`',
    CONSTRAINT pk_asset_location PRIMARY KEY(`asset_location_id`)
) COMMENT 'SSOT for the physical deployment and transfer history of each port asset within the terminal footprint. Records every location assignment and inter-zone transfer as a time-stamped event, capturing assigned berth, quay zone, yard block, terminal area, or maintenance bay, along with location code, terminal zone, GPS coordinates, effective assignment date, transfer reason, authorising officer, originating and destination cost centres, and operational area designation. Subsumes all asset relocation and transfer tracking. Supports yard planning, equipment dispatch, maintenance crew routing, and cost centre reallocation. Integrates with NAVIS N4 and TOPS Expert for real-time equipment positioning.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_parent_asset_port_asset_id` FOREIGN KEY (`parent_asset_port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ADD CONSTRAINT `fk_asset_swl_certificate_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ADD CONSTRAINT `fk_asset_depreciation_schedule_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_work_order_template_id` FOREIGN KEY (`work_order_template_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order_template`(`work_order_template_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ADD CONSTRAINT `fk_asset_work_order_task_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_previous_failure_report_id` FOREIGN KEY (`previous_failure_report_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`failure_report`(`failure_report_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ADD CONSTRAINT `fk_asset_downtime_record_failure_report_id` FOREIGN KEY (`failure_report_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`failure_report`(`failure_report_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ADD CONSTRAINT `fk_asset_downtime_record_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ADD CONSTRAINT `fk_asset_downtime_record_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_inspection_checklist_id` FOREIGN KEY (`inspection_checklist_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`inspection_checklist`(`inspection_checklist_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_swl_certificate_id` FOREIGN KEY (`swl_certificate_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`swl_certificate`(`swl_certificate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ADD CONSTRAINT `fk_asset_spare_part_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ADD CONSTRAINT `fk_asset_meter_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ADD CONSTRAINT `fk_asset_meter_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ADD CONSTRAINT `fk_asset_acquisition_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ADD CONSTRAINT `fk_asset_disposal_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ADD CONSTRAINT `fk_asset_task_part_consumption_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`spare_part`(`spare_part_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ADD CONSTRAINT `fk_asset_task_part_consumption_work_order_task_id` FOREIGN KEY (`work_order_task_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order_task`(`work_order_task_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ADD CONSTRAINT `fk_asset_plan_part_requirement_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ADD CONSTRAINT `fk_asset_plan_part_requirement_plan_spare_part_id` FOREIGN KEY (`plan_spare_part_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`spare_part`(`spare_part_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ADD CONSTRAINT `fk_asset_plan_part_requirement_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`spare_part`(`spare_part_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ADD CONSTRAINT `fk_asset_inspection_checklist_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ADD CONSTRAINT `fk_asset_inspection_checklist_inspection_superseded_by_checklist_id` FOREIGN KEY (`inspection_superseded_by_checklist_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`inspection_checklist`(`inspection_checklist_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ADD CONSTRAINT `fk_asset_inspection_checklist_parent_inspection_checklist_id` FOREIGN KEY (`parent_inspection_checklist_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`inspection_checklist`(`inspection_checklist_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ADD CONSTRAINT `fk_asset_work_order_template_parent_work_order_template_id` FOREIGN KEY (`parent_work_order_template_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order_template`(`work_order_template_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ADD CONSTRAINT `fk_asset_asset_location_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`asset` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`asset` SET TAGS ('dbx_domain' = 'asset');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `equipment_class_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Owning Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `parent_asset_port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Asset Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ALTER COLUMN `material_group_id` SET TAGS ('dbx_business_glossary_term' = 'Material Group Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `swl_certificate_id` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) Certificate ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `compliance_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `applicable_standard` SET TAGS ('dbx_business_glossary_term' = 'Applicable Standard');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `certificate_document_url` SET TAGS ('dbx_business_glossary_term' = 'Certificate Document URL');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `certificate_status` SET TAGS ('dbx_business_glossary_term' = 'Certificate Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `certificate_status` SET TAGS ('dbx_value_regex' = 'Valid|Expired|Suspended|Revoked|Pending Renewal');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `equipment_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `inspection_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency in Months');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `renewal_notification_sent_date` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notification Sent Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `surveyor_license_number` SET TAGS ('dbx_business_glossary_term' = 'Surveyor License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `surveyor_name` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `swl_rating_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) Rating in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `test_date` SET TAGS ('dbx_business_glossary_term' = 'Test Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `test_load_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Test Load in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `test_location` SET TAGS ('dbx_business_glossary_term' = 'Test Location');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `test_method` SET TAGS ('dbx_business_glossary_term' = 'Test Method');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `test_method` SET TAGS ('dbx_value_regex' = 'Static Load Test|Dynamic Load Test|Non-Destructive Testing|Visual Inspection|Combined');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `test_result` SET TAGS ('dbx_business_glossary_term' = 'Test Result');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ALTER COLUMN `test_result` SET TAGS ('dbx_value_regex' = 'Pass|Fail|Conditional Pass');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciation_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `accumulated_depreciation` SET TAGS ('dbx_business_glossary_term' = 'Accumulated Depreciation');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `annual_depreciation_amount` SET TAGS ('dbx_business_glossary_term' = 'Annual Depreciation Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `appraiser_name` SET TAGS ('dbx_business_glossary_term' = 'Appraiser Name');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `appraiser_reference` SET TAGS ('dbx_business_glossary_term' = 'Appraiser Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `asset_retirement_obligation` SET TAGS ('dbx_business_glossary_term' = 'Asset Retirement Obligation (ARO)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciable_amount` SET TAGS ('dbx_business_glossary_term' = 'Depreciable Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciation_area` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Area');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciation_area` SET TAGS ('dbx_value_regex' = 'book|tax|ifrs|group|cost_accounting|consolidated');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciation_end_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|double_declining_balance|units_of_production|sum_of_years_digits|accelerated');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciation_percentage` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciation_run_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Run Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciation_status` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `depreciation_status` SET TAGS ('dbx_value_regex' = 'active|suspended|completed|reversed|adjusted');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `impairment_date` SET TAGS ('dbx_business_glossary_term' = 'Impairment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `impairment_indicator` SET TAGS ('dbx_business_glossary_term' = 'Impairment Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `impairment_loss` SET TAGS ('dbx_business_glossary_term' = 'Impairment Loss');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `net_book_value` SET TAGS ('dbx_business_glossary_term' = 'Net Book Value (NBV)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Schedule Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `period_depreciation_amount` SET TAGS ('dbx_business_glossary_term' = 'Period Depreciation Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `residual_value` SET TAGS ('dbx_business_glossary_term' = 'Residual Value');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `revaluation_date` SET TAGS ('dbx_business_glossary_term' = 'Revaluation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `revaluation_surplus` SET TAGS ('dbx_business_glossary_term' = 'Revaluation Surplus');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `sap_asset_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Asset Accounting Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `useful_life_units` SET TAGS ('dbx_business_glossary_term' = 'Useful Life (Units)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life (Years)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `valuation_amount` SET TAGS ('dbx_business_glossary_term' = 'Valuation Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `valuation_date` SET TAGS ('dbx_business_glossary_term' = 'Valuation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `valuation_type` SET TAGS ('dbx_business_glossary_term' = 'Valuation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ALTER COLUMN `valuation_type` SET TAGS ('dbx_value_regex' = 'book_value|fair_market_value|insurance_replacement_value|liquidation_value|appraisal_value');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Last Completed Work Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Security Personnel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Planner ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `risk_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `work_order_template_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Template ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ALTER COLUMN `asset_class` SET TAGS ('dbx_business_glossary_term' = 'Asset Class');
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
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `compliance_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `procurement_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Security Personnel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Supervisor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `terminal_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Equipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `tertiary_work_approved_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `tertiary_work_approved_by_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `tertiary_work_approved_by_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `tug_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Crew ID');
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
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Technician ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
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
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `vendor_service_provider` SET TAGS ('dbx_business_glossary_term' = 'Vendor Service Provider');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ALTER COLUMN `warranty_claim_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `failure_report_id` SET TAGS ('dbx_business_glossary_term' = 'Failure Report ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `violation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Violation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `ohs_incident_id` SET TAGS ('dbx_business_glossary_term' = 'OHS (Occupational Health and Safety) Incident ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `previous_failure_report_id` SET TAGS ('dbx_business_glossary_term' = 'Previous Failure Report ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reported By Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ALTER COLUMN `terminal_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Equipment Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `downtime_record_id` SET TAGS ('dbx_business_glossary_term' = 'Downtime Record ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `failure_report_id` SET TAGS ('dbx_business_glossary_term' = 'Failure Report ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reported By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `terminal_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Equipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `tertiary_downtime_approved_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `tertiary_downtime_approved_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `tertiary_downtime_approved_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `tug_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `acknowledged_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Acknowledged Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `affected_berth` SET TAGS ('dbx_business_glossary_term' = 'Affected Berth');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `affected_terminal` SET TAGS ('dbx_business_glossary_term' = 'Affected Terminal');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `corrective_action_taken` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `downtime_category` SET TAGS ('dbx_business_glossary_term' = 'Downtime Category');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `downtime_category` SET TAGS ('dbx_value_regex' = 'planned_maintenance|unplanned_breakdown|operational_standby|weather_hold|regulatory_inspection|operator_unavailable');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `downtime_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Downtime Duration Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `downtime_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Downtime End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `downtime_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Downtime Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `downtime_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Downtime Reason Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `downtime_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Downtime Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `downtime_status` SET TAGS ('dbx_business_glossary_term' = 'Downtime Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `downtime_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|resolved|closed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `is_current_record` SET TAGS ('dbx_business_glossary_term' = 'Is Current Record');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `is_regulatory_reportable` SET TAGS ('dbx_business_glossary_term' = 'Is Regulatory Reportable');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `is_safety_related` SET TAGS ('dbx_business_glossary_term' = 'Is Safety Related');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `maintenance_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Cost Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `maintenance_cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `mtbf_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'MTBF (Mean Time Between Failures) Impact Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `mttr_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'MTTR (Mean Time To Repair) Impact Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `oee_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'OEE (Overall Equipment Effectiveness) Impact Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `operational_impact_teu` SET TAGS ('dbx_business_glossary_term' = 'Operational Impact TEU (Twenty-foot Equivalent Unit)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `operational_impact_vessel_moves` SET TAGS ('dbx_business_glossary_term' = 'Operational Impact Vessel Moves');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `preventive_action_recommended` SET TAGS ('dbx_business_glossary_term' = 'Preventive Action Recommended');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `record_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Record Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `record_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Record Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `reported_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Reported Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `resolution_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Resolution Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `responsible_party` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `responsible_party` SET TAGS ('dbx_value_regex' = 'internal_maintenance|external_contractor|equipment_manufacturer|operator_error|force_majeure|third_party_damage');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'SLA (Service Level Agreement) Breach Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `source_record_reference` SET TAGS ('dbx_business_glossary_term' = 'Source Record ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `spare_parts_used` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Used');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ALTER COLUMN `weather_condition` SET TAGS ('dbx_business_glossary_term' = 'Weather Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_record_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Record Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `compliance_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `inspection_checklist_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Checklist Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Security Personnel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `service_entry_sheet_id` SET TAGS ('dbx_business_glossary_term' = 'Service Entry Sheet Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `swl_certificate_id` SET TAGS ('dbx_business_glossary_term' = 'Swl Certificate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `terminal_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Equipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ALTER COLUMN `tug_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` SET TAGS ('dbx_subdomain' = 'parts_supply');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `equipment_class_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Material Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `warehouse_code` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period in Months');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` SET TAGS ('dbx_subdomain' = 'parts_supply');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `meter_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Meter ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Technician ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `terminal_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Equipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `tug_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `alert_generated_flag` SET TAGS ('dbx_business_glossary_term' = 'Alert Generated Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `alert_threshold` SET TAGS ('dbx_business_glossary_term' = 'Meter Alert Threshold');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `cumulative_total` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Meter Total');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `current_reading` SET TAGS ('dbx_business_glossary_term' = 'Current Meter Reading');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `data_quality_score` SET TAGS ('dbx_business_glossary_term' = 'Data Quality Score');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `incremental_usage` SET TAGS ('dbx_business_glossary_term' = 'Incremental Usage');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `meter_type` SET TAGS ('dbx_business_glossary_term' = 'Meter Type');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `meter_type` SET TAGS ('dbx_value_regex' = 'operating_hours|lift_cycles|distance_travelled|load_cycles|fuel_consumption|engine_hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `next_pm_threshold` SET TAGS ('dbx_business_glossary_term' = 'Next Preventive Maintenance (PM) Threshold');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `pm_interval` SET TAGS ('dbx_business_glossary_term' = 'Preventive Maintenance (PM) Interval');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `previous_reading` SET TAGS ('dbx_business_glossary_term' = 'Previous Meter Reading');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `reading_accuracy` SET TAGS ('dbx_business_glossary_term' = 'Meter Reading Accuracy');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `reading_accuracy` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `reading_date` SET TAGS ('dbx_business_glossary_term' = 'Meter Reading Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `reading_method` SET TAGS ('dbx_business_glossary_term' = 'Meter Reading Method');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `reading_method` SET TAGS ('dbx_value_regex' = 'direct_observation|remote_telemetry|system_integration|estimated|interpolated');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `reading_notes` SET TAGS ('dbx_business_glossary_term' = 'Meter Reading Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `reading_source` SET TAGS ('dbx_business_glossary_term' = 'Meter Reading Source');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `reading_source` SET TAGS ('dbx_value_regex' = 'manual|automated|iot_sensor|telematics|scada');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `reading_status` SET TAGS ('dbx_business_glossary_term' = 'Meter Reading Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `reading_status` SET TAGS ('dbx_value_regex' = 'valid|invalid|estimated|adjusted|pending_verification');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `rollover_count` SET TAGS ('dbx_business_glossary_term' = 'Meter Rollover Count');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `rollover_flag` SET TAGS ('dbx_business_glossary_term' = 'Meter Rollover Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `sensor_code` SET TAGS ('dbx_business_glossary_term' = 'Sensor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `source_record_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `unit` SET TAGS ('dbx_business_glossary_term' = 'Meter Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `unit` SET TAGS ('dbx_value_regex' = 'hours|cycles|kilometers|meters|liters|gallons');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `usage_rate_per_day` SET TAGS ('dbx_business_glossary_term' = 'Average Usage Rate per Day');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ALTER COLUMN `variance_from_expected` SET TAGS ('dbx_business_glossary_term' = 'Variance from Expected Reading');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `acquisition_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Acquisition Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Manager Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `risk_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `acceptance_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `acceptance_certificate_number` SET TAGS ('dbx_value_regex' = '^AC[0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `asset_class_code` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `asset_class_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `asset_location_code` SET TAGS ('dbx_business_glossary_term' = 'Asset Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `asset_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `capitalization_date` SET TAGS ('dbx_business_glossary_term' = 'Capitalization Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|units_of_production|sum_of_years_digits');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `funding_source` SET TAGS ('dbx_business_glossary_term' = 'Funding Source');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `funding_source` SET TAGS ('dbx_value_regex' = 'own_funds|bank_loan|lease|public_private_partnership|government_grant|bond_issuance');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `handover_acceptance_date` SET TAGS ('dbx_business_glossary_term' = 'Handover Acceptance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `handover_acceptance_status` SET TAGS ('dbx_business_glossary_term' = 'Handover Acceptance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `handover_acceptance_status` SET TAGS ('dbx_value_regex' = 'pending_inspection|conditionally_accepted|fully_accepted|rejected|under_remediation');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `initial_swl_certification_date` SET TAGS ('dbx_business_glossary_term' = 'Initial Safe Working Load (SWL) Certification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `installation_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Installation Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `installation_contractor_name` SET TAGS ('dbx_business_glossary_term' = 'Installation Contractor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `installation_contractor_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `installation_contractor_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `insurance_coverage_amount` SET TAGS ('dbx_business_glossary_term' = 'Insurance Coverage Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_value_regex' = '^PO[0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `residual_value` SET TAGS ('dbx_business_glossary_term' = 'Residual Value');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `swl_rating_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) Rating in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life in Years');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ALTER COLUMN `warranty_terms` SET TAGS ('dbx_business_glossary_term' = 'Warranty Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `disposal_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Disposal Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Security Personnel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `authorization_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `authorization_reference` SET TAGS ('dbx_business_glossary_term' = 'Authorization Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `authorized_by` SET TAGS ('dbx_business_glossary_term' = 'Authorized By');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `contractor` SET TAGS ('dbx_business_glossary_term' = 'Disposal Contractor');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `cost` SET TAGS ('dbx_business_glossary_term' = 'Disposal Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `disposal_date` SET TAGS ('dbx_business_glossary_term' = 'Disposal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `disposal_status` SET TAGS ('dbx_business_glossary_term' = 'Disposal Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `disposal_status` SET TAGS ('dbx_value_regex' = 'pending|approved|in-progress|completed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `environmental_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `environmental_disposal_certificate` SET TAGS ('dbx_business_glossary_term' = 'Environmental Disposal Certificate');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `gain_loss` SET TAGS ('dbx_business_glossary_term' = 'Disposal Gain or Loss');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `gain_loss` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `insurance_claim_reference` SET TAGS ('dbx_business_glossary_term' = 'Insurance Claim Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `insurance_claim_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `location` SET TAGS ('dbx_business_glossary_term' = 'Disposal Location');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `maximo_work_order_number` SET TAGS ('dbx_business_glossary_term' = 'Maximo Work Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `method` SET TAGS ('dbx_business_glossary_term' = 'Disposal Method');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `method` SET TAGS ('dbx_value_regex' = 'scrap|sale|transfer|donation|write-off|trade-in');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `net_book_value` SET TAGS ('dbx_business_glossary_term' = 'Net Book Value (NBV)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `net_book_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Disposal Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `proceeds` SET TAGS ('dbx_business_glossary_term' = 'Disposal Proceeds');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `proceeds` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `reason` SET TAGS ('dbx_business_glossary_term' = 'Disposal Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `receiving_party_identifier` SET TAGS ('dbx_business_glossary_term' = 'Receiving Party Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `receiving_party_identifier` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `receiving_party_name` SET TAGS ('dbx_business_glossary_term' = 'Receiving Party Name');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `receiving_party_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Disposal Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `sap_fi_aa_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Financial Accounting Asset Accounting (FI-AA) Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` SET TAGS ('dbx_subdomain' = 'parts_supply');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` SET TAGS ('dbx_association_edges' = 'asset.work_order_task,asset.spare_part');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `task_part_consumption_id` SET TAGS ('dbx_business_glossary_term' = 'Task Part Consumption ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Issued By Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Task Part Consumption - Spare Part Id');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `work_order_task_id` SET TAGS ('dbx_business_glossary_term' = 'Task Part Consumption - Work Order Task Id');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `consumption_reason` SET TAGS ('dbx_business_glossary_term' = 'Consumption Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `issue_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Issue Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `quantity_consumed` SET TAGS ('dbx_business_glossary_term' = 'Quantity Consumed');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `return_quantity` SET TAGS ('dbx_business_glossary_term' = 'Return Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `return_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Return Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `spare_parts_consumed` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Consumed');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `total_parts_cost` SET TAGS ('dbx_business_glossary_term' = 'Total Parts Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `unit_cost_at_consumption` SET TAGS ('dbx_business_glossary_term' = 'Unit Cost at Consumption');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `warehouse_location_at_issue` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Location at Issue');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ALTER COLUMN `warranty_claim_eligible` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Eligible');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` SET TAGS ('dbx_subdomain' = 'parts_supply');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` SET TAGS ('dbx_association_edges' = 'asset.maintenance_plan,asset.spare_part');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `plan_part_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Plan Part Requirement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Plan Part Requirement - Maintenance Plan Id');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `plan_spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Plan Part Requirement - Spare Part Id');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Substitutable Part ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Created Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `criticality_flag` SET TAGS ('dbx_business_glossary_term' = 'Criticality Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `estimated_unit_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Unit Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `last_updated_date` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Days');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `required_quantity` SET TAGS ('dbx_business_glossary_term' = 'Required Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `required_spare_parts` SET TAGS ('dbx_business_glossary_term' = 'Required Spare Parts');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`plan_part_requirement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `inspection_checklist_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Checklist Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `inspection_superseded_by_checklist_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Checklist Id');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `parent_inspection_checklist_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Inspection Checklist Id');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `parent_inspection_checklist_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `applicable_regulation_code` SET TAGS ('dbx_business_glossary_term' = 'Applicable Regulation Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_business_glossary_term' = 'Approved By Name');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approved Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `asset_category` SET TAGS ('dbx_business_glossary_term' = 'Asset Category');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `certification_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Certification Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `checklist_code` SET TAGS ('dbx_business_glossary_term' = 'Checklist Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `checklist_description` SET TAGS ('dbx_business_glossary_term' = 'Checklist Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `checklist_name` SET TAGS ('dbx_business_glossary_term' = 'Checklist Name');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `checklist_type` SET TAGS ('dbx_business_glossary_term' = 'Checklist Type');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `checklist_version` SET TAGS ('dbx_business_glossary_term' = 'Checklist Version');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `digital_form_available_flag` SET TAGS ('dbx_business_glossary_term' = 'Digital Form Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `documentation_retention_years` SET TAGS ('dbx_business_glossary_term' = 'Documentation Retention Years');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `effective_until_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `equipment_class` SET TAGS ('dbx_business_glossary_term' = 'Equipment Class');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `estimated_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `external_system_reference_code` SET TAGS ('dbx_business_glossary_term' = 'External System Reference Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `inspection_frequency` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `inspector_qualification_level` SET TAGS ('dbx_business_glossary_term' = 'Inspector Qualification Level');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `integration_system_code` SET TAGS ('dbx_business_glossary_term' = 'Integration System Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `mandatory_checkpoint_count` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Checkpoint Count');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `pass_threshold_percentage` SET TAGS ('dbx_business_glossary_term' = 'Pass Threshold Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `photo_evidence_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Photo Evidence Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `regulatory_requirement_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `safety_critical_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `inspection_checklist_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `swl_verification_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Swl Verification Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_checklist` ALTER COLUMN `total_checkpoint_count` SET TAGS ('dbx_business_glossary_term' = 'Total Checkpoint Count');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` SET TAGS ('dbx_subdomain' = 'maintenance_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `work_order_template_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Template Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `parent_work_order_template_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Work Order Template Id');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `parent_work_order_template_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `approval_required` SET TAGS ('dbx_business_glossary_term' = 'Approval Required');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `asset_class` SET TAGS ('dbx_business_glossary_term' = 'Asset Class');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `downtime_required` SET TAGS ('dbx_business_glossary_term' = 'Downtime Required');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `estimated_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `estimated_labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Labor Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `frequency_interval` SET TAGS ('dbx_business_glossary_term' = 'Frequency Interval');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `frequency_unit` SET TAGS ('dbx_business_glossary_term' = 'Frequency Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `inspection_checklist` SET TAGS ('dbx_business_glossary_term' = 'Inspection Checklist');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `lockout_tagout_required` SET TAGS ('dbx_business_glossary_term' = 'Lockout Tagout Required');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `maintenance_category` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Category');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `permit_required` SET TAGS ('dbx_business_glossary_term' = 'Permit Required');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `required_crew_size` SET TAGS ('dbx_business_glossary_term' = 'Required Crew Size');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `required_skills` SET TAGS ('dbx_business_glossary_term' = 'Required Skills');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `required_tools` SET TAGS ('dbx_business_glossary_term' = 'Required Tools');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `safety_critical_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `spare_parts_list` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts List');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `swl_verification_required` SET TAGS ('dbx_business_glossary_term' = 'Swl Verification Required');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `task_list` SET TAGS ('dbx_business_glossary_term' = 'Task List');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `template_code` SET TAGS ('dbx_business_glossary_term' = 'Template Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `template_description` SET TAGS ('dbx_business_glossary_term' = 'Template Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `template_name` SET TAGS ('dbx_business_glossary_term' = 'Template Name');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `template_status` SET TAGS ('dbx_business_glossary_term' = 'Template Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `work_order_type` SET TAGS ('dbx_business_glossary_term' = 'Work Order Type');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` SET TAGS ('dbx_subdomain' = 'equipment_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `asset_location_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Location ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `access_restriction_level` SET TAGS ('dbx_business_glossary_term' = 'Access Restriction Level');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `access_restriction_level` SET TAGS ('dbx_value_regex' = 'public|authorized|escort_required|permit_only|emergency_only');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `assignment_number` SET TAGS ('dbx_business_glossary_term' = 'Location Assignment Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `assignment_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `assignment_priority` SET TAGS ('dbx_business_glossary_term' = 'Assignment Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `assignment_priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Assignment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `assignment_status` SET TAGS ('dbx_value_regex' = 'active|pending|completed|cancelled|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `assignment_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Assignment Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `authorizing_officer` SET TAGS ('dbx_business_glossary_term' = 'Authorizing Officer');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `berth_code` SET TAGS ('dbx_business_glossary_term' = 'Berth Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `berth_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `destination_cost_centre` SET TAGS ('dbx_business_glossary_term' = 'Destination Cost Centre');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `destination_cost_centre` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `dispatch_order_number` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `dispatch_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `distance_from_previous_location_m` SET TAGS ('dbx_business_glossary_term' = 'Distance From Previous Location (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `environmental_zone` SET TAGS ('dbx_business_glossary_term' = 'Environmental Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `environmental_zone` SET TAGS ('dbx_value_regex' = 'standard|controlled_emission|noise_restricted|hazmat|marine_protected');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_business_glossary_term' = 'GPS Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_business_glossary_term' = 'GPS Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `is_temporary_assignment` SET TAGS ('dbx_business_glossary_term' = 'Is Temporary Assignment');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `load_bearing_capacity_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Load Bearing Capacity (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `location_code` SET TAGS ('dbx_business_glossary_term' = 'Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `location_name` SET TAGS ('dbx_business_glossary_term' = 'Location Name');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `network_connectivity_available` SET TAGS ('dbx_business_glossary_term' = 'Network Connectivity Available');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `next_scheduled_location_code` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `next_scheduled_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `operational_area` SET TAGS ('dbx_business_glossary_term' = 'Operational Area');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `originating_cost_centre` SET TAGS ('dbx_business_glossary_term' = 'Originating Cost Centre');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `originating_cost_centre` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `power_supply_available` SET TAGS ('dbx_business_glossary_term' = 'Power Supply Available');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `previous_location_code` SET TAGS ('dbx_business_glossary_term' = 'Previous Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `previous_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `safety_zone_classification` SET TAGS ('dbx_business_glossary_term' = 'Safety Zone Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `safety_zone_classification` SET TAGS ('dbx_value_regex' = 'unrestricted|restricted|hazardous|isps_controlled|confined_space');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `surface_type` SET TAGS ('dbx_business_glossary_term' = 'Surface Type');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `surface_type` SET TAGS ('dbx_value_regex' = 'concrete|asphalt|gravel|rail|water|mixed');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `terminal_zone` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `transfer_description` SET TAGS ('dbx_business_glossary_term' = 'Transfer Description');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `transfer_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Transfer Duration (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `transfer_reason` SET TAGS ('dbx_business_glossary_term' = 'Transfer Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `work_order_number` SET TAGS ('dbx_business_glossary_term' = 'Work Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `work_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `yard_block` SET TAGS ('dbx_business_glossary_term' = 'Yard Block');
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ALTER COLUMN `yard_block` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,8}$');
