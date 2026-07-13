-- Schema for Domain: vessel | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:32

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`vessel` COMMENT 'Manages vessel traffic, scheduling, berthing operations, and marine movements including VTS coordination, anchorage management, ETA/ETB/ATA/ATD tracking, and vessel documentation. Covers vessel profiles (LOA, DWT, GRT, NRT, IMO number), port calls, berth allocation planning, voyage planning, and stowage plans. SSOT for all vessel-related operational data.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` (
    `vessel_id` BIGINT COMMENT 'Unique system identifier for the vessel record. Primary key for the vessel master registry.',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: Flag state determines PSC targeting factor, MOU inspection regime, SOLAS/MARPOL compliance framework, and port state control risk assessment. Required for inspection prioritization, deficiency trackin',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Every operational vessel record must reference authoritative master data for IMO validation, classification society verification, flag state compliance, and PSC inspection history. Critical for regula',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Vessel type determines berth compatibility, pilotage requirements, crane type selection, tariff category, and handling equipment allocation. Essential for port resource planning, berth assignment opti',
    `beam_meters` DECIMAL(18,2) COMMENT 'Maximum width of the vessel measured at the widest point. Used for berth allocation planning and lock/canal passage clearance calculations.',
    `call_sign` STRING COMMENT 'Unique radio call sign assigned to the vessel for maritime communication purposes. Issued by the flag state telecommunications authority.',
    `classification_society_code` STRING COMMENT 'Code identifying the recognized classification society responsible for certifying the vessels structural and mechanical fitness (e.g., Lloyds Register, DNV, ABS, Bureau Veritas). Critical for PSC inspection risk profiling.',
    `cso_contact_email` STRING COMMENT 'Email address of the Company Security Officer for security incident reporting and ISPS coordination.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `cso_contact_phone` STRING COMMENT 'Telephone number of the Company Security Officer for 24/7 security incident escalation.',
    `cso_name` STRING COMMENT 'Name of the designated Company Security Officer responsible for ISPS Code compliance and security management for the vessel. Required under SOLAS Chapter XI-2.',
    `draft_meters` DECIMAL(18,2) COMMENT 'Maximum vertical distance between the waterline and the bottom of the hull (keel). Determines minimum water depth required for safe navigation and berth assignment.',
    `dwt_tonnes` DECIMAL(18,2) COMMENT 'Maximum weight of cargo, fuel, fresh water, ballast water, provisions, passengers, and crew that the vessel can safely carry. Expressed in metric tonnes.',
    `grt_tonnes` DECIMAL(18,2) COMMENT 'Measure of the overall internal volume of the vessel. Used for regulatory compliance, port dues calculation, and manning requirements. Expressed in register tons (100 cubic feet).',
    `imo_number` STRING COMMENT 'Unique seven-digit ship identification number assigned by the International Maritime Organization. Permanent identifier that remains unchanged through changes of ownership, flag, or name. Required for vessels 100 GT and above engaged in international voyages.. Valid values are `^IMO[0-9]{7}$`',
    `ism_company_imo_number` STRING COMMENT 'Unique IMO company identification number assigned to the ISM-responsible company.',
    `ism_company_name` STRING COMMENT 'Name of the company holding the Document of Compliance (DOC) and responsible for ISM Code implementation on the vessel. Identified on the vessels Safety Management Certificate.',
    `isps_security_level` STRING COMMENT 'Current ISPS security level assigned to the vessel (1=normal, 2=heightened, 3=exceptional). Determines security measures and access control requirements during port calls.',
    `last_psc_deficiency_count` STRING COMMENT 'Number of deficiencies identified during the most recent PSC inspection. High deficiency counts trigger increased inspection frequency and may result in detention.',
    `last_psc_detention_flag` BOOLEAN COMMENT 'Boolean indicator of whether the vessel was detained during the most recent PSC inspection. Detention history is a key risk factor for future inspections.',
    `last_psc_inspection_date` DATE COMMENT 'Date of the most recent Port State Control inspection conducted on the vessel. Used for risk profiling and inspection interval targeting under regional PSC MOU regimes.',
    `loa_meters` DECIMAL(18,2) COMMENT 'Maximum length of the vessel measured from the foremost point of the bow to the aftermost point of the stern. Critical dimension for berth allocation and channel navigation clearance.',
    `mmsi_number` STRING COMMENT 'Nine-digit identifier used in the Automatic Identification System (AIS) and Digital Selective Calling (DSC) for vessel tracking and communication.. Valid values are `^[0-9]{9}$`',
    `vessel_name` STRING COMMENT 'Current registered name of the vessel as recorded in the ship registry. Subject to change through vessel renaming procedures.',
    `nrt_tonnes` DECIMAL(18,2) COMMENT 'Measure of the cargo-carrying volume of the vessel, calculated by subtracting non-cargo spaces from GRT. Used for port charges and canal dues.',
    `operational_status` STRING COMMENT 'Current operational state of the vessel. Active indicates the vessel is in service and available for port calls. Laid up indicates temporary withdrawal from service. Under repair indicates the vessel is in drydock or undergoing major maintenance. Scrapped indicates the vessel has been decommissioned. Lost indicates the vessel has been destroyed or sunk. Detained indicates the vessel is held by port state control or other authority.. Valid values are `active|laid_up|under_repair|scrapped|lost|detained`',
    `owner_country_domicile_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the country where the registered owner is domiciled or incorporated. Used for sanctions screening and beneficial ownership analysis.',
    `ownership_current_flag` BOOLEAN COMMENT 'Boolean indicator of whether this record represents the current active ownership. True for the current record, False for historical records. Part of SCD Type 2 implementation.',
    `ownership_effective_from_date` DATE COMMENT 'Start date of the current ownership record. Part of SCD Type 2 implementation for tracking ownership change history.',
    `ownership_effective_to_date` DATE COMMENT 'End date of the current ownership record. Null for the current active ownership record. Part of SCD Type 2 implementation for tracking ownership change history.',
    `pni_club_code` STRING COMMENT 'Code identifying the P&I club providing third-party liability insurance coverage for the vessel. Used for claims coordination and financial assurance verification.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vessel record was first created in the system. Audit trail for data lineage and compliance.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this vessel record was last modified. Audit trail for data lineage and compliance.',
    `registered_owner_imo_company_number` STRING COMMENT 'Unique IMO company identification number assigned to the registered owner organization. Enables corporate hierarchy tracking and sanctions screening.',
    `registered_owner_name` STRING COMMENT 'Legal name of the entity holding title to the vessel as recorded in the ship registry. May differ from commercial operator or technical manager.',
    `risk_profile_score` STRING COMMENT 'Composite risk score (0-100) calculated from vessel age, flag state, classification society, PSC history, ownership transparency, and sanctions screening. Higher scores indicate higher risk. Used for prioritizing inspections and service restrictions.',
    `sanctions_screening_date` DATE COMMENT 'Date of the most recent sanctions screening check performed on the vessel and its ownership chain.',
    `sanctions_screening_status` STRING COMMENT 'Result of sanctions screening against OFAC, EU, UN, and other sanctions lists. Cleared indicates no match. Flagged indicates potential match requiring review. Under review indicates active investigation. Blocked indicates confirmed sanctions match and vessel is prohibited from port services.. Valid values are `cleared|flagged|under_review|blocked`',
    `shipyard_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the nation where the shipyard is located.',
    `shipyard_name` STRING COMMENT 'Name of the shipyard where the vessel was constructed. Provides provenance and build quality indicators for risk profiling.',
    `technical_manager_imo_company_number` STRING COMMENT 'Unique IMO company identification number assigned to the technical manager organization.',
    `technical_manager_name` STRING COMMENT 'Name of the company responsible for the technical operation, maintenance, and crewing of the vessel. May be the owner, a third-party ship manager, or the ISM company.',
    `teu_capacity` STRING COMMENT 'Maximum number of twenty-foot equivalent containers the vessel can carry. Applicable to container vessels only. Null for non-container vessel types.',
    `year_built` STRING COMMENT 'Calendar year in which the vessel was constructed and delivered. Used for age-based risk assessment, PSC targeting, and insurance underwriting.',
    CONSTRAINT pk_vessel PRIMARY KEY(`vessel_id`)
) COMMENT 'Master registry of all vessels calling at the port, including ownership and management hierarchy. Captures the authoritative vessel profile: IMO number, vessel name, flag state (FK to masterdata), vessel type (FK to masterdata), LOA, beam, draft, DWT, GRT, NRT, TEU capacity, call sign, MMSI number, classification society, P&I club, year built, shipyard, and current operational status. Ownership attributes: registered owner, technical manager, commercial operator (disponent owner), ISM company, ship manager, IMO company numbers, country of domicile, and management role types — tracked as SCD Type 2 for ownership change history. Supports ISPS compliance (CSO identification), PSC inspection records, commercial billing relationships, sanctions screening, and vessel risk profiling. SSOT for all vessel identity, static characteristics, and corporate hierarchy referenced across terminal, cargo, marine, and billing domains.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` (
    `owner_id` BIGINT COMMENT 'Primary key for owner',
    `country_id` BIGINT COMMENT 'add column country_id (BIGINT) with FK to masterdata.country.country_id - vessel owners have a country of registration relevant for sanctions and compliance',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Vessel owners are port community participants when they hold billing accounts, sign service agreements, maintain credit facilities, or undergo ISPS accreditation. Port commercial operations require li',
    `receivable_account_id` BIGINT COMMENT 'Foreign key linking to billing.receivable_account. Business justification: Vessel owners maintain credit accounts with port authorities for recurring charges (port dues, agency fees, disbursements). Essential for credit limit enforcement, payment terms management, dunning pr',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel for which this ownership record applies. Links to the vessel master data.',
    `billing_account_reference` STRING COMMENT 'Reference to the billing account used for invoicing port charges and services to this owning or managing company. Links vessel operations to commercial billing relationships.',
    `business_registration_number` STRING COMMENT 'The official business or company registration number issued by the country of domicile. Used for legal entity verification and due diligence.',
    `company_name` STRING COMMENT 'The legal name of the company or entity holding this ownership or management role for the vessel.',
    `contact_email` STRING COMMENT 'Primary email address for official communication with the owning or managing company regarding vessel operations, compliance, and commercial matters.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `contact_fax` STRING COMMENT 'Fax number for formal document transmission to the owning or managing company, still used in maritime industry for official correspondence.',
    `contact_phone` STRING COMMENT 'Primary telephone number for contacting the owning or managing company for operational and emergency communications.',
    `country_of_domicile` STRING COMMENT 'The three-letter ISO country code representing the country where the owning or managing company is legally domiciled or incorporated.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this ownership record was first created in the system. Used for audit trail and data lineage tracking.',
    `credit_rating` STRING COMMENT 'The credit rating assigned to the owning or managing company for financial risk assessment and credit limit determination. Used for commercial terms negotiation and payment guarantee requirements. [ENUM-REF-CANDIDATE: AAA|AA|A|BBB|BB|B|CCC|CC|C|D|not_rated — 11 candidates stripped; promote to reference product]',
    `cso_contact_email` STRING COMMENT 'Email address of the Company Security Officer for security-related communications and Port State Control (PSC) inspections.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `cso_contact_phone` STRING COMMENT '24/7 contact phone number for the Company Security Officer for emergency security communications and PSC verification.',
    `cso_name` STRING COMMENT 'Full name of the designated Company Security Officer responsible for ISPS Code compliance and security management for the vessel. Required for ISM company role type.',
    `doc_certificate_number` STRING COMMENT 'The certificate number of the Document of Compliance issued to the ISM company demonstrating compliance with the International Safety Management Code. Required for ISM company role type and PSC inspections.',
    `doc_expiry_date` DATE COMMENT 'The expiration date of the Document of Compliance certificate. Used for compliance monitoring and PSC inspection readiness.',
    `doc_issue_date` DATE COMMENT 'The date on which the Document of Compliance certificate was issued to the ISM company by the flag state or recognized organization.',
    `effective_from_date` DATE COMMENT 'The date from which this ownership or management relationship became effective. Tracks ownership transfers and management contract start dates.',
    `effective_to_date` DATE COMMENT 'The date on which this ownership or management relationship ended or is scheduled to end. Null for current active relationships. Used for historical tracking of ownership changes and management contract terminations.',
    `imo_company_number` STRING COMMENT 'The unique seven-digit IMO company identification number assigned by IHS Fairplay to maritime companies. Used for global identification and tracking of ship owners, managers, and operators in compliance with IMO regulations.. Valid values are `^[0-9]{7}$`',
    `is_beneficial_owner` BOOLEAN COMMENT 'Boolean flag indicating whether this entity is the beneficial owner (ultimate economic owner) of the vessel, as opposed to nominee or registered owner. Critical for anti-money laundering (AML) compliance and transparency requirements.',
    `kyc_verification_date` DATE COMMENT 'The date when KYC verification was completed or last updated for this owning or managing company. Used for compliance monitoring and re-verification scheduling.',
    `kyc_verification_status` STRING COMMENT 'Status of Know Your Customer due diligence verification for this owning or managing company. Verified indicates completed and approved KYC checks, pending for in-progress verification, failed for rejected applications, expired for verifications requiring renewal.. Valid values are `verified|pending|failed|expired`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this ownership record was last updated in the system. Used for audit trail and change tracking.',
    `management_contract_reference` STRING COMMENT 'Reference number of the ship management contract or agreement governing this management relationship. Applicable for technical manager, commercial operator, and ship manager role types.',
    `notes` STRING COMMENT 'Free-text field for additional notes, comments, or special instructions related to this ownership or management relationship. Used for operational context and historical documentation.',
    `ownership_percentage` DECIMAL(18,2) COMMENT 'The percentage of ownership stake this entity holds in the vessel, applicable for registered owner role type. Used for commercial billing allocation and liability determination.',
    `ownership_role_type` STRING COMMENT 'The type of ownership or management relationship this entity has with the vessel. Registered owner holds legal title, technical manager handles maintenance and crewing, commercial operator (disponent owner) manages commercial operations, ISM company is responsible for International Safety Management Code compliance, ship manager provides comprehensive vessel management services, bareboat charterer has operational control under charter agreement.. Valid values are `registered_owner|technical_manager|commercial_operator|ism_company|ship_manager|bareboat_charterer`',
    `ownership_status` STRING COMMENT 'Current lifecycle status of this ownership or management relationship. Active indicates current valid relationship, inactive for historical records, pending transfer during ownership change process, terminated for formally ended relationships.. Valid values are `active|inactive|pending_transfer|terminated`',
    `pni_certificate_number` STRING COMMENT 'The certificate number for the P&I insurance coverage. Required for port entry clearance and commercial operations.',
    `pni_club_name` STRING COMMENT 'The name of the Protection and Indemnity insurance club providing liability coverage for the vessel under this ownership arrangement. Critical for claims management and port entry requirements.',
    `registered_address` STRING COMMENT 'The full registered business address of the owning or managing company as recorded in official maritime registries.',
    `sanctions_screening_date` DATE COMMENT 'The date when the most recent sanctions screening check was performed for this owning or managing company. Used for compliance audit trails and re-screening scheduling.',
    `sanctions_screening_status` STRING COMMENT 'Result of sanctions screening checks against international sanctions lists (OFAC, EU, UN) for this owning or managing company. Cleared indicates no matches, flagged for potential matches requiring review, under review for active investigation, blocked for confirmed sanctions violations preventing port operations.. Valid values are `cleared|flagged|under_review|blocked`',
    `tax_identification_number` STRING COMMENT 'The tax identification number or VAT registration number of the owning or managing company in their country of domicile. Required for invoicing and tax compliance.',
    CONSTRAINT pk_owner PRIMARY KEY(`owner_id`)
) COMMENT 'Master record of vessel ownership and management entities. Captures registered owner, technical manager, commercial operator (disponent owner), ISM company, and ship manager details including company name, IMO company number, country of domicile, contact details, and management role type. Tracks ownership changes and management transfers over time. Supports ISPS compliance (CSO identification), PSC inspection records, commercial billing relationships, and sanctions screening. Distinct from the customer domain which tracks port community participants as commercial clients — this product captures the vessels corporate hierarchy as declared in IMO records.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`call` (
    `call_id` BIGINT COMMENT 'Primary key for call',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Port calls execute services under terminal operating agreements (TOAs), concession agreements, or service contracts. Billing, SLA measurement, and dispute resolution all require linking calls to gover',
    `anchorage_area_id` BIGINT COMMENT 'Reference to the anchorage area where the vessel waited before berthing. Null if vessel proceeded directly to berth.',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Every port call incurs charges (port dues, wharfage, pilotage) defined in the applicable port tariff schedule. This is the foundational commercial relationship - port calls generate revenue via tariff',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Commercial vessel calls under service contracts with shipping lines use negotiated rate cards instead of published tariffs. Volume commitment customers operate under contracted pricing. Essential for ',
    `berth_id` BIGINT COMMENT 'Reference to the berth allocated for this port call. Links to berth master data containing location and specifications.',
    `contact_person_id` BIGINT COMMENT 'Reference to the primary contact person at the agent company responsible for coordinating this port call.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Port calls generate operational costs (VTS, pilotage, marine coordination) that must be allocated to specific cost centres for activity-based costing and operational expense tracking. Essential for ma',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Port calls require specific assets (cranes, tugs, fenders) for cargo operations and vessel handling. Operations teams assign equipment to calls for berth planning, resource scheduling, and billing. Es',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Port calls generate revenue across different service lines (terminal operations, marine services, pilotage) tracked by profit centre. Required for revenue recognition, profitability analysis by busine',
    `vendor_id` BIGINT COMMENT 'Reference to the shipping agent company appointed to represent the vessel and coordinate port operations for this call.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel making this port call. Links to vessel master data containing vessel profile information (LOA, DWT, GRT, NRT, IMO number).',
    `agency_type` STRING COMMENT 'Type of agency service provided for this port call. Defines the scope of agent responsibilities and authority.. Valid values are `general|husbanding|cargo|protective`',
    `all_fast_timestamp` TIMESTAMP COMMENT 'Timestamp when all mooring lines were secured and the vessel was fully berthed. Marks completion of berthing operations.',
    `appointment_end_date` DATE COMMENT 'Date when the agent appointment expires. Null for single-call appointments that end with call completion.',
    `appointment_scope` STRING COMMENT 'Duration and coverage scope of the agent appointment. Determines whether appointment is for this call only or extends to multiple calls.. Valid values are `single_call|voyage_series|annual|term_contract`',
    `appointment_start_date` DATE COMMENT 'Date when the agent appointment becomes effective for this port call or series of calls.',
    `appointment_status` STRING COMMENT 'Current status of the agent appointment for this port call. Affects document submission authority and billing routing.. Valid values are `active|suspended|terminated|pending_approval`',
    `ata` TIMESTAMP COMMENT 'Actual timestamp when the vessel arrived at the port anchorage or pilot boarding station. Recorded by VTS.',
    `atb` TIMESTAMP COMMENT 'Actual timestamp when the vessel was secured alongside the berth with all lines fast. Marks the start of berth occupancy.',
    `atd` TIMESTAMP COMMENT 'Actual timestamp when the vessel departed from the berth and left the port. Marks the end of the port call.',
    `baplie_received_flag` BOOLEAN COMMENT 'Indicates whether the BAPLIE EDI message containing the vessel stowage plan has been received from the shipping line.',
    `call_number` STRING COMMENT 'Sequential port-assigned identifier for this specific vessel visit. Used as the business reference number for all port operations and billing.',
    `call_status` STRING COMMENT 'Current lifecycle status of the port call. Tracks progression from pre-arrival notification through departure. [ENUM-REF-CANDIDATE: pre_arrival|expected|arrived|berthed|working|completed|departed|cancelled — 8 candidates stripped; promote to reference product]',
    `cargo_ops_end_timestamp` TIMESTAMP COMMENT 'Timestamp when all cargo loading or discharge operations were completed. Used for calculating working time and productivity.',
    `cargo_ops_start_timestamp` TIMESTAMP COMMENT 'Timestamp when cargo loading or discharge operations commenced. Used for calculating working time and productivity.',
    `cargo_type` STRING COMMENT 'Primary type of cargo being handled during this port call. Determines handling equipment and operational procedures. [ENUM-REF-CANDIDATE: containerized|breakbulk|bulk_dry|bulk_liquid|roro|general|mixed — 7 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this port call record was first created in the system. Audit trail for data lineage.',
    `customs_clearance_status` STRING COMMENT 'Current status of customs clearance for this port call. Affects cargo release and vessel departure authorization.. Valid values are `pending|cleared|inspection_required|hold|released`',
    `dangerous_goods_flag` BOOLEAN COMMENT 'Indicates whether the vessel is carrying IMDG-classified dangerous goods during this call. Triggers additional safety and documentation requirements.',
    `eta` TIMESTAMP COMMENT 'Estimated timestamp when the vessel is expected to arrive at the port anchorage or pilot boarding station. Updated as voyage progresses.',
    `etb` TIMESTAMP COMMENT 'Estimated timestamp when the vessel is expected to be secured alongside the berth and ready for cargo operations.',
    `etd` TIMESTAMP COMMENT 'Estimated timestamp when the vessel is expected to depart from the berth and leave the port.',
    `first_line_timestamp` TIMESTAMP COMMENT 'Timestamp when the first mooring line was secured to the berth during berthing operations.',
    `gangway_down_timestamp` TIMESTAMP COMMENT 'Timestamp when the gangway was lowered and secured, allowing personnel access to the vessel.',
    `isps_security_level` STRING COMMENT 'ISPS security level in effect during this port call (1=normal, 2=heightened, 3=exceptional). Determines security procedures and access controls.',
    `last_line_timestamp` TIMESTAMP COMMENT 'Timestamp when the last mooring line was released during unberthing operations. Marks start of departure sequence.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this port call record was last updated. Audit trail for data lineage and change tracking.',
    `pilot_boarded_timestamp` TIMESTAMP COMMENT 'Timestamp when the marine pilot boarded the vessel to guide it into port. First milestone in the arrival sequence.',
    `pilot_off_timestamp` TIMESTAMP COMMENT 'Timestamp when the marine pilot disembarked after guiding the vessel out of port. Final milestone in the departure sequence.',
    `pod` STRING COMMENT 'UN/LOCODE of the next port where cargo will be discharged after this call. Five-character code following UN/LOCODE standard.. Valid values are `^[A-Z]{5}$`',
    `pol` STRING COMMENT 'UN/LOCODE of the port where cargo was loaded prior to this call. Five-character code following UN/LOCODE standard.. Valid values are `^[A-Z]{5}$`',
    `port_state_control_inspection_flag` BOOLEAN COMMENT 'Indicates whether this vessel was selected for Port State Control inspection during this call. True if inspection occurred.',
    `purpose` STRING COMMENT 'Primary reason for the vessel visit. Determines operational requirements and resource allocation. [ENUM-REF-CANDIDATE: loading|discharge|loading_discharge|bunkering|transit|lay_up|crew_change|repair|provisions — 9 candidates stripped; promote to reference product]',
    `remarks` STRING COMMENT 'Free-text field for operational notes, special instructions, or exceptions related to this port call.',
    `total_feu_declared` STRING COMMENT 'Total number of FEU declared for loading and discharge operations during this call. Used for capacity planning and billing.',
    `total_teu_declared` STRING COMMENT 'Total number of TEU declared for loading and discharge operations during this call. Used for capacity planning and billing.',
    `voyage_number` STRING COMMENT 'The voyage identifier assigned by the shipping line for this specific journey. Used for tracking vessel movements across multiple port calls.',
    `vts_clearance_reference` STRING COMMENT 'Reference number issued by VTS granting clearance for vessel movement within port waters. Required for compliance with ISPS and port regulations.',
    CONSTRAINT pk_call PRIMARY KEY(`call_id`)
) COMMENT 'Core transactional record representing a single vessel visit to the port, from pre-arrival notification through departure. Captures: voyage number, POL, POD, ETA/ETB/ETD, ATA/ATB/ATD, call purpose (loading, discharge, bunkering, transit, lay-up, crew change), cargo type, total TEU/FEU declared, call status, VTS clearance reference. Agent appointment attributes: appointed agent company, agency type (general, husbanding, cargo, protective), appointment scope (single call, voyage series, annual), appointment dates, primary contact, and appointment status. Milestone timestamps: pilot boarded, first line, all fast, gangway down, cargo ops start/end, last line, pilot off. The primary operational anchor entity linking vessel movements to berth allocation, cargo operations, pilotage, towage, and billing. Supports SLA measurement, port call performance reporting (UNCTAD indicators), and agent coordination for document submission authority and billing address routing.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` (
    `voyage_id` BIGINT COMMENT 'Unique identifier for the voyage record. Primary key for the voyage entity.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Voyages operate under service contracts with shipping lines defining berth allocation, service windows, and commercial terms. Required for rate application, volume commitment tracking, and SLA measure',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Service-level commercial agreements link entire voyages to negotiated rate cards. Shipping line services (identified by service_code, shipping_line_id) operate under contracted pricing for the rotatio',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Voyage coordinators manage service schedules, berth planning, and cargo forecasting for shipping line services. Critical for operational planning, customer service accountability, and productivity ana',
    `shipping_line_id` BIGINT COMMENT 'Reference to the shipping line or carrier operating this voyage. Links to the participant account representing the commercial operator responsible for the voyage.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel performing this voyage. Links to the vessel master data containing vessel profile, IMO number, LOA, DWT, GRT, NRT, and other vessel characteristics.',
    `ata` TIMESTAMP COMMENT 'The actual timestamp when the vessel arrived at the port limits or pilot boarding station. Recorded by Vessel Traffic Service (VTS) and used for performance measurement and billing calculations.',
    `atb` TIMESTAMP COMMENT 'The actual timestamp when the vessel was secured alongside the berth with first line ashore. Marks the start of berth occupancy time for billing and the commencement of cargo operations window.',
    `atd` TIMESTAMP COMMENT 'The actual timestamp when the vessel departed from the berth with last line off. Marks the end of berth occupancy time for billing and the conclusion of the port call.',
    `baplie_received_flag` BOOLEAN COMMENT 'Boolean indicator showing whether the BAPLIE (Bayplan and Stowage Plan) EDI message has been received. BAPLIE contains the vessels container stowage plan showing exact position of each container on board.',
    `berth_productivity_target` DECIMAL(18,2) COMMENT 'The target container handling productivity rate for this voyage measured in container moves per hour. Used for terminal resource planning and SLA performance measurement.',
    `call_sequence` STRING COMMENT 'Sequential number indicating this ports position in the voyages port call sequence. Used to order intermediate ports of call and support cargo routing logic.',
    `cargo_manifest_received_flag` BOOLEAN COMMENT 'Boolean indicator showing whether the cargo manifest for this voyage has been received from the shipping line. Critical for customs clearance, cargo planning, and terminal readiness.',
    `coparn_received_flag` BOOLEAN COMMENT 'Boolean indicator showing whether the COPARN (Container Pre-Announcement) EDI message has been received. COPARN provides advance notice of containers to be discharged and loaded.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this voyage record was first created in the system. Used for audit trail and data lineage tracking.',
    `customs_clearance_status` STRING COMMENT 'Current status of customs clearance for the voyage cargo. Pending indicates awaiting customs processing, cleared indicates all cargo approved for release, inspection_required indicates physical examination needed, hold indicates customs detention, released indicates cargo available for delivery.. Valid values are `pending|cleared|inspection_required|hold|released`',
    `destination_port_code` STRING COMMENT 'UN/LOCODE of the voyage destination port. Five-character code identifying the final port of call for this voyage leg.. Valid values are `^[A-Z]{5}$`',
    `empty_teu_onboard` DECIMAL(18,2) COMMENT 'The number of empty containers onboard measured in TEU. Critical for empty container repositioning planning and depot management.',
    `end_date` DATE COMMENT 'The date when the voyage concluded at the destination port. Represents the actual or planned arrival date marking the end of the commercial voyage journey.',
    `eta` TIMESTAMP COMMENT 'The estimated timestamp when the vessel is expected to arrive at the port. Updated throughout the voyage based on vessel position, speed, and weather conditions. Critical for berth planning and resource allocation.',
    `etb` TIMESTAMP COMMENT 'The estimated timestamp when the vessel is expected to berth at the assigned quay. Accounts for pilotage, towage, and berth availability. Used for terminal operations planning and gate scheduling.',
    `etd` TIMESTAMP COMMENT 'The estimated timestamp when the vessel is expected to depart from the berth. Based on cargo operations completion forecast, customs clearance, and next port schedule requirements.',
    `imdg_cargo_onboard_flag` BOOLEAN COMMENT 'Boolean indicator showing whether the vessel is carrying dangerous goods as classified under IMDG Code. Triggers special safety protocols, segregation requirements, and emergency response planning.',
    `is_maiden_call` BOOLEAN COMMENT 'Boolean flag indicating whether this is the vessels first-ever call to this port. Maiden calls often receive special ceremonial recognition and may have different operational procedures.',
    `is_omitted` BOOLEAN COMMENT 'Boolean flag indicating whether this scheduled port call was omitted or skipped by the vessel. Used for schedule reliability analysis and customer service impact assessment.',
    `isps_security_level` STRING COMMENT 'The ISPS security level applicable to this voyage. Level 1 is normal security, Level 2 is heightened security due to increased risk, Level 3 is exceptional security measures for imminent threat. Determines security protocols and access controls.. Valid values are `level_1|level_2|level_3`',
    `laden_teu_onboard` DECIMAL(18,2) COMMENT 'The number of laden (full) containers onboard measured in TEU. Used for cargo volume analysis and vessel utilization calculations.',
    `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this voyage record was last modified. Updated whenever any attribute value changes. Critical for change tracking and data synchronization.',
    `next_port_code` STRING COMMENT 'UN/LOCODE of the next scheduled port of call after the current port. Critical for stowage planning (BAPLIE) and cargo routing decisions.. Valid values are `^[A-Z]{5}$`',
    `omission_reason` STRING COMMENT 'Textual explanation for why a scheduled port call was omitted. Common reasons include weather delays, mechanical issues, insufficient cargo, port congestion, or schedule recovery actions.',
    `oog_cargo_onboard_flag` BOOLEAN COMMENT 'Boolean indicator showing whether the vessel is carrying out-of-gauge cargo that exceeds standard container dimensions. Requires special handling equipment and stowage planning considerations.',
    `origin_port_code` STRING COMMENT 'UN/LOCODE (United Nations Code for Trade and Transport Locations) of the voyage origin port. Five-character code identifying the port where the voyage originated.. Valid values are `^[A-Z]{5}$`',
    `pilot_required_flag` BOOLEAN COMMENT 'Boolean indicator showing whether pilotage service is required for this voyage. Determined by vessel characteristics, port regulations, and pilotage exemption status.',
    `previous_port_code` STRING COMMENT 'UN/LOCODE of the port immediately preceding the current port call. Used for cargo manifest reconciliation and vessel movement tracking.. Valid values are `^[A-Z]{5}$`',
    `quarantine_status` STRING COMMENT 'Health quarantine status of the vessel and crew. Not_required indicates no health concerns, pending indicates awaiting health authority inspection, cleared indicates health clearance granted, restricted indicates quarantine measures in effect.. Valid values are `not_required|pending|cleared|restricted`',
    `reefer_teu_onboard` DECIMAL(18,2) COMMENT 'The number of refrigerated containers onboard measured in TEU. Requires special handling, power supply monitoring, and temperature-controlled storage planning.',
    `remarks` STRING COMMENT 'Free-text field for operational notes, special instructions, or additional voyage information not captured in structured fields. Used for inter-departmental communication and operational coordination.',
    `rotation_number` STRING COMMENT 'Sequential rotation identifier within the service string. Used by shipping lines to track vessel position within a cyclical service route (e.g., rotation 1, rotation 2). Supports schedule adherence analysis.',
    `service_code` STRING COMMENT 'The shipping lines service route code or string identifier for the regular service this voyage belongs to. Used to group voyages into service patterns for schedule analysis and capacity planning.',
    `service_name` STRING COMMENT 'Human-readable name of the shipping service route (e.g., Asia-Europe Express, Pacific Loop Service). Provides business context for the voyages commercial service pattern.',
    `start_date` DATE COMMENT 'The date when the voyage commenced from the origin port. Represents the actual or planned departure date marking the beginning of the commercial voyage journey.',
    `total_teu_capacity` DECIMAL(18,2) COMMENT 'The total container capacity of the vessel for this voyage measured in TEU. Represents the maximum number of twenty-foot equivalent containers the vessel can carry.',
    `towage_required_flag` BOOLEAN COMMENT 'Boolean indicator showing whether tug assistance is required for berthing and unberthing operations. Based on vessel size, maneuverability, weather conditions, and port regulations.',
    `voyage_number` STRING COMMENT 'The externally-known unique voyage number assigned by the shipping line or port authority. This is the business identifier used in operational communications, manifests, and port call documentation.',
    `voyage_status` STRING COMMENT 'Current lifecycle status of the voyage. Planned indicates initial voyage planning stage, scheduled indicates confirmed berth and resource allocation, in_progress indicates vessel is actively executing the voyage, completed indicates voyage has concluded with vessel departure, cancelled indicates voyage was terminated before execution, delayed indicates voyage is behind schedule.. Valid values are `planned|scheduled|in_progress|completed|cancelled|delayed`',
    `voyage_type` STRING COMMENT 'Classification of the voyage based on direction and scope. Inbound indicates arrival to the port, outbound indicates departure, coastal indicates domestic port-to-port movement, international indicates cross-border movement, feeder indicates short-sea collection/distribution service, and transshipment indicates cargo transfer voyage.. Valid values are `inbound|outbound|coastal|international|feeder|transshipment`',
    CONSTRAINT pk_voyage PRIMARY KEY(`voyage_id`)
) COMMENT 'Master record of a vessel voyage representing the commercial and operational journey between ports. Captures voyage number, voyage type (inbound, outbound, coastal, international), service route, shipping line service code, origin port, destination port, intermediate ports of call sequence, voyage start and end dates, and voyage status. Links to port calls at each port of call and supports stowage planning (BAPLIE), cargo manifest reconciliation, and freight billing. Distinct from port_call which represents the single-port visit event.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` (
    `anchorage_id` BIGINT COMMENT 'Primary key for anchorage',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Anchorage assignments must reference the physical anchorage area infrastructure for position management, ISPS security zone enforcement, VTS monitoring, and capacity planning. Current denormalized cod',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Anchorage assignments incur anchorage charges defined in port tariff schedules based on vessel size, duration, and anchorage area. While anchorage_charge_amount captures the result, the tariff referen',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Anchorage operations incur costs (VTS monitoring, coordination, safety oversight) allocated to marine services cost centres. Required for operational cost tracking, anchorage service costing, and reso',
    `berth_id` BIGINT COMMENT 'Reference to the berth allocated for the vessel after departing anchorage. Links anchorage assignment to subsequent berth allocation.',
    `ohs_incident_id` BIGINT COMMENT 'Foreign key linking to safety.ohs_incident. Business justification: Incidents occur during anchorage operations including anchor handling, pilot boarding via pilot ladder, crew transfers, and launch operations. Investigations must reference the specific anchorage assi',
    `call_id` BIGINT COMMENT 'Reference to the port call associated with this anchorage assignment. Links the anchorage to the vessels overall port visit.',
    `employee_id` BIGINT COMMENT 'Reference to the VTS officer responsible for managing and monitoring this anchorage assignment. Ensures accountability and operational oversight.',
    `terminal_berth_allocation_id` BIGINT COMMENT 'Foreign key linking to terminal.berth_allocation. Business justification: Anchorage assignments must track the specific berth allocation (time-slotted operational assignment) the vessel will move to after weighing anchor. Critical for VTS vessel traffic sequencing, berth wi',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel assigned to this anchorage. Identifies which vessel is anchored.',
    `actual_anchor_drop_time` TIMESTAMP COMMENT 'Actual timestamp when the vessel dropped anchor at the anchorage position. Recorded by VTS for operational tracking and performance measurement.',
    `actual_weigh_anchor_time` TIMESTAMP COMMENT 'Actual timestamp when the vessel weighed anchor and departed the anchorage position. Recorded by VTS for operational tracking and billing purposes.',
    `anchor_berth_number` STRING COMMENT 'Specific berth or position number within the anchorage area assigned to the vessel. Used for precise positioning and capacity management.. Valid values are `^[A-Z0-9-]{1,15}$`',
    `assignment_priority` STRING COMMENT 'Priority ranking for the anchorage assignment used for sequencing and capacity management. Lower numbers indicate higher priority. Used by VTS to manage vessel traffic flow.',
    `assignment_status` STRING COMMENT 'Current lifecycle status of the anchorage assignment. Values: ASSIGNED (anchorage allocated but vessel not yet anchored), ANCHORED (vessel currently at anchor), DEPARTED (vessel has weighed anchor and departed), CANCELLED (assignment cancelled before anchoring).. Valid values are `ASSIGNED|ANCHORED|DEPARTED|CANCELLED`',
    `charge_amount` DECIMAL(18,2) COMMENT 'Total anchorage fee charged to the vessel for the duration at anchor. Calculated based on vessel size, duration, and applicable tariff rates.',
    `charge_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the anchorage charge amount. Ensures accurate financial reporting and billing.. Valid values are `^[A-Z]{3}$`',
    `created_by_user_code` STRING COMMENT 'User identifier of the person or system that created the anchorage assignment record. Supports audit and accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the anchorage assignment record was first created in the system. Used for audit trail and data lineage.',
    `customs_clearance_status` STRING COMMENT 'Status of customs clearance for the vessel at anchorage. Values: PENDING (clearance not yet initiated), CLEARED (customs clearance granted), HOLD (customs hold in place), INSPECTION_REQUIRED (physical inspection needed).. Valid values are `PENDING|CLEARED|HOLD|INSPECTION_REQUIRED`',
    `duration_hours` DECIMAL(18,2) COMMENT 'Total duration the vessel remained at anchorage measured in hours. Calculated from actual anchor drop time to actual weigh anchor time. Used for billing and performance analysis.',
    `expected_weigh_anchor_time` TIMESTAMP COMMENT 'Expected timestamp when the vessel will weigh anchor and depart the anchorage. Used for berth planning and vessel traffic sequencing.',
    `last_modified_by_user_code` STRING COMMENT 'User identifier of the person or system that last modified the anchorage assignment record. Supports audit and accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the anchorage assignment record was last updated. Used for audit trail and change tracking.',
    `pilot_required_flag` BOOLEAN COMMENT 'Indicates whether pilotage service is required for the vessel to move from anchorage to berth. True if pilot is mandatory, False otherwise.',
    `port_health_clearance_status` STRING COMMENT 'Status of port health authority clearance for the vessel at anchorage. Determines whether vessel can proceed to berth or receive services.. Valid values are `PENDING|CLEARED|HOLD|INSPECTION_REQUIRED`',
    `position_latitude` DECIMAL(18,2) COMMENT 'Latitude coordinate of the vessels anchorage position in decimal degrees. Used for precise vessel location tracking and VTS monitoring.',
    `position_longitude` DECIMAL(18,2) COMMENT 'Longitude coordinate of the vessels anchorage position in decimal degrees. Used for precise vessel location tracking and VTS monitoring.',
    `quarantine_flag` BOOLEAN COMMENT 'Indicates whether the vessel is under quarantine at anchorage. True if quarantine restrictions apply, False otherwise. Affects boarding permissions and service access.',
    `reason_code` STRING COMMENT 'Coded reason for the vessel anchorage assignment. Supports operational planning and capacity management. Values: AWAITING_BERTH (waiting for berth availability), AWAITING_TIDE (waiting for favorable tide conditions), CUSTOMS_HOLD (customs inspection or clearance hold), BUNKERING (refueling operations), CREW_CHANGE (crew rotation), REPAIRS (maintenance or repair work), QUARANTINE (health or security quarantine). [ENUM-REF-CANDIDATE: AWAITING_BERTH|AWAITING_TIDE|CUSTOMS_HOLD|BUNKERING|CREW_CHANGE|REPAIRS|QUARANTINE — 7 candidates stripped; promote to reference product]',
    `reason_description` STRING COMMENT 'Detailed textual description of the reason for anchorage. Provides additional context beyond the coded reason.',
    `remarks` STRING COMMENT 'Free-text remarks and notes related to the anchorage assignment. Captures operational observations, special instructions, or incident notes.',
    `scheduled_anchor_drop_time` TIMESTAMP COMMENT 'Planned timestamp when the vessel is scheduled to drop anchor at the assigned anchorage position. Used for VTS coordination and sequencing.',
    `sea_state_code` STRING COMMENT 'Coded sea state condition at the anchorage position. Values based on World Meteorological Organization (WMO) sea state scale: CALM (0-0.1m), SLIGHT (0.1-0.5m), MODERATE (0.5-1.25m), ROUGH (1.25-2.5m), VERY_ROUGH (2.5-4m), HIGH (4-6m).. Valid values are `CALM|SLIGHT|MODERATE|ROUGH|VERY_ROUGH|HIGH`',
    `security_level` STRING COMMENT 'ISPS security level applicable to the anchorage at the time of assignment. LEVEL_1 (normal security), LEVEL_2 (heightened security), LEVEL_3 (exceptional security). Determines security protocols and access restrictions.. Valid values are `LEVEL_1|LEVEL_2|LEVEL_3`',
    `tug_assistance_required_flag` BOOLEAN COMMENT 'Indicates whether tug assistance is required for the vessel to move from anchorage. True if tug service is needed, False otherwise.',
    `visibility_meters` DECIMAL(18,2) COMMENT 'Visibility distance at the anchorage position measured in meters. Important for navigation safety and VTS monitoring.',
    `water_depth_meters` DECIMAL(18,2) COMMENT 'Water depth at the anchorage position measured in meters. Critical for vessel safety and ensuring adequate under-keel clearance.',
    `weather_condition` STRING COMMENT 'Description of weather conditions at the time of anchorage assignment. Relevant for safety assessment and operational decision-making.',
    `wind_speed_knots` DECIMAL(18,2) COMMENT 'Wind speed at the anchorage position measured in knots. Critical for vessel safety and anchoring operations.',
    CONSTRAINT pk_anchorage PRIMARY KEY(`anchorage_id`)
) COMMENT 'Transactional record of a vessel anchorage assignment managed by VTS (Vessel Traffic Service). Captures anchorage area code, anchorage position (latitude/longitude), assigned anchor berth number, time of anchoring, expected time to weigh anchor, actual time of departure from anchorage, reason for anchorage (awaiting berth, awaiting tide, customs hold, bunkering, crew change), water depth at anchorage, and VTS officer assignment. Supports anchorage capacity management and vessel traffic sequencing.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` (
    `movement_id` BIGINT COMMENT 'Primary key for movement',
    `anchorage_area_id` BIGINT COMMENT 'add column anchorage_area_id (BIGINT) with FK to infrastructure.anchorage_area.anchorage_area_id - vessel movements include anchorage-to-berth transits',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Vessel movements generate costs (pilotage, VTS coordination, tug operations oversight) allocated to marine services cost centres. Essential for activity-based costing of vessel traffic management, pil',
    `employee_id` BIGINT COMMENT 'Reference to the VTS operator who monitored and authorized this movement. Links to workforce/operator master data.',
    `berth_id` BIGINT COMMENT 'add column infrastructure_berth_id (BIGINT) with FK to infrastructure.berth.berth_id - vessel movements are to/from berths and must reference origin and destination berth',
    `ohs_incident_id` BIGINT COMMENT 'Foreign key linking to safety.ohs_incident. Business justification: Vessel movements (berthing, unberthing, shifting berths) are high-risk operations where incidents commonly occur involving mooring lines, pilot boarding, tug operations. Incident investigations must r',
    `pilot_id` BIGINT COMMENT 'Reference to the marine pilot assigned to guide the vessel during this movement. Null if no pilot was required or assigned.',
    `call_id` BIGINT COMMENT 'Reference to the parent port call under which this movement occurs. Links the movement to the vessels overall visit.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel performing this movement. Links to vessel master data.',
    `air_draft_meters` DECIMAL(18,2) COMMENT 'Vertical distance from the waterline to the highest point of the vessel at the time of movement, measured in meters. Critical for clearance under bridges and overhead structures.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this movement record was first created in the system. Audit trail timestamp for record creation.',
    `current_direction_degrees` DECIMAL(18,2) COMMENT 'Water current direction at the time of movement, expressed in degrees (0-360). Indicates the direction toward which the current is flowing.',
    `current_speed_knots` DECIMAL(18,2) COMMENT 'Water current speed at the time of movement, measured in knots. Affects vessel handling and is recorded for navigation safety analysis.',
    `dangerous_cargo_flag` BOOLEAN COMMENT 'Indicates whether the vessel is carrying dangerous goods (IMDG cargo) during this movement. True if dangerous cargo is on board, False otherwise. Triggers special handling and notification procedures.',
    `delay_minutes` STRING COMMENT 'Delay time in minutes compared to scheduled movement timestamp. Positive value indicates late movement, zero indicates on-time. Used for SLA (Service Level Agreement) performance tracking.',
    `delay_reason_code` STRING COMMENT 'Standardized code indicating the reason for movement delay. References delay reason lookup table. Null if movement was on time.',
    `destination_location_code` STRING COMMENT 'Code identifying the ending location of the movement. May reference a berth, anchorage, or port boundary point. For departures, this is typically the port exit or pilot disembarkation point.',
    `draft_aft_meters` DECIMAL(18,2) COMMENT 'Vessels draft at the aft perpendicular at the time of movement, measured in meters. Used with forward draft to calculate trim and ensure safe passage.',
    `draft_forward_meters` DECIMAL(18,2) COMMENT 'Vessels draft at the forward perpendicular at the time of movement, measured in meters. Critical for safe navigation and channel depth clearance verification.',
    `duration_minutes` STRING COMMENT 'Total duration of the movement from start to completion, measured in minutes. Used for operational efficiency analysis and billing calculations.',
    `heading_degrees` DECIMAL(18,2) COMMENT 'Vessels heading in degrees (0-360) at the time of movement. 0/360 represents North, 90 represents East, 180 represents South, 270 represents West.',
    `imdg_class` STRING COMMENT 'IMDG classification of dangerous goods on board during movement. Null if no dangerous cargo. Multiple classes may be present; this captures the highest-risk class.',
    `isps_security_level` STRING COMMENT 'ISPS security level in effect at the time of movement. Level 1 is normal, Level 2 is heightened, Level 3 is exceptional. Affects movement procedures and clearance requirements.. Valid values are `level_1|level_2|level_3`',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this movement record was last modified. Audit trail timestamp for tracking changes to movement details.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the vessels position at the time of movement event recording. Expressed in decimal degrees, positive for North, negative for South.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the vessels position at the time of movement event recording. Expressed in decimal degrees, positive for East, negative for West.',
    `movement_number` STRING COMMENT 'Business identifier for the movement event, typically assigned by VTS (Vessel Traffic Service) or port operations. Externally-known reference number for this movement.',
    `movement_status` STRING COMMENT 'Current lifecycle status of the movement event. Tracks the movement through its workflow from scheduling to completion.. Valid values are `scheduled|in_progress|completed|cancelled|delayed`',
    `movement_timestamp` TIMESTAMP COMMENT 'The actual date and time when the movement event occurred. Principal business event timestamp for this transaction. Recorded in UTC and converted to local port time for operational reporting.',
    `movement_type` STRING COMMENT 'Classification of the movement event. Defines the nature of the vessels movement within port waters: arrival (entering port), departure (leaving port), shifting (moving between berths), anchorage entry/exit, or canal transit.. Valid values are `arrival|departure|shifting|anchorage_entry|anchorage_exit|canal_transit`',
    `number_of_tugs` STRING COMMENT 'Count of tug vessels assisting with this movement. Zero if no tug assistance was provided. Used for resource planning and billing.',
    `origin_location_code` STRING COMMENT 'Code identifying the starting location of the movement. May reference a berth, anchorage, or port boundary point. For arrivals, this is typically the port entrance or pilot boarding ground.',
    `pilot_on_board_flag` BOOLEAN COMMENT 'Indicates whether a marine pilot was on board the vessel during this movement. True if pilot was present, False otherwise. Critical for safety and regulatory compliance tracking.',
    `remarks` STRING COMMENT 'Free-text operational notes and observations recorded by VTS operators or pilots during the movement. Captures special circumstances, incidents, or noteworthy events.',
    `scheduled_movement_timestamp` TIMESTAMP COMMENT 'The planned date and time for the movement event. Used for comparison against actual movement timestamp to calculate delays and measure operational performance.',
    `speed_over_ground_knots` DECIMAL(18,2) COMMENT 'Vessels speed over ground at the time of movement, measured in knots. Captured from AIS (Automatic Identification System) or VTS radar tracking.',
    `tide_height_meters` DECIMAL(18,2) COMMENT 'Tidal height above chart datum at the time of movement, measured in meters. Critical for under-keel clearance calculations.',
    `tug_assistance_flag` BOOLEAN COMMENT 'Indicates whether tug assistance was provided during this movement. True if tugs were used, False otherwise. Important for operational cost allocation and safety analysis.',
    `visibility_meters` DECIMAL(18,2) COMMENT 'Horizontal visibility distance at the time of movement, measured in meters. Critical safety parameter for navigation in restricted waters.',
    `vts_clearance_number` STRING COMMENT 'Unique clearance reference number issued by VTS (Vessel Traffic Service) authorizing this movement. Required for all movements within VTS-controlled waters per SOLAS regulations.',
    `vts_reporting_channel` STRING COMMENT 'VHF radio channel used for VTS communication during this movement. Typically a designated port operations channel (e.g., Channel 12, Channel 14).',
    `weather_condition` STRING COMMENT 'Prevailing weather conditions at the time of movement. Recorded for safety analysis and incident investigation purposes.. Valid values are `clear|cloudy|rain|fog|storm|snow`',
    `wind_direction_degrees` DECIMAL(18,2) COMMENT 'Wind direction at the time of movement, expressed in degrees (0-360). 0/360 represents wind from North.',
    `wind_speed_knots` DECIMAL(18,2) COMMENT 'Wind speed at the time of movement, measured in knots. Affects vessel maneuverability and is recorded for safety analysis.',
    CONSTRAINT pk_movement PRIMARY KEY(`movement_id`)
) COMMENT 'Granular transactional record of each discrete vessel movement event within port waters as tracked by the VTS (Vessel Traffic Service). Captures movement type (arrival, departure, shifting, anchorage entry/exit, canal transit), movement timestamp, position at movement (latitude/longitude), speed over ground, heading, pilot on board flag, tug assistance flag, VTS clearance number, reporting channel, and movement status. Provides the detailed audit trail of vessel traffic for VTMS reporting, safety investigations, and port throughput analytics.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` (
    `vts_log_id` BIGINT COMMENT 'Primary key for vts_log',
    `anchorage_id` BIGINT COMMENT 'Identifier of the anchorage area where the vessel was located during the VTS communication, if applicable. Links to anchorage master data.',
    `employee_id` BIGINT COMMENT 'Identifier of the VTS watch officer who recorded or handled this communication. Links to workforce/employee master data.',
    `marine_incident_id` BIGINT COMMENT 'Identifier linking this VTS log entry to a formal incident record, if the communication was related to a safety incident or emergency. Null if no incident.',
    `pilot_id` BIGINT COMMENT 'Identifier of the marine pilot on board the vessel during the VTS communication, if applicable. Links to pilot master data. Null if no pilot on board.',
    `call_id` BIGINT COMMENT 'Identifier of the port call associated with this VTS log entry, if applicable. Links to the specific vessel visit.',
    `terminal_berth_allocation_id` BIGINT COMMENT 'Identifier of the berth allocation associated with this VTS communication, if the communication relates to berthing operations. Links to berth allocation planning data.',
    `vessel_id` BIGINT COMMENT 'Identifier of the vessel involved in this VTS communication or traffic event. Links to vessel master data.',
    `acknowledgement_status` STRING COMMENT 'Status indicating whether the vessel acknowledged the VTS communication. Values: Acknowledged (vessel confirmed receipt), Not Acknowledged (no response received), Pending (awaiting response), Not Required (acknowledgement not needed for this message type).. Valid values are `Acknowledged|Not Acknowledged|Pending|Not Required`',
    `acknowledgement_timestamp` TIMESTAMP COMMENT 'Date and time when the vessel acknowledged the VTS communication, if applicable. Null if not acknowledged or acknowledgement not required.',
    `ais_message_reference` STRING COMMENT 'Identifier of the AIS message associated with this VTS log entry, if the communication was triggered by or included AIS data. Links to AIS message logs.',
    `communication_channel` STRING COMMENT 'The communication medium or channel used for the VTS interaction (e.g., VHF radio channel, telephone, AIS, email). [ENUM-REF-CANDIDATE: VHF Channel 12|VHF Channel 14|VHF Channel 16|Telephone|AIS|Email|Radio — 7 candidates stripped; promote to reference product]',
    `incident_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this VTS log entry is associated with a safety incident, near-miss, or emergency event requiring investigation or follow-up.',
    `instruction_compliance_status` STRING COMMENT 'Status indicating whether the vessel complied with VTS instructions. Complied (vessel followed directive), Non-Compliant (vessel did not follow directive), Partial (vessel partially followed), Not Applicable (no instruction given).. Valid values are `Complied|Non-Compliant|Partial|Not Applicable`',
    `isps_security_level` STRING COMMENT 'The ISPS security level in effect at the time of the VTS communication. Level 1 (normal), Level 2 (heightened), Level 3 (exceptional). Relevant for compliance and incident investigation.. Valid values are `Level 1|Level 2|Level 3`',
    `log_timestamp` TIMESTAMP COMMENT 'Date and time when the VTS communication or traffic event occurred. This is the operational event time, not the record creation time.',
    `message_content` STRING COMMENT 'Summary or full text of the VTS communication message content. Captures the substance of the instruction, advisory, warning, or information exchanged.',
    `message_type` STRING COMMENT 'Classification of the VTS message or communication type: clearance (permission to proceed), instruction (directive action), advisory (recommendation), warning (hazard alert), information (status update), query (request for information), or acknowledgement (confirmation). [ENUM-REF-CANDIDATE: Clearance|Instruction|Advisory|Warning|Information|Query|Acknowledgement — 7 candidates stripped; promote to reference product]',
    `pilot_on_board_flag` BOOLEAN COMMENT 'Boolean flag indicating whether a marine pilot was on board the vessel at the time of the VTS communication. Relevant for understanding vessel control and responsibility.',
    `priority_level` STRING COMMENT 'Priority classification of the VTS communication. Routine (standard traffic management), Priority (time-sensitive operational matter), Urgent (safety-critical), Distress (emergency requiring immediate action).. Valid values are `Routine|Priority|Urgent|Distress`',
    `record_created_by` STRING COMMENT 'User ID or system identifier of the person or process that created this VTS log record. Audit trail for accountability.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Date and time when this VTS log record was created in the system. Audit trail for data lineage and compliance.',
    `record_updated_by` STRING COMMENT 'User ID or system identifier of the person or process that last updated this VTS log record. Audit trail for accountability.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this VTS log record was last updated in the system. Audit trail for data lineage and compliance.',
    `remarks` STRING COMMENT 'Additional free-text remarks or notes recorded by the VTS watch officer regarding this communication or traffic event. Captures context, observations, or follow-up actions.',
    `response_time_seconds` STRING COMMENT 'Time elapsed in seconds between the VTS communication being sent and the vessel acknowledgement being received. Used for VTS performance monitoring and SLA compliance.',
    `traffic_density` STRING COMMENT 'Assessment of vessel traffic density in the VTS area at the time of the communication. Light (few vessels), Moderate (normal traffic), Heavy (high volume), Congested (capacity constraints).. Valid values are `Light|Moderate|Heavy|Congested`',
    `vessel_course_degrees` DECIMAL(18,2) COMMENT 'Course or heading of the vessel at the time of the VTS communication, measured in degrees (0-360) from true north.',
    `vessel_position_latitude` DECIMAL(18,2) COMMENT 'Latitude coordinate of the vessel at the time of the VTS communication, in decimal degrees. Positive for North, negative for South.',
    `vessel_position_longitude` DECIMAL(18,2) COMMENT 'Longitude coordinate of the vessel at the time of the VTS communication, in decimal degrees. Positive for East, negative for West.',
    `vessel_speed_knots` DECIMAL(18,2) COMMENT 'Speed of the vessel at the time of the VTS communication, measured in knots (nautical miles per hour).',
    `visibility_meters` STRING COMMENT 'Visibility distance in meters at the time of the VTS communication. Critical for assessing navigation safety and VTS decision-making.',
    `vts_area_zone` STRING COMMENT 'The specific VTS area or zone within the port VTS coverage where the vessel was located during this communication (e.g., Approach Zone, Inner Harbor, Anchorage Area).',
    `vts_centre_code` BIGINT COMMENT 'Identifier of the VTS centre that recorded this log entry. Links to the VTS centre master data.',
    `weather_condition` STRING COMMENT 'Description of the prevailing weather conditions at the time of the VTS communication (e.g., clear, fog, heavy rain, strong winds). Relevant for incident investigation and traffic management analysis.',
    CONSTRAINT pk_vts_log PRIMARY KEY(`vts_log_id`)
) COMMENT 'Operational log maintained by the Vessel Traffic Service (VTS) centre recording all VTS communications, instructions, and traffic management actions for vessels within the ports VTS area. Captures VTS centre identifier, watch officer, vessel identifier, communication channel, message type (clearance, instruction, advisory, warning), message content summary, timestamp, and acknowledgement status. Supports ISPS compliance, incident investigation, and VTS performance auditing. Distinct from vessel_movement which tracks positional events.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` (
    `call_document_id` BIGINT COMMENT 'Primary key for call_document',
    `agent_appointment_id` BIGINT COMMENT 'Reference to the shipping agent, vessel operator, or authorized representative who submitted the document.',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Vessel call documents (FAL Form 3 cargo declaration, FAL Form 4 ships stores) directly reference customs declarations for cargo clearance and stores declaration. Port single windows require linking F',
    `previous_document_call_document_id` BIGINT COMMENT 'Reference to the previous version of this document if this is an amendment or resubmission.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Port authority officers review FAL forms, cargo manifests, and ISPS declarations for regulatory compliance. Mandatory for customs clearance workflows, port health authority coordination, and IMO FAL C',
    `un_locode_id` BIGINT COMMENT 'Foreign key linking to masterdata.un_locode. Business justification: FAL forms (IMO Convention) require standardized UN/LOCODE for port identification in customs declarations, immigration manifests, and cargo declarations. Ensures regulatory compliance with IMO FAL Con',
    `call_id` BIGINT COMMENT 'Reference to the port call for which this document was submitted.',
    `amendment_count` STRING COMMENT 'Number of times this document has been amended or resubmitted after initial submission.',
    `authority_acknowledgement_timestamp` TIMESTAMP COMMENT 'Date and time when the regulatory authority acknowledged receipt or processed the document.',
    `authority_reference_number` STRING COMMENT 'Reference number assigned by the regulatory authority upon receipt or approval of the document.',
    `cargo_manifest_reference` STRING COMMENT 'Reference number of the cargo manifest document. Applicable to cargo manifest documents.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this document record was first created in the system.',
    `crew_change_count` STRING COMMENT 'Number of crew members joining or leaving the vessel during this port call. Applicable to crew list documents.',
    `crew_count` STRING COMMENT 'Total number of crew members listed on the crew list (FAL Form 5). Applicable only to crew list documents.',
    `customs_clearance_status` STRING COMMENT 'Status of customs clearance for this document. Applicable to customs declaration documents.. Valid values are `pending|cleared|inspection_required|hold|released`',
    `dangerous_goods_flag` BOOLEAN COMMENT 'Indicates whether the vessel is carrying dangerous goods as defined by IMDG Code. Applicable to cargo manifest and dangerous goods declaration documents.',
    `document_file_path` STRING COMMENT 'Storage path or URI to the digital copy of the submitted document in the document management system.',
    `document_format` STRING COMMENT 'File format or medium of the submitted document. [ENUM-REF-CANDIDATE: pdf|xml|json|edi|csv|image|paper — 7 candidates stripped; promote to reference product]',
    `document_reference_number` STRING COMMENT 'Unique external reference number assigned to the document by the submitting party or regulatory authority.',
    `document_status` STRING COMMENT 'Current processing status of the document in the port clearance workflow. [ENUM-REF-CANDIDATE: draft|submitted|under_review|accepted|rejected|amended|withdrawn|expired — 8 candidates stripped; promote to reference product]',
    `document_type` STRING COMMENT 'Classification of the document according to IMO FAL Convention and port authority requirements. [ENUM-REF-CANDIDATE: general_declaration|crew_list|passenger_list|cargo_manifest|stores_list|crew_effects_declaration|health_declaration|maritime_declaration_health|waste_notification|isps_declaration|dangerous_goods_manifest|ballast_water_reporting|ship_sanitation_certificate|customs_declaration|immigration_declaration|port_clearance|other — 17 candidates stripped; promote to reference product]',
    `edi_message_type` STRING COMMENT 'Electronic Data Interchange (EDI) message type code if the document was submitted via EDI (e.g., IFTMIN, COPARN, BAPLIE).',
    `expiry_date` DATE COMMENT 'Date when the document expires or is no longer valid, if applicable (e.g., certificates, permits).',
    `fal_form_number` STRING COMMENT 'IMO Facilitation (FAL) Convention form number if applicable (e.g., FAL Form 1 for General Declaration, FAL Form 5 for Crew List).',
    `health_illness_description` STRING COMMENT 'Description of any illness, symptoms, or health conditions reported onboard. Applicable to health declaration documents.',
    `health_illness_onboard_flag` BOOLEAN COMMENT 'Indicates whether there are any cases of illness or health concerns onboard requiring port health notification. Applicable to health declaration documents.',
    `health_sanitation_certificate_number` STRING COMMENT 'Ship Sanitation Certificate or Ship Sanitation Control Exemption Certificate number. Applicable to health declaration documents.',
    `imdg_class` STRING COMMENT 'IMDG Code classification of dangerous goods onboard (e.g., Class 1: Explosives, Class 3: Flammable Liquids). Applicable to dangerous goods declaration documents. [ENUM-REF-CANDIDATE: class_1_explosives|class_2_gases|class_3_flammable_liquids|class_4_flammable_solids|class_5_oxidizing|class_6_toxic|class_7_radioactive|class_8_corrosive|class_9_miscellaneous — promote to reference product]',
    `isps_current_security_level` STRING COMMENT 'Current ship security level (1: normal, 2: heightened, 3: exceptional) as declared under ISPS Code. Applicable to ISPS security declaration documents.',
    `isps_dos_required` BOOLEAN COMMENT 'Indicates whether a Declaration of Security (DoS) is required for this port call under ISPS Code. Applicable to ISPS security declaration documents.',
    `isps_issc_number` STRING COMMENT 'International Ship Security Certificate number issued under ISPS Code. Applicable to ISPS security declaration documents.',
    `isps_last_ten_ports` STRING COMMENT 'Comma-separated list of the last ten ports of call with their security levels, as required by ISPS Code. Applicable to ISPS security declaration documents.',
    `isps_security_incident_flag` BOOLEAN COMMENT 'Indicates whether any security incidents occurred since the last port of call. Applicable to ISPS security declaration documents.',
    `isps_sso_name` STRING COMMENT 'Name of the Ship Security Officer (SSO) responsible for vessel security. Applicable to ISPS security declaration documents.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this document record was last updated or modified.',
    `marpol_waste_type` STRING COMMENT 'Type of waste being declared according to MARPOL Annexes (I: oil, II: noxious liquid substances, III: harmful packaged substances, IV: sewage, V: garbage, VI: air emissions). Applicable only to waste notification documents. [ENUM-REF-CANDIDATE: annex_i_oil|annex_ii_noxious_liquid|annex_iii_harmful_packaged|annex_iv_sewage|annex_v_garbage|annex_vi_air_emissions — promote to reference product]',
    `passenger_count` STRING COMMENT 'Total number of passengers listed on the passenger list (FAL Form 6). Applicable only to passenger list documents.',
    `reception_facility_name` STRING COMMENT 'Name of the port reception facility that received the waste. Applicable to waste notification documents.',
    `regulatory_authority` STRING COMMENT 'Primary regulatory body or government agency responsible for reviewing and approving this document type. [ENUM-REF-CANDIDATE: port_authority|customs|immigration|health|maritime_safety|environmental|security|quarantine|agriculture — 9 candidates stripped; promote to reference product]',
    `rejection_reason` STRING COMMENT 'Explanation provided by the regulatory authority if the document was rejected, including required corrections.',
    `remarks` STRING COMMENT 'Additional notes, comments, or special instructions related to the document submission or processing.',
    `submission_channel` STRING COMMENT 'Channel through which the document was submitted to port authorities. [ENUM-REF-CANDIDATE: pcs|edi|email|manual|web_portal|mobile_app|api — 7 candidates stripped; promote to reference product]',
    `submission_timestamp` TIMESTAMP COMMENT 'Date and time when the document was submitted to the port authority or regulatory body.',
    `submitting_agent_name` STRING COMMENT 'Name of the organization or individual who submitted the document on behalf of the vessel.',
    `waste_actual_volume_m3` DECIMAL(18,2) COMMENT 'Actual volume of waste discharged at port reception facility, measured in cubic meters (CBM). Applicable to waste notification documents.',
    `waste_delivery_confirmation_number` STRING COMMENT 'Confirmation receipt number issued by the port reception facility upon waste delivery. Applicable to waste notification documents.',
    `waste_estimated_volume_m3` DECIMAL(18,2) COMMENT 'Estimated volume of waste to be discharged at port reception facility, measured in cubic meters (CBM). Applicable to waste notification documents.',
    CONSTRAINT pk_call_document PRIMARY KEY(`call_document_id`)
) COMMENT 'Consolidated master record of all official documentation, regulatory declarations, and compliance submissions for a port call. Encompasses: (1) General declarations (IMO FAL Form 1), (2) Crew lists (FAL Form 5) including crew member details, nationality, rank, passport/seafarer book numbers, STCW references, and crew change records, (3) Cargo manifests and stores lists, (4) Health declarations, (5) Waste notifications per MARPOL Annexes I-VI and EU PRF Directive including waste type, estimated/actual volumes, reception facility, and delivery confirmation, (6) ISPS security declarations including ISSC number, current ship security level, last 10 ports with security levels, SSO identification, Declaration of Security details, and security incident records, (7) All other documents required by IMO FAL Convention and national port authority regulations. Captures document type, document reference number, submission channel (PCS/EDI/manual), submission timestamp, submitting agent, document status (submitted, accepted, rejected, amended), regulatory authority acknowledgement, and type-specific attributes. Supports Port Community System (PCS) integration, customs clearance workflows, ISPS compliance, immigration screening, environmental reporting, and port health notifications.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` (
    `certificate_id` BIGINT COMMENT 'Primary key for certificate',
    `compliance_audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Vessel certificates (ISM DOC, ISPS, class certificates) undergo periodic compliance audits by classification societies, flag states, and certification bodies. Audit records must reference the certific',
    `marine_incident_id` BIGINT COMMENT 'Foreign key linking to marine.incident. Business justification: Certificate deficiencies, expirations, or suspensions discovered during operations (e.g., expired ISSC during ISPS check, invalid class certificate during cargo ops) trigger safety incidents requiring',
    `psc_inspection_id` BIGINT COMMENT 'Unique identifier assigned by the PSC authority for the inspection event. Applicable when record_type is psc_inspection.',
    `security_audit_id` BIGINT COMMENT 'Foreign key linking to security.security_audit. Business justification: Security audits verify vessel ISSC certificates and security compliance documentation. Auditors examine certificate validity, survey dates, and PSC inspection history to assess ISPS Code conformance. ',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Port operations staff verify vessel certificates (ISSC, class certificates, MARPOL) during clearance and PSC inspections. Required for port state control workflows, detention risk assessment, and regu',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel to which this certificate or inspection applies.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Certificate requirements and survey intervals vary by vessel type - SOLAS chapter applicability, MARPOL annex requirements, and classification society rules are type-specific. Essential for compliance',
    `annual_survey_due_date` DATE COMMENT 'Due date for the next annual survey required to maintain certificate validity. Annual surveys are typically required within 3 months before or after the anniversary date.',
    `certificate_number` STRING COMMENT 'Unique certificate number assigned by the issuing authority. Applicable when record_type is certificate. Examples include SOLAS Safety Construction Certificate number, Load Line Certificate number, MARPOL IOPP Certificate number.',
    `certificate_status` STRING COMMENT 'Current validity status of the certificate. Valid indicates the certificate is in force. Expired indicates the certificate has passed its expiry date. Suspended indicates temporary suspension by the authority. Withdrawn indicates permanent revocation. Pending renewal indicates the certificate is under renewal process.. Valid values are `valid|expired|suspended|withdrawn|pending_renewal`',
    `certificate_type` STRING COMMENT 'Type of statutory or class certificate. SOLAS (Safety of Life at Sea) certificates include Safety Construction, Safety Equipment, Safety Radio. MARPOL (Marine Pollution Convention) certificates include IOPP (International Oil Pollution Prevention), NLS (Noxious Liquid Substances). ISM (International Safety Management) includes DOC (Document of Compliance) and SMC (Safety Management Certificate). ISPS (International Ship and Port Facility Security) includes ISSC (International Ship Security Certificate). MLC (Maritime Labour Convention), Tonnage, Classification, CLC (Civil Liability Convention) / Bunker Convention certificates also tracked. [ENUM-REF-CANDIDATE: solas_safety_construction|solas_safety_equipment|solas_safety_radio|load_line|marpol_iopp|marpol_nls|ism_doc|ism_smc|isps_issc|mlc|tonnage|classification|clc_bunker_convention|other — 14 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this certificate or inspection record was first created in the system.',
    `data_source_system` STRING COMMENT 'Name of the source system from which this certificate or inspection record was ingested. Examples: NAVIS N4, VTMS, Port Community System, Manual Entry.',
    `deficiency_codes` STRING COMMENT 'Comma-separated list of deficiency codes identified during the PSC inspection, per the MOU convention deficiency code list. Examples: 01106 (Certificates & Documentation - SOLAS), 07113 (Fire Safety - Fire Doors), 11101 (Life-Saving Appliances - Lifeboats).',
    `detention_end_date` DATE COMMENT 'Date on which the vessel detention was lifted after deficiencies were rectified and re-inspection was satisfactory. Applicable only if detention_flag is true.',
    `detention_flag` BOOLEAN COMMENT 'Boolean indicator of whether the vessel was detained as a result of the PSC inspection. True indicates detention occurred. False indicates no detention. Detention prevents the vessel from sailing until deficiencies are rectified.',
    `detention_start_date` DATE COMMENT 'Date on which the vessel detention commenced following the PSC inspection. Applicable only if detention_flag is true.',
    `document_url` STRING COMMENT 'URL or file path to the scanned certificate document stored in the document management system.',
    `expiry_date` DATE COMMENT 'Date on which the certificate expires and must be renewed. Critical for port entry eligibility checks.',
    `follow_up_action_description` STRING COMMENT 'Detailed description of the follow-up actions required, including rectification steps, re-inspection requirements, or flag state notifications.',
    `follow_up_action_required` BOOLEAN COMMENT 'Boolean indicator of whether follow-up action is required by the vessel operator or flag state. True indicates follow-up is needed. False indicates no further action required.',
    `inspecting_officer_name` STRING COMMENT 'Name of the PSC officer who conducted the inspection. Business-confidential operational data.',
    `inspection_outcome` STRING COMMENT 'Overall outcome of the PSC inspection. No deficiencies indicates a clean inspection. Deficiencies rectified indicates issues were resolved before departure. Deficiencies outstanding indicates issues remain to be addressed. Detained indicates the vessel was held in port. Banned indicates the vessel is prohibited from entering ports in the MOU region.. Valid values are `no_deficiencies|deficiencies_rectified|deficiencies_outstanding|detained|banned`',
    `inspection_port` STRING COMMENT 'Name of the port where the PSC inspection was conducted.',
    `inspection_port_code` STRING COMMENT 'UN/LOCODE or other standardized code for the port where the PSC inspection was conducted.',
    `inspection_report_url` STRING COMMENT 'URL or file path to the full PSC inspection report document stored in the document management system.',
    `inspection_type` STRING COMMENT 'Type of PSC inspection conducted. Initial inspection is a standard check. More detailed inspection is triggered by deficiencies or risk factors. Expanded inspection is a comprehensive examination. Concentrated Inspection Campaign (CIC) focuses on specific themes (e.g., MARPOL compliance, crew welfare).. Valid values are `initial|more_detailed|expanded|concentrated_inspection_campaign`',
    `intermediate_survey_due_date` DATE COMMENT 'Due date for the next intermediate survey, typically required at the second or third anniversary of the certificate issue date.',
    `issue_date` DATE COMMENT 'Date on which the certificate was issued by the authority.',
    `issuing_authority` STRING COMMENT 'Name of the flag state administration or Recognized Organization (RO) that issued the certificate. Examples: Panama Maritime Authority, Liberia Registry, Lloyds Register, DNV GL, American Bureau of Shipping.',
    `issuing_authority_code` STRING COMMENT 'Standardized code for the issuing authority or RO. Examples: LR (Lloyds Register), DNV (Det Norske Veritas), ABS (American Bureau of Shipping), BV (Bureau Veritas).',
    `last_survey_date` DATE COMMENT 'Date of the most recent survey conducted for this certificate (annual, intermediate, or renewal).',
    `last_survey_type` STRING COMMENT 'Type of the most recent survey conducted. Annual surveys verify ongoing compliance. Intermediate surveys are more comprehensive mid-term inspections. Renewal surveys are conducted for certificate renewal. Special surveys address specific issues. Damage surveys assess vessel condition after incidents.. Valid values are `annual|intermediate|renewal|special|damage`',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this certificate or inspection record was last modified in the system.',
    `psc_authority` STRING COMMENT 'Name of the PSC authority or MOU region that conducted the inspection. Examples: Paris MOU (Europe), Tokyo MOU (Asia-Pacific), Indian Ocean MOU, US Coast Guard, AMSA (Australian Maritime Safety Authority).',
    `psc_authority_code` STRING COMMENT 'Standardized code for the PSC authority or MOU region. Examples: PMOU (Paris MOU), TMOU (Tokyo MOU), IOMOU (Indian Ocean MOU), USCG (US Coast Guard).',
    `psc_inspection_date` DATE COMMENT 'Date on which the PSC inspection was conducted at the port.',
    `record_type` STRING COMMENT 'Discriminator indicating whether this record represents a statutory/class certificate or a Port State Control (PSC) inspection event.. Valid values are `certificate|psc_inspection`',
    `rectification_deadline` DATE COMMENT 'Deadline by which identified deficiencies must be rectified. May be set for the next port, within 14 days, or before departure depending on deficiency severity.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, observations, or context related to the certificate or PSC inspection. May include inspector comments, vessel operator responses, or operational notes.',
    `renewal_survey_due_date` DATE COMMENT 'Due date for the renewal survey required to issue a new certificate upon expiry of the current certificate.',
    `ship_risk_profile` STRING COMMENT 'Risk classification of the vessel based on PSC inspection history, flag state performance, recognized organization performance, company performance, and vessel age. Used for PSC targeting and inspection frequency determination per the New Inspection Regime (NIR) under Paris MOU and Tokyo MOU.. Valid values are `low_risk_ship|standard_risk_ship|high_risk_ship`',
    `total_deficiencies` STRING COMMENT 'Total number of deficiencies identified during the PSC inspection. Used for ship risk profile calculation and detention risk assessment.',
    CONSTRAINT pk_certificate PRIMARY KEY(`certificate_id`)
) COMMENT 'Unified vessel compliance record encompassing statutory/class certificates and Port State Control (PSC) inspections that verify them. For certificates: captures certificate type (SOLAS Safety Construction, Load Line, MARPOL IOPP, ISM DOC/SMC, ISPS ISSC, MLC, Tonnage, Classification, CLC/Bunker Convention), issuing authority (flag state or RO), certificate number, issue date, expiry date, survey due dates (annual, intermediate, renewal), and certificate status (valid, expired, suspended, withdrawn). For PSC inspections: captures inspection date, PSC authority (Paris MOU, Tokyo MOU, Indian Ocean MOU, etc.), inspecting officer, inspection type (initial, expanded, concentrated inspection campaign), deficiency codes per MOU conventions, total deficiencies, detention flag, detention start/end dates, rectification deadline, inspection outcome, and follow-up actions. Provides the unified vessel compliance profile supporting port entry eligibility checks, PSC targeting (ship risk profile calculation), detention history analysis, and flag state performance monitoring.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` (
    `psc_inspection_id` BIGINT COMMENT 'Primary key for psc_inspection',
    `violation_id` BIGINT COMMENT 'Foreign key linking to compliance.violation. Business justification: PSC inspections detect compliance violations that require formal violation records for enforcement tracking, penalty assessment, and flag state reporting. Maritime authorities require linking inspecti',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: PSC inspections incur costs (inspector time, administrative support, coordination) allocated to regulatory compliance cost centres. Required for compliance cost tracking, regulatory service costing, a',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Port authority assigns internal coordinators to liaise with PSC inspectors, manage documentation, and track rectification. Required for compliance management, detention cost recovery, and port state c',
    `call_id` BIGINT COMMENT 'Reference to the specific port call during which this PSC inspection was conducted.',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: PSC inspections discovering ISPS security deficiencies must create security incident records for corrective action tracking and compliance management. Port State Control officers escalate security non',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel that was inspected during this Port State Control inspection.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: PSC inspection scope and deficiency patterns correlate with vessel type - tankers face MARPOL focus, container ships face cargo securing checks, passenger vessels face SOLAS life-saving equipment scru',
    `areas_inspected` STRING COMMENT 'Comma-separated list of vessel areas and systems inspected during the PSC inspection (e.g., bridge, engine room, accommodation, safety equipment, cargo holds, pollution prevention equipment).',
    `certificates_checked` STRING COMMENT 'Comma-separated list of statutory certificates and documents verified during the inspection (e.g., Safety Construction Certificate, Load Line Certificate, IOPP Certificate, Minimum Safe Manning Document, ISPS Certificate).',
    `clear_grounds_observed` STRING COMMENT 'Description of any clear grounds (overriding or unexpected factors) that justified a more detailed or expanded inspection beyond the initial inspection scope.',
    `conventions_checked` STRING COMMENT 'Comma-separated list of international maritime conventions under which deficiencies were assessed (e.g., SOLAS, MARPOL, Load Lines, STCW, MLC, Tonnage, COLREG, ILO).',
    `crew_interviewed_count` STRING COMMENT 'Number of crew members interviewed during the PSC inspection to verify competency, working conditions, and compliance with Maritime Labour Convention requirements.',
    `detention_duration_hours` DECIMAL(18,2) COMMENT 'Total duration of vessel detention in hours, calculated from detention start to detention end. Null if vessel was not detained.',
    `detention_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the vessel detention was lifted after satisfactory rectification of deficiencies. Null if vessel was not detained or detention is ongoing.',
    `detention_flag` BOOLEAN COMMENT 'Indicates whether the vessel was detained as a result of this PSC inspection due to serious deficiencies posing a danger to persons, property, or the environment.',
    `detention_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the vessel detention order was issued by the PSC authority. Null if vessel was not detained.',
    `flag_state_notification_date` DATE COMMENT 'Date on which the flag state administration was notified of the inspection results. Null if flag state was not notified.',
    `flag_state_notified_flag` BOOLEAN COMMENT 'Indicates whether the vessels flag state administration was notified of the inspection results, particularly in cases of detention or serious deficiencies.',
    `follow_up_port` STRING COMMENT 'Name of the port where follow-up inspection is scheduled or recommended to verify deficiency rectification. Null if no follow-up required.',
    `follow_up_required_flag` BOOLEAN COMMENT 'Indicates whether a follow-up inspection is required to verify rectification of deficiencies that could not be corrected before departure.',
    `inspection_cost_usd` DECIMAL(18,2) COMMENT 'Total cost incurred by the port authority for conducting the PSC inspection, including inspector time, administrative overhead, and any third-party expert fees. Recorded in USD for standardized reporting.',
    `inspection_date` DATE COMMENT 'Date on which the Port State Control inspection was conducted.',
    `inspection_end_time` TIMESTAMP COMMENT 'Timestamp when the PSC inspection was completed and inspectors departed the vessel.',
    `inspection_outcome` STRING COMMENT 'Final outcome classification of the PSC inspection indicating the resolution status of identified deficiencies.. Valid values are `no_deficiencies|deficiencies_rectified_before_departure|deficiencies_rectified_within_14_days|deficiencies_rectified_at_next_port|detained|sailed_with_outstanding_deficiencies`',
    `inspection_reason` STRING COMMENT 'Primary reason or trigger for conducting the PSC inspection: routine selection, priority vessel (high-risk profile), overriding factors (clear grounds), unexpected factors (observed deficiencies), follow-up, complaint from crew or third party, incident-related, or part of a Concentrated Inspection Campaign. [ENUM-REF-CANDIDATE: routine|priority_vessel|overriding_factors|unexpected_factors|follow_up|complaint|incident_related|cic_campaign — 8 candidates stripped; promote to reference product]',
    `inspection_reference_number` STRING COMMENT 'Official reference number assigned by the Port State Control authority for this inspection. Used for tracking and reporting to regional MOU databases.. Valid values are `^[A-Z0-9-]{6,20}$`',
    `inspection_regime` STRING COMMENT 'Regional Memorandum of Understanding (MOU) or national regime under which the inspection was conducted, determining applicable standards and procedures. [ENUM-REF-CANDIDATE: paris_mou|tokyo_mou|indian_ocean_mou|caribbean_mou|mediterranean_mou|black_sea_mou|riyadh_mou|abuja_mou|vina_del_mar_mou|uscg|other — 11 candidates stripped; promote to reference product]',
    `inspection_remarks` STRING COMMENT 'Additional remarks, observations, or contextual notes recorded by the PSC inspectors regarding the inspection, vessel condition, or cooperation of the crew.',
    `inspection_start_time` TIMESTAMP COMMENT 'Timestamp when the PSC inspection commenced on board the vessel.',
    `inspection_type` STRING COMMENT 'Classification of the PSC inspection scope: initial (basic checks), more detailed (extended checks based on risk factors), expanded (comprehensive inspection of all areas), concentrated inspection campaign (CIC - focused thematic inspection), or follow-up (verification of previous deficiency rectification).. Valid values are `initial|more_detailed|expanded|concentrated_inspection_campaign|follow_up`',
    `isps_security_level_at_inspection` STRING COMMENT 'ISPS security level in effect at the port facility at the time of the PSC inspection: Level 1 (normal), Level 2 (heightened), or Level 3 (exceptional).. Valid values are `level_1|level_2|level_3`',
    `lead_inspector_certificate_number` STRING COMMENT 'Official certificate or license number of the lead PSC inspector, verifying their authorization to conduct inspections.',
    `lead_inspector_name` STRING COMMENT 'Full name of the lead PSC inspector who conducted the inspection.',
    `master_notified_timestamp` TIMESTAMP COMMENT 'Timestamp when the vessel master was formally notified of the inspection findings and any deficiencies or detention orders.',
    `port_state_control_report_issued_date` DATE COMMENT 'Date on which the formal PSC inspection report was issued to the vessel master and relevant authorities.',
    `psc_authority_code` STRING COMMENT 'Standardized code identifying the PSC authority, typically aligned with country or regional MOU codes.. Valid values are `^[A-Z]{2,4}$`',
    `psc_authority_name` STRING COMMENT 'Name of the national maritime authority or agency that conducted the inspection (e.g., Maritime and Port Authority, Coast Guard, Flag State Administration).',
    `recognized_organization_notified_flag` BOOLEAN COMMENT 'Indicates whether the Recognized Organization (classification society) that issued the vessels statutory certificates was notified of deficiencies related to their certification scope.',
    `record_created_by` STRING COMMENT 'User ID or system identifier of the person or process that created this PSC inspection record.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this PSC inspection record was first created in the port management system.',
    `record_updated_by` STRING COMMENT 'User ID or system identifier of the person or process that last updated this PSC inspection record.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this PSC inspection record was last modified in the port management system.',
    `rectification_deadline_date` DATE COMMENT 'Date by which all identified deficiencies must be rectified, as specified by the PSC authority. May be immediate (before departure), within 14 days, or at next port.',
    `ship_risk_profile` STRING COMMENT 'Risk classification of the vessel at the time of inspection based on the New Inspection Regime (NIR) ship risk profile calculation, considering flag state performance, recognized organization, vessel type, age, and deficiency history.. Valid values are `high_risk_ship|standard_risk_ship|low_risk_ship|unknown`',
    `total_deficiencies_found` STRING COMMENT 'Total count of deficiencies identified during the PSC inspection across all areas and conventions checked.',
    CONSTRAINT pk_psc_inspection PRIMARY KEY(`psc_inspection_id`)
) COMMENT 'Transactional record of a Port State Control (PSC) inspection conducted on a vessel during a port call. Captures inspection date, PSC authority, inspecting officer, inspection type (initial, expanded, concentrated inspection campaign), total deficiencies found, detention flag, detention start and end dates, deficiency codes (per Paris/Tokyo MOU), rectification deadline, and inspection outcome (no deficiencies, deficiencies rectified, detained). Supports port authority compliance reporting and vessel risk profiling.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` (
    `agent_appointment_id` BIGINT COMMENT 'Primary key for agent_appointment',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Agent appointments are formalized through agency agreements defining scope, commission rates, financial authority, and service fees. Essential for billing reconciliation, commission calculation, and d',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Port authority officers approve agent appointments, verify credentials, and manage ISPS security clearances. Essential for regulatory control, security compliance, and commercial relationship manageme',
    `contractor_safety_id` BIGINT COMMENT 'Foreign key linking to safety.contractor_safety. Business justification: Ship agents engage contractors for vessel services (stevedoring, waste disposal, repairs, bunkering). Agent appointments must reference contractor safety qualifications, insurance certificates, and sa',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Agent coordination, oversight, and port community system management generate costs allocated to port operations cost centres. Required for agency management cost allocation and operational expense tra',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Vessel agents appoint customs brokers for cargo clearance and customs declaration submission on behalf of vessel operators. This link enables agent-broker coordination tracking, customs clearance auth',
    `call_id` BIGINT COMMENT 'Reference to the specific port call for which the agent is appointed. Nullable for standing appointments not tied to a single call.',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the shipping agent company appointed to represent the vessel or owner. Links to the participant master record in the customer domain.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel for which the agent is appointed. Links to the vessel master record.',
    `agency_type` STRING COMMENT 'Classification of the agent appointment role. General agent handles all vessel matters; husbanding agent provides operational support; cargo agent manages cargo documentation; protective agent represents owner interests; liner agent serves scheduled services; port agent provides local representation.. Valid values are `general_agent|husbanding_agent|cargo_agent|protective_agent|liner_agent|port_agent`',
    `appointment_agreement_reference` STRING COMMENT 'Reference to the formal agency agreement or contract document that governs the terms and conditions of the agent appointment.',
    `appointment_end_date` DATE COMMENT 'The date on which the agent appointment expires or is scheduled to terminate. Nullable for indefinite appointments.',
    `appointment_reason` STRING COMMENT 'Free-text description of the business reason or circumstances that led to this agent appointment, such as regular service, emergency replacement, or special cargo handling.',
    `appointment_reference_number` STRING COMMENT 'External business identifier for the agent appointment, often provided by the agent company or vessel operator for tracking and invoicing purposes.',
    `appointment_scope` STRING COMMENT 'Defines the coverage extent of the agent appointment. Single call for one port visit; voyage series for a defined set of calls; annual contract for all calls within a year; indefinite for ongoing representation.. Valid values are `single_call|voyage_series|annual_contract|indefinite`',
    `appointment_start_date` DATE COMMENT 'The date from which the agent appointment becomes effective and the agent is authorized to act on behalf of the vessel or owner.',
    `appointment_status` STRING COMMENT 'Current lifecycle state of the agent appointment. Pending awaits confirmation; active is in force; suspended is temporarily inactive; terminated is ended early; expired has reached natural end date.. Valid values are `pending|active|suspended|terminated|expired`',
    `billing_address_routing` STRING COMMENT 'Specifies to whom port invoices and charges should be addressed. Agent routes to agent company; owner to vessel owner; operator to vessel operator; charterer to the charterer.. Valid values are `agent|owner|operator|charterer`',
    `commission_rate_percent` DECIMAL(18,2) COMMENT 'The percentage commission rate payable to the agent for services rendered, typically applied to port charges or cargo handling fees.',
    `customs_clearance_authority` BOOLEAN COMMENT 'Indicates whether the agent is authorized to handle customs clearance procedures and submit customs declarations on behalf of the vessel.',
    `disbursement_account_reference` STRING COMMENT 'Reference to the disbursement account used by the agent for settling port charges, pilotage fees, and other expenses on behalf of the vessel.',
    `document_submission_authority` BOOLEAN COMMENT 'Indicates whether the agent is authorized to submit official port and customs documentation on behalf of the vessel or owner. True grants submission rights; false restricts to coordination only.',
    `edi_enabled_flag` BOOLEAN COMMENT 'Indicates whether the agent company is enabled for electronic data interchange messaging with the port community system for automated document submission and status updates.',
    `edi_participant_code` STRING COMMENT 'Unique EDI participant identifier assigned to the agent company within the port community system for message routing and authentication.',
    `emergency_contact_phone` STRING COMMENT '24/7 emergency telephone number for the agent company to handle urgent vessel matters outside business hours.',
    `financial_authority_flag` BOOLEAN COMMENT 'Indicates whether the agent has authority to commit to financial obligations and sign invoices on behalf of the vessel owner or operator.',
    `isps_security_clearance_status` STRING COMMENT 'Security clearance status of the agent company under ISPS Code requirements. Cleared allows port facility access; pending awaits approval; denied restricts access; expired requires renewal.. Valid values are `cleared|pending|denied|expired`',
    `performance_rating` STRING COMMENT 'Qualitative assessment of the agents performance during the appointment period. Used for future agent selection and relationship management.. Valid values are `excellent|good|satisfactory|poor|not_rated`',
    `port_facility_access_permit_number` STRING COMMENT 'Unique identifier of the port facility access permit issued to the agent company, required for physical access to restricted port areas.',
    `primary_contact_email` STRING COMMENT 'Email address of the primary contact person at the agent company for operational correspondence and document submission.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_contact_name` STRING COMMENT 'Full name of the primary contact person at the agent company responsible for this appointment. Used for operational coordination and communication.',
    `primary_contact_phone` STRING COMMENT 'Telephone number of the primary contact person at the agent company for urgent operational matters and coordination.',
    `proforma_disbursement_account_required` BOOLEAN COMMENT 'Indicates whether a proforma disbursement account statement must be issued before the vessel arrival for advance payment of estimated port charges.',
    `record_created_by` STRING COMMENT 'User identifier or system account that created this agent appointment record. Audit trail field.',
    `record_created_timestamp` TIMESTAMP COMMENT 'The date and time when this agent appointment record was first created in the system. Audit trail field.',
    `record_updated_by` STRING COMMENT 'User identifier or system account that last modified this agent appointment record. Audit trail field.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this agent appointment record was last modified. Audit trail field.',
    `remarks` STRING COMMENT 'Additional free-text notes or comments regarding the agent appointment, special instructions, or operational considerations.',
    `service_fee_structure` STRING COMMENT 'Defines how the agent is compensated. Fixed per call charges a set amount; percentage commission applies a rate to charges; time and materials bills actual hours; hybrid combines methods.. Valid values are `fixed_per_call|percentage_commission|time_and_materials|hybrid`',
    `termination_notice_date` DATE COMMENT 'The date on which formal notice of termination was given by either party. Used to track notice period compliance per agency agreement terms.',
    `termination_reason` STRING COMMENT 'Free-text description of the reason for early termination of the agent appointment, if applicable. Nullable for active or naturally expired appointments.',
    CONSTRAINT pk_agent_appointment PRIMARY KEY(`agent_appointment_id`)
) COMMENT 'Association record linking a vessel or port call to its appointed port agent (shipping agent). Captures agent company reference, agency appointment type (general agent, husbanding agent, cargo agent, protective agent), appointment start and end dates, appointment scope (single call, voyage series, annual), primary contact name, and appointment status. Supports port call coordination, document submission authority, and billing address routing. Distinct from the customer domain which holds the full agent company master record.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` (
    `call_schedule_id` BIGINT COMMENT 'Primary key for call_schedule',
    `port_location_id` BIGINT COMMENT 'add column port_location_id (BIGINT) with FK to masterdata.port_location.port_location_id - vessel call schedules must reference the port location for scheduling context',
    `shipping_line_id` BIGINT COMMENT 'add column shipping_line_id (BIGINT) with FK to masterdata.shipping_line.shipping_line_id - call schedules are published by shipping lines for their service rotations',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel scheduled for this port call. Links to the vessel master data.',
    `alliance_designation` STRING COMMENT 'Name of the shipping alliance if this service is part of a carrier alliance (e.g., 2M, Ocean Alliance, THE Alliance). Null for independent services.',
    `average_vessel_capacity_teu` STRING COMMENT 'Average container capacity in TEU of vessels deployed on this service. Used for capacity planning and commercial forecasting.',
    `berth_preference` STRING COMMENT 'Preferred berth or berth zone requested by the shipping line or agent for this scheduled call. Used in berth allocation planning.',
    `commercial_agreement_reference` STRING COMMENT 'Reference to the commercial service agreement or contract governing this scheduled service. Links to tariff and SLA terms.',
    `forecast_cargo_volume_teu` STRING COMMENT 'Forecasted container volume in TEU expected to be loaded and discharged at this port call. Used for yard planning and equipment allocation.',
    `forecast_discharge_teu` STRING COMMENT 'Forecasted number of TEU to be discharged from the vessel at this port call.',
    `forecast_load_teu` STRING COMMENT 'Forecasted number of TEU to be loaded onto the vessel at this port call.',
    `forecast_restow_teu` STRING COMMENT 'Forecasted number of TEU requiring restow operations (containers moved to optimize stowage). Impacts operational planning and berth time.',
    `next_port_code` STRING COMMENT 'UN/LOCODE of the port immediately following this call in the rotation sequence. Used for cargo routing and stowage planning.. Valid values are `^[A-Z]{5}$`',
    `omission_reason` STRING COMMENT 'Explanation for why a scheduled port call was omitted or skipped (e.g., weather, operational delays, insufficient cargo). Populated when schedule_status is omitted.',
    `operating_shipping_line` STRING COMMENT 'Name of the primary shipping line or carrier operating this service. May include multiple lines in alliance services.',
    `planned_berth_window_hours` DECIMAL(18,2) COMMENT 'Expected duration in hours that the vessel will occupy the berth, calculated from planned ETB to planned ETD. Used for berth utilization planning.',
    `planned_eta` TIMESTAMP COMMENT 'Scheduled estimated time when the vessel is expected to arrive at the port. Forward-looking planning timestamp provided by shipping line or agent.',
    `planned_etb` TIMESTAMP COMMENT 'Scheduled estimated time when the vessel is expected to berth at the assigned terminal. Used for berth planning and resource allocation.',
    `planned_etd` TIMESTAMP COMMENT 'Scheduled estimated time when the vessel is expected to depart from the port. Used for berth window planning and next port coordination.',
    `port_of_call_code` STRING COMMENT 'Five-letter UN/LOCODE identifying the port for this scheduled call (e.g., USNYC, SGSIN, NLRTM).. Valid values are `^[A-Z]{5}$`',
    `previous_port_code` STRING COMMENT 'UN/LOCODE of the port immediately preceding this call in the rotation sequence. Used for voyage tracking and cargo routing.. Valid values are `^[A-Z]{5}$`',
    `priority_level` STRING COMMENT 'Priority classification for this scheduled call. Higher priority calls receive preferential berth allocation and resource assignment.. Valid values are `standard|priority|express|emergency`',
    `record_created_by` STRING COMMENT 'User ID or system identifier that created this schedule record. Used for audit trail and accountability.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this schedule record was first created in the port system. Used for audit trail and data lineage.',
    `record_updated_by` STRING COMMENT 'User ID or system identifier that last modified this schedule record. Used for audit trail and accountability.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this schedule record was last modified. Used for change tracking and audit trail.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special instructions, or operational comments related to this scheduled call.',
    `rotation_port_count` STRING COMMENT 'Total number of ports in the complete service rotation. Provides context for the rotation sequence number.',
    `rotation_sequence_number` STRING COMMENT 'Sequential position of this port call within the service rotation. Indicates the order of port visits in the voyage loop (e.g., 1 for first port, 2 for second).',
    `schedule_effective_from_date` DATE COMMENT 'Date from which this schedule version becomes effective. Supports schedule versioning and historical tracking.',
    `schedule_effective_to_date` DATE COMMENT 'Date until which this schedule version remains effective. Null for current active schedules. Used for schedule supersession management.',
    `schedule_published_date` DATE COMMENT 'Date when this schedule was first published or communicated to the port. Used for schedule horizon management and planning lead time analysis.',
    `schedule_received_timestamp` TIMESTAMP COMMENT 'Timestamp when this schedule record was received by the port system. Used for audit trail and schedule update tracking.',
    `schedule_source` STRING COMMENT 'Origin system or channel through which this schedule information was received (e.g., EDI from shipping line, agent portal submission, VTS pre-notification).. Valid values are `shipping_line_edi|agent_submission|vts_pre_notification|port_community_system|manual_entry`',
    `schedule_status` STRING COMMENT 'Current status of this scheduled port call. Tracks the lifecycle from initial provisional schedule through confirmation, amendments, or cancellation.. Valid values are `provisional|confirmed|amended|cancelled|omitted`',
    `schedule_version` STRING COMMENT 'Version identifier for this schedule record (e.g., 2024-01-V01). Allows tracking of schedule amendments and revisions over time.. Valid values are `^[0-9]{4}-[0-9]{2}-V[0-9]{2}$`',
    `service_code` STRING COMMENT 'Unique alphanumeric code identifying the shipping service or route (e.g., AE1, FE2, TP3). Used by shipping lines to designate specific service strings.. Valid values are `^[A-Z0-9]{2,10}$`',
    `service_frequency` STRING COMMENT 'Frequency at which this service calls at the port (e.g., weekly, bi-weekly, monthly). Indicates the regularity of scheduled calls.. Valid values are `weekly|bi-weekly|fortnightly|monthly|ad-hoc`',
    `service_name` STRING COMMENT 'Full descriptive name of the shipping service or route (e.g., Asia-Europe Express, Transpacific Loop 3).',
    `service_status` STRING COMMENT 'Current operational status of the shipping service. Indicates whether the service is actively operating or temporarily suspended.. Valid values are `active|suspended|discontinued|seasonal`',
    `service_type` STRING COMMENT 'Classification of the shipping service based on its operational scope and role in the network (mainline for long-haul trunk routes, feeder for regional distribution, shuttle for point-to-point).. Valid values are `mainline|feeder|regional|shuttle|inducement`',
    `terminal_code` STRING COMMENT 'Code identifying the specific terminal within the port where the vessel is scheduled to berth.. Valid values are `^[A-Z0-9]{2,6}$`',
    `vessel_string_size` STRING COMMENT 'Number of vessels deployed in this service rotation. Indicates the fleet size required to maintain the service frequency.',
    `voyage_number` STRING COMMENT 'Unique identifier assigned by the shipping line for this specific voyage or sailing. Used for cargo booking and documentation reference.. Valid values are `^[A-Z0-9]{3,15}$`',
    CONSTRAINT pk_call_schedule PRIMARY KEY(`call_schedule_id`)
) COMMENT 'Forward-looking schedule and service route record representing planned port calls for a vessel over a service rotation or voyage series. Service route attributes: service code, service name, operating shipping line(s), alliance designation, rotation of ports in sequence, service frequency (weekly, bi-weekly), vessel string size, average TEU capacity, service type (mainline, feeder, regional), and service status. Schedule attributes: rotation sequence number, planned ETA, planned ETD, planned berth window, cargo volume forecast (TEU), schedule version, schedule source (shipping line EDI, agent submission, VTS pre-notification), and schedule status (provisional, confirmed, amended, cancelled). Supports berth planning horizon management, resource pre-allocation, volume forecasting, and commercial service agreement management. Distinct from call which is the actual operational record of a realized port visit.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` (
    `draft_survey_id` BIGINT COMMENT 'Primary key for draft_survey',
    `wharfage_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.wharfage_schedule. Business justification: Draft surveys determine cargo weight (calculated_cargo_weight_mt) which directly drives wharfage charges under weight-based tariff schedules. Essential for wharfage billing calculation, cargo tonnage-',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Draft surveys performed by port surveyors generate costs allocated to marine services cost centres. Required for survey service cost allocation, operational expense tracking, and profitability analysi',
    `permit_to_work_id` BIGINT COMMENT 'Foreign key linking to safety.permit_to_work. Business justification: Draft surveys involve surveyors working at height on vessel decks, accessing confined spaces (tanks), and working over water. Permits to work are required for surveyor safety, fall protection, confine',
    `call_id` BIGINT COMMENT 'Reference to the port call during which this draft survey was conducted. Links the survey to the vessels visit.',
    `employee_id` BIGINT COMMENT 'Identifier of the system user who created this draft survey record. Audit trail for accountability.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel on which the draft survey was performed.',
    `aft_draft_port_meters` DECIMAL(18,2) COMMENT 'Draft reading at the aft perpendicular on the port side of the vessel, measured in meters from the waterline to the keel.',
    `aft_draft_starboard_meters` DECIMAL(18,2) COMMENT 'Draft reading at the aft perpendicular on the starboard side of the vessel, measured in meters from the waterline to the keel.',
    `ballast_water_mt` DECIMAL(18,2) COMMENT 'Weight of ballast water on board the vessel at the time of survey, measured in metric tons. Deducted from displacement to calculate cargo weight.',
    `bol_reference` STRING COMMENT 'Reference number of the Bill of Lading associated with the cargo being surveyed. Links the draft survey to the cargo documentation.',
    `bunker_fuel_mt` DECIMAL(18,2) COMMENT 'Weight of bunker fuel oil on board the vessel at the time of survey, measured in metric tons. Deducted from displacement to calculate cargo weight.',
    `calculated_cargo_weight_mt` DECIMAL(18,2) COMMENT 'Net weight of cargo loaded or discharged, calculated by subtracting lightship weight, constant, bunkers, water, ballast, and stores from the displacement. Measured in metric tons. This is the principal quantitative result of the draft survey.',
    `cargo_type` STRING COMMENT 'Type or description of cargo being surveyed (e.g., iron ore, coal, grain, steel coils). Provides context for the survey and weight verification.',
    `certificate_issue_date` DATE COMMENT 'Date on which the draft survey certificate was officially issued by the surveyor.',
    `certificate_issued_flag` BOOLEAN COMMENT 'Indicates whether a formal draft survey certificate has been issued for this survey. True if certificate issued, False otherwise.',
    `constant_mt` DECIMAL(18,2) COMMENT 'Constant correction factor representing the difference between the actual lightship weight and the documented lightship weight, measured in metric tons. Accounts for permanent additions or removals since last lightship survey.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this draft survey record was first created in the system. Audit trail for record creation.',
    `displacement_mt` DECIMAL(18,2) COMMENT 'Total weight of water displaced by the vessel at the surveyed draft, measured in metric tons. Derived from hydrostatic tables and draft readings.',
    `dwa_allowance_mm` DECIMAL(18,2) COMMENT 'Dock water allowance correction applied when the vessel is in water of intermediate density between salt and fresh water, measured in millimeters.',
    `forward_draft_port_meters` DECIMAL(18,2) COMMENT 'Draft reading at the forward perpendicular on the port side of the vessel, measured in meters from the waterline to the keel.',
    `forward_draft_starboard_meters` DECIMAL(18,2) COMMENT 'Draft reading at the forward perpendicular on the starboard side of the vessel, measured in meters from the waterline to the keel.',
    `fresh_water_mt` DECIMAL(18,2) COMMENT 'Weight of fresh water on board the vessel at the time of survey, measured in metric tons. Deducted from displacement to calculate cargo weight.',
    `fwa_allowance_mm` DECIMAL(18,2) COMMENT 'Fresh water allowance correction applied when the vessel is in fresh water or dock water, measured in millimeters. Accounts for the difference in buoyancy between salt and fresh water.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this draft survey record was last updated in the system. Audit trail for record modifications.',
    `lightship_weight_mt` DECIMAL(18,2) COMMENT 'Weight of the vessel in light condition (empty, without cargo, fuel, water, stores), measured in metric tons. Used as baseline for cargo weight calculation.',
    `list_degrees` DECIMAL(18,2) COMMENT 'Transverse inclination of the vessel measured in degrees. Positive value indicates list to starboard, negative indicates list to port.',
    `mean_aft_draft_meters` DECIMAL(18,2) COMMENT 'Average of port and starboard aft draft readings, used in displacement calculations.',
    `mean_draft_meters` DECIMAL(18,2) COMMENT 'Overall mean draft of the vessel calculated from forward, midship, and aft draft readings, used as the primary input for displacement calculation.',
    `mean_forward_draft_meters` DECIMAL(18,2) COMMENT 'Average of port and starboard forward draft readings, used in displacement calculations.',
    `mean_midship_draft_meters` DECIMAL(18,2) COMMENT 'Average of port and starboard midship draft readings, used in displacement calculations.',
    `midship_draft_port_meters` DECIMAL(18,2) COMMENT 'Draft reading at the midship section on the port side of the vessel, measured in meters from the waterline to the keel.',
    `midship_draft_starboard_meters` DECIMAL(18,2) COMMENT 'Draft reading at the midship section on the starboard side of the vessel, measured in meters from the waterline to the keel.',
    `remarks` STRING COMMENT 'Additional notes, observations, or comments recorded by the surveyor regarding the draft survey, including any anomalies, special conditions, or clarifications.',
    `sea_state_code` STRING COMMENT 'Standardized code representing sea state conditions during the survey (e.g., Douglas Sea Scale 0-9). Affects survey accuracy and reliability.',
    `stores_provisions_mt` DECIMAL(18,2) COMMENT 'Weight of stores, provisions, and consumables on board the vessel at the time of survey, measured in metric tons. Deducted from displacement to calculate cargo weight.',
    `survey_accuracy_rating` STRING COMMENT 'Surveyors assessment of the accuracy and reliability of the draft survey results based on conditions and measurement quality: excellent, good, fair, or poor.. Valid values are `excellent|good|fair|poor`',
    `survey_datetime` TIMESTAMP COMMENT 'Date and time when the draft survey was conducted. Principal business event timestamp for this transaction.',
    `survey_purpose` STRING COMMENT 'Business purpose for conducting the draft survey: cargo weight verification, load line compliance check, demurrage calculation support, charter party contractual requirement, customs declaration, or insurance claim documentation.. Valid values are `cargo_weight_verification|load_line_compliance|demurrage_calculation|charter_party_requirement|customs_declaration|insurance_claim`',
    `survey_reference_number` STRING COMMENT 'External reference number or certificate number assigned by the surveyor or survey company for this draft survey.',
    `survey_status` STRING COMMENT 'Current lifecycle status of the draft survey: draft (in progress), completed (survey finished), certified (certificate issued), disputed (under dispute), or cancelled.. Valid values are `draft|completed|certified|disputed|cancelled`',
    `survey_type` STRING COMMENT 'Type of draft survey conducted: initial (before loading), final (after loading/discharge), intermediate (during operations), pre-loading, or post-discharge.. Valid values are `initial|final|intermediate|pre-loading|post-discharge`',
    `surveyor_company_name` STRING COMMENT 'Name of the marine surveyor company or independent surveyor who conducted the draft survey.',
    `surveyor_license_number` STRING COMMENT 'Professional license or certification number of the surveyor who conducted the survey.',
    `surveyor_name` STRING COMMENT 'Full name of the individual surveyor who performed the draft survey measurements and calculations.',
    `trim_meters` DECIMAL(18,2) COMMENT 'Difference between forward and aft drafts. Positive value indicates trim by stern (aft deeper), negative indicates trim by bow (forward deeper).',
    `water_density_kg_per_m3` DECIMAL(18,2) COMMENT 'Density of the water in which the vessel is floating at the time of survey, measured in kilograms per cubic meter. Used for displacement corrections.',
    `weather_condition` STRING COMMENT 'Description of weather conditions at the time of the survey (e.g., calm, moderate wind, rough seas). Weather can affect draft reading accuracy.',
    CONSTRAINT pk_draft_survey PRIMARY KEY(`draft_survey_id`)
) COMMENT 'Transactional record of a draft survey conducted on a vessel to determine cargo weight loaded or discharged. Captures survey date and time, surveyor company, survey type (initial, final, intermediate), forward draft, aft draft, midship draft, trim, list, displacement, fresh water allowance (FWA), dock water allowance (DWA), calculated cargo weight (MT), and survey certificate reference. Supports cargo weight verification, demurrage calculations, and load line compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` (
    `service_route_id` BIGINT COMMENT 'Primary key for service_route',
    `berth_id` BIGINT COMMENT 'Identifier of the preferred or contracted berth for this service. Used in berth allocation planning and service level agreement management.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Service routes are governed by berth allocation agreements and service contracts with shipping lines/alliances. Required for commercial planning, berth allocation priority, rate schedule application, ',
    `shipping_line_id` BIGINT COMMENT 'add column shipping_line_id (BIGINT) with FK to masterdata.shipping_line.shipping_line_id - service routes are operated by shipping lines and must reference the operator',
    `alliance_name` STRING COMMENT 'Name of the shipping alliance or consortium operating the service (e.g., 2M Alliance, THE Alliance, Ocean Alliance). Null if service is operated by a single carrier outside alliance framework.',
    `alliance_service_designation` STRING COMMENT 'Alliance-level service identifier or designation code used when multiple carriers jointly operate the service under a shared service agreement.',
    `average_vessel_beam_meters` DECIMAL(18,2) COMMENT 'Average beam (width) in meters of vessels deployed on this service. Used for berth compatibility assessment and safe navigation planning.',
    `average_vessel_capacity_teu` STRING COMMENT 'Average nominal container capacity in TEU of vessels deployed on this service. Used for volume forecasting, berth capacity planning, and yard space allocation. TEU is the standard unit for measuring container vessel capacity.',
    `average_vessel_draft_meters` DECIMAL(18,2) COMMENT 'Average maximum draft in meters of vessels deployed on this service. Critical for ensuring channel depth and berth depth compatibility, and for tide-dependent berthing planning.',
    `average_vessel_loa_meters` DECIMAL(18,2) COMMENT 'Average length overall in meters of vessels deployed on this service. LOA is critical for berth allocation planning and ensuring adequate berth length availability.',
    `dangerous_cargo_percentage` DECIMAL(18,2) COMMENT 'Expected percentage of container volume classified as dangerous goods under IMDG Code. Used for safety planning, segregation requirements, and regulatory compliance.',
    `edi_service_code` STRING COMMENT 'Service code used in EDI messages (BAPLIE, COPARN, IFTMIN) for electronic data exchange with shipping lines and port community systems. Ensures consistent service identification across systems.',
    `effective_from_date` DATE COMMENT 'Date from which this service configuration becomes effective. Used for managing service changes, new service launches, and historical tracking.',
    `effective_to_date` DATE COMMENT 'Date until which this service configuration remains effective. Null for currently active services with no planned end date. Used for managing service suspensions, discontinuations, and configuration changes.',
    `expected_container_volume_teu` STRING COMMENT 'Forecasted or contracted container volume in TEU per vessel call for this service at this port. Used for yard planning, equipment allocation, and commercial performance tracking.',
    `export_volume_percentage` DECIMAL(18,2) COMMENT 'Expected percentage of total container volume that is export (loading) cargo. Used for yard planning and gate operation forecasting.',
    `import_volume_percentage` DECIMAL(18,2) COMMENT 'Expected percentage of total container volume that is import (discharge) cargo. Used for yard planning and gate operation forecasting. Complement is export and transshipment volume.',
    `last_call_date` DATE COMMENT 'Date of the most recent vessel call for this service at this port. Used for service activity monitoring and performance tracking.',
    `next_scheduled_call_date` DATE COMMENT 'Date of the next scheduled vessel call for this service at this port. Used for near-term berth planning and operational readiness.',
    `operating_shipping_line` STRING COMMENT 'Primary shipping line or carrier operating the service. May be a single carrier or lead carrier in a vessel sharing agreement. Used for commercial relationship management and billing.',
    `port_call_sequence_number` STRING COMMENT 'Sequential position of this port within the service rotation (e.g., 1 for first port, 2 for second port). Used for berth window planning and voyage sequencing.',
    `port_rotation_sequence` STRING COMMENT 'Ordered list of ports in the service rotation, typically represented as comma-separated port codes or names (e.g., Singapore-Hong Kong-Shanghai-Busan-Los Angeles-Oakland). Defines the complete loop or string that vessels follow on this service.',
    `port_stay_duration_hours` DECIMAL(18,2) COMMENT 'Average or planned duration in hours that vessels on this service spend at this port, from berthing to departure. Used for berth window planning and terminal resource allocation.',
    `record_created_by` STRING COMMENT 'User identifier or system account that created this service route record. Used for audit trail and accountability.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this service route record was first created in the system. Used for audit trail and data lineage tracking.',
    `record_updated_by` STRING COMMENT 'User identifier or system account that last modified this service route record. Used for audit trail and accountability.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this service route record was last modified. Used for audit trail, change tracking, and data synchronization.',
    `reefer_percentage` DECIMAL(18,2) COMMENT 'Expected percentage of container volume that requires refrigeration (reefer containers). Used for reefer plug allocation planning and power supply capacity management.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special handling requirements, operational constraints, or other relevant information about the service that does not fit structured fields.',
    `rotation_duration_days` STRING COMMENT 'Total number of days required to complete one full service rotation from first port back to first port. Used to calculate vessel string requirements and service frequency.',
    `service_code` STRING COMMENT 'Unique alphanumeric code assigned by the shipping line to identify the liner service (e.g., AE1, FE2, TP3). Industry-standard identifier used in vessel schedules, berth planning, and commercial agreements.',
    `service_commencement_date` DATE COMMENT 'Date when the service first commenced operations at this port. Used for historical analysis and service tenure tracking.',
    `service_frequency` STRING COMMENT 'Scheduled frequency of vessel calls at this port for the service. Weekly services provide one call per week; bi-weekly provides two calls per week; fortnightly provides one call every two weeks. Critical for berth planning and volume forecasting.. Valid values are `weekly|bi-weekly|tri-weekly|fortnightly|monthly`',
    `service_name` STRING COMMENT 'Full commercial name of the liner service as marketed by the shipping line (e.g., Asia-Europe Express, Transpacific Loop 3). Used in customer-facing documentation and service agreements.',
    `service_reliability_percentage` DECIMAL(18,2) COMMENT 'Percentage of vessel calls that arrived within the scheduled time window over a measurement period. Key performance indicator for service quality and customer satisfaction.',
    `service_status` STRING COMMENT 'Current operational status of the liner service. Active services are currently calling at the port; suspended services are temporarily halted; discontinued services have been permanently terminated; planned services are scheduled to commence in the future.. Valid values are `active|suspended|discontinued|planned`',
    `service_type` STRING COMMENT 'Classification of the liner service based on operational scope and connectivity. Mainline services connect major hub ports across continents; feeder services connect regional ports to mainline hubs; regional services operate within a geographic region; shuttle services provide point-to-point connectivity; express services offer premium transit times.. Valid values are `mainline|feeder|regional|shuttle|express`',
    `terminal_operator` STRING COMMENT 'Name of the terminal operating company handling this service. Used for operational coordination and commercial agreement management.',
    `transshipment_volume_percentage` DECIMAL(18,2) COMMENT 'Expected percentage of total container volume that is transshipment cargo (discharged from one vessel and loaded onto another). Critical for hub port operations and inter-terminal transfer planning.',
    `vessel_string_size` STRING COMMENT 'Number of vessels deployed on this service rotation. Determines service frequency and capacity. For example, a 7-vessel string on a 49-day rotation provides weekly frequency.',
    CONSTRAINT pk_service_route PRIMARY KEY(`service_route_id`)
) COMMENT 'Master record of a shipping lines scheduled service route (liner service) calling at the port. Captures service code, service name, operating shipping line(s), alliance service designation, rotation of ports in sequence, service frequency (weekly, bi-weekly), vessel string size (number of vessels deployed), average vessel TEU capacity, service type (mainline, feeder, regional), and service status (active, suspended, discontinued). Supports berth window planning, volume forecasting, and commercial service agreement management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` (
    `crew_list_id` BIGINT COMMENT 'Primary key for crew_list',
    `access_credential_id` BIGINT COMMENT 'Foreign key linking to security.access_credential. Business justification: Crew members granted shore leave require temporary access credentials for port facility entry. Immigration and port security issue credentials after ISPS screening, passport verification, and shore le',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Crew nationality determines visa requirements, shore leave authorization, immigration clearance procedures, and MLC compliance verification. Required for port health clearance, immigration processing,',
    `ohs_incident_id` BIGINT COMMENT 'Foreign key linking to safety.ohs_incident. Business justification: Crew members are frequently injured parties in port-side incidents during cargo operations, gangway accidents, or vessel maintenance. Incident reports must identify the specific crew member involved, ',
    `call_id` BIGINT COMMENT 'Reference to the specific port call during which this crew member is aboard the vessel. Links crew list to vessel visit.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel on which this crew member is serving. Links crew member to vessel master record.',
    `visitor_log_id` BIGINT COMMENT 'Foreign key linking to security.visitor_log. Business justification: Crew shore leave is logged as visitor access when entering restricted port areas beyond the vessel berth. Security posts record crew entry/exit timestamps, zones accessed, and escort requirements. Vis',
    `contact_address` STRING COMMENT 'Shore-based contact address for the crew member. Used for emergency contact and repatriation purposes.',
    `contact_phone_number` STRING COMMENT 'Shore-based contact phone number for the crew member or their next of kin. Used for emergency notifications.',
    `crew_change_type` STRING COMMENT 'Indicates whether the crew member is joining the vessel, departing (signing off), remaining aboard, or in transit through the port. Critical for immigration and crew change coordination.. Valid values are `joining|departing|remaining|transit`',
    `crew_list_status` STRING COMMENT 'Current status of the crew member on this vessel port call. Tracks lifecycle from active service through sign-off or other separation events.. Valid values are `active|signed_off|deceased|deserted|hospitalized|repatriated`',
    `crew_member_family_name` STRING COMMENT 'Family name (surname) of the crew member as it appears on their passport or seafarer identity document. Required for immigration and security screening.',
    `crew_member_given_name` STRING COMMENT 'Given name (first name) of the crew member as it appears on their passport or seafarer identity document. Required for immigration and security screening.',
    `crew_member_middle_name` STRING COMMENT 'Middle name or patronymic of the crew member if applicable. Optional field for complete name identification.',
    `date_of_birth` DATE COMMENT 'Crew members date of birth as recorded on their passport or seafarer identity document. Used for identity verification and age-related compliance.',
    `date_of_joining_vessel` DATE COMMENT 'Date on which the crew member joined the vessel. Marks the start of their current tour of duty and is used to calculate sea service time.',
    `expected_date_of_signing_off` DATE COMMENT 'Anticipated date on which the crew member will sign off the vessel and complete their tour of duty. Used for crew change planning and relief scheduling.',
    `expected_port_of_signing_off` STRING COMMENT 'Name of the port where the crew member is expected to sign off the vessel. Used for crew change coordination and travel arrangements.',
    `isps_screening_timestamp` TIMESTAMP COMMENT 'Date and time when ISPS security screening was completed for the crew member. Used for audit trail and compliance verification.',
    `isps_security_screening_status` STRING COMMENT 'Result of ISPS security screening for the crew member. Cleared status is required for vessel operations in ISPS-compliant ports.. Valid values are `cleared|pending|flagged|denied`',
    `medical_certificate_expiry_date` DATE COMMENT 'Date on which the crew members medical fitness certificate expires. Must be valid for the crew member to serve aboard the vessel.',
    `medical_certificate_number` STRING COMMENT 'Medical certificate number confirming the crew member is medically fit for sea service. Required under ILO Maritime Labour Convention.',
    `next_of_kin_name` STRING COMMENT 'Full name of the crew members next of kin or emergency contact person. Critical for emergency notifications and repatriation.',
    `next_of_kin_phone_number` STRING COMMENT 'Contact phone number for the crew members next of kin. Primary channel for emergency notifications.',
    `next_of_kin_relationship` STRING COMMENT 'Relationship of the next of kin to the crew member (e.g., spouse, parent, sibling). Used for emergency contact prioritization.',
    `passport_expiry_date` DATE COMMENT 'Date on which the crew members passport expires. Must be valid for the duration of the port call and voyage to meet immigration requirements.',
    `passport_issue_date` DATE COMMENT 'Date on which the crew members passport was issued. Used to verify document validity and authenticity.',
    `passport_issuing_country_code` STRING COMMENT 'Three-letter ISO country code of the country that issued the crew members passport. May differ from nationality in some cases.. Valid values are `^[A-Z]{3}$`',
    `passport_number` STRING COMMENT 'Passport number of the crew member. Primary travel document identifier for immigration clearance and port state control inspections.',
    `place_of_birth` STRING COMMENT 'City and country where the crew member was born. May be required by certain port state authorities for immigration processing.',
    `port_health_clearance_status` STRING COMMENT 'Health clearance status assigned by port health authority. Cleared status is required before crew can disembark or vessel can commence cargo operations.. Valid values are `cleared|pending|quarantine_required|medical_hold`',
    `port_of_joining` STRING COMMENT 'Name of the port where the crew member joined the vessel. Used for crew change tracking and repatriation planning.',
    `rank_position` STRING COMMENT 'The crew members rank or position aboard the vessel as per the ships crew list. Determines responsibilities and STCW certification requirements. [ENUM-REF-CANDIDATE: master|chief_officer|second_officer|third_officer|chief_engineer|second_engineer|third_engineer|bosun|able_seaman|ordinary_seaman|deck_cadet|engine_cadet|radio_officer|electrician|fitter|oiler|wiper|cook|steward|messman|pumpman|other — 22 candidates stripped; promote to reference product]',
    `record_created_by` STRING COMMENT 'User ID or system identifier of the person or process that created this crew list record. Used for audit trail and accountability.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Date and time when this crew list record was first created in the system. Used for audit trail and data lineage.',
    `record_updated_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified this crew list record. Used for audit trail and accountability.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this crew list record was last modified. Used for audit trail and change tracking.',
    `remarks` STRING COMMENT 'Free-text field for additional notes or special circumstances related to the crew members status, documentation, or port call requirements.',
    `seafarers_book_expiry_date` DATE COMMENT 'Date on which the seafarers book expires. Must be valid for the crew member to serve aboard the vessel.',
    `seafarers_book_issue_date` DATE COMMENT 'Date on which the seafarers book was issued. Used to verify document validity and seafaring experience.',
    `seafarers_book_number` STRING COMMENT 'Seafarers discharge book or continuous discharge certificate number. Official record of sea service and qualifications issued by flag state.',
    `shore_leave_authorized_flag` BOOLEAN COMMENT 'Indicates whether the crew member has been authorized for shore leave by port immigration authorities. True if authorized, false if restricted to vessel.',
    `stcw_certificate_expiry_date` DATE COMMENT 'Date on which the STCW certificate expires. Crew member must hold valid certification to serve in their assigned rank.',
    `stcw_certificate_grade` STRING COMMENT 'Grade or level of the STCW certificate held by the crew member (e.g., Master Unlimited, Chief Engineer, Officer of the Watch). Determines authorized duties.',
    `stcw_certificate_issue_date` DATE COMMENT 'Date on which the STCW certificate was issued. Used to verify currency of qualifications.',
    `stcw_certificate_number` STRING COMMENT 'Certificate of competency number issued under the STCW Convention. Validates that the crew member holds the required qualifications for their rank.',
    `vaccination_certificate_number` STRING COMMENT 'International certificate of vaccination number (yellow card). May be required by port health authorities for entry into certain jurisdictions.',
    `visa_expiry_date` DATE COMMENT 'Date on which the crew members visa expires. Must be valid for the duration of the port call if shore leave is requested.',
    `visa_number` STRING COMMENT 'Visa number if the crew member holds a visa for the port state. Required for shore leave authorization and immigration compliance.',
    CONSTRAINT pk_crew_list PRIMARY KEY(`crew_list_id`)
) COMMENT 'Master record of crew members aboard a vessel during a port call, as declared in the crew list submitted under IMO FAL Form 5. Captures crew member name, nationality, rank/position, passport number, seafarers book number, STCW certificate reference, date of joining, date of signing off, and crew change type (joining, departing, remaining). Supports ISPS security screening, immigration compliance, crew change coordination, and port health authority notifications. Distinct from the workforce domain which manages port employees.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` (
    `waste_declaration_id` BIGINT COMMENT 'Primary key for waste_declaration',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: MARPOL waste types require commodity code classification for disposal tracking, environmental compliance reporting, and waste reception facility invoicing. Links waste_type_code to HS code framework f',
    `marpol_record_id` BIGINT COMMENT 'Foreign key linking to compliance.marpol_record. Business justification: Waste declarations submitted under MARPOL Annexes I/IV/V/VI generate formal MARPOL compliance records for port state enforcement, garbage record book verification, and IMO reporting. Port authorities ',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Waste reception oversight, environmental compliance monitoring, and MARPOL enforcement generate costs allocated to environmental services cost centres. Required for environmental compliance cost track',
    `employee_id` BIGINT COMMENT 'Reference to the port state control inspector who verified the waste declaration and discharge operations.',
    `port_asset_id` BIGINT COMMENT 'Reference to the port reception facility used for waste discharge.',
    `call_id` BIGINT COMMENT 'Reference to the port call during which this waste declaration was submitted or fulfilled.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: MARPOL Annex V compliance requires tracking which licensed waste reception facility (a port community participant) received ship-generated waste. Port state control inspections verify waste delivery t',
    `screening_record_id` BIGINT COMMENT 'Foreign key linking to security.screening_record. Business justification: Hazardous waste deliveries (IMDG class, radioactive materials) undergo security screening at port reception facilities. Screening records document radiation readings, prohibited item checks, and MARSE',
    `vendor_id` BIGINT COMMENT 'Reference to the licensed waste management contractor responsible for waste collection and disposal.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel submitting the waste declaration.',
    `actual_delivery_timestamp` TIMESTAMP COMMENT 'Actual date and time when waste was delivered to the port reception facility and discharge operations commenced.',
    `actual_volume_delivered_m3` DECIMAL(18,2) COMMENT 'Actual volume of waste delivered to the port reception facility, measured in cubic meters (m³) upon discharge completion.',
    `charge_amount` DECIMAL(18,2) COMMENT 'Total charge levied for waste reception and disposal services, calculated based on waste volume, type, and applicable tariffs.',
    `charge_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the waste discharge charge (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `compliance_verification_status` STRING COMMENT 'Status of regulatory compliance verification by port state control or environmental officers: pending review, verified compliant, non-compliant (violation detected), or under investigation.. Valid values are `pending|verified|non_compliant|under_investigation`',
    `declaration_number` STRING COMMENT 'Unique business identifier for the waste declaration, used for tracking and regulatory reporting.. Valid values are `^WD-[0-9]{8}-[A-Z0-9]{6}$`',
    `declaration_status` STRING COMMENT 'Current lifecycle status of the waste declaration in the port authority workflow. [ENUM-REF-CANDIDATE: draft|submitted|under_review|approved|delivery_confirmed|waiver_granted|rejected|cancelled — 8 candidates stripped; promote to reference product]',
    `declaration_submission_timestamp` TIMESTAMP COMMENT 'Date and time when the waste declaration was officially submitted to the port authority, typically required at least 24 hours before arrival per MARPOL.',
    `declaration_type` STRING COMMENT 'Type of waste declaration: pre-arrival notification (advance notice), delivery confirmation (actual discharge), waiver request (exemption application), or amendment (correction to prior declaration).. Valid values are `pre_arrival_notification|delivery_confirmation|waiver_request|amendment`',
    `delivery_completion_timestamp` TIMESTAMP COMMENT 'Date and time when waste discharge operations were completed and the vessel was cleared.',
    `disposal_facility_license_number` STRING COMMENT 'Environmental license or permit number of the disposal facility, verifying its authorization to handle the declared waste type.',
    `disposal_facility_name` STRING COMMENT 'Name of the licensed waste disposal or treatment facility where the waste will be ultimately processed.',
    `disposal_method` STRING COMMENT 'Method by which the waste will be disposed of or processed: incineration, landfill, recycling, treatment, reuse, or export to another facility.. Valid values are `incineration|landfill|recycling|treatment|reuse|export`',
    `ems_integration_status` STRING COMMENT 'Status of data transmission to the Environmental Monitoring System for emissions tracking and environmental compliance reporting.. Valid values are `not_sent|sent|acknowledged|failed`',
    `ems_transmission_timestamp` TIMESTAMP COMMENT 'Date and time when waste declaration data was transmitted to the Environmental Monitoring System.',
    `estimated_volume_m3` DECIMAL(18,2) COMMENT 'Estimated volume of waste to be discharged, declared in cubic meters (m³) in the pre-arrival notification.',
    `hazardous_waste_flag` BOOLEAN COMMENT 'Indicates whether the waste is classified as hazardous under IMDG or local environmental regulations, requiring specialized disposal procedures.',
    `imdg_class` STRING COMMENT 'IMDG classification code if the waste contains hazardous or dangerous materials requiring special handling (e.g., Class 3 for flammable liquids, Class 9 for miscellaneous dangerous substances).',
    `inspection_timestamp` TIMESTAMP COMMENT 'Date and time when the PSC inspection of waste discharge operations was conducted.',
    `invoice_reference` STRING COMMENT 'Reference to the billing invoice generated for waste discharge services, linking to the port billing system.',
    `marpol_annex` STRING COMMENT 'MARPOL annex category under which the waste is classified: Annex I (oily waste), Annex II (noxious liquid substances), Annex IV (sewage), Annex V (garbage), Annex VI (air pollution residues).. Valid values are `annex_I|annex_II|annex_IV|annex_V|annex_VI`',
    `next_port_of_call` STRING COMMENT 'UN/LOCODE of the next port where the vessel intends to discharge waste, used to support waiver applications.. Valid values are `^[A-Z]{5}$`',
    `penalty_amount` DECIMAL(18,2) COMMENT 'Monetary penalty imposed for non-compliance with waste discharge regulations, if applicable.',
    `penalty_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the penalty amount.. Valid values are `^[A-Z]{3}$`',
    `psc_inspection_flag` BOOLEAN COMMENT 'Indicates whether this waste declaration was subject to a Port State Control inspection for MARPOL compliance verification.',
    `record_created_by` STRING COMMENT 'User ID or system identifier of the person or process that created this waste declaration record.',
    `record_created_timestamp` TIMESTAMP COMMENT 'System timestamp when this waste declaration record was first created in the database.',
    `record_updated_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified this waste declaration record.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this waste declaration record was last modified.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special instructions, or observations related to the waste declaration and discharge operations.',
    `scheduled_delivery_timestamp` TIMESTAMP COMMENT 'Planned date and time for waste delivery to the port reception facility, coordinated with berth operations.',
    `un_number` STRING COMMENT 'Four-digit UN identification number for hazardous waste substances as per the UN Recommendations on the Transport of Dangerous Goods.. Valid values are `^UN[0-9]{4}$`',
    `unit_of_measure` STRING COMMENT 'Unit of measure used for waste volume or weight reporting (cubic meters, liters, kilograms, tonnes).. Valid values are `cubic_meters|liters|kilograms|tonnes`',
    `violation_description` STRING COMMENT 'Detailed description of any detected violation, including the nature of non-compliance and evidence collected.',
    `violation_detected_flag` BOOLEAN COMMENT 'Indicates whether a MARPOL or environmental regulation violation was detected during inspection or verification (e.g., undeclared waste, illegal discharge).',
    `waiver_expiry_date` DATE COMMENT 'Date until which the granted waiver remains valid, after which the vessel must discharge waste at a port reception facility.',
    `waiver_granted_flag` BOOLEAN COMMENT 'Indicates whether the vessel was granted a waiver exempting it from mandatory waste discharge requirements (e.g., due to sufficient onboard storage or next port arrangements).',
    `waiver_reason` STRING COMMENT 'Justification for granting a waste discharge waiver, including evidence of sufficient onboard capacity or confirmed arrangements at the next port of call.',
    `waste_contractor_reference` STRING COMMENT 'External reference number or job ticket issued by the waste contractor for this waste collection service.',
    `waste_description` STRING COMMENT 'Detailed textual description of the waste material, including composition, source, and any hazardous characteristics.',
    `waste_receipt_number` STRING COMMENT 'Official receipt number issued by the port reception facility confirming waste delivery, required under MARPOL for vessel records.. Valid values are `^WR-[0-9]{8}-[A-Z0-9]{4}$`',
    `waste_type_code` STRING COMMENT 'Standardized code identifying the specific waste category (e.g., OW01 for bilge water, GC03 for plastic waste) per MARPOL classification.. Valid values are `^[A-Z]{2}[0-9]{2}$`',
    CONSTRAINT pk_waste_declaration PRIMARY KEY(`waste_declaration_id`)
) COMMENT 'Transactional record of waste notification and delivery declarations submitted by vessels in compliance with MARPOL and EU Port Reception Facilities Directive. Captures waste type (Annex I oily waste, Annex II noxious liquids, Annex IV sewage, Annex V garbage, Annex VI air emissions), estimated waste volume, actual waste delivered volume, reception facility used, delivery timestamp, waste contractor reference, and declaration status (pre-arrival notification, delivery confirmed, waiver granted). Supports environmental compliance reporting and EMS integration.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` (
    `isps_record_id` BIGINT COMMENT 'Primary key for isps_record',
    `facility_security_plan_id` BIGINT COMMENT 'Foreign key linking to security.facility_security_plan. Business justification: Vessel ISPS records must reference the facility security plan governing the port call. Security level coordination, DoS requirements, and security measures are determined by the facility plan under wh',
    `inspection_id` BIGINT COMMENT 'Foreign key linking to safety.safety_inspection. Business justification: ISPS security records are verified during port facility and PSC safety inspections. Inspectors check ISSC certificates, security levels, last ten ports, and Declaration of Security compliance. This li',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Ship ISPS records must reference port facility ISPS records when Declaration of Security (DoS) is signed per ISPS Code Part A/16.1. This link enables ship-to-shore security interface documentation, Do',
    `call_id` BIGINT COMMENT 'Reference to the port call for which this ISPS record is created. Links this security compliance record to the specific vessel visit.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Port Facility Security Officers (PFSO) manage ISPS compliance, sign Declarations of Security, and coordinate security measures. Mandatory under ISPS Code for security incident reporting, DoS managemen',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel subject to ISPS compliance verification. Links to the vessel master data.',
    `additional_security_measures_applied` STRING COMMENT 'Description of any additional or special security measures applied beyond standard procedures, such as enhanced screening, armed guards, restricted access zones, or increased surveillance.',
    `compliance_verification_officer_name` STRING COMMENT 'Name of the port security officer or authority representative who conducted the ISPS compliance verification for this port call.',
    `compliance_verification_status` STRING COMMENT 'Status of the ISPS compliance verification for this port call. Compliant = all requirements met, Non-compliant = deficiencies identified, Pending Verification = under review, Conditional Approval = approved with conditions, Rejected = entry denied.. Valid values are `compliant|non_compliant|pending_verification|conditional_approval|rejected`',
    `compliance_verification_timestamp` TIMESTAMP COMMENT 'Date and time when the ISPS compliance verification was completed by the Port Facility Security Officer or designated authority.',
    `control_measures_imposed` STRING COMMENT 'Description of any control measures imposed by the port state control authority in response to identified deficiencies, such as detention, expulsion, restrictions on operations, or requirement for rectification before departure.',
    `declaration_of_security_reference_number` STRING COMMENT 'Unique reference number assigned to the Declaration of Security document agreed between the ship and the port facility. Null if DoS is not required.',
    `declaration_of_security_required_flag` BOOLEAN COMMENT 'Indicates whether a Declaration of Security is required for this port call. True if security level is 2 or 3, or if ship-to-ship activity is planned, or if requested by either party.',
    `declaration_of_security_signed_timestamp` TIMESTAMP COMMENT 'Date and time when the Declaration of Security was signed by both the Ship Security Officer and the Port Facility Security Officer. Null if DoS is not required.',
    `deficiency_description` STRING COMMENT 'Detailed description of any ISPS compliance deficiencies identified, including the nature of the deficiency, affected security measures, and required corrective actions. Null if no deficiencies were found.',
    `deficiency_identified_flag` BOOLEAN COMMENT 'Indicates whether any ISPS compliance deficiencies were identified during the verification process. True if deficiencies were found.',
    `issc_certificate_number` STRING COMMENT 'The unique certificate number of the vessels valid ISSC issued by the flag state or recognized security organization. Mandatory for vessels engaged in international voyages.',
    `issc_expiry_date` DATE COMMENT 'Date when the ISSC certificate expires. Vessels must renew before this date to maintain compliance.',
    `issc_issue_date` DATE COMMENT 'Date when the ISSC certificate was issued to the vessel.',
    `issc_issuing_authority` STRING COMMENT 'Name of the flag state administration or recognized security organization that issued the ISSC certificate.',
    `last_ten_ports_of_call` STRING COMMENT 'Comma-separated list of the last ten ports where the vessel called, including port name and country code. Required for security risk assessment and ISPS compliance verification.',
    `last_ten_ports_security_levels` STRING COMMENT 'Comma-separated list of security levels (1, 2, or 3) at which the vessel operated at each of the last ten ports of call. Corresponds to the ports listed in last_ten_ports_of_call.',
    `port_facility_security_level` STRING COMMENT 'Security level set by the port facility at the time of the vessels arrival. Level 1 = normal, Level 2 = heightened, Level 3 = exceptional.',
    `port_facility_security_officer_contact` STRING COMMENT 'Contact phone number or communication channel for the Port Facility Security Officer during the vessels port call.',
    `port_facility_security_officer_name` STRING COMMENT 'Full name of the Port Facility Security Officer responsible for the development, implementation, and maintenance of the port facility security plan.',
    `pre_arrival_security_information_submitted_flag` BOOLEAN COMMENT 'Indicates whether the vessel submitted the required pre-arrival security information to the port facility within the mandated timeframe (typically 24-96 hours before arrival).',
    `pre_arrival_security_information_submitted_timestamp` TIMESTAMP COMMENT 'Date and time when the vessel submitted the pre-arrival security information to the port facility.',
    `record_created_by` STRING COMMENT 'User ID or system identifier of the person or process that created this ISPS compliance record. Part of audit trail for regulatory compliance.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Date and time when this ISPS compliance record was first created in the system. Part of audit trail for regulatory compliance and data lineage.',
    `record_updated_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified this ISPS compliance record. Part of audit trail for regulatory compliance.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this ISPS compliance record was last modified in the system. Part of audit trail for regulatory compliance and data lineage.',
    `remarks` STRING COMMENT 'Additional notes, observations, or comments related to the ISPS compliance record for this port call. May include special circumstances, coordination notes, or follow-up actions.',
    `security_incident_description` STRING COMMENT 'Detailed description of any security incident, breach, or threat that occurred during the port call. Null if no incident occurred. Confidential information for security management.',
    `security_incident_flag` BOOLEAN COMMENT 'Indicates whether any security incident, breach, or threat was reported during this port call. True if an incident occurred.',
    `security_incident_reported_timestamp` TIMESTAMP COMMENT 'Date and time when the security incident was first reported to the port facility or relevant authorities. Null if no incident occurred.',
    `security_measures_in_place` STRING COMMENT 'Description of specific security measures implemented for this port call, including access control, surveillance, cargo screening, and perimeter security. May reference the Ship Security Plan and Port Facility Security Plan.',
    `ship_security_level` STRING COMMENT 'Current security level at which the ship is operating at the time of port call. Level 1 = normal, Level 2 = heightened, Level 3 = exceptional. Must align with port facility security level or higher.',
    `ship_security_officer_contact` STRING COMMENT 'Contact phone number or radio call sign for the Ship Security Officer during the port call.',
    `ship_security_officer_name` STRING COMMENT 'Full name of the designated Ship Security Officer responsible for implementing and maintaining the ship security plan on board the vessel.',
    `ship_to_ship_activity_description` STRING COMMENT 'Description of ship-to-ship activities conducted, including the name and IMO number of the other vessel, type of activity (cargo transfer, bunkering, etc.), and location. Null if no ship-to-ship activity occurred.',
    `ship_to_ship_activity_flag` BOOLEAN COMMENT 'Indicates whether the vessel engaged in ship-to-ship activities during this port call. Ship-to-ship activities require additional security coordination and may mandate a Declaration of Security.',
    CONSTRAINT pk_isps_record PRIMARY KEY(`isps_record_id`)
) COMMENT 'Transactional record capturing ISPS (International Ship and Port Facility Security) compliance data for each vessel port call. Captures vessel ISSC (International Ship Security Certificate) number, current ship security level (1, 2, or 3), last 10 ports of call with security levels, ship security officer name, declaration of security (DoS) requirement flag, DoS reference number, DoS signing timestamp, port facility security officer, and any security incidents or special measures applied. Mandatory for ISPS Code compliance and port facility security management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` (
    `bunker_operation_id` BIGINT COMMENT 'Unique identifier for the bunkering operation record. Primary key.',
    `amended_bunker_operation_id` BIGINT COMMENT 'Self-referencing FK on bunker_operation (amended_bunker_operation_id)',
    `anchorage_id` BIGINT COMMENT 'Reference to the anchorage area where bunkering occurred, if conducted at anchorage. Null if conducted at berth.',
    `bunker_adjustment_id` BIGINT COMMENT 'Foreign key linking to tariff.bunker_adjustment. Business justification: Bunker operations may be subject to bunker adjustment factors (BAF) that affect port service pricing when fuel price volatility impacts operational costs. Required for calculating fuel-indexed surchar',
    `berth_id` BIGINT COMMENT 'Reference to the berth where bunkering occurred, if conducted at berth. Null if conducted at anchorage or offshore.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Bunker operations execute under fuel supply agreements defining pricing, quality specifications, delivery terms, and payment conditions. Required for rate verification, invoice reconciliation, and dis',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Bunker operations require port oversight, safety coordination, and VTS monitoring, generating costs allocated to marine operations cost centres. Required for operational cost tracking of fuel transfer',
    `ohs_incident_id` BIGINT COMMENT 'Foreign key linking to safety.ohs_incident. Business justification: Bunkering operations have high incident risk including fuel spills, fires, hose failures, and personnel injuries. Incident investigations must reference the specific bunker operation for root cause an',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Port operations supervisors authorize bunkering operations, verify safety checklists, and monitor MARPOL compliance. Critical for environmental protection, safety incident accountability, and VTS coor',
    `permit_to_work_id` BIGINT COMMENT 'Foreign key linking to safety.permit_to_work. Business justification: Bunkering is a high-risk hot work operation requiring permits for fire safety, spill prevention, gas testing, ISPS security clearance, and emergency response readiness. Permits authorize bunkering ope',
    `port_asset_id` BIGINT COMMENT 'Identification number or name of the bunker barge used for fuel delivery, if delivery method was barge.',
    `call_id` BIGINT COMMENT 'Reference to the port call during which this bunkering operation occurred. Links the bunker operation to the vessels visit.',
    `vendor_id` BIGINT COMMENT 'Reference to the company providing the bunker fuel supply services.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel receiving bunker fuel during this operation.',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when bunker fuel delivery was completed. Recorded when hose is disconnected and operation is finalized.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when bunker fuel delivery commenced. Recorded when hose connection is established and pumping begins.',
    `bdn_reference_number` STRING COMMENT 'Unique reference number from the Bunker Delivery Note issued by the supplier. Required for MARPOL Annex VI compliance and serves as the official receipt for fuel delivery.. Valid values are `^[A-Z0-9-]{6,30}$`',
    `bunker_barge_imo_number` STRING COMMENT 'Seven-digit IMO number of the bunker barge, if applicable. Used for vessel tracking and security screening.. Valid values are `^[0-9]{7}$`',
    `bunker_supplier_name` STRING COMMENT 'Name of the bunker fuel supplier company conducting the operation.',
    `chief_engineer_name` STRING COMMENT 'Name of the vessels Chief Engineer who supervised and signed off on the bunkering operation.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the bunker fuel transaction (e.g., USD, EUR, SGD).. Valid values are `^[A-Z]{3}$`',
    `delivery_location_type` STRING COMMENT 'Type of location where the bunkering operation is conducted. Impacts safety protocols and operational procedures.. Valid values are `berth|anchorage|offshore|terminal`',
    `delivery_method` STRING COMMENT 'Method used to deliver bunker fuel to the vessel. Barge is most common in ports, pipeline for fixed berths, truck for smaller quantities, ship-to-ship for offshore operations.. Valid values are `barge|pipeline|truck|ship_to_ship`',
    `density_at_15c_kg_per_m3` DECIMAL(18,2) COMMENT 'Density of the bunker fuel at 15 degrees Celsius in kilograms per cubic meter. Standard measurement for fuel quality verification per ISO 8217.',
    `flash_point_celsius` DECIMAL(18,2) COMMENT 'Flash point temperature of the fuel in degrees Celsius. Safety parameter indicating the lowest temperature at which fuel vapors can ignite. Minimum 60°C per SOLAS.',
    `fuel_grade` STRING COMMENT 'Specific grade or quality designation of the bunker fuel as per ISO 8217 standards (e.g., RMG380, DMA, DMB).',
    `fuel_sample_seal_number` STRING COMMENT 'Seal number of the fuel sample container. Ensures sample integrity for potential dispute resolution or PSC inspection.',
    `fuel_sample_taken_flag` BOOLEAN COMMENT 'Indicates whether a representative fuel sample was taken during delivery for quality verification and MARPOL compliance.',
    `fuel_type` STRING COMMENT 'Type of bunker fuel being delivered. VLSFO (Very Low Sulphur Fuel Oil), LSMGO (Low Sulphur Marine Gas Oil), HFO (Heavy Fuel Oil), MGO (Marine Gas Oil), LNG (Liquefied Natural Gas), and alternative fuels. [ENUM-REF-CANDIDATE: VLSFO|LSMGO|HFO|MGO|LNG|METHANOL|AMMONIA — 7 candidates stripped; promote to reference product]',
    `isps_security_level` STRING COMMENT 'International Ship and Port Facility Security (ISPS) Code security level in effect during the bunkering operation. Determines security protocols and access controls.. Valid values are `level_1|level_2|level_3`',
    `operation_duration_minutes` STRING COMMENT 'Total duration of the bunkering operation in minutes, from start to end. Used for billing berth time and operational efficiency analysis.',
    `operation_status` STRING COMMENT 'Current lifecycle status of the bunkering operation. Tracks progression from scheduling through completion or termination.. Valid values are `scheduled|in_progress|completed|suspended|cancelled|aborted`',
    `port_service_charge` DECIMAL(18,2) COMMENT 'Port authority charges for facilitating the bunkering operation, including berth time during fueling and safety oversight.',
    `quality_certificate_number` STRING COMMENT 'Certificate number from the fuel quality analysis report provided by the supplier or independent laboratory.',
    `quantity_delivered_mt` DECIMAL(18,2) COMMENT 'Actual quantity of bunker fuel delivered to the vessel in metric tonnes (MT). Recorded on the BDN and used for billing.',
    `quantity_ordered_mt` DECIMAL(18,2) COMMENT 'Quantity of bunker fuel ordered by the vessel in metric tonnes (MT). Represents the planned delivery volume.',
    `receiving_tank_name` STRING COMMENT 'Name or designation of the vessels fuel tank receiving the bunker delivery (e.g., Port Bunker Tank No. 1, Starboard Service Tank).',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this bunker operation record was first created in the system.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this bunker operation record was last modified in the system.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, observations, or issues encountered during the bunkering operation.',
    `safety_checklist_completed_flag` BOOLEAN COMMENT 'Indicates whether the ship-shore safety checklist was completed before bunkering commenced. Required by ISGOTT (International Safety Guide for Oil Tankers and Terminals).',
    `safety_checklist_reference` STRING COMMENT 'Reference number or document identifier for the completed ship-shore safety checklist.',
    `scheduled_start_timestamp` TIMESTAMP COMMENT 'Planned date and time for the bunkering operation to commence. Used for berth planning and VTS coordination.',
    `sea_state_code` STRING COMMENT 'Douglas Sea State code (0-9) representing wave conditions during bunkering. Critical for offshore and anchorage operations.. Valid values are `^[0-9]$`',
    `sulphur_content_percent` DECIMAL(18,2) COMMENT 'Sulphur content of the delivered fuel expressed as a percentage by mass. Critical for MARPOL Annex VI compliance (0.50% global limit, 0.10% in ECAs).',
    `supplier_representative_name` STRING COMMENT 'Name of the bunker suppliers representative who conducted the delivery and signed the BDN.',
    `tank_after_sounding_meters` DECIMAL(18,2) COMMENT 'Tank gauging reading in meters after bunkering completed. Used to verify delivered quantity against BDN.',
    `tank_before_sounding_meters` DECIMAL(18,2) COMMENT 'Tank gauging reading in meters before bunkering commenced. Used to calculate actual quantity received.',
    `total_fuel_cost` DECIMAL(18,2) COMMENT 'Total cost for the bunker fuel delivered, calculated as quantity delivered multiplied by unit price.',
    `unit_price_per_mt` DECIMAL(18,2) COMMENT 'Price per metric tonne of bunker fuel. Commercial pricing information used for billing and cost analysis.',
    `viscosity_cst` DECIMAL(18,2) COMMENT 'Kinematic viscosity of the fuel in centistokes (cSt) at 50°C. Key quality parameter affecting fuel handling and combustion.',
    `vts_clearance_number` STRING COMMENT 'VTS clearance reference number authorizing the bunkering operation. Required for operations in VTS-controlled waters.',
    `weather_condition` STRING COMMENT 'Weather conditions during the bunkering operation. Impacts safety assessment and operational decision-making.',
    `wind_speed_knots` DECIMAL(18,2) COMMENT 'Wind speed in knots during the bunkering operation. Safety parameter for determining if conditions are suitable for fuel transfer.',
    CONSTRAINT pk_bunker_operation PRIMARY KEY(`bunker_operation_id`)
) COMMENT 'Transactional record of bunkering (fuel supply) operations conducted during a port call. Captures bunker supplier, fuel type (VLSFO, LSMGO, HFO, LNG), quantity ordered, quantity delivered (MT), delivery method (barge, pipeline, truck), BDN (Bunker Delivery Note) reference number, sulphur content percentage, density, delivery start and end timestamps, tank gauging readings (before/after), and operation status. Supports MARPOL Annex VI compliance, port safety management during bunkering, and commercial billing for anchorage/berth time during fueling operations.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` (
    `deployment_id` BIGINT COMMENT 'Unique identifier for this gang deployment record. Primary key.',
    `call_id` BIGINT COMMENT 'Foreign key linking to the vessel port call for which this gang was deployed',
    `vessel_id` BIGINT COMMENT 'add column vessel_id (BIGINT) with FK to vessel.vessel.vessel_id - vessel deployments must reference which vessel is being deployed',
    `gang_id` BIGINT COMMENT 'Foreign key linking to the stevedore gang deployed for this operation',
    `actual_finish_time` TIMESTAMP COMMENT 'Actual timestamp when this gang completed cargo operations and was released from this vessel call. Used for productivity and billing.',
    `actual_start_time` TIMESTAMP COMMENT 'Actual timestamp when this gang commenced cargo operations on this vessel. Used for productivity calculation and payroll.',
    `cargo_type` STRING COMMENT 'The type of cargo handled by this gang during this deployment. Determines handling requirements, safety protocols, and productivity targets.',
    `deployment_timestamp` TIMESTAMP COMMENT 'Timestamp when this gang deployment was created or assigned in the system. Used for audit and planning history.',
    `gang_size_actual` STRING COMMENT 'The actual number of workers deployed in this gang for this specific call. May differ from standard complement due to operational requirements or availability.',
    `gross_hours_worked` DECIMAL(18,2) COMMENT 'Total elapsed hours from actual start to actual finish for this gang deployment. Used for payroll and cost allocation.',
    `hatch_number` STRING COMMENT 'The vessel hatch or bay location where this gang was deployed. Multiple gangs may work different hatches on the same call simultaneously.',
    `moves_completed` STRING COMMENT 'Total number of container moves (lifts) completed by this gang during this deployment. Primary productivity metric.',
    `moves_per_hour` DECIMAL(18,2) COMMENT 'Calculated productivity metric: moves completed divided by net working hours (gross minus stoppages). Key performance indicator for gang and terminal efficiency.',
    `operation_type` STRING COMMENT 'The specific cargo operation this gang performed during this deployment: loading, discharge, restow, lashing, or unlashing. Determines productivity benchmarks and billing rates.',
    `scheduled_start_time` TIMESTAMP COMMENT 'Planned timestamp when this gang was scheduled to commence work on this vessel call. Used for shift planning and resource allocation.',
    `stoppage_hours` DECIMAL(18,2) COMMENT 'Total hours of operational stoppages during this deployment (weather, equipment breakdown, vessel delays). Subtracted from gross hours for net productivity calculation.',
    `teu_handled` STRING COMMENT 'Total TEU handled by this gang during this deployment. Used for volume-based productivity and billing calculations.',
    CONSTRAINT pk_deployment PRIMARY KEY(`deployment_id`)
) COMMENT 'This association product represents the operational deployment of a stevedore gang to a specific vessel port call. It captures the assignment of labour resources to cargo operations, tracking scheduled and actual work times, productivity metrics, and operational outcomes. Each record links one gang to one call with attributes that exist only in the context of this specific deployment event.. Existence Justification: In maritime terminal operations, a single vessel port call requires multiple stevedore gangs deployed across different hatches, shifts, and cargo operation types (loading, discharge, restow, lashing). Conversely, each gang is deployed to multiple vessel calls throughout their operational roster period. Gang deployment is a core operational business process actively managed by terminal planners, with rich transactional data including scheduled and actual times, productivity metrics (moves per hour), stoppage tracking, hatch assignments, and payroll integration.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` (
    `agency_appointment_id` BIGINT COMMENT 'Unique surrogate identifier for each vessel agency appointment record. Primary key for the association.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to the port community participant acting as the vessel agent',
    `call_id` BIGINT COMMENT 'add column vessel_call_id (BIGINT) with FK to vessel.call.call_id - agency appointments are made in context of a specific vessel call',
    `vessel_id` BIGINT COMMENT 'Foreign key linking to the vessel being represented by the appointed agent',
    `agency_type` STRING COMMENT 'Classification of the type of agency service being provided. Husbandry agents handle operational services (pilotage, tugs, linesmen, provisions), protective agents represent cargo interests, customs brokers handle customs clearance, liner agents represent shipping lines on a standing basis, and port agents provide general port services.',
    `appointing_party_imo_company_number` STRING COMMENT 'IMO company identification number of the entity that made the agency appointment. Links to the vessel ownership/management hierarchy.',
    `appointing_party_name` STRING COMMENT 'Name of the entity that made the agency appointment (typically the vessel owner, technical manager, or commercial operator). Identifies who has the authority to appoint and terminate the agent.',
    `appointment_created_by` STRING COMMENT 'User identifier of the person who created the agency appointment record. Used for audit trail and accountability.',
    `appointment_created_date` TIMESTAMP COMMENT 'Timestamp when the agency appointment record was created in the system. Used for audit trail and appointment history tracking.',
    `appointment_end_date` DATE COMMENT 'Date on which the agency appointment expires or is scheduled to terminate. May be null for open-ended appointments that continue until explicitly terminated.',
    `appointment_reference_number` STRING COMMENT 'Unique business reference number assigned to the agency appointment. Used in commercial correspondence, invoicing, and port authority documentation.',
    `appointment_scope` STRING COMMENT 'Textual description of the scope of authority and services covered by the agency appointment. Defines what the agent is authorized to do on behalf of the vessel (e.g., Full husbandry services including berth booking, pilotage arrangement, crew changes, and bunker coordination or Customs clearance only).',
    `appointment_start_date` DATE COMMENT 'Date on which the agency appointment becomes effective. The agent is authorized to act on behalf of the vessel from this date forward.',
    `appointment_status` STRING COMMENT 'Current lifecycle status of the agency appointment. Active indicates the appointment is in force, Suspended indicates temporary hold, Terminated indicates early cancellation, Expired indicates natural end of appointment period.',
    `authority_level` STRING COMMENT 'Level of decision-making authority granted to the agent. Full authority allows agent to commit vessel to services and expenses up to approved limits, limited authority requires pre-approval for major items, notification only means agent coordinates but does not commit.',
    `commission_rate_percent` DECIMAL(18,2) COMMENT 'Percentage commission rate paid to the agent on port service charges arranged on behalf of the vessel. Typically ranges from 2.5% to 7.5% depending on service type and volume. Commercially sensitive data.',
    `financial_limit_amount` DECIMAL(18,2) COMMENT 'Maximum amount the agent is authorized to commit on behalf of the vessel without seeking additional approval. Null indicates no specific limit or full authority level does not require limits.',
    `financial_limit_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the financial limit amount.',
    `port_of_appointment` STRING COMMENT 'UN/LOCODE of the port where this agency appointment is valid. Many vessels have different agents at different ports. Null indicates the appointment is valid at all ports.',
    `service_fee_structure` STRING COMMENT 'Billing model for the agency services. Commission-only means agent earns percentage of arranged services, flat fee means fixed amount per call, commission plus fee combines both, time and materials means hourly billing. Commercially sensitive data.',
    `termination_reason` STRING COMMENT 'Reason for early termination of the agency appointment if status is Terminated. Examples include poor service performance, change of vessel ownership, vessel sold, or commercial dispute. Null if appointment is active or expired naturally.',
    CONSTRAINT pk_agency_appointment PRIMARY KEY(`agency_appointment_id`)
) COMMENT 'This association product represents the Agency Appointment contract between a vessel and a port community participant acting as the vessels agent. It captures the formal appointment of a port agent (shipping agent, husbandry agent, protective agent, or customs broker) to represent and provide services to a vessel during port calls. Each record links one vessel to one port community participant with appointment-specific attributes including agency type, scope of authority, appointment period, commission structure, and service fee arrangements that exist only in the context of this agency relationship.. Existence Justification: Vessel agency appointments are genuine operational M:N relationships in maritime logistics. A single vessel requires multiple agents across different ports and service types (husbandry agent in Singapore, protective agent in Rotterdam, customs broker in Los Angeles), and a single port agent company services multiple vessels simultaneously. The business actively manages these appointments as formal contracts with specific scope, authority levels, commission rates, and appointment periods.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` (
    `service_agreement_id` BIGINT COMMENT 'Unique identifier for this vessel-vendor service agreement record. Primary key.',
    `agreement_id` BIGINT COMMENT 'add column contract_agreement_id (BIGINT) with FK to contract.agreement.agreement_id - vessel service agreements should link to the central contract domain for unified contract management',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to the vendor providing services to the vessel',
    `vessel_id` BIGINT COMMENT 'Foreign key linking to the vessel receiving services from the vendor',
    `contract_reference` STRING COMMENT 'External contract or agreement reference number governing this vessel-vendor service relationship. Links to procurement contract management system.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this vessel service agreement record was created.',
    `performance_rating` DECIMAL(18,2) COMMENT 'Performance rating for this specific vendor-vessel service relationship, typically on a scale of 0.00 to 5.00. Captures service quality, timeliness, compliance, and responsiveness specific to this vessel-vendor pairing. Used for vendor selection and contract renewal decisions.',
    `preferred_vendor_flag` BOOLEAN COMMENT 'Indicates whether this vendor is designated as a preferred supplier for this service type for this specific vessel. Used for procurement routing and vendor selection workflows.',
    `service_type` STRING COMMENT 'Category of service provided by the vendor to the vessel. Examples: ship agency, chandlery, waste disposal, bunker supply, repair and maintenance, technical services, crew services, provisions.',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this vessel service agreement record was last updated.',
    `valid_from_date` DATE COMMENT 'Date from which this vessel-vendor service agreement becomes effective. Used for temporal validity tracking and historical service relationship analysis.',
    `valid_to_date` DATE COMMENT 'Date until which this vessel-vendor service agreement remains valid. Null indicates open-ended agreement. Used for contract renewal planning and vendor relationship management.',
    CONSTRAINT pk_service_agreement PRIMARY KEY(`service_agreement_id`)
) COMMENT 'This association product represents the contractual service relationship between a vessel and a vendor. It captures the specific services provided by vendors to vessels, including service type, contract terms, validity periods, and performance tracking. Each record links one vessel to one vendor with attributes that exist only in the context of this service relationship. Supports procurement planning, vendor performance management, and vessel operational readiness tracking.. Existence Justification: In maritime port operations, vessels require multiple specialized vendors across different service categories (ship agents, chandlers, waste contractors, bunker suppliers, repair yards, crew services) at different ports and operational contexts. Each vendor serves multiple vessels across different shipping lines and vessel types. The business actively manages these service relationships as Vessel Service Agreements with specific contract terms, validity periods, service types, and performance ratings that are unique to each vessel-vendor pairing.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` (
    `charter_id` BIGINT COMMENT 'Unique system identifier for this vessel charter agreement record. Primary key.',
    `port_community_participant_id` BIGINT COMMENT 'add column port_community_participant_id (BIGINT) with FK to customer.port_community_participant.port_community_participant_id - charters involve a charterer party who is a port community participant',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to the shipping line master record. Identifies which carrier is operating the vessel under this charter.',
    `vessel_id` BIGINT COMMENT 'Foreign key linking to the vessel master record. Identifies which vessel is subject to this charter agreement.',
    `bareboat_charter_flag` BOOLEAN COMMENT 'Indicates whether this is a bareboat (demise) charter where the charterer takes full possession and operational control of the vessel, effectively operating it as if they were the owner.',
    `charter_type` STRING COMMENT 'Type of charter arrangement governing this vessel-carrier relationship. TIME_CHARTER: carrier hires vessel for specified period; VOYAGE_CHARTER: carrier hires vessel for specific voyage; BAREBOAT_CHARTER: carrier takes full operational control; SLOT_CHARTER: carrier leases container slots; DEMISE_CHARTER: full transfer of possession and control.',
    `commercial_operator_flag` BOOLEAN COMMENT 'Indicates whether this shipping line is the commercial operator (disponent owner) of the vessel under this charter, responsible for commercial decisions, cargo booking, and freight revenue.',
    `commercial_operator_imo_company_number` STRING COMMENT 'Unique IMO company identification number assigned to the commercial operator organization. [Moved from vessel: This is relationship-specific data that varies by charter arrangement. The commercial operator IMO number should be derived from the shipping_line master record linked through this association, not stored redundantly in the vessel record.]',
    `commercial_operator_name` STRING COMMENT 'Name of the entity commercially operating the vessel under charter or management agreement. The disponent owner controls cargo bookings and voyage planning. [Moved from vessel: This attribute currently exists in the vessel product but represents relationship-specific data. A vessel can have different commercial operators through different charter arrangements simultaneously or over time. This belongs in the vessel_charter association with the commercial_operator_flag to properly model the many-to-many reality of vessel charter relationships.]',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this charter relationship record was first created in the port system.',
    `end_date` DATE COMMENT 'Date when this charter agreement expires or was terminated. Null indicates an active ongoing charter with no fixed end date.',
    `operational_status` STRING COMMENT 'Current operational status of this charter agreement. ACTIVE: charter is in effect; SUSPENDED: temporarily inactive; TERMINATED: charter has ended; PENDING: charter signed but not yet commenced.',
    `party_reference` STRING COMMENT 'External reference number or identifier for the charter party agreement document governing this vessel-carrier relationship. Used for contract management and legal reference.',
    `start_date` DATE COMMENT 'Date when this charter agreement became effective and the shipping line assumed operational responsibility for the vessel under the terms of this charter.',
    `technical_manager_flag` BOOLEAN COMMENT 'Indicates whether this shipping line is responsible for technical management of the vessel under this charter, including maintenance, crew management, and technical operations.',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this charter relationship record was last modified.',
    CONSTRAINT pk_charter PRIMARY KEY(`charter_id`)
) COMMENT 'This association product represents the charter contract between a vessel and a shipping line. It captures the commercial and operational relationship where a shipping line operates a vessel under various charter arrangements (time charter, voyage charter, bareboat charter). Each record links one vessel to one shipping line with charter-specific attributes including charter type, duration, and operational responsibility flags. This is the operational SSOT for vessel-carrier relationships used in vessel scheduling, commercial billing, fleet management, and regulatory reporting.. Existence Justification: In maritime operations, vessels operate under complex charter arrangements where a single vessel can simultaneously have relationships with multiple shipping lines in different operational capacities (owner, bareboat charterer, time charterer, slot charterer). Conversely, shipping lines operate fleets of multiple vessels under various charter types. Charter agreements are actively managed business contracts with specific attributes (charter type, duration, operational responsibility splits) that belong to neither the vessel nor the shipping line alone, but to the relationship itself.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` (
    `port_call_id` BIGINT COMMENT 'Unique system identifier for the port call record. Primary key.',
    `infrastructure_berth_allocation_id` BIGINT COMMENT 'Foreign key to the specific berth assignment record if this call involved berthing operations. Links to berth scheduling system.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to the port location where the call occurred',
    `call_id` BIGINT COMMENT 'add column vessel_call_id (BIGINT) with FK to vessel.call.call_id - port_call appears to duplicate or extend vessel.call and must be linked to avoid data silos',
    `vessel_id` BIGINT COMMENT 'Foreign key linking to the vessel making the port call',
    `access_restriction_flag` BOOLEAN COMMENT 'Indicates whether this vessel has access restrictions or blacklist status for this specific port location.',
    `arrival_datetime` TIMESTAMP COMMENT 'Timestamp when the vessel arrived at the port location (pilot boarding or berth arrival depending on location type).',
    `call_performance_rating` STRING COMMENT 'Overall performance rating for this port call based on operational efficiency, safety compliance, and commercial metrics.',
    `call_purpose` STRING COMMENT 'Primary business purpose of the port call. Determines operational workflows and billing categories.',
    `call_sequence_number` STRING COMMENT 'Sequential number of this call for the vessel at this specific port location. Enables tracking of repeat visits (1st call, 2nd call, etc.).',
    `call_status` STRING COMMENT 'Current operational status of the port call in the lifecycle workflow.',
    `cargo_volume_tonnes` DECIMAL(18,2) COMMENT 'Total cargo volume handled during this port call in metric tonnes. Aggregated from cargo operations.',
    `container_moves_count` STRING COMMENT 'Total number of container moves (load + discharge) performed during this port call. Key performance metric for container terminals.',
    `created_datetime` TIMESTAMP COMMENT 'Timestamp when this port call record was created in the system.',
    `departure_datetime` TIMESTAMP COMMENT 'Timestamp when the vessel departed from the port location.',
    `last_updated_datetime` TIMESTAMP COMMENT 'Timestamp when this port call record was last modified.',
    `port_stay_hours` DECIMAL(18,2) COMMENT 'Total duration of the port call in hours, calculated from arrival to departure. Used for performance analytics and berth utilization metrics.',
    `preferred_location_flag` BOOLEAN COMMENT 'Indicates whether this port location is a preferred calling point for this vessel based on operational history and performance.',
    `psc_deficiency_count` STRING COMMENT 'Number of deficiencies identified during PSC inspection if conducted. Used for vessel risk profiling.',
    `psc_inspection_flag` BOOLEAN COMMENT 'Indicates whether a Port State Control inspection was conducted during this call.',
    `restriction_reason` STRING COMMENT 'Explanation of why access restrictions apply to this vessel-location combination (e.g., PSC detention history, commercial dispute, safety incident).',
    `total_port_charges_amount` DECIMAL(18,2) COMMENT 'Total port charges billed for this call including berth dues, pilotage, towage, and other marine services.',
    CONSTRAINT pk_port_call PRIMARY KEY(`port_call_id`)
) COMMENT 'This association product represents the operational event of a vessel calling at a specific port location. It captures the complete port call lifecycle including arrival, berthing, operations, and departure. Each record links one vessel to one port location with attributes that track call-specific operational data, performance metrics, and access control decisions. This is the foundational operational record for terminal operations, marine services billing, and vessel performance analytics.. Existence Justification: In maritime port operations, vessels make multiple calls at multiple port locations throughout their operational life, and each port location receives thousands of vessels over time. Each port call is a distinct operational event with its own lifecycle (arrival, berthing, operations, departure), performance metrics, cargo volumes, charges, and access control decisions. Port calls are actively managed by marine operations teams as standalone business events with rich operational data.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` (
    `call_assignment_id` BIGINT COMMENT 'Unique identifier for this port call assignment record. Primary key.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to the employee assigned to this port call',
    `call_id` BIGINT COMMENT 'Foreign key linking to the port call being serviced by this assignment',
    `assignment_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the employee completed or was relieved from their assignment to this port call. Used for shift handover tracking and labor cost calculation. Explicitly identified in detection phase relationship data.',
    `assignment_role` STRING COMMENT 'The specific operational role the employee is performing for this port call. Determines responsibilities, authority level, and coordination requirements. Explicitly identified in detection phase relationship data.',
    `assignment_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the employee began their assignment to this port call. May precede vessel arrival for pre-arrival planning roles. Explicitly identified in detection phase relationship data.',
    `assignment_status` STRING COMMENT 'Current lifecycle status of this assignment. Scheduled indicates planned but not yet active; active indicates employee is currently on duty; completed indicates assignment finished normally; relieved indicates handover to another employee; cancelled indicates assignment was not fulfilled.',
    `created_by_user_code` BIGINT COMMENT 'Reference to the user who created this assignment record. Supports accountability for crew scheduling decisions.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this assignment record was created in the system. Used for audit trail and planning lead time analysis.',
    `responsibility_area` STRING COMMENT 'The specific operational area or scope of responsibility for this assignment (e.g., Berth 5-7, Container Terminal A, VTS Channel 12, Cargo Hold 1-3). Supports zone-based coordination and accountability. Explicitly identified in detection phase relationship data.',
    `shift_type` STRING COMMENT 'The shift classification during which this assignment occurred. Affects labor rates, overtime calculation, and crew availability planning. Explicitly identified in detection phase relationship data.',
    CONSTRAINT pk_call_assignment PRIMARY KEY(`call_assignment_id`)
) COMMENT 'This association product represents the operational assignment of port workforce personnel to vessel port calls. It captures the specific role, time window, and responsibility area for each employee assigned to support a vessel visit. Each record links one port call to one employee with attributes that exist only in the context of this assignment relationship. Supports multi-role tracking, shift handover coordination, and operational accountability for vessel service delivery.. Existence Justification: In port operations, a single vessel call requires multiple employees in different operational roles (port captain, VTS officer, security officer, customs liaison, operations supervisor, pilots, linesmen, stevedore foremen, equipment operators, cargo inspectors) working simultaneously or in sequence across the call lifecycle. Conversely, each employee handles multiple vessel calls per shift, day, or week depending on their role and the ports traffic volume. The business actively manages these assignments with role-specific responsibilities, time windows, shift types, and responsibility areas.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` (
    `call_icd_allocation_id` BIGINT COMMENT 'Unique identifier for this port call to ICD facility cargo allocation record. Primary key.',
    `icd_facility_id` BIGINT COMMENT 'Foreign key to intermodal.icd_facility.icd_facility_id representing the inland depot receiving cargo',
    `call_id` BIGINT COMMENT 'Foreign key linking to the vessel port call that is distributing cargo to the ICD facility',
    `cargo_volume_teu` STRING COMMENT 'Number of TEU allocated from this specific port call to this specific ICD facility. Represents the planned or actual cargo volume for this distribution relationship.',
    `effective_from_date` DATE COMMENT 'Date when this cargo allocation or service agreement between the port call and ICD facility becomes effective',
    `effective_to_date` DATE COMMENT 'Date when this cargo allocation or service agreement expires. Null for ongoing allocations.',
    `primary_cargo_type` STRING COMMENT 'Primary type of cargo being allocated from this port call to this ICD facility. Determines handling requirements and facility capabilities needed.',
    `service_level_agreement` STRING COMMENT 'Service level agreement terms or reference code governing the cargo distribution relationship between this port call and ICD facility',
    CONSTRAINT pk_call_icd_allocation PRIMARY KEY(`call_icd_allocation_id`)
) COMMENT 'This association product represents the cargo distribution allocation between a vessel port call and an inland container depot. It captures the volume of cargo (in TEU) allocated from a specific port call to a specific ICD facility, along with the service agreement terms, effective dates, and primary cargo type for that allocation. Each record links one port call to one ICD facility with attributes that exist only in the context of this cargo distribution relationship.. Existence Justification: In maritime logistics operations, a single vessel port call distributes cargo to multiple inland container depots based on destination routing, and each ICD facility receives containers from multiple vessel calls throughout its operations. The port manages cargo distribution allocations as operational records with specific volume commitments, effective dates, and service agreements for each port-call-to-ICD relationship.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` (
    `call_inspection_id` BIGINT COMMENT 'Unique identifier for this call-inspection association record. Primary key.',
    `call_safety_inspection_id` BIGINT COMMENT 'Foreign key to the safety inspection record',
    `inspection_id` BIGINT COMMENT 'Foreign key linking to the safety inspection record that was conducted for this port call',
    `call_id` BIGINT COMMENT 'Foreign key linking to the specific port call that was subject to this safety inspection event',
    `clearance_granted_timestamp` TIMESTAMP COMMENT 'Timestamp when departure clearance was granted following successful inspection or rectification completion. Null if clearance not yet granted.',
    `deficiencies_found` STRING COMMENT 'Number of deficiencies identified during this inspection that are specific to this port call context. Used to determine detention risk and clearance requirements.',
    `detention_flag` BOOLEAN COMMENT 'Indicates whether this inspection resulted in vessel detention for this port call. Critical for port call performance metrics and vessel scheduling.',
    `follow_up_due_timestamp` TIMESTAMP COMMENT 'Deadline by which follow-up actions must be completed for this port call. Typically set relative to planned ETD.',
    `follow_up_required` BOOLEAN COMMENT 'Indicates whether follow-up actions or re-inspection are required before this port call can be cleared for departure. Blocks ETD if true.',
    `inspection_notes` STRING COMMENT 'Free-text notes specific to this inspection in the context of this port call, including any call-specific observations or coordination notes with the vessel agent.',
    `inspection_outcome` STRING COMMENT 'The outcome of this specific inspection for this port call. Determines whether the vessel is cleared for departure or must complete rectification actions.',
    `inspection_scope` STRING COMMENT 'The specific scope of this inspection as it relates to this particular port call. A single safety inspection may cover multiple calls (e.g., PSC campaign), and this attribute captures what aspects were inspected for THIS call specifically.',
    `inspection_timestamp` TIMESTAMP COMMENT 'Precise timestamp when this inspection was conducted for this port call. Critical for tracking whether inspection occurred before cargo operations commenced or before departure clearance.',
    CONSTRAINT pk_call_inspection PRIMARY KEY(`call_inspection_id`)
) COMMENT 'This association product represents the inspection event linking a vessel port call to a safety inspection record. It captures the specific scope, timing, and outcomes when a safety inspection is conducted in the context of a particular port call. Each record links one port call to one safety inspection with attributes that exist only in the context of this relationship, such as the specific inspection scope for that call, findings relevant to that vessel visit, and follow-up actions required before departure clearance.. Existence Justification: In maritime port operations, a single port call can undergo multiple safety inspections (PSC, ISPS security check, cargo safety audit, environmental compliance inspection) during the vessels stay. Conversely, a single safety inspection campaign (e.g., coordinated PSC inspection day) can cover multiple vessels/port calls simultaneously. The business actively manages these inspection-to-call associations, tracking which inspections have been completed for each call, whether findings block departure clearance, and what follow-up actions are required before the vessel can sail.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ADD CONSTRAINT `fk_vessel_owner_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ADD CONSTRAINT `fk_vessel_voyage_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ADD CONSTRAINT `fk_vessel_anchorage_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ADD CONSTRAINT `fk_vessel_anchorage_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ADD CONSTRAINT `fk_vessel_vts_log_anchorage_id` FOREIGN KEY (`anchorage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`anchorage`(`anchorage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ADD CONSTRAINT `fk_vessel_vts_log_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ADD CONSTRAINT `fk_vessel_vts_log_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ADD CONSTRAINT `fk_vessel_call_document_agent_appointment_id` FOREIGN KEY (`agent_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`agent_appointment`(`agent_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ADD CONSTRAINT `fk_vessel_call_document_previous_document_call_document_id` FOREIGN KEY (`previous_document_call_document_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call_document`(`call_document_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ADD CONSTRAINT `fk_vessel_call_document_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_psc_inspection_id` FOREIGN KEY (`psc_inspection_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`psc_inspection`(`psc_inspection_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ADD CONSTRAINT `fk_vessel_draft_survey_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ADD CONSTRAINT `fk_vessel_draft_survey_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ADD CONSTRAINT `fk_vessel_crew_list_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ADD CONSTRAINT `fk_vessel_crew_list_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ADD CONSTRAINT `fk_vessel_waste_declaration_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ADD CONSTRAINT `fk_vessel_waste_declaration_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ADD CONSTRAINT `fk_vessel_isps_record_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ADD CONSTRAINT `fk_vessel_isps_record_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_amended_bunker_operation_id` FOREIGN KEY (`amended_bunker_operation_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`bunker_operation`(`bunker_operation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_anchorage_id` FOREIGN KEY (`anchorage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`anchorage`(`anchorage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ADD CONSTRAINT `fk_vessel_deployment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ADD CONSTRAINT `fk_vessel_deployment_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ADD CONSTRAINT `fk_vessel_agency_appointment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ADD CONSTRAINT `fk_vessel_agency_appointment_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ADD CONSTRAINT `fk_vessel_service_agreement_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ADD CONSTRAINT `fk_vessel_charter_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ADD CONSTRAINT `fk_vessel_call_assignment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` ADD CONSTRAINT `fk_vessel_call_icd_allocation_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ADD CONSTRAINT `fk_vessel_call_inspection_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`vessel` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`vessel` SET TAGS ('dbx_domain' = 'vessel');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `beam_meters` SET TAGS ('dbx_business_glossary_term' = 'Beam Width in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `call_sign` SET TAGS ('dbx_business_glossary_term' = 'Radio Call Sign');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `classification_society_code` SET TAGS ('dbx_business_glossary_term' = 'Classification Society Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `cso_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Company Security Officer (CSO) Contact Email');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `cso_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `cso_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `cso_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `cso_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Company Security Officer (CSO) Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `cso_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `cso_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `cso_name` SET TAGS ('dbx_business_glossary_term' = 'Company Security Officer (CSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `cso_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `draft_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Draft in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `dwt_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Deadweight Tonnage (DWT) in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `grt_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `imo_number` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `imo_number` SET TAGS ('dbx_value_regex' = '^IMO[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `ism_company_imo_number` SET TAGS ('dbx_business_glossary_term' = 'ISM Company IMO Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `ism_company_name` SET TAGS ('dbx_business_glossary_term' = 'International Safety Management (ISM) Company Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `last_psc_deficiency_count` SET TAGS ('dbx_business_glossary_term' = 'Last Port State Control (PSC) Deficiency Count');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `last_psc_detention_flag` SET TAGS ('dbx_business_glossary_term' = 'Last Port State Control (PSC) Detention Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `last_psc_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Port State Control (PSC) Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `loa_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `mmsi_number` SET TAGS ('dbx_business_glossary_term' = 'Maritime Mobile Service Identity (MMSI) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `mmsi_number` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `vessel_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `nrt_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Net Registered Tonnage (NRT) in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|laid_up|under_repair|scrapped|lost|detained');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `owner_country_domicile_code` SET TAGS ('dbx_business_glossary_term' = 'Owner Country of Domicile Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `ownership_current_flag` SET TAGS ('dbx_business_glossary_term' = 'Ownership Current Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `ownership_effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Ownership Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `ownership_effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Ownership Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `pni_club_code` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `registered_owner_imo_company_number` SET TAGS ('dbx_business_glossary_term' = 'Registered Owner IMO Company Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `registered_owner_name` SET TAGS ('dbx_business_glossary_term' = 'Registered Owner Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `risk_profile_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Profile Score');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `risk_profile_score` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `sanctions_screening_date` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `sanctions_screening_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `sanctions_screening_status` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `sanctions_screening_status` SET TAGS ('dbx_value_regex' = 'cleared|flagged|under_review|blocked');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `sanctions_screening_status` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `shipyard_country_code` SET TAGS ('dbx_business_glossary_term' = 'Shipyard Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `shipyard_name` SET TAGS ('dbx_business_glossary_term' = 'Shipyard Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `technical_manager_imo_company_number` SET TAGS ('dbx_business_glossary_term' = 'Technical Manager IMO Company Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `technical_manager_name` SET TAGS ('dbx_business_glossary_term' = 'Technical Manager Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `teu_capacity` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `year_built` SET TAGS ('dbx_business_glossary_term' = 'Year Built');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `owner_id` SET TAGS ('dbx_business_glossary_term' = 'Owner Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `receivable_account_id` SET TAGS ('dbx_business_glossary_term' = 'Receivable Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `billing_account_reference` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `business_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Business Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `company_name` SET TAGS ('dbx_business_glossary_term' = 'Company Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Contact Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `contact_fax` SET TAGS ('dbx_business_glossary_term' = 'Contact Fax Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `contact_fax` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `contact_fax` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `country_of_domicile` SET TAGS ('dbx_business_glossary_term' = 'Country of Domicile');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `country_of_domicile` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `credit_rating` SET TAGS ('dbx_business_glossary_term' = 'Credit Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `credit_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `cso_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Company Security Officer (CSO) Contact Email');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `cso_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `cso_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `cso_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `cso_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Company Security Officer (CSO) Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `cso_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `cso_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `cso_name` SET TAGS ('dbx_business_glossary_term' = 'Company Security Officer (CSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `cso_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `cso_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `doc_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Document of Compliance (DOC) Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `doc_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Document of Compliance (DOC) Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `doc_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Document of Compliance (DOC) Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `imo_company_number` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Company Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `imo_company_number` SET TAGS ('dbx_value_regex' = '^[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `is_beneficial_owner` SET TAGS ('dbx_business_glossary_term' = 'Is Beneficial Owner Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `kyc_verification_date` SET TAGS ('dbx_business_glossary_term' = 'Know Your Customer (KYC) Verification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `kyc_verification_status` SET TAGS ('dbx_business_glossary_term' = 'Know Your Customer (KYC) Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `kyc_verification_status` SET TAGS ('dbx_value_regex' = 'verified|pending|failed|expired');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `management_contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Management Contract Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `ownership_percentage` SET TAGS ('dbx_business_glossary_term' = 'Ownership Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `ownership_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `ownership_role_type` SET TAGS ('dbx_business_glossary_term' = 'Ownership Role Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `ownership_role_type` SET TAGS ('dbx_value_regex' = 'registered_owner|technical_manager|commercial_operator|ism_company|ship_manager|bareboat_charterer');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `ownership_status` SET TAGS ('dbx_business_glossary_term' = 'Ownership Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `ownership_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_transfer|terminated');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `pni_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `pni_club_name` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `registered_address` SET TAGS ('dbx_business_glossary_term' = 'Registered Address');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `registered_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `registered_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `sanctions_screening_date` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `sanctions_screening_status` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `sanctions_screening_status` SET TAGS ('dbx_value_regex' = 'cleared|flagged|under_review|blocked');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Call Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `contact_person_id` SET TAGS ('dbx_business_glossary_term' = 'Agent Primary Contact Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Appointed Agent Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `agency_type` SET TAGS ('dbx_business_glossary_term' = 'Agency Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `agency_type` SET TAGS ('dbx_value_regex' = 'general|husbanding|cargo|protective');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `all_fast_timestamp` SET TAGS ('dbx_business_glossary_term' = 'All Fast Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `appointment_end_date` SET TAGS ('dbx_business_glossary_term' = 'Appointment End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `appointment_scope` SET TAGS ('dbx_business_glossary_term' = 'Appointment Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `appointment_scope` SET TAGS ('dbx_value_regex' = 'single_call|voyage_series|annual|term_contract');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `appointment_start_date` SET TAGS ('dbx_business_glossary_term' = 'Appointment Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `appointment_status` SET TAGS ('dbx_business_glossary_term' = 'Appointment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `appointment_status` SET TAGS ('dbx_value_regex' = 'active|suspended|terminated|pending_approval');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `ata` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Arrival (ATA)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `atb` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Berthing (ATB)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `atd` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Departure (ATD)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `baplie_received_flag` SET TAGS ('dbx_business_glossary_term' = 'Bayplan/Stowage Plan (BAPLIE) Received Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `call_number` SET TAGS ('dbx_business_glossary_term' = 'Call Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `call_status` SET TAGS ('dbx_business_glossary_term' = 'Call Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `cargo_ops_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Cargo Operations End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `cargo_ops_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Cargo Operations Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|inspection_required|hold|released');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `dangerous_goods_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `eta` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Arrival (ETA)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `etb` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Berthing (ETB)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `etd` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Departure (ETD)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `first_line_timestamp` SET TAGS ('dbx_business_glossary_term' = 'First Line Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `gangway_down_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Gangway Down Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `last_line_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Line Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `pilot_boarded_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Pilot Boarded Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `pilot_off_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Pilot Off Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `pod` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `pod` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `pol` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `pol` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `port_state_control_inspection_flag` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Inspection Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `purpose` SET TAGS ('dbx_business_glossary_term' = 'Call Purpose');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Call Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `total_feu_declared` SET TAGS ('dbx_business_glossary_term' = 'Total Forty-foot Equivalent Unit (FEU) Declared');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `total_teu_declared` SET TAGS ('dbx_business_glossary_term' = 'Total Twenty-foot Equivalent Unit (TEU) Declared');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `vts_clearance_reference` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Clearance Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Coordinator Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `ata` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Arrival (ATA)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `atb` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Berthing (ATB)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `atd` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Departure (ATD)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `baplie_received_flag` SET TAGS ('dbx_business_glossary_term' = 'BAPLIE (Bayplan/Stowage Plan) Received Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `berth_productivity_target` SET TAGS ('dbx_business_glossary_term' = 'Berth Productivity Target (Moves per Hour)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `call_sequence` SET TAGS ('dbx_business_glossary_term' = 'Port Call Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `cargo_manifest_received_flag` SET TAGS ('dbx_business_glossary_term' = 'Cargo Manifest Received Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `coparn_received_flag` SET TAGS ('dbx_business_glossary_term' = 'COPARN (Container Pre-Announcement) Received Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|inspection_required|hold|released');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `destination_port_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Port UN/LOCODE');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `destination_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `empty_teu_onboard` SET TAGS ('dbx_business_glossary_term' = 'Empty TEU (Twenty-foot Equivalent Unit) Onboard');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Voyage End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `eta` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Arrival (ETA)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `etb` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Berthing (ETB)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `etd` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Departure (ETD)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `imdg_cargo_onboard_flag` SET TAGS ('dbx_business_glossary_term' = 'IMDG (International Maritime Dangerous Goods) Cargo Onboard Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `is_maiden_call` SET TAGS ('dbx_business_glossary_term' = 'Maiden Call Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `is_omitted` SET TAGS ('dbx_business_glossary_term' = 'Port Call Omission Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_business_glossary_term' = 'ISPS (International Ship and Port Facility Security) Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `laden_teu_onboard` SET TAGS ('dbx_business_glossary_term' = 'Laden TEU (Twenty-foot Equivalent Unit) Onboard');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `next_port_code` SET TAGS ('dbx_business_glossary_term' = 'Next Port UN/LOCODE');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `next_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `omission_reason` SET TAGS ('dbx_business_glossary_term' = 'Port Call Omission Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `oog_cargo_onboard_flag` SET TAGS ('dbx_business_glossary_term' = 'OOG (Out of Gauge) Cargo Onboard Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `origin_port_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Port UN/LOCODE');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `origin_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `pilot_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `previous_port_code` SET TAGS ('dbx_business_glossary_term' = 'Previous Port UN/LOCODE');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `previous_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `quarantine_status` SET TAGS ('dbx_business_glossary_term' = 'Quarantine Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `quarantine_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|cleared|restricted');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `reefer_teu_onboard` SET TAGS ('dbx_business_glossary_term' = 'Reefer TEU (Twenty-foot Equivalent Unit) Onboard');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Voyage Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `rotation_number` SET TAGS ('dbx_business_glossary_term' = 'Rotation Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `service_code` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Service Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `service_name` SET TAGS ('dbx_business_glossary_term' = 'Service Route Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Voyage Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `total_teu_capacity` SET TAGS ('dbx_business_glossary_term' = 'Total TEU (Twenty-foot Equivalent Unit) Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `towage_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Towage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `voyage_status` SET TAGS ('dbx_business_glossary_term' = 'Voyage Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `voyage_status` SET TAGS ('dbx_value_regex' = 'planned|scheduled|in_progress|completed|cancelled|delayed');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `voyage_type` SET TAGS ('dbx_business_glossary_term' = 'Voyage Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `voyage_type` SET TAGS ('dbx_value_regex' = 'inbound|outbound|coastal|international|feeder|transshipment');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `anchorage_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Next Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `ohs_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Officer ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `terminal_berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Next Berth Allocation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `actual_anchor_drop_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Anchor Drop Time (ATA - Actual Time of Anchoring)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `actual_weigh_anchor_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Weigh Anchor Time (ATD - Actual Time of Departure from Anchorage)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `anchor_berth_number` SET TAGS ('dbx_business_glossary_term' = 'Anchor Berth Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `anchor_berth_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `assignment_priority` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Assignment Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Assignment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `assignment_status` SET TAGS ('dbx_value_regex' = 'ASSIGNED|ANCHORED|DEPARTED|CANCELLED');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `charge_currency` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Charge Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `charge_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_value_regex' = 'PENDING|CLEARED|HOLD|INSPECTION_REQUIRED');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Duration (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `expected_weigh_anchor_time` SET TAGS ('dbx_business_glossary_term' = 'Expected Weigh Anchor Time (ETD - Expected Time to Depart Anchorage)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `last_modified_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `last_modified_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `last_modified_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `pilot_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Pilot Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `port_health_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Port Health Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `port_health_clearance_status` SET TAGS ('dbx_value_regex' = 'PENDING|CLEARED|HOLD|INSPECTION_REQUIRED');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `port_health_clearance_status` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `port_health_clearance_status` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `position_latitude` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Position Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `position_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `position_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `position_longitude` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Position Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `position_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `position_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `quarantine_flag` SET TAGS ('dbx_business_glossary_term' = 'Quarantine Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Reason Description');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Assignment Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `scheduled_anchor_drop_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Anchor Drop Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `sea_state_code` SET TAGS ('dbx_business_glossary_term' = 'Sea State Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `sea_state_code` SET TAGS ('dbx_value_regex' = 'CALM|SLIGHT|MODERATE|ROUGH|VERY_ROUGH|HIGH');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `security_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `security_level` SET TAGS ('dbx_value_regex' = 'LEVEL_1|LEVEL_2|LEVEL_3');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `tug_assistance_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Tug Assistance Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `visibility_meters` SET TAGS ('dbx_business_glossary_term' = 'Visibility (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `water_depth_meters` SET TAGS ('dbx_business_glossary_term' = 'Water Depth at Anchorage (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `weather_condition` SET TAGS ('dbx_business_glossary_term' = 'Weather Condition at Anchorage');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ALTER COLUMN `wind_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Wind Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `movement_id` SET TAGS ('dbx_business_glossary_term' = 'Movement Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Operator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `ohs_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `air_draft_meters` SET TAGS ('dbx_business_glossary_term' = 'Air Draft (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `current_direction_degrees` SET TAGS ('dbx_business_glossary_term' = 'Current Direction (Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `current_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Current Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `dangerous_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `delay_minutes` SET TAGS ('dbx_business_glossary_term' = 'Delay (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `delay_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Delay Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `draft_aft_meters` SET TAGS ('dbx_business_glossary_term' = 'Draft Aft (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `draft_forward_meters` SET TAGS ('dbx_business_glossary_term' = 'Draft Forward (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Movement Duration (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `heading_degrees` SET TAGS ('dbx_business_glossary_term' = 'Heading (Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `movement_number` SET TAGS ('dbx_business_glossary_term' = 'Movement Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `movement_status` SET TAGS ('dbx_business_glossary_term' = 'Movement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `movement_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|delayed');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `movement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Movement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `movement_type` SET TAGS ('dbx_business_glossary_term' = 'Movement Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `movement_type` SET TAGS ('dbx_value_regex' = 'arrival|departure|shifting|anchorage_entry|anchorage_exit|canal_transit');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `number_of_tugs` SET TAGS ('dbx_business_glossary_term' = 'Number of Tugs');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `pilot_on_board_flag` SET TAGS ('dbx_business_glossary_term' = 'Pilot On Board Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Movement Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `scheduled_movement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Movement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `speed_over_ground_knots` SET TAGS ('dbx_business_glossary_term' = 'Speed Over Ground (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `tide_height_meters` SET TAGS ('dbx_business_glossary_term' = 'Tide Height (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `tug_assistance_flag` SET TAGS ('dbx_business_glossary_term' = 'Tug Assistance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `visibility_meters` SET TAGS ('dbx_business_glossary_term' = 'Visibility (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `vts_clearance_number` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Clearance Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `vts_reporting_channel` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Reporting Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `weather_condition` SET TAGS ('dbx_business_glossary_term' = 'Weather Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `weather_condition` SET TAGS ('dbx_value_regex' = 'clear|cloudy|rain|fog|storm|snow');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `wind_direction_degrees` SET TAGS ('dbx_business_glossary_term' = 'Wind Direction (Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `wind_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Wind Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vts_log_id` SET TAGS ('dbx_business_glossary_term' = 'Vts Log Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `anchorage_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Watch Officer ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `marine_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Incident ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `terminal_berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Allocation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `acknowledgement_status` SET TAGS ('dbx_business_glossary_term' = 'Acknowledgement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `acknowledgement_status` SET TAGS ('dbx_value_regex' = 'Acknowledged|Not Acknowledged|Pending|Not Required');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `acknowledgement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Acknowledgement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `ais_message_reference` SET TAGS ('dbx_business_glossary_term' = 'Automatic Identification System (AIS) Message ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `communication_channel` SET TAGS ('dbx_business_glossary_term' = 'Communication Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `incident_flag` SET TAGS ('dbx_business_glossary_term' = 'Incident Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `instruction_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Instruction Compliance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `instruction_compliance_status` SET TAGS ('dbx_value_regex' = 'Complied|Non-Compliant|Partial|Not Applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_value_regex' = 'Level 1|Level 2|Level 3');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `log_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Log Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `message_content` SET TAGS ('dbx_business_glossary_term' = 'Message Content Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `message_type` SET TAGS ('dbx_business_glossary_term' = 'Message Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `pilot_on_board_flag` SET TAGS ('dbx_business_glossary_term' = 'Pilot On Board Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'Routine|Priority|Urgent|Distress');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `record_created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `record_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `response_time_seconds` SET TAGS ('dbx_business_glossary_term' = 'Response Time (Seconds)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `traffic_density` SET TAGS ('dbx_business_glossary_term' = 'Traffic Density');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `traffic_density` SET TAGS ('dbx_value_regex' = 'Light|Moderate|Heavy|Congested');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vessel_course_degrees` SET TAGS ('dbx_business_glossary_term' = 'Vessel Course (Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vessel_position_latitude` SET TAGS ('dbx_business_glossary_term' = 'Vessel Position Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vessel_position_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vessel_position_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vessel_position_longitude` SET TAGS ('dbx_business_glossary_term' = 'Vessel Position Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vessel_position_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vessel_position_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vessel_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Vessel Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `visibility_meters` SET TAGS ('dbx_business_glossary_term' = 'Visibility (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vts_area_zone` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Area Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `vts_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Centre ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ALTER COLUMN `weather_condition` SET TAGS ('dbx_business_glossary_term' = 'Weather Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` SET TAGS ('dbx_subdomain' = 'compliance_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `call_document_id` SET TAGS ('dbx_business_glossary_term' = 'Call Document Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `agent_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Submitting Agent ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `previous_document_call_document_id` SET TAGS ('dbx_business_glossary_term' = 'Previous Document ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reviewing Officer Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `un_locode_id` SET TAGS ('dbx_business_glossary_term' = 'Un Locode Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `amendment_count` SET TAGS ('dbx_business_glossary_term' = 'Amendment Count');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `authority_acknowledgement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Authority Acknowledgement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `authority_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Authority Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `cargo_manifest_reference` SET TAGS ('dbx_business_glossary_term' = 'Cargo Manifest Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `crew_change_count` SET TAGS ('dbx_business_glossary_term' = 'Crew Change Count');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `crew_count` SET TAGS ('dbx_business_glossary_term' = 'Crew Count');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|inspection_required|hold|released');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `dangerous_goods_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `document_file_path` SET TAGS ('dbx_business_glossary_term' = 'Document File Path');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `document_file_path` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `document_format` SET TAGS ('dbx_business_glossary_term' = 'Document Format');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `document_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Document Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `document_status` SET TAGS ('dbx_business_glossary_term' = 'Document Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Document Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `edi_message_type` SET TAGS ('dbx_business_glossary_term' = 'EDI Message Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `fal_form_number` SET TAGS ('dbx_business_glossary_term' = 'FAL Form Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `health_illness_description` SET TAGS ('dbx_business_glossary_term' = 'Health Illness Description');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `health_illness_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `health_illness_onboard_flag` SET TAGS ('dbx_business_glossary_term' = 'Health Illness Onboard Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `health_illness_onboard_flag` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `health_illness_onboard_flag` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `health_sanitation_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Health Sanitation Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `health_sanitation_certificate_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `health_sanitation_certificate_number` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'IMDG Class');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `isps_current_security_level` SET TAGS ('dbx_business_glossary_term' = 'ISPS Current Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `isps_dos_required` SET TAGS ('dbx_business_glossary_term' = 'ISPS Declaration of Security (DoS) Required');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `isps_issc_number` SET TAGS ('dbx_business_glossary_term' = 'ISPS International Ship Security Certificate (ISSC) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `isps_last_ten_ports` SET TAGS ('dbx_business_glossary_term' = 'ISPS Last Ten Ports');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `isps_security_incident_flag` SET TAGS ('dbx_business_glossary_term' = 'ISPS Security Incident Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `isps_sso_name` SET TAGS ('dbx_business_glossary_term' = 'ISPS Ship Security Officer (SSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `marpol_waste_type` SET TAGS ('dbx_business_glossary_term' = 'MARPOL Waste Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `passenger_count` SET TAGS ('dbx_business_glossary_term' = 'Passenger Count');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `reception_facility_name` SET TAGS ('dbx_business_glossary_term' = 'Reception Facility Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `regulatory_authority` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `submission_channel` SET TAGS ('dbx_business_glossary_term' = 'Submission Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Submission Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `submitting_agent_name` SET TAGS ('dbx_business_glossary_term' = 'Submitting Agent Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `waste_actual_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Waste Actual Volume (Cubic Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `waste_delivery_confirmation_number` SET TAGS ('dbx_business_glossary_term' = 'Waste Delivery Confirmation Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ALTER COLUMN `waste_estimated_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Waste Estimated Volume (Cubic Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` SET TAGS ('dbx_subdomain' = 'compliance_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `certificate_id` SET TAGS ('dbx_business_glossary_term' = 'Certificate Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `compliance_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `marine_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `psc_inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Inspection ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `security_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Verification Officer Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `annual_survey_due_date` SET TAGS ('dbx_business_glossary_term' = 'Annual Survey Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `certificate_status` SET TAGS ('dbx_business_glossary_term' = 'Certificate Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `certificate_status` SET TAGS ('dbx_value_regex' = 'valid|expired|suspended|withdrawn|pending_renewal');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `certificate_type` SET TAGS ('dbx_business_glossary_term' = 'Certificate Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Data Source System');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `deficiency_codes` SET TAGS ('dbx_business_glossary_term' = 'Deficiency Codes');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `detention_end_date` SET TAGS ('dbx_business_glossary_term' = 'Detention End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `detention_flag` SET TAGS ('dbx_business_glossary_term' = 'Detention Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `detention_start_date` SET TAGS ('dbx_business_glossary_term' = 'Detention Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `document_url` SET TAGS ('dbx_business_glossary_term' = 'Certificate Document Uniform Resource Locator (URL)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `follow_up_action_description` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Description');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `follow_up_action_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Required');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `inspecting_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Inspecting Officer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `inspecting_officer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `inspection_outcome` SET TAGS ('dbx_business_glossary_term' = 'Inspection Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `inspection_outcome` SET TAGS ('dbx_value_regex' = 'no_deficiencies|deficiencies_rectified|deficiencies_outstanding|detained|banned');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `inspection_port` SET TAGS ('dbx_business_glossary_term' = 'Inspection Port');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `inspection_port_code` SET TAGS ('dbx_business_glossary_term' = 'Inspection Port Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `inspection_report_url` SET TAGS ('dbx_business_glossary_term' = 'Inspection Report Uniform Resource Locator (URL)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `inspection_type` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Inspection Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `inspection_type` SET TAGS ('dbx_value_regex' = 'initial|more_detailed|expanded|concentrated_inspection_campaign');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `intermediate_survey_due_date` SET TAGS ('dbx_business_glossary_term' = 'Intermediate Survey Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `issuing_authority_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `last_survey_date` SET TAGS ('dbx_business_glossary_term' = 'Last Survey Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `last_survey_type` SET TAGS ('dbx_business_glossary_term' = 'Last Survey Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `last_survey_type` SET TAGS ('dbx_value_regex' = 'annual|intermediate|renewal|special|damage');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `psc_authority` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `psc_authority_code` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Authority Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `psc_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `record_type` SET TAGS ('dbx_business_glossary_term' = 'Record Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `record_type` SET TAGS ('dbx_value_regex' = 'certificate|psc_inspection');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `rectification_deadline` SET TAGS ('dbx_business_glossary_term' = 'Rectification Deadline');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `renewal_survey_due_date` SET TAGS ('dbx_business_glossary_term' = 'Renewal Survey Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `ship_risk_profile` SET TAGS ('dbx_business_glossary_term' = 'Ship Risk Profile');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `ship_risk_profile` SET TAGS ('dbx_value_regex' = 'low_risk_ship|standard_risk_ship|high_risk_ship');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `total_deficiencies` SET TAGS ('dbx_business_glossary_term' = 'Total Deficiencies');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` SET TAGS ('dbx_subdomain' = 'compliance_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `psc_inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Psc Inspection Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `violation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Violation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Coordinator Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `areas_inspected` SET TAGS ('dbx_business_glossary_term' = 'Areas Inspected');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `certificates_checked` SET TAGS ('dbx_business_glossary_term' = 'Certificates Checked');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `clear_grounds_observed` SET TAGS ('dbx_business_glossary_term' = 'Clear Grounds Observed');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `conventions_checked` SET TAGS ('dbx_business_glossary_term' = 'Conventions Checked');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `crew_interviewed_count` SET TAGS ('dbx_business_glossary_term' = 'Crew Interviewed Count');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `detention_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Detention Duration Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `detention_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Detention End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `detention_flag` SET TAGS ('dbx_business_glossary_term' = 'Detention Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `detention_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Detention Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `flag_state_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Flag State Notification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `flag_state_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Flag State Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `follow_up_port` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Port');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `follow_up_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Inspection Cost United States Dollars (USD)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_cost_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_end_time` SET TAGS ('dbx_business_glossary_term' = 'Inspection End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_outcome` SET TAGS ('dbx_business_glossary_term' = 'Inspection Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_outcome` SET TAGS ('dbx_value_regex' = 'no_deficiencies|deficiencies_rectified_before_departure|deficiencies_rectified_within_14_days|deficiencies_rectified_at_next_port|detained|sailed_with_outstanding_deficiencies');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_reason` SET TAGS ('dbx_business_glossary_term' = 'Inspection Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_regime` SET TAGS ('dbx_business_glossary_term' = 'Inspection Regime');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_remarks` SET TAGS ('dbx_business_glossary_term' = 'Inspection Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_start_time` SET TAGS ('dbx_business_glossary_term' = 'Inspection Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `inspection_type` SET TAGS ('dbx_value_regex' = 'initial|more_detailed|expanded|concentrated_inspection_campaign|follow_up');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `isps_security_level_at_inspection` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Level at Inspection');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `isps_security_level_at_inspection` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `lead_inspector_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Lead Inspector Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `lead_inspector_certificate_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `lead_inspector_name` SET TAGS ('dbx_business_glossary_term' = 'Lead Inspector Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `lead_inspector_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `master_notified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Master Notified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `port_state_control_report_issued_date` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Report Issued Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `psc_authority_code` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Authority Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `psc_authority_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `psc_authority_name` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Authority Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `recognized_organization_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Recognized Organization (RO) Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `record_created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `record_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `rectification_deadline_date` SET TAGS ('dbx_business_glossary_term' = 'Rectification Deadline Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `ship_risk_profile` SET TAGS ('dbx_business_glossary_term' = 'Ship Risk Profile');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `ship_risk_profile` SET TAGS ('dbx_value_regex' = 'high_risk_ship|standard_risk_ship|low_risk_ship|unknown');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `total_deficiencies_found` SET TAGS ('dbx_business_glossary_term' = 'Total Deficiencies Found');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` SET TAGS ('dbx_subdomain' = 'agency_disbursement');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `agent_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Agent Appointment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agency Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Appointing Officer Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `contractor_safety_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Safety Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Agent Company ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `agency_type` SET TAGS ('dbx_business_glossary_term' = 'Agency Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `agency_type` SET TAGS ('dbx_value_regex' = 'general_agent|husbanding_agent|cargo_agent|protective_agent|liner_agent|port_agent');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `appointment_agreement_reference` SET TAGS ('dbx_business_glossary_term' = 'Appointment Agreement Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `appointment_end_date` SET TAGS ('dbx_business_glossary_term' = 'Appointment End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `appointment_reason` SET TAGS ('dbx_business_glossary_term' = 'Appointment Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `appointment_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Appointment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `appointment_scope` SET TAGS ('dbx_business_glossary_term' = 'Appointment Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `appointment_scope` SET TAGS ('dbx_value_regex' = 'single_call|voyage_series|annual_contract|indefinite');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `appointment_start_date` SET TAGS ('dbx_business_glossary_term' = 'Appointment Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `appointment_status` SET TAGS ('dbx_business_glossary_term' = 'Appointment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `appointment_status` SET TAGS ('dbx_value_regex' = 'pending|active|suspended|terminated|expired');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `billing_address_routing` SET TAGS ('dbx_business_glossary_term' = 'Billing Address Routing');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `billing_address_routing` SET TAGS ('dbx_value_regex' = 'agent|owner|operator|charterer');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `billing_address_routing` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `billing_address_routing` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `commission_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Commission Rate Percent');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `commission_rate_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `customs_clearance_authority` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `disbursement_account_reference` SET TAGS ('dbx_business_glossary_term' = 'Disbursement Account (D/A) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `document_submission_authority` SET TAGS ('dbx_business_glossary_term' = 'Document Submission Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `edi_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Enabled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `edi_participant_code` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Participant Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `financial_authority_flag` SET TAGS ('dbx_business_glossary_term' = 'Financial Authority Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `isps_security_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `isps_security_clearance_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|denied|expired');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Performance Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `performance_rating` SET TAGS ('dbx_value_regex' = 'excellent|good|satisfactory|poor|not_rated');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `port_facility_access_permit_number` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Access Permit Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `proforma_disbursement_account_required` SET TAGS ('dbx_business_glossary_term' = 'Proforma Disbursement Account (PDA) Required');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `record_created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `record_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `service_fee_structure` SET TAGS ('dbx_business_glossary_term' = 'Service Fee Structure');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `service_fee_structure` SET TAGS ('dbx_value_regex' = 'fixed_per_call|percentage_commission|time_and_materials|hybrid');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `service_fee_structure` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `termination_notice_date` SET TAGS ('dbx_business_glossary_term' = 'Termination Notice Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Termination Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `call_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Call Schedule Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `alliance_designation` SET TAGS ('dbx_business_glossary_term' = 'Alliance Designation');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `average_vessel_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Average Vessel Capacity Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `berth_preference` SET TAGS ('dbx_business_glossary_term' = 'Berth Preference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `commercial_agreement_reference` SET TAGS ('dbx_business_glossary_term' = 'Commercial Agreement Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `forecast_cargo_volume_teu` SET TAGS ('dbx_business_glossary_term' = 'Forecast Cargo Volume Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `forecast_discharge_teu` SET TAGS ('dbx_business_glossary_term' = 'Forecast Discharge Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `forecast_load_teu` SET TAGS ('dbx_business_glossary_term' = 'Forecast Load Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `forecast_restow_teu` SET TAGS ('dbx_business_glossary_term' = 'Forecast Restow Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `next_port_code` SET TAGS ('dbx_business_glossary_term' = 'Next Port Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `next_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `omission_reason` SET TAGS ('dbx_business_glossary_term' = 'Omission Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `operating_shipping_line` SET TAGS ('dbx_business_glossary_term' = 'Operating Shipping Line');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `planned_berth_window_hours` SET TAGS ('dbx_business_glossary_term' = 'Planned Berth Window Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `planned_eta` SET TAGS ('dbx_business_glossary_term' = 'Planned Estimated Time of Arrival (ETA)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `planned_etb` SET TAGS ('dbx_business_glossary_term' = 'Planned Estimated Time of Berthing (ETB)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `planned_etd` SET TAGS ('dbx_business_glossary_term' = 'Planned Estimated Time of Departure (ETD)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `port_of_call_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Call Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `port_of_call_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `previous_port_code` SET TAGS ('dbx_business_glossary_term' = 'Previous Port Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `previous_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'standard|priority|express|emergency');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `record_created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `record_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `rotation_port_count` SET TAGS ('dbx_business_glossary_term' = 'Rotation Port Count');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `rotation_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Rotation Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `schedule_effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Schedule Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `schedule_effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Schedule Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `schedule_published_date` SET TAGS ('dbx_business_glossary_term' = 'Schedule Published Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `schedule_received_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Schedule Received Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `schedule_source` SET TAGS ('dbx_business_glossary_term' = 'Schedule Source');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `schedule_source` SET TAGS ('dbx_value_regex' = 'shipping_line_edi|agent_submission|vts_pre_notification|port_community_system|manual_entry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `schedule_status` SET TAGS ('dbx_business_glossary_term' = 'Schedule Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `schedule_status` SET TAGS ('dbx_value_regex' = 'provisional|confirmed|amended|cancelled|omitted');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `schedule_version` SET TAGS ('dbx_business_glossary_term' = 'Schedule Version');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `schedule_version` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-V[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `service_code` SET TAGS ('dbx_business_glossary_term' = 'Service Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `service_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `service_frequency` SET TAGS ('dbx_business_glossary_term' = 'Service Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `service_frequency` SET TAGS ('dbx_value_regex' = 'weekly|bi-weekly|fortnightly|monthly|ad-hoc');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `service_name` SET TAGS ('dbx_business_glossary_term' = 'Service Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `service_status` SET TAGS ('dbx_business_glossary_term' = 'Service Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `service_status` SET TAGS ('dbx_value_regex' = 'active|suspended|discontinued|seasonal');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'mainline|feeder|regional|shuttle|inducement');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `terminal_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `vessel_string_size` SET TAGS ('dbx_business_glossary_term' = 'Vessel String Size');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `voyage_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` SET TAGS ('dbx_subdomain' = 'crew_surveys');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `draft_survey_id` SET TAGS ('dbx_business_glossary_term' = 'Draft Survey Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Wharfage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `aft_draft_port_meters` SET TAGS ('dbx_business_glossary_term' = 'Aft Draft Port Side (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `aft_draft_starboard_meters` SET TAGS ('dbx_business_glossary_term' = 'Aft Draft Starboard Side (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `ballast_water_mt` SET TAGS ('dbx_business_glossary_term' = 'Ballast Water (Metric Tons - MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `bol_reference` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `bunker_fuel_mt` SET TAGS ('dbx_business_glossary_term' = 'Bunker Fuel (Metric Tons - MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `calculated_cargo_weight_mt` SET TAGS ('dbx_business_glossary_term' = 'Calculated Cargo Weight (Metric Tons - MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `certificate_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `certificate_issued_flag` SET TAGS ('dbx_business_glossary_term' = 'Certificate Issued Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `constant_mt` SET TAGS ('dbx_business_glossary_term' = 'Constant (Metric Tons - MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `displacement_mt` SET TAGS ('dbx_business_glossary_term' = 'Displacement (Metric Tons - MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `dwa_allowance_mm` SET TAGS ('dbx_business_glossary_term' = 'Dock Water Allowance (DWA) (Millimeters - mm)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `forward_draft_port_meters` SET TAGS ('dbx_business_glossary_term' = 'Forward Draft Port Side (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `forward_draft_starboard_meters` SET TAGS ('dbx_business_glossary_term' = 'Forward Draft Starboard Side (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `fresh_water_mt` SET TAGS ('dbx_business_glossary_term' = 'Fresh Water (Metric Tons - MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `fwa_allowance_mm` SET TAGS ('dbx_business_glossary_term' = 'Fresh Water Allowance (FWA) (Millimeters - mm)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `lightship_weight_mt` SET TAGS ('dbx_business_glossary_term' = 'Lightship Weight (Metric Tons - MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `list_degrees` SET TAGS ('dbx_business_glossary_term' = 'List (Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `mean_aft_draft_meters` SET TAGS ('dbx_business_glossary_term' = 'Mean Aft Draft (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `mean_draft_meters` SET TAGS ('dbx_business_glossary_term' = 'Mean Draft (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `mean_forward_draft_meters` SET TAGS ('dbx_business_glossary_term' = 'Mean Forward Draft (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `mean_midship_draft_meters` SET TAGS ('dbx_business_glossary_term' = 'Mean Midship Draft (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `midship_draft_port_meters` SET TAGS ('dbx_business_glossary_term' = 'Midship Draft Port Side (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `midship_draft_starboard_meters` SET TAGS ('dbx_business_glossary_term' = 'Midship Draft Starboard Side (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `sea_state_code` SET TAGS ('dbx_business_glossary_term' = 'Sea State Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `stores_provisions_mt` SET TAGS ('dbx_business_glossary_term' = 'Stores and Provisions (Metric Tons - MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `survey_accuracy_rating` SET TAGS ('dbx_business_glossary_term' = 'Survey Accuracy Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `survey_accuracy_rating` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `survey_datetime` SET TAGS ('dbx_business_glossary_term' = 'Survey Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `survey_purpose` SET TAGS ('dbx_business_glossary_term' = 'Survey Purpose');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `survey_purpose` SET TAGS ('dbx_value_regex' = 'cargo_weight_verification|load_line_compliance|demurrage_calculation|charter_party_requirement|customs_declaration|insurance_claim');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `survey_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Survey Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `survey_status` SET TAGS ('dbx_business_glossary_term' = 'Survey Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `survey_status` SET TAGS ('dbx_value_regex' = 'draft|completed|certified|disputed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `survey_type` SET TAGS ('dbx_business_glossary_term' = 'Survey Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `survey_type` SET TAGS ('dbx_value_regex' = 'initial|final|intermediate|pre-loading|post-discharge');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `surveyor_company_name` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Company Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `surveyor_license_number` SET TAGS ('dbx_business_glossary_term' = 'Surveyor License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `surveyor_name` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `trim_meters` SET TAGS ('dbx_business_glossary_term' = 'Trim (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `water_density_kg_per_m3` SET TAGS ('dbx_business_glossary_term' = 'Water Density (Kilograms per Cubic Meter - kg/m³)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ALTER COLUMN `weather_condition` SET TAGS ('dbx_business_glossary_term' = 'Weather Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `service_route_id` SET TAGS ('dbx_business_glossary_term' = 'Service Route Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `alliance_name` SET TAGS ('dbx_business_glossary_term' = 'Alliance Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `alliance_service_designation` SET TAGS ('dbx_business_glossary_term' = 'Alliance Service Designation');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `average_vessel_beam_meters` SET TAGS ('dbx_business_glossary_term' = 'Average Vessel Beam Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `average_vessel_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Average Vessel Capacity Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `average_vessel_draft_meters` SET TAGS ('dbx_business_glossary_term' = 'Average Vessel Draft Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `average_vessel_loa_meters` SET TAGS ('dbx_business_glossary_term' = 'Average Vessel Length Overall (LOA) Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `dangerous_cargo_percentage` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Cargo Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `edi_service_code` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Service Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `expected_container_volume_teu` SET TAGS ('dbx_business_glossary_term' = 'Expected Container Volume Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `export_volume_percentage` SET TAGS ('dbx_business_glossary_term' = 'Export Volume Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `import_volume_percentage` SET TAGS ('dbx_business_glossary_term' = 'Import Volume Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `last_call_date` SET TAGS ('dbx_business_glossary_term' = 'Last Call Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `next_scheduled_call_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Call Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `operating_shipping_line` SET TAGS ('dbx_business_glossary_term' = 'Operating Shipping Line');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `port_call_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Port Call Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `port_rotation_sequence` SET TAGS ('dbx_business_glossary_term' = 'Port Rotation Sequence');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `port_stay_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Port Stay Duration Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `record_created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `record_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `reefer_percentage` SET TAGS ('dbx_business_glossary_term' = 'Reefer Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `rotation_duration_days` SET TAGS ('dbx_business_glossary_term' = 'Rotation Duration Days');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `service_code` SET TAGS ('dbx_business_glossary_term' = 'Service Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `service_commencement_date` SET TAGS ('dbx_business_glossary_term' = 'Service Commencement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `service_frequency` SET TAGS ('dbx_business_glossary_term' = 'Service Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `service_frequency` SET TAGS ('dbx_value_regex' = 'weekly|bi-weekly|tri-weekly|fortnightly|monthly');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `service_name` SET TAGS ('dbx_business_glossary_term' = 'Service Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `service_reliability_percentage` SET TAGS ('dbx_business_glossary_term' = 'Service Reliability Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `service_status` SET TAGS ('dbx_business_glossary_term' = 'Service Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `service_status` SET TAGS ('dbx_value_regex' = 'active|suspended|discontinued|planned');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'mainline|feeder|regional|shuttle|express');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `terminal_operator` SET TAGS ('dbx_business_glossary_term' = 'Terminal Operator');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `transshipment_volume_percentage` SET TAGS ('dbx_business_glossary_term' = 'Transshipment Volume Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ALTER COLUMN `vessel_string_size` SET TAGS ('dbx_business_glossary_term' = 'Vessel String Size');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` SET TAGS ('dbx_subdomain' = 'crew_surveys');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_list_id` SET TAGS ('dbx_business_glossary_term' = 'Crew List Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Access Credential Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Nationality Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `country_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `country_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `ohs_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `visitor_log_id` SET TAGS ('dbx_business_glossary_term' = 'Visitor Log Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `contact_address` SET TAGS ('dbx_business_glossary_term' = 'Contact Address');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `contact_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `contact_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `contact_phone_number` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `contact_phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `contact_phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_change_type` SET TAGS ('dbx_business_glossary_term' = 'Crew Change Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_change_type` SET TAGS ('dbx_value_regex' = 'joining|departing|remaining|transit');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_list_status` SET TAGS ('dbx_business_glossary_term' = 'Crew List Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_list_status` SET TAGS ('dbx_value_regex' = 'active|signed_off|deceased|deserted|hospitalized|repatriated');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_member_family_name` SET TAGS ('dbx_business_glossary_term' = 'Crew Member Family Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_member_family_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_member_family_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_member_given_name` SET TAGS ('dbx_business_glossary_term' = 'Crew Member Given Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_member_given_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_member_given_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_member_middle_name` SET TAGS ('dbx_business_glossary_term' = 'Crew Member Middle Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_member_middle_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `crew_member_middle_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_business_glossary_term' = 'Date of Birth');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_dob' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `date_of_joining_vessel` SET TAGS ('dbx_business_glossary_term' = 'Date of Joining Vessel');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `expected_date_of_signing_off` SET TAGS ('dbx_business_glossary_term' = 'Expected Date of Signing Off');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `expected_port_of_signing_off` SET TAGS ('dbx_business_glossary_term' = 'Expected Port of Signing Off');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `isps_screening_timestamp` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Screening Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `isps_security_screening_status` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Screening Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `isps_security_screening_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|flagged|denied');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `medical_certificate_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Medical Fitness Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `medical_certificate_expiry_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `medical_certificate_expiry_date` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `medical_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Medical Fitness Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `medical_certificate_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `medical_certificate_number` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `next_of_kin_name` SET TAGS ('dbx_business_glossary_term' = 'Next of Kin Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `next_of_kin_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `next_of_kin_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `next_of_kin_phone_number` SET TAGS ('dbx_business_glossary_term' = 'Next of Kin Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `next_of_kin_phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `next_of_kin_phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `next_of_kin_relationship` SET TAGS ('dbx_business_glossary_term' = 'Next of Kin Relationship');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `next_of_kin_relationship` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `next_of_kin_relationship` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Passport Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_expiry_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_expiry_date` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Passport Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_issue_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_issue_date` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_issuing_country_code` SET TAGS ('dbx_business_glossary_term' = 'Passport Issuing Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_issuing_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_issuing_country_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_issuing_country_code` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_number` SET TAGS ('dbx_business_glossary_term' = 'Passport Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `passport_number` SET TAGS ('dbx_pii_passport' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `place_of_birth` SET TAGS ('dbx_business_glossary_term' = 'Place of Birth');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `place_of_birth` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `place_of_birth` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `port_health_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Port Health Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `port_health_clearance_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|quarantine_required|medical_hold');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `port_health_clearance_status` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `port_health_clearance_status` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `port_of_joining` SET TAGS ('dbx_business_glossary_term' = 'Port of Joining');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `rank_position` SET TAGS ('dbx_business_glossary_term' = 'Rank or Position');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `record_created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `record_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `seafarers_book_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Seafarers Book Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `seafarers_book_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Seafarers Book Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `seafarers_book_number` SET TAGS ('dbx_business_glossary_term' = 'Seafarers Book Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `seafarers_book_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `seafarers_book_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `shore_leave_authorized_flag` SET TAGS ('dbx_business_glossary_term' = 'Shore Leave Authorized Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `stcw_certificate_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training, Certification and Watchkeeping (STCW) Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `stcw_certificate_grade` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training, Certification and Watchkeeping (STCW) Certificate Grade');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `stcw_certificate_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training, Certification and Watchkeeping (STCW) Certificate Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `stcw_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training, Certification and Watchkeeping (STCW) Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `vaccination_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Vaccination Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `vaccination_certificate_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `vaccination_certificate_number` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `visa_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Visa Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `visa_number` SET TAGS ('dbx_business_glossary_term' = 'Visa Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `visa_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ALTER COLUMN `visa_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` SET TAGS ('dbx_subdomain' = 'compliance_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `waste_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Waste Declaration Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `marpol_record_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Marpol Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'PSC (Port State Control) Inspector ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Reception Facility ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Reception Facility Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `screening_record_id` SET TAGS ('dbx_business_glossary_term' = 'Screening Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Waste Contractor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `actual_volume_delivered_m3` SET TAGS ('dbx_business_glossary_term' = 'Actual Volume Delivered (Cubic Meters - CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Waste Discharge Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `charge_currency` SET TAGS ('dbx_business_glossary_term' = 'Charge Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `charge_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `compliance_verification_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `compliance_verification_status` SET TAGS ('dbx_value_regex' = 'pending|verified|non_compliant|under_investigation');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Waste Declaration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `declaration_number` SET TAGS ('dbx_value_regex' = '^WD-[0-9]{8}-[A-Z0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `declaration_status` SET TAGS ('dbx_business_glossary_term' = 'Declaration Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `declaration_submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Declaration Submission Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `declaration_type` SET TAGS ('dbx_business_glossary_term' = 'Declaration Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `declaration_type` SET TAGS ('dbx_value_regex' = 'pre_arrival_notification|delivery_confirmation|waiver_request|amendment');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `delivery_completion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Delivery Completion Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `disposal_facility_license_number` SET TAGS ('dbx_business_glossary_term' = 'Disposal Facility License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `disposal_facility_name` SET TAGS ('dbx_business_glossary_term' = 'Disposal Facility Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `disposal_method` SET TAGS ('dbx_business_glossary_term' = 'Disposal Method');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `disposal_method` SET TAGS ('dbx_value_regex' = 'incineration|landfill|recycling|treatment|reuse|export');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `ems_integration_status` SET TAGS ('dbx_business_glossary_term' = 'EMS (Environmental Management System) Integration Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `ems_integration_status` SET TAGS ('dbx_value_regex' = 'not_sent|sent|acknowledged|failed');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `ems_transmission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'EMS (Environmental Management System) Transmission Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `estimated_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Estimated Volume (Cubic Meters - CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `hazardous_waste_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Waste Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'IMDG (International Maritime Dangerous Goods) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `inspection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `invoice_reference` SET TAGS ('dbx_business_glossary_term' = 'Invoice Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `marpol_annex` SET TAGS ('dbx_business_glossary_term' = 'MARPOL (Marine Pollution Convention) Annex');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `marpol_annex` SET TAGS ('dbx_value_regex' = 'annex_I|annex_II|annex_IV|annex_V|annex_VI');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `next_port_of_call` SET TAGS ('dbx_business_glossary_term' = 'Next Port of Call (UN/LOCODE)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `next_port_of_call` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `penalty_amount` SET TAGS ('dbx_business_glossary_term' = 'Penalty Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `penalty_currency` SET TAGS ('dbx_business_glossary_term' = 'Penalty Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `penalty_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `psc_inspection_flag` SET TAGS ('dbx_business_glossary_term' = 'PSC (Port State Control) Inspection Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `record_created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `record_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By User');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `scheduled_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'UN (United Nations) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'cubic_meters|liters|kilograms|tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `violation_description` SET TAGS ('dbx_business_glossary_term' = 'Violation Description');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `violation_detected_flag` SET TAGS ('dbx_business_glossary_term' = 'Violation Detected Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `waiver_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Waiver Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `waiver_granted_flag` SET TAGS ('dbx_business_glossary_term' = 'Waiver Granted Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `waiver_reason` SET TAGS ('dbx_business_glossary_term' = 'Waiver Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `waste_contractor_reference` SET TAGS ('dbx_business_glossary_term' = 'Waste Contractor Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `waste_description` SET TAGS ('dbx_business_glossary_term' = 'Waste Description');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `waste_receipt_number` SET TAGS ('dbx_business_glossary_term' = 'Waste Receipt Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `waste_receipt_number` SET TAGS ('dbx_value_regex' = '^WR-[0-9]{8}-[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `waste_type_code` SET TAGS ('dbx_business_glossary_term' = 'Waste Type Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ALTER COLUMN `waste_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` SET TAGS ('dbx_subdomain' = 'compliance_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `isps_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Record Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Inspection Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Security Officer Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `additional_security_measures_applied` SET TAGS ('dbx_business_glossary_term' = 'Additional Security Measures Applied');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `compliance_verification_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Compliance Verification Officer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `compliance_verification_officer_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `compliance_verification_officer_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `compliance_verification_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `compliance_verification_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending_verification|conditional_approval|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `compliance_verification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Compliance Verification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `control_measures_imposed` SET TAGS ('dbx_business_glossary_term' = 'Control Measures Imposed');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `declaration_of_security_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Declaration of Security (DoS) Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `declaration_of_security_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Declaration of Security (DoS) Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `declaration_of_security_signed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Declaration of Security (DoS) Signed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `deficiency_description` SET TAGS ('dbx_business_glossary_term' = 'Deficiency Description');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `deficiency_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `deficiency_identified_flag` SET TAGS ('dbx_business_glossary_term' = 'Deficiency Identified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `issc_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'International Ship Security Certificate (ISSC) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `issc_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'International Ship Security Certificate (ISSC) Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `issc_issue_date` SET TAGS ('dbx_business_glossary_term' = 'International Ship Security Certificate (ISSC) Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `issc_issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'International Ship Security Certificate (ISSC) Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `last_ten_ports_of_call` SET TAGS ('dbx_business_glossary_term' = 'Last Ten Ports of Call');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `last_ten_ports_security_levels` SET TAGS ('dbx_business_glossary_term' = 'Last Ten Ports Security Levels');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `port_facility_security_level` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `port_facility_security_officer_contact` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Contact');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `port_facility_security_officer_contact` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `port_facility_security_officer_contact` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `port_facility_security_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `port_facility_security_officer_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `port_facility_security_officer_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `pre_arrival_security_information_submitted_flag` SET TAGS ('dbx_business_glossary_term' = 'Pre-Arrival Security Information Submitted Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `pre_arrival_security_information_submitted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Pre-Arrival Security Information Submitted Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `record_created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `record_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `security_incident_description` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Description');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `security_incident_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `security_incident_flag` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `security_incident_reported_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Reported Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `security_measures_in_place` SET TAGS ('dbx_business_glossary_term' = 'Security Measures in Place');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `ship_security_level` SET TAGS ('dbx_business_glossary_term' = 'Ship Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `ship_security_officer_contact` SET TAGS ('dbx_business_glossary_term' = 'Ship Security Officer (SSO) Contact');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `ship_security_officer_contact` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `ship_security_officer_contact` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `ship_security_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Ship Security Officer (SSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `ship_security_officer_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `ship_security_officer_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `ship_to_ship_activity_description` SET TAGS ('dbx_business_glossary_term' = 'Ship-to-Ship Activity Description');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ALTER COLUMN `ship_to_ship_activity_flag` SET TAGS ('dbx_business_glossary_term' = 'Ship-to-Ship Activity Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` SET TAGS ('dbx_subdomain' = 'crew_surveys');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `bunker_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Bunker Operation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `amended_bunker_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Amended Bunker Operation Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `amended_bunker_operation_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `anchorage_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `bunker_adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Bunker Adjustment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Bunker Supply Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `ohs_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operations Supervisor Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Bunker Barge ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Bunker Supplier ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `bdn_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Bunker Delivery Note (BDN) Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `bdn_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,30}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `bunker_barge_imo_number` SET TAGS ('dbx_business_glossary_term' = 'Bunker Barge IMO Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `bunker_barge_imo_number` SET TAGS ('dbx_value_regex' = '^[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `bunker_supplier_name` SET TAGS ('dbx_business_glossary_term' = 'Bunker Supplier Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `chief_engineer_name` SET TAGS ('dbx_business_glossary_term' = 'Chief Engineer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `delivery_location_type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `delivery_location_type` SET TAGS ('dbx_value_regex' = 'berth|anchorage|offshore|terminal');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Delivery Method');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `delivery_method` SET TAGS ('dbx_value_regex' = 'barge|pipeline|truck|ship_to_ship');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `density_at_15c_kg_per_m3` SET TAGS ('dbx_business_glossary_term' = 'Density at 15°C (kg/m³)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `flash_point_celsius` SET TAGS ('dbx_business_glossary_term' = 'Flash Point (°C)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `fuel_grade` SET TAGS ('dbx_business_glossary_term' = 'Fuel Grade');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `fuel_sample_seal_number` SET TAGS ('dbx_business_glossary_term' = 'Fuel Sample Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `fuel_sample_taken_flag` SET TAGS ('dbx_business_glossary_term' = 'Fuel Sample Taken Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `fuel_type` SET TAGS ('dbx_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_business_glossary_term' = 'ISPS Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `operation_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Operation Duration (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `operation_status` SET TAGS ('dbx_business_glossary_term' = 'Bunker Operation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `operation_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|suspended|cancelled|aborted');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `port_service_charge` SET TAGS ('dbx_business_glossary_term' = 'Port Service Charge');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `quality_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Quality Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `quantity_delivered_mt` SET TAGS ('dbx_business_glossary_term' = 'Quantity Delivered (MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `quantity_ordered_mt` SET TAGS ('dbx_business_glossary_term' = 'Quantity Ordered (MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `receiving_tank_name` SET TAGS ('dbx_business_glossary_term' = 'Receiving Tank Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `safety_checklist_completed_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Checklist Completed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `safety_checklist_reference` SET TAGS ('dbx_business_glossary_term' = 'Safety Checklist Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `scheduled_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `sea_state_code` SET TAGS ('dbx_business_glossary_term' = 'Sea State Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `sea_state_code` SET TAGS ('dbx_value_regex' = '^[0-9]$');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `sulphur_content_percent` SET TAGS ('dbx_business_glossary_term' = 'Sulphur Content Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `supplier_representative_name` SET TAGS ('dbx_business_glossary_term' = 'Supplier Representative Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `tank_after_sounding_meters` SET TAGS ('dbx_business_glossary_term' = 'Tank After Sounding (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `tank_before_sounding_meters` SET TAGS ('dbx_business_glossary_term' = 'Tank Before Sounding (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `total_fuel_cost` SET TAGS ('dbx_business_glossary_term' = 'Total Fuel Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `total_fuel_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `unit_price_per_mt` SET TAGS ('dbx_business_glossary_term' = 'Unit Price per Metric Tonne');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `unit_price_per_mt` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `viscosity_cst` SET TAGS ('dbx_business_glossary_term' = 'Viscosity (cSt)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `vts_clearance_number` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Clearance Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `weather_condition` SET TAGS ('dbx_business_glossary_term' = 'Weather Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ALTER COLUMN `wind_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Wind Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` SET TAGS ('dbx_association_edges' = 'vessel.call,workforce.gang');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `deployment_id` SET TAGS ('dbx_business_glossary_term' = 'Deployment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Deployment - Port Call Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Deployment - Workforce Stevedore Gang Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `actual_finish_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Finish Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `actual_start_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `deployment_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Deployment Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `gang_size_actual` SET TAGS ('dbx_business_glossary_term' = 'Actual Gang Size');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `gross_hours_worked` SET TAGS ('dbx_business_glossary_term' = 'Gross Hours Worked');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `hatch_number` SET TAGS ('dbx_business_glossary_term' = 'Hatch Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `moves_completed` SET TAGS ('dbx_business_glossary_term' = 'Moves Completed');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `moves_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Moves Per Hour');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `operation_type` SET TAGS ('dbx_business_glossary_term' = 'Operation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `scheduled_start_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `stoppage_hours` SET TAGS ('dbx_business_glossary_term' = 'Stoppage Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ALTER COLUMN `teu_handled` SET TAGS ('dbx_business_glossary_term' = 'TEU Handled');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` SET TAGS ('dbx_association_edges' = 'vessel.vessel,customer.port_community_participant');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `agency_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Agency Appointment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Agency Appointment - Port Community Participant Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Agency Appointment - Vessel Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `agency_type` SET TAGS ('dbx_business_glossary_term' = 'Agency Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `appointing_party_imo_company_number` SET TAGS ('dbx_business_glossary_term' = 'Appointing Party IMO Company Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `appointing_party_name` SET TAGS ('dbx_business_glossary_term' = 'Appointing Party Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `appointment_created_by` SET TAGS ('dbx_business_glossary_term' = 'Appointment Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `appointment_created_date` SET TAGS ('dbx_business_glossary_term' = 'Appointment Created Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `appointment_end_date` SET TAGS ('dbx_business_glossary_term' = 'Appointment End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `appointment_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Appointment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `appointment_scope` SET TAGS ('dbx_business_glossary_term' = 'Appointment Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `appointment_start_date` SET TAGS ('dbx_business_glossary_term' = 'Appointment Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `appointment_status` SET TAGS ('dbx_business_glossary_term' = 'Appointment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `authority_level` SET TAGS ('dbx_business_glossary_term' = 'Authority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `commission_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Commission Rate Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `commission_rate_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `financial_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Financial Limit Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `financial_limit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `financial_limit_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Financial Limit Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `port_of_appointment` SET TAGS ('dbx_business_glossary_term' = 'Port of Appointment');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `service_fee_structure` SET TAGS ('dbx_business_glossary_term' = 'Service Fee Structure');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `service_fee_structure` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Termination Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` SET TAGS ('dbx_subdomain' = 'agency_disbursement');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` SET TAGS ('dbx_association_edges' = 'vessel.vessel,procurement.vendor');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ALTER COLUMN `service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Service Agreement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Service Agreement - Vendor Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Service Agreement - Vessel Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Vendor Performance Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ALTER COLUMN `preferred_vendor_flag` SET TAGS ('dbx_business_glossary_term' = 'Preferred Vendor Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` SET TAGS ('dbx_association_edges' = 'vessel.vessel,masterdata.shipping_line');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `charter_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Charter Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Charter - Shipping Line Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Charter - Vessel Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `bareboat_charter_flag` SET TAGS ('dbx_business_glossary_term' = 'Bareboat Charter Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `charter_type` SET TAGS ('dbx_business_glossary_term' = 'Charter Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `commercial_operator_flag` SET TAGS ('dbx_business_glossary_term' = 'Commercial Operator Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `commercial_operator_imo_company_number` SET TAGS ('dbx_business_glossary_term' = 'Commercial Operator IMO Company Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `commercial_operator_name` SET TAGS ('dbx_business_glossary_term' = 'Commercial Operator (Disponent Owner) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `commercial_operator_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `commercial_operator_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Charter Termination Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Charter Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `party_reference` SET TAGS ('dbx_business_glossary_term' = 'Charter Party Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Charter Commencement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `technical_manager_flag` SET TAGS ('dbx_business_glossary_term' = 'Technical Manager Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` SET TAGS ('dbx_association_edges' = 'vessel.vessel,masterdata.port_location');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `port_call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `infrastructure_berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Assignment');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call - Port Location Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call - Vessel Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `access_restriction_flag` SET TAGS ('dbx_business_glossary_term' = 'Access Restriction Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `arrival_datetime` SET TAGS ('dbx_business_glossary_term' = 'Arrival Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `call_performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Call Performance Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `call_purpose` SET TAGS ('dbx_business_glossary_term' = 'Call Purpose');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `call_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Call Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `call_status` SET TAGS ('dbx_business_glossary_term' = 'Call Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `cargo_volume_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Cargo Volume');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `container_moves_count` SET TAGS ('dbx_business_glossary_term' = 'Container Moves Count');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `created_datetime` SET TAGS ('dbx_business_glossary_term' = 'Record Created Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `departure_datetime` SET TAGS ('dbx_business_glossary_term' = 'Departure Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `last_updated_datetime` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `port_stay_hours` SET TAGS ('dbx_business_glossary_term' = 'Port Stay Duration');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `preferred_location_flag` SET TAGS ('dbx_business_glossary_term' = 'Preferred Location Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `psc_deficiency_count` SET TAGS ('dbx_business_glossary_term' = 'PSC Deficiency Count');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `psc_inspection_flag` SET TAGS ('dbx_business_glossary_term' = 'PSC Inspection Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `restriction_reason` SET TAGS ('dbx_business_glossary_term' = 'Restriction Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `restriction_reason` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `total_port_charges_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Port Charges');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` SET TAGS ('dbx_association_edges' = 'vessel.call,workforce.employee');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `call_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Call Assignment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Call Assignment - Employee Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Call Assignment - Port Call Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `assignment_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Assignment End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `assignment_role` SET TAGS ('dbx_business_glossary_term' = 'Assignment Role');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `assignment_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Assignment Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Assignment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Assignment Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Assignment Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `responsibility_area` SET TAGS ('dbx_business_glossary_term' = 'Responsibility Area');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ALTER COLUMN `shift_type` SET TAGS ('dbx_business_glossary_term' = 'Shift Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` SET TAGS ('dbx_association_edges' = 'vessel.call,intermodal.icd_facility');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` ALTER COLUMN `call_icd_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Call ICD Allocation Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'ICD Facility Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Call Icd Allocation - Port Call Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` ALTER COLUMN `cargo_volume_teu` SET TAGS ('dbx_business_glossary_term' = 'Cargo Volume TEU');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` ALTER COLUMN `primary_cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Primary Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` ALTER COLUMN `service_level_agreement` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` SET TAGS ('dbx_subdomain' = 'crew_surveys');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` SET TAGS ('dbx_association_edges' = 'vessel.call,safety.safety_inspection');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `call_inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Call Inspection Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `call_safety_inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Inspection Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Call Inspection - Safety Inspection Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Call Inspection - Port Call Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `clearance_granted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Departure Clearance Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `deficiencies_found` SET TAGS ('dbx_business_glossary_term' = 'Deficiency Count');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `detention_flag` SET TAGS ('dbx_business_glossary_term' = 'Vessel Detention Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `follow_up_due_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Follow-up Action Deadline');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `follow_up_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-up Action Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `inspection_notes` SET TAGS ('dbx_business_glossary_term' = 'Call-Specific Inspection Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `inspection_outcome` SET TAGS ('dbx_business_glossary_term' = 'Inspection Outcome Status');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `inspection_scope` SET TAGS ('dbx_business_glossary_term' = 'Inspection Scope for Call');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ALTER COLUMN `inspection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Event Timestamp');
