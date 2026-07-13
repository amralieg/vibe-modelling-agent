-- Schema for Domain: vessel | Business: Shipping_Ports | Version: v2_mvm
-- Generated on: 2026-07-13 10:24:19

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`vessel` COMMENT 'Manages vessel traffic, scheduling, berthing operations, and marine movements including VTS coordination, anchorage management, ETA/ETB/ATA/ATD tracking, and vessel documentation. Covers vessel profiles (LOA, DWT, GRT, NRT, IMO number), port calls, berth allocation planning, voyage planning, and stowage plans. SSOT for all vessel-related operational data.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` (
    `vessel_id` BIGINT COMMENT 'Unique system identifier for the vessel record. Primary key for the vessel master registry.',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: Flag state determines PSC targeting factor, MOU inspection regime, SOLAS/MARPOL compliance framework, and port state control risk assessment. Required for inspection prioritization, deficiency trackin',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: PSC risk profiling, sanctions screening, and flag state performance analysis all require normalized shipyard country reference. Port state control authorities use shipyard country in vessel risk scori',
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
    `discount_scheme_id` BIGINT COMMENT 'Foreign key linking to tariff.discount_scheme. Business justification: Vessel owners negotiate port charge discount schemes (volume-based, loyalty, environmental incentive) that apply across all their vessels calls. Linking owner to discount_scheme enables automatic dis',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Vessel owners are port community participants when they hold billing accounts, sign service agreements, maintain credit facilities, or undergo ISPS accreditation. Port commercial operations require li',
    `receivable_account_id` BIGINT COMMENT 'Foreign key linking to billing.receivable_account. Business justification: Vessel owners maintain credit accounts with port authorities for recurring charges (port dues, agency fees, disbursements). Essential for credit limit enforcement, payment terms management, dunning pr',
    `sanctions_screening_id` BIGINT COMMENT 'Foreign key linking to compliance.sanctions_screening. Business justification: Ship owners and beneficial owners must be screened against sanctions lists as part of KYC/AML compliance before vessel calls are approved. owner holds denormalized sanctions_screening_date and sanctio',
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
    `tax_identification_number` STRING COMMENT 'The tax identification number or VAT registration number of the owning or managing company in their country of domicile. Required for invoicing and tax compliance.',
    CONSTRAINT pk_owner PRIMARY KEY(`owner_id`)
) COMMENT 'Master record of vessel ownership and management entities. Captures registered owner, technical manager, commercial operator (disponent owner), ISM company, and ship manager details including company name, IMO company number, country of domicile, contact details, and management role type. Tracks ownership changes and management transfers over time. Supports ISPS compliance (CSO identification), PSC inspection records, commercial billing relationships, and sanctions screening. Distinct from the customer domain which tracks port community participants as commercial clients — this product captures the vessels corporate hierarchy as declared in IMO records.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`call` (
    `call_id` BIGINT COMMENT 'Primary key for call',
    `anchorage_area_id` BIGINT COMMENT 'Reference to the anchorage area where the vessel waited before berthing. Null if vessel proceeded directly to berth.',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Every port call incurs charges (port dues, wharfage, pilotage) defined in the applicable port tariff schedule. This is the foundational commercial relationship - port calls generate revenue via tariff',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Commercial vessel calls under service contracts with shipping lines use negotiated rate cards instead of published tariffs. Volume commitment customers operate under contracted pricing. Essential for ',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: VTS reporting and pilotage planning require tracking which navigational channel a vessel used for port entry/departure. Channel constraints (max draft, LOA, beam) must be validated against the vessel',
    `berth_id` BIGINT COMMENT 'Reference to the berth allocated for this port call. Links to berth master data containing location and specifications.',
    `contact_person_id` BIGINT COMMENT 'Reference to the primary contact person at the agent company responsible for coordinating this port call.',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Every vessel call at an ISPS-regulated port facility requires a Declaration of Security (DoS) between ship and facility. Linking the call to the specific ISPS facility record enables verification that',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Port calls execute services under terminal operating agreements (TOAs), concession agreements, or service contracts. Billing, SLA measurement, and dispute resolution all require linking calls to gover',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the shipping agent company appointed to represent the vessel and coordinate port operations for this call.',
    `port_dues_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.port_dues_schedule. Business justification: Port dues are assessed at the call level — the specific port entry event triggers dues under a schedule determined by vessel type, GRT band, and flag state. Agents use this FK to generate proforma dis',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Port calls generate operational costs (VTS, pilotage, marine coordination) that must be allocated to specific cost centres for activity-based costing and operational expense tracking. Essential for ma',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Port call billing, berth allocation priority, and EDI messaging all require shipping line identity at the call level. Unscheduled calls may exist without a voyage record, making voyage-level shipping_',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.sla_profile. Business justification: Port call performance (berth productivity, turnaround time) is measured against SLA commitments. The SLA profile governs penalty calculations and performance reporting for each call. Port operations t',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Terminal zone allocation precedes berth assignment in port planning workflows. A call is assigned to a terminal zone (container, bulk, RoRo) before a specific berth is confirmed. Terminal operators us',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel making this port call. Links to vessel master data containing vessel profile information (LOA, DWT, GRT, NRT, IMO number).',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: A port call belongs to a specific voyage — this is the fundamental parent-child relationship between a vessel visit (call) and its commercial/operational journey (voyage). The call table currently car',
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
    `vts_clearance_reference` STRING COMMENT 'Reference number issued by VTS granting clearance for vessel movement within port waters. Required for compliance with ISPS and port regulations.',
    CONSTRAINT pk_call PRIMARY KEY(`call_id`)
) COMMENT 'Core transactional record representing a single vessel visit to the port, from pre-arrival notification through departure. Captures: voyage number, POL, POD, ETA/ETB/ETD, ATA/ATB/ATD, call purpose (loading, discharge, bunkering, transit, lay-up, crew change), cargo type, total TEU/FEU declared, call status, VTS clearance reference. Agent appointment attributes: appointed agent company, agency type (general, husbanding, cargo, protective), appointment scope (single call, voyage series, annual), appointment dates, primary contact, and appointment status. Milestone timestamps: pilot boarded, first line, all fast, gangway down, cargo ops start/end, last line, pilot off. The primary operational anchor entity linking vessel movements to berth allocation, cargo operations, pilotage, towage, and billing. Supports SLA measurement, port call performance reporting (UNCTAD indicators), and agent coordination for document submission authority and billing address routing.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` (
    `voyage_id` BIGINT COMMENT 'Unique identifier for the voyage record. Primary key for the voyage entity.',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Service-level commercial agreements link entire voyages to negotiated rate cards. Shipping line services (identified by service_code, shipping_line_id) operate under contracted pricing for the rotatio',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Voyages operate under service contracts with shipping lines defining berth allocation, service windows, and commercial terms. Required for rate application, volume commitment tracking, and SLA measure',
    `port_dues_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.port_dues_schedule. Business justification: Port dues (conservancy, light, tonnage dues) are assessed per voyage based on vessel GRT/NRT/LOA and flag state. The applicable port_dues_schedule must be recorded on the voyage for dues billing, prof',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Voyage coordinators manage service schedules, berth planning, and cargo forecasting for shipping line services. Critical for operational planning, customer service accountability, and productivity ana',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` (
    `movement_id` BIGINT COMMENT 'Primary key for movement',
    `anchorage_area_id` BIGINT COMMENT 'add column anchorage_area_id (BIGINT) with FK to infrastructure.anchorage_area.anchorage_area_id - vessel movements include anchorage-to-berth transits',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: VTS channel traffic management requires each inbound/outbound vessel movement to reference the specific navigational channel being transited. Under-keel clearance compliance checks and channel capacit',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: VTS dangerous cargo movement tracking and port hazmat reporting require normalized IMDG class reference. Vessel movements carrying dangerous goods must be linked to the IMDG classification for emergen',
    `berth_id` BIGINT COMMENT 'add column infrastructure_berth_id (BIGINT) with FK to infrastructure.berth.berth_id - vessel movements are to/from berths and must reference origin and destination berth',
    `pilot_id` BIGINT COMMENT 'Reference to the marine pilot assigned to guide the vessel during this movement. Null if no pilot was required or assigned.',
    `pilotage_assignment_id` BIGINT COMMENT 'Foreign key linking to marine.pilotage_assignment. Business justification: Regulatory audit trail for incident investigation and PSC compliance: SOLAS and port state control require that each vessel movement under pilotage be directly traceable to the active pilotage assignm',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Vessel movement records (berthing, shifting, unmooring) engage specific port assets (fenders, bollards, mooring equipment). Linking movement to port_asset enables asset utilization reporting, wear-and',
    `call_id` BIGINT COMMENT 'Reference to the parent port call under which this movement occurs. Links the movement to the vessels overall visit.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Vessel movements generate costs (pilotage, VTS coordination, tug operations oversight) allocated to marine services cost centres. Essential for activity-based costing of vessel traffic management, pil',
    `towage_order_id` BIGINT COMMENT 'Foreign key linking to marine.towage_order. Business justification: Operational reconciliation of tug-assisted movements: movement records carry tug_assistance_flag and number_of_tugs, indicating tug context exists but is denormalized. Linking to the active towage_ord',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` (
    `certificate_id` BIGINT COMMENT 'Primary key for certificate',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Vessel certificates (ISM DOC, ISPS, class certificates) undergo periodic compliance audits by classification societies, flag states, and certification bodies. Audit records must reference the certific',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: Statutory certificates (SOLAS, MARPOL, ISM, ISPS) are issued by flag state authorities. PSC inspection certificate validity checks and MOU performance reporting require knowing the issuing flag state.',
    `pilotage_assignment_id` BIGINT COMMENT 'Foreign key linking to marine.incident. Business justification: Certificate deficiencies, expirations, or suspensions discovered during operations (e.g., expired ISSC during ISPS check, invalid class certificate during cargo ops) trigger safety incidents requiring',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Port operations staff verify vessel certificates (ISSC, class certificates, MARPOL) during clearance and PSC inspections. Required for port state control workflows, detention risk assessment, and regu',
    `psc_inspection_id` BIGINT COMMENT 'Unique identifier assigned by the PSC authority for the inspection event. Applicable when record_type is psc_inspection.',
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
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: PSC inspections legally require flag state notification (flag_state_notification_date, flag_state_notified_flag already exist on psc_inspection). MOU performance statistics and flag state risk ratings',
    `call_id` BIGINT COMMENT 'Reference to the specific port call during which this PSC inspection was conducted.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: PSC inspections incur costs (inspector time, administrative support, coordination) allocated to regulatory compliance cost centres. Required for compliance cost tracking, regulatory service costing, a',
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
    `contact_person_id` BIGINT COMMENT 'Foreign key linking to customer.contact_person. Business justification: Agent appointment has primary_contact_name, primary_contact_email, primary_contact_phone as plain-text denormalizations of a contact_person record. Port operations require a proper FK for vessel arriv',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Vessel agents appoint customs brokers for cargo clearance and customs declaration submission on behalf of vessel operators. This link enables agent-broker coordination tracking, customs clearance auth',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Agent appointments are formalized through agency agreements defining scope, commission rates, financial authority, and service fees. Essential for billing reconciliation, commission calculation, and d',
    `call_id` BIGINT COMMENT 'Reference to the specific port call for which the agent is appointed. Nullable for standing appointments not tied to a single call.',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the shipping agent company appointed to represent the vessel or owner. Links to the participant master record in the customer domain.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Port authority officers approve agent appointments, verify credentials, and manage ISPS security clearances. Essential for regulatory control, security compliance, and commercial relationship manageme',
    `receivable_account_id` BIGINT COMMENT 'Foreign key linking to billing.receivable_account. Business justification: Agent appointments include a disbursement account reference (currently plain text: disbursement_account_reference) that maps to a receivable_account for AR management. A proper FK replaces this denorm',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Shipping agents are appointed by shipping lines for port calls. Agent performance reporting, commission rate management, and EDI partner configuration are all managed per shipping line. Port operation',
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
    `document_submission_authority` BOOLEAN COMMENT 'Indicates whether the agent is authorized to submit official port and customs documentation on behalf of the vessel or owner. True grants submission rights; false restricts to coordination only.',
    `edi_enabled_flag` BOOLEAN COMMENT 'Indicates whether the agent company is enabled for electronic data interchange messaging with the port community system for automated document submission and status updates.',
    `edi_participant_code` STRING COMMENT 'Unique EDI participant identifier assigned to the agent company within the port community system for message routing and authentication.',
    `emergency_contact_phone` STRING COMMENT '24/7 emergency telephone number for the agent company to handle urgent vessel matters outside business hours.',
    `financial_authority_flag` BOOLEAN COMMENT 'Indicates whether the agent has authority to commit to financial obligations and sign invoices on behalf of the vessel owner or operator.',
    `isps_security_clearance_status` STRING COMMENT 'Security clearance status of the agent company under ISPS Code requirements. Cleared allows port facility access; pending awaits approval; denied restricts access; expired requires renewal.. Valid values are `cleared|pending|denied|expired`',
    `performance_rating` STRING COMMENT 'Qualitative assessment of the agents performance during the appointment period. Used for future agent selection and relationship management.. Valid values are `excellent|good|satisfactory|poor|not_rated`',
    `port_facility_access_permit_number` STRING COMMENT 'Unique identifier of the port facility access permit issued to the agent company, required for physical access to restricted port areas.',
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
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: call_schedule represents the forward-looking planned port call; call represents the actual executed port visit. When a planned schedule entry materializes into an actual port call, this FK links the p',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Call schedules pre-allocate specific port assets (cranes, berths as assets) to planned vessel calls for resource planning. Linking call_schedule to port_asset enables asset pre-allocation workflows, m',
    `port_location_id` BIGINT COMMENT 'add column port_location_id (BIGINT) with FK to masterdata.port_location.port_location_id - vessel call schedules must reference the port location for scheduling context',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Shipping lines submit preferred berth requests in advance call schedules for berth window planning and resource pre-allocation. The existing berth_preference is a plain text denormalization of infrast',
    `shipping_line_id` BIGINT COMMENT 'add column shipping_line_id (BIGINT) with FK to masterdata.shipping_line.shipping_line_id - call schedules are published by shipping lines for their service rotations',
    `terminal_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal. Business justification: Call schedules specify which terminal a vessel will call at — this drives terminal resource pre-planning, berth window allocation, and terminal operator notifications. terminal_code is a denormalized ',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Call schedules are submitted per terminal zone (container terminal, bulk terminal, RoRo). The existing terminal_code is a denormalized text reference to infrastructure.terminal_zone. Linking enables t',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel scheduled for this port call. Links to the vessel master data.',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: A call_schedule entry (forward-looking planned port call) is associated with a specific voyage. The call_schedule table currently carries voyage_number as a denormalized STRING reference. Adding voyag',
    `alliance_designation` STRING COMMENT 'Name of the shipping alliance if this service is part of a carrier alliance (e.g., 2M, Ocean Alliance, THE Alliance). Null for independent services.',
    `average_vessel_capacity_teu` STRING COMMENT 'Average container capacity in TEU of vessels deployed on this service. Used for capacity planning and commercial forecasting.',
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
    `vessel_string_size` STRING COMMENT 'Number of vessels deployed in this service rotation. Indicates the fleet size required to maintain the service frequency.',
    CONSTRAINT pk_call_schedule PRIMARY KEY(`call_schedule_id`)
) COMMENT 'Forward-looking schedule and service route record representing planned port calls for a vessel over a service rotation or voyage series. Service route attributes: service code, service name, operating shipping line(s), alliance designation, rotation of ports in sequence, service frequency (weekly, bi-weekly), vessel string size, average TEU capacity, service type (mainline, feeder, regional), and service status. Schedule attributes: rotation sequence number, planned ETA, planned ETD, planned berth window, cargo volume forecast (TEU), schedule version, schedule source (shipping line EDI, agent submission, VTS pre-notification), and schedule status (provisional, confirmed, amended, cancelled). Supports berth planning horizon management, resource pre-allocation, volume forecasting, and commercial service agreement management. Distinct from call which is the actual operational record of a realized port visit.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` (
    `port_call_id` BIGINT COMMENT 'Unique system identifier for the port call record. Primary key.',
    `berth_allocation_id` BIGINT COMMENT 'Foreign key to the specific berth assignment record if this call involved berthing operations. Links to berth scheduling system.',
    `call_schedule_id` BIGINT COMMENT 'Foreign key linking to vessel.call_schedule. Business justification: port_call (the operational execution record) should reference its originating call_schedule (the planning record) to close the plan-to-execution loop at the port_call level. This complements the call_',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.participant_account. Business justification: Port call charges (total_port_charges_amount on port_call) must be billed to a participant_account. Port dues invoicing and accounts receivable reconciliation require knowing which billing account is ',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Port authority operational reporting (throughput KPIs, port performance dashboards, annual statistics) requires port_call records to directly reference the infrastructure.port entity. port_location_id',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to the port location where the call occurred',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Port call performance reporting (container moves, cargo volumes, port stay hours) must be aggregated by terminal zone for terminal utilization analysis and operator billing. Terminal zone determines w',
    `call_id` BIGINT COMMENT 'add column vessel_call_id (BIGINT) with FK to vessel.call.call_id - port_call appears to duplicate or extend vessel.call and must be linked to avoid data silos',
    `vessel_id` BIGINT COMMENT 'Foreign key linking to the vessel making the port call',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: port_call is the operational event of a vessel calling at a specific port location, and it is always part of a voyage. While port_call already links to call (vessel_call_id) and vessel (vessel_id), a ',
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

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ADD CONSTRAINT `fk_vessel_owner_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ADD CONSTRAINT `fk_vessel_voyage_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_psc_inspection_id` FOREIGN KEY (`psc_inspection_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`psc_inspection`(`psc_inspection_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_call_schedule_id` FOREIGN KEY (`call_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call_schedule`(`call_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`vessel` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`vessel` SET TAGS ('dbx_domain' = 'vessel');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Shipyard Country Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `shipyard_name` SET TAGS ('dbx_business_glossary_term' = 'Shipyard Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `technical_manager_imo_company_number` SET TAGS ('dbx_business_glossary_term' = 'Technical Manager IMO Company Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `technical_manager_name` SET TAGS ('dbx_business_glossary_term' = 'Technical Manager Name');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `teu_capacity` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ALTER COLUMN `year_built` SET TAGS ('dbx_business_glossary_term' = 'Year Built');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `owner_id` SET TAGS ('dbx_business_glossary_term' = 'Owner Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `discount_scheme_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `receivable_account_id` SET TAGS ('dbx_business_glossary_term' = 'Receivable Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `sanctions_screening_id` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Call Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Arrival Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `contact_person_id` SET TAGS ('dbx_business_glossary_term' = 'Agent Primary Contact Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Appointed Agent Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Profile Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ALTER COLUMN `vts_clearance_reference` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Clearance Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Coordinator Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
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
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `movement_id` SET TAGS ('dbx_business_glossary_term' = 'Movement Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `pilotage_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Assignment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ALTER COLUMN `towage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Order Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `certificate_id` SET TAGS ('dbx_business_glossary_term' = 'Certificate Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Issuing Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `pilotage_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Verification Officer Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ALTER COLUMN `psc_inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Inspection ID');
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
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `psc_inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Psc Inspection Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` SET TAGS ('dbx_subdomain' = 'fleet_registry');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `agent_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Agent Appointment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `contact_person_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Person Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agency Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Agent Company ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Appointing Officer Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `receivable_account_id` SET TAGS ('dbx_business_glossary_term' = 'Receivable Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `call_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Call Schedule Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Actual Call Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `alliance_designation` SET TAGS ('dbx_business_glossary_term' = 'Alliance Designation');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `average_vessel_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Average Vessel Capacity Twenty-foot Equivalent Unit (TEU)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ALTER COLUMN `vessel_string_size` SET TAGS ('dbx_business_glossary_term' = 'Vessel String Size');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` SET TAGS ('dbx_subdomain' = 'port_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `port_call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Assignment');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `call_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Call Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call - Port Location Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call - Vessel Id');
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
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
